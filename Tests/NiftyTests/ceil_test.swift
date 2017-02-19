
/***************************************************************************************************
 *  ceil_test.swift
 *
 *  This file tests the ceil function.
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

class ceil_test: XCTestCase 
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
        // Test generic vector input
        let v1 = Vector([1.1, 2.0, 3.9])
        let v1_answer = Vector([2.0, 2.0, 4.0])
        XCTAssert(isequal(ceil(v1), v1_answer, within: 0.00001))
        
        // Test matrix input with negative values
        let m1 = Matrix([[1.1, 2.0], [3.9, -4.001]])
        let m1_answer = Matrix([[2.0, 2.0], [4.0, -4.0]])
        XCTAssert(isequal(ceil(m1), m1_answer, within: 0.00001))
        
        // TODO:: Test input for Tensors
    }
}
