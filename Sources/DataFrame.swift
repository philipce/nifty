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

public protocol DataFrameProtocol: CustomStringConvertible
{
    var count:      Int  { get }
    var isComplete: Bool { get }
    var isEmpty:    Bool { get }

    init()
    init(_ : [DataSeries<Any>])
    init(_ : DataSeries<Any>...)    
    init(_ : String)
    
    func contains(_ : String) -> Bool
    func get<T>(_ : String) -> DataSeries<T>?
    
    mutating func add<T>(_ : [DataSeries<T>])
    mutating func add<T>(_ : DataSeries<T>...)
    mutating func fill(method: Nifty.Options.EstimationMethod)
}

public struct DataFrame: DataFrameProtocol
{
    //----------------------------------------------------------------------------------------------
    // MARK: Stored Properties
    //----------------------------------------------------------------------------------------------
    
    internal var series : [DataSeries<Any>]	   

    //----------------------------------------------------------------------------------------------
    // MARK: Computed Properties
    //----------------------------------------------------------------------------------------------
    
    public var count: Int
    {
        return self.series.count
    }

    public var description: String
    {
        if self.series.isEmpty { return "Empty DataSeries" }

        let (blankInd, padInd) = _columnizeData(
            list: self.series[0].index, 
            name: "",
            maxWidth: nil, 
            padLeft: false)	
        
        var padNames = [String]()
        var padSeries = [[String]]() 
        for i in 0..<self.series.count
        {			
            let (padName, padData) = _columnizeData(
                list: self.series[i].data, 
                name: self.series[i].name ?? "n/a", 
                maxWidth: self.series[i].maxColumnWidth, 
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
    // MARK: Initializers
    //----------------------------------------------------------------------------------------------    
    
    public init()
    {
        self.series = []
    }
    
    public init(_ series: [DataSeries<Any>])
    {
        self.series = []        
        self.add(series)
    }

    public init(_ series: DataSeries<Any>...)
    {
        self.init(series)
    }

    // TODO: add init that reads csv string
    public init(_ csv: String)
    {
        fatalError("Not yet impl")
    }

    //----------------------------------------------------------------------------------------------
    // MARK: Non-Mutating Functions
    //----------------------------------------------------------------------------------------------    
    
    public func contains(_ column: String) -> Bool
    {
        // TODO: add case insensitive option

        for i in 0..<self.count
        {
            if self.series[i].name == column { return true }
        }

        return false
    }

    public func get<T>(_ column: String) -> DataSeries<T>?
    {
        var matches = [Int]()
        for i in 0..<self.count
        {
            if self.series[i].name == column { matches.append(i) }
        }

        if matches.isEmpty { return nil }
        precondition(matches.count == 1, "Duplicate column '\(column)'")
        
        let s = self.series[matches[0]]      

        var ind = [Double]()
        var dat = [T?]()
        for j in 0..<s.count
        {                    
            var newData: T? = nil    
            if let d = s.data[j]
            {
                guard let t = d as? T else 
                { 
                    print("Warning: Can't get DataSeries<\(type(of:d))> as DataSeries<\(T.self)>")
                    return nil
                } 
                newData = t
            }
            ind.append(s.index[j])
            dat.append(newData)
        }
        
        return DataSeries<T>(dat, index: ind, name: s.name, maxColumnWidth: s.maxColumnWidth) 
    }

    //----------------------------------------------------------------------------------------------
    // MARK: Mutating Functions
    //----------------------------------------------------------------------------------------------    

    // TODO: mutating func set<T>(_ column: String,                  to series: DataSeries<T>) 
    // TODO: mutating func set<T>(_ column: Int,                     to series: DataSeries<T>)
    // TODO: mutating func set<T>(_ column: String, _ index: Double, to element: T)
    // TODO: mutating func set<T>(_ column: Int,    _ index: Double, to element: T)
    
    public mutating func add<T>(_ addSeries: [DataSeries<T>])
    {
        // FIXME: the following code assumes the series are ascending...
        // We should add support for any series ordering, but this will take some thinking for how
        // to handle reconciliation of indexes when there may be duplicate values. Also, we will
        // need to decide how to handle a frame with each series sorted differently (if at all--this
        // seems like it should perhaps be disallowed)
        assert(self.series.reduce(true, {$0 && $1.order == .increasing}), 
            "Only increasing series currently supported")        

        for si in 0..<addSeries.count
        {
            var s = addSeries[si]
            let origIndex = s.index

            // ensure each series has a unique name
            let rootName = s.name ?? "column_\(self.series.count+1)"
            var uniqueName = rootName
            var uniqueID = 1
            while self.contains(uniqueName)
            {
                uniqueName = rootName + "_\(uniqueID)"
                uniqueID += 1
            }

            // add indexes from DataFrame to s
            if !self.series.isEmpty
            {
                for dfIndex in self.series[0].index
                {
                    let doInsert: Bool
                    if s.isEmpty { doInsert = true }
                    else
                    {
                        // check if the new series already has the current index from this data frame
                        let ind = s.index[find(in: s.index, nearest: dfIndex)]
                        doInsert = ind != dfIndex // FIXME: proper double compare
                    }
                    if doInsert
                    {
                        let success = s.insert(nil, at: dfIndex, verify: true)
                        assert(success, "Failed to add nil to series") // TODO: handle this better
                    }
                }
            }

            // add indexes from s to every series in this DataFrame
            for sIndex in origIndex
            {
                let doInsert: Bool
                if self.isEmpty { doInsert = true }
                else
                {
                    if self.series[0].index.isEmpty { doInsert = true }
                    else
                    {
                        // check if this data frame already has the current index from the new series
                        let ind = self.series[0].index[find(in: self.series[0].index, nearest: sIndex)]
                        doInsert = ind != sIndex // FIXME: proper double compare
                    }                   
                }
                if doInsert
                {                    
                    for dfi in 0..<self.series.count
                    {                 
                        let success = self.series[dfi].insert(nil, at: sIndex, verify: true)
                        assert(success, "Failed to add nil to series") // TODO: handle this better
                    }
                }
            }

            // create new series with elements upcast to Any and add to this DataFrame
            // TODO: revisit this for efficiency; currently create new series needs to recheck the ordering
            var newData = [Any]()
            for el in s.data { newData.append(el as Any) }
            let newSeries = DataSeries<Any>(newData, index: s.index, order: s.order, 
                name: uniqueName, maxColumnWidth: s.maxColumnWidth)
            self.series.append(newSeries)
        }
    }
    
    public mutating func add<T>(_ addSeries: DataSeries<T>...)
    {
        self.add(addSeries)
    }	
    
    public mutating func fill(method: Nifty.Options.EstimationMethod = .nearlin)
    {
        for i in 0..<self.series.count
        {
            self.series[i].fill(method: method)

            assert(self.series[i].data.count == self.series[0].count, "Sanity check--filled series must match original size")
        }
    }
}
