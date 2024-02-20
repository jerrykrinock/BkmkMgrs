#import "Extore.h"

// Dictionary keys used in BkmxFileProperties dictionaries only in this subclass
// There are more, common keys in Extore.h.
#define KEY_FILE_HEADER_LAST_MODIFIED_DATE @"fileHeaderLastModifiedDate" //  NSDate*

@class Stark ;

@interface ExtoreOmniWeb : Extore {
	// Retained
	NSMutableDictionary* filePropertiesBar ;
	NSMutableDictionary* filePropertiesMenu ;
	NSMutableDictionary* filePropertiesOhared ;
	NSNumber* omniWebHistoryVersion ;
	
	// Non-objects
	NSUInteger nextOmniWebBarID ;
	NSUInteger nextOmniWebMenuID ;
	NSUInteger nextOmniWebOharedID ;
	NSInteger omniWebHistoryFormat ;
}

@end
