/***************************************************************************************************
 *  norm.swift
 *
 *  This file provides vector, matrix, and tensor norm functionality.
 *
 *  Author: Adam Duracz
 *  Creation Date: 30 Jan 2017
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
 *  Copyright 2016 Adam Duracz
 **************************************************************************************************/

// TODO: add p-norm and frobenius norm
// TODO: add overload for vector and tensor

/// Compute vector norm.
///
/// - Parameters
///     - A: vector
/// - Returns: vector L^2 norm of A, that is, |A| = \sqrt (\sum_k (x_k)^2)
public func norm(_ A: Matrix<Double>) -> Double
{
    // A is a vector
    precondition(A.rows == 1 || A.columns == 1, "Matrix must be a vector")

    let v = A.data
    var res: Double = 0.0

    for i in 0 ..< v.count {
        res += v[i]*v[i]
    }

    return sqrt(res)
}