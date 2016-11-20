/***************************************************************************************************
 *  Matrix.swift
 *
 *  This file defines the Matrix data structure. 
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

/// Data structure for a 2-D, row-major order matrix.
public struct Matrix: CustomStringConvertible
{
	/// Number of elements in the matrix.
	public let numel: Int

	/// Number of [rows, columns] in the matrix.
	public var size: [Int]

	/// Data contained in matrix in row-major order.
	public var data: [Double]

	/// Optional name of matrix (e.g., for use in display).
	public var name: String?

	// Determine whether to show name/info when displaying matrx.
	public var title: Bool

	/// Formatter to be used in displaying matrix elements.
	public var format: NumberFormatter

	/// Initialize a new matrix.
	///
	/// - Parameters:
	///		- size: number of rows, columns if two numbers are provided; length 
	///			of one side of square matrix if only one number provided
	///		- data: matrix data in row-major order
	///		- name: optional name of matrix
	///		- title: determine whether to print the matrix title; false by default
	public init(size: [Int], data: [Double], name: String? = nil, title: Bool = false)
	{
		let numel: Int
		if size.count == 1
		{
			self.size = [size[0], size[0]]
			numel = self.size[0] * self.size[0]
		}
		else
		{
			precondition(size.count == 2, "Matrix must be 2-D")
			self.size = size
			numel = self.size[0] * self.size[1]			
		}

		precondition(numel > 0, "Matrix have at least 1 element")
		self.numel = numel			

		precondition(data.count == numel, "Matrix dimensions must match data")
		self.data = data	
		self.name = name	
		self.title = title

		// default display settings
		let fmt = NumberFormatter()
		fmt.numberStyle = .decimal
		fmt.usesSignificantDigits = true
		fmt.paddingCharacter = " "
		fmt.paddingPosition = .afterSuffix
		fmt.formatWidth = 8
		self.format = fmt
	}

	/// Initialize a new matrix.
	///
	/// - Parameters:
	///		- size: number of rows, columns if two numbers are provided; length 
	///			of one side of square matrix if only one number provided
	///		- data: matrix data where an inner array is an entire row
	///		- name: optional name of matrix
	///		- title: determine whether to print the matrix title; false by default
	public init(_ data: [[Double]], name: String? = nil, title: Bool = false)
	{
		let size = [data.count, data[0].count]
		self.init(size: size, data: Array(data.joined()), name: name, title: title)
	}

	/// Initialize a new matrix.
	///
	/// - Parameters:
	///		- size: number of rows, columns if two numbers are provided; length 
	///			of one side of square matrix if only one number provided
	///		- value: single value repeated throughout matrix
	///		- name: optional name of matrix
	///		- title: determine whether to print the matrix title; false by default
	public init(size: [Int], value: Double, name: String? = nil, title: Bool = false)
	{
		let data = Array<Double>(repeating: value, count: size.reduce(1, *))
		self.init(size: size, data: data, name: name, title: title)
	}

	/// Initialize a new square matrix.
	///
	/// - Parameters:
	///		- size: length of one side of square matrix
	///		- value: single value repeated throughout matrix
	///		- name: optional name of matrix
	///		- title: determine whether to print the matrix title; false by default
	public init(size: Int, value: Double, name: String? = nil, title: Bool = false)
	{
		self.init(size: [size], value: value, name: name, title: title)						
	}
		
	/// Initialize a new matrix.
	///
	/// - Parameters:
	///		- size: number of rows, columns if two numbers are provided; length 
	///			of one side of square matrix if only one number provided
	///		- data: matrix data in row-major order
	///		- name: optional name of matrix
	///		- title: determine whether to print the matrix title; false by default
	public init(size: Int, data: [Double], name: String? = nil, title: Bool = false)
	{
		self.init(size: [size], data: data, name: name, title: title)
	}	

	/// Initialize a new matrix, copying given matrix and possibly renaming.
	///
	/// - Parameters:
	///		- copy: matrix to copy
	///		- rename: optional name of new matrix
	///		- title: determine whether to print the matrix title; false by default
	public init(copy: Matrix, rename: String? = nil, title: Bool = false)
	{
		self.numel = copy.numel
		self.size = copy.size
		self.data = copy.data
		self.name = rename
		self.title = copy.title
		self.format = copy.format
	}

	/// Access a single element of the matrix.
	///
	/// - Parameters:
	///		- s: row, column subscript into matrix if two numbers are provided;
	///			linear index into row-major order data if only one 
	/// - Returns: single value at index/subscript for get
	public subscript(_ s: Int...) -> Double
	{
		get { return self[s] }
		set { self[s] = newValue }
	}

	/// Access a single element of the matrix.
	///
	/// - Parameters:
	///		- s: row, column subscript into matrix if two numbers are provided;
	///			linear index into row-major order data if only one 
	/// - Returns: single value at index/subscript for get
	public subscript(_ s: [Int]) -> Double
	{
		get
		{
			if s.count == 1
			{
				precondition(s[0] >= 0 && s[0] < self.numel, "Invalid matrix index: \(s[0])")
				return self.data[s[0]]
			}
			else
			{	
				let index = sub2ind(size: self.size, subscripts: s)				
				precondition(index >= 0, "Invalid matrix subscripts: \(s)")
				return self.data[index]
			}
		}

		set(newVal)
		{
			if s.count == 1
			{
				precondition(s[0] >= 0 && s[0] < self.numel, "Invalid matrix index: \(s[0])")
				self.data[s[0]] = newVal
			}
			else
			{	
				let index = sub2ind(size: self.size, subscripts: s)				
				precondition(index >= 0, "Invalid matrix subscripts: \(s)")
				self.data[index] = newVal
			}
		}
	}

	/// Access a slice of the matrix.
	///
	/// - Parameters:
	///		- s: two values, either Ints or Ranges, defining the matrix slice
	/// - Returns: new matrix composed of slice
	public subscript(_ s: SliceIndex...) -> Matrix
	{
		get 
		{ 
			let ranges = _convertToCountableClosedRanges(s)

			// slice with range of linear indices
			if ranges.count == 1
			{
				// inherit name, add slice info
				var sliceName = self.name
				if sliceName != nil { sliceName! += "[\(s[0])]" }

				return Matrix([Array(self.data[ranges[0]])], name: sliceName, 
					title: self.title)
			}

			// otherwise, slice with range of subscripts
			precondition(ranges.count == 2, "Invalid matrix slice: \(s)")

			// determine size of resulting matrix slice, and start/end subscripts to read
			var newSize = [Int](repeating: 0, count: ranges.count)
			var startSub = [Int](repeating: 0, count: ranges.count)
			var endSub = [Int](repeating: 0, count: ranges.count)
			for (i, range) in ranges.enumerated()
			{
				newSize[i] = range.count				
				startSub[i] = range.lowerBound
				endSub[i] = range.upperBound
			}			

			// start reading from matrix, rolling over each dimension
			var newData = [Double]()
			var curSub = startSub
			while true
			{
				newData.append(self[curSub])
				guard let inc = _cascadeIncrementSubscript(curSub, min: startSub, max: endSub) else
				{
					break
				}

				curSub = inc
			}

			// inherit name, add slice info
			var sliceName = self.name
			if sliceName != nil { sliceName! += "[\(s[0]), \(s[1])]" }

			return Matrix(size: newSize, data: newData, name: sliceName, title: self.title) 
		}

		set(newVal)
		{
			let ranges = _convertToCountableClosedRanges(s)

			// slice with range of linear indices
			if ranges.count == 1
			{
				self.data[ranges[0]] = ArraySlice(newVal.data)
				return
			}

			// otherwise, slice with range of subscripts
			precondition(ranges.count == 2, "Invalid matrix slice: \(s)")

			// determine range of writes in each dimension
            var startSub = [Int](repeating: 0, count: ranges.count)
            var endSub = [Int](repeating: 0, count: ranges.count)
            for (i,range) in ranges.enumerated()
            {
                startSub[i] = range.lowerBound
                endSub[i] = range.upperBound
            }    

            // ensure that new data size matches size of slice to write to
            let sliceSize = [endSub[0]-startSub[0]+1, endSub[1]-startSub[1]+1]
            precondition(sliceSize == newVal.size, "Supplied data size does not match destination")        

            // start writing to matrix, rolling over each dimension
			var newData = newVal.data
			var curSub = startSub
			for i in 0..<newData.count
            {
                self[curSub] = newData[i]

                
                guard let inc = _cascadeIncrementSubscript(curSub, min: startSub, max: endSub) else
                {
                    return
                }

                curSub = inc                
            }
		}
	}

	/// Return matrix contents in an easily readable grid format.
	///
	/// Note: The formatter associated with this matrix is used as a suggestion; elements may be
	///	formatted differently to improve readability. Elements that can't be displayed under the 
	/// current formatting constraints will be displayed as '#'.
	///
	/// - Returns: string representation of matrix
	public var description: String
	{
		// TODO: entries in a column should be right justified, e.g.
		//		 506                    506
		//	   1,048     instead of     1,048 

		var lines = [String]()

		// create matrix title
		if self.title
		{
			let title = (self.name ?? "\(self.size[0])-by-\(self.size[1]) matrix") + ":"
			lines.append(title)
		}
		
		// create string representation of each matrix row		
		for r in 0..<self.size[0]
		{
			var row = "\(r): "
			for c in 0..<self.size[1]
			{				
				let el = self[r, c]			
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
				row += sign + s + "  "
			}			
			lines.append(row)
		}

		return lines.joined(separator: "\n")
	}
}

//==================================================================================================
// MARK: FILE PRIVATE HELPER FUNCTIONS
//==================================================================================================
fileprivate func _convertToCountableClosedRanges(_ s: [SliceIndex]) -> [CountableClosedRange<Int>]
{
	var ranges = [CountableClosedRange<Int>]()
	for el in s
	{
		switch el
        {
            case let el as Int:
                ranges.append(el...el)
            case let el as CountableRange<Int>:
            	ranges.append(CountableClosedRange<Int>(el))
            case let el as CountableClosedRange<Int>:
            	ranges.append(el)
            default:
                fatalError("Unknown type of SliceIndex: \(el) \(type(of: el))")
        }
	}

	return ranges
}

/// Increment the first element of a given subscript, cascading carry values into the subsequent 
/// element if possible.
///
/// Note: row-major order is assumed; last dimension increments quickest.
///
/// - Parameters: 
///     - sub: subscript to increment
///     - min: min values for each element in list
///     - max: max values for each element in list
/// - Returns: incremented subscript or nil if list is already at max value
fileprivate func _cascadeIncrementSubscript(_ sub: [Int], min: [Int], max: [Int]) -> [Int]?
{	
	precondition(sub.count == min.count && min.count == max.count)

	let n = sub.count
	var newSub = sub
	newSub[n-1] += 1 

	for i in stride(from: n-1, through: 0, by: -1) // 0..<newSub.count
	{
	    if newSub[i] > max[i]
	    {
	        if i == 0
	        {
	            return nil
	        }

	        newSub[i] = min[i]
	        newSub[i-1] = newSub[i-1] + 1
	    }
	    else
	    {
	    	return newSub
	    }
	}

	return nil
}