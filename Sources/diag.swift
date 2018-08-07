/***************************************************************************************************
 *  diag.swift
 *
 *  This file provides functionality for creating or retrieving the diagonal of a matrix.
 *
 *  Author: Tor Rafsol Løseth
 *  Creation Date: 07 Jul 2018
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
 *  Copyright 2018 Tor Rafsol Løseth
 **************************************************************************************************/


/// Returns a square diagonal matrix with the elements of vector v on the main diagonal,
/// and zeros everywhere else.
///
/// - Parameter v   : A vector data structure
/// - Returns: A matrix data structure
public func diag(v: Vector<Double>) -> Matrix<Double>
{
    return diag(v: v, k: 0)
}


/// Returns a square diagonal matrix with the elements of vector v on the kth diagonal,
/// and zeros everywhere else.
///
/// - Parameters:
///   - v: A vector data structure.
///   - k: The kth diagonal, k = 0 is the main diagonal, k > 0 is above the main diagonal, and k < 0 is below the main diagonal.
/// - Returns: A square matrix data structure.
public func diag(v: Vector<Double>, k: Int) -> Matrix<Double>
{
    
    let length = v.count + abs(k)
    let A = Matrix(length, length, value: 0.0)
    var data = A.data
    
    // Diagonals have indices intervals at every other:
    let interval = A.rows + 1
    
    let diagonalStartIndex = k >= 0 ? k : length * abs(k)
    
    let vectorIndices = (0..<v.count).map {index in
        diagonalStartIndex + (index * interval)
    }

    vectorIndices.enumerated().forEach {(index, value) in
        data[value] = v.data[index]
    }
    
    return Matrix(length, length, data)
}


/// Returns a vector data structure with the elements from the main diagonal of a square matrix.
///
/// - Parameter A: A square matrix data structure.
/// - Returns: A vector structure with diagonal elements.
public func diag(A: Matrix<Double>) -> Vector<Double>
 {
    return diag(A: A, k: 0)
 }


/// Returns a vector data structure with the elements from the kth diagonal of a square matrix.
///
/// - Parameters:
///   - A: A square matrix data structure.
///   - k: The kth diagonal, k = 0 is the main diagonal, k > 0 is above the main diagonal, and k < 0 is below the main diagonal.
/// - Returns: A vector data structure.
public func diag(A: Matrix<Double>, k: Int) -> Vector<Double> {
    
    precondition(A.rows == A.columns, "Matrix must be square")
    precondition(k < abs(A.rows), "abs(k) must be less than the the A dimensions")
    
    var data = A.data
    
    // Diagonals have indices intervals at every other:
    let interval = A.rows + 1
    
    let diagonalStartIndex = k >= 0 ? k : A.rows * abs(k)
    let diagonalEndIndex = k >= 0 ? (data.count - (A.rows * k)) : data.count - abs(k)
    
    // NB! Remove upper before lower (data.count changes)
    let rangeUpper = Range(diagonalEndIndex..<data.count)
    data.removeSubrange(rangeUpper)
    let rangeLower = Range(0..<diagonalStartIndex)
    data.removeSubrange(rangeLower)
    
    let indices = data.indices.filter {$0 % interval == 0}
    let values = indices.map {data[$0]}
    
    return Vector(values)
}
