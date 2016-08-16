/*******************************************************************************
 *  toc.swift
 *
 *  This file provides functions for stopping an ellapsed time stopwatch.
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

/// Measure the ellapsed time since the stopwatch was started with
/// sub-millisecond precision.
///
/// - Parameters:
///     - units: (optional) units of time (nanoseconds, microseconds, 
///         milliseconds, seconds, minutes, hours) to display result in; result 
///         not displayed if nil
/// - Returns: the time on the stopwatch, in the units specified, or in seconds
///     if none is specified
public func toc(units: String? = nil) -> Double
{
    // TODO: add options parameter to allow dictionary of options, e.g.
    // toc(options: ["units":"ms", "display":"off"])

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