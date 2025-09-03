// main.swift
// Entry point for PM2 Monitor macOS app

import Cocoa
import Foundation

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?
    var pm2Manager: PM2Manager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let d = UserDefaults.standard
        let pm2Path = d.string(forKey: "pm2Path") ?? "/opt/homebrew/bin/pm2"
        pm2Manager = PM2Manager(pm2Path: pm2Path)
        statusBarController = StatusBarController(pm2Manager: pm2Manager!)
    }
}


let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
