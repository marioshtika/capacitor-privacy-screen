import XCTest
@testable import PrivacyScreenPlugin

class PrivacyScreenPluginTests: XCTestCase {
    func testEnableDisableState() {
        let implementation = PrivacyScreen()
        implementation.setEnabled(true)
        XCTAssertTrue(implementation.isEnabled)

        implementation.setEnabled(false)
        XCTAssertFalse(implementation.isEnabled)
    }
}
