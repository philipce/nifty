/**************************************************************************************************
 *  eq.swift
 *
 *  This file defines functionality for determining floating-point relative accuracy.
 *
 *  Author: Nicolas Bertagnolli
 *  Creation Date: 21 Feb 2017
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
 *  Copyright 2017 Nicolas Bertagnolli
 **************************************************************************************************/

/// Compute elementwise equality of two matrices
///
/// - Parameters:
///    - A: first Matrix
///    - B: second Matrix
/// - Returns: A Matrix where the i, j element is 1 if A[i,j] = B[i, j] and 0 otherwise
func eq(_ A: Matrix<Double>, _ B: Matrix<Double>, within tol: Double=0.0000001) -> Matrix<Double> {
    precondition(A.size == B.size, "Matrices must be the same shape")
    
    var result = zeros(A.size[0], A.size[1])
    
    for i in 0..<A.size[0] {
        for j in 0..<A.size[1] {
            if A[i, j] > B[i, j] - tol && A[i, j] < B[i, j] + tol {
                result[i, j] = 1.0
            }
        }
    }
    
    return result
}

/// Compute elementwise equality of two vectors
///
/// - Parameters:
///    - a: first Vector
///    - b: second Vector
/// - Returns: A Vector where the ith element is 1 if a[i] = b[i] and 0 otherwise
func eq(_ a: Vector<Double>, _ b: Vector<Double>, within tol: Double=0.0000001) -> Vector<Double> {
    precondition(a.count == b.count, "Vectors must be the same shape")
    
    var result = Vector(a.count, value: 0.0)
    
    for i in 0..<a.count {
        if a[i] > b[i] - tol && a[i] < b[i] + tol {
            result[i] = 1.0
        }
    }
    
    return result
}
