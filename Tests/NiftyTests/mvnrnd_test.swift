/***************************************************************************************************
 *  mvnrnd_test.swift
 *
 *  This file provides tests for mvnrand().
 *
 *  Author: Philip Erickson
 *  Creation Date: 17 Jan 2017
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

class mvnrnd_test: XCTestCase 
{
    static var allTests: [XCTestCaseEntry] 
    {
        let tests = 
        [
            testCase([("testBasic", self.testBasic)]),
        ]

        return tests
    }

    func testBasic() 
    {       
        // generate a single vector 
        print("\ntesting mvnrnd for single vector...")

        let mu = Vector([2.0,3.0], name: "μ")       
        let sigma = Matrix<Double>([[1,1.5],[1.5,3.0]], name: "Σ")
        let v = mvnrnd(mu: mu, sigma: sigma)

        print(mu)
        print(sigma)
        print(v)

        // generate a list of vectors
        print("\ntesting mvnrnd for many vectors...")

        let l = mvnrnd(mu: mu, sigma: sigma, cases: 5)

        for el in l { print(el) }

        // test time to generate a single high-dimensional vector
        print("\ngenerating a single large vector...")
        let itr = 10
        var times = [Double]()
        var d = 100
        for _ in 0..<itr
        {
            
            let mu = randi(d, min: 0, max: 100)

            // generate psd matrix
            let a = rand(d, d)
            let sigma = transpose(a)*a

            tic()
            let _ = mvnrnd(mu: mu, sigma: sigma)
            let t = toc(returning: .ms)
            times.append(t)
        }
        print("average time to generate 1 \(d)-dimensional vector: \(mean(times)) ms")

        // test time to generate many small vectors
        print("\ngenerating many small vectors...")
        let n = 1000
        times = []
        d = 3
        for _ in 0..<itr
        {
            let mu = randi(d, min: 0, max: 100)

            // generate psd matrix
            let a = rand(d, d)
            let sigma = transpose(a)*a

            tic()
            let _ = mvnrnd(mu: mu, sigma: sigma, cases: n)
            let t = toc(returning: .ms)
            times.append(t)
        }
        print("average time to generate \(n) \(d)-dimensional vectors: \(mean(times)) ms")

        print("\n")
    }
}