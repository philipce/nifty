
// TODO: add in comments and conform to matlab
public func transpose(_ A: Matrix) -> Matrix
{
	let transA = CblasTrans
	let transB = CblasTrans
	let m = Int32(A.size[0])
	let n = Int32(A.size[1])
	let k = Int32(A.size[1])
	let alpha = 1.0
	let a = A.data
	let lda = k
	let B = eye([Int(k), Int(n)])
	let b = B.data
	let ldb = n
	let beta = 0.0
	var c = Array<Double>(repeating: 0, count: Int(m)*Int(n))
	let ldc = m

	cblas_dgemm(CblasRowMajor, transA, transB, m, n, k, alpha, a, lda, b, ldb, beta, &c, ldc)

	return Matrix(size: [Int(k), Int(m)], data: c)
}