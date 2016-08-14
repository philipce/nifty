/// Perform element wise matrix division, dividing by left matrix elements.
///
/// - Parameters
///     - A: left matrix
///     - B: right matrix
/// - Returns: element wise matrix division of A and B
func ldivide(_ A: Matrix, _ B: Matrix) -> Matrix
{
    assert(size(A) == size(B), "Matrices must have the same size")

    var newData = [Double]()
    for i in 0..<numel(A)
    {
        newData.append(B[i] / A[i])
    }

    return Matrix(size: size(A), data: newData)
}

