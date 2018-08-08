
/***************************************************************************************************
 *  det.swift
 *
 *  This file provides inverse cosine functionality.
 *
 *  Author: Tor Rafsol Løseth
 *  Creation Date: 15 July 2010
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
 *  Copyright 2018 Tor Rafsol Løseth
 **************************************************************************************************/

/// Compute the determinant of an square matrix of size nxn.


#if NIFTY_XCODE_BUILD
import Accelerate
#else
import CLapacke
#endif


/// Returns the determinant of a square matrix.
///
/// - Parameter A: A square matrix data structure.
/// - Returns: The determinant.
///
public func det(_ A: Matrix<Double>) -> Double
{
    precondition(A.rows == A.columns, "Matrix must be square")
    
    var data = A.data
    let size = A.size
    
    var m = __CLPK_integer(size[0])
    var n = __CLPK_integer(size[1])
    var lda = m
    var pivots = [__CLPK_integer](repeating: 0, count: Int(n))
    var error: __CLPK_integer = 0
    
    #if NIFTY_XCODE_BUILD
    dgetrf_(&m, &n, &data, &lda, &pivots, &error)
    #else
    data = LAPACKE_dgetrf(LAPACK_ROW_MAJOR, &m, &n, &data, lda, &pivots)
    #endif
    
    let LU = Matrix(A.rows, A.columns, data)
    let diagonals = diag(A: LU)

    var det: Double = 1
    
    for pivot in 0..<Int(pivots.count) {
        
        let piv = Int(pivot)
        det *= diagonals.data[piv]
        
        //  dgetrf's IPIV (pivots here) tells how many row swaps for each row,
        //  if swaps are odd, mulitply by (-1), else if even by (1)
        //  dgetrf (as a subroutine in Fortran) don't use zero-indexing,
        //  so pivots is 1-indexed, hence the - 1.
        if (Int(pivots[piv]) - 1) != piv {
            det *= -1
        }
    }

    return det
}
