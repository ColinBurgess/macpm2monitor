import XCTest
@testable import macpm2monitor

class StatusBarControllerTests: XCTestCase {
    func testStatusBarControllerInitSetsStatusItem() {
        let pm2Manager = PM2Manager(pm2Path: "/usr/bin/env")
        let controller = StatusBarController(pm2Manager: pm2Manager)
        XCTAssertNotNil(controller.statusItem)
    }
}
