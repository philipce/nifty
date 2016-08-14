/*******************************************************************************
 *  isinf.swift
 *
 *  This file contains code for determining whether a value is infinite.
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

// TODO: extend this (and others, like isnan) to matrix versions

/// Returns whether the number is infinity or not.
///
/// - Parameters
///     - n: number
/// - Returns: true iff n is infinity
func isinf(_ n: Double) -> Bool
{
    return n.isInfinite
}
