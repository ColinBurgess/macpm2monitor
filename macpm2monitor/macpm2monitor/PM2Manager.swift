// MARK: - PM2 Process Management
extension PM2Manager {
	func logDebug(_ text: String, verbose: Bool = false) {
		if verbose {
			print("[DEBUG] \(text)")
		}
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
		// Try to use stored PM2 path from preferences, fallback to Homebrew path
		let pm2Path = UserDefaults.standard.string(forKey: "pm2Path") ?? "/opt/homebrew/bin/pm2"

		var effectivePATH = ProcessInfo.processInfo.environment["PATH"] ?? "/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/homebrew/bin"
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

		print("[PM2Manager] Using PM2 path: \(proc.launchPath ?? "unknown")")
		print("[PM2Manager] Arguments: \(proc.arguments ?? [])")
		print("[PM2Manager] PATH: \(effectivePATH)")

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

		// Debug logging
		print("[PM2Manager] Command exit code: \(code)")
		print("[PM2Manager] Command output length: \(output.count)")
		print("[PM2Manager] Command output preview: \(String(output.prefix(200)))")

		guard code == 0, let data = output.data(using: .utf8) else {
			print("[PM2Manager] Failed: code=\(code), hasData=\(output.data(using: .utf8) != nil)")
			return []
		}

		do {
			let json = try JSONSerialization.jsonObject(with: data, options: [])
			if let processes = json as? [[String: Any]] {
				print("[PM2Manager] Successfully parsed \(processes.count) processes")
				for (index, process) in processes.enumerated() {
					if let name = process["name"] as? String,
					   let pm2_env = process["pm2_env"] as? [String: Any],
					   let status = pm2_env["status"] as? String {
						print("[PM2Manager] Process \(index): \(name) (\(status))")
					}
				}
				return processes
			} else {
				print("[PM2Manager] JSON is not an array of dictionaries")
				return []
			}
		} catch {
			print("[PM2Manager] JSON parse error: \(error)")
			return []
		}
	}
}
