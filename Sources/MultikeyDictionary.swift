/***************************************************************************************************
 *  MultikeyDictionary.swift
 *
 *  This file defines a multi-key dictionary data structure. 
 *
 *  Author: Philip Erickson
 *  Creation Date: 21 Dec 2016
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

// Adapted from the section on "Ternary Search Tries" in the following textbook:  
// "Algorithms, 4th Edition", Sedgewick, R., Wayne, K. (2011). 

public struct MultikeyDictionary<KeyType: Comparable, ValueType>
{   
    public var count: Int 
    public let keys: Int     

    /// Initialize a new multikey dictionary where elements are indexed by the given number of keys.
    ///
    /// - Parameters:
    ///		- keys: number of keys to index each element with
    public init(keys: Int)
    {
        self.count = 0
        self.keys = keys
        self.root = nil      
    }

    /// Insert a new value into the dictionary with the given keys.
    ///
    /// - Parameters:
    ///		- value: the value to insert
    ///		- keys: the keys to index the inserted value
    public mutating func insert(_ value: ValueType, keys: KeyType...)
   	{   	
   		precondition(keys.count == self.keys, "Expected \(self.keys) search keys")
   		self.put(value, keys)
   	}

   	public mutating func insert(_ value: ValueType, keys: [KeyType])
   	{   
   		precondition(keys.count == self.keys, "Expected \(self.keys) search keys")
   		self.put(value, keys)
   	}

   	/// Find the values in the dictionary that match the given keys.
    ///
    ///	- Note: nil search keys are considered wild cards and will match any key
    /// - Parameters:
    ///		- keys: the keys to use in finding matching elements
   	public func find(_ keys: KeyType?...) -> [ValueType]
   	{
   		precondition(keys.count == self.keys, "Expected \(self.keys) search keys")
   		return self.get(keys)
   	}

   	public func find(_ keys: [KeyType?]) -> [ValueType]
   	{
   		precondition(keys.count == self.keys, "Expected \(self.keys) search keys")
   		return self.get(keys)
   	}

   	/// Determine if the dictionary contains an element matching the given keys.
   	///
   	/// - Parameters:
   	///		- keys: the keys to match
    public func contains(_ keys: [KeyType?]) -> Bool
    {
        precondition(keys.count == self.keys, "Expected \(self.keys) search keys")
        return self.get(keys).count > 0
    }  

    /// Remove all values matching the given keys from the dictionary.
    ///
    /// - Parameters:
    ///		- keys: specify the element(s) to remove
    public mutating func remove(_ keys: [KeyType])
    {
    	// FIXME: implement remove in a better way...
    	///This seems a hacky way to do this: have to first find if it exists in the collection
    	// then have to go find again where to put the new value. Instead, we should have a 
    	// dedicated remove function that walks the trie and removes all matches (allowing wild
    	// cards) and then removing unnecessary nodes. We changed put to allow an optional value
    	// so this could nil it out, but once we do this right, we should undo that change.    	    
    	precondition(keys.count == self.keys, "Expected \(self.keys) search keys")

    	if self.contains(keys)
    	{
    		self.count -= 1
    	}
    	self.put(nil, keys)
    } 

    /// Remove all elements from the dictionary.
    public mutating func removeAll()
    {
    	self.count = 0
    	self.root = nil
    }

   	//----------------------------------------------------------------------------------------------
    // PRIVATE MEMBER DATA/FUNCTIONS
    //----------------------------------------------------------------------------------------------

   	private var root: Node<KeyType, ValueType>?

   	private mutating func put(_ value: ValueType?, _ keySet: [KeyType])
    {
        assert(keySet.count == self.keys)

        if !self.contains(keySet)
        {
            self.count += 1
        }

        self.root = self.put(value, self.root, keySet, 0)
    }

    private mutating func put(_ value: ValueType?, _ node: Node<KeyType, ValueType>?, _ keySet: [KeyType], _ index: Int) -> Node<KeyType, ValueType>
    {
        assert(keySet.count == self.keys)        

        let curKey = keySet[index]
        let retNode = node ?? Node<KeyType, ValueType>(key: curKey, value: nil)

        if curKey < retNode.key
        {
            retNode.lesser = self.put(value, retNode.lesser, keySet, index)
        }
        else if curKey > retNode.key
        {
            retNode.greater = self.put(value, retNode.greater, keySet, index)
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
                retNode.equal = self.put(value, retNode.equal, keySet, index+1)
            }
        }

        return retNode
    }

    private func get(_ keySet: [KeyType?]) -> [ValueType]
    {
        assert(keySet.count == self.keys)
        
        if self.root == nil
        {
            assert(self.count == 0)    
            return []
        }
        
        // FIXME: get should return list of nodes; shouldn't wrap result in array
        let nodes = [self.get(self.root!, keySet, 0)]
        let values = nodes.filter({$0 != nil && $0!.value != nil}).map({$0!.value!})

        return values
    }

    private func get(_ node: Node<KeyType, ValueType>?, _ keySet: [KeyType?], _ index: Int) -> Node<KeyType, ValueType>?
    {
    	guard let node = node else
    	{
    		return nil
    	}

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


}

/// Helper class representing node in multikey dictionary. Reference semantics needed.
fileprivate class Node<KeyType: Comparable, ValueType>
{    
    let key: KeyType
    var value: ValueType?

    // sub-tries, relative to this node's key
    var lesser  : Node<KeyType, ValueType>?
    var equal   : Node<KeyType, ValueType>?
    var greater : Node<KeyType, ValueType>?   

    init(key: KeyType, value: ValueType?)
    {
        self.key = key
        self.value = value
        self.lesser = nil
        self.equal = nil
        self.greater = nil
    }
}