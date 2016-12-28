import XCTest
@testable import Nifty

class chol_test: XCTestCase 
{
    static var allTests: [XCTestCaseEntry] 
    {
        let tests = 
        [
            testCase([("testBasic", chol_test.testBasic)]),
        ]

        return tests
    }

    func testBasic() 
    {        
        // this is the matlab example on their chol doc

        print("\n\n")

        let X = Matrix<Double>(
        [[1, 1,  1,  1,  1],
         [1, 2,  3,  4,  5],
         [1, 3,  6, 10, 15],
         [1, 4, 10, 20, 35],
         [1, 5, 15, 35, 70]], name: "X", showName: true)      

        print(X, terminator: "\n\n")

        let R = chol(X)
        print(R, terminator: "\n\n")

        let L = chol(X, .lower)        
        print(L, terminator: "\n\n")

        print("\n\n")
    }
}