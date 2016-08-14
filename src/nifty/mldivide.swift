/*******************************************************************************
 *  mldivide.swift
 *
 *  This file provides functionality for solving systems of linear equations. 
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

// TODO: complete doc

/// Solve the system of linear equations A*x = B for x.
public func mldivide(_ A: Matrix, _ B: Matrix) -> Matrix
{	
	var a = A.data
	var b = B.data
	
	// solve if A is square
	if A.size[0] == A.size[1]
	{
		let n = Int32(A.size[0])
		let nrhs = Int32(B.size[1])
		let lda = n
		let ldb = n
		var ipiv = Array<Int32>(repeating: 0, count: Int(n))

		let info = LAPACKE_dgesv(LAPACK_ROW_MAJOR, n, nrhs, &a, lda, &ipiv, 
			&b, ldb)
		precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
		precondition(info == 0, "Cannot solve due to singular factor U")

		return Matrix(size: Int(n), Int(nrhs), data: b)
	}

	// otherwise return least-squares solution
	else
	{
		// FIXME: implement least squares solution
		return Matrix(size: 2, 2, data: [0, 0, 0, 0])
	}
	

}

