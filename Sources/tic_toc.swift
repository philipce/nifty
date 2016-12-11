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

// TODO: Improvements:
// - make this thread safe, allow for multiple stopwatches, etc... e.g. have tic return a key, like
//        a UUID, which toc could then pass in to retrieve the time ellapsed since particular tic
// - do we really want to use formatter here? Seems overkill

import Foundation

// Time display settings
fileprivate var formatSetup = false
fileprivate let stopwatchFormat = NumberFormatter()

// Start of ellapsed time interval used by tic/toc
fileprivate var _stopwatch = Date()

/// Restart a stopwatch timer for measuring performance. Ellapsed time since starting the stopwatch 
/// is measured using the toc() function. 
///
/// Note: the stopwatch is automatically started at runtime; to accurately time a particular code 
/// segment, the stopwatch should be reset at the start of the segment using tic().
public func tic()
{
    _stopwatch = Date()

    if !formatSetup
    {
        stopwatchFormat.usesSignificantDigits = true
        stopwatchFormat.maximumSignificantDigits = 5
    }
}

/// Measure the ellapsed time since the last call to tic() was made and display to the console.
///
/// - Parameters:
///     - units: units of time to display result in; seconds by default
public func toc(_ units: StopwatchUnit = .seconds)
{
    // Calling through to more generic toc function would reduce repeated code but introduce another
    // function call, reducing the accuracy of the stopwatch. Such a small amount of repeated code
    // seems worth it in this case.

    let stop = Date()
    let ellapsed_secs = Double(stop.timeIntervalSince(_stopwatch))
    let ellapsed = ellapsed_secs * units.rawValue
    
    let fmt = stopwatchFormat.string(from: NSNumber(value: ellapsed)) ?? "ERROR!"
    print("Ellapsed time: \(fmt) \(units)")
}

/// Measure the ellapsed time since the last call to tic() was made and return the result.
///
/// - Parameters:
///     - returning units: units of time to return measured time in
///     - printing: optionally print ellapsed time to console; false by default
/// - Returns: ellapsed time in the specified units
public func toc(returning units: StopwatchUnit, printing: Bool = false) -> Double
{
    let stop = Date()
    let ellapsed_secs = Double(stop.timeIntervalSince(_stopwatch))
    let ellapsed = ellapsed_secs * units.rawValue

    if printing
    {
        let fmt = stopwatchFormat.string(from: NSNumber(value: ellapsed)) ?? "ERROR!"
        print("Ellapsed time: \(fmt) \(units)")
    }

    return ellapsed
}

/// Enumerate the units supported by the stopwatch, with a raw value that is the conversion
/// factor from seconds to the particular case.
///
/// Note: This enum is used instead of Foundation's UnitDuration for two reasons: 1) UnitDuration 
/// only has hours, minutes, and seconds, and 2) UnitDuration imposes availability constraints
/// on Mac.
public enum StopwatchUnit: Double
{
    case weeks    = 1.6534
    case days     = 1.1574E-5
    case hours    = 2.7777E-4
    case minutes  = 1.6666E-2
    case seconds  = 1.0
    case ms       = 1.0E3
    case us       = 1.0E6
    case ns       = 1.0E9
}