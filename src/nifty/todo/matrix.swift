/*******************************************************************************
 *  matrix.swift
 *
 *  This file provides a matrix structure and basic functionality.
 *
 *  Author: Philip Erickson
 *  Creation Date: 1 May 2016
 *  Contributors: 
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  Copyright 2016 Philip Erickson
 ******************************************************************************/

/// Protocol used to enable otherwise nonhomogeneous parameters list of 
/// Int's and Range<Int>'s in subscripting. It's up to the subscript
/// function to ensure that a received parameter really is Int or Range<Int>
public protocol SliceElement {}
extension Int: SliceElement {}
extension Range: SliceElement {}
extension CountableClosedRange: SliceElement {}

/// Provide matrix structure used throughout Nifty.
///
/// The Matrix struct provides only basic functionality: creating matrices with
/// specified size and values; accessing matrix elements and slices; and
/// displaying matrix values.
///
/// Additional matrix information and functionality is provided by outside 
/// functions that act on a supplied Matrix instance, rather than by Matrix
/// member functions.
public struct Matrix: CustomStringConvertible
{
    public let numel: Int
    public var size: [Int]
    public var data: [Double]    

    //--------------------------------------------------
    // Matrix Initializers
    //--------------------------------------------------
    /// Initialize a new matrix of given size and uniform value.
    ///
    /// - Parameters:
    ///     - size: array containing number of elements in each dimension,
    ///         e.g. number of rows, columns, pages, etc.
    ///     - value: initial value for all elements of the matrix 
    public init(size: [Int], value: Double) 
    {
        let totalSize = size.reduce(1, combine: *)

        assert(!size.isEmpty && totalSize > 0, 
            "Matrix dimensions must all be positive")

        self.numel = totalSize
        self.size = size
        self.data = [Double](repeating: value, count: self.numel)
    }

    /// Initialize a new 1D matrix (vector) with the given data.
    ///
    /// - Parameters:
    ///     - data: matrix data
    public init(data: [Double])
    {
        self.numel = data.count
        self.size = [1, data.count]
        self.data = data
    }

    /// Initialize a new 2D matrix with given data and inferred size.
    ///
    /// - Parameters:
    ///     - data: matrix data, where inner array represents a single row
    public init(data: [[Double]])
    {
        let size = [data.count, data[0].count]
        let flat = Array(data.flatten())
        let count = flat.count

        assert(size.reduce(1, combine: *) == count, 
            "Matrix dimension not consistent")

        var mdata = [Double]()
        for c in 0..<size[1]
        {
            for r in 0..<size[0]
            {
                mdata.append(data[r][c])
            }
        }

        self.numel = count
        self.size = size
        self.data = mdata
    }

    /// Initialize a new, arbitrary dimensional matrix of given size and values.
    ///
    /// - Parameters:
    ///     - size: array containing number of elements in each dimension
    ///     - data: values for all elements of the matrix
    ///         note: data should be in order expected by ind2sub()
    public init(size: [Int], data: [Double])
    {
        let totalSize = size.reduce(1, combine: *)

        assert(!size.isEmpty && totalSize > 0, 
            "Matrix dimensions must all be positive")

        assert(!data.isEmpty && data.count == totalSize, 
            "Matrix dimensions must match provided data")

        self.numel = data.count
        self.size = size
        self.data = data
    }

    //--------------------------------------------------
    // Matrix Accessors
    //--------------------------------------------------   
    /// Access the element of the matrix at the given subscripts.
    ///
    /// If more than one number is passed, it is assumed that multidimensional
    /// subscripting is intended. Otherwise, a single number is interpretted
    /// as a monodimensional index. In both cases, the appropriate bounds
    /// checking is performed.
    ///
    /// - Parameters:
    ///     - subscripts: subscripts specifying desired element
    /// - Returns: element at the given subscripts     
    public subscript(subscripts: Int...) -> Double
    {   
        get { return self[element: subscripts] }
        set { self[element: subscripts] = newValue }
    }

    /// Access the element of the matrix at the subscripts in the given array.
    ///
    /// - Parameters:
    ///     - subscripts: array of subscripts specifying element, where external
    ///         name is used to resolve ambiguity with slicing overload
    /// - Returns: element at the given subscripts   
    public subscript(element subscripts: [Int]) -> Double
    {
        get 
        { 
            if subscripts.count == 1
            {
                assert(_isValidIndex(subscripts[0]), 
                    "Invalid matrix index \(subscripts[0])")

                return self.data[subscripts[0]] 
            }
            else
            {
                assert(_isValidSubscript(subscripts), 
                    "Invalid matrix subscripts \(subscripts)")

                return self.data[sub2ind(self.size, subscripts: subscripts)] 
            }        
        }

        set(val)
        { 
            if subscripts.count == 1
            {
                assert(_isValidIndex(subscripts[0]), 
                    "Invalid matrix index \(subscripts[0])")

                self.data[subscripts[0]] = val
            }
            else
            {              
                assert(_isValidSubscript(subscripts), 
                    "Invalid matrix subscripts \(subscripts)")
                
                self.data[sub2ind(self.size, subscripts: subscripts)] = val
            }
        }
    }

    /// Access the specified slice of the matrix.
    ///
    /// - Parameters:
    ///     - subscripts: subscripts of elements in each dimension to select
    /// - Returns: slice of matrix
    // TODO: remove external slice label... Swift 2.2 finds this subscript
    // ambiguous with the subsubscript(Int...) call, hence the label to
    // disambiguate. However, Swift 3 defaults to the Int... call, which is what
    // we'd like. So the external label can go once we switch to Swift 3.
    public subscript(slice subscripts: SliceElement...) -> Matrix
    {   
        get { return self[subscripts] }
        set { self[subscripts] = newValue }
    }

    /// Access the specified slice of the matrix.
    ///
    /// - Parameters:
    ///     - slice: subscripts of elements in each dimension to select, where
    ///         external name is used to resolve ambiguity with slicing overload
    /// - Returns: slice of matrix
    // TODO: figure out a way to allow setting a double array, 
    //      e.g. m1[1, 0...3] = [0,1,2,3]
    // TODO: include get/set that takes Range<Int>... to save having to convert
    public subscript(subscripts: [SliceElement]) -> Matrix
    {   
        get
        {
            var ranges = [CountableClosedRange<Int>]()
            for s in subscripts
            {
                switch s
                {
                    case let se as Int:
                        ranges.append(se...se)
                    case let se as CountableClosedRange<Int>:
                        ranges.append(se)
                    default:
                        assert(false, "Invalid slice subscript \(s)")
                }
            }

            if ranges.count == 1
            {   
                // FIXME: check upperBound-1, is this how this works in swift 3?

                assert(_isValidIndex(ranges[0].lowerBound) && 
                    _isValidIndex(ranges[0].upperBound), 
                    "Invalid matrix slice \(ranges[0])")
                
                return Matrix(data: Array(self.data[ranges[0]]))
            }
            else
            {
                assert(_isValidSlice(ranges), "Invalid matrix slice \(ranges)")

                // determine size of resulting matrix and the starting point for reading
                var newSize = [Int](repeating: 0, count: ranges.count)
                var firstReadSub = [Int](repeating: 0, count: ranges.count)
                var lastReadSub = [Int](repeating: 0, count: ranges.count)
                for (i,range) in ranges.enumerated()
                {
                    newSize[i] = range.count
                    firstReadSub[i] = range.lowerBound
                    lastReadSub[i] = range.upperBound-1
                }    

                var newData = [Double]()

                // start reading from matrix, rolling over each dimension
                var curReadSub = firstReadSub
                while true
                {
                    newData.append(self[element: curReadSub])
                    guard let inc = _cascadeInc(curReadSub, min: firstReadSub, 
                        max: lastReadSub) else
                    {
                        break
                    }

                    curReadSub = inc                
                }
                
                return Matrix(size: newSize, data: newData) 
            }
        }

        set(val)
        {
            var ranges = [CountableClosedRange<Int>]()
            for s in subscripts
            {
                switch s
                {
                    case let se as Int:
                        ranges.append(se...se)
                    case let se as CountableClosedRange<Int>:
                        ranges.append(se)
                    default:
                        assert(false, "Invalid slice subscript \(s)")
                }
            }

            if ranges.count == 1
            {
                assert(_isValidIndex(ranges[0].lowerBound) && 
                    _isValidIndex(ranges[0].upperBound), 
                    "Invalid matrix slice \(ranges[0])")
                
                self.data[ranges[0]] = ArraySlice(val.data)
            }
            else
            {
                assert(_isValidSlice(ranges), "Invalid matrix slice \(ranges)")

                // determine range of writes in each dimension
                var firstWriteSub = [Int](repeating: 0, count: ranges.count)
                var lastWriteSub = [Int](repeating: 0, count: ranges.count)
                for (i,range) in ranges.enumerated()
                {
                    firstWriteSub[i] = range.lowerBound
                    lastWriteSub[i] = range.upperBound-1
                }    

                let newData = val.data

                // start writing to matrix, rolling over each dimension
                var curWriteSub = firstWriteSub
                for i in 0..<newData.count
                {
                    self[element: curWriteSub] = newData[i]

                    // FIXME: ensure that newData size matches slice size to
                    // write to
                    guard let inc = _cascadeInc(curWriteSub, min: firstWriteSub, 
                        max: lastWriteSub) else
                    {
                        return
                    }

                    curWriteSub = inc                
                }                
            }
        }
    }    

    //--------------------------------------------------
    // Matrix Display
    //--------------------------------------------------
    public var description: String
    {
        // TODO: improve, extend to 3+ dim matrix
        assert(self.size.count <= 2, "Printing 3D matrix not yet implmemented")

        var s = "Matrix, \(self.size[0])-by-\(self.size[1]): \n"

        for r in 0..<self.size[0]
        {
            for c in 0..<self.size[1]
            {
                let d = self.data[sub2ind(self.size, subscripts: [r,c])]

                // TODO: string format not yet impl on linux
                s += "\(Double(round(d*1000))/1000.0)   " 
            }
            s += "\n"
        }

        return s
    }

    //--------------------------------------------------
    // Private Helper Functions
    //--------------------------------------------------
    /// Increment the first element of a given list, cascading carry values
    /// into the subsequent element if possible.
    ///
    /// - Parameters: 
    ///     - list: list to increment
    ///     - min: min values for each element in list
    ///     - max: max values for each element in list
    /// - Returns: incremented list or nil if list is already at max value
    private func _cascadeInc(_ list: [Int], min: [Int], max: [Int]) -> [Int]?
    {
        var newList = list        
        var success = false

        newList[0] += 1 
    
        for i in 0..<newList.count
        {
            if newList[i] > max[i]
            {
                if i == newList.count-1
                {
                    return nil
                }

                newList[i] = min[i]
                newList[i+1] = newList[i+1] + 1
            }
            else
            {
                success = true
                break
            }
        }

        return success ? newList : nil
    }

    /// Determine if subscript corresponds to an index that is within bounds.
    ///
    /// - Parameters:
    ///     - subscripts: multidimensional subscript into matrix
    /// - Returns: true if valid, false otherwise
    private func _isValidSubscript(_ subscripts: [Int]) -> Bool
    {
        if subscripts.count == 1
        {
            return self._isValidIndex(subscripts[0])
        }
        else
        {
            return self._isValidIndex(sub2ind(self.size, subscripts: subscripts))
        }
    }

    /// Determine if index is within bounds of the matrix.
    ///
    /// - Parameters:
    ///     - index: monodimensional index into matrix
    /// - Returns: true if valid, false otherwise
    private func _isValidIndex(_ index: Int) -> Bool
    {
        return index >= 0 && index <= self.numel
    }

    /// Determine if slice is well defined and if the ranges in slice are 
    /// within bounds of the matrix.
    ///
    /// - Parameters:
    ///     - ranges: ranges to select in corresponding dimension
    /// - Returns: true if the slice is valid, false otherwise
    private func _isValidSlice(_ ranges: [CountableClosedRange<Int>]) -> Bool
    {        
        // TODO: Allow infinite upper range for matlab 'end'? Allow 'start'?    

        // FIXME: check upperBound-1 in swift 3 

        if ranges.count != self.size.count
        {
            return false
        }

        for (dim, range) in ranges.enumerated()
        {
            if range.lowerBound < 0 || range.upperBound-1 >= self.size[dim]
            {
                return false
            }
        }

        return true
    }
}
