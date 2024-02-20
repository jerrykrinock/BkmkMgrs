#import <Bkmxwork/Bkmxwork-Swift.h>
#import "Stark+Sorting.h"
#import "Bookshig.h"
#import "NSString+BkmxURLHelp.h"
#import "BkmxDoc.h"
#import "Stark.h"
#import "BkmxArrayCategories.h"
#import "NSObject+MoreDescriptions.h"

@interface NSArray (SSYSorting)

/*!
 @details  This is to support sorting bookmarks by tags.
 */
- (NSComparisonResult)compare:(NSArray*)other ;

@end

@implementation NSArray (SSYSorting)
    
- (NSComparisonResult)compare:(NSArray*)other {
    if ([self count] < [other count]) {
        return NSOrderedAscending ;
    }
    if ([self count] > [other count]) {
        return NSOrderedDescending ;
    }
    
    return NSOrderedSame ;
}

- (void)segmentIntoFolders:(NSMutableArray*)folders
                 bookmarks:(NSMutableArray*)bookmarks {
    for (Stark* stark in self) {
        if ([stark sharypeCoarseValue] < SharypeCoarseLeaf) {
            [folders addObject:stark];
        } else {
            [bookmarks addObject:stark];
        }
    }
}

@end

@implementation Stark (Sorting)

+ (NSArray*)sortedArrayStarks:(NSObject <NSFastEnumeration> *)starks
			  sortDescriptors:(NSArray*)sortDescriptors
				 searchString:(NSString*)searchString
                caseSensitive:(BOOL)caseSensitive
                   wholeWords:(BOOL)wholeWords
                   searchDays:(NSNumber*)searchDays
			 stringSearchKeys:(NSSet*)stringSearchKeys
				 matchingTags:(NSSet*)filterTags
						logic:(NSInteger)filterLogic {
    BOOL doDays = (searchDays != nil) ;
	BOOL doString ;
	BOOL doTags ;
    if (doDays) {
        doString = NO ;
        doTags = NO ;
    }
    else {
        doString = [searchString length] > 0 ;
        doTags = (filterLogic > 0) && ([filterTags count] > 0) ;
    }
    
	NSMutableArray* filteredSortedBookmarks ;
	if (doString || doTags) {
        NSStringCompareOptions options = caseSensitive ? 0 : NSCaseInsensitiveSearch ;
		filteredSortedBookmarks = [[NSMutableArray alloc] init] ;
		for (Stark* item in starks) {
			BOOL matched = YES ;
			if (doString) {
				matched = NO ;
				for (NSString* key in stringSearchKeys) {
					NSString* string = [item valueForKey:key] ;
					if (string) {
                        NSRange range = [string rangeOfString:searchString
                                                      options:options] ;
						if (range.location != NSNotFound) {
                            unichar borderChar ;
                            if (wholeWords) {
                                BOOL frontEndOk = NO ;
                                if (range.location == 0) {
                                    frontEndOk = YES ;
                                }
                                else {
                                    borderChar = [string characterAtIndex:range.location - 1] ;
                                    if (![[NSCharacterSet alphanumericCharacterSet] characterIsMember:borderChar]) {
                                        frontEndOk = YES ;
                                    }
                                }
                                if (frontEndOk) {
                                    BOOL backEndOk = NO ;
                                    if (range.location == [string length]) {
                                        backEndOk = YES ;
                                    }
                                    else {
                                        borderChar = [string characterAtIndex:range.location + range.length] ;
                                        if (![[NSCharacterSet alphanumericCharacterSet] characterIsMember:borderChar]) {
                                            backEndOk = YES ;
                                        }
                                    }
                                    if (backEndOk) {
                                        matched = YES ;
                                    }
                                }
                            }
                            else {
                                matched = YES ;
                            }
							break ;
						}
					}
				}
			}

			if (matched && doTags) {
				matched = NO ;
				for (Tag* filterTag in filterTags) {
					if (filterLogic > 1) {
						// Logic is to require "ALL" tags.
						// Forget any previous match
						matched = NO ;
					}
					for (Tag* tag in [item tags]) {
                        NSString* filterTagString = filterTag.string;
                        NSString* thisTagString = tag.string;
						if (filterTagString && [thisTagString caseInsensitiveCompare:filterTagString] == NSOrderedSame) {
							matched = YES ;
							break ;
						}
					}
					if ((filterLogic > 1) != matched) {
						// If filterLogic is ALL, and got no match for this tag, the answer is NO.
						// If filterLogic is ANY, and did match for this tag, the answer is YES.
						// In either of these cases, we're done...
						break ;
					}
				}
			}
			if (matched) {				
				[filteredSortedBookmarks addObject:item] ;
			}
		}
	}
    else if (doDays) {
		filteredSortedBookmarks = [[NSMutableArray alloc] init] ;
        NSTimeInterval searchSeconds = [searchDays integerValue] * 24 * 60 * 60 ;
		for (Stark* stark in starks) {
            NSTimeInterval lastModifiedSecondsAgo = - [[stark lastModifiedDate] timeIntervalSinceNow] ;
            if (lastModifiedSecondsAgo < searchSeconds) {
                [filteredSortedBookmarks addObject:stark] ;
            }
        }
    }
	else {
		if ([starks isKindOfClass:[NSSet class]]) {
            /*
             Prior to BookMacster 1.19.2, the above tested if starks
             responded to -allObjects.  Surprise!  In macOS 10.9, but
             not in 10.6, NSArray does respond to -allObjects, even though this
             is not documented!  It returns a copy of self.  But anyhow,
             I don't want to do the unnecessary copying.
             */

			// It's a set.  Convert to array.
            starks = [(NSSet*)starks allObjects] ;
		}
		
		filteredSortedBookmarks = [starks mutableCopy] ;
	}
	
	if (sortDescriptors) {
		[filteredSortedBookmarks sortUsingDescriptors:sortDescriptors] ;
	}
		
	NSArray* answer = [filteredSortedBookmarks copy] ;
	[filteredSortedBookmarks release] ;
	
	return [answer autorelease] ;
}

+ (NSArray*)filteredSortedStarksFromStarks:(NSMutableArray *)starks
                              searchString:(NSString *)searchString
                                searchDays:(NSNumber*)searchDays
                        searchInAttributes:(NSSet*)searchInAttributes
                                   sortKey:(NSString*)sortKey
                             caseSensitive:(BOOL)caseSensitive
                                wholeWords:(BOOL)wholeWords
                             sortAscending:(BOOL)sortAscending
                                filterTags:(NSSet*)filterTags
                           filterTagsLogic:(NSInteger)filterTagsLogic
                           foldersAtBottom:(BOOL)foldersAtBottom {
    NSMutableArray* sortDescriptors = [NSMutableArray array] ;
    
    NSSortDescriptor* sortDescriptor ;
    
    Stark* anyStark = [starks firstObject] ;
    SEL sortSelector ;
    if ([[anyStark valueForKey:sortKey] respondsToSelector:@selector(localizedCaseInsensitiveCompare:)]) {
        if (caseSensitive) {
            sortSelector = @selector(localizedCaseInsensitiveCompare:) ;
        }
        else {
            sortSelector = @selector(compare:) ;
        }
    }
    else {
        sortSelector = @selector(compare:) ;
    }
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey
                                                 ascending:sortAscending
                                                  selector:sortSelector] ;
    [sortDescriptors addObject:sortDescriptor] ;
    [sortDescriptor release] ;
    
    NSArray* filteredSortedContents = [Stark sortedArrayStarks:starks
                                               sortDescriptors:sortDescriptors
                                                  searchString:searchString
                                                 caseSensitive:caseSensitive
                                                    wholeWords:wholeWords
                                                    searchDays:searchDays
                                              stringSearchKeys:searchInAttributes
                                                  matchingTags:filterTags
                                                         logic:filterTagsLogic] ;
    return filteredSortedContents;
}

- (NSArray*)descendantsFilteredSortedWithSharypesMask:(Sharype)sharypesMask
                                         searchString:(NSString*)searchString
                                           searchDays:(NSNumber*)searchDays
                                     stringSearchKeys:(NSSet*)searchInAttributes
                                        caseSensitive:(BOOL)caseSensitive
                                           wholeWords:(BOOL)wholeWords
                                              sortKey:(NSString*)sortKey
                                        sortAscending:(BOOL)sortAscending
                                         matchingTags:(NSSet*)filterTags
                                                logic:(NSInteger)filterTagsLogic {
    BOOL doBookmarks = ((sharypesMask & SharypeCoarseLeaf) != 0) ;
    BOOL doFolders = ((sharypesMask & SharypeGeneralContainer) != 0) ;
    BOOL foldersAtBottom = doBookmarks && doFolders ;
    
    NSMutableArray* allStarks = [[NSMutableArray alloc] init] ;
    NSMutableArray* leaves = doBookmarks ? allStarks : nil ;
    NSMutableArray* folders = doFolders ? allStarks : nil ;
    [self classifyBySharypeDeeply:YES
                       hartainers:folders
                      softFolders:folders
                           leaves:leaves
                          notches:nil] ;
    [allStarks removeObject:self] ;
    
    NSArray *filteredSortedContents;
    filteredSortedContents = [Stark filteredSortedStarksFromStarks:allStarks
                                                      searchString:searchString
                                                        searchDays:searchDays
                                                searchInAttributes:searchInAttributes
                                                           sortKey:sortKey
                                                     caseSensitive:caseSensitive
                                                        wholeWords:wholeWords
                                                     sortAscending:sortAscending
                                                        filterTags:filterTags
                                                   filterTagsLogic:filterTagsLogic
                                                   foldersAtBottom:foldersAtBottom] ;
    [allStarks release] ;
    
    return filteredSortedContents ;
}



- (BOOL)marksSameSiteAs:(Stark*)otherBookmark {
	NSString* url1 = [self url] ;
	NSString* url2 = [otherBookmark url] ;
    
    return [url1 marksSameSiteAs:url2] ;	
}

- (NSComparisonResult)nameCompare:(Stark*)otherStark {
	NSComparisonResult answer ;
	
	BkmxSortDirective directive1 = [self sortDirectiveValue] ;
	BkmxSortDirective directive2 = [otherStark sortDirectiveValue] ;
	
	if (directive1 == directive2) {
		Bookshig* shig = [(BkmxDoc*)[self owner] shig] ;
		if ([[shig filterIgnoredPrefixes] boolValue]) {
			NSArray* ignoredPrefixes = [[NSUserDefaults standardUserDefaults] objectForKey:constKeyIgnoredPrefixes] ;
			NSMutableString* mutableSelfName = [[self name] mutableCopy] ;
			NSMutableString* mutableOtherName = [[otherStark name] mutableCopy] ;
			for (NSString* prefix in ignoredPrefixes) {
				NSUInteger thisLength = [prefix length] ;
				NSRange thisRange = NSMakeRange(0, thisLength) ;
				if ([mutableSelfName length] >= thisLength) {
					[mutableSelfName replaceOccurrencesOfString:prefix
												   withString:@""
													  options:NSCaseInsensitiveSearch
														range:thisRange] ;
				}
				if ([mutableOtherName length] >= thisLength) {
					[mutableOtherName replaceOccurrencesOfString:prefix
												   withString:@""
													  options:NSCaseInsensitiveSearch
														range:thisRange] ;
				}
			}

			answer = [mutableSelfName localizedCaseInsensitiveCompare:mutableOtherName] ;
			[mutableSelfName release] ;
			[mutableOtherName release] ;
		}
		else {
			answer = [[self name] localizedCaseInsensitiveCompare:[otherStark name]] ;
		}
	}
	else if (directive1 == BkmxSortDirectiveTop) {
		answer = NSOrderedAscending ;
	}
	else if (directive1 == BkmxSortDirectiveBottom) {
		answer = NSOrderedDescending ;
	}
	else if (directive2 == BkmxSortDirectiveTop) {
		answer = NSOrderedDescending ;
	}
	else if (directive2 == BkmxSortDirectiveBottom) {
		answer = NSOrderedAscending ;
	}
	else {
		NSLog(@"Internal Error 550-8584:\n%ld %@\n%ld %@",
			  (long)directive1,
			  [self shortDescription],
			  (long)directive2,
			  [otherStark shortDescription]) ;
		answer = NSOrderedSame ;
	}

	return answer;
}

- (NSComparisonResult)compareNames:(Stark*)otherStark {
	return [[self name] localizedCaseInsensitiveCompare:[otherStark name]] ;
}

- (NSComparisonResult)compare:(Stark*)otherStark {
	Sharype sharype1 = [self sharypeValue] ;
	Sharype sharype2 = [otherStark sharypeValue] ;
	
	// Assume that self's owner must be a BkmxDoc, not an Extore
	Bookshig* shig = [(BkmxDoc*)[self owner] shig] ;
	
	// Permanent Hartainers always go at the top, regardless of
	// any user settings.
	if ((![StarkTyper isMoveableSharype:sharype1]) || (![StarkTyper isMoveableSharype:sharype2])) {
		return (sharype1 < sharype2) ? NSOrderedAscending : NSOrderedDescending ;
	}
	
	/* This default value is to give deterministic results in case there are
     no differences.  User Ken W. had a number of bookmarks in the same folder
     with the same name with slightly different URL.  They were not */
    NSComparisonResult result = NSOrderedSame ;
	
    BkmxSortingSegmentation sortingSegmentation = (BkmxSortingSegmentation)[[shig sortingSegmentation] integerValue];
    if ((sharype1 == sharype2) || (sortingSegmentation == BkmxSortingSegmentationMixAndSortAll)) {
		// Non-trivial case where both are of the same type, or, we don't care.
		BkmxSortBy sortBy = (BkmxSortBy)[shig sortByValue] ;
        /* We only sort by domainHostPath if the two operands are not
         containers.  */
		if ( (sortBy==BkmxSortByDomainHostPath) && ![StarkTyper canHaveChildrenSharype:sharype1] ) {
			result = [[self url] compareByDomainHostPathWith:[otherStark url]] ;
		}
        // The part after || in the next line is because folders are always sorted by name, unless we're sorting by rating.
		else if ((sortBy == BkmxSortByName) || ([StarkTyper canHaveChildrenSharype:sharype1] && (sortBy != BkmxSortByRating))) {
			if (sharype1 == SharypeBar) {
				result = NSOrderedAscending ;
			}
			else if (sharype2 == SharypeBar) {
				result = NSOrderedDescending ;
			}
			else if (sharype1 == SharypeMenu) {
				result = NSOrderedAscending ;
			}
			else if (sharype2 == SharypeMenu) {
				result = NSOrderedDescending ;
			}
			else if (sharype1 == SharypeUnfiled) {
				result = NSOrderedAscending ;
			}
			else if (sharype2 == SharypeUnfiled) {
				result = NSOrderedDescending ;
			}
			else if (sharype1 == SharypeOhared) {
				result = NSOrderedAscending ;
			}
			else if (sharype2 == SharypeOhared) {
				result = NSOrderedDescending ;
			}
			else {
				result = [self nameCompare:otherStark] ;
			}
		}
		else if (sortBy == BkmxSortByUrl) {
			result = [[self url] localizedCompare:[otherStark url]] ;
		}		
		else if (sortBy == BkmxSortByRating) {
			result = [[self rating] compare:[otherStark rating]] ;
			if (result == NSOrderedAscending) {
				result = NSOrderedDescending ;
			}
			else if (result == NSOrderedDescending) {
				result = NSOrderedAscending ;
			}
		}		
	}
	else if ([StarkTyper canHaveChildrenSharype:sharype1]) {
		// #1 is a folder and #2 is a bookmark
        if (
            (sortingSegmentation == BkmxSortingSegmentationFoldersAtTopSortingBoth) ||
            (sortingSegmentation == BkmxSortingSegmentationFoldersAtTopSortingFoldersOnly) ||
            (sortingSegmentation == BkmxSortingSegmentationFoldersAtTopSortingBookmarksOnly)
            ) {
			result = NSOrderedAscending ;
		}
		else {
            // sortingSegmentation must be one of the three BkmxSortingSegmentationFoldersAtBottomSortingXXX values
			result = NSOrderedDescending ;
		}
	}
	else {                 
		// #2 is a folder and #1 is a bookmark
        if (
            (sortingSegmentation == BkmxSortingSegmentationFoldersAtTopSortingBoth) ||
            (sortingSegmentation == BkmxSortingSegmentationFoldersAtTopSortingFoldersOnly) ||
            (sortingSegmentation == BkmxSortingSegmentationFoldersAtTopSortingBookmarksOnly)
            ) {
			result = NSOrderedDescending ;
		}
		else {
            // sortingSegmentation must be one of the three BkmxSortingSegmentationFoldersAtBottomSortingXXX values
			result = NSOrderedAscending ;
		}
	}
	
	/* The following backup sort descriptors are also implemented
	in +sortBy:.  We must be careful to not sort by attributes which are not
     synced be all browsers lest we get churn if users sync two Macs via a
     browser and have enabled sorting in our app in both Macs.  For example,
     it would not be a good idea to sort by starkid or rating here, as we
     did until BkmkMgrs 2.3. */
	
	if (result == NSOrderedSame) {
		result = [[self sharype] compare:[otherStark sharype]] ;
	}
	
	if (result == NSOrderedSame) {
		result = [self nameCompare:otherStark] ;
	}
	
	return result ;
}

- (NSComparisonResult)lineageLineCompare:(Stark *)otherStark {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;

	NSComparisonResult answer = [[self lineageLineDoSelf:YES
												 doOwner:NO] localizedCaseInsensitiveCompare:[otherStark lineageLineDoSelf:YES
																												   doOwner:NO]] ;
	[pool release] ;
	return answer ;
}

- (NSComparisonResult)overallQualityCompare:(Stark*)other {
	id sv ; // self value
	id ov ; // other value
	
	NSComparisonResult result = NSOrderedSame ;
	
	// If one has more children than the other, it is better.
	NSInteger sNC = [self numberOfChildren] ;
	NSInteger oNC = [other numberOfChildren] ;
	if (abs((int)(sNC-oNC)) > 0) {
		result = (sNC > oNC)
		?
		NSOrderedDescending : NSOrderedAscending ;
		goto end ;
	}
	
	// If one has more tags, it is better.
	sv = [self tags] ;
	ov = [other tags] ;
	if ((sv || ov) && ([sv count] != [ov count])) {
		result = ([sv count] > [ov count]) 
		?
		NSOrderedDescending : NSOrderedAscending ;			
		goto end ;
	}
	
	// Added in BookMacster 1.21.5
    // If one is http:// and the other is https:// , https:// is better.
    NSString* sUrlString = [self url] ;
    NSString* oUrlString = [other url] ;
    if (sUrlString && oUrlString) {
        NSURL* sUrl = [[NSURL alloc] initWithString:sUrlString] ;
        NSURL* oUrl = [[NSURL alloc] initWithString:oUrlString] ;
        if ([[sUrl scheme] isEqualToString:@"http"]) {
            if ([[oUrl scheme] isEqualToString:@"https"]) {
                // other is better
                result = NSOrderedAscending ;
                [sUrl release] ;
                [oUrl release] ;
                goto end ;
            }
        }
        if ([[oUrl scheme] isEqualToString:@"http"]) {
            if ([[sUrl scheme] isEqualToString:@"https"]) {
                // self is better
                result = NSOrderedDescending ;
                [sUrl release] ;
                [oUrl release] ;
                goto end ;
            }
        }
        [sUrl release] ;
        [oUrl release] ;
    }
    
    // If one is buried deeper, it is better.
	NSInteger sl = [self lineageDepth] ;
	NSInteger ol = [other lineageDepth] ;
	if (abs((int)(sl-ol)) > 0) {
		result = (sl > ol)
		?
		NSOrderedDescending : NSOrderedAscending ;
		goto end ;
	}
	
	// If both have Last Modified dates, and one is more than 5 minutes
	// newer than the other, it is better.
	sv = [self lastModifiedDate] ;
	ov = [other lastModifiedDate] ;
	// NSTimeInterval is 8 bytes, therefore if sv or ov are nil,
	// sending them -timeIntervalSinceReferenceDate could result
	// in garbage.  Search for text "guaranteed to work" in
	// http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
	NSTimeInterval st = sv ? [sv timeIntervalSinceReferenceDate] : 0.0 ;
	NSTimeInterval ot = ov ? [sv timeIntervalSinceReferenceDate] : 0.0 ;		
	// Ignore differences less than 5 minutes
	if (sv && ov && (fabs(st-ot) > 300)) {
		result = (st > ot)
		?
		NSOrderedDescending : NSOrderedAscending ;
		goto end ;
	}
	
	// If one has a longer comments, it is better
	sv = [self comments] ;
	ov = [other comments] ;
	if ((sv || ov) && ([sv length] != [ov length])){
		result = ([sv length] > [ov length])  
		?
		NSOrderedDescending : NSOrderedAscending ;
		goto end ;
	}
	
	// If one has a longer name, it is better
	sv = [self name] ;
	ov = [other name] ;
	if ((sv || ov) && ([sv length] != [ov length])) {
		result = ([sv length] > [ov length])  
		?
		NSOrderedDescending : NSOrderedAscending ;
		goto end ;
	}

	// If one is marked 'dontVerify = YES', it is better
	sv = [self dontVerify] ;
	ov = [other dontVerify] ;
	if ([sv boolValue] || [ov boolValue]) {
		result = [sv boolValue]  
		?
		NSOrderedDescending : NSOrderedAscending ;
		goto end ;
	}
	
end:;
	return result ;
}

// This method will recurse into children if height > 0
// and will decrement height on each recursion.
// For an unlimited deep search set height to INT_MAX
- (void)classifyBySharypeHeight:(NSInteger)height
					 hartainers:(NSMutableArray*)hartainers
					softFolders:(NSMutableArray*)softFolders
						 leaves:(NSMutableArray*)leaves
						notches:(NSMutableArray*)notches {
	Sharype sharype = [self sharypeValue] ;
	switch (sharype) {
		case SharypeBookmark:
		case SharypeLiveRSS:
			[leaves addObject:self] ;
			break ;
		case SharypeSeparator:
			[notches addObject:self] ;
			break ;
			
			// The remaining types can have children
			// and thus will require a recursion
		case SharypeSoftFolder:
			[softFolders addObject:self] ;
		default:  // root, bar, menu, shared, undefined??
			if (![StarkTyper isMoveableSharype:sharype]) {
				// The above is to exclude SharypeSoftFolder and SharypeLiveRSS
				// (because there was no break after previous case:)
				[hartainers addObject:self] ;
			}
			
			// Recurse into children
			if (height > 0) {
				// Use childrenOrdered since we need the output
				// to be ordered.
				NSArray* descendants = [self childrenOrdered] ;
				height-- ;
				for (Stark* descendant in descendants) {
					[descendant classifyBySharypeHeight:height
											 hartainers:hartainers
											softFolders:softFolders
												 leaves:leaves
												notches:notches] ;
				}  
			}
	}
}

- (void)classifyBySharypeDeeply:(BOOL)deeply
					 hartainers:(NSMutableArray*)hartainers
					softFolders:(NSMutableArray*)folders
						 leaves:(NSMutableArray*)leaves
						notches:(NSMutableArray*)notches {
	NSInteger height = deeply ? NSIntegerMax : 0 ;  // Until BookMacster 1.12.7, "0" was "1"
	return [self classifyBySharypeHeight:height
							  hartainers:hartainers
							 softFolders:folders
								  leaves:leaves
								 notches:notches] ;
}

/*!
 @brief    Recursive worker for -descendantsWithSelf:
*/
- (void)collectDescendantsInArray:(NSMutableArray*)array {
	// Use childrenOrdered since we need the output
	// to be ordered.
	NSArray* descendants = [self childrenOrdered] ;
	for (Stark* descendant in descendants) {
		if (descendant == self) {
			NSLog(@"Internal Error 521-8205 Own child: %@", self) ;
			break ;
		}
		[array addObject:descendant] ;
		[descendant collectDescendantsInArray:array] ;
	}  
}

- (NSMutableArray*)descendantsWithSelf:(BOOL)withSelf {
	NSMutableArray* array = [NSMutableArray array] ;
	if (withSelf) {
		[array addObject:self] ;
	}
	[self collectDescendantsInArray:array] ;
	
	return array ;
}

- (NSInteger)sortSegment:(id)segment
           startingIndex:(NSInteger)index {
    if ([segment respondsToSelector:@selector(sortUsingSelector:)]) {
        // piece is a sub-array of items between separators
        NSMutableArray* segmentMutant = [segment mutableCopy];
        [segmentMutant sortUsingSelector:@selector(compare:)];
        for (Stark* item in segmentMutant) {
            [item setIndexValue:index];
            index++ ;
        }
        [segmentMutant release];
    }
    else {
        // segment is a separator
        [segment setIndexValue:index];
        index++ ;
    }
    
    return index;
}

- (void)sortShallowly {
	if ([self isRoot] ?
		[[[(BkmxDoc*)[self owner] shig] rootSortable] boolValue]
		: [self shouldSort]) {
        NSArray* myChildren = [self childrenOrdered] ;
        
        // First, segment at separators
		NSArray* segments = [myChildren chopAtSeparators];
        /* Note that the elements of segments are a mixture of subarrays
         (NSArray objects) and separators (Stark objects) */

        // Next, if so configured, segment further into Folder and Bookmark segments
        Bookshig* shig = [(BkmxDoc*)[self owner] shig]; // owner must be a BkmxDoc, not an Extore
        BkmxSortingSegmentation sortingSegmentation = (BkmxSortingSegmentation)[[shig sortingSegmentation] integerValue];
        if (sortingSegmentation != BkmxSortingSegmentationMixAndSortAll) {
            BOOL foldersAtTop = (
                                 (sortingSegmentation == BkmxSortingSegmentationFoldersAtTopSortingBoth) ||
                                 (sortingSegmentation == BkmxSortingSegmentationFoldersAtTopSortingFoldersOnly) ||
                                 (sortingSegmentation == BkmxSortingSegmentationFoldersAtTopSortingBookmarksOnly)
                                 );
            NSInteger index = 0;
            for (id segment in segments) {
                if ([segment respondsToSelector:@selector(sortUsingSelector:)]) {
                    // Must split each segment into two segments
                    NSMutableArray* folders = [NSMutableArray new];
                    NSMutableArray* bookmarks = [NSMutableArray new];
                    [segment segmentIntoFolders:(NSMutableArray*)folders
                                      bookmarks:(NSMutableArray*)bookmarks];
                    if (foldersAtTop) {
                        if (sortingSegmentation == BkmxSortingSegmentationFoldersAtTopSortingBoth) {
                            index = [self sortSegment:folders
                                        startingIndex:index];
                            index = [self sortSegment:bookmarks
                                        startingIndex:index];
                        } else if (sortingSegmentation == BkmxSortingSegmentationFoldersAtTopSortingFoldersOnly) {
                            index = [self sortSegment:folders
                                        startingIndex:index];
                            for (Stark* bookmark in bookmarks) {
                                [bookmark setIndexValue:index++];
                            }
                        } else if (sortingSegmentation == BkmxSortingSegmentationFoldersAtTopSortingBookmarksOnly) {
                            for (Stark* folder in folders) {
                                [folder setIndexValue:index++];
                            }
                            index = [self sortSegment:bookmarks
                                        startingIndex:index];
                        }
                    } else {  // folders at bottom
                        if (sortingSegmentation == BkmxSortingSegmentationFoldersAtBottomSortingBoth) {
                            index = [self sortSegment:bookmarks
                                        startingIndex:index];
                            index = [self sortSegment:folders
                                        startingIndex:index];
                        } else if (sortingSegmentation == BkmxSortingSegmentationFoldersAtBottomSortingFoldersOnly) {
                            for (Stark* bookmark in bookmarks) {
                                [bookmark setIndexValue:index++];
                            }
                            index = [self sortSegment:folders
                                        startingIndex:index];
                        } else if (sortingSegmentation == BkmxSortingSegmentationFoldersAtBottomSortingBookmarksOnly) {
                            index = [self sortSegment:bookmarks
                                        startingIndex:index];
                            for (Stark* folder in folders) {
                                [folder setIndexValue:index++];
                            }
                        }
                    }
                    [folders release];
                    [bookmarks release];
                }
                else {
                    // segment is a separator itself
                    index++;
                }
            }
        } else {
            NSInteger index = 0;
            for (id segment in segments) {
                index = [self sortSegment:segment
                            startingIndex:index];
            }
        }
	}
}

+ (void)sortBy:(NSMenuItem*)sender {
	NSArray* starks = [sender representedObject] ;
	if ([starks count] < 1) {
		return ;
	}
	
	BkmxSortBy sortBy = (BkmxSortBy)[sender tag] ;
	NSString* sortKey = nil ;
	SEL comparator = NULL ;
	BOOL ascending ;
	switch (sortBy) {
		case BkmxSortByName:
			sortKey = constKeyName ;
			ascending = YES ;
			comparator = @selector(localizedCaseInsensitiveCompare:) ;
			break;
		case BkmxSortByUrl:
			sortKey = constKeyUrl ;
			ascending = YES ;
			comparator = @selector(localizedCaseInsensitiveCompare:) ;
			break;
		case BkmxSortByDomainHostPath:
			sortKey = constKeyUrl ;
			ascending = YES ;
			comparator = @selector(compareByDomainHostPathWith:) ;
			break;
		case BkmxSortByShortcut:
			sortKey = constKeyShortcut ;
			ascending = YES ;
			comparator = @selector(localizedCaseInsensitiveCompare:) ;
			break;
		case BkmxSortByAddDate:
			sortKey = constKeyAddDate ;
			ascending = NO ;
			comparator = @selector(compare:) ;
			break;
		case BkmxSortByLastModified:
			sortKey = constKeyLastModifiedDate ;
			ascending = NO ;
			comparator = @selector(compare:) ;
			break;
		case BkmxSortByLastVisited:
			sortKey = constKeyLastVisitedDate ;
			ascending = NO ;
			comparator = @selector(compare:) ;
			break;
		case BkmxSortByVerifyStatusCode:
			sortKey = constKeyVerifierCode ;
			ascending = YES ;
			comparator = @selector(compare:) ;
			break;
		case BkmxSortByVisitCount:
			sortKey = constKeyVisitCount ;
			ascending = NO ;
			comparator = @selector(compare:) ;
			break;
		case BkmxSortByRating:
			sortKey = constKeyRating ;
			ascending = NO ;
			comparator = @selector(compare:) ;
			break ;
	}
	
	for (Stark* stark in starks) {
		NSArray* children = [stark childrenOrdered] ;
		NSArray* pieces = [children chopAtSeparators] ;
		// The elements of separators alternate between sub-arrays and separators
		NSInteger index = 0 ;
		for (id piece in pieces) {
			if ([piece respondsToSelector:@selector(sortUsingSelector:)]) {
				// piece is a sub-array of items between separators
				piece = [piece mutableCopy] ;
				
				NSSortDescriptor* sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:sortKey
																			   ascending:ascending
                                                                                 selector:comparator] ;
                /* More sort descriptors, to ensure deterministic results.
                 Unlike in -compare:, here we are not concerned with churn
                 between Macs, so we can use `rating` and `starkId.` */
                NSSortDescriptor* sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:constKeySharype
																				ascending:YES
																				 selector:@selector(compare:)] ;
				NSSortDescriptor* sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:constKeyName
																				ascending:YES
																				 selector:@selector(localizedCaseInsensitiveCompare:)] ;
				NSSortDescriptor* sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:constKeyRating
																				ascending:NO
																				 selector:@selector(compare:)] ;
				NSSortDescriptor* sortDescriptor5 = [[NSSortDescriptor alloc] initWithKey:constKeyStarkid
																				ascending:YES
																				 selector:@selector(compare:)] ;
				NSArray* sortDescriptors = [NSArray arrayWithObjects:
											sortDescriptor1,
											sortDescriptor2,
											sortDescriptor3,
											sortDescriptor4,
											sortDescriptor5,
											nil] ;
				[piece sortUsingDescriptors:sortDescriptors] ;
				[sortDescriptor1 release] ;
				[sortDescriptor2 release] ;
				[sortDescriptor3 release] ;
				[sortDescriptor4 release] ;
				[sortDescriptor5 release] ;
				
				for (Stark* child in piece) {
					[child setIndexValue:index] ;
					index++ ;
				}
				[piece release] ;
			}
			else {
				// piece is a separator itself
				[piece setIndexValue:index] ;
				index++ ;
			}
		}
	}
	
	BOOL one = ([starks count] == 1) ;
	Stark* stark = [starks objectAtIndex:0] ;
	BkmxDoc* bkmxDoc = (BkmxDoc*)[stark owner] ;
	[bkmxDoc setUndoActionNameForAction:SSYModelChangeActionSort
								object:(one ? stark : nil)
							 objectKey:nil
							updatedKey:nil
								 count:(one ? 0 : [starks count])] ;
}

@end
