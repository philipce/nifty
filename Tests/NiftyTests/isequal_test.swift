import XCTest
@testable import Nifty

class isequal_test: XCTestCase 
{
    static var allTests: [XCTestCaseEntry] 
    {
        let tests = 
        [
            testCase([("testBasic", self.testBasic)]),
        ]

        return tests
    }

    func testBasic() 
    {        

        XCTAssert(isequal(1.00001, 1.00002, within: 0.00001, comparison: .absolute))
        XCTAssert(isequal(1.00001, 1.00002, within: 0.00001, comparison: .relative))
        XCTAssert(!isequal(1.00001, 1.00002))

        XCTAssert(isequal(4579834.34598354, 4579834.34599))
        XCTAssert(isequal(4579834.34598354, 4579834.34599, within: eps.single))
        XCTAssert(!isequal(4579834.34598354, 4579834.34599, comparison: .absolute))
        XCTAssert(!isequal(4579834.34598354, 4579834.34599, within: eps.single, comparison: .absolute))
        XCTAssert(!isequal(4579834.34598354, 4579834.34599, within: eps.double))

        XCTAssert(isequal(0.000000001, 0.00000005))
        XCTAssert(!isequal(0.000125234, 0.000126))
        XCTAssert(!isequal(0.000000001, 0.00000005, within: eps.double))
    }
}