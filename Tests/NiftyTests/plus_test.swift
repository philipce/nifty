
/***************************************************************************************************
 *  plus_test.swift
 *
 *  This file tests the plus function.
 *
 *  Author: Philip Erickson
 *  Creation Date: 22 Jan 2017
 *  Contributors: Adam Duracz
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
 *  Copyright 2017 Philip Erickson, Adam Duracz
 **************************************************************************************************/

import XCTest
@testable import Nifty

class plus_test: XCTestCase 
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
        let A = Matrix([4,4], Array<Double>(repeating: 1.0, count: 16))
        for e in (A + A).data {
            XCTAssert(e == 2.0)
        }
    }
}
