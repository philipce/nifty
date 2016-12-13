/***************************************************************************************************
 *  randn.swift
 *
 *  This file provides normal random number functionality.
 *
 *  Author: Philip Erickson
 *  Creation Date: 11 Dec 2016
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
 *  Copyright 2016 Philip Erickson
 **************************************************************************************************/

/// Internal structure for generating normal random numbers. Makes use of UniformRandomGenerator in
/// computing normal deviates
///
/// Algorithm based on:
/// Press, William H. "Numerical recipes 3rd edition: The art of scientific computing.", Cambridge 
/// university press, 2007. Chapter 7.3.9, pg 368-369.
internal class NormalRandomGenerator
{
    var mu: Double
    var sigma: Double
    var ugen: UniformRandomGenerator

    init(mu: Double, sigma: Double, ugen: UniformRandomGenerator)
    {
        self.mu = mu
        self.sigma = sigma
        self.ugen = ugen
    }

    func doub() -> Double
    {
        var u, v, x, y, q: Double
        repeat
        {
            u = self.ugen.doub()
            v = 1.7156 * (self.ugen.doub() - 0.5)
            x = u - 0.449871
            y = abs(v) + 0.386595
            q = x*x + y*(0.196*y - 0.25472*x)
        }
        while (q > 0.27597) && (q > 0.27846 || (v*v > -4.0*log(u)*u*u))

        return self.mu + self.sigma*v/u
    }
}

// Global random number generator instance used for generation of uniform randoms, unless function
// is called with the `threadSafe` option set.
internal var g_NormalRandGen: NormalRandomGenerator? = nil

//==================================================================================================
// MARK: PUBLIC RANDN INTERFACE
//==================================================================================================

import Foundation

/// Return a matrix of random numbers drawn from the specified normal distribution.
///
/// - Note: If large amounts of random numbers are needed, it's more efficient to request one large 
///    matrix rather than many individual numbers.
/// - Parameters:
///    - size: size of random matrix to generate
///    - mean: optionally specify a mean other than the default zero mean
///    - std: optionally specify standard deviation other than the default unit
///    - seed: optionally provide specific seed for generator. If threadSafe is set, this seed will
///        not be applied to global generator, but to the temporary generator instance
///    - threadSafe: if set to true, a new random generator instance will be created that will be 
///        be used and exist only for the duration of this call. Otherwise, global instance is used.
public func randn(_ size: [Int], mean: Double = 0.0, std: Double = 1.0, seed: UInt64? = nil, 
    threadSafe: Bool = false) -> Matrix
{
    let totalSize = size.reduce(1, *)

    precondition(!size.isEmpty && totalSize > 0, "Matrix dimensions must all be positive")
    precondition(std >= 0, "Standard deviation cannot be negative")

    // If not set to be thread safe, save time and use global generator. Otherwise, make new one.
    var curRandGen: NormalRandomGenerator
    if !threadSafe
    {
        // create or reseed global generator with given seed
        if let s = seed
        {
            let urg = UniformRandomGenerator(seed: s)
            curRandGen = NormalRandomGenerator(mu: mean, sigma: std, ugen: urg)
            g_UniformRandGen = urg
            g_NormalRandGen = curRandGen
        }
        // just use the current global generator if there is one, adjusting mean and std
        else if let gen = g_NormalRandGen
        {
            curRandGen = gen          
            curRandGen.mu = mean
            curRandGen.sigma = std
        }
        // initialize global generator with default seed
        else
        {
            // Seed random number generator with all significant digits in current time.
            let urg = UniformRandomGenerator(seed: UInt64(Date().timeIntervalSince1970*10000))
            curRandGen = NormalRandomGenerator(mu: mean, sigma: std, ugen: urg)
            g_UniformRandGen = urg 
            g_NormalRandGen = curRandGen
        }
    }
    else
    {
        // TODO: Foundation currently doesn't provide a way for getting thread ID. As a temporary 
        // substitue, use the hash of the current thread object representation (I believe the 
        // address in the thread description is unique to each thread) as a seed, if one wasn't 
        // given, to ensure different random numbers between threads. Add the time (times 10000 so 
        // all significant digits are in integer) so the same thread seeds differently on each call.
        let ts = UInt64(abs("\(Thread.current)".hash)) + UInt64(Date().timeIntervalSince1970*10000)
        let urg = UniformRandomGenerator(seed: seed ?? ts)
        curRandGen = NormalRandomGenerator(mu: mean, sigma: std, ugen: urg)
    }

    // Grab as many normally distributed doubles as needed
    var randomData = [Double]()
    for _ in 0..<totalSize
    {        
        randomData.append(curRandGen.doub())
    }

    return Matrix(size, data: randomData)
}

public func randn(_ rows: Int, _ columns: Int, mean: Double = 0.0, std: Double = 1.0, seed: UInt64? = nil, 
    threadSafe: Bool = false) -> Matrix
{
    return randn([rows, columns], mean: mean, std: std, seed: seed, threadSafe: threadSafe)
}

public func randn(mean: Double = 0.0, std: Double = 1.0, seed: UInt64? = nil, 
    threadSafe: Bool = false) -> Double
{
    let m = randn([1], mean: mean, std: std, seed: seed, threadSafe: threadSafe)
    return m.data[0]
}