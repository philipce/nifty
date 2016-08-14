/*******************************************************************************
 *  find.swift
 *
 *  This file provides functionality for finding elements in a matrix.
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

/// Find every element of the given matrix equal to the provided value.
///
/// - Parameters:
///     - A: matrix to search
///     - value: specifty value to search for, otherwise all non-zero values
///     - tolerance: (optional) error tolerance, plus or minus
///     - direction: TODO "last" or "first"
/// - Returns: list of linear indices into matrix at which value was found
public func find(_ A: Matrix, value: Double? = nil, direction: String = "first", 
    tolerance: Double = DefaultDecimalTolerance) -> [Int]
{
    var indices = [Int]()

    for i in 0..<A.numel
    {
        if let val = value where (abs(val-A.data[i]) < tolerance)
        {
            indices.append(i)
        }
        else if abs(A.data[i]) > tolerance
        {
            indices.append(i)
        }
    }

    return indices
}
