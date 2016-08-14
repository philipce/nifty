/*******************************************************************************
 *  isequal.swift
 *
 *  This file provides functionality deterimining equality.
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

/// This file provides extensions to Swift Doubles

// TODO: find this file a better home and name
// maybe this shouldn't be about doubles, but instead just compare matrices

// TODO: I think isequal should all just live in the same file, and compare doubles as well as matrices

extension Double
{
    /// Test if two Doubles are equivalent.
    ///
    /// - Parameters:
    ///     - d: the number to compare this double against
    ///     - tol: (optional) tolerance to use in comparison
    func isequal(_ d: Double, tolerance: Double = DefaultDecimalTolerance) -> Bool
    {
        return abs(self-d) < tolerance
    }
}
