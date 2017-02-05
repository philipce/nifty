
/***************************************************************************************************
 *  tanh_test.swift
 *
 *  This file tests the tanh function.
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

class tanh_test: XCTestCase 
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
        let tol = 1E-4

        let vals : [Double] = [0.43, 0.61, 0.13, 0.5]
        let ans  : [Double] = [0.4053, 0.5441, 0.1293, 0.4621]

        let x = vals[0]
        let opx = tanh(x)
        let ansx = ans[0]
        XCTAssert(isequal(opx, ansx, within: tol), "\(opx) != \(ansx)")        

        let v = Vector(vals)
        let opv = tanh(v)
        let ansv = Vector(ans)    
        XCTAssert(isequal(opv, ansv, within: tol), "\(opv) != \(ansv)")

        let m = Matrix([2,2], vals)
        let opm = tanh(m)
        let ansm = Matrix([2,2], ans)    
        XCTAssert(isequal(opm, ansm, within: tol), "\(opm) != \(ansm)")

        let t = Tensor([1,1,4], vals)
        let opt = tanh(t)
        let anst = Tensor([1,1,4], ans)    
        XCTAssert(isequal(opt, anst, within: tol), "\(opt) != \(anst)")
    }
}
