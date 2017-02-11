
/***************************************************************************************************
 *  rand_test.swift
 *
 *  This file tests the rand function.
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

// FIXME: add back in: import Dispatch
import XCTest
@testable import Nifty

class rand_test: XCTestCase 
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
        // reseed global generator
        let r1 = rand(10, seed: 1234)
        let r2 = rand(10)
        let r3 = rand(10, seed: 1234)
        print(r1)
        print(r2)
        print(r3)
        XCTAssert(isequal(r1, r3, within: 0.1))
        XCTAssert(!isequal(r1, r2, within: 0.1))


        // thread safe - ensure each iteration pulls a unique number

        // FIXME: add back in: 
        /*
        let lock = DispatchSemaphore(value: 1)

        var nums = Set<Int>()
        let itr = 100000
        func randBlock(_ i: Int)
        {         
            let r = rand(threadSafe: true)
            lock.wait()
            nums.insert(Int(r*1000000000000))
            lock.signal()
        }
        let queue = DispatchQueue(label: "randQueue", attributes: .concurrent)
        queue.sync
        {            
            DispatchQueue.concurrentPerform(iterations: itr, execute: randBlock)
        }

        XCTAssert(nums.count == itr)
        */
    }
}
