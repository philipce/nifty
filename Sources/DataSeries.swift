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




// TODO: move SeriesIndexOrder inside series to be Series.IndexOrder once Swift compiler allows it!

/// Enumerates how the indexes of a series are ordered:
/// - decreasing: sorted large-to-small, no duplicates
/// - increasing: sorted small-to-large, no duplicates
/// - nonDecreasing: sorted large-to-small, with possible duplicates
/// - nonIncreasing: sorted small-to-large, with possible duplicates
/// - unorderedUnique: not sorted, no duplicates
/// - unordered: not sorted, with possible duplicates
public enum SeriesIndexOrder
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

public protocol DataSeriesProtocol: CustomStringConvertible
{
    associatedtype T
    associatedtype IndexType: Comparable

    var count          : Int              { get }
    var data           : [T?]             { get }
    var index          : [IndexType]      { get }
    var isComplete     : Bool             { get }
    var isEmpty        : Bool             { get }
    var maxColumnWidth : Int?             { get }
    var name           : String?          { get }
    var order          : SeriesIndexOrder { get }    
    var type           : T.Type           { get }

    // TODO: add setter subscripts?
    subscript(_ : IndexType)              -> T?                              { get } 
    subscript(_ : Range<IndexType>)       -> [(index: IndexType, value: T?)] { get }
    subscript(_ : ClosedRange<IndexType>) -> [(index: IndexType, value: T?)] { get }

    mutating func append(_ : T, index: IndexType, verify: Bool) -> Bool
    mutating func fill(method: Nifty.Options.EstimationMethod)
    mutating func insert(_ : T?, at index: IndexType, verify: Bool) -> Bool

    func get(nearest index: IndexType) -> (index: IndexType, value: T)
    func get(n: Int, nearest index: IndexType) -> [(index: IndexType, value: T)]
    func minus(_ other: Self, method: Nifty.Options.EstimationMethod) -> Self
    func mse(_ other: Self, method: Nifty.Options.EstimationMethod) -> Double
    func present() -> (index: [IndexType], data: [T], locs: [Int])
    func query(_ index: IndexType, method: Nifty.Options.EstimationMethod) -> T
    func query(_ indexes: [IndexType], method: Nifty.Options.EstimationMethod) -> [T]
    func resample(start: IndexType, step: Double, n: Int, name: String?, 
        method: Nifty.Options.EstimationMethod) -> Self
    func rms(_ other: Self, method: Nifty.Options.EstimationMethod) -> Double
}

public struct DataSeries<T>: DataSeriesProtocol
{	    
    public typealias IndexType = Double

    //----------------------------------------------------------------------------------------------
    // MARK: Stored Properties
    //----------------------------------------------------------------------------------------------
    
    private var _data           : [T?]
    private var _index          : [Double]
    private let _maxColumnWidth : Int?    
    private var _name           : String?
    private var _order          : SeriesIndexOrder        
    private let _type           : T.Type = T.self	

    //----------------------------------------------------------------------------------------------
    // MARK: Computed Properties
    //----------------------------------------------------------------------------------------------
    
    public var count: Int
    {
        assert(self._index.count == self._data.count)
        return self._data.count
    }

    public var data: [T?] { return self._data }

    public var description: String
    {
        let (blankInd, padInd) = _columnizeData(
            list: self._index, 
            name: "",
            maxWidth: self._maxColumnWidth, 
            padLeft: false)	
        
        let (padName, padData) = _columnizeData(
            list: self._data, 
            name: self._name ?? "", 
            maxWidth: self._maxColumnWidth, 
            padLeft: true)
        
        precondition(padInd.count == padData.count, "Must have same number of indexes as data points")
        
        var rows = ["\(blankInd!)   \(padName!)"]
        for i in 0..<padInd.count
        {
            rows.append("\(padInd[i]):  \(padData[i])")
        }
        
        return "\n" + rows.joined(separator: "\n")
    }
    
    public var index: [Double] { return self._index }

    public var isComplete: Bool
    {
        return self._data.reduce(true, { $0 && $1 != nil })
    }

    public var isEmpty: Bool
    {
        assert(self._data.count == self._index.count)
        return self._index.count < 1
    }

    public var maxColumnWidth: Int? { return self._maxColumnWidth }
    
    public var name: String? { return self._name }

    public var order: SeriesIndexOrder { return self._order }       
    
    public var type: T.Type { return self._type }    

    //----------------------------------------------------------------------------------------------
    // MARK: Initializers
    //----------------------------------------------------------------------------------------------
    
    // TODO: add initializer to convert time series to data series

    /// Initialize a new series with the given information.
    ///
    /// If an index is provided, it must have the same number of elements as the data and be ordered
    /// according to the given order, otherwise it will result in an unrecoverable error.
    ///
    /// - Parameters:
    ///     - data: series data
    ///     - index: series index (optional)
    ///     - order: initial series order (default: increasing)
    ///     - name: series name (optional)
    ///		- columnWidth: the preferred column width (default: vary according to data width)
    public init(
        _ data: [T?] = [], 
        index: [Double]? = nil, 
        order: SeriesIndexOrder = .increasing, 
        name: String? = nil, 
        maxColumnWidth: Int? = nil)
    {        
        self._data = data
        
        // verify supplied index or create default index
        if let ind = index
        {
            precondition(data.count == ind.count, "Index and data must match in size")
            precondition(_verifyIndexOrder(ind, order), "Index is not \(order)")
            self._index = ind
        }
        else
        {
            self._index = (0..<data.count).map({Double($0)})			
        }
        
        self._order = order    
        
        // sanitize name, no whitespace allowed
        self._name = name?.replacingOccurrences(of: "\\s+", with: "-", options: .regularExpression)
        
        // column can be limited to no fewer than 5 columns
        self._maxColumnWidth = maxColumnWidth == nil ? nil : max(maxColumnWidth!, 5)
    }
    
    //----------------------------------------------------------------------------------------------
    // MARK: Subscripts
    //----------------------------------------------------------------------------------------------
    
    // TODO: add setters

    public subscript(_ index: Double) -> T?
    {
        // TODO: how to handle duplicate values? 
        // If the series has a duplicate index, which of the values do we return? Changing the
        // signature to an array seems annoying for the majority case (non-duplicate indices)
        // Perhaps just returning the first one found is okay, no guarantees which one
        
        let i = find(in: self._index, nearest: index, order: self._order)        
        
        let closestIndex = self._index[i]
        if closestIndex != index { return nil } // FIXME: proper double compare
        return self._data[i]
    }
    
    public subscript(_ slice: Range<Double>) -> [(index: Double, value:T?)]
    {
        precondition(self._order.isSorted && self._order.isUnique, "Cannot slice \(self._order) series")
        
        let left: Int
        let right: Int
        if self._order == .increasing
        {            
            left = find(in: self._index, after: slice.lowerBound)
            right = find(in: self._index, before: slice.upperBound)
        }
        else
        {
            assert(self._order == .decreasing, "Not possible--already checked for other cases")
            right = find(in: self._index, before: slice.lowerBound)
            left = find(in: self._index, after: slice.upperBound)
        }
        
        let indexValues = self._index[left...right]       
        let dataValues = self._data[left...right]
        
        return Array(zip(indexValues, dataValues))
    }
    
    public subscript(_ slice: ClosedRange<Double>) -> [(index: Double, value:T?)]
    {
        // TODO: parameters with defaults are not allowed in subscripts...
        // Are we okay having unchangeable default for the subscript? Seems like neares/linterp 
        // combo is a reasonable default. How could the user achieve the same semantics as slice
        // but with a different estimation method? Perhaps the series has a global default they 
        // could change?
        
        precondition(self._order.isSorted && self._order.isUnique, "Cannot slice \(self._order) series")
        
        let openSlice = self[slice.lowerBound..<slice.upperBound]                
        
        let left, right: (index: Double, value: T?)
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
    /// See the insert function for information on what consitutes success/failure.
    /// 
    /// - Parameters: 
    ///     - x: value to append to the series
    ///     - index: the index to append to the series
    ///     - verify: control whether this append is verified (default: true)
    /// - Returns: true if append was successful, false if the append failed
    public mutating func append(_ x: T, index: Double, verify: Bool = true) -> Bool
    {        
        // ensure that insert will put value on the correct side of final value
        let correctOrder: Bool
        switch self._order
        {
        case .decreasing where !self.isEmpty: 
            correctOrder = self._index[self._index.count-1] > index // FIXME: proper double compare
        case .increasing where !self.isEmpty:
            correctOrder = self._index[self._index.count-1] < index // FIXME: proper double compare
        default:
            correctOrder = true
        }

        return correctOrder && self.insert(x, at: index, verify: verify)
    }
    
    /// Fill missing data for existing series indexes with an estimate, using the given method.
    ///
    /// - Parameters:
    ///     - method: method to use for estimating missing values
    public mutating func fill(method: Nifty.Options.EstimationMethod = .nearlin)
    {                
        let unknowns = self._index.enumerated().filter({self._data[$0.0] == nil})      
        let fillData = interp1(x: self._index, y: self._data, query: unknowns.map({$0.1}), order: self._order, method: method)   
        
        assert(fillData.count == unknowns.count, "Fill data must match unknown data size")
        
        for (fdIndex, i) in unknowns.map({$0.0}).enumerated() 
        { 
            self._data[i] = fillData[fdIndex] 
        }
    }
    
    /// Inserts the given value into the series at the given index, if able.
    ///
    /// When inserting a new value, the default behavior is to verify that the given value can go at
    /// the given index, based on the series index ordering. If the insert fails (e.g. a duplicate
    /// value is inserted into an increasing series), the insertion is not performed and failure is
    /// returned. If verification is disabled, the insertion will never fail, but may downgrade the
    /// series order. Note, verification is only of the current operation.
    ///
    /// - Parameters: 
    ///     - x: value to insert into the series
    ///     - at i: index at which to insert
    ///     - verify: control whether this insertion is verified (default: true)
    /// - Returns: true if insert was successful, false if the insert failed
    public mutating func insert(_ x: T?, at index: Double, verify: Bool = true) -> Bool
    {        
        if self.isEmpty
        {
            self._index.append(index)
            self._data.append(x)
            return true
        }

        let i = find(in: self._index, nearest: index, order: self._order)

        switch self._order
        {
            case .decreasing:
                if index > self._index[i] // FIXME: proper double compare
                {
                    self._index.insert(index, at: i)
                    self._data.insert(x, at: i)
                    return true
                }
                else if index < self._index[i] // FIXME: proper double compare
                {
                    self._index.insert(index, at: i+1)
                    self._data.insert(x, at: i+1)
                    return true
                }
                else
                {
                    if verify { return false }
                    else
                    {
                        self._index.insert(index, at: i)
                        self._data.insert(x, at: i)
                        self._order = .nonIncreasing
                        return true
                    }
                }
                
            case .increasing:
                if index > self._index[i] // FIXME: proper double compare
                {
                    self._index.insert(index, at: i+1)
                    self._data.insert(x, at: i+1)
                    return true
                }
                else if index < self._index[i] // FIXME: proper double compare
                {
                    self._index.insert(index, at: i)
                    self._data.insert(x, at: i)
                    return true
                }
                else
                {
                    if verify { return false }
                    else
                    {
                        self._index.insert(index, at: i)
                        self._data.insert(x, at: i)
                        self._order = .nonDecreasing
                        return true
                    }
                }
                
            case .nonDecreasing:
                if index > self._index[i] // FIXME: proper double compare
                {
                    self._index.insert(index, at: i+1)
                    self._data.insert(x, at: i+1)
                    return true
                }
                else
                {
                    self._index.insert(index, at: i)
                    self._data.insert(x, at: i)
                    return true
                }
                
            case .nonIncreasing:
                if index > self._index[i] // FIXME: proper double compare
                {
                    self._index.insert(index, at: i)
                    self._data.insert(x, at: i)
                    return true
                }
                else
                {
                    self._index.insert(index, at: i+1)
                    self._data.insert(x, at: i+1)
                    return true
                }
                
            case .unorderedUnique:
                if self._index.contains(index) // FIXME: proper double compare
                {
                    if verify { return false }
                    else
                    {
                        self._index.insert(index, at: i)
                        self._data.insert(x, at: i)
                        self._order = .unordered
                        return true
                    }
                }
                else
                {
                    self._index.insert(index, at: i)
                    self._data.insert(x, at: i)
                    return true
                }
                
            case .unordered:
                self._index.insert(index, at: i)
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
    
    public func get(nearest index: Double) -> (index: Double, value: T)
    {
        // TODO: better way to handle this than precondition? ...
        // In all other cases the return is not nil so making it an optional seems gross
        precondition(!self.isEmpty, "Cannot find in empty series")
        
        let (indexList, dataList, _) = self.present() // exclude missing values from search         
        let fi = find(in: indexList, nearest: index, order: self._order)
        
        return (indexList[fi], dataList[fi])        
    }
    
    public func get(n: Int, nearest index: Double) -> [(index: Double, value: T)]
    {
        if self.isEmpty { return [] }
        let (indexList, dataList, _) = self.present() // exclude missing values from search        
        let foundIndices = find(in: indexList, n: n, nearest: index, order: self._order)        
        var foundList = [(index: Double, value: T)]()
        for fi in foundIndices
        {
            if fi < 0 { break } // TODO: better way to check invalid return index from find?
            foundList.append((indexList[fi], dataList[fi]))
        }
        
        return foundList
    }
    
    
    // FIXME: BEFORE AND AFTER SEMANTICS ARE UNCLEAR! IN THE CASE OF A DECREASING SERIES, IS THE 
    // VALUE TO THE LEFT BEFORE OR AFTER? DO NOT USE THESE UNTIL SEMANTICS ARE RESOLVED

    // TODO: think about the above question in terms of behavior in the time series... clearly before
    // and after are chronological, regardless of list ordering... so for decreasing series, the time
    // to the left is after

    /*
     public func find(before index: Double) -> (index: Double, value: T)
     {
     // TODO: better way to handle this than precondition? ...
     // In all other cases the return is not nil so making it an optional seems gross
     precondition(!self.isEmpty, "Cannot find in empty series")
     
     let (indexList, dataList) = self.present() // exclude missing values from search         
     let fi = SeriesTest.find(in: indexList, before: index)
     
     return (indexList[fi], dataList[fi])        
     }
     
     public func find(n: Int, before index: Double) -> [(index: Double, value: T)]
     {
     if self.isEmpty { return [] }
     let (indexList, dataList) = self.present() // exclude missing values from search        
     let foundIndices = SeriesTest.find(in: indexList, n: n, before: index)        
     var foundList = [(index: Double, value: T)]()
     for fi in foundIndices
     {
     if fi < 0 { break } // TODO: better way to check invalid return index from find?
     foundList.append((indexList[fi], dataList[fi]))
     }
     
     return foundList
     }
     
     public func find(after index: Double) -> (index: Double, value: T)
     {
     // TODO: better way to handle this than precondition? ...
     // In all other cases the return is not nil so making it an optional seems gross
     precondition(!self.isEmpty, "Cannot find in empty series")
     
     let (indexList, dataList) = self.present() // exclude missing values from search         
     let fi = SeriesTest.find(in: indexList, after: index)
     
     return (indexList[fi], dataList[fi])        
     }
     
     public func find(n: Int, after index: Double) -> [(index: Double, value: T)]
     {
     if self.isEmpty { return [] }
     let (indexList, dataList) = self.present() // exclude missing values from search        
     let foundIndices = SeriesTest.find(in: indexList, n: n, after: index)        
     var foundList = [(index: Double, value: T)]()
     for fi in foundIndices
     {
     if fi < 0 { break } // TODO: better way to check invalid return index from find?
     foundList.append((indexList[fi], dataList[fi]))
     }
     
     return foundList
     }    
     */

     // TODO: add rename to minus?

    /// Subtract the elements in the other series from this series. 
    ///
    /// The resulting data series will have as its index the union set of the index of this series 
    /// and the other series. Missing values in either series will be estimated with the given 
    /// method so that the difference at every point in either series can be computed.
    ///
    /// - Note: this function is only applicable to types that can be subtracted; calling this 
    ///    function on series of unsupported types will cause an unrecoverable error.
    /// - Parameters:
    ///    - other: data series to subtract from this series
    ///    - method: method for estimating missing index values of other series (default: nearlin)
    /// - Returns: new series with same index as this series, containing differences
    public func minus(_ other: DataSeries<T>, method: Nifty.Options.EstimationMethod = .nearlin) -> DataSeries<T>
    {
        var newSeries: DataSeries<T>
        switch T.self
        {
            case is Double.Type:

                // FIXME: handle sorting differences more gracefully
                precondition(self._order == other.order, "Can't difference differently ordered series")
                precondition(self._order == .increasing || self._order == .decreasing, 
                             "Can only difference increasing or decreasing series")    
                
                newSeries = DataSeries<T>(order: self._order)
       
                // TODO: revisit this for efficiency ...
                // There's probably a bunch we can do to speed this up. E.g. walking both indexes in
                // order, alternating between each depending on the sorting rather than just pulling
                // the entire self.index and appending different values from other.index (this
                // should remove the need for one query and make the other more efficient)
                
                // create the union set of indexes in this series and other
                var newUnorderedIndex = [Double]()
                newUnorderedIndex.append(contentsOf: self._index)
                for i in 0..<other.count
                {
                    let ind = other.index[i]
                    if !newUnorderedIndex.contains(where: {$0 == ind}) { newUnorderedIndex.append(ind) } // FIXME: proper double compare                    
                }

                for ind in newUnorderedIndex
                {
                    let thisVal = self.query(ind, method: method) as! Double 
                    let otherVal = other.query(ind, method: method) as! Double
                    let diff = (thisVal - otherVal) as! T                    
                    let success = newSeries.insert(diff, at: ind)
                    assert(success, "Unexpectedly failed to insert \(diff) at \(ind)")
                }
                
            default:
                fatalError("Unsupported series type: \(T.self)")
        }
        return newSeries
    }
    
    /// Compute the mean squared error between two series.
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
    /// - Returns: mean square error value
    public func mse(_ other: DataSeries<T>, method: Nifty.Options.EstimationMethod = .nearlin) -> Double
    {
        let error: Double
        switch T.self
        {
        case is Double.Type:
            let difference = self.minus(other, method: method)
            var total = 0.0
            var n = 0
            for i in 0..<difference.count
            {
                total += (difference.data[i] as! Double) * (difference.data[i] as! Double)
                n += 1
            }
            error = total/Double(n)
            
        default:
            fatalError("Unsupported series type: \(T.self)")
        }
        
        return error        
    }
    
    /// Return list of the present (i.e. not nil) data in this series and corresponding indexes, as 
    /// well as the locations in the series storage.
    public func present() -> (index: [Double], data: [T], locs: [Int])
    {
        if self.isEmpty { return ([], [], []) }

        let iDataList = self._data.enumerated().filter({$0.1 != nil})
        let iList = iDataList.map({$0.0})
        let dataList = iDataList.map({$0.1!})
        let indexList = iList.map({self._index[$0]})
        assert(dataList.count == indexList.count)
        
        return (indexList, dataList, iList)
    }
    
    public func query(_ index: Double, method: Nifty.Options.EstimationMethod = .nearlin) -> T
    {                
        // TODO: better way to handle this than precondition? ...
        // In all other cases the return is not nil so making it an optional seems gross
        precondition(!self.isEmpty, "Cannot query empty series")         
        
        let q = interp1(x: self._index, y: self._data, query: [index], order: self._order, method: method)
        assert(q.count == 1, "Not possible--single query should return single point")
        
        return q[0]
    }
    
    public func query(_ indexes: [Double], method: Nifty.Options.EstimationMethod = .nearlin) -> [T]
    {
        // FIXME: this can be done a lot more efficiently in a batch than one at a time!
        
        if self.isEmpty { return [] }
        
        var values = [T]()
        for index in indexes
        {
            values.append(query(index, method: method))
        }
        
        return values
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
    public func resample(start: Double, step: Double, n: Int, name: String? = nil, method: Nifty.Options.EstimationMethod = .nearlin) -> DataSeries<T>
    {
        // TODO: revisit the impact of resampling an unordered/unverified list...
        // Does that cause any problems? It's not clear that it doesn't     
        
        var indexes = [Double]()
        var curIndex = start
        for _ in 0..<n
        {
            indexes.append(curIndex)
            curIndex += step
        }
        let data = self.query(indexes, method: method)
        
        return DataSeries(data, index: indexes, order: self._order, name: name, maxColumnWidth: self._maxColumnWidth)        
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
    public func rms(_ other: DataSeries<T>, method: Nifty.Options.EstimationMethod = .nearlin) -> Double
    {
        let error = self.mse(other, method: method)
        return sqrt(error)
    }
}

//==================================================================================================
// MARK: - INTERNAL HELPER FUNCTIONS
//==================================================================================================

extension String
{
    public func paddingLeft(toLength: Int, withPad: String, startingAt: Int = 0) -> String
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

func _verifyIndexOrder(_ index: [Double], _ order: SeriesIndexOrder) -> Bool
{
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
            guard index[i-1] < index[i] else { return false } // FIXME: proper double compare
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
