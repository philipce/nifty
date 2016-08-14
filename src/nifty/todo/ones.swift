/*******************************************************************************
 *  ones.swift
 *
 *  This file provides functionality for creating a ones matrix.
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

// TODO: match inf and nan() signatures

/// Creates a matrix of the given size where all elements are one.
///
/// - Parameters:
///     - size: size of matrix to create
/// - Returns: matrix containing ones
func ones(_ size: [Int]) -> Matrix
{
    let totalSize = size.reduce(1, combine: *)
    precondition(!size.isEmpty && totalSize > 0, 
            "Matrix dimensions must all be positive")

    return Matrix(size: size, value: 1)
}

/// Creates a square matrix of the given size where all elements are one.
///
/// - Parameters:
///     - size: edge size of matrix to create
/// - Returns: square matrix containing ones
func ones(_ size: Int) -> Matrix
{
    precondition(size > 0, "Matrix dimensions must be positive")

    return Matrix(size: [size, size], value: 1)
}
