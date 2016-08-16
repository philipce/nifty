/*******************************************************************************
 *  Matrix.swift
 *
 *  This file defines the Matrix data structure. 
 *
 *  Author: Philip Erickson
 *  Creation Date: 14 Aug 2016
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

public struct Matrix: CustomStringConvertible
{
	/// Number of elements in the matrix.
	public let numel: Int

	/// Number of [rows, columns] in the matrix.
	public var size: [Int]

	/// Data contained in matrix in row-major order.
	public var data: [Double]

	/// Initialize a new matrix.
	///
	/// - Parameters:
	///		- size: number of rows, columns if two numbers are provided; length 
	///			of one side of square matrix if only one number provided
	///		- value: single value repeated throughout matrix
	public init(size: [Int], value: Double)
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
		self.data = Array<Double>(repeating: value, count: numel)						
	}

	/// Initialize a new square matrix.
	///
	/// - Parameters:
	///		- size: length of one side of square matrix
	///		- value: single value repeated throughout matrix
	public init(size: Int, value: Double)
	{
		self.init(size: [size], value: value)						
	}
	
	/// Initialize a new matrix.
	///
	/// - Parameters:
	///		- size: number of rows, columns if two numbers are provided; length 
	///			of one side of square matrix if only one number provided
	///		- data: matrix data in row-major order
	public init(size: [Int], data: [Double])
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
	}

	/// Initialize a new matrix.
	///
	/// - Parameters:
	///		- size: number of rows, columns if two numbers are provided; length 
	///			of one side of square matrix if only one number provided
	///		- data: matrix data in row-major order
	public init(size: Int, data: [Double])
	{
		self.init(size: [size], data: data)
	}

	/// Initialize a new matrix.
	///
	/// - Parameters:
	///		- size: number of rows, columns if two numbers are provided; length 
	///			of one side of square matrix if only one number provided
	///		- data: matrix data where an inner array is an entire row
	public init(data: [[Double]])
	{
		let size = [data.count, data[0].count]

		// FIXME: update to latest swift 3 preview
        //let flat = Array(data.joined())
		let flat = data.reduce([], combine: +)        
		
		let numel = flat.count

		precondition(size[0] * size[1] == numel, 
			"Matrix dimensions must be consistent")

		self.numel = numel
		self.size = size
		self.data = flat
	}

	/// Access a single element of the matrix.
	///
	/// - Parameters:
	///		- s: row, column subscript into matrix if two numbers are provided;
	///			linear index into row-major order data if only one 
	/// - Returns: single value at index/subscript for get
	public subscript(_ s: Int...) -> Double
	{
		get
		{
			if s.count == 1
			{
				precondition(_isValidIndex(s[0]), 
					"Invalid matrix index: \(s[0])")

				return self.data[s[0]]
			}
			else
			{	
				precondition(_isValidSubscript(s), 
					"Invalid matrix subscripts: \(s)")

				return self.data[sub2ind(size: self.size, subscripts: s)]
			}
		}

		set(newVal)
		{
			if s.count == 1
			{
				precondition(_isValidIndex(s[0]), 
					"Invalid matrix index: \(s[0])")

				self.data[s[0]] = newVal
			}
			else
			{	
				precondition(_isValidSubscript(s), 
					"Invalid matrix subscripts: \(s)")

				self.data[sub2ind(size: self.size, subscripts: s)] = newVal
			}
		}
	}

	/// Access a slice of the matrix.
	///
	/// - Parameters:
	///		- s: two values, either Ints or Ranges, defining the matrix slice
	/// - Returns: new matrix composed of slice
	public subscript(_ s: Slice...) -> Matrix
	{
		get { assert(false, "Unimplemented"); return self }
		set { assert(false, "Unimplemented")}
	}

	/// Return matrix contents in an easily readable grid format.
	///
	/// - Returns: string representation of matrix
	public var description: String
	{
		// TODO: pad matrix cells so everything is aligned

		var str = "\n"
		
		for r in 0..<self.size[0]
		{
			for c in 0..<self.size[1]
			{
				str += "\(self[r, c])  " 
			}
			
			str += "\n"
		}

		return str
	}

	//==========================================================================
	// MARK: PRIVATE HELPERS
	//==========================================================================

	/// Determine whether a given index is valid for this matrix.
	///
	/// - Parameters:
	///		- i: index to check
	///	- Returns: true if index is valid, else false 
	private func _isValidIndex(_ i: Int) -> Bool
	{
		// FIXME:
		assert(false, "Unimplemented")
		return true
	}

	/// Determine whether a given subscript is valid for this matrix.
	///
	/// - Parameters:
	///		- s: subscript to check
	///	- Returns: true if subscript is valid, else false
	private func _isValidSubscript(_ s: [Int]) -> Bool
	{
		// FIXME:
		assert(false, "Unimplemented")
		return true
	}

	/// Determine whether a given slice is valid for this matrix.
	///
	/// - Parameters:
	///		- s: slice to check
	///	- Returns: true if slice is valid, else false
	private func _isValidSlice(_ s: [Slice]) -> Bool
	{
		// FIXME:
		assert(false, "Unimplemented")
		return true
	}
}