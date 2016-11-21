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

#if os(Linux)
import Glibc
#else
import Darwin
#endif

// FIXME: Glibc random is not very good. It's fine for a first cut, but we should just implement our 
// own random number generator.

// TODO: this is not safe for multi threading as it uses drand48 instead of
// drand48_r; change implementation to use drand48_r if needed.

fileprivate var _seed: Int = Glibc.time(nil)

/// Produces uniformly distributed random numbers in the interval [0.0,1.0).
///
/// - Parameters:
///     - size: size of the array to create
///     - seed: (optional) seed number for random generator; default nil value 
///         uses time/counter as seed to ensure unique numbers
/// - Returns: matrix of random decimal numbers
public func rand(_ size: [Int], seed: Int? = nil) -> Matrix
{    
    let totalSize = size.reduce(1, *)

    precondition(!size.isEmpty && totalSize > 0, "Matrix dimensions must all be positive")

    if seed == nil || seed! < 0
    {
        Glibc.srand48(_seed) 
        _seed += 1
    }
    else
    {
        Glibc.srand48(seed!)
    }    

    var randomData = [Double]()
    for _ in 0..<totalSize
    {
        randomData.append(Glibc.drand48())
    }

    return Matrix(size: size, data: randomData)
}

/// Produces a square matrix of uniformly distributed random numbers in the interval [0.0,1.0).
///
/// - Parameters:
///     - side: length of side of the square matrix to create
///     - seed: (optional) seed number for random generator; default nil value 
///         uses time/counter as seed to ensure unique numbers
/// - Returns: matrix of random decimal numbers
public func rand(_ side: Int, seed: Int? = nil) -> Matrix
{
    return rand([side, side], seed: seed)
}

/// Produces a uniformly distributed random number in the interval [0.0,1.0).
///
/// TODO: this is not safe for multi threading as it uses drand48 instead of
/// drand48_r; change implementation to use drand48_r if needed.
///
/// - Parameters:
///     - seed: (optional) seed number for random generator; default nil value 
///         uses time/counter as seed to ensure unique numbers
/// - Returns: random decimal number
public func rand(seed: Int? = nil) -> Double
{
    if seed == nil || seed! < 0
    {
        Glibc.srand48(_seed)
        _seed += 1
    }
    else
    {
        Glibc.srand48(seed!)
    }
    
    return Glibc.drand48()
}