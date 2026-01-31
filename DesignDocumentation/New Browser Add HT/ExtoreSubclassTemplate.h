// Template for creating a new Extore subclass
// Replace "ChatGPTAtlas" with your browser name throughout
// Replace "ExtoreChromy" with appropriate base class:
//   - ExtoreChromy: For Chromium-based browsers (JSON Bookmarks file)
//   - ExtoreFirey: For Mozilla/Firefox-based browsers (places.sqlite)
//   - ExtoreLocalPlist: For plist-based formats
//   - Extore: For custom/proprietary formats

#import "ExtoreChromy.h"  // Change based on format type

@interface ExtoreChatGPTAtlas : ExtoreChromy {
    // Add instance variables if needed
    // Most simple subclasses don't need any
}

// Required method declaration
+ (NSString*)appSupportRelativePath;

// Optional: Add any other custom method declarations needed
// - (NSSet*)allProfilesThisHome;
// - (BOOL)supportsMultipleProfiles;
// etc.

@end
