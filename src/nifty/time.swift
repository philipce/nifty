/*******************************************************************************
 *  time.swift
 *
 *  This file provides functions for measuring ellapsed time.
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

import Foundation

// TODO: revisit this impl for efficiency and use of Foundation
// TODO: make this thread safe... e.g. have tic return a key, pass that key
// to toc to retrieve the appropriate time

/// Start of ellapsed time interval used by tic/toc
private var _stopwatch = NSDate()

/// Restart a stopwatch timer for measuring performance. Ellapsed time since
/// starting the stopwatch is measured using the toc() function. 
///
/// Note: the stopwatch is automatically started at runtime; to accurately 
/// time a particular code segment, the stopwatch should be reset at the 
/// start of the segment using tic().
public func tic()
{
    _stopwatch = NSDate()
}

/// Measure the ellapsed time since the stopwatch was started with
/// sub-millisecond precision.
///
/// - Parameters:
///     - units: (optional) units of time (nanoseconds, microseconds, 
///         milliseconds, seconds, minutes, hours) to display result in; result 
///         not displayed if nil
/// - Returns: the number of seconds on the stopwatch
public func toc(units: String? = nil) -> Double
{
    let stop = NSDate()
    var ellapsed: Double = stop.timeIntervalSince(_stopwatch) 

    if units != nil
    {
        var descrip: String
        switch units!.lowercased()
        {
            case "ns", "nano", "nanosecond", "nanoseconds":
                descrip = "nanoseconds"
                ellapsed *= 1e9     
            case "us", "micro", "microsecond", "microseconds":
                descrip = "microseconds"
                ellapsed *= 1e6
            case "ms", "milli", "millis", "millisecond", "milliseconds":
                descrip = "milliseconds"
                ellapsed *= 1e3
            case "s", "sec", "secs", "second", "seconds":
                descrip = "seconds"
            case "m", "min", "minute", "minutes":
                descrip = "minutes"
                ellapsed /= 60
            case "h", "hr", "hour", "hours":
                descrip = "hours"
                ellapsed /= 3600
            default:
                descrip = "units"
        }

        let disp = "\(round(ellapsed*1000)/1000.0)" // TODO: string format not yet impl on linux
        print("Ellapsed time: \(disp) \(descrip)")
    }

    return ellapsed
}
