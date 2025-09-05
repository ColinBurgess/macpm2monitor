# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2025-09-05
- Complete migration of all tests to Swift/XCTest (`macpm2monitorTests/`), removing the `test/` folder and all Bash scripts and CLI mocks.
- Refactoring and cleanup: removed obsolete files, improved project structure, and updated Xcode configuration.
- Updated and translated all technical and test documentation to English.
- Removed app sandbox from entitlements to allow PM2 execution.
- Improvements in PM2 logic and UI: refactored `PM2Manager.swift` and `StatusBarController.swift`, added support for PM2 path configuration and user preferences.
- Updated `.gitignore` to ignore temporary, user, and Xcode files.

## [1.0.0] - 2025-09-03
- Initial release: PM2 Monitor for macOS with process listing, start/stop/restart/delete, add process modal, notifications, debug logging, and screenshots.
