
/***************************************************************************************************
 *  Matrix.swift
 *
 *  This file defines the Matrix data structure.
 *
 *  Authors: Philip Erickson, Nicolas Bertagnolli
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
 *  Copyright 2016 Philip Erickson, Nicolas Bertagnolli
 **************************************************************************************************/
/// Compute the mean of matrices and vectors.  If it is a vector just return
/// the scalar mean.  If it is a matrix examine the mean across either columns
/// or rows


/// Computes the row/column wise mean of a Matrix
///
/// By default, calculates the mean across columns.  For example given a matrix [[1, 2, 3], [4, 5, 6]]
/// the default return type would be [[2.0, 5.0]] if dim=1 then it would be [[2.5, 3.5, 4.5]]
///
/// - Parameters:
///     - A: A matrix that we want to calculate the mean of
///     - dim: the dimension that we want the mean over. 0 means across columns 1 means across rows
/// - Returns: A matrix with the values of the row/column wise mean
public func mean(_ A: Matrix<Double>, dim: Int = 0) -> Matrix<Double> {
    // Default to taking the mean across rows
    var outside = A.rows
    var inside = A.columns
    var means = zeros(1, A.rows)
    
    // If dim=0 then take the mean across columns
    if dim == 1 {
        outside = A.columns
        inside = A.rows
        means = zeros(1, A.columns)
    }
    
    let divisor = Double(inside)
    
    for i in 0..<outside {
        for j in 0..<inside  {
            if dim == 0 {
                means[0, i] += A[i, j] / divisor
            } else {
                means[0, i] += A[j, i] / divisor
            }

        }
    }
    return means
}

public func mean(_ v: Vector<Double>) -> Double {
    return dot(v, Vector(v.count, value: 1.0)) / Double(v.count)
}

public func mean(_ list: [Double]) -> Double
{
    var sum = 0.0
    for el in list { sum += el }
    return sum/Double(list.count)
}
