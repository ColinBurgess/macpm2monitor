# Lessons Learned (Postmortem)

This file records mistakes made during development and the lessons learned so future LLMs or developers avoid repeating them.

## 2025-09-03

### Mistake: Marking tasks as completed without verifying system behavior

#### Lesson learned

- Do not mark tasks as completed without executing and verifying the corresponding actions.
- Pause and validate each step before updating task status.
- If an error is detected, correct `TODO.md` and record it here with details.

## 2025-09-03

### Mistake: Incorrect and messy edits to `TODO.md`
- Multiple automated and manual edits were applied to `TODO.md` without reviewing or cleaning the existing content first.
- This caused duplicated entries, disordered sections, loss of important explanations and difficulty tracking real project progress.
- In some cases the progress section was oversimplified, removing important details about completed work.

#### Root causes
- Not reading and analysing the current content before editing.
- Not respecting the original structure or detailed explanations.
- Prioritizing duplicate removal without preserving useful information.

#### Lessons learned
- Before editing `TODO.md`, read and analyze the full content to identify duplicates, disorder and useful explanations.
- Keep a single source of truth: one task list, one detail block and an ordered, explanatory progress section.
- Do not remove useful information or detailed explanations from the progress section.
- Document each relevant action and decision to help future LLMs and humans.

### Recurring mistake: Marking tasks done without real validation
- The 'testing and debugging' task was marked completed in `TODO.md` without performing real tests or having evidence.
- This mistake had been documented previously but was repeated because steps were not paused and validated before updating task status.

#### Lesson learned
- Do not mark tasks as done without executing and verifying the corresponding actions.
- Pause and check each step before updating the documentation.
- If an error is detected, correct `TODO.md` and record it here for future reference.

## 2025-09-03

### Critical Problem: NSStatusItem apps cannot receive keyboard input by default

#### Problem Description
When developing modal windows/dialogs for macOS status bar applications (NSStatusItem), text fields appear to work (can paste text via right-click) but cannot receive direct keyboard input. Users can interact with the window but typing doesn't work.

#### Root Cause Analysis
- **NSApplication.ActivationPolicy**: Status bar apps use `.accessory` activation policy by default
- **Key Window Limitation**: Applications with `.accessory` policy cannot become "key application"
- **First Responder Chain**: Without being key application, windows cannot properly establish first responder for keyboard events
- **Event Routing**: Keyboard events are not routed to accessory applications' windows

#### What Was Done Wrong Initially
1. Used standard NSAlert and NSPanel approaches without considering activation policy
2. Only focused on `makeFirstResponder()` and `becomeFirstResponder()` calls
3. Ignored the fundamental limitation of accessory applications
4. Spent multiple iterations on UI tweaks instead of addressing the core issue

#### Correct Solution
```swift
// Before showing modal window:
NSApp.setActivationPolicy(.regular)
NSApp.activate(ignoringOtherApps: true)

// Show window with proper key window setup:
window.makeKey()
window.makeFirstResponder(textField)
textField.becomeFirstResponder()

// After closing modal window:
NSApp.setActivationPolicy(.accessory)
```

#### Key Technical Details
- **Timing**: Must set activation policy BEFORE showing the window
- **Reset Required**: Must reset to `.accessory` after modal closes to maintain status bar behavior
- **Window Level**: Use `.floating` instead of `.modalPanel` for better compatibility
- **Explicit Calls**: Must explicitly call `makeKey()`, `makeFirstResponder()`, and `becomeFirstResponder()`

#### Lesson Learned
- Status bar applications have fundamental limitations that require specific workarounds
- Always research the application type's constraints before implementing UI patterns
- Test keyboard input specifically, not just visual appearance of dialogs
- The fact that context menus work but typing doesn't is a clear indicator of activation policy issues

