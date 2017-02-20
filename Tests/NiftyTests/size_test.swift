
/***************************************************************************************************
 *  size_test.swift
 *
 *  This file tests the size function.
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

class size_test: XCTestCase 
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
        // Test size of nxn matrix without dim argument
        XCTAssert(size(Matrix([[1.0, 2.0], [3.0, 4.0]])) == [2, 2])
        
        // Test size of n > m matrix without dim argument
        XCTAssert(size(Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])) == [3, 2])
        
        // Test size of n < m matrix without dim argument
        XCTAssert(size(Matrix([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])) == [2, 3])
        
        // Test size of nxn matrix with dim argument
        XCTAssert(size(Matrix([[1.0, 2.0], [3.0, 4.0]]), 0) == 2)
        
        // Test size of n > m matrix with dim argument
        XCTAssert(size(Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]]), 0) == 3)
        
        // Test size of n < m matrix with dim argument
        XCTAssert(size(Matrix([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]), 1) == 3)
        
    }
}
