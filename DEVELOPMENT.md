# Development Guide for macpm2monitor

This guide provides detailed instructions for building, running, and developing the macpm2monitor application.

## Quick Start Commands

### Prerequisites Setup

```bash
# Install PM2 via Homebrew
brew install pm2

# Verify PM2 installation
which pm2  # Should output: /opt/homebrew/bin/pm2
pm2 --version
```

### Clone and Build

```bash
# Clone the repository
git clone https://github.com/ColinBurgess/macpm2monitor.git
cd macpm2monitor

# Option 1: Build with Xcode (Recommended for development)
open macpm2monitor/macpm2monitor.xcodeproj
# Then press ⌘+R to build and run

# Option 2: Build from command line
cd macpm2monitor/macpm2monitor
xcodebuild -scheme macpm2monitor -configuration Debug build

# Option 3: One-liner build and launch
cd macpm2monitor/macpm2monitor && \
xcodebuild -scheme macpm2monitor build && \
find ~/Library/Developer/Xcode/DerivedData -name "macpm2monitor.app" -path "*/Debug/*" -exec open {} \; 2>/dev/null
```

## Detailed Build Instructions

### Environment Requirements

- **macOS**: 15.5 or later
- **Xcode**: 16.0 or later
- **Command Line Tools**: Latest version
- **PM2**: Installed via Homebrew at `/opt/homebrew/bin/pm2`

### Verify Environment

```bash
# Check macOS version
sw_vers

# Check Xcode version
xcodebuild -version

# Verify Xcode Command Line Tools
xcode-select --print-path

# Check PM2 installation
ls -la /opt/homebrew/bin/pm2
pm2 jlist  # Should return empty array [] if no processes
```

### Build Configurations

#### Debug Build (Development)

```bash
cd macpm2monitor/macpm2monitor

# Build for debugging
xcodebuild -scheme macpm2monitor -configuration Debug build

# Find the built app
BUILD_DIR=$(xcodebuild -scheme macpm2monitor -showBuildSettings | grep "BUILT_PRODUCTS_DIR" | awk '{print $3}')
echo "Built app location: $BUILD_DIR/macpm2monitor.app"

# Launch the app
open "$BUILD_DIR/macpm2monitor.app"
```

#### Release Build (Distribution)

```bash
cd macpm2monitor/macpm2monitor

# Build for release
xcodebuild -scheme macpm2monitor -configuration Release build

# Create archive for distribution
xcodebuild -scheme macpm2monitor archive -archivePath ./build/macpm2monitor.xcarchive

# Export archive (requires further configuration in Xcode)
```

### Alternative Build Methods

#### Using Xcode GUI

1. **Open Project**:
   ```bash
   open macpm2monitor/macpm2monitor.xcodeproj
   ```

2. **Select Scheme**: Choose `macpm2monitor` from the scheme dropdown

3. **Build Settings**:
   - Debug: `⌘+B` (Build only)
   - Debug + Run: `⌘+R` (Build and run)
   - Release: Product → Archive

4. **View Build Location**:
   - Go to Window → Organizer → Archives
   - Or check: Xcode → Preferences → Locations → DerivedData

#### Clean Build

```bash
# Clean via command line
xcodebuild -scheme macpm2monitor clean

# Clean DerivedData (nuclear option)
rm -rf ~/Library/Developer/Xcode/DerivedData/macpm2monitor-*
```

## Running the Application

### Launch Methods

#### Method 1: Direct Launch

```bash
# After building, find and launch the app
DERIVED_DATA=$(find ~/Library/Developer/Xcode/DerivedData -name "macpm2monitor-*" -type d | head -1)
APP_PATH="$DERIVED_DATA/Build/Products/Debug/macpm2monitor.app"
open "$APP_PATH"
```

#### Method 2: From Xcode

1. Press `⌘+R` in Xcode
2. The app will launch and appear in the menu bar
3. Use Xcode's debugger and console for development

#### Method 3: Terminal Launch with Debugging

```bash
# Launch with console output visible
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "macpm2monitor.app" -path "*/Debug/*" | head -1)
"$APP_PATH/Contents/MacOS/macpm2monitor"
```

### Verify Application is Working

1. **Check Menu Bar**: Look for the PM2 icon in your menu bar
2. **Click Icon**: You should see a dropdown menu
3. **Test with Processes**:
   ```bash
   # Create test processes
   pm2 start "sleep 3600" --name "test-1"
   pm2 start "sleep 3600" --name "test-2"

   # Refresh the menu - you should see these processes
   ```

## Development Workflow

### Typical Development Session

```bash
# 1. Start development environment
cd macpm2monitor
open macpm2monitor/macpm2monitor.xcodeproj

# 2. Create test PM2 processes
pm2 start "sleep 3600" --name "dev-test-1"
pm2 start "node -e 'setInterval(() => console.log(Date.now()), 1000)'" --name "dev-test-logger"

# 3. Build and run from Xcode (⌘+R)
# 4. Test functionality with menu interactions
# 5. Check logs for debugging

# 6. Clean up test processes
pm2 delete dev-test-1 dev-test-logger
```

### Debugging

#### View Application Logs

```bash
# Real-time log monitoring
log stream --predicate 'process CONTAINS "macpm2monitor"' --level debug

# View recent logs
log show --predicate 'process CONTAINS "macpm2monitor"' --last 10m --info --debug

# Open Console.app for GUI log viewing
open -a Console
```

#### Debug PM2 Integration

```bash
# Test PM2 commands that the app uses
pm2 jlist  # JSON list of processes
pm2 list   # Human readable list
pm2 start "sleep 60" --name "debug-test"
pm2 stop debug-test
pm2 restart debug-test
pm2 delete debug-test
```

#### Common Debug Scenarios

1. **Application doesn't detect PM2 processes**:
   ```bash
   # Check if PM2 daemon is running
   pm2 ping

   # Check PM2 process list
   pm2 jlist

   # Verify app logs
   log show --predicate 'eventMessage CONTAINS "PM2Manager"' --last 5m
   ```

2. **Build failures**:
   ```bash
   # Clean and rebuild
   xcodebuild -scheme macpm2monitor clean
   xcodebuild -scheme macpm2monitor build
   ```

3. **Runtime crashes**:
   ```bash
   # Check crash logs
   log show --predicate 'eventMessage CONTAINS "crash"' --last 1h

   # Run from terminal to see immediate output
   APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "macpm2monitor.app" -path "*/Debug/*" | head -1)
   "$APP_PATH/Contents/MacOS/macpm2monitor"
   ```

### Code Changes and Testing

#### Making Changes

1. **Edit source files** in Xcode:
   - `main.swift` - Application entry point
   - `PM2Manager.swift` - PM2 integration logic
   - `StatusBarController.swift` - UI and menu handling

2. **Build and test**:
   - Press `⌘+R` to rebuild and run
   - Test with real PM2 processes
   - Check logs for any issues

3. **Validate changes**:
   ```bash
   # Test various PM2 states
   pm2 start "sleep 60" --name "test"
   # Test start/stop/restart in app menu
   pm2 delete test
   ```

#### Testing Framework

```bash
# Test with real PM2 processes
pm2 start "sleep 3600" --name "test-process"
pm2 jlist

# Launch your app to test PM2 integration
cd macpm2monitor/macpm2monitor
xcodebuild -scheme macpm2monitor build
find ~/Library/Developer/Xcode/DerivedData -name "macpm2monitor.app" -path "*/Debug/*" -exec open {} \;

# Clean up test processes when done
pm2 delete test-process
```

## Project Structure Details

```
macpm2monitor/
├── macpm2monitor/                    # Main Xcode project
│   ├── macpm2monitor.xcodeproj      # Xcode project file
│   └── macpm2monitor/               # Source code
│       ├── main.swift               # App entry point & delegate
│       ├── PM2Manager.swift         # PM2 CLI integration
│       ├── StatusBarController.swift # Menu bar UI controller
│       └── macpm2monitor.entitlements # Security permissions
├── build/                           # Build artifacts (created during build)
├── screenshots/                    # App screenshots
├── README.md                       # Main documentation
├── DEVELOPMENT.md                  # This file
├── ROADMAP.md                      # Future plans
├── TODO.md                         # Current tasks
└── lessons_learned.md              # Development notes
```

## Key Implementation Details

### Security Configuration

- **No Sandbox**: App runs without sandbox restrictions to execute PM2 commands
- **Entitlements**: Configured in `macpm2monitor.entitlements`
- **Permissions**: Full system access for PM2 integration

### PM2 Integration

- **CLI Commands**: Executes PM2 via `Process()` calls
- **JSON Parsing**: Parses `pm2 jlist` output for process information
- **Path Handling**: Expects PM2 at `/opt/homebrew/bin/pm2`
- **Error Handling**: Comprehensive error checking and logging

### UI Architecture

- **AppKit**: Native macOS interface using NSStatusBar
- **Menu System**: Dynamic menu generation based on PM2 process list
- **State Management**: Real-time updates when menu is opened
- **User Interactions**: Confirmation dialogs for destructive actions

## Troubleshooting Development Issues

### Build Issues

```bash
# Missing command line tools
sudo xcode-select --install

# Outdated Xcode
# Update via App Store

# Corrupted DerivedData
rm -rf ~/Library/Developer/Xcode/DerivedData

# Project file issues
cd macpm2monitor/macpm2monitor
open macpm2monitor.xcodeproj
# Check project settings in Xcode
```

### Runtime Issues

```bash
# PM2 not found
brew install pm2
which pm2  # Verify path

# Permissions issues
# Check Console.app for permission errors

# Process execution failures
# Check entitlements configuration
codesign -d --entitlements - /path/to/app
```

### Performance Issues

```bash
# Monitor app performance
top -pid $(pgrep macpm2monitor)

# Check memory usage
vmmap $(pgrep macpm2monitor)

# Profile in Xcode
# Use Instruments for detailed profiling
```

## Advanced Development

### Custom PM2 Paths

To support different PM2 installations:

```swift
// In PM2Manager.swift, modify the pm2Path
private let pm2Path = UserDefaults.standard.string(forKey: "pm2Path") ?? "/opt/homebrew/bin/pm2"
```

### Extended Logging

Add more detailed logging:

```swift
// Enhanced debug logging
NSLog("[PM2Manager] Executing: \(pm2Path) \(arguments.joined(separator: " "))")
```

### Custom Build Scripts

Create build automation:

```bash
#!/bin/bash
# build_and_deploy.sh

set -e

echo "Building macpm2monitor..."
cd macpm2monitor/macpm2monitor
xcodebuild -scheme macpm2monitor -configuration Release build

echo "Creating distribution package..."
# Add packaging logic here

echo "Build complete!"
```

## Contributing Guidelines

1. **Fork the repository** and create a feature branch
2. **Make focused changes** with clear commit messages
3. **Test thoroughly** with both mock and real PM2
4. **Update documentation** for new features
5. **Submit pull request** with detailed description

### Code Style

- Follow Swift conventions
- Add comments for complex logic
- Include debug logging for new features
- Use meaningful variable names
- Keep functions focused and small

### Testing Requirements

- Test with various PM2 process states
- Verify error handling
- Check memory usage
- Test on different macOS versions
- Validate with both Homebrew and custom PM2 paths
