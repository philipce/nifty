/**************************************************************************************************
 *  isequal.swift
 *
 *  This file provides functionality for comparing numbers, Vectors, Matrices, and Tensors for 
 *  equality within given tolerances.
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

// The article "Comparing Floating Point Numbers, 2012 Edition", by Bruce Dawson was useful in this:
// https://randomascii.wordpress.com/2012/02/25/comparing-floating-point-numbers-2012-edition/

extension Nifty.Options
{
    public enum isequal
    {
        case absolute
        case relative
    }
}

/// Determine whether two numbers are equal, within the given tolerance.
///
/// The default method of comparison is to use absolute comparisons for small numbers, and relative 
/// comparisons for large numbers. This default can be overridden by specifying in the function call
/// which comparison method to use.
///
/// - Parameters:
///    - a: first number to compare
///    - b: second number to compare
///    - within tolerance: tolerance to allow as equal
///    - comparison: optionally override default, specifying whether to compute absolute or relative 
///        difference between numbers, which is then compared against the given tolerance
/// - Returns: true if values are equal according to the specified tolerance
public func isequal(_ a: Double, _ b: Double, within tolerance: Double = eps.single, 
    comparison: Nifty.Options.isequal? = nil) -> Bool
{
    switch comparison
    {
        case .some(.absolute):
            return abs(a-b) < tolerance

        case .some(.relative):
            let diff = abs(a-b)
            return diff <= max(abs(a), abs(b)) * tolerance

        case .none:
            // TODO: revisit what should constitute a "small number"
            // compare small numbers absolutely (relative comparsion against 0 doesn't make sense)
            if abs(a) < 1 || abs(b) < 1
            {
                return abs(a-b) < tolerance
            }
            // larger numbers make more sense to compare relatively
            else
            {
                let diff = abs(a-b)
                return diff <= max(abs(a), abs(b)) * tolerance
            }
    }
}

public func isequal(_ a: Vector<Double>, _ b: Vector<Double>, within tolerance: Double = eps.single, 
    comparison: Nifty.Options.isequal? = nil) -> Bool
{
    if a.count != b.count
    { 
        return false
    }

    for i in 0..<a.count
    {
        if !isequal(a[i], b[i], within: tolerance, comparison: comparison)
        {
            return false
        }
    }

    return true
}

public func isequal(_ a: Matrix<Double>, _ b: Matrix<Double>, within tolerance: Double = eps.single, 
    comparison: Nifty.Options.isequal? = nil) -> Bool
{
    if a.size != b.size
    { 
        return false
    }

    for i in 0..<a.count
    {
        if !isequal(a[i], b[i], within: tolerance, comparison: comparison)
        {
            return false
        }
    }

    return true
}

public func isequal(_ a: Tensor<Double>, _ b: Tensor<Double>, within tolerance: Double = eps.single, 
    comparison: Nifty.Options.isequal? = nil) -> Bool
{
    if a.size != b.size
    { 
        return false
    }

    for i in 0..<a.count
    {
        if !isequal(a[i], b[i], within: tolerance, comparison: comparison)
        {
            return false
        }
    }

    return true
}