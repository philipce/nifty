/***************************************************************************************************
 *  sum.swift
 *
 *  This file defines the sum function for various data structures. 
 *
 *  Author: Philip Erickson
 *  Creation Date: 2 Mar 2017
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
 *  Copyright 2017 Philip Erickson
 **************************************************************************************************/

//==================================================================================================
// MARK: - Lists
//==================================================================================================

public func sum(_ l: [Double]) -> Double
{
    return l.reduce(0.0,+)
}

public func sum(_ l: [Int]) -> Int
{
    return l.reduce(0,+)
}

//==================================================================================================
// MARK: - Vectors
//==================================================================================================

public func sum(_ v: Vector<Double>) -> Double
{
    return v.data.reduce(0.0,+)
}

public func sum(_ v: Vector<Int>) -> Int
{
    return v.data.reduce(0,+)
}

//==================================================================================================
// MARK: - Matrices
//==================================================================================================

public func sum(_ A: Matrix<Double>) -> Double
{
    return A.data.reduce(0.0, +)
}

public func sum(_ A: Matrix<Int>) -> Int
{
    return A.data.reduce(0, +)
}

public func sum(_ A: Matrix<Double>, dim: Int) -> Matrix<Double>
{
    let t = Tensor(A)
    let tsum = sum(t, dim: dim)
    return Matrix(tsum)
}

//==================================================================================================
// MARK: - Tensors
//==================================================================================================

public func sum(_ A: Tensor<Double>) -> Double
{
    return A.data.reduce(0.0, +)
}

public func sum(_ A: Tensor<Int>) -> Int
{
    return A.data.reduce(0, +)
}

public func sum(_ A: Tensor<Double>, dim: Int) -> Tensor<Double>
{
    // compute number of elements to sum and size of the summed tensor (collapse the sum dimension)
    if dim < 0 || dim >= A.size.count { error("Invalid dimension specified") }
    var sumSize = A.size    
    sumSize[dim] = 1
    let sumCount = A.size[dim]
    let sumLowerBounds = Array<Int>(repeating: 0, count: sumSize.count)
    let sumUpperBounds = sumSize.map({$0-1})

    var sumTensor = Tensor<Double>(sumSize, value: 0.0)

    // for each slice, starting at the first, sum all elements in the sum dimension
    var curSlice: [Int]? = Array<Int>(repeating: 0, count: sumSize.count)
    while curSlice != nil
    {
        var total = 0.0
        for i in 0..<sumCount
        {
            var curElement = curSlice!
            curElement[dim] = i
            total += A[curElement]
        }

        sumTensor[curSlice!] = total

        curSlice = _cascadeIncrementSubscript(curSlice!, min: sumLowerBounds, max: sumUpperBounds)
    }

    return sumTensor
}