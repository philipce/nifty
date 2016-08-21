// import if makefile built separate modules
#if NIFTY
import Nifty
#endif

print("********************")
print("NIFTY")
print("********************")

// wrap stuff in function to avoid creating global vars
public func main()
{
    //-----------------------------------------------
    // format number string
    print("\n--------------------")
    print("Formatting number string...")
    print(formatNumber(n:123.45, places:1, width:10, exponent:0))
    print(formatNumber(n:123.45, places:1, width:10, exponent:2))
    print(formatNumber(n:123.45, places:4, width:10, exponent:2))
    print(formatNumber(n:123.45, places:6, width:10, exponent:2))
    print(formatNumber(n:123.45, places:7, width:10, exponent:2))

	//-----------------------------------------------
	// matrix subscript
	print("\n--------------------")
	print("Subscripting matrix S...")
	let S = Matrix(size: [3,2], data: [11, 12, 21, 22, 31, 32], name: "S")
	print(S)
	print("Data in S: \(S.data)")
	print("S[0,0]=\(S[0,0])")
	print("S[0,1]=\(S[0,1])")
	print("S[1,0]=\(S[1,0])")
	print("S[1,1]=\(S[1,1])")
	print("S[0]=\(S[0])")
	print("S[1]=\(S[1])")
	print("S[2]=\(S[2])")

	//-----------------------------------------------
	// mldivide
	print("\n--------------------")
	print("Solving Ax=B for x...")
	let A = Matrix(size: 2, data: [1, 2, 3, 4], name: "A")
	let B = Matrix(size: 2, data: [19, 22, 43, 50], name: "B")
	let x = Matrix(copy: A-/B, rename: "x, where Ax=B")
	print(A)
	print(B)
	print(x)

	print("\n--------------------")
	print("Solving overdetermined Ax=B for x...")
	let A2 = Matrix(data: [[1,1,1], [2,3,4], [3,5,2], [4,2,5], [5,4,3]])
	let B2 = Matrix(size: [5, 2], data: [-10,-3,12,14,14,12,16,16,18,16])
	let x2 = A2-/B2
	print("Matrix A2 = \(A2)")
	print("Matrix B2 = \(B2)")
	print("x2 = \(x2)")

	print("\n--------------------")
	print("Solving underdetermined Ax=B for x...")
	let A3 = Matrix(data: [[99, 261, 196], [262, 132, 27]])
	let B3 = Matrix(size: [2, 1], data: [19, 184])
	let x3 = A3-/B3
	print("Matrix A3 = \(A3)")
	print("Matrix B3 = \(B3)")
	print("x3 = \(x3)")

	print("\n--------------------")
	print("Solving underdetermined Ax=B for x...")
	let A4 = Matrix(size: [3,4], data: [0.5,0.5,0.5,0.5,0.5,-1.5,0.5,-1.5,1,1,0,1])
	let B4 = Matrix(size: [3,4], data: [1,1,1,0,1,-1,2.5,1,1,1,3,0])
	let x4 = A4-/B4
	print("Matrix A4 = \(A4)")
	print("Matrix B4 = \(B4)")
	print("x4 = \(x4)")

	//-----------------------------------------------
	// inv
	print("\n--------------------")
	print("Inverting A...")
	let Ainv = ~A
	print("~A = \(Ainv)")

	//-----------------------------------------------
	// randi
	print("\n--------------------")
	print("Creating random integer matrix R...")
	let R = randi([5,5], imax: 345)
	print("R = \(R)")

	//-----------------------------------------------
	// transpose
	print("\n--------------------")
	print("Transposing R...")
	let Rtrans = R.~
	print("R.~ = \(Rtrans)")

	//-----------------------------------------------
	// mean
	print("\n--------------------")
	let n_vm = 100000
	print("Taking mean of \(n_vm) uniform numbers 0-100...")
	let V = randi([1,n_vm], imax:100)
	tic()
	let mu = mean(V.data)
	let _ = toc(units: "ms")
	print("mean=\(mu)")

	//-----------------------------------------------
	// std
	print("\n--------------------")
	print("Taking standard deviation of \(n_vm) uniform numbers 0-100...")
	tic()
	let s = std(V.data)
	let _ = toc(units: "ms")
	print("std=\(s)")

	//-----------------------------------------------
	// average stats for large matrix ops
	let numTrials = 2
	let n = 500
	var createTimes: [Double] = []
	var invertTimes: [Double] = []
	var transposeTimes: [Double] = []

	print("\n--------------------")
	print("Creating, inverting, and transposing \(n)-by-\(n) random matrix \(numTrials) times...")

	for _ in 0..<numTrials
	{
		tic()
		let M = randi([n,n], imax: 99999)
		createTimes.append(toc())

		tic()
		let _ = inv(M)
		invertTimes.append(toc())

		tic()
		let _ = transpose(M)
		transposeTimes.append(toc())
	}

	print("Create: mean=\(mean(createTimes))s, std=\(std(createTimes))s")
	print("Invert: mean=\(mean(invertTimes))s, std=\(std(invertTimes))s")
	print("Transpose: mean=\(mean(transposeTimes))s, std=\(std(transposeTimes))s")	
}

main()
