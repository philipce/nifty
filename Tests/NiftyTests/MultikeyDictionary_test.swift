import XCTest
@testable import Nifty

class MultiMap_test: XCTestCase 
{
    #if os(Linux)
    static var allTests: [XCTestCaseEntry] 
    {
        let tests = 
        [
            testCase([("testBasic", MultiMap_test.testBasic)]),
            testCase([("testWildcardInsertContains", MultiMap_test.testWildcardInsertContains)]),
        ]

        return tests
    }
    #endif

    func testBasic() 
    {
        // Number of entries to initially put in dictionary
        let initEntries = randi(min: 20, max: 100)

        // Number of keys in key set
        let numKeys = randi(min: 1, max: 8)

        // Map a keyset to an integer value
        var mm = MultiMap<String, Int>(keys: numKeys)

        // Map the value back to the key so we can check our answers
        var dict = [Int: [String]]()

        // Initialize dictionary with unique keys and unique values
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
                mm.insert(curValue, keys: curKeySet)
            }
        }

        // Check that everything went into the dictionary correctly
        XCTAssert(mm.count == initEntries, "Expected \(initEntries) entries, found \(mm.count)")
        for (k, v) in dict
        {
            let found = mm.find(v)

            XCTAssert(found.count == 1, "Expected to only get one result for mm.find(\(v))=\(k), but got \(found) instead")
            XCTAssert(found[0] == k, "Expected mm.find(\(v))=\(k), but got \(found) instead")
        }

        // Remove about half the entries from the dictionary 
        var removeDict = [Int: [String]]()
        var remainDict = [Int: [String]]()
        for (k, v) in dict
        {
            if randi(min: 0, max: 1) == 0
            {   
                removeDict[k] = v
                mm.remove(v)
            }
            else
            {
                remainDict[k] = v
            }
        }

        // Check that the stuff that was removed was removed, and that the rest stayed put
        XCTAssert(mm.count == remainDict.count, "Expected \(remainDict.count) entries to remain, found \(mm.count)")
        for (_, v) in removeDict
        {
            XCTAssert(mm.find(v).isEmpty, "Expected to not find value for removed key \(v)")
        }
        for (k, v) in remainDict
        {
            let found = mm.find(v)
            XCTAssert(found.count == 1 && found[0] == k, "Expected un-removed key \(v) to retain value \(k), found \(found)")
        }

        // Try removing keys that aren't in the dictionary
        for (_, v) in removeDict
        {   
            mm.remove(v)
            XCTAssert(mm.find(v).isEmpty, "Removing non-existent value from dictionary failed")   
        }
        XCTAssert(mm.count == remainDict.count, "Removing non-existent value from dictionary changed count")
        for (k, v) in remainDict
        {
            let found = mm.find(v)
            XCTAssert(found.count == 1 && found[0] == k, "Removing non-existent entry failed: expected key \(v) to retain value \(k), found \(found)")
        }

        // Try inserting the same values for keys that already exist
        for (k, v) in remainDict
        {
            XCTAssert(mm.contains(v), "Expected dictionary to already contain \(v)")
            mm.insert(k, keys: v)  
        }
        XCTAssert(mm.count == remainDict.count, "Re-inserting existent keys/values changed count")
        for (k, v) in remainDict
        {
            let found = mm.find(v)
            XCTAssert(found.count == 1 && found[0] == k, "Re-inserting existent keys/values failed: expected key \(v) to have value \(k), found \(found)")
        }

        // Try inserting different values for keys that already exist
        var newRemainDict = [Int: [String]]()
        for (_, v) in remainDict
        {
            // create new value and ensure it's unique (since it's used as key in newRemainDict)
            var newValue = Int(randi())
            while newRemainDict[newValue] != nil
            {
                newValue = Int(randi())
            }
            newRemainDict[newValue] = v

            XCTAssert(mm.contains(v), "Expected dictionary to already contain \(v)")
            mm.insert(newValue, keys: v)
        }
        XCTAssert(mm.count == remainDict.count && mm.count == newRemainDict.count, "Inserting new values for existent keys changed count")
        for (k, v) in newRemainDict
        {
            let found = mm.find(v)
            XCTAssert(found.count == 1 && found[0] == k, "Inserting new values for existent keys failed: expected key \(v) to have value \(k), found \(found)")
        }

        // Remove all elements from the dictionary
        mm.removeAll()

        // Ensure that all elements were removed
        XCTAssert(mm.count == 0, "Expected dictionary to have 0 elements, found \(mm.count)")
        for (_, v) in newRemainDict
        {
            let found = mm.find(v)
            XCTAssert(found.count == 0, "Expected dictionary to be empty, found \(v)=\(found)")
        }
    }

    func testWildcardInsertContains()
    {        
        var mm = MultiMap<String, Int>(keys: 3)
        
        mm.insert(123,  keys: "Bob",   "Smith", "UT")
        mm.insert(456,  keys: "Bob",   "Smith", "CA")
        mm.insert(789,  keys: "John",  "Smith", "NY")
        mm.insert(1011, keys: "John",  "Smith", "WA")
        mm.insert(1212, keys: "John",  "Doe",   "VA")
        mm.insert(1213, keys: "Jane",  "Doe",   "VA")
        mm.insert(1415, keys: "Smith", "Brown", "ID")

        XCTAssert(Set(mm.find("Bob","Smith",nil)) == Set([123, 456]), "Unexpected result")
        XCTAssert(Set(mm.find(nil,"Smith",nil)) == Set([123, 456, 789, 1011]), "Unexpected result")
        XCTAssert(Set(mm.find(nil,nil,"VA")) == Set([1212, 1213]), "Unexpected result")
        XCTAssert(Set(mm.find("Smith",nil,nil)) == Set([1415]), "Unexpected result")
        XCTAssert(Set(mm.find("Bill",nil,nil)) == Set([]), "Unexpected result")
        XCTAssert(Set(mm.find(nil,nil,nil)) == Set([123, 456, 789, 1011, 1212, 1213, 1415]), "Unexpected result")

        XCTAssert(mm.contains("Bob", nil, nil), "Dictionary ought to report containing 'Bob'")
    }


    // TODO: Insert with wildcard

    // TODO: remove with wildcard

    // TODO: fuzz test: run for a long time, doing random operations, with random keys, and checking result

}
