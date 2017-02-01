/***************************************************************************************************
 *  chol.swift
 *
 *  This file provides functionality for computing the Cholesky decomposition of a matrix.
 *
 *  Author: Philip Erickson
 *  Creation Date: 25 Dec 2016
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

// TODO: MATLAB provides a lot more return options than just the two R or L = chol(A). Add more?

#if NIFTY_XCODE_BUILD
import Accelerate
#else
import CLapacke
#endif

extension Nifty.Options
{
    public enum chol
    {
        case upper
        case lower
    }
}

/// Computes the Cholesky decomposition of a real symmetric positive definite matrix.
///
/// By default, produces an upper triangular matrix R such that transpose(R)*R=A. If requested, a
/// lower triangular matrix L is produced instead, such that L*transpose(L)=A.
///
/// - Parameters:
///     - A: matrix to decompose
///     - option: request upper or lower triangular result    
/// - Returns: requested triangular matrix
public func chol(_ A: Matrix<Double>, _ option: Nifty.Options.chol = .upper) -> Matrix<Double>
{
    var uplo: Int8
    switch option
    {
        case .upper:
            uplo = 85 // ascii 'U'
        case .lower:
            uplo = 76 // ascii 'L'
    }

    precondition(A.rows == A.columns, "Matrix must be square")
    var n = Int32(A.rows)
    var a = A.data

    // The leading dimension equals the number of elements in the major dimension. In this case,
    // we are doing row-major so lda is the number of columns in A.
    var lda = Int32(A.columns)
    
    var info = Int32(0)
    
    // TODO: find better way to resolve the difference between clapack used by Accelerate and LAPACKE
    #if NIFTY_XCODE_BUILD
    let At = transpose(A)
    var at = At.data
    dpotrf_(&uplo, &n, &at, &lda, &info)
    a = transpose(Matrix(Int(n), Int(n), at)).data
    #else
    info = LAPACKE_dpotrf(LAPACK_ROW_MAJOR, uplo, n, &a, lda)
    #endif
        
    precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
    precondition(info == 0, "The leading minor of order \(info) is not positive definite, and the " +
        "factorization could not be completed")

    switch option
    {
        case .upper:
            var R = triu(Matrix(Int(n), Int(n), a))
            R.name = A.name != nil ? "chol(\(A.name!), .upper)" : nil
            R.showName = A.showName

            return R

        case .lower:
            var L = tril(Matrix(Int(n), Int(n), a))
            L.name = A.name != nil ? "chol(\(A.name!), .lower)" : nil
            L.showName = A.showName

            return L
    }
}
