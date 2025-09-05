import XCTest
@testable import macpm2monitor

class PM2ManagerMockTests: XCTestCase {
    func testRunPM2CommandSuccess() {
        let mock = PM2ManagerMock(pm2Path: "/mock/path")
        let (code, output) = mock.runPM2Command(args: ["jlist"])
        XCTAssertEqual(code, 0)
        XCTAssertEqual(output, "Mocked success")
        XCTAssertEqual(mock.lastCommand, ["jlist"])
    }

    func testRunPM2CommandFailure() {
        let mock = PM2ManagerMock(pm2Path: "/mock/path")
        mock.shouldFail = true
        let (code, output) = mock.runPM2Command(args: ["start", "test"])
        XCTAssertEqual(code, -1)
        XCTAssertEqual(output, "Mocked failure")
    }

    func testGetPM2ProcessListReturnsMockedList() {
        let mock = PM2ManagerMock(pm2Path: "/mock/path")
        mock.mockProcessList = [["name": "test", "pm2_env": ["status": "online"]]]
        let list = mock.getPM2ProcessList()
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list[0]["name"] as? String, "test")
    }
}
