// ...existing code...

// MARK: - Menu and Actions
extension StatusBarController {
    // ...existing code...

    @objc func addProcess(_ sender: Any?) {
        // ...migrated addProcess logic from main.swift...
    }

    @objc func handleStartProcess(_ sender: NSButton) {
        // ...migrated handleStartProcess logic from main.swift...
    }

    @objc func handleCancelProcess(_ sender: NSButton) {
        // ...migrated handleCancelProcess logic from main.swift...
    }

    @objc func processAction(_ sender: NSMenuItem) {
        // ...migrated processAction logic from main.swift...
    }

    @objc func showProcessInfo(_ sender: NSMenuItem) {
        // ...migrated showProcessInfo logic from main.swift...
    }

    @objc func showLogs(_ sender: Any?) {
        // ...migrated showLogs logic from main.swift...
    }

    @objc func openPreferences(_ sender: Any?) {
        // ...migrated openPreferences logic from main.swift...
    }

    func setupAutoRefresh() {
        // ...migrated setupAutoRefresh logic from main.swift...
    }

    func showNotification(_ message: String) {
        // ...migrated showNotification logic from main.swift...
    }

    func showOutput(_ title: String, text: String) {
        // ...migrated showOutput logic from main.swift...
    }
}
// StatusBarController.swift
// Handles status bar UI and menu logic

import Cocoa

class StatusBarController {
    let statusItem: NSStatusItem
    let pm2Manager: PM2Manager
    var autoRefreshInterval: TimeInterval = 0
    var refreshTimer: Timer?

    init(pm2Manager: PM2Manager) {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        self.pm2Manager = pm2Manager
        // Set a default icon (system image)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "bolt.circle", accessibilityDescription: "PM2 Monitor")
        }
        setupMenu()
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
        for proc in processList {
            let name = (proc["name"] as? String) ?? "<unknown>"
            let status = ((proc["pm2_env"] as? [String: Any])?["status"] as? String) ?? "?"
            let title = "\(name) (\(status))"
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

        menu.addItem(NSMenuItem.separator())
        let quit = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        quit.target = NSApp
        menu.addItem(quit)

        statusItem.menu = menu
    }

    @objc func refreshList() {
        setupMenu()
    }
    // ...other UI logic...
}
