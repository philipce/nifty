/***************************************************************************************************
 *  plus.swift
 *
 *  This file provides functionality for vector, matrix, and tensor addition.
 *
 *  Author: Adam Duracz
 *  Creation Date: 30 Jan 2017
 *  Contributors: Adam Duracz, Philip Erickson
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
 *  Copyright 2016 Adam Duracz, Philip Erickson
 **************************************************************************************************/

// TODO: add overloads for vector and tensor

public func + <T: TensorProtocol>(left: T, right: T) -> T where T.Element: Numeric
{
    return plus(left, right)
}

/// Perform tensor addition.
///
/// Alternatively, `plus(A, B)` can be executed with `A+B`.
///
/// - Parameters
///     - A: left tensor
///     - B: right tensor
/// - Returns: tensor sum of A and B
func plus<T: TensorProtocol>(_ A: T, _ B: T) -> T where T.Element: Numeric
{
    // A and B are of same size
    precondition(B.size == A.size, "Tensor dimensions must agree")
    
    var C = Array<T.Element>(repeating: 0, count: A.count)
    for i in 0 ..< A.count {
        C[i] = A.data[i] + B.data[i]
    }
    
    // inherit name
    var newName: String? = nil
    if let nameA = A.name, let nameB = B.name
    {
        newName = "\(_parenthesizeExpression(nameA))+\(_parenthesizeExpression(nameB))"
    }
    
    return T(A.size, C, name: newName, showName: A.showName)
}
