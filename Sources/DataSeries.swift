/***************************************************************************************************
 *  DataSeries.swift
 *
 *  This file defines a data series structure. 
 *
 *  Author: Philip Erickson
 *  Creation Date: 22 Feb 2017
 *
 *  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License. You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software distributed under the 
 *  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either 
 *  express or implied. See the License for the specific language governing permissions and 
 *  limitations under the License.
 *
 *  Copyright 2017 Philip Erickson
 **************************************************************************************************/

import func Foundation.sqrt
import func Foundation.pow
import struct Foundation.Date

/// Enumerates how the indexes of a series are ordered:
/// - decreasing: sorted large-to-small, no duplicates
/// - increasing: sorted small-to-large, no duplicates
/// - nonDecreasing: sorted large-to-small, with possible duplicates
/// - nonIncreasing: sorted small-to-large, with possible duplicates
/// - unorderedUnique: not sorted, no duplicates
/// - unordered: not sorted, with possible duplicates
public enum DataSeriesIndexOrder
{
    case decreasing        
    case increasing
    case nonDecreasing
    case nonIncreasing
    case unorderedUnique
    case unordered
    
    var isSorted: Bool 
    {
        switch self
        {
        case .decreasing, .increasing, .nonDecreasing, .nonIncreasing:
            return true
        case .unorderedUnique, .unordered:
            return false
        }
    }
    
    var isUnique: Bool 
    {
        switch self
        {
        case .decreasing, .increasing, .unorderedUnique:
            return true
        case .nonDecreasing, .nonIncreasing, .unordered:
            return false
        }
    }
}

/// Allows using arbitrary indices within a data series, all index types using Doubles for the 
/// underlying representation.
public protocol DataSeriesIndexProtocol: Comparable
{
    func indexToDouble() -> Double 
    static func indexFromDouble(_ d: Double) -> Self
}

extension Double: DataSeriesIndexProtocol
{
    public func indexToDouble() -> Double { return self }
    public static func indexFromDouble(_ d: Double) -> Double { return d }
}

extension Date: DataSeriesIndexProtocol
{
    public func indexToDouble() -> Double { return self.timeIntervalSince1970 }
    public static func indexFromDouble(_ d: Double) -> Date { return Date(timeIntervalSince1970: d) }
}

/// Stores and operates on values in an indexed series.
///
/// Data is not stored sparsely. That is, every index entry has a corresponding data entry at the 
/// same location in the series, even if the data entry is nil. This allows for distinguishing 
/// between an index that is present in the series but has no value, from an index that is not 
/// present in the series.
///
/// This has a few drawbacks. For one, when operating on the data, the nil entries may need to be
/// filtered (e.g. when querying a point that needs to be interpolated). It only needs to be done
/// once per query, even if there are multiple points in a query. The result is that querying N 
/// points at once is much faster than querying N points individually. Obviously, another drawback
/// is the extra memory used to store nils in the data array.
///
/// An alternative design that was considered was keeping the index and data arrays sparse (no nil
/// data stored) and then keeping a set of indexes that included all indexes with non-nil data, as 
/// well as those indexes present in the series that have no data. This avoids storing nil values, 
/// but still allows for distinguishing present indexes with nil data from non-present ones.
///
/// One problem with this and similar approaches arises when trying to read out the entire series, 
/// including indexes with nil values. For increasing or decreasing series, the indexes with nil
/// data can be grabbed from the set and inserted into sorted order. But with series having 
/// duplicate indices or in unordered series, the location of those indexes cannot be determined.
///
/// The slowness of multiple single point queries and the extra memory used seem, for now, to be 
/// acceptable limitations.
public struct DataSeries<IndexType: DataSeriesIndexProtocol, DataType>: CustomStringConvertible
{	    
    /// Transform a given string value, with any associated header rows, into a series point. 
    /// Useful for parsing text files with non-standard representations of the data within.
    public typealias IndexTransform = (_ value: String?, _ headers: [String?]?) -> IndexType?
    public typealias DataTransform  = (_ value: String?, _ headers: [String?]?) -> DataType?
    
    //----------------------------------------------------------------------------------------------
    // MARK: Stored Properties
    //----------------------------------------------------------------------------------------------
    
    private var _data           : [DataType?]
    internal var _index          : [Double] // TODO: should data frame be allowed access?
    private let _maxColumnWidth : Int?    
    private var _name           : String?
    private var _order          : DataSeriesIndexOrder        
    
    //----------------------------------------------------------------------------------------------
    // MARK: Computed Properties
    //----------------------------------------------------------------------------------------------
    
    public var count: Int
    {
        return self._index.count
    }
    
    public var data: [DataType?] { return self._data }
    
    public var description: String
    {
        let (blankInd, padInd) = _columnizeData(
            list: self._index.map{IndexType.indexFromDouble($0)}, 
            name: "",
            maxWidth: self._maxColumnWidth, 
            padLeft: false)	
        
        let (padName, padData) = _columnizeData(
            list: self._data, 
            name: self._name ?? "", 
            maxWidth: self._maxColumnWidth, 
            padLeft: true)
        
        precondition(padInd.count == padData.count, "Not possible--Must have same number of indexes as data points")
        
        var rows = ["\(blankInd!)   \(padName!)"]
        for i in 0..<padInd.count
        {
            rows.append("\(padInd[i]):  \(padData[i])")
        }
        
        return "\n" + rows.joined(separator: "\n")
    }
    
    public var index: [IndexType] { return self._index.map{IndexType.indexFromDouble($0)} }
    
    public var isComplete: Bool
    {
        for d in self._data { if d == nil { return false } }
        return true
    }
    
    public var isEmpty: Bool
    {
        return self._index.count == 0
    }
    
    public var maxColumnWidth: Int? { return self._maxColumnWidth }
    
    public var name: String? { return self._name }
    
    public var order: DataSeriesIndexOrder { return self._order }       
    
    public var type: DataType.Type { return DataType.self }    
    
    //----------------------------------------------------------------------------------------------
    // MARK: Initializers
    //----------------------------------------------------------------------------------------------
    
    // TODO: add initializer to convert time series to data series
    
    /// Initialize a new series with the given information.
    ///
    /// If an index is provided, it must have the same number of elements as the data and be ordered
    /// according to the given order, otherwise it will result in an unrecoverable error.
    ///
    /// The index parameter may be omitted if the given order is either increasing or decreasing.
    /// This results in a default index, beginning at 0.0 and incrementing by 1.0 or beginning at 
    /// one less than the number of data points and decrementing by 1.0, depending on order. Other
    /// series orders cannot generate a default index and will cause an unrecoverable error.
    ///
    /// - Parameters:
    ///     - data: series data
    ///     - index: series index (optional)
    ///     - order: initial series order (default: increasing)
    ///     - name: series name (optional)
    ///		- columnWidth: the preferred column width (default: vary according to data width)
    public init(
        _ data: [DataType?] = [], 
        index: [IndexType]? = nil, 
        order: DataSeriesIndexOrder = .increasing, 
        name: String? = nil, 
        maxColumnWidth: Int? = nil)
    {        
        self._data = data
        
        // Verify supplied index or create default index
        if let ind = index
        {
            let dIndex = ind.map{$0.indexToDouble()}
            precondition(data.count == dIndex.count, "Index and data must match in size")
            precondition(_verifyIndexOrder(dIndex, order), "Index is not \(order)")
            self._index = dIndex
        }
        else if order == .increasing
        {
            self._index = (0..<data.count).map({Double($0)})
        }
        else if order == .decreasing
        {
            self._index = stride(from: data.count-1, through: 0, by: -1).map({Double($0)})
        }            
        else
        {
            fatalError("Cannot create default index for \(order) series")            
        }
        
        self._order = order    
        
        // Sanitize name, no whitespace allowed
        self._name = name?.replacingOccurrences(of: "\\s+", with: "-", options: .regularExpression)
        
        // Column can be limited to no fewer than 5 columns
        self._maxColumnWidth = maxColumnWidth == nil ? nil : max(maxColumnWidth!, 5)
    }    
    
    /// Initialize a new series from the given comma separated file.
    ///
    /// - Parameters:
    ///     - csv: path to csv file to read data from
    ///     - skipRows: list of rows (first row is row 0) to skip during parsing (default: none)
    ///     - headerRows: list of rows to treat as headers (default: row 0)
    ///     - indexColumn: column number to read index from (optional)
    ///     - indexColumnName: name of column header to read index from (optional)
    ///     - dataColumn: column number to read data from (optional)
    ///     - dataColumnName: name of column header to read data from (optional)
    ///     - indexTransform: function to generate index from index string values (optional)
    ///     - dataTransform: function to generate data from index string values (optional)
    ///     - order: initial series order (default: increasing)
    ///     - name: series name (optional)
    ///		- columnWidth: the preferred column width (default: vary according to data width)    
    public init(
        csv             : String, 
        skipRows        : [Int]            = [],
        headerRows      : [Int]            = [0],
        indexColumn     : Int?             = nil,
        indexColumnName : String?          = nil,
        dataColumn      : Int?             = nil,
        dataColumnName  : String?          = nil,
        indexTransform  : IndexTransform?  = nil,
        dataTransform   : DataTransform?   = nil,
        order           : DataSeriesIndexOrder = .increasing, 
        name            : String?          = nil, 
        maxColumnWidth  : Int?             = nil)
    {        
        // Extract lines, header values, and determine where to start processing
        let lines = csv.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)                                 
        let headers: [[String]]?
        if headerRows.count > 0
        {
            var h = [[String]]()
            for r in headerRows
            {
                if skipRows.contains(r) { continue }
                h.append(lines[r].components(separatedBy: ",").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)}))                
            }
            headers = h            
        }
        else { headers = nil }   
        
        // Resolve column numbers for index and data
        var indexResolveResult = _resolveColumnForParsing(column: indexColumn, name: indexColumnName, headers: headers)
        if indexColumn == nil && indexColumnName == nil 
        {
            // use default index if both column and name are omitted
            indexResolveResult.i = -1
            indexResolveResult.error = nil
        } 
        let dataResolveResult = _resolveColumnForParsing(column: dataColumn, name: dataColumnName, headers: headers)        
        guard let resolvedIndexColumn = indexResolveResult.i, let resolvedDataColumn = dataResolveResult.i else
        {
            let indexError = indexResolveResult.error ?? "n/a"
            let dataError = dataResolveResult.error ?? "n/a"
            let msg = "Error resolving columns: \(indexError); \(dataError)"
            fatalError(msg)
        }
        
        // Iterate remaining lines in file, creating 1 series index/data pair per line   
        var indexValues = [IndexType]()
        var dataValues = [DataType?]()
        lineLoop: for lineNumber in 0..<lines.count
        {
            if skipRows.contains(lineNumber) || headerRows.contains(lineNumber) { continue }
            
            let curLine = lines[lineNumber]
            let curCols = curLine.components(separatedBy: ",").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
            
            // Parse index point
            let curIndex: IndexType
            if resolvedIndexColumn >= 0
            {          
                guard resolvedIndexColumn < curCols.count else 
                {
                    print("Warning: column \(resolvedIndexColumn) is out of bounds on line \(lineNumber); line will be skipped") // TODO: handle this better
                    continue lineLoop
                }
                let curStr = curCols[resolvedIndexColumn]                
                let curHeaders = headers?.map({$0[resolvedIndexColumn]})                
                if let transform = indexTransform
                {
                    guard let x = transform(curStr, curHeaders) else
                    {
                        print("Warning: failed to parse index for line \(lineNumber); line will be skipped") // TODO: handle this better
                        continue lineLoop
                    }
                    curIndex = x
                }
                else if IndexType.self == Double.self // TODO: we could make it so if the string is parseable as a double it gets converted through the protocol... no need to restrict this to indexes of the Double type only
                {
                    guard let x = Double(curStr) else
                    {
                        print("Warning: index is not numeric on line \(lineNumber); line will be skipped") // TODO: handle this better
                        continue lineLoop
                    }
                    curIndex = x as! IndexType
                }
                else
                {                    
                    // TODO: add default parsers for different types, e.g. Date
                    fatalError("Could not parse index column. No index transform given and no default known.")
                }                                
            }       
            else
            {
                // FIXME: compute default index
                fatalError("Fix this... add in calculation of default index")                
            }
            
            // Parse data point
            let curData: DataType? 
            guard resolvedDataColumn < curCols.count else 
            {
                print("Warning: column \(resolvedDataColumn) is out of bounds on line \(lineNumber); line will be skipped") // TODO: handle this better
                continue lineLoop
            }
            let curStr = curCols[resolvedDataColumn]                
            let curHeaders = headers?.map({$0[resolvedDataColumn]})                
            if let transform = dataTransform
            {
                curData = transform(curStr, curHeaders)
            }
            else if curStr.isEmpty // TODO: should strings other than empty (e.g. "NULL", "nil", "n/a") auto map to nil? Initial thought is no... if they really want that they should put it in a transform
            {
                curData = nil
            }
            else if DataType.self == Double.self
            {
                guard let x = Double(curStr) else
                {
                    print("Warning: data is not numeric on line \(lineNumber); line will be skipped") // TODO: handle this better
                    continue lineLoop
                }
                curData = (x as! DataType)
            }
            else if DataType.self == Int.self
            {
                guard let x = Int(curStr) else
                {
                    print("Warning: data is not an integer on line \(lineNumber); line will be skipped") // TODO: handle this better
                    continue lineLoop
                }
                curData = (x as! DataType)                
            }
            else if DataType.self == String.self
            {
                curData = (curStr as! DataType)
            }
            else
            {
                // TODO: add default support for more data types (e.g. parse Dates, Units)?
                print("Warning: data is not a standard type on line \(lineNumber); line will be skipped") // TODO: handle this better
                continue lineLoop
            }
            
            // Store the index/data pair parsed from this line
            indexValues.append(curIndex)
            dataValues.append(curData)                        
        }
        
        // Delegate series initialization
        let seriesName = name ?? (headers?[0][resolvedDataColumn]) ?? "unnamed" // TODO: reading headers may be out of bounds if incorrectly specified; add check that reports friendlier message                
        let initIndex: [IndexType]? = resolvedIndexColumn >= 0 ? indexValues : nil
        self.init(dataValues, index: initIndex, order: order, name: seriesName, maxColumnWidth: maxColumnWidth)        
    }
    
    //----------------------------------------------------------------------------------------------
    // MARK: Subscripts
    //----------------------------------------------------------------------------------------------
    
    // TODO: add setters
    
    // TODO: should slice return series instead of/in addition to list of tuples?
    
    public subscript(_ index: IndexType) -> DataType?
    {
        // TODO: how to handle duplicate values? 
        // If the series has a duplicate index, which of the values do we return? Changing the
        // signature to an array seems annoying for the majority case (non-duplicate indices)
        // Perhaps just returning the first one found is okay, no guarantees which one
        
        let dIndex = index.indexToDouble()
        
        let i = find(in: self._index, nearest: dIndex, order: self._order)        
        
        let closestIndex = self._index[i]
        if closestIndex != dIndex { return nil } // FIXME: proper double compare
        
        return self._data[i]
    }
    
    public subscript(_ slice: Range<IndexType>) -> [(index: IndexType, value:DataType?)]
    {
        precondition(self._order.isSorted && self._order.isUnique, "Cannot slice \(self._order) series")
        
        let left: Int
        let right: Int
        if self._order == .increasing
        {            
            left = find(in: self._index, after: slice.lowerBound.indexToDouble())
            right = find(in: self._index, before: slice.upperBound.indexToDouble())
        }
        else
        {
            assert(self._order == .decreasing, "Not possible--already checked for other cases")
            right = find(in: self._index, before: slice.lowerBound.indexToDouble())
            left = find(in: self._index, after: slice.upperBound.indexToDouble())
        }
        
        let indexValues = self._index[left...right].map({IndexType.indexFromDouble($0)})       
        let dataValues = self._data[left...right]
        
        return Array(zip(indexValues, dataValues))
    }
    
    public subscript(_ slice: ClosedRange<IndexType>) -> [(index: IndexType, value: DataType?)]
    {
        // TODO: swift doesnt allow parameters in subscripts to have defaults...
        // Are we okay having unchangeable interp default for subscript? Seems like nearest/linterp 
        // combo is a reasonable default. How could the user achieve the same semantics as slice
        // but with a different estimation method? Perhaps the series has a global default they 
        // could change?
        
        precondition(self._order.isSorted && self._order.isUnique, "Cannot slice \(self._order) series")
        
        let openSlice = self[slice.lowerBound..<slice.upperBound]                
        
        let left, right: (index: IndexType, value: DataType?)
        if self._order == .increasing
        {
            left = (slice.lowerBound, self.query(slice.lowerBound))
            right = (slice.upperBound, self.query(slice.upperBound))            
        }
        else
        {
            assert(self._order == .decreasing, "Not possible--already checked for other cases")
            right = (slice.lowerBound, self.query(slice.lowerBound))
            left = (slice.upperBound, self.query(slice.upperBound))                        
        }
        
        let closedSlice = [left] + openSlice + [right]
        
        return closedSlice
    }
    
    //----------------------------------------------------------------------------------------------
    // MARK: Mutating Functions
    //----------------------------------------------------------------------------------------------
    
    // TODO: should append and insert be able to append and insert nil?
    
    /// Appends the given value to the end of the series, if able.
    ///
    /// When inserting a new value, the default behavior is to verify that the given value can go at
    /// the given index, based on the series index ordering. If the insert fails (e.g. a duplicate
    /// value is inserted into an increasing series), the insertion is not performed and failure is
    /// returned. If verification is disabled, the insertion occur without fail, but will downgrade
    /// the series order if necessary.
    /// 
    /// - Note: verification is only of the current operation!
    /// - Parameters: 
    ///     - x: value to append to the series
    ///     - index: the index to append to the series
    ///     - verify: control whether this append is verified (default: true)
    /// - Returns: true if append was successful, false if the append failed
    public mutating func append(_ x: DataType?, index: IndexType, verify: Bool = true) -> Bool
    {               
        let dIndex = index.indexToDouble()
        
        // Determine if appending the given index will maintain the correct order
        let correctOrder: Bool
        switch self._order
        {
        case .decreasing where !self.isEmpty: 
            correctOrder = self._index[self._index.count-1] > dIndex // FIXME: proper double compare
        case .increasing where !self.isEmpty:
            correctOrder = self._index[self._index.count-1] < dIndex // FIXME: proper double compare
        case .nonDecreasing where !self.isEmpty:
            correctOrder = self._index[self._index.count-1] <= dIndex // FIXME: proper double compare
        case .nonIncreasing where !self.isEmpty:
            correctOrder = self._index[self._index.count-1] >= dIndex // FIXME: proper double compare
        case .unorderedUnique where !self.isEmpty:
            correctOrder = self._index.contains(dIndex) // FIXME: proper double compare
        default:
            correctOrder = true
        }
        
        // Append will maintain order
        if correctOrder
        {
            self._index.append(dIndex)
            self._data.append(x)
            return true
        }
            
            // Append will not be performed since it will break order and verification is enabled
        else if verify
        {
            return false
        }
        
        // Append will break order but will be performed since verification is disabled
        assert(!verify && !correctOrder)
        let newOrder: DataSeriesIndexOrder
        switch self._order
        {
        case .decreasing: 
            newOrder = self._index[self._index.count-1] < dIndex ? .unorderedUnique : .nonIncreasing // FIXME: proper double compare
        case .increasing:
            newOrder = self._index[self._index.count-1] > dIndex ? .unorderedUnique : .nonDecreasing // FIXME: proper double compare
        default:
            newOrder = .unordered
        }
        
        self._index.append(dIndex)
        self._data.append(x)
        self._order = newOrder
        
        return true
    }
    
    /// Add the given index to this series if it doesn't already exist; if it does exist do nothing.
    ///
    /// Index is added according to order. If the series is unordered, the new index will be 
    /// assigned immediately before the nearest index.
    ///
    /// - Parameters:
    ///     - x: data to associate with new index (default: nil)
    ///     - index: new index to assign to series
    /// - Returns: true if new index was added; false indicates preexisting index
    public mutating func assign(_ x: DataType? = nil, index: IndexType) -> Bool
    {
        let dIndex = index.indexToDouble()
        
        var locAssign: Int? = nil
        if self.isEmpty { locAssign = 0 }
        else
        {
            let locNear = find(in: self._index, nearest: dIndex, order: self._order)
            let dIndexNear = self._index[locNear]
            if dIndex != dIndexNear // FIXME: proper double compare            
            {
                switch self._order
                {
                case .increasing, .nonDecreasing:
                    locAssign = dIndex > dIndexNear ? locNear+1 : locNear
                case .decreasing, .nonIncreasing:
                    locAssign = dIndex < dIndexNear ? locNear+1 : locNear
                case .unordered, .unorderedUnique:
                    locAssign = locNear
                }
            }
        }        
        if let loc = locAssign
        {
            self._index.insert(dIndex, at: loc)
            self._data.insert(x, at: loc)            
            
            return true
        }
        
        return false
    }
    
    /// Fill missing data for existing series indexes with an estimate, using the given method.
    ///
    /// - Parameters:
    ///     - method: method to use for estimating missing values
    public mutating func fill(method: Nifty.Options.EstimationMethod = .nearlin)
    {              
        // Separate this series into known and unknown data 
        // TODO: efficiency can be improved by walking the data array once and interpolating nils...
        // as they come (this works for some methods, like linear interp. Regression though wouldn't)
        var unknownLoc = [Int]()
        var unknownIndex = [Double]()
        var knownIndex = [Double]()
        var knownData = [DataType]()
        for loc in 0..<self._data.count
        {
            if self._data[loc] == nil
            {
                unknownLoc.append(loc)
                unknownIndex.append(self._index[loc])
            }
            else
            {
                knownIndex.append(self._index[loc])
                knownData.append(self._data[loc]!)
            }                        
        }
        
        // Interpolate data for unknown points
        let fillData = interp1(x: knownIndex, y: knownData, query: unknownIndex, order: self._order, method: method)                   
        
        // Back fill this series' data array with newly interpolated data
        assert(fillData.count == unknownIndex.count, "Not possible--Fill data must match unknown data size")        
        for i in 0..<unknownLoc.count
        { 
            let loc = unknownLoc[i]
            let dat = fillData[i]            
            self._data[loc] = dat
        }
    }
    
    /// Inserts the given value into the series at the given index, if able.
    ///
    /// When inserting a new value, the default behavior is to verify that the given value can go at
    /// the given index, based on the series index ordering. If the insert fails (e.g. a duplicate
    /// value is inserted into an increasing series), the insertion is not performed and failure is
    /// returned. If verification is disabled, the insertion occur without fail, but will downgrade
    /// the series order if necessary.
    /// 
    /// - Note: verification is only of the current operation!
    /// - Parameters: 
    ///     - x: value to insert into the series
    ///     - at i: index at which to insert
    ///     - verify: control whether this insertion is verified (default: true)
    /// - Returns: true if insert was successful, false if the insert failed
    public mutating func insert(_ x: DataType?, at index: IndexType, verify: Bool = true) -> Bool
    {        
        let dIndex = index.indexToDouble()
        
        if self.isEmpty
        {
            self._index.append(dIndex)
            self._data.append(x)
            return true
        }
        
        let i = find(in: self._index, nearest: dIndex, order: self._order)
        
        switch self._order
        {
        case .decreasing:
            if dIndex > self._index[i] // FIXME: proper double compare. This should probably be changed to compare for equality first... the less than and greater than might get triggered even if the two numbers should be equal
            {
                self._index.insert(dIndex, at: i)
                self._data.insert(x, at: i)
                return true
            }
            else if dIndex < self._index[i] // FIXME: proper double compare
            {
                self._index.insert(dIndex, at: i+1)
                self._data.insert(x, at: i+1)
                return true
            }
            else
            {
                if verify { return false }
                else
                {
                    self._index.insert(dIndex, at: i)
                    self._data.insert(x, at: i)
                    self._order = .nonIncreasing
                    return true
                }
            }
            
        case .increasing:
            if dIndex > self._index[i] // FIXME: proper double compare
            {
                self._index.insert(dIndex, at: i+1)
                self._data.insert(x, at: i+1)
                return true
            }
            else if dIndex < self._index[i] // FIXME: proper double compare
            {
                self._index.insert(dIndex, at: i)
                self._data.insert(x, at: i)
                return true
            }
            else
            {
                if verify { return false }
                else
                {
                    self._index.insert(dIndex, at: i)
                    self._data.insert(x, at: i)
                    self._order = .nonDecreasing
                    return true
                }
            }
            
        case .nonDecreasing:
            if dIndex > self._index[i] // FIXME: proper double compare
            {
                self._index.insert(dIndex, at: i+1)
                self._data.insert(x, at: i+1)
                return true
            }
            else
            {
                self._index.insert(dIndex, at: i)
                self._data.insert(x, at: i)
                return true
            }
            
        case .nonIncreasing:
            if dIndex > self._index[i] // FIXME: proper double compare
            {
                self._index.insert(dIndex, at: i)
                self._data.insert(x, at: i)
                return true
            }
            else
            {
                self._index.insert(dIndex, at: i+1)
                self._data.insert(x, at: i+1)
                return true
            }
            
        case .unorderedUnique:
            if self._index.contains(dIndex) // FIXME: proper double compare
            {
                if verify { return false }
                else
                {
                    self._index.insert(dIndex, at: i)
                    self._data.insert(x, at: i)
                    self._order = .unordered
                    return true
                }
            }
            else
            {
                self._index.insert(dIndex, at: i)
                self._data.insert(x, at: i)
                return true
            }
            
        case .unordered:
            self._index.insert(dIndex, at: i)
            self._data.insert(x, at: i)
            return true
        }   
    }
    
    //----------------------------------------------------------------------------------------------
    // MARK: Non-Mutating Functions
    //----------------------------------------------------------------------------------------------
    
    // TODO: Remove workaround for bug SR-2450 (https://bugs.swift.org/browse/SR-2450)
    // This bug requires use of the module name to disambiguate the find() function within
    // the struct with the find() function declared globally. When fixed, remove this 
    // workaround in the case below and the several others throughout the struct.
    
    // TODO: get used to be named find but it collided with external find name... compiler
    // bug kept it from being recognized, rename this when bug is fixed
    
    public func get(nearest index: IndexType) -> (index: IndexType, value: DataType)
    {
        // TODO: better way to handle this than precondition? ...
        // In all other cases the return is not nil so making it an optional seems gross
        precondition(!self.isEmpty, "Cannot find in empty series")
        
        let (indexList, dataList, _) = self.present() // exclude missing values from search 
        
        // TODO: add overloads to resolve this inefficiency... converting to IndexTypes in present()
        // to then convert back to Doubles is stupid...
        let fi = find(in: indexList.map({$0.indexToDouble()}), nearest: index.indexToDouble(), order: self._order)
        
        return (indexList[fi], dataList[fi])        
    }
    
    public func get(n: Int, nearest index: IndexType) -> [(index: IndexType, value: DataType)]
    {
        if self.isEmpty { return [] }
        let (indexList, dataList, _) = self.present() // exclude missing values from search      
        
        // TODO: add overloads to resolve this inefficiency... converting to IndexTypes in present()
        // to then convert back to Doubles is stupid...
        let foundIndices = find(in: indexList.map({$0.indexToDouble()}), n: n, nearest: index.indexToDouble(), order: self._order)        
        
        var foundList = [(index: IndexType, value: DataType)]()
        for fi in foundIndices
        {
            if fi < 0 { break } // TODO: better way to check invalid return index from find?
            foundList.append((indexList[fi], dataList[fi]))
        }
        
        return foundList
    }
    
    /// Subtract the elements in the other series from this series. 
    ///
    /// - Note: this function is only applicable to types that can be subtracted; calling this 
    ///    function on series of unsupported types will cause an unrecoverable error.
    /// - Parameters:
    ///    - other: data series to subtract from this series
    ///    - method: method for estimating missing index values of other series (default: nearlin)
    /// - Returns: new series with same index as this series, containing differences
    public func minus(_ other: DataSeries<IndexType, DataType>, renamed: String? = nil, method: Nifty.Options.EstimationMethod = .nearlin) -> DataSeries<IndexType, DataType>
    {
        // TODO: add option to decide how to handle index mismatches
        // The series being compared need not be the same size; for index values that are present in 
        // one series but missing in the other, the values will be estimated with the given method so 
        // that the difference at every point in either series can be computed and included in the 
        // error calculation.
        //
        // In pandas, subtracting 2 series with different index sets results in NaN values wherever
        // and Index isn't present in both series... This seems like a reasonable default (with nils
        // instead of NaNs--NaN should exclusively represent math operation errors, e.g. 1/0).
        // Maybe the default estimation method is nil and if it is left nil it behaves.
        //
        // Whatever we do, the current operation is asymetric... the size of the resulting series
        // may depend on the order of subtraction. We should name options to make it clear that this 
        // option is asymetric.        
        
        // TODO: create protocol to enforce subtractability instead of only allowing doubles
        // This seems like perhaps the new evolution on the numeric protocols might be useful. 
        // Once this is fixed to only allow subtractable data types at compile time, make sure to 
        // udpate the function header.
        precondition(DataType.self == Double.self, "Currently, minus() only accepts Double series ")
        
        // TODO: this is weird but done to get rid of any potential nil values... 
        // how should this be done better?
        
        let selfIndex = self._index.map({IndexType.indexFromDouble($0)}) // TODO: get rid of inefficiency mapping back and forth between doubles/indexes
        
        let selfValues = self.query(selfIndex) 
        
        let otherValues = other.query(selfIndex)
        assert(selfValues.count == otherValues.count, "Not possible to get different counts")
        
        let difference = selfValues.enumerated().map({(($0.1 as! Double) - (otherValues[$0.0] as! Double)) as! DataType})
        
        let newSeries = DataSeries<IndexType, DataType>(difference, index: selfIndex, order: self._order, name: renamed, maxColumnWidth: self._maxColumnWidth)
        
        return newSeries
    }
    
    /// Compute the mean squared error between two series.    
    ///
    /// - Note: this function is only applicable to types that can be subtracted; calling this 
    ///    function on series of unsupported types will cause an unrecoverable error.
    /// - Parameters:
    ///    - other: data series to compare to this series
    ///    - method: method for estimating missing index values of other series (default: nearlin)
    /// - Returns: mean square error value
    public func mse(_ other: DataSeries<IndexType, DataType>, method: Nifty.Options.EstimationMethod = .nearlin) -> Double
    {        
        // TODO: add option to decide how to union indexes
        // The series being compared need not be the same size; for index values that are present in 
        // one series but missing in the other, the values will be estimated with the given method so 
        // that the difference at every point in either series can be computed and included in the 
        // error calculation.
        
        // TODO: create protocol to enforce subtractability instead of only allowing doubles
        // This seems like perhaps the new evolution on the numeric protocols might be useful. 
        // Once this is fixed to only allow subtractable data types at compile time, make sure to 
        // udpate the function header.
        precondition(DataType.self == Double.self, "Currently, mse() only accepts Double series ")
        
        // TODO: should this utilize minus() instead of directly computing? Is it faster to do directly?
        
        
        let selfIndex = self._index.map({IndexType.indexFromDouble($0)}) // TODO: get rid of inefficiency mapping back and forth between doubles/indexes
        
        // TODO: this is weird but done to get rid of any potential nil values... 
        // how should this be done better?
        let selfValues = self.query(selfIndex) 
        
        let otherValues = other.query(selfIndex)
        assert(selfValues.count == otherValues.count, "Not possible to get different counts")
        
        let squaredErrors = selfValues.enumerated().map({pow(($0.1 as! Double) - (otherValues[$0.0] as! Double), 2)})
        let meanSquaredError = squaredErrors.reduce(0.0, +) / Double(squaredErrors.count)
        
        return meanSquaredError
    }
    
    /// Return list of the present (i.e. not nil) data in this series and corresponding indexes, as 
    /// well as the locations in the series storage.
    public func present() -> (index: [IndexType], data: [DataType], locs: [Int])
    {
        if self.isEmpty { return ([], [], []) }
        
        let iDataList = self._data.enumerated().filter({$0.1 != nil})
        let iList = iDataList.map({$0.0})
        let dataList = iDataList.map({$0.1!})
        let indexList = iList.map({self._index[$0]})
        assert(dataList.count == indexList.count)
        
        return (indexList.map({IndexType.indexFromDouble($0)}), dataList, iList)
    }
    
    public func query(_ index: IndexType, method: Nifty.Options.EstimationMethod = .nearlin) -> DataType?
    {                                
        let q = self.query([index], method: method)
        assert(q.count <= 1, "Not possible--single query cannot return more than 1 point")
        
        // TODO: better way to handle this than precondition? ...
        // In all other cases the return is not nil so making it an optional seems gross
        precondition(q.count > 0, "Cannot query empty series")         
        
        return q[0]
    }
    
    public func query(_ indexes: [IndexType], method: Nifty.Options.EstimationMethod = .nearlin) -> [DataType?]
    {
        // FIXME: because we are storing data in a non-sparse way, we have to filter the nils out
        // before calling interp1. This means that if a user wants to query lots of points, they have
        // to do it in a single call, rather than say, one at a time in a for loop. Otherwise, this
        // filtering process happens each time which is crazy expensive. But there's no reason the
        // user should be forced to do that, so we should change our storage to be sparse...
        
        // But the above doesn't totally solve the problem... if when we say sparse we mean that 
        // no series has nil values then sure, that works. But what if a user want to insert a nil
        // value to hold a place, to show that the index exists but no value does, as opposed to just
        // no matching index? We'll need a master index list that has all indexes for all series, but 
        // no series gets a value inserted into it unless there is an actual value.
        
        // We could also just make interp1 work with nils... it just skips the values that are nil
        
        // exclude missing values from computation 
        let iyData = self._data.enumerated().filter({$0.1 != nil})
        let iData = iyData.map({$0.0})
        let yData = iyData.map({$0.1!})
        let xData = iData.map({self._index[$0]})
        
        assert(xData.count == yData.count, "Not possible--counts must match")   
        
        // TODO: revisit what should happen when querying an empty series...
        // Seems like any queries to the empty series should just return as many nils as there were
        // query points. If you try to create a series from the result of the query, unless you get 
        // back an equal number of nils, the series init will fail since the number of indices
        // doesn't match the number of data points
        //
        // Is it annoying to return optionals in the [Data
        if xData.isEmpty 
        { 
            let c = indexes.count            
            let nils = [DataType?](repeating: nil, count: c)
            return nils 
        }    
        
        return interp1(x: xData, y: yData, query: indexes.map({$0.indexToDouble()}), order: self._order, method: method)            
    }
    
    /// Resample this series that the given resolution.
    ///
    /// - Parameters:
    ///     - start: index into the series from which to begin sampling
    ///     - step: amount to increment index by for each sample
    ///     - n: number of samples to take
    ///     - name: name for resampled series (optional)
    ///     - method: estimation method used to interpolate and/or extrapolate (default: nearlin)
    /// - Returns: a new series containing the resampled points
    public func resample(start: IndexType, step: Double, n: Int, name: String? = nil, method: Nifty.Options.EstimationMethod = .nearlin) -> DataSeries<IndexType, DataType>
    {
        // TODO: revisit the impact of resampling an unordered/unverified list...
        // Does that cause any problems? It's not clear that it doesn't     
        
        var indexes = [Double]()
        var curIndex = start.indexToDouble()        
        for _ in 0..<n
        {
            indexes.append(curIndex)
            curIndex += step
        }
        
        // TODO: query is written to take and index of IndexTypes... should we add an overload to it
        // (and similar methods) to allow passing an index of Doubles? That saves the hassle of 
        // converting from Doubles to IndexTypes, to pass to query, which then just converts back
        // to IndexTypes.
        let indexTypes = indexes.map({IndexType.indexFromDouble($0)})
        let data = self.query(indexTypes, method: method)
        
        // TODO: add to DataSeries constructor to allow passing list of doubles as index? We could
        // just convert the doubles based on the generic IndexType...
        return DataSeries<IndexType, DataType>(data, index: indexTypes, order: self._order, name: name, maxColumnWidth: self._maxColumnWidth)        
    }
    
    /// Compute the root-mean-square error between two series.
    ///
    /// The series being compared need not be the same size; for index values that are present in 
    /// one series but missing in the other, the values will be estimated with the given method so 
    /// that the difference at every point in either series can be computed and included in the 
    /// error calculation.
    ///
    /// - Note: this function is only applicable to types that can be subtracted; calling this 
    ///    function on series of unsupported types will cause an unrecoverable error.
    /// - Parameters:
    ///    - other: data series to compare to this series
    ///    - method: method for estimating missing index values of other series (default: nearlin)
    /// - Returns: root-mean-square error value
    public func rms(_ other: DataSeries<IndexType, DataType>, method: Nifty.Options.EstimationMethod = .nearlin) -> Double
    {
        // TODO: revisit how to decide which indexes from each series to use... symmetry?
        
        let error = self.mse(other, method: method)
        return sqrt(error)
    }    
}

//==================================================================================================
// MARK: - INTERNAL HELPER FUNCTIONS
//==================================================================================================

func _resolveColumnForParsing(column: Int?, name: String?, headers: [[String]]?) -> (i: Int?, error: String?)
{
    guard column == nil || name == nil else { return (nil, "Specifying both column and name not allowed") }
    guard column == nil ? name != nil : true else { return (nil, "Either column or name must be specified") }
    
    var resolvedColumn: Int? = nil
    
    if let n = name
    {
        var i: Int? = nil 
        guard let rows = headers else 
        {
            return (nil, "Column name specified but no header rows were given")
        }
        headerLoop: for row in rows
        {                    
            if let itmp = row.index(of: n)
            {
                if i != nil && i! != itmp 
                { 
                    return (nil, "Found column name in different header columns locations")
                }
                i = itmp
            }
        }
        if i != nil { resolvedColumn = i! }                
        else { return (nil, "Could not find column '\(n)' in header rows \(rows)") } 
    }
    else if let i = column 
    { 
        resolvedColumn = i 
    } 
    
    return (resolvedColumn, nil)
}

func _columnizeData(
    list: [Any?], 
    name: String? = nil, 
    maxWidth: Int? = nil, 
    padLeft: Bool = true) -> (paddedName: String?, paddedData: [String])
{
    var strList = [String]()
    var maxActualWidth = -1
    if let n = name
    {
        maxActualWidth = max(maxActualWidth, n.characters.count)
        strList.append(n)
    }
    for l in list
    {
        let str = "\(l ?? "-")"
        strList.append(str)
        maxActualWidth = max(maxActualWidth, str.characters.count)
    }
    
    let len = min(maxWidth ?? maxActualWidth, maxActualWidth)
    
    var paddedData = [String]()
    for var str in strList
    {
        if str.characters.count <= len
        {
            if padLeft
            {
                str = str.paddingLeft(toLength: len, withPad: " ", startingAt: 0)
            }
            else
            {
                str = str.padding(toLength: len, withPad: " ", startingAt: 0)
            }
        }
        else
        {
            str = str[str.startIndex...str.index(str.startIndex, offsetBy: len-4)] + "..."
        }
        
        paddedData.append(str)
    }
    
    var paddedName: String? = nil
    if let _ = name
    {
        paddedName = paddedData.remove(at: 0)
    }
    
    return (paddedName, paddedData)
}

func _verifyIndexOrder(_ index: [Double], _ order: DataSeriesIndexOrder) -> Bool
{
    if index.isEmpty { return true }
    
    switch order
    {
    case .decreasing:
        for i in 1..<index.count
        {
            guard index[i-1] > index[i] else { return false } // FIXME: proper double compare
        }
        
    case .increasing: 
        for i in 1..<index.count
        {
            guard index[i-1] < index[i] else 
            { 
                print(index[i-1])
                print(index[i])
                return false 
            } // FIXME: proper double compare
        }
        
    case .nonDecreasing:
        for i in 1..<index.count
        {
            guard index[i-1] <= index[i] else { return false } // FIXME: proper double compare
        }
        
    case .nonIncreasing:
        for i in 1..<index.count
        {
            guard index[i-1] >= index[i] else { return false } // FIXME: proper double compare
        }
        
    case .unorderedUnique:
        if Set<Double>(index).count != index.count { return false } // FIXME: proper double compare
        
    case .unordered:
        break
    }
    
    return true
}

extension String
{
    /// Provide a left padding function.
    ///
    /// Note: padding to a length less than the current string will remove characters from the 
    /// left side of the string.
    ///
    /// - Parameters:
    ///     - toLength: length of string to return
    ///     - withPad: string consisting of padding characters to use, starting with the leftmost, 
    ///         cycling as necessary
    ///     - startingAt: index into pad to start padding with
    /// - Returns: string padded on the left to the desired length
    func paddingLeft(toLength: Int, withPad: String, startingAt: Int = 0) -> String
    {
        let padLength = toLength - self.characters.count
        
        if padLength > 0
        {
            return "".padding(toLength: padLength, withPad: withPad, startingAt: startingAt) + self
        }
        else if padLength < 0
        {
            return self.substring(from: self.index(self.startIndex, offsetBy: -padLength))
        }
        else
        {
            return self
        }
    }
}
