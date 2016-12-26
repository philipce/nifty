/***************************************************************************************************
 *  lu.swift
 *
 *  This file provides functionality for computing the LU decomposition of a matrix.
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

// TODO: this function only returns L and U--extend it to return P, Q, and R (as in MATLAB)

import CLapacke

/// Compute the LU decomposition of a given square matrix.
///
///	A warning is printed if the given matrix is singular.
///
/// - Parameters:
///     - A: matrix to decompose
/// - Returns: the lower triangular matrix L and the upper triangular matrix U, and the permutation
///		matrix P (indicating how the rows of L were permuted), such that A=P*L*U.
public func lu(_ A: Matrix) -> (L: Matrix, U: Matrix, P: Matrix)
{
	let m = Int32(A.size[0])
	let n = Int32(A.size[1])	
	var a = A.data

	// The leading dimension equals the number of elements in the major dimension. In this case,
	// we are doing row-major so lda is the number of columns in A.
	let lda = n
	
	var ipiv = Array<Int32>(repeating: 0, count: Int(n))		

	// compute LU factorization
	let info = LAPACKE_dgetrf(LAPACK_ROW_MAJOR, m, n, &a, lda, &ipiv)
	precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
	if info > 0
	{
		print("Warning: U(\(info),\(info)) is exactly zero. The factorization has been completed, " + 
			"but the factor U is exactly singular, and division by zero will occur if it is used " +
			"to solve a system of equations.")
	}

	// // use LU factorization to compute inverse
	// info = LAPACKE_dgetri(LAPACK_ROW_MAJOR, n, &a, lda, &ipiv)
	// precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
	// precondition(info == 0, "Cannot invert singular matrix")
	
	print("a = \n\(a)\n")

	print("ipiv = \n\(ipiv)\n")

	// separate out lower and upper components
	var u = [Double](repeating: 0, count: Int(m)*Int(n))
	var l = [Double](repeating: 0, count: Int(m)*Int(m))
	for r in 0..<Int(m)
	{
		for c in 0..<Int(n)
		{
			let i = r*Int(n) + c

			if r < c
			{
				u[i] = a[i]
				l[i] = 0
			}
			else if r == c
			{
				u[i] = a[i]
				l[i] = 1
			}
			else
			{
				u[i] = 0
				l[i] = a[i]
			}
		}
	}

	var L = Matrix(Int(m), Int(m), data: l)
	var U = Matrix(Int(m), Int(n), data: u)

	// FIXME: verify that this ipiv to permutation conversion is correct
	// The dimensions on the ipiv array concern me, still unclear on the 
	// dimensionality, "(min(M,N))" from LAPACK doc...
	var P = ipiv2p(ipiv: ipiv, m: m, n: n)

	if let nameA = A.name
	{
		L.name = "lu(\(nameA)).L"
		U.name = "lu(\(nameA)).U"
		P.name = "lu(\(nameA)).P"
	}
	if A.showName
	{
		L.showName = true
		U.showName = true
		P.showName = true
	}

	// // inherit name
	// var newName = A.name
	// if newName != nil { newName = "LU(" + newName! + ")" }

	// return Matrix(Int(n), data: a, name: newName, showName: A.showName)

	return (L, U, P)
}