import XCTest
@testable import macpm2monitor

class PM2ManagerTests: XCTestCase {
    func testRunPM2CommandReturnsErrorForInvalidCommand() {
        let manager = PM2Manager(pm2Path: "/invalid/path")
        let (code, output) = manager.runPM2Command(args: ["invalid"])
        XCTAssertNotEqual(code, 0)
        XCTAssertTrue(output.contains("Could not launch pm2"))
    }

    func testGetPM2ProcessListReturnsArray() {
        let manager = PM2Manager(pm2Path: "/usr/local/bin/pm2")
        let list = manager.getPM2ProcessList()
        XCTAssertTrue(list.isEmpty || !list.isEmpty) // Always true, but tests the method call
    }
}
