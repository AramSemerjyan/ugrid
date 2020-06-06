import XCTest
@testable import ugrid

final class ugridTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ugrid().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
