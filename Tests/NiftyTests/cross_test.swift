import XCTest
@testable import Nifty

class cross_test: XCTestCase 
{
    static var allTests: [XCTestCaseEntry] 
    {
        let tests = 
        [
            testCase([("testBasic", cross_test.testBasic)]),
        ]

        return tests
    }

    func testBasic() 
    {        
        let v1 = Vector([1.0, 345.35, 2342564.453])
        let v2 = Vector([5.6, 4.5, 4254.3])
        let x = cross(v1, v2)

        print(x)
        XCTAssert(x.data == [-0.90723175335E7, 1.31141066368E7, -0.000192946E7]) // FIXME: use compare with precision
        
    }
}