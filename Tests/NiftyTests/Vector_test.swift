import XCTest
@testable import Nifty

class Vector_test: XCTestCase 
{
    static var allTests: [XCTestCaseEntry] 
    {
        let tests = 
        [
            testCase([("testBasic", Vector_test.testBasic)]),
        ]

        return tests
    }

    func testBasic() 
    {        
        print("\n\n")

        let v = Vector([1.0, 345.35, 2342564.453, 354, 35345, 0.000234])
        print("\(v)\n")
        print(v.csv)

        print("\n\n")
    }
}
