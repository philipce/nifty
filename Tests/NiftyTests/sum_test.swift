
/***************************************************************************************************
 *  sum_test.swift
 *
 *  This file tests the sum function.
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

class sum_test: XCTestCase 
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
        // List sums
        let l1 = [1,2,3]        
        let l2 = [5.5,1.5,2.0]
        XCTAssert(sum(l1) == 6)
        XCTAssert(sum(l2) == 9.0)

        // Vector sums
        let v1 = Vector(l1)
        let v2 = Vector(l2)
        XCTAssert(sum(v1) == 6)
        XCTAssert(sum(v2) == 9.0)        

        // Matrix sums
        let A = Matrix<Double>([[3,7,3,6,5],[8,34,1,4,56],[8,46,0,23,4]])
        let Ai = Matrix([[3,7,3,6,5],[8,34,1,4,56],[8,46,0,23,4]])
        let rsum = sum(A, dim: 0)        
        let csum = sum(A, dim: 1)
        XCTAssert(sum(A) == 208.0)
        XCTAssert(sum(Ai) == 208)
        XCTAssert(rsum.size == [1,5] && rsum.data == [19,87,4,33,65])
        XCTAssert(csum.size == [3,1] && csum.data == [24,103,81])
        
        // Tensor sums
        let T = Tensor([2,3,4,2], value: 1.0)
        let Ti = Tensor([2,3,4,2], value: 1)        
        let sum0 = sum(T, dim: 0)
        let sum1 = sum(T, dim: 1)
        let sum2 = sum(T, dim: 2)
        let sum3 = sum(T, dim: 3)
        XCTAssert(sum(T) == 2.0*3.0*4.0*2.0)
        XCTAssert(sum(Ti) == 2*3*4*2)
        XCTAssert(sum0.size == [1,3,4,2] && sum(sum0) == 2.0*3.0*4.0*2.0)
        XCTAssert(sum1.size == [2,1,4,2] && sum(sum1) == 2.0*3.0*4.0*2.0)
        XCTAssert(sum2.size == [2,3,1,2] && sum(sum2) == 2.0*3.0*4.0*2.0)
        XCTAssert(sum3.size == [2,3,4,1] && sum(sum3) == 2.0*3.0*4.0*2.0)
    }
}
