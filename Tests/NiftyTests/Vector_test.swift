import XCTest
@testable import Nifty

class Vector_test: XCTestCase 
{
    #if os(Linux)
    static var allTests: [XCTestCaseEntry] 
    {
        let tests = 
        [
            testCase([("testBasic", Vector_test.testBasic)]),
        ]

        return tests
    }
    #endif

    func testBasic() 
    {        
        print("\n\n")

        // array init and computed properties
        let v = Vector([1.0, 345.35, 2342564.453, 354.0, 35345.0, 0.000234], name: "v")
        print("\(v)\n")
        print(v.rawDescription)
        XCTAssert(v.count == 6)
        XCTAssert(v.data == [1.0, 345.35, 2342564.453, 354.0, 35345.0, 0.000234])
        XCTAssert(v.name == "v")
        XCTAssert(v.showName)
        let _ = v.format

        // repeated value init
        var v2 = Vector(45, value: 1.0)
        v2.showName = true
        print(v2)
        XCTAssert(v2.data.reduce(0.0,+) == 45.0)

        // other vector init
        var v3 = Vector(v2)
        XCTAssert(isequal(v2, v3))

        // subscript and slice
        let x = v3[0...1]
        XCTAssert(x.count == 2)
        XCTAssert(x.data.reduce(0.0,+) == 2.0)
        v3[0..<45] = Vector(45, value: 2.0)
        XCTAssert(v3.data.reduce(0.0,+) == 90.0)

        print("\n\n")
    }
}
