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

// TODO: MATLAB provides a lot more return options than just the one R = chol(A). Add as necessary.

import CLapacke

public func chol(_ A: Matrix, _ opt: CholeskyOption = .upper) -> Matrix
{
	let uplo: Int8
	switch opt
	{
		case .upper:
			uplo = 85 // ascii 'U'
		case .lower:
			uplo = 76 // ascii 'L'
	}

	precondition(A.rows == A.columns, "Matrix must be square")
	let n = A.rows

	var a = A.data

	// The leading dimension equals the number of elements in the major dimension. In this case,
	// we are doing row-major so lda is the number of columns in A.
	let lda = Int32(A.columns)

	let info = LAPACKE_dpotrf(LAPACK_ROW_MAJOR, uplo, Int32(n), &a, lda)
	precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
	precondition(info == 0, "The leading minor of order \(info) is not positive definite, and the " +
		"factorization could not be completed")

	// FIXME: a contains both the upper and lower... need to split them apart

	return Matrix(n, n, data: a)
}

/// Enumerate options for Cholesky decomposition
public enum CholeskyOption
{
	case upper
	case lower
}