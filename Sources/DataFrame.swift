/***************************************************************************************************
 *  DataFrame.swift
 *
 *  This file defines a data frame structure. 
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
import Foundation

public struct DataFrame<IndexType: DataSeriesIndexable>: CustomStringConvertible
{
    //----------------------------------------------------------------------------------------------
    // MARK: - Stored Properties
    //----------------------------------------------------------------------------------------------
    
    internal var series     : [DataSeries<IndexType, Any>]	   
    internal var types      : [Any.Type]
    
    //----------------------------------------------------------------------------------------------
    // MARK: - Computed Properties
    //----------------------------------------------------------------------------------------------
    
    public var count: Int
    {
        return self.series.count
    }
    
    public var description: String
    {
        let selfCopy = self.copyWithFilledIndex()
        
        if selfCopy.series.isEmpty { return "[]" }
        
        let (blankInd, padInd) = _columnizeData(
            list: selfCopy.series[0].index, 
            name: "",
            maxWidth: nil, 
            padLeft: false)	
        
        var padNames = [String]()
        var padSeries = [[String]]() 
        for i in 0..<selfCopy.series.count
        {			
            let (padName, padData) = _columnizeData(
                list: selfCopy.series[i].data, 
                name: selfCopy.series[i].name ?? "n/a", 
                maxWidth: selfCopy.series[i].maxColumnWidth, 
                padLeft: true)
            padNames.append(padName!)
            padSeries.append(padData)
        }
        
        assert( padSeries.reduce(true, {($1.count == padInd.count) && $0}), 
                "All series must have same number of indexes as data points" )
        
        var rows = [String]()
        let nameRow = blankInd! + " " + "   " + padNames.joined(separator: "   ")
        if !nameRow.isEmpty { rows.append(nameRow) }
        for r in 0..<padSeries[0].count
        {
            var curRow = [String]()
            for c in -1..<padSeries.count
            {
                if c == -1 { curRow.append(padInd[r] + ":") }
                else { curRow.append(padSeries[c][r]) }	
            }
            rows.append(curRow.joined(separator: "   "))
        }
        
        return rows.joined(separator: "\n")
    }		
    
    public var isComplete: Bool
    {
        return self.series.reduce(true, { $0 && $1.isComplete })
    }
    
    public var isEmpty: Bool
    {
        return self.series.isEmpty
    }
    
    //----------------------------------------------------------------------------------------------
    // MARK: - Initializers
    //----------------------------------------------------------------------------------------------    
    
    public init()
    {
        self.series = []
        self.types = []
    }
    
    public init(_ series: [DataSeries<IndexType, Any>])
    {
        self.series = []     
        self.types = []
        self.assign(series)
    }
    
    public init(_ series: DataSeries<IndexType, Any>...)
    {
        self.init(series)
    }
    
    /*
     // TODO: add init that reads csv string
     public init(
     csv: String, 
     skipRows        : [Int]                                         = [],
     headerRows      : [Int]                                         = [0],
     indexColumn     : Int?                                          = nil,
     indexColumnName : String?                                       = nil,
     dataColumns     : [Int?]?                                       = nil,
     dataColumnNames : [String?]?                                    = nil,
     dataColumnTypes : Any.Type...,
     indexTransform  : DataSeries<IndexType, Any>.IndexTransform?    = nil,
     dataTransform   : DataSeries<IndexType, Any>.DataTransform?     = nil,
     order           : DataSeriesIndexOrder                          = .increasing, 
     names           : [String?]?                                    = nil, 
     maxColumnWidth  : Int?                                          = nil)
     {                
     // TODO: this can be made more efficient by doing all columns at once rather than doing each
     // series in its entirety sequentially
     
     THIS IS ONLY PARTIALLY COMPLETE
     
     let numberOfSeries: Int
     if dataColumns != nil && dataColumnNames == nil
     {
     numberOfSeries = dataColumns!.count
     }
     else if dataColumns == nil && dataColumnNames != nil
     {
     numberOfSeries = dataColumnNames!.count
     }
     else
     {
     fatalError("Must have exactly one or the other of names and index")
     }
     
     var parsedSeriesTypes: [Any.Type]
     if dataColumnTypes.count < 1 
     { 
     fatalError("Must have at least 1 column type") 
     }
     else if dataColumnTypes.count == 1
     {
     parsedSeriesTypes = Array(repeating: dataColumnTypes[0], count: numberOfSeries)
     }
     else
     {
     precondition(parsedSeriesTypes.count == numberOfSeries, "Invalid number of column types given")
     parsedSeriesTypes = dataColumnTypes            
     }
     
     var parsedSeries = [DataSeries<Any>]()
     
     for seriesNum in 0..< numberOfSeries
     {
     
     let curType = parsedSeriesTypes[seriesNum]
     
     //let curSeries = 
     
     }
     
     }
     
     fatalError("Not yet impl")
     }
     */
    
    //----------------------------------------------------------------------------------------------
    // MARK: - Non-Mutating Functions
    //----------------------------------------------------------------------------------------------    
    
    public func contains(_ column: String, caseInsensitive: Bool = false) -> Bool
    {
        if caseInsensitive
        {
            for i in 0..<self.count 
            { 
                if self.series[i].name?.caseInsensitiveCompare(column) == ComparisonResult.orderedSame { return true } 
            }
        }
        else
        {
            for i in 0..<self.count { if self.series[i].name == column { return true } }
        }
        
        return false
    }        
    
    public func get<DataType>(_ column: String) -> DataSeries<IndexType, DataType>?
    {
        var matches = [Int]()
        for i in 0..<self.count
        {
            if self.series[i].name == column { matches.append(i) }
        }
        
        if matches.isEmpty { return nil }
        precondition(matches.count == 1, "Duplicate column '\(column)'")
        
        let s = self.series[matches[0]]      
        
        var ind = [IndexType]()
        var dat = [DataType?]()
        for j in 0..<s.count
        {                    
            var newData: DataType? = nil    
            if let d = s.data[j]
            {
                guard let t = d as? DataType else 
                { 
                    print("Warning: Can't get DataSeries<\(type(of:d))> as DataSeries<\(DataType.self)>")
                    return nil
                } 
                newData = t
            }
            
            ind.append(s.index[j])
            dat.append(newData)
        }
        
        return DataSeries<IndexType, DataType>(dat, index: ind, name: s.name, maxColumnWidth: s.maxColumnWidth) 
    }
    
    public func locate(_ column: String, caseInsensitive: Bool = false) -> Int?
    {
        if caseInsensitive
        {
            for i in 0..<self.count 
            { 
                if self.series[i].name?.caseInsensitiveCompare(column) == ComparisonResult.orderedSame { return i } 
            }
        }
        else
        {
            for i in 0..<self.count { if self.series[i].name == column { return i } }
        }
        
        return nil        
    }
    
    public func resample(start: IndexType, step: Double, n: Int, name: String? = nil, method: Nifty.Options.EstimationMethod = .nearlin) -> DataFrame<IndexType>
    {
        
        
        
        var resampledFrame = DataFrame<IndexType>()
        
        for i in 0..<self.series.count
        {
            let resampledSeries = self.series[i].resample(
                start: start, 
                step: step, 
                n: n, 
                name: self.series[i].name, 
                method: method)            
            
            resampledFrame.assign(resampledSeries)
        }
        
        return resampledFrame
    }
    
    //----------------------------------------------------------------------------------------------
    // MARK: - Mutating Functions
    //----------------------------------------------------------------------------------------------    
    
    // TODO: mutating func set<T>(_ column: String,                  to series: DataSeries<T>) 
    // TODO: mutating func set<T>(_ column: Int,                     to series: DataSeries<T>)
    // TODO: mutating func set<T>(_ column: String, _ index: Double, to element: T)
    // TODO: mutating func set<T>(_ column: Int,    _ index: Double, to element: T)
    
    public mutating func assign<DataType>(_ newSeries: [DataSeries<IndexType, DataType>])
    {
        for si in 0..<newSeries.count
        {
            var s = newSeries[si]
            let origIndex = s.index
            
            // ensure new series order matches
            // TODO: revisit how ordering mismatch between series should be handled... 
            // Should it just crash? Is there a more graceful handling? Should it allow order downgrading?
            if !self.isEmpty
            {
                precondition(self.series[0].order == s.order, "Cannot assign mismatch series order")
            }
            
            // ensure each series has a unique name in frame
            let rootName = s.name ?? "column_\(self.series.count+1)"
            var uniqueName = rootName
            var uniqueID = 1
            while self.contains(uniqueName)
            {
                uniqueName = rootName + "_\(uniqueID)"
                uniqueID += 1
            }
            
            // add indexes from this data frame to new series
            if !self.series.isEmpty
            {
                for dfIndex in self.series[0].index // Note: all series in frame have same index!
                {
                    _ = s.assign(index: dfIndex)
                }
            }
            
            // add indexes from s to every series in this DataFrame
            for sIndex in origIndex
            {
                for dfi in 0..<self.series.count
                {
                    // TODO: improve efficiency of assigning new index to all current series...
                    // All series will insert the index at the same place (since all series in a 
                    // frame have identical indexes). Calling assign each time searches for the 
                    // location every time. Instead, find the location once then insert into all
                    // series.
                    _ = self.series[dfi].assign(index: sIndex)                    
                }
            }
            
            // create new series with elements upcast to Any and add to this DataFrame
            // TODO: revisit this for efficiency; currently create new series needs to recheck the ordering
            var newData = [Any]()
            for el in s.data { newData.append(el as Any) }
            let newSeries = DataSeries<IndexType, Any>(newData, index: s.index, order: s.order, 
                                                       name: uniqueName, maxColumnWidth: s.maxColumnWidth)
            self.series.append(newSeries)
            self.types.append(DataType.self)
        }
    }
    
    public mutating func assign<DataType>(_ newSeries: DataSeries<IndexType, DataType>...)
    {
        self.assign(newSeries)
    }	
    
    public mutating func append<DataType>(_ x: DataType, index: IndexType, to series: String, verify: Bool = true) -> Bool
    {
        // TODO: decide how to handle when this frame doesn't contain the given column
        // Perhaps crashing is okay? Maybe it should add a series with that name? Throw? Return false
        // for failure, true for success?
        
        guard let i = self.locate(series) else 
        { 
            print("Frame contains no series '\(series)'") 
            return false
        }
        
        // FIXME: append needs to keep the indexes in sync across all the series in this frame...
        // When appending, we need to append nil to all the other series. But then what happens when 
        // someone appends a value to a series that just had a nil written? You'll get a duplicate index
        // when there really shouldn't be... Maybe the best solution is to not resolve indexes until
        // needed. Maybe keeping a index list that has the union of all indices is best, then for like
        // prinitng that list can be used, inserting nils as needed without having to make all the 
        // series match
        
        guard self.types[i] == type(of: x) else 
        {
            print("Cannot append value of type \(type(of: x)) to series of type \(self.types[i])")
            return false
        }
        
        let success = self.series[i].append(x, index: index, verify: verify)
        
        return success        
    }
    
    public mutating func fill(method: Nifty.Options.EstimationMethod = .nearlin)
    {
        for i in 0..<self.series.count
        {
            self.series[i].fill(method: method)
            
            assert(self.series[i].data.count == self.series[0].count, "Sanity check--filled series must match original size")
        }
    }      
    
    /// This function adds indexes to all series in the frame such that all series have the exact 
    /// same indexes. Any indexes that need to be added to a series are given a value of nil.
    public func copyWithFilledIndex() -> DataFrame<IndexType>
    {
        // FIXME: this function returns a copy of the frame that has the indexes filled, rather than
        // modifying self. The reason is because the computed description property (for 
        // CustomStringConvertible) cannot mutate self, and printing self is the main motivator
        // for this method. This should be redesigned to be better.
        var frameCopy = self
        
        let allSorted = frameCopy.series.reduce(true, {$0 && $1.order.isSorted})
        let allUnique = frameCopy.series.reduce(true, {$0 && $1.order.isUnique})
        
        // TODO: implement solution to allow filling frames with series that have non-unique index...
        // The way fillIndex is currently done is to create a union set of indices from all series
        // then fill them in all series. So if there are duplicate entries in any series then the 
        // duplicate index will be omitted in other series.
        guard allSorted && allUnique else
        {
            print("Aborting: unable to fill indices on anything but a frame containing only sorted unique indices--implement me")
            return frameCopy
        }
        
        var indexUnion = Set<Double>()
        for s in frameCopy.series
        {
            indexUnion = indexUnion.union(s._index)
        }
        
        for loc in 0..<frameCopy.count
        {
            for dInd in indexUnion
            {
                _ = frameCopy.series[loc].assign(nil, index: IndexType.indexFromDouble(dInd))                
            }            
        }
        
        return frameCopy
        
    }
    
    
    /// This function adds indexes to all series in the frame such that all series have the exact 
    /// same indexes. Any indexes that need to be added to a series are given a value of nil.
    public mutating func fillIndex()
    {
        let allSorted = self.series.reduce(true, {$0 && $1.order.isSorted})
        let allUnique = self.series.reduce(true, {$0 && $1.order.isUnique})
        
        // TODO: implement solution to allow filling frames with series that have non-unique index...
        // The way fillIndex is currently done is to create a union set of indices from all series
        // then fill them in all series. So if there are duplicate entries in any series then the 
        // duplicate index will be omitted in other series.
        guard allSorted && allUnique else
        {
            print("Aborting: unable to fill indices on anything but a frame containing only sorted unique indices--implement me")
            return
        }
        
        var indexUnion = Set<Double>()
        for s in self.series
        {
            indexUnion = indexUnion.union(s._index)
        }
        
        for loc in 0..<self.count
        {
            for dInd in indexUnion
            {
                _ = self.series[loc].assign(nil, index: IndexType.indexFromDouble(dInd))                
            }            
        }
    }
}
