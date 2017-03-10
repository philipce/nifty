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

// FIXME: these all fail if an empty list is queried!

public func find(in x: [Double], nearest: Double, order: SeriesIndexOrder) -> Int
{
    return find(in: x, n: 1, nearest: nearest, order: order)[0]
}

public func find(in x: [Double], n: Int, nearest: Double, order: SeriesIndexOrder) -> [Int]
{    

    precondition(n > 0, "Find cannot search for less than 1 element")

    switch order 
    {
        case .increasing, .nonDecreasing:

            let (i, _) = binarySearch(nonDecreasingList: x, for: nearest)

            var nn = [i]
            var l = i-1
            var r = i+1
            while nn.count < n
            {
                let lval = l > 0 ? x[l] : Double.infinity
                let rval = r < x.count ? x[r] : Double.infinity

                if abs(lval-nearest) < abs(rval-nearest)
                {
                    nn.append(l > 0 ? l : -1)
                    l -= 1
                }
                else
                {
                    nn.append(r < x.count ? r : -1)
                    r += 1
                }
            }

            return nn

        default:

            var diffs = [(Double, Int)]()
            for i in 0..<x.count { diffs.append((abs(x[i]-nearest), i)) }
            diffs.sort(by: {return $0.0 < $1.0})
            
            var nn = diffs[0..<n].map({$0.1})  
            nn.append(contentsOf: Array(repeating: -1, count: nn.count-n))
            
            return nn
    }
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

//==================================================================================================
// MARK: - INTERNAL HELPER FUNCTIONS
//==================================================================================================

func binarySearch(nonDecreasingList list: [Double], for item: Double) -> (i: Int, found: Bool)
{
    var iLower = 0
    var iUpper = list.count-1

    var iCur: Int 
    while true
    {
        iCur = (iUpper+iLower)/2

        if list[iCur] == item // FIXME: proper double compare
        {
            return (iCur, true)
        }
        else if iLower >= iUpper
        {
            let i = abs(list[iLower]-item) < abs(list[iUpper]-item) ? iLower : iUpper
            return (i, false)
        }
        else if list[iCur] < item
        {
            iLower = iCur+1
        }
        else
        {
            iUpper = iCur-1
        }
    }
}