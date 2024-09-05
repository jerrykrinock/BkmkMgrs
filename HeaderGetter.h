#import <Cocoa/Cocoa.h>
#import "BkmxGlobals.h"

@class CURLHandle ;
@class Stark ;

@interface HeaderGetter : NSObject <NSURLSessionDelegate> {	
	// Non-object instance variables
	NSInteger _index ;
	NSInteger _errorIn1stResponse ;
	SEL _targetMethod ;
	BOOL _feedFake ;
	CGFloat _timeout ;
	
	BOOL _cancelled ;
}

- (Stark*)bookmark ;

// Initializer
/*	bookmark_ must contain a NSString* value for a key @"url".
 This value should be the absolute path to the desired site such as "http://www.apple.com"
 receiveTarget_ is the object which will get a message when the header is available.
 (Typically, this is "sender").
 receiveSelector is this message that will be sent when the header is available.
 Its signature should be:
 - (void)gotHeaders:(NSMutableDictionary*)headers ;
 headers will not be nil
 */
- (id)initWithBookmark:(id)bookmark
				 index:(NSInteger)i
		  sendResultTo:(id)receiveTarget
		  usingMessage:(SEL)receiveSelector
			   timeout:(CGFloat)timeout
			 userAgent:(NSString*)userAgent	;


- (void)abortSession ; // safe cancel; cancels only if not already cancelled

@end

