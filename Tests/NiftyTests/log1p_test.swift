
/***************************************************************************************************
 *  log1p_test.swift
 *
 *  This file tests the log1p function.
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

class log1p_test: XCTestCase 
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
        // Test that log works for each element of the vector
        let v1 = Vector([0.0, 1.0, 2.0])
        let v1_answer = Vector([0.0, 0.693147, 1.0986122])
        XCTAssert(isequal(log1p(v1), v1_answer, within: 0.0001))
        
        // Test that log works for each element of the matrix
        let m1 = Matrix([[0.0, 1.0], [2.0, 3.0]])
        let m1_answer = Matrix([[0.0, 0.693147], [1.0986122, 1.386294]])
        XCTAssert(isequal(log1p(m1), m1_answer, within: 0.0001))
        
        // Test that log works for each element of the tensor
        let m = Matrix(2,3, [0.0, 1.0, 2.0, 0.0, 1.0, 2.0])
        let m_answer = Matrix(2,3, [0.0, 0.693147, 1.0986122, 0.0, 0.693147, 1.0986122])
        let tm = log1p(Tensor(m))
        XCTAssert(isequal(m_answer, Matrix<Double>(2,3, tm.data), within: 0.0001))
    }
}
