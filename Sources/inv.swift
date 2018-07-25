/***************************************************************************************************
 *  inv.swift
 *
 *  This file provides functionality for inverting a matrix.
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
import CLapacke
#endif

public prefix func ~ (A: Matrix<Double>) -> Matrix<Double>
{
    return inv(A)
}

/// Compute the inverse of a given square matrix.
///
/// A warning is printed if the given matrix is singular.
///
/// Alternatively, `inv(A)` can be executed with `~A`.
///
/// - Parameters:
///     - A: square matrix to invert
/// - Returns: inverse of A matrix
public func inv(_ A: Matrix<Double>) -> Matrix<Double>
{
    precondition(A.size[0] == A.size[1], "Matrix must be square")

    var n = Int32(A.size[0])
    var m = n
    var a = A.data

    // The leading dimension equals the number of elements in the major dimension. In this case,
    // we are doing row-major so lda is the number of columns in A.
    var lda = n
    var ipiv = Array<Int32>(repeating: 0, count: Int(n))
    var info = Int32(0)

    // TODO: find better way to resolve the difference between clapack used by Accelerate and LAPACKE
    #if NIFTY_XCODE_BUILD
    // compute LU factorization
    let At = transpose(A)
    var at = At.data
    dgetrf_(&m, &n, &at, &lda, &ipiv, &info)
    precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")

    // use LU factorization to compute inverse
    var lwork = n*n // TODO: revisit this for optimal performance... see lapack docs 
    var work = Array<Double>(repeating: 0, count: Int(lwork))
    dgetri_(&n, &at, &lda, &ipiv, &work, &lwork, &info)
    precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
    precondition(info == 0, "Cannot invert singular matrix")
    a = transpose(Matrix(Int(n), Int(n), at)).data
    #else
    // compute LU factorization
    info = LAPACKE_dgetrf(LAPACK_ROW_MAJOR, m, n, &a, lda, &ipiv)
    precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")

    // use LU factorization to compute inverse
    info = LAPACKE_dgetri(LAPACK_ROW_MAJOR, n, &a, lda, &ipiv)
    precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
    precondition(info == 0, "Cannot invert singular matrix")
    #endif

    // inherit name
    var newName = A.name
    if newName != nil { newName = "~" + newName! }

    return Matrix(Int(n), a, name: newName, showName: A.showName)
}
