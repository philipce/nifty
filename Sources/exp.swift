/***************************************************************************************************
 *  exp.swift
 *
 *  This file provides natural exponentiation functionality.
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
///  Compute e (the base of natural logarithms) raised to the power x.
///  
///  If the magnitude of the result is too large to be representable, exp 
///  signals overflow.
let exp: (Double) -> Double = Glibc.exp