print("Testing multi key dictionary")

// Number of entries to initially put in dictionary
let initEntries = randi(min: 20, max: 100)

// Number of keys in key set
let numKeys = randi(min: 1, max: 8)

// Map a keyset to an integer value
var mkd = MultikeyDictionary<String, Int>(keys: numKeys)

// Map the value back to the key so we can check our answers
var dict = [Int: [String]]()

// Initialize dictionary with unique keys and unique values
print("Initializing dictionary with \(initEntries) unique \(numKeys) element key sets and unique values...", terminator: "")
while dict.count < initEntries
{
	var curKeySet = [String]()
	for _ in 0..<numKeys
	{
		curKeySet.append(randa(randi(min: 10, max: 15)))
	}

	let curValue = randi()

	if !dict.contains(where: {$0 == curValue || $1 == curKeySet})
	{
		dict[curValue] = curKeySet
		mkd.insert(curValue, keys: curKeySet)
	}
}
print(" done")

// Check that everything went into the dictionary correctly
print("Checking that initial dictionary contains the correct key/value pairs...", terminator: "")
assert(mkd.count == initEntries, "Expected \(initEntries) entries, found \(mkd.count)")
for (k, v) in dict
{
	let found = mkd.find(v)

	assert(found.count == 1, "Expected to only get one result for mkd.find(\(v))=\(k), but got \(found) instead")
	assert(found[0] == k, "Expected mkd.find(\(v))=\(k), but got \(found) instead")
}
print(" done")


// Remove about half the entries from the dictionary 
print("Removing some elements from the dictionary... ", terminator: "")
var removeDict = [Int: [String]]()
var remainDict = [Int: [String]]()
for (k, v) in dict
{
	if randi(min: 0, max: 1) == 0
	{	
		removeDict[k] = v
		mkd.remove(v)
	}
	else
	{
		remainDict[k] = v
	}
}
print(" done, \(removeDict.count) elements removed")

// Check that the stuff that was removed was removed, and that the rest stayed put
print("Ensuring that the items were correctly removed...", terminator: "")
assert(mkd.count == remainDict.count, "Expected \(remainDict.count) entries to remain, found \(mkd.count)")
for (k, v) in removeDict
{
	assert(mkd.find(v).isEmpty, "Expected to not find value for removed key \(v)")
}
for (k, v) in remainDict
{
	let found = mkd.find(v)
	assert(found.count == 1 && found[0] == k, "Expected un-removed key \(v) to retain value \(k), found \(found)")
}
print(" done")

// TODO: Try removing keys that aren't in the dictionary

// TODO: Try inserting values for keys that already exist

// Remove all elements from the dictionary
print("Removing all elements from the dictionary..." , terminator: "")
mkd.removeAll()
print(" done")

// Ensure that all elements were removed
print("Ensuring all elements were removed from the dictionary..." , terminator: "")
assert(mkd.count == 0, "Expected dictionary to have 0 elements, found \(mkd.count)")
for (k, v) in remainDict
{
	let found = mkd.find(v)
	assert(found.count == 0, "Expected dictionary to be empty, found \(v)=\(found)")
}
print(" done")

// TODO: Find with wildcard

