/***************************************************************************************************
 *  ge.swift
 *
 *  This file provides functionality for greater-than-or-equal-to comparison.
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

public func >= (left: Matrix, right: Matrix)   -> Matrix { return ge(left, right) }
public func >= (left: Matrix, right: Double)   -> Matrix { return ge(left, right) }
public func >= (left: Matrix, right: Int)      -> Matrix { return ge(left, right) }
public func >= (left: Double, right: Matrix)   -> Matrix { return ge(left, right) }
public func >= (left: Int, right: Matrix)      -> Matrix { return ge(left, right) }

/// Determine greater than or equal to inequality.
///
/// - Paramters:
///     - A: First matrix to compare
///     - B: Second matrix to compare
/// - Returns: matrix with ones where comparison is true and zeros elsewhere
public func ge(_ A: Matrix, _ B: Matrix) -> Matrix
{
    assert(size(A) == size(B), "Matrices must be same size")

    var m = [Double]()
    for i in 0..<A.numel
    {        
        m.append(A[i] >= B[i] ? 1 : 0)
    }

    return Matrix(size: size(A), data: m)
}

/// Determine greater than or equal to inequality.
///
/// - Paramters:
///     - A: Matrix to compare
///     - b: Number to compare against
/// - Returns: matrix with ones where comparison is true and zeros elsewhere
public func ge(_ A: Matrix, _ b: Double) -> Matrix
{
    var m = [Double]()
    for i in 0..<A.numel
    {        
        m.append(A[i] >= b ? 1 : 0)
    }

    return Matrix(size: size(A), data: m)
}

/// Determine greater than or equal to inequality.
///
/// - Paramters:
///     - A: Matrix to compare
///     - b: Number to compare against
/// - Returns: matrix with ones where comparison is true and zeros elsewhere
public func ge(_ A: Matrix, _ b: Int) -> Matrix
{
    return ge(A, Double(b))
}

/// Determine greater than or equal to inequality.
///
/// - Paramters:
///     - a: Number to compare
///     - B: Matrix to compare against
/// - Returns: matrix with ones where comparison is true and zeros elsewhere
public func ge(_ a: Double, _ B: Matrix) -> Matrix
{
    var m = [Double]()
    for i in 0..<B.numel
    {        
        m.append(a >= B[i] ? 1 : 0)
    }

    return Matrix(size: size(B), data: m)
}

/// Determine greater than or equal to inequality.
///
/// - Paramters:
///     - a: Number to compare
///     - B: Matrix to compare against
/// - Returns: matrix with ones where comparison is true and zeros elsewhere
public func ge(_ a: Int, _ B: Matrix) -> Matrix
{
    return ge(Double(a), B)
}