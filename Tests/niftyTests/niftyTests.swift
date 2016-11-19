import XCTest
@testable import nifty

class niftyTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(nifty().text, "Hello, World!")
    }


    static var allTests : [(String, (niftyTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
