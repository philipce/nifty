/*******************************************************************************
 *  operators.swift
 *
 *  This file overloads/defines all operators in Nifty, calling outside 
 *  functions for anything but the simplest of operators.
 *
 *  Author: Philip Erickson
 *  Creation Date: 1 May 2016
 *  Contributors: 
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  Copyright 2016 Philip Erickson
 ******************************************************************************/

//==============================================================================
// MARK: OPERATOR DECLARATIONS
//==============================================================================
infix operator .* {associativity left precedence 150}
infix operator ./ {associativity left precedence 150}
infix operator ** {associativity left precedence 160}
infix operator .** {associativity left precedence 160}

//==============================================================================
// MARK: NUMERIC OPERATORS
//==============================================================================
/// Raise a double to a double power.
func ** (left: Double, right: Double) -> Double 
{ 
    return pow(left, right) 
}

/// Raise a double to an integer power.
func ** (left: Double, right: Int) -> Double
{
    return pow(left, Double(right))
}

/// Raise an integer to a double power.
func ** (left: Int, right: Double) -> Double
{
    return pow(Double(left), right)
}

/// Raise an integer to an integer power
func ** (left: Int, right: Int) -> Int
{
    return Int(pow(Double(left), Double(right)))
}

//==============================================================================
// MARK: MATRIX COMPARISON OPERATORS
//==============================================================================
/// Matrix less-than comparison
func < (left: Matrix, right: Matrix)    -> Matrix { return lt(left, right) }
func < (left: Matrix, right: Double)    -> Matrix { return lt(left, right) }
func < (left: Matrix, right: Int)       -> Matrix { return lt(left, right) }
func < (left: Double, right: Matrix)    -> Matrix { return lt(left, right) }
func < (left: Int, right: Matrix)       -> Matrix { return lt(left, right) }

/// Matrix less-than or equal-to comparison
func <= (left: Matrix, right: Matrix)   -> Matrix { return le(left, right) }
func <= (left: Matrix, right: Double)   -> Matrix { return le(left, right) }
func <= (left: Matrix, right: Int)      -> Matrix { return le(left, right) }
func <= (left: Double, right: Matrix)   -> Matrix { return le(left, right) }
func <= (left: Int, right: Matrix)      -> Matrix { return le(left, right) }

/// Matrix greater-than comparison
func > (left: Matrix, right: Matrix)    -> Matrix { return gt(left, right) }
func > (left: Matrix, right: Double)    -> Matrix { return gt(left, right) }
func > (left: Matrix, right: Int)       -> Matrix { return gt(left, right) }
func > (left: Double, right: Matrix)    -> Matrix { return gt(left, right) }
func > (left: Int, right: Matrix)       -> Matrix { return gt(left, right) }

/// Matrix greater-than or equal-to comparison
func >= (left: Matrix, right: Matrix)   -> Matrix { return ge(left, right) }
func >= (left: Matrix, right: Double)   -> Matrix { return ge(left, right) }
func >= (left: Matrix, right: Int)      -> Matrix { return ge(left, right) }
func >= (left: Double, right: Matrix)   -> Matrix { return ge(left, right) }
func >= (left: Int, right: Matrix)      -> Matrix { return ge(left, right) }

/// Matrix element wise equals 
func == (left: Matrix, right: Matrix)   -> Matrix { return eq(left, right) }
func == (left: Matrix, right: Double)   -> Matrix { return eq(left, right) }
func == (left: Matrix, right: Int)      -> Matrix { return eq(left, right) }
func == (left: Double, right: Matrix)   -> Matrix { return eq(left, right) }
func == (left: Int, right: Matrix)      -> Matrix { return eq(left, right) }

/// Matrix element wise not equals
func != (left: Matrix, right: Matrix)   -> Matrix { return ne(left, right) }
func != (left: Matrix, right: Double)   -> Matrix { return ne(left, right) }
func != (left: Matrix, right: Int)      -> Matrix { return ne(left, right) }
func != (left: Double, right: Matrix)   -> Matrix { return ne(left, right) }
func != (left: Int, right: Matrix)      -> Matrix { return ne(left, right) }

//==============================================================================
// MARK: MATRIX ARITHMETIC OPERATORS
//==============================================================================
/// Element wise Matrix add.
func + (left: Matrix, right: Matrix) -> Matrix
{
    return plus(left, right)
}

// TODO: put in add/subtract for A + 1, e.g.

/// Element wise Matrix subtract.
func - (left: Matrix, right: Matrix) -> Matrix
{
    return minus(left, right)
}

/// Element wise Matrix multiply.
func .* (left: Matrix, right: Matrix) -> Matrix
{
    return times(left, right)
}

/// Element wise right Matrix divide.
func ./ (left: Matrix, right: Matrix) -> Matrix
{
    return rdivide(left, right)
}

// TODO: add all parameter combos
func .** (left: Matrix, right: Double) -> Matrix
{
    return power(left, right)
}

// TODO: scalar multiply
//func * (left: Matrix, right: Double) -> Matrix
//func * (left: Double, right: Matrix) -> Matrix
//func * (left: Matrix, right: Int) -> Matrix
//func * (left: Int, right: Matrix) -> Matrix





// TODO: negate
//prefix func - (matrix: Matrix) -> Matrix 


/// Matrix multiply.
func * (left: Matrix, right: Matrix) -> Matrix
{
    return mtimes(left, right)
}

/// Matrix transpose.
postfix operator ~ {}

postfix func ~ (A: Matrix) -> Matrix
{
    return transpose(A)
}

// TODO: add all parameter combos
func ** (left: Matrix, right: Double) -> Matrix
{
    return mpower(left, right)
}

// TODO: right matrix divide
//func / (left: Matrix, right: Matrix) -> Matrix

// TODO: left matrix divide
//infix operator \ {associativity left precedence 150}
//func \ (left: Matrix, right: Matrix) -> Matrix

// TODO: outer product?

// TODO: cross product?








