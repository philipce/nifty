/***************************************************************************************************
 *  eye.swift
 *
 *  This file provides functionality for obtaining an identity matrix.
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

// TODO: remove the optional column... maybe a vector wants an eye function?

/// Create a matrix with ones on the main diagonal and zeros elsewhere.
///
/// - Parameters:
///    - rows: number of rows; or edge length in square matrix if columns is nil
///    - columns: number of columns; if nil, return square identity matrix
/// - Returns: identity matrix of specified size
public func eye(_ rows: Int, _ columns: Int? = nil) -> Matrix<Double>
{   
    let cols = columns ?? rows

    precondition(rows > 0 && cols > 0, "Invalid matrix dimensions: \([rows, cols])")
    
    var M = zeros(rows, cols)
    for d in 0..<rows
    {
        M[d,d] = 1
    }

    return M
}

public func eye(_ size: [Int]) -> Matrix<Double>
{
    precondition(size.count == 2, "Matrix size must be 2 dimensional")
    return eye(size[0], size[1])
}

/// Return the scalar multiplicative identity.
///
/// - Returns: the scalar 1
public func eye() -> Double
{
	return 1.0
}