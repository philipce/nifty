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
/// Note: Row-major order is used. In row-major order, the last dimension is contiguous. In 2-D
/// matrix, this corresponds to walking through the columns in a row before moving to the next row.
/// In a 3-D matrix, the index walks through the layers for a particular row/column pair, then 
/// through the columns in a row, then finally moves to the next row.
///
/// - Parameters: 
///     - size: size of data structure
///     - subscripts: subscripts into data structure
/// - Returns: index into flattened data structure, or -1 if subscript is out of bounds
public func sub2ind(_ subscripts: [Int], size: [Int]) -> Int
{
    precondition(size.count == subscripts.count, "Size and subscripts must match in dimension")
    
    var index = 0

    // work backwards through subscripts, e.g. row-major --> columns change faster than rows
    for dim in stride(from: subscripts.count, to: 0, by: -1)
    {        
        let sub = subscripts[dim-1]        
        if !(sub >= 0 && sub < size[dim-1]) { return -1 }

        // compute array slots needed to move if incrementing current subscript by 1
        let dimSize = size[dim..<subscripts.count].reduce(1, *)        
        index += dimSize * sub
    }

    return index
}

// TODO: compiler doesn't like creating an overload: 
//    func sub2ind(_ subscripts: Int..., size: [Int]) -> Int { ... }
// It's not clear to me why it has trouble distinguishing in this case and not in others. 
// Decide if we want this overload, and if so, how to do it.