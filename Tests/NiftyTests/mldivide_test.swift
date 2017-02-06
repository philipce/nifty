
/***************************************************************************************************
 *  mldivide_test.swift
 *
 *  This file tests the mldivide function.
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

class mldivide_test: XCTestCase 
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
        // least-squares solution of underdetermined system
        let A = Matrix<Double>([[1, 2, 0], [0, 4, 3]], name: "A")
        let B = Matrix<Double>([[8], [18]], name: "B")
        let x = A-/B              
        let Ax = A*x
        print(A)
        print(B)
        print(x)
        print(Ax)
        XCTAssert(isequal(Ax, B, within: 0.1))
    }
}
