#import "Starker.h"
#import "Stark+Sorting.h"
#import "Stark+Attributability.h"
#import "BkmxBasis+Strings.h"
#import "NSObject+DoNil.h"
#import "NSManagedObjectContext+Cheats.h"
#import "NSNumber+Sharype.h"
#import "NSObject+MoreDescriptions.h"
#import "Client.h"
#import "Exporter.h"
#import "BkmxDoc.h"

// Needed for Note 201300815
#import "NSError+MyDomain.h"
#import "NSError+InfoAccess.h"
#import "NSError+SSYInfo.h"
#import "SSYAlert.h"

// Debugging
#import "StarkTyper.h"

@interface Starker ()

@property (retain) NSMutableSet* cachedAllObjects ;
@property (retain) NSDictionary* cachedStarksByKey ;
@property (retain) NSMutableDictionary* cachedHartainers ;
- (void)setRoot:(Stark*)root ;

@end

@implementation Starker

@synthesize cachedAllObjects = m_cachedAllObjects ;
@synthesize hartainersChangeCount = m_hartainersChangeCount ;
@synthesize cachedStarksByKey = m_cachedStarksByKey ;
@synthesize cachedHartainers = m_cachedHartainers ;
@synthesize destinees = m_destinees ;

+ (NSInteger)countOfBookmarksInItems:(NSArray*)starks {
	NSMutableArray* bookmarks = [[NSMutableArray alloc] init] ;
	for (Stark* stark in starks) {
		[stark classifyBySharypeDeeply:YES
							  hartainers:nil
						   softFolders:nil
								leaves:bookmarks
							   notches:nil] ;
	}
	
	NSInteger countOfBookmarksInSelection = [bookmarks count] ;
	[bookmarks release] ;
	
	return countOfBookmarksInSelection ;
}

+ (NSInteger)areSortableItems:(NSArray*)starks {
	BOOL committed = NO ;
	BOOL commitment = NO ;
	BOOL consistent = YES ;
	NSInteger answer ;
	if ([starks count] > 0) {
		for (Stark* item in starks) {
			if ([item canHaveChildren]) {
				BOOL thisValue = [[item sortable] boolValue] ;
				if (!committed) {
					commitment = thisValue ;
					committed = YES ;
				}
				else if (thisValue != commitment) {
					consistent = NO ;
					break ;
				}
			}					
		}

		if (!consistent) {
			answer = NSControlStateValueMixed ;
		}
		else {
			answer = commitment ;
		}
	}
	else {
		answer = NSControlStateValueMixed ;
	}
			
	return answer ;
}

#pragma mark * Accessors

@synthesize owner = m_owner ;

#pragma mark * Basic Infrastructure

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext_
							 owner:(NSObject <SSYErrorHandler> *)owner {
	if (managedObjectContext_ && owner) {
		self = [super initWithManagedObjectContext:managedObjectContext_
										entityName:constEntityNameStark] ;
		if (self != nil) {
			[self setOwner:owner] ;
			[[NSNotificationCenter defaultCenter] addObserver:self 
													 selector:@selector(objectsChangedNote:)
														 name:NSManagedObjectContextObjectsDidChangeNotification
													   object:managedObjectContext_] ;
		}
	}
	else {
		// See http://lists.apple.com/archives/Objc-language/2008/Sep/msg00133.html ...
		[super dealloc] ;
		self = nil ;
	}
	
	return self ;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self] ;

	[clientoid release] ;
	[m_root release] ;
	[m_cachedAllObjects release] ;
	[m_cachedStarksByKey release] ;
	[m_cachedHartainers release] ;
	[m_destinees release] ;
	
	[super dealloc];
}

- (void)processPendingChanges {
	[[self managedObjectContext] processPendingChanges] ;
}

#pragma mark * Special Methods for Starks

- (NSArray*)allNonRootStarks {
	// There does not seem to be any NSPredicate operator to do bit masks.
	// However, I did a test of a similar problem (finding fatCat employees),
	// in a modification of Apple's DepartmentsAndEmployees sample code,
	// and found that performance was the same between this method
	// (fetch all, then filter) as opposed to fetching with a filtering
	// predicate.  The extra time spent in doing the filtering is compensated
	// for because fetching without a predicate is faster than with.
	NSArray* allStarks = [self allStarks] ;
	NSMutableArray* allNonRootStarks = [[NSMutableArray alloc] init] ;
	for (Stark* stark in allStarks) {
		if (![StarkTyper isRootSharype:[stark sharypeValue]]) {
			[allNonRootStarks addObject:stark] ;
		}
	}
	
	NSArray* answer = [NSArray arrayWithArray:allNonRootStarks] ;
	[allNonRootStarks release] ;
	
	return answer ;
}

- (NSSet*)allObjectsQuickly {
	NSSet* allObjects = [self cachedAllObjects] ;
	if (!allObjects) {
		NSError* error = nil ;
		allObjects = [NSSet setWithArray:[super allObjectsError_p:&error]] ;
		[SSYAlert alertError:error] ;
		NSMutableSet* mutableAllObjects = [allObjects mutableCopy] ;
		[self setCachedAllObjects:mutableAllObjects] ;
		[mutableAllObjects release] ;
	}
	
	return allObjects ;
}

- (void)objectsChangedNote:(NSNotification*)note {
    NSArray* objects ;
    BOOL hartainersDidChange = NO ;

	// Process deletions (cacheAllObjects and/or hartainersDidChange)
	objects = [[note userInfo] objectForKey:NSDeletedObjectsKey] ;
    for (NSManagedObject* object in objects) {
        if ([object isKindOfClass:[Stark class]]) {
			[[self cachedAllObjects] removeObject:object] ;

			Stark* stark = (Stark*)object ;
            if ([stark sharypeCoarseValue] == SharypeCoarseHartainer) {
               // A hartainer was deleted
                hartainersDidChange = YES ;
            }
		}
	}

	// Process insertions (cacheAllObjects and/or hartainersDidChange)
    objects = [[note userInfo] objectForKey:NSInsertedObjectsKey] ;
    for (NSManagedObject* object in objects) {
        if ([object isKindOfClass:[Stark class]]) {
            // Note that if -cachedAllObjects had to do a fetch in order
            // to re-establish the cache, it will probably already contain
            // the new object, and thus the following will have no effect.
            [[self cachedAllObjects] addObject:object] ;
            
            Stark* stark = (Stark*)object ;            
            if ([stark sharypeCoarseValue] == SharypeCoarseHartainer) {
                // A hartainer was inserted.  This does not happen with
                // Core Data in macOS 10.8, because, to insert a hartainer,
                // this method runs twice, first when a new stark with
                // null attributes is inserted (not a hartainer yet) and
                // second to update its attributes.  So, in macOS 10.8,
                // this branch never executes.  But it seems like this is
                // a Core Data implementation detail that might change.
                hartainersDidChange = YES ;
            }
        }
    }

	// Process updates
	objects = [[note userInfo] objectForKey:NSUpdatedObjectsKey] ;
    for (NSManagedObject* object in objects) {
        if ([object isKindOfClass:[Stark class]]) {
			Stark* stark = (Stark*)object ;

            if ([stark sharypeCoarseValue] == SharypeCoarseHartainer) {
                // A stark could have been changed into a hartainer.  This is
                // typically how a new hartainer is inserted; it is first
                // inserted with null attributes.
                hartainersDidChange = YES ;
            }
            
            if ([[self owner] isKindOfClass:[BkmxDoc class]]) {
                BkmxDoc* bkmxDoc = (BkmxDoc*)[self owner] ;
                Stark* lastLandedBookmark = [bkmxDoc lastLandedBookmark] ;
                if (stark == lastLandedBookmark) {
                    [bkmxDoc addRecentLanding:[stark parent]] ;
                }
            }
		}
	}
    
	// Effect hartainer changes
    if (hartainersDidChange) {
		[self setHartainersChangeCount:[self hartainersChangeCount] + 1] ;
        if ([[self owner] respondsToSelector:@selector(refreshHasHartainersCache)]) {
            BkmxDoc* bkmxDoc = (BkmxDoc*)[self owner] ;
            [bkmxDoc refreshHasHartainersCache] ;
        }
	}
}

- (NSSet*)allSoftStarksQuickly:(BOOL)quickly {
	// There does not seem to be any NSPredicate operator to do bit masks.
	// However, I did a test of a similar problem (finding fatCat employees),
	// in a modification of Apple's DepartmentsAndEmployees sample code,
	// and found that performance was the same between this method
	// (fetch all, then filter) as opposed to fetching with a filtering
	// predicate.  The extra time spent in doing the filtering is compensated
	// for because fetching without a predicate is faster than with.
	NSSet* allStarks = quickly ? [self allObjectsQuickly] : [NSSet setWithArray:[self allStarks]] ;
	NSMutableSet* allSoftStarks = [[NSMutableSet alloc] init] ;
	for (Stark* stark in allStarks) {
		if (![StarkTyper isHartainerCoarseSharype:[stark sharypeValue]]) {
			[allSoftStarks addObject:stark] ;
		}
	}
	
	NSSet* answer = [NSSet setWithSet:allSoftStarks] ;
	[allSoftStarks release] ;
	
	return answer ;
}

- (NSArray*)allNonhierarchicalStarks {
	// See Note on Bit Mask Predicates, below
	NSArray* allStarks = [self allStarks] ;
	NSMutableArray* allNonhierarchicalStarks = [[NSMutableArray alloc] init] ;
	for (Stark* stark in allStarks) {
		if ([StarkTyper doesDisplayInNoFoldersViewSharype:[stark sharypeValue]]) {
			[allNonhierarchicalStarks addObject:stark] ;
		}
	}
	
	NSArray* answer = [NSArray arrayWithArray:allNonhierarchicalStarks] ;
	[allNonhierarchicalStarks release] ;
	
	return answer ;
}

- (NSArray*)allSeparatorStarks {
	NSExpression* lhs = [NSExpression expressionForKeyPath:constKeySharype] ;
	NSExpression* rhs = [NSExpression expressionForConstantValue:[NSNumber numberWithInteger:SharypeSeparator]];
	NSError* error = nil ;
	NSArray* answer = [self objectsWithDirectPredicateLeftExpression:lhs
													 rightExpression:rhs
														operatorType:NSEqualToPredicateOperatorType
															 error_p:&error] ;
	[SSYAlert alertError:error] ;
	return answer ;
}

- (NSSet*)allShortcuts {
	NSArray* allBookmarks = [[self root] extractLeavesOnly]	;
	NSMutableSet* shortcuts = [[NSMutableSet alloc] init] ;
	for (Stark* bookmark in allBookmarks) {
		NSString* shortcut = [bookmark shortcut] ;
		if (shortcut != nil) {
			[shortcuts addObject:shortcut] ;
		}
	}
	
	return [shortcuts autorelease] ;
}

- (Stark*)starkWithEqualValueForKey:(NSString*)key
							asStark:(Stark*)stark {
	Stark* answer = nil ;
	if ([[[[[self managedObjectContext] store1] URL] scheme] isEqualToString:@"file"]) {
		for (Stark* aStark in [self allObjectsQuickly]) {
			if ([NSObject isEqualHandlesNilObject1:[stark url]
										   object2:[aStark url]]) {
				answer = aStark ;
				break ;
			}
		}
	}
	else {
		NSExpression* lhs = [NSExpression expressionForKeyPath:key] ;
		NSExpression* rhs = [NSExpression expressionForConstantValue:[stark valueForKey:key]] ;
		NSError* error = nil ;
		answer = (Stark*)[self objectWithDirectPredicateLeftExpression:lhs
													   rightExpression:rhs
														  operatorType:NSEqualToPredicateOperatorType
															   error_p:&error] ;
		[SSYAlert alertError:error] ;
	}		

	return answer ;
}

- (NSDictionary*)starksKeyedByKey:(NSString*)key {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init] ;
	for (Stark* stark in [self allStarks]) {
		id keyValue = [stark valueForKey:key] ;
		// The following condition was added in BookMacster 1.8 as defensive programming,
		// after an upstream bug allowed a Delicious bookmark with nil url into starker.
		if (keyValue) {
			[dic setValue:stark
				   forKey:keyValue] ;
		}
	}
	
	NSDictionary* answer = [dic copy] ;
	[dic release] ;
	
	return [answer autorelease] ;
}

- (NSArray*)matchedStarks {
	NSExpression* lhs = [NSExpression expressionForKeyPath:constKeySponsorIndex] ;
	NSExpression* rhs = [NSExpression expressionForConstantValue:nil];  
	// Note: Could also use [NSNull null] instead of nil.  Fetches and doesn't-fetch same.
	
	NSError* error = nil ;
	NSArray* answer = [self objectsWithDirectPredicateLeftExpression:lhs
										  rightExpression:rhs
											 operatorType:NSNotEqualToPredicateOperatorType
												  error_p:&error] ;
	[SSYAlert alertError:error] ;
	return answer ;
}

- (NSArray*)unmatchedStarks {
	NSExpression* lhs = [NSExpression expressionForKeyPath:constKeySponsorIndex] ;
	NSExpression* rhs = [NSExpression expressionForConstantValue:nil];
	// Note: Could also use [NSNull null] instead of nil.  Fetches and doesn't-fetch same.
	
	NSError* error = nil ;
	NSArray* answer = [self objectsWithDirectPredicateLeftExpression:lhs
													 rightExpression:rhs
														operatorType:NSEqualToPredicateOperatorType
															 error_p:&error] ;
	[SSYAlert alertError:error] ;
	return answer ;
}

- (void)setAllStarksNotMatched {
	for (Stark* stark in [self allStarks]) {
		[stark setSponsorIndex:nil] ;
	}
}

- (void)setValue:(id)value
		  forKey:(NSString*)key
		inStarks:(id)starks {
	if ([starks count] > 0) {
		for (Stark* stark in starks) {
			[stark setValue:value
					 forKey:key] ;
		}
	}
}

- (Stark*)starkOfSharype:(Sharype)sharype {
	// Try to read from moc
	NSExpression* lhs = [NSExpression expressionForKeyPath:constKeySharype] ;
	NSExpression* rhs = [NSExpression expressionForConstantValue:[NSNumber numberWithInteger:sharype]];
	NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:lhs
																rightExpression:rhs
																	   modifier:NSDirectPredicateModifier
																		   type:NSEqualToPredicateOperatorType
																		options:0] ;
	NSError* error = nil ;
    Stark* stark = (Stark*)[self objectWithPredicate:predicate
                                             error_p:&error] ;
    [SSYAlert alertError:error] ;
	return stark ;
}

- (Stark*)root {
	Stark* root ;
	@synchronized(self) {
		// First, try the cached, instance variable	
		if (!m_root) {
			// Second, try fetching
			m_root = [self starkOfSharype:SharypeRoot] ;
			[m_root retain] ;
		}
		
		if (!m_root) {
			// Third, insert new
			m_root = [self freshStark] ;
			[m_root setSharypeValue:SharypeRoot] ;
			// Never seen by user but nice for debugging:
			[m_root setName:[[BkmxBasis sharedBasis] labelRoot]] ;
			[m_root retain] ;
		}

		root = [[m_root retain] autorelease] ;
	}
	return root ;
}

- (void)setRoot:(Stark*)root {
	@synchronized(self) {
		if (root != m_root) {
			[m_root release];
			m_root = [root retain] ;
		}
	}
}


- (Stark*)rootChildOfSharype:(Sharype)sharype {
	Stark* root = [self root] ;
	Stark* answer = [root firstChildOfSharype:sharype] ;
	return answer ;
}

- (Stark*)bar {
	return [self rootChildOfSharype:SharypeBar] ;
}

- (Stark*)menu {
	return [self rootChildOfSharype:SharypeMenu] ;
}

- (Stark*)unfiled {
	return [self rootChildOfSharype:SharypeUnfiled] ;
}

- (Stark*)ohared {
	return [self rootChildOfSharype:SharypeOhared] ;
}

- (Stark*)freshStark {
	Stark* stark = (Stark*)[self freshObject] ;
 
	return stark ;
}

- (Stark*)freshDatedStark {
	Stark* stark = [self freshStark] ;
	NSDate* date = [NSDate date] ;
	[stark setAddDate:date] ;
	[stark setLastModifiedDate:date] ;
	return stark ;
}

- (Stark*)freshBookMacsterizer {
	Stark* stark = [self freshDatedStark] ;
	[stark setSharypeValue:SharypeBookmark] ;
	[stark setName:[[BkmxBasis sharedBasis] bookmacsterizeName]] ;
	[stark setSortDirectiveValue:BkmxSortDirectiveBottom] ;
	[stark setComments:[[BkmxBasis sharedBasis] bookmacsterizeComments]] ;
	[stark setUrl:constUrlBookmacsterizer] ;
	// The getSelection() function works only for static text, not text that user has entered in, for example, a textarea.
	return stark ;
}

+ (void)populateStarkets:(NSMutableDictionary*)starkets
 keyedByExidForClientoid:(Clientoid*)clientoid
               fromArray:(NSArray*)starks {
	for (Stark* stark in starks) {
		NSString* exid = [stark exidForClientoid:clientoid] ;
		if (exid) {
            id object = [starkets objectForKey:exid] ;
            if (object == nil) {
                // No existing object
                object = stark ;
            }
            else if ([object isKindOfClass:[NSSet class]]) {
                // Existing object contains two existing starks
                object = [object setByAddingObject:stark] ;
            }
            else {
                // Existing starket is a single stark
                object = [NSSet setWithObjects:stark, object, nil] ;
            }

            [starkets setObject:object
                         forKey:exid] ;
		}
	}
}

- (void)insertStarkLikeStark:(Stark*)otherStark {
	Stark* stark = [self freshStark] ;
	[stark overwriteAttributesFromStark:otherStark] ;
}

- (BOOL)save:(NSError**)error_ {
	return [[self managedObjectContext] save:error_] ;
}	

- (void)logTreeWithMarker:(NSString*)marker {
	NSArray* all = [self allStarks] ;
	NSLog(@"*** %@ *** %ld starks in moc ***", marker, (long)[all count]) ;
	for (Stark* stark in all) {
//		NSLog(@"   %@ %p has %ld children, parent = %@", [stark name], stark, (long)[stark numberOfChildren], [[stark parent] name]) ;
		NSLog(@"   %@ %p has %ld children, isSponsored = %hhd", [stark name], stark, (long)[stark numberOfChildren], (BOOL)(stark.sponsorIndex.integerValue >= 0)) ;
	}
}

- (NSArray*)allStarks {
	NSError* error = nil ;
	NSArray* answer = [super allObjectsError_p:&error] ;
	[SSYAlert alertError:error] ;
	return answer ;
}

- (void)clearCaches {
	[self setRoot:nil] ;
	[self setCachedAllObjects:nil] ;
	[self setCachedStarksByKey:nil] ;
	[self setCachedHartainers:nil] ;
}

- (NSInteger)finalizeStarksLastModifiedDates {
	NSInteger count = 0 ;
	for (Stark* stark in [self allStarks]) {
		BOOL hasChanges = [stark finalizeLastModifiedDate] ;
		if (hasChanges) {
			count++ ;
		}
	}
	
	return count ;
}

- (void)refreshHartainersCache {
	// There does not seem to be any NSPredicate operator to do bit masks.
    // UPDATE: Oh, yes it does…
    // https://stackoverflow.com/questions/30789546/nspredicate-with-bitmask-for-filtering-nsarray
    // /UPDATE
	// However, I did a test of a similar problem (finding fatCat employees),
	// in a modification of Apple's DepartmentsAndEmployees sample code,
	// and found that performance was the same between this method
	// (fetch all, then filter) as opposed to fetching with a filtering
	// predicate.  The extra time spent in doing the filtering is compensated
	// for because fetching without a predicate is faster than with.
	NSArray* allStarks = [self allStarks] ;
	NSMutableDictionary* allHartainers = [[NSMutableDictionary alloc] init] ;
	for (Stark* stark in allStarks) {
		NSNumber* sharype = [stark sharype] ;
		if ([StarkTyper isHartainerCoarseSharype:[sharype sharypeValue]]) {
			[allHartainers setObject:stark
							  forKey:sharype] ;
		}
	}

	[self setCachedHartainers:allHartainers] ;
	[allHartainers release] ;
}

- (void)forgetHartainersCache {
	[self setCachedHartainers:nil] ;
}

- (Stark*)makeStandinSharype:(Sharype)sharype {
	if ([self cachedHartainers] == nil) {
		[self refreshHartainersCache] ;
	}

	Stark* standin = nil ;
	NSNumber* key = [NSNumber numberWithSharype:sharype] ;
	if (![[self cachedHartainers] objectForKey:key]) {
        // Hartainer is missing.  Must make one.
		standin = [self freshStark] ;
		[standin setSharype:key] ;
		[[self cachedHartainers] setObject:standin
									forKey:key] ;
	}
	
	return standin ;
}

- (NSSet<Stark*>*)allHartainers {
    if (![self cachedHartainers]) {
        [self refreshHartainersCache];
    }
    return [NSSet setWithArray:[[self cachedHartainers] allValues]];
}

- (Stark*)hartainerOfSharype:(Sharype)sharype
					 quickly:(BOOL)quickly {
	if (!quickly & ![self cachedHartainers]) {
		[self refreshHartainersCache] ;
	}
	
	return [[self cachedHartainers] objectForKey:[NSNumber numberWithSharype:sharype]] ;
}

- (Stark*)clearStandinHartainerSharype:(Sharype)sharype
		  				    traceLevel:(NSInteger)traceLevel {
	Stark* standin = nil ;
	if ([self cachedHartainers]) {
		id owner = [self owner] ;
		NSObject <StarCatcher> * starCatcher ;
		if ([owner conformsToProtocol:@protocol(StarCatcher)]) {
			starCatcher = owner ;
		}
		else {
			if ([owner respondsToSelector:@selector(client)]) {
				starCatcher = [(Client*)[owner client] exporter] ;
			}
			else {
				NSLog(@"Internal Error 892-4324 %@", owner) ;
				return nil ;
			}
		}		
		
		BOOL keepIt ;
		switch (sharype) {
			case SharypeBar:
				keepIt = [starCatcher hasBar] ;
				break ;
			case SharypeMenu:
                keepIt = [starCatcher hasMenu] ;
				break ;
			case SharypeUnfiled:
				keepIt = [starCatcher hasUnfiled] ;
				break ;
			case SharypeOhared:
				keepIt = [starCatcher hasOhared] ;
				break ;
			default:
				NSLog(@"Internal Error 625-0190 %hd", sharype) ;
				keepIt = YES ;
		}
		
		if (!keepIt) {
			NSString* logEntry ;
			
			if (traceLevel > 3) {
				logEntry = [[NSString alloc] initWithFormat:@"80596:    Clearing out %@ since %@ doesn't have one.\n", [StarkTyper readableSharype:sharype], [starCatcher displayName]] ;
#if LOG_TO_CONSOLE_TOO
				NSLog(@"%@", logEntry) ;
#endif
				[[BkmxBasis sharedBasis] trace:logEntry] ;
				[logEntry release] ;
			}
			NSNumber* key = [NSNumber numberWithSharype:sharype] ;
			standin = [[self cachedHartainers] objectForKey:key] ;
			NSArray* childrenNeedingToBeMoved = [standin childrenOrdered] ;
			NSMutableSet* affectedDonees = [[NSMutableSet alloc] init] ;
			NSNumber* lastSponsorIndex = [NSNumber numberWithInteger:NSNotFound/2] ;
			for (Stark* child in childrenNeedingToBeMoved) {
				Stark* donee = [starCatcher fosterParentForStark:child] ;
				NSInteger index = [[donee owner] hasOrder] ? NSNotFound : DONT_SET_THE_INDEX ;
				// DONT_SET_THE_INDEX was added in BookMacster 1.11,
				// to eliminate churn when exporting to flat extores,
                // although originally it was -1.
				[child moveToBkmxParent:donee
								atIndex:index
								restack:NO] ;
				// Starting in BookMacster 1.11, we use lastSponsorIndex so that the
				// donated children appear below the original children.
				[child setSponsorIndex:lastSponsorIndex] ;
				if (traceLevel > 3) {
					logEntry = [[NSString alloc] initWithFormat:@"80796:       Set sponsorIndex %lx, moved to %@: %@.\n", (long)[lastSponsorIndex integerValue], [donee name], [child shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
					NSLog(@"%@", logEntry) ;
#endif
					[[BkmxBasis sharedBasis] trace:logEntry] ;
					[logEntry release] ;
				}
				// Condition index != DONT_SET_THE_INDEX was added in BookMacster 1.11.3 to eliminate
				// apparent churn (in Status Bar and Sync Log, not actual churn) when
				// exporting to ExtoreWebFlat extores.  (Actual churn was avoided
				// because pendingAdditions and pendingDeletions are checked for 
				// -[Extore supportedAttributesAreEqualComparingStark:otherStark:ixportStyle:]
				// in -[ExtoreWebFlat writeUsingStyle1InOperation:].)
				if (index != DONT_SET_THE_INDEX) {
					[affectedDonees addObject:donee] ;
				}
			}
			
			// Added in BookMacster 1.11 after fixing -[Stark moveToBkmsParent:atIndex:restack:]
			// so that restack:NO really meant NO instead of HALFWAY made this necessary…
			for (Stark* donee in affectedDonees) {
				[donee restackChildrenOfHartainerForGulp] ;
				if (traceLevel > 3) {
					logEntry = [[NSString alloc] initWithFormat:@"80896:    Restacked donee %@:\n%@\n", [donee name], [[donee childrenOrdered] shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
					NSLog(@"%@", logEntry) ;
#endif
					[[BkmxBasis sharedBasis] trace:logEntry] ;
					[logEntry release] ;
				}
			}
			[affectedDonees release] ;
			
			[[self managedObjectContext] deleteObject:standin] ;
		}			
	}	

	return standin ;
}

// Note on Bit Mask Predicates
// There does not seem to be any NSPredicate operator to require that
// integer values (such as sharype) of objects (starks) match a certain
// bit mask.
// However, I did a test of a similar problem (finding fatCat employees),
// in a modification of Apple's DepartmentsAndEmployees sample code,
// and found that performance was the same between this method
// (fetch all, then filter) as opposed to fetching with a filtering
// predicate.  The extra time spent in doing the filtering is compensated
// for because fetching without a predicate is faster than with.

#pragma mark * Debugging

- (NSString*)description {
	return [NSString stringWithFormat:
			@"%@ for %@",
			[super description],
			[self owner]] ;
}

@end
