/***************************************************************************************************
 *  TimeSeries_test.swift
 *
 *  This file tests TimeSeries.
 *
 *  Author: Philip Erickson
 *  Creation Date: 5 Mar 2017
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
import XCTest
@testable import Nifty

class TimeSeries_test: XCTestCase 
{
    #if os(Linux)
    static var allTests: [XCTestCaseEntry] 
    {
    let tests = 
    [
    testCase([("testBasic", self.testBasic)]),
    ]
    
    return tests
    }
    #endif
    
    func testBasic() 
    {               
        let a1: [Int?] = [2,3,nil]
        let a2 = [2.35,0.23,4.24]

        
        let a3 = [22.35,10.23,44.24]
        let a4 = [132.35,670.23,54.2564,687.243,73.123]
        let a5: [Bool?] = [true, nil,nil,nil,nil,nil,nil,nil,false]
        let i5: [Double] = [3,6,9,13,14,15,18,23,30]
        let a6 = ["Asdfsdfwefsdf","Bdhdhgwregsgsdfg"]
        let a7: [Double?] = [12.3, nil, 45.3, nil, nil, nil, 123.1]
        let a8 = [23.4, 456.2, 545.3, 1423.23] 
        let a9 = [3453.234, 2344.2, 145.3, 45.3, 3.4, 0.4, -1.23, -12.43, -346.3]

        let startDate = Date()

        let s1 = TimeSeries(a1, start: startDate, step: 60, name: "s1")
        let s2 = TimeSeries(a2, start: startDate, step: 60, name: "s2")
        let s3 = TimeSeries(a3, start: startDate, step: 60)
        let s4 = TimeSeries(a4, start: startDate, step: 60, name: "s4")
        let s5 = TimeSeries(a5, index: i5.map({Date(timeIntervalSince1970: Double($0*10))}))
        let s6 = TimeSeries(a6, start: startDate, step: 60, name: "s6", maxColumnWidth: 15)
        var s7 = TimeSeries(a7, start: startDate, step: 60, name: "s7")

        
        print("\n\n\n\n***************************************************\n")

        print(s1)     
        print("\ns1[\(startDate)]: \(s1[startDate])")
        XCTAssert(s1[startDate] == a1[0])
    
        
        // FIXME: slicing s2 breaks on linux!
        //let s2_slice = s2[startDate..<Date(timeInterval: 120, since:startDate)]
        //print("s2_slice: \(s2_slice)")

        


        
        /*
        print(s2)
        XCTAssert(isequal(s2[1] ?? -99.9, a2[1]))       

        print("\ns3 = \(s3)")
        
        for i in 0..<a4.count
        {
            print("\ns4[\(i)]: \(s4[Double(i)])")
            XCTAssert(isequal(s4[Double(i)] ?? -99.9, a4[i]))
        }
        
        print("\ns4[0..<4]: \(s4[0..<4])")
        XCTAssert(s4[0..<4][0].0 == 1.0 && s4[0..<4][0].1 == 670.23)        
        XCTAssert(s4[0..<4][1].0 == 2.0 && s4[0..<4][1].1 == 54.2564)
        XCTAssert(s4[0..<4][2].0 == 3.0 && s4[0..<4][2].1 == 687.243)

        print("\ns4[0.5...4.1]: \(s4[0.5...4.1])")
        XCTAssert(s4[0.5...4.1][0].0 == 0.5)
        XCTAssert(s4[0.5...4.1][5].0 == 4.1)

        print("\ns4[0.1...14.1]: \(s4[0.1...14.1])")
        print("\ns4[0.0...14.1]: \(s4[0.0...14.1])")
        print("\ns4[-2.0...3.0]: \(s4[-2.0...3.0])")
                
        let s3_resamp = s3.resample(start: 0.0, step: 0.5, n: 10, name: "resampled s3")
        print(s3_resamp)
        XCTAssert(s3_resamp.count == 10)
        
        print(s5)
        XCTAssert(!s5.isEmpty)
        XCTAssert(s5.index == i5)
        
        print(s6)

        print(s7)
        XCTAssert(!s7.isEmpty && !s7.isComplete)
        s7.fill()
        XCTAssert(!s7.isEmpty && s7.isComplete)
        print(s7)
        
        print("\n\n\n\n")
        
        var df = DataFrame()
        df.add(s1)
        df.add(s2)
        df.add(s3)
        df.add(s4)
        df.add(s5)
        df.add(s6)
        df.add(s7)
        
        print("\n\nOriginal data frame:\n\(df)")
        df.fill()
        print("\nFilled data frame:\n\(df)")
        
        if let S1: DataSeries<Int> = df.get("s1")
        {
            XCTAssert(S1.data[0] == 2 && S1.data[10] == 3)
            print(S1)
        }
        else { XCTAssert(false) }        

        if let S2: DataSeries<Double> = df.get("s2")
        {
            XCTAssert(S2.data[0] == 2.35 && S2.data[10] == 4.24)
            print(S2)
        }
        else { XCTAssert(false) }       

        var s8 = DataSeries<Double>()
        for (i,v) in a8.enumerated()
        {
            XCTAssert(s8.append(v, index: Double(i)))
        }
        print(s8)
        XCTAssert(!s8.append(9.9, index: 1.21))
        print(s8)

        var s9 = DataSeries<Double>(order: .decreasing)
        for i in stride(from: a9.count-1, through: 0, by: -1)
        {
            XCTAssert(s9.append(a9[i], index: Double(i)))
        }
        XCTAssert(!s9.append(122344.234, index: 123.1))   

        print("s9: \(s9)\n")     

        // Minus
        print("\nMinus function...")
        let s3_minus_s4 = s3.minus(s4)
        print("s3-s4:\(s3_minus_s4)\n\n")       
        XCTAssert([-110.0, -660.0, -10.0164, -643.003, -28.883].enumerated()
            .reduce(0.0, {$0 + ((s3_minus_s4.data[$1.0] ?? -99.9)-$1.1)}) < 0.00001)

        let s4_minus_s3 = s4.minus(s3)
        print("s4-s3:\(s4_minus_s3)\n\n")
        XCTAssert([110.0, 660.0, 10.0164, 643.003, 28.883].enumerated()
            .reduce(0.0, {$0 + ((s4_minus_s3.data[$1.0] ?? -99.9)-$1.1)}) < 0.00001)

        // Present
        let (ind1, dat1, loc1) =  s1.present()
        XCTAssert(ind1.count == 2 && dat1.count == 2 && loc1.count == 2)
        
        // MSE and RMS        
        let mse22 = s2.mse(s2)
        XCTAssert(mse22 < 0.000000001)
        
        let rms22 = s2.rms(s2)
        XCTAssert(rms22 < 0.000000001)
        
        let mse23 = s2.mse(s3)
        let mse32 = s3.mse(s2)
        XCTAssert(mse23 == mse32 && (mse23-700 < 0.000001))
        
        let rms23 = s2.rms(s3)
        let rms32 = s3.rms(s2)
        XCTAssert(rms23 == rms32 && (rms23-26.4575131106 < 0.0000000001))

        */
    }
}
