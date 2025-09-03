# Roadmap — PM2 Monitor for macOS

This file is the public-facing roadmap for the PM2 Monitor project. It contains high-level goals, planned milestones and what contributors/users should expect.

## Vision
Provide a lightweight, native macOS status-bar utility that lets users view and control PM2-managed Node.js processes without opening a terminal.

## High-level milestones

1. Prototype (Completed)
   - Native macOS status bar app (Swift + AppKit) that shows a status item and a menu.
   - Basic menu actions scaffolded: Refresh, Start, Stop, Restart, Quit.
   - Logging added for debugging (`/tmp/pm2monitor.log`).

2. PM2 Integration (In progress)
   - Reliable invocation of the PM2 CLI (handle PATH differences when launched from GUI).
   - Parse `pm2 jlist` JSON and populate the UI with process name, status and PID.
   - Implement Start/Stop/Restart actions and show success/failure notifications.

3. UX & Safety improvements
   - Confirmations for destructive actions (Stop/Restart).
   - Migrate notifications to the UserNotifications framework (modern macOS API).
   - Add a settings panel for refresh interval and PM2 binary path override.

4. Packaging & Distribution
   - Provide a simple packaged app (signed and optionally notarized) or installer.
   - Add launch agent instructions for running on login.

5. Tests & CI
   - Add unit tests for the PM2 wrapper logic (mock PM2 outputs).
   - Add basic CI checks for build and lint.

## Contribution & development notes
- Primary UI language: Swift (AppKit). PM2 control logic can be a small Node.js helper script or direct CLI calls.
- Keep the UI responsive: run PM2 invocations off the main thread and update UI on the main queue.
- Respect user environments: the app must handle different PATH configurations when launched from Finder/LaunchAgent.

## How to try the prototype (developer)
- Build and run on macOS with Xcode Command Line Tools installed:

```bash
mkdir -p build
swiftc App/main.swift -o build/pm2monitor -framework Cocoa
./build/pm2monitor
```

- If the app cannot find `pm2`, set the PM2 path in the code (or run the app from a terminal where `pm2` is in PATH).

## Public scope
This roadmap contains user-facing goals and high-level milestones. Internal developer notes and step-by-step TODOs are kept in `TODO.md` (ignored by git) and are not part of the public roadmap.
