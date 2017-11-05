/***************************************************************************************************
 *  rand.swift
 *
 *  This file provides random decimal number functionality.
 *
 *  Author: Philip Erickson
 *  Creation Date: 1 May 2016
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

import Dispatch
import Foundation

/// Return a matrix of random real numbers in the specified range.
///
/// - Note: If large amounts of random numbers are needed, it's more efficient to request one large 
///    matrix rather than many individual numbers.
/// - Note: Generated numbers are limited to a maximum magnitude of 2^53-1; this ensures that they
///    can be stored as Doubles without loss of precision.
/// - Parameters:
///    - rows: number of rows in matrix to generate
///    - columns: number of columns in matrix to generate
///    - min: optionally specify minimum integer value to return, inclusive
///    - max: optionally specify maximum integer value to return, inclusive
///    - seed: optionally provide specific seed for generator. If threadSafe is set, this seed will
///        not be applied to global generator.
///    - threadSafe: if set to true, a new random generator instance will be created that will be 
///        be used and exist only for the duration of this call. Otherwise, global instance is used.
public func rand(_ rows: Int, _ columns: Int, min: Double = 0.0, max: Double = 1.0, 
    seed: UInt64? = nil, threadSafe: Bool = false) -> Matrix<Double>
{
    let totalSize = rows * columns

    precondition(rows > 0 && columns > 0, "Matrix dimensions must all be positive")
    precondition(max < 9007199254740992.0 && max > -9007199254740992.0, "|Max| must be below 2^53")
    precondition(min < 9007199254740992.0 && min > -9007199254740992.0, "|Min| must be below 2^53")
    precondition(max > min, "Max must be greater than min")    

    let range = max-min

    // If not set to be thread safe, save time and use global generator. Otherwise, make new one.
    var curRandGen: UniformRandomGenerator
    if !threadSafe
    {
        // create or reseed global generator with given seed
        if let s = seed
        {
            curRandGen = UniformRandomGenerator(seed: s)
            g_UniformRandGen = curRandGen
        }
        // just use the current global generator if there is one
        else if let gen = g_UniformRandGen
        {
            curRandGen = gen          
        }
        // initialize global generator with default seed
        else
        {
            // Seed random number generator with all significant digits in current time.
            curRandGen = UniformRandomGenerator(seed: UInt64(Date().timeIntervalSince1970*1000000))
            g_UniformRandGen = curRandGen
        }
    }
    else
    {
        if let ts = seed
        {
            curRandGen = UniformRandomGenerator(seed: ts)
        }
        else
        {
            // ensure that each thread gets a differently seeded generator
            threadLock.wait()
            let ts = threadSeed
            threadSeed = threadSeed.addingReportingOverflow(UInt64(Date().timeIntervalSince1970)).0
            threadLock.signal()
            curRandGen = UniformRandomGenerator(seed: ts) 
        }
    }

    // Grab random doubles until we've got enough in range
    var randomData = [Double]()
    while true
    {        
        let r = curRandGen.doub()

        // scale and shift value to range [min, max]
        let scaledShiftedValue = r * range + min
        randomData.append(scaledShiftedValue)
        if randomData.count == totalSize
        {
            return Matrix(rows, columns, randomData)
        }
    }
}

public func rand(_ elements: Int, min: Double = 0.0, max: Double = 1.0, seed: UInt64? = nil, 
    threadSafe: Bool = false) -> Vector<Double>
{
    let m = rand(1, elements, min: min, max: max, seed: seed, threadSafe: threadSafe)
    return Vector(m)
}

public func rand(min: Double = 0.0, max: Double = 1.0, seed: UInt64? = nil, 
    threadSafe: Bool = false) -> Double
{
    let m = rand(1, 1, min: min, max: max, seed: seed, threadSafe: threadSafe)
    return m.data[0]
}

// Use this to atomically check and increment seed for thread-safe calls
fileprivate var threadLock = DispatchSemaphore(value: 1)
fileprivate var threadSeed = UInt64(Date().timeIntervalSince1970*2000000)
