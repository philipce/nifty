import XCTest
@testable import Nifty

class lu_test: XCTestCase 
{
    static var allTests: [XCTestCaseEntry] 
    {
        let tests = 
        [
            testCase([("testBasic", lu_test.testBasic)]),
        ]

        return tests
    }

    func testBasic() 
    {        
        // this is the matlab example on their lu doc

        print("\n\n")

        let A = Matrix([[1,2,3],
                [4,5,6],
                [7,8,0]], name: "A", showName: true)

        print("Calling lu(A) = (L,U,P):")
        let (L, U, P) = lu(A)        
        print(A, terminator: "\n\n")
        print(L, terminator: "\n\n")
        print(U, terminator: "\n\n")
        print(P, terminator: "\n\n")
        print(P*A, terminator: "\n\n")
        print(L*U, terminator: "\n\n")

        print("Calling lu(A) = (L,U):")
        let (L2, U2) = lu(A)
        print(L2, terminator: "\n\n")
        print(U2, terminator: "\n\n")

        print("\n\n")
    }
}