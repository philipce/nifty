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
/// withouth changing the meaning, yielding "A^2". However, exp="A+B" would need parentheses to 
/// yield "(A+B)^2" otherwise the expression ("A+B^2") would not have the same meaning. 
///
/// - Parameters:
///     - expression: expression to possibly parenthesize
/// - Returns: parenthesized expression, if needed
internal func _parenthesizeExpression(_ expression: String) -> String
{
    // TODO: this can be fancier, perhaps use regular expressions when linux and mac converge

    var expressionLiteralCharacters = CharacterSet.alphanumerics
    expressionLiteralCharacters.insert("_")

    // if expression is separated by whitespace, or contains any characters other than alphanumerics
    // or the underscore, enclose in parentheses
    if let _ = expression.rangeOfCharacter(from: expressionLiteralCharacters.inverted)
    {
        return "(\(expression))"        
    }
        
    return expression
}





/// Create a new instance of a NumberFormatter, copying values from the given instance.
///
/// - Parameters:
///    - format: instance to copy
/// - Returns: new formatter instance
internal func _copyNumberFormatter(_ format: NumberFormatter) -> NumberFormatter
{
    let fmt = NumberFormatter()
    fmt.numberStyle = format.numberStyle
    fmt.usesSignificantDigits = format.usesSignificantDigits
    fmt.paddingCharacter = format.paddingCharacter
    fmt.paddingPosition = format.paddingPosition
    fmt.formatWidth = format.formatWidth
    
    return fmt
}





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





/// Increment the first element of a given subscript, cascading carry values into the subsequent 
/// element if possible.
///
/// Note: row-major order is assumed; last dimension increments quickest.
///
/// - Parameters: 
///     - sub: subscript to increment
///     - min: min values for each element in list
///     - max: max values for each element in list
/// - Returns: incremented subscript or nil if list is already at max value
internal func _cascadeIncrementSubscript(_ sub: [Int], min: [Int], max: [Int]) -> [Int]?
{   
    let n = sub.count
    precondition(min.count == n && max.count == n, "Subscript, min, and max must match in dimension")
    
    var newSub = sub
    newSub[n-1] += 1 

    for i in stride(from: n-1, through: 0, by: -1)
    {
        if newSub[i] > max[i]
        {
            if i == 0
            {
                return nil
            }

            newSub[i] = min[i]
            newSub[i-1] = newSub[i-1] + 1
        }
        else
        {
            return newSub
        }
    }

    return nil
}





/// Format a vector/matrix/tensor element according to the given formatter.
///
/// If there's an error in formatting, e.g. the element can't fit in the given space or number 
/// formatting fails, a "#" is returned. Long non-numeric elements may be abbreviated by truncating 
/// and adding "...".
///
/// - Parameters:
///    - element: element to format
///    - format: formatter to use; will not be modified by function
/// - Returns: formatted string representation; string will not be padded to a particular width, but 
///     may include leading/trailing spaces to handle alignment (e.g. a leading space on positive
///     numbers to match the leading '-' on negatives)
internal func _formatElement<T>(_ element: T, _ format: NumberFormatter) -> String
{
    // copy format since it's a reference type
    let fmt = NumberFormatter()
    fmt.numberStyle = format.numberStyle
    fmt.usesSignificantDigits = format.usesSignificantDigits
    fmt.paddingCharacter = format.paddingCharacter
    fmt.paddingPosition = format.paddingPosition
    fmt.formatWidth = format.formatWidth

    // convert any numeric type to a double
    let doubleValue: Double?
    switch element 
    {
        case is Double:  doubleValue = (element as! Double)
        case is Float:   doubleValue = Double(element as! Float)
        case is Float80: doubleValue = Double(element as! Float80)
        case is Int:     doubleValue = Double(element as! Int)
        case is Int8:    doubleValue = Double(element as! Int8)
        case is Int16:   doubleValue = Double(element as! Int16)
        case is Int32:   doubleValue = Double(element as! Int32)
        case is Int64:   doubleValue = Double(element as! Int64)
        case is UInt:    doubleValue = Double(element as! UInt)
        case is UInt8:   doubleValue = Double(element as! UInt8)
        case is UInt16:  doubleValue = Double(element as! UInt16)
        case is UInt32:  doubleValue = Double(element as! UInt32)
        case is UInt64:  doubleValue = Double(element as! UInt64)
        default:         doubleValue = nil
    }

    // format numbers and strings differently
    if let el = doubleValue 
    {
        var s = fmt.string(from: NSNumber(value: abs(el))) ?? "#"

        // if element doesn't fit in desired width, format in minimal notation
        if s.count > fmt.formatWidth
        {
            fmt.maximumSignificantDigits = fmt.formatWidth-4 // for 'E-99'
            fmt.numberStyle = .scientific
            s = fmt.string(from: NSNumber(value: abs(el))) ?? "#"
        }

        // TODO: come up with better way to handle padding...
        // Rather than having all elements padded to a fixed width, the current approach is to strip
        // all padding, then let the caller examine the collection of elements to be printed and 
        // determine the minimal padding necessary.
        s = s.trimmingCharacters(in: .whitespacesAndNewlines)
        let sign = el < 0 ? "-" : ""
        s = sign + s      

        // TODO: NumberFormatter.Style.decimal shouldn't add commas according to current docs.
        // But it does, so for now, strip commas. We should change this though to allow users to 
        // specify whether or not to use commas.
        s = s.replacingOccurrences(of: ",", with: "")

        return s
    }
    else
    {
        var s = "\(element)"
        s = s.trimmingCharacters(in: .whitespacesAndNewlines)

        // abbreviate or squash s if needed
        if s.count > fmt.formatWidth
        {
            if fmt.formatWidth >= 4
            {
                let endIndex = s.index(s.startIndex, offsetBy: fmt.formatWidth-3)
                s = s[s.startIndex..<endIndex] + "..."
            }
            else
            {
                s = "#"
            }
        }

        return s
    }
}
