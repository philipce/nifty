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

<<<<<<< HEAD
/// Internal structure for generating uniform random numbers. Random number generation throughout 
/// Nifty should use this object as a base.
///
/// Algorithm based on:
/// Press, William H. "Numerical recipes 3rd edition: The art of scientific computing.", Cambridge 
/// university press, 2007. Chapter 7.1, pg 342-343.
public class UniformRandomGenerator
{
    var u: UInt64
    var v: UInt64
    var w: UInt64

    init(seed j: UInt64)
    {
        self.v = 4101842887655102017
        self.w = 1
        self.u = j ^ self.v
        let _ = self.uint64()
        self.v = self.u
        let _ = self.uint64()
        self.w = self.v
        let _ = self.uint64()
    }
=======
#if os(Linux)
import Glibc
fileprivate let _rand: () -> Int32 = Glibc.rand
fileprivate let _srand: (UInt32) -> Void = Glibc.srand
fileprivate let _time: (UnsafeMutablePointer<time_t>!) -> time_t = Glibc.time
fileprivate let _RAND_MAX: Int32 = Glibc.RAND_MAX
#else
import Darwin
fileprivate let _rand: () -> UInt32 = Darwin.arc4random // Note: rand is unavailable on Mac
fileprivate let _srand: (UInt32) -> Void = { _ in} // FIXME: arc4random doesn't have a seed so this does nothing! 
fileprivate let _time: (UnsafeMutablePointer<time_t>!) -> time_t = Darwin.time
fileprivate let _RAND_MAX: Int32 = Darwin.RAND_MAX
#endif
>>>>>>> bfd1bccbd8982391e7a2dba8f4c560d1fd12c532

    func uint64() -> UInt64
    {
        self.u = UInt64.addWithOverflow(UInt64.multiplyWithOverflow(self.u, 2862933555777941757).0, 
            7046029254386353087).0
        self.v ^= self.v >> 17
        self.v ^= self.v << 31
        self.v ^= self.v >> 8
        let w_temp = UInt64.multiplyWithOverflow(4294957665, (self.w & 0xffffffff)).0
        self.w = UInt64.addWithOverflow(w_temp, self.w >> 32).0
        var x: UInt64 = self.u ^ (self.u << 21) 
        x ^= x >> 35
        x ^= x << 4
        let retVal = UInt64.addWithOverflow(x, self.v).0 ^ self.w

        return retVal
    }

    func uint32() -> UInt32
    {
        return UInt32(self.uint64() >> 32)
    }

<<<<<<< HEAD
    func doub() -> Double
    {
        // TODO: Revist and test the need to use only 53 bits. Is it really necessary?
        // Integers up to 2^53-1 can be stored in double without loss of precision. Beyond that, 
        // precision may be lost, which would mean multiple UInt64s may map to same double, throwing
        // off uniformity. Use only 53 bits of UInt64 to prevent this and multiply by 1/(2^53-1)
=======
// Counter to prevent rapid-fire calls from having same seed
fileprivate var _seed: UInt32 = UInt32(_time(nil))
>>>>>>> bfd1bccbd8982391e7a2dba8f4c560d1fd12c532

        return 1.110223024625156786942664549657E-16  * Double(self.uint64() >> 11)
    }
}

//==================================================================================================
// MARK: PUBLIC RANDI INTERFACE
//==================================================================================================

import Foundation

// Global random number generator instance used for generation of uniform randoms, unless function
// is called with the `threadSafe` option set.
var g_UniformRandGen: UniformRandomGenerator? = nil

/// Return a matrix of random integers in the specified range.
///
/// - Note: If large amounts of random numbers are needed, it's more efficient to request one large 
///    matrix rather than many individual numbers.
/// - Note: Generated numbers are limited to a maximum magnitude of 2^53-1; this ensures that they
///    can be stored as Doubles without loss of precision. Furthemore, the most negative number that 
///    can be generated is Int.min+1, not Int.min; this is so the range `min-max` can be computed 
///    without overflow.
/// - Parameters:
///    - size: size of random matrix to generate
///    - min: optionally specify minimum integer value to return, inclusive
///    - max: optionally specify maximum integer value to return, inclusive
///    - seed: optionally provide specific seed for generator. If threadSafe is set, this seed will
///        not be applied to global generator.
///    - threadSafe: if set to true, a new random generator instance will be created that will be 
///        be used and exist only for the duration of this call. Otherwise, global instance is used.
public func randi(_ size: [Int], min: Int = 0, max: Int = Int(Int16.max), seed: UInt64? = nil, 
    threadSafe: Bool = false) -> Matrix
{
    let totalSize = size.reduce(1, *)

    precondition(!size.isEmpty && totalSize > 0, "Matrix dimensions must all be positive")
    precondition(max < 9007199254740992 && max > -9007199254740992, "|Max| must be below 2^53")
    precondition(min < 9007199254740992 && min > -9007199254740992, "|Min| must be below 2^53")
    precondition(max > min, "Max must be greater than min")    

<<<<<<< HEAD
    // Note: The weirdness below in computing the range is to deal with potential overflow.
    //
    // For one, if max = Int.max and min < 0, then max-min is too large to fit in an Int; so we need
    // to cast each term to unsigned first.
    //
    // Secondly, if min is Int.min, then abs(min) will overflow. Currently can't find a way to make 
    // swift return the result of abs(min) as a UInt rather than an Int. The current resolution is
    // to make Int.min+1 as the lowest possible min. If we come up with a way to allow Int.min, then 
    // then make sure to change the note in the function header.
    let range: UInt
    if max >= 0 && min < 0
    {
        range = UInt(max) + UInt(abs(min))
    }
    else
    {
        range = UInt(max - min)
    } 

    // If not set to be thread safe, save time and use global generator. Otherwise, make new one.
    var curRandGen: UniformRandomGenerator
    if !threadSafe
    {
        if let gen = g_UniformRandGen
=======
    precondition(max > 0 && Int32(max) <= _RAND_MAX, 
        "Maximum random value must be in range [1,RAND_MAX]")

    if seed == nil || seed! < 0
    {
        _srand(_seed)
        _seed += 1
    }
    else
    {
        _srand(UInt32(seed!))
    }

    let bits = msb(UInt(max))
    let mask = Int32((1 << bits)-1)
    var randomData = [Double]()
    while true
    {        
        let r32 = Int32(_rand())
        for chunkIndex in 0..<(32/bits)
>>>>>>> bfd1bccbd8982391e7a2dba8f4c560d1fd12c532
        {
            curRandGen = gen          
        }
        // initialize global generator if needed
        else
        {
            // Seed random number generator with all significant digits in current time.
            curRandGen = UniformRandomGenerator(seed: seed ?? 
                UInt64(Date().timeIntervalSince1970*10000))
            g_UniformRandGen = curRandGen
        }
    }
<<<<<<< HEAD
    else
    {
        // TODO: Foundation currently doesn't provide a way for getting thread ID. As a temporary 
        // substitue, use the hash of the current thread object representation (I believe the 
        // address in the thread description is unique to each thread) as a seed, if one wasn't 
        // given, to ensure different random numbers between threads. Add the time (times 10000 so 
        // all significant digits are in integer) so the same thread seeds differently on each call.
        let ts = UInt64(abs("\(Thread.current)".hash)) + UInt64(Date().timeIntervalSince1970*10000)
        curRandGen = UniformRandomGenerator(seed: seed ?? ts)
    }
=======
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
    precondition(max > 0 && Int32(max) <= _RAND_MAX, 
        "Maximum random value must be in range [1,RAND_MAX]")
>>>>>>> bfd1bccbd8982391e7a2dba8f4c560d1fd12c532

    // Create mask that will select the right-most number of bits we need to represent the random 
    // number out of a 64 bit number. For example, a random number in the range 0-3 needs 2 bits,
    // so if mask=0x11, `uint64 & mask` would select just the random 2 bits we need from the 64. We
    // could right shift uint64 by 2 and repeat, using all 64 bits to get 32 random numbers in 0-3.
    let bits = UInt64(msb(range))
    let mask: UInt64
    if bits == 64 
    {
<<<<<<< HEAD
        mask = UInt64.max
    }
    else
    {
        mask = (UInt64(1) << bits)-1   
=======
        _srand(_seed)
        _seed += 1
    }
    else
    {
        _srand(UInt32(seed!))
>>>>>>> bfd1bccbd8982391e7a2dba8f4c560d1fd12c532
    }

    // Grab 64 random bits at a time, breaking it down into as many chunks of the needed size as 
    // possible to avoid wasting bits.
    var randomData = [Double]()
    while true
    {        
<<<<<<< HEAD
        let r64 = curRandGen.uint64()
        for chunkIndex in 0..<(64/bits)
=======
        let r32 = Int32(_rand())
        for chunkIndex in 0..<(32/bits)
>>>>>>> bfd1bccbd8982391e7a2dba8f4c560d1fd12c532
        {
            let bitChunk = (r64 >> UInt64(chunkIndex*bits)) & mask

            // only accept generated chunks in the range [0, range]
            if bitChunk <= UInt64(range) 
            {
                // shift value to range [min, max]
                let shiftedValue = Double(Int(bitChunk)+min) 
                randomData.append(shiftedValue)
                if randomData.count == totalSize
                {
                    return Matrix(size: size, data: randomData)
                }
            }
        }
    }
}

public func randi(min: Int = Int.min, max: Int = Int.max, seed: UInt64? = nil, 
    threadSafe: Bool = false) -> Int
{
    let m = randi([1], min: min, max: max, seed: seed, threadSafe: threadSafe)
    return Int(m.data[0])
}