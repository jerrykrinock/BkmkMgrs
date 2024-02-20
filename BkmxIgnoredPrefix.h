#import <Cocoa/Cocoa.h>


@interface BkmxIgnoredPrefix : NSObject {
	NSString* phrase ;
	NSNumber* hasTrailingSpace ;
}

@property (copy) NSString* phrase ; 
@property (retain) NSNumber* hasTrailingSpace ;
@property (assign) NSString* string ;

@end


