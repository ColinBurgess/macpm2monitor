<!-- PROJECT LOGO -->
# PM2 Monitor for macOS

Lightweight macOS status-bar utility to view and control PM2-managed Node.js processes without a terminal.

<!-- Badges -->
![Swift](https://img.shields.io/badge/language-Swift-orange)
![Platform](https://img.shields.io/badge/platform-macOS-blue)
![License](https://img.shields.io/badge/license-MIT-green)

---

## Overview
PM2 Monitor is a minimal native macOS app that places a small icon in the status bar and exposes an interactive menu that lists PM2-managed processes. From the menu you can refresh the list and perform common actions (start, stop, restart) on processes.

This application runs **without sandbox restrictions** to provide full access to PM2 commands and system resources.

## Features
- ✅ Native status-bar item implemented in Swift + AppKit
- ✅ Read processes from PM2 (`pm2 jlist`) and display name & status
- ✅ Start / Stop / Restart / Delete actions wired to PM2 CLI
- ✅ Add new process via modal window (custom command and optional name)
- ✅ Show process info (PM2 details)
- ✅ Real-time process monitoring and updates
- ✅ Comprehensive debug logging
- ✅ No sandbox restrictions for full PM2 access

## Requirements

- **macOS 15.5 or later**
- **Xcode 16.0 or later** (for building from source)
- **PM2 installed via Homebrew** at `/opt/homebrew/bin/pm2`

## Installation

### Prerequisites

First, ensure PM2 is installed and accessible:

```bash
# Install PM2 via Homebrew (recommended)
brew install pm2

# Verify installation
which pm2  # Should output: /opt/homebrew/bin/pm2
pm2 --version  # Verify it works
```

### Build from Source

#### Option 1: Using Xcode (Recommended)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ColinBurgess/macpm2monitor.git
   cd macpm2monitor
   ```

2. **Open in Xcode:**
   ```bash
   open macpm2monitor/macpm2monitor.xcodeproj
   ```

3. **Build and run:**
   - Select the `macpm2monitor` scheme
   - Press `⌘+R` or click the Play button
   - The app will launch and appear in your menu bar

#### Option 2: Command Line Build

```bash
# Navigate to project directory
cd macpm2monitor/macpm2monitor

# Build the application
xcodebuild -scheme macpm2monitor -configuration Debug build

# Find and launch the built app
DERIVED_DATA_PATH=$(xcodebuild -showBuildSettings -scheme macpm2monitor | grep "BUILT_PRODUCTS_DIR" | awk '{print $3}')
open "$DERIVED_DATA_PATH/macpm2monitor.app"
```

#### Option 3: Quick Command Line Build and Launch

```bash
# One-liner to build and launch
cd macpm2monitor/macpm2monitor && \
xcodebuild -scheme macpm2monitor build && \
find ~/Library/Developer/Xcode/DerivedData -name "macpm2monitor.app" -path "*/Debug/*" -exec open {} \; 2>/dev/null
```

### Build Locations

Xcode stores built applications in:
```
~/Library/Developer/Xcode/DerivedData/macpm2monitor-[hash]/Build/Products/Debug/macpm2monitor.app
```

## Security Configuration

This application requires **no sandbox restrictions** to execute PM2 commands. The entitlements are configured to allow:
- ✅ External process execution (`pm2` commands)
- ✅ File system access
- ✅ Network access for PM2 operations
- ✅ Debug capabilities (`com.apple.security.get-task-allow`)

**Note:** The app is intentionally built without sandboxing to provide full PM2 functionality.

## Screenshot

### Screenshots

![Main Window](screenshots/pm2monitorimg01.png)
**Main window**
Shows the main status bar menu with PM2 processes listed.

![Process Info](screenshots/pm2monitorimg02.png)
**Process info**
Displays detailed information for a selected PM2 process.

![Add Process Modal](screenshots/pm2monitorimg03.png)
**Add process window**
Shows the modal window to add a new process to PM2, with fields for command and name.

---


## Quick Start (Developer)

### Requirements
- macOS with Xcode installed (download for free from the App Store)
- PM2 installed and accessible (for example, `/opt/homebrew/bin/pm2`)

### Build and Run the App
1. Open the project folder in Xcode (`File > Open...`).
2. Select the `macpm2monitor` scheme in the top bar of Xcode.
3. Press the "Play" button (▶️) or `Cmd+R` to build and run the app.
4. The app will run in development mode and you can debug from Xcode.

### Where is the Binary Generated?
Xcode saves binaries and compiled products in:
```
~/Library/Developer/Xcode/DerivedData/
```
Look for the subfolder with your project name (`macpm2monitor-*`).

### Create the Final Binary (Release)
1. In Xcode, go to the `Product > Archive` menu.
2. Wait for the archiving process to finish.
3. The "Organizer" window will open where you can export the final binary (`.app`) for distribution, testing, or signing for the App Store.
4. The exported binary will be in the path you choose during export.

### Notes
- If the app does not find `pm2` when launched from Finder, run it from the terminal or configure the path in the source code.
- Debug logs are written to `/tmp/pm2monitor.log`.

---

## Usage

### Viewing and Managing Processes

1. **Launch the application** - It will appear in your menu bar with a PM2 icon
2. **Click the menu bar icon** to see your PM2 processes
3. **Refresh processes** - Click "Refresh PM2 Processes" to update the list
4. **Manage processes** - Click on individual processes to access actions

### Menu Options

- **Process List**: Shows all PM2 processes with their status (online/stopped/errored)
- **Refresh PM2 Processes**: Updates the process list from PM2
- **Add Process**: Launch the modal to add a new PM2 process
- **Quit**: Closes the application

### Process Actions

For each process, you can:
- **Start**: Launch a stopped process
- **Stop**: Stop a running process (with confirmation)
- **Restart**: Restart a process (with confirmation)
- **Delete**: Remove the process from PM2 (with confirmation)
- **Show Info**: View detailed PM2 information for the process

### Adding a New Process

1. Click "Add Process…" in the menu
2. A modal window will appear with fields:
   - **Command**: Enter the full command to run (e.g., `node server.js --port 3000`)
   - **Name**: Optionally enter a name (PM2 will auto-generate if blank)
3. Click **Start** to create and launch the process
4. The process will appear in the menu list

**Tip:** For shell commands, prefix with `-c` (e.g., `-c "echo hello && sleep 10"`)

## Development

### Project Structure

```
macpm2monitor/
├── macpm2monitor/
│   ├── main.swift                    # Application entry point
│   ├── PM2Manager.swift              # PM2 command interface with debug logging
│   ├── StatusBarController.swift     # Menu bar UI controller
│   └── macpm2monitor.entitlements    # Security permissions (no sandbox)
├── build/                            # Build artifacts
├── screenshots/                      # Application screenshots
└── README.md                        # This file
```

### Key Components

- **PM2Manager**: Handles all PM2 command execution, JSON parsing, and process management
- **StatusBarController**: Manages the menu bar interface, user interactions, and UI updates
- **Entitlements**: Configured without sandbox for full system access

### Debug Logging

pm2 list
The application includes comprehensive debug logging for troubleshooting:

```bash
# View application logs in Console.app
open -a Console

# Command line log viewing
log show --predicate 'process CONTAINS "macpm2monitor"' --info --debug --last 10m

# Monitor logs in real-time
log stream --predicate 'process CONTAINS "macpm2monitor"' --level debug

# Check recent application activity
log show --last 5m | grep macpm2monitor
```

### Build Configurations

#### Debug Build (Development)
```bash
cd macpm2monitor/macpm2monitor
xcodebuild -scheme macpm2monitor -configuration Debug build
```

#### Release Build (Distribution)
```bash
cd macpm2monitor/macpm2monitor
xcodebuild -scheme macpm2monitor -configuration Release build
```

#### Archive for Distribution
```bash
xcodebuild -scheme macpm2monitor archive -archivePath ./build/macpm2monitor.xcarchive
```

## Troubleshooting

### Common Issues

#### 1. "No PM2 processes found"
**Possible causes:**
- PM2 not installed or not in expected location
- No processes currently managed by PM2
- Permission issues

**Solutions:**
```bash
# Check PM2 installation
which pm2  # Should return: /opt/homebrew/bin/pm2

# Install PM2 if missing
brew install pm2

# Start a test process
pm2 start "sleep 60" --name "test-process"

# Verify PM2 works
pm2 list
pm2 jlist
```

#### 2. Application not detecting processes
**Possible causes:**
- Sandbox restrictions (should be disabled)
- PM2 path issues
- Process execution permissions

**Solutions:**
```bash
# Check entitlements (should have no sandbox)
codesign -d --entitlements - /path/to/macpm2monitor.app

# Check application logs
log show --predicate 'process CONTAINS "macpm2monitor"' --last 5m

# Verify PM2 path matches application expectations
ls -la /opt/homebrew/bin/pm2
```

#### 3. Build errors
**Possible causes:**
- Outdated Xcode version
- Missing dependencies
- Corrupted build cache

**Solutions:**
```bash
# Clean build folder in Xcode
# Product → Clean Build Folder (⌘+Shift+K)

# Reset DerivedData if needed
rm -rf ~/Library/Developer/Xcode/DerivedData/macpm2monitor-*

# Ensure Xcode 16.0+ is installed
xcodebuild -version
```

#### 4. Process actions not working
**Possible causes:**
- PM2 daemon not running
- Insufficient permissions
- Process state inconsistencies

**Solutions:**
```bash
# Restart PM2 daemon
pm2 kill
pm2 resurrect

# Check PM2 daemon status
pm2 status

# Verify process states
pm2 jlist | jq '.[].pm2_env.status'
```

### Debug Commands

```bash
# PM2 Status and Health
pm2 status
pm2 info <process-name>
pm2 logs <process-name>

# Application Debugging
log show --predicate 'process CONTAINS "macpm2monitor"' --last 10m
log stream --predicate 'eventMessage CONTAINS "PM2Manager"' --level debug

# System Information
which pm2
pm2 --version
sw_vers  # macOS version
xcodebuild -version
```

### Performance Considerations

- **Process List Updates**: The app refreshes the process list when the menu is opened
- **Background Monitoring**: No continuous background polling to preserve battery life
- **Memory Usage**: Minimal memory footprint using native Swift/AppKit
- **CPU Usage**: Low CPU usage, only active during user interactions

## Contributing

Contributions are welcome! If you'd like to help:

1. **Open an issue** describing the feature or bug
2. **Fork the repository** and create a feature branch
3. **Make changes** with clear, focused commits
4. **Add tests** if applicable
5. **Update documentation** as needed
6. **Open a pull request** with a clear description

### Development Guidelines

- Keep changes small and focused
- Follow Swift coding conventions
- Add debug logging for new features
- Test with various PM2 process states
- Update README for new features or changes

### Known Issues

- [ ] Notifications could be migrated to UserNotifications framework
- [ ] Settings UI for custom PM2 path configuration
- [ ] Auto-refresh option with configurable intervals
- [ ] Process filtering and search functionality

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- Built with Swift and AppKit for native macOS experience
- Integrates with PM2 process manager via CLI commands
- Inspired by the need for GUI-based PM2 process management
