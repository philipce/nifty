/***************************************************************************************************
 *  expm1.swift
 *
 *  This file provides exponentiation minus 1 functionality.
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

/// Return a value equivalent to exp (x) - 1. Computed in a way that is 
/// accurate even if x is near zero—a case where exp (x) - 1 would be 
/// inaccurate owing to subtraction of two numbers that are nearly equal.

#if os(Linux)
@_exported import func Glibc.expm1
#else
@_exported import func Darwin.expm1
#endif

public func expm1(_ v: Vector<Double>) -> Vector<Double>
{
    let newData = v.data.map({expm1($0)})

    return Vector(newData, name: v.name, showName: v.showName)
}

public func expm1(_ m: Matrix<Double>) -> Matrix<Double>
{
    let newData = m.data.map({expm1($0)})

    return Matrix(m.size, newData, name: m.name, showName: m.showName)
}

public func expm1(_ t: Tensor<Double>) -> Tensor<Double>
{
    let newData = t.data.map({expm1($0)})

    return Tensor(t.size, newData, name: t.name, showName: t.showName)
}
