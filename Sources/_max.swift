
/***************************************************************************************************
 *  _max.swift
 *
 *  This file defines functionality for computing the max
 *
 *  Author: Félix Fischer
 *  Creation Date: 23 May 2017
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
 *  Copyright 2017 Félix Fischer
 **************************************************************************************************/

// FIXME: implement Tensor and dim-dependent Matrix variants 

public func max(_ T: Tensor<Double>) -> Double {
    return max(T.data)
}

public func max(_ A: Matrix<Double>) -> Double {
    return max(A.data)
}

public func max(_ v: Vector<Double>) -> Double {
    return max(v.data)
}

public func max(_ list: [Double]) -> Double
{
    var m = list[0]
    for el in list { m = el > m ? el : m }
    return m
}