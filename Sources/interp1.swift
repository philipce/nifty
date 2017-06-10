/***************************************************************************************************
 *  interp1.swift
 *
 *  This file provides 1-dimensional interpolation functionality. 
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

// TODO: revisit this interface and reconcile it with MATLAB!

public func interp1<T>(x: [Double], y: [T], query: [Double], order: DataSeriesIndexOrder, method: Nifty.Options.EstimationMethod = .nearlin) -> [T]
{
    // TODO: how to handle duplicate values? ...
    // If two identical indexes exist, which should be used? For now, just use the first one found
    
    precondition(x.count == y.count, "Data for x and y must be same size")    
    if x.isEmpty || query.isEmpty { return [] }
    
    
    
    var qValues = [T]()    
    switch method
    {
    case .nearest:
        
        for q in query
        {
            let i = find(in: x, nearest: q, order: order)
            assert(i >= 0, "Not possible--conditions were checked so find should not return -1")
            qValues.append(y[i])            
        }
        
    case .nearlin:
        
        for q in query
        {
            let i = find(in: x, nearest: q, order: order)
            var left: Int? = nil
            var right: Int? = nil
            
            // if query point exists in series, just add it and move on
            if x[i] == q { qValues.append(y[i]); continue } // FIXME: proper double compare
                
                // otherwise find points to one (or both) sides for estimation                  
            else if x[i] < q 
            {
                left = i            
                for j in i+1..<x.count 
                {
                    if x[j] > q { right = j; break }                    
                }
            }
            else 
            {
                right = i
                for j in stride(from: i-1, through: 0, by: -1)
                {
                    if x[j] < q { left = j; break }
                }
            }
            
            // check if data type can be downcast to double
            var isDouble = T.self == Double.self
            if let _ = y[0] as? Double { isDouble = true }
            
            // if there is data to the left and right and type is a double, linterp is possible
            if let li = left, let ri = right, isDouble
            {
                // TODO: put this into a seperate linterpBetween2Pts function
                let xFrac = (q-x[li])/(x[ri]-x[li])
                assert(xFrac >= 0.0 && xFrac <= 1.0, "Expected q to be above left, below right")
                let yDiff = (y[ri] as! Double)-(y[li] as! Double)
                let qVal = (y[li] as! Double) + xFrac*yDiff
                qValues.append(qVal as! T)
                continue
            }
                
                // otherwise, just use nearest neighbor
            else                
            {
                let ni: Int
                if let li = left, let ri = right { ni = abs(x[li]-q) <= abs(x[ri]-q) ? li : ri }
                else { ni = left ?? right! }                
                qValues.append(y[ni])
            }
        }
        
    default:
        fatalError("Interpolation method not supported: \(method)")
    }
    
    return qValues    
}
