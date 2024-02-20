#import <Cocoa/Cocoa.h>
#import "BkmxGlobals.h"

@class BkmxDoc ;

@protocol GulperDelegate

@property (assign) BkmxDoc* bkmxDoc ;

- (BOOL)isAnImporter ;
- (BOOL)isAnExporter ;
- (NSNumber*)fabricateFolders ;
- (BOOL)shouldDeleteUnmatchedItemsWithInfo:(NSDictionary*)info ;
- (NSString*)displayName ;

// Should only be used -isAnExporter, which should be never
- (void)objectWillChangeNote:(NSNotification*)note ;

@end
