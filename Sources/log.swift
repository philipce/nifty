/***************************************************************************************************
 *  log.swift
 *
 *  This file provides natural logarithm functionality.
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

import Glibc

/// Convenience wrapper to make glibc implementation available through Nifty.
///
/// Compute the natural logarithm of x where exp(log(x)) equals x, exactly in 
/// mathematics and approximately in C.
///
/// If x is negative, log signals a domain error. If x is zero, it returns 
/// negative infinity; if x is too close to zero, it may signal overflow.
public let log: (Double) -> Double = Glibc.log