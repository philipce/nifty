/***************************************************************************************************
 *  ndims.swift
 *
 *  This file provides functionality for finding the dimensionality of a matrix.
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

/// Provide the number of matrix dimensions.
///
/// - Parameters
///     - A: given matrix
/// - Returns: dimensionality of the given matrix
public func ndims<T>(_ A: Matrix<T>) -> Int
{
    return A.size.count
}