/*******************************************************************************
 *  transpose.swift
 *
 *  This file provides functionality for transposing a matrix.
 *
 *  Author: Philip Erickson
 *  Creation Date: 1 May 2016
 *  Contributors: 
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  Copyright 2016 Philip Erickson
 ******************************************************************************/

import Core

/// Compute the nonconjugate transpose of a given matrix.
///
/// - Parameters:
///     - A: matrix to transpose
/// - Returns: transposed matrix
func transpose(_ A: Matrix) -> Matrix
{
    // TODO: should be able to get constant time transpose by setting a flag in
    // Matrix to indicate how subscripts/indexes ought to be read (row-col vs
    // col-row order)

    let totalSize = size(A).reduce(1, combine: *)

    assert(!size(A).isEmpty && totalSize > 0, 
        "Matrix dimensions must all be positive")

    assert(ndims(A) <= 2, "Matrix must be 1 or 2 dimensional")

    var At = zeros([size(A, 1), size(A, 0)])

    for r in 0..<size(A, 0)
    {
        for c in 0..<size(A, 1)
        {
            At[Int(c),Int(r)] = A[Int(r),Int(c)]
        }
    }

    return At
}
