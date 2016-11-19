/***************************************************************************************************
 *  toc.swift
 *
 *  This file provides functionality for stopping an ellapsed time stopwatch.
 *
 *  Author: Philip Erickson
 *  Creation Date: 1 May 2016
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

import Foundation

// TODO: format printed time to only have some number of decimal places

/// Measure the ellapsed time since the last call to tic() was made and display to the console.
///
/// This function is useful when the caller doesn't want to store the ellapsed time and wants to
/// avoid compiler warnings about unused returns.
///
/// - Parameters:
///     - units: units of time to display result in; seconds by default
public func toc(_ units: UnitDuration = .seconds)
{
    // Calling through to more generic toc function would reduce repeated code but introduce another
    // function call, reducing the accuracy of the stopwatch. Such a small amount of repeated code
    // seems worth it in this case.

    let stop = Date()
    let ellapsed = Measurement<UnitDuration>(value: stop.timeIntervalSince(_stopwatch),
        unit: .seconds)

    print("Ellapsed time: \(ellapsed.converted(to: units))")
}

/// Measure the ellapsed time since the last call to tic() was made.
///
/// This function is useful when the caller needs to store the ellapsed time.
///
/// - Parameters:
///     - units: units of time to measure result in
///     - printing: optionally print ellapsed time to console; false by default
public func toc(returning units: UnitDuration, printing: Bool = false) -> Double
{
    let stop = Date()
    let ellapsed = Measurement<UnitDuration>(value: stop.timeIntervalSince(_stopwatch),
        unit: .seconds)

    let time = ellapsed.converted(to: units)
    if printing
    {
        print("Ellapsed time: \(time)")
    }

    return time.value
}