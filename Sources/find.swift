/***************************************************************************************************
 *  find.swift
 *
 *  This file defines functions for searching various data structures. 
 *
 *  Author: Philip Erickson
 *  Creation Date: 22 Feb 2017
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

// TODO: revisit this interface and reconcile with MATLAB!

public func find(in x: [Double], nearest: Double) -> Int
{
    return find(in: x, n: 1, nearest: nearest)[0]
}

public func find(in x: [Double], n: Int, nearest: Double) -> [Int]
{
    var diffs = [(Double, Int)]()
    for i in 0..<x.count { diffs.append((abs(x[i]-nearest), i)) }
    diffs.sort(by: {return $0.0 < $1.0})
    
    var nn = diffs[0..<n].map({$0.1})  
    nn.append(contentsOf: Array(repeating: -1, count: nn.count-n))
    
    return nn
}

public func find(in x: [Double], before: Double) -> Int
{
    return find(in: x, n: 1, before: before)[0]
}

public func find(in x: [Double], n: Int, before: Double) -> [Int]
{
    var diffs = [(Double, Int)]()     
    for i in 0..<x.count 
    {
        let diff = before-x[i]
        if diff > 0 { diffs.append((diff, i)) }
    }
    diffs.sort(by: {return $0.0 < $1.0})
    
    var nb = diffs[0..<n].map({$0.1})  
    nb.append(contentsOf: Array(repeating: -1, count: nb.count-n))
    
    return nb    
}

public func find(in x: [Double], after: Double) -> Int
{
    return find(in: x, n: 1, after: after)[0]
}

public func find(in x: [Double], n: Int, after: Double) -> [Int]
{
    var diffs = [(Double, Int)]()     
    for i in 0..<x.count 
    {
        let diff = x[i]-after
        if diff > 0 { diffs.append((diff, i)) }
    }
    diffs.sort(by: {return $0.0 < $1.0})
    
    var nb = diffs[0..<n].map({$0.1})  
    nb.append(contentsOf: Array(repeating: -1, count: nb.count-n))
    
    return nb    
}

