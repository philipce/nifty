/***************************************************************************************************
 *  error.swift
 *
 *  This file provides functonality for signaling and handling errors.
 *
 *  Author: Philip Erickson
 *  Creation Date: 21 Feb 2017
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

// FIXME: flesh out error function--this is just a stub...

public func error(
    _ msg: String,
    handler: ((() -> Void)?) = nil,
    file: String = #file, 
    function: String = #function,
    line: Int = #line)
{
    print("Error: \(msg).\t[\(file), \(function), line \(line)]")
    
    if let h = handler { h() }
    else { fatalError() }    
}
