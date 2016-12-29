import XCTest
@testable import NiftyTests

var tests = [XCTestCaseEntry]()

tests += chol_test.allTests
tests += dot_test.allTests
tests += lu_test.allTests
tests += Matrix_test.allTests
tests += MultikeyDictionary_test.allTests
tests += Tensor_test.allTests
tests += Vector_test.allTests

XCTMain(tests)
