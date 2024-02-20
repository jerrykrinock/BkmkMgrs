#import "OperationDupe.h"
#import "NSError+MyDomain.h"
#import "BkmxDoc.h"
#import "Bookshig.h"
#import "Dupetainer.h"
#import "BkmxBasis+Strings.h"
#import "Stark+Sorting.h"
#import "SSYProgressView.h"
#import "NSString+LocalizeSSY.h"
#import "NSError+InfoAccess.h"
#import "NSString+SSYExtraUtils.h"
#import "NSString+VarArgs.h"
#import "Starker.h"
#import "Dupe.h"
#import "NSString+BkmxURLHelp.h"
#import "NSString+MoreComparisons.h"
#import "NSObject+MoreDescriptions.h"

// Prior to BookMacster version 1.3.19, when the local autorelease
// pool was added for each loop iteration in the following loop,
// the following two limits were 16x lower, 0x800=256.  They were
// needed to keep memory usage from going into the gigabytes.
// Now, they're probably not needed.
#define MAX_DUPES_GROUPS       0x00008000 // 32768
#define MAX_BOOKMARKS_IN_GROUP 0x00008000 // 32768


@implementation SSYOperation (OperationDupe)

- (void)findDupes {
    dispatch_queue_t mainQueue = dispatch_get_main_queue() ;
    NSError* __block error = nil ;
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
    BOOL __block needDo ;
    [[BkmxBasis sharedBasis] logFormat:@"Begin Find Duplicates"] ;
    dispatch_sync(mainQueue, ^{
        needDo = [[bkmxDoc shig] dupesMaybeMore] ;
    }) ;
	if (needDo) {
		Stark* root = [[self info] objectForKey:constKeyRootStark] ;
		BOOL exceptAllowed = [[[self info] objectForKey:constKeyExceptAllowed] boolValue] ;
		BOOL ignoreDisparateDupes = [[[self info] objectForKey:constKeyDoIgnoreDisparateDupes] boolValue] ;
		
        NSArray* __block bookmarks ;
        dispatch_sync(mainQueue, ^{
            bookmarks = [root extractLeavesOnly] ;
            [bookmarks retain] ;
        }) ;
		NSMutableDictionary* dupeDic = [NSMutableDictionary dictionary] ;
		[[self info] setObject:dupeDic
						forKey:constKeyDupeDic] ;
		
		NSInteger nBookmarks = [bookmarks count] ;
        SSYProgressView* progressView = [[bkmxDoc progressView] setIndeterminate:NO
                                                               withLocalizedVerb:[NSString localizeFormat:
                                                                                  @"findingX",
                                                                                  [NSString localize:@"080_dupes"]]
                                                                        priority:SSYProgressPriorityRegular] ;
		// Note: In BkmxAgent, progressView will be nil.
        [progressView setDoubleValue:0.0] ;
		[progressView setMaxValue:nBookmarks] ;
		
		NSInteger __block nDone = 0 ;
        NSInteger __block i = nBookmarks-1 ;
		
		// I did run this loop backwards because each the duration of each iteration is proportional to
		// i, due to j<i in the inner loop.  Therefore, the maximum values of i will take the longest.
		// By running the loop backwards, the progress bar speed accelerates instead of decelerates,
		// which gives the user the illusion that the program is running faster.
		// Since I fixed that now, it doesn't matter, but, oh, well.
        while (i>=0) {
            dispatch_sync(mainQueue, ^{
                // Update progress and make sure count is not getting ridiculous
                    [progressView setDoubleValue:(nBookmarks - i)] ;
                    if ([dupeDic count] > MAX_DUPES_GROUPS) {
                        NSString* msg = [NSString stringWithFormat:@"You have over %ld groups of identical bookmarks.\n\nIt will be more efficient to stop and clean those up, then re-run to find more.", (long)MAX_DUPES_GROUPS] ;
                        error = SSYMakeError(57425, msg) ;
                        i = -1 ; // will abort outer loop
                    }
            }) ;
            
            dispatch_sync(mainQueue, ^{
                NSTimeInterval startTime = [[NSDate date] timeIntervalSinceReferenceDate] ;
                while (i>=0) {
                    NSInteger j ;
                    for (j=0; j<i; j++) {  // Note that i=j must obviously be excluded since any bookmark equals itself.
                        // Also we don't want j<i since this will just duplicate each duplicate pair in reverse order.
                        
                        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
                        
                        Stark* bookmark1 = [bookmarks objectAtIndex:i] ;
                        Stark* bookmark2 = [bookmarks objectAtIndex:j] ;
                        BOOL marksSameSite ;
                        marksSameSite = [bookmark1 marksSameSiteAs:bookmark2] ;
                        
                        NSString* url1 = [bookmark1 url] ;
                        NSString* url2 = [bookmark2 url] ;
                        if (
                            marksSameSite ||  // equal or just http vs https difference
                            (!url1 && !url2)  // both of them are nil
                            )  {
                            // This block only executes when duplicate or similar urls are found, which should be rare,
                            // so for best efficiency we compute variables depending only on i in here.
                            bool ignoreThisOne = false ;
                            
                            // We've got a potential dupe pair.
                            // Now we check several things to see if this dupe pair should be ignored
                            
                            // Check if either bookmark in this pair is an allowed dupe
                            if (exceptAllowed) {
                                if
                                    (
                                     ([[bookmark1 isAllowedDupe] boolValue] != 0)
                                     ||
                                     ([[bookmark2 isAllowedDupe] boolValue] != 0)
                                     ) {
                                        ignoreThisOne = true ;
                                    }
                            }
                            
                            // Check if these are in different collections and such dupes are allowed
                            if (ignoreDisparateDupes) {
                                // The collection "Bookmarks Menu", "Bookmarks Bar", etc. should be the second-last object in the path NSArray
                                // because the last object is, for example,  "Jerry's Safari Bookmarks"
                                // Yes, if the item is a _bookmark_, its path array must contain at least 3 items:
                                //     {"its collection", "User's Bookmarks", bookmarksTreeSuperRoot}
                                Stark* collection1 = [(Stark*)bookmark1 collection] ;
                                Stark* collection2 = [(Stark*)bookmark2 collection] ;
                                // Prior to BookMacster version 1.3.12, following was just (collection1 != collection2)
                                if (collection1 && collection2 && (collection1 != collection2)) {
                                    ignoreThisOne = true ;
                                }
                            }
                            
                            if (!ignoreThisOne) {
                                NSMutableSet* set = nil ;
                                
                                NSString* pUrl ;
                                if ([url1 hasPrefix:@"http://"]) {
                                    pUrl = url1 ;
                                }
                                else if ([url2 hasPrefix:@"http://"]) {
                                    pUrl = url2 ;
                                }
                                else {
                                    pUrl = [url1 http_from_https] ;
                                }
                                
                                NSString* sUrl ;
                                if ([url1 hasPrefix:@"https://"]) {
                                    sUrl = url1 ;
                                }
                                else if ([url2 hasPrefix:@"https://"]) {
                                    sUrl = url2 ;
                                }
                                else {
                                    sUrl = [url1 https_from_http] ;
                                }
                                
                                // Find the best url
                                NSString* url ;
                                if (sUrl) {
                                    url = sUrl ;
                                }
                                else if (pUrl) {
                                    url = pUrl ;
                                }
                                else {
                                    url = [bookmark1 url] ;
                                    if (!url) {
                                        NSLog(@"Internal Error 524-4849 %@", [bookmark1 shortDescription]) ;
                                        url = [bookmark2 url] ;
                                    }
                                    if (!url) {
                                        NSLog(@"Internal Error 524-5202 %@", [bookmark2 shortDescription]) ;
                                    }
                                }
                                
                                NSMutableSet* pSet = [dupeDic objectForKey:pUrl] ;
                                NSMutableSet* sSet = [dupeDic objectForKey:sUrl] ;
                                
                                if (sSet) {
                                    set = sSet ;
                                }
                                else if (pSet) {
                                    set = pSet ;
                                }
                                
                                if (sSet && pSet) {
                                    NSLog(@"Internal Error 624-9295\n%@ = %@\n%@ = %@", pUrl, pSet, sUrl, sSet) ;
                                }
                                
                                // Test added in BookMacster 0.9.31 to check for nil url, which I
                                // suppose could happen if importing corrupt bookmarks from somewhere.
                                if ([url length] > 0) {
                                    if (!set) {
                                        set = [[NSMutableSet alloc] init] ;
                                        [dupeDic setObject:set
                                                    forKey:url] ;
                                        [set release] ;
                                    }
                                    
                                    if ([set count] > MAX_BOOKMARKS_IN_GROUP) {
                                        NSString* msg = [NSString stringWithFormat:
                                                         @"Aborted after finding %ld bookmarks with URL\"%@\".  It will be more efficient to stop and clean those up, then re-run to find more.",
                                                         (long)MAX_BOOKMARKS_IN_GROUP,
                                                         url] ;
                                        error = SSYMakeError(28571, msg) ;
                                        i = -1 ; // will abort outer loop
                                        break ; // abort inner loop
                                    }
                                    
                                    [set addObject:bookmark1] ;
                                    [set addObject:bookmark2] ;
                                    
                                    if (pSet && [url hasPrefix:@"https:"]) {
                                        if (pUrl) {
                                            [dupeDic removeObjectForKey:pUrl] ;
                                        }
                                        [dupeDic setObject:set
                                                    forKey:url] ;
                                    }
                                }
                            }
                        }
                        
                        [pool release] ;
                        nDone++ ;
                    }
                    
                    i-- ;
                    NSTimeInterval nowTime = [[NSDate date] timeIntervalSinceReferenceDate] ;
                    if (nowTime - startTime > 0.2) {
                        break ;
                    }
                }
            }) ;
        }
        
        dispatch_sync(mainQueue, ^{
            [[bkmxDoc dupetainer] setDupesWithDictionary:dupeDic] ;
        }) ;
        NSString* msg = [NSString stringWithFormat:@"Found %ld duplicate groups", (long)[dupeDic count]] ;
        [[BkmxBasis sharedBasis] logFormat:msg] ;
        
		[progressView clearAll] ;
        [bookmarks release] ;
	}
    else {
        [[BkmxBasis sharedBasis] logFormat:@"Dupe finding not needed"] ;        
    }
    
    if (error) {
		error = [error errorByAddingLocalizedRecoverySuggestion:@"In menu click 'Bookmarks' > 'Delete All Duplicates'.  To avoid losing work, Save.  Then Find Duplicates again.  Repeat as necessary."] ;
		[self setError:error] ;
	}
}

// Cannot run in arbitrary thread since NSUndoManager is not thread safe.
// I *did* run this in a secondary thread (that is, the code which is now
// in finishFindDupes_unsafe was in this method) until BookMacster 1.12.
// That caused a very nasty bug which took me a week, working on and off, to
// track down.  The bug was that, after a Find Duplicates operation, and
// after closing the Bksmlf window, the BkmxDoc was left with a retainCount
// of 1 and never dealloced.  Implementing finishFindDupes_unsafe fixed
// the problem.  The clue was that if I commented out [self beginUndoGrouping]
// inside of -[SSYDooDooUndoManager beginAutoEndingUndoGrouping], or if I
// disabled -[GCUndoManager submitUndoTask:], the BkmxDoc deallocced OK.
// It also may have caused a bug which caused bookmarks deleted by
// "Delete All Duplicates" to reappear after closing and reopening the BkmxDoc.
- (void)finishFindDupes {
	[self doSafely:_cmd] ;
}

- (void)finishFindDupes_unsafe {
	// Because we are running in an SSYOperation, we know that
	// has been no error so far
	
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	// Note: If we were finding dupes in an extore, bkmxDoc will be nil.

	[bkmxDoc postDupesDone] ;
}

// Cannot run in arbitrary thread since NSUndoManager is not thread safe.
- (void)showCompletionFindDupes {
	[self doSafely:_cmd] ;
}

- (void)showCompletionFindDupes_unsafe {
	SSYProgressView* progressView = [[[self info] objectForKey:constKeyDocument] progressView] ;
	if (progressView) {
		// Must be in MainApp
		NSInteger count = [[[self info] objectForKey:constKeyDupeDic] count] ;
		[progressView showCompletionVerb:[NSString localize:@"080_dupesFind"]
                                  result:[NSString stringWithInt:count]
                                priority:SSYProgressPriorityRegular] ;
	}
}	

- (void)forgetDupes {
	[self doSafely:_cmd] ;
}

- (void)forgetDupes_unsafe {
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
    NSManagedObjectContext* moc = [bkmxDoc managedObjectContext] ;
    
	for (Dupe* dupe in [[bkmxDoc dupetainer] dupes]) {
		[moc deleteObject:dupe] ;
    }
    
    [bkmxDoc postDupesMaybeMore] ;
}

- (void)deleteDupes {
	[self doSafely:_cmd] ;
}

- (void)deleteDupes_unsafe {
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	NSMutableDictionary* dupeDic = [[bkmxDoc dupetainer] allDupeDic] ;

	SSYProgressView* progressView = [bkmxDoc progressView] ;
	// Note: In BkmxAgent, progressView will be nil.
	
	[progressView setVerb:[[NSString localizeFormat:
						   @"analyzingX",
						   [NSString localize:@"080_dupes"]] ellipsize] resize:YES] ;
	[progressView setDoubleValue:0.0] ;
	[progressView setMaxValue:[dupeDic count]] ;
	
	NSMutableSet* condemnedBookmarks = [NSMutableSet set] ;
	NSUInteger nDeleted = 0 ;
	
	for (NSString* url in dupeDic) {
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
		[progressView incrementDoubleValueBy:1.0] ;
		
		NSArray* starksFixed = [dupeDic objectForKey:url] ;
		NSMutableArray* starks = [starksFixed mutableCopy] ;
		if ([starksFixed count] < 12) {
			// We limit the above for performance reasons
			[starks sortUsingSelector:@selector(overallQualityCompare:)] ;
		}
		// Starks are now in ascending order of quality, so we take the last one
		Stark* survivor = [starks objectAtIndex:([starks count] - 1)] ;
		NSArray* currentCondemnees = [starks subarrayWithRange:NSMakeRange(0, ([starks count] - 1))] ;
		
		[condemnedBookmarks addObjectsFromArray:currentCondemnees] ;

		// Form a combined set of tags and set in survivor.
		// Also, set verifierDisposition of each condemnee.
		NSMutableArray* tags = [[survivor tags] mutableCopy] ;
		for (Stark* condemnee in currentCondemnees) {			
			[tags addObjectsFromArray:[condemnee tags]] ;
			
			[condemnee setVerifierDisposition:[NSNumber numberWithInteger:kDeleteIt]] ;
			// The above is also going to be done by -delete, but we
			// need to pre-do it here so that pairs containing this bookmark will no longer
			// cause an iteration of this loop, since that would make an infinite loop.			
		}
		
		NSArray* combinedTags = [tags copy] ;
		[tags release] ;
		[survivor setTags:combinedTags] ;
		[combinedTags release] ;
		
		[starks release] ;
		
		nDeleted += [currentCondemnees count] ;
		[pool release] ;
	}
	
	// Do the actual deleting.
	[progressView setVerb:[[NSString localizeFormat:
							@"deleting%0",
							[NSString localize:@"000_Safari_Bookmarks"]] ellipsize] resize:YES] ;
	[progressView setDoubleValue:0.0] ;
	[progressView setMaxValue:[condemnedBookmarks count]] ;
	for (Stark* stark in condemnedBookmarks) {
		// Local autorelease pool added in BookMacster 1.3.19 because memory was
		// growing too much when deleting 50,000 bookmarks
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
		[progressView incrementDoubleValueBy:1.0] ;
		[stark moveToBkmxParent:nil
						atIndex:0
						restack:NO] ;
		[pool release] ;
	}
    
	// Fetch
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
	NSArray* allStarks = [[bkmxDoc starker] allStarks] ;
	[allStarks retain] ;
	[pool release] ;

	// Restacking
	// Added in BookMacster version 1.3.19
	[progressView setVerb:[NSString localizeFormat:
						   @"restacking%0",
						   [[BkmxBasis sharedBasis] labelChildren]]
				   resize:YES] ;
	[progressView setDoubleValue:0.0] ;
	[progressView setMaxValue:[dupeDic count]] ;
	for (Stark* stark in allStarks) {
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
		[progressView incrementDoubleValueBy:1.0] ;
		[stark restackChildrenStealthily:NO] ;
		[pool release] ;
	}

	[allStarks release] ;

    [progressView clearAll] ;
		
	[[self info] setObject:[NSNumber numberWithInteger:nDeleted]
					forKey:constKeyCountOfDeletedStarks] ;
}

- (void)showCompletionDeleteDupes {
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	SSYProgressView* progressView = [bkmxDoc progressView] ;
	if (progressView) {
		// Must be in MainApp
		[progressView showCompletionVerb:[[BkmxBasis sharedBasis] labelDeleteAllDupes]
                                  result:[NSString stringWithInt:[[[self info] objectForKey:constKeyCountOfDeletedStarks] integerValue]]
                                priority:SSYProgressPriorityRegular] ;
	}
}	


@end
