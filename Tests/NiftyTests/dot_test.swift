import XCTest
@testable import Nifty

class dot_test: XCTestCase 
{
    static var allTests: [XCTestCaseEntry] 
    {
        let tests = 
        [
            testCase([("testBasic", dot_test.testBasic)]),
        ]

        return tests
    }

    func testBasic() 
    {        
        let v1 = Vector([1.0, 345.35, 2342564.453, 354, 35345, 0.000234])
        let v2 = Vector([5.6, 4.5, 4254.3, 34, 345, 0.001574])
        let x = dot(v1, v2)

        XCTAssert(x == 9978179573.0729) // TODO: use some kind of equals with precision function

        let n = 5000
        let v3 = rand(n, min: -9999, max: 9999) 
        let v4 = rand(n)
        let y = v3*v4

        var sum = 0.0
        for i in 0..<n
        {
            sum += v3[i]*v4[i]
        }

        XCTAssert(y == sum) // TODO: use some kind of equals with precision function

        
    }
}
