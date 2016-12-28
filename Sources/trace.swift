/***************************************************************************************************
 *  trace.swift
 *
 *  This file provides functionality for computing the trace of a matrix.
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

/// Compute the trace of a matrix.
///
/// - Parameters:
///     - A: matrix to compute trace of
/// - Returns: sum of the elements on the main diagonal
public func trace(_ A: Matrix<Double>) -> Double
{
    precondition(size(A,0) == size(A,1), "Trace only applies to square matrix")

    var tr = 0.0
    for i in 0..<size(A,0)
    {
        tr += A[i,i]
    }

    return tr
}