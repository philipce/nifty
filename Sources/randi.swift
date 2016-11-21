/***************************************************************************************************
 *  randi.swift
 *
 *  This file provides random integer functionality.
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

#if os(Linux)
import Glibc
#else
import Darwin
#endif

// FIXME: get rid of use of glibc rand! Implement random function from scratch

// TODO: make thread safe

// TODO: allow better control over range, i.e. min and max

// Counter to prevent rapid-fire calls from having same seed
fileprivate var _seed: UInt32 = UInt32(Glibc.time(nil))

/// Produces uniformly distributed random integers in the interval [0, max].
///
/// The max value, max, returned by this function must be less than RAND_MAX.
/// RAND_MAX is an integer constant representing the largest value the 
/// Glibc.rand function can return. In the GNU C Library, it is 2147483647, 
/// which is the largest signed integer representable in 32 bits. In other 
/// libraries, it may be as low as 32767.
///
/// - Parameters:
///     - size: size of the matrix to create
///     - max: the largest random integer to allow
///     - seed: (optional) seed number for random generator; default nil value 
///         uses time/counter as seed to ensure unique numbers
/// - Returns:
public func randi(_ size: [Int], max: Int, seed: Int? = nil) -> Matrix
{
    // TODO: make max default to RAND_MAX

    let totalSize = size.reduce(1, *)

    precondition(!size.isEmpty && totalSize > 0, 
        "Matrix dimensions must all be positive")

    precondition(max > 0 && Int32(max) <= Glibc.RAND_MAX, 
        "Maximum random value must be in range [1,RAND_MAX]")

    if seed == nil || seed! < 0
    {
        Glibc.srand(_seed)
        _seed += 1
    }
    else
    {
        Glibc.srand(UInt32(seed!))
    }

    let bits = msb(UInt(max))
    let mask = Int32((1 << bits)-1)
    var randomData = [Double]()
    while true
    {        
        let r32 = Glibc.rand()
        for chunkIndex in 0..<(32/bits)
        {
            let rbits = (r32 >> Int32(chunkIndex*bits)) & mask
            if rbits <= Int32(max)
            {
                randomData.append(Double(rbits))
                if randomData.count == totalSize
                {
                    return Matrix(size: [size[0], size[1]], data: randomData)
                }
            }
        }
    }
}

/// Produces a uniformly distributed random number in the interval [0, max].
///
/// The max value, max, returned by this function must be less than RAND_MAX.
/// RAND_MAX is an integer constant representing the largest value the 
/// Glibc.rand function can return. In the GNU C Library, it is 2147483647, 
/// which is the largest signed integer representable in 32 bits. In other 
/// libraries, it may be as low as 32767.
///
/// - Parameters:
///     - max: the largest random integer to allow
///     - seed: (optional) seed number for random generator; default nil value 
///         uses time/counter as seed to ensure unique numbers
/// - Returns: random number
public func randi(max: Int, seed: Int? = nil) -> Int
{
    precondition(max > 0 && Int32(max) <= Glibc.RAND_MAX, 
        "Maximum random value must be in range [1,RAND_MAX]")

    if seed == nil || seed! < 0
    {
        Glibc.srand(_seed)
        _seed += 1
    }
    else
    {
        Glibc.srand(UInt32(seed!))
    }

    let bits = msb(UInt(max))
    let mask = Int32((1 << bits)-1)
    while true
    {        
        let r32 = Glibc.rand()
        for chunkIndex in 0..<(32/bits)
        {
            let rbits = (r32 >> Int32(chunkIndex*bits)) & mask
            if rbits <= Int32(max)
            {
                return Int(rbits)
            }
        }
    }
}