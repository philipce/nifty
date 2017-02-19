
/***************************************************************************************************
 *  zeros_test.swift
 *
 *  This file tests the zeros function.
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
 *  Copyright 2017 Nicolas Bertagnolli
 **************************************************************************************************/

import XCTest
@testable import Nifty

class zeros_test: XCTestCase 
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
        // Test n = m Matrix
        XCTAssert(isequal(zeros(2, 2), Matrix([[0.0, 0.0], [0.0, 0.0]]), within: 0.00001))
        
        // Test n > m  Matrix
        XCTAssert(isequal(zeros(1, 3), Matrix([[0.0, 0.0, 0.0]]), within: 0.00001))
        
        // Test n < m Matrix
        XCTAssert(isequal(zeros(4, 1), Matrix([[0.0], [0.0], [0.0], [0.0]]), within: 0.00001))
        
        // Tests Vector
        XCTAssert(isequal(zeros(4), Vector([0.0, 0.0, 0.0, 0.0]), within: 0.00001))
    }
}
