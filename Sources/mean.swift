
/***************************************************************************************************
 *  mean.swift
 *
 *  This file defines functionality for computing the mean
 *
 *  Author: Nicolas Bertagnolli
 *  Contributors: Philip Erickson
 *  Creation Date: 19 Feb 2017
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
 *  Copyright 2017 Nicolas Bertagnolli
 **************************************************************************************************/

// Compute the mean of matrices and vectors.  If it is a vector just return
// the scalar mean.  If it is a matrix examine the mean across either columns
// or rows

public func mean(_ T: Tensor<Double>, dim : Int) -> Tensor<Double> {
	
	precondition(dim >= 0 && dim < T.size.count, "Invalid tensor dimensions")

	let s = sum(T, dim: dim)

	return s/Double(T.size[dim])
}

public func mean(_ T: Tensor<Double>) -> Double {
	return mean(T.data)
}


/// Computes the row/column wise mean of a Matrix.
///
/// Calculates the mean along the given dimension. For example given a matrix [[1, 2, 3],[4, 5, 6]],
/// the mean for dim=1 would be [[2.0],[5.0]]. If dim=1 then it would be [[2.5,3.5,4.5]]. The matrix
/// retains its size/shape, except for the specified dimension to sum along, which will always be 1.
///
/// - Parameters:
///     - A: A matrix that we want to calculate the mean of
///     - dim: the dimension that we want the mean over. 0 means across columns 1 means across rows
/// - Returns: A matrix with the values of the row/column wise mean
public func mean(_ A: Matrix<Double>, dim: Int) -> Matrix<Double> {

    precondition(dim == 0 || dim == 1, "Invalid matrix dimension: \(dim)")

    let s = sum(A, dim: dim)

    return s/Double(A.size[dim])
}

public func mean(_ A: Matrix<Double>) -> Double {
    return mean(A.data)
}

public func mean(_ v: Vector<Double>) -> Double {
    return dot(v, Vector(v.count, value: 1.0)) / Double(v.count)
}

public func mean(_ list: [Double]) -> Double
{
    var s = 0.0
    for el in list { s += el }
    return s/Double(list.count)
}
