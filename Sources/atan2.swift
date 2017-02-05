/***************************************************************************************************
 *  atan2.swift
 *
 *  This file provides 4-quadrant inverse tangent functionality.
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

/// This function computes the arc tangent of y/x, but the signs of both 
/// arguments are used to determine the quadrant of the result, and x is 
/// permitted to be zero. The return value is given in radians and is in the 
/// range -pi to pi, inclusive.
/// 
/// If x and y are coordinates of a point in the plane, atan2 returns the 
/// signed angle between the line from the origin to that point and the x-axis. 
/// Thus, atan2 is useful for converting Cartesian coordinates to polar 
/// coordinates.

#if os(Linux)
@_exported import func Glibc.atan2
#else
@_exported import func Darwin.atan2
#endif

// TODO: how to overload this for vector, matrix, tensor? Take 2 of each and use each as x and y?