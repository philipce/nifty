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

        var t = Tensor(size, data, name: "t", showName: true)

        print("\(t)\n\n")
        print("\(t.csv)\n\n")

        // test subscript read/write
        print("\(t[1,2,0...1,0...1])")

        let T = Tensor([1,1,2,2], [100,101,102,103])
        t[1,2,0...1,0...1] = T
        print("\(t)\n\n")

        print("\n\n")
    }
}
