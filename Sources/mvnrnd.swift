/***************************************************************************************************
 *  mvnrnd.swift
 *
 *  This file provides multivariate normal random numbers.
 *
 *  Author: Philip Erickson
 *  Creation Date: 17 Jan 2017
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

// Algorithm based on:
// Press, William H. "Numerical recipes 3rd edition: The art of scientific computing.", Cambridge 
// university press, 2007. Chapter 7.4, pg 379.

/// Compute a vector of multivariate normal random numbers.
///
/// - Parameters:
///    - mu: d-dimensionsal mean vector
///    - sigma: d-by-d symmetric positive semi-definite covariance matrix
///    - seed: optionally provide specific seed for generator. If threadSafe is set, this seed will
///        not be applied to global generator, but to the temporary generator instance
///    - threadSafe: if set to true, a new random generator instance will be created that will be 
///        be used and exist only for the duration of this call. Otherwise, global instance is used.
/// - Returns: d-dimensional vector from the given distribution
public func mvnrnd(mu: Vector<Double>, sigma: Matrix<Double>, seed: UInt64? = nil, 
    threadSafe: Bool = false) -> Vector<Double>
{
    let d = mu.count
    precondition(sigma.size == [d, d], "Sigma must be d-by-d matrix")

    let y = randn(mu.count, 1, mean: 0.0, std: 1.0, seed: seed, threadSafe: threadSafe) 
    let L = chol(sigma, .lower)
    let Ly = L*y


    var v = Vector(Ly)
    for i in 0..<d
    {
        v[i] += mu[i]
    }    
    v.name = mu.name != nil && sigma .name != nil ? "mvnrnd(\(mu.name!), \(sigma.name!))" : nil
    v.showName = mu.showName || sigma.showName

    return v
}

/// Compute multiple vectors of multivariate normal random numbers.
///
/// - Parameters:
///    - mu: d-dimensionsal mean vector
///    - sigma: d-by-d symmetric positive semi-definite covariance matrix
///    - cases: number of vectors to generate
///    - seed: optionally provide specific seed for generator. If threadSafe is set, this seed will
///        not be applied to global generator, but to the temporary generator instance
///    - threadSafe: if set to true, a new random generator instance will be created that will be 
///        be used and exist only for the duration of this call. Otherwise, global instance is used.
/// - Returns: a list of d-dimensional vectors from the given distribution
public func mvnrnd(mu: Vector<Double>, sigma: Matrix<Double>, cases: Int, seed: UInt64? = nil, 
    threadSafe: Bool = false) -> [Vector<Double>]
{
    var l = [Vector<Double>]()
    l.reserveCapacity(cases)

    for _ in 0..<cases
    {
        let v = mvnrnd(mu: mu, sigma: sigma, seed: seed, threadSafe: threadSafe)
        l.append(v)
    }

    return l
}