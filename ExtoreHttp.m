#import "ExtoreHttp.h"
#import "BkmxBasis+Strings.h"
#import "NSError+MyDomain.h"
#import "Stark.h"
#import "Starker.h"
#import "Client+SpecialOptions.h"
#import "NSString+DangerousUrl.h"
#import "NSError+InfoAccess.h"
#import "NSString+BkmxURLHelp.h"
#import "NSString+LocalizeSSY.h"
#import "NSString+SSYExtraUtils.h"
#import "SSYOperationQueue.h"
#import "NSString+TimeIntervals.h"
#import "SSYProgressView.h"
#import "NSDate+Components.h"
#import "NSError+Recovery.h"


@interface ExtoreHttp (Private)

@end

@implementation ExtoreHttp

+ (NSString*)specialNibName {
	// Return the special nib common to Diigo and Pinboard
	return @"SpecialHttp" ;						
}

- (void)getFreshExid_p:(NSString**)exid_p
            higherThan:(NSInteger)higherThan
              forStark:(Stark*)stark
               tryHard:(BOOL)tryHard {
	*exid_p = [[stark url] md5HashAsLowercaseHex] ;
}

- (NSDate*)lastChangeTimeFromServer {
	// Force download by saying that bookmarks were just modified now.
	return [NSDate date] ;
}

- (BOOL)getExternallyDerivedLastKnownTouch:(NSDate**)date_p {
	if (date_p) {
		*date_p = [NSDate date] ;
	}
	
	return YES ;
}

- (BOOL)talkToSubpathQuery:(NSString*)subpathQuery
					client:(Client*)client
				   timeout:(CGFloat)timeout
			 receiveData_p:(NSData**)hdlResponseData 
				   error_p:(NSError**)error_p {
	if (error_p) {
		NSString* msg = [NSString stringWithFormat:
						 @"Internal Error.  %@ must override %s",
						 [self className],
						 __PRETTY_FUNCTION__] ;
		*error_p = SSYMakeError(253908, msg) ;
	}
	return NO ;
}

- (id)tweakedValueFromStark:(Stark*)stark
					 forKey:(NSString*)key {
	id tweakedValue = [stark valueForKey:key] ;
	
	if ([key isEqualToString:constKeyName]) {
		tweakedValue = [(NSString*)tweakedValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ;
		tweakedValue = [(NSString*)tweakedValue stringByCollapsingConsecutiveSpaces] ;
	}
	else if ([key isEqualToString:constKeyComments]) {
		tweakedValue = [(NSString*)tweakedValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ;
		tweakedValue = [(NSString*)tweakedValue stringByCollapsingConsecutiveSpaces] ;
	}
	else if ([key isEqualToString:constKeyUrl]) {
		tweakedValue = [stark url] ;
		// Change feed:// schemes to http://
		if ([(NSString*)tweakedValue hasPrefix:@"feed://"]) {
			tweakedValue = [@"http://" stringByAppendingString:[(NSString*)tweakedValue substringFromIndex:MIN(7, [tweakedValue length]-1)]] ;
		}
	}
	else if ([key isEqualToString:constKeyIsShared]) {
		if ([(NSNumber*)tweakedValue boolValue]) {
			if([[stark url] isDangerous]) {
				tweakedValue = [NSNumber numberWithBool:NO] ;
			}
		}
	}
	
	return tweakedValue ;
}

- (void)syncToServerAndLocalAdditions:(NSMutableSet*)additions
							deletions:(NSMutableSet*)deletions
						   doneTarget:(SSYOperation*)doneTarget {
	SSYProgressView* progressView = [self progressView] ;
	
	NSInteger nTasks = [deletions count] + [additions count] ;
	[progressView setMaxValue:(double)nTasks] ;
	[progressView setHasCancelButtonWithTarget:self
										action:@selector(cancel:)] ;
	[progressView setProgressBarWidth:245.0] ;
	[progressView setDoubleValue:1.0] ;
	[progressView display] ;
	
	NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								 additions, constKeyPendingAdditions,
								 deletions, constKeyPendingDeletions,
								 [NSNumber numberWithInteger:0], constKeyNDone,
								 [NSNumber numberWithInteger:nTasks], constKeyNTasks,
								 [NSNumber numberWithDouble:1.0], constHttpBackoff,
								 doneTarget, constKeySSYOperationQueueDoneTarget,
								 nil] ;
	
	[self scheduleRegularOutputInfo:info] ;
}

@end
