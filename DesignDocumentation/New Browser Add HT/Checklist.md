# Adding Browser Support: ChatGPT Atlas

This document outlines all files that must be created or modified to add support for the fictional "ChatGPT Atlas" browser to BkmkMgrs.

## Overview

The integration uses a naming convention-based system where:
- Exformat name: `ChatGPTAtlas` (must match class name suffix)
- Class: `ExtoreChatGPTAtlas` (prefix `Extore` + exformat)
- Constant: `constExformatChatGPTAtlas`

The system dynamically maps exformat strings to classes at runtime:
```objc
// In Extore.m
NSString* extoreClassName = [@"Extore" stringByAppendingString:@"ChatGPTAtlas"];
Class extoreClass = NSClassFromString(extoreClassName); // Returns ExtoreChatGPTAtlas
```

## Files to Create

### 1. **ExtoreChatGPTAtlas.h** (New Header File)

Create at root level: `/Users/jk/Documents/Programming/Projects/BkmkMgrs/ExtoreChatGPTAtlas.h`

Determine the inheritance hierarchy:
- If bookmarks are stored in **Chromium-based format** (SQLite): inherit from `ExtoreChromy` or a specific subclass like `ExtoreChrome`
- If stored in **custom/proprietary format**: inherit directly from `Extore` or `ExtoreLocalPlist`
- If stored as **plist file**: inherit from `ExtoreLocalPlist`

Example for Chromium-based browser:
```objc
#import "ExtoreChromy.h"

@interface ExtoreChatGPTAtlas : ExtoreChromy {
}

+ (NSString*)appSupportRelativePath;

@end
```

For a custom format, inherit from `ExtoreLocalPlist`:
```objc
#import "ExtoreLocalPlist.h"

@interface ExtoreChatGPTAtlas : ExtoreLocalPlist {
}

+ (NSString*)appSupportRelativePath;

@end
```

### 2. **ExtoreChatGPTAtlas.m** (New Implementation File)

Create at root level: `/Users/jk/Documents/Programming/Projects/BkmkMgrs/ExtoreChatGPTAtlas.m`

Minimum implementation required:

```objc
#import "ExtoreChatGPTAtlas.h"
#import "BkmxGlobals.h"
#import "StarkTyper.h"

static const ExtoreConstants extoreConstants = {
	/* canEditAddDate */                  NO,
	/* canEditComments */                 BkmxCanEditInStyleNeither,
	/* canEditFavicon */                  NO,
	/* canEditFaviconUrl */               NO,
	/* canEditIsAutoTab */                NO,
	/* canEditIsExpanded */               NO,
	/* canEditIsShared */                 NO,
	/* canEditLastChengDate */            NO,
	/* canEditLastModifiedDate */         NO,
	/* canEditLastVisitedDate */          NO,
	/* canEditName */                     YES,
	/* canEditRating */                   NO,
	/* canEditRssArticles */              NO,
    /* canEditSeparators */               BkmxCanEditInStyleNeither,
	/* canEditShortcut */                 BkmxCanEditInStyleNeither,
	/* canEditTags */                     BkmxCanEditInStyleNeither,
	/* canEditUrl */			          YES,
	/* canEditVisitCount */               NO,
	/* canCreateNewDocuments */           YES,
	/* ownerAppDisplayName */             @"ChatGPT Atlas",
	/* webHostName */                     nil,
	/* authorizationMethod */             BkmxAuthorizationMethodNone,
	/* accountNameHint */                 nil,
	/* oAuthConsumerKey */                nil,
	/* oAuthConsumerSecret */             nil,
	/* oAuthRequestTokenUrl */            nil,
	/* oAuthRequestAccessUrl */           nil,
	/* oAuthRealm */                      nil,
	/* appSupportRelativePath */          @"ChatGPT-Atlas",
	/* defaultFilename */                 @"Bookmarks",
	/* defaultProfileName */              @"Default",
	/* iconResourceFilename */            nil,
	/* iconInternetURL */                 nil,
	/* fileType */                        @"",
	/* ownerAppObservability */           OwnerAppObservabilitySpecialFile,
	/* canPublicize */                    NO,
	/* silentlyRemovesDuplicates */       NO,
	/* normalizesURLs */                  NO,
	/* catchesChangesDuringSave */        NO,
	/* telltaleString */                  @"checksum",
	/* hasBar */                          YES,
	/* hasMenu */                         YES,
	/* hasUnfiled */                      NO,
	/* hasOhared */                       NO,
	/* tagDelimiter */                    nil,
	/* dateRef1970Not2001 */              YES,
	/* hasOrder */                        YES,
	/* hasFolders */                      YES,
	/* ownerAppIsLocalApp */              YES,
	/* defaultSpecialOptions */           0x0000000000000000LL,
	/* extensionInstallDirectory */       @"Extensions",
	/* minBrowserVersionMajor */          1,
	/* minBrowserVersionMinor */          0,
	/* minBrowserVersionBugFix */         0,
	/* minSystemVersionForBrowsMajor */   12,  // macOS 12.0 (Monterey)
	/* minSystemVersionForBrowMinor */    0,
	/* minSystemVersionForBrowBugFix */   0
} ;

@implementation ExtoreChatGPTAtlas

+ (const ExtoreConstants *)constants_p {
	return &extoreConstants ;
}

+ (NSArray*)browserBundleIdentifiers {
    return [NSArray arrayWithObject:@"com.chatgpt.atlas"] ;  // Replace with actual bundle ID
}

+ (NSString*)appSupportRelativePath {
    return [self constants_p]->appSupportRelativePath;
}

+ (NSString*)fileParentRelativePath {
	return @"";  // Empty if bookmarks file is at root or in profile folder
}

+ (PathRelativeTo)fileParentPathRelativeTo {
    return PathRelativeToApplicationSupport;  // Or PathRelativeToProfile
}

+ (BOOL)supportsMultipleProfiles {
    return YES;  // Or NO depending on browser design
}

+ (NSSet*)allProfilesThisHome {
    // Return set of available profiles on this Mac
    // Implementation depends on how ChatGPT Atlas stores profiles
    return [NSSet set];
}

@end
```

## Files to Modify

### 3. **BkmxGlobals.h** (Modify - Add Constant Declaration)

File: `/Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxGlobals.h`

**Find the exformat declarations section** (around line 200-250):
```objc
extern NSString* const constExformatOrion ;
extern NSString* const constExformatSafari ;
extern NSString* const constExformatVivaldi ;
```

**Add the new declaration** (keep alphabetically sorted):
```objc
extern NSString* const constExformatChatGPTAtlas ;
```

### 4. **BkmxGlobals.m** (Modify - Add Constant Definition)

File: `/Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxGlobals.m`

**Find the exformat definitions section** (corresponds to declarations in .h):
```objc
NSString* const constExformatOrion = @"Orion" ;
NSString* const constExformatSafari = @"Safari" ;
NSString* const constExformatVivaldi = @"Vivaldi" ;
```

**Add the new definition** (keep alphabetically sorted):
```objc
NSString* const constExformatChatGPTAtlas = @"ChatGPTAtlas" ;
```

### 5. **BkmkMgrs.xcodeproj/project.pbxproj** (Modify - Add to Build Target)

File: `/Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmkMgrs.xcodeproj/project.pbxproj`

**Steps**:
1. Open in Xcode or with a text editor
2. Find the "Sources" phase for the BookMacster target
3. Locate where other `Extore*.m` files are listed
4. **Add two new file references**:
   - `ExtoreChatGPTAtlas.h` → Target membership: BookMacster
   - `ExtoreChatGPTAtlas.m` → Target membership: BookMacster

**Or use Xcode GUI**:
1. Open `BkmkMgrs.xcworkspace` in Xcode
2. Select project → BookMacster target → Build Phases → Compile Sources
3. Click `+` and add the two new files

### 6. **Client.m** (Modify - Register in Format List) [Optional but Recommended]

File: `/Users/jk/Documents/Programming/Projects/BkmkMgrs/Client.m`

This file may contain factory methods or lists of supported formats. Search for where existing formats are enumerated and add ChatGPTAtlas if present.

Example pattern to look for:
```objc
- (NSArray*)supportedExformats {
    return @[constExformatChrome, constExformatSafari, constExformatFirefox, /* ... */];
}
```

### 7. **Test Data Files** [Strongly Recommended]

Directory: `/Users/jk/Documents/Programming/Projects/BkmkMgrs/BookMacsterTests/Cases/ChatGPTAtlas/`

Create sample bookmark files for testing:
- **ChatGPTAtlas/** - New test case directory
  - `run.sh` - Shell script to set up test environment (if needed)
  - Sample bookmark export/file in ChatGPT Atlas format

This allows developers to test import/export without the actual browser.

## Implementation Checklist

### ExtoreChatGPTAtlas.h/m Creation
- [ ] Create header file with proper inheritance
- [ ] Define `ExtoreConstants` structure with accurate metadata
- [ ] Implement `+ (const ExtoreConstants *)constants_p`
- [ ] Implement `+ (NSArray*)browserBundleIdentifiers`
- [ ] Implement `+ (NSString*)appSupportRelativePath`
- [ ] Implement `+ (NSString*)fileParentRelativePath`
- [ ] Implement `+ (PathRelativeTo)fileParentPathRelativeTo`
- [ ] Implement `+ (BOOL)supportsMultipleProfiles`
- [ ] Implement `+ (NSSet*)allProfilesThisHome` if multiple profiles supported
- [ ] Override other methods as needed (sync support, special handling, etc.)

### Global Registration
- [ ] Add `extern` declaration in `BkmxGlobals.h`
- [ ] Add constant definition in `BkmxGlobals.m`
- [ ] Add files to Xcode project build phases
- [ ] Add to `Client.m` supported formats list (if applicable)

### Testing & Documentation
- [ ] Create test data files in `BookMacsterTests/Cases/ChatGPTAtlas/`
- [ ] Test import from ChatGPT Atlas bookmarks file
- [ ] Test export to ChatGPT Atlas format
- [ ] Test bookmark synchronization
- [ ] Verify application can detect installed ChatGPT Atlas browser
- [ ] Document any special handling in code comments

## Key Implementation Decisions

When implementing `ExtoreChatGPTAtlas`, you'll need to determine:

1. **Inheritance Path**:
   - **Chromium-based?** → Inherit from `ExtoreChromy` or `ExtoreChrome`
   - **Custom/proprietary format?** → Inherit from `Extore` directly
   - **Plist file?** → Inherit from `ExtoreLocalPlist`

2. **Bookmark Storage**:
   - Where does ChatGPT Atlas store bookmarks? (file path)
   - What format? (SQLite, plist, HTML, JSON, custom)
   - How to read/parse the format?
   - How to write back to the format?

3. **Profile Support**:
   - Single or multiple profiles?
   - How are profiles discovered?
   - Profile location within app support directory?

4. **Features**:
   - Does it support extensions? (browser extensions for sync)
   - Can it edit various bookmark properties? (name, URL, date, etc.)
   - Special requirements or quirks?

5. **Bundle Identifier**:
   - What is the actual macOS bundle ID for ChatGPT Atlas?
   - Used for: `[SSYOtherApper fullPathForAppWithBundleIdentifier:]`

## Related Files for Reference

Key files that implement similar functionality:

- **Chromium-based browsers**: `ExtoreChrome.m`, `ExtoreVivaldi.m`, `ExtoreEdge.m`
- **Plist-based format**: `ExtoreLocalPlist.m`, `ExtoreSafari.m`
- **Firefox (custom format)**: `ExtoreFirefox.m`
- **Custom parser example**: `ExtoreHttp.m` (web services like Pinboard)

Study these implementations for patterns specific to your browser's data format.

## Dynamic Registration System

The system uses dynamic class registration at runtime. No registry file or switch statements are needed:

```objc
// In Extore.m - this code already exists and will auto-discover your new class
+ (Class)extoreClassForExformat:(NSString*)exformat {
    Class extoreClass = nil ;
    if (exformat) {
        NSString* extoreClassName = [@"Extore" stringByAppendingString:exformat] ;
        extoreClass = NSClassFromString(extoreClassName) ;  // Dynamic lookup
    }
    return extoreClass ;
}
```

Once you:
1. Create `ExtoreChatGPTAtlas` class
2. Add the constant `constExformatChatGPTAtlas = @"ChatGPTAtlas"`
3. Add files to Xcode project

The system will automatically discover and use your new Extore subclass. No additional registration code required!

## Build & Test

After implementation:

```bash
# Build the project
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BookMacster -configuration Debug

# Run tests
xcodebuild -workspace BkmkMgrs.xcworkspace -scheme BookMacster test

# Check for compilation errors
# Verify no undefined symbol errors for ExtoreChatGPTAtlas
```

## Notes

- **ExtoreConstants struct**: Defines capabilities (what properties can be edited), file formats, authentication method, UI hints, and compatibility info. See `Extore.h` for the struct definition.
- **Multiple profiles**: If the browser supports multiple profiles, implement profile discovery in `+ (NSSet*)allProfilesThisHome`
- **File access**: Bookmarks may be locked by the running browser. Handle accordingly (wait for browser to quit, use file watching, API-based access, etc.)
- **Import/Export styles**: The base `Extore` class supports two "styles":
  - **Style 1**: Read/write files directly to browser's storage location
  - **Style 2**: Use browser's API/extensions for synchronization
