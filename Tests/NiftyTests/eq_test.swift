
/***************************************************************************************************
 *  eq_test.swift
 *
 *  This file tests the eq function.
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

class eq_test: XCTestCase 
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
        // Test Matrix eq
        let m1 = Matrix([[1.0, 2.0, 3.0], [4.4444, 5.1, 6.0], [7.0, 8.0, -9.0]])
        let m2 = Matrix([[1.0, 2.1, -3.0], [4.4445, 5.1, 0.0], [-7.0, 18.0, -9.0]])
        let m_answer = Matrix([[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]])
        XCTAssert(isequal(eq(m1, m2), m_answer, within: 0.000001))
        
        // Test Vector eq
        let v1 = Vector([-1.0, 0.0, 1.0, 2.1, 3.5])
        let v2 = Vector([-1.0, 0.0001, 1.0, 2.1, -3.5])
        let v_answer = Vector([1.0, 0.0, 1.0, 1.0, 0.0])
        XCTAssert(isequal(eq(v1, v2), v_answer, within: 0.000001))
    }
}
