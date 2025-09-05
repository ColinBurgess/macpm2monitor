// StatusBarController.swift
// Handles status bar UI and menu logic

import Cocoa
import UserNotifications

class StatusBarController {
	let statusItem: NSStatusItem
	let pm2Manager: PM2Manager
	var autoRefreshInterval: TimeInterval = 30.0 // Default 30 seconds
	var refreshTimer: Timer?

	init(pm2Manager: PM2Manager) {
		self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
		self.pm2Manager = pm2Manager
		// Set a default icon (system image)
		if let button = statusItem.button {
			button.image = NSImage(systemSymbolName: "bolt.circle", accessibilityDescription: "PM2 Monitor")
		}
		setupMenu()
		setupAutoRefresh()
	}

	func setupMenu() {
		let menu = NSMenu()
		let refreshItem = NSMenuItem(title: "Refresh", action: #selector(refreshList), keyEquivalent: "r")
		refreshItem.target = self
		menu.addItem(refreshItem)

		let addItem = NSMenuItem(title: "Add Process…", action: #selector(addProcess), keyEquivalent: "n")
		addItem.target = self
		menu.addItem(addItem)

		let logsItem = NSMenuItem(title: "Show Logs…", action: #selector(showLogs), keyEquivalent: "l")
		logsItem.target = self
		menu.addItem(logsItem)

		let prefsItem = NSMenuItem(title: "Preferences…", action: #selector(openPreferences), keyEquivalent: ",")
		prefsItem.target = self
		menu.addItem(prefsItem)

		menu.addItem(NSMenuItem.separator())

		// Add PM2 process list
		let processList = pm2Manager.getPM2ProcessList()
		print("[StatusBarController] Got \(processList.count) processes from PM2Manager")

		if processList.isEmpty {
			let noProcessItem = NSMenuItem(title: "No PM2 processes found", action: nil, keyEquivalent: "")
			noProcessItem.isEnabled = false
			menu.addItem(noProcessItem)
		} else {
			for proc in processList {
				let name = (proc["name"] as? String) ?? "<unknown>"
				let status = ((proc["pm2_env"] as? [String: Any])?["status"] as? String) ?? "?"
				let title = "\(name) (\(status))"
				print("[StatusBarController] Adding menu item: \(title)")

				let procMenu = NSMenu()

				let start = NSMenuItem(title: "Start", action: #selector(processAction), keyEquivalent: "")
				start.representedObject = ["cmd": "start", "name": name]
				start.target = self
				procMenu.addItem(start)

				let stop = NSMenuItem(title: "Stop", action: #selector(processAction), keyEquivalent: "")
				stop.representedObject = ["cmd": "stop", "name": name]
				stop.target = self
				procMenu.addItem(stop)

				let restart = NSMenuItem(title: "Restart", action: #selector(processAction), keyEquivalent: "")
				restart.representedObject = ["cmd": "restart", "name": name]
				restart.target = self
				procMenu.addItem(restart)

				let info = NSMenuItem(title: "Show Info", action: #selector(showProcessInfo), keyEquivalent: "")
				info.representedObject = ["name": name]
				info.target = self
				procMenu.addItem(info)

				let delete = NSMenuItem(title: "Delete", action: #selector(processAction), keyEquivalent: "")
				delete.representedObject = ["cmd": "delete", "name": name]
				delete.target = self
				procMenu.addItem(delete)

				let wrapper = NSMenuItem(title: title, action: nil, keyEquivalent: "")
				menu.addItem(wrapper)
				menu.setSubmenu(procMenu, for: wrapper)
			}
		}

		menu.addItem(NSMenuItem.separator())
		let quit = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
		quit.target = NSApp
		menu.addItem(quit)

		statusItem.menu = menu
	}

	@objc func refreshList() {
		setupMenu()
	}
}

// MARK: - Menu and Actions
extension StatusBarController {
    @objc func addProcess(_ sender: Any?) {
        let alert = NSAlert()
        alert.messageText = "Add New Process"
        alert.informativeText = "Enter the command to start your process:"
        alert.addButton(withTitle: "Start")
        alert.addButton(withTitle: "Cancel")

        let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        textField.placeholderString = "e.g., node server.js"
        alert.accessoryView = textField

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            let command = textField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
            if !command.isEmpty {
                let (code, output) = pm2Manager.runPM2Command(args: ["start", command])
                if code == 0 {
                    showNotification("Process started successfully")
                    refreshList()
                } else {
                    showOutput("Error Starting Process", text: output)
                }
            }
        }
    }

    @objc func processAction(_ sender: NSMenuItem) {
        guard let data = sender.representedObject as? [String: String],
              let cmd = data["cmd"],
              let name = data["name"] else { return }

        let (code, output) = pm2Manager.runPM2Command(args: [cmd, name])
        if code == 0 {
            showNotification("Process \(cmd) successful for \(name)")
            refreshList()
        } else {
            showOutput("Error with \(cmd)", text: output)
        }
    }

    @objc func showProcessInfo(_ sender: NSMenuItem) {
        guard let data = sender.representedObject as? [String: String],
              let name = data["name"] else { return }

        let (code, output) = pm2Manager.runPM2Command(args: ["info", name])
        if code == 0 {
            showOutput("Process Info: \(name)", text: output)
        } else {
            showOutput("Error Getting Info", text: output)
        }
    }

    @objc func showLogs(_ sender: Any?) {
        let (code, output) = pm2Manager.runPM2Command(args: ["logs", "--lines", "50"])
        if code == 0 {
            showOutput("PM2 Logs", text: output)
        } else {
            showOutput("Error Getting Logs", text: output)
        }
    }

    @objc func openPreferences(_ sender: Any?) {
        let alert = NSAlert()
        alert.messageText = "Preferences"
        alert.informativeText = "PM2 Path:"
        alert.addButton(withTitle: "Save")
        alert.addButton(withTitle: "Cancel")

        let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        let currentPath = UserDefaults.standard.string(forKey: "pm2Path") ?? "/opt/homebrew/bin/pm2"
        textField.stringValue = currentPath
        alert.accessoryView = textField

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            let newPath = textField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
            UserDefaults.standard.set(newPath, forKey: "pm2Path")
            showNotification("Preferences saved. Restart app to apply changes.")
        }
    }

    func setupAutoRefresh() {
        refreshTimer?.invalidate()
        if autoRefreshInterval > 0 {
            refreshTimer = Timer.scheduledTimer(withTimeInterval: autoRefreshInterval, repeats: true) { _ in
                self.refreshList()
            }
        }
    }

    func showNotification(_ message: String) {
        let center = UNUserNotificationCenter.current()

        // Request notification permission if not already granted
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "PM2 Monitor"
                content.body = message
                content.sound = .default

                let request = UNNotificationRequest(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: nil // Immediate notification
                )

                center.add(request) { error in
                    if let error = error {
                        print("Error delivering notification: \(error)")
                    }
                }
            }
        }
    }

    func showOutput(_ title: String, text: String) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = text
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
}
