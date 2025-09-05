import Foundation
import XCTest
@testable import macpm2monitor

// Simple mock class without inheritance to avoid override issues
class PM2ManagerMock {
    var lastCommand: [String] = []
    var mockProcessList: [[String: Any]] = []
    var shouldFail: Bool = false
    var pm2Path: String

    init(pm2Path: String) {
        self.pm2Path = pm2Path
    }

    func runPM2Command(args: [String]) -> (Int32, String) {
        lastCommand = args
        if shouldFail {
            return (-1, "Mocked failure")
        }
        return (0, "Mocked success")
    }

    func getPM2ProcessList() -> [[String: Any]] {
        return mockProcessList
    }
}
