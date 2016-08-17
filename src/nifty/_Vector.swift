/**************************************************************************************************
 *  Vector.swift
 *
 *  This file defines the Vector data structure. 
 *
 *  Author: Philip Erickson
 *  Creation Date: 14 Aug 2016
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

/// Data structure for a vector.
public struct Vector: CustomStringConvertible
{
    /// Number of elements in vector.
    public let numel: Int

    /// Size of vector (same as number of elements).
    public let size: Int

    /// Data contained in vector.
    public var data: [Double]

    /// Optional name of vector for use in display
    public let name: String?

    // TODO: add default format string for vector elements
    public let format: String? = nil

    /// Initialize a new vector.
    ///
    /// - Parameters:
    ///        - size: number of elements in vector
    ///        - value: single value repeated throughout vector
    ///        - name: optional name of vector
    public init(size: Int, value: Double, name: String? = nil)
    {
        precondition(size > 0, "Matrix have at least 1 element")

        self.numel = size
        self.size = size                 
        self.data = Array<Double>(repeating: value, count: size)    
        self.name = name                    
    }

    /// Initialize a new vector.
    ///
    /// - Parameters:
    ///        - size: number of elements in vector
    ///        - value: single value repeated throughout vector
    ///        - name: optional name of vector
    public init(size: Int, data: [Double], name: String? = nil)
    {
        precondition(size > 0, "Matrix have at least 1 element")

        self.numel = size
        self.size = size                 
        self.data = data
        self.name = name                    
    }

    /// Access a single element of the vector.
    ///
    /// - Parameters:
    ///     - s: index into vector
    /// - Returns: single value at index/subscript for get
    public subscript(_ s: Int) -> Double
    {
        get
        {
            precondition(_isValidIndex(s), "Invalid matrix index: \(s)")
            return self.data[s]           
        }

        set(newVal)
        {
            precondition(_isValidIndex(s), "Invalid matrix index: \(s)")
            self.data[s] = newVal            
        }
    }

    /// Access a slice of the the vector.
    ///
    /// - Parameters:
    ///     - s: index or range defining the vector slice
    /// - Returns: new vector composed of slice
    public subscript(_ s: Slice) -> Vector
    {
        get { assert(false, "Unimplemented"); return self }
        set { assert(false, "Unimplemented")}
    }

    /// Return vector contents in an easily readable format.
    ///
    /// - Returns: string representation of vector
    public var description: String
    {
        // TODO: pad vector cells so everything is evenly spaced
        // TODO: use vector fmt string specific to this vector to determine how many digits and 
        // decimal places to display. (do this for matrix and tensor also)
        
        var str = "\(self.size)-D vector"
        if let name = self.name
        {
            str += " \(name):\n"
        }
        else
        {
            str += ":\n"
        }
        
        for i in 0..<self.size
        {
            str += "\(self[i])  "                      
        }

        return str
    }

    //==========================================================================
    // MARK: PRIVATE HELPERS
    //==========================================================================

    /// Determine whether a given index is valid for this vector.
    ///
    /// - Parameters:
    ///        - i: index to check
    ///    - Returns: true if index is valid, else false 
    private func _isValidIndex(_ i: Int) -> Bool
    {
        // FIXME:
        assert(false, "Unimplemented")
        return true
    }

    /// Determine whether a given slice is valid for this vector.
    ///
    /// - Parameters:
    ///        - s: slice to check
    ///    - Returns: true if slice is valid, else false
    private func _isValidSlice(_ s: Slice) -> Bool
    {
        // FIXME:
        assert(false, "Unimplemented")
        return true
    }
}