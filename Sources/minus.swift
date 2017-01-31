/***************************************************************************************************
 *  minus.swift
 *
 *  This file provides functionality for vector, matrix, and tensor subtraction.
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

// TODO: add overloads for vector and tensor

public func - (left: Matrix<Double>, right: Matrix<Double>) -> Matrix<Double>
{
    return minus(left, right)
}

/// Perform matrix subtraction.
///
/// Alternatively, `minus(A, B)` can be executed with `A-B`.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: matrix difference of A and B
func minus(_ A: Matrix<Double>, _ B: Matrix<Double>) -> Matrix<Double>
{
    // A and B are of same size
    precondition(B.size == A.size, "Matrix dimensions must agree")

    var C = Array<Double>(repeating: 0, count: A.count)
    for i in 0 ..< A.count {
        C[i] = A[i] - B[i]
    }

    // inherit name
    var newName: String? = nil
    if let nameA = A.name, let nameB = B.name
    {
        newName = "\(_parenthesizeExpression(nameA))-\(_parenthesizeExpression(nameB))"
    }

    return Matrix(A.size, C, name: newName, showName: A.showName)
}
