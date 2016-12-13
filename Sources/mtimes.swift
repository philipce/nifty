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

import CBlas

public func * (left: Matrix, right: Matrix) -> Matrix
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
func mtimes(_ A: Matrix, _ B: Matrix) -> Matrix
{
    // TODO check size

    let transA = CblasNoTrans
    let transB = CblasNoTrans

    let m = A.size[0]
    let n = B.size[1]

    precondition(A.size[1] == B.size[0], "Inner matrix dimensions must agree")
    let k = A.size[1]
    

    let alpha = 1.0
    let a = A.data
    let lda = k

    let b = B.data
    let ldb = n
    let beta = 0.0
    var c = Array<Double>(repeating: 0, count: m*n)
    let ldc = k

    cblas_dgemm(CblasRowMajor, transA, transB, Int32(m), Int32(n), Int32(k), alpha, a, Int32(lda), 
        b, Int32(ldb), beta, &c, Int32(ldc))

    // inherit name
    var newName: String? = nil
    if let nameA = A.name, let nameB = B.name
    {
        newName = "\(nameA)*\(nameB)"
    }

    return Matrix(m, n, data: c, name: newName, showName: A.showName)
}

// TODO: determine where this stuff goes, here or times:
//     add matrix*scalar, scalar*matrix, matrix*vector, vector*matrix