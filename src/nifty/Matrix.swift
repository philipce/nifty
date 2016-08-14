
public struct Matrix: CustomStringConvertible
{
	public let numel: Int
	public var size: [Int]
	public var data: [Double]

	public var description: String
	{
		return "\(self.data)"
	}

	/* TODO:
	public init(size: Int..., value: Double)
	{

	}
	*/
	
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
}
