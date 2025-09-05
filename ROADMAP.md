# Roadmap — PM2 Monitor for macOS

This file is the public-facing roadmap for the PM2 Monitor project. It contains high-level goals, planned milestones and what contributors/users should expect.

## Vision
Provide a lightweight, native macOS status-bar utility that lets users view and control PM2-managed Node.js processes without opening a terminal. The application should be secure, performant, and integrate seamlessly with macOS.

## Current Status: **Version 1.1.0 - Test Refactor & Project Cleanup ✅**

The PM2 Monitor application has successfully achieved its primary objectives and is now fully functional.

## Completed Milestones

### 1. ✅ Prototype & Foundation (Completed)
- ✅ Native macOS status bar app (Swift + AppKit) with menu interface
- ✅ Basic menu structure and UI components
- ✅ Application architecture and project structure
- ✅ Debug logging system implemented

### 2. ✅ PM2 Integration (Completed)
- ✅ Reliable PM2 CLI execution without sandbox restrictions
- ✅ Full PATH handling for GUI-launched applications
- ✅ Complete `pm2 jlist` JSON parsing and process display
- ✅ All core PM2 actions implemented:
  - ✅ Start processes
  - ✅ Stop processes
  - ✅ Restart processes
  - ✅ Delete processes
  - ✅ Show process information
  - ✅ Add new processes via modal interface
- ✅ Real-time process status updates
- ✅ Comprehensive error handling and user feedback

### 3. ✅ Security & Permissions (Completed)
- ✅ No sandbox restrictions for full PM2 access
- ✅ Proper entitlements configuration
- ✅ Secure process execution with full system access
- ✅ Debug capabilities maintained for development

### 4. ✅ User Experience (Completed)
- ✅ Intuitive menu-based interface
- ✅ Process status indicators (online/stopped/errored)
- ✅ Confirmation dialogs for destructive actions
- ✅ Clean, native macOS interface design
- ✅ Responsive UI with proper threading

### 5. ✅ Development & Testing (Completed)
- ✅ Comprehensive test suite with mock PM2
- ✅ Build system and command-line compilation
- ✅ Debug logging and troubleshooting tools
- ✅ Complete documentation and development guides

## Future Enhancements (Planned)

### Phase 2: Advanced Features

#### 2.1 Enhanced User Interface
- [ ] **Settings Panel**: Configure PM2 path, refresh intervals, and preferences
- [ ] **Process Filtering**: Search and filter processes by name or status
- [ ] **Auto-refresh**: Optional automatic process list updates
- [ ] **Keyboard Shortcuts**: Quick actions via hotkeys
- [ ] **Dark Mode**: Enhanced dark mode support and theming

#### 2.2 Notifications & Monitoring
- [ ] **UserNotifications Framework**: Modern notification system
- [ ] **Process Monitoring**: Alerts for process crashes or status changes
- [ ] **Performance Metrics**: CPU and memory usage display
- [ ] **Log Viewer**: Built-in process log viewing
- [ ] **Health Checks**: Process health monitoring and alerts

#### 2.3 Advanced PM2 Features
- [ ] **Ecosystem Support**: PM2 ecosystem file management
- [ ] **Environment Variables**: Process environment configuration
- [ ] **Clustering**: Multi-instance process management
- [ ] **Watch Mode**: File watching and auto-restart configuration
- [ ] **Load Balancing**: PM2 load balancer integration

### Phase 3: Distribution & Integration

#### 3.1 Packaging & Distribution
- [ ] **Code Signing**: Official Apple Developer signing
- [ ] **Notarization**: Apple notarization for security
- [ ] **Installer Package**: Professional installer creation
- [ ] **Homebrew Cask**: Homebrew distribution support
- [ ] **GitHub Releases**: Automated release pipeline

#### 3.2 System Integration
- [ ] **Launch Agent**: Auto-start on system boot
- [ ] **Menu Bar Customization**: Icon and appearance options
- [ ] **System Preferences**: macOS System Preferences integration
- [ ] **Spotlight Integration**: Process search via Spotlight
- [ ] **Accessibility**: VoiceOver and accessibility support

### Phase 4: Advanced Monitoring

#### 4.1 Analytics & Reporting
- [ ] **Usage Statistics**: Process usage analytics
- [ ] **Performance Graphs**: Historical performance data
- [ ] **Export Reports**: Process status and performance reports
- [ ] **Dashboard View**: Comprehensive process dashboard
- [ ] **Alerts System**: Configurable alert conditions

#### 4.2 Remote Management
- [ ] **Remote PM2**: Connect to remote PM2 instances
- [ ] **SSH Integration**: Secure remote process management
- [ ] **Multi-server Support**: Manage multiple PM2 servers
- [ ] **Cloud Integration**: Integration with cloud PM2 services

## Technical Roadmap

### Performance Optimization
- [ ] **Memory Efficiency**: Optimize memory usage for long-running instances
- [ ] **CPU Usage**: Minimize background CPU consumption
- [ ] **Battery Life**: Optimize for MacBook battery preservation
- [ ] **Startup Time**: Reduce application launch time

### Code Quality
- [ ] **Unit Tests**: Comprehensive Swift unit test coverage
- [ ] **Integration Tests**: End-to-end testing automation
- [ ] **Code Coverage**: 90%+ test coverage target
- [ ] **Static Analysis**: Automated code quality checks
- [ ] **Performance Profiling**: Regular performance monitoring

### Platform Support
- [ ] **macOS Versions**: Support for older macOS versions (14.x, 13.x)
- [ ] **Intel Macs**: Ensure compatibility with Intel-based Macs
- [ ] **Apple Silicon**: Optimize for M1/M2/M3 processors
- [ ] **Virtualization**: Support for virtualized macOS environments

## Community & Ecosystem

### Documentation
- [ ] **User Manual**: Comprehensive user documentation
- [ ] **Video Tutorials**: Step-by-step video guides
- [ ] **API Documentation**: Developer API reference
- [ ] **Best Practices**: PM2 and application best practices guide

### Community Features
- [ ] **Plugin System**: Extensibility via plugins
- [ ] **Theme Support**: Custom themes and appearances
- [ ] **Localization**: Multi-language support
- [ ] **Community Templates**: Shared process templates

## How to Build and Use

### Current Version (1.0)

```bash
# Clone and build
git clone https://github.com/ColinBurgess/macpm2monitor.git
cd macpm2monitor/macpm2monitor
xcodebuild -scheme macpm2monitor build

# Quick launch
find ~/Library/Developer/Xcode/DerivedData -name "macpm2monitor.app" -path "*/Debug/*" -exec open {} \;
```

### Prerequisites
- **macOS 15.5+** (current requirement)
- **Xcode 16.0+** for building
- **PM2 via Homebrew**: `brew install pm2`

## Contribution Guidelines

We welcome contributions to achieve these roadmap goals:

### Priority Areas
1. **Settings Panel Implementation** - High priority for user customization
2. **Modern Notifications** - Migrate to UserNotifications framework
3. **Performance Optimization** - Memory and CPU usage improvements
4. **Testing Coverage** - Expand automated testing
5. **Distribution Packaging** - Professional app distribution

### Development Process
1. **Check Roadmap**: Ensure feature aligns with planned goals
2. **Open Issue**: Discuss feature or enhancement before implementation
3. **Fork & Branch**: Create feature branch from main
4. **Implement**: Follow Swift coding standards and add tests
5. **Test**: Verify with both mock and real PM2 environments
6. **Document**: Update documentation for new features
7. **Pull Request**: Submit with clear description and testing evidence

### Technical Standards
- **Swift 5.5+** language features
- **AppKit** for native macOS UI
- **No external dependencies** (pure Swift/macOS)
- **Comprehensive logging** for debugging
- **Memory safety** and performance focus

## Success Metrics

### Version 1.0 Achievements ✅
- ✅ **Functional**: All core PM2 operations working
- ✅ **Stable**: No crashes during normal operation
- ✅ **Secure**: No sandbox restrictions while maintaining security
- ✅ **Documented**: Complete documentation and guides
- ✅ **Tested**: Mock testing framework and real-world validation

### Future Success Targets
- **📈 Performance**: <50MB memory usage, <1% CPU when idle
- **🔧 Reliability**: 99.9% uptime during extended use
- **👥 Adoption**: Community usage and contribution growth
- **🏆 Quality**: App Store quality standards for potential distribution
- **🌍 Compatibility**: Support for 95% of macOS PM2 installations

## Timeline Estimates

### Short Term (3-6 months)
- Settings panel implementation
- UserNotifications framework migration
- Performance optimization
- Code signing and distribution setup

### Medium Term (6-12 months)
- Advanced monitoring features
- Remote PM2 support
- Plugin system foundation
- Comprehensive testing automation

### Long Term (12+ months)
- Full ecosystem integration
- Multi-platform considerations
- Advanced analytics and reporting
- Enterprise features

---

## Public Scope & Communication

This roadmap represents user-facing goals and technical direction. For detailed implementation tasks, see:
- **DEVELOPMENT.md** - Technical development guide
- **TODO.md** - Current development tasks
- **lessons_learned.md** - Development insights and decisions

Community feedback and contributions are essential to achieving these roadmap goals. Please engage through GitHub issues, discussions, and pull requests.
