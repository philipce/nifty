
// currently, nifty and user code are built together, so there's no module
#if MODULAR
import Nifty
#endif

print("NIFTY")

// mldivide
print("\nSolving Ax=B for x...")
let A = Matrix(size: 2, 2, data: [1, 2, 3, 4])
let B = Matrix(size: 2, 2, data: [19, 22, 43, 50])
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

let n = 500
print("\nCreating \(n)-by-\(n) random integer matrix...")
tic()
let R2 = randi([n,n], imax: 99999)
let _ = toc(units: "ms")

print("\nInverting \(n)-by-\(n) random integer matrix...")
tic()
let R2inv = inv(R2)
let _ = toc(units: "ms")

