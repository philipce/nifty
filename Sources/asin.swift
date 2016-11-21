/***************************************************************************************************
 *  asin.swift
 *
 *  This file provides inverse sine functionality.
 *
 *  Author: Philip Erickson
 *  Creation Date: 1 May 2016
 *  Contributors: 
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

/// Convenience wrapper to make glibc implementation available through Nifty.
///
/// Compute the arc sine of x—that is, the value whose sine is x. The value is in 
/// units of radians. Mathematically, there are infinitely many such values; the 
/// one actually returned is the one between -pi/2 and pi/2 (inclusive).
/// 
/// The arc sine function is defined mathematically only over the domain -1 to 
/// 1. If x is outside the domain, asin signals a domain error.
public let asin: (Double) -> Double = Glibc.asin

#else

import Darwin

/// Convenience wrapper to make glibc implementation available through Nifty.
///
/// Compute the arc sine of x—that is, the value whose sine is x. The value is in 
/// units of radians. Mathematically, there are infinitely many such values; the 
/// one actually returned is the one between -pi/2 and pi/2 (inclusive).
/// 
/// The arc sine function is defined mathematically only over the domain -1 to 
/// 1. If x is outside the domain, asin signals a domain error.
public let asin: (Double) -> Double = Darwin.asin

#endif