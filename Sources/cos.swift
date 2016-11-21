/***************************************************************************************************
 *  cos.swift
 *
 *  This file provides cosine functionality.
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

/// Convenience wrapper to make glibc implementation available through Nifty.
///
/// Return the cosine of x, where x is given in radians and the return value is 
/// in the range -1 to 1.
public let cos: (Double) -> Double = Glibc.cos

#else

import Darwin

/// Convenience wrapper to make glibc implementation available through Nifty.
///
/// Return the cosine of x, where x is given in radians and the return value is 
/// in the range -1 to 1.
public let cos: (Double) -> Double = Darwin.cos

#endif