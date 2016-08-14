/*******************************************************************************
 *  ind2sub.swift
 *
 *  This file provides functionality for converting indices to subscripts.
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

/// Convert monodimensional index into multidimensional subscripts.
///
/// - Parameters: 
///     - index: index into flattened matrix
///     - size: size of matrix
/// - Returns: list of subscripts
func ind2sub(_ size: [Int], _ index: Int) -> [Int] 
{
    // TODO: error check / validate params
    // TODO: check implementation

    var subs = [Int](repeating: 0, count: size.count)                  

    for dim in stride(from: size.count-1, through: 0, by: -1)
    {
        let dimSize = size[0..<dim].reduce(1, combine: *)
        subs[dim] = (index / dimSize) % size[dim]
    }
    
    return subs
}
