/***************************************************************************************************
 *  cross_test.swift
 *
 *  This file tests the cross function.
 *
 *  Author: Philip Erickson
 *  Creation Date: 22 Jan 2017
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

class cross_test: XCTestCase 
{
    #if os(Linux)
    static var allTests: [XCTestCaseEntry] 
    {
        let tests = 
        [
            testCase([("testBasic", cross_test.testBasic)]),
        ]

        return tests
    }
    #endif

    func testBasic() 
    {        
        let v1 = Vector([1.0, 345.35, 2342564.453])
        let v2 = Vector([5.6, 4.5, 4254.3])
        let x = cross(v1, v2)

        print(x)
        XCTAssert(x.data == [-0.90723175335E7, 1.31141066368E7, -0.000192946E7]) // FIXME: use compare with precision
        
    }
}
