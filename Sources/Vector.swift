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
public struct Vector<Element>: TensorProtocol
{
    public let count: Int
    public var size: [Int]
    public var data: [Element]
    public var name: String?
    public var showName: Bool
    public var format: NumberFormatter

    //----------------------------------------------------------------------------------------------
    // MARK: INITIALIZE
    //----------------------------------------------------------------------------------------------
    
    public init(_ size: [Int], _ data: [Element], name: String? = nil, showName: Bool? = nil)
    {
        precondition(size.count == 1, "Vector must have 1 dimension")
        precondition(size[0] == data.count, "Vector size must match given data")
        self.init(data, name: name, showName: showName)
    }
    
    public init(_ size: [Int], value: Element, name: String? = nil, showName: Bool? = nil)
    {
        precondition(size.count == 1, "Vector must have 1 dimension")
        self.init(size[0], value: value, name: name, showName: showName)
    }
    
    public init<T>(_ t: T, name: String? = nil, showName: Bool? = nil) where T : TensorProtocol, Element == T.Element
    {
        self.init(t.data, name: name, showName: showName)
    }
    
    public init(_ rawDescription: String, name: String? = nil, showName: Bool? = nil)
    {
        // FIXME: implement
        fatalError("Not yet implemented")
    }
    
    /// Initialize a new vector from a list of data.
    ///
    /// - Parameters:
    ///    - data: ordered vector elements
    ///    - name: optional name of vector
    ///    - showName: determine whether to print the vector name; defaults to true if the vector is
    ///        given a name, otherwise to false
    public init(_ data: [Element], name: String? = nil, showName: Bool? = nil)
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

    /// Initialize a new vector with a repeated value.
    ///
    /// - Parameters:
    ///    - count: number of elements in vector
    ///    - value: single value repeated throughout vector
    ///    - name: optional name of vector
    ///    - showName: determine whether to print the vector name; defaults to true if the vector is
    ///        given a name, otherwise to false
    public init(_ count: Int, value: Element, name: String? = nil, showName: Bool? = nil)
    {
        precondition(count > 0, "Vector have at least 1 element")

        self.init(Array<Element>(repeating: value, count: count), name: name, showName: showName)
    }    

    //----------------------------------------------------------------------------------------------
    // MARK: SUBSCRIPT
    //----------------------------------------------------------------------------------------------

    /// Access a single element of the vector.
    ///
    /// - Parameters:
    ///     - s: index into vector
    /// - Returns: single value at index/subscript for get
    public subscript(_ index: Int) -> Element
    {
        get
        {
            precondition(index >= 0 && index < self.count, "Vector subscript out of bounds")
            return self.data[index]           
        }

        set(newVal)
        {
            precondition(index >= 0 && index < self.count, "Vector subscript out of bounds")
            self.data[index] = newVal            
        }
    }

    /// Access a slice of the the vector.
    ///
    /// - Parameters:
    ///     - s: range defining the vector slice
    /// - Returns: new vector composed of slice
    public subscript(_ s: SliceIndex) -> Vector<Element>
    {
        get 
        {
            let range = _convertToCountableClosedRange(s)

            // inherit name, add slice info
            var sliceName = self.name
            if sliceName != nil { sliceName = "\(_parenthesizeExpression(sliceName!))[\(s)]" }

            return Vector(Array(self.data[range]), name: sliceName, showName: self.showName)
        }
        set(newVal) 
        { 
            let range = _convertToCountableClosedRange(s)
            self.data[range] = ArraySlice(newVal.data)

            return
        }
    }
    
    //----------------------------------------------------------------------------------------------
    // MARK: DISPLAY
    //----------------------------------------------------------------------------------------------

    /// Return vector contents in an easily readable format.
    ///
    /// - Note: The formatter associated with this vector is used as a suggestion; elements may be
    ///    formatted differently to improve readability. Elements that can't be displayed under the 
    ///    current formatting constraints will be displayed as '#'; non-numeric elements may be 
    ///    abbreviated by truncating and appending "...".    
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
            let el = self[i]         
            let s = _formatElement(el, self.format)
            elements.append(s)
        }

        return "\(title)<\(elements.joined(separator: "   "))>"
    }

    /// Return vector representation in unformatted, comma separated list.
    public var rawDescription: String
    {    
        return (self.data.map({"\($0)"})).joined(separator: ",")
    }
}
