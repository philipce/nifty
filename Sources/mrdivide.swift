/***************************************************************************************************
 *  mrdivide.swift
 *
 *  This file provides functionality for solving systems of linear equations. 
 *
 *  Author: Philip Erickson
 *  Creation Date: 20 Nov 2016
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

#if !NIFTY_XCODE_BUILD
import CLapacke
#endif

public func / (left: Matrix<Double>, right: Matrix<Double>) -> Matrix<Double>
{
    return mrdivide(left, right)
}

/// Solve the system of linear equations xA = B for x.
///
/// If A is not square then the solution will be the least-squares solution to the system.
///
/// Alternatively, `mrdivide(B, A)` can be executed with `B/A`.
///
/// - Parameters:
///     - A: matrix A in the equation Ax = B
///     - B: matrix B in the equation Ax = B
/// - Returns: matrix x in the equation Ax = B
public func mrdivide(_ B: Matrix<Double>, _ A: Matrix<Double>) -> Matrix<Double>
{
    // Note: xA = B can be re-written transpose(A)*transpose(x) = transpose(B). This second form is 
    // more conducive to solving as Ax=B is the standard form expected by LAPACK.

    // TODO: The simplest way to do this is transpose both A and B, call mldivide, and transpose
    // the answer. Surely there is a way to call into LAPACK and avoid the transposes, increasing
    // efficiency, but for now we take the simple approach as a first cut.

    // inherit name
    var newName: String? = nil
    if let nameA = A.name, let nameB = B.name
    {
        newName = "\(nameB)/\(nameA)"
    }

    let A_t = transpose(A)
    let B_t = transpose(B)
    let x_t = mldivide(A_t, B_t)
    var x = transpose(x_t)
    x.name = newName

    return x
}
