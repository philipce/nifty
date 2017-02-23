//
//  DataSeries_test.swift
//  Nifty
//
//  Created by Phil on 2/22/17.
//  Copyright © 2017 nifty-swift. All rights reserved.
//

import Foundation

/***************************************************************************************************
 *  DataSeries_test.swift
 *
 *  This file tests DataSeries.
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

class DataSeries_test: XCTestCase 
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
        // TODO: fill me in
        print("\n\t*** WARNING: Test unimplemented - \(#file)\n")
        
        // TODO: below is just functionality demo, add real tests
        
        let s1 = Series([2,3,nil], name: "s1")
        let s2 = Series([2.35,0.23,4.24], name: "s2")
        let s21 = Series([22.35,10.23,44.24])
        let s3 = Series([132.35,670.23,54.2564,687.243,73.123], name: "s3")
        let s31 = Series([true, nil,nil,nil,nil,nil,nil,nil,false], index: [3,6,9,13,14,15,18,23,30])
        let s4 = Series(["Asdfsdfwefsdf","Bdhdhgwregsgsdfg"], name: "s4", maxColumnWidth: 15)
        var s5 = Series([12.3, nil, 45.3, nil, nil, nil, 123.1], name: "s5")
        
        print(s1)
        print("")
        print("s1[3]: \(s1[3])")
        
        print(s2)
        
        print(s3)
        print("")
        print("s3[1]: \(s3[1])")
        print("s3[2]: \(s3[2])")
        print("s3[3]: \(s3[3])")
        print("s3[3.5]: \(s3[3.5])")
        print("s3[6]: \(s3[6])")
        print("s3[18]: \(s3[18])")
        print("s3[0..<4]: \(s3[0..<4])")
        print("s3[0.5...4.1]: \(s3[0.5...4.1])")
        print("s3[0.1...14.1]: \(s3[0.1...14.1])")
        print("s3[0.0...14.1]: \(s3[0.0...14.1])")
        print("s3[-2.0...3.0]: \(s3[-2.0...3.0])")
        
        
        print(s3.resample(start: 0.0, step: 0.5, n: 10, name: "resampled s3"))
        
        print(s4)
        
        print(s5)
        s5.fill()
        print(s5)
        
        print("\n\n\n\n")
        
        var df = DataFrame()
        df.add(s1)
        df.add(s2)
        df.add(s21)
        df.add(s3)
        df.add(s31)
        df.add(s4)
        df.add(s1)
        df.add(s1)
        df.add(s1)
        
        print("\n----------\nOriginal data frame:\n\(df)")
        df.fill()
        print("\n----------\nFilled data frame:\n\(df)")
        
        guard let S1: Series<Int> = df.get("s1") else {fatalError()}
        guard let S2: Series<Double> = df.get("s2") else {fatalError()}
        print(S1)
        print(S2)
        
        
    }
}
