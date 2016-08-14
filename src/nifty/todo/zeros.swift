/*******************************************************************************
 *  zeros.swift
 *
 *  This file provides functionality for creating a zero matrix.
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

// TODO: match inf(), nan(), ones() signatures

/// Creates a matrix of the given size where all elements are zero.
///
/// - Parameters:
///     - size: size of matrix to create
/// - Returns: zero matrix
public func zeros(_ size: [Int]) -> Matrix
{
    assert(!size.isEmpty && size.reduce(1, combine: *) > 0, 
            "Matrix dimensions must all be positive")

    return Matrix(size: size, value: 0)
}

/// Creates a square matrix of the given size where all elements are zero.
///
/// - Parameters:
///     - size: edge size of matrix to create
/// - Returns: square zero matrix
public func zeros(_ size: Int) -> Matrix
{
    assert(size > 0, "Matrix dimensions must be positive")

    return Matrix(size: [size, size], value: 0)
}
