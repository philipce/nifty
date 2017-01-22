import XCTest
@testable import Nifty

class Matrix_test: XCTestCase 
{
    #if os(Linux)
    static var allTests: [XCTestCaseEntry] 
    {
        let tests = 
        [
            testCase([("testBasic", Matrix_test.testBasic)]),
        ]

        return tests
    }
    #endif

    func testBasic() 
    {        
        print("\n\n")

        let m = Matrix(
        [[1.0,   345.35, 2342564.453, 354, 35345,  0.000234],
         [120,   345.35,     464.453, 354,  1536,  0.004454],
         [7.8, 23345.35,      26.453,   3, 35567, 1.0460234]])

        print("\(m)\n")
        print("\(m.csv)\n")


        let ms = Matrix(
        [[randa(1), randa(2), randa(3)],
         [randa(60), randa(5), randa(4)]])

        print("\(ms)\n")
        print("\(ms.csv)\n")

        print("\n\n")
    }
}
