
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
        // min norm solution of underdetermined system
        let A = Matrix<Double>([[1, 2, 0], [0, 4, 3]], name: "A")
        let B = Matrix<Double>([[8], [18]], name: "B")
        let x = A-/B              
        let Ax = A*x
        print(A)
        print(B)
        print(x)
        print(Ax)
        XCTAssert(isequal(Ax, B, within: 0.1))

        // find least squares of overdetermined system
        let A2 = Matrix<Double>([[82,    64,   96],
                                 [91,    10,   97],
                                 [13,    28,   16],
                                 [92,    55,   98]], name: "A2")
        let B2 = Matrix<Double>([[96,    43],
                                 [49,    92],
                                 [81,    80],
                                 [15,    96]], name: "B2")
        let x2 = A2-/B2
        let Ax2 = A2*x2
        print(A2)
        print(B2)
        print(x2)
        print(Ax2)

        let ans = Matrix([[109.892,   57.9295],
                          [28.526,    69.9968],
                          [25.7719,   20.6471],
                          [30.6735,   112.844]])
        XCTAssert(isequal(Ax2, ans, within: 0.1), "\(Ax2) != \(ans)")        
    }
}
