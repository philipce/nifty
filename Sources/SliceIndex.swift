/***************************************************************************************************
 *  SliceIndex.swift
 *
 *  This file defines the SliceIndex protocol, allowing for mixed slicing (using both integers 
 *  and ranges) of data structures. 
 *
 *  Author: Phil Erickson
 *  Creation Date: 14 Aug 2016
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

// This protocol allows subscripting/slicing with a mixture of Ints and Ranges.
public protocol SliceIndex {}
extension Int: SliceIndex {}
extension CountableRange: SliceIndex {}
extension CountableClosedRange: SliceIndex {}

/// Convert a collection of SliceIndex elements to countable closed ranges.
///
/// - Parameters: 
///     - s: collection of SliceIndex elements to convert
/// - Returns: collection of countable closed ranges
internal func _convertToCountableClosedRanges(_ s: [SliceIndex]) -> [CountableClosedRange<Int>]
{
    var ranges = [CountableClosedRange<Int>]()
    for el in s
    {
        switch el
        {
            case let el as Int:
                ranges.append(el...el)
            case let el as CountableRange<Int>:
                ranges.append(CountableClosedRange<Int>(el))
            case let el as CountableClosedRange<Int>:
                ranges.append(el)
            default:
                // FIXME: slicing a matrix with Int32 will hit this default case! 
                fatalError("Unknown type of SliceIndex: \(el) \(type(of: el))")
        }
    }

    return ranges
}

internal func _convertToCountableClosedRange(_ s: SliceIndex) -> CountableClosedRange<Int>
{
    return (_convertToCountableClosedRanges([s]))[0]
}
