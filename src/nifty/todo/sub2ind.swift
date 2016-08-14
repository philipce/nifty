/*******************************************************************************
 *  sub2ind.swift
 *
 *  This file provides functionality for converting subscripts to indices.
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

/// Convert multidimensional subscripts into monodimensional index.
///
/// - Parameters: 
///     - size: size of matrix
///     - subscripts: list of subscripts
/// - Returns: index into flattened matrix
func sub2ind(_ size: [Int], subscripts: [Int]) -> Int
{
    // TODO: error check that subscripts has correct dimensionality
    // TODO: bounds check on subscripts?
    // TODO: check implement
    
    var index = 0

    // TODO: Swift 3: for (dim, sub) in subscripts.enumerated()
    for (dim, sub) in subscripts.enumerated()
    {
        let dimSize = size[0..<dim].reduce(1, combine: *)
        index += dimSize * sub
    }

    return index
}
