/***************************************************************************************************
 *  DataFrame_test.swift
 *
 *  This file tests DataFrame.
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

import XCTest
@testable import Nifty

class DataFrame_test: XCTestCase 
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
        let a2: [Double?] = [2.35,0.23,4.24]
        let a3: [Double?] = [22.35,10.23,44.24]
        let a4: [Double?] = [132.35,670.23,54.2564,687.243,73.123]
        let a5: [Bool?] = [true, nil,nil,nil,nil,nil,nil,nil,false]
        let i5: [Double] = [3,6,9,13,14,15,18,23,30]
        let a6: [String?] = ["Asdfsdfwefsdf","Bdhdhgwregsgsdfg"]
        let a7: [Double?] = [12.3, nil, 45.3, nil, nil, nil, 123.1]

        let s1 = DataSeries(a1, name: "s1")
        let s2 = DataSeries(a2, name: "s2")
        let s3 = DataSeries(a3)
        let s4 = DataSeries(a4, name: "s4")
        let s5 = DataSeries(a5, index: i5)
        let s6 = DataSeries(a6, name: "s6", maxColumnWidth: 15)
        let s7 = DataSeries(a7, name: "s7")

        var df = DataFrame()        
        df.add(s1)
        df.add(s2,s3,s4)
        df.add(s5)
        df.add(s6)
        df.add(s7)

        XCTAssert(df.count == 7)

        guard let s1_out: DataSeries<Int>    = df.get("s1"),
              let s2_out: DataSeries<Double> = df.get("s2"), 
              let s3_out: DataSeries<Double> = df.get("column_3"), 
              let s4_out: DataSeries<Double> = df.get("s4"), 
              let s5_out: DataSeries<Bool>   = df.get("column_5"), 
              let s6_out: DataSeries<String> = df.get("s6"), 
              let s7_out: DataSeries<Double> = df.get("s7") else
        {
            XCTAssert(false, "Failed to read out one or more series from the data frame")
            return
        }

        XCTAssert(s1_out.count == 14)
        XCTAssert(s2_out.count == 14)
        XCTAssert(s3_out.count == 14)
        XCTAssert(s4_out.count == 14)
        XCTAssert(s5_out.count == 14)
        XCTAssert(s6_out.count == 14)
        XCTAssert(s7_out.count == 14)
        XCTAssert(s1_out.present().index.count == a1.filter({$0 != nil}).count)
        XCTAssert(s2_out.present().index.count == a2.filter({$0 != nil}).count)
        XCTAssert(s3_out.present().index.count == a3.filter({$0 != nil}).count)
        XCTAssert(s4_out.present().index.count == a4.filter({$0 != nil}).count)
        XCTAssert(s5_out.present().index.count == a5.filter({$0 != nil}).count)
        XCTAssert(s6_out.present().index.count == a6.filter({$0 != nil}).count)
        XCTAssert(s7_out.present().index.count == a7.filter({$0 != nil}).count)

        XCTAssert(!df.isComplete)

        print("\n\nOriginal data frame:\n\(df)")

        df.fill(method: .nearlin)
        XCTAssert(df.isComplete)
        print("\n\nFilled data frame:\n\(df)")
        guard let s7_fill: DataSeries<Double> = df.get("s7") else
        {
            XCTAssert(false)
            return
        }
        let s7_exp = [12.3, 28.8, 45.3, 64.75, 84.2, 103.65, 123.1, 123.1, 123.1, 123.1, 123.1, 123.1, 123.1, 123.1]

        XCTAssert(s7_exp.enumerated().reduce(0.0, {$0 + ((s7_fill.data[$1.0] ?? -99.9)-$1.1)}) < 0.00001)
        
        print("\n\n")
    }
}
