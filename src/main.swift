// currently, nifty and user code are built together, so there's no module
#if MODULAR
import Nifty
#endif

print("NIFTY")


// mldivide
print("\nSolving Ax=B for x...")
let A = Matrix(size: 2, data: [1, 2, 3, 4])
let B = Matrix(size: 2, data: [19, 22, 43, 50])
let x = mldivide(A, B)
print("Matrix A = \(A)")
print("Matrix B = \(B)")
print("x = \(x)")

// inv
print("\nInverting A...")
let Ainv = inv(A)
print("A' = \(Ainv)")

// randi
print("\nCreating random integer matrix...")
let R = randi([5,5], imax: 345)
print("R = \(R)")

// average inv of large matrix
let numTrials = 3
let n = 5000
var createTimes: [Double] = []
var invertTimes: [Double] = []

print("\nCreating then inverting \(n)-by-\(n) random integer matrix \(numTrials) times...")
for i in 0..<numTrials
{
	tic()
	let M = randi([n,n], imax: 99999)
	createTimes.append(toc())

	tic()
	let Minv = inv(M)
	invertTimes.append(toc())
}

print("Create: mean=\(mean(createTimes))s, std=\(std(createTimes))s")
print("Invert: mean=\(mean(invertTimes))s, std=\(std(invertTimes))s")