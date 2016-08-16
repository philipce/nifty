/***************************************************************************************************
 *  sub2ind.swift
 *
 *  This file provides functionality for converting subscripts to indices.
 *
 *  Author: Philip Erickson
 *  Creation Date: 1 May 2016
 *  Contributors: 
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

/// Convert multidimensional subscripts into monodimensional index.
///
/// - Parameters: 
///     - size: size of data structure
///     - subscripts: list of subscripts
/// - Returns: index into flattened data structure
public func sub2ind(size: [Int], subscripts: [Int]) -> Int
{
    precondition(size.count == subscripts.count, "Size and subscripts must match in dimension")
    
    var index = 0

    // work backwards through subscripts, e.g. row-major --> columns change faster than rows
    for dim in stride(from: subscripts.count, to: 0, by: -1)
    {
        let sub = subscripts[dim-1]

        precondition(sub >= 0 && sub < size[dim-1], "Subscript out of bounds")

        // compute array slots needed to move if incrementing current subscript by 1
        let dimSize = size[dim..<subscripts.count].reduce(1, combine: *)

        index += dimSize * sub
    }

    return index
}