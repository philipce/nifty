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

import Foundation

/// Data structure for a vector.
public struct Vector<T>: CustomStringConvertible
{
    /// Number of elements in vector.
    public let count: Int

    /// Size of vector (same as number of elements).
    public let size: [Int]

    /// Data contained in vector.
    public var data: [T]

    /// Optional name of vector for use in display
    public var name: String?

    /// Determine whether to show name when displaying matrx.
    public var showName: Bool

    /// Formatter to be used in displaying matrix elements.
    public var format: NumberFormatter

    /// Initialize a new vector.
    ///
    /// - Parameters:
    ///    - data: ordered vector elements
    ///    - name: optional name of vector
    ///    - showName: determine whether to print the vector name; defaults to true if the vector is
    ///        given a name, otherwise to false
    public init(_ data: [T], name: String? = nil, showName: Bool? = nil)
    {
        precondition(data.count > 0, "Vector have at least 1 element")

        self.count = data.count
        self.size = [data.count]
        self.data = data
        self.name = name
        
        if let show = showName
        {
            self.showName = show
        }
        else
        {
            self.showName = name != nil
        }

        // default display settings
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.usesSignificantDigits = true
        fmt.paddingCharacter = " "
        fmt.paddingPosition = .afterSuffix
        fmt.formatWidth = 8
        self.format = fmt                  
    }

    /// Initialize a new vector.
    ///
    /// - Parameters:
    ///    - count: number of elements in vector
    ///    - value: single value repeated throughout vector
    ///    - name: optional name of vector
    ///    - showName: determine whether to print the vector name; defaults to true if the vector is
    ///        given a name, otherwise to false
    public init(_ count: Int, value: T, name: String? = nil, showName: Bool? = nil)
    {
        precondition(count > 0, "Vector have at least 1 element")

        self.init(Array<T>(repeating: value, count: count), name: name, showName: showName)
    }    

    /// Initialize a new vector, copying given vector and possibly renaming.
    ///
    /// - Parameters:
    ///    - copy: vector to copy
    ///    - rename: optional name of new vector
    ///    - showName: determine whether to print the vector name; defaults to true if the vector is
    ///        being renamed, otherwise to false
    public init(copy: Vector, rename: String? = nil, showName: Bool? = nil)
    {
        self.count = copy.count
        self.size = copy.size
        self.data = copy.data
        self.name = rename

        if let show = showName
        {
            self.showName = show
        }
        else
        {
            self.showName = rename != nil
        }

        self.format = copy.format
    }

    /// Vectorize a given matrix to form a new vector.
    ///
    /// - Parameters:
    ///    - matrix: matrix to vectorize
    ///    - rename: optional name of new vector
    ///    - showName: determine whether to print the vector name; defaults to true if the vector is
    ///        being renamed, otherwise to false
    public init(_ matrix: Matrix<T>, rename: String? = nil, showName: Bool? = nil)
    {
        self.init(matrix.data, name: rename, showName: showName)
    }

    /// Access a single element of the vector.
    ///
    /// - Parameters:
    ///     - s: index into vector
    /// - Returns: single value at index/subscript for get
    public subscript(_ s: Int) -> T
    {
        get
        {
            precondition(s >= 0 && s < self.count, "Invalid vector index: \(s)")
            return self.data[s]           
        }

        set(newVal)
        {
            precondition(s >= 0 && s < self.count, "Invalid vector index: \(s)")
            self.data[s] = newVal            
        }
    }

    /// Access a slice of the the vector.
    ///
    /// - Parameters:
    ///     - s: range defining the vector slice
    /// - Returns: new vector composed of slice
    public subscript(_ s: SliceIndex) -> Vector<T>
    {
        get 
        {
            let range = (_convertToCountableClosedRanges([s]))[0]

            // inherit name, add slice info
            var sliceName = self.name
            if sliceName != nil { sliceName! += "[\(s)]" }

            return Vector(Array(self.data[range]), name: sliceName, showName: self.showName)
        }
        set(newVal) 
        { 
            let range = (_convertToCountableClosedRanges([s]))[0]            
            self.data[range] = ArraySlice(newVal.data)

            return
        }
    }

    // TODO: add setter that can take a matrix or tensor too


    // TODO: add CSV option that spits out matrix in easily readable .csv format (i.e. don't print
    // surrounding brackets, extra space, etc.)

    /// Return vector contents in an easily readable format.
    ///
    /// - Note: The formatter associated with this vector is used as a suggestion; elements may be
    ///    formatted differently to improve readability. Elements that can't be displayed under the 
    ///    current formatting constraints will be displayed as '#'.    
    /// - Returns: string representation of vector
    public var description: String
    {
        var elements = [String]()

        // create vector title
        var title = ""
        if self.showName
        {
            title = (self.name ?? "\(self.count)D vector") + ": "
        }

        // create string representation of each vector element
        for i in 0..<self.count
        {
            if let el = self[i] as? Double
            {
                var s = self.format.string(from: NSNumber(value: abs(el))) ?? "#"

                // if element doesn't fit in desired width, format in minimal notation
                if s.characters.count > self.format.formatWidth            
                {
                    let oldMaxSigDig = self.format.maximumSignificantDigits
                    let oldNumberStyle = self.format.numberStyle
                    self.format.maximumSignificantDigits = self.format.formatWidth-4 // for 'E-99'
                    self.format.numberStyle = .scientific
                    s = self.format.string(from: NSNumber(value: abs(el))) ?? "#"
                    self.format.maximumSignificantDigits = oldMaxSigDig
                    self.format.numberStyle = oldNumberStyle
                }

                let sign = el < 0 ? "-" : " "
                s = sign + s
                s = s.trimmingCharacters(in: .whitespaces)

                elements.append(s)
            }
            else
            {
                // FIXME: Improve printing for non double types
                elements.append("\(self[i])")
            }
        }

        return "\(title)<\(elements.joined(separator: "   "))>"
    }
}