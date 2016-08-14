/*******************************************************************************
 *  eye.swift
 *
 *  This file provides functionality for obtaining an identity matrix.
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


// TODO: combine these to take Int...
// Check to make sure there are 0, 1, or 2 numbers, nothing else is supported in MATLAB

/// Creates a square identity matrix of the given size.
///
/// - Parameters:
///     - size: edge size of identity matrix to create
/// - Returns: identity matrix
// TODO: get rid of this convention of a single int making a square?
// Why not force eye([N,N]) instead for clarity?
// Is it worth maintaining numpy/matlab convention?
func eye(_ size: Int) -> Matrix
{
    assert(size > 0, "Matrix dimensions must be positive")

    var m = zeros([size,size])

    for r in 0..<size
    {
        m[r,r] = 1
    }

    return m
}

/// Creates a matrix with ones on the main diagonal and zeros elsewhere.
///
/// - Parameters:
///     - size: size of matrix to create
/// - Returns: specified matrix
func eye(_ size: [Int]) -> Matrix
{   
    assert(!size.isEmpty && size.reduce(1, combine: *) > 0, 
            "Matrix dimensions must all be positive")
    
    var m = zeros(size)

    for r in 0..<size[0]
    {
        m[r,r] = 1
    }

    return m
}
