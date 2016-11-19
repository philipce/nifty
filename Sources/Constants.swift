/***************************************************************************************************
 *  Constants.swift
 *
 *  This file contains constant definitions useful throughout Nifty.
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

// TODO: determine better way to do this, e.g. static inside class so Nifty.Pi?

/// Default tolerance used for comparing decimal values.
public let DefaultDecimalTolerance = 1e-12

/// Special double values
public let NaN = Double.nan
public let Inf = Double.infinity

/// Pi
public let Pi = 3.141592653589793

/// Euler's number
public let E = 2.718281828459046
