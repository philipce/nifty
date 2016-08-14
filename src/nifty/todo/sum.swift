/*******************************************************************************
 *  sum.swift
 *
 *  This file provides functionality for summing over a matrix.
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

/// Compute the sum of matrix elements.
///
/// - Parameters:
///     - A: matrix to sum
/// - Returns: sum of matrix elements
func sum(_ A: Matrix) -> Double
{
    var s = 0.0
    for i in 0..<numel(A)
    {
        s += A[i]
    }

    return s
}

/// Compute the sum of matrix elements along a particular dimension.
///
/// - Parameters:
///     - A: matrix to sum
///     - dim: dimension to sum along
/// - Returns: sum of matrix elements
func sum(_ A: Matrix, dim: Int) -> Matrix
{
    // TODO: impl
    assert(false, "sum over dims not implemented")

    // determine size of result (essentially flatten given dim)
    var newSize = size(A)
    newSize[dim] = 1

    // create new matrix
    let M = zeros(newSize)

    // for every subscript in the newly sized matrix...
    for _ in 0..<numel(M)
    {
        //let curSubs = ind2sub(newSize, index: i)

        // FIXME: 
        // 1) cant mix range and ints in cursubs array
        // 2) this depends on leaving the flattened dimension present with a
        //    size of 1. E.g. in matlab, flattening a 3D [5,5,10] to 2D would
        //    leave a [5,5], but this impl relies on it leaving a [5,5,1]... How
        //    should this be handled? Leave the 1 in the 3rd dim? Compact to 2D?
        //curSubs[dim] = 0..<size(A,dim)        
        
        // perform operation on slice and stick result in new matrix
        // TODO: A[cursubs] needs to return a slice!
        // M[i] = A[curSubs].reduce(0, combine: +) 
    }

    return M
}
