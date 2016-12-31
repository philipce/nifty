/**************************************************************************************************
 *  cross.swift
 *
 *  This file defines singular value decomposition functionality. 
 *
 *  Author: Philip Erickson
 *  Creation Date: 29 Dec 2016
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

import CLapacke

/// Return the singular values of a given matrix.
///
/// - Parameters:
///    - A: matrix to find singular values of
/// - Returns: singular values of A, sorted in descending order
public func svd(_ A: Matrix<Double>) -> [Double]
{    

    let jobz: Int8 = 78 // ascii 'N'
    let m = Int32(A.rows)
    let n = Int32(A.columns)

    var a = A.data

    // The leading dimension equals the number of elements in the major dimension. In this case,
    // we are doing row-major so lda is the number of columns in A.
    let lda = n

    // s is a double array, dimension (min(M,N)). 
    // The singular values of A, sorted so that s(i) >= s(i+1).
    var s = [Double](repeating: 0.0, count: Int(min(m,n)))

    // U is not referenced since jobz='N'
    var u = [0.0]
    let ldu: Int32 = 1

    // VT is not referenced since jobz='N'
    var vt = [0.0]
    let ldvt = m    

    let info = LAPACKE_dgesdd(LAPACK_ROW_MAJOR, jobz, m, n, &a, lda, &s, &u, ldu, &vt, ldvt)
    precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
    if info > 0
    {
        print("Warning: DBDSDC did not converge, updating process failed.")
    }    

    return s
}

/// Perform a singular value decomposition of a given matrix.
///
/// - Parameters:
///    - A: matrix to find singular values of
/// - Returns: matrices U, S, and V such that A=U*S*transpose(V)
public func svd(_ A: Matrix<Double>) -> (U: Matrix<Double>, S: Matrix<Double>, V: Matrix<Double>)
{
    let jobz: Int8 = 65 // ascii 'A'
    let m = Int32(A.rows)
    let n = Int32(A.columns)

    // The leading dimension equals the number of elements in the major dimension. In this case,
    // we are doing row-major so lda is the number of columns in A.
    let lda = n

    var a = A.data

    // s is a double array, dimension (min(M,N)). 
    // The singular values of A, sorted so that s(i) >= s(i+1).
    var s = [Double](repeating: 0.0, count: Int(min(m,n)))

    // U is an m x m matrix; ldu is the leading dimension
    var u = [Double](repeating: 0.0, count: Int(m*m))
    let ldu = m

    // VT is an n x n matrix; ldvt is the leading dimension
    var vt = [Double](repeating: 0.0, count: Int(n*n))
    let ldvt = n    

    let info = LAPACKE_dgesdd(LAPACK_ROW_MAJOR, jobz, m, n, &a, lda, &s, &u, ldu, &vt, ldvt)
    precondition(info >= 0, "Illegal value in LAPACK argument \(-1*info)")
    if info > 0
    {
        print("Warning: DBDSDC did not converge, updating process failed.")
    }    

    var nameU: String? = nil
    var nameS: String? = nil
    var nameV: String? = nil    
    if let nameA = A.name
    {
        nameU = "svd(\(nameA)).U"
        nameS = "svd(\(nameA)).S"
        nameV = "svd(\(nameA)).V"
    }

    let U = Matrix(Int(m), u, name: nameU, showName: A.showName)

    // S is an m x n matrix with the singular values descending on the main diagonal 
    // TODO: we should extend the diag() function from matlab to handle non square matrices and use it here
    var S = zeros(Int(m), Int(n))
    for i in 0..<s.count
    {
        S[i,i] = s[i]
    }    
    S.name = nameS
    S.showName = A.showName

    let VT = Matrix(Int(n), vt)
    var V = transpose(VT)
    V.name = nameV 
    V.showName = A.showName

    return (U, S, V)
}
