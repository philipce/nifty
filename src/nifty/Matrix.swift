
// TODO: revisit
public protocol Slice {}
extension Int: Slice {}
extension CountableRange: Slice {}
extension CountableClosedRange: Slice {}

public struct Matrix: CustomStringConvertible
{
	public let numel: Int
	public var size: [Int]
	public var data: [Double]

	public init(size: Int..., value: Double)
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
	
	public init(size: Int..., data: [Double])
	{
		// TODO: allow single digit input to be square matrix

		precondition(size.count == 2, "Matrix must be 2-D")
		self.size = size

		let numel = self.size[0] * self.size[1]
		precondition(numel > 0, "Matrix have at least 1 element")
		self.numel = numel

		precondition(data.count == numel, "Matrix dimensions must match data")
		self.data = data
	}

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

	// FIXME: implement
	public subscript(_ s: Slice...) -> Matrix
	{
		get { assert(false, "Unimplemented"); return self }
		set { assert(false, "Unimplemented")}
	}

	// FIXME: implement this so it prints in an aligned grid
	public var description: String
	{
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

	// FIXME: implement
	private func _isValidIndex(_ i: Int) -> Bool
	{
		//assert(false, "Unimplemented")
		return true
	}

	// FIXME: implement
	private func _isValidSubscript(_ s: [Int]) -> Bool
	{
		assert(false, "Unimplemented")
		return true
	}

	// FIXME: implement
	private func _isValidSlice(_ s: [Slice]) -> Bool
	{
		assert(false, "Unimplemented")
		return true
	}

}
