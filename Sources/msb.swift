/***************************************************************************************************
 *  msb.swift
 *
 *  This file allows for determining the position of the left-most set bit in an unsigned integer.
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

/// Return the position of the left-most (most significant) 1 bit in a number.
///
/// Note: negative two's complement numbers all have the left-most bit set to 
/// 1, hence this function is only defined on unsigned numbers.
///
/// - Parameters:
///     - x: number to find msb in
/// - Returns: 1-indexed bit position (index 1 is the least significant bit)
public func msb(_ x: UInt) -> Int
{
    var v = x
    var msb = 0
    while v != 0
    {
        msb += 1
        v >>= 1
    }

    return msb
}