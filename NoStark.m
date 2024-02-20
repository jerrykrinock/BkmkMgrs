#import "NoStark.h"
#import "SSYProgressView.h"
#import "BkmxGlobals.h"

@implementation NoStark

- (NSDictionary*)lineageStatus {
	NSDictionary* answer = [NSDictionary dictionaryWithObjectsAndKeys:
		  @"", constKeyPlainText,
		  //[NSString localize:@"move"], constKeyHyperText,
		  //[(BkmxAppDel*)[NSApp delegate] inspectorController], constKeyTarget,
		  //[NSValue valueWithPointer:@selector(popMoveMenuOntoLineageField:)], constKeyActionValue,
		  nil] ;
	return answer ;
}

/*!
 @brief    Note 2134990.

 @details  This implementatation is probably needed
 because we use manual bindings on SSYStarRatingsView,
 and it needs a little help.
 Another fix for this problem is in 
 -[InspectorController startObservers:]
 However, although that will stop the exception
 from being raised, we'll still get a
 -setValue:forUndefinedKey: here, which we'd have
 to filter out in there.
 
 Since Cocoa bindings are so poorly defined, I
 decided to do both fixes, for defensive programming.
*/
- (void)setRating:(NSNumber*)rating {
	// Just swallow it silently.
}

/*!
 @details  This implementatation is probably needed
 because we use manual bindings on SSYStarRatingsView,
 and it needs a little help.
 
 Without it, if we close all document windows so that 
 there is no selected stark, the star rating view
 continues to show the rating of the last stark that
 was selected.
 */
- (NSNumber*)rating {
	return [NSNumber numberWithDouble:0.0] ;
}

- (id)valueForUndefinedKey:(NSString*)key {
	return nil ;
	// We rely on the fact that the above also gives the
	// intended result of NO for pseudo-attributes such
	// as -canHaveUrl, -canEditName, and possibly others
	// which are bound to in Inspector.xib
}

/*!
 @details  This implementation is for defensive programming.  It should
 not be needed unless I fail to disable a field in the Inspector when
 the selectedStark is a NoStark, in which case an exception would
 be raised by the default implementation if user enters data into it.
*/
- (void)setValue:(id)value
 forUndefinedKey:(NSString*)key {
	// Note 2134990
	if ([key isEqualToString:constKeyRating]) {
		return ;
	}
	
	NSLog(@"Internal Error 524-9124 %@ %@", value, key) ;
}

- (BOOL)isAStark {
	return NO ;
}

+ (NoStark*)noStark {
	return [[[NoStark alloc] init] autorelease] ;
}



@end