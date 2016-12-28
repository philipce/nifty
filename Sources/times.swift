/*******************************************************************************
 *  times.swift
 *
 *  This file provides functionality for element-wise matrix multiplication.
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

/// Perform element wise matrix multiplication.
///
/// Note: used by '.*' operator.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: element wise matrix product of A and B
func times(_ A: Matrix<Double>, _ B: Matrix<Double>) -> Matrix<Double>
{
    assert(A.size == B.size, "Matrices must have the same size")

    var newData = [Double]()
    for i in 0..<A.count
    {
        newData.append(A[i] * B[i])
    }

    return Matrix(A.rows, A.columns, newData)
}

// TODO: determine where this stuff goes, here or mtimes:
//     add matrix*scalar, scalar*matrix, matrix*vector, vector*matrix