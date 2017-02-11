/***************************************************************************************************
 *  exp.swift
 *
 *  This file provides natural exponentiation functionality.
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

///  Compute e (the base of natural logarithms) raised to the power x.
///  
///  If the magnitude of the result is too large to be representable, exp 
///  signals overflow.

#if os(Linux)
@_exported import func Glibc.exp
#else
@_exported import func Darwin.exp
#endif

public func exp(_ v: Vector<Double>) -> Vector<Double>
{
    let newData = v.data.map({exp($0)})

    return Vector(newData, name: v.name, showName: v.showName)
}

public func exp(_ m: Matrix<Double>) -> Matrix<Double>
{
    let newData = m.data.map({exp($0)})

    return Matrix(m.size, newData, name: m.name, showName: m.showName)
}

public func exp(_ t: Tensor<Double>) -> Tensor<Double>
{
    let newData = t.data.map({exp($0)})

    return Tensor(t.size, newData, name: t.name, showName: t.showName)
}