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
public struct Matrix<T>: CustomStringConvertible
{
	/// Number of elements in the matrix.
	public let count: Int

	/// Number of [rows, columns] in the matrix.
	public var size: [Int]
    public var rows: Int { return self.size[0] }
    public var columns: Int { return self.size[1] }

	/// Data contained in matrix in row-major order.
	public var data: [T]

	/// Optional name of matrix (e.g., for use in display).
	public var name: String?

	/// Determine whether to show name when displaying matrx.
	public var showName: Bool

	/// Formatter to be used in displaying matrix elements.
	public var format: NumberFormatter    

	/// Initialize a new matrix with the given dimensions from an array of data in row-major order.
	///
	/// - Parameters:
    ///    - rows: number of rows in matrix
	///    - columns: number of columns in a matrix
	///	   - data: matrix data in row-major order
	///	   - name: optional name of matrix
	///	   - showName: determine whether to print the matrix name; defaults to true if the matrix is
    ///        given a name, otherwise to false
	public init(_ rows: Int, _ columns: Int, _ data: [T], name: String? = nil, showName: Bool? = nil)
	{   
        precondition(rows >= 1 && columns >= 1, "Matrix have at least 1 row and 1 column")      

        let count = rows * columns     
		precondition(data.count == count, "Matrix dimensions must match data")

        self.size = [rows, columns]
        self.count = count
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

    /// Initialize a new square matrix with the given dimensions from an array of data in 
    /// row-major order.
    ///
    /// - Parameters:
    ///    - side: number of elements along one side of square matrix
    ///    - data: matrix data in row-major order
    ///    - name: optional name of matrix
    ///    - showName: determine whether to print the matrix name; defaults to true if the matrix is
    ///        given a name, otherwise to false
    public init(_ side: Int, _ data: [T], name: String? = nil, showName: Bool? = nil)
    {
        self.init(side, side, data, name: name, showName: showName)
    }

    /// Initialize a new matrix of the given size from an array of data in row-major order.
    ///
    /// - Parameters:
    ///    - size: size of matrix  
    ///    - data: matrix data in row-major order
    ///    - name: optional name of matrix
    ///    - showName: determine whether to print the matrix name; defaults to true if the matrix is
    ///        given a name, otherwise to false
    public init(_ size: [Int], _ data: [T], name: String? = nil, showName: Bool? = nil)
    {
        precondition(size.count == 2, "Matrix must be 2 dimensional")
        self.init(size[0], size[1], data, name: name, showName: showName)
    }

	/// Initialize a new matrix with the given dimensions and uniform value.
	///
	/// - Parameters:
    ///    - rows: number of rows in matrix
    ///    - columns: number of columns in matrix
	///	   - value: single value repeated throughout matrix
	///	   - name: optional name of matrix
	///    - showName: determine whether to print the matrix name; defaults to true if the matrix is
    ///        given a name, otherwise to false
	public init(_ rows: Int, _ columns: Int, value: T, name: String? = nil, showName: Bool? = nil)
	{
        let count = rows * columns
        precondition(count > 0, "Matrix must have at least one element")
		let data = Array<T>(repeating: value, count: count)
		self.init(rows, columns, data, name: name, showName: showName)
	}

    /// Initialize a new square matrix with the given dimensions and uniform value.
    ///
    /// - Parameters:
    ///    - side: number of elements along one side of square matrix
    ///    - value: single value repeated throughout matrix
    ///    - name: optional name of matrix
    ///    - showName: determine whether to print the matrix name; defaults to true if the matrix is
    ///        given a name, otherwise to false
    public init(_ side: Int, value: T, name: String? = nil, showName: Bool? = nil)
    {
        self.init(side, side, value: value, name: name, showName: showName)
    }

    /// Initialize a new matrix of the given size and uniform value.
    ///
    /// - Parameters:
    ///    - size: size of matrix
    ///    - value: single value repeated throughout matrix
    ///    - name: optional name of matrix
    ///    - showName: determine whether to print the matrix name; defaults to true if the matrix is
    ///        given a name, otherwise to false
    public init(_ size: [Int], value: T, name: String? = nil, showName: Bool? = nil)
    {
        precondition(size.count == 2, "Matrix must be 2 dimensional")
        self.init(size[0], size[1], value: value, name: name, showName: showName)
    }
	
    /// Initialize a new matrix, inferring size from the provided data.
    ///
    /// - Parameters:
    ///    - data: matrix data where each inner array represents an entire row
    ///    - name: optional name of matrix
    ///    - showName: determine whether to print the matrix name; defaults to true if the matrix is
    ///        given a name, otherwise to false
    public init(_ data: [[T]], name: String? = nil, showName: Bool? = nil)
    {        
        let size = [data.count, data[0].count]

        var flatData = [T]()
        for row in data
        {
            precondition(row.count == size[1], "Matrix must have same number of columns in all rows")
            flatData.append(contentsOf: row)
        }
                
        self.init(size, flatData, name: name, showName: showName)
    }    

    /// Initialize a new matrix from the data in a given vector.
    ///
    /// - Parameters:
    ///    - vector: vector to initialize from
    ///    - name: optional name of new matrix
    ///    - showName: determine whether to print the matrix name; defaults to true if the matrix is
    ///        given a name, otherwise to false
    public init(_ vector: Vector<T>, name: String? = nil, showName: Bool? = nil)
    {
        self.init(1, vector.count, vector.data, name: name, showName: showName)
        self.format = vector.format
    }
    
	/// Initialize a new matrix from the data in a given matrix.
	///
	/// - Parameters:
	///    - matrix: matrix to copy
	///    - name: optional name of new matrix, defaults to no name
	///    - showName: determine whether to print the matrix name; defaults to true if the matrix is
    ///        given a name, otherwise to false
	public init(_ matrix: Matrix<T>, name: String? = nil, showName: Bool? = nil)
	{
        self.init(matrix.size, matrix.data, name: name, showName: showName)
        self.format = matrix.format
	}

    /// Initialize a new matrix from the data in a given tensor.
    ///
    /// - Parameters:
    ///    - tensor: tensor to copy
    ///    - name: optional name of new matrix, defaults to no name
    ///    - showName: determine whether to print the matrix name; defaults to true if the matrix is
    ///        given a name, otherwise to false
    public init(_ tensor: Tensor<T>, name: String? = nil, showName: Bool? = nil)
    {
        precondition(tensor.size.count == 2, "Tensor must be 2D to initialize Matrix")
        self.init(tensor.size, tensor.data, name: name, showName: showName)
        self.format = tensor.format
    }

    /// Access a single element of the matrix with a row, column subscript.
    ///
    /// - Parameters:
    ///    - row: row subscript
    ///    - column: column subscript
    /// - Returns: single value at subscript
	public subscript(_ row: Int, _ column: Int) -> T
	{
		get
		{
			let index = sub2ind(row, column, size: self.size)				
			precondition(index >= 0, "Invalid matrix subscripts: \([row, column])")
			return self.data[index]
		}

		set(newVal)
		{
			let index = sub2ind(row, column, size: self.size)				
			precondition(index >= 0, "Invalid matrix subscripts: \([row, column])")
			self.data[index] = newVal
		}
	}

    /// Access a single element of the matrix with a row-major linear index.
    ///
    /// - Parameters:
    ///    - index: linear index into matrix
    /// - Returns: single value at index
    public subscript(_ index: Int) -> T
    {
        get
        {
            precondition(index >= 0 && index < self.count, "Matrix index \(index) out of bounds")
            return self.data[index]            
        }

        set(newVal)
        {
            precondition(index >= 0 && index < self.count, "Matrix index \(index) out of bounds")
            self.data[index] = newVal
        }

    }

	/// Access a slice of the matrix with a row, column range subscript.
	///
    /// - Parameters:
    ///    - rows: row range; or if columns is omitted, linear index range
    ///    - columns: column range; if omitted, use linear index range instead
	/// - Returns: new matrix composed of slice
	public subscript(_ rows: SliceIndex, _ columns: SliceIndex) -> Matrix<T>
	{
		get 
		{ 
			let ranges = _convertToCountableClosedRanges([rows, columns])

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
			var newData = [T]()
			var curSub = startSub
			while true
			{
				newData.append(self[curSub[0], curSub[1]])
				guard let inc = _cascadeIncrementSubscript(curSub, min: startSub, max: endSub) else
				{
					break
				}

				curSub = inc
			}

			// inherit name, add slice info
			var sliceName = self.name
			if sliceName != nil { sliceName! += "[\(rows), \(columns)]" }

			return Matrix(newSize, newData, name: sliceName, showName: self.showName) 
		}

		set(newVal)
		{
			let ranges = _convertToCountableClosedRanges([rows, columns])

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
            precondition(sliceSize == newVal.size, "Supplied data does not match matrix slice size")        

            // start writing to matrix, rolling over each dimension
			var newData = newVal.data
			var curSub = startSub
			for i in 0..<newData.count
            {
                self[curSub[0], curSub[1]] = newData[i]

                
                guard let inc = _cascadeIncrementSubscript(curSub, min: startSub, max: endSub) else
                {
                    return
                }

                curSub = inc                
            }
		}
	}

    /// Access a slice of the matrix with a row-major linear index range.
    ///
    /// - Parameters:
    ///    - index: linear index range 
    /// - Returns: new matrix composed of slice
    public subscript(_ index: SliceIndex) -> Matrix<T>
    {
        get
        {
            let range = (_convertToCountableClosedRanges([index]))[0]

            // inherit name, add slice info
            var sliceName = self.name
            if sliceName != nil { sliceName! += "[\(index)]" }

            return Matrix([Array(self.data[range])], name: sliceName, showName: self.showName)
        }
        set(newVal)
        {
            let range = (_convertToCountableClosedRanges([index]))[0]
            self.data[range] = ArraySlice(newVal.data)

            return
        }
    }

    // TODO: add setter that can take a tensor or vector too


    // TODO: add CSV option that spits out matrix in easily readable .csv format (i.e. don't print
    // row headers, extra space, etc.)

	/// Return matrix contents in an easily readable grid format.
	///
	/// - Note: The formatter associated with this matrix is used as a suggestion; elements may be
	///	    formatted differently to improve readability. Elements that can't be displayed under the 
	///     current formatting constraints will be displayed as '#'.	
	/// - Returns: string representation of matrix
	public var description: String
	{
		// TODO: entries in a column should be right justified, e.g.
		//		 506                    506
		//	   1,048     instead of     1,048 

        // TODO: make the specifed format indicate the max spacing, but make it actually dynamic to
        // save space; e.g. a matrix of single digit numbers doesn't need more than two spaces
        // between columns--downsize the format width to what's needed by the largest element

        // FIXME: Improve printing for non double types
        // Instead of treating them separately, use the formatter just to round/shorten doubles;
        // append all elements as strings to the list, then go through the list and pad with spaces
        // appropriately. Also, could formatter be used for types other than doubles? If not, should
        // it be set to nil for non double structs?

		var lines = [String]()

		// create matrix title
		if self.showName
		{
			let title = (self.name ?? "\(self.size[0])-by-\(self.size[1]) matrix") + ":"
			lines.append(title)
		}
		       
		// create string representation of each matrix row		
		for r in 0..<self.size[0]
		{
			var row = "R\(r): "
			for c in 0..<self.size[1]
			{				
				if let el = self[r, c] as? Double
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
                    row += sign + s + "  "
                }
                else
                {
                    row += "\(self[r, c])   "
                }
			}			
			lines.append(row)
		}

		return lines.joined(separator: "\n")
	}
}

//==================================================================================================
// MARK: HELPER FUNCTIONS
//==================================================================================================


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