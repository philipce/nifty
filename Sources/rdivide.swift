/***************************************************************************************************
 *  rdivide.swift
 *
 *  This file provides functionality for scalar division of vectors, matrices, and tensors. 
 *
 *  Author: Philip Erickson
 *  Contributors: Félix Fischer
 *  Creation Date: 15 Mar 2017
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
 *  Copyright 2017 Philip Erickson
 **************************************************************************************************/

public func / (left: Matrix<Double>, right: Double) -> Matrix<Double>
{
    var m = left
    m.data = m.data.map({$0/right})
    return m
}

public func / (left: Matrix<Double>, right: Int) -> Matrix<Double>
{
    var m = left
    m.data = m.data.map({$0/Double(right)})
    return m
}


public func / (left: Tensor<Double>, right: Double) -> Tensor<Double>
{
    var t = left
    t.data = t.data.map({$0/right})
    return t
}

public func / (left: Tensor<Double>, right: Int) -> Tensor<Double>
{
    var t = left
    t.data = t.data.map({$0/Double(right)})
    return t
}