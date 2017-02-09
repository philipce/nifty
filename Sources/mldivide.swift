/***************************************************************************************************
 *  mldivide.swift
 *
 *  This file provides functionality for solving systems of linear equations. 
 *
 *  Author: Philip Erickson
 *  Creation Date: 1 May 2016
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

#if NIFTY_XCODE_BUILD
import Accelerate
#else
import CLapacke
#endif

infix operator -/ : MultiplicationPrecedence
public func -/ (left: Matrix<Double>, right: Matrix<Double>) -> Matrix<Double>
{
    return mldivide(left, right)
}

/// Solve the system of linear equations Ax = B for x.
///
/// If A is not square then the solution will be the least-squares solution to the system.
///
/// Alternatively, `mldivide(A, B)` can be executed with `A-/B`.
///
/// - Parameters:
///     - A: matrix A in the equation Ax = B
///     - B: matrix B in the equation Ax = B
/// - Returns: matrix x in the equation Ax = B
public func mldivide(_ A: Matrix<Double>, _ B: Matrix<Double>) -> Matrix<Double>
{   
    // inherit name
    var newName: String? = nil
    if let nameA = A.name, let nameB = B.name
    {
        newName = "\(nameA)-/\(nameB)"
    }

    // solve if A is square
    if A.size[0] == A.size[1]
    {
        var n = Int32(A.size[0])
        var nrhs = Int32(B.size[1])
        var a = A.data  
        var b = B.data

        // The leading dimension equals the number of elements in the major dimension. In this case,
        // we are doing row-major so lda is the number of columns in A, e.g.
        var lda = Int32(A.size[1])
        var ldb = Int32(B.size[1])

        var ipiv = Array<Int32>(repeating: 0, count: Int(n))
        var info = Int32(0)

        // TODO: find better way to resolve the difference between clapack used by Accelerate and LAPACKE
        #if NIFTY_XCODE_BUILD
            
            // Everything is column-major order when using Accelerate 
            let At = transpose(A)
            let Bt = transpose(B)
            var at = At.data  
            var bt = Bt.data
            lda = Int32(A.size[0])
            ldb = Int32(B.size[0])
            dgesv_(&n, &nrhs, &at, &lda, &ipiv, &bt, &ldb, &info)
            b = transpose(Matrix(Bt.size, bt)).data 
            
        #else
        
           info = LAPACKE_dgesv(LAPACK_ROW_MAJOR, n, nrhs, &a, lda, &ipiv, &b, ldb)
            
        #endif
        
        precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
        precondition(info == 0, "Cannot solve singularity")
        
        return Matrix(Int(n), Int(nrhs), b, name: newName, showName: A.showName || B.showName)                    
    }

    // otherwise return least-squares solution
    else
    {        
        var m = Int32(A.size[0])
        var n = Int32(A.size[1])
        
        // overdetermined system
        if m >= n
        {
            
            
            // TODO: find better way to resolve the difference between clapack used by Accelerate and LAPACKE
            #if NIFTY_XCODE_BUILD
                
                var nrhs = Int32(B.size[1])
                var a = A.data
                var b = B.data
                var info = Int32(0)
            
                // Everything is column-major order when using Accelerate 
                a = transpose(A).data
                let Bt = transpose(B)
                b[0..<Bt.count] = Bt.data[0..<Bt.count]                  
                var lda = Int32(A.size[0])
                var ldb = Int32(B.size[0])
                                
                // TODO: redo this with 'T' to save an extra transpose
                var trans: Int8 = 78 // ascii 'n' (ascii 'T' = 84)    
                let mn = min(m, n) 
                var lwork = mn + max(mn, nrhs) // TODO: revisit this for optimal performance... see lapack docs 
                var work = Array<Double>(repeating: 0, count: Int(lwork))

                dgels_(&trans, &m, &n, &nrhs, &a, &lda, &b, &ldb, &work, &lwork, &info)    
                
                precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
                if info != 0 { print("Warning: Matrix does not have full rank") }   
                
                // TODO: Bout also contains errors... should we return these as well?
                let Bout = transpose(Matrix(Int(nrhs), Int(m), b))                
                var X = Bout[0..<Int(n), 0..<Int(nrhs)]
                X.name = newName
                X.showName = A.showName || B.showName

                return X

            #else              

                let nrhs = Int32(B.size[1])
                var a = A.data
                var b = B.data
                var info = Int32(0)
                
                // The leading dimension equals the number of elements in the major dimension. In this 
                // case, we are doing row-major so lda is the number of columns in A, e.g.
                let lda = Int32(A.size[1])
                let ldb = Int32(B.size[1])

                let trans: Int8 = 78 // ascii 'N'
                info = LAPACKE_dgels(LAPACK_ROW_MAJOR, trans, m, n, nrhs, &a, lda, &b, ldb)
            
                precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
                if info != 0 { print("Warning: Matrix does not have full rank") }            

                let x = Array(b[0..<Int(n*nrhs)])  

                return Matrix(Int(n), Int(nrhs), x, name: newName, showName: A.showName || B.showName)          

            #endif                            
        }

        // underdetermined system
        else
        {
            
            var nrhs = Int32(B.size[1])
            var a = A.data

            // solution is larger than B so extra space must be added
            var b = Array<Double>(repeating: 0, count: Int(n*nrhs))
                  
            var info = Int32(0)
            
            // TODO: find better way to resolve the difference between clapack used by Accelerate and LAPACKE
            #if NIFTY_XCODE_BUILD
                                                
                // Everything is column-major order when using Accelerate 
                a = transpose(A).data
                let Bt = transpose(B)
                b[0..<Bt.count] = Bt.data[0..<Bt.count]                  
                var lda = Int32(A.size[0])
                var ldb = max(m,n) // FIXME: seems like this should be Int32(B.size[0]), why is it max(1,m,n) in docs?
                                
                // TODO: redo this with 'T' to save an extra transpose
                var trans: Int8 = 78 // ascii 'n' (ascii 'T' = 84)	
                let mn = min(m, n) 
                var lwork = mn + max(mn, nrhs) // TODO: revisit this for optimal performance... see lapack docs 
                var work = Array<Double>(repeating: 0, count: Int(lwork))
                dgels_(&trans, &m, &n, &nrhs, &a, &lda, &b, &ldb, &work, &lwork, &info)    
                                    
                precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
                if info != 0 { print("Warning: Matrix does not have full rank") }   
                
                let x = Array(b[0..<Int(n*nrhs)]) 

                let Xt = Matrix(Int(nrhs), Int(n), x, name: newName, showName: A.showName || B.showName)
                var X = transpose(Xt)
                X.name = Xt.name
                X.showName = Xt.showName

                return X
                
            #else
                
                // The leading dimension equals the number of elements in the major dimension. In this 
                // case, we are doing row-major so lda is the number of columns in A, e.g.
                let lda = Int32(A.size[1]) 
                let ldb = Int32(B.size[1])    
                    
                b[0..<B.count] = B.data[0..<B.count]      
                                    
                let trans: Int8 = 78 // ascii 'N'            
                info = LAPACKE_dgels(LAPACK_ROW_MAJOR, trans, m, n, nrhs, &a, lda, &b, ldb)
                    
                precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
                if info != 0 { print("Warning: Matrix does not have full rank") }   
                
                let x = Array(b[0..<Int(n*nrhs)])          
                
                return Matrix(Int(n), Int(nrhs), x, name: newName, showName: A.showName || B.showName)

            #endif  
        }
    }
}
