/***************************************************************************************************
 *  mtimes.swift
 *
 *  This file provides functionality for matrix multiplication.
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

#if NIFTY_XCODE_BUILD
import Accelerate
#else
import CBlas
#endif


public func * (left: Matrix<Double>, right: Matrix<Double>) -> Matrix<Double>
{
    return mtimes(left, right)
}

/// Perform matrix multiplication.
///
/// Alternatively, `mtimes(A, B)` can be executed with `A*B`.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: matrix product of A and B
func mtimes(_ A: Matrix<Double>, _ B: Matrix<Double>) -> Matrix<Double>
{
    // TODO check size

    let transA = CblasNoTrans
    let transB = CblasNoTrans

    // A is m x k
    let m = A.rows
    let k = A.columns
    let alpha = 1.0
    let a = A.data
    let lda = k

    // B is k x n
    precondition(B.rows == k, "Inner matrix dimensions must agree")
    let n = B.columns
    let b = B.data
    let ldb = n

    // C is m x n
    let beta = 0.0
    var c = Array<Double>(repeating: 0, count: m*n)
    let ldc = n
     

    cblas_dgemm(CblasRowMajor, transA, transB, Int32(m), Int32(n), Int32(k), alpha, a, Int32(lda), 
        b, Int32(ldb), beta, &c, Int32(ldc))

    // inherit name
    var newName: String? = nil
    if let nameA = A.name, let nameB = B.name
    {
        newName = "\(_parenthesizeExpression(nameA))*\(_parenthesizeExpression(nameB))"
    }

    return Matrix(m, n, c, name: newName, showName: A.showName)
}

// TODO: determine where this stuff goes, here or times:
//     add matrix*scalar, scalar*matrix, matrix*vector, vector*matrix
