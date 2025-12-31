# Adding Browser Support to BkmkMgrs

This document serves as an index to all resources for adding support for a new browser (example: ChatGPT Atlas).

## Quick Answer

**To add support for a new browser, you must create and modify 6-7 files:**

### Files to CREATE (2):
1. **ExtoreChatGPTAtlas.h** - Class header (~15 lines)
2. **ExtoreChatGPTAtlas.m** - Class implementation (~125-200 lines)

### Files to MODIFY (4):
3. **BkmxGlobals.h** - Add 1 line (exformat declaration)
4. **BkmxGlobals.m** - Add 1 line (constant definition)
5. **BkmkMgrs.xcodeproj/project.pbxproj** - Add file references to build target
6. **Client.m** (Optional) - Add to format lists if they exist

### Files to ADD (Optional):
7. **BookMacsterTests/Cases/ChatGPTAtlas/** - Sample bookmark files for testing

## Total Implementation

- **~250 lines of code**
- **6-7 files touched**
- **Key insight**: Dynamic runtime reflection auto-discovers new browsers via naming convention

## Available Documentation

### 1. **ADD_NEW_BROWSER_QUICK_START.md** ⭐ START HERE
   - Quickest path to implementation
   - 2-page summary
   - Key decisions before coding
   - One complete minimal example
   - **Best for:** Getting something working fast

### 2. **BROWSER_SUPPORT_CHECKLIST.md** 📋 COMPREHENSIVE GUIDE
   - Complete file-by-file breakdown
   - All decisions explained
   - Implementation checklist
   - Reference implementations listed
   - Dynamic registration system explanation
   - **Best for:** Understanding everything in detail

### 3. **EXTORE_TEMPLATE.h** 📄 CODE TEMPLATE
   - Copy-and-customize template for header
   - Inline comments
   - Inheritance options explained
   - **Best for:** Starting with actual code

### 4. **EXTORE_TEMPLATE.m** 📄 CODE TEMPLATE
   - Copy-and-customize template for implementation
   - Detailed ExtoreConstants documentation (~65 lines)
   - All required methods with explanations
   - Real code patterns from existing browsers
   - **Best for:** Understanding ExtoreConstants struct

### 5. **CLAUDE.md** 📚 PROJECT OVERVIEW
   - General codebase architecture
   - Build commands
   - Testing instructions
   - Major subsystems
   - **Best for:** Understanding BkmkMgrs overall

## The System's Magic

The system uses **dynamic class discovery** at runtime:

```objc
// No registry needed! Just create the class and the system finds it:
NSString* className = [@"Extore" stringByAppendingString:@"ChatGPTAtlas"];
Class extoreClass = NSClassFromString(className);  // Returns ExtoreChatGPTAtlas
```

Once you:
1. Create `ExtoreChatGPTAtlas` class
2. Define `constExformatChatGPTAtlas = @"ChatGPTAtlas"` constant
3. Add files to Xcode build target

**The system automatically discovers and uses your new browser. No other registration needed!**

## Recommended Reading Order

### For Quick Implementation (30-60 minutes):
1. Read **ADD_NEW_BROWSER_QUICK_START.md**
2. Copy **EXTORE_TEMPLATE.h** → **ExtoreChatGPTAtlas.h**
3. Copy **EXTORE_TEMPLATE.m** → **ExtoreChatGPTAtlas.m**
4. Customize constants
5. Add to BkmxGlobals.h/m and Xcode
6. Build and test

### For Deep Understanding (2-3 hours):
1. Read **BROWSER_SUPPORT_CHECKLIST.md**
2. Study EXTORE_TEMPLATE.h and EXTORE_TEMPLATE.m
3. Look at reference implementations (ExtoreChrome.m, ExtoreSafari.m)
4. Make implementation decisions
5. Implement and test

### For Full Context:
1. **CLAUDE.md** - Project architecture and building
2. **BROWSER_SUPPORT_CHECKLIST.md** - Browser integration details
3. **EXTORE_TEMPLATE.m** - Implementation reference

## Key Decisions Before Coding

Research the browser and answer these questions:

| Question | Impact |
|----------|--------|
| **How are bookmarks stored?** | Determines inheritance path (Chromy vs LocalPlist vs Extore) |
| **Where are bookmarks located?** | Sets `appSupportRelativePath` and `fileParentPathRelativeTo` |
| **Does it support multiple profiles?** | Determines `supportsMultipleProfiles` and profile discovery logic |
| **What's the bundle identifier?** | Used by system to locate installed browser |
| **Minimum macOS version?** | Sets version requirements in ExtoreConstants |

## Inheritance Paths

Choose based on how the browser stores bookmarks:

### Chromium-based (Most Common)
```objc
@interface ExtoreChatGPTAtlas : ExtoreChromy
// Inherits SQLite reading/writing from Chrome
// Minimal implementation (~125 lines)
// Examples: Chrome, Vivaldi, Edge, Brave
```

### Plist-based (Like Safari)
```objc
@interface ExtoreChatGPTAtlas : ExtoreLocalPlist
// Inherits property list parsing
// Implementation (~150 lines)
// Examples: Safari
```

### Custom Format
```objc
@interface ExtoreChatGPTAtlas : Extore
// Custom parsing required
// Most complex (~200+ lines)
// Examples: Firefox, web services
```

## What Each File Does

### ExtoreChatGPTAtlas.h
Declares the Extore subclass interface. Minimal:
```objc
@interface ExtoreChatGPTAtlas : ExtoreChromy {}
+ (NSString*)appSupportRelativePath;
@end
```

### ExtoreChatGPTAtlas.m
Implements browser-specific handling:
- **ExtoreConstants struct** (~60 lines) - Defines capabilities, paths, versions
- **Class methods** - Return metadata about the browser
- **Instance methods** - Override if special behavior needed

### BkmxGlobals.h & BkmxGlobals.m
Register the new format constant:
```objc
// .h file:
extern NSString* const constExformatChatGPTAtlas;

// .m file:
NSString* const constExformatChatGPTAtlas = @"ChatGPTAtlas" ;
```

### BkmkMgrs.xcodeproj/project.pbxproj
Add files to BookMacster target's Compile Sources build phase.

### Client.m (Optional)
If there are methods that enumerate supported formats, add the new constant.

## Build & Test

```bash
# Build the project
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BookMacster -configuration Debug

# Run tests
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BookMacster test

# Launch the application
open "build/Debug/BookMacster.app"
```

Then in the app:
1. Preferences → Add New Client
2. Select "ChatGPT Atlas"
3. Test import/export with sample bookmark files

## Common Pitfalls

❌ **Wrong bundle identifier** - Browser won't be detected by system

✅ **Get it right**: `mdls -name kMDItemCFBundleIdentifier /Applications/ChatGPTAtlas.app`

---

❌ **Class name typo** - Runtime reflection won't find it

✅ **Formula**: `Extore` + exformat = class name
- Example: `Extore` + `ChatGPTAtlas` = `ExtoreChatGPTAtlas`

---

❌ **Files not in Xcode target** - Won't compile or link

✅ **Add via**: Project → Target → Build Phases → Compile Sources

---

❌ **Wrong inheritance** - Missing methods or wrong behavior

✅ **Study**: Similar browsers (ExtoreChrome.m for Chromium, ExtoreSafari.m for plist)

---

❌ **Incorrect paths** - Bookmark file not found

✅ **Verify**: Actual bookmark storage path in ~/Library/Application Support/

## Reference Files in Codebase

### Simple Examples
- **ExtoreOrion.m** (~125 lines) - Minimal Chromium-based example
- **ExtoreChrome.m** - Chrome variant (Chromium base)

### Complex Examples
- **ExtoreFirefox.m** (184KB) - Custom SQLite format with parsing
- **ExtoreSafari.m** (168KB) - Complex plist handling with special sync

### Abstractions
- **Extore.h/.m** (258KB) - Base class with all abstract methods
- **ExtoreChromy.h/.m** (91KB) - Chromium base with SQLite handling
- **ExtoreLocalPlist.h/.m** - Plist file handling base

## Files Documentation

```
BkmkMgrs/
├── CLAUDE.md                          ← Project overview & architecture
├── ADD_NEW_BROWSER_QUICK_START.md     ← Quick reference (START HERE)
├── BROWSER_SUPPORT_CHECKLIST.md       ← Comprehensive guide
├── EXTORE_TEMPLATE.h                  ← Copy to create new browser header
├── EXTORE_TEMPLATE.m                  ← Copy to create new browser implementation
├── README_BROWSER_SUPPORT.md          ← This file
├── BkmxGlobals.h                      ← Add exformat declaration here
├── BkmxGlobals.m                      ← Add constant definition here
├── Extore.h / Extore.m                ← Abstract base class
├── ExtoreChromy.h / ExtoreChromy.m    ← Chromium base implementation
├── ExtoreChrome.h / ExtoreChrome.m    ← Chrome variant
├── ExtoreSafari.h / ExtoreSafari.m    ← Safari variant
├── ExtoreFirefox.h / ExtoreFirefox.m  ← Firefox variant
└── Client.m                           ← Optional: Register in format lists
```

## Support

For questions about:
- **Architecture**: See CLAUDE.md or BROWSER_SUPPORT_CHECKLIST.md
- **Quick implementation**: See ADD_NEW_BROWSER_QUICK_START.md
- **Code templates**: See EXTORE_TEMPLATE.h/m
- **Building/testing**: See CLAUDE.md

## Summary

Adding browser support involves:

1. **Research** (~15 min) - How does the browser store bookmarks?
2. **Create 2 files** (~30 min) - Header and implementation
3. **Register globally** (~5 min) - Add constants to BkmxGlobals
4. **Add to Xcode** (~5 min) - Include in build target
5. **Build & test** (~10 min) - Verify it works

**Total: ~60-90 minutes for a working implementation**

The elegant design of the Extore system makes browser support remarkably easy to add!
