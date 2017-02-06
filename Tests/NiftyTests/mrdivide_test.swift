
/***************************************************************************************************
 *  mrdivide_test.swift
 *
 *  This file tests the mrdivide function.
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

class mrdivide_test: XCTestCase 
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
        // solve system of equations that has unique solution
        let A = Matrix<Double>([[1, 1, 3], [2, 0, 4], [-1, 6, -1]])
        let B = Matrix<Double>([[2, 19, 8]])
        let x = B/A
        let ansx = Matrix([[1.0, 2.0, 3.0]])       
        XCTAssert(isequal(x, ansx), "\(x) != \(ansx)")

        // solve an underdetermined system
        print("Solving underdetermined system; expect to see rank deficient warning...")
        let C = Matrix<Double>([[1, 0], [2, 0], [1, 0]])
        let D = Matrix<Double>([[1, 2]])
        let _ = mrdivide(D, C)        
    }
}
