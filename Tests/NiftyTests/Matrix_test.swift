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

        // 2D array init and csv
        let m = Matrix(
        [[1.0,   345.35, 2342564.453, 354, 35345,  0.000234],
         [120,   345.35,     464.453, 354,  1536,  0.004454],
         [7.8, 23345.35,      26.453,   3, 35567, 1.0460234]])
        print("\(m)\n")
        print("\(m.csv)\n")

        // 2D string array init and csv
        let ms = Matrix(
        [[randa(1), randa(2), randa(3)],
         [randa(60), randa(5), randa(4)]])
        print("\(ms)\n")
        print("\(ms.csv)\n")

        // square uniform init
        let m123 = Matrix(4, value: 123)
        XCTAssert(m123.data.reduce(0,+) == 4*4*123)

        // sized uniform init
        let ma = Matrix([1,2], value: "A")
        XCTAssert(ma.data == ["A","A"])

        // vector init
        let v2 = Vector([1.2,4.5,6.7,8.9])
        let m2 = Matrix(v2)
        XCTAssert(isequal(Vector(m2.data), v2))

        // matrix init
        let m3 = Matrix(m2)
        XCTAssert(isequal(m2, m3))

        // tensor init
        let t = Tensor([2,2], [1.0,2.0,3.0,4.0])
        let mt = Matrix(t)
        XCTAssert(mt.size == [2,2] && mt.data == [1.0,2.0,3.0,4.0])

        // linear index
        var M = Matrix([[1.0,2.0],[3.0,4.0]])
        let _ = M[1]
        M[3] = 4.456
        M[0...1] = Matrix([[1.3, 1.4]])
        let Ms = M[0...1]
        XCTAssert(Ms.data == [1.3, 1.4])

        print("\n\n")
    }
}
