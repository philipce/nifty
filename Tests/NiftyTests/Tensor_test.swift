import XCTest
@testable import Nifty

class Tensor_test: XCTestCase 
{
    #if os(Linux)
    static var allTests: [XCTestCaseEntry] 
    {
        let tests = 
        [
            testCase([("testBasic", Tensor_test.testBasic)]),
        ]

        return tests
    }
    #endif

    func testBasic() 
    {        
        print("\n\n")

        let size = [3,4,2,2]
        var data = [Int]()
        for i in 1...size.reduce(1,*)
        {
            data.append(i)
        }

        // test data array constructor
        var t = Tensor(size, data, name: "t", showName: true)
        print("\(t)\n\n")
        print("\(t.rawDescription)\n\n")

        // test uniform value constructor
        let t2Size = [3,5,6,1,7,2,9]
        let t2Value = 547.23
        let t2ExpSum = Double(t2Size.reduce(1, *)) * t2Value
        let t2 = Tensor(t2Size, value: t2Value)
        let t2Sum = t2.data.reduce(0.0, +)
        XCTAssert(isequal(t2Sum, t2ExpSum, within: 0.1), "Expected t2Sum==\(t2Sum), got \(t2ExpSum)")

        // test construction from vector
        let v = Vector<Double>([32,5,6,45,345,24,234,64])
        let tv = Tensor(v)
        XCTAssert(isequal(v, Vector(tv.data)))

        // test construction from matrix
        let m = Matrix(2,3, [1.23, 5.4, 23.4, 8.7, 2.3, 645.7])
        let tm = Tensor(m)
        XCTAssert(isequal(m, Matrix<Double>(2,3, tm.data)))        

        // test construction from tensor
        let t3 = Tensor(t2)
        XCTAssert(isequal(t2, t3))                

        // test subscripting
        print("\(t[1,2,0...1,0...1])")
        var T = Tensor([1,1,2,2], [100,101,102,103])
        t[1,2,0...1,0...1] = T
        print("\(t)\n\n")
        let _ = T[0,0,1,1]
        T[0,0,1,1] = 200
        T[2] = 67
        let _ = T[0...2]
        T[0...1] = Tensor([1,1,1,2], [567, 345])

        // test descriptions
        let T1D = Tensor([5], [1,2,3,4,5], name: "T1D", showName: true)
        print(T1D)
        print(T1D.rawDescription)

        let T2D = Tensor([2,2], [1,2,3,4], name: "T2D", showName: true)
        print(T2D)
        print(T2D.rawDescription)

        print("\n\n")
    }
}
