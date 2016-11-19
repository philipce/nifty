/***************************************************************************************************
 *  ind2sub.swift
 *
 *  This file provides functionality for converting indices to subscripts.
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

/// Convert monodimensional index into multidimensional subscripts.
///
/// Note: Row-major order is used. In row-major order, the last dimension is contiguous. In 2-D
/// matrix, this corresponds to walking through the columns in a row before moving to the next row.
/// In a 3-D matrix, the index walks through the layers for a particular row/column pair, then 
/// through the columns in a row, then finally moves to the next row.
///
/// - Parameters: 
///     - size: size of data structure to subscript
///     - index: index into flattened data structure
/// - Returns: list of subscripts corresponding to index, or empty list if index is out of bounds
func ind2sub(size: [Int], index: Int) -> [Int] 
{        
    precondition(!size.isEmpty, "Size must not be empty")
   
    if index < 0 || index > size.reduce(1, *)-1
    {
        return []
    } 

    var curIndex = index
    var subs = [Int](repeating: 0, count: size.count)                  
       
    // compute the steps in linear index needed to increment each dimension subscript
    var steps = [Int](repeating: 0, count: size.count) 
    steps[size.count-1] = 1
    for i in stride(from: size.count-2, through: 0, by: -1)
    {
        steps[i] = steps[i+1] * size[i+1]
    }

    // count the number of subscript increments, beginning with slowest moving dimension
    for dim in 0..<size.count
    {
        subs[dim] = curIndex/steps[dim]
        curIndex = curIndex - (subs[dim]*steps[dim])
    }
    
    return subs
}