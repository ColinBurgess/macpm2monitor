// ...existing code...

// MARK: - PM2 Process Management
extension PM2Manager {
    func logDebug(_ text: String, verbose: Bool = false) {
        // ...migrated logDebug logic from main.swift...
    }

}
// PM2Manager.swift
// Handles all PM2 process interactions and shell commands

import Foundation

class PM2Manager {
    var pm2Path: String

    init(pm2Path: String) {
        self.pm2Path = pm2Path
    }

    func runPM2Command(args: [String]) -> (Int32, String) {
        var effectivePATH = ProcessInfo.processInfo.environment["PATH"] ?? "/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"
        do {
            let shell = Process()
            shell.launchPath = "/bin/zsh"
            shell.arguments = ["-l", "-c", "echo $PATH"]
            let outPipe = Pipe()
            shell.standardOutput = outPipe
            try shell.run()
            let outData = outPipe.fileHandleForReading.readDataToEndOfFile()
            shell.waitUntilExit()
            if let out = String(data: outData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines), out.count > 0 {
                effectivePATH = out
            }
        } catch {
            // ignore and use default PATH
        }
        let proc = Process()
        if FileManager.default.fileExists(atPath: pm2Path) {
            proc.launchPath = pm2Path
            proc.arguments = args
        } else {
            proc.launchPath = "/usr/bin/env"
            proc.arguments = ["pm2"] + args
        }
        var env = ProcessInfo.processInfo.environment
        env["PATH"] = effectivePATH
        env["HOME"] = NSHomeDirectory()
        proc.environment = env
        let pipe = Pipe()
        proc.standardOutput = pipe
        proc.standardError = pipe
        do {
            try proc.run()
        } catch {
            let err = "Could not launch pm2: \(error.localizedDescription). PATH used: \(effectivePATH)"
            return (-1, err)
        }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        proc.waitUntilExit()
        let output = String(data: data, encoding: .utf8) ?? ""
        return (proc.terminationStatus, output)
    }

    func getPM2ProcessList() -> [[String: Any]] {
        let (code, output) = runPM2Command(args: ["jlist"])
        guard code == 0, let data = output.data(using: .utf8) else { return [] }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json as? [[String: Any]] ?? []
        } catch {
            return []
        }
    }
}
