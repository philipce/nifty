/**************************************************************************************************
 *  isequal.swift
 *
 *  This file provides functionality for comparing numbers, Vectors, Matrices, and Tensors.
 *
 *  Author: Philip Erickson
 *  Creation Date: 1 Jan 2017
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
 *  Copyright 2017 Philip Erickson
 **************************************************************************************************/


extension NiftyOption
{
    public enum isequal
    {
        case absolute
        case relative
    }
}

// FIXME: decide how to handle defaults... default machine epsilon seems maybe too small for 
// practical purposes. Maybe shrink default epsilon? Better, make relative difference default?

/// Determine whether 2 numbers are equal, within the given tolerance.
///
/// Default epsilon is taken from https://en.wikipedia.org/wiki/Machine_epsilon.
///
/// - Parameters:
///    - a: first number to compare
///    - b: second number to compare
///    - within tolerance: tolerance to allow as equal
///    -epsilon: specify whether given tolerance should be treated as absolute, or relative (what
///        percent error to allow)
/// - Returns: true if values are equal according to the specified tolerance
public func isequal(_ a: Double, _ b: Double, within tolerance: Double = 2.22E-16, 
    epsilon: NiftyOption.isequal = .absolute) -> Bool
{
    switch epsilon
    {
        case .absolute:
            return abs(a-b) < tolerance
        case .relative:
            fatalError("Not yet implemented") // FIXME: impl
    }
}

public func isequal(_ a: Vector<Double>, _ b: Vector<Double>, within tolerance: Double = 2.22E-16, 
    epsilon: NiftyOption.isequal = .absolute) -> Bool
{
    if a.count != b.count
    { 
        return false
    }

    for i in 0..<a.count
    {
        if !isequal(a[i], b[i], within: tolerance, epsilon: epsilon)
        {
            return false
        }
    }

    return true
}

public func isequal(_ a: Matrix<Double>, _ b: Matrix<Double>, within tolerance: Double = 2.22E-16, 
    epsilon: NiftyOption.isequal = .absolute) -> Bool
{
    if a.size != b.size
    { 
        return false
    }

    for i in 0..<a.count
    {
        if !isequal(a[i], b[i], within: tolerance, epsilon: epsilon)
        {
            return false
        }
    }

    return true
}

public func isequal(_ a: Tensor<Double>, _ b: Tensor<Double>, within tolerance: Double = 2.22E-16, 
    epsilon: NiftyOption.isequal = .absolute) -> Bool
{
    if a.size != b.size
    { 
        return false
    }

    for i in 0..<a.count
    {
        if !isequal(a[i], b[i], within: tolerance, epsilon: epsilon)
        {
            return false
        }
    }

    return true
}