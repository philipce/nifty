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

// FIXME: matrix initializer infers type any on mixed integer/double array...
// E.g. Matrix([[1,3.5],[2,4]]) creates a Matrix<Any>. This is easily fixed by either 
// Matrix<Double>([[1,3.5],[2,4]]) or Matrix([[1.0,3.5],[2.0,4.0]]), but the error is kind of 
// cryptic since it shows up when I try to pass the matrix to something that takes Matrix<Double>...
// Is there a way to get it to default to a Matrix<Double>? Maybe add overloads for Matrix<Any> to 
// the functions that convert all elements to Double?

import Foundation

/// Data structure for a 2-D, row-major order matrix.
public struct Matrix<Element>: TensorProtocol
{
	public let count: Int
	public var size: [Int]
	public var data: [Element]
	public var name: String?
	public var showName: Bool
	public var format: NumberFormatter
    
    /// Number of rows in the Matrix.
    public var rows: Int { return self.size[0] }
    
    /// Number of columns in the Matrix.
    public var columns: Int { return self.size[1] }

    //----------------------------------------------------------------------------------------------
    // MARK: INITIALIZE
    //----------------------------------------------------------------------------------------------
    
    public init(_ size: [Int], _ data: [Element], name: String? = nil, showName: Bool? = nil)
    {
        precondition(size.count == 2, "Matrix must be 2 dimensional")
        self.init(size[0], size[1], data, name: name, showName: showName)
    }
    
    public init(_ size: [Int], value: Element, name: String? = nil, showName: Bool? = nil)
    {
        precondition(size.count == 2, "Matrix must be 2 dimensional")
        self.init(size[0], size[1], value: value, name: name, showName: showName)
    }
    
    public init<T>(_ t: T, name: String? = nil, showName: Bool? = nil) where T : TensorProtocol, Element == T.Element
    {
        precondition(t.size.count > 0 , "Tensor must have at least 1 dimension")
        
        let size: [Int]
        if t.size.count == 1
        {
            size = [1, t.size[0]]
        }
        else
        {
            size = t.size
        }

        self.init(size, t.data, name: name, showName: showName)
    }
    
    public init(_ rawDescription: String, name: String? = nil, showName: Bool? = nil)
    {
        // FIXME: implement
        fatalError("Not yet implemented")
    }
    
    /// Initialize a new matrix, inferring size from the provided data.
    ///
    /// - Parameters:
    ///    - data: matrix data where each inner array represents an entire row
    ///    - name: optional name of matrix
    ///    - showName: determine whether to print the matrix name; defaults to true if the matrix is
    ///        given a name, otherwise to false
    public init(_ data: [[Element]], name: String? = nil, showName: Bool? = nil)
    {
        let size = [data.count, data[0].count]
        
        var flatData = [Element]()
        for row in data
        {
            precondition(row.count == size[1], "Matrix must have same number of columns in all rows")
            flatData.append(contentsOf: row)
        }
        
        self.init(size, flatData, name: name, showName: showName)
    }
    
    /// Initialize a new matrix with the given dimensions and uniform value.
    ///
    /// - Parameters:
    ///    - rows: number of rows in matrix
    ///    - columns: number of columns in matrix
    ///       - value: single value repeated throughout matrix
    ///       - name: optional name of matrix
    ///    - showName: determine whether to print the matrix name; defaults to true if the matrix is
    ///        given a name, otherwise to false
    public init(_ rows: Int, _ columns: Int, value: Element, name: String? = nil, showName: Bool? = nil)
    {
        let count = rows * columns
        precondition(count > 0, "Matrix must have at least one element")
        let data = Array<Element>(repeating: value, count: count)
        self.init(rows, columns, data, name: name, showName: showName)
    }
    
	/// Initialize a new matrix with the given dimensions from a row-major ordered array.
	///
	/// - Parameters:
    ///    - rows: number of rows in matrix
	///    - columns: number of columns in a matrix
	///	   - data: matrix data in row-major order
	///	   - name: optional name of matrix
	///	   - showName: determine whether to print the matrix name; defaults to true if the matrix is
    ///        given a name, otherwise to false
	public init(_ rows: Int, _ columns: Int, _ data: [Element], name: String? = nil, showName: Bool? = nil)
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

    /// Initialize a new square matrix with the given dimensions from a row-major ordered array.
    ///
    /// - Parameters:
    ///    - side: number of elements along one side of square matrix
    ///    - data: matrix data in row-major order
    ///    - name: optional name of matrix
    ///    - showName: determine whether to print the matrix name; defaults to true if the matrix is
    ///        given a name, otherwise to false
    public init(_ side: Int, _ data: [Element], name: String? = nil, showName: Bool? = nil)
    {
        self.init(side, side, data, name: name, showName: showName)
    }

    /// Initialize a new square matrix with the given dimensions and uniform value.
    ///
    /// - Parameters:
    ///    - side: number of elements along one side of square matrix
    ///    - value: single value repeated throughout matrix
    ///    - name: optional name of matrix
    ///    - showName: determine whether to print the matrix name; defaults to true if the matrix is
    ///        given a name, otherwise to false
    public init(_ side: Int, value: Element, name: String? = nil, showName: Bool? = nil)
    {
        self.init(side, side, value: value, name: name, showName: showName)
    }

    //----------------------------------------------------------------------------------------------
    // MARK: SUBSCRIPT
    //----------------------------------------------------------------------------------------------

    /// Access a single element of the matrix with a row-major linear index.
    ///
    /// - Parameters:
    ///    - index: linear index into matrix
    /// - Returns: single value at index
    public subscript(_ index: Int) -> Element
    {
        get
        {
            precondition(index >= 0 && index < self.count, "Matrix subscript out of bounds")
            return self.data[index]            
        }

        set(newVal)
        {
            precondition(index >= 0 && index < self.count, "Matrix subscript out of bounds")
            self.data[index] = newVal
        }
    }

    /// Access a single element of the matrix with a row, column subscript.
    ///
    /// - Parameters:
    ///    - row: row subscript
    ///    - column: column subscript
    /// - Returns: single value at subscript
	public subscript(_ row: Int, _ column: Int) -> Element
	{
		get
		{
			let index = sub2ind([row, column], size: self.size)				
			return self.data[index]
		}

		set(newVal)
		{
			let index = sub2ind([row, column], size: self.size)				
			self.data[index] = newVal
		}
	}    

    /// Access a slice of the matrix with a row-major linear index range.
    ///
    /// - Parameters:
    ///    - index: linear index range 
    /// - Returns: new matrix composed of slice
    public subscript(_ index: SliceIndex) -> Matrix<Element>
    {
        get
        {
            let range = _convertToCountableClosedRange(index)

            // inherit name, add slice info
            var sliceName = self.name
            if sliceName != nil { sliceName = "\(_parenthesizeExpression(sliceName!))[\(index)]" }

            return Matrix([Array(self.data[range])], name: sliceName, showName: self.showName)
        }
        set(newVal)
        {
            let range = _convertToCountableClosedRange(index)
            self.data[range] = ArraySlice(newVal.data)

            return
        }
    }

	/// Access a slice of the matrix with a row, column range subscript.
	///
    /// - Parameters:
    ///    - rows: row range
    ///    - columns: column range
	/// - Returns: new matrix composed of slice
	public subscript(_ rows: SliceIndex, _ columns: SliceIndex) -> Matrix<Element>
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
			var newData = [Element]()
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
            if sliceName != nil { sliceName = "\(_parenthesizeExpression(sliceName!))[\(rows), \(columns)]" }

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
            precondition(sliceSize == newVal.size, "Provided data must match matrix slice size")        

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

    //----------------------------------------------------------------------------------------------
    // MARK: DISPLAY
    //----------------------------------------------------------------------------------------------
    
	/// Return matrix contents in an easily readable grid format.
	///
    /// - Note: The formatter associated with this matrix is used as a suggestion; elements may be
    ///    formatted differently to improve readability. Elements that can't be displayed under the 
    ///    current formatting constraints will be displayed as '#'; non-numeric elements may be 
    ///    abbreviated by truncating and appending "...".    
	public var description: String
	{
		// create matrix title
        var title = ""
		if self.showName
		{
			title = (self.name ?? "\(self.size[0])x\(self.size[1]) matrix") + ":\n"
		}

        // store length of widest element of each column, including additional column for row header
		var colWidths = Array<Int>(repeating: 0, count: self.columns+1)

		// create string representation of elements of each matrix row	
        var lines = [[String]]()	
		for r in 0..<self.rows
		{
			var curRow = [String]()

            // form row header
            let header = "R\(r):"
            curRow.append(header)
            colWidths[0] = max(colWidths[0], header.count)

			for c in 0..<self.columns
			{				
				let el = self[r, c]
                let s = _formatElement(el, self.format)
                curRow.append(s)

                // advance index by 1 because element 0 is row header
                colWidths[c+1] = max(colWidths[c+1], s.count)
			}			
			lines.append(curRow)
		}

        // pad each column in row to the max width, storing each row as single string
        var rowStrs = [String]()
        for rs in 0..<lines.count
        {
            var str = [String]() 
            for cs in 0..<lines[0].count
            {
                let s = lines[rs][cs]

                assert(s.count <= colWidths[cs], "Max column width was computed incorrectly")
                
                let pad = String(repeating: " ", count: colWidths[cs]-s.count)

                str.append(pad+s)
            }
            rowStrs.append(str.joined(separator: "   "))
        }

		return title + rowStrs.joined(separator: "\n")
	}

    /// Return matrix representation in unformatted, comma separated list.
    ///
    /// Elements of a row are comma separated. Rows are separated by newlines.
    public var rawDescription: String
    {   
        var s = [String]()
        for r in 0..<self.rows
        {
            let row = self[r, 0..<self.columns]
            let v = Vector(row)
            s.append(v.rawDescription)
        }

        return s.joined(separator: "\n")
    }
}
