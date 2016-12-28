/***************************************************************************************************
 *  _internal_helpers.swift
 *
 *  This file provides miscellaneous helpers used internally by Nifty that aren't closely related to 
 *  any other specific source file. 
 *
 *  Author: Phil Erickson
 *  Creation Date: 27 Dec 2016
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

import Foundation





/// Enclose a given expression in parentheses if necessary.
/// 
/// If expression consists of a single literal then there is no need to enclose in parentheses, 
/// since there would be no ambiguity when combined with another expression. If the expression
/// contains operators however, the expression may need parentheses to retain the same meaning when
/// combined with another expression.
///
/// For example, the expression exp="A" could be directly inserted into the expression "\(exp)^2" 
/// withouth ambiguity, yielding "A^2". However, exp="A+B" would need parentheses to yield "(A+B)^2"
/// otherwise the expression ("A+B^2") would not have the same meaning. 
///
/// - Parameters:
///     - expression: expression to possibly parenthesize
/// - Returns: parenthesized expression, if needed
internal func _parenthesizeExpression(_ expression: String) -> String
{
    // TODO: this can be fancier, perhaps use regular expressions when linux and mac converge

    // if expression is separated by whitespace, or contains any characters other than alphanumerics
    // or the underscore, enclose in parentheses
    if let _ = expression.rangeOfCharacter(from: expressionLiteralCharacters.inverted)
    {
        return expression
    }
    else
    {
        return "(\(expression))"
    }
}

fileprivate let expressionLiteralCharacters = CharacterSet(charactersIn: "_").union(CharacterSet.alphanumerics) 





/// Convert LAPACK pivot indices to permutation matrix.
///
/// From LAPACK description of ipiv: for 1 <= i <= min(M,N), row i of the matrix was interchanged 
/// with row IPIV(i)/
///
/// For example: ipiv=[3,3,3]. This indicates that first row 1 of the matrix was changed with row 3,
///    then row 2 was changed with row 3, then row 3 was changed with row 3. These changes, when 
/// applied to a 3x3 identity matrix, result in the permutation matrix P=[[0,0,1],[1,0,0],[0,1,0]].
///
/// - Parameters:
///        - ipiv: pivot indices; note LAPACK pivots are 1-indexed
///        - m: number of rows in matrix to permute
///        - n: number of columns in matrix to permute
/// - Returns: permutation matrix
internal func _ipiv2p(ipiv: [Int32], m: Int32, n: Int32) -> Matrix<Double>
{
    // FIXME: revisit this for 1) correctness and 2) efficiency
    // 1) currently just assuming the permutation matrix starts out as an mxn identity. Is that ok?
    // 2) current impl is terribly inefficient, going through and performing each swap rather than 
    // resolving the final swaps and only doing those.
    
    precondition(Int32(ipiv.count) == m, "Expected the number of pivot indices to match number of rows")

    var P = eye(Int(m),Int(n))
    for r in 0..<Int(m)
    {
        P = swap(rows: r, Int(ipiv[r])-1, in: P)
    }

    return P
}