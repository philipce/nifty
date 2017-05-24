
/***************************************************************************************************
 *  max_test.swift
 *
 *  This file tests the max function.
 *
 *  Author: Félix Fischer
 *  Creation Date: 23 May 2017
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
 *  Copyright 2017 Félix Fischer
 **************************************************************************************************/

import XCTest
@testable import Nifty

class max_test: XCTestCase 
{
    #if os(Linux)
    static var allTests: [XCTestCaseEntry] 
    {
        let tests = 
        [
            testCase([("testList", self.testList)]),
            testCase([("testMatrix", self.testMatrix)]),
            testCase([("testVector", self.testVector)]),
            testCase([("testTensor", self.testTensor)]),
        ]

        return tests
    }
    #endif

    func testList() 
    {        
        let doubleList = [0.0, -1.0, 1.0, 10.0, 0.0, 5.0]

        XCTAssert(max(doubleList) == 10.0)
    }

    func testMatrix() 
    {        
        //FIXME: implement test
    }

    func testVector() 
    {        
        //FIXME: implement test
    }

    func testTensor() 
    {        
        //FIXME: implement test
    }

}
