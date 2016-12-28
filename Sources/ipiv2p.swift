/***************************************************************************************************
 *  swap.swift
 *
 *  This file provides internal functionality for converting LAPACK pivot indices to the permutation 
 *  matrices more typically used in, for example, MATLAB.
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

/// Convert LAPACK pivot indices to permutation matrix.
///
/// From LAPACK description of ipiv: for 1 <= i <= min(M,N), row i of the matrix was interchanged 
/// with row IPIV(i)/
///
/// For example: ipiv=[3,3,3]. This indicates that first row 1 of the matrix was changed with row 3,
///	then row 2 was changed with row 3, then row 3 was changed with row 3. These changes, when 
/// applied to a 3x3 identity matrix, result in the permutation matrix P=[[0,0,1],[1,0,0],[0,1,0]].
///
/// - Parameters:
///		- ipiv: pivot indices; note LAPACK pivots are 1-indexed
///		- m: number of rows in matrix to permute
///		- n: number of columns in matrix to permute
/// - Returns: permutation matrix
internal func ipiv2p(ipiv: [Int32], m: Int32, n: Int32) -> Matrix<Double>
{
	// FIXME: revisit this for 1) correctness and 2) efficiency
	// 1) currently just assuming the permutation matrix starts out as an mxn identity. Is that ok?
	// 2) current impl is terribly inefficient, going through and performing each swap rather than 
	// resolving the final swaps and only doing those.
	
	precondition(Int32(ipiv.count) == m, "Expected the number of pivot indices to match number of rows")

	var P = eye(Int(m),Int(n))
	for r in 0..<Int(m)
	{
		P = swap(rows: r, Int(ipiv[r])-1, in: P)
	}

	return P
}