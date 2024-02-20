- (BOOL)ixternalizeFromStartainer:(NSObject <Startainer, StarkReplicator> *)source
					 toStartainer:(NSObject <Startainer, StarkReplicator> *)destin
							 info:(NSMutableDictionary*)info 
						  error_p:(NSError**)error_p {
	NSInteger logLevel = [[info objectForKey:constKeyLogLevel] intValue] ;
	
	NSSet* siblings = [self isAnInternalizer]
	? [[[self owner] shig] internalizers]
	: [[[self owner] shig] externalizers] ;
	NSString* displayName = [NSString stringWithFormat:
							 @"%@ (%d/%d)",
							 [[self client] displayName],
							 ([[self index] intValue] + 1),  // +1 to change from starting index from 0 to 1
							 [siblings count]] ;	
	
if (logLevel > 0) {
	NSString* what = [self isAnInternalizer] ? @"import" : @"export" ;
	NSLog(@"-------> Beginning %@ for %@ <------", what, displayName) ;
}
	// See flowchart 'Ixternalize.graffle'
	
	// Some basic stuff we'll be using..
	Bkmslf* bkmslf = (Bkmslf*)([source respondsToSelector:@selector(progressView)] ? source : destin) ;
	SSYProgressView* progressView = [bkmslf progressView] ;
	ClientSignature* clientSignature = [[self client] clientSignature] ;
	NSError* error ;
	NSString* verb ;
	
#pragma mark ixternalizeFromStartainer:::  1.  Prepare  **********************
if (logLevel > 0) {
	NSLog(@"   1.  Prepare") ;
}
	
	verb = [NSString stringWithFormat:@"%@ : Fetching (1/4)", displayName] ;
	[progressView setIndeterminate:YES
				 withLocalizedVerb:verb] ;
	// Get starkers
	Starker* sourceStarker = [source starker] ;
	if (!sourceStarker) {
		error = [source safelyPerformSelector:@selector(error)
								   withObject:nil] ;
		if (!error) {
			error = SSYMakeError(21614, @"Could not create source starker") ;
		}
		
		if (error_p) {
			*error_p = error ;
		}
		
		return NO ;
	}	
	Starker* destinStarker = [destin starker] ;
	if (!destinStarker) {
		error = [destin safelyPerformSelector:@selector(error)
								   withObject:nil] ;
		if (!error) {
			error = SSYMakeError(21618, @"Could not create destin starker") ;
		}
		
		if (error_p) {
			*error_p = error ;
		}
		
		return NO ;
	}	
	
	// Since the Bkmslf end of the process supports all attributes,
	// the common attrbutes are simply those of the extore.
	NSSet* commonAttributes = [[[self client] extoreClass] supportedAttributes] ;
	if ([[self fabricateTags] boolValue]) {
		// If importing, our bookmarks will be getting tagged
		// before merging, so we'll need 'tags' in commonAttributes.
		// Likewise if exporting, our bookmarks will need to have
		// tags copied to them so we can create folders from them
		// after merging, so we'll need 'tags' in commonAttributes.
		commonAttributes = [commonAttributes setByAddingObject:constKeyTags] ;
	}
	
	// Local variables we'll be re-using
	Stark* sourceStark ;
	Stark* destinStark ;
	NSInteger i ;
	
	// Due to the vagaries of Core Data, the Extore may not be deallocced
	// when it goes out of scope.  Then, it and its starker may be
	// re-used for subsequent externalizations.  So, In case we're re-using
	// an old starker, we first empty it out.
	// (I may have fixed Extore re-use by releasing it in -[Client didTurnIntoFault], but I'm not sure.)
	Extore* extore_ = [self extore] ;
	[[extore_ starker] deleteAllObjects] ;
	
	// Read data from external store into its emptied starker.
	BOOL ok = [extore readExternalDoingPrereqs] ;
	if (!ok) {
		if (error_p) {
			*error_p = [extore_ error] ;
		}
		
		return NO ;
	}
	
	if ([self isAnInternalizer]) {
		if ([[self doSpecialMapping] boolValue]) {
			[extore_ doSpecialMappingAfterImport] ;
		}
	}
	// Do two fetches to get the two sets of starks that we shall use
	// throughout this method.  We do this to avoid the inefficiency of
	// fetches, and also because the matesXXXX dictionary will key
	// starks by their pointer values which, could be different if they
	// were re-fetched.  Pointer values are also much more compact than
	// managed object identifiers (-objectID), and not subject to change
	// from temporary to permanent if fetches or saves are done.
	NSSet* sourceStarks = [NSSet setWithArray:[sourceStarker allObjects]] ;
	NSSet* destinStarks = [NSSet setWithArray:[destinStarker allObjects]] ;
if (logLevel > 3) {
	NSLog(@"00001: exids for %d sourceStarks:", [sourceStarks count]) ;
	for (Stark* stark in sourceStarks) {
		NSLog(@"%@ %@", [stark exidForClientSignature:clientSignature], [stark shortDescription]) ;
	}
	NSLog(@"00002: %d destinStarks: %@", [destinStarks count], [destinStarks valueForKey:@"shortDescription"]) ;
}
	
	BOOL beginningProduct = ([self isAnExternalizer] || [self isFirstActiveInternalizer]) ;
	BOOL endingProduct = ([self isAnExternalizer] || [self isLastActiveInternalizer]) ;
	
	if (beginningProduct) {
		for (destinStark in destinStarks) {
			[destinStark setSponsorIndex:nil] ;
			if ([destinStark canHaveChildren]) {
				NSArray* correctChildren = [destinStark childrenOrdered] ;
				[destinStark setChildrenTemp:[NSMutableArray arrayWithArray:correctChildren]] ;
				if (!correctChildren || [correctChildren count] == 0) {
					[destinStark setWasChildless] ;
				}
				
				// In case there was an error such as an Ixport Limit being exceeded
				// on a non-last Import Client, the "Clean Transient Children" during
				// Reassign Children will not have run, because it only runs if
				// endingProduct, i.e. after the last Import Client, which will have
				// been skipped due to the error.
				// In the previous section, we did part of Clean Transient Children,
				// with setChildrenTemp:, but sponsoredChildren may still have garbage.
				// Specifically, it will have ghost items with sharype=SharypeDefault,
				// no name, and nil managed object context.  I suppose this happens
				// when the original extore and its transient MOC are released.  Then,
				// in the Reassign Children section, you get an exception raised:
				// Illegal attempt to establish a relationship 'children' between objects in different contexts.
				// This is apparently because the nil moc != the Bkmslf moc.
				// However the user does not see this unless they are watching
				// Console, so they end up with these ghost items which look like
				// empty disclosure triangles.  In Andrew Lyle's case, this puts such
				// an empty item under each real item, and sorting makes them go away.
				// (See Safari+Firefox.old.afterimport.bkmslf).  When I tried to
				// reproduce this, I got only the ghost items.  Weird.
				// But in either case, Sort All gets rid of the ghost items and, in
				// my case, unhides the real items.
				// (Bug fixed in BookMacster 0.9.28)
				[destinStark setSponsoredChildren:nil] ;
			}
		}
		
		[[bkmslf changeLogger] begin] ;
	}			
	[[bkmslf changeLogger] setFrom:self] ;
	
	//  Add a KVO observer to observe when attributes of starks in the
	// transMoc are updated, 
	
	// * We need this when internalizing; otherwise changes of stark
	// attributes such as 'index' will not run postSortMaybeNot, and
	// -needsSort will return NO when in fact sorting is needed.
	// However, we do not need to addObserver here, because this
	// observation is already added in -[Bkmslf initializeCommon].
	
	// * We need this when externalizing, for adding to our SSYModelChangeCounts
	// result, and we need to add it explicitly here.
	
	// Note that we have waited until after the empty transMoc is populated by
	// -[Extore readExternalDoingPrereqs] before doing this, to avoid all
	// the noise which that would generate.
	// We also wait until after [destinStarker allObjects] has been sent.
	// For some reason, that creates alot of notifications for us also,
	// all of them as children are removed one at a time.  I don't understand
	// that.  Oh, well.  Someday I'll look into it.
	
	// Important Note: If added, this observation is removed at the end of this method,
	// so it had better still be active when we get there!
	if ([self isAnExternalizer]) {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(objectWillChangeNote:)
													 name:constNoteWillUpdateObject
												   object:nil] ; // Nil because must observe any stark
	}
	
	BkmxMergeStark mergeStark = [[self mergeStark] shortValue] ;
	BOOL mergeUrl = [[self mergeUrl] boolValue] ;
	
	// Compute whether or not cleanSlate is active in the direction
	// of this ixternalization.
	BOOL doCleanSlate = NO ;
	Bookshig* shig = [[self owner] shig] ;
	NSMutableDictionary* exidFeedbackDic = nil ;
	if ([self isAnExternalizer]) {
		// Look at individual switch for this Externalizer
		doCleanSlate = [[self cleanSlate] boolValue] ;
		// And prepare an empty dictionary to feed back exids from extore to bkmslf
		exidFeedbackDic = [NSMutableDictionary dictionary] ;
		[info setObject:exidFeedbackDic
				 forKey:constKeyExidFeedbackDic] ;
	}
	else if ([self isLastActiveInternalizer]) {
		// Last Internalizer.  Look at document-wide switch.
		if (
			// Clean slate only if Import Clean Slate checkbox is ON
			[[shig cleanSlateOnImport] boolValue]
			) {
			doCleanSlate = YES ;
		}
	}
if (logLevel > 3) {
	NSLog(@"       doCleanSlate = %d", doCleanSlate) ;	
}
	
	// Note that the value of mergeResolutionTags is ignored.  The
	// behavior is hard-wired using the Steve Jobs 80/20 Rule:
	BkmxMergeResolutionTags mergeTagsParm ;
	if ([self isAnInternalizer]) {
		// We're importing
		mergeTagsParm = BkmxMergeResolutionKeepBothTags ;
	}
	else if ([self supportsTags]) {
		// We're exporting to a client that supports tags
		mergeTagsParm = BkmxMergeResolutionKeepSourceTags ;
	}
	else {
		// We're exporting to a client that does not support tags
		mergeTagsParm = BkmxMergeResolutionKeepDestinTags ;
		// The reason for the above is so that the adding of tags
		// which will ultimately not be exported does not cause
		// otherwise-unchanged starks to be counted in 
		// ChangeLogger's updates.
	}
	
#pragma mark ixternalizeFromStartainer:::  2.  Merge  **********************
if (logLevel > 0) {
	NSString* readableMergeStark ;
	switch (mergeStark) {
		case BkmxMergeStarkKeepBoth:
			readableMergeStark = @"Keep Both" ;
			break;
		case BkmxMergeStarkKeepSource:
			readableMergeStark = @"Keep Source" ;
			break;
		case BkmxMergeStarkKeepDestin:
			readableMergeStark = @"Keep Destin" ;
			break;
		default:
			readableMergeStark = @"@@@!!!%%% ERROR %%%!!!@@@" ;			
			break;
	}
	NSLog(@"   2.  Merge with mergeStark = %@", readableMergeStark) ;	
}
	
	NSMutableDictionary* matesKeyedBySource = [[NSMutableDictionary alloc] init] ;
	NSMutableDictionary* matesKeyedByDestin = [[NSMutableDictionary alloc] init] ;	
	// We can pre-compute this for efficiency
	NSDictionary* destinStarksKeyedByExid = [Starker starksKeyedByExidForClientSignature:clientSignature
																			   fromArray:[destinStarks allObjects]] ;
if (logLevel > 3) {
	NSLog(@"      %d destinStarksKeyedByExid:", [destinStarksKeyedByExid count], destinStarksKeyedByExid) ;
	for (NSString* someExid in destinStarksKeyedByExid) {
		Stark* someStark = [destinStarksKeyedByExid objectForKey:someExid] ;
		NSLog(@"            %@: %@", someExid, [someStark shortDescription]) ;
	}
}
	
	NSMutableDictionary* destinHartainers = [NSMutableDictionary dictionary] ;
	for (destinStark in destinStarks) {
		if ([destinStark isHartainer]) {
			NSNumber* sharype = [destinStark sharype] ;
			[destinHartainers setObject:destinStark
								 forKey:sharype] ;
		}
	}
	
	NSDate* now = [NSDate date] ;
	NSMutableSet* newDestinStarks = [NSMutableSet set] ;
	
	verb = [NSString stringWithFormat:@"%@ : Merging (2/4)", displayName] ;
	[progressView setIndeterminate:NO
				 withLocalizedVerb:verb] ;
	[progressView setMaxValue:[sourceStarks count]] ;
	i = 0 ;
	[progressView setDoubleValue:i] ;
	for (sourceStark in sourceStarks) {
		i++ ;
		[progressView incrementDoubleValueBy:1] ;
		
		if ([sourceStark canHaveChildren]) {
			NSSet* children = [sourceStark children] ;
			if (!children || [children count] == 0) {
				[sourceStark setWasChildless] ;
			}
		}
		
		Sharype sharype = [sourceStark sharypeValue] ;
		
		// Try to get destin stark with same exid as source stark
		NSString* exid = [sourceStark exidForClientSignature:clientSignature] ;
		if ([sourceStark isHartainer]) {
			NSNumber* sharype = [sourceStark sharype] ;
			destinStark = [destinHartainers objectForKey:sharype] ;
			
			if (!destinStark) {
				sharype = [NSNumber numberWithSharype:[destin preferredCatchypeValue]] ;
				// Destin will probably have one of its own preferredCatchypeValue hartainers
				destinStark = [destinHartainers objectForKey:sharype] ;
				if (!destinStark) {
					// This will happen when exporting to a destin that does not
					// have, for example, a root, such as Delicious.
					continue ;
				}
				goto thisMateIsOneWayOnly ;
			}
		}
		else {
			// It's a soft Stark of some kind
			
			switch (mergeStark) {
				case BkmxMergeStarkKeepBoth:
					destinStark = nil ;
					break ; 
				case BkmxMergeStarkKeepSource:
				case BkmxMergeStarkKeepDestin:
					// First, try to find a destinStark with the same exid
					destinStark = [destinStarksKeyedByExid objectForKey:exid] ;
					
					if (!destinStark && mergeUrl) {
						// Second, try and find a destinStark with same urlNormalized
						NSMutableArray* candidates = [[NSMutableArray alloc] init] ;
						Stark* chosenCandidate = nil ;
						for (Stark* candidate in destinStarks) {
							// Mark the duplicate by matching this destin stark
							if ([candidate marksSameSiteAs:sourceStark]) {
								[candidates addObject:candidate] ;
							}
						}
						
						if ([candidates count] == 1) {
							chosenCandidate = [candidates objectAtIndex:0] ;
						}
						else if ([candidates count] > 1) {
							// Eliminate those with different parents, identified by exid
							NSString* targetParentExid = [[sourceStark parent] exidForClientSignature:clientSignature] ;
							NSArray* candidates1 = [candidates copy] ;
							for (Stark* candidate in candidates1) {
								if (![NSObject isEqualHandlesNilObject1:targetParentExid
																object2:[[candidate parent] exidForClientSignature:clientSignature]]) {
									[candidates removeObject:candidate] ;
								}
							}
							
							if ([candidates count] == 1) {
								chosenCandidate = [candidates objectAtIndex:0] ;
							}
							else {
								if ([candidates count] < 1) {
									// Retreat to previous copy
									[candidates release] ;
									candidates = [candidates1 mutableCopy] ;
								}
								
								// Eliminate those with different names
								NSString* targetName = [sourceStark name] ;
								NSArray* candidates2 = [candidates copy] ;
								for (Stark* candidate in candidates2) {
									if (![NSObject isEqualHandlesNilObject1:targetName
																	object2:[candidate name]]) {
										[candidates removeObject:candidate] ;
									}
								}
								
								if ([candidates count] >= 1) {
									// That was our last chance.  If still > 1, just take the first
									chosenCandidate = [candidates objectAtIndex:0] ;
								}
								else  {
									// Retreat to previous copy and take first item
									chosenCandidate = [candidates2 objectAtIndex:0] ;
								}
								[candidates2 release] ;
							}
							[candidates1 release] ;
						}	
						[candidates release] ;
						
						// Mark the duplicate by matching this destin stark
						destinStark = chosenCandidate ;
						if (![destinStark exidForClientSignature:clientSignature]) {
							[destinStark setExid:exid
							  forClientSignature:clientSignature] ;
						}
					}
			}
			
			if (destinStark) {
if (logLevel > 3) {
				NSLog(@"33074:\n    Matched source: %@\n         to destin: %@", [sourceStark shortDescription], [destinStark shortDescription]) ;
}
				if (mergeStark == BkmxMergeStarkKeepSource) {
					[destinStark setShouldMirrorSourceMate] ;
				}
			}
			else {
if (logLevel > 3) {
				NSLog(@"33589: No match for exid: %@\n of srcStrk %@", exid, [sourceStark shortDescription]) ;
}				// Could not match destinStark.  Must create a new one
				
				// First, we do two checks to make sure that we want it
				if ([self isAnExternalizer]) {
					if (![extore_ isExportableStark:sourceStark]) {
						// If the sourceStark is not exportable, any
						// destinStark which we would create from it
						// would not be exportable either
if (logLevel > 3) {
						NSLog(@"34596:    Ignoring unexportable.") ;
}
						continue ;
					}
				}
				if ([sourceStark sharypeValue] == SharypeSeparator) {
					if (
						(
						 // For either importing or exporting, we try to
						 // "do what you probably want"
						 (mergeStark != BkmxMergeStarkKeepSource)
						 ||
						 (
						  // In addition, for exporting only, we obey the value
						  // of a checkbox which may unconditionally preclude
						  // importing of separators
						  [self isAnExternalizer]
						  &&
						  (![[self ixportSeparators] boolValue])
						  )
						 )
						) {
if (logLevel > 3) {
						NSLog(@"34268:    Ignoring unwanted separator") ;
}
						continue ;
					}
				}
				
if (logLevel > 3) {
				NSLog(@"35012:    Creating new") ;
}
				destinStark = [destinStarker newStark] ;
				[destinStark setSharype:[NSNumber numberWithSharype:sharype]] ;
				[destinStark setIsNewItem] ;
				
				// By default, we expand all new imported folders.
				// Note that this may be overwritten by the
				// subsequent -overwriteAttributes:mergeTags:fabricateTags:fromStark:
				if ([destinStark canHaveChildren]) {
					[destinStark setIsExpanded:[NSNumber numberWithBool:YES]] ;
				}
				[destinStark setIsShared:[self shareNewItems]] ;
				
				[newDestinStarks addObject:destinStark] ;
			}
			
			[destinStark setSponsorIndex:[self index]] ;
			[destinStark setSponsoredIndex:[sourceStark index]] ;
if (logLevel > 3) {
			NSLog(@"35406:    Did set sponsor for %@", [destinStark shortDescription]) ;
}
			if ([destinStark isNewItemThisClient] || (mergeStark == BkmxMergeStarkKeepSource)) {
				[destinStark overwriteAttributes:commonAttributes
									   mergeTags:mergeTagsParm
								   fabricateTags:[[self fabricateTags] boolValue] 
									   fromStark:sourceStark] ;
			}
			
			// We note in passing that we need not copy
			// exids related to other browsers or files.  This is because, when
			// importing, the only exid we want from the external store, indeed
			// the only one it has, is its own.  Similarly, when exporting, the 
			// external store is interested only in its own exid.
			if ([self isAnInternalizer]) {
				NSString* exid = [sourceStark exidForClientSignature:clientSignature] ;
				if (exid) {
					[destinStark setExid:exid
					  forClientSignature:clientSignature] ;
				}
				else {
					NSLog (@"Internal Error 684-5459.  No exid for %@ in item %@ imported from %@.  Exids are: %@",
						   clientSignature,
						   [sourceStark shortDescription],
						   [source shortDescription],
						   [sourceStark exids]) ;
				}
			}
			else {
				[exidFeedbackDic setObject:sourceStark                // Bkmslf
									forKey:[destinStark objectID]] ;  // Client
			}
			
			if (
				[destin supportsAttribute:constKeyAddDate]
				&&
				![source supportsAttribute:constKeyAddDate]
				&&
				![destinStark addDate]
				) {
				[destinStark setAddDate:now] ;
			}
			
			if (
				[destin supportsAttribute:constKeyLastModifiedDate]
				&&
				![source supportsAttribute:constKeyLastModifiedDate]
				&&
				![destinStark lastModifiedDate]
				) {
				[destinStark setLastModifiedDate:now] ;
			}
		}		
		
		[matesKeyedByDestin setObject:sourceStark
							   forKey:[NSValue valueWithPointer:destinStark]] ;
	thisMateIsOneWayOnly:
		[matesKeyedBySource setObject:destinStark
							   forKey:[NSValue valueWithPointer:sourceStark]] ;
		
	}	
	[progressView clearAll] ;
	
if (logLevel > 3) {
	NSLog(@"10400: %d newDestinStarks after Merge: %@", [newDestinStarks count], [newDestinStarks shortDescription]) ;
}
	
	// Note that we could not have done this immediately upon creating the
	// new stark, because it might not yet have had all of its attributes
	// (url in particular, for Delicious and Google) that are necessary
	// to pass the isExportableStark: test
	for (destinStark in newDestinStarks) {
		if (([self isAnExternalizer] && [extore_ isExportableStark:destinStark]) || [self isAnInternalizer]) {
			[[(Bkmslf*)[self owner] changeLogger] logAddStark:destinStark] ;
		}
	}		
	
	// Note that, due the substitution of preferredCatchypeValue above, matesKeyedBySource
	// may have a few more elements than matesKeyedByDestin, because the preferred
	// catchype object in it may be referenced by more than one key.  But since keys
	// must be unique, and also since I prevent incorrect settings by goto:thisMateIsOneWayOnly,
	// the inverse dictionary matesKeyedBySource will not have these duplicate entries.
	
	
if (logLevel > 3) {
	NSLog(@"11400: destinStarks after Merge: %@", [destinStarks shortDescription]) ;
}
	
#pragma mark ixternalizeFromStartainer:::  3.  Prepare Destin  **********************
if (logLevel > 0) {
	NSLog(@"   3.  Prepare Destin") ;
}
	
	// Clean the destin's slate of unmatched items
	NSMutableSet* survivors = [[NSMutableSet alloc] init] ;
	verb = [NSString stringWithFormat:@"%@ : Preparing Destination (3/4)", displayName] ;
	[progressView setIndeterminate:NO
				 withLocalizedVerb:verb] ;
	[progressView setMaxValue:[destinStarks count]] ;
	i = 0 ;
	[progressView setDoubleValue:i] ;
	
	// If mergeStark == Keep Source, we want the source items first, so destinSponsorIndex = NSNotFound
	// If mergeStark == Keep Destin, we want existing destin items first, so destinSponsorIndex = -1
	// If mergeStark ==   Keep Both, we want existing destin items first, so destinSponsorIndex = -1
	NSNumber* destinSponsorIndex = [NSNumber numberWithInt:(mergeStark == BkmxMergeStarkKeepSource) ? NSNotFound : -1] ;
	
	for (destinStark in destinStarks) {
if (logLevel > 3) {
		NSLog(@"   Considering deletion of %@", [destinStark shortDescription]) ;	
}		
		i++ ;
		[progressView incrementDoubleValueBy:1] ;
		
		BOOL unsponsored = (([destinStark sponsorIndex] == nil) || ([[destinStark sponsorIndex] intValue] == NSNotFound)) ;
if (logLevel > 3) {
		NSLog(@"      unsponsored=%d  isHartainer=%d  isBookmacsterizer=%d", unsponsored, [destinStark isHartainer], [destinStark isBookmacsterizer]) ;	
}		
		BOOL shouldDelete = NO ;
		if (unsponsored) {
			BOOL softShouldClean = (
									doCleanSlate // ==> All unmatched soft starks now in destin should be deleted
									&&
									![destinStark isHartainer]
									&&
									// Don't clean the Bookmacsterizer when importing.
									// This is particularly important during the first import 
									// after just creating an new Bookmarkshelf whose only
									// bookmark is the Bookmacsterizer.
									!([destinStark isBookmacsterizer]  && [self isAnInternalizer])
									) ;
			BOOL unwantedSeparator = (
									  ([destinStark sharypeValue] == SharypeSeparator)
									  &&
									  (
									   (mergeStark != BkmxMergeStarkKeepDestin)
									   ||
									   doCleanSlate
									   )
									  ) ;
if (logLevel > 3) {
			NSLog(@"      softShouldClean=%d  unwantedSeparator=%d", softShouldClean, unwantedSeparator) ;	
}		
			if (softShouldClean || unwantedSeparator) {
				shouldDelete = YES ;
			}
		}
		if (shouldDelete) {
if (logLevel > 3) {
			NSLog(@"      deleting stealthily %@", [destinStark shortDescription]) ;
}
			// We use the "Stealth" method so that the indexes of its siblings
			// do not get changed -- yet. If no stark comes in to replace
			// this one, the required adjustments will be made to sibling
			// indexes in Connect Families.
			// If we did a regular deleteStark: here, then the indexes
			// of its siblings would be changed immediately, adding them
			// to ChangeLogger's updates, when in fact Connect Families
			// may later change its index back to the original value.
			[destinStarker deleteStealthilyStark:destinStark] ;
			[[(Bkmslf*)[self owner] changeLogger] logDeleteStark:destinStark] ;
		}
		else {
if (logLevel > 3) {
			NSLog(@"      Needs to be retained.") ;
}
			// This stark needs to be retained.
			[survivors addObject:destinStark] ;
			
			if (![destinStark isNewItemThisIxport]) {
if (logLevel > 3) {
				NSLog(@"      Is not new this ixport.") ;
}
				// Could just as well use isNewItemThisClient in the above.
				// If hartainer, override destinSponsorIndex so it goes to the top.
				NSNumber* thisSponsorIndex = [destinStark isHartainer] ? [NSNumber numberWithInt:-1] : destinSponsorIndex ;
				
				// The reason for the following if() is in case the destinStark was 
				// matched to a kept (dominant) source stark, it will already have
				// had the sponsor values properly set
				if (![destinStark sponsoredIndex]) {
					[destinStark setSponsoredIndex:[destinStark index]] ;
					[destinStark setSponsorIndex:thisSponsorIndex] ;
if (logLevel > 3) {
					NSLog(@"      Set sponsorIndex=%@, sponsoredIndex=%@", [destinStark sponsorIndex], [destinStark sponsoredIndex]) ;
}
				}
			}
		}
	}
	[progressView clearAll] ;
	
	destinStarks = [NSSet setWithSet:survivors] ;
	[survivors release] ;
	
	// Now that we've cleaned the slate of old destinStarks,
	// we can add in the newDestinStarks
	destinStarks = [destinStarks setByAddingObjectsFromSet:newDestinStarks] ;
	
if (logLevel > 3) {
	NSLog(@"18141: matesKeyedByDestin:") ;
	NSLog(@"     destin      source") ;
	for (NSValue* p in matesKeyedByDestin) {
		NSLog(@"   0x%08x  0x%08x", [p pointerValue], [matesKeyedByDestin objectForKey:p]) ;
	}
	
	NSLog(@"18241: matesKeyedBySource:") ;
	NSLog(@"     source      destin") ;
	for (NSValue* p in matesKeyedBySource) {
		NSLog(@"   0x%08x  0x%08x", [p pointerValue], [matesKeyedBySource objectForKey:p]) ;
	}
	
	NSLog(@"18200: newDestinStarks after Clean Slate: %@", [newDestinStarks shortDescription]) ;
	
	NSLog(@"18400: destinStarks, now including newDestinStarks: %@", [destinStarks shortDescription]) ;
}
	
#pragma mark ixternalizeFromStartainer:::  4.  Identify Families  **********************
if (logLevel > 0) {
	NSLog(@"   4.  Identify Families") ;
}
	
	verb = [NSString stringWithFormat:@"%@ : Finding Relationships (4/4)", displayName] ;
	[progressView setIndeterminate:NO
				 withLocalizedVerb:verb] ;
	[progressView setMaxValue:[destinStarks count]] ;
	i = 0 ;
	[progressView setDoubleValue:i] ;
	Stark* destinRoot = [destinHartainers objectForKey:[NSNumber numberWithSharype:SharypeRoot]] ;
	for (destinStark in destinStarks) {
if (logLevel > 3) {
		NSLog(@"      Identifamiling destin %@", [destinStark shortDescription]) ;
}
		i++ ;
		[progressView incrementDoubleValueBy:1] ;
		
		if ([destinStark correctParentHasMe]) {
			// This must be an ixport consisting of multiple sources, and this
			// destinStark is from a previous source.  Its correctParent has
			// already been assigned, so we just...
if (logLevel > 3) {
			NSLog(@"      correct parent already has: continuing") ;
}
			continue ;
		}
		
		sourceStark = [matesKeyedByDestin objectForKey:[NSValue valueWithPointer:destinStark]] ;
if (logLevel > 3) {
		NSLog(@"         mating sourceStark: %@", [sourceStark shortDescription]) ;
}
		if ([sourceStark sharypeValue] == SharypeRoot) {
			// Root does not have a parent
if (logLevel > 3) {
			NSLog(@"         mating sourceStark is root: continuing") ;
}
			continue ;
		}
		
		Stark* sourceParent = [sourceStark parent] ;
		Stark* correctParent = nil ;
		BOOL headedForRoot = NO ;
		
		/*
		 *** How to reproduce the "Location Oscillate" bug (which was fixed in 0.9.13)
		 * Create a bookmarkshelf using New Bookmarkshelf wizard, Usage Style 2, for Camino and Firefox, with Camino first.
		 * Note that this gives the default Import Merging Keep settings of:
		 *     Keep Client for Camino
		 *     Keep Bkmslf for Firefox
		 * Create a soft folder named "My Folder" in the Bookmarks Bar.
		 * Export
		 * Export (Should be no changes on this second export.)
		 * Launch Firefox
		 * Move "My Folder" from Bar to Menu
		 * Quit Firefox
		 * In Bkmx, Import
		 
		 Expected Result: "My Folder" should stay in Bar, because that's where it is in Camino,
		 where Merging Keep is set to Keep Client, and ignoring the location in Firefox,
		 which is set to Keep Bkmslf.  Also, there should be 0 changes.  Note: If you do this
		 with OmniWeb instead of Firefox, then you will find 1 addition + 1 deletion because of
		 the problem that OmniWeb identifiers are not unique across Bar and Menu; a new item
		 must be created.
		 
		 Actual Result: Moves to Menu.  Import again and again.  Each time, it flips from Bar to Menu or vice versa.
		 
		 * Close the Bookmarkshelf, but don't save, if you want to modify and repeat the test.
		 
		 *** How to reproduce the "No Follow Source Moves" bug (which was fixed in 0.9.21)
		 * Create a bookmarkshelf using New Bookmarkshelf wizard, Usage Style 1, for Firefox.
		 * Note that this gives the default Import Merging Keep settings of:
		 *     Keep Client for Firefox
		 * Create a soft folder named "My Folder" in the Bookmarks Bar.
		 * Export
		 * Launch Firefox
		 * Move "My Folder" from Bar to Menu
		 * Quit Firefox
		 * In Bkmx, Import
		 
		 Expected Result: "My Folder" should move to Menu, as it is in Firefox
		 
		 Actual Result: Stays in Bar.
		 
		 * Close the Bookmarkshelf, but don't save, if you want to modify and repeat the test.
		 
		 */
		
		// Possibly assign a correct  to source location.
		
		// * If the next line is:
		// if (sourceParent) {
		// Moves too much.  You get the "Location Oscillate" bug, described above.
		// This was the original design.
		
		// * If the next line is:
		// if (sourceParent && [destinStark isNewItemThisClient]) {
		// Moves too little.  You get the "No Follow Source Moves" bug, described above.
		// This was the design as of 0.9.13.
		
		// The correct next line moves not too little, not too much, avoiding both bugs
		// This is the design as of 0.9.21.
		if (sourceParent && [destinStark shouldMirrorSourceMate]) {		
			NSValue* sourceParentPointerValue = [NSValue valueWithPointer:sourceParent] ;
			correctParent = [matesKeyedBySource objectForKey:sourceParentPointerValue] ;
if (logLevel > 3) {
			NSLog(@"         did set correctParent via reflection") ;
}
		}
		else if (
				 // currently has no parent
				 ![destinStark parent]
				 &&
				 // is not itself root
				 ([destinStark sharypeValue] != SharypeRoot)
				 &&
				 [destinStark isNewItemThisClient]
				 ) {
			// This stark is headed for root.
			[[destinRoot childrenTemp] addObject:destinStark] ;
			// Mark this in case we are not the last ixport of
			// a multiple-source ixport
			[destinStark setCorrectParentHasMe:YES] ;
			headedForRoot = YES ;
if (logLevel > 3) {
			NSLog(@"         added to root") ;
}
		}
		
		if ([destinStark sharypeValue] != SharypeRoot) {
			if ([correctParent isRoot]) {
				// The following if() is important to filter out starks that
				// are already in the destination.
				// This stark is headed for root directly.
				headedForRoot = YES ;
if (logLevel > 3) {
				NSLog(@"         will add to root") ;
}
			}
		}
		
		if (headedForRoot) {
			if (![destin canBeAtRootStark:destinStark]) {
				correctParent = [destin defaultParentForStark:destinStark] ;
if (logLevel > 3) {
				NSLog(@"         Can't go to root, rerouted to default parent %@", [correctParent name]) ;
}
				[destinStark setSponsoredIndex:[NSNumber numberWithInt:([destinStark indexValue] + ORPHAN_OFFSET)]] ;
			}
		}
		
		if (!correctParent) {
if (logLevel > 3) {
			NSLog(@"         was in destin, not matched, not deleted, parent OK: continuing") ;
}
			// This is an item that was in the destination to begin with,
			// and not matched/sponsored during Merge, and not deleted
			// during Clean Slate, and its correctParent is its current
			// parent.
			// Or else, it is a parentlessDestinStark
			continue ;
		}
		
		Stark* currentParent = [destinStark parent] ;
if (logLevel > 3) {
		NSLog(@"         currentParent  = %@", [currentParent shortDescription]) ;
		NSLog(@"         correctParent  = %@", [correctParent shortDescription]) ;
		NSLog(@"         currentIndex   = %d", [destinStark indexValue]) ;
		NSLog(@"         sponsoredIndex = %d", [[destinStark sponsoredIndex] intValue]) ;
}		
		short needsCorrection = 0 ;
		if (![[currentParent objectID] isEqual:[correctParent objectID]]) {
if (logLevel > 3) {
			NSLog(@"            %@ needs parent correction due to parent", [destinStark name]) ;
}
			needsCorrection = 1 ;
		}
		else if ([destinStark sponsoredIndex]) {
			if (![[destinStark index] isEqual:[destinStark sponsoredIndex]]) {
if (logLevel > 3) {
				NSLog(@"            %@ needs parent correction due to index", [destinStark name]) ;
}
				needsCorrection = 2 ;
			}
		}
		
		if (needsCorrection > 0) {
			if ([correctParent managedObjectContext] != [destinStark managedObjectContext]) {
				NSLog(@"Attempt to do cross-moc relationship!\n   correctParent:%@ owner:%@ moc:%@ ownerOfMoc:%@\n   attempted sponsoredChildObject:%@ owner:%@ moc:%@ ownerOfMoc:%@",
					  [correctParent shortDescription],\
					  [correctParent owner],
					  [correctParent managedObjectContext],
					  [SSYMOCManager ownerOfManagedObjectContext:[correctParent managedObjectContext]],
					  [destinStark shortDescription],
					  [destinStark owner],
					  [destinStark managedObjectContext],
					  [SSYMOCManager ownerOfManagedObjectContext:[destinStark managedObjectContext]]) ;
			}
			else {
				[correctParent addSponsoredChildrenObject:destinStark] ;
			}
			// Mark this in case we are not the last ixport of
			// a multiple-source ixport
			[destinStark setCorrectParentHasMe:YES] ;
			
			// Also need to remove from current parent, lest it may still be in the
			// correctChildrenSet of the old parent, and thus Connect Families
			// might put it in the old parent if it happens to be processed
			// after the correctParent -- behavior is random -- Yikes!!
			if (currentParent) {
				[[currentParent childrenTemp] removeObject:destinStark] ;
			}
			else {
				// It must be in here...
				[[destinRoot childrenTemp] removeObject:destinStark] ;
			}
		}
		
	}	
	[progressView clearAll] ;
	
	
#pragma mark ixternalizeFromStartainer:::  5.  Connect Families  **********************
if (logLevel > 0) {
	NSLog(@"   5.  Connect Families") ;
}
	
	if (endingProduct) {
		// We're into summary mode now, so anything logged from now on
		// is not necessarily from the current client/ixternalizer/self
		[[bkmslf changeLogger] setFrom:nil] ;
		
		// Progress is shown a indeterminate because
		// just incrementing with each stark as it is correct children area added
		// can be too erratic if, for example, you have a folder
		// containing 100 correct children -- Progress will just stop
		// at that point for a second or so.
		
		// Create sort descriptors to sort first by sponsor, then sponsoredIndex
		NSSortDescriptor* sd1 = [[NSSortDescriptor alloc] initWithKey:constKeySponsorIndex
															ascending:YES] ;
		NSSortDescriptor* sd2 = [[NSSortDescriptor alloc] initWithKey:constKeySponsoredIndex
															ascending:YES] ;
		NSArray* sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil] ;
		[sd1 release] ;
		[sd2 release] ;
		
		verb = [NSString stringWithFormat:@"Finishing: Connecting Relationships"] ;
		[progressView setIndeterminate:NO
					 withLocalizedVerb:verb] ;
		[progressView setMaxValue:[destinStarks count]] ;
		[progressView setDoubleValue:0] ;
		for (Stark* parent in destinStarks) {
if (logLevel > 3) {
			NSLog(@"         Connecting parent: %@", [parent shortDescription]) ;
}
			[progressView incrementDoubleValueBy:1] ;
			NSSet* sponsoredChildren = [parent sponsoredChildren] ;
			
			// Start with childrenTemp, and immediately eliminate
			// children that were cleaned off the slate.
			NSMutableArray* correctChildren = [NSMutableArray array] ;
			for (Stark* child in [parent childrenTemp]) {
				if ([destinStarks member:child]) {
					[correctChildren addObject:child] ;
				}
			}
			[parent setChildrenTemp:correctChildren] ;
			
			[correctChildren addObjectsFromArray:[sponsoredChildren allObjects]] ;
			
			[correctChildren sortUsingDescriptors:sortDescriptors] ;
			
			NSInteger i = 0 ;
			for (Stark* child in correctChildren) {
				[child setIndexValue:i++] ;
			}
			
if (logLevel > 3) {
			NSLog(@"            correctChildren: %@", [correctChildren shortDescription]) ;
}
		}	
		[progressView clearAll] ;
	}
	
if (logLevel > 3) {
	NSLog(@"28400: destinStarks after Connect Families:") ;
	{
		for (Stark* stark in destinStarks) {
			NSLog(@"   %@", [stark shortDescription]) ; }
	}	
}
	
#pragma mark ixternalizeFromStartainer:::  6.  Reassign Children  **********************
if (logLevel > 0) {
	NSLog(@"   6.  Reassign Children") ;
}
	
	if (endingProduct) {
		verb = [NSString stringWithFormat:@"Finishing: Reassign Children"] ;
		[progressView setIndeterminate:NO
					 withLocalizedVerb:verb] ;
		[progressView setMaxValue:[destinStarks count]] ;
		[progressView setDoubleValue:0] ;
		for (destinStark in destinStarks) {
			[progressView incrementDoubleValueBy:1] ;
			if (![destinStark canHaveChildren]) {
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
if (logLevel > 3) {
				NSLog(@"Corr-children for %@ in moc %p", [destinStark shortDescription], [destinStark managedObjectContext]) ;
				for (Stark* child in correctChildren) {
					NSLog(@"  corr-child %@, %@ from moc %p owned by %@",
						  [child className],
						  [child name],
						  [child managedObjectContext],
						  [SSYMOCManager ownerOfManagedObjectContext:[child managedObjectContext]]) ;
				}
}				
				///*DB?Line*/ NSLog(@"68003: Into destinStark: %@\nSetting children:\n%@", [destinStark shortDescription], [correctChildren shortDescription]) ;
				[destinStark setChildren:[NSSet setWithArray:correctChildren]] ;
				/*			[destinStark removeAllChildren] ;
				 NSInteger j = 0 ;
				 for (Stark* stark in correctChildren) {
				 if (logLevel > 3) {
				 NSLog(@"            Adopting: %@", [stark shortDescription]) ;
				 }
				 [stark moveToBkmxParent:destinStark
				 atIndex:j] ;
				 j++ ;
				 }
				 */			
			}
			
			// Clean Transient Children
			// This is just to be neat.  We also do it in section 1
			// because this may not always run.  See explanation of
			// "Clean Transient Children" above.
			[destinStark setSponsoredChildren:nil] ;
			[destinStark setChildrenTemp:nil] ;
		}
		[progressView clearAll] ;
	}		
	
#pragma mark ixternalizeFromStartainer:::  7.  Fabricate Folders  **********************
if (logLevel > 0) {
	NSLog(@"   7.  Fabricate Folders") ;
}
	
	if ([[self fabricateFolders] shortValue] > BkmxFabricateFoldersOff) {
		verb = [NSString stringWithFormat:@"Finishing: Fabricate Folders"] ;
		[progressView setIndeterminate:NO
					 withLocalizedVerb:verb] ;
		[progressView setMaxValue:[destinStarks count]] ;
		[progressView setDoubleValue:0] ;
		for (destinStark in destinStarks) {
			[progressView incrementDoubleValueBy:1] ;
			[destinStark fabricateFolders:[self fabricateFolders]] ;
		}
		[progressView clearAll] ;
	}			
	
	
#pragma mark ixternalizeFromStartainer:::  8.  Merge Folders **********************
if (logLevel > 0) {
	NSLog(@"   8.  Merge Folders") ;
}
	
	if (endingProduct) {
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
		if (mergeStark != BkmxMergeStarkKeepBoth) {
			[progressView setIndeterminate:NO
						 withLocalizedVerb:@"Finishing: Merge Folders"] ;
			[progressView setMaxValue:nTotalChildren] ;
			[progressView setDoubleValue:0] ;
			[destinRoot recursivelyPerformSelector:@selector(mergeFoldersWithProgressView:keepSource:)
										withObject:progressView
										withObject:[NSNumber numberWithBool:(mergeStark == BkmxMergeStarkKeepSource)]] ;
			[progressView clearAll] ;
		}
	}
	
	
#pragma mark ixternalizeFromStartainer:::  8.  Merge Folders **********************
if (logLevel > 0) {
	NSLog(@"   9.  Delete Empty Folders") ;
}
	
	if (endingProduct) {
		// Delete destin container starks which became childless
		[[bkmslf changeLogger] setFrom:@"Delete Empty Folders"] ;
		
		verb = [NSString stringWithFormat:@"Finishing: Delete Empty Folders"] ;
		[progressView setIndeterminate:NO
					 withLocalizedVerb:verb] ;
		[progressView setMaxValue:[destinStarks count]] ;
		[progressView setDoubleValue:0] ;
		for (destinStark in destinStarks) {
			if ([destinStark canHaveChildren]) {
if (logLevel > 3) {
				NSLog(@"38210:    Considering %@", [destinStark shortDescription]) ;
}
				[progressView incrementDoubleValueBy:1] ;
				if ([destinStark numberOfChildren] == 0) {
					if (![destinStark wasChildless]) {
						if (![destinStark isHartainer]) {
							sourceStark = [matesKeyedByDestin objectForKey:[NSValue valueWithPointer:destinStark]] ;
							if (
								!sourceStark
								||
								(sourceStark && ![sourceStark wasChildless])
								) {
if (logLevel > 3) {
								NSLog(@"38250:       Deleting it.") ;
}
								[[bkmslf changeLogger] logDeleteStark:destinStark] ;
								// Note that the following method will also adjust indexes
								// of siblings as necessary.
								[destinStarker deleteStark:destinStark] ;
							}
						}
					}
				}
			}
		}
		[progressView clearAll] ;
		
		// Probably not needed, but just in case I add something later in this method
		[[bkmslf changeLogger] setFrom:nil] ;
	}
	
	
#pragma mark ixternalizeFromStartainer:::  9a.  Integrity Test **********************
if (logLevel > 0) {
	NSLog(@"  9a.  Integrity Test") ;
}
	
	if (endingProduct) {
		[progressView setIndeterminate:NO
					 withLocalizedVerb:@"Final Integrity Test"] ;
		[progressView setMaxValue:[destinStarks count]] ;
		[progressView setDoubleValue:0] ;
		for (destinStark in destinStarks) {
			if ([destinStark canHaveChildren]) {
				NSArray* children = [destinStark childrenOrdered] ;
				NSInteger i = 0 ;
				for (Stark* child in children) {
					NSInteger childIndexValue = [child indexValue] ;
					if (childIndexValue != i) {
						error = SSYMakeError(57460, @"Indexes in merged result failed continuity test") ;
						NSString* msg = @"This is an internal error caused by a rarely-triggerred bug in BookMacster that we've been hunting for." ;
						error = [error errorByAddingLocalizedFailureReason:msg] ;
						msg = [NSString stringWithFormat:@"Please click the life-preserver icon and send to sheepsystems.com.  "
							   @"If possible, try and preserve this Bookmarkshelf and bookmarks in %@ until you hear from us.",
							   [[self client] displayName]] ;
						error = [error errorByAddingLocalizedRecoverySuggestion:msg] ;
						error = [error errorByAddingUserInfoObject:[NSNumber numberWithInt:i]
															forKey:@"Index, expected"] ;
						error = [error errorByAddingUserInfoObject:[NSNumber numberWithInt:childIndexValue]
															forKey:@"Index, actual"] ;
						error = [error errorByAddingUserInfoObject:[destinStark description]
															forKey:@"Parent"] ;
						error = [error errorByAddingUserInfoObject:[children shortDescription]
															forKey:@"Children"] ;
						if (error_p) {
							*error_p = error ;
						}
						
						return NO ;
					}
					i++ ;
				}
			}
			[progressView incrementDoubleValueBy:1] ;
		}
		[progressView clearAll] ;
	}
	
	
#pragma mark ixternalizeFromStartainer:::  10.  Clearing Temporary Flags **********************
if (logLevel > 0) {
	NSLog(@"   10.  Clearing Temporary Flags") ;
}
	
	[progressView setIndeterminate:NO
				 withLocalizedVerb:@"Clearing Temporary Flags"] ;
	for (destinStark in destinStarks) {
		// Re-set transient attributes that we don't
		// want to affect any subsequent client, or ixport.
		if (endingProduct) {
			// These attributes not persistent but still might affect
			// subsequent ixports until the document is closed:
			[destinStark setSponsorIndex:nil] ;    
			[destinStark setSponsoredIndex:nil] ;
			[destinStark clearIxternalizeFlags] ;
		}
		else {
			[destinStark clearThisClientFlags] ;
		}
	}	
	[progressView clearAll] ;
	
	if ([self isAnExternalizer]) {		
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:constNoteWillUpdateObject
													  object:nil] ;
	}
	
#pragma mark ixternalizeFromStartainer:::  11.  Cleanup **********************
if (logLevel > 0) {
	NSLog(@"  11.  Cleanup") ;
}	
	
	[matesKeyedBySource release] ;
	[matesKeyedByDestin release] ;
	
if (logLevel > 3) {
	NSLog(@"38300: exidFeedbackDic after finish:") ;
	for (NSString* key in [info objectForKey:constKeyExidFeedbackDic]) {
		NSLog(@"   key (objectID): %@", key) ;
		NSLog(@"      value: %@", [[[info objectForKey:constKeyExidFeedbackDic] objectForKey:key] shortDescription]) ;
	}
	NSLog(@"39500: re-fetched destinStarks after finish: %@", [[[destin starker] allObjects] shortDescription]) ;
}
	
if (logLevel > 0) {
	NSLog (@"-------< Completed %@ for %@ >-------", what, displayName) ;
}
	return YES ;
}

