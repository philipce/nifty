import XCTest
@testable import NiftyTests

var tests = [XCTestCaseEntry]()

tests += MultikeyDictionary_test.allTests
tests += lu_test.allTests
tests += chol_test.allTests

XCTMain(tests)
