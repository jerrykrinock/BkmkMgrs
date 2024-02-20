#import <Cocoa/Cocoa.h>

@class BkmxDoc ;

@interface VerifySummary : NSObject {
	// Details
	NSUInteger nUnverified ;
	NSUInteger nUnverifiable ;
	NSUInteger n200 ;
    NSUInteger nSecured ;
	NSUInteger nOtherOk ;
	NSUInteger nDontVerify ;
	NSUInteger n301 ;
	NSUInteger n302Agree ;
	NSUInteger n302Disagree ;
	NSUInteger n302DisagreeOk ;
	NSUInteger n302DisagreeUpdated ;
	NSUInteger n302DisagreeBroken ;
	NSUInteger n302Unsure ;
	NSUInteger n302UnsureOk ;
	NSUInteger n302UnsureUpdated ;
	NSUInteger n302UnsureBroken ;
	NSUInteger n404 ;
	NSUInteger n1001 ;
	NSUInteger n1003 ;
	NSUInteger nOthersBroken ;
	NSUInteger nOthersUpdated ;
	
	// Grand Summary.  Should total to the same, but
	// addressed separately because which subtotal
	// the 302s go NSUIntegero depend on user defaults.
	NSUInteger nTotalUnknown ;
	NSUInteger nTotalOk ;
	NSUInteger nTotalUpdated ;
	NSUInteger nTotalBroken ;
}

@property (readonly) NSUInteger nUnverified ;
@property (readonly) NSUInteger nUnverifiable ;
@property (readonly) NSUInteger n200 ;
@property (readonly) NSUInteger nOtherOk ;
@property (readonly) NSUInteger nSecured ;
@property (readonly) NSUInteger nDontVerify ;
@property (readonly) NSUInteger n301 ;
@property (readonly) NSUInteger n302Agree ;
@property (readonly) NSUInteger n302Disagree ;
// One of the next three will equal n302Disagree.
// The other two will be NSUIntegerMax
@property (readonly) NSUInteger n302DisagreeOk ;
@property (readonly) NSUInteger n302DisagreeUpdated ;
@property (readonly) NSUInteger n302DisagreeBroken ;
@property (readonly) NSUInteger n302Unsure ;
// One of the next three will equal n302Unsure.
// The other two will be NSUIntegerMax
@property (readonly) NSUInteger n302UnsureOk ;
@property (readonly) NSUInteger n302UnsureUpdated ;
@property (readonly) NSUInteger n302UnsureBroken ;
@property (readonly) NSUInteger n404 ;
@property (readonly) NSUInteger n1001 ;
@property (readonly) NSUInteger n1003 ;
@property (readonly) NSUInteger nOthersBroken ;
@property (readonly) NSUInteger nOthersUpdated ;

@property (readonly) NSUInteger nTotalUnknown ;
@property (readonly) NSUInteger nTotalOk ;
@property (readonly) NSUInteger nTotalUpdated ;
@property (readonly) NSUInteger nTotalBroken ;

- (id)initWithBkmxDoc:(BkmxDoc*)bkmxDoc ;

@end

