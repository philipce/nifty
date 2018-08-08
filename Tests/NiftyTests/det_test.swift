/***************************************************************************************************
 *  det_test.swift
 *
 *  This file tests the det function.
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

class det_test: XCTestCase 
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
        let A123 = Matrix<Double>([
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
            ])
        let detA123 = det(A123)
        let answA123 = 0.0
        XCTAssert(isequal(detA123, answA123, within: 0.00001))

        let Aegerter = Matrix<Double>([
        [1, 0, 0, 0, 1],
        [0, 1, 0, 0, 2],
        [0, 0, 1, 0, 3],
        [0, 0, 0, 1, 4],
        [1, 2, 3, 4, 5]
        ])
        let detAegerter = det(Aegerter)
        let answAegerter = -25.0
        XCTAssert(isequal(detAegerter, answAegerter, within: 0.00001))

        let AntiHadamard = Matrix<Double>([
        [1, 1, 0, 1, 0],
        [0, 1, 1, 0, 1],
        [0, 0, 1, 1, 0],
        [0, 0, 0, 1, 1],
        [0, 0, 0, 0, 1]
        ])
        let detAntiHadamard = det(AntiHadamard)
        let answAntiHadamard = 1.0
        XCTAssert(isequal(detAntiHadamard, answAntiHadamard, within: 0.00001))
        
        let matlab = Matrix<Double>([
            [1, -2, 4,],
            [-5, 2, 0],
            [1, 0, 3]
            ])
        let det5 = det(matlab)
        let answ5 = -32.0
        XCTAssert(isequal(det5, answ5, within: 0.00001))
        
        let AntiSymmRandom = Matrix([
        [0.0000, -0.1096, 0.0813, 0.9248, -0.0793],
        [0.1096, 0.0000, 0.1830, 0.1502, 0.8244],
        [-0.0813, -0.1830, 0.0000, 0.0899, -0.2137],
        [-0.9248, -0.1502, -0.0899, 0.0000, -0.4804],
        [0.0793, -0.8244, 0.2137, 0.4804, 0.0000]
        ])
        let detAntiSymmRandom = det(AntiSymmRandom)
        let answAntiSymmRandom = 0.0
        XCTAssert(isequal(detAntiSymmRandom, answAntiSymmRandom, within: 0.00001))
        
        let Bab = Matrix<Double>([
            [5, 2, 0, 0, 0],
            [2, 5, 2, 0, 0],
            [0, 2, 5, 2, 0],
            [0, 0, 2, 5, 2],
            [0, 0, 0, 2, 5]
            ])
        let detBab = det(Bab)
        let answBab = 1365.0
        XCTAssert(isequal(detBab, answBab, within: 0.00001))
        
        let Bauer = Matrix<Double>([
        [-74, 80, 18, -11, -4, -8],
        [14, -69, 21, 28, 0, 7],
        [66, -72, -5, 7, 1, 4],
        [-12, 66, -30, -23, 3, -3],
        [3, 8, -7, -4, 1, 0],
        [4, -12, 4, 4, 0, 1]
        ])
        let detBauer = det(Bauer)
        let answBauer = 1.0
        XCTAssert(isequal(detBauer, answBauer, within: 0.00001))
        
        let Bernstein = Matrix<Double>([
            [-4, 6, -4, 1],
            [4, -12, 12, -4],
            [0, 6, -12, 6],
            [0, 0, 0, 1]
            ])
        let detBernstein = det(Bernstein)
        let answBernstein = -96.0
        XCTAssert(isequal(detBernstein, answBernstein, within: 0.00001))
        
        let Bodewig = Matrix<Double>([
            [2, 1, 3, 4],
            [1, -3, 1, 5],
            [3, 1, 6, -2],
            [4, 5, -2, -1]
            ])
        let detBodewig = det(Bodewig)
        let answBodewig = 568.0
        XCTAssert(isequal(detBodewig, answBodewig, within: 0.00001))
    }
}
