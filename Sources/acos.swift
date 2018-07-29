/***************************************************************************************************
 *  acos.swift
 *
 *  This file provides inverse cosine functionality.
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

/// Compute the arc cosine of x—that is, the value whose cosine is x. The value 
/// is in units of radians. Mathematically, there are infinitely many such 
/// values; the one actually returned is the one between 0 and pi (inclusive).
/// 
/// The arc cosine function is defined mathematically only over the domain -1 
/// to 1. If x is outside the domain, acos signals a domain error.

#if os(Linux)
@_exported import func Glibc.acos
#else
@_exported import func Darwin.acos
#endif

/// Returns the inverse cosine (cos⁻¹) in radians for each element in a vector data structure.
///
/// - Parameter v: A vector data structure with elements to convert.
/// - Returns: A vector data structure with inverse cosine values.
///
/// - Warning: A domain error occurs for arguments not in the range [-1, +1].
public func acos(_ v: Vector<Double>) -> Vector<Double>
{
    let newData = v.data.map({acos($0)})

    return Vector(newData, name: v.name, showName: v.showName)
}

/// Returns the inverse cosine (cos⁻¹) in radians for each element in a matrix data structure.
///
/// - Parameter m: A matrix data structure with elements to convert.
/// - Returns: A matrix data structure with inverse cosine values.
///
/// - Warning: A domain error occurs for arguments not in the range [-1, +1].
public func acos(_ m: Matrix<Double>) -> Matrix<Double>
{
    let newData = m.data.map({acos($0)})

    return Matrix(m.size, newData, name: m.name, showName: m.showName)
}

/// Returns the inverse cosine (cos⁻¹) in radians for each element in a tensor data structure.
///
/// - Parameter t: A tensor data structure with elements to convert.
/// - Returns: A tensor data structure with inverse cosine values.
///
/// - Warning: A domain error occurs for arguments not in the range [-1, +1].
public func acos(_ t: Tensor<Double>) -> Tensor<Double>
{
    let newData = t.data.map({acos($0)})

    return Tensor(t.size, newData, name: t.name, showName: t.showName)
}
