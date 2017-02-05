
/***************************************************************************************************
 *  asinh_test.swift
 *
 *  This file tests the asinh function.
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

class asinh_test: XCTestCase 
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
        let tol = 1E-6

        let x = 0.43
        let opx = asinh(x)
        let ansx = 0.417743    
        XCTAssert(isequal(opx, ansx, within: tol), "\(opx) != \(ansx)")

        let v = Vector([0.43, 0.61, 0.13, 0.5])
        let opv = asinh(v)
        let ansv = Vector([0.417743, 0.577381, 0.129637, 0.481212])    
        XCTAssert(isequal(opv, ansv, within: tol), "\(opv) != \(ansv)")

        let m = Matrix([2,2], [0.43, 0.61, 0.13, 0.5])
        let opm = asinh(m)
        let ansm = Matrix([2,2], [0.417743, 0.577381, 0.129637, 0.481212])    
        XCTAssert(isequal(opm, ansm, within: tol), "\(opm) != \(ansm)")

        let t = Tensor([1,1,4], [0.43, 0.61, 0.13, 0.5])
        let opt = asinh(t)
        let anst = Tensor([1,1,4], [0.417743, 0.577381, 0.129637, 0.481212])    
        XCTAssert(isequal(opt, anst, within: tol), "\(opt) != \(anst)")
    }
}
