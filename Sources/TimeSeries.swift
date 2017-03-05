/***************************************************************************************************
 *  TimeSeries.swift
 *
 *  This file defines a time series structure. 
 *
 *  Author: Philip Erickson
 *  Creation Date: 4 Mar 2017
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

public struct TimeSeries<T>: DataSeriesProtocol
{
    public typealias IndexType = Date

    //----------------------------------------------------------------------------------------------
    // MARK: Stored Properties
    //----------------------------------------------------------------------------------------------

    private var series : DataSeries<T>
    private var format : DateFormatter

    //----------------------------------------------------------------------------------------------
    // MARK: Computed Properties
    //----------------------------------------------------------------------------------------------

    public var count: Int { return self.series.count }

    public var data: [T?] { return self.series.data }

    public var description: String
    {
        let timeIndex = self.series.index.map
        { 
            self.format.string(from: Date(timeIntervalSince1970: $0))
        }

        let (blankInd, padInd) = _columnizeData(
            list: timeIndex, 
            name: "",
            maxWidth: self.series.maxColumnWidth, 
            padLeft: false)    

        let (padName, padData) = _columnizeData(
            list: self.series.data, 
            name: self.series.name ?? "", 
            maxWidth: self.series.maxColumnWidth, 
            padLeft: true)
        
        precondition(padInd.count == padData.count, "Must have same number of indexes as data points")
        
        var rows = ["\(blankInd!)   \(padName!)"]
        for i in 0..<padInd.count
        {
            rows.append("\(padInd[i]):  \(padData[i])")
        }
        
        return "\n" + rows.joined(separator: "\n")
    }

    public var index: [Date] { return self.series.index.map({Date(timeIntervalSince1970: $0)}) }

    public var isComplete: Bool { return self.series.isComplete }

    public var isEmpty: Bool { return self.series.isEmpty }

    public var maxColumnWidth: Int? { return self.series.maxColumnWidth }
    
    public var name: String? { return self.series.name }

    public var order: SeriesIndexOrder { return self.series.order }       
    
    public var type: T.Type { return self.series.type } 

    //----------------------------------------------------------------------------------------------
    // MARK: Initializers
    //----------------------------------------------------------------------------------------------
    
    // TODO: add initializer to convert data series to time series (where double is some number of ns
    // pas a given start date)

    public init(
        _ data: [T?] = [], 
        index: [Date] = [], 
        order: SeriesIndexOrder = .increasing, 
        name: String? = nil, 
        maxColumnWidth: Int? = nil,
        format: DateFormatter? = nil)
    {        
        let doubleIndex: [Double] = index.map({$0.timeIntervalSince1970})
        self.series = DataSeries(data, index: doubleIndex, order: order, name: name, maxColumnWidth: maxColumnWidth)

        self.format = DateFormatter()
        self.format.dateStyle = format?.dateStyle ?? .short
        self.format.timeStyle = format?.timeStyle ?? .medium
    }

    public init(
        _ data: [T?] = [], 
        start: Date, 
        step: Double, // TODO: switch this from double seconds to measurment duration
        order: SeriesIndexOrder = .increasing, 
        name: String? = nil, 
        maxColumnWidth: Int? = nil,
        format: DateFormatter? = nil)
    {        
        var index = [Date]()
        for (i, _) in data.enumerated()
        { 
            index.append(Date(timeInterval: Double(i)*step, since: start))
        }
        self.init(data, index: index, order: order, name: name, maxColumnWidth: maxColumnWidth, format: format)
    }

    //----------------------------------------------------------------------------------------------
    // MARK: Subscripts
    //----------------------------------------------------------------------------------------------

    // TODO: add setters

    public subscript(_ index: Date) -> T?
    {
        let d: Double = index.timeIntervalSince1970
        return self.series[d]
    }

    public subscript(_ slice: Range<Date>) -> [(index: Date, value:T?)]
    {
        let lo: Double = slice.lowerBound.timeIntervalSince1970
        let hi: Double = slice.upperBound.timeIntervalSince1970

        let range = lo..<hi
        print("subscripting: \(range)")

        let list = self.series[lo..<hi]

        print(type(of: list))
        print(list)


        //let ret =  list.map({(index: Date(timeIntervalSince1970: $0.0), value: $0.1)})

        var ret = [(index: Date, value: T?)]()
        for (itr,e) in list.enumerated()
        {
            let d = TimeInterval(e.0)

            print("itr = \(itr), e=\(e) (\(type(of:e))), --> \(d), \(type(of: d)) ")

            let i = Date(timeIntervalSince1970: d) // FIXME: for some reason this line fails on Linux

            print("i = \(i)")

            let v = e.1

            print("v = \(v)")

            let t = (index: i, value: v)

            print("t = \(t)")

            ret.append(t)
        }


        print(ret)

        return ret
    }

    public subscript(_ slice: ClosedRange<Date>) -> [(index: Date, value:T?)]
    {
        let lo: Double = slice.lowerBound.timeIntervalSince1970
        let hi: Double = slice.upperBound.timeIntervalSince1970
        let list = self.series[lo...hi]
        return list.map({(Date(timeIntervalSince1970: $0.0), $0.1)})
    }

    //----------------------------------------------------------------------------------------------
    // MARK: Mutating Functions
    //----------------------------------------------------------------------------------------------

    // TODO: accept nil for append

    public mutating func append(_ x: T, index: Date, verify: Bool = true) -> Bool
    {        
        let d: Double = index.timeIntervalSince1970
        return self.series.append(x, index: d, verify: verify)
    }

    public mutating func fill(method: Nifty.Options.EstimationMethod = .nearlin)
    {  
        self.series.fill(method: method)
    }

    public mutating func insert(_ x: T?, at index: Date, verify: Bool = true) -> Bool
    {        
        let d: Double = index.timeIntervalSince1970
        return self.series.insert(x, at: d, verify: verify)
    }

    //----------------------------------------------------------------------------------------------
    // MARK: Non-Mutating Functions
    //----------------------------------------------------------------------------------------------

    public func get(nearest index: Date) -> (index: Date, value: T)
    {
        let d: Double = index.timeIntervalSince1970
        let ret = self.series.get(nearest: d)
        return (Date(timeIntervalSince1970: ret.index), ret.value)
    }

    public func get(n: Int, nearest index: Date) -> [(index: Date, value: T)]
    {
        let d: Double = index.timeIntervalSince1970
        let dResult = self.series.get(n: n, nearest: d)

        return dResult.map({(Date(timeIntervalSince1970: $0.index), $0.value)})
    }

    // TODO: add before and after getters

    // TODO: add rename to minus?

    public func minus(_ other: TimeSeries<T>, method: Nifty.Options.EstimationMethod = .nearlin) -> TimeSeries<T>
    {
        // TODO: revisit this for efficiency (shouldn't need to convert to double then back to date)

        let dIndex = other.index.map({$0.timeIntervalSince1970})
        let dOther = DataSeries<T>(other.data, index: dIndex, order: other.order, name: other.name, 
            maxColumnWidth: other.maxColumnWidth)
        let dResult = self.series.minus(dOther, method: method)
        let tIndex = dResult.index.map({Date(timeIntervalSince1970: $0)})
        let result = TimeSeries<T>(dResult.data, index: tIndex, order: dResult.order, name: dResult.name,
            maxColumnWidth: dResult.maxColumnWidth, format: self.format)

        return result
    }

    public func mse(_ other: TimeSeries<T>, method: Nifty.Options.EstimationMethod = .nearlin) -> Double
    {
        // TODO: revisit this for efficiency (shouldn't need to convert to double then back to date)

        let dIndex = other.index.map({$0.timeIntervalSince1970})
        let dOther = DataSeries<T>(other.data, index: dIndex, order: other.order, name: other.name, 
            maxColumnWidth: other.maxColumnWidth)
        
        return self.series.mse(dOther, method: method)
    }

    public func present() -> (index: [Date], data: [T], locs: [Int])
    {
        let ret = self.series.present()
        var index = [Date]()
        for d in ret.index
        {
            index.append(Date(timeIntervalSince1970: d))
        }

        return (index, ret.data, ret.locs)
    }

    public func query(_ index: Date, method: Nifty.Options.EstimationMethod = .nearlin) -> T
    {  
        return self.series.query(index.timeIntervalSince1970, method: method)
    }

    public func query(_ indexes: [Date], method: Nifty.Options.EstimationMethod = .nearlin) -> [T]
    {
        let dIndex = index.map({$0.timeIntervalSince1970})
        return self.series.query(dIndex, method: method)   
    }

    // TODO: step is number of seconds to step... change it to time measurement? This will break the protocol, which requires it as a double

    public func resample(start: Date, step: Double, n: Int, name: String? = nil, method: Nifty.Options.EstimationMethod = .nearlin) -> TimeSeries<T>
    {
        let dResult = self.series.resample(start: start.timeIntervalSince1970, step: step,
            n: n, name: name, method: method)
        let tIndex = dResult.index.map({Date(timeIntervalSince1970: $0)})
        let result = TimeSeries<T>(dResult.data, index: tIndex, order: dResult.order, name: dResult.name,
            maxColumnWidth: dResult.maxColumnWidth, format: self.format)

        return result
    }

    public func rms(_ other: TimeSeries<T>, method: Nifty.Options.EstimationMethod = .nearlin) -> Double
    {
        let error = self.mse(other, method: method)
        return sqrt(error)
    }
}