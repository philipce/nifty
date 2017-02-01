/***************************************************************************************************
 *  transpose.swift
 *
 *  This file provides functionality for transposing matrices.
 *
 *  Author: Philip Erickson
 *  Creation Date: 16 Aug 2016
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

// TODO: transpose only operates on double matrices... extend to int, float, string, etc.
// It's specific to doubles because of the use of BLAS function. Can use BLAS on ints/floats, but
// for strings or Any we'll have to do something custom (which will be slower).

// TODO: there must be a faster way to transpose... 
// LAPACKE states that it transposes row-major matrices on input (since fortran is column-major), 
// and that seems to barely be noticeable in inverting large (5000x5000) matrices (both row and 
// column take around 6 seconds). But just transposing the way it's done below takes around 4 
// seconds (still better than the 8 seconds a naive double for loop takes).

// TODO: decide on operator, add it to documentation. Maybe A^ to transpose? A* should be conjugate.
// A~ maybe. A` is invalid I believe. Maybe unicode symbols? Aᵀ
postfix operator ^
public postfix func ^ (A: Matrix<Double>) -> Matrix<Double>
{
	return transpose(A)
}

/// Return the nonconjugate transpose of the given matrix.
///
/// Alternatively, `transpose(B)` can be executed with `B^`. 
///
/// - Parameters:
///		- B: the matrix to transpose
///	- Returns: transposed matrix
public func transpose(_ B: Matrix<Double>) -> Matrix<Double>
{
    let A = eye(B.columns, B.columns)
    let transA = CblasNoTrans
    let m = A.rows
    let k = A.columns
    let a = A.data
    let lda = m
    let alpha = 1.0	
    
    let transB = CblasTrans
    assert(k == B.columns) // k is rows in transpose(B) and columns in A
    let n = B.rows         // n is columns in transpose(B) and columns in C
    let b = B.data
    let ldb = k            // ldb is rows in transpose(B)
    
    var c = Array<Double>(repeating: 0, count: k*n)
    let ldc = n 		  // for row-major, leading dimension is the number of elements in row 
    let beta = 0.0
    
    cblas_dgemm(CblasRowMajor, transA, transB, Int32(m), Int32(n), Int32(k), alpha, a, Int32(lda), 
                b, Int32(ldb), beta, &c, Int32(ldc))
    
    // inherit name
    var newName = A.name
    if newName != nil { newName = "transpose(\(newName!))"}
    
    return Matrix(k, n, c, name: newName, showName: A.showName)
}
