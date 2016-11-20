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

/// Create a matrix with ones on the main diagonal and zeros elsewhere.
///
/// - Parameters:
///     - size: size of matrix to create
/// - Returns: specified matrix
public func eye(_ size: [Int]) -> Matrix
{   
    precondition(size.count == 2, "Only 2-D identity matrices are supported")
    
    var M = zeros(size)
    for d in 0..<size[0]
    {
        M[d,d] = 1
    }

    return M
}

public func eye(_ size: Int...) -> Matrix
{   
    return eye(size)
}

/// Create a square identity matrix of the given size.
///
/// - Parameters:
///     - size: edge size of identity matrix to create
/// - Returns: square identity matrix
public func eye(_ size: Int) -> Matrix
{
    return eye([size,size])
}

/// Return the scalar multiplicative identity.
///
/// - Returns: the scalar 1
public func eye() -> Int
{
	return 1
}


