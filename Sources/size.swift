/*******************************************************************************
 *  size.swift
 *
 *  This file provides functionality for determining the size of a matrix.
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

/// Provide the size of a matrix in each dimension.
///
/// - Parameters
///     - A: given matrix
/// - Returns: size of the given matrix
public func size<T>(_ A: Matrix<T>) -> [Int]
{
    return A.size
}

/// Provide the size of a matrix in a specific dimension.
///
/// - Parameters
///     - A: given matrix
///     - dim: dimension of interest
/// - Returns: size of the given matrix dimension
public func size<T>(_ A: Matrix<T>, _ dim: Int) -> Int
{
    return A.size[dim]
}
