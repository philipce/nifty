/**************************************************************************************************
 *  cross.swift
 *
 *  This file defines vector cross product functionality. 
 *
 *  Author: Philip Erickson
 *  Creation Date: 29 Dec 2016
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

/// Compute the cross product of two vectors.
///
/// - Parameters:
///    - a: first vector
///    - b: second vector
/// - Returns: cross product of given vectors
public func cross(_ a: Vector<Double>, _ b: Vector<Double>) -> Vector<Double>
{
    precondition(a.count == 3 && b.count == 3, "The cross product requires A and B be of length 3")

    let s1 = a[1]*b[2] - a[2]*b[1]
    let s2 = a[2]*b[0] - a[0]*b[2]
    let s3 = a[0]*b[1] - a[1]*b[0]

    var name: String? = nil
    var showName: Bool? = nil
    if let nameA = a.name, let nameB = b.name
    {
        name = "cross\(nameA, nameB)"
        showName = a.showName && b.showName
    }

    return Vector([s1, s2, s3], name: name, showName: showName)
}

