# Quick Start: Add Support for a New Browser

## Summary

To add **ChatGPT Atlas** browser support to BkmkMgrs, you need to create and modify **7 files/locations**:

## Files to Create

### 1. ExtoreChatGPTAtlas.h
```objc
#import "ExtoreChromy.h"  // or ExtoreLocalPlist depending on format

@interface ExtoreChatGPTAtlas : ExtoreChromy {
}

+ (NSString*)appSupportRelativePath;

@end
```

### 2. ExtoreChatGPTAtlas.m
- Define `ExtoreConstants` static struct with browser capabilities
- Implement required class methods:
  - `+ (const ExtoreConstants *)constants_p`
  - `+ (NSArray*)browserBundleIdentifiers`
  - `+ (NSString*)appSupportRelativePath`
  - `+ (NSString*)fileParentRelativePath`
  - `+ (PathRelativeTo)fileParentPathRelativeTo`
  - `+ (BOOL)supportsMultipleProfiles`

See `ExtoreOrion.m` for a minimal example.

## Files to Modify

### 3. BkmxGlobals.h
Add after line ~220 (alphabetically with other constants):
```objc
extern NSString* const constExformatChatGPTAtlas;
```

### 4. BkmxGlobals.m
Add corresponding definition:
```objc
NSString* const constExformatChatGPTAtlas = @"ChatGPTAtlas" ;
```

### 5. BkmkMgrs.xcodeproj/project.pbxproj
Add these files to the **BookMacster target's Compile Sources phase**:
- ExtoreChatGPTAtlas.h
- ExtoreChatGPTAtlas.m

(Use Xcode: Project → BookMacster target → Build Phases → Compile Sources → Add)

### 6. Client.m (Optional)
If there's a method listing supported formats, add `constExformatChatGPTAtlas` there.

### 7. BookMacsterTests/Cases/ChatGPTAtlas/ (Optional but Recommended)
Create sample bookmark files for regression testing.

## Key Decisions

Before implementing, research ChatGPT Atlas:

| Decision | Impact |
|----------|--------|
| **Bookmark format** | Determines inheritance (Chromy, LocalPlist, Extore) |
| **Storage location** | Affects `appSupportRelativePath`, `fileParentPathRelativeTo` |
| **Multiple profiles?** | Determines `supportsMultipleProfiles`, `allProfilesThisHome` |
| **macOS version** | Set `minSystemVersionForBrows*` in ExtoreConstants |
| **Bundle identifier** | Used by system to locate installed browser |

## The Magic: Dynamic Registration

**You don't need to register the class anywhere!** The system uses runtime reflection:

```objc
// Extore.m automatically finds your class at runtime:
NSString* className = [@"Extore" stringByAppendingString:@"ChatGPTAtlas"];
Class extoreClass = NSClassFromString(className);  // = ExtoreChatGPTAtlas
```

Once you create the class and add the constant, the system discovers it automatically.

## Inheritance Examples

Choose based on how ChatGPT Atlas stores bookmarks:

```
Chromium-based (SQLite):
ExtoreChatGPTAtlas : ExtoreChromy

Plist file:
ExtoreChatGPTAtlas : ExtoreLocalPlist

Custom format:
ExtoreChatGPTAtlas : Extore
```

## Testing the Integration

```bash
# Build to check for compilation errors
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BookMacster

# Run tests
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BookMacster test

# Launch app
open "build/Debug/BookMacster.app"

# In app: Preferences → Add new "ChatGPT Atlas" client
# Try import/export with test bookmarks file
```

## Reference Implementations

- **Similar Chromium browser**: `ExtoreChrome.m`, `ExtoreVivaldi.m`
- **Plist format**: `ExtoreSafari.m`, `ExtoreLocalPlist.m`
- **Minimal example**: `ExtoreOrion.m` (~125 lines)
- **Complex example**: `ExtoreFirefox.m` (184KB - custom format parsing)

## That's It!

The naming convention and dynamic class lookup handle everything else:

1. ✅ Create `ExtoreChatGPTAtlas` class
2. ✅ Add `constExformatChatGPTAtlas` constant
3. ✅ Register in Xcode build target
4. ✅ Done! System auto-discovers the new browser

See `BROWSER_SUPPORT_CHECKLIST.md` for detailed implementation guide.
