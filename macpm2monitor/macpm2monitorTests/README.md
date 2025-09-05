# Swift Unit Tests for macpm2monitor

This directory contains all unit tests for the Swift code in the project, using the official XCTest framework. All verification is now performed in Swift; the old `test/` folder with Bash scripts and CLI mocks has been removed.

## What is Xcode?
Xcode is the official development environment for Apple platforms (macOS, iOS, etc). It allows you to edit code, build, debug, and run tests graphically and via automation. Download it for free from the macOS App Store.

## How do Swift unit tests work?
Unit tests verify that functions and classes work correctly in isolation. Tests are written in `.swift` files using the XCTest library, and each test checks a specific aspect of the code (e.g., that a function returns the expected value or a class initializes correctly).

## How to run the tests

### Option 1: Using Xcode (recommended)
1. Open the project folder in Xcode (`File > Open...`).
2. Find the `macpm2monitorTests` folder in the Xcode file navigator.
3. Right-click the folder and select "New File > Swift Test Case" to add more tests if needed.
4. To run all tests, press `Cmd+U` or go to the `Product > Test` menu.
5. Xcode will show test results (passed/failed) at the bottom.

### Option 2: From the terminal (advanced)
If you have Xcode and command line tools installed, you can run tests with:

```bash
xcodebuild test -scheme macpm2monitor
```

This will run all tests and show results in the terminal.

## Current coverage
- `PM2ManagerTests.swift`: Tests for PM2Manager logic.
- `StatusBarControllerTests.swift`: Basic initialization test for StatusBarController.
- `PM2ManagerMockTests.swift`: Examples of using mocks to simulate external dependencies.

## Best practices
- Use XCTest for all Swift logic.
- Simulate external dependencies (like the PM2 binary) with mocks for fast, reliable tests.
- Add more tests for business logic and edge cases as the app evolves.

## How to add more tests
Create new test files in this folder and write functions starting with `test...`. For example:

```swift
testMyFunction() {
    let result = myFunction()
    XCTAssertEqual(result, expectedValue)
}
```

Each time you run the tests, Xcode or the terminal will automatically check all test functions and show the results.
