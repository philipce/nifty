
/***************************************************************************************************
 *  trace_test.swift
 *
 *  This file tests the trace function.
 *
 *  Author: Nicolas Bertagnolli
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
 *  Copyright 2017 Nicolas Bertagnolli
 **************************************************************************************************/

import XCTest
@testable import Nifty

class trace_test: XCTestCase 
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
        // Test Matrix Trace with positive elements on off diagonal elements
        XCTAssert(isequal(trace(Matrix([[0.0, 1.1], [1.0, 0.0]])), 0.0, within: 0.00001))
        
        // Test Matrix Trace with negative values on 3x3 Matrix
        XCTAssert(isequal(trace(Matrix([[1.0, 0.0, 1.0], [1.0, -3.0, 2.0], [0.0, 0.0, 1.0]])), -1.0, within: 0.00001))
        
        // Test Matrix Trace with all positive values 2x2
        XCTAssert(isequal(trace(Matrix([[1.0, 2.0], [3.0, 4.0]])), 5.0, within: 0.00001))
    }
}
