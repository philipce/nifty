/***************************************************************************************************
 *  MultiMap.swift
 *
 *  This file defines a multi-key map data structure.
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

// Adapted from the section on "Ternary Search Tries" in "Algorithms, 4th Edition", Sedgewick, 
// R., Wayne, K. (2011). 

// TODO: make dictionary iterable!

// TODO: allow for wild card inserts: this allows nil values in the insertion keyset. The result of 
//	this operation is to 1) re-write the values for any existing keys that match the given key set and
//	2) insert a new node such that any specific query on the wildcard will match. 
//
// Maybe the 2 features noted above should be separate functions? insert and upate?
// 
// For example, dictionary D has entries: ["Bob", "Smith", "Blonde"]=4 and ["Bob", "Ross", "Blonde"]=27.
// Now, D.insert(9, keys: "Bob", nil, "Blonde") should result in having ["Bob","Smith","Blonde"]=9 and 
// ["Bob","Ross","Blonde"]=9 and ["Bob", nil, "Blonde"]=9. If I were later to do D.find("Bob","Jensen","Blonde"),
// it would match the wildcard middle key and return 9.

// TODO: add method that performs a wildcard find, but returns all found values AND their entire key set
// For example, for D.find(["Bob", nil, "Blond"]), I might want to get back (["Bob", "Smith", "Blond"], 4)
// and (["Bob", "Ross", "Blond"], 27)

// TODO: add better documentation for this class. Explaining what it does, giving some motivation, and showing example usage.
public struct MultiMap<Key: Comparable, Value>
{   
    public var count: Int 
    public let keyCount: Int     

    /// Initialize a new multikey dictionary where elements are indexed by the given number of keys.
    ///
    /// - Parameters:
    ///		- keys: number of keys to index each element with
    public init(keys: Int)
    {
        self.count = 0
        self.keyCount = keys
        self.root = nil      
    }

    /// Insert a new value into the dictionary with the given keys.
    ///
    /// - Parameters:
    ///		- value: the value to insert
    ///		- keys: the keys to index the inserted value
    public mutating func insert(_ value: Value, keys: [Key])
   	{   	
   		precondition(keys.count == self.keyCount, "Expected \(self.keyCount) search keys")
   		self.put(value, keys)
   	}
   	public mutating func insert(_ value: Value, keys: Key...) { self.insert(value, keys: keys) }

   	/// Find the values in the dictionary that match the given keys.
    ///
    ///	- Note: nil search keys are considered wild cards and will match any key
    /// - Parameters:
    ///		- keys: the keys to use in finding matching elements
   	public func find(_ keys: [Key?]) -> [Value]
   	{
   		precondition(keys.count == self.keyCount, "Expected \(self.keyCount) search keys")
   		return self.get(keys)
   	}
   	public func find(_ keys: Key?...) -> [Value] { return self.find(keys) }

   	/// Determine if the dictionary contains an element matching the given keys.
   	///
   	/// - Parameters:
   	///		- keys: the keys to match
    public func contains(_ keys: [Key?]) -> Bool
    {
        precondition(keys.count == self.keyCount, "Expected \(self.keyCount) search keys")
        return self.get(keys).count > 0
    }  
    public func contains(_ keys: Key?...) -> Bool { return self.contains(keys) }  

    /// Remove all values matching the given keys from the dictionary.
    ///
    /// - Parameters:
    ///		- keys: specify the element to remove
    public mutating func remove(_ keys: [Key])
    {
    	// FIXME: implement remove in a better way...
    	// This seems a hacky way to do this: have to first find if it exists in the collection
    	// then have to go find again where to put the new value. Instead, we should have a 
    	// dedicated remove function that walks the trie and removes all matches (allowing wild
    	// cards) and then removing unnecessary nodes. We changed put to allow an optional value
    	// so this could nil it out, but once we do this right, we should undo that change.    	    
    	precondition(keys.count == self.keyCount, "Expected \(self.keyCount) search keys")

    	if self.contains(keys)
    	{
    		self.count -= 1
    		self.put(nil, keys)
    	}    	
    } 
    public mutating func remove(_ keys: Key...) { return self.remove(keys) }

    /// Remove all elements from the dictionary.
    public mutating func removeAll()
    {
    	self.count = 0
    	self.root = nil
    }

   	//----------------------------------------------------------------------------------------------
    // PRIVATE MEMBER DATA/FUNCTIONS
    //----------------------------------------------------------------------------------------------

   	private var root: Node<Key, Value>?

   	private mutating func put(_ value: Value?, _ keySet: [Key])
    {
        assert(keySet.count == self.keyCount)

        if !self.contains(keySet)
        {
            self.count += 1
        }

        self.root = self.put(value, self.root, keySet, 0)
    }

    private mutating func put(_ value: Value?, _ node: Node<Key, Value>?, _ keySet: [Key], _ index: Int) -> Node<Key, Value>
    {
        assert(keySet.count == self.keyCount)        

        let curKey = keySet[index]
        let retNode = node ?? Node<Key, Value>(key: curKey, value: nil)

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
            if index == self.keyCount-1
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

    private func get(_ keySet: [Key?]) -> [Value]
    {
        assert(keySet.count == self.keyCount)
        
        if self.root == nil
        {
            assert(self.count == 0)    
            return []
        }
        
        let nodes = self.get(self.root!, keySet, 0)
        let values = nodes.filter({$0.value != nil}).map({$0.value!})

        return values
    }

    private func get(_ optNode: Node<Key, Value>?, _ keySet: [Key?], _ index: Int) -> [Node<Key, Value>]
    {
    	guard let node = optNode else
    	{
    		return []
    	}

        assert(keySet.count == self.keyCount)

        let curKey = keySet[index]
        var matches = [Node<Key, Value>]()

        if curKey == nil || curKey! < node.key
        {
            let lesserMatches: [Node<Key, Value>] = get(node.lesser, keySet, index)
            matches.append(contentsOf: lesserMatches)
        }

        if curKey == nil || curKey! > node.key
        {
        	let greaterMatches: [Node<Key, Value>] = get(node.greater, keySet, index)
            matches.append(contentsOf: greaterMatches)
        }

        if curKey == nil || curKey! == node.key
        {
	        if index < self.keyCount-1
	        {
	        	let equalMatches: [Node<Key, Value>] = get(node.equal, keySet, index+1)
	            matches.append(contentsOf: equalMatches)
	        }
	        else
	        {
	        	matches.append(node)
	            //return [node]
	        }
	    }

	    return matches
    }
}

/// Helper class representing node in multikey dictionary. Reference semantics needed.
fileprivate class Node<Key: Comparable, Value>
{    
    let key: Key
    var value: Value?

    // sub-tries, relative to this node's key
    var lesser  : Node<Key, Value>?
    var equal   : Node<Key, Value>?
    var greater : Node<Key, Value>?   

    init(key: Key, value: Value?)
    {
        self.key = key
        self.value = value
        self.lesser = nil
        self.equal = nil
        self.greater = nil
    }
}
