
/***************************************************************************************************
 *  mean_test.swift
 *
 *  This file tests the mean function.
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

class mean_test: XCTestCase 
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
        // Test Vector mean for constant input
        XCTAssert(mean(Vector([1.0, 1.0, 1.0])) == 1.0)
        // Test Vector mean for varying positive
        XCTAssert(mean(Vector([1.0, 2.0, 3.0])) == 2.0)
        
        // Test Matrix mean for square matrix
        let m1 = Matrix([[1.0, 2.0], [3.0, 4.0]])
        XCTAssert(isequal(mean(m1), Matrix([[1.5, 3.5]]), within: 0.0001))  // Across columns
        XCTAssert(isequal(mean(m1, dim: 1), Matrix([[2.0, 3.0]]), within: 0.0001))  // Across rows
        
        // Test Matrix mean for n > m matrix
        let m2 = Matrix([[1.0, 2.0], [4.0, 5.0], [6.0, 7.0]])
        XCTAssert(isequal(mean(m2), Matrix([[1.5, 4.5, 6.5]]), within: 0.0001))  // Across columns
        XCTAssert(isequal(mean(m2, dim: 1), Matrix([[3.666666, 4.666666]]), within: 0.0001))  // Across rows
        
        // Test Matrix mean for n < m matrix
        let m3 = Matrix([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
        XCTAssert(isequal(mean(m3), Matrix([[2.0, 5.0]]), within: 0.0001))  // Across columns
        XCTAssert(isequal(mean(m3, dim: 1), Matrix([[2.5, 3.5, 4.5]]), within: 0.0001))  // Across rows
        

    }
}
