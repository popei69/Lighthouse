import XCTest

import lighthouseTests

var tests = [XCTestCaseEntry]()
tests += lighthouseTests.allTests()
XCTMain(tests)
