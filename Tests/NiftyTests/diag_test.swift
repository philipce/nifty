/***************************************************************************************************
 *  diag_test.swift
 *
 *  This file tests the diag function.
 *
 *  Author: Tor Rafsol Løseth
 *  Creation Date: 07 Jul 2018
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
 *  Copyright 2018 Tor Rafsol Løseth
 **************************************************************************************************/

import XCTest
@testable import Nifty

class diag_test: XCTestCase
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
        let v1 = Vector<Double>([1])
        let v2 = Vector<Double>([1, 2])
        let v5 = Vector<Double>([1, 2, 3, 4, 5])
        
        let diag1 = diag(v: v1)
        let answ1 = Matrix<Double>([[1]])
        XCTAssert(isequal(diag1, answ1, within: 0.00001))
        
        let diag2 = diag(v: v2)
        let answ2 = Matrix<Double>([[1, 0],[0, 2]])
        XCTAssert(isequal(diag2, answ2, within: 0.00001))
        
        let diag5 = diag(v: v5)
        let answ5 = Matrix<Double>([
            [1, 0, 0, 0, 0],
            [0, 2, 0, 0, 0],
            [0, 0, 3, 0, 0],
            [0, 0, 0, 4, 0],
            [0, 0, 0, 0, 5]
            ])
        XCTAssert(isequal(diag5, answ5, within: 0.00001))
        
        let diag1k = diag(v: v1, k: 0)
        let answ1k = Matrix<Double>([[1]])
        XCTAssert(isequal(diag1k, answ1k, within: 0.00001))
        
        let diag2k = diag(v: v1, k: -2)
        let answ2k = Matrix<Double>([
            [0, 0, 0],
            [0, 0, 0],
            [1, 0, 0]
            ])
        XCTAssert(isequal(diag2k, answ2k, within: 0.00001))
        
        let diag3k = diag(v: v1, k: 2)
        let answ3k = Matrix<Double>([
            [0, 0, 1],
            [0, 0, 0],
            [0, 0, 0]
            ])
        XCTAssert(isequal(diag3k, answ3k, within: 0.00001))
        
        let diag4k = diag(v: v2, k: 2)
        let answ4k = Matrix<Double>([
            [0, 0, 1, 0],
            [0, 0, 0, 2],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
            ])
        XCTAssert(isequal(diag4k, answ4k, within: 0.00001))
        
        let diag5k = diag(v: v5, k: -2)
        let answ5k = Matrix<Double>([
            [0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0],
            [1, 0, 0, 0, 0, 0, 0],
            [0, 2, 0, 0, 0, 0, 0],
            [0, 0, 3, 0, 0, 0, 0],
            [0, 0, 0, 4, 0, 0, 0],
            [0, 0, 0, 0, 5, 0, 0],
            ])
        XCTAssert(isequal(diag5k, answ5k, within: 0.00001))
        
        
        
        let m1 = Matrix<Double>([[1]])
        let m2 = Matrix<Double>([[1, 2], [3, 4]])
        let m4 = Matrix<Double>([
            [1, -2, 3, 1],
            [-2, 1, -2, -1],
            [3, -2, 1, 5],
            [1, -1, 5, 3]
            ])
        
        let diag6 = diag(A: m1)
        let answ6 = Vector<Double>([1])
        XCTAssert(isequal(diag6, answ6, within: 0.00001))
        
        let diag7 = diag(A: m2)
        let answ7 = Vector<Double>([1, 4])
        XCTAssert(isequal(diag7, answ7, within: 0.00001))
        
        let diag8 = diag(A: m4)
        let answ8 = Vector<Double>([1, 1, 1, 3])
        XCTAssert(isequal(diag8, answ8, within: 0.00001))

        let diag9k = diag(A: m2, k: 0)
        let answ9k = Vector<Double>([1, 4])
        XCTAssert(isequal(diag9k, answ9k, within: 0.00001))

        let diag10k = diag(A: m2, k: 1)
        let answ10k = Vector<Double>([2])
        XCTAssert(isequal(diag10k, answ10k, within: 0.00001))

        let diag11k = diag(A: m4, k: -2)
        let answ11k = Vector<Double>([3, -1])
        XCTAssert(isequal(diag11k, answ11k, within: 0.00001))

        let diag12k = diag(A: m4, k: 0)
        let answ12k = Vector<Double>([1, 1, 1, 3])
        XCTAssert(isequal(diag12k, answ12k, within: 0.00001))

        let diag13k = diag(A: m4, k: 3)
        let answ13k = Vector<Double>([1])
        XCTAssert(isequal(diag13k, answ13k, within: 0.00001))
        
        let diag14k = diag(A: m4, k: -3)
        let answ14k = Vector<Double>([1])
        XCTAssert(isequal(diag14k, answ14k, within: 0.00001))
    }
}
