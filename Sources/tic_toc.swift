/***************************************************************************************************
 *  tic_toc.swift
 *
 *  This file provides stopwatch functionality.
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

// TODO: Improvements:
// - revisit this impl for efficiency and use of Foundation... perhaps instead of NSDate there is a 
//        better way to get ellapsed time.
// - make this thread safe, allow for multiple stopwatches, etc... e.g. have tic return a key, like
//        a UUID, which toc could then pass in to retrieve the time ellapsed since particular tic

// TODO: Do we really want to use formatter here? Seems overkill
// Time display settings
fileprivate var formatSetup = false
fileprivate let stopwatchFormat = NumberFormatter()

// Start of ellapsed time interval used by tic/toc
fileprivate var _stopwatch = Date()

/// Restart a stopwatch timer for measuring performance. Ellapsed time since starting the stopwatch 
/// is measured using the toc() function. 
///
/// Note: the stopwatch is automatically started at runtime; to accurately time a particular code 
///    segment, the stopwatch should be reset at the start of the segment using tic().
@available(OSX 10.12, *) // TODO: remove after getting rid of use of UnitDuration in toc
public func tic()
{
    _stopwatch = Date()

    if !formatSetup
    {
        stopwatchFormat.usesSignificantDigits = true
        stopwatchFormat.maximumSignificantDigits = 5
    }
}

// TODO: format printed time to only have some number of decimal places

/// Measure the ellapsed time since the last call to tic() was made and display to the console.
///
/// This function is useful when the caller doesn't want to store the ellapsed time and wants to
/// avoid compiler warnings about unused returns.
///
/// - Parameters:
///     - units: units of time to display result in; seconds by default
@available(OSX 10.12, *) // TODO: remove after getting rid of use of UnitDuration in toc
public func toc(_ units: UnitDuration = .seconds)
{
    // Calling through to more generic toc function would reduce repeated code but introduce another
    // function call, reducing the accuracy of the stopwatch. Such a small amount of repeated code
    // seems worth it in this case.

    let stop = Date()
    var ellapsed = Measurement<UnitDuration>(value: stop.timeIntervalSince(_stopwatch),
        unit: .seconds)
    ellapsed.convert(to: units)
    
    let fmt = stopwatchFormat.string(from: NSNumber(value: ellapsed.value)) ?? "ERROR!"
    print("Ellapsed time: \(fmt) \(ellapsed.unit.symbol)")
}

/// Measure the ellapsed time since the last call to tic() was made.
///
/// This function is useful when the caller needs to store the ellapsed time.
///
/// - Parameters:
///     - units: units of time to measure result in
///     - printing: optionally print ellapsed time to console; false by default
@available(OSX 10.12, *) // TODO: remove after getting rid of use of UnitDuration in toc
public func toc(returning units: UnitDuration, printing: Bool = false) -> Double
{
    let stop = Date()
    var ellapsed = Measurement<UnitDuration>(value: stop.timeIntervalSince(_stopwatch),
        unit: .seconds)
    ellapsed.convert(to: units)

    if printing
    {
        let fmt = stopwatchFormat.string(from: NSNumber(value: ellapsed.value)) ?? "ERROR!"
        print("Ellapsed time: \(fmt) \(ellapsed.unit.symbol)")
    }

    return ellapsed.value
}