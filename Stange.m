#import "Stange.h"
#import "Stark.h"
#import "NSObject+MoreDescriptions.h"
#import "NSArray+SSYMutations.h"
#import "NSString+LocalizeSSY.h"
#import "NSObject+DoNil.h"

@implementation Stange

- (id)init {
	self = [super init] ;
	if (self) {
		[self setChangeType:SSYModelChangeActionUndefined] ;
	}
	
	return self ;
}

@synthesize changeType = m_changeType ;
@synthesize sharypeCoarse = m_sharypeCoarse ;
@synthesize lineage = m_lineage ;
@synthesize updates = m_updates ;
@synthesize addedChildren = m_addedChildren ;
@synthesize addedTags = m_addedTags ;
@synthesize deletedChildren = m_deletedChildren ;
@synthesize deletedTags = m_deletedTags ;
@synthesize fromDisplayName = m_fromDisplayName ;
@synthesize stark = m_stark ;
@synthesize oldIndex = m_oldIndex ;

- (NSString*)description {
	Stark* stark = [self stark] ;
	NSString* starkStatus ;
	if ([stark isDeleted]) {
		starkStatus = @"Deleted" ;
	}
	else if ([stark isFault]) {
		starkStatus = @"Faulted" ;
	}
	else {
		starkStatus = [stark nameNoNil] ;
	}

	Stark* oldParent = [stark oldParent] ;
	NSString* oldParentStatus ;
	if ([oldParent isDeleted]) {
		oldParentStatus = @"Deleted" ;
	}
	else if ([oldParent isFault]) {
		oldParentStatus = @"Faulted" ;
	}
	else {
		oldParentStatus = [oldParent nameNoNil] ;
	}
	
	NSMutableString* addeletions = [[@"" mutableCopy] autorelease] ;
	if ([[self addedChildren] count] > 0) {
		[addeletions appendFormat:@"\nadded children: %@", [[self addedChildren] shortDescription]] ;
	}
	if ([[self addedTags] count] > 0) {
		[addeletions appendFormat:@"\nadded tags: %@", [[self addedTags] shortDescription]] ;
	}
	if ([[self deletedChildren] count] > 0) {
		[addeletions appendFormat:@"\ndeleted children: %@", [[self deletedChildren] shortDescription]] ;
	}
	if ([[self deletedTags] count] > 0) {
		[addeletions appendFormat:@"\ndeleted tags: %@", [[self deletedTags] shortDescription]] ;
	}
	return [NSString stringWithFormat:
            @"*** <Stange %p>\ntype: %@\nlineage: {%@} from=%@\n* stark: %@\n* oldIndex=%@ oldParent/Status: %@\n* attribute updates: %@\n* collection updates: %@",
			self,
			[SSYModelChangeTypes asciiNameForAction:[self changeType]],
			[Stark lineageLineWithLineageNames:[self lineage]],
			[self fromDisplayName],
			starkStatus,
			[self oldIndex],
			oldParentStatus,
			[[self updates] shortDescription],
			addeletions] ;
}

- (void)dealloc {
	[m_lineage release] ;
	[m_updates release] ;
	[m_addedChildren release] ;
	[m_addedTags release] ;
	[m_deletedChildren release] ;
	[m_deletedTags release] ;
	[m_fromDisplayName release] ;
	[m_stark release] ;
	[m_oldIndex release] ;

	[super dealloc] ;
}

- (NSComparisonResult)compareStarkPositions:(Stange*)otherStange {
	NSInteger depth = [[self stark] lineageDepth] ;
	NSInteger otherDepth = [[otherStange stark] lineageDepth] ;
	NSComparisonResult answer ;
	if (depth < otherDepth) {
		answer = NSOrderedAscending ;
	}
	else if (depth > otherDepth) {
		answer = NSOrderedDescending ;
	}
	else {
		NSInteger index = [[self stark] indexValue] ;
		NSInteger otherIndex = [[otherStange stark] indexValue] ;
		if (index < otherIndex) {
			answer = NSOrderedAscending ;
		}
		else if (index > otherIndex) {
			answer = NSOrderedDescending ;
		}
		else {
			answer = NSOrderedSame ;
		}		
	}
	
	return answer ;
}

- (void)tryNewChangeType:(SSYModelChangeAction)newChangeType {
	// Correct operation of this method relies on the fact that
	// the enum SSYModelChangeAction is ordered by priority, and
	// that, in our init method, we set changeType to
	// SSYChangeTypeUndefined, which has the highest value, which
	// is the lowest priority.
	SSYModelChangeAction priorChangeType = [self changeType] ;
	// The following branch was added in BookMacster 1.7/1.6.8.  See Note 098534.
	if (
		(
		 (priorChangeType == SSYModelChangeActionMove)
		 &&
		 (newChangeType == SSYModelChangeActionModify)
		 )
		||
		(
		 (priorChangeType == SSYModelChangeActionModify)
		 &&
		 (newChangeType == SSYModelChangeActionMove)
		 )
		||  // Added in BookMacster 1.11…
		(
		 (priorChangeType == SSYModelChangeActionSlosh)
		 &&
		 (newChangeType == SSYModelChangeActionMove)
		 )
		) {
		[self setChangeType:SSYModelChangeActionMosh] ;
	}
	else if (
		(
		 (priorChangeType == SSYModelChangeActionSlide)
		 &&
		 (newChangeType == SSYModelChangeActionModify)
		 )
		||
		(
		 (priorChangeType == SSYModelChangeActionModify)
		 &&
		 (newChangeType == SSYModelChangeActionSlide)
		 )
		) {
		[self setChangeType:SSYModelChangeActionSlosh] ;
	}
	else if (newChangeType < priorChangeType) {
		[self setChangeType:newChangeType] ;
	}
}


- (void)registerAdd {
	if ([self changeType] == SSYModelChangeActionRemove) {
		NSLog(@"Internal Error 153-0028  Adding removed stark %@", [self stark]) ;
		return ;
	}
	
	[self tryNewChangeType:SSYModelChangeActionInsert] ;
	[self setUpdates:nil] ;
}

- (void)registerDelete {
	if ([self changeType] == SSYModelChangeActionInsert) {
		[self setChangeType:SSYModelChangeActionCancel] ;
	}
	else {
		[self tryNewChangeType:SSYModelChangeActionRemove] ;
	}
	[self setUpdates:nil] ;
}

/*!
 @brief    
 
 @details  
 @result   YES if the receiver still indicates valid changes,
 NO if all changes have been cancelled out.
 */
- (BOOL)registerUpdateKey:(NSString*)key
				 oldValue:(id)oldValue
				 newValue:(id)newValue {
	SSYModelChangeAction changeType = [self changeType] ;
	if (changeType == SSYModelChangeActionRemove) {
		// Don't bother registering updates to an item which is
		// being removed anyhow.
		return YES ;
	}
	
	if (
		// Check both in case one is nil
		[oldValue respondsToSelector:@selector(count)]
		||
		[newValue respondsToSelector:@selector(count)]
		) {
		
		if (
			// Check both in case one is nil
			[oldValue respondsToSelector:@selector(objectForKey:)]
			||
			[newValue respondsToSelector:@selector(objectForKey:)]
			) {
			// Value is/was a dictionary
			// key must be 'localValues' nee 'browprietaryValues'
			// Beginning with BookMacster 1.11, these should not happen any more
			// because 'localValues' are only in starks owned by Extores, and
			// an Import or Export involves updating a stark owned by an Extore
			// per one owned by a BkmxDoc or vice versa
			NSLog(@"Internal Error 719-0284 old: %@\nnew: %@", oldValue, newValue) ;
		}
		else {		
			// Value is/was a set or array
			// key may be 'children' or 'tags'
			
			// Make old value into a set
			NSCountedSet* oldSet ;
			if ([oldValue isKindOfClass:[NSArray class]]) {
				oldSet = [[[NSCountedSet alloc] initWithArray:oldValue] autorelease] ;
			}
			else if ([oldValue isKindOfClass:[NSSet class]]){
				oldSet = [[[NSCountedSet alloc] initWithSet:oldValue] autorelease] ;
			}
			else {
				oldSet = [[[NSCountedSet alloc] init] autorelease] ;
			}
			
			// Make new value into a set
			NSCountedSet* newSet ;
			if ([newValue isKindOfClass:[NSArray class]]) {
				newSet = [[[NSCountedSet alloc] initWithArray:newValue] autorelease] ;
			}
			else if ([newValue isKindOfClass:[NSSet class]]){
				newSet = [[[NSCountedSet alloc] initWithSet:newValue] autorelease] ;
			}
			else {
				newSet = [[[NSCountedSet alloc] init] autorelease] ;
			}
			
			// Find differences between new and old
			NSCountedSet* newAdditions = [newSet mutableCopy] ;
			[newAdditions minusSet:oldSet] ;
			NSCountedSet* newDeletions = [oldSet mutableCopy] ;
			[newDeletions minusSet:newSet] ;
			
			id currentAdditions = nil ; // NSMutableArray* or NSMutableDictionary*
			id currentDeletions = nil ; // NSMutableArray* or NSMutableDictionary*
			
			if ([key isEqualToString:constKeyChildren]) {
				currentAdditions = [self addedChildren] ;
				if (!currentAdditions) {
					currentAdditions = [[NSMutableArray alloc] init] ;
					[self setAddedChildren:currentAdditions] ;
					[currentAdditions release] ;
				}
				
				currentDeletions = [self deletedChildren] ;
				if (!currentDeletions) {
					currentDeletions = [[NSMutableArray alloc] init] ;
					[self setDeletedChildren:currentDeletions] ;
					[currentDeletions release] ;
				}
			}
			else if ([key isEqualToString:constKeyTags]) {
				currentAdditions = [self addedTags] ;
				if (!currentAdditions) {
					currentAdditions = [[NSMutableArray alloc] init] ;
					[self setAddedTags:currentAdditions] ;
					[currentAdditions release] ;
				}
				
				currentDeletions = [self deletedTags] ;
				if (!currentDeletions) {
					currentDeletions = [[NSMutableArray alloc] init] ;
					[self setDeletedTags:currentDeletions] ;
					[currentDeletions release] ;
				}			
			}
			else {
				NSLog(@"Warning 123-3906: %@", key) ;
			}
			
			// Note that since currentAdditions and currentDeletions
			// are mutable array properties of this instance, the
			// following mutates this instance.
			[NSMutableArray mutateAdditions:currentAdditions
								  deletions:currentDeletions
							   newAdditions:newAdditions
							   newDeletions:newDeletions] ;
			
			[newAdditions release] ;
			[newDeletions release] ;
			
			if (
				([[self addedChildren] count] == 0)
				&&
				([[self addedTags] count] == 0)
				&&
				([[self deletedChildren] count] == 0)
				&&
				([[self deletedTags] count] == 0)
				&&
				([[self updates] count] == 0)
				) {
				// Apparently all updates of any kind have been
				// cancelled out for this Stange object.

				// However, we still want to keep this stange if its
				// change is of a higher priority than update/modify.
				// (Fixed in BookMacster 1.6.2; was just return NO
				return (changeType < SSYModelChangeActionModify) ;
			}		
		}

		[self tryNewChangeType:SSYModelChangeActionModify] ;	
		
		return YES ;
	}
	
	// Change type was either Mosh, Modify, Move, or Slide, and key
	// was neither children nor tags.
	
	if ([key isEqualToString:constKeyParent]) {
		// This change, ignoring others, would be type Move
		[self tryNewChangeType:SSYModelChangeActionMove] ;
	}
	else if ([key isEqualToString:constKeyIndex]) {
		// This change, ignoring others, would be type Slide
		[self tryNewChangeType:SSYModelChangeActionSlide] ;	
	}
	else {
		// This change, ignoring others, would be type Modify
		[self tryNewChangeType:SSYModelChangeActionModify] ;
	}
	
	// The following section was improved in BookMacster 1.6.2 to cancel
	// out the update case the values have gone "full circle", which is
	// often the case when key=index, as empty folders are inserted and
	// then deleted.
	NSMutableDictionary* updates = [self updates] ;
	id olderValue = nil ;
	if (updates) {
		olderValue = [[updates objectForKey:key] objectForKey:NSKeyValueChangeOldKey] ;
	}
		
	id oldestValue = (olderValue ? olderValue : oldValue) ;
	
	if ([NSObject isEqualHandlesNilObject1:oldestValue
								   object2:newValue]) {
		// We've come "full circle", putting value back
		// to the original value.  Cancel it out.
		[updates removeObjectForKey:key] ;
		
		if ([updates count] == 0) {
			[self setUpdates:nil] ;
			
			// However, we still want to keep this stange if its
			// change is of a higher priority than update/modify,
			// move or slide.
			if (changeType < SSYModelChangeActionModify) {
				return YES ;
			}
			
			// We also still want to keep this stange if it has
			// collection changes
			if ([[self addedTags] count] > 0) {
				return YES ;
			}
			if ([[self deletedTags] count] > 0) {
				return YES ;
			}
			if ([[self addedChildren] count] > 0) {
				return YES ;
			}
			if ([[self deletedChildren] count] > 0) {
				return YES ;
			}
			
			// If we've reached here, seems to be no more changes
			// still existing in this stange
			return NO ;
		}
	}
	else {
		// Oldest value and new value are different
		NSMutableDictionary* update = [[NSMutableDictionary alloc] init] ;
		[update setValue:oldestValue
				  forKey:NSKeyValueChangeOldKey] ;
		[update setValue:newValue
				  forKey:NSKeyValueChangeNewKey] ;
		NSDictionary* newUpdate = [NSDictionary dictionaryWithDictionary:update] ;
		[update release] ;
		
		if (!updates) {
			updates = [[NSMutableDictionary alloc] init] ;
			[self setUpdates:updates] ;
			[updates release] ;
		}			

		[updates setValue:newUpdate
				   forKey:key] ;		
	}
	
	return YES ;
}

- (void)registerBasicsFromStark:(Stark*)stark {
	if ([stark isRoot]) {
		[self setLineage:[NSArray arrayWithObject:[NSString localize:@"lineageRoot"]]] ;
	}
	else {
		NSArray* proposedLineage = [stark lineageNamesDoSelf:YES
													 doOwner:NO] ;
		if ([proposedLineage count] >= [[self lineage] count]) {
			[self setLineage:proposedLineage] ;
		}
	}
	
	Sharype proposedSharype = [stark sharypeCoarseValue] ;
	if (proposedSharype != SharypeUndefined) {
		[self setSharypeCoarse:proposedSharype] ;
	}
	
#if 0
#warning Chaker testing stark identities
	Stark* existingStark = [self stark] ;
	if (existingStark) {
		if (existingStark != stark) {
			NSLog(@"Internal Error 153-0188 \nExisting: %@      New: %@",
				  [existingStark shortDescription],
				  [stark shortDescription]) ;
		}
	}
#endif
	
	[self setStark:stark] ;
	[self setOldIndex:[stark index]] ;
}



@end
