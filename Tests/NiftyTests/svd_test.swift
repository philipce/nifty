import XCTest
@testable import Nifty

class svd_test: XCTestCase 
{
    static var allTests: [XCTestCaseEntry] 
    {
        let tests = 
        [
            testCase([("testBasic", svd_test.testBasic)]),
        ]

        return tests
    }

    func testBasic() 
    {        
        // examples from matlab docs on svd

        var A = Matrix<Double>([[1,0,1],[-1,-2,0],[0,1,-1]])
        let s: Vector<Double> = svd(A)

        XCTAssert(isequal(s, Vector([2.4605, 1.6996, 0.2391]), within: 1E-4))

        A = Matrix([[1,2],[3,4],[5,6],[7,8]], name: "A")
        let (U,S,V) = svd(A)
        let USVT = U*S*transpose(V) 

        print(A, terminator: "\n\n")
        print(U, terminator: "\n\n")
        print(S, terminator: "\n\n")
        print(V, terminator: "\n\n")  
        print(USVT, terminator: "\n\n")       

        XCTAssert(isequal(A, USVT, within: 1E-10))
    }
}