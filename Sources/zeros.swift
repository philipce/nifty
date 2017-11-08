/***************************************************************************************************
 *  zeros.swift
 *
 *  This file provides functionality for creating a zero matrix.
 *
 *  Author: Philip Erickson
 *  Creation Date: 1 May 2016
 *  Contributors: Philip Erickson, Nicolas Bertagnolli
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

/// Create a matrix of the given size where all elements are zero.
///
/// - Parameters:
///    - rows: number of rows in zero matrix
///    - columns: number of columns in zero matrix
/// - Returns: zero matrix
public func zeros(_ rows: Int, _ columns: Int) -> Matrix<Double>
{
    precondition(rows > 0 && columns > 0, "Matrix dimensions must both be at least 1")

    return Matrix(rows, columns, value: 0.0)
}


// TODO: implement this vector constructor:


/// Creates a vector of the given size where all elements are zero.
///
/// - Parameters:
///     - count: number of elements in zero vector
/// - Returns: zero vector
public func zeros(_ count: Int) -> Vector<Double>
{
    precondition(count > 0, "Vector must contain at least 1 element")

    return Vector(count, value: 0.0)
}
