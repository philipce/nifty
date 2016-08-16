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

/// Measure the ellapsed time since the stopwatch was started with sub-millisecond precision.
///
///	Supported time units are nanoseconds, microseconds, milliseconds, seconds, minutes, hours. All
///	units can be specified by full name or most common abbreviations and are case-insensitive.
///
/// If no parameters are provided, the default behavior is to return the time in seconds without
/// displaying the ellapsed time. When units are provided, the converted value will be returned,
///	as well as printed to the console.
///
/// - Parameters:
///     - units: units of time  to display result in; seconds by default
/// - Returns: the time on the stopwatch in the units specified, seconds be default
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

        let fmt = String(format: "%0.3f", arguments: [ellapsed])     
        print("Ellapsed time: \(fmt) \(descrip)")
    }

    return ellapsed
}