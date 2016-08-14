/*******************************************************************************
 *  plus.swift
 *
 *  This file provides functionality for matrix addition.
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

/// Perform matrix addition.
///
/// Note: used by '+' operator.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: matrix sum of A and B
func plus(_ A: Matrix, _ B: Matrix) -> Matrix
{
    assert(size(A) == size(B), "Matrices must have the same size")

    var newData = [Double]()
    for i in 0..<numel(A)
    {
        newData.append(A[i] + B[i])
    }

    return Matrix(size: size(A), data: newData)
}
