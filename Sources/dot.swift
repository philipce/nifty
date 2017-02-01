/**************************************************************************************************
 *  dot.swift
 *
 *  This file defines vector dot product functionality. 
 *
 *  Author: Philip Erickson
 *  Creation Date: 29 Dec 2016
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

#if NIFTY_XCODE_BUILD
import Accelerate
#else
import CBlas
#endif

public func * (left: Vector<Double>, right: Vector<Double>) -> Double { return dot(left, right) }

/// Compute the dot product of two vectors.
///
/// - Parameters:
///    - a: first vector
///    - b: second vector
/// - Returns: dot product of given vectors
public func dot(_ a: Vector<Double>, _ b: Vector<Double>) -> Double
{
    precondition(a.count == b.count, "Dot product requires vectors of equal length")

    return cblas_ddot(Int32(a.count), a.data, 1, b.data, 1)
}
