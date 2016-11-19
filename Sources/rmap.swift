/*******************************************************************************
 *  rmap.swift
 *
 *  This file provides functionality for remapping a number to a new range.
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

/// Maps a number linearly from one range to another.
///
/// - Parameters:
///     - x: number to map
///     - from: original range
///     - to: target range
/// - Returns: re-mapped number
func rmap(_ x: Double, from: Range<Int>, to: Range<Int>) -> Double
{
    let fromLow = Double(from.lowerBound)
    let fromHigh = Double(from.upperBound-1)
    let toLow = Double(to.lowerBound)
    let toHigh = Double(to.upperBound-1)

    return rmap(x, l: fromLow, h: fromHigh, tl: toLow, th: toHigh)
}

// TODO: should overloads get a comment header?
// Check out how doc tool (e.g. jazzy) handles this
func rmap(_ x: Int, from: Range<Int>, to: Range<Int>) -> Double
{
    // FIXME: check whether this upperBound-1 makes sense (hold over from Swift 2.2)

    let fromLow = Double(from.lowerBound)
    let fromHigh = Double(from.upperBound-1)
    let toLow = Double(to.lowerBound)
    let toHigh = Double(to.upperBound-1)

    return rmap(Double(x), l: fromLow, h: fromHigh, tl: toLow, th: toHigh)
}

func rmap(_ x: Double, from: ClosedRange<Double>, 
    to: ClosedRange<Double>) -> Double
{
    let fromLow = from.lowerBound
    let fromHigh = from.upperBound
    let toLow = to.lowerBound
    let toHigh = to.upperBound

    return rmap(x, l: fromLow, h: fromHigh, tl: toLow, th: toHigh)
}

func rmap(_ x: Int, from: ClosedRange<Double>, 
    to: ClosedRange<Double>) -> Double
{
    let fromLow = from.lowerBound
    let fromHigh = from.upperBound
    let toLow = to.lowerBound
    let toHigh = to.upperBound

    return rmap(Double(x), l: fromLow, h: fromHigh, tl: toLow, th: toHigh)
}

private func rmap(_ x: Double, l: Double, h: Double, tl: Double, 
    th: Double) -> Double
{
    return (x-l) * (th-tl)/(h-l) + tl
}
