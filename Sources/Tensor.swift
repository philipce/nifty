/***************************************************************************************************
 *  Tensor.swift
 *
 *  This file defines the Tensor data structure, a multidimensional array.
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

/// Data structure for a multidimensional, row-major order array.
public struct Tensor<Element>: TensorProtocol
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
        let n = size.reduce(1, *)

        precondition(n > 0, "Tensor must have at least 1 element")
        precondition((size.filter({$0 <= 0})).count == 0, "Tensor must have all dimensions > 0")
        precondition(data.count == n, "Tensor dimensions must match data")

        self.size = size
        self.count = n
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

    public init(_ size: [Int], value: Element, name: String? = nil, showName: Bool? = nil)
    {
        let n = size.reduce(1, *)
        precondition(n > 0, "Tensor must contain at least one element")
        let data = Array<Element>(repeating: value, count: n)
        self.init(size, data, name: name, showName: showName)
    }
   
    public init<T>(_ t: T, name: String? = nil, showName: Bool? = nil) where T : TensorProtocol, Element == T.Element
    {
        self.init(t.size, t.data, name: name, showName: showName)
    }
    
    public init(_ rawDescription: String, name: String? = nil, showName: Bool? = nil)
    {
        // FIXME: implement
        fatalError("Not yet implemented")
    }
   
    //----------------------------------------------------------------------------------------------
    // MARK: SUBSCRIPT
    //----------------------------------------------------------------------------------------------

    /// Access a single element of the tensor with a subscript.
    ///
    /// If only one subscript is given, it is interpretted as a row-major order linear index.
    /// Otherwise, the given subscripts are treated as indexes into each dimension.
    ///
    /// - Parameters:
    ///    - s: subscripts
    /// - Returns: single value at index
    public subscript(_ s: [Int]) -> Element
    {
        get
        {
            assert(s.count > 0)

            if s.count == 1
            {
                return self.getValue(index: s[0])
            }
            else
            {
                return self.getValue(subscripts: s)
            }
        }

        set(newValue)
        {    
            assert(s.count > 0)

            if s.count == 1
            {
                self.setValue(index: s[0], value: newValue)
            }
            else
            {
                self.setValue(subscripts: s, value: newValue)
            }
        }
    }
    
    public subscript(_ s: Int...) -> Element
    {
        get { return self[s] }
        set(newValue) { self[s] = newValue }
    }
    
    /// Access a slice of the tensor with a subscript range.
    ///
    /// If only one range is given, it is interpretted as a row-major order linear index. Otherwise,
    /// the given subscripts are treated as indexes into each dimension.
    ///
    /// - Parameters:
    ///    - s: subscripts
    /// - Returns: new tensor composed of slice
    public subscript(_ s: SliceIndex...) -> Tensor<Element>
    {
        get
        {
            assert(s.count > 0)
            
            if s.count == 1
            {
                return self.getSlice(index: s[0])
            }
            else
            {
                return self.getSlice(subscripts: s)
            }
        }
        
        set(newValue)
        {
            assert(s.count > 0)
            
            if s.count == 1
            {
                self.setSlice(index: s[0], value: newValue)
            }
            else
            {
                self.setSlice(subscripts: s, value: newValue)
            }
        }
    }

    private func getValue(index: Int) -> Element
    {
        precondition(index >= 0 && index < self.count, "Tensor subscript out of bounds")
        return self.data[index]            
    }

    private mutating func setValue(index: Int, value: Element)
    {
        precondition(index >= 0 && index < self.count, "Tensor subscript out of bounds")
        self.data[index] = value
    }

    private func getValue(subscripts: [Int]) -> Element
    {
        let index = sub2ind(subscripts, size: self.size)
        precondition(index >= 0, "Tensor subscript out of bounds")
        return self.data[index]
    }

    private mutating func setValue(subscripts: [Int], value: Element)
    {
        let index = sub2ind(subscripts, size: self.size)
        precondition(index >= 0, "Tensor subscript out of bounds")
        self.data[index] = value
    }   

    private func getSlice(index: SliceIndex) -> Tensor<Element>
    {
        let range = _convertToCountableClosedRange(index)

        // inherit name, add slice info
        var sliceName = self.name     
        if sliceName != nil { sliceName = "\(_parenthesizeExpression(sliceName!))[\(index)]" }
      
        let d = Array(self.data[range])
        return Tensor([1, d.count], d, name: sliceName, showName: self.showName)
    }

    private mutating func setSlice(index: SliceIndex, value: Tensor<Element>)
    {
        // FIXME: there's no shape checking here! E.g. a [1,1,4] slice could 
        // be assigned a [1,2,2] Tensor. How should that be handled?
        let range = _convertToCountableClosedRange(index)
        self.data[range] = ArraySlice(value.data)
    } 

    private func getSlice(subscripts: [SliceIndex]) -> Tensor<Element>
    {        
        let ranges = _convertToCountableClosedRanges(subscripts)

        precondition(ranges.count == self.size.count, "Subscript must match tensor dimension")

        // determine size of resulting tensor slice, and start/end subscripts to read
        var newSize = [Int](repeating: 0, count: ranges.count)
        var startSub = [Int](repeating: 0, count: ranges.count)
        var endSub = [Int](repeating: 0, count: ranges.count)
        for (i, range) in ranges.enumerated()
        {
            newSize[i] = range.count                
            startSub[i] = range.lowerBound
            endSub[i] = range.upperBound
        }    

        // start reading from tensor, rolling over each dimension
        var newData = [Element]()
        var curSub = startSub
        while true
        {
            newData.append(self.getValue(subscripts: curSub))
            guard let inc = _cascadeIncrementSubscript(curSub, min: startSub, max: endSub) else
            {
                break
            }

            curSub = inc
        }        

        // inherit name, add slice info
        var sliceName = self.name
        if sliceName != nil 
        { 
            // closed countable ranges print with quotes around them, which clutters display
            let subsDescrip = "\((subscripts.map({"\($0)"})))".replacingOccurrences(of: "\"", with: "")
            sliceName = "\(_parenthesizeExpression(sliceName!))\(subsDescrip)" 
        }

        return Tensor(newSize, newData, name: sliceName, showName: self.showName)        
    }

    private mutating func setSlice(subscripts: [SliceIndex], value: Tensor<Element>)
    {
        let ranges = _convertToCountableClosedRanges(subscripts)

        precondition(ranges.count == self.size.count, "Subscript must match tensor dimension")

        // determine range of writes in each dimension
        var startSub = [Int](repeating: 0, count: ranges.count)
        var endSub = [Int](repeating: 0, count: ranges.count)
        for (i,range) in ranges.enumerated()
        {
            startSub[i] = range.lowerBound
            endSub[i] = range.upperBound
        }    

        // ensure that new data size matches size of slice to write to
        var sliceSize = [Int](repeating: 0, count: ranges.count)
        for i in 0..<ranges.count
        {
            sliceSize[i] = endSub[i]-startSub[i]+1
        }

        precondition(sliceSize == value.size, "Provided data must match tensor slice size")        

        // start writing to matrix, rolling over each dimension
        var newData = value.data
        var curSub = startSub
        for i in 0..<newData.count
        {
            self.setValue(subscripts: curSub, value: newData[i])
            
            guard let inc = _cascadeIncrementSubscript(curSub, min: startSub, max: endSub) else
            {
                return
            }

            curSub = inc                
        }
    }
    
    //----------------------------------------------------------------------------------------------
    // MARK: DISPLAY
    //----------------------------------------------------------------------------------------------

    /// String representation of tensor contents in an easily readable grid format.
    ///
    /// - Note: The formatter associated with this tensor is used as a suggestion; elements may be
    ///     formatted differently to improve readability. Elements that can't be displayed under the
    ///     current formatting constraints will be displayed as '#'.
    public var description: String
    {
        // create tensor title
        var title = ""
        if self.showName
        {
            title = (self.name ?? "\(self.size.map({"\($0)"}).joined(separator: "x")) tensor") + ":\n"
        }

        // handle 1D tensor
        if self.size.count == 1
        {
            return "\(Vector(self, name: title, showName: self.showName))"
        }

        // handle 2D tensor
        else if self.size.count == 2
        {
            return "\(Matrix(self, name: title, showName: self.showName))"                
        }

        // break 3D+ tensors into 2D tensor chunks
        else
        {
            // The approach here is to increment across only the third and higher dimensions. At
            // each point, we can slice off the first and second dimensions and print those as a 
            // matrix. To do this though, we need to increment the lower dimensions faster, rather 
            // than the higher dimensions as row-major order does. This is because we'd expect to 
            // see the third dimension slices printed together, then the fourth, etc.
            var str = title

            // slice of third and higher dimensions
            let hiDims = self.size[2..<self.size.count]

            // reverse dimensions so cascade increment goes through low dimension fastest
            let hiDimsRev = Array(hiDims.reversed())
            let startRev = Array(repeating: 0, count: hiDimsRev.count)
            let endRev = hiDimsRev.map({$0-1})

            var curSubRev = Array<Int>(repeating: 0, count: hiDimsRev.count)
            while true
            {
                // create a slice over entire dims 1 and 2 for the current spot in dims 3+
                let curSliceLoSubs: [SliceIndex] = [0..<self.size[0], 0..<self.size[1]] 
                let curSliceHiSubs: [SliceIndex] = Array(curSubRev.reversed())
                let curSliceSubs = curSliceLoSubs + curSliceHiSubs
                let curSlice = self.getSlice(subscripts: curSliceSubs)

                // create a header to identify current matrix location in tensor
                let mName = "[..., ..., " + curSliceHiSubs.map({"\($0)"}).joined(separator: ", ") + "]"

                // turn slice into matrix for easy printing
                let m = Matrix(curSlice.size[0], curSlice.size[1], curSlice.data, name: mName, showName: true)
                str += "\(m)\n\n"

                // increment through higher dimensions until we've reached the end
                guard let inc = _cascadeIncrementSubscript(curSubRev, min: startRev, max: endRev) else
                {
                    return str
                }

                curSubRev = inc 
            }
        }  
    }    

    /// String representation of tensor in raw format.
    ///
    /// Elements of a row are comma separated. Rows are separated by newlines. Higher dimensional
    /// slices are separated by a line consisting entirely of semicolons, where the number of
    /// semicolons indicates the dimension that ended; e.g. ";" comes between matrices in a 3D
    /// tensor, ";;" comes between 3D tensors in a 4D tensor, ";;;" between 4D tensors in 5D, etc.
    public var rawDescription: String
    {    
        // handle 1D tensor
        if self.size.count == 1
        {
            return Vector(self, name: nil, showName: false).rawDescription
        }

        // handle 2D tensor
        else if self.size.count == 2
        {
            return Matrix(self, name: nil, showName: false).rawDescription
        }

        // break 3D+ tensors into 2D tensor chunks
        else
        {
            var str = [String]()

            // slice of third and higher dimensions
            let hiDims = self.size[2..<self.size.count]

            // reverse dimensions so cascade increment goes through low dimension fastest
            let hiDimsRev = Array(hiDims.reversed())
            let startRev = Array(repeating: 0, count: hiDimsRev.count)
            let endRev = hiDimsRev.map({$0-1})

            var curSubRev = Array<Int>(repeating: 0, count: hiDimsRev.count)
            while true
            {
                // create a slice over entire dims 1 and 2 for the current spot in dims 3+
                let curSliceLoSubs: [SliceIndex] = [0..<self.size[0], 0..<self.size[1]] 
                let curSliceHiSubs: [SliceIndex] = Array(curSubRev.reversed())
                let curSliceSubs = curSliceLoSubs + curSliceHiSubs
                let curSlice = self.getSlice(subscripts: curSliceSubs)

                // turn slice into matrix for easy printing
                let m = Matrix(curSlice.size[0], curSlice.size[1], curSlice.data, name: nil, showName: false)
                str.append("\(m.rawDescription)")

                // increment through higher dimensions until we've reached the end
                guard let inc = _cascadeIncrementSubscript(curSubRev, min: startRev, max: endRev) else
                {
                    return str.joined(separator: "\n")
                }

                // find which dimension rolled over to determine how many semicolons to delimit with
                var numSemicolons = -1
                for d in 0..<curSubRev.count
                {
                    if curSubRev[d] != inc[d]
                    {
                        numSemicolons = curSubRev.count-d
                        break
                    }                    
                }
                assert(numSemicolons > 0, "No semicolon needed implies function should have already returned")
                let semicolons = String(repeating: ";", count: numSemicolons)
                str.append(semicolons)

                // move on to next slice
                curSubRev = inc 
            }
        }  
    }
}
