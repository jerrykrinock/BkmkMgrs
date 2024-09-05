#import "VerifySummary.h"
#import "BkmxDoc.h"
#import "Starker.h"
#import "Stark.h"

@interface Stark (VerifySummarizer)

- (void)summarizeIntoSummary:(VerifySummary*)stats ;

@end

@interface VerifySummary () 

@property NSUInteger nUnverified ;
@property NSUInteger nUnverifiable ;
@property NSUInteger n200 ;
@property NSUInteger nOtherOk ;
@property NSUInteger nDontVerify ;
@property NSUInteger n301 ;
@property NSUInteger n302Agree ;
@property NSUInteger n302Disagree ;
@property NSUInteger n302DisagreeOk ;
@property NSUInteger n302DisagreeUpdated ;
@property NSUInteger n302DisagreeBroken ;
@property NSUInteger n302Unsure ;
@property NSUInteger n302UnsureOk ;
@property NSUInteger n302UnsureUpdated ;
@property NSUInteger n302UnsureBroken ;
@property NSUInteger n404 ;
@property NSUInteger n1001 ;
@property NSUInteger n1003 ;
@property NSUInteger nOthersBroken ;
@property NSUInteger nOthersUpdated ;
@property NSUInteger nSecurified ;

@property NSUInteger nTotalUnknown ;
@property NSUInteger nTotalOk ;
@property NSUInteger nTotalUpdated ;
@property NSUInteger nSecured ;
@property NSUInteger nTotalBroken ;

@end

@implementation Stark (VerifySummarizer)

- (void)summarizeIntoSummary:(VerifySummary*)stats {
    NSNumber* verifierCode = [self verifierCode] ;
    Sharype sharype = [self sharypeValue] ;
	BkmxFixDispo fixDisposition ;
    
	if (sharype == SharypeBookmark) {
		if ([[self dontVerify] boolValue]) {
			stats.nDontVerify++ ;
		}
		else if (verifierCode) {
			NSInteger code = [verifierCode integerValue] ;
	    	
			if (code == 200) {
                stats.n200++ ;
			}
			else if (code==301) {
				stats.n301++ ;
			}
			else if (code==302) {
				NSNumber* ost = [self verifierSubtype302] ;
				
				BkmxHttp302 st;
				if (ost) {
					st = (BkmxHttp302)[[self verifierSubtype302] integerValue] ;
				}
				else {
					// should not happen
					st = BkmxHttp302Agree ;
				} 				
				switch (st) {
					case BkmxHttp302Agree:
						stats.n302Agree++;
						break ;
					case BkmxHttp302Disagree:
						stats.n302Disagree++;
						break ;
					case BkmxHttp302Unsure:
						stats.n302Unsure++;
						break ;
					default: // should not happen
						stats.n302Agree++;
				}
			}
			else if (code==404) {
				stats.n404++ ;
			}
			else if (code==-1001) {
				stats.n1001++ ;
			}
			// I've never seen any between -1001 and 0
			else if (code==-1003) {
				stats.n1003++ ;
			}
			else if (code==0) {
				// for ftp://
				stats.nUnverifiable++ ;
			}
			else if (code==-1002) {
				// for javascript bookmarklets
				stats.nUnverifiable++ ;
			}
			else if (code==-1012) {
				// "Needs Login"
				stats.nOtherOk++ ;
			}
			else {
				fixDisposition = [self verifierDispositionValue] ;
				if (fixDisposition == BkmxFixDispoDoUpdate) {
					stats.nOthersUpdated++ ;
				}
				else if (fixDisposition == BkmxFixDispoLeaveAsIs) {
					stats.nUnverifiable++ ; // some javascript bookmarklets will end up here
                } else {
                    /* for fixDisposition cases:
                     BkmxFixDispoNotApplicable
                     BkmxFixDispoToBeDetermined
                     BkmxFixDispoLeaveBroken */
                    stats.nOthersBroken++ ;
                }
            }
		}
		else {
			// This will happen if this website has not replied yet, or if user has removed code by Manual Fixing with "Next"
			stats.nUnverified++ ;
		}
	}
    else if ([StarkTyper canHaveChildrenSharype:sharype]) {
        // Call this method recursively to add stats from this object's children's...children
        for (Stark* child in [self children]) {
            [child summarizeIntoSummary:stats] ;
        }
    }
}

@end

@implementation VerifySummary

@synthesize nUnverified ;
@synthesize nUnverifiable ;
@synthesize n200 ;
@synthesize nSecured ;
@synthesize nOtherOk ;
@synthesize nDontVerify ;
@synthesize n301 ;
@synthesize n302Agree ;
@synthesize n302Disagree ;
@synthesize n302DisagreeOk ;
@synthesize n302DisagreeUpdated ;
@synthesize n302DisagreeBroken ;
@synthesize n302Unsure ;
@synthesize n302UnsureOk ;
@synthesize n302UnsureUpdated ;
@synthesize n302UnsureBroken ;
@synthesize n404 ;
@synthesize n1001 ;
@synthesize n1003 ;
@synthesize nOthersBroken ;
@synthesize nOthersUpdated ;

@synthesize nTotalUnknown ;
@synthesize nTotalOk ;
@synthesize nTotalUpdated ;
@synthesize nTotalBroken ;

- (id)initWithBkmxDoc:(BkmxDoc*)bkmxDoc {
	self = [super init] ;
	if (self) {	
		NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults] ;
		
		Stark* tree ;
        if ((tree = [[bkmxDoc starker] root])) {
			[tree summarizeIntoSummary:self] ;
        }
		
		// Compute the totals, not including the 302Disagrees and 302Unsures yet
		self.nTotalUnknown = self.nDontVerify + self.nUnverified + self.nUnverifiable ; 		
		self.nTotalOk = self.n200 + self.n302Agree + self.nOtherOk ;
		self.nTotalUpdated = self.n301 + self.nOthersUpdated + self.nSecured ;
		self.nTotalBroken = self.n404 + self.n1001 + self.n1003 + self.nOthersBroken ; 		
		
		
		// Now add in the 302Perms to the grand summary,
		// and also set one of the three n302Disagree columns,
		// leaving the other two at NSUIntegerMax placeholder.
		// (Binding in xib uses SSYTransformMaxUIntegerToEmptyString
		// to make avoid displaying this number.)
		// Which grand total gets this contribution, and which
		// column gets the non-placeholer depends on a user default.
		self.n302DisagreeOk = NSUIntegerMax ;
		self.n302DisagreeUpdated = NSUIntegerMax ;
		self.n302DisagreeBroken = NSUIntegerMax ;
		BkmxFixDispo dispo302Perm = (BkmxFixDispo)[[userDefaults objectForKey:constKeyDispose302Perm] integerValue] ; 	
		switch(dispo302Perm) {
			case BkmxFixDispoLeaveAsIs:
				self.nTotalOk += self.n302Disagree ;
				self.n302DisagreeOk = self.n302Disagree ;
				break ;
			case BkmxFixDispoDoUpdate:
				self.nTotalUpdated += self.n302Disagree ;
				self.n302DisagreeUpdated = self.n302Disagree ;
				break ;
			case BkmxFixDispoLeaveBroken:
				self.nTotalBroken += self.n302Disagree ;
				self.n302DisagreeBroken = self.n302Disagree ;
				break ;
			case BkmxFixDispoNotApplicable:
			case BkmxFixDispoToBeDetermined:
            case BkmxFixDispoDoUpgradeInsecure:
				break ;
		}
		
		// Now add in the 302Unsures to the grand summary.
		// and also set one of the three n302Unsure columns,
		// leaving the other two at NSUIntegerMax placeholder.
		// (Binding in xib uses SSYTransformMaxUIntegerToEmptyString
		// to make avoid displaying this number.)
		// Which grand total gets this contribution, and which
		// column gets the non-placeholer depends on a user default.
		self.n302UnsureOk = NSUIntegerMax ;
		self.n302UnsureUpdated = NSUIntegerMax ;
		self.n302UnsureBroken = NSUIntegerMax ;
		BkmxFixDispo dispo302Unsure = (BkmxFixDispo)[[userDefaults objectForKey:constKeyDispose302Unsure] integerValue] ; 	
		switch(dispo302Unsure)
		{
			case BkmxFixDispoLeaveAsIs:
				self.nTotalOk += self.n302Unsure ;
				self.n302UnsureOk = self.n302Unsure ;
				break ;
			case BkmxFixDispoDoUpdate:
				self.nTotalUpdated += self.n302Unsure ;
				self.n302UnsureUpdated = self.n302Unsure ;
				break ;
			case BkmxFixDispoLeaveBroken:
				self.nTotalBroken += self.n302Unsure ;
				self.n302UnsureBroken = self.n302Unsure ;
				break ;
			case BkmxFixDispoNotApplicable:
			case BkmxFixDispoToBeDetermined:
            case BkmxFixDispoDoUpgradeInsecure:
				break ;
		}
	}
	
	return self ;
}

- (NSString*)description {
	return [NSString stringWithFormat:
			@"<VerifySummary %p> unknown:%lu ok:%lu changed:%lu broken:%lu",
			self,
			(unsigned long)(self.nTotalUnknown),
			(unsigned long)(self.nTotalOk),
			(unsigned long)(self.nTotalUpdated),
			(unsigned long)(self.nTotalBroken)] ;
}

@end
