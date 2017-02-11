/***************************************************************************************************
 *  pow.swift
 *
 *  This file provides general exponentiation functionality.
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

/// General exponentiation function, returning base raised to power.
///
/// Mathematically, pow would return a complex number when base is negative and 
/// power is not an integral value. pow can’t do that, so instead it signals a 
/// domain error. May also underflow or overflow the destination type.

#if os(Linux)
@_exported import func Glibc.pow
#else
@_exported import func Darwin.pow
#endif

// TODO: verify this precedence
infix operator ** : ExponentiationPrecedence
precedencegroup ExponentiationPrecedence
{ 
    associativity: left
    higherThan: MultiplicationPrecedence
}

/// Raise a double to a double power.
public func ** (left: Double, right: Double) -> Double 
{ 
    return pow(left, right) 
}

/// Raise a double to an integer power.
public func ** (left: Double, right: Int) -> Double
{
    return pow(left, Double(right))
}

/// Raise an integer to a double power.
public func ** (left: Int, right: Double) -> Double
{
    return pow(Double(left), right)
}

/// Raise an integer to an integer power
public func ** (left: Int, right: Int) -> Int
{
    return Int(pow(Double(left), Double(right)))
}

