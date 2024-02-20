#import <Cocoa/Cocoa.h>
#import "GulperDelegate.h"

@class BkmxDoc ;

@interface GulperImportDelegate : NSObject <GulperDelegate> {
	BkmxDoc* m_bkmxDoc ;
}

- (id)initWithBkmxDoc:(BkmxDoc*)bkmxDoc ;

@end
