/***************************************************************************************************
 *  hypot.swift
 *
 *  This file provides functionality for computing a hypotenuse.
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

/// Return sqrt(x*x+y*y). This is the length of the hypotenuse of a right 
/// triangle with sides of length x and y, or the distance of the point 
/// (x, y) from the origin. Using this function instead of the direct formula 
/// is wise, since the error is much smaller. 

#if os(Linux)
@_exported import func Glibc.hypot
#else
@_exported import func Darwin.hypot
#endif
