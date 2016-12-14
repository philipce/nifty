/***************************************************************************************************
 *  Tensor.swift
 *
 *  This file defines the Tensor data structure, an n-dimensional array. 
 *
 *  Author: Philip Erickson
 *  Creation Date: 12 Dec 2016
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

/// Data structure for an N-D, row-major order array.
public struct Tensor: CustomStringConvertible
{
    /// Number of elements in the tensor.
    public let count: Int

    /// Number of elements in each dimension of the tensor.
    public var size: [Int]

    /// Data contained in tensor in row-major order.
    public var data: [Double]

    /// Optional name of tensor (e.g., for use in display).
    public var name: String?

    /// Determine whether to show name when displaying tensor.
    public var showName: Bool

    /// Formatter to be used in displaying tensor elements.
    public var format: NumberFormatter

    /// Initialize a new tensor.
    ///
    /// - Parameters:
    ///    - size: number of elements in each dimension of the tensor
    ///    - data: tensor data in row-major order
    ///    - name: optional name of tensor
    ///    - showName: determine whether to print the tensor name; false by default
    public init(_ size: [Int], data: [Double], name: String? = nil, showName: Bool = false)
    {       
        let n = size.reduce(1, *)

        precondition(n > 0, "Tensor must have at least 1 element")
        precondition((size.filter({$0 <= 0})).count == 0, "Tensor must have all dimensions > 0")
        precondition(data.count == n, "Tensor dimensions must match data")

        self.size = size
        self.count = n
        self.data = data    
        self.name = name    
        self.showName = showName

        // default display settings
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.usesSignificantDigits = true
        fmt.paddingCharacter = " "
        fmt.paddingPosition = .afterSuffix
        fmt.formatWidth = 8
        self.format = fmt
    }
  
    // TODO: this constructor causes the compiler grief
    /*
    public init(_ size: Int..., data: [Double], name: String? = nil, showName: Bool = false)
    {    
        self.init(size, data: data, name: name, showName: showName)
    }
    */

    /// Initialize a new tensor.
    ///
    /// - Parameters:
    ///    - size: number of elements in each dimension of the tensor
    ///    - value: single value repeated throughout tensor
    ///    - name: optional name of tensor
    ///    - showName: determine whether to print the tensor name; false by default
    public init(_ size: [Int], value: Double, name: String? = nil, showName: Bool = false)
    {
        let n = size.reduce(1, *)
        let data = Array<Double>(repeating: value, count: abs(n))
        self.init(size, data: data, name: name, showName: showName)
    }
    
    // TODO: this constructor causes the compiler grief
    /*
    public init(_ size: Int..., value: Double, name: String? = nil, showName: Bool = false)
    {
        self.init(size, value: value, name: name, showName: showName)
    }
    */       
    
    /// Initialize a new tensor, copying given data structure and possibly renaming.
    ///
    /// - Parameters:
    ///    - copy: data to copy
    ///    - rename: optional name of new tensor
    ///    - showName: determine whether to print the tensor name; false by default
    public init(copy: Tensor, rename: String? = nil, showName: Bool = false)
    {
        self.count = copy.count
        self.size = copy.size
        self.data = copy.data
        self.name = rename
        self.showName = copy.showName
        self.format = copy.format
    }

    public init(copy: Matrix, rename: String? = nil, showName: Bool = false)
    {
        self.count = copy.count
        self.size = copy.size
        self.data = copy.data
        self.name = rename
        self.showName = copy.showName
        self.format = copy.format
    }

    public init(copy: Vector, rename: String? = nil, showName: Bool = false)
    {
        self.count = copy.count
        self.size = copy.size
        self.data = copy.data
        self.name = rename
        self.showName = copy.showName
        self.format = copy.format
    }

    /// Access a single element of the tensor with a n-dimensional subscript.
    ///
    /// - Parameters:
    ///    - s: n-dimensional subscript
    /// - Returns: single value at subscript
    public subscript(_ s: Int...) -> Double
    {
        get
        {
            fatalError("Not yet implemented")
        }

        set(newVal)
        {
            fatalError("Not yet implemented")
        }
    }

    /// Access a single element of the tensor with a row-major linear index.
    ///
    /// - Parameters:
    ///    - index: linear index into matrix
    /// - Returns: single value at index
    public subscript(_ index: Int) -> Double
    {
        get
        {
            precondition(index >= 0 && index < self.count, "Tensor index \(index) out of bounds")
            return self.data[index]            
        }

        set(newVal)
        {
            precondition(index >= 0 && index < self.count, "Tensor index \(index) out of bounds")
            self.data[index] = newVal
        }

    }

    /// Access a slice of the tensor with an n-dimensional subscript range.
    ///
    /// - Parameters:
    ///    - s: subscript range
    /// - Returns: new matrix composed of slice
    public subscript(_ s: SliceIndex...) -> Tensor
    {
        get 
        { 
            fatalError("Not yet implemented")
        }

        set(newVal)
        {
            fatalError("Not yet implemented")
        }
    }

    /// Access a slice of the tensor with a row-major linear index range.
    ///
    /// - Parameters:
    ///    - index: linear index range 
    /// - Returns: new tensor composed of slice
    public subscript(_ index: SliceIndex) -> Tensor
    {
        get
        {
            let range = (_convertToCountableClosedRanges([index]))[0]

            // inherit name, add slice info
            var sliceName = self.name
            if sliceName != nil { sliceName! += "[\(index)]" }

            let d = Array(self.data[range])
            return Tensor([1, d.count], data: d, name: sliceName, showName: self.showName)
        }
        set(newVal)
        {
            let range = (_convertToCountableClosedRanges([index]))[0]
            self.data[range] = ArraySlice(newVal.data)

            return
        }
    }

    // TODO: add setter that can take a matrix or vector too

    /// Return tensor contents in an easily readable grid format.
    ///
    /// - Note: The formatter associated with this tensor is used as a suggestion; elements may be
    ///     formatted differently to improve readability. Elements that can't be displayed under the 
    ///     current formatting constraints will be displayed as '#'.    
    /// - Returns: string representation of tensor
    public var description: String
    {
       // FIXME: implement properly
       return "\(self.data)"
    }    
}