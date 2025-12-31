#import "Bkmxwork/Bkmxwork-Swift.h"
#import "BkmxAppDel.h"
#import "BkmxBasis+Strings.h"
#import "ContentDataSource.h"
#import "Starker.h"
#import "BkmxDoc.h"
#import "SSMoveableToolTip.h"
#import "NSString+LocalizeSSY.h"
#import "SSYWeblocGuy.h"
#import "NSString+SSYExtraUtils.h"
#import "StarkTableColumn.h"
#import "NSDate+NiceFormats.h"
#import "BkmxArrayCategories.h"
#import "StarkEditor.h"
#import "Stark+Sorting.h"
#import "NSNumber+Sharype.h"
#import "NSArray+Stringing.h"
#import "ContentOutlineView.h"
#import "ExtoreSafari.h"
#import "BkmxDocWinCon.h"
#import "CntntViewController.h"
#import "NSArray+SSYDisjoint.h"
#import "NSObject+MoreDescriptions.h"
#import "NSFileManager+SomeMore.h"
#import "NSArray+SSYPathUtils.h"
#import "NSInvocation+Quick.h"
#import "CntntViewController.h"

// Global data objects
extern NSString* RPTokenControlPasteboardTypeTokens ;
extern NSString* RPTokenControlPasteboardTypeTabularTokens ;
extern NSString* RPTokenControlPasteboardTypeRepresentedObjects;
#warning Shouldn't that be in RPTokenControl.h????

@implementation ContentDataSource

#pragma mark * Accessors

@synthesize filterString = m_filterString ;
@synthesize filterDays = m_filterDays ;
@synthesize filterTags = m_filterTags ;
@synthesize filterTagsLogic = m_filterTagsLogic ;
@synthesize filterAnnunciation = m_filterAnnunciation ;
@synthesize flatSortKey = m_flatSortKey ;
@synthesize flatSortAscending = m_flatSortAscending ;

- (id)initWithDocument:(BkmxDoc*)document_ {
    self = [super initWithDocument:document_] ;
    
    if (self != 0)  {
        /* Until BkmkMghrs 3.0.8, the following line specified selector
         -objectsChangedNote (past tense) to observation of
         SSYManagedObjectWillUpdateNotification (future tens).  As a result,
         -objectsChangedNote and consequently -noteChangedChildrenForStark:
         and consequently -[NSOutlineView reloadItem:reloadChildren:] got
         called before the children were changed, resulting in either nameless
         items or mushed-together items in the outline view.
         
         Example to demo the bug: Create a document with three bookmarks at
         root, no hartainers, no clients.  Click to tab Settings > Clients and
         add Firefox as a Client.  This will also add the 3 hartainers inherent
         in Firefox.  Now click back to the Content tab.  One of the three
         bookmarks will have disappeared because it was mushedd with the
         last of the 3 hartainers that were added, because the ContentProxy
         children of root were rebuilt before the last hartainer was added.
         If you then try any further editing in that Content, things go
         downhill from there because of the mushed items.  */
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(objectsChangedNote:)
                                                     name:SSYManagedObjectDidUpdateNotification
                                                   object:nil] ;
        
        // By default, sort ascending by name
        [self setFlatSortKey:constKeyName] ;
        [self setFlatSortAscending:YES] ;
    }
    
    return self ;
}

- (void)objectsChangedNote:(NSNotification*)note {
    NSString* changedKey = [[note userInfo] objectForKey:constKeySSYChangedKey] ;
    Stark* stark = [note object] ;
    if ([stark respondsToSelector:@selector(owner)]) {
        if ([stark owner] == [self document]) {
            if ([changedKey isEqualToString:constKeyChildren]) {
                [self noteChangedChildrenForStark:stark] ;
            }
        }
    }
}

- (void)invalidateFlatCache {
	[flatCache release] ;
	flatCache = nil ;
}

+ (Sharype)sharypesMaskForSearchForSharypesSet:(NSSet *)searchForSharypes {
    Sharype mask = 0 ;
	if([searchForSharypes member:[NSNumber numberWithSharype:SharypeCoarseLeaf]] != nil) {
		mask += SharypeCoarseLeaf ;
	}
	if([searchForSharypes member:[NSNumber numberWithSharype:SharypeGeneralContainer]] != nil) {
		mask += SharypeGeneralContainer ;
	}
    return mask;
}

- (Sharype)flatSharypesMask {
	BkmxDocWinCon* bkmxDocWinCon = [[self document] bkmxDocWinCon] ;
	NSSet* searchForSharypes = [bkmxDocWinCon autosavedSearchValueForKey:constAutosaveSearchFor] ;
	return [StarkTyper sharypesMaskForSearchForSharypesSet:searchForSharypes] ;
}

- (void)refreshFilterAnnunciationForOutlineMode:(BOOL)mode {
	NSString* annunciation = @"" ;
	
	if (!mode) { 
		NSString* candidates ;
		Sharype sharypesMask = [self flatSharypesMask] ;
		if ((sharypesMask & SharypeCoarseLeaf) != 0) {
			if ((sharypesMask & SharypeGeneralContainer) != 0) {
				// Both
				NSArray* array = [NSArray arrayWithObjects:
								  [[BkmxBasis sharedBasis] labelBookmarks],
								  [[BkmxBasis sharedBasis] labelFolders],
								  nil] ;
				candidates = [array listValuesForKey:@"self"
										 conjunction:@"&"
										  truncateTo:0] ;
			}
			else {
				// Bookmarks only
				candidates = [[BkmxBasis sharedBasis] labelBookmarks] ;
			}
		}
		else if ((sharypesMask & SharypeGeneralContainer) != 0) {
			// Folders only
			candidates = [[BkmxBasis sharedBasis] labelFolders] ;
		}
		else {
			// Neither
			candidates = nil ;
		}
		
		if (candidates) {
			NSString* stringCriteria = nil ;
			
			NSString* filterString = [self filterString] ;
            NSNumber* filterDays = [self filterDays] ;
			if ([filterString length] > 0) {
				BkmxDocWinCon* bkmxDocWinCon = [[self document] bkmxDocWinCon] ;
				NSSet* searchInAttributes = [bkmxDocWinCon autosavedSearchValueForKey:constAutosaveSearchIn] ;
				if ([searchInAttributes count] > 0) {
					// If there is a programming error and -bkmxAttributeDisplayName returns nil
					// for one of the searchInAttributes, listValuesForKey:conjunction:truncateTo:
					// will omit the corresponding item in the returned attributeString.
					// Thus, we have acceptable defensive programming here.
					NSString* attributeString = [[searchInAttributes allObjects] listValuesForKey:@"bkmxAttributeDisplayName"
																					  conjunction:[NSString localize:@"filterRuleOr"]
																					   truncateTo:0] ;				
					if ([attributeString length] > 0) {
						stringCriteria = [NSString localizeFormat:
										  @"filterRuleTextInX2",
										  filterString,
										  attributeString] ;
					}
				}
			}
            else if (filterDays) {
                stringCriteria = [NSString stringWithFormat:@"touched in last %ld days", (long)[filterDays integerValue]] ;
            }
			
			NSString* tagsCriteria = nil ;
			NSInteger filterLogic = [self filterTagsLogic] ;
			NSArray* filterTags = [[[self filterTags] allObjects] valueForKey:constKeyString];
			if ((filterLogic > 0) && ([filterTags count] > 0)) {
				NSString* conjunctionKey = (filterLogic == 1) ? @"filterRuleOr" : @"filterRuleAnd" ;
				NSString* tagsList = [filterTags listValuesForKey:@"doublequote"
													  conjunction:[NSString localize:conjunctionKey]
													   truncateTo:0] ;
				tagsCriteria = [NSString localizeFormat:
								@"taggedX",
								tagsList] ;
			}
			
			// Combine stringCriteria and/or tagsCriteria into one string
			NSString* criteria ;
			if (stringCriteria) {
				if (tagsCriteria) {
					// Both string and tags criteria
					criteria = [NSString stringWithFormat:
								@"%@ %@ %@",
								stringCriteria,
								[NSString localize:@"filterRuleAnd"],
								tagsCriteria] ;
				}
				else {
					// String criteria only
					criteria = stringCriteria ;
				}
			}
			else if (tagsCriteria) {
				// Tags criteria only
				criteria = tagsCriteria ;
			}
			else {
				// Neither criteria
				criteria = nil ;
			}
			
			// Assemble the final result
			if (criteria) {
				annunciation = [NSString stringWithFormat:
								@"%@ %@",
								candidates,
								criteria] ;
			}
			else {
				annunciation = [NSString localizeFormat:
								@"allX",
								candidates] ;
			}
		}
		else {
			// This should never happen because the Quick Search's menu
			// logic requires that either "Bookmarks" or "Folders" be
			// checked on
			NSLog(@"Internal Error 211-0974") ;
			annunciation = @"Error no Search For in Quick Search" ;
		}
	}
	
	[self setFilterAnnunciation:annunciation] ;
}

- (NSArray*)flatCache {
	if (!flatCache) {
		Sharype sharypesMask = [self flatSharypesMask] ;

		BkmxDocWinCon* bkmxDocWinCon = [[self document] bkmxDocWinCon] ;
		NSSet* searchInAttributes = [bkmxDocWinCon autosavedSearchValueForKey:constAutosaveSearchIn] ;
        NSSet* searchOptions = [bkmxDocWinCon autosavedSearchValueForKey:constAutosaveSearchOptions] ;
        BOOL caseSensitive = [searchOptions member:constKeyCaseSensitive] != nil ;
        BOOL wholeWords = [searchOptions member:constKeyWholeWords] != nil ;
        NSString* searchString = [self filterString] ;
        NSNumber* searchDays = [self filterDays] ;
        NSSet* filterTags = [self filterTags] ;
        NSInteger filterTagsLogic = [self filterTagsLogic] ;
		Stark* root = [[[self document] starker] root] ;

        flatCache = [root descendantsFilteredSortedWithSharypesMask:sharypesMask
                                                       searchString:searchString
                                                         searchDays:searchDays
                                                   stringSearchKeys:searchInAttributes
                                                      caseSensitive:caseSensitive
                                                         wholeWords:wholeWords
                                                            sortKey:[self flatSortKey]
                                                      sortAscending:[self flatSortAscending]
                                                       matchingTags:filterTags
                                                              logic:filterTagsLogic] ;
#if 0
        NSMutableString* nfc = [[NSMutableString alloc] initWithFormat:@"Created new flatCache ascending=%hhd:", [self flatSortAscending]] ;
        for (Stark* stark in flatCache) {
            [nfc appendFormat:
             @"\n%@ %@",
             [stark.addDate geekDateTimeString], stark.name] ;
        }
        NSLog(@"%@", nfc) ;
#endif
		[flatCache retain] ;
	}
	
	return flatCache ;
}

- (ContentProxy*)proxyForStark:(Stark *)stark {
    ContentProxy* proxy = nil ;
    /* This method will also be invoked during the "Gulp" phase of an import
     operation, while parents and children are being connected, because of
     the notification resulting from those connections.  During that
     phase, some starks may not have parents yet, and in that case the loop
     below which finds the index path will return a single zero ({0}), and
     the proxy for that will be found to be the first child of root (usually
     Bookmarks Bar) which, of course is wrong.  We detect those cases with
     the following test and, in addition to avoiding much fruitless work,
     return nil, a more reasonable answer.  Actually, it does not matter what
     we return during this phase, because it is followed by a full reload
     later, after all of the parents and children are connected.  */
#if DEBUG
    NSInteger nLoops = 0 ;
    NSArray* indexPathCopy = nil ;
    NSInteger breakType = -1 ;
#endif
    if ([stark isRoot] || [stark parent]) {
        if (stark) {
            if ([[[self document] bkmxDocWinCon] outlineMode]) {
                /* Although this would seem to be a natural for NSIndexPath,
                 I'll need a reverse enumeration, and NSIndexPath does not
                 support that.  NSArray does support a reverse enumerator. */
                NSMutableArray* indexPath = [[NSMutableArray alloc] init] ;
                /* indexPath[0] shall be the *innermost* index. */

                Stark* starkInLoop = stark ;
                while (YES) {
#if DEBUG
                    nLoops++ ;
#endif
                    if (![starkInLoop isRoot] && [starkInLoop index]) {
                        [indexPath addObject:[starkInLoop index]] ;
                    }
                    else {
#if DEBUG
                        breakType = 1 ;
#endif
                        break ;
                    }
                    starkInLoop = [starkInLoop parent] ;
                    if (!starkInLoop) {
#if DEBUG
                        breakType = 2 ;
#endif
                        break ;
                    }
                }
            
#if DEBUG
                indexPathCopy = [NSArray arrayWithArray:indexPath] ;
#endif
                for (NSNumber* index in [indexPath reverseObjectEnumerator]) {
                    NSInteger indexValue = [index integerValue] ;
                    if (![proxy isKindOfClass:[ContentProxy class]]) {
                        if (indexValue < [m_rootProxies count]) {
                            proxy = [m_rootProxies objectAtIndex:indexValue] ;
                        }
                        else {
                            /* This can happen after an object has been added and its
                             parents' proxy has been removed:
                             #2	0x0000000100075c60 in -[ContentDataSource proxyForStark:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/ContentDataSource.m:232
                             #3	0x000000010007a606 in -[ContentOutlineView rowForItem:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/ContentOutlineView.m:475
                             #4	0x0000000100053887 in -[BkmxOutlineView selectObjects:byExtendingSelection:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxOutlineView.m:143
                             #5	0x0000000100079b5f in -[ContentOutlineView reloadData] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/ContentOutlineView.m:327
                             #6	0x00000001002fec99 in -[CntntViewController reload] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/CntntViewController.m:1029
                             #7	0x000000010010cb0a in -[BkmxDocWinCon reloadContent] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxDocWinCon.m:2448
                             #8	0x000000010010cb3b in -[BkmxDocWinCon reloadAll] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxDocWinCon.m:2452
                             #9	0x00000001001c6264 in +[StarkEditor parentingAction:items:newParent:newIndex:revealDestin:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/StarkEditor.m:507
                             #10	0x0000000100079570 in -[ContentOutlineView paste:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/ContentOutlineView.m:218  */
                        }
                        if (![proxy isKindOfClass:[ContentProxy class]]) {
                            // This can happen if proxy has been invalidated by
                            // -checkAllProxies
                        }
                    }
                    else {
                        proxy = (ContentProxy*)[proxy childAt:indexValue] ;
                    }
                   
                   if (!proxy) {
                       break ;
                   }
                }

                [indexPath release] ;
            }
            else {
                // Unfortunately, in Table Mode we do not have the hierarchy to
                // guide us.  So we must do a brute force search.
                for (ContentProxy* aProxy in m_rootProxies) {
                    // In development, I've see here that aProxy can be an
                    // SSYDisjoiningPlaceholder, which does not respond to -stark.
                    if ([aProxy isKindOfClass:[ContentProxy class]]) {
                        if ([aProxy stark] == stark) {
                            proxy = aProxy ;
                        }
                    }
                }
            }
        }
    }

#if DEBUG
    if (proxy) {
        if ([proxy respondsToSelector:@selector(stark)]) {
            if (([[proxy stark] managedObjectContext] == [stark managedObjectContext]) && [proxy stark] != stark) {
                NSLog(@"Maybe Warning 526-9480 Expected %@, got %@ after %ld loops, bt=%ld, path: %@",
                      [stark name],
                      [[proxy stark] name],
                      (long)nLoops,
                      (long)breakType,
                      indexPathCopy) ;
                /* Comparing managed object contexts was added because, after
                 dragging in starks from another document, [proxy stark] may be
                 nil, or its managed object context may be of the source
                 document.  
                 
                 This branch may still occur when initially configuring a new
                 Synmkark document and importing from Firefox after
                 Reset & Start Over. */
            }
        }
        else {
            NSString* starkName = nil;
            if ([proxy respondsToSelector:@selector(stark)]) {
                starkName = [[proxy stark] name];
            } else {
                starkName = [NSString stringWithFormat:
                             @"instance of %@",
                             [proxy className]];
            }
            NSLog(@"Internal Error 526-9481 Expected %@,got %@ after %ld loops, bt=%ld, path: %@",
                  [stark name],
                  starkName,
                  (long)nLoops, (long)breakType, indexPathCopy);
        }
    }
#endif

    return proxy ;
}

- (NSArray*)rootProxies {
    return m_rootProxies ;
}

- (void)checkAllProxies {
    Stark* rootStark = self.document.starker.root ;
    NSInteger i = 0 ;
    NSInteger nRootChildren = [rootStark numberOfChildren] ;
    for (ContentProxy* proxy in m_rootProxies) {
        if (i > nRootChildren) {
            break ;
        }
        if ([proxy respondsToSelector:@selector(setStark:)]) {
            [proxy setStark:[rootStark childAtIndex:i]] ;
            [proxy ensureDeeplyAndRegardlessly] ;
            i++ ;
        }
        else {
            /* proxy may be a SSYDisjoiningPlaceholder object.  I'm not sure
             how this happens, but I'm not sure how much of anything happens
             in this very complicated data source! */
        }
    }
    
    if (!m_rootProxies) {
        m_rootProxies = [[NSMutableArray alloc] init] ;
    }
    
    /* The remainder of this method implements most of the algorithm described
     and also implemented in -[ContentProxy ensureValuesDeeply:regardless:] */

    i = 0 ;
    NSArray* rootChildren ;
    if (self.document.bkmxDocWinCon.outlineMode) {
        rootChildren = [rootStark childrenOrdered] ;
    }
    else {
        rootChildren = [self flatCache] ;
    }

    for (Stark* childStark in rootChildren) {
        ContentProxy* childProxy = nil ;
        if (i < [m_rootProxies count]) {
            childProxy = [m_rootProxies objectAtIndex:i] ;
        }
        if (!childProxy  || ![childProxy isKindOfClass:[ContentProxy class]]) {
            childProxy = [[ContentProxy alloc] init] ;
            [m_rootProxies putObject:childProxy
                             atIndex:i] ;
            [childProxy release] ;
        }
        if ([childProxy stark] != childStark) {
            [childProxy setStark:childStark] ;
        }
        if ([childProxy index] != i) {
            [childProxy setIndex:i] ;
        }
        
        i++ ;
    }
    // Mark any remaining children as dirty
    for ( ; i<[m_rootProxies count]; i++) {
        ContentProxy* dirtyChild = [m_rootProxies objectAtIndex:i] ;
        // Test in case dirtyChild is a SSYDisjoiningPlaceholder
        if ([dirtyChild respondsToSelector:@selector(noteChangedChildren)]) {
            [dirtyChild noteChangedChildren];
        }
    }
}

- (void)clearProxies {
    [m_proxies removeAllObjects] ;
    [m_rootProxies removeAllObjects] ;
}

- (void)noteChangedChildrenForStark:(Stark*)stark {
    if (stark) {
        if ([[[self document] bkmxDocWinCon] outlineMode]) {
            ContentProxy* proxy = [self proxyForStark:stark] ;
            [proxy noteChangedChildren] ;
            if (!proxy) {
                if ([stark isRoot]) {
                    // Stark is root
                    [m_rootProxies removeAllObjects] ;
                    
                    /* The following is necessary to stop rare(?) crashes when
                     creating a new .bmco importing from Safari only when
                     Safari bookmarks are Crash20140201-Safari-Bookmarks.plist
                     only in macOS 10.9.5.  I don't know what is special about
                     this situation that makes his an edge case of some kind;
                     in other words, I don't know why it doesn't crash all the
                     time here after creating a new document.  (The problem was
                     that when the import occurred, -noteChangedChildreForStark:
                     was invoked with Root as parameter, which caused its proxy
                     children Bar, Menu and Unfiled to be deallocced, but these
                     proxies were soon after referenced by one of the four data
                     source methods, because data had not been reloaded.)
                     
                     I have not analyzed what is the correct reload
                     incantation to use here, because it is difficult to
                     understand.  Instead, I did tests with three likely
                     candidates:
                     • -reloadData : Works but generates about 7x more crap
                     in console thwn I log reloads, ContentProxy inits and
                     deallocs, than the chosen incantation.  So I presume it
                     is less performant than the chosen incantation.
                     • -reloadItem:nil reloadChildren:NO : Still crashes. 
                     Here is the chosen incantation: */
                    [[(BkmxDocWinCon*)[[self document] bkmxDocWinCon] contentOutlineView] reloadItem:nil
                                                                                      reloadChildren:YES] ;
                }
            }
        }
        else {
            [m_rootProxies removeAllObjects] ;
        }
    }
    else {
        // This can happen if a folder is deleted.
    }
}

#pragma mark * Data Source Protocol Methods

- (NSInteger)   outlineView:(NSOutlineView*)outlineView
     numberOfChildrenOfItem:(ContentProxy*)proxy {
    Stark* stark = [proxy stark] ;
    
	NSInteger numberOfChildren ;

	if ([[[self document] bkmxDocWinCon] outlineMode]) {
		// We are displaying folders (hierarchical view)
		if (!stark) {
			stark = [[[self document] starker] root] ;
		}
		
		numberOfChildren = [stark numberOfChildren] ;
	}
	else {
		// We are not displaying folders (flat view)
		if (!stark) {
			// They want the number of children of root
			numberOfChildren = [[self flatCache] count] ;
		}
		else {
			// We do not display children of non-root when in flat mode
			numberOfChildren = 0 ;
		}
	}

	return numberOfChildren ;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
   isItemExpandable:(ContentProxy*)proxy {
    Stark* stark = [proxy stark] ;
    BOOL answer ;
	
	// We use [[self document] bkmxDocWinCon] instead of [[self document] bkmxDocWinCon]
	// because the latter can be nil if the tab in which self resides is not dislayed
	// when the window is loaded from the nib.
	if ([[[self document] bkmxDocWinCon] outlineMode]) {
		if (stark) {
			NSInteger nChildren = [stark numberOfChildren];
			if (nChildren > 0) {
				answer = YES ;
			}
			else {
				answer = NO ;
			}
		}
		else {
			// nil means they want root; root always has children if it exists
			answer =  ([[[self document] starker] root] != nil) ;		
		}
	}
	else {
		// We do not display disclosure triangles when in flat mode
		answer = NO ;
	}
	
	return answer ;
}

- (id)outlineView:(NSOutlineView *)outlineView
			child:(NSInteger)index
           ofItem:(ContentProxy*)parent {
    ContentProxy* proxy ;
    if (parent) {
        proxy = (ContentProxy*)[parent childAt:index] ;
    }
    else if (index < [m_rootProxies count]) {
        // parent is nil, which means root
        proxy = (ContentProxy*)[m_rootProxies objectAtIndex:index] ;
    }
    else {
        proxy = nil ;   
    }
    
    if (![proxy isKindOfClass:[ContentProxy class]]) {
        // proxy is either nil, or is a SSYDisjoiningPlaceholder.  Must replace
        // with a ContentProxy
        proxy = [[ContentProxy alloc] init] ;
        [proxy setParent:parent] ;
        [proxy setIndex:index] ;
        [parent putChild:proxy at:index];
        // We handle the case of !parent below, adding to m_rootProxies.
        [proxy setOutlineView:outlineView] ;

        if (!m_proxies) {
            m_proxies = [[NSMutableSet alloc] init] ;
        }
        
        /* m_proxies is a mutable set which is used to retain proxies  */
        
        [m_proxies addObject:proxy] ;
        
        if (!parent) {
            if (!m_rootProxies) {
                m_rootProxies = [[NSMutableArray alloc] init] ;
            }
            
            [m_rootProxies putObject:proxy
                             atIndex:index] ;
        }
        
        [proxy release] ;
    }


    return proxy ;
}

- (id)           outlineView:(NSOutlineView *)outlineView
   objectValueForTableColumn:(NSTableColumn *)tableColumn
					  byItem:(ContentProxy*)proxy {
    Stark* stark = [proxy stark] ;
	Sharype sharype = [stark sharypeValue] ;
	
	NSString* answer = @"" ;
	
	if (!stark) {
		return answer ;
	}
	
	if ([(NSString*)[tableColumn identifier] isEqualToString:@"name"]) {
		if (sharype == SharypeSeparator) {
			answer = constSeparatorLineForBookMacster ;
		}
		else {
			answer = [stark name] ;
		}
	}
	else { // userDefined column
		// The following code is similar to that in -[StarkTableColumn setUserDefinedAttribute:]
		
		NSString* key = [(StarkTableColumn*)tableColumn userDefinedAttribute] ;
		if (key) {
			id value = [stark valueForKey:key] ;

            // Tweak for Dates -- Date formatting
			if ([value isKindOfClass:[NSDate class]]) {
				value = [value medDateShortTimeString] ;
			}
			
			// Tweak for Enumerated Types
			if ([value isKindOfClass:[NSNumber class]]) {
				NSString* displayMethodName = [key stringByAppendingString:@"DisplayName"] ;
				SEL displayMethodSelector = NSSelectorFromString(displayMethodName) ;
				if ([value respondsToSelector:displayMethodSelector]) {
					value = [value performSelector:displayMethodSelector] ;
				}
			}

            answer = value ;
		}
	}
	
	return answer ; 
}

// Getting user edits from NSOutlineView
- (void)outlineView:(NSOutlineView *)outlineView
     setObjectValue:(id)object
     forTableColumn:(NSTableColumn *)tableColumn
             byItem:(ContentProxy*)proxy {
	//  As of Bookdog 2.0.8, object will be an NSAttributedString if it has been drawn
	//  in the table.  But if it is a new edit, it will still be an NSString.
	NSString* newString ;
	if ([object respondsToSelector:@selector(string)]) // object must be an NSAttributedString
		newString = [object string] ;
	else // object must be a NSString, so bypass the extraction and use as is.
		newString = object ;
	
    Stark* stark = [proxy stark] ;
    if ([stark sharypeValue] != SharypeSeparator) {
		// Without this qualification, when user clicks a separator, its name
		// will change from "Separator" to "---------".  Arghhhh!!
		
		if ([[tableColumn identifier] isEqualToString:@"name"]) {
			if ([newString isAllWhite])
				return ; // We don't allow a name of all whitespace.
			else
			{
				// This callback gets invoked whenever cell is merely selected or doubleclicked, so I filter these quickly,
				if ([newString isEqualToString:[stark name]])        // was newName
					return ;
				
				[stark setName:newString] ;
			}
		}
		else if ([(NSString*)[tableColumn identifier] isEqualToString:@"url"]) {
			// This callback gets invoked whenever cell is merely selected or doubleclicked, so I filter these:
			if ([newString isEqualToString:[stark url]])
				return ;
			
			[stark setUrl:newString] ;
		}
		else {
			// userDefined column
			[stark setValue:object
							forKey:[(StarkTableColumn*)tableColumn userDefinedAttribute]] ;
		}
	}
}

#pragma mark * Dragging Source Protocol Methods
// ***** Dragging and Dropping (These must be here, in a NSTable/OutlineView's dataSource!!) ***** //


- (id <NSPasteboardWriting>)outlineView:(NSOutlineView *)outlineView
                pasteboardWriterForItem:(ContentProxy*)item {
    if (![item respondsToSelector:@selector(stark)]) {
        NSLog(@"Internal Error 383-9846");
        return nil;
    }
    
    Stark* stark = [item stark];
    if ([stark isHartainer]) {
        return nil;
    }
    
    NSPasteboardItem *pboardItem = [[NSPasteboardItem alloc] init];
    
    DraggableStark* draggableStark = [[DraggableStark alloc] initWithStark:stark];
    if (draggableStark) {
        [pboardItem setString:draggableStark.jsonString
                      forType:constBkmxPboardTypeDraggableStark];
    }
    [draggableStark release];

    NSString* urlString = [stark url];
    if (urlString) {
        [pboardItem setString:urlString
                      forType:NSPasteboardTypeString];
        NSURL* url = [NSURL URLWithString:urlString];
        if (url) {
            NSString* stringRepresentation = [url absoluteString];
            if (stringRepresentation) {
                [pboardItem setString:stringRepresentation
                              forType:NSPasteboardTypeURL];
                if ([url isFileURL]) {
                    [pboardItem setString:stringRepresentation
                                  forType:NSPasteboardTypeFileURL];
                }
            }
        }
    } else {
        /* This will happen if stark is a folder. */
        NSString* name = [stark name];
        if (name) {
            [pboardItem setString:name
                          forType:NSPasteboardTypeString];
        }
    }

    NSString* template = [[NSUserDefaults standardUserDefaults] stringForKey:constKeyTextCopyTemplate];
    NSString* tabbedRep = [stark textSummaryWithTemplate:template];
    [pboardItem setString:tabbedRep
                  forType:NSPasteboardTypeTabularText];

    [pboardItem autorelease];
    return pboardItem;

}

#if 0
// Dragging Source: Writing TO the System Dragging Pasteboard
- (BOOL)outlineView:(NSOutlineView*)olv
		 writeItems:(NSArray*)proxies
	   toPasteboard:(NSPasteboard*)pasteboard
{
	NSArray* providedDragTypes = [NSArray arrayWithObjects:
								  constBkmxPboardTypeStark,
								  NSPasteboardTypeString,
								  nil] ;
	[pasteboard declareTypes:providedDragTypes
					   owner:self] ;

    NSArray* starks = [proxies valueForKey:@"stark"] ;
    
	// The following does not work because of the @"Parent" key in each item, which is an NSValue.
	// success1 = [pboard setPropertyList:writeItems forType:constBkmxPboardTypeStark] ;
	// NSValues are not supported for serialization.  Therefore, even though setPropertyLost:forType will return YES,
	// it is in fact not successful.  The pasteboard will contain NULL for type constBkmxPboardTypeStark
	
	// So, we do this instead
	[[(BkmxAppDel*)[NSApp delegate] intraAppDragArray] removeAllObjects] ;
	[[(BkmxAppDel*)[NSApp delegate] intraAppDragArray] addObjectsFromArray:starks] ;
	
	// Now, we set the urls onto the pasteboard for other apps
	// Set NSPasteboardTypeString data onto pasteboard
	NSString* urls = [starks tabReturnLeavesSummary] ;
	if (urls) {
		[pasteboard setString:urls forType:NSPasteboardTypeString];
	}
	
	return YES ;
}
#endif

/* // Here is an implementation (from Hilleglass) for doing the same thing/
 // if this were a table view instead of an outline view.
 - (BOOL)tableView:(NSTableView *)tv writeRows:(NSArray*)rows 
 toPasteboard:(NSPasteboard*)pb 
 { 
 NSMutableArray *rowArray = [[NSMutableArray alloc] init]; 
 NSEnumerator *enumerator = [rows objectEnumerator]; 
 id object; 
 NSData *rowData; 
 while (object = [enumerator nextObject]) { 
 NSInteger theRow = [object intValue]; 
 NSMutableDictionary *rowRecord = [[self model] recordForRow:theRow]; 
 [rowArray addObject:rowRecord]; 
 } 
 rowData = [self encodeDataRepresentationForObjects:rowArray]; 
 [pb declareTypes:[NSArray arrayWithObjects:MY_DRAG_TYPE, nil] owner:self]; 
 return [pb setData:rowData forType:MY_DRAG_TYPE]; 
 }
 */

/*
 shouldDelayWindowOrderingForEvent:
 Overridden by subclasses to allow the user to drag images from the receiver without its window moving forward and possibly obscuring the destination and without activating the application.
 - (BOOL)shouldDelayWindowOrderingForEvent:(NSEvent *)theEvent
 Discussion
 If this method returns YES, the normal window-ordering and activation mechanism is delayed (not necessarily prevented) until the next mouse-up event. If it returns NO, then normal ordering and activation occur. Never invoke this method directly; it‚Äôs invoked automatically for each mouse-down event directed at the NSView.
 An NSView subclass that allows dragging should implement this method to return YES if theEvent, an initial mouse-down event, is potentially the beginning of a dragging session or of some other context where window ordering isn‚Äôt appropriate. This method is invoked before a mouseDown: message for theEvent is sent. NSView‚Äôs implementation returns NO.
 If, after delaying window ordering, the receiver actually initiates a dragging session or similar operation, it should also send a preventWindowOrdering message to NSApp, which completely prevents the window from ordering forward and the activation from becoming active. preventWindowOrdering is sent automatically by NSView‚Äôs dragImage:... and dragFile:... methods.
 
 */
/*
 - (NSData *)encodeDataRepresentationForObjects:(NSArray *)objects
 {
 NSData *data;
 NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
 NSString *plist;
 
 [root setObject:objects forKey:@"Root"];
 plist = [root description];
 data = [plist dataUsingEncoding:NSASCIIStringEncoding];
 //	data = [NSSerializer serializePropertyList:root];
 [root release];
 return data;
 }
 */

#pragma mark * Dragging Destination Protocol Methods

// This is to OK the proposed drop before it happens
/* This is stil used in the new drag/drop regime. */
- (NSDragOperation)outlineView:(ContentOutlineView*)outlineView
				  validateDrop:(id <NSDraggingInfo>)info  // contains payload item(s)
				  proposedItem:(id)proposedProxy
			proposedChildIndex:(NSInteger)proposedIndex {       // location within target item
	
    Stark* proposedParent = [proposedProxy stark] ;
	NSPasteboard* pboard = [info draggingPasteboard];
	NSDragOperation output = NSDragOperationMove | NSDragOperationCopy ; // Start by assuming it will work
	StarkLocation* target = [[StarkLocation alloc] initWithParent:proposedParent index:proposedIndex] ;	
	BOOL isProposingToCreateStark = NO ;
	
	//  1. Disallow drops if no appropriate Pboard type
	if (output != NSDragOperationNone) {
		if([pboard availableTypeFromArray:[NSArray arrayWithObjects:
										   constBkmxPboardTypeDraggableStark,
										   nil]]) {
			// No restrictions if payload is Stark or filename
			isProposingToCreateStark = YES ;
		}
		if([pboard availableTypeFromArray:[NSArray arrayWithObjects:
                                           constBkmxPboardTypeDraggableStark,
                                           NSPasteboardTypeFileURL, nil]]) {
			// No restrictions if payload is Stark or filename
			isProposingToCreateStark = YES ;
		}
		else if([pboard availableTypeFromArray:[NSArray arrayWithObjects:
												RPTokenControlPasteboardTypeTokens,
												RPTokenControlPasteboardTypeTabularTokens,
                                                RPTokenControlPasteboardTypeRepresentedObjects,
                                                nil]]) {
			// Disallow drops of tags onto folders, separators, 1Password bookmarklets, or at root (nil proposedTarget).
			// Only drops onto bookmarks are OK.
			if (
				(proposedParent == nil)
				||
				!([proposedParent sharypeValue] == SharypeBookmark)
				) {
				output =  NSDragOperationNone ;
			}
		}
		else if([pboard availableTypeFromArray:[NSArray arrayWithObject:
												NSPasteboardTypeString]]) {
			// Drops of text strings (to create new bookmarks) are, in
            // general, OK.  If dropping onto root and Settings say to not
            // allow bookmarks in root, the drop will be retargetted.
			isProposingToCreateStark = YES ;
		}
		else {
			// Disallow drops of unknown types!
			output = NSDragOperationNone ;
		}
	}
	
	NSArray* items = [pboard pasteboardItems] ;
	// Note that items will be nil if drag is of a tag, or from another app.
	// intraAppDragArray is only used for Starks.
    if (!proposedParent) {
        proposedParent = [[[self document] starker] root];
    }

    NSMutableArray* starks = [NSMutableArray new];
    for (ContentProxy* proxy in items) {
        if ([proxy respondsToSelector:@selector(stark)]) {
            Stark* stark = [proxy stark];
            [starks addObject:stark];
        }
    }
    
    
	//  2. If outline is in flat mode, disallow drags from same outline
	if (output != NSDragOperationNone) {
		if (isProposingToCreateStark && ![[[outlineView window] windowController] outlineMode]) {
			// We just check the first item, assuming that they all came from the same source document
			Stark* stark = [starks objectAtIndex:0] ;
            if ([stark owner] == [self document]) {
                output = NSDragOperationNone ;
            }
		}
	}
	
	//  3. Check if OK to insert proposed items at proposed location
	if (output != NSDragOperationNone) {
        if (isProposingToCreateStark) {
            StarkCanParent can = [StarkEditor canInsertStarks:starks
                                                   intoParent:proposedParent];
            if (proposedParent == nil) {
                /* proposedTarget == nil means that user is hovering mouse over
                 whitespace at the bottom of the view.  In this case, the user
                 expects the items to be retargetted, so we allow the operation
                 to proceed even if retargetting will happen upon dropping. */
                if (can <= StarkCanParentNopeDemarcation) {
                    output = NSDragOperationNone;
                }
            } else {
                /* proposedTarget != nil means that user is hovering mouse over
                 a proposed destination item.  In this case, the user does not
                 expect the items to be retargetted, so we are more
                 restrictive, returning NSDragOperationNone if any retargetting
                 will happen upon dropping*/
                if (can != StarkCanParentOkAsRequested) {
                    output = NSDragOperationNone ;
                }
			}
		}
	}
    
	//  4. Now see if we want to retarget proposed Stark creation
	//     Here, we only do retargetting which does not depend on the payloadItem.
	//     In outlineView:acceptDrop:item:childIndex, we may do additional retargetting per payload item.
	if (isProposingToCreateStark && (output != NSDragOperationNone)) {
        StarkLocationFix fix = [[[outlineView window] windowController] outlineMode]
                                ? StarkLocationFixParentAndIndex
                                : StarkLocationFixParentOnly ;
		[target canInsertItems:nil
                           fix:fix
				   outlineView:outlineView] ;
		// We send a message to the outline view to do the retargetting (this seems strange, but it works).
        ContentProxy* targetParentProxy = [self proxyForStark:[target parent]] ;
		[[(BkmxDocWinCon*)[[self document] bkmxDocWinCon] contentOutlineView] setDropItem:targetParentProxy
                                                                           dropChildIndex:[target index]] ;
		// Note: -canInsertItems:::: will be invoked again later, when outlineView:acceptDrop:item:childIndex sends
		// -parentingAction:items:newParent:newIndex:revealDestin:] because this method
		// does it for clipboard copies and contextual menu Copy To and Move To items.  But we also "pre-do" it
		// in this case of drag/dropping, to give visual feedback to the user.  Also, in the later case we do 
		// not CheckRange
	}

    /* 5. Do not allow drops of a single item onto itself */
	if (!isProposingToCreateStark && (output != NSDragOperationNone)) {
        if (starks.count == 1) {
            if ([starks firstObject] == proposedParent) {
                output = NSDragOperationNone;
            }
        }
    }

    [starks release];
    [target release] ;

	return output ;
}

- (Stark*)insertStarkTreeFromPath:(NSString*)path
                           parent:(Stark*)parent
                            index:(NSInteger)index {
    BOOL isDirectory ;
    Stark* newStark = nil ;
    [[NSFileManager defaultManager] fileExistsAtPath:path
                                         isDirectory:&isDirectory] ;
    if (isDirectory) {
        newStark = [[[self document] starker] freshStark] ;
        [newStark setSharypeValue:SharypeSoftFolder] ;
        [newStark setName:[path lastPathComponent]] ;
        
        NSArray* children = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                                error:NULL] ;
        NSInteger childIndex = 0 ;
        for (NSString* childName in children) {
            NSString* childPath = [path stringByAppendingPathComponent:childName] ;
            [self insertStarkTreeFromPath:childPath
                                   parent:newStark
                                    index:childIndex] ;
            childIndex++ ;
        }
    }
    else {
        NSDictionary* filenameAndURL = [SSYWeblocGuy filenameAndUrlFromWeblocFileAtPath:path] ;
        if (filenameAndURL) {
            newStark = [[[self document] starker] freshStark] ;
            [newStark setSharypeValue:SharypeBookmark] ;
            [newStark setUrl:[filenameAndURL objectForKey:@"url"]] ;
            [newStark setName:[filenameAndURL objectForKey:@"filename"]] ;
        }
        else {
            /* path is not a valid .webloc file; ignore it. */
        }
    }

    if (newStark) {
        [newStark setAddDate:[[NSFileManager defaultManager] modificationDateForPath:path]] ;
        [newStark setLastModifiedDate:[[NSFileManager defaultManager] creationDateForPath:path]] ;

        [StarkEditor parentingAction:BkmxParentingAdd
                               items:newStark
                           newParent:parent
                            newIndex:index
                        revealDestin:NO] ;
        /* We passed reveralDestin:NO for performance in case hundreds or more
         starks are beint inserted.  We instead do it once, for all starks,
         after this method returns to outlineView:acceptDrop:::. */
    }

    return newStark ;
}

- (NSArray*)freshStarksFromString:(NSString*)string {
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray* itemStrings = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] ;
    NSMutableArray* newBookmarks = [[NSMutableArray alloc] init] ;
    for (NSString* itemString in itemStrings) {
        // Since the tab-return data indeed represents a "brand new" item,
        // and since the data itself does not contain any date information,
        // we use -freshDatedStark, to set the addDate and lastModified date
        // to the current date.
        Stark* newBookmark = [[[self document] starker] freshDatedStark] ;
        [newBookmark setSharypeValue:SharypeBookmark] ;

        NSString* name ;
        NSString* url = [itemString parseForUrlAndName_p:&name] ;

        if (url) {
            [newBookmark setUrl:url] ;
        }

        [newBookmark setName:name] ;

        [newBookmarks addObject:newBookmark] ;
    }

    NSArray* answer = [newBookmarks copy];
    [newBookmarks release];
    [answer autorelease];
    

    return answer;
}

// This is to actually accept the drop
/* This is stil used in the new drag/drop regime. */
- (BOOL)outlineView:(NSOutlineView *)outlineView
		 acceptDrop:(id <NSDraggingInfo>)info
			   item:(id)targetProxy
		 childIndex:(NSInteger)proposedIndex {
    /* When testing in macOS 10.15 Catalina Beta 3, I found that, when dropping
     items onto a folder, proposedIndex at this point would be -1, which this
     implementation does not expect and will cause items to appear in the new
     parent in incorrect order.  I investigated whether my code was causing
     this, by passing -1 to -setDropItem:targetParentProxydropChildIndex: or
     -setDropRow:dropOperation:, but neither was culpable.  The meaning of -1
     is explained in the documentation of the latter:
     https://developer.apple.com/documentation/appkit/nstableview/1535123-setdroprow?language=objc
     in "Discussion".
     I don't know if this is a new feature in macOS 10.15, or a bug in the
     current beta, or if it has been this way for years.  But, whatever the
     reason, here is the fix: */
    if (proposedIndex == -1) {
        proposedIndex = NSNotFound;
    }

	// So that when -parentingAction::::: invokes
	// -[ContentOutlineView realizeIsExpandedValuesFromModelFromRoot:],
	// -shouldExpandItem will return YES and items will expand.
	// Without this, the whole damned outline collapses (fixed in BookMacster 0.9.7)
	[(ContentOutlineView*)outlineView reEnableSpringLoading:nil] ;
	
	[SSMoveableToolTip goAway] ;
    
    Stark* targetItem = [targetProxy stark] ;
	
	// In case the outline is in flat mode (outlineMode==NO), the target item
	// will be nil.  That was correct for the outlineView, since it means root,
	// but now we have to change it to a real parent in the outline
	if (targetItem == nil) {
		Stark* root = [[[self document] starker] root] ;
		targetItem = root ;
		// Note: it is possible that this root cannot accept this item due to
		// exformat restrictions.  That will be taken care of by retargetting
		// in parentingAction:::::
	}
	
	NSPasteboard *pboard = [info draggingPasteboard];
	NSDragOperation dragOperation = [info draggingSourceOperationMask] ;

    /*
     * Modifier   Value that I         Result
     * Key        return in            dragOperation
     * Down       -draggingUpdated:    in this method
     * --------   -----------------    ------
     * None       M + G                M + C
     * option     C + G                C
     * command    G                    0
     * opt+cmd    C + G                C
     
     * where:
     *   M = NSDragOperationMove
     *   C = NSDragOperationCopy
     *   Result = the value that I get from sending -draggingSourceOperationMask
     *            to the acceptDrop parameter of
     *            -outlineView:acceptDrop:item:childIndex:
     
     I think that the value returned in -draggingUpdated does not affect the
     Result.  It only affects the dragging icon shown at the cursor.
     Otherwise, the "Result" provided by Cocoa makes *some* sense but not much.
     Nonetheless, the following code is written to accomodate it.
     It was modified in BookMacster 1.19.
    */
     
	BOOL result ;
	NSArray* tagTargets = nil ;
	BkmxParentingAction action = BkmxParentingActionNone ;

    if (
        ((dragOperation & NSDragOperationMove) != 0)        // No modifier key
        ||
        (dragOperation == NSDragOperationNone)             // cmd modifier key
        ) {
		action = BkmxParentingMoveOrCopy ;
	}
	else if ((dragOperation & NSDragOperationCopy) != 0) {  // opt or (cmd+opt) modifier key
		action = BkmxParentingCopy ;
	}
	
	if (action != BkmxParentingActionNone) {
        if ([pboard availableTypeFromArray:[NSArray arrayWithObject:constBkmxPboardTypeDraggableStark]]) {
            NSMutableArray* starks = [NSMutableArray new];
            for (NSPasteboardItem* pboardItem in [pboard pasteboardItems]) {
                NSString* jsonWay = [pboardItem stringForType:constBkmxPboardTypeDraggableStark];
                DraggableStark* draggableStark = [[DraggableStark alloc] initWithJsonString:jsonWay];
                Stark* stark = [draggableStark stark];
                if (stark) {
                    [starks addObject:stark];
                }
                [draggableStark release];
            }
            [StarkEditor parentingAction:action
                                   items:starks
                               newParent:targetItem
                                newIndex:proposedIndex
                            revealDestin:YES] ;
            [starks release];
            result = YES ;
        }
        else if (
                 [pboard availableTypeFromArray:[NSArray arrayWithObjects:constBkmxPboardTypeSafari, nil]]
                 || [pboard availableTypeFromArray:[NSArray arrayWithObjects:constBkmxPboardTypeSafariLegacy, nil]]
                 ) {
            NSArray* safariItems = [pboard propertyListForType:constBkmxPboardTypeSafari];
            if (!safariItems) {
                safariItems = [pboard propertyListForType:constBkmxPboardTypeSafariLegacy] ;
            }
            Starker* starker = [(BkmxDoc*)[targetItem owner] starker] ;
            
            NSMutableArray* starks =[[NSMutableArray alloc] init] ;
            for (NSDictionary* safariItem in safariItems) {
                Stark* stark = [ExtoreSafari starkFromExtoreNode:safariItem
                                                         starker:starker
                                                       clientoid:nil] ;
                if (stark) {
                    [starks addObject:stark] ;
                }
            }
            [StarkEditor parentingAction:BkmxParentingCopy
                                   items:starks
                               newParent:targetItem
                                newIndex:proposedIndex
                            revealDestin:YES] ;
            /*
             Note that we use BkmxParentingCopy here, even though we are ^adding^
             new items to BookMacster, I believe we need to pretend that we are
             copying so that copies are made.  Otherwise, redo will not work.
             In the other two 'else if' branches that follow this branch
             (handling .webloc files and strings), I believe we are able to
             get away with BkmxParentingAdd since these items do not have any
             parents from which they can be removed.  I hope that makes sense.
             Anyhow, they seem to redo properly.
             */
            
            // The following was added in BookMacster 1.17, in an effort to fix
            // the reports of 134030 errors from Core Data
            for (Stark* stark in starks) {
                [starker deleteObject:stark] ;
            }
            
            [starks release] ;
            result = YES ;
            
        }
        else if ([pboard availableTypeFromArray:[NSArray arrayWithObjects:NSPasteboardTypeFileURL, nil]]) {
            NSArray* items = pboard.pasteboardItems;
            NSMutableArray* newRootStarks = [NSMutableArray new] ;
            for (NSPasteboardItem* item in items) {
                /* */
                NSString* weirdFileReferenceUrlPath = [item propertyListForType:@"public.file-url"];
                /* weirdFileReferenceUrlPath example value: "file:/.file/id=6571367.11667664"
                 This is a so-called "File Reference URL"; see
                 https://developer.apple.com/library/ios/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/AccessingFilesandDirectories/AccessingFilesandDirectories.html#//apple_ref/doc/uid/TP40010672-CH3-SW6
                 aka File System Programming Guide > Accessing Files and Directories > Specifying the Path to a File or Directory.
                 We need to convert this string to a NSURL so we can "standardize" it,
                 resulting in a posix path. */
                NSURL* fileUrl = [NSURL fileURLWithPath:weirdFileReferenceUrlPath];
                NSString* path = [[fileUrl standardizedURL] path];
                Stark* newStark = [self insertStarkTreeFromPath:path
                                                         parent:targetItem
                                                          index:proposedIndex++] ;
                if (newStark) {
                    [newRootStarks addObject:newStark] ;
                }
            }

            /* Because we did not "show them" (the new starks) in when we
             invoked -parentingAction::::: in -insertStarkTreeFromPath:::,
             we do it now.  We do it with a delay, as is done in
             -parentingAction:::::.  I don't know if it work without the delay
             and have not tried.  It's not a big deal, so I figured it would
             be safer to do it the same way. */
            BOOL yes = YES ;
            NSInvocation* showAndTell = [NSInvocation invocationWithTarget:outlineView
                                                                  selector:@selector(showStarks:selectThem:expandAsNeeded:)
                                                           retainArguments:YES
                                                         argumentAddresses:&newRootStarks, &yes, &yes] ;
            [showAndTell performSelector:@selector(invoke)
                              withObject:nil
                              afterDelay:CONTENT_OUTLINE_VIEW_RELOAD_DELAY_1] ;
            
            [newRootStarks release] ;
            
            result = YES ;
        }
        else if([pboard availableTypeFromArray:[NSArray arrayWithObject:RPTokenControlPasteboardTypeRepresentedObjects]]) {
            NSArray* selectedTags = [[[[self document] bkmxDocWinCon] cntntViewController] selectedTags];
            tagTargets = [NSArray arrayWithObject:targetItem] ;
            [StarkEditor addTags:selectedTags
                     toBookmarks:tagTargets] ;
            result = YES ;
        }
        else if([pboard availableTypeFromArray:[NSArray arrayWithObject:NSPasteboardTypeString]]) {
            NSString* string = [pboard stringForType:NSPasteboardTypeString] ;
            // High-level method which adds new bookmarks to the tree.
            [StarkEditor parentingAction:BkmxParentingAdd
                                   items:[self freshStarksFromString:string]
                               newParent:targetItem
                                newIndex:proposedIndex
                            revealDestin:YES] ;

            [NSApp activateIgnoringOtherApps:YES] ;
            result = YES ;
        }
        else {
            result = NO ;
        }
    }
    else {
        // Should never happen.  Added in BookMacster 1.19
        result = NO ;
        NSLog(@"Internal Error 295-2924") ;
    }

	if (tagTargets) {
        [(ContentOutlineView*)outlineView showStarks:tagTargets // Showing is not really necessary since target must have already been showing to be dropped upon.
                                          selectThem:YES        // This is what we really want
                                      expandAsNeeded:NO] ;      // Like showing, expanding should not be necessary either
	}
	
	return result ;
}

#if 0
#warning Logging RR for ContentDataSource
- (id)retain {
	id x = [super retain] ;
	NSLog(@"%@ retained %03ld\n%@", self, (long)[self retainCount], SSYDebugBacktraceDepth(8)) ;
	return x ;
}
- (id)autorelease {
	id x = [super autorelease] ;
	NSLog(@"%@ autoreleased\n%@", self, SSYDebugBacktraceDepth(8)) ;
	return x ;
}

- (oneway void)release {
	NSInteger rc = [self retainCount] ;
	[super release] ;
	NSLog(@"%p released %03ld\n%@", self, (long)rc, SSYDebugBacktraceDepth(8)) ;
	return ;
}
#endif

- (void)tearDown {
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

- (void)dealloc {
    [self tearDown]; // In case this was not done earlier

	[m_filterString release] ;
    [m_filterDays release] ;
    [m_filterTags release] ;
    [m_proxies release] ;
    [m_rootProxies release] ;
    [m_flatSortKey release] ;
	[flatCache release] ;
	[m_filterAnnunciation release] ;
	
	[super dealloc] ;
}



#pragma mark * Extras

- (BOOL)outlineView:(NSOutlineView*)outlineView
	   containsItem:(id)item {
	Sharype sharypeValue = [item sharypeValue] ;
	BOOL answer ;
	// We use [[self document] bkmxDocWinCon] instead of [[self document] bkmxDocWinCon]
	// because the latter can be nil if the tab in which self resides is not dislayed
	// when the window is loaded from the nib.
	if (![[[self document] bkmxDocWinCon] outlineMode]) {
		// Not displaying folders
		// Only if this sharype is displayed in nonhierarchical
		answer = ([StarkTyper doesDisplayInNoFoldersViewSharype:sharypeValue]) ;
	}
	else {
		// Displaying folders
		// Answer is YES for all except root.
		answer = (sharypeValue > SharypeRoot) ;
	}
	
	return answer ;
}

#if 0
- (void)printProxies {
    NSMutableSet* inters = [[NSSet setWithArray:m_rootProxies] mutableCopy] ;
    [inters intersectSet:m_proxies] ;
    NSLog(@"tt = %ld    rt = %ld   it = %ld", (long)[m_proxies count], (long)[m_rootProxies count], (long)[inters count]) ;
//    NSLog(@"m_proxies: %@", m_proxies) ;
//    NSLog(@"m_rootProxies: %@\n\n", m_rootProxies) ;
    [inters release] ;
}
#endif

@end
