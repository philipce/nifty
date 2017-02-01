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

// TODO: MATLAB provides more info, e.g. (L,U,P,Q,R) = lu(A). Should we provide Q and R?

#if NIFTY_XCODE_BUILD
import Accelerate
#else
import CLapacke
#endif

/// Compute the LU decomposition of a given square matrix.
///
///	A warning is printed if the U factor is singular.
///
/// - Parameters:
///     - A: matrix to decompose
/// - Returns: lower triangular matrix L and the upper triangular matrix U
public func lu(_ A: Matrix<Double>) -> (L: Matrix<Double>, U: Matrix<Double>)
{
	let (L, U, _) = _lu(A)

	return (L, U)
}

/// Compute the LU decomposition of a given square matrix.
///
///	A warning is printed if the U factor is singular.
///
/// - Parameters:
///     - A: matrix to decompose
/// - Returns: the lower triangular matrix L, the upper triangular matrix U, and the permutation
///		matrix P (indicating how the rows of L were permuted), such that P*A=L*U
public func lu(_ A: Matrix<Double>) -> (L: Matrix<Double>, U: Matrix<Double>, P: Matrix<Double>)
{
	let (L, U, ipiv) = _lu(A)

	// FIXME: verify that this ipiv to permutation conversion is correct
	// The dimensions on the ipiv array concern me, still unclear on the 
	// dimensionality, "(min(M,N))" from LAPACK doc...
	let m = Int32(A.size[0])
	let n = Int32(A.size[1])
	var P = _ipiv2p(ipiv: ipiv, m: m, n: n)

	if let nameA = A.name
	{
		P.name = "lu(\(nameA)).P"
	}
	if A.showName
	{
		P.showName = true
	}

	return (L, U, P)
}

/// Compute the LU decomposition, returning L, U, and the pivot indices.
///
///	A warning is printed if the U factor is singular.
///
/// This function is just useful as an intermediate, so that the user can avoid computing the
/// permutation matrix from the pivot indices if the permutation matrix isn't needed.
///
/// - Parameters:
///     - A: matrix to decompose
/// - Returns: the lower triangular matrix L, the upper triangular matrix U, and the pivot indices
fileprivate func _lu(_ A: Matrix<Double>) -> (L: Matrix<Double>, U: Matrix<Double>, ipiv: [Int32])
{
	var m = Int32(A.size[0])
	var n = Int32(A.size[1])	
	var a = A.data

	// The leading dimension equals the number of elements in the major dimension. In this case,
	// we are doing row-major so lda is the number of columns in A.
	var lda = n
	var ipiv = Array<Int32>(repeating: 0, count: Int(n))		
    var info = Int32(0)
    
    // compute LU factorization
    
    // TODO: find better way to resolve the difference between clapack used by Accelerate and LAPACKE
    #if NIFTY_XCODE_BUILD
    let At = transpose(A)
    var at = At.data  
    dgetrf_(&m, &n, &at, &lda, &ipiv, &info)
    a = transpose(Matrix(Int(n), Int(n), at)).data
    #else    	
	info = LAPACKE_dgetrf(LAPACK_ROW_MAJOR, m, n, &a, lda, &ipiv)
    #endif
    
	precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
	if info > 0
	{
		print("Warning: U(\(info),\(info)) is exactly zero. The factorization has been completed, " + 
			"but the factor U is exactly singular, and division by zero will occur if it is used " +
			"to solve a system of equations.")
	}	

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

    var L = Matrix(Int(m), Int(m), l)
    var U = Matrix(Int(m), Int(n), u)
    
	if let nameA = A.name
	{
		L.name = "lu(\(nameA)).L"
		U.name = "lu(\(nameA)).U"
	}
	if A.showName
	{
		L.showName = true
		U.showName = true
	}

	return (L, U, ipiv)
}
