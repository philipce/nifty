/**************************************************************************************************
 *  Nifty.swift
 *
 *  This file provides a class for namespacing options and constants.
 *
 *  Author: Philip Erickson
 *  Creation Date: 1 Jan 2017
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
 *  Copyright 2017 Philip Erickson
 **************************************************************************************************/


public class Nifty
{
    /// Contains all options used throughout Nifty.
    ///
    /// Options are name for the function that uses them, and are either enums, or structs wrapping 
    /// enums to provide another level of hierarchy.
    ///
    /// Options that don't clearly belong to a particular source file may be defined here. Or, if there 
    /// is a clear correspondence, and extension to this struct may be made in that file.
    public class Options
    {

    }

    /// Contains constant definitions used throughout Nifty.
    public class Constants
    {
        public static let e   = 2.718281828459046
        public static let phi = 1.618033988749895
        public static let pi  = 3.141592653589793        
    }
}