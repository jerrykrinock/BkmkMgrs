#import "Syncer.h"
#import "AgentPerformer.h"
#import "BkmxBasis.h"
#import "BkmxDoc.h"
#import "BkmxDocWinCon.h"
#import "Clientoid.h"
#import "Watch.h"
#import "Client.h"
#import "Command.h"
#import "Macster.h"
#import "NSArray+Indexing.h"
#import "NSBundle+HelperPaths.h"
#import "NSBundle+MainApp.h"
#import "NSDate+Components.h"
#import "NSDate+NiceFormats.h"
#import "NSError+InfoAccess.h"
#import "NSError+MyDomain.h"
#import "NSManagedObject+Debug.h"
#import "NSObject+MoreDescriptions.h"
#import "NSSet+Indexing.h"
#import "NSSet+SimpleMutations.h"
#import "NSString+LocalizeSSY.h"
#import "NSString+SSYExtraUtils.h"
#import "NSUserDefaults+Bkmx.h"
#import "NSUserDefaults+MainApp.h"
#import "OperationRevert.h"
#import "Trigger.h"


NSString* constKeyUserDescription = @"userDescription" ;
NSString* constGroupNameAgentPerformEnd = @"Agent-Perform-End" ;

@interface Syncer (CoreDataGeneratedAccessors)

- (void)setPrimitiveIndex:(NSNumber*)value ;
- (void)setPrimitiveIsActive:(NSNumber*)value ;
- (void)setPrimitiveUserDescription:(NSString*)value ;
- (void)setPrimitiveMacster:(Macster*)value ;

- (void)addCommandsObject:(Command *)value;
- (void)removeCommandsObject:(Command *)value;
- (void)addCommands:(NSSet *)value;
- (void)removeCommands:(NSSet *)value;

- (NSMutableSet*)primitiveTriggers;
- (void)setPrimitiveTriggers:(NSMutableSet*)value;
- (void)addTriggersObject:(Trigger *)value;
- (void)removeTriggersObject:(Trigger *)value;
- (void)addTriggers:(NSSet *)value;
- (void)removeTriggers:(NSSet *)value;

- (NSMutableSet*)primitiveCommands;
- (void)setPrimitiveCommands:(NSMutableSet*)value;

@end


@implementation Syncer

+ (NSInteger)totalDocsOfAnyAppWithInstalledSyncers {
    NSMutableSet* docUuids = [NSMutableSet new];
    NSSet* watches = [[NSUserDefaults standardUserDefaults] watchesForApps:BkmxWhichAppsAny];
    for (Watch* watch in watches) {
        [docUuids addObject:watch.docUuid];
    }

    NSInteger count = [docUuids count];
    [docUuids release];

    return count;
}

// From NSManagedObject documentation: "You are discouraged from overriding
// description ... if this method fires a fault during a debugging
// operation, the results may be unpredictable.
- (NSString*)shortDescription {
	return [NSString stringWithFormat:
			@"<Syncer %p %@ idx=%@ nTrgs=%ld, nCmds=%ld, %@>",
			self,
			[self truncatedID],
			[self index],
			(long)[[self triggers] count],
			(long)[[self commands] count],
			[self userDescription]] ;
}

#pragma mark * Accessors for non-managed object properties


#pragma mark * Accessors for managed object properties

// Attributes

- (BOOL)hasAClientBasedTrigger {
	NSSet* triggers = [self triggers] ;
	for (Trigger* trigger in triggers) {
		BkmxTriggerType type = [trigger triggerTypeValue] ;
		if (
			(type == BkmxTriggerBrowserQuit)
			||
			(type == BkmxTriggerSawChange)
			) {
			return YES ;
		}
	}
	
	return NO ;
}

- (BOOL)doesImport {
	BOOL syncerDoesImport = NO ;
	for (Command* command in [self commands]) {
		NSString* methodName = [command method] ;
		if ([Command doesImportMethodName:methodName]) {
			syncerDoesImport = YES ;
			break ;
		}
	}
	
	return syncerDoesImport ;
}

- (BOOL)doesExport {
	BOOL syncerDoesExport = NO ;
	for (Command* command in [self commands]) {
		NSString* methodName = [command method] ;
		if ([Command doesExportMethodName:methodName]) {
			syncerDoesExport = YES ;
			break ;
		}
	}
	
	return syncerDoesExport ;
}

@dynamic index ;

- (void)setIndex:(NSNumber*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyIndex] ;
	[self willChangeValueForKey:constKeyIndex] ;
    [self setPrimitiveIndex:newValue] ;
    [self didChangeValueForKey:constKeyIndex] ;
	
	[[self macster] postTouchedSyncer:self
                             severity:3] ;
}

@dynamic isActive ;

- (void)setIsActive:(NSNumber*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyIsActive] ;
	[self willChangeValueForKey:constKeyIsActive] ;
    [self setPrimitiveIsActive:newValue] ;
    [self didChangeValueForKey:constKeyIsActive] ;
	
	NSInteger severity = ([newValue boolValue]) ? 7 : 4 ;
	[[self macster] postTouchedSyncer:self
                             severity:severity] ;
}

@dynamic userDescription ;

- (void)setUserDescription:(NSString*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyUserDescription] ;
	[self willChangeValueForKey:constKeyUserDescription] ;
    [self setPrimitiveUserDescription:newValue] ;
    [self didChangeValueForKey:constKeyUserDescription] ;
	
	[[self macster] postTouchedSyncer:self
                             severity:2] ;
}

// Relationships
@dynamic commands ;

- (void)postWillSetNewCommands:(NSSet*)newValue {
	[self postWillSetNewValue:newValue
					   forKey:constKeyCommands] ;
}

- (void)setCommands:(NSSet*)value {    
	[self postWillSetNewCommands:value] ;
	
    [self willChangeValueForKey:constKeyCommands];
    [self setPrimitiveCommands:[NSMutableSet setWithSet:value]];
    [self didChangeValueForKey:constKeyCommands];
	
	NSInteger severity = ([value count] > 0) ? 7 : 4 ;
	[[self macster] postTouchedSyncer:self
                             severity:severity] ;
}

- (void)addCommandsObject:(Command*)value {    
	[self postWillSetNewCommands:[[self commands] setByAddingObject:value]] ;
	
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyCommands withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
 	// The following uses my NSMutableSet(Indexing) category, to adjust sibling indexes
    [[self primitiveCommands] addObject:value
								atIndex:[[value index] integerValue]];
    [self didChangeValueForKey:constKeyCommands withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	
    [changedObjects release];
	
	NSInteger severity = (value != nil) ? 5 : 4 ;
    // Above was 7 : 4 until BookMacster 1.20.2.  Reduced it because this
    // was one of the causes of "Export or Pause" prompt showing after
    // switching on "Sort (alphabetize)" Simple Syncer.
	[[self macster] postTouchedSyncer:self
                             severity:severity] ;
}

- (void)removeCommandsObject:(Command*)value {
	[self postWillSetNewCommands:[[self commands] setByRemovingObject:value]] ;
	
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyCommands withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	// The following uses my NSMutableSet(Indexing) category, to adjust sibling indexes
    [[self primitiveCommands] removeIndexedObject:value] ;
    [self didChangeValueForKey:constKeyCommands withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
	
	[[self macster] postTouchedSyncer:self
                             severity:4] ;
}

#if 0
/*
 These methods are not implemented because they would need to use
 my NSMutableSet(Indexing) methods to maintain sibling indexes,
 and that would be messy.  By not implementing them, the system
 is forced to use -addFoosObject: and -removeFoosObject:, which
 do use my NSMutableSet(Indexing).
*/
- (void)addCommands:(NSSet*)value
- (void)removeCommands:(NSSet *)value
#endif

@dynamic macster ;

- (void)setMacster:(Macster*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyMacster] ;
	[self willChangeValueForKey:constKeyMacster] ;
    [self setPrimitiveMacster:newValue] ;
    [self didChangeValueForKey:constKeyMacster] ;
}

@dynamic triggers ;

- (void)postWillSetNewTriggers:(NSSet*)newValue {
	[self postWillSetNewValue:newValue
					   forKey:constKeyTriggers] ;
}

- (void)setTriggers:(NSSet*)value {    
	[self postWillSetNewTriggers:value] ;
	
    [self willChangeValueForKey:constKeyTriggers];
    [self setPrimitiveTriggers:[NSMutableSet setWithSet:value]];
    [self didChangeValueForKey:constKeyTriggers];
	
	NSInteger severity = ([value count] > 0) ? 7 : 4 ;
	[[self macster] postTouchedSyncer:self
                             severity:severity] ;
}

- (void)addTriggersObject:(Trigger*)value {
	Trigger* existingTrigger = [[self primitiveTriggers] member:value] ;
    if ([[existingTrigger index] isEqual:[value index]]) {
		return ;
	}
	
	[self postWillSetNewTriggers:[[self triggers] setByAddingObject:value]] ;
	
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyTriggers withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	// The following uses my NSMutableSet(Indexing) category, to adjust sibling indexes
    [[self primitiveTriggers] addObject:value
								atIndex:[[value index] integerValue]];
    [self didChangeValueForKey:constKeyTriggers withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
	
	[self refreshCommandsArguments] ;
	
	NSInteger severity = [Trigger severityWhenSettingNewType:[value triggerType]
													 oldType:nil] ;
	[[self macster] postTouchedSyncer:self
                             severity:severity] ;
}

- (void)removeTriggersObject:(Trigger*)value {
	[self postWillSetNewTriggers:[[self triggers] setByRemovingObject:value]] ;
	
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyTriggers withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	// The following uses my NSMutableSet(Indexing) category, to adjust sibling indexes
    [[self primitiveTriggers] removeIndexedObject:value] ;  
    [self didChangeValueForKey:constKeyTriggers withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
	
	[self refreshCommandsArguments] ;
}

#if 0
// These methods are not implemented because they would need to use
// my NSMutableSet(Indexing) methods to maintain sibling indexes,
// and that would be messy.  By not implementing them, the system
// is forced to use -addFoosObject: and -removeFoosObject:, which
// do use my NSMutableSet(Indexing).
- (void)addTriggers:(NSSet*)value 
- (void)removeTriggers:(NSSet *)value 
#endif

#pragma mark * Shallow Value-Added Getters

- (NSArray*)commandsOrdered {
    return [[self commands] arraySortedByKeyPath:constKeyIndex] ;
}

// Accessed by Bindings when adding a command in the nib:
- (void)setCommandsOrdered:(NSArray*)commandsOrdered {
	// See "Bindings: NSArrayController gets a new but equal array, pushes back to model"
	// at end of Macster.m 
	if ([commandsOrdered isEqualToArray:[self commandsOrdered]]) {
		return ;
	}
	
	[self setIndexedSetWithArray:commandsOrdered
					   forSetKey:constKeyCommands] ;
}

+ (NSSet*)keyPathsForValuesAffectingCommandsOrdered {
	return [NSSet setWithObjects:
			@"commands",
			nil] ;
}

- (NSArray*)triggersOrdered {
    return [[self triggers] arraySortedByKeyPath:constKeyIndex] ;
}

- (Trigger*)anyTrigger {
    return [[self triggers] anyObject] ;
}
+ (NSSet*)keyPathsForValuesAffectingAnyTrigger {
	return [NSSet setWithObjects:
			@"triggers",
			nil] ;
}


// Accessed when adding a trigger in the nib:
- (void)setTriggersOrdered:(NSArray*)triggersOrdered {
	// See "Bindings: NSArrayController gets a new but equal array, pushes back to model"
	// at end of Macster.m 
	if ([triggersOrdered isEqualToArray:[self triggersOrdered]]) {
		return ;
	}
	
	// Before the actual change, compute whether or not we are adding new triggers
	NSMutableSet* addedTriggers = [NSMutableSet setWithArray:triggersOrdered] ;
	[addedTriggers minusSet:[self triggers]] ;
	
	[self setIndexedSetWithArray:triggersOrdered
					   forSetKey:constKeyTriggers] ;
	
	NSInteger severity = 0 ;
	for (Trigger* trigger in addedTriggers) {
		severity = MAX(severity, [Trigger severityWhenSettingNewType:[trigger triggerType]
															 oldType:nil]) ;
	}
	[[self macster] postTouchedSyncer:self
                             severity:severity] ;
}

+ (NSSet*)keyPathsForValuesAffectingTriggersOrdered {
	return [NSSet setWithObjects:
			@"triggers",
			nil] ;
}

- (Command*)freshCommandAtIndex:(NSInteger)index {
	// Put in same managed object context
	NSManagedObjectContext *moc = [self managedObjectContext] ;
	
	Command* command = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameCommand
													 inManagedObjectContext:moc] ;
	
	NSMutableSet* siblings = [self mutableSetValueForKey:constKeyCommands] ;
	// The following uses my NSMutableSet(Indexing) category, to adjust sibling indexes
	[siblings addObject:command
				atIndex:index] ;
	[command setSyncer:self] ;
	
	[[self macster] postTouchedSyncer:self
                             severity:5] ;  // Was 7 until BookMacster 1.20.2
	
	return command ;
}

- (Command*)freshCommand {
	return [self freshCommandAtIndex:NSNotFound] ;
}

- (Trigger*)freshTriggerAtIndex:(NSInteger)index {
	// Put in same managed object context
	NSManagedObjectContext *moc = [self managedObjectContext] ;
	
	Trigger* trigger = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameTrigger
													 inManagedObjectContext:moc] ;
	
	NSMutableSet* newSiblings = [self mutableSetValueForKey:constKeyTriggers] ;
	// The following uses my NSMutableSet(Indexing) category, to adjust sibling indexes
	[newSiblings addObject:trigger
				   atIndex:index] ;
	[trigger setSyncer:self] ;
	
	[[self macster] postTouchedSyncer:self
                             severity:7] ;
	
	return trigger ;
}

- (void)deleteTrigger:(Trigger*)trigger {
	NSInteger index = [[trigger index] integerValue] ;
	[self removeTriggersObject:trigger] ;
	// See Note 290293
	[[self managedObjectContext] deleteObject:trigger] ;
	
	[[self triggersOrdered] fixIndexesContiguousStartingAtIndex:index] ;
}

- (void)deleteAllTriggers {
	NSSet* immutableCopy = [[self triggers] copy] ;
	for (Trigger* trigger in immutableCopy) {
		[self removeTriggersObject:trigger] ;
		// See Note 290293
		[[self managedObjectContext] deleteObject:trigger] ;
	}
	[immutableCopy release] ;
	
	[[self macster] postTouchedSyncer:self
                             severity:4] ;
}

- (void)deleteCommand:(Command*)command {
	NSInteger index = [[command index] integerValue] ;
	[self removeCommandsObject:command] ;
	// See Note 290293
	[[self managedObjectContext] deleteObject:command] ;
	
	[[self commandsOrdered] fixIndexesContiguousStartingAtIndex:index] ;
}

- (void)deleteAllCommands {
	NSSet* immutableCopy = [[self commands] copy] ;
	for (Command* command in immutableCopy) {
		[self removeCommandsObject:command] ;
		// See Note 290293
		[[self managedObjectContext] deleteObject:command] ;
	}
	[immutableCopy release] ;
	
	[[self macster] postTouchedSyncer:self
                             severity:4] ;	
}

- (void)removeOwnees {
	[self deleteAllTriggers] ;
	[self deleteAllCommands] ;
}

- (void)initializeObservers {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(clientTouchNote:)
												 name:constNoteBkmxClientDidChange
											   object:[self macster]] ;
}

- (void)awakeCommon {
	[self initializeObservers] ;
}


- (void)awakeFromFetch {
	[super awakeFromFetch] ;
	[self awakeCommon] ;
}

- (void)awakeFromInsert {
	[super awakeFromInsert] ;
	[self awakeCommon] ;
	
	// Create a default description
	[self setUserDescription:[NSString localizeFormat:
							  @"whatWhenWho",
							  [NSString localize:@"syncer"],
							  [NSDate currentDateFormattedConcisely],
							  NSUserName()]] ;
	
	// Create a single default Trigger
	[self freshTriggerAtIndex:NSNotFound] ;
	
	// Create a couple of default commands
	Command* command ;
	//   Import
	command = [self freshCommandAtIndex:NSNotFound] ;
	[command setMethod:DEFAULT_IMPORT_METHOD] ;
	[command setArgument:[NSNumber numberWithInteger:BkmxDeferenceYield]] ;
	//   Export
	command = [self freshCommandAtIndex:NSNotFound] ;
	[command setMethod:constMethodPlaceholderExportAll] ;
	[command setArgument:[NSNumber numberWithInteger:BkmxDeferenceYield]] ;
	
}

- (void)didTurnIntoFault {
	[[NSNotificationCenter defaultCenter] removeObserver:self] ;
	
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
	
	[super didTurnIntoFault] ;
}

- (void)clientTouchNote:(NSNotification*)note {
	// Remove triggers that are watching clients who we no longer import or export.
	NSSet* thisUserClientoids = [[[self macster] thisUserClients] valueForKey:@"clientoid"] ;
	NSMutableIndexSet* badTriggerIndexes = [[NSMutableIndexSet alloc] init] ;
	NSInteger i = 0 ;
	for (Trigger* trigger in [self triggersOrdered]) {
		if (
			[trigger triggerTypeValue] == BkmxTriggerBrowserQuit
			||
			[trigger triggerTypeValue] == BkmxTriggerSawChange
			) {
			Clientoid* clientoid = [[trigger client] clientoid] ;
			BOOL found = NO ;
			// I tried to use -[NSSet member:] instead of the following loop,
			// but couldn't get it to work and gave up.  Something about -isEqual ??
            /* Update 2018-10-03.  Well, it could have been due to a bug in
             -[Clientoid hash] which I just fixed.  I was *adding* two hashes
             together, not realizing that the result of an overflowing integer
             additon in C os undefined.   That should have affected this too,
             but, you know, undefined is not predictable. */
			for (Clientoid* aClientoid in thisUserClientoids) {
				if ([aClientoid isEqual:clientoid]) {
					found = YES ;
					break ;
				}
			}
			
			if (!found) {
				[badTriggerIndexes addIndex:i] ;
			}
		}
		
		i++ ;
	}
	// See Note 274, below
	if ([badTriggerIndexes count] > 0) {
		NSArray* badTriggers = [[self triggersOrdered] objectsAtIndexes:badTriggerIndexes] ;
		for (Trigger* badTrigger in badTriggers) {
			[self deleteTrigger:badTrigger] ;
		}
	}
	[badTriggerIndexes release] ;
	
	// Note 274: The following if() qualifier was added after I found
	// that, upon opening a document that had a Syncer with a Trigger
	// to sort when browser was (Firefox) was quit, the dirty dot was
	// dirty.  I found the problem in this method and added the three
	// if() qualifiers with Note 274, in order, until finally the
	// problem was solved.
}

- (NSArray*)availableTriggerTypes {
	NSArray* types = [NSArray arrayWithObjects:
					  [NSNumber numberWithInteger:BkmxTriggerLogIn],
					  [NSNumber numberWithInteger:BkmxTriggerCloud],
                      [NSNumber numberWithInteger:BkmxTriggerLanding],
					  [NSNumber numberWithInteger:BkmxTriggerScheduled],
                      [NSNumber numberWithInteger:BkmxTriggerPeriodic],
					  nil] ;
	
	if ([[self macster] hasAThisUserActiveImportClient]) {
		types = [types arrayByAddingObject:[NSNumber numberWithInteger:BkmxTriggerBrowserQuit]] ;
	}
	
	if ([[self macster] hasAnImportClientWithObserveableBookmarksChanges]) {
		types = [types arrayByAddingObject:[NSNumber numberWithInteger:BkmxTriggerSawChange]] ;
	}
	
	return types ; 
}
/*
 + (NSSet*)keyPathsForValuesAffectingAvailableTriggerTypes {
 return [NSSet setWithObjects:
 
 @"self.macster.bkmxDoc.fileURL",  // I tested this in Mac OS 10.6 and 'fileURL' KVO works,
 // even if fileURL is changed by changing file name in Path Finder.
 nil] ;
 }
 */

- (NSArray*)availableCommandMethods {	
 	NSMutableArray* methods = [[NSMutableArray alloc] initWithObjects:
							   // Note that deleteAllContent would usually be done first -- however if I
							   // put it first or last it implies that maybe this means to delete
							   // the items in the popup menu, instead of deleting all bookmarks,
							   // separators and soft folders.  So that's why I put it third.
							   NSStringFromSelector(@selector(revert)),
							   constMethodPlaceholderImportAll,
							   NSStringFromSelector(@selector(deleteAllContent)),
							   NSStringFromSelector(@selector(sort)),
							   NSStringFromSelector(@selector(findDupes)),
							   NSStringFromSelector(@selector(verifyAll)),
							   constMethodPlaceholderExportAll,
							   NSStringFromSelector(@selector(saveDocument)),
							   nil] ;
	
	if ([self hasAClientBasedTrigger]) {
		[methods insertObject:constMethodPlaceholderExport1
					  atIndex:6] ;
		[methods insertObject:constMethodPlaceholderImport1
					  atIndex:1] ;
	}
	
	NSArray* answer = [NSArray arrayWithArray:methods] ;
	[methods release] ;
	
	return answer ; 
}

- (void)refreshCommandsArguments {
	for (Command* command in [self commands]) {
		[command refreshArgument] ;
	}
}

- (BOOL)anyCommandDoes1Import {
	NSSet* commands = [self commands] ;
	for (Command* command in commands) {
		NSString* methodName = [command method] ;
		if ([Command doesImportMethodName:methodName]) {
			if([Command does1MethodName:methodName]) {
				return YES ;
			}
		}
	}
	
	return NO ;
}

- (BOOL)anyCommandDoes1Export {
	NSSet* commands = [self commands] ;
	for (Command* command in commands) {
		NSString* methodName = [command method] ;
		if ([Command doesExportMethodName:methodName]) {
			if([Command does1MethodName:methodName]) {
				return YES ;
			}
		}
	}
	
	return NO ;
}

- (BOOL)anyTriggerNeedsDeference {
#if 0
	NSSet* triggers = [self triggers] ;
    // At one time, I thought that only certain
    // trigger types would warrant a deference
    // when commands are executed…
    for (Trigger* trigger in triggers) {
        if ([trigger triggerTypeValue] …) {
            return YES ;
        }
    }
    return NO ;
#endif
    
    // But now, I feel that they all do
    BOOL answer = ([[self triggers] count] > 0) ;
	
	return answer ;
}

#pragma mark * AppleScriptability

- (NSScriptObjectSpecifier*)objectSpecifier {	
	NSScriptObjectSpecifier *containerSpecifier = [[[self macster] bkmxDoc] objectSpecifier] ;
	NSScriptClassDescription *containerClassDescription = [containerSpecifier keyClassDescription] ;
	NSScriptObjectSpecifier* specifier = [[NSIndexSpecifier allocWithZone:[self zone]] initWithContainerClassDescription:containerClassDescription
																									  containerSpecifier:containerSpecifier
																													 key:@"syncersOrdered"
																												   index:[[self index] integerValue]] ;
	// Note: If this object had a "unique" specifier instead of an "index" specifier, we
	// would use initWithContainerClassDescription:containerSpecifier:key:uniqueID: instead of the above.
	return [specifier autorelease] ;
}

@end

/*
 There were three unrelated changes made in BookMacster 1.14.10 to reduce
 syncer activity…

 * To ignore changes which are merely updates of synchronization metadata from iCloud, the bookmarks content is hashed and compared with prior hashes before staging a job.
 * To ignore launchd WatchPath events caued by spurious inode changes, the file modification date is examined before staging a job.
 * In Trigger.m, for BkmxTriggerSawChange syncers, throttle interval was reduced.
*/
