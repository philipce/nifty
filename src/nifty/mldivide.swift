/***************************************************************************************************
 *  mldivide.swift
 *
 *  This file provides functionality for solving systems of linear equations. 
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

infix operator -/ {associativity left precedence 150}
public func -/ (left: Matrix, right: Matrix) -> Matrix
{
	return mldivide(left, right)
}

/// Solve the system of linear equations Ax = B for x.
///
///	If A is not square then the solution will be the least-squares solution to the system.
///
/// Alternatively, `mldivide(A)` can be executed with `A-/B`.
///
/// - Parameters:
///		- A: matrix A in the equation Ax = B
///		- B: matrix B in the equation Ax = B
/// - Returns: matrix x in the equation Ax = B
public func mldivide(_ A: Matrix, _ B: Matrix) -> Matrix
{	
	// solve if A is square
	if A.size[0] == A.size[1]
	{
		let n = A.size[0]
		let nrhs = B.size[1]
		var a = A.data	
		var b = B.data

		// The leading dimension equals the number of elements in the major dimension. In this case,
		// we are doing row-major so lda is the number of columns in A, e.g.
		let lda = A.size[1] 
		let ldb = B.size[1]

		var ipiv = Array<Int32>(repeating: 0, count: n)

		let info = LAPACKE_dgesv(LAPACK_ROW_MAJOR, Int32(n), Int32(nrhs), &a, Int32(lda), &ipiv, &b,
			Int32(ldb))

		precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
		precondition(info == 0, "Cannot solve singularity")

		return Matrix(size: [n,nrhs], data: b)
	}

	// otherwise return least-squares solution
	else
	{
		// TODO: what's a good way to convert "N" to Int8?
		let trans: Int8 = 78 // ASCII decimal values: N=78, T=84 

		let m = A.size[0]
		let n = A.size[1]
		
		// overdetermined system
		if m >= n
		{
			let nrhs = B.size[1]
			var a = A.data
			var b = B.data

			// The leading dimension equals the number of elements in the major dimension. In this 
			// case, we are doing row-major so lda is the number of columns in A, e.g.
			let lda = A.size[1] 
			let ldb = B.size[1]

			let info = LAPACKE_dgels(LAPACK_ROW_MAJOR, trans, Int32(m), Int32(n), Int32(nrhs), &a, 
				Int32(lda), &b, Int32(ldb))

			precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
			precondition(info == 0, "Matrix A does not have full rank")

			let x = Array(b[0..<(n*nrhs)])	

			return Matrix(size: [n,nrhs], data: x)			
		}

		// underdetermined system
		else
		{
			let nrhs = B.size[1]
			var a = A.data

			// solution is larger than B so extra space must be added
			var b = Array<Double>(repeating: 0, count: n*nrhs)
			b[0..<B.numel] = B.data[0..<B.numel]		

			// The leading dimension equals the number of elements in the major dimension. In this 
			// case, we are doing row-major so lda is the number of columns in A, e.g.
			let lda = A.size[1] 
			let ldb = B.size[1]

			let info = LAPACKE_dgels(LAPACK_ROW_MAJOR, trans, Int32(m), Int32(n), Int32(nrhs), &a, 
				Int32(lda), &b, Int32(ldb))

			precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
			precondition(info == 0, "Matrix A does not have full rank")

			let x = Array(b[0..<(n*nrhs)])			

			return Matrix(size: [n,nrhs], data: x)	
		}
	}
}