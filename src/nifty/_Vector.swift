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

/*
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
    public let format: String?

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
    public subscript(_ s: Int...) -> Double
    {
        get
        {
            precondition(_isValidIndex(s[0]), "Invalid matrix index: \(s[0])")
            return self.data[s[0]]           
        }

        set(newVal)
        {
            precondition(_isValidIndex(s[0]), "Invalid matrix index: \(s[0])")
            self.data[s[0]] = newVal            
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
        // TODO: pad vector cells so everything is evenly spaced, use vector fmt string
        
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
            str += "\(self[1])  "                      
        }

        return str
    }
}
*/