/***************************************************************************************************
 *  swap.swift
 *
 *  This file provides functionality for swapping elements of vectors, matrices, or tensors.
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

// TODO: extend this to allow swapping of vector elements, columns of matrices as well as rows, and
// 2D tensors in 3D tensors, etc.

#if NIFTY_XCODE_BUILD
import Accelerate
#else
import CBlas
#endif


// Swap two rows in a given matrix.
///
/// - Parameters:
///		- rows: exactly two numbers, corresponding to the zero-indexed rows to swap
///		- A: the matrix in which to swap rows
public func swap<T>(rows: Int..., in A: Matrix<T>) -> Matrix<T>
{
	// FIXME: do this faster using BLAS DSWAP
	// see https://software.intel.com/en-us/node/520744 for better doc

	precondition(rows.count == 2, "Swap requires exactly 2 rows to be specified")

	var Aswap = A

	let temp = Aswap[rows[0], 0..<Aswap.columns]
	Aswap[rows[0], 0..<Aswap.columns] = Aswap[rows[1], 0..<Aswap.columns]
	Aswap[rows[1], 0..<Aswap.columns] = temp

	if let nameA = A.name
	{
		Aswap.name = "swap(rows: \(rows[0]), \(rows[1]), in: \(nameA))"
	}

	return Aswap
}
