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

//==================================================================================================
// MARK: - DATA SERIES DEFINITION
//==================================================================================================

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
public struct DataSeries<IndexType: DataSeriesIndexable, ValueType>: CustomStringConvertible
{       
    /// Transform a given string value, with any associated header rows, into a series point. 
    /// Useful for parsing text files with non-standard representations of the data within.
    public typealias IndexTransform = (_ value: String?, _ headers: [String?]?) -> IndexType?
    public typealias ValueTransform  = (_ value: String?, _ headers: [String?]?) -> ValueType?
    
    //----------------------------------------------------------------------------------------------
    // MARK: Stored Properties
    //----------------------------------------------------------------------------------------------

    /// Controls the default method used for estimation by this series; modifiable by user.
    public var defaultEstimationMethod = Nifty.Options.nearlin

    /// Contains all index/value pairs in the series with non-nil values.
    var _presentIndex: [DataSeriesIndex: [DataSeriesValue<ValueType>]]
        
    /// Contains all indexes present in the series that have nil values.
    var _absentIndex: Set<DataSeriesIndex>
    
    /// Lists references into the index dictionaries in the series order.
    var _position: [(DataSeriesIndex, DataSeriesValue<ValueType>?)]

    /// Series index ordering; can be modified automatically by operations (e.g. insert, append)
    var _order : DataSeriesIndexOrder        
    
    /// Name of series, for use in display and by the user.
    var _name : String?
    
    /// Max width to be used in displaying series column.
    let _width : Int?    

    //----------------------------------------------------------------------------------------------
    // MARK: Computed Properties
    //----------------------------------------------------------------------------------------------
    
    public var count: Int
    {
        return self._position.count
    }
    
    public var values: [ValueType?] 
    { 
        return self._position.map{$0.1?.value} 
    }
    
    public var index: [IndexType]
    {
        return self._position.map{IndexType.indexFromDouble($0.0.index)}
    }

    public var description: String
    {
        let (blankInd, padInd) = _columnizeData(
            list: self.index, 
            name: "",
            maxWidth: self._width, 
            padLeft: false) 
        
        let (padName, padData) = _columnizeData(
            list: self.values, 
            name: self._name ?? "", 
            maxWidth: self._width, 
            padLeft: true)
        
        precondition(padInd.count == padData.count, "Expected index and value lists to be the same size")
        
        var rows = ["\(blankInd!)   \(padName!)"]
        for i in 0..<padInd.count
        {
            rows.append("\(padInd[i]):  \(padData[i])")
        }
        
        return "\n" + rows.joined(separator: "\n")
    }

    public var isComplete: Bool
    {
        return self._absentIndex.isEmpty
    }
    
    public var isEmpty: Bool
    {
        return self._position.isEmpty
    }
    
    public var maxColumnWidth: Int? { return self._width }
    
    public var name: String? { return self._name }
    
    public var order: DataSeriesIndexOrder { return self._order }       
    
    public var indexType: IndexType.Type { return IndexType.self }    
    
    public var valueType: ValueType.Type { return ValueType.self }    
    
    //----------------------------------------------------------------------------------------------
    // MARK: Initializers
    //----------------------------------------------------------------------------------------------

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
    ///     - values: values in series
    ///     - index: series index (optional)
    ///     - comparator: specify comparator for series index (optional)
    ///     - order: initial series order (default: increasing)
    ///     - name: series name (optional)
    ///     - width: the preferred max column width (default: vary according to data width)
    public init(
        _ values: [ValueType?] = [], 
        index: [IndexType]? = nil, 
        comparator: DataSeriesIndexComparator? = nil,
        order: DataSeriesIndexOrder = .increasing, 
        name: String? = nil, 
        width: Int? = nil)
    {        
        // Verify supplied index or create default index
        let dIndex: [Double]
        if let ind = index
        {
            dIndex = ind.map{$0.indexToDouble()}            
            precondition(_verifyIndexOrder(dIndex, order), "Index is not \(order)")
        }
        else if order == .increasing
        {
            dIndex = (0..<values.count).map({Double($0)})
        }
        else if order == .decreasing
        {
            dIndex = stride(from: values.count-1, through: 0, by: -1).map({Double($0)})
        }            
        else
        {
            fatalError("Cannot create default index for \(order) series")            
        }
        
        // Create index comparator for this series
        let seriesComparator = comparator ?? DataSeriesIndexComparator()
        
        // Create present, absent, and position structures
        precondition(values.count == dIndex.count, "Index and data must match in size")
        var present = [DataSeriesIndex: [DataSeriesValue<ValueType>]]()
        var absent = Set<DataSeriesIndex>()
        var position = [(DataSeriesIndex, DataSeriesValue<ValueType>?)]()
        for i in 0..<values.count
        {
            let dsi = DataSeriesIndex(dIndex[i], seriesComparator)
            let dsv: DataSeriesValue<ValueType>?
            
            if let v = values[i] { dsv = DataSeriesValue(v) }
            else { dsv = nil }
            
            if dsv != nil 
            { 
                if present.keys.contains(dsi) { present[dsi]!.append(dsv!) }
                else { present[dsi] = [dsv!] }
            }
            else { absent.insert(dsi) } 
            position.append((dsi, dsv))            
        }        
        self._presentIndex = present
        self._absentIndex = absent
        self._position = position        
        
        // TODO: allow user to skip specifying order--make default order nil, infer order if nil
        self._order = order 
        
        // Sanitize name--no whitespace allowed
        self._name = name?.replacingOccurrences(of: "\\s+", with: "-", options: .regularExpression)
        
        // Column can be limited to no fewer than 5 columns
        self._width = maxColumnWidth == nil ? nil : max(maxColumnWidth!, 5)
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
    ///     - columnWidth: the preferred column width (default: vary according to data width)    
    public init(
        csv             : String, 
        skipRows        : [Int]            = [],
        headerRows      : [Int]            = [0],
        indexColumn     : Int?             = nil,
        indexColumnName : String?          = nil,
        dataColumn      : Int?             = nil,
        dataColumnName  : String?          = nil,
        indexTransform  : IndexTransform?  = nil,
        dataTransform   : ValueTransform?   = nil,
        order           : DataSeriesIndexOrder = .increasing, 
        name            : String?          = nil, 
        maxColumnWidth  : Int?             = nil)
    {        
        // FIXME: implement csv initializer (RFC4180)
        fatalError("Not yet implemented")
    }
    
    //----------------------------------------------------------------------------------------------
    // MARK: Get & Set Values
    //----------------------------------------------------------------------------------------------
    
    // TODO: document decision on how series with duplicate indexes are handled... it should probably be the case that
    // there is no guarantee made about how the index is selected (e.g. it's just whichever binary search finds first,
    // which could be first, middle, or last occurrence), for most of these anyway. Those functions that actually 
    // specifically are about finding the first e.g. would be the exception


    public subscript(_ index: IndexType) -> ValueType
    {
        /// Query this series for the given value, using the series default estimation method.
        get 
        {
            let ind = index.indexToDouble()
            if let val = self._presentIndex[ind] { return val.value[0] }
            else { return self.query(ind) }
        }
        
        /// Insert the given value into this series, if doing so maintains series order. Otherwise, call will be ignored.
        set(newValue) 
        {
            self.assign(newValue, index: index)
        }                
    }

    /// Slicing with an open range returns a series that does not include the specified start and end points--only 
    /// indices between the specified start and end points are included.
    ///
    /// In case the specified range bounds do not exist in the series, the indices that are closest (smallest in 
    /// absolute difference, not in position) will be used.
    ///
    /// In the case of duplicate indices, the occurrences that give the widest range will be used (e.g. in an 
    /// increasing series, the first occurrence of the start index and the last occurrence of the end index), and 
    /// the index/value pairs between the two will be selected.
    public subscript(_ slice: Range<IndexType>) -> DataSeries<IndexType, ValueType>
    {        
        // TODO: handle open ranges in swift 4
                
        /// Query this series for the given range of values, using the series default estimation method.
        get 
        {        
            let (firstPos, lastPos) = self._resolveOpenRange(range: slice)

            let pairs = self._position[firstPos...lastPos]
            let indexes = pairs.map({$0.index})
            let values = pairs.map({$0.value})    
            let newName = self.name == nil ? nil : "\(self.name![\(slice)])"        

            return DataSeries<IndexType, ValueType>(values, index: indexes, comparator: self.comparator,
                order: self.order, name: newName, width: self.width)
        }
        
        /// For each index in the given series, set it to the given value in this series if it 
        /// exists; otherwise, insert it.
        set(newSeries)
        {
            let (firstPos, lastPos) = self._resolveOpenRange(range: slice)

            let pairs = self._position[firstPos...lastPos]
            let setPositions = Array(firstPos...lastPos)
            let setIndexes = self._position[firstPos...lastPos].map({$0.index}) 
            let newValues = newSeries.query(setIndexes)

            assert(setPositions.count == setIndexes.count, "Position and Index lists must be same size")
            assert(setIndexes.count == newValues.count, "Query must return same number of values as indexes")

            for i in 0..<setPositions.count
            {
                let p = setPositions[i]
                let v = newValues[i]
                self._position[p].value = v
            }
        }
    }
    
    public subscript(_ slice: ClosedRange<IndexType>) -> [(index: IndexType, value: ValueType?)]
    {
        /// Query this series for the given range of values, using the series default estimation 
        /// method.
        get 
        {
            // TODO: create default estimation method
        }
        
        /// For each index in the given series, set it to the given value in this series if it 
        /// exists; otherwise, insert it.
        set(newValue)
        {
            // TODO: create set/insert hybrid that sets if present, otherwise asserts (e.g. assign)
            
        }
        
    }

    /// Return value at given index if it exists, otherwise return nil.
    public func get(_ index: IndexType) -> (position: Int, value: ValueType)?
    {
        
    }
    
    /// Get the value for the index in the series nearest the given index.
    ///
    /// - Note: Calling this function on an empty series will cause an unrecoverable error.
    public func get(nearest index: IndexType) -> (index: IndexType, position: Int, value: ValueType)
    {
        
    }
    
    /// Get values for the n indices in the series nearest the given index, sorted nearest first.
    ///
    /// For series with duplicate indexes, no guarantee is made about which occurrence the returned values correspond to.
    public func get(n: Int, nearest index: IndexType) -> [(index: IndexType, position: Int, value: ValueType)]
    {
        
    }
    
    /// Get the value for the nth occurence of the given index in the series, or nil if the series doesn't contain it.
    ///
    /// Occurrence is zero-based (e.g. 0 is the first, n-1 is the nth). Additionally, negative numbers may be used to 
    /// indicate counting from the end, (e.g. -1 is the last, -n is the first). 
    public func get(occurrence n: Int, of index: IndexType) -> (position: Int, value: ValueType)?
    {
        
    }
    
    /// Set the specified index to the given value. 
    ///
    /// The new value is written if the specified index already exists in the series, overwritting
    /// the previous value. Otherwise, this function has no effect.
    ///
    /// - Returns: true if value was set; false indicates the specified index was not in series
    public mutating func set(_ value: ValueType?, index: IndexType) -> Bool
    {
        // TODO: what about duplicate indexes? Should all them be overwritten. Seems like yes, since
        // there's the set occurrence of
    }
    
    /// Set the index in the series nearest the given index to the given value.
    ///
    /// - Returns: true if value was set; false is returned in case of an empty series
    public mutating func set(_ value: ValueType?, nearest index: IndexType) -> Bool
    {
        
    }
    
    /// Set the nth occurrence of specified index to the given value. 
    ///
    /// The new value is written if the specified index already exists in the series, overwritting
    /// the previous value. Otherwise, this function has no effect.
    ///
    /// Occurrence is zero-based (e.g. 0 is the first, n-1 is the nth). Additionally, negative numbers may be used to 
    /// indicate counting from the end, (e.g. -1 is the last, -n is the first). 
    ///
    /// - Returns: true if value was set; false indicates the series did not contain n occurrences 
    ///     of the specified index
    public mutating func set(_ value: ValueType?, occurrence n: Int, of index: IndexType) -> Bool
    {
        
    }

    // TODO: do we want to add positional set equivalents? e.g. set position 5 to some value...
    

    //----------------------------------------------------------------------------------------------
    // MARK: Add New Values To Series
    //----------------------------------------------------------------------------------------------
    
    /// Append the given value to the end of the series, if able.
    ///
    /// By default, the append will only be performed if it can be done without changing series 
    /// ordering (e.g. appending a duplicate index to an increasing series would cause it to become
    /// non-decreasing). The default behavior may be overriden, causing the append to be performed
    /// even if it results in modifying the series order.
    /// 
    /// - Parameters: 
    ///     - value: value to append to the series
    ///     - index: the index associated with the value to append to the series
    ///     - maintainOrder: ignore calls that would modify series order (default: true)
    /// - Returns: true if value was appended, false if the call was ignored
    public func append(_ value: ValueType?, index: IndexType, maintainOrder: Bool = true) -> Bool
    {
        
    }
    
    /// Inserts the given value into the series at the given index, if able.
    ///
    /// By default, the insert will only be performed if it can be done without changing series 
    /// ordering (e.g. inserting a duplicate index to an increasing series would cause it to become
    /// non-decreasing). The default behavior may be overriden, causing the insert to be performed
    /// even if it results in modifying the series order.
    /// 
    /// - Parameters: 
    ///     - value: value to insert into the series
    ///     - index: the index associated with the value to assert into the series
    ///     - maintainOrder: ignore calls that would modify series order (default: true)
    /// - Returns: true if value was inserted, false if the call was ignored
    public func insert(_ value: ValueType?, at index: IndexType, maintainOrder: Bool = true) -> Bool
    {
        
    }
    
    /// Assign the given value to the given index in this series. 
    ///
    /// If the given index already exists, the old value will be overwritten with the new value
    /// (duplicate indexes will be maintained, but all the duplicate indexes values will be overwritten).
    ///
    /// If the given index does not exist, the index will be inserted and assigned the given value.
    ///
    /// In all cases, the series order will be maintained.
    public func assign(_ value: ValueType?, index: IndexType)
    {
        // TODO: what about duplicate indexes? Should all them be overwritten. Seems like yes, since
        // there's the set occurrence of
    }
        
    //----------------------------------------------------------------------------------------------
    // MARK: Inference And Estimation
    //----------------------------------------------------------------------------------------------
    

    /// Query a single index from the series, using the given estimation method if the index does
    /// not exist in the series.
    ///
    /// - Parameters:
    ///     - index: index to query
    ///     - method: method to use for estimating missing values
    /// - Returns: the value associated with the queried index
    public func query(_ index: IndexType, method: Nifty.Options.EstimationMethod = self.defaultEstimationMethod) -> ValueType
    {
        let dIndex = index.indexToDouble()
        return query(dIndex: dIndex, method: method)   
    }

    public func query(dIndex: Double, method: Nifty.Options.EstimationMethod = self.defaultEstimationMethod) -> ValueType
    {


    }
    
    /// Query multiple indexes from the series, using the given estimation method for indexes that
    /// do not exist in the series.
    ///
    /// - Parameters:
    ///     - indexes: indexes to query
    ///     - method: method to use for estimating missing values
    /// - Returns: the values associated with the queried indexes
    public func query(_ indexes: [IndexType], method: Nifty.Options.EstimationMethod = self.defaultEstimationMethod) -> [ValueType]
    {
        
    }

    public func query(dIndexes: [Double], method: Nifty.Options.EstimationMethod = self.defaultEstimationMethod) -> [ValueType]
    {
        
    }


    
    /// Fill in missing values (both nil and NaN) for existing series indexes.
    ///
    /// - Parameters:
    ///     - method: method to use for estimating missing values
    public mutating func fill(method: Nifty.Options.EstimationMethod = .nearlin)
    {
        
    }
    
    /// Produce a new series, resampled at the given resolution.
    ///
    /// - Parameters:
    ///     - start: index into the series from which to begin sampling
    ///     - step: amount to increment index by for each sample
    ///     - n: number of samples to take
    ///     - name: name for resampled series (optional)
    ///     - method: estimation method used to interpolate and/or extrapolate (default: nearlin)
    /// - Returns: a new series containing the resampled points
    public func resample(
        start: IndexType, 
        step: IndexIncrementType, // TODO: create this type so we could resample time series in terms of seconds, hours, etc.
        n: Int, 
        method: Nifty.Options.EstimationMethod = .nearlin, 
        name: String? = nil) -> DataSeries<IndexType, ValueType>
    {
    
    
    }

    
    
    
    //----------------------------------------------------------------------------------------------
    // MARK: Basic Operations
    //----------------------------------------------------------------------------------------------
    
    public func contains(index: IndexType) -> Bool
    {
        
    }

    public func count(index: IndexType) -> Int
    {

    }
    
    
    //----------------------------------------------------------------------------------------------
    // MARK: Mathematical Operations
    //----------------------------------------------------------------------------------------------
    
    // TODO: add func signatures below 
        
    public func subtract() {}
    public func add() {}
    public func multiply() {}
    public func divide() {}
    
    public func sum() {}
    public func prod() {}
    public func cumsum() {}
    public func cumprod() {}
    
    public func diff() {}
    
    public func mse() {}
    public func rms() {}
    
    public func mean() {}
    public func std() {}
    public func variance() {}
    
    
    
    
    
    //----------------------------------------------------------------------------------------------
    // MARK: Format Conversions
    //----------------------------------------------------------------------------------------------
    
    // TODO: add func signatures below 
    
    public func toVector() {} // (to Matrix for data frame)    
    public func toCSV() {}
    

    //----------------------------------------------------------------------------------------------
    // MARK: Internal Member Helpers
    //----------------------------------------------------------------------------------------------
        
    /// Find the positions in this series of the indexes that constitute the given open range. The endpoints in the 
    /// specified open range will not be included; instead, the closest indexes (in absolute difference, not position)
    /// just inside either bound will be used. Since a Swift Range must be increasing, a decreasing/non-increasing
    /// series will interpret the bounds on the given range in reverse order. For unordered series, the series will
    /// be searched for endpoints both as if it were increasing and decreasing, and the points that result in the 
    /// widest range will be used.
    ///
    /// - Parameters:
    ///     - range: open range to find endpoints for
    /// - Returns: left and right positions of endpoints
    internal func _resolveOpenRange(range: Range<IndexType>) -> (Int, Int)
    {
        // Positions of the first and last element to be included in the open range
        var firstPos: Int
        var lastPos: Int

        // For decreasing series, interpret the range in reverse order (so range.lowerBound is on the right side of the series)
        let firstPos_dec: Int
        let lastPos_dec: Int        
        if self._order == .decreasing || self._order == .nonIncreasing || !self._order.isSorted
        {
            let greaterIndex = self.get(greaterThan: slice.lowerBound).index
            lastPos_dec = self.get(occurrence: -1, of: greaterIndex).position

            let lesserIndex = self.get(lessThan: slice.upperBound).index
            firstPos_dec = self.get(occurence: 0, of: lesserIndex).position

            // If this isn't an unordered series, set first and last position
            if self._order.isSorted
            {
                firstPos = firstPos_dec
                lastPos = lastPos_dec
            }
        }

        // For increasing series, interpret the range in normal order (so range.lowerBound is on the left side of the series)
        let firstPos_inc: Int
        let lastPos_inc: Int
        if self._order == .increasing || self._order == .nonDecreasing || !self._order.isSorted
        {
            let greaterIndex = self.get(greaterThan: slice.lowerBound).index
            firstPos = self.get(occurrence: 0, of: greaterIndex).position

            let lesserIndex = self.get(lessThan: slice.upperBound).index
            lastPos = self.get(occurence: -1, of: lesserIndex).position

            // If this isn't an unordered series, set first and last position
            if self._order.isSorted
            {
                firstPos = firstPos_inc
                lastPos = lastPos_inc
            }
        }

        // For unordered series, use whichever (valid--can't have first after last) interpretation gives the largest range.
        if (firstPos_inc <= lastPos_inc) && (abs(firstPost_inc - lastPos_inc) >= abs(firstPost_dec - lastPos_dec))
        {
            firstPos = firstPos_inc
            lastPos = lastPos_inc
        }
        else
        {
            firstPos = firstPos_dec
            lastPos = lastPos_dec
        }

        assert(firstPos <= lastPos, "Can't have first (\(firstPos)) before last (\(lastPos))")
        assert(firstPos < self._position.count, "Can't have out of bounds first (\(firstPos))")
        assert(lastPos < self._position.count, "Can't have out of bounds last (\(lastPos))")

        return (firstPos, lastPos)
    }
    
    
    





















    //**********************************************************************************************
    // MARK: - OLD STUFF BELOW HERE
    //**********************************************************************************************    
    
    // TODO: add setters
    
    // TODO: should slice return series instead of/in addition to list of tuples?
    
    public subscript(_ index: IndexType) -> ValueType?
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
    
    public subscript(_ slice: Range<IndexType>) -> [(index: IndexType, value:ValueType?)]
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
    
    public subscript(_ slice: ClosedRange<IndexType>) -> [(index: IndexType, value: ValueType?)]
    {
        // TODO: swift doesnt allow parameters in subscripts to have defaults...
        // Are we okay having unchangeable interp default for subscript? Seems like nearest/linterp 
        // combo is a reasonable default. How could the user achieve the same semantics as slice
        // but with a different estimation method? Perhaps the series has a global default they 
        // could change?
        
        precondition(self._order.isSorted && self._order.isUnique, "Cannot slice \(self._order) series")
        
        let openSlice = self[slice.lowerBound..<slice.upperBound]                
        
        let left, right: (index: IndexType, value: ValueType?)
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
    public mutating func append(_ x: ValueType?, index: IndexType, verify: Bool = true) -> Bool
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
    public mutating func assign(_ x: ValueType? = nil, index: IndexType) -> Bool
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
        var knownData = [ValueType]()
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
    public mutating func insert(_ x: ValueType?, at index: IndexType, verify: Bool = true) -> Bool
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
    
    public func get(nearest index: IndexType) -> (index: IndexType, value: ValueType)
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
    
    public func get(n: Int, nearest index: IndexType) -> [(index: IndexType, value: ValueType)]
    {
        if self.isEmpty { return [] }
        let (indexList, dataList, _) = self.present() // exclude missing values from search      
        
        // TODO: add overloads to resolve this inefficiency... converting to IndexTypes in present()
        // to then convert back to Doubles is stupid...
        let foundIndices = find(in: indexList.map({$0.indexToDouble()}), n: n, nearest: index.indexToDouble(), order: self._order)        
        
        var foundList = [(index: IndexType, value: ValueType)]()
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
    public func minus(_ other: DataSeries<IndexType, ValueType>, renamed: String? = nil, method: Nifty.Options.EstimationMethod = .nearlin) -> DataSeries<IndexType, ValueType>
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
        precondition(ValueType.self == Double.self, "Currently, minus() only accepts Double series ")
        
        // TODO: this is weird but done to get rid of any potential nil values... 
        // how should this be done better?
        
        let selfIndex = self._index.map({IndexType.indexFromDouble($0)}) // TODO: get rid of inefficiency mapping back and forth between doubles/indexes
        
        let selfValues = self.query(selfIndex) 
        
        let otherValues = other.query(selfIndex)
        assert(selfValues.count == otherValues.count, "Not possible to get different counts")
        
        let difference = selfValues.enumerated().map({(($0.1 as! Double) - (otherValues[$0.0] as! Double)) as! DataType})
        
        let newSeries = DataSeries<IndexType, ValueType>(difference, index: selfIndex, order: self._order, name: renamed, maxColumnWidth: self._width)
        
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
    public func mse(_ other: DataSeries<IndexType, ValueType>, method: Nifty.Options.EstimationMethod = .nearlin) -> Double
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
        precondition(ValueType.self == Double.self, "Currently, mse() only accepts Double series ")
        
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
    public func present() -> (index: [IndexType], data: [ValueType], locs: [Int])
    {
        if self.isEmpty { return ([], [], []) }
        
        let iDataList = self._data.enumerated().filter({$0.1 != nil})
        let iList = iDataList.map({$0.0})
        let dataList = iDataList.map({$0.1!})
        let indexList = iList.map({self._index[$0]})
        assert(dataList.count == indexList.count)
        
        return (indexList.map({IndexType.indexFromDouble($0)}), dataList, iList)
    }
    
    public func query(_ index: IndexType, method: Nifty.Options.EstimationMethod = .nearlin) -> ValueType?
    {                                
        let q = self.query([index], method: method)
        assert(q.count <= 1, "Not possible--single query cannot return more than 1 point")
        
        // TODO: better way to handle this than precondition? ...
        // In all other cases the return is not nil so making it an optional seems gross
        precondition(q.count > 0, "Cannot query empty series")         
        
        return q[0]
    }
    
    public func query(_ indexes: [IndexType], method: Nifty.Options.EstimationMethod = .nearlin) -> [ValueType?]
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
            let nils = [ValueType?](repeating: nil, count: c)
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
    public func resample(start: IndexType, step: Double, n: Int, name: String? = nil, method: Nifty.Options.EstimationMethod = .nearlin) -> DataSeries<IndexType, ValueType>
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
        return DataSeries<IndexType, ValueType>(data, index: indexTypes, order: self._order, name: name, maxColumnWidth: self._width)        
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
    public func rms(_ other: DataSeries<IndexType, ValueType>, method: Nifty.Options.EstimationMethod = .nearlin) -> Double
    {
        // TODO: revisit how to decide which indexes from each series to use... symmetry?
        
        let error = self.mse(other, method: method)
        return sqrt(error)
    }    
 
    
 
}


//==================================================================================================
// MARK: - INDEX AND VALUE DEFINITIONS
//==================================================================================================

/// Enumerates how the indexes of a series are ordered:
/// - decreasing: sorted large-to-small, no duplicates
/// - increasing: sorted small-to-large, no duplicates
/// - nonIncreasing: sorted large-to-small, with possible duplicates
/// - nonDecreasing: sorted small-to-large, with possible duplicates
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

/// Allows using arbitrary indices within a data series, where all index types use Doubles for the 
/// underlying representation.
public protocol DataSeriesIndexable: Comparable
{
    func indexToDouble() -> Double 
    static func indexFromDouble(_ d: Double) -> Self
}

extension Double: DataSeriesIndexable
{
    public func indexToDouble() -> Double { return self }
    public static func indexFromDouble(_ d: Double) -> Double { return d }
}

extension Date: DataSeriesIndexable
{
    public func indexToDouble() -> Double { return self.timeIntervalSince1970 }
    public static func indexFromDouble(_ d: Double) -> Date { return Date(timeIntervalSince1970: d) }
}

/// Handles properly comparing data series indexes, essentially just wrapping up configuration 
/// parameters for the isequals function. Reference semantics are desirable because all elements
/// in a series should have the same comparator (otherwise you could have asymetric equality e.g.)
public class DataSeriesIndexComparator
{
    internal let tolerance: Double
    internal let comparison: Nifty.Options.isequal?
    
    /// A simple wrapper for the `isequal()` function that allows for specifying how indices in this
    /// data series will be compared.
    ///
    /// - Parameters:
    ///     - tolerance: tolerance value
    ///     - comparison: comparison method
    public init(tolerance: Double = eps.single, comparison: Nifty.Options.isequal? = nil)
    {
        self.tolerance = tolerance
        self.comparison = comparison
    }
    
    /// Compare two data series indexes as specified.
    /// 
    /// - Parameters:
    ///     - a: left side index to compare
    ///     - b: right side index to compare
    /// - Returns: 0 if a == b, -1 if a < b, and 1 if a > b
    internal func compare(_ a: DataSeriesIndex, _ b: DataSeriesIndex) -> Int
    {
        if isequal(a.index, b.index, within: self.tolerance, comparison: self.comparison) 
        { 
            return 0  
        }
        else if a.index < b.index    
        { 
            return -1 
        }
        else                         
        { 
            return 1  
        }        
    }
}

/// Wraps an index into a data series in a class in order to enable proper double comparison, use
/// as dictionary key, and reference semantics.
internal class DataSeriesIndex: Hashable, Comparable
{
    let index: Double
    let comparator: DataSeriesIndexComparator
    
    init<T: DataSeriesIndexable>(_ i: T, _ c: DataSeriesIndexComparator)
    {
        self.index = i.indexToDouble()    
        self.comparator = c
    }
    
    var hashValue: Int
    {
        return index.hashValue
    }
    
    // Note: Only one of the lhs and rhs comparators is used; the comparators must be equivalent if 
    // symetric comparison is desired.
    
    static func == (lhs: DataSeriesIndex, rhs: DataSeriesIndex) -> Bool
    {
        return lhs.comparator.compare(lhs, rhs) == 0
    }
    
    static func < (lhs: DataSeriesIndex, rhs: DataSeriesIndex) -> Bool
    {
        return lhs.comparator.compare(lhs, rhs) == -1
    }
    
    static func > (lhs: DataSeriesIndex, rhs: DataSeriesIndex) -> Bool
    {
        return lhs.comparator.compare(lhs, rhs) == 1
    }
}

/// Wraps the double representation of a value corresponding to data series index into a class in 
/// order to get reference semantics.
internal class DataSeriesValue<T>
{
    var value: T
    
    init(_ v: T)
    {
        self.value = v
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
