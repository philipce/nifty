import Core

/// Compute the LU decomposition for the given matrix.
///
/// Decomposition is done using the Crout algorithm.
///
/// - Parameters:
///     - A: m-by-n matrix to decompose
/// - Returns: tuple consisting of
///     - L: m-by-n lower triangular matrix with unit diagonal
///     - U: n-by-n upper triangular matrix 
///     - P: m-by-m permutation matrix, such that L*U = P*A
func lu(_ A: Matrix) -> (L: Matrix, U: Matrix, P: Matrix)
{
    // FIXME: implement this
    return (L: zeros([1,1]), U: zeros([1,1]), P: zeros([1,1]))
}
