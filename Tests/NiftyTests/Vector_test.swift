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

        let v = Vector([1.0, 345.35, 2342564.453, 354, 35345, 0.000234])
        print("\(v)\n")
        print(v.csv)

        print("\n\n")
    }
}
