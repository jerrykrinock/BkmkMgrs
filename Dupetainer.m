#import "Dupetainer.h"
#import "Dupester.h"
#import "Dupe.h"
#import "Stark.h"
#import "BkmxDoc.h"
#import "Bookshig.h"
#import "NSSet+SimpleMutations.h"
#import "NSDate+NiceFormats.h"
#import "NSString+BkmxURLHelp.h"

NSString* const constKeyDupes = @"dupes" ;
NSString* const constKeyDupesOrdered = @"dupesOrdered" ;

@interface Dupetainer ()

@end

@interface Dupetainer (CoreDataGeneratedPrimitiveAccessors)

- (NSMutableSet*)primitiveDupes;
- (void)setPrimitiveDupes:(NSMutableSet*)value;

@end

@implementation Dupetainer

@dynamic dupes ;

- (void)initializeObservers {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(clearCache)
												 name:NSUndoManagerWillUndoChangeNotification
											   object:[[self managedObjectContext] undoManager]] ;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(clearCache)
												 name:NSUndoManagerWillRedoChangeNotification
											   object:[[self managedObjectContext] undoManager]] ;
}

- (void)awakeFromFetch {
	[super awakeFromFetch] ;
	[self initializeObservers] ;
}

- (void)awakeFromInsert {
	[super awakeFromInsert] ;
	[self initializeObservers] ;
}

- (void)didTurnIntoFault {
	/* cocoa-dev@lists.apple.com

	 On 20090812 20:41, Jerry Krinock said:
	 
	 Now I understand that if nilling an instance variable after releasing
	 it is done in -dealloc, it is papering over other memory management
	 problems and is therefore bad programming practice.  But I believe
	 that this practice is OK in -didTurnIntoFault because, particularly
	 when Undo is involved, -didTurnIntoFault may be invoked more than once
	 on an object.  Therefore nilling after releasing in -didTurnIntoFault
	 is recommended.
	 
	 On 20090812 22:06, Sean McBride said
	 
	 I made that discovery a few months back too, and I agree with your
	 reasoning and conclusions.  I also asked an Apple guy at WWDC and he
	 concurred too.
	 */
	[[NSNotificationCenter defaultCenter] removeObserver:self] ;
	
	[super didTurnIntoFault] ;
}

- (void)postWillSetNewDupes:(NSSet*)newValue {
	[self postWillSetNewValue:newValue
					   forKey:constKeyDupes] ;
}

- (void)setDupes:(NSSet*)value 
{    
	[self postWillSetNewDupes:value] ;
	
    [self willChangeValueForKey:constKeyDupes];
    [self setPrimitiveDupes:[NSMutableSet setWithSet:value]];
    [self didChangeValueForKey:constKeyDupes];
	[self clearCache] ;
}

- (void)addDupesObject:(Dupe *)value 
{    
	[self postWillSetNewDupes:[[self dupes] setByAddingObject:value]] ;
	
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyDupes withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveDupes] addObject:value];
    [self didChangeValueForKey:constKeyDupes withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	[self clearCache] ;
    
    [changedObjects release];
}

- (void)removeDupesObject:(Dupe *)value 
{
	[self postWillSetNewDupes:[[self dupes] setByRemovingObject:value]] ;
	
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyDupes withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveDupes] removeObject:value];
    [self didChangeValueForKey:constKeyDupes withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	[self clearCache] ;
    
    [changedObjects release];
}

- (void)addDupes:(NSSet *)value 
{    
	[self postWillSetNewDupes:[[self dupes] setByAddingObjectsFromSet:value]] ;
	
    [self willChangeValueForKey:constKeyDupes withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveDupes] unionSet:value];
    [self didChangeValueForKey:constKeyDupes withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
	[self clearCache] ;
}

- (void)removeDupes:(NSSet *)value 
{
	[self postWillSetNewDupes:[[self dupes] setByRemovingObjectsFromSet:value]] ;
	
    [self willChangeValueForKey:constKeyDupes withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveDupes] minusSet:value];
    [self didChangeValueForKey:constKeyDupes withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
	[self clearCache] ;
}

- (BOOL)hasOneOrMore {
	return ([[self dupes] count] > 0) ;
}
+ (NSSet*)keyPathsForValuesAffectingHasOneOrMore {
	return [NSSet setWithObjects:
			constKeyDupes,
			nil] ;
}

- (NSArray*)dupesOrdered {
	NSArray* dupesOrdered ;
	@synchronized(self) {
		if (!m_dupesOrdered) {
			m_dupesOrdered = [[[self dupes] allObjects] sortedArrayUsingSelector:@selector(compareUrls:)] ;
			[m_dupesOrdered  retain] ;
		}
		dupesOrdered = m_dupesOrdered ;
	}
	return dupesOrdered ;
}

- (void)clearDupesOrdered {
	@synchronized(self) {
		[m_dupesOrdered release] ;
		m_dupesOrdered = nil ;
	}
}

+ (NSSet*)keyPathsForValuesAffectingDupesOrdered {
	return [NSSet setWithObjects:
			constKeyDupes,
			nil] ;
}

- (void)clearCache {
	[self clearDupesOrdered] ;
}

- (void) dealloc {
	[m_dupesOrdered release] ;
	
	[super dealloc] ;
}


- (NSMutableDictionary*)allDupeDic {
	NSMutableDictionary* allDupeDic = [NSMutableDictionary dictionary] ;
	for (Dupe* dupe in [self dupes]) {
		[allDupeDic setObject:[[dupe starks] allObjects]
					   forKey:[dupe url]] ;
	}
	
	return allDupeDic ;
}

- (void)setDupesWithDictionary:(NSDictionary*)dupesDictionary {
	NSMutableSet* dupes_ = [[NSMutableSet alloc] init] ;
	Dupester* dupester = [[Dupester alloc] initWithManagedObjectContext:[self managedObjectContext]] ;
	
	for (NSString* url in dupesDictionary) {
		Dupe* dupe = (Dupe*)[dupester freshObject] ;
		[dupe setUrl:url] ;
		[dupe setStarks:[dupesDictionary objectForKey:url]] ;
		[dupes_ addObject:dupe] ;
	}
	
	[dupester release] ;
	
	[self setDupes:dupes_] ;
	[dupes_ release] ;
	
	// Removed 20090329.  Doubles the time required.  Should be done later, coalesced, by objectWillChangeNote:
	// [[[(BkmxDoc*)[self owner] bkmxDocWinCon] dupesOutlineView] reloadData] ;
}

- (void)checkAndRemoveDupeDisparagees {
	BOOL ignoreDisparateDupes = [[[(BkmxDoc*)[self owner] shig] ignoreDisparateDupes] boolValue] ;
	if (!ignoreDisparateDupes) {
		return ;
	}
	
	// See if any dupes are disparate
	
	Dupester* dupester = [[Dupester alloc] initWithManagedObjectContext:[self managedObjectContext]] ;

	NSMutableSet* newDupes = [[NSMutableSet alloc] init] ;
	// To avoid removing an object from [self dupes] while enumerating through
	// it, we enumerate a copy.
	NSSet* dupesCopy = [[self dupes] copy] ;
	for (Dupe* dupe in dupesCopy) {
		// To avoid removing an object from [dupe starks] while enumerating through
		// it, we collect them into a separate set.
		NSMutableSet* starksInRoot = [[NSMutableSet alloc] init] ;
		NSMutableSet* starksInBar = [[NSMutableSet alloc] init] ;
		NSMutableSet* starksInMenu = [[NSMutableSet alloc] init] ;
		NSMutableSet* starksInUnfiled = [[NSMutableSet alloc] init] ;
		NSMutableSet* starksInOhared = [[NSMutableSet alloc] init] ;
		Stark* stark ;
		for (stark in [dupe starks]) {
			Stark* collection = [stark collection] ;

			Sharype sharype = [collection sharypeValue] ;
			switch (sharype) {
				case SharypeRoot:
					[starksInRoot addObject:stark] ;
					break ;
				case SharypeBar:
					[starksInBar addObject:stark] ;
					break ;
				case SharypeMenu:
					[starksInMenu addObject:stark] ;
					break ;
				case SharypeUnfiled:
					[starksInUnfiled addObject:stark] ;
					break ;
				case SharypeOhared:
					[starksInOhared addObject:stark] ;
					break ;
				case 0:
					// -[Stark collections] returned nil, probably because
					// the stark or its lineage may have been just deleted.
				default:
					;
			}
		}

		NSSet* starkSubsets = [[NSSet alloc] initWithObjects:
								   starksInRoot,
								   starksInBar,
								   starksInMenu,
								   starksInUnfiled,
								   starksInOhared,
								   nil] ;
		[starksInRoot release] ;
		[starksInBar release] ;
		[starksInMenu release] ;
		[starksInUnfiled release] ;
		[starksInOhared release] ;
		
		// Subsets that have 2 or more starks:
		NSMutableSet* starkSubsetsWith2 = [[NSMutableSet alloc] init] ;
		
		for (NSSet* collection in starkSubsets) {
			NSInteger count = [collection count] ;
			if (count > 1) {
				[starkSubsetsWith2 addObject:collection] ;
			}
		}
		[starkSubsets release] ;
		
		if ([starkSubsetsWith2 count] == 1) {
			if ([[starkSubsetsWith2 anyObject] count] == [dupe numberOfStarks]) {
				// No change to this dupe because all of its starks are in one collection
                [starkSubsetsWith2 release] ;
				continue ;
			}
		}

		// If we got here, that means that this dupe is no longer valid
		// as constituted.  So we'll delete it and create new dupes if
		// any exist
		[self removeDupesObject:dupe] ;
		// Added in BookMacster 1.7…
		[[dupe managedObjectContext] deleteObject:dupe] ;
		
		for (NSSet* collection in starkSubsetsWith2) {
			Dupe* newDupe = (Dupe*)[dupester freshObject] ;
			[newDupe setUrl:[dupe url]] ;
			[newDupe setStarks:collection] ;
			[newDupes addObject:newDupe] ;
		}
		[starkSubsetsWith2 release] ;
	}
	[dupesCopy release] ;
	[dupester release] ;
	
	
	for (Dupe* dupe in newDupes) {
		[self addDupesObject:dupe] ; // should trigger KVO
	}
	[newDupes release] ;
}

- (void)checkAndRemoveDupeVestiges {
	NSMutableDictionary* starksByNewUrl = [[NSMutableDictionary alloc] init] ;
	Dupe* dupe ;
	// To avoid removing an object from [self dupes] while enumerating through
	// it, we enumerate a copy.
	NSSet* dupesCopy = [[self dupes] copy] ;
	for (dupe in dupesCopy) {
		NSString* originalUrl = [dupe url] ;
		// To avoid removing an object from [dupe starks] while enumerating through
		// it, we enumerate a copy.
		NSSet* starksCopy = [[dupe starks] copy] ;
		for (Stark* stark in starksCopy) {
			if ([stark isDeleted]) {
				[dupe removeStarksObject:stark] ;
			}			
			else {
				NSString* url = [stark url] ;
				BOOL doRemove = NO ;
				if (![originalUrl marksSameSiteAs:url]) {
					// This stark has had its url changed, so that it
					// no longer belongs in the dupe it is now in.
					
					// Remove it from its current dupe
					doRemove = YES ;				
					// Add it to a set of starks, if any, with the same new url
					NSMutableSet* newSisters = [starksByNewUrl objectForKey:url] ;
					{
						// Digression: Create the set for this url if it does not exist yet
						if (!newSisters) {
							newSisters = [NSMutableSet set] ;
							[starksByNewUrl setObject:newSisters
											   forKey:url] ;
						}
					}
					[newSisters addObject:stark] ;
				}
				else if ([[stark isAllowedDupe] boolValue]) {
					// Remove it from its current dupe
					doRemove = YES ;
				}

				if (doRemove) {
					[dupe removeStarksObject:stark] ;
				}
			}
		}
		[starksCopy release] ;
		
		if ([[dupe starks] count] < 2) {
			[self removeDupesObject:dupe] ;
		}
	}
	[dupesCopy release] ;
	
	// Create new dupes if necessary
	Dupester* dupester = nil ;
	for (NSString* url in starksByNewUrl) {
		NSSet* starks = [starksByNewUrl objectForKey:url] ;
		if ([starks count] > 1) {
			if (!dupester) {
				dupester = [[Dupester alloc] initWithManagedObjectContext:[self managedObjectContext]] ;
			}
			Dupe* newDupe = (Dupe*)[dupester freshObject] ;
			[newDupe setUrl:url] ;
			[newDupe setStarks:starks] ;
			[self addDupesObject:newDupe] ; // should trigger KVO
		}
	}
	[dupester release] ;
	[starksByNewUrl release] ;
}

#pragma mark * Data Source Protocol Methods

- (NSInteger)    outlineView:(NSOutlineView *)outlineView
numberOfChildrenOfItem:(id)item {
    NSInteger numberOfChildren ;
	
	if (!item) {
		// root		
		numberOfChildren = [[self dupes] count] ;
	}
	else if ([item isKindOfClass:[Dupe class]]) {
		numberOfChildren = [[item starks] count] ;
	}
	else {
		// item must be a Stark/Bookmark
		numberOfChildren = 0 ;
	}
	
	return numberOfChildren ;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
   isItemExpandable:(id)item {
    BOOL answer ;
	
	if (!item) {
		// root
		answer = YES ;
	}
	else if ([item isKindOfClass:[Dupe class]]) {
		answer = YES ;
	}
	else {
		// item must be a Stark/Bookmark
	answer = NO ;
	}
	
	return answer ;
}

- (id)outlineView:(NSOutlineView *)outlineView
			child:(NSInteger)index
		   ofItem:(id)item {
	id child = nil ;
	
	if (!item) {
		// root
		child = [[self dupesOrdered] objectAtIndex:index] ;
	}
	else if ([item isKindOfClass:[Dupe class]]) {
		child = [[(Dupe*)item starksOrderedSloppy] objectAtIndex:index] ;
	}
    else {
        // Defensive programming, this should never happen
        child = [outlineView itemAtRow:0] ;
    }

	return child ;
}

- (id)           outlineView:(NSOutlineView *)outlineView
   objectValueForTableColumn:(NSTableColumn *)tableColumn
					  byItem:(id)item {
	NSString* answer ;
	
	if (![[tableColumn identifier] isEqualToString:constKeyAddDate]) {
		// Must be the first column
		if ([item isKindOfClass:[Dupe class]]) {
			answer = [(Stark*)item url] ;
		}
		else {
			// item must be a Stark/Bookmark
			answer = [(Stark*)item lineageLineDoSelf:YES
											 doOwner:NO] ;
		}
	}
	else {
		// Must be the second column
		if ([item isKindOfClass:[Dupe class]]) {
			// Don't show anything
			answer = nil ;
		}
		else {
			// item must be a Stark/Bookmark
			answer = [[(Stark*)item addDate] medDateShortTimeString] ;
		}
	}		
	
	return answer ; 
}

@end
