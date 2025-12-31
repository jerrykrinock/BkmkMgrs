# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**BkmkMgrs** (BookMacster) is a sophisticated macOS bookmark management application that synchronizes bookmarks across multiple browsers (Safari, Chrome, Firefox, Opera, Edge, Vivaldi, Brave, etc.) and web services (Pinboard, Diigo, Delicious, Google Bookmarks, etc.). Current version: **3.3.1**

Key capabilities:
- Multi-browser bookmark import/export
- Bookmark synchronization and tagging
- Duplicate detection and resolution
- Background monitoring and auto-sync via XPC service
- Native Safari extension and W3C browser extension support
- Secure credential storage via macOS Keychain

## Build & Development Commands

### Building

```bash
# Build main application (Release)
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BookMacster -configuration Release

# Build main application (Debug)
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BookMacster -configuration Debug

# Build specific target
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BkmxAgent -configuration Debug

# Build with verbose output
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BookMacster -configuration Debug -v
```

### Testing

```bash
# Run all unit tests
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BookMacster test

# Run specific test target
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme CategoriesObjCTests test

# Run UI tests
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BookMacsterUITests test

# Run agent tests
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BkmxAgentTests test

# Run single test class
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BookMacster test -only-testing:BkmkMgrsTests/BkmkMgrTests

# Run test with verbose output and no caching
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BookMacster test -verbose -fresh
```

Test data fixtures are in `BookMacsterTests/Cases/` (Safari, Chrome, Firefox bookmark samples).

### Running the Application

```bash
# Launch from build directory
open "build/Debug/BookMacster.app"

# Run with LLDB debugger
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BookMacster -configuration Debug -enableAddressSanitizer YES run
```

### Build Products Location

```
/Users/jk/Documents/Programming/Projects/BkmkMgrs/build/
├── Debug/
│   ├── BookMacster.app
│   └── [other targets]
└── Release/
    ├── BookMacster.app
    └── [other targets]
```

## Architecture & Design

### Multi-Process Design

BkmkMgrs uses a multi-process architecture for reliability and performance:

```
┌─────────────────────────────────────────┐
│    BookMacster Main Application         │
│    - UI Layer (NSViewController)         │
│    - Document Management (BkmxDoc)      │
│    - Application Services (BkmxAppDel)  │
└──────────────────┬──────────────────────┘
                   │ XPC Connection
        ┌──────────┴──────────┐
        │                     │
    ┌───▼────────┐    ┌───────▼────┐
    │ BkmxAgent  │    │   Safari   │
    │ (Daemon)   │    │ Extension  │
    └────────────┘    └────────────┘
        │ Background sync & watches
        │ Coordinates job queue
        └──→ W3CBE Browser Extensions
            (Chrome, Firefox, etc.)
```

### Core Data Model

**26 CoreData Entities** in `BookMacster.xcdatamodeld/`:

| Entity | Role |
|--------|------|
| **Stark** (163KB) | Bookmark/folder tree node with external ID tracking |
| **Client** | Browser profile or service account (e.g., Safari, Chrome, Pinboard) |
| **Extore** (258KB) | Abstract external store; subclasses handle format-specific access (Safari, Firefox, Chromium-based, etc.) |
| **Ixporter** (192KB) | Import/Export handler; orchestrates bookmark transfer with merge logic |
| **Importer/Exporter** | Concrete implementations for bidirectional sync |
| **Macster** (133KB) | Synchronization coordinator; manages multi-way sync jobs |
| **Bookshig** | Document metadata (sort order, filters, verification dates) |
| **Dupe/Dupetainer** | Duplicate detection and management |
| **Command, Syncer** | Job scheduling and execution |
| **Tag** | User-applied bookmark tags |

**Data Persistence**: SQLite via CoreData (uses multi-threaded context model)

**Data Migrations**: Three schema versions (Bkmx017 → Bkmx018 → Bkmx019) with migration policies in `*MigrationPolicy.m`

### Major Subsystems

#### 1. **Import/Export Engine**
- **Files**: `Ixporter.m`, `Importer.m`, `Exporter.m`
- Handles multiple formats: HTML, JSON, plist, SQLite, OPML
- Format-agnostic interface with pluggable handlers
- Merge strategies: compare URLs, titles, hierarchies

#### 2. **Browser Abstraction Layer (Extore)**
- **File**: `Extore.m` (258KB) + subclasses
- Protocol-based design for format abstraction
- Implementations:
  - `ExtoreSafari` (168KB)
  - `ExtoreFirefox` (184KB)
  - `ExtoreChromy` (91KB) - Base class for Chromium browsers
  - `ExtoreChrome`, `ExtoreCanary`, `ExtoreBrave`, `ExtoreVivaldi`, etc.
- Each handles browser-specific quirks and file locations

#### 3. **Bookmark Tree Model**
- **File**: `Stark.m` (163KB)
- Inherits from `SSYManagedTreeObject` for hierarchy support
- External ID tracking via `Clixid` entities for multi-browser mapping
- Tree operations: reordering, expansion state, parent/child relationships

#### 4. **Synchronization & Background Jobs**
- **File**: `AgentPerformer.m` (63KB)
- Runs in `BkmxAgent` XPC service
- Operation queue for sequential/parallel execution
- Job types: import, export, verify, sort, duplicate detection, save
- Each operation is an NSOperation subclass:
  - `OperationImport`, `OperationExport`
  - `OperationSort`, `OperationVerify`
  - `OperationDupe`, `OperationExpandConsolidate`

#### 5. **Browser Extensions**
- **W3CBE (World Wide Web Consortium Browser Extension Community Group)**
  - `BookMacsterButton` - Quick-add bookmark from browser
  - `BookMacsterSync` - Auto-sync capability
  - Supports Firefox, Chrome, Chromium-based browsers via manifests
- **Safari Extension** (`SheepSafariHelper.m`, 157KB)
  - Native App Extension (no messaging bridge needed)
- **Chromessenger** - Native messaging bridge for Chrome
  - JSON-based message protocol

#### 6. **Application Coordination**
- **BkmxAppDel.m** (271KB) - Application delegate
  - Document lifecycle management
  - Job queue coordination
  - Browser monitoring via `ActiveBrowserObserver`
  - Notification handling

- **BkmxDoc.m** (408KB) - Document class
  - CoreData coordination
  - Undo/redo management
  - Import/export delegation
  - Window and view management

### Key Architectural Patterns

1. **MVC** - Models (CoreData entities), Views (NSView subclasses), Controllers (NSViewController/NSWindowController)

2. **Document-Based App** - NSDocument subclasses for document persistence and lifecycle

3. **Strategy Pattern** - `Extore` subclasses implement format-specific reading/writing strategies

4. **Observer Pattern** - Extensive use of NSNotificationCenter for event propagation

5. **XPC Services** - Multi-process isolation with `BkmxAgent` daemon for background work

6. **Operation Queue** - Async work via NSOperation/NSOperationQueue for responsive UI

7. **Adapter Pattern** - Format converters bridge between external formats and internal model

### Source Code Organization

**Root directory** (~600 files):
- **Core models**: `Stark.{h,m}`, `Client.{h,m}`, `Extore.{h,m}`
- **UI controllers**: `BkmxDoc*.{h,m}`, `BkmxAppDel.m`, `BkmxDocWinCon.m`
- **Import/Export**: `Ixporter.{h,m}`, `Importer.m`, `Exporter.m`
- **Browser handlers**: `ExtoreSafari.m`, `ExtoreFirefox.m`, `ExtoreChromy.m`, etc.
- **Operations**: `Operation*.{h,m}` (Import, Export, Sort, Verify, Dupe, etc.)
- **Utilities**: NS* category extensions, helper classes

**Subdirectories**:
- `BkmkMgrs.xcodeproj/` - Xcode project configuration
- `BkmkMgrs.xcworkspace/` - Xcode workspace (preferred for building)
- `BookMacsterTests/` - Unit test cases and test data fixtures
- `BookMacsterUITests/` - UI automation tests
- `BkmxAgentRunner/` - Swift CLI tool for agent management
- `BkmxAgentTest/` - SwiftUI test application
- `ExtensionsBrowser/` - Browser extension source code
- `BuildScripts/` - Build automation (W3CBE extensions, etc.)
- `BookMacster.xcdatamodeld/` - CoreData models with migration mappings

## Key Technical Details

### Language Mix
- **Objective-C**: ~567 files (legacy and core business logic)
- **Swift**: ~32 files (modern components, agent runner, UI tests)
- **C**: Minimal (some utility code)

Mixing languages requires:
- Bridge headers (e.g., `BkmxAgentRunner-Bridging-Header.h`)
- Manual memory management in Objective-C files using `-fno-objc-arc` compiler flag where needed
- Import statements in Swift files for Objective-C headers

### CoreData Access

Multi-threaded access pattern:
- Main thread: UI operations
- Background threads: Import/export, sync operations
- Separate managed object contexts per thread
- Use `performBlock:` or `performBlockAndWait:` for thread-safe access

Example pattern in `AgentPerformer.m`:
```objc
[managedObjectContext performBlockAndWait:^{
    // Sync operation on background thread
}];
```

### Credential Storage

Sensitive credentials stored in macOS Keychain via `SSYKeychain`:
- Browser profile passwords
- Service account tokens
- No credentials in CoreData or preference files

### External ID Tracking

Multi-client bookmark mapping via `Clixid` entity:
- Each browser/service has a Client instance
- Each Stark (bookmark) tracks external IDs per Client
- Example: Same bookmark exists as Chromium ID #123 and Safari ID #456
- Enables proper duplicate detection and merge operations

### Common Workflow: Adding Support for a New Browser

1. Create new `Extore` subclass (e.g., `ExtoreNewBrowser.m`)
2. Implement protocol methods:
   - Read bookmarks from browser's storage format
   - Write bookmarks back to external format
   - Handle browser-specific quirks and file locations
3. Register in `Client` class factory methods
4. Add corresponding `Importer`/`Exporter` instances if format differs
5. Test with sample bookmark files in `BookMacsterTests/Cases/`

## Common Issues & Patterns

### Objective-C ARC Status

Many files compiled with `-fno-objc-arc` (manual memory management):
- Check build phase "Compile Sources" for individual file compiler flags
- Required for older utility classes and categories
- New Swift code and modern Objective-C use ARC

### Large Core Files

Three largest files indicate architectural hotspots:
- `BkmxDoc.m` (408KB) - Document coordination
- `BkmxAppDel.m` (271KB) - Application services
- `Extore.m` (258KB) - Format abstraction

Consider these areas for refactoring opportunities if making significant changes.

### XPC Service Communication

BkmxAgent runs as XPC service:
- Defined in `BkmxAgent.entitlements`
- Protocol: `BkmxAgentProtocol.h`
- Use `NSXPCConnection` for inter-process calls
- Callbacks are asynchronous (no synchronous RPC)

### Test Data

Sample bookmark files in `BookMacsterTests/Cases/`:
- `Safari/`, `Safari-v2/` - Safari bookmarks HTML exports
- Various browser formats for regression testing
- Each directory may have `run.sh` to set up test environment

## Dependencies & Frameworks

**Apple Frameworks**:
- Cocoa, AppKit, Foundation - macOS UI and core APIs
- CoreData - Persistent storage
- Security - Keychain access
- ServiceManagement - LaunchAgent management
- ApplicationServices, CloudKit, IOKit - System integration

**Internal Frameworks**:
- `Bkmxwork` - Shared bookmark handling framework
- `SSY*` classes - SheepSystems utility classes (error handling, tree objects, etc.)

**External Dependencies**:
- `swift-argument-parser` (v1.3.0) - CLI argument parsing for SwiftUI tools

## Xcode Workspace vs Project

**Always use the workspace** (`BkmkMgrs.xcworkspace`) for building:

```bash
# Correct - uses framework dependencies properly
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BookMacster

# May have dependency issues
xcodebuild -project BkmkMgrs.xcodeproj -scheme BookMacster
```

The workspace coordinates the main project with the `Bkmxwork` framework and build dependencies.

## Recent Changes & Context

From git history:
- v3.3.1: Fixed Diigo/Pinboard keychain checkbox persistence
- v3.3: Fixed macOS Tahoe file duplication, extension alignment
- v3.3.1: Relaxed Opera bookmark index validation (schema changed in 2024)

Browser-specific issues are tracked in code comments and migration policies.

