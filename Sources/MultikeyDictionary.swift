/***************************************************************************************************
 *  MultikeyDictionary.swift
 *
 *  This file defines a multi-key dictionary data structure. 
 *
 *  Author: Philip Erickson
 *  Creation Date: 14 Aug 2016
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

// Adapted from the "Ternary Search Trie" as discussed in: Sedgewick, R., Wayne, K. (2011). 
// Algorithms, 4th Edition. Addison-Wesley. ISBN: 978-0-321-57351-3 

public struct MultikeyDictionary<KeyType: Comparable, Value>
{    
    public var count: Int 
    public let keys: Int

    public typealias KeySet = [KeyType?]

    private var root: Node<KeyType, Value>?

    public init(keys: Int)
    {
        self.count = 0
        self.keys = keys
        self.root = nil      
    }

    public func contains(_ keySet: KeySet) -> Bool
    {
        precondition(keySet.count == self.keys, "Expected \(self.keys) search keys")
        let matches = self.get(keySet)

        return matches.count > 0
    }



    private func get(_ keySet: KeySet) -> [Value]
    {
        assert(keySet.count == self.keys)

        
        if self.root == nil
        {
            assert(self.count == 0)    
            return []
        }
        
        // FIXME: get should return list of nodes; shouldn't wrap result in array
        let nodes = [self.get(self.root!, keySet, 0)]
        let values = nodes.filter({$0.value != nil}).map({$0.value!})

        return values
    }

    private func get(_ node: Node<KeyType, Value>, _ keySet: KeySet, _ index: Int) -> Node<KeyType, Value>
    {
        assert(keySet.count == self.keys)

        // FIXME: need to handle nil keys in key set as wildcards, not force unwrap!
        let curKey = keySet[index]!

        if curKey < node.key
        {
            return get(node.lesser, keySet, index)
        }
        else if curKey > node.key
        {
            return get(node.greater, keySet, index)
        }
        else if index < self.keys-1
        {
            return get(node.equal, keySet, index+1)
        }
        else
        {
            return node
        }
    }



    private mutating func put(_ keySet: KeySet, _ value: Value)
    {
        assert(keySet.count == self.keys)

        // assign don't-care keys
        var assignedKeys = keySet // FIXME: how to handle generating new key of KeyType? keySet.map({$0 ?? self.dontCareKey()})

        if !self.contains(assignedKeys)
        {
            self.count += 1
        }

        self.root = self.put(self.root, assignedKeys, 0, value)
    }

    private func put(_ node: Node<KeyType, Value>?, _ keySet: KeySet, _ index: Int, _ value: Value) -> Node<KeyType, Value>
    {
        assert(keySet.count == self.keys)
        
        // FIXME: unable to assign don't-cares for generic KeyType
        assert(keySet[index] != nil, "Don't-care keys should all be assigned at this point")

        let curKey = keySet[index]!
        let retNode = node ?? Node<KeyType, Value>(key: curKey, value: nil)

        if curKey < retNode.key
        {
            retNode.lesser = self.put(retNode.lesser, keySet, index, value)
        }
        else if curKey > retNode.key
        {
            retNode.greater = self.put(retNode.greater, keySet, index, value)
        }
        else
        {
            // if all keys in the set have been used, then this node should store value
            if index == self.keys-1
            {
                retNode.value = value 
            }
            // otherwise, move on to the next key in the set
            else
            {
                retNode.equal = self.put(retNode.equal, keySet, index+1, value)
            }
        }

        return retNode
    }

    // Returns a key for use in inserting values with dont-care keys in the key set. The key
    // is just a counter value so it is guaranteed to be unique.
    private var _dontCareCount: UInt = 0
    private mutating func dontCareKey() -> String
    {
    
        // FIXME: remove this since it only applies to string, not generic KeyType
        
        let s = "\(_dontCareCount)"
        _dontCareCount += 1

        return s
    }
}



fileprivate class Node<KeyType: Comparable, Value>
{    
    let key: KeyType
    var value: Value?

    // sub-tries, relative to this node's key
    var lesser  : Node<KeyType, Value>?
    var equal   : Node<KeyType, Value>?
    var greater : Node<KeyType, Value>?   

    init(key: KeyType, value: Value?)
    {
        self.key = key
        self.value = value
        self.lesser = nil
        self.equal = nil
        self.greater = nil
    }
}