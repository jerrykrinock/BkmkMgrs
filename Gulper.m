#import "Gulper.h"
#import "BkmxBasis.h"
#import "Extore.h"
#import "SSYProgressView.h"
#import "Stark+Attributability.h"
#import "BkmxDoc.h"
#import "Ixporter.h" // for constants
#import "NSObject+MoreDescriptions.h"
#import "Chaker.h"
#import "NSError+InfoAccess.h"
#import "Starker.h"
#import "NSError+MyDomain.h"
#import "Client.h"
#import "NSNumber+Sharype.h"

@interface Gulper ()

@property (assign) 	NSObject <GulperDelegate> * delegate ;

@end


@implementation Gulper

@synthesize delegate = m_delegate ;

- (id)initWithDelegate:(NSObject <GulperDelegate> *)delegate {
	self = [super init] ;
	if (self) {
		[self setDelegate:delegate] ;
	}
	
	return self ;
}

+ (NSArray*)sortDescriptorsForGulping {
	// Create sort descriptors to sort first by sponsor, then sponsoredIndex
	NSArray *sortDescriptors ;
	NSSortDescriptor* sdSponsorIndex = [[NSSortDescriptor alloc] initWithKey:constKeySponsorIndex
																   ascending:YES] ;
	NSSortDescriptor* sdSponsoredIndex = [[NSSortDescriptor alloc] initWithKey:constKeySponsoredIndex
																	 ascending:YES] ;
    /* We add a final sort descriptor, for corner cases when items from
     different source folders are merged, sortSponsorIndex and
     sortSponsoredIndex will be the same.  The following sort will then
     arbitrarily order these items, preventing nondeterministic sorting, which
     could cause churn. */
	NSSortDescriptor* sdIxportingIndex = [[NSSortDescriptor alloc] initWithKey:constKeyIxportingIndex
																	 ascending:YES] ;
    sortDescriptors = [NSArray arrayWithObjects:sdSponsorIndex, sdSponsoredIndex, sdIxportingIndex, nil] ;

	[sdSponsorIndex release] ;
	[sdSponsoredIndex release] ;
	[sdIxportingIndex release] ;
    
	return sortDescriptors ;
}

+ (NSArray*)sortDescriptorsForMergingHartainers {
	NSArray *sortDescriptors ;
	NSSortDescriptor* sdSponsorIndex = [[NSSortDescriptor alloc] initWithKey:constKeySponsorIndex
																   ascending:YES] ;
	NSSortDescriptor* sdCurrentIndex = [[NSSortDescriptor alloc] initWithKey:constKeyIndex
																   ascending:YES] ;
	NSSortDescriptor* sdSponsoredIndex = [[NSSortDescriptor alloc] initWithKey:constKeySponsoredIndex
																	 ascending:YES] ;
	NSSortDescriptor* sdIxportingIndex = [[NSSortDescriptor alloc] initWithKey:constKeyIxportingIndex
																	 ascending:YES] ;
	sortDescriptors = [NSArray arrayWithObjects:sdSponsorIndex, sdCurrentIndex, sdSponsoredIndex, sdIxportingIndex, nil] ;

	[sdSponsorIndex release] ;
    [sdCurrentIndex release] ;
	[sdSponsoredIndex release] ;
	[sdIxportingIndex release] ;

	return sortDescriptors ;
}

- (BOOL)gulpStartainer:(NSObject <Startainer, StarCatcher, StarkReplicator> *)destin
				  info:(NSMutableDictionary*)info
			   error_p:(NSError**)error_p {
	
	BkmxBasis* basis = [BkmxBasis sharedBasis] ;
	NSInteger traceLevel = [basis traceLevel] ;
	NSString* logEntry ;
	BOOL ok = YES ;	
	
	if (traceLevel > 0) {
		logEntry = [[NSString alloc] initWithFormat:@"-------> Beginning Gulp for %@ <------\n", [destin displayName]] ;
#if LOG_TO_CONSOLE_TOO
		NSLog(@"%@", logEntry) ;
#endif
		[basis trace:logEntry] ;
		[logEntry release] ;
	}
	
	BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument] ;
	Extore* extore = [info objectForKey:constKeyExtore] ;
	Starker* destinStarker = [destin starker] ;
	SSYProgressView* progressView = nil ;
	BOOL isAnExporter = [[self delegate] isAnExporter] ;
	BOOL isAnImporter = [[self delegate] isAnImporter] ;
    NSError* error = nil ;
	NSString* verb ;
    BkmxMergeBias mergeBiasValue = [[info objectForKey:constKeyMergeBias] shortValue];
	NSMutableArray* affectedEnumeratedDestinStarks ;
	Stark* destinStark ;
	NSInteger i ;
	BOOL shouldDeleteUnmatchedItems = [[self delegate] shouldDeleteUnmatchedItemsWithInfo:info] ;
	
    if (traceLevel > 0) {
		NSString* readableMergeBias ;
		switch (mergeBiasValue) {
			case BkmxMergeBiasKeepSource:
				readableMergeBias = @"Keep Source" ;
				break;
			case BkmxMergeBiasKeepDestin:
				readableMergeBias = @"Keep Destin" ;
				break;
			case BkmxMergeBiasKeepBoth:
				readableMergeBias = @"Keep Both" ;
				break;
			default:
				readableMergeBias = @"@@@!!!%%% ERROR %%%!!!@@@" ;			
				break;
		}
		
		logEntry = [[NSString alloc] initWithFormat:@"\n"
					@"  shouldDeleteUnmatchedItems = %ld\n"
					@"             mergeBiasValue = %ld (%@)\n"
					@"                isAnImporter = %ld\n"
					@"                isAnExporter = %ld\n",
					(long)shouldDeleteUnmatchedItems,
					(long)mergeBiasValue, readableMergeBias,
					(long)isAnImporter,
					(long)isAnExporter] ;
#if LOG_TO_CONSOLE_TOO
		NSLog(@"%@", logEntry) ;
#endif
		[basis trace:logEntry] ;
		[logEntry release] ;
	}
		

	NSMutableArray* destinStarks = [[destin starker] destinees] ;
	
	// Important Note: If added, this observation is removed at the end of this method,
	// so it had better still be active when we get there!
	if (isAnExporter) {
		[[self delegate] setBkmxDoc:bkmxDoc] ;  // Observer will need this
		[[NSNotificationCenter defaultCenter] addObserver:[self delegate] 
												 selector:@selector(objectWillChangeNote:)
													 name:SSYManagedObjectWillUpdateNotification
												   object:nil] ; // Nil because must observe any stark
	}
	
#pragma mark gulpStartainer:::  Gulp-01.  Prepare Destin  **********************
	
	if (traceLevel > 0) {
		logEntry = [[NSString alloc] initWithFormat:@"  Gulp-01.  Prepare Destin\n"] ;
#if LOG_TO_CONSOLE_TOO
		NSLog(@"%@", logEntry) ;
#endif
		[basis trace:logEntry] ;
		[logEntry release] ;
	}
	
	// Clean the receivers's slate of unmatched items
	verb = [NSString stringWithFormat:@"Finalizing: Prepare Destination"] ;
    progressView = [[bkmxDoc progressView] setIndeterminate:NO
                                          withLocalizedVerb:verb
                                                   priority:SSYProgressPriorityRegular] ;
	[progressView setMaxValue:[destinStarks count]] ;
	i = 0 ;
	[progressView setDoubleValue:i] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;

	// If mergeBiasValue == Keep Source, we want the source items first, so destinSponsorIndex = SPONSORED_BY_SOURCE (which is a very large number)
	// If mergeBiasValue == Keep Destin, we want existing receiver's items first, so destinSponsorIndex = SPONSORED_BY_DESTIN (which is a very small number)
	// If mergeBiasValue ==   Keep Both, we want existing receiver's items first, so destinSponsorIndex = SPONSORED_BY_DESTIN (which is a very small number)
	// NSNumber* destinSponsorIndex = [NSNumber numberWithInt:(mergeBiasValue == BkmxMergeBiasKeepSource) ? SPONSORED_BY_SOURCE : SPONSORED_BY_DESTIN] ;
	NSNumber* destinSponsorIndex = [NSNumber numberWithInteger:SPONSORED_BY_DESTIN] ;
	if (traceLevel > 0) {
		logEntry = [[NSString alloc] initWithFormat:@"   destinSponsorIndex = %@\n", destinSponsorIndex] ;
#if LOG_TO_CONSOLE_TOO
		NSLog(@"%@", logEntry) ;
#endif
		[basis trace:logEntry] ;
		[logEntry release] ;
	}
	
	for (destinStark in destinStarks) {
		if (traceLevel > 3) {
			logEntry = [[NSString alloc] initWithFormat:@"   Considering deletion of %@\n", [destinStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
			NSLog(@"%@", logEntry) ;
#endif
			[basis trace:logEntry] ;
			[logEntry release] ;	
		}		
		i++ ;
		[progressView incrementAndRunDoubleValueBy:1] ;

		BOOL unsponsored = ([destinStark sponsorIndex] == nil) ;   // Note CanSwapSecs4&5-201
		if (traceLevel > 3) {
			logEntry = [[NSString alloc] initWithFormat:@"      unsponsored=%hhd  isNotHartainer=%hhd  isNotSeparator=%hhd\n", unsponsored, (BOOL)![destinStark isHartainer], (BOOL)([destinStark sharypeValue] != SharypeSeparator)] ;
#if LOG_TO_CONSOLE_TOO
			NSLog(@"%@", logEntry) ;
#endif
			[basis trace:logEntry] ;
			[logEntry release] ;	
		}		
		BOOL softShouldClean = NO ;
		if (unsponsored) {
			softShouldClean = (
							   shouldDeleteUnmatchedItems // ==> All unmatched soft starks now in receiver should be deleted
							   &&
							   ![destinStark isHartainer]
							   &&
							   ([destinStark sharypeValue] != SharypeSeparator)  // Separators are marked for deletion in -[Ixporter mergeFromStartainer::::].
							   &&
							   (
								isAnExporter
								||
								(
								 isAnImporter
								 &&
								 [bkmxDoc wasImportableStark:destinStark]
								 )
								)
							   ) ;
			if (traceLevel > 3) {
				logEntry = [[NSString alloc] initWithFormat:@"      softShouldClean=%ld\n", (long)softShouldClean] ;
#if LOG_TO_CONSOLE_TOO
				NSLog(@"%@", logEntry) ;
#endif
				[basis trace:logEntry] ;
				[logEntry release] ;	
			}		
		}
		if (softShouldClean) {
			if (traceLevel > 0) {
				logEntry = [[NSString alloc] initWithFormat:@"      Set isDeletedThisIxport\n"] ;
#if LOG_TO_CONSOLE_TOO
				NSLog(@"%@", logEntry) ;
#endif
				[basis trace:logEntry] ;
				[logEntry release] ;
			}
			// We do not -[destinStark remove] here so that the indexes of its siblings
			// do not get changed -- yet. If no stark comes in to replace
			// this one, the required adjustments will be made to sibling
			// indexes in Connect Families.
			// If we did -[destinStark remove] here, then the indexes
			// of its siblings would be changed immediately, adding them
			// to Chaker's updates, when in fact Connect Families
			// may later change its index back to the original value.
			// Furthermore, as of BookMacster 1.0.4, we don't even stealthily
			// delete it from the managed object context yet; i.e. [destinStarker deleteObject]
			// Instead, we set a flag for it to be deleted later.
			[destinStark setIsDeletedThisIxport] ;  // Note CanSwapSecs4&5-101
		}
		else if ([destinStark isDeletedThisIxport]) {
			// Leave as is.
			// This branch was added in BookMacster 1.9.5 to handle unwanted separators which 
			// now receive -setIsDeletedThisIxport in -mergeFromStartainer::::.
		}
		else {
			// If hartainer, override destinSponsorIndex to SPONSORED_BY_IS_HARTAINER = -2, so it goes to the top.
			// (Prior to BookMacster 1.11.3, this was SPONSORED_BY_DESTIN = -1, but that allowed
			//  the hartainers to float around when importing from an ExtoreWebFlat.)
			NSNumber* thisSponsorIndex = [destinStark isHartainer] ? [NSNumber numberWithInteger:SPONSORED_BY_IS_HARTAINER] : destinSponsorIndex ;
			
			// The reason for the following if() is in case the destinStark was matched to a
			// kept (dominant) source stark, it will already have, or if it was Sponsored by
			// Source (see above), it will have had its sponsor/ed values already set properly.
			if (![destinStark sponsoredIndex]) {                         // Note CanSwapSecs4&5-202
				NSNumber* sponsorIndex = (mergeBiasValue==BkmxMergeBiasKeepDestin) ? [NSNumber numberWithInteger:SPONSORED_BY_DESTIN] : thisSponsorIndex ;
				[destinStark setSponsorIndex:sponsorIndex] ;
				[destinStark setSponsoredIndex:[destinStark index]] ;    // Note CanSwapSecs4&5-103
				if (traceLevel > 3) {
					logEntry = [[NSString alloc] initWithFormat:@"      Self-sponsored as sI=%@.%@\n", thisSponsorIndex, [destinStark index]] ;
#if LOG_TO_CONSOLE_TOO
					NSLog(@"%@", logEntry) ;
#endif
					[basis trace:logEntry] ;
					[logEntry release] ;
				}
			}
		}
	}
	
	[progressView clearAll] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;

	
	if (traceLevel > 3) {
		logEntry = [[NSString alloc] initWithFormat:@"18400: destinStarks, now including newDestinStarks: %@\n", [destinStarks shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
		NSLog(@"%@", logEntry) ;
#endif
		[basis trace:logEntry] ;
		[logEntry release] ;
	}
	else if (traceLevel > 0) {
		logEntry = [[NSString alloc] initWithFormat:@"       %ld destin starks after Prepare Destin\n", (long)[destinStarks count]] ;
#if LOG_TO_CONSOLE_TOO
		NSLog(@"%@", logEntry) ;
#endif
		[basis trace:logEntry] ;
		[logEntry release] ;	
	}
	
	
#pragma mark gulpStartainer:::  Gulp-02.  Connect Families  **********************
	
	if (traceLevel > 0) {
		logEntry = [[NSString alloc] initWithFormat:@"  Gulp-02.  Connect Families\n"] ;
#if LOG_TO_CONSOLE_TOO
		NSLog(@"%@", logEntry) ;
#endif
		[basis trace:logEntry] ;
		[logEntry release] ;
	}
	
	// Added in BookMacster 1.10
	BOOL didImportAnyIndexes = NO ;
	for (Extore* extore in [bkmxDoc importedExtores]) {
		if ([extore hasOrder]) {
			didImportAnyIndexes = YES ;
			break ;
		}
	}
	
	// We're into summary mode now, so anything logged from now on
	// is not necessarily from the current client/ixporter/self
	
	NSArray* sortDescriptors ;
	if (isAnImporter  && !didImportAnyIndexes) {
		// Special case, happens when we import only from an ExtoreWebFlat.
		
		// This section was added in BookMacster 1.10.1, to replace a change done
		// in BookMacster 1.10, below which was removed.  *That* change was to
		// not sort at all in this special case, which was a mistake.  The correct
		// answer is to sort, but use different sort descriptors as is done here.
		
		// When importing from an ExtoreWebFlat, I think that all items will have 
		// either have the same parent, or nil parent.
		// New items will have nil parent.  We use ascending:NO to make those last.
		NSSortDescriptor* sdParent = [[NSSortDescriptor alloc] initWithKey:constKeyParent
																 ascending:NO] ;
		NSSortDescriptor* sdExistingIndex = [[NSSortDescriptor alloc] initWithKey:constKeyIndex
																		ascending:YES] ;
		NSSortDescriptor* sdName = [[NSSortDescriptor alloc] initWithKey:constKeyName
															   ascending:YES] ;
		sortDescriptors = [NSArray arrayWithObjects:sdParent, sdExistingIndex, sdName, nil] ;
		
		[sdParent release] ;
		[sdExistingIndex release] ;
		[sdName release] ;
	}
	else {
		// Normal case
		sortDescriptors = [[self class] sortDescriptorsForGulping] ;
	}
	
	verb = [NSString stringWithFormat:@"Finalizing: Connect Relationships"] ;
	[progressView setIndeterminate:NO
                 withLocalizedVerb:verb
                          priority:SSYProgressPriorityRegular] ;
	[progressView setMaxValue:[destinStarks count]] ;
	[progressView setDoubleValue:0] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
    NSDictionary* sponsoredChildrenDic = [info objectForKey:constKeySponsoredChildren] ;
	for (Stark* parent in destinStarks) {
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
		[progressView incrementAndRunDoubleValueBy:1] ;

		if (![parent canHaveChildren]) {
			// No need to go further.  This is done for efficiency.
			[pool drain] ;
			continue ;
		}
		
		// Added in BookMacster 1.0.4
		if ([parent isDeletedThisIxport]) {
			// No need to go further.  This is done for efficiency.
			[pool drain] ;
			continue ;
		}
		
		if (traceLevel > 3) {
			logEntry = [[NSString alloc] initWithFormat:@"28100    Connecting parent: %@\n", [parent shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
			NSLog(@"%@", logEntry) ;
#endif
			[basis trace:logEntry] ;
			[logEntry release] ;
		}
		
		if (traceLevel > 3) {
			logEntry = [[NSString alloc] initWithFormat:
						@"28104      original childrenTemp (%ld) :\n",
						(long)[[parent childrenTemp] count]] ;
#if LOG_TO_CONSOLE_TOO
			NSLog(@"%@", logEntry) ;
#endif
			[basis trace:logEntry] ;
			[logEntry release] ;
			for (Stark* child in [parent childrenTemp]) {
				logEntry = [[NSString alloc] initWithFormat:@"%p  ", child] ;
#if LOG_TO_CONSOLE_TOO
				NSLog(@"%@", logEntry) ;
#endif
				[basis trace:logEntry] ;
				[logEntry release] ;
			}
			[basis trace:@"\n"] ;
		}
		
		// Start with childrenTemp, and immediately eliminate
		// children that were deleted because they were unmatched.
  		NSMutableArray* correctChildren = [NSMutableArray array] ;
		for (Stark* child in [parent childrenTemp]) {
			if (![child isDeletedThisIxport]) {
  				[correctChildren addObject:child] ;
			}
		}
		[parent setChildrenTemp:correctChildren] ;
        // But we're not done.  Add sponsored (new) children.
		
		NSSet* sponsoredChildren = [sponsoredChildrenDic objectForKey:[parent starkid]] ;
		if (traceLevel > 3) {
			logEntry = [[NSString alloc] initWithFormat:
						@"28108      sponsoredChildren (%ld) :\n",
						(long)[sponsoredChildren count]] ;
#if LOG_TO_CONSOLE_TOO
			NSLog(@"%@", logEntry) ;
#endif
			[basis trace:logEntry] ;
			[logEntry release] ;
			for (Stark* child in sponsoredChildren) {
				logEntry = [[NSString alloc] initWithFormat:@"%p  ", child] ;
#if LOG_TO_CONSOLE_TOO
				NSLog(@"%@", logEntry) ;
#endif
				[basis trace:logEntry] ;
				[logEntry release] ;
			}
			[basis trace:@"\n"] ;
		}
        for (Stark* sponsoredChild in sponsoredChildren) {
            // The following test is actually more than defensive programming,
            // because I have not even thought through if some of these
            // children might be deleted in some corner case.  I assume that it
            // is possible.
            if ([sponsoredChild isAvailable]) {
                [correctChildren addObject:sponsoredChild] ;
            }
        }

		[correctChildren sortUsingDescriptors:sortDescriptors] ;
				
		// Set new indexes, if…
		if (isAnImporter || [extore hasOrder]) {  // In BookMacster 1.10, was anyIndexesImported sted isAnImporter.  In BookMacster 1.10.1, changed back to pre-1.10 code isAnImporter
			NSInteger i = 0 ;
			for (Stark* child in correctChildren) {
				// Because Chaker is properly tracking and cancelling
				// "full circle" changes, I do not need to deactivate it here.
				[child setIndexValue:i++] ;
			}
		}
		
		if (traceLevel > 3) {
			logEntry = [[NSString alloc] initWithFormat:@"28200      final correctChildren=childrenTemp (%ld): %@\n", (long)[correctChildren count], [correctChildren shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
			NSLog(@"%@", logEntry) ;
#endif
			[basis trace:logEntry] ;
			[logEntry release] ;
		}
		
		[pool drain] ;
	}	
	[progressView clearAll] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;


	if (traceLevel > 3) {
		logEntry = [[NSString alloc] initWithFormat:@"28400: destinStarks after Connect Families:\n"] ;
#if LOG_TO_CONSOLE_TOO
		NSLog(@"%@", logEntry) ;
#endif
		[basis trace:logEntry] ;
		[logEntry release] ;
		{
			for (Stark* stark in destinStarks) {
				logEntry = [[NSString alloc] initWithFormat:@"   %@\n", [stark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
				NSLog(@"%@", logEntry) ;
#endif
				[basis trace:logEntry] ;
				[logEntry release] ;
			}
		}	
	}


// /* This section would be needed if we ever switched on cullRedundantSlides
//    in ExtoreSafari.  It could run conditionally. */
//- #pragma mark gulpStartainer:::  Gulp-03.  Remember Old Relationships  **********************
//
//    // The following is because Extore Safari needs to know the former
//    // parent and parents' former children  in order to export changes for iCloud,
//    // and the following setChildren: will setParent:nil for children which
//    // are being moved out, due to Delete Rule in data model.  We'll use this
//    // soon, when we -deleteStark: in Gulp-07.  Delete Unmatched or Merged Items
//    /* Also, this must be done before Reassign Children because, although it
//     is not apparent, adding a child to a different folder in setChildren:
//     *will* remove it from the children of the old parent. */
//    if (isAnExporter && [extore writingRequiresOldRelationships]) {
//        if (traceLevel > 0) {
//            logEntry = [[NSString alloc] initWithFormat:@"  Gulp-03.  Remember Old Relationships\n"] ;
//#if LOG_TO_CONSOLE_TOO
//            NSLog(@"%@", logEntry) ;
//#endif
//            [basis trace:logEntry] ;
//            [logEntry release] ;
//        }
//
//        Clientoid* clientoid = extore.client.clientoid;
//
//        verb = [NSString stringWithFormat:@"Finalizing: Remember Old Relationships"] ;
//        [progressView setIndeterminate:NO
//                     withLocalizedVerb:verb
//                              priority:SSYProgressPriorityRegular] ;
//        [progressView setMaxValue:[destinStarks count]] ;
//        [progressView setDoubleValue:0] ;
//        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
//        for (destinStark in destinStarks) {
//            NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
//
//            [progressView incrementAndRunDoubleValueBy:1] ;
//            if (![destinStark canHaveChildren]) {
//                [pool drain] ;
//                continue ;
//            }
//            if ([destinStark isDeletedThisIxport]) {
//                [pool drain] ;
//                continue ;
//            }
//
//            NSMutableArray* oldChildrenExids = [NSMutableArray new];
//            NSMutableArray* childrenOrdered = [[destinStark.children allObjects] mutableCopy];
//            /* Note: We cannot just use destinStark.childrenOrdered here.
//             It's a long story.  But this gives a different result: */
//            [childrenOrdered sortUsingDescriptors:sortDescriptors];
//            for (Stark* child in childrenOrdered) {
//                [child setOldParent:destinStark] ;
//                NSString* exid = [child exidForClientoid:clientoid];
//                if (clientoid) { /* Defensive programming */
//                    [oldChildrenExids addObject:exid];
//                }
//            }
//            [destinStark setOldChildrenExids:oldChildrenExids];
//
//            [pool drain] ;
//        }
//        [progressView clearAll] ;
//        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
//    }
	
#pragma mark gulpStartainer:::  Gulp-04.  Reassign Children  **********************
    
    if (traceLevel > 0) {
        logEntry = [[NSString alloc] initWithFormat:@"  Gulp-04.  Reassign Children\n"] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
    
    verb = [NSString stringWithFormat:@"Finalizing: Reassign Children"] ;
    [progressView setIndeterminate:NO
                 withLocalizedVerb:verb
                          priority:SSYProgressPriorityRegular] ;
    [progressView setMaxValue:[destinStarks count]] ;
    [progressView setDoubleValue:0] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
    for (destinStark in destinStarks) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;

        [progressView incrementAndRunDoubleValueBy:1] ;
        if (![destinStark canHaveChildren]) {
            [pool drain] ;
            continue ;
        }
        if ([destinStark isDeletedThisIxport]) {
            [pool drain] ;
            continue ;
        }

        NSArray* existingChildren = [destinStark childrenOrdered] ;
        NSArray* correctChildren = [destinStark childrenTemp] ;
        BOOL wrong = NO ;
        if ((correctChildren == nil) != (existingChildren == nil)) {
            // One is nil and the other is not
            wrong = YES ;
        }
        else if (correctChildren != nil) {
            // Both are non-nil
            if (![correctChildren isEqualToArray:existingChildren]) {
                wrong = YES ;
            }
        }
        else {
            // Both are nil.  Since nil=nil, this is not wrong.
        }

        if (wrong) {
            if (traceLevel > 3) {
                logEntry = [[NSString alloc] initWithFormat:@"Corr-children for %@: %@\n", [destinStark shortDescription], [correctChildren shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                NSLog(@"%@", logEntry) ;
#endif
                [basis trace:logEntry] ;
                [logEntry release] ;
            }
            NSSet* correctSet = [NSSet setWithArray:correctChildren] ;

            /* If destin has neither order nor folders, let the chaker rest. */
            if (![destin hasOrder] && ![destin hasFolders]) {
                [[bkmxDoc chaker] setIsActive:NO] ;
            }

            [destinStark setChildren:correctSet] ;

            [[bkmxDoc chaker] setIsActive:YES] ;
        }

        // Clean Transient Children
        // This is just to be neat.  We also do it in -[Ixporter mergeFromStartainer::::]
        // because this may not always run.
        [destinStark setChildrenTemp:nil] ;

        [pool drain] ;
    }
    [progressView clearAll] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;

    // Just to release memory I reckon, no longer needed.
    [info removeObjectForKey:constKeySponsoredChildren] ;
	
	// Clear the Standin Hartainers, which means to deal with any that aren't
	// supposed to exist in the destination by moving their children into
	// the default parent.
	
	// Removed in BookMacster 1.11 because it was found to be hiding necessary
	// cancellations from Charker during an Import, if the BkmxDoc does not have
	// one of the hartainers that an Import client has items in.  (Note that
	// this will not occur if the New Collection wizard is used.  I think
	// that this was a hangover from before I developed the Gulper, which is
	// only used for imports.  Here is the old comment which no longer applies:
	// <oldComment>
	// Before clearing the standin hartainers, we remove bkmxDoc as an observer,
	// and after, re-add it.  Note that we do *not* remove [self delegate] as
	// an observer of SSYManagedObjectWillUpdateNotification selecting -objectWillChangeNote:,
	// because the Chaker needs to see any moves of children that are done
	// during this process, even if they just cancel out previous moves.
	// It is important for Write Style 2 to, for example, Chrome, that Chaker
	// receives all moves, if only for cancellation.
	// </oldComment>
	// Note 890539.  See mating comment below.
	//	[[NSNotificationCenter defaultCenter] removeObserver:bkmxDoc 
	//													name:SSYManagedObjectWillUpdateNotification
	//												  object:nil] ;
	// However, removing the above then caused apparent churn (in Status Bar
	// and Sync Log, not actual churn) when exporting to ExtoreWebFlat extores.
	// (Actual churn was avoided because pendingAdditions and 
	// pendingDeletions are checked for 
	// -[Extore supportedAttributesAreEqualComparingStark:otherStark:ixportStyle:]
	// in -[ExtoreWebFlat writeUsingStyle1InOperation:].)
	// So in BookMacster 1.11.3 I added this…
	// if (![destin hasOrderAndFolders]) {
    // and updated it in BookMacster 1.12.3 to this…
    if (![destin hasOrder] && ![destin hasFolders]) {
		[[bkmxDoc chaker] setIsActive:NO] ;
	}

    NSSet* hartainersRead = [info objectForKey:constKeyHartainerSharypesRead];
    NSMutableSet* readButRemovedHartainerSharypes = [NSMutableSet new];
	// Order of the following four operations was reversed in
    // BookMacster 1.21.4 so that bookmarks imported from Safari to a
    // Markster document with no structure would have their root, bar
    // and menu bookmarks stacked with bar before menu.
    [self clearStandinHartainerSharype:SharypeOhared
                        hartainersRead:hartainersRead
                            traceLevel:traceLevel
                          destinStarks:destinStarks
                         destinStarker:destinStarker
       readButRemovedHartainerSharypes:readButRemovedHartainerSharypes];
    [self clearStandinHartainerSharype:SharypeUnfiled
                        hartainersRead:hartainersRead
                            traceLevel:traceLevel
                          destinStarks:destinStarks
                         destinStarker:destinStarker
       readButRemovedHartainerSharypes:readButRemovedHartainerSharypes];
    [self clearStandinHartainerSharype:SharypeMenu
                        hartainersRead:hartainersRead
                            traceLevel:traceLevel
                          destinStarks:destinStarks
                         destinStarker:destinStarker
       readButRemovedHartainerSharypes:readButRemovedHartainerSharypes];
    [self clearStandinHartainerSharype:SharypeBar
                        hartainersRead:hartainersRead
                            traceLevel:traceLevel
                          destinStarks:destinStarks
                         destinStarker:destinStarker
       readButRemovedHartainerSharypes:readButRemovedHartainerSharypes];
	
    if ([readButRemovedHartainerSharypes count] > 0) {
        /* Note RemovedHartainerUncertainty
         This branch should only occuring when removing the legacy Bookmarks
         Menu from an old Safari bookmarks file. */
        [[bkmxDoc chaker] setIsActive:NO] ;
        for (NSNumber* sharypeNumber in readButRemovedHartainerSharypes) {
            NSString* msg = [NSString stringWithFormat:
                             @"Removing legacy %@ from %@",
                             [sharypeNumber readableSharype],
                             [destin displayName]];
            [[BkmxBasis sharedBasis] logString:msg];
            Stark* hartainer = [destinStarker hartainerOfSharype:sharypeNumber.sharypeValue
                                                         quickly:NO];
            [[destinStarker root] removeChildrenObject:hartainer];
        }

        [[destinStarker root] restackChildrenOfHartainerForGulp];
    }

    [readButRemovedHartainerSharypes release];
    [[bkmxDoc chaker] setIsActive:YES];
    

	// Note 890539.  See mating comment above.
	//	[[NSNotificationCenter defaultCenter] addObserver:bkmxDoc 
	//											 selector:@selector(objectWillChangeNote:)
	//												 name:SSYManagedObjectWillUpdateNotification
	//											   object:nil] ;

	
#pragma mark gulpStartainer:::  Gulp-05.  Fabricate Folders  **********************
	
	if (traceLevel > 0) {
		logEntry = [[NSString alloc] initWithFormat:@"  Gulp-05.  Fabricate Folders\n"] ;
#if LOG_TO_CONSOLE_TOO
		NSLog(@"%@", logEntry) ;
#endif
		[basis trace:logEntry] ;
		[logEntry release] ;
	}
	
	NSNumber* fabricateFolders = [[self delegate] fabricateFolders] ;
	if ([fabricateFolders shortValue] > BkmxFabricateFoldersOff) {
		verb = [NSString stringWithFormat:@"Finalizing: Fabricate Folders"] ;
		[progressView setIndeterminate:NO
                     withLocalizedVerb:verb
                              priority:SSYProgressPriorityRegular] ;
		[progressView setMaxValue:[destinStarks count]] ;
		[progressView setDoubleValue:0] ;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
        NSInteger ixportingIndex = 0x0800;
        NSMutableSet* newFolders = [NSMutableSet new];
		for (destinStark in destinStarks) {
			[progressView incrementAndRunDoubleValueBy:1] ;
            [destinStark fabricateFolders:fabricateFolders
                           ixportingIndex:ixportingIndex
                               newFolders:&newFolders] ;
		}
        [destinStarks addObjectsFromArray:[newFolders allObjects]];
        for (Stark* newFolder in newFolders) {
            [[bkmxDoc chaker] addStark:newFolder];
        }
        
        [newFolders release];
		[progressView clearAll] ;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
	}
	
	
#pragma mark gulpStartainer:::  Gulp-06.  Merge Folders **********************
	
	if (
		isAnImporter
		||
		(isAnExporter && [extore hasFolders])
		) {
		if (traceLevel > 0) {
			logEntry = [[NSString alloc] initWithFormat:@"  Gulp-06.  Merge Folders\n"] ;
#if LOG_TO_CONSOLE_TOO
			NSLog(@"%@", logEntry) ;
#endif
			[basis trace:logEntry] ;
			[logEntry release] ;
		}
		
		// Progress is must show "second order" effects because
		// just incrementing as each stark merges folders
		// can be too erratic if, for example, you have a folder
		// containing 100 subfolders -- Progress will just stop
		// at that point for many seconds.  In order to get the "second
		// order" max value, I need the total number of children:
		NSInteger nTotalChildren = 0 ;
		Stark* destinRoot = nil ;
		for (destinStark in destinStarks) {
			nTotalChildren += [destinStark numberOfChildren] ;
			if ([destinStark sharypeValue] == SharypeRoot) {
				destinRoot = destinStark ;
			}
		}
		
		// Merge Folders
        [[bkmxDoc chaker] setFrom:@"Merge folders"] ;
		if (mergeBiasValue != BkmxMergeBiasKeepBoth) {
			[progressView setIndeterminate:NO
                         withLocalizedVerb:@"Finalizing: Merge Folders"
                                  priority:SSYProgressPriorityRegular] ;
			[progressView setMaxValue:nTotalChildren] ;
			[progressView setDoubleValue:0] ;
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
			[info setObject:[NSNumber numberWithBool:(mergeBiasValue == BkmxMergeBiasKeepSource)]
					 forKey:constKeyKeepSourceNotDestin] ;
            /* Because the Connect Families phase has already run, we must
             fix the indexes of any siblings of any folders which are deleted
             during folder consolidation (aka merging).  (This is kind of a
             situation where both the chicken and the egg need to be first,
             so our solution is to provide a pre-egg and a post-egg.) For
             efficiency, we collect such deleted folders in this mutable set. */
             NSMutableSet* foldersDeletedDuringConsolidation = [NSMutableSet new];
             [info setObject:foldersDeletedDuringConsolidation
                      forKey:constKeyFoldersDeletedDuringConsolidation];
             [foldersDeletedDuringConsolidation release];
            /* Note that the this may be only necessary for exports to Safari
             (see commit message and Version History for BkmkMgrs 2.10.20)
             because Safari returns NO to -shouldActuallyDeleteBeforeWrite.
             (I tried setting that to YES, but that caused SheepSafariHelper to crash with
             -[__NSSetM safari_arrayByRemovingRedundantDescendantBookmarks]
             selector not found during removal of limboites.  I did not
             investigate why, because to fix an edge case, you want to be
             un-intrusive as possible, and definitely not touch anything as
             tricky as SheepSafariHelper.)  Also note that these folders will not really
             be deleted yet, because we do not pass the BOOL
             constKeyConsolidateAndRemoveNow in `info`. */
			[destinRoot recursivelyPerformSelector:@selector(mergeFoldersWithInfo:)
										withObject:info] ;
            for (Stark* deletedFolder in foldersDeletedDuringConsolidation) {
                Stark* parent = [deletedFolder parent];
                NSInteger i=0;
                for (Stark* child in [parent childrenOrdered]) {
                    if (![child isDeletedThisIxport]) {
                        [child setIndexValue:i];
                        i++;
                    }
                }
            }
            logEntry = [[NSString alloc] initWithFormat:@"%ld folders deleted during consolidation\n", foldersDeletedDuringConsolidation.count] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;


			[progressView clearAll] ;
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
		}
	}

	
#pragma mark gulpStartainer:::  Gulp-07.  Delete Unmatched or Merged Items **********
	
	if (traceLevel > 0) {
		logEntry = [[NSString alloc] initWithFormat:@"  Gulp-07.  Delete Unmatched or Merged Items\n"] ;
#if LOG_TO_CONSOLE_TOO
		NSLog(@"%@", logEntry) ;
#endif
		[basis trace:logEntry] ;
		[logEntry release] ;
	}
	
	[[bkmxDoc chaker] setFrom:@"Delete Unmatched or Merged Items"] ;
	
	verb = [NSString stringWithFormat:@"Finalizing: Delete Unmatched or Merged Items"] ;
	[progressView setIndeterminate:NO
                 withLocalizedVerb:verb
                          priority:SSYProgressPriorityRegular] ;
	[progressView setMaxValue:[destinStarks count]] ;
	[progressView setDoubleValue:0] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
	affectedEnumeratedDestinStarks = [[NSMutableArray alloc] init] ;
	for (destinStark in destinStarks) {
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
		[progressView incrementAndRunDoubleValueBy:1] ;
		if (traceLevel > 3) {
			logEntry = [[NSString alloc] initWithFormat:@"38210:    Considering %@\n", [destinStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
			NSLog(@"%@", logEntry) ;
#endif
			[basis trace:logEntry] ;
			[logEntry release] ;
		}
		
		if ([destinStark isDeletedThisIxport]) {
			if (traceLevel > 3) {
				logEntry = [[NSString alloc] initWithFormat:@"38250:       Adding to Chaker's Deletions -- Delete Unmatched or Merged Items.\n"] ;
#if LOG_TO_CONSOLE_TOO
				NSLog(@"%@", logEntry) ;
#endif
				[basis trace:logEntry] ;
				[logEntry release] ;
			}
			[[bkmxDoc chaker] deleteStark:destinStark] ;
			// Note that the above method will, eventually, during
			// -[SSYOperation(Operation_Common) actuallyDelete],
			// adjust indexes of siblings as necessary.
			[affectedEnumeratedDestinStarks addObject:destinStark] ;
			// Until BookMacster version 1.3.5, we did this here…
			// [destinStark remove] ; // Prior to BookMacster 1.1, was -[managedObjectContext deleteObject:]
			// But now we do this instead in the 'actuallyDelete' (for
			// import) or 'writeAndDelete' operation
			// because at this point we might still need its attributes in
			// 'syncLog', and for addon exports, when doing the export.
			// (Recall that managed objects' attributes all get
			// set to nil when the managed object is deleted.) 
		}
		
		[pool drain] ;
	}
	[progressView clearAll] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;

	for (Stark* cleanee in affectedEnumeratedDestinStarks) {
		[destinStarks removeObject:cleanee] ;
	}
	[affectedEnumeratedDestinStarks release] ;
	
	// Probably not needed, but just in case I add something later in this method
	[[bkmxDoc chaker] setFrom:nil] ;
	
	
#pragma mark gulpStartainer:::  Gulp-08.  Delete Dupes If Not Allowed **********
	
	// Prior to BookMacster version 1.3.19, when the local autorelease
	// pool was added for each loop iteration in the following loop,
	// the following two limits were 16x lower, 0x800=256.  They were
	// needed to keep memory usage from going into the gigabytes.
	// Now, they're probably not needed.
#define MAX_DUPES_GROUPS       0x00008000 // 32768
#define MAX_BOOKMARKS_IN_GROUP 0x00008000 // 32768
	
	if (isAnExporter && [extore silentlyRemovesDuplicates]) {
		// We don't do any of the fancy things that we might in here, such as 
		// combining tags of deleted bookmarks with undeleted ones, or trying
		// to make a smart decision which one to delete, or asking the user,
		// or even telling the user.
		
		// However, it *is* necessary to delete dupes at this point because:
        // When exids are assigned for Pinboard, they
		// are based on the url.  Thus, at this point we may have
		// multiple bookmarks with the same URL.  And these exids will be
		// fed back to the Collection.  This will cause mismatches
		// during subsequent imports and exports.  For example, say that the
		// user changes the URL of a pair of bookmarks that have the same
		// exid, in the BkmxDoc.  Then she exports.  The bookmark in the extore
		// with the same identifier will match (by exid) the bookmark in the
		// bkmxDoc which has a different URL, and thus it will not be added
		// as a new item to the extore.
		
		if (traceLevel > 0) {
			logEntry = [[NSString alloc] initWithFormat:@"  Gulp-08.  Delete Dupes If Not Allowed\n"] ;
#if LOG_TO_CONSOLE_TOO
			NSLog(@"%@", logEntry) ;
#endif
			[basis trace:logEntry] ;
			[logEntry release] ;
		}
		
		NSString* from = [NSString stringWithFormat:
						  @"Delete Dupes (dupes not allowed in %@)",
						  [extore ownerAppDisplayName]] ;
		[[bkmxDoc chaker] setFrom:from] ;
		
		verb = [NSString stringWithFormat:@"Finalizing: %@", from] ;
		[progressView setIndeterminate:NO
                     withLocalizedVerb:verb
                              priority:SSYProgressPriorityRegular] ;
		NSInteger nStarks = [destinStarks count] ;
		[progressView setMaxValue:nStarks] ;
		[progressView setDoubleValue:0] ;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
		NSMutableArray* dupes = [[NSMutableArray alloc] init] ;
		NSMutableSet* usedUrls = [[NSMutableSet alloc] init] ;
        NSMutableDictionary* exportFeedbackDic = [info objectForKey:constKeyExportFeedbackDic] ;        
		for (Stark* destinStark in destinStarks) {
			NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
			// Update progress and make sure count is not getting ridiculous
			[progressView incrementAndRunDoubleValueBy:1] ;
			if ([usedUrls count] > MAX_DUPES_GROUPS) {
				NSString* msg = [NSString stringWithFormat:
								 @"While eliminating duplicates (since %@ does not allow them), we found over %ld groups of identical bookmarks.\n\nIt will be more efficient to stop and clean those up, then re-run to find more.",
								 [extore ownerAppDisplayName],
								 (long)MAX_DUPES_GROUPS] ; 
				error = SSYMakeError(502294, msg) ;
				break ;
			}
			
			NSString* url = [destinStark url] ;
			if (url) {
				if ([usedUrls member:url]) {
					// We've found a duplicate
					[dupes addObject:destinStark] ;
					// Note that the following method will also adjust indexes
					// of siblings as necessary.
					// Until BookMacster version 1.3.5, we did this here…
					// [destinStark remove] ;
					// But now we do this instead in the 'actuallyDelete' (for
					// import) or 'writeAndDelete' (for export) operation
					// because at this point we might still need its attributes in
					// 'syncLog', and for addon exports, when doing the export.
					// (Recall that managed objects' attributes all get
					// set to nil when the managed object is deleted.) 
					[[bkmxDoc chaker] deleteStark:destinStark] ;
                    
                    /* Remove the corresponding exid feedback entry, lest the
                     source stark mated to the destin stark indicate a
                     nonexistent "Client Association", and also during
                     subsequent exports, the fact that only *one* has the
                     client association will cause that one to be the best
                     match in -[Stark bestMatchBetweenStark1:stark2:] again,
                     eliminating "churn" when a Collection with duplicat-URL
                     bookmarks is exported by Pinboard or Diigo. (Pinboard
                     and Diigo use a hash of the URL as their exid.) */
                    [exportFeedbackDic removeObjectForKey:[destinStark objectID]];
				}
				else {
					[usedUrls addObject:url] ;
				}
			}
			[pool drain] ;
		}
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
		[progressView clearAll] ;
		
		for (Stark* cleanee in dupes) {
			[destinStarks removeObject:cleanee] ;
		}
		[dupes release] ;
		[usedUrls release] ;
		
		// Probably not needed, but just in case I add something later in this method
		[[bkmxDoc chaker] setFrom:nil] ;
		
		if (error) {
			if (error_p) {
				*error_p = error ;
			}
			
			goto end ;
		}
	}
    
#pragma mark gulpStartainer:::  Gulp-09.  Default Item Dates **********************
	
    // This phase was added in BookMacster 1.20.5.
    if (traceLevel > 0) {
        logEntry = [[NSString alloc] initWithFormat:@"  Gulp-09.  Default Item Dates\n"] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
    
	NSDate* now = [NSDate date] ;
    BOOL canEditAddDate;
    BOOL canEditLastModifiedDate;
    if (isAnExporter) {
        canEditAddDate = [destin canEditAttribute:constKeyAddDate
                                          inStyle:extore.ixportStyle];
        canEditLastModifiedDate = [destin canEditAttribute:constKeyLastModifiedDate
                                                   inStyle:extore.ixportStyle];
    }
    else {
        // destin is Bkmslf which can edit all attributes
        canEditAddDate = YES;
        canEditLastModifiedDate = YES;
    }
    for (destinStark in destinStarks) {
        if (![destinStark addDate] && canEditAddDate) {
            [destinStark setAddDate:now] ;
        }
        
        if (![destinStark lastModifiedDate] && canEditLastModifiedDate) {
            // This covers a weird but not rare corner case.
            [destinStark setLastModifiedDate:now] ;
        }
    }


#pragma mark gulpStartainer:::  Gulp-10.  Integrity Test **********************
	
	if (isAnImporter || [extore hasOrder]) {  // Line added in 1.1.5 since indexes no longer set in this case
		if (traceLevel > 0) {
			logEntry = [[NSString alloc] initWithFormat:@"  Gulp-10.  Integrity Test\n"] ;
#if LOG_TO_CONSOLE_TOO
			NSLog(@"%@", logEntry) ;
#endif
			[basis trace:logEntry] ;
			[logEntry release] ;
		}
		
		[progressView setIndeterminate:NO
                     withLocalizedVerb:@"Finalizing: Integrity Test"
                              priority:SSYProgressPriorityRegular] ;
		[progressView setMaxValue:[destinStarks count]] ;
		[progressView setDoubleValue:0] ;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
		for (destinStark in destinStarks) {
			NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
			[progressView incrementAndRunDoubleValueBy:1] ;

			// Added in BookMacster 1.0.4
			if ([destinStark isDeletedThisIxport]) {
				[pool drain] ;
				continue ;
			}
			
			if ([destinStark canHaveChildren]) {
				NSArray* children = [destinStark childrenOrdered] ;
				NSInteger i = 0 ;
				for (Stark* child in children) {
                    if ([child isDeletedThisIxport]) {
                        continue;
                    }
					NSInteger childIndexValue = [child indexValue] ;
                    if (childIndexValue != i) {
                        NSString* desc = [NSString stringWithFormat:
                                          @"Indexes in merged result failed continuity test during %@ to %@",
                                          isAnImporter ? @"import" : @"export",
                                          [destin displayName]] ;
						error = SSYMakeError(57460, desc) ;
						NSString* msg ;
						msg = [NSString stringWithFormat:@"Please click the life-preserver icon and send to sheepsystems.com.  "
							   @"If possible, try and preserve this Collection and bookmarks in %@ until you hear from us.",
							   [[self delegate] displayName]] ;
						error = [error errorByAddingLocalizedRecoverySuggestion:msg] ;
						error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:i]
															forKey:@"Index, expected"] ;
						error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:childIndexValue]
															forKey:@"Index, actual"] ;
						error = [error errorByAddingUserInfoObject:[destinStark shortDescription]
															forKey:@"Parent"] ;
						error = [error errorByAddingUserInfoObject:[children shortDescription]
															forKey:@"Children"] ;
                        if (error_p) {
							*error_p = error ;
						}
						
						ok = NO ;
#if 0
#warning Logging then ignoring integrity errors
                        NSLog(@"INTEGRITY: %@", error) ;
                        if (error_p) {
							*error_p = nil ;
						}
                        error = nil ;
                        ok = YES ;
#endif
                        
                        // Added in BookMacster 1.13.6
                        if (isAnImporter) {
                            [bkmxDoc forgetLastPreImportedHashForClient:[extore client]] ;
                        }
                        else {
                            [bkmxDoc forgetLastPreExportedHashForClient:[extore client]] ;
                        }
												
						[error retain] ;
						[pool drain] ;
						[error autorelease] ;

                        goto end ;
					}
					i++ ;
				}
			}
			
			[pool drain] ;
		}
		[progressView clearAll] ;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
	}


#pragma mark gulpStartainer:::  Gulp-11.  Cleaning up Gulp **********************

end:
        if (traceLevel > 0) {
            logEntry = [[NSString alloc] initWithFormat:@"  Gulp-11.  Cleaning up Gulp\n"] ;
    #if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
    #endif
            [basis trace:logEntry] ;
            [logEntry release] ;
        }
        
    [progressView setIndeterminate:YES
                 withLocalizedVerb:@"Finalizing: Clean Up"
                          priority:SSYProgressPriorityRegular] ;
    [progressView setMaxValue:[destinStarks count]] ;
    [progressView setDoubleValue:0] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;

    if (isAnExporter) {
        [[NSNotificationCenter defaultCenter] removeObserver:[self delegate]
                                                        name:SSYManagedObjectWillUpdateNotification
                                                      object:nil] ;
        // Back in the beginning of this method, we setBkmxDoc: which
        // was needed by our observer method.  It is not needed any more.
        // It is a weak property.  The following may be defensive programming.
        // We don't want to be hanging on to it, in case it closes later.
        [[self delegate] setBkmxDoc:nil] ;
    }
    
	[bkmxDoc setImportedExtores:nil] ;
    if (bkmxDoc == destin) {
        // We're importing, not exporting
        // The following is needed for import clients which provide
        // lastModifiedDate values, such as Firefox, Diigo and XBEL.
        [bkmxDoc finalizeStarksLastModifiedDates] ;
    }
    
	if (traceLevel > 3) {
		logEntry = [[NSString alloc] initWithFormat:@"39200: exportFeedbackDic after finish:\n"] ;
#if LOG_TO_CONSOLE_TOO
		NSLog(@"%@", logEntry) ;
#endif
		[basis trace:logEntry] ;
		[logEntry release] ;
		for (NSString* key in [info objectForKey:constKeyExportFeedbackDic]) {
			logEntry = [[NSString alloc] initWithFormat:@"   key (objectID): %@\n", key] ;
#if LOG_TO_CONSOLE_TOO
			NSLog(@"%@", logEntry) ;
#endif
			[basis trace:logEntry] ;
			[logEntry release] ;
			logEntry = [[NSString alloc] initWithFormat:@"      value: %@\n", [[[info objectForKey:constKeyExportFeedbackDic] objectForKey:key] shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
			NSLog(@"%@", logEntry) ;
#endif
			[basis trace:logEntry] ;
			[logEntry release] ;
		}
		logEntry = [[NSString alloc] initWithFormat:@"39500: re-fetched destin starks after finish: %@\n", [[[destin starker] allStarks] shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
		NSLog(@"%@", logEntry) ;
#endif
		[basis trace:logEntry] ;
		[logEntry release] ;
	}
	
	if (traceLevel > 0) {
		if (error) {
			logEntry = [[NSString alloc] initWithFormat:@"Error was:\n%@", [error longDescription]] ;
#if LOG_TO_CONSOLE_TOO
			NSLog(@"%@", logEntry) ;
#endif
			[basis trace:logEntry] ;
			[logEntry release] ;
		}
		else {
			logEntry = [[NSString alloc] initWithFormat:@"No error.\n"] ;
#if LOG_TO_CONSOLE_TOO
			NSLog(@"%@", logEntry) ;
#endif
			[basis trace:logEntry] ;
			[logEntry release] ;
		}
	}
	
	if (traceLevel > 0) {
		logEntry = [[NSString alloc] initWithFormat:@"-------> Ended Gulp for %@  ok=%ld<------\n\n", [destin displayName], (long)ok] ;
#if LOG_TO_CONSOLE_TOO
		NSLog(@"%@", logEntry) ;
#endif
		[basis trace:logEntry] ;
		[logEntry release] ;
	}
	
	return ok ;
}

    - (void)clearStandinHartainerSharype:(Sharype)sharype
                          hartainersRead:(NSSet*)hartainersRead
                              traceLevel:(NSInteger)traceLevel
                            destinStarks:(NSMutableArray*)destinStarks
                           destinStarker:(Starker*)destinStarker
         readButRemovedHartainerSharypes:(NSMutableSet*)readButRemovedHartainerSharypes {
        Stark* clearedStark = [destinStarker clearStandinHartainerSharype:sharype
                                                               traceLevel:traceLevel] ;
        if (clearedStark) {
            // destStark was cleared/removed
            [destinStarks removeObject:clearedStark];
            NSNumber* sharypeNumber = @(sharype);
            if ([hartainersRead member:sharypeNumber] != nil) {
                [readButRemovedHartainerSharypes addObject:sharypeNumber];
            }
        }
    }

@end
