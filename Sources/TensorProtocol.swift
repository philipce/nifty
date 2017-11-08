/***************************************************************************************************
 *  TensorProtocol.swift
 *
 *  This file provides a protocol unifying Tensors, Matrices, and Vectors.
 *
 *  Author: Philip Erickson
 *  Creation Date: 6 Nov 2017
 *  Contributors: Philip Erickson, Félix Fischer
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
 *  Copyright 2017 Philip Erickson, Félix Fischer
 **************************************************************************************************/

import Foundation

public protocol TensorProtocol: CustomStringConvertible
{
    associatedtype Element

    /// Number of elements in the tensor protocol type.
    var count: Int { get }
    
    /// Number of elements in each dimension of the tensor protocol type.
    var size: [Int] { get }
    
    /// Data contained in tensor protocol type in row-major order.
    var data: [Element] { get set }
    
    /// Optional name of tensor protocol type.
    var name: String? { get set }
    
    /// Determine whether to show name when displaying tensor protocol type.
    var showName: Bool { get set }
    
    /// Formatter to be used in displaying elements of tensor protocol type.
    var format: NumberFormatter { get set }
    
    /// Representation of tensor protocol type in comma separated list.
    var rawDescription: String { get }

    /// Initialize a new tensor protocol type of the given size from an array of data.
    ///
    /// - Parameters:
    ///    - size: number of elements in each dimension
    ///    - data: data in row-major order
    ///    - name: optional name
    ///    - showName: optional display setting; by default, true if it has name, else false
    init(_ size: [Int], _ data: [Element], name: String?, showName: Bool?)
    
    /// Initialize a new tensor protocol type of the given size and uniform value.
    ///
    /// - Parameters:
    ///    - size: number of elements in each dimension of the tensor
    ///    - value: single value repeated throughout tensor
    ///    - name: optional name
    ///    - showName: optional display setting; by default, true if it has name, else false
    init(_ size: [Int], value: Element, name: String?, showName: Bool?)
    
    /// Initialize a new tensor protocol type from the data in a given tensor protocol type.
    ///
    /// - Parameters:
    ///    - t: tensor protocol type to initialize from
    ///    - name: optional name of new tensor protocol type
    ///    - showName: optional display setting; by default, true if it has name, else false
    init<T: TensorProtocol>(_ t: T, name: String?, showName: Bool?) where T.Element == Element
    
    /// Initialize a new tensor protocol type from a string.
    ///
    /// The given string is expected to be in the format returned by `TensorProtocol.rawDescription`.
    ///
    /// - Parameters:
    ///    - rawDescription: comma separated string containing data
    ///    - name: optional name of new tensor protocol type
    ///    - showName: optional display setting; by default, true if it has name, else false
    init(_ rawDescription: String, name: String?, showName: Bool?)
}
