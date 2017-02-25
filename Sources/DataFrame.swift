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

struct DataFrame: CustomStringConvertible
{
    var series : [[Any?]]	
    var names  : [String] 
    var widths : [Int?]
    var index  : [Double]
    
    var description: String
    {
        let (blankInd, padInd) = _columnizeData(
            list: self.index, 
            name: "",
            maxWidth: nil, 
            padLeft: false)	
        
        var padNames = [String]()
        var padSeries = [[String]]() 
        for i in 0..<self.series.count
        {			
            let (padName, padData) = _columnizeData(
                list: self.series[i], 
                name: self.names[i], 
                maxWidth: self.widths[i], 
                padLeft: true)
            padNames.append(padName!)
            padSeries.append(padData)
        }
        
        assert( padSeries.reduce(true, {($1.count == padInd.count) && $0}), 
                "All series must have same number of indexes as data points" )
        
        var rows = [String]()
        let nameRow = blankInd! + " " + "  " + padNames.joined(separator: "  ")
        if !nameRow.isEmpty { rows.append(nameRow) }
        for r in 0..<padSeries[0].count
        {
            var curRow = [String]()
            for c in -1..<padSeries.count
            {
                if c == -1 { curRow.append(padInd[r] + ":") }
                else { curRow.append(padSeries[c][r]) }	
            }
            rows.append(curRow.joined(separator: "  "))
        }
        
        return rows.joined(separator: "\n")
    }		
    
    init()
    {
        self.series = []
        self.names  = []
        self.widths = []
        self.index  = []
    }
    
    init<T>(_ series: DataSeries<T>..., columnWidth: Int = 15)
    {
        self.series = []
        self.names  = []
        self.widths = []
        self.index  = []
        
        self.add(series)
    }
    
    func get<T>(_ column: String) -> DataSeries<T>?
    {
        if let i = self.names.index(of: column)
        {
            let s = self.series[i]
            
            assert(self.index.count == s.count)            
            var ind = [Double]()
            var dat = [T]()
            for j in 0..<self.index.count
            {
                if let d = s[j]
                {
                    guard let t = d as? T else { fatalError("Can't get DataSeries<\(type(of:d))> as DataSeries<\(T.self)>") }
                    ind.append(self.index[j])
                    dat.append(t)
                }
            }
            
            return DataSeries<T>(dat, index: ind, name: self.names[i], maxColumnWidth: self.widths[i])
        }
        else { return nil }
    }
    
    mutating func add<T>(_ series: DataSeries<T>...)
    {
        self.add(series)
    }
    
    mutating func add<T>(_ series: [DataSeries<T>])
    {
        for s in series
        {
            let rootName = s.name ?? "col\(self.series.count+1)"
            var name = rootName
            var dupe = 1
            while self.names.contains(where: {$0 == name})
            {
                name = rootName + "_\(dupe)"
                dupe += 1
            }
            
            // Reconcile the frame index with the index of the series to append
            // TODO: ensure the indexes are in sorted ascending order
            var newIndex = s.index  
            var newSeries: [Any?] = s.data
            var i = 0
            var j = 0
            while true            
            {                
                // if frame index has no values left to traverse, add remaining rows from new series index
                if i > self.index.count-1
                {
                    let remainIndex = newIndex[j..<newIndex.count]  
                    self.index.append(contentsOf: remainIndex)                    
                    let remainData = Array<Any?>(repeating: nil, count: remainIndex.count)
                    for k in 0..<self.series.count { self.series[k].append(contentsOf: remainData) }                    
                    break
                }
                
                // if new series index has no values left to traverse, add remaining rows from frame index
                if j > newIndex.count-1
                {                    
                    let remainData = Array<Any?>(repeating: nil, count: self.index.count-i)
                    newSeries.append(contentsOf: remainData)
                    break    
                }
                
                // if the frame index matches new index for this row, nothing new needs to be added
                if self.index[i] == newIndex[j] // FIXME: double compare correctly
                {
                    i = i+1
                    j = j+1
                }
                    
                    // if the frame index is missing a row that the new series index has, add row to frame
                else if self.index[i] > newIndex[j]
                {
                    self.index.insert(newIndex[j], at: i); i += 1
                    for k in 0..<self.series.count { self.series[k].insert(nil, at: i) }
                    j = j+1 //min(j+1, newIndex.count-1)
                }
                    
                    // if the frame index has a row the new series index doesn't, add a nil placholder to new series
                else // index[i] < newIndex[j]
                {
                    newSeries.insert(nil, at: i)
                    i = i+1
                }
            }
            
            self.series.append(newSeries)            
            self.names.append(name)
            self.widths.append(s.maxColumnWidth)
            
            assert(Set<Int>([self.series.count, self.names.count, self.widths.count]).count == 1,
                   "Member lists must have the same number of elements")
            assert(self.series.reduce(true, {$0 && $1.count == self.index.count}),
                   "Index and series count must match")
        }
    }	
    
    mutating func fill(method: Nifty.Options.EstimationMethod = .nearest)
    {
        for (i, data) in self.series.enumerated()
        {
            var tempSeries = DataSeries(data, index: self.index)
            tempSeries.fill(method: method)
            
            assert(tempSeries.data.count == self.index.count, "Filled series must match original size")
            self.series[i] = tempSeries.data
        }
    }
}
