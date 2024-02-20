#import "OperationSort.h"
#import "Stark+Sorting.h"
#import "Stark+Attributability.h"
#import "BkmxDoc.h"
#import "SSYProgressView.h"
#import "Starker.h"
#import "BkmxBasis.h"

#import "NSString+LocalizeSSY.h"


@implementation SSYOperation (OperationSort)

- (void)sortDescendantsOfStark:(Stark*)stark {
	if ([stark canHaveChildren]) {
	    NSSet* children = [stark children] ;
		
        // First, drill down and call this method recursively to sort your children's children...
        for(Stark* child in children) {
			if ([child canHaveChildren]) {
        		[self sortDescendantsOfStark:child] ;
            }
        }
		
		[stark sortShallowly] ;

    }
}

- (void)sortTreeIfNeeded {
	[self doSafely:_cmd] ;
}

- (void)sortTreeIfNeeded_unsafe {
#if 0
#warning Inserting phony delay in OperationSort
#define PHONY_DELAY_SECONDS 10  // Must be integer
	{
		NSLog(@"Begin phony delay of %ld seconds", (long)PHONY_DELAY_SECONDS) ;
        [[NSSound soundNamed:@"Sosumi"] play];
		sleep(2) ;
		BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
		SSYProgressView* progressView = [bkmxDoc progressView] ;
		// Note: In BkmxAgent, progressView will be nil.
		[progressView clearAll] ;
		
		// Wait, with a progress bar
		[progressView setMaxValue:PHONY_DELAY_SECONDS] ;
		[progressView setDoubleValue:0] ;
		NSString* whatDoing = @"Phony Delay" ;
		[progressView setVerb:whatDoing
					   resize:YES] ;
		[progressView display] ;
		for (NSInteger i=0; i< PHONY_DELAY_SECONDS; i++) {
			[progressView incrementDoubleValueBy:1.0] ;
			sleep(1) ;
		}
		[progressView clearAll] ;
		NSLog(@"End phony delay of %ld seconds", (long)PHONY_DELAY_SECONDS) ;
	}		
#endif
	
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];

	if ([bkmxDoc needsSort]) {
		[[BkmxBasis sharedBasis] logFormat:@"Sorting"] ;
		[[bkmxDoc progressView] setIndeterminate:YES
                             withLocalizableVerb:@"sorting"
                                        priority:SSYProgressPriorityRegular] ;
		// Note: In BkmxAgent, progressView will be nil

		[self sortDescendantsOfStark:[[bkmxDoc starker] root]];
       	[bkmxDoc checkAllProxies:nil];
		[bkmxDoc postSortDone];
		
		[[self info] setObject:[NSNumber numberWithBool:YES]
						forKey:constKeyDidSort] ;
	}
	else {
		[[BkmxBasis sharedBasis] logFormat:@"No unsorting actions since last sort \u279E Skip sorting"] ;
	}
}

// Cannot run in arbitrary thread since NSUndoManager is not thread safe.
- (void)showCompletionSorted {
	[self doSafely:_cmd] ;
}

- (void)showCompletionSorted_unsafe {
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	SSYProgressView* progressView = [bkmxDoc progressView] ;
	if (progressView) {
		// Must be in MainApp
		if ([[[self info] objectForKey:constKeyDidSort] boolValue]) {
			[progressView showCompletionVerb:[NSString localize:@"080_sort"]
                                      result:nil
                                    priority:SSYProgressPriorityRegular] ;
		}
	}
}	


@end
