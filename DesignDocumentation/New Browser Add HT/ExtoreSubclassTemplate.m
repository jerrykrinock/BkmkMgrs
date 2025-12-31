// Template for creating a new Extore subclass implementation
// Replace "ChatGPTAtlas" with your browser name throughout
// Copy this entire file and customize the ExtoreConstants struct

#import "ExtoreChatGPTAtlas.h"
#import "BkmxGlobals.h"
#import "StarkTyper.h"

// Define the capabilities and metadata for this browser
// This struct tells BkmkMgrs how to handle bookmarks from ChatGPT Atlas
static const ExtoreConstants extoreConstants = {
	/* canEditAddDate */                  NO,      // Can user edit add date?
	/* canEditComments */                 BkmxCanEditInStyleNeither,  // Comments editing
	/* canEditFavicon */                  NO,      // Favicon support
	/* canEditFaviconUrl */               NO,      // Favicon URL support
	/* canEditIsAutoTab */                NO,      // Auto-tab support
	/* canEditIsExpanded */               NO,      // Folder expansion state
	/* canEditIsShared */                 NO,      // Share/privacy support
	/* canEditLastChengDate */            NO,      // Last change date
	/* canEditLastModifiedDate */         NO,      // Last modified date
	/* canEditLastVisitedDate */          NO,      // Last visited date
	/* canEditName */                     YES,     // Can edit bookmark name
	/* canEditRating */                   NO,      // Rating/stars
	/* canEditRssArticles */              NO,      // RSS support
    /* canEditSeparators */               BkmxCanEditInStyleNeither,  // Separators
	/* canEditShortcut */                 BkmxCanEditInStyleNeither,  // Shortcuts/keywords
	/* canEditTags */                     BkmxCanEditInStyleNeither,  // Tags/labels
	/* canEditUrl */			          YES,     // Can edit bookmark URL
	/* canEditVisitCount */               NO,      // Visit counter
	/* canCreateNewDocuments */           YES,     // Can create new bookmark files
	/* ownerAppDisplayName */             @"ChatGPT Atlas",  // Name for UI
	/* webHostName */                     nil,     // Web service domain (for HTTP exts)
	/* authorizationMethod */             BkmxAuthorizationMethodNone,  // Auth type
	/* accountNameHint */                 nil,     // UI hint for username
	/* oAuthConsumerKey */                nil,     // OAuth key (if needed)
	/* oAuthConsumerSecret */             nil,     // OAuth secret (if needed)
	/* oAuthRequestTokenUrl */            nil,     // OAuth endpoints
	/* oAuthRequestAccessUrl */           nil,
	/* oAuthRealm */                      nil,
	/* appSupportRelativePath */          @"ChatGPT Atlas",  // Path in ~/Library/Application Support/
	/* defaultFilename */                 @"Bookmarks",      // Default file name
	/* defaultProfileName */              @"Default",        // Default profile name
	/* iconResourceFilename */            nil,     // App icon (bundle resource)
	/* iconInternetURL */                 nil,     // App icon URL
	/* fileType */                        @"",     // UTI file type
	/* ownerAppObservability */           OwnerAppObservabilitySpecialFile,  // How to find bookmarks
	/* canPublicize */                    NO,      // Can export as public?
	/* silentlyRemovesDuplicates */       NO,      // Browser removes dupes internally?
	/* normalizesURLs */                  NO,      // Browser normalizes URLs?
	/* catchesChangesDuringSave */        NO,      // Browser detects changes during save?
	/* telltaleString */                  @"checksum",  // String to identify format
	/* hasBar */                          YES,     // Has bookmarks bar/toolbar?
	/* hasMenu */                         YES,     // Has bookmarks menu?
	/* hasUnfiled */                      NO,      // Has "Unfiled" folder?
	/* hasOhared */                       NO,      // Has "Other" folder?
	/* tagDelimiter */                    nil,     // Tag separator (if supported)
	/* dateRef1970Not2001 */              YES,     // Dates relative to 1970 vs 2001?
	/* hasOrder */                        YES,     // Preserves bookmark order?
	/* hasFolders */                      YES,     // Supports folders?
	/* ownerAppIsLocalApp */              YES,     // Local app vs web service?
	/* defaultSpecialOptions */           0x0000000000000000LL,  // Special handling flags
	/* extensionInstallDirectory */       @"Extensions",  // Browser extension directory
	/* minBrowserVersionMajor */          1,       // Minimum browser version
	/* minBrowserVersionMinor */          0,
	/* minBrowserVersionBugFix */         0,
	/* minSystemVersionForBrowsMajor */   12,      // Minimum macOS version (12=Monterey)
	/* minSystemVersionForBrowMinor */    0,
	/* minSystemVersionForBrowBugFix */   0
} ;

@implementation ExtoreChatGPTAtlas

/*
 The following implementation is the same in all subclasses, but we define it
 in each subclass in order to pick up the static variables which are different
 in each Extore subclass' implementation file.
 */
+ (const ExtoreConstants *)constants_p {
	return &extoreConstants ;
}

/*
 Required: Return the macOS bundle identifier(s) for the browser.
 This is used by the system to locate the installed browser application.
 If the browser has multiple variants (beta, canary, etc.), return multiple IDs.
 */
+ (NSArray*)browserBundleIdentifiers {
    return [NSArray arrayWithObject:@"com.chatgpt.atlas"] ;  // MUST match real bundle ID
}

/*
 Required: Return the relative path within ~/Library/Application Support/
 where bookmarks are stored. This combines with fileParentRelativePath
 to form the complete path.

 Example:
   appSupportRelativePath = "ChatGPT Atlas"
   fileParentRelativePath = "Default"
   → ~/Library/Application Support/ChatGPT Atlas/Default/
 */
+ (NSString*)appSupportRelativePath {
    return [self constants_p]->appSupportRelativePath;
}

/*
 Override if bookmarks are in a subfolder within appSupportRelativePath
 Return empty string if bookmarks are directly in appSupportRelativePath
 */
+ (NSString*)fileParentRelativePath {
	return @"";  // Empty, or "Default", "Profile1", etc.
}

/*
 Override if bookmarks are not in Application Support directory
 Common options:
 • PathRelativeToApplicationSupport (default)
 • PathRelativeToProfile (~ directory)
 • PathRelativeToLibraryPreferences (~/Library/Preferences/)
 */
+ (PathRelativeTo)fileParentPathRelativeTo {
    return PathRelativeToApplicationSupport;
}

/*
 Override if the browser supports multiple profiles.
 If YES, must also implement allProfilesThisHome
 */
+ (BOOL)supportsMultipleProfiles {
    return YES;  // Or NO depending on browser
}

/*
 If supportsMultipleProfiles returns YES, implement this to discover
 all available profiles for the browser on this Mac.

 This is called when user adds a new ChatGPT Atlas client to populate
 the profile selector dropdown.
 */
+ (NSSet*)allProfilesThisHome {
    // Example implementation:
    // Read ~/Library/Application Support/ChatGPT Atlas/ directory
    // Return set of profile folder names (e.g., {"Default", "Work", "Personal"})
    // If single profile, return [NSSet setWithObject:@"Default"]

    NSSet* profiles = [NSSet set];
    // TODO: Implement profile discovery
    return profiles;
}

/*
 Optional: If the browser has a proprietary sync mechanism through extensions,
 return YES to enable Style 2 export (extension-based sync)
 */
+ (BOOL)syncExtensionAvailable {
    return YES;  // Or NO if no extension-based sync
}

/*
 Optional: If Style 1 (file-based import/export) is available, return YES
 This requires the bookmark file to be readable/writable on disk
 */
+ (BOOL)style1Available {
    return YES;  // Or NO if bookmarks can't be accessed directly
}

/*
 Optional: Return the display name for this browser's sync service
 Used in UI messages like "Waiting for Sync..."
 */
- (NSString*)ownerAppSyncServiceDisplayName {
    return @"ChatGPT Atlas's syncing" ;
}

@end

//
// NOTES ON ExtoreConstants FIELDS:
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
// The struct above defines:
//
// 1. EDITING CAPABILITIES (canEdit* fields)
//    → Determine what properties user can edit in BkmkMgrs when syncing
//    → Most browsers only support editing name & URL
//    → Values: YES/NO or BkmxCanEditInStyleNeither/StyleOne/StyleTwo/Both
//
// 2. BROWSER CHARACTERISTICS
//    → Has folders? Has menu? Has toolbar?
//    → Whether dates are relative to 1970 or 2001
//    → Tag delimiter (if tags are supported)
//
// 3. AUTHENTICATION
//    → BkmxAuthorizationMethodNone = Local browser
//    → BkmxAuthorizationMethodBasicPassword = Username/password
//    → BkmxAuthorizationMethodOAuth = OAuth flow
//
// 4. FILE LOCATION & FORMAT
//    → appSupportRelativePath: Folder name in ~/Library/Application Support/
//    → fileParentRelativePath: Subfolder for profiles
//    → fileParentPathRelativeTo: Which base directory to use
//    → telltaleString: Magic string to identify file format
//
// 5. EXTENSION/SYNC SUPPORT
//    → extensionInstallDirectory: Folder for browser extensions
//    → Special options for handling specific browser quirks (bitmask)
//
// 6. VERSION REQUIREMENTS
//    → minBrowserVersionMajor/Minor/BugFix: Minimum browser version
//    → minSystemVersionForBrows*: Minimum macOS version (12=Monterey, 13=Ventura, etc.)
//
// For most simple cases (like inheriting from ExtoreChromy):
// • Copy ExtoreOrion.m above as template
// • Change name, bundle ID, and path constants
// • Done!
//
