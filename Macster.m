#import "BkmxDoc+Actions.h"
#import "Bookshig.h"
#import "Watch.h"
#import "Macster.h"
#import "Client.h"
#import "Clientoid.h"
#import "ClientChoice.h"
#import "Importer.h"
#import "Trigger.h"
#import "Exporter.h"
#import "NSInvocation+Quick.h"
#import "NSError+MyDomain.h"
#import "Syncer.h"
#import "NSSet+Indexing.h"
#import "BkmxBasis+Strings.h"
#import "BkmxDocumentController.h"
#import "Extore.h"
#import "NSArray+Stringing.h"
#import "NSArray+SafeGetters.h"
#import "Command.h"
#import "SSYAppInfo.h"
#import "NSObject+DoNil.h"
#import "NSObject+MoreDescriptions.h"
#import "BkmxAppDel+Capabilities.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "NSArray+Indexing.h"
#import "NSString+LocalizeSSY.h"
#import "NSArray+SortDescriptorsHelp.h"
#import "NSError+InfoAccess.h"
#import "NSString+Truncate.h"
#import "BkmxDocWinCon.h"
#import "SSYMojo.h"
#import "NSNumber+TrigTypeDisplay.h"
#import "NSManagedObjectContext+Cheats.h"
#import "NSInvocation+Quick.h"
#import "SSYSheetEnder.h"
#import "SSYLazyNotificationCenter.h"
#import "SSYBetterHashCategories.h"
#import "NSString+SSYExtraUtils.h"
#import "SSYMH.AppAnchors.h"
#import "Stager.h"
#import "FolderMap.h"
#import "TagMap.h"
#import "NSUserDefaults+MainApp.h"
#import "NSUserDefaults+Bkmx.h"
#import "NSDictionary+KeyPaths.h"
#import <Bkmxwork/Bkmxwork-Swift.h>


static NSArray* static_importSettingsKeyPaths = nil ;

NSString* const constKeySyncersDummyForKVO = @"syncersDummyForKVO" ;
NSString* const constKeyClientsDummyForKVO = @"clientsDummyForKVO" ;

NSString* const constKeyAutosaveUponClose = @"autosaveUponClose" ;
NSString* const constKeyDeleteUnmatchedMxtr = @"deleteUnmatchedMxtr" ;
NSString* const constKeyDaysDiary = @"daysDiary" ;
NSString* const constKeyAutoExport = @"autoExport" ;
NSString* const constKeyDoFindDupesAfterOpen = @"doFindDupesAfterOpen" ;
NSString* const constKeyAutoImport = @"autoImport" ;
NSString* const constKeyDoSortAfterOpen = @"doSortAfterOpen" ;
NSString* const constKeySafeLimitImport = @"safeLimitImport" ;

NSString* const constKeySyncerConfig = @"syncerConfig" ;
NSString* const constKeySyncers = @"syncers" ;

NSString* const constDummyNotificationName = @"dummyNoteName" ;

NSString* const constNoteDuplicateTrigger = @"duplicateTrigger" ;

@interface Macster (CoreDataGeneratedAccessors)

/*
 For some stupid reason, these to-many accessors, which I do not implement
 because they are dynamically generated at runtime by Core Data, 
 must be declared in a category with no implementation. If declared in, for
 example, the subclass @interface, you get compiler warnings that their implementations
 are missing.
 http://www.cocoabuilder.com/archive/message/cocoa/2008/8/10/215317
 */

- (void)addClientsObject:(Client*)value;
- (void)removeClientsObject:(Client*)value;
- (void)addClients:(NSSet *)value;
- (void)removeClients:(NSSet *)value;

- (void)addSyncersObject:(Syncer *)value;
- (void)removeSyncersObject:(Syncer *)value;
- (void)addSyncers:(NSSet *)value;
- (void)removeSyncers:(NSSet *)value;

@end


@interface Macster (CoreDataGeneratedPrimitiveAccessors)

- (id)primitiveSyncerConfig ;
- (void)setPrimitiveSyncerConfig:(id)value ;
- (id)primitiveSyncers ;
- (void)setPrimitiveSyncers:(id)value ;
- (id)primitiveAnyStarkCatchypeOrder ;
- (void)setPrimitiveAnyStarkCatchypeOrder:(id)value ;
- (id)primitiveAutosaveUponClose ;
- (void)setPrimitiveAutosaveUponClose:(id)value ;
- (id)primitiveDeleteUnmatchedMxtr ;
- (void)setPrimitiveDeleteUnmatchedMxtr:(id)value ;
- (id)primitiveClients ;
- (void)setPrimitiveClients:(id)value ;
- (id)primitiveDaysDiary ;
- (void)setPrimitiveDaysDiary:(id)value ;
- (id)primitiveAutoExport ;
- (void)setPrimitiveAutoExport:(id)value ;
- (id)primitiveDoFindDupesAfterOpen ;
- (void)setPrimitiveDoFindDupesAfterOpen:(id)value ;
- (id)primitiveAutoImport ;
- (void)setPrimitiveAutoImport:(id)value ;
- (id)primitiveDoSortAfterOpen ;
- (void)setPrimitiveDoSortAfterOpen:(id)value ;
- (id)primitivePreferredCatchype ;
- (void)setPrimitivePreferredCatchype:(id)value ;
- (id)primitiveSafeLimitImport ;
- (void)setPrimitiveSafeLimitImport:(id)value ;

@end


@interface Macster ()

/*
 These are used for coalescing notifications so that the notification
 with the highest severity wins.
 */
@property (assign) BOOL clientTouchedAll ;
@property (assign) NSInteger syncerTouchSeverity ;
@property (assign) BOOL syncerTouchedAll ;
@property (assign) NSInteger macsterTouchSeverity ;
@property (retain) NSTimer* badTriggerSayer ;

- (void)macsterTouchNote:(NSNotification*)note ;
@end


@implementation Macster

@synthesize badTriggerSayer = m_badTriggerSayer ;

- (void)dealloc {
    [m_badTriggerSayer release] ;
    [m_bkmxDoc release] ;
    
    [super dealloc] ;
}

/*!
 @brief    Returns an sorted array of the receiving class's
 key paths pertaining to import settings which should be used when
 calculating a hash representing the receiver's import settins.
 
 @details  The returned array is sorted and stored in a static
 variable, so that this is fast, and will give identical results in
 every application run.
 */
+ (NSArray*)importSettingsKeyPaths {
	if (!static_importSettingsKeyPaths) {
		static_importSettingsKeyPaths = [[NSArray alloc] initWithObjects:
										 constKeySafeLimitImport,
										 constKeyPreferredCatchype,
										 constKeyDeleteUnmatchedMxtr,
										 nil] ;
	}		
	
	return static_importSettingsKeyPaths ;
}

- (uint32_t)importSettingsHash {
	NSMutableArray* hashableValues = [[NSMutableArray alloc] init] ;
	id aValue ;
	
	for (NSString* key in [Macster importSettingsKeyPaths]) {
		aValue = [self valueForKeyPath:key] ;
		
		if (aValue) {
			[hashableValues addObject:aValue] ;
		}
	}
	
	uint32_t hash = [hashableValues hashBetter32] ;
	[hashableValues release] ;
	
	return hash ;
}

#if 0
#warning Logging Debug Extras for Macster
/*
 - (id)retain {
 id x = [super retain] ;
 NSLog(@"113033: After retain, rc=%d", [self retainCount]) ;
 return x ;
 }
 - (id)autorelease {
 id x = [super autorelease] ;
 NSLog(@"111008: After autorelease, rc=%d", [self retainCount]) ;
 return x ;
 }
- (oneway void)release {
 NSInteger rc = [self retainCount] ;
 [super release] ;
 NSLog(@"113300: After release, rc=%d", rc-1) ;
 return ;
 }
 - (void)dealloc {
 NSLog(@"%s", __PRETTY_FUNCTION__) ;
 [super dealloc] ;
 }
 */
#endif

- (void)willTurnIntoFault {
    [m_badTriggerSayer invalidate] ;
    [m_badTriggerSayer release] ;
    m_badTriggerSayer = nil ;

    if ([self.managedObjectContext concurrencyType] == NSMainQueueConcurrencyType) {
        [[NSNotificationCenter defaultCenter] removeObserver:self] ;
        [[SSYLazyNotificationCenter defaultCenter] removeObserver:self] ;
        [[NSUserDefaults standardUserDefaults] removeObserver:self
                                                   forKeyPath:constKeySortShoeboxDuringSyncs] ;
    }
	
    [[NSRunLoop currentRunLoop] cancelPerformSelectorsWithTarget:self] ;
    
	[super willTurnIntoFault] ;
}

#pragma mark * Accessors for non-managed object properties

@synthesize syncersDummyForKVO = m_syncersDummyForKVO ;
@synthesize clientsDummyForKVO = m_clientsDummyForKVO ;
@synthesize clientTouchSeverity = m_clientTouchSeverity ;
@synthesize clientTouchedAll = m_clientTouchedAll ;
@synthesize syncerTouchSeverity = m_syncerTouchSeverity ;
@synthesize syncerTouchedAll = m_syncerTouchedAll ;
@synthesize macsterTouchSeverity = m_macsterTouchSeverity ;
@synthesize syncerPausedConfig = m_syncerPausedConfig ;
@synthesize syncersPaused = m_syncersPaused ;

- (NSString*)docUuid {
	NSString* docUuid = [[BkmxBasis sharedBasis] docUuidOfSettingsObject:self] ;
	return docUuid ;
}

@synthesize bkmxDoc = m_bkmxDoc ;


#pragma mark * Core Data Generated Accessors for managed object properties

// Attributes

@dynamic anyStarkCatchypeOrder ;
@dynamic deleteUnmatchedMxtr ;
@dynamic daysDiary ;
@dynamic autosaveUponClose ;
@dynamic doFindDupesAfterOpen ;
@dynamic doSortAfterOpen ;
@dynamic autoImport ;
@dynamic autoExport ;
@dynamic preferredCatchype ;
@dynamic safeLimitImport ;

@dynamic syncerConfig ;

// Relationships

@dynamic clients ;
+ (NSSet*)keyPathsForValuesAffectingClients {
	return [NSSet setWithObjects:
			constKeyClientsDummyForKVO,
			nil] ;
}

@dynamic syncers ;


#pragma mark * Custom Accessors

- (void)postMacsterTouchedTimer:(NSTimer*)timer {
	NSNumber* severityNumber = [NSNumber numberWithInteger:[self macsterTouchSeverity]] ;
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							  severityNumber, constKeySeverity,
							  nil] ;
	[[NSNotificationCenter defaultCenter] postNotificationName:constNoteBkmxMacsterDidChange
														object:self
													  userInfo:userInfo] ;
	// Reset for next run loop iteration, next notification coalesce group
	[self setMacsterTouchSeverity:0] ;
}

- (void)postTouchedMacsterWithSyncerSeverity:(NSInteger)severity {
	// Here, see analagous comment in -postClientTouched:severity:
	if ([self macsterTouchSeverity] == 0) {
		[NSTimer scheduledTimerWithTimeInterval:0.0
										 target:self
									   selector:@selector(postMacsterTouchedTimer:)
									   userInfo:nil
										repeats:NO] ;
	}
	
	if (severity > [self macsterTouchSeverity]) {
		[self setMacsterTouchSeverity:severity] ;
	}
}


- (void)setAnyStarkCatchypeOrder:(NSArray*)value {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:value
					   forKey:constKeyAnyStarkCatchypeOrder] ;
	
    [self willChangeValueForKey:constKeyAnyStarkCatchypeOrder] ;
    [self setPrimitiveAnyStarkCatchypeOrder:value];
    [self didChangeValueForKey:constKeyAnyStarkCatchypeOrder] ;

	// The real reason why we need this custom setter:
	[self postTouchedMacsterWithSyncerSeverity:5] ;
}

- (void)setAutosaveUponClose:(NSNumber*)value {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:value
					   forKey:constKeyAutosaveUponClose] ;
	
    [self willChangeValueForKey:constKeyAutosaveUponClose] ;
    [self setPrimitiveAutosaveUponClose:value];
    [self didChangeValueForKey:constKeyAutosaveUponClose] ;
	
	// The real reason why we need this custom setter:
	[self postTouchedMacsterWithSyncerSeverity:0] ;
}

- (void)setDeleteUnmatchedMxtr:(NSNumber *)value {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:value
					   forKey:constKeyDeleteUnmatchedMxtr] ;
	
    [self willChangeValueForKey:constKeyDeleteUnmatchedMxtr] ;
    [self setPrimitiveDeleteUnmatchedMxtr:value];
    [self didChangeValueForKey:constKeyDeleteUnmatchedMxtr] ;
	
	for (Ixporter* importer in [self importers]) {
		[importer doMergeByBusinessLogic] ;
	}
	
	[self postTouchedMacsterWithSyncerSeverity:5] ;
	[[self bkmxDoc] forgetAllLastPreImportedHashes] ;
}

- (void)setDaysDiary:(NSNumber *)value {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:value
					   forKey:constKeyDaysDiary] ;
	
    [self willChangeValueForKey:constKeyDaysDiary] ;
    [self setPrimitiveDaysDiary:value];
    [self didChangeValueForKey:constKeyDaysDiary] ;
	
	[self postTouchedMacsterWithSyncerSeverity:0] ;
}

- (void)setAutoExport:(NSNumber*)value {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:value
					   forKey:constKeyAutoExport] ;
	
    [self willChangeValueForKey:constKeyAutoExport] ;
    [self setPrimitiveAutoExport:value];
    [self didChangeValueForKey:constKeyAutoExport] ;
	
	// The real reason why we need this custom setter:
	[self postTouchedMacsterWithSyncerSeverity:0] ;
}

- (void)setDoFindDupesAfterOpen:(NSNumber*)value {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:value
					   forKey:constKeyDoFindDupesAfterOpen] ;
	
    [self willChangeValueForKey:constKeyDoFindDupesAfterOpen] ;
    [self setPrimitiveDoFindDupesAfterOpen:value];
    [self didChangeValueForKey:constKeyDoFindDupesAfterOpen] ;
	
	// The real reason why we need this custom setter:
	[self postTouchedMacsterWithSyncerSeverity:0] ;
}

- (void)setAutoImport:(NSNumber*)value {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:value
					   forKey:constKeyAutoImport] ;
	
    [self willChangeValueForKey:constKeyAutoImport] ;
    [self setPrimitiveAutoImport:value];
    [self didChangeValueForKey:constKeyAutoImport] ;
	
	// The real reason why we need this custom setter:
	[self postTouchedMacsterWithSyncerSeverity:5] ;
}

- (void)setDoSortAfterOpen:(NSNumber*)value {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:value
					   forKey:constKeyDoSortAfterOpen] ;
	
    [self willChangeValueForKey:constKeyDoSortAfterOpen] ;
    [self setPrimitiveDoSortAfterOpen:value];
    [self didChangeValueForKey:constKeyDoSortAfterOpen] ;
	
	// The real reason why we need this custom setter:
	[self postTouchedMacsterWithSyncerSeverity:5] ;
}

- (void)setPreferredCatchype:(NSNumber*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyPreferredCatchype] ;
	
    [self willChangeValueForKey:constKeyPreferredCatchype] ;
    [self setPrimitivePreferredCatchype:value];
    [self didChangeValueForKey:constKeyPreferredCatchype] ;

	[[self bkmxDoc] forgetAllLastPreImportedHashes] ;
}

- (void)setSafeLimitImport:(NSNumber*)newValue {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:newValue
					   forKey:constKeySafeLimitImport] ;

	[self willChangeValueForKey:constKeySafeLimitImport] ;
    [self setPrimitiveSafeLimitImport:newValue] ;
    [self didChangeValueForKey:constKeySafeLimitImport] ;

	// The real reason why we need this custom setter:
	[self postTouchedMacsterWithSyncerSeverity:0] ;
}

/*!
 @details This method is typically called in main app, but may also be called
 in BkmxAgent if syncing is paused due to a Sync Fight detected.
 */
- (void)setSyncerConfig:(NSNumber*)value {
	// self.syncerConfig may be nil
	if ([NSNumber isEqualHandlesNilObject1:value
								   object2:[self syncerConfig]]) {
		return ;
	}
	
	unsigned long long oldConfig = [self syncerConfigValue] ;
	unsigned long long newConfig = [value unsignedLongLongValue] ;
	unsigned long long additionalConfigBits = (oldConfig ^ newConfig) & newConfig ;
    if (
        (newConfig != constBkmxSyncerConfigNone)
        &&
        (newConfig != constBkmxSyncerConfigIsAdvanced)
        ) {
        if (
            ([[self activeImportersOrdered] count] == 0)
            &&
            ([[self activeExportersOrdered] count] == 0)
            ) {
            [[self bkmxDoc] warnCantSyncNoClients] ;
            
            return ;
        }
        
        if ((additionalConfigBits & constBkmxSyncerConfigImportChanges) != 0) {
            if ([[self activeClients] count] > 0) {
                [self warnSyncingAffectedAfterDelay] ;
            }
        }
    }

	[self postWillSetNewValue:value
					   forKey:constKeySyncerConfig] ;
	
    [self willChangeValueForKey:constKeySyncerConfig] ;
    [self setPrimitiveSyncerConfig:value];
    [self didChangeValueForKey:constKeySyncerConfig] ;
	
	NSInteger severity = (additionalConfigBits > 0) ? 7 : 4 ;
	[self postTouchedMacsterWithSyncerSeverity:severity] ;
}

#pragma mark * Reactions

/*
 For explanation of how the next two methods work, see comments ahead of
 -postTouchedClient:severity:, below.  It's the same idea, and was also changed
 in BookMacster 1.9.8.
*/
- (void)postTouchedSyncer:(Syncer*)syncer
                 severity:(NSInteger)severity {
	NSDictionary* userInfo = syncer ? [NSDictionary dictionaryWithObject:syncer
																 forKey:constKeySyncer] : nil ;
	// Here, see analagous comment in -postClientTouched:severity:
	if ([self syncerTouchSeverity] == 0) {
		[NSTimer scheduledTimerWithTimeInterval:0.0
										 target:self
									   selector:@selector(postSyncerTouchedTimer:)
									   userInfo:userInfo
										repeats:NO] ;
	}
	
	if (severity > [self syncerTouchSeverity]) {
		[self setSyncerTouchSeverity:severity] ;
	}
	
	if (!syncer) {
		[self setSyncerTouchedAll:YES] ;
	}
}

- (void)postSyncerTouchedTimer:(NSTimer*)timer {
	Syncer* syncer = [self syncerTouchedAll] ? nil : [[timer userInfo] objectForKey:constKeySyncer] ;
	NSNumber* severityNumber = [NSNumber numberWithInteger:[self syncerTouchSeverity]] ;
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							  severityNumber, constKeySeverity,
							  syncer, constKeySyncer,
							  nil] ;
	[[NSNotificationCenter defaultCenter] postNotificationName:constNoteBkmxSyncerDidChange
														object:self
													  userInfo:userInfo] ;
	// Reset for next run loop iteration, next notification coalesce group
	[self setSyncerTouchSeverity:0] ;
	[self setSyncerTouchedAll:NO] ;
	
	[self setSyncersDummyForKVO:![self syncersDummyForKVO]] ;
}

/*
 Here is a description of how -postTouchedClient:severity:, clientTouchSeverity,
 -postClientTouchedTimer: and constNoteBkmxClientDidChange work to
 coalesce client changes into a single notification that has the
 highest severity passed by any change since the last such notification.  It
 uses a NSTimer…
 
 1.  Setters in the Macster class send -[Macster postTouchedClient:severity:] when clients 
 are changed.  Setters in the Client class send the same message
 whenever attribute of a Client object is changed.  Note that the value of the
 severity must be > 0 or the following are noops.
 
 2. -[Macster postTouchedClient:severity:] does two things…

 2a.  It examines the current value of clientTouchSeverity. If it is 0, this
 indicates that no notification is pending to be posted, so it creates a timer
 to post one at the beginning of the next run loop.
 
 2b.  If the given severity is greater than the current clientTouchSeverity,
 it assigns the given severity to clientTouchSeverity.
 
 2c.  If the given severity is negative, the absolute value of it is assigned
 to clientTouchSeverity, regardless of its current value.  In other words,
 passing a negative severity is a way to ratchet down the severity.
 
 3.  At the beginning of the next run loop, the timer fires, invoking 
 -postClientTouchedTimer: which does three things…
 
 3a.  Posts a constNoteBkmxClientDidChange notification, passing the current
 clientTouchSeverity, which is now the highest severity passed to
 -postTouchedClient:severity: since the last time this notification was posted,
 unless it was ratcheted down as descrived in step 2c.
 
 3b.  Clears clientTouchSeverity to 0, preparing for the next post
 
 3c.  Toggles the clientsDummyForKVO instance variable. 
 */
- (void)postTouchedClient:(Client*)client
				 severity:(NSInteger)severity {
    NSDictionary* userInfo = client ? [NSDictionary dictionaryWithObject:client
                                                                  forKey:constKeyClient] : nil ;
    BOOL underride = NO ;
    if (severity < 0) {
        underride = YES ;
        severity = -severity ;
    }
    
    // We don't need to worry about different client being passed
    // the next time this method is invoked, because I can't think
    // of any way that user could insert or update a different client
    // during one run loop iteration, and after the current run loop
    // iteration we'll start over with a new NSTimer.  However, it
    // might be possible to have both nil ("all clients") and non-nil
    // client passed during a single run loop iteration.  Not sure.
    // We handle that at the end of this method, with setClientTouchedAll:.
    if ([self clientTouchSeverity] == 0) {
        [NSTimer scheduledTimerWithTimeInterval:0.0
                                         target:self
                                       selector:@selector(postClientTouchedTimer:)
                                       userInfo:userInfo
                                        repeats:NO] ;
    }
    
    if (underride || (severity > [self clientTouchSeverity])) {
        [self setClientTouchSeverity:severity] ;
    }
    
    if (!client) {
        [self setClientTouchedAll:YES] ;
    }
}

- (void)postClientTouchedTimer:(NSTimer*)timer {
	Client* client = [self clientTouchedAll] ? nil : [[timer userInfo] objectForKey:constKeyClient] ;
	NSNumber* severityNumber = [NSNumber numberWithInteger:[self clientTouchSeverity]] ;
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							  severityNumber, constKeySeverity,
							  client, constKeyClient,
							  nil] ;
	[[NSNotificationCenter defaultCenter] postNotificationName:constNoteBkmxClientDidChange
														object:self
													  userInfo:userInfo] ;
	// Reset for next run loop iteration, next notification coalesce group
	[self setClientTouchSeverity:0] ;
	[self setClientTouchedAll:NO] ;

	[self setClientsDummyForKVO:![self clientsDummyForKVO]] ;
}

- (void)setClients:(NSSet*)value {    	
    [self willChangeValueForKey:constKeyClients];
    [self setPrimitiveClients:[NSMutableSet setWithSet:value]];
    [self didChangeValueForKey:constKeyClients];
	
	NSInteger severity = ([value count] > 0) ? 7 : 4 ;
	[self postTouchedClient:nil
				   severity:severity] ;
}

- (void)addClientsObject:(Client*)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyClients withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveClients] addObject:value];
    [self didChangeValueForKey:constKeyClients withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];

	NSInteger severity = (value != nil) ? 7 : 4 ; // Probably defensive programming.  Could value ever be nil?
	[self postTouchedClient:value
				   severity:severity] ;
}

- (void)removeClientsObject:(Client*)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyClients withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveClients] removeObject:value];
    [self didChangeValueForKey:constKeyClients withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];

	[self postTouchedClient:value
				   severity:4] ;
}

- (void)addClients:(NSSet*)value {    
    [self willChangeValueForKey:constKeyClients withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveClients] unionSet:value];
    [self didChangeValueForKey:constKeyClients withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];

	NSInteger severity = ([value count] > 0) ? 7 : 4 ;
	[self postTouchedClient:nil
				   severity:severity] ;
}

- (void)removeClients:(NSSet *)value {
    [self willChangeValueForKey:constKeyClients withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveClients] minusSet:value];
    [self didChangeValueForKey:constKeyClients withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];

	[self postTouchedClient:nil
				   severity:4] ;
}

- (void)deleteAllClients {
	NSSet* immutableCopy = [[self clients] copy] ;
	for (Client* client in immutableCopy) {
		[self removeClientsObject:client] ;
		// See Note 290293
		[[self managedObjectContext] deleteObject:client] ;
	}
	[immutableCopy release] ;
	
	[self postTouchedClient:nil
				   severity:4] ;
}

- (long long)syncerConfigValue {
	return [[self syncerConfig] unsignedLongLongValue] ;
}

// Note that the following to-many accessor overrides are needed to -postTouchedSyncer:severity:
// and save the moc, etc., when an syncer is added or removed in Settings > Advanced
// by clicking the [+] or [-] button, because this action comes via the array
// controller.  Added these methods to fix bug in BookMacster 1.1.20.
- (void)setSyncers:(NSSet*)value {    	
    [self willChangeValueForKey:constKeySyncers];
    [self setPrimitiveSyncers:[NSMutableSet setWithSet:value]];
    [self didChangeValueForKey:constKeySyncers];
	
	[self postTouchedSyncer:nil
                   severity:8] ;
}

- (void)addSyncersObject:(Syncer*)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeySyncers withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveSyncers] addObject:value];
    [self didChangeValueForKey:constKeySyncers withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
	
	[self postTouchedSyncer:value
                   severity:8] ;
}

- (void)removeSyncersObject:(Syncer*)value {
	[Stager removeStagingForSyncerUri:[value objectUriMakePermanent:NO
                                                           document:nil]] ;

    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeySyncers withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveSyncers] removeObject:value];
    [self didChangeValueForKey:constKeySyncers withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
	
	[self postTouchedSyncer:value
                   severity:4] ;
}

- (void)addSyncers:(NSSet*)value {    
    [self willChangeValueForKey:constKeySyncers withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveSyncers] unionSet:value];
    [self didChangeValueForKey:constKeySyncers withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
	
	[self postTouchedSyncer:nil
                   severity:8] ;
}

- (void)removeSyncers:(NSSet *)value {
	for (Syncer* syncer in value) {
		[Stager removeStagingForSyncerUri:[syncer objectUriMakePermanent:NO
                                                                document:nil]] ;
	}
    [self willChangeValueForKey:constKeySyncers withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveSyncers] minusSet:value];
    [self didChangeValueForKey:constKeySyncers withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
	
	[self postTouchedSyncer:nil
                   severity:4] ;
}

- (void)setSyncerConfigBit:(BOOL)bit
                      mask:(long long)bitMask {
	// Get the existing value from the model
	long long syncerConfig = [self syncerConfigValue] ;
	// Set the existing bit to 0
	syncerConfig = syncerConfig & (~bitMask) ;
	// Set the bit to the new value
	long long newValueMask = bit ? bitMask : 0x0 ;
	syncerConfig = syncerConfig | newValueMask ;
	// Set the new value into the model
	NSNumber* newValue = [NSNumber numberWithLongLong:syncerConfig] ;
	[self setSyncerConfig:newValue] ;

	[self syncSyncersFromSyncingConfig] ;
}

- (void)setSyncerPausedConfigBit:(BOOL)bit
                            mask:(long long)bitMask {
	// Get the existing value from the ivar
	long long syncerPausedConfig = [self syncerPausedConfig] ;
	// Set the existing bit to 0
	syncerPausedConfig = syncerPausedConfig & (~bitMask) ;
	// Set the bit to the new value
	long long newValueMask = bit ? bitMask : 0x0 ;
	syncerPausedConfig = syncerPausedConfig | newValueMask ;
	// Set the new value into the ivar
	[self setSyncerPausedConfig:syncerPausedConfig] ;
}

- (long long)syncerConfigActiveValue {
	long long answer ;
	if ([self syncersPaused]) {
		answer = [self syncerPausedConfig] ;
	}
	else {
		answer = [self syncerConfigValue] ;
	}

	return answer ;
}

+ (NSSet*)keyPathsForValuesAffectingSyncerConfigActiveValue {
    return [NSSet setWithObjects:
            @"syncerConfig",
            @"syncerPausedConfig",
            @"syncersPaused",
            nil] ;
}

- (BOOL)syncerConfigImportChanges {
    BOOL answer = (([self syncerConfigActiveValue] & constBkmxSyncerConfigImportChanges) != 0) ;
    
	return answer ;
}

- (void)setSyncerConfigImportChanges:(BOOL)yn {
	if ([self syncersPaused]) {
		[self setSyncerPausedConfigBit:yn
                                  mask:constBkmxSyncerConfigImportChanges] ;
	}
	else {
		[self setSyncerConfigBit:yn
                            mask:constBkmxSyncerConfigImportChanges] ;
	}
    
    // Added in BookMacster 1.19.8
    if (!yn) {
        [self setSyncerConfigSort:NO] ;
        [self setSyncerConfigExportToClients:NO] ;
    }
}

+ (NSSet*)keyPathsForValuesAffectingSyncerConfigImportChanges {
	return [NSSet setWithObjects:
			@"syncerConfig",
			@"syncerPausedConfig",
			@"syncersPaused",
			nil] ;
}

- (BOOL)syncerConfigSort {
    BOOL answer = (([self syncerConfigActiveValue] & constBkmxSyncerConfigSort) != 0) ;
	
	return answer ;
}

- (void)setSyncerConfigSort:(BOOL)yn {
	if ([self syncersPaused]) {
		[self setSyncerPausedConfigBit:yn
                                  mask:constBkmxSyncerConfigSort] ;
	}
	else {
		[self setSyncerConfigBit:yn
                            mask:constBkmxSyncerConfigSort] ;
	}
}

+ (NSSet*)keyPathsForValuesAffectingSyncerConfigSort {
	return [NSSet setWithObjects:
			@"syncerConfig",
			@"syncerPausedConfig",
			@"syncersPaused",
			nil] ;
}

- (BOOL)syncerConfigExportToClients {
    BOOL answer = (([self syncerConfigActiveValue] & constBkmxSyncerConfigExportToClients) != 0) ;
	
	return answer ;
}

- (void)setSyncerConfigExportToClients:(BOOL)yn {
	if ([self syncersPaused]) {
		[self setSyncerPausedConfigBit:yn
                                  mask:constBkmxSyncerConfigExportToClients] ;
	}
	else {
		[self setSyncerConfigBit:yn
                            mask:constBkmxSyncerConfigExportToClients] ;
	}
}

+ (NSSet*)keyPathsForValuesAffectingSyncerConfigExportToClients {
	return [NSSet setWithObjects:
			@"syncerConfig",
			@"syncerPausedConfig",
			@"syncersPaused",
			nil] ;
}

- (BOOL)syncerConfigExportCloud {
    BOOL answer = (([self syncerConfigActiveValue] & constBkmxSyncerConfigExportFromCloud) != 0) ;
	
	return answer ;
}

- (void)setSyncerConfigExportCloud:(BOOL)yn {
	if ([self syncersPaused]) {
		[self setSyncerPausedConfigBit:yn
                                  mask:constBkmxSyncerConfigExportFromCloud] ;
	}
	else {
		[self setSyncerConfigBit:yn
                            mask:constBkmxSyncerConfigExportFromCloud] ;
	}
}

+ (NSSet*)keyPathsForValuesAffectingSyncerConfigExportCloud {
	return [NSSet setWithObjects:
			@"syncerConfig",
			@"syncerPausedConfig",
			@"syncersPaused",
			nil] ;
}

- (BOOL)syncerConfigExportLanding {
    BOOL answer = (([self syncerConfigActiveValue] & constBkmxSyncerConfigExportLanding) != 0) ;
	
	return answer ;
}

- (void)setSyncerConfigExportLanding:(BOOL)yn {
	if ([self syncersPaused]) {
		[self setSyncerPausedConfigBit:yn
                                  mask:constBkmxSyncerConfigExportLanding] ;
	}
	else {
		[self setSyncerConfigBit:yn
                            mask:constBkmxSyncerConfigExportLanding] ;
	}
}

+ (NSSet*)keyPathsForValuesAffectingSyncerConfigExportLanding {
	return [NSSet setWithObjects:
			@"syncerConfig",
			@"syncerPausedConfig",
			@"syncersPaused",
			nil] ;
}

- (void)setSyncerConfigActiveValueNone {
    [self setSyncerConfigImportChanges:NO] ;
    [self setSyncerConfigExportToClients:NO] ;
    [self setSyncerConfigExportCloud:NO] ;
    [self setSyncerConfigExportLanding:NO] ;
}

- (void)setSyncerConfigFullSync {
    [self setSyncerConfigImportChanges:YES] ;
    [self setSyncerConfigExportToClients:YES] ;
    [self setSyncerConfigExportCloud:YES] ;
    [self setSyncerConfigExportLanding:YES] ;
}

- (void)pauseSyncers {
	long long syncerConfig = [self syncerConfigValue] ;
	BOOL syncersIsAdvanced = ((syncerConfig & constBkmxSyncerConfigIsAdvanced) != 0) ;
	
	if (syncersIsAdvanced) {
		for (Syncer* syncer in [self syncers]) {
			[syncer setIsActive:@NO] ;
		}
	}
	else {
		[self setSyncerConfig:[NSNumber numberWithLongLong:constBkmxSyncerConfigNone]] ;
	}
	[self setSyncerPausedConfig:syncerConfig] ;
	
	[self setSyncersPaused:YES] ;
	
	// Don't save here because this is just a pause.
	// If we crash before saving, they might come back.
	// [self save] ;  // Don't do this.    
}

- (NSString*)pauseSyncersAndAppendToMessage:(NSString*)message {
	if ([self syncerConfigValue] == constBkmxSyncerConfigNone) {
		return message ;
	}
	
	[self pauseSyncers] ;

	// Normally, if the user just casually clicks the 'Syncing' button to
	// pause syncers, we don't save that state immediately.  But in this
	// case, we do.
	[self save] ;
	
	// Append to the message what we did, creating a message if none.
	if (!message) {
		message = [NSString string] ;
	}
	else if ([message length] > 0) {
		message = [message stringByAppendingString:@"\n\n"] ;
	}

	/* -pauseSyncers actually removes the syncers.  The paused syncers are
     stored in syncerPausedConfig, which is volatile and goes away when the app
     quits.  So if we are in a BkmxAgent which has not user interface and
     quits without warning, syncers are not recoverable, so they are
     effectively removed and not just paused. */
	NSString* pausedOrSwitchedOff = [[BkmxBasis sharedBasis] isBkmxAgent] ? @"switched off" : @"paused" ;
	message = [message stringByAppendingFormat:
			   @"One more thing: To prevent recurrence, syncing has been %@.  "
			   @"To resume syncing, after the issue is resolved, click the 'Syncing' button in the toolbar.",
			   pausedOrSwitchedOff] ;
	
	return message ;
}

- (void)pauseSyncers:(BOOL)pauseSyncers
			  alert:(SSYAlert*)alert {
	if (alert) {
		NSInteger checkboxState = [alert checkboxState] ;
		if (checkboxState == NSControlStateValueOn) {
            // Bug fixed in BookMacster 1.22.4.  The following was not using
            // the 'mainApp' version, so had no effect in shoebox Workers.
			[[NSUserDefaults standardUserDefaults] setAndSyncMainAppBool:YES
                                                                  forKey:constKeyDontWarnExport] ;
		}
	}
	
	if (pauseSyncers) {
		[self pauseSyncers] ;
	}
}

- (BOOL)isPoisedToSync {
    BOOL answer =
    ![self syncersPaused]
    &&
    [self aSyncerWouldIxportIfActivatedOrResumedDoQualifyExport:YES]
    &&
    ([[self activeClients] count] > 0)
    &&
    (
     (([self syncerConfigValue] & constBkmxSyncerConfigIsAdvanced) != 0)
     ||
     (([self syncerConfigValue] & constBkmxSyncerConfigImportChanges) != 0)
     ||
     (([self syncerConfigValue] & constBkmxSyncerConfigExportToClients) != 0)
     )
    ;

    return answer ;
}

- (void)resumeSyncers {
    long long pausedConfig = [self syncerPausedConfig] ;
    if (pausedConfig == constBkmxSyncerConfigIsAdvanced) {
        // Resume Advanced Syncers
        for (Syncer* syncer in [self syncers]) {
            [syncer setIsActive:[NSNumber numberWithBool:YES]] ;
        }
    }
    else if (pausedConfig != constBkmxSyncerConfigNone) {
        // Resume Simple Syncers
        [self setSyncerConfig:[NSNumber numberWithLongLong:pausedConfig]] ;
        [self syncSyncersFromSyncingConfig] ;
    }
    
    [self setSyncerPausedConfig:constBkmxSyncerConfigNone] ;
    [self setSyncersPaused:NO] ;
}

- (BOOL)aSyncerWouldIxportIfActivatedOrResumedDoQualifyExport:(BOOL)doQualifyExport {
	BOOL answer = NO ;

	long long syncerConfig = [self syncerConfigValue] ;
	BOOL syncersIsAdvanced = ((syncerConfig & constBkmxSyncerConfigIsAdvanced) != 0) ;
	
	if (syncersIsAdvanced) {
		for (Syncer* syncer in [self syncers]) {
			if ([syncer doesImport] || ([syncer doesExport] && doQualifyExport)) {
				answer = YES ;
				break ;
			}
		}
	}
	else {
		// Syncers are simple
		long long relevantSyncerConfig = [self syncerConfigActiveValue] ;
		
		if (
			((relevantSyncerConfig & constBkmxSyncerConfigImportChanges) != 0)
			||			
			(((relevantSyncerConfig & constBkmxSyncerConfigExportToClients) != 0) && doQualifyExport)
			||			
			(((relevantSyncerConfig & constBkmxSyncerConfigExportFromCloud) != 0) && doQualifyExport)
			||
			(((relevantSyncerConfig & constBkmxSyncerConfigExportLanding) != 0) && doQualifyExport)
			) {
			answer = YES ;
		}
	}
	
	return answer ;
}

- (void)toggleSync {
	if ([self aSyncerWouldIxportIfActivatedOrResumedDoQualifyExport:YES]) {
		if ([self syncersPaused]) {
			[self resumeSyncers] ;
		}
		else {
			[self pauseSyncers:YES
						alert:nil] ;
		}
	}
	else {
		[[[self bkmxDoc] bkmxDocWinCon] setUpSync:self] ;
	}
}

- (void)deleteAllSyncers {
	// Setup…
	[self setSyncerConfig:[NSNumber numberWithLongLong:constBkmxSyncerConfigNone]] ;
	
	// removing Triggers and Commands (i.e., ownees) will be done by
	// Core Data's Cascade Delete Rule
	[self postTouchedMacsterWithSyncerSeverity:0] ;
}

- (void)syncersSetExpertise:(BOOL)advanced {	
	long long newConfig ;
	if (advanced) {
		// In this case, we change the configuration but do not remove
		// any of the syncers
		newConfig = constBkmxSyncerConfigIsAdvanced ;
	}
	else {
		// In this case, we change the configuration *and* remove any
		// existing syncers
		newConfig = constBkmxSyncerConfigNone ;
		// [self deleteAllSyncers] ;  Not needed because this will be done by -syncSyncersFromSyncingConfig
	}
	
	[self setSyncerConfig:[NSNumber numberWithLongLong:newConfig]] ;
}

- (BOOL)hasAThisUserActiveImportClient {
	BOOL answer = NO ;
	for (Client* client in [self clients]) {
		if (![[(Ixporter*)[client importer] isActive] boolValue]) {
			continue ;
		}
		
		Class extoreClass = [client extoreClass] ;
		const ExtoreConstants* constants_p = [extoreClass constants_p] ;
		// Defensive programming: Next section will crash if !constants_p
		if (constants_p == NULL) {
			continue ;
		}
		
		NSString* extoreMedia = [client extoreMedia] ;
		if ([extoreMedia isEqualToString:constBkmxExtoreMediaThisUser]) {
			if (constants_p->ownerAppIsLocalApp) {
				answer = YES ;
				break ;
			}
		}
	}
	
	return answer ;
}

- (BOOL)hasAnImportClientWithObserveableBookmarksChanges {
	BOOL answer = NO ;
	for (Client* client in [self clients]) {
		Class extoreClass = [client extoreClass] ;
		const ExtoreConstants* constants_p = [extoreClass constants_p] ;
		if (constants_p == NULL) {
            // This will happen during an "Export to only > Choose File"
            // because the client is "empty" (no exformat, nothing).
            // This is not repeatable.  I don't know why now.  Anyhow,
			continue ;
		}
		
		NSString* extoreMedia = [client  extoreMedia] ;
		if ([extoreMedia isEqualToString:constBkmxExtoreMediaThisUser]) {
			if (constants_p->ownerAppIsLocalApp) {
				OwnerAppObservability observability = [extoreClass ownerAppObservability] ;
				if ([Extore isLiveObservability:observability]) {
					answer = YES ;
					break ;
				}
			}
		}
	}
	
	return answer ;
}

- (NSInteger)deleteObjectsOfEntityName:(NSString*)entityName
					   withNilSelector:(SEL)parentSelector {
	NSManagedObjectContext* moc = [self managedObjectContext] ;
	SSYMojo* mojo ;
	NSMutableSet* deadObjects = [[NSMutableSet alloc] init] ;
	
	// Get orphaned objects
	mojo = [[SSYMojo alloc] initWithManagedObjectContext:moc
											  entityName:entityName] ;
	for (NSManagedObject* object in [mojo allObjects]) {
		if (![object respondsToSelector:parentSelector]) {
			NSLog(@"Internal Error 354-6820 %@ %@", entityName, NSStringFromSelector(parentSelector)) ;
			continue ;
		}
		if ([object performSelector:parentSelector] == nil) {
			[deadObjects addObject:object] ;
		}
	}
	[mojo release] ;
	
	// Delete all orphans found
	for (NSManagedObject* object in deadObjects) {
		[moc deleteObject:object] ;
	}
	
	NSInteger count = [deadObjects count] ;
	[deadObjects release] ;
	
	[self save] ;
	
	return count ;
}

- (NSInteger)removeOrphanedObjectsOfClass:(Class)aClass {
	SEL parentSelector = nil ;
	NSString* entityName = [SSYManagedObject entityNameForClass:aClass] ;
	
	if ([entityName isEqualToString:constEntityNameSyncer]) {
		parentSelector = @selector(macster) ;
	}
	else if ([entityName isEqualToString:constEntityNameTrigger]) {
		parentSelector = @selector(syncer) ;
	}
	else if ([entityName isEqualToString:constEntityNameCommand]) {
		parentSelector = @selector(syncer) ;
	}
	else if ([entityName isEqualToString:constEntityNameClient]) {
		parentSelector = @selector(macster) ;
	}
	else {
		NSLog(@"Internal Error 012-4439 %@", entityName) ;
		return  0 ;
	}
	
	return [self deleteObjectsOfEntityName:entityName
						   withNilSelector: parentSelector] ;
}

#if 0 
#warning Compiling debug method to show all commands in Macster's MOC
- (NSArray*)allCommandsInMoc {
	NSManagedObjectContext* moc = [self managedObjectContext] ;
	SSYMojo* mojo ;
	mojo = [[SSYMojo alloc] initWithManagedObjectContext:moc
											  entityName:[SSYManagedObject entityNameForClass:[Command class]]] ;
	NSArray* commands = [mojo allObjects] ;
	[mojo release] ;
	return [commands shortDescription] ;
}
#endif

+ (NSInteger)countOfSyncersInSyncerConfig:(long long)syncerConfig {
	NSInteger count = 0 ;
	if ((syncerConfig & constBkmxSyncerConfigImportChanges) > 0) {
		count++ ;
	}
	if ((syncerConfig & constBkmxSyncerConfigExportFromCloud) > 0) {
		count++ ;
	}
	if ((syncerConfig & constBkmxSyncerConfigExportLanding) > 0) {
		count++ ;
	}
	
	return count ;
}

- (void)adjustTriggersForClient:(Client*)client
                         syncer:(Syncer*)syncer
               triggerTypeValue:(BkmxTriggerType)triggerTypeValue
               triggersToRemove:(NSMutableSet*)triggersToRemove {
    BOOL matchedExistingTrigger = NO ;

    for (Trigger* trigger in [syncer triggersOrdered]) {
        if ((client == [trigger client]) && (triggerTypeValue == [trigger triggerTypeValue])) {
            // Keep the existing trigger
            [triggersToRemove removeObject:trigger] ;
            matchedExistingTrigger = YES ;
            break;
        }
    }

    if (!matchedExistingTrigger) {
        // No existing trigger matched.  Insert a new one.
        Trigger* trigger = [syncer freshTriggerAtIndex:NSNotFound] ;
        [trigger setTriggerTypeValue:triggerTypeValue] ;
        [trigger setClient:client] ;
    }
}

/*!
 @details This method is typically called in main app, but may also be called
 in BkmxAgent if syncing is paused due to a Sync Fight detected.
 */
- (void)syncSyncersFromSyncingConfig {
	long long syncerConfig = [self syncerConfigValue] ;

	// Only execute if syncerConfig state indicates is Simple, not Advanced.
	if ((syncerConfig & constBkmxSyncerConfigIsAdvanced) != 0) {
        [self save];
		return;
	}
	
	/* Until BookMacster version 1.3.6, at this point I sent [self deleteAllSyncers] ;
	 and then added all *new* syncers based on syncerConfig.  That was easy but
	 sleazy, because I could only invoke this method when syncerConfig was
	 changed manually.  Thus, simple syncers would not update if clients
	 were changed.  To fix that, I needed to invoke this method
	 in -macsterTouchNote.  But that caused an infinite loop because when
	 I removed all syncers in here (or did anything to the syncers, it would
	 invoke -postTouchedSyncer:severity:, which would re-invoke -macsterTouchNote when
	 the runloop cycled, which would reinvoke this method.
	 
	 So in BookMacster 1.3.6 this implementation was changed too.  Instead of
	 removing all syncers at the beginning and adding all new syncers from
	 scratch, now I do a comparison between syncers, their triggers and their
	 commands, and only touch an syncer, trigger or command if it is found
	 to not match the requirements of the current syncerConfig.  That is
	 why you see many, many blocks in this method looking like
	 * if ([foo bar] != newBar) {
	 *      [foo setBar:newBar] ;
	 * }
	 The if() avoid unnecessary touches to syncers, triggers or commands
	 which would cause a -postTouchedSyncer:severity:.  It is lengthy and tedious,
	 but it works.
	 
	 Admittedly, the implementation here is probably not rigorously correct.
	 I wrote it by modifying the original method in an ad hoc fashion, then in
	 BookMacster 1.11 added more code to fix a couple of corner case bugs as
	 noted below.  I was able to get away with this because there are really
	 only two Simple Syncers possible, the "Local Sync" and "Remote Sync", and
	 the user can only switch one of them ON or OFF at a time.  So there are
	 actually only a handful of configuration changes possible.
	 
	 When syncerConfig is changed, the syncers, triggers and commands will be
	 re-set on the first pass through here, postTouchedSyncer:severity: will be
	 invoked, which will notify macsterTouchNote:, which will invoke this
	 method again.  But on the second run, all of the ([foo bar] != newBar)
	 will evaluate to NO, and there will te no more -postTouchedSyncer:severity:,
	 and thus no infinite loop. */
	
	// Stuff we'll be using in this method
	NSManagedObjectContext* moc = [self managedObjectContext] ;
	SSYMojo* mojo ;
	mojo = [[SSYMojo alloc] initWithManagedObjectContext:moc
											  entityName:[SSYManagedObject entityNameForClass:[Syncer class]]] ;
	Syncer* syncer ;
	
	// Added in BookMacster 1.11 to fix a corner case bug
	if (
		([[self syncers] count] == 2)
		&&
		([Macster countOfSyncersInSyncerConfig:syncerConfig] == 1)
		) {
		if ((syncerConfig & constBkmxSyncerConfigExportFromCloud) != 0) {
			// We have two syncers, but we want only one, the second one.
			// Therefore we should delete the first one.  Otherwise,
			// we will modify the first one to be the second one and
			// then delete the second one, which was probably OK.
			Syncer* deadSyncer = [[self syncersOrdered] objectAtIndex:0] ;
			[moc deleteObject:deadSyncer] ;
			[moc processPendingChanges] ;
			[(Syncer*)[[self syncers] anyObject] setIndex:0] ;
		}
	}

	// Added in BookMacster 1.11 to fix a corner case bug, which is kind of
	// the dual of the previous corner case bug fix
	BOOL shouldCreateFirstSyncer = NO ;
	if (
		([[self syncers] count] == 1)
		&&
		([Macster countOfSyncersInSyncerConfig:syncerConfig] == 2)
		) {
		if (![[[self syncersOrdered] objectAtIndex:0] doesImport]) {
			// We want two syncers, but only have one, the second one.
			// Therefore, when comparing the first syncer, we should
			// insert a new one.  If we don't, we'll modify the existing
			// syncer, which is perfectly good as the second syncer, to
			// be the first syncer, and then need to re-create the
			// second syncer.
			shouldCreateFirstSyncer = YES ;
		}
	}	
	
	NSInteger syncerIndex = 0 ;
	if ((syncerConfig & constBkmxSyncerConfigImportChanges) != 0) {
		if ([self hasAThisUserActiveImportClient]) {
			NSMutableString* userDescription = [NSMutableString stringWithString:[[BkmxBasis sharedBasis] labelSyncerImportClients]] ;
			syncer = [[self syncersOrdered] objectSafelyAtIndex:syncerIndex] ;
			if (!syncer || shouldCreateFirstSyncer) {			
				// Create Syncer and User Description
				syncer = [self freshSyncerAtIndex:0] ;
				// Remove the default trigger and commands
				[syncer deleteAllTriggers] ;
				[syncer deleteAllCommands] ;
			}
			
			// Check trigger(s), re-create if wrong
            NSMutableSet* triggersToRemove = [[[syncer triggers] mutableCopy] autorelease] ;
			for (Client* client in [self clientsOrdered]) {
				NSString* extoreMedia = [client extoreMedia] ;
				if (![extoreMedia isEqualToString:constBkmxExtoreMediaThisUser]) {
					continue ;
				}
				
				Class extoreClass = [client extoreClass] ;
				const ExtoreConstants* constants_p = [extoreClass constants_p] ;
				if (!constants_p) {
					NSLog(@"Internal Error 513-2938 %@", [client shortDescription]) ;
					continue ;
				}
				
				if (!(constants_p->ownerAppIsLocalApp)) {
					continue ;
				}
				
				if (![[[client importer] isActive] boolValue]) {
					continue ; 
				}
				
                OwnerAppObservability observability = [extoreClass ownerAppObservability] ;

                /* There are two possible trigger to fulfill the requirement
                 of importing changes.  Depending on the browser's
                 observability, we may add triggers to implement one or both. */
                if ([Extore isLiveObservability:observability]) {
                    // We need a BkmxTriggerSawChange trigger for this client
                    [self adjustTriggersForClient:client
                                           syncer:syncer
                                 triggerTypeValue:BkmxTriggerSawChange
                                 triggersToRemove:triggersToRemove];
                }
                if ((observability & OwnerAppObservabilityOnQuit) != 0) {
                    // We need a BkmxTriggerBrowserQuit trigger for this client
                    [self adjustTriggersForClient:client
                                           syncer:syncer
                                 triggerTypeValue:BkmxTriggerBrowserQuit
                                 triggersToRemove:triggersToRemove];
                }
			}

            /* Remove any existing triggers which were not matched to a
             now-needed trigger. */
            for (Trigger* trigger in triggersToRemove) {
                [syncer deleteTrigger:trigger] ;
            }

            // Check commands, re-create if wrong
			Command* command ;
			NSInteger commandIndex = 0 ;
			{
				//   Import
				command = [[syncer commandsOrdered] objectSafelyAtIndex:commandIndex] ;
				if (!command) {
					command = [syncer freshCommandAtIndex:commandIndex] ;
				}
				if (![[command method] isEqualToString:DEFAULT_IMPORT_METHOD]) {
					[command setMethod:DEFAULT_IMPORT_METHOD] ;
				}
				NSNumber* deference = [NSNumber numberWithInteger:BkmxDeferenceYield] ;
				if (![[command argument] isEqual:deference]) {
					[command setArgument:deference] ;
				}
				commandIndex++ ;
			}
			if ((syncerConfig & constBkmxSyncerConfigSort) != 0) {
				// Sort
                /* This branch got many changes in BookMacster 1.20.2
                 I'm not sure why I did this, but  here is *what* it is.
                 In the other branches, I look at the next indexed command, see
                 if it has the expected method, and if not, not modify its
                 *method* to do what is expected.  In this branch, instead of
                 taking the one which is at the expected *index*, I search
                 through all remaining commands to find one which *has* the
                 expected *method*, and if necessary modify its *index* to
                 the expected position.  This must have resulted in less
                 "command churning" in some important case(s). */
				command = [[syncer commandsOrdered] objectSafelyAtIndex:commandIndex] ;
				if (![[command method] isEqualToString:@"sort"]) {
                    for (Command* aCommand in [syncer commands]) {
                        NSInteger currentIndex = [[aCommand index] integerValue] ;
                        if (currentIndex >= commandIndex) {
                            [aCommand setIndex:[NSNumber numberWithInteger:(currentIndex+1)]] ;
                        }
                    }
                    // Don't use -freshCommandAtIndex: because that would adjust
                    // siblings' indexes.  Instead, use two separate calls…
                    command = [syncer freshCommand] ;
                    [command setIndex:[NSNumber numberWithInteger:commandIndex]] ;
					[command setMethod:@"sort"] ;
				}
				[userDescription appendFormat:
				 @" %@ %@",
				 constEmDash,
				 [[BkmxBasis sharedBasis] labelSort]] ;
				commandIndex++ ;
			}
			if ((syncerConfig & constBkmxSyncerConfigExportToClients) != 0) {
				// Export
				command = [[syncer commandsOrdered] objectSafelyAtIndex:commandIndex] ;
				if (!command) {
					command = [syncer freshCommandAtIndex:commandIndex] ;
				}
				if (![[command method] isEqualToString:constMethodPlaceholderExportAll]) {
					[command setMethod:constMethodPlaceholderExportAll] ;
				}
				NSNumber* deference = [NSNumber numberWithInteger:BkmxDeferenceYield] ;
				if (![[command argument] isEqual:deference]) {
					[command setArgument:deference] ;
				}
				[userDescription appendFormat:
				 @" %@ %@",
				 constEmDash,
				 [[BkmxBasis sharedBasis] labelExportToAll]] ;
				commandIndex++ ;
			}		
			{
				// Save
				command = [[syncer commandsOrdered] objectSafelyAtIndex:commandIndex] ;
				if (!command) {
					command = [syncer freshCommandAtIndex:commandIndex] ;
				}
				if (![[command method] isEqualToString:@"saveDocument"]) {
					[command setMethod:@"saveDocument"] ;
				}
				commandIndex++ ;
			}
            // Remove any commands beyond those currently required
			while ((command = [[syncer commandsOrdered] objectSafelyAtIndex:commandIndex])) {
				[syncer deleteCommand:command] ;
			}
			
			// Finish this syncer
			if(![[syncer userDescription] isEqualToString:userDescription]) {
				[syncer setUserDescription:userDescription] ;
			}
			syncerIndex++ ;
		}
		else if ([self hasAnImportClientWithObserveableBookmarksChanges]) {
			// This branch was added in BookMacster 1.11.3 after I spent an hour wondering
			// why I didn't get the "Export" "It's OK" "Pause Syncing" dialog after 
			// creating a Syncer when no Clients had an active Import.
			NSString* msg = @"An syncer has been created, but will not do anything until you have at least one Client set to 'Import'.  To fix that, click the 'Clients' tab." ;
			SSYAlert* alert = [SSYAlert alert] ;
			[alert setSmallText:msg] ;
			[alert setIconStyle:SSYAlertIconInformational] ;
			[alert setButton1Title:[[BkmxBasis sharedBasis] labelOk]] ;
			[[self bkmxDoc] runModalSheetAlert:alert
                                    resizeable:NO
                                     iconStyle:SSYAlertIconInformational
                                 modalDelegate:nil
                                didEndSelector:NULL
                                   contextInfo:NULL] ;
		}
	}	
		
	if ((syncerConfig & constBkmxSyncerConfigExportFromCloud) != 0) {
		syncer = [[self syncersOrdered] objectSafelyAtIndex:syncerIndex] ;
		if (!syncer) {			
			// Create Syncer and User Description
			syncer = [self freshSyncerAtIndex:NSNotFound] ;
			// Remove the default trigger and commands
			[syncer deleteAllTriggers] ;
			[syncer deleteAllCommands] ;
		}
		
		// Check/Create the two triggers
		Trigger* trigger ;
        // Create or modify trigger 0, "Other Mac updates this file"
        trigger = [[syncer triggersOrdered] objectSafelyAtIndex:0] ;
		if (!trigger) {
			trigger = [syncer freshTriggerAtIndex:0] ;
		}				
		if ([trigger triggerTypeValue] != BkmxTriggerCloud) {
			[trigger setTriggerTypeValue:BkmxTriggerCloud] ;
		}
        if ([[trigger efficiently] integerValue] != TRIGGER_DETAIL_EFFICIENTLY_NO) {
            [trigger setEfficiently:[NSNumber numberWithInteger:TRIGGER_DETAIL_EFFICIENTLY_NO]] ;
        }
        if ([trigger client] != nil) {
            [trigger setClient:nil] ;
        }
        if ([trigger recurringDate] != nil) {
            [trigger setRecurringDate:nil] ;
        }
		// Create or modify trigger 1, "I log in to my Mac … only if this .bmco has changed"
        trigger = [[syncer triggersOrdered] objectSafelyAtIndex:1] ;
		if (!trigger) {
			trigger = [syncer freshTriggerAtIndex:1] ;
		}
		if ([trigger triggerTypeValue] != BkmxTriggerLogIn) {
			[trigger setTriggerTypeValue:BkmxTriggerLogIn] ;
		}
        if ([[trigger efficiently] integerValue] != TRIGGER_DETAIL_EFFICIENTLY_YES) {
            [trigger setEfficiently:[NSNumber numberWithInteger:TRIGGER_DETAIL_EFFICIENTLY_YES]] ;
        }
        if ([trigger client] != nil) {
            [trigger setClient:nil] ;
        }
        if ([trigger recurringDate] != nil) {
            [trigger setRecurringDate:nil] ;
        }
		// Remove any triggers beyond those two
		while ((trigger = [[syncer triggersOrdered] objectSafelyAtIndex:2])) {
			[syncer deleteTrigger:trigger] ;
		}
		
		// Check/Create the single Command
		Command* command ;
		{
			// Export
			command = [[syncer commandsOrdered] objectSafelyAtIndex:0] ;
			if (!command) {
				command = [syncer freshCommandAtIndex:0] ;
			}
			if (![[command method] isEqualToString:constMethodPlaceholderExportAll]) {
				[command setMethod:constMethodPlaceholderExportAll] ;
			}
			if (![[command argument] isEqual:[NSNumber numberWithInteger:BkmxDeferenceQuit]]) {
				[command setArgument:[NSNumber numberWithInteger:BkmxDeferenceQuit]] ;
			}
		}
		// Remove any commands beyond the one currently required
		while ((command = [[syncer commandsOrdered] objectSafelyAtIndex:1])) {
			[syncer deleteCommand:command] ;
		}
		
		NSString* userDescription = [[BkmxBasis sharedBasis] labelSyncerCloud] ;
		if (![[syncer userDescription] isEqualToString:userDescription]) {
			[syncer setUserDescription:userDescription] ;
		}
		syncerIndex++ ;
	}
	
	if ((syncerConfig & constBkmxSyncerConfigExportLanding) != 0) {
		syncer = [[self syncersOrdered] objectSafelyAtIndex:syncerIndex] ;
		if (!syncer) {
			// Create Syncer and User Description
			syncer = [self freshSyncerAtIndex:NSNotFound] ;
			// Remove the default trigger and commands
			[syncer deleteAllTriggers] ;
			[syncer deleteAllCommands] ;
		}
		
		// Check/Create the single Trigger
		Trigger* trigger = [[syncer triggersOrdered] objectSafelyAtIndex:0] ;
		if (!trigger) {
			trigger = [syncer freshTriggerAtIndex:0] ;
		}
		if ([trigger triggerTypeValue] != BkmxTriggerLanding) {
			[trigger setTriggerTypeValue:BkmxTriggerLanding] ;
		}
		// Remove any triggers beyond those currently required
		while ((trigger = [[syncer triggersOrdered] objectSafelyAtIndex:1])) {
			[syncer deleteTrigger:trigger] ;
		}
		
		// Check/Create the single Command
		Command* command ;
		{
			// Export
			command = [[syncer commandsOrdered] objectSafelyAtIndex:0] ;
			if (!command) {
				command = [syncer freshCommandAtIndex:0] ;
			}
			if (![[command method] isEqualToString:constMethodPlaceholderExportAll]) {
				[command setMethod:constMethodPlaceholderExportAll] ;
			}
			if (![[command argument] isEqual:[NSNumber numberWithInteger:BkmxDeferenceQuit]]) {
				[command setArgument:[NSNumber numberWithInteger:BkmxDeferenceQuit]] ;
			}
		}
		// Remove any commands beyond the one currently required
		while ((command = [[syncer commandsOrdered] objectSafelyAtIndex:1])) {
			[syncer deleteCommand:command] ;
		}
		
		NSString* userDescription = [[BkmxBasis sharedBasis] labelSyncerLanded] ;
		if (![[syncer userDescription] isEqualToString:userDescription]) {
			[syncer setUserDescription:userDescription] ;
		}
		syncerIndex++ ;
	}
	
	/* Delete syncers which are no longer warranted. */
    NSMutableSet* deadObjects = [[NSMutableSet alloc] init] ;
	for (Syncer* syncer in [mojo allObjects]) {
		if ([[syncer index] integerValue] >= syncerIndex) {
			[deadObjects addObject:syncer] ;
		}
	}
	for (Syncer* syncer in deadObjects) {
		[moc deleteObject:syncer] ;
	}
	[deadObjects release] ;
	[self save] ;

	[mojo release] ;
#if 0
    NSLog(@"After syncing syncers from simple syncer config, syncers are:") ;
    for (Syncer* syncer in [self syncersOrdered]) {
        printf("   %s\n", [[syncer shortDescription] UTF8String]) ;
        for (Trigger* trigger in [syncer triggersOrdered]) {
            printf("      %s [%s]\n", [[trigger shortDescription] UTF8String], trigger.client ? trigger.client.clientoid.exformat.UTF8String : "Na Client") ;
        }
        for (Command* command in [syncer commandsOrdered]) {
            printf("      %s\n", [[command shortDescription] UTF8String]) ;
        }
    }
#endif
}

- (void)fixDeferencelessIECommands {
	for (Syncer* syncer in [self syncers]) {
		for (Command* command in [syncer commands]) {
			if (
				[[command method] isEqualToString:constMethodPlaceholderImport1]
				||
				[[command method] isEqualToString:constMethodPlaceholderImportAll]
				||
				[[command method] isEqualToString:constMethodPlaceholderExport1]
				||
				[[command method] isEqualToString:constMethodPlaceholderExportAll]
				) {
				if (![command argument]) {
					[command setArgument:[NSNumber numberWithInteger:BkmxDeferenceYield]] ;
					NSLog(@"Fixed deferenceless command %@", [command shortDescription]) ;
				}
			}
		}
	}
	
	[self save] ;
}

- (Client*)clientForClidentifier:(NSString*)clidentifier {
	for (Client* client in [self clients]) {
		if ([[[client clientoid] clidentifier] isEqualToString:clidentifier]) {
			return client ;
		}
	}
	
	return nil ;
}

- (NSSet*)clientsForExformat:(NSString*)exformat {
	NSMutableSet* clients = [[NSMutableSet alloc] init] ;
	for (Client* client in [self clients]) {
		if ([[client exformat] isEqualToString:exformat]) {
			[clients addObject:client] ;
		}
	}
	
	NSSet* answer = [clients copy] ;
	[clients release] ;
	
	return [answer autorelease] ;
}



- (NSSet*)thisUserClients {
	NSMutableSet* clients = [[NSMutableSet alloc] init] ;
	for (Client* client in [self clients]) {
		if ([[client extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
			[clients addObject:client] ;
		}
	}
	
	NSSet* answer = [NSSet setWithSet:clients] ;
	[clients release] ;
	
	return answer ;
}

- (NSSet*)thisUserLocalClients {
	NSMutableSet* clients = [[NSMutableSet alloc] init] ;
	for (Client* client in [self thisUserClients]) {
		if ([[client extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
			Class extoreClass = [client extoreClass] ;
			if ([extoreClass constants_p]->ownerAppIsLocalApp) {
				[clients addObject:client] ;
			}
		}
	}
	
	NSSet* answer = [NSSet setWithSet:clients] ;
	[clients release] ;
	
	return answer ;
}

- (NSArray*)syncersOrdered {
	NSSet* syncers = [self syncers] ;
	NSArray* answer = nil ;
	if (syncers) {
		answer = [syncers arraySortedByKeyPath:constKeyIndex] ;
	}
	else {
		answer = nil ;
	}
	
	return answer ;
}

+ (NSSet *)keyPathsForValuesAffectingSyncersOrdered {
	return [NSSet setWithObject:constKeySyncers] ;	
}

- (void)setSyncersOrdered:(NSArray*)syncersOrdered {
	// See "Bindings: NSArrayController gets a new but equal array, pushes back to model"
	// at end of Bookshig.m 
	if ([syncersOrdered isEqualToArray:[self syncersOrdered]]) {
		return ;
	}
	
	[self setIndexedSetWithArray:syncersOrdered
					   forSetKey:constKeySyncers] ;
}

- (Syncer*)syncerAtIndex:(NSInteger)index {
	return [[self syncersOrdered] objectSafelyAtIndex:index] ;
}

- (void)setClientsOrdered:(NSArray*)clientsOrdered {
	// See "Bindings: NSArrayController gets a new but equal array, pushes back to model"
	// at end of Bookshig.m 
	if ([clientsOrdered isEqualToArray:[self clientsOrdered]]) {
		return ;
	}
	
	[self setIndexedSetWithArray:clientsOrdered
					   forSetKey:constKeyClients] ;
}

- (void)makeNewLocalClientWithExformat:(NSString*)exformat
                           profileName:(NSString*)profileName {
	Client* client = [self freshClientAtIndex:NSNotFound
                                    singleUse:NO] ;
	Clientoid* clientoid = [Clientoid clientoidThisUserWithExformat:exformat
														profileName:profileName] ;
	[client setIvarsThenInvokeWaitingIfAnyLikeClientoid:clientoid] ;
	[self save] ;
}

/*!
 @details  The returned Client object has an importer and exporter
 (courtesy of -[Client awakeFromInsert])
 and both of their isActive are set to the model default value of YES.
 */
- (Client*)freshClientAtIndex:(NSInteger)index
                    singleUse:(BOOL)singleUse {
	// Put in same managed object context
	NSManagedObjectContext *moc = [self managedObjectContext] ;
	
	Client* client = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameClient
												   inManagedObjectContext:moc] ;
	NSMutableSet* newSiblings = [self mutableSetValueForKey:constKeyClients] ;
	[newSiblings addObject:client
				   atIndex:index] ;
	
	[self postTouchedClient:client
				   severity:(singleUse ? -4 : 7)] ;

	return client ;
}

/*
 - (Ixporter*)addImporterAtIndex:(NSInteger)index {
 Ixporter* importer = [self newIxporter] ;
 
 NSMutableSet* newSiblings = [self mutableSetValueForKey:constKeyImporters] ;
 [newSiblings addObject:importer
 atIndex:index] ;
 
 [importer addObserver:self
 forKeyPath:constKeyClient
 selector:@selector(mikeAshObserveValueForKeyPath:ofObject:change:userInfo:)
 userInfo:nil
 options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)] ;
 // In case it gets moved later
 [importer addObserver:self
 forKeyPath:constKeyIndex
 selector:@selector(mikeAshObserveValueForKeyPath:ofObject:change:userInfo:)
 userInfo:nil
 options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)] ;
 
 return importer ;
 }
 
 - (Ixporter*)addExporterAtIndex:(NSInteger)index {
 Ixporter* exporter = [self newIxporter] ;
 
 [exporter addObserver:self
 forKeyPath:constKeyClient
 selector:@selector(mikeAshObserveValueForKeyPath:ofObject:change:userInfo:)
 userInfo:nil
 options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)] ;
 // In case it gets moved later
 [exporter addObserver:self
 forKeyPath:constKeyIndex
 selector:@selector(mikeAshObserveValueForKeyPath:ofObject:change:userInfo:)
 userInfo:nil
 options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)] ;
 
 NSMutableSet* newSiblings = [self mutableSetValueForKey:constKeyExporters] ;
 
 [newSiblings addObject:exporter
 atIndex:index] ;
 
 return exporter ;
 }
 */

- (Syncer*)freshSyncerAtIndex:(NSInteger)index {
	// Put in same managed object context
	NSManagedObjectContext *moc = [self managedObjectContext] ;
	
	Syncer* syncer = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameSyncer
												 inManagedObjectContext:moc] ;
	
	NSMutableSet* newSiblings = [self mutableSetValueForKey:constKeySyncers] ;
	[newSiblings addObject:syncer
				   atIndex:index] ;

	[self postTouchedSyncer:syncer
                   severity:8] ;
	
	return syncer ;
}

- (IBAction)addNewSyncer {
	[self freshSyncerAtIndex:NSNotFound] ;
}

- (BOOL)unblindTriggersWithKeys:(NSSet*)triggerBlinderKeys
                        error_p:(NSError**)error_p {
	if ([triggerBlinderKeys count] == 0) {
		return YES ;
	}
	
	NSError* error = nil ;
    
    SSYMojo* mojo = [[SSYMojo alloc] initWithManagedObjectContext:[self managedObjectContext]
													   entityName:constEntityNameTrigger] ;
	NSArray* triggers = [mojo allObjects] ;
	[mojo release] ;
	
	NSMutableArray* errors = [[NSMutableArray alloc] init] ;
    NSInteger nTriggers = 0 ;
    for (NSString* key in triggerBlinderKeys) {
		for (Trigger* trigger in triggers) {
            nTriggers++ ;
			NSError* aError = nil ;
            [trigger unblindIfKey:key
                          error_p:&aError] ;
            if (aError) {
                [errors addObject:aError] ;
            }
		}
	}
    
    if ([errors count] > 0) {
        NSString* errorDesc = [NSString stringWithFormat:
                               @"Could not re-enable %ld/%ld syncer triggers",
                               (long)[errors count],
                               (long)nTriggers] ;
        error = SSYMakeError(constBkmxErrorCouldNotReenableTrigger, errorDesc) ;
        if ([errors count] == 1) {
            error = [error errorByAddingUnderlyingError:[errors objectAtIndex:0]] ;
        }
        else {
            // TODO someday: SSYUnderlyingErrorsErrorKey
            error = [error errorByAddingUserInfoObject:errors
                                                forKey:@"Underlying Errors"] ;
        }
    }
    
    [errors release] ;
    
    if (error && error_p) {
        *error_p = error ;
    }
    
    return (error == nil) ;
}

- (NSArray*)clientsOrdered {
    NSArray* __block answer;
    [self.managedObjectContext performBlockAndWait:^{
        NSSet* clients = [self clients];
        answer = [clients arraySortedByKeyPath:constKeyIndex];
        [answer retain];
    }];
    [answer autorelease];
    return answer;
}
+ (NSSet*)keyPathsForValuesAffectingClientsOrdered {
	return [NSSet setWithObjects:
			constKeyClientsDummyForKVO,
			nil] ;
}

- (NSArray*)clientsWithIxportBothActive {
	NSMutableArray* ixportClients = [[NSMutableArray alloc] init] ;
	for (Client* client in [self clientsOrdered]) {
		if (
			[[[client importer] isActive] boolValue]
			&&
			[[[client exporter] isActive] boolValue]
			) {
			[ixportClients addObject:client] ;
		}
	}
	
	NSArray* answer = [ixportClients copy] ;
	[ixportClients release] ;
	return [answer autorelease] ;
}

- (NSArray*)clientsWithIxportEitherActive {
	NSMutableArray* ixportClients = [[NSMutableArray alloc] init] ;
	for (Client* client in [self clientsOrdered]) {
		if (
			[[[client importer] isActive] boolValue]
			||
			[[[client exporter] isActive] boolValue]
			) {
			[ixportClients addObject:client] ;
		}
	}
	
	NSArray* answer = [ixportClients copy] ;
	[ixportClients release] ;
	return [answer autorelease] ;
}

- (NSArray*)activeIxportersWithSelector:(SEL)selector {
	NSMutableArray* activeIxporters = [[NSMutableArray alloc] init] ;
	for (Client* client in [self clientsOrdered]) {
		Ixporter* ixporter = [client performSelector:selector] ;
		if ([[ixporter isActive] boolValue]) {
			[activeIxporters addObject:ixporter] ;
		}
	}
	
	NSArray* answer = [activeIxporters copy] ;
	[activeIxporters release] ;
	
	return [answer autorelease] ;
}

- (NSArray*)activeImportersOrdered {
	return [self activeIxportersWithSelector:@selector(importer)] ;
}

- (NSArray*)activeExportersOrdered {
	return [self activeIxportersWithSelector:@selector(exporter)] ;
}

- (NSSet*)ixportersWithSelector:(SEL)selector {
	NSMutableSet* ixporters = [[NSMutableSet alloc] init] ;
	for (Client* client in [self clientsOrdered]) {
		Ixporter* ixporter = [client performSelector:selector] ;
		[ixporters addObject:ixporter] ;
	}
	
	NSSet* answer = [ixporters copy] ;
	[ixporters release] ;
	
	return [answer autorelease] ;
}

- (NSSet*)importers {
	return [self ixportersWithSelector:@selector(importer)] ;
}
+ (NSSet*)keyPathsForValuesAffectingImporters {
	return [NSSet setWithObjects:
			constKeyClientsDummyForKVO,
			nil] ;
}

- (NSSet*)exporters {
	return [self ixportersWithSelector:@selector(exporter)] ;
}
+ (NSSet*)keyPathsForValuesAffectingExporters {
	return [NSSet setWithObjects:
			constKeyClientsDummyForKVO,
			nil] ;
}

- (NSArray*)folderMappings {
    NSMutableArray* folderMappings = [[NSMutableArray alloc] init] ;
    for (Client* client in [self clientsOrdered]) {
        NSArray* ixporters = [NSArray arrayWithObjects:
                              [client importer],
                              [client exporter],
                              nil] ;
        for (Ixporter* ixporter in ixporters) {
            for (FolderMap* folderMap in [ixporter folderMapsOrdered]) {
                BkmxIxportPolarity polarity = [ixporter isKindOfClass:[Importer class]] ? BkmxIxportPolarityImport : BkmxIxportPolarityExport ;
                NSDictionary* mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithBool:polarity], constKeyIxportPolarity,
                                         [folderMap folderId], constKeyFolderId,
                                         [[folderMap ixporter] client], constKeyClient,
                                         [folderMap tag], constKeyTag,
                                         nil] ;
                [folderMappings addObject:mapping] ;
            }
        }
    }
    
    NSArray* answer = [[folderMappings copy] autorelease] ;
    [folderMappings release] ;
    
    return answer ;
}

- (NSArray*)tagMappings {
    NSMutableArray* tagMappings = [[NSMutableArray alloc] init] ;
    for (Client* client in [self clientsOrdered]) {
        NSArray* ixporters = [NSArray arrayWithObjects:
                              [client importer],
                              [client exporter],
                              nil] ;
        for (Ixporter* ixporter in ixporters) {
            for (TagMap* tagMap in [ixporter tagMapsOrdered]) {
                BkmxIxportPolarity polarity = [ixporter isKindOfClass:[Importer class]] ? BkmxIxportPolarityImport : BkmxIxportPolarityExport ;
                NSDictionary* mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithBool:polarity], constKeyIxportPolarity,
                                         [tagMap folderId], constKeyFolderId,
                                         [[tagMap ixporter] client], constKeyClient,
                                         [tagMap tag], constKeyTag,
                                         nil] ;
                [tagMappings addObject:mapping] ;
            }
        }
    }
    
    NSArray* answer = [[tagMappings copy] autorelease] ;
    [tagMappings release] ;
    
    return answer ;
}

- (void)save {
	if ([self bkmxDoc]) {
        NSError* error = nil ;
        BOOL ok = [[self managedObjectContext] save:&error] ;
        /* I occasionally see exceptions raised by the above.  Possibly that is
         because the macster gets saved (that is, this code runs) a half dozen
         or more times during a typical syncing operation.  It is possible that
         some work could be done to fix that, but, on the other hand, the many
         saves may be good for data integrity. */
        if (!ok) {
            NSLog(@"Error 229850 saving %@ for %@: %@",
                  [self managedObjectContext],
                  [self shortDescription],
                  [error longDescription]) ; // Added in BookMacster 1.11
        }
    }
}

- (void)saveLater {
	[self performSelector:@selector(save)
			   withObject:nil
			   afterDelay:0.0] ;
}

- (void)sayBadTriggerTimer:(NSTimer*)timer {
    NSString* badTriggerReason = [timer userInfo] ;
    NSString* msg = [NSString stringWithFormat:@"Uh-oh. %@", badTriggerReason] ;
    [[BkmxBasis sharedBasis] logFormat:msg] ;
    NSLog(@"Warning 624-0025 %@", msg) ;
    msg = [@"Your Syncers can no longer work as you have prescribed.  Please check your Clients and Syncers.  " stringByAppendingString:badTriggerReason] ;
    if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
        SSYAlert* alert = [SSYAlert alert] ;
        [alert setSmallText:msg] ;
        [[self bkmxDoc] runModalSheetAlert:alert
                                resizeable:NO
                                 iconStyle:SSYAlertIconCritical
                             modalDelegate:nil
                            didEndSelector:NULL
                               contextInfo:NULL] ;
    }
    
    [[self badTriggerSayer] invalidate] ; // Defensive programming
    [self setBadTriggerSayer:nil] ;
}

- (BOOL)fixTriggersIfSimpleSyncers {
    BOOL didChangeSomething = NO;
    if ([self syncerConfigValue] != constBkmxSyncerConfigIsAdvanced) {
        for (Syncer* syncer in [self syncers]) {

            // Build dictionary of clients and triggers
            NSMutableArray* clientsAndTriggers = [NSMutableArray new];
            for (Trigger* trigger in [syncer triggers]) {
                Client* client = [trigger client];
                if (client) {
                    NSMutableDictionary* clientDic = nil;
                    for (NSMutableDictionary* dic in clientsAndTriggers) {
                        if ([dic objectForKey:constKeyClient] == client) {
                            clientDic = dic;
                        }
                    }
                    if (!clientDic) {
                        clientDic = [NSMutableDictionary new];
                        [clientsAndTriggers addObject:clientDic];
                        [clientDic release];
                        [clientDic setObject:client
                                      forKey:constKeyClient];
                        NSMutableSet* triggers = [NSMutableSet new];
                        [clientDic setObject:triggers
                                      forKey:constKeyTriggers];
                        [triggers release];
                    }
                    [[clientDic objectForKey:constKeyTriggers] addObject:trigger];
                }
            }

            for (NSDictionary* dic in clientsAndTriggers) {
                Client* client = [dic objectForKey:constKeyClient];

                // Determine what triggers we now need
                BOOL needsBrowserQuitTrigger = NO;
                BOOL needsSawChangeTrigger = NO;
                OwnerAppObservability observability = [[client extoreClass] ownerAppObservability] ;
                if ((observability & OwnerAppObservabilityOnQuit) > 0) {
                    needsBrowserQuitTrigger = YES;
                }
                if ([Extore isLiveObservability:observability]) {
                    needsSawChangeTrigger = YES;
                }

                // Sort existing triggers
                Trigger* existingBrowserQuitTrigger = nil;
                Trigger* existingSawChangeTrigger = nil;
                for (Trigger* trigger in [dic objectForKey:constKeyTriggers]) {
                    if (trigger.triggerTypeValue == BkmxTriggerBrowserQuit) {
                        existingBrowserQuitTrigger = trigger;
                    }
                    else if (trigger.triggerTypeValue == BkmxTriggerSawChange) {
                        existingSawChangeTrigger = trigger;
                    }
                }

                /* Add, remove and/or change type(s) of trigger(s) in one of
                 the 16 possible cases */
                if (!needsBrowserQuitTrigger && !needsSawChangeTrigger) {
                    // We need no triggers at all
                    if (!existingBrowserQuitTrigger && !existingSawChangeTrigger) {
                        // We have no triggers at all.
                    }
                    else if (!existingBrowserQuitTrigger && existingSawChangeTrigger) {
                        // We have only a SawChange trigger.
                        [syncer deleteTrigger:existingSawChangeTrigger] ;
                        didChangeSomething = YES;
                    }
                    else if (existingBrowserQuitTrigger && !existingSawChangeTrigger) {
                        // We have only a BrowserQuit trigger.
                        [syncer deleteTrigger:existingBrowserQuitTrigger] ;
                        didChangeSomething = YES;
                    }
                    else /* (existingBrowserQuitTrigger && existingSawChangeTrigger) */ {
                        // We have both triggers.
                        [syncer deleteTrigger:existingBrowserQuitTrigger] ;
                        [syncer deleteTrigger:existingSawChangeTrigger] ;
                        didChangeSomething = YES;
                    }
                }
                else if (!needsBrowserQuitTrigger && needsSawChangeTrigger) {
                    // We need only a SawChange trigger
                    if (!existingBrowserQuitTrigger && !existingSawChangeTrigger) {
                        // We have no triggers at all.
                        Trigger* trigger = [syncer freshTriggerAtIndex:NSNotFound] ;
                        [trigger setTriggerTypeValue:BkmxTriggerSawChange] ;
                        [trigger setClient:client] ;
                        didChangeSomething = YES;
                    }
                    else if (!existingBrowserQuitTrigger && existingSawChangeTrigger) {
                        // We have only a SawChange trigger.
                    }
                    else if (existingBrowserQuitTrigger && !existingSawChangeTrigger) {
                        // We have only a BrowserQuit trigger.
                        [existingBrowserQuitTrigger setTriggerTypeValue:BkmxTriggerSawChange] ;
                        didChangeSomething = YES;
                    }
                    else /* (existingBrowserQuitTrigger && existingSawChangeTrigger) */ {
                        // We have both triggers.
                        [syncer deleteTrigger:existingBrowserQuitTrigger] ;
                        didChangeSomething = YES;
                    }
                }
                else if (needsBrowserQuitTrigger && !needsSawChangeTrigger) {
                    // We need only a BrowserQuit trigger
                    if (!existingBrowserQuitTrigger && !existingSawChangeTrigger) {
                        // We have no triggers at all.
                        Trigger* trigger = [syncer freshTriggerAtIndex:NSNotFound] ;
                        [trigger setTriggerTypeValue:BkmxTriggerBrowserQuit] ;
                        [trigger setClient:client] ;
                        didChangeSomething = YES;
                    }
                    else if (!existingBrowserQuitTrigger && existingSawChangeTrigger) {
                        // We have only a SawChange trigger.
                        [existingSawChangeTrigger setTriggerTypeValue:BkmxTriggerBrowserQuit] ;
                        didChangeSomething = YES;
                    }
                    else if (existingBrowserQuitTrigger && !existingSawChangeTrigger) {
                        // We have only a BrowserQuit trigger.
                    }
                    else /* (existingBrowserQuitTrigger && existingSawChangeTrigger) */ {
                        // We have both triggers.
                        [syncer deleteTrigger:existingSawChangeTrigger] ;
                        didChangeSomething = YES;
                    }
                }
                else if (needsBrowserQuitTrigger && needsSawChangeTrigger) {
                    // We need both triggers (Firefox during years ~2016~2018)
                    if (!existingBrowserQuitTrigger && !existingSawChangeTrigger) {
                        // We have no triggers at all.
                        Trigger* trigger;
                        trigger = [syncer freshTriggerAtIndex:NSNotFound] ;
                        [trigger setTriggerTypeValue:BkmxTriggerSawChange] ;
                        [trigger setClient:client] ;
                        trigger = [syncer freshTriggerAtIndex:NSNotFound] ;
                        [trigger setTriggerTypeValue:BkmxTriggerBrowserQuit] ;
                        [trigger setClient:client] ;
                        didChangeSomething = YES;
                    }
                    else if (!existingBrowserQuitTrigger && existingSawChangeTrigger) {
                        // We have only a SawChange trigger.
                        Trigger* trigger = [syncer freshTriggerAtIndex:NSNotFound] ;
                        [trigger setTriggerTypeValue:BkmxTriggerBrowserQuit] ;
                        [trigger setClient:client] ;
                        didChangeSomething = YES;
                    }
                    else if (existingBrowserQuitTrigger && !existingSawChangeTrigger) {
                        // We have only a BrowserQuit trigger.
                        Trigger* trigger = [syncer freshTriggerAtIndex:NSNotFound] ;
                        [trigger setTriggerTypeValue:BkmxTriggerSawChange] ;
                        [trigger setClient:client] ;
                        didChangeSomething = YES;
                    }
                    else /* (existingBrowserQuitTrigger && existingSawChangeTrigger) */ {
                        // We have both triggers.
                    }
                }
            }
            
            [clientsAndTriggers release];
        }
    }

    return didChangeSomething;
}

- (void)macsterBusinessNote:(NSNotification*)note {
    if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        if (self.syncers.count > 0) {
            /* For BkmxAgent, this method is only needed if syncers are
             being removed (due to Sync Fight). */
            return;
        }
    }

	if ([[note name] isEqualToString:constNoteBkmxClientDidChange]) {
		[[[self bkmxDoc] shig] setUserIsFussingWithClients:YES] ;
		if ([[[note userInfo] objectForKey:constKeySeverity] integerValue] > 1) {
			Client* client = [[note userInfo] objectForKey:constKeyClient] ;
			NSSet* clients ;
			if (client) {
				clients = [NSSet setWithObject:client] ;
			}
			else {
				// No client in the notification means "all clients".
				clients = [self clients] ;
			}
			for (Client* client in clients) {
                /* Client may be unavailable if it was a temporary client. */
                if ([client isAvailable]) {
                    [[self bkmxDoc] forgetLastPreImportedHashForClient:client] ;
                    [[self bkmxDoc] forgetLastPreExportedHashForClient:client] ;
                }
			}
		}		
	}

    [self fixTriggersIfSimpleSyncers];

	// The following was added in BookMacster version 1.3.6.
	// See the long comment in -syncSyncersFromSyncingConfig.
    [self syncSyncersFromSyncingConfig] ;
	
	// Business logic to make sure that triggerTypes of all
	// Triggers and methods of all Commands are still
	// applicable, for each syncer.
	NSSet* syncersCopy = [[self syncers] copy] ;
	for (Syncer* syncer in syncersCopy) {
		NSSet* triggersCopy = [[syncer triggers] copy] ;
		for (Trigger* trigger in triggersCopy) {
			// Added in BookMacster 1.9.9, in case someone sets an identical
			// trigger.  This is easy to do in Advanced Syncers tab.
			for (Trigger* otherTrigger in triggersCopy) {
				if (otherTrigger == trigger) {
					continue ;
				}
				if ([otherTrigger doesSameAsTrigger:trigger]) {
					// I was thinking of simply setting isBadTrigger so that
					// one of them would be removed, but that would probably
					// result in some situations where you could not add a
					// trigger, if the default trigger were identical to an
					// existing trigger.  After playing with it for a while,
					// I realized that it would take several hours to write
					// code that would cover all the cases, far more time
					// than this issue is worth.  So,
                    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [trigger shortDescription], @"Trigger",
                                              [otherTrigger shortDescription], @"Other Trigger",
                                              [syncer shortDescription], @"Syncers",
                                              nil] ;
					NSNotification* note = [NSNotification notificationWithName:constNoteDuplicateTrigger
																		 object:self
                                                                       userInfo:userInfo] ;
					[[SSYLazyNotificationCenter defaultCenter] enqueueNotification:note
																			 delay:1.0] ;
					
				}
			}
			
			NSString* badTriggerReason = nil ;
			NSArray* availableTriggerTypes = [syncer availableTriggerTypes] ;
            NSNumber* triggerType = [trigger triggerType] ;
			if ([availableTriggerTypes indexOfObject:triggerType] == NSNotFound) {
				// Possibly triggerType is BkmxTriggerBookmarksChanged and a
				// cooperative client is no longer present.
				badTriggerReason = [NSString stringWithFormat:@"Unsupported"] ;
			}
			else {
				if (
					([trigger triggerTypeValue] == BkmxTriggerSawChange)
					||
					([trigger triggerTypeValue] == BkmxTriggerBrowserQuit)
					) {
					Client* client = [trigger client] ;
					if (!client) {
						badTriggerReason = [NSString stringWithFormat:@"No client to watch for"] ;
					}
					else if ([[[client importer] isActive] boolValue] == NO) {
						badTriggerReason = [NSString stringWithFormat:@"Inactive client for"] ;
					}
				}
			}				
			
			if (badTriggerReason) {
                badTriggerReason = [badTriggerReason stringByAppendingFormat:
                                    @" trigger type %@",
                                    [triggerType triggerTypeDisplayName]] ;
				// Remove the trigger.
				[syncer deleteTrigger:trigger] ;

				// And it needs to be an Advanced syncer.
				// Probably the next line is superfluous because if this was a Simple Syncer,
				// it would have been made good during -syncSyncersFromSyncingConfig
				// which was invoked above.  I think.  Not 100% sure.
				[self setSyncerConfig:[NSNumber numberWithLongLong:constBkmxSyncerConfigIsAdvanced]] ;
                
                if (![self badTriggerSayer]) {
                    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.0
                                                                      target:self
                                                                    selector:@selector(sayBadTriggerTimer:)
                                                                    userInfo:badTriggerReason
                                                                     repeats:NO] ;
                    [self setBadTriggerSayer:timer] ;
                }
			}
		}
        [triggersCopy release] ;
		
		for (Command* command in [syncer commands]) {
			// If a Syncer no longer has a client-based trigger, check all of
			// its Commands and change any command operating on the single
			// triggering client to the equivalent command operating on 
			// all clients
			if (![syncer hasAClientBasedTrigger]) {
				if ([[command method] isEqualToString:constMethodPlaceholderImport1]) {
					[command setMethod:constMethodPlaceholderImportAll] ;
				}
				else if ([[command method] isEqualToString:constMethodPlaceholderExport1]) {
					[command setMethod:constMethodPlaceholderExportAll] ;
				}
			}
			
			// Fix any other un-availableCommandMethods by setting
			// them to an arbitrary but available default method.
			NSArray* availableCommandMethods = [syncer availableCommandMethods] ;
			if ([availableCommandMethods indexOfObject:[command method]] == NSNotFound) {
				[command setMethod:[availableCommandMethods firstObjectSafely]] ;
			}
		}
	}
    [syncersCopy release] ;
	
    NSError* error = nil ;
    [[self bkmxDoc] realizeSyncersToWatchesError_p:&error] ;
    [SSYAlert alertError:error] ;
    
    NSMutableSet* docUuidsWithWatches = [NSMutableSet new];

    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
        NSSet <Watch*>* watchesThisApp = [[NSUserDefaults standardUserDefaults] watchesThisApp];
        for (Watch* watch in watchesThisApp) {
            [docUuidsWithWatches addObject:watch.docUuid];
        }
        if (docUuidsWithWatches.count > 1) {
            [(BkmxAppDel*)[NSApp delegate] warnMultiDocsInWatches:watchesThisApp] ;
        }
    } else {
        /* Fail-safe mechanism added in BkmkMgrs 2.10.4 after user Matt P.
         and possibly Ken W. had trouble which turned out to be caused by
         a Synkmark~.bmco document which was still syncing, in addition to
         the Synkmark.bmco document.  In this case, we don't care what change
         has caused this method to run, nor about the total number of watches.
         If we are syncing, any watch, unless it is for the current app
         (Synkmark or Smarky) *and* for the current document should be
         removed.   We do it immediately, without question or warning. */
        if ([note.object isKindOfClass:[Macster class]]) {
            if (((Macster*)(note.object)).syncerConfig.integerValue > 0) {
                [[NSUserDefaults standardUserDefaults] removeAllSyncingExceptDocUuid:self.bkmxDoc.uuid];
            }
        }
    }

    [docUuidsWithWatches release];

    [self updateAllClientsCompositeImportSettingsHashesInUserDefaults];
}

- (void)updateAllClientsCompositeImportSettingsHashesInUserDefaults {
    for (Client* client in self.clients) {
        uint32_t hash = (client.importer.settingsHash ^ self.importSettingsHash);
        [[NSUserDefaults standardUserDefaults] setCompositeImportSettingsHash:hash
                                                                    clientoid:client.clientoid];
    }
}

- (NSString*)syncedClientsList {
    return [[self clientsWithIxportEitherActive] listValuesForKey:@"displayName"
                                                      conjunction:[NSString localize:@"andEndList"]
                                                       truncateTo:0] ;
}

- (void)warnSyncingAffected {
    m_delayedExportWarningIsPending = NO ;
    [FullDiskAccessor check];
    
    NSString* sortAnd ;
    BOOL doSort ;
    if ([self syncerConfigSort]) {
        sortAnd = @"sort and " ;
        doSort = YES ;
    }
    else {
        sortAnd = @"" ;
        doSort = NO ;
    }

    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
        NSMutableString* msg = [NSMutableString stringWithFormat:
                                @"To begin syncing, we must ensure that the Content herein exactly matches what you have in %@.\n\n",
                                [self syncedClientsList]];
        [msg appendFormat:
         @"Click 'Export' to %@push this document's Content into %@, replacing whatever bookmarks they have now.",
         sortAnd,
         [self syncedClientsList]] ;
        [msg appendString:@"  You should do this if you have already inspected and approved of this document's Content.\n\n"] ;
        [msg appendString:@"Click 'Pause' to temporarily deactivate your Syncers."] ;
        [msg appendString:@"  You should do this if you need to File > Import from some browser(s) to get new items and/or do more reorganization first.  We'll remind you to resume syncing later.\n\n"] ;
        [msg appendString:@"Click 'It's OK' to skip exporting."] ;
        [msg appendString:@"  Do this only if you are sure that neither the Clients' nor this document's Content has changed since the last Export."] ;
        NSString* button1Title = [[BkmxBasis sharedBasis] labelExport] ;
        NSString* button2Title = @"Pause" ;
        NSString* button3Title = @"It's OK" ;
        SSYAlert* alert = [SSYAlert alert] ;
        [alert setSmallText:msg] ;
        [alert setIconStyle:SSYAlertIconInformational] ;
        [alert setButton1Title:button1Title] ;
        [alert setButton2Title:button2Title] ;
        [alert setButton3Title:button3Title] ;
        BOOL yes = YES ;
        
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithDouble:30.0], constKeyUninhibitSecondsAfterDone,
                                     [NSNumber numberWithBool:YES], constKeyPauseSyncersIfUserCancelsExport,
                                     nil] ;
        // See Note InhibNewSyncers below
        
        NSArray* doneInvocations = [NSArray arrayWithObjects:
                                    // "[Sort and] Export".
                                    [NSInvocation invocationWithTarget:[self bkmxDoc]
                                                              selector:@selector(doSort:thenExportIfPermittedWithInfo:)
                                                       retainArguments:YES
                                                     argumentAddresses:&doSort, &info],
                                    // "Pause"
                                    [NSInvocation invocationWithTarget:self
                                                              selector:@selector(pauseSyncers:alert:)
                                                       retainArguments:YES
                                                     argumentAddresses:&yes, &alert],
                                    // "It's OK".  Do nothing.
                                    [NSNull null],
                                    nil] ;
        [[self bkmxDoc] runModalSheetAlert:alert
                                resizeable:NO
                                 iconStyle:SSYAlertIconInformational
                             modalDelegate:[SSYSheetEnder class]
                            didEndSelector:@selector(didEndGenericSheet:returnCode:retainedInvocations:)
                               contextInfo:[doneInvocations retain]] ;
    }
    else {
        // A simpler dialog for Smarky and Synkmark
        
        NSString* button1Title = [[BkmxBasis sharedBasis] labelExport] ;
        NSString* button2Title = @"Pause Syncing" ;
        NSString* safariOr;
        if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSmarky) {
            safariOr = @"Safari and/or other ";
        } else {
            safariOr = @"";
        }
        NSString* msg = [NSString stringWithFormat:
                         @"To begin syncing, we must ensure that the %@ (bookmarks and folders) herein exactly matches what you have in %@.\n\n"
                         @"Click '%@' to %@export the %@ in this window into %@.  WARNING: This will *replace* any existing bookmarks, deleting any which are not in this %@.\n\n"
                         @"If this %@ does not contain exactly the bookmarks you desire, instead click '%@'.  You may then wish to import from %@browser(s) if they have what you want.",

                         [[BkmxBasis sharedBasis] labelContent],
                         [self syncedClientsList],

                         button1Title,
                         sortAnd,
                         [[BkmxBasis sharedBasis] labelContent],
                         [self syncedClientsList],
                         [[BkmxBasis sharedBasis] labelContent],

                         [[BkmxBasis sharedBasis] labelContent],
                         button2Title,
                         safariOr];
        SSYAlert* alert = [SSYAlert alert] ;
        [alert setSmallText:msg] ;
        [alert setIconStyle:SSYAlertIconInformational] ;
        [alert setButton1Title:button1Title] ;
        [alert setButton2Title:button2Title] ;
        BOOL yes = YES ;
        
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithDouble:30.0], constKeyUninhibitSecondsAfterDone,
                                     [NSNumber numberWithBool:YES], constKeyPauseSyncersIfUserCancelsExport,
                                     nil] ;
        // See Note InhibNewSyncers below
        
        NSArray* doneInvocations = [NSArray arrayWithObjects:
                                    // "[Sort and] Export".
                                    [NSInvocation invocationWithTarget:[self bkmxDoc]
                                                              selector:@selector(doSort:thenExportIfPermittedWithInfo:)
                                                       retainArguments:YES
                                                     argumentAddresses:&doSort, &info],
                                    // "Cancel".
                                    // Because we have already started
                                    // syncing, we must backtrack and Pause.
                                    [NSInvocation invocationWithTarget:self
                                                              selector:@selector(pauseSyncers:alert:)
                                                       retainArguments:YES
                                                     argumentAddresses:&yes, &alert],
                                    nil] ;
        [[self bkmxDoc] runModalSheetAlert:alert
                                resizeable:NO
                                 iconStyle:SSYAlertIconInformational
                             modalDelegate:[SSYSheetEnder class]
                            didEndSelector:@selector(didEndGenericSheet:returnCode:retainedInvocations:)
                               contextInfo:[doneInvocations retain]] ;
        
    }
}

#define JUST_LONG_ENOUGH_FOR_AVERAGE_USER_TO_NOTICE_THAT_CHECKBOXES_WERE_SWITCHED_ON 1.5

- (void)warnSyncingAffectedAfterDelay {
    if (!m_delayedExportWarningIsPending) {
        m_delayedExportWarningIsPending = YES ;
        [self performSelector:@selector(warnSyncingAffected)
                   withObject:nil
                   afterDelay:JUST_LONG_ENOUGH_FOR_AVERAGE_USER_TO_NOTICE_THAT_CHECKBOXES_WERE_SWITCHED_ON] ;
    }
}

- (void)macsterTouchNote:(NSNotification*)note {
	// This section was added in BookMacster 1.11
	
	// See if turning off Auto Import is necessary, and if so, warn user and do it.
	if (
		[[note name] isEqualToString:constNoteBkmxSyncerDidChange]
		||
		[[note name] isEqualToString:constNoteBkmxMacsterDidChange]
		) {
		if ([[[note userInfo] objectForKey:constKeySeverity] integerValue] > 4) {
			if ([self aSyncerWouldIxportIfActivatedOrResumedDoQualifyExport:NO]) {
				if ([[self autoImport] boolValue]) {
					[self setAutoImport:nil] ;
					[self saveLater] ;
					// The following alert is shown in two situations, that I can think of…
					// •  If user switches on the Auto Import box while at least one syncer could import if activated or resumed
					//       Better message: @"Auto Import is not a good idea because you also have an importing Syncer."
					// •  If Auto Import is active and user adds at least one syncer could import if activated or resumed
					//       Better message: @"Auto Import (upon document opening) has been disabled because you've got an importing Syncer now."
					NSString* msg = @"Auto Import has been disabled, because you have an importing Syncer." ;
					SSYAlert* alert = [SSYAlert alert] ;
					[alert setSmallText:msg] ;
					[alert setIconStyle:SSYAlertIconInformational] ;
					[alert setButton1Title:[[BkmxBasis sharedBasis] labelOk]] ;
					[[self bkmxDoc] runModalSheetAlert:alert
                                            resizeable:NO
                                             iconStyle:SSYAlertIconInformational
                                         modalDelegate:nil
                                        didEndSelector:NULL
                                           contextInfo:NULL] ;
				}
			}
		}
	}
	
	// Maybe show the "Syncing affected, should export" warning.
    if ([[note name] isEqualToString:constNoteBkmxClientDidChange]) {
        if ([[[note userInfo] objectForKey:constKeySeverity] integerValue] > 4) {
            Client* affectedClient = [[note userInfo] objectForKey:constKeyClient] ;
            if (![affectedClient willSelfDestruct]) {
                if ([self isPoisedToSync]) {
                   [self warnSyncingAffectedAfterDelay] ;
                }
            }
        }
    }

	// Do other business logic
	[self macsterBusinessNote:note] ;
}

/*
 * Note InhibNewSyncers
 
 If user clicks "Export", the export will be a result of just activating Syncers.
 Because the user is in BookMacster, we consider any triggers such as those that always
 occur after 10 secs after exporting to Chrome and Firefox if they're running to be
 extraneous, and because those are annoying, and because we want to make a good
 first impression, we don't want retrigger/resyncs to occur.  To prevent them,
 we have set the key constKeyUninhibitSecondsAfterDone into info, with a value of
 30 seconds.  This is: 15 seconds for the trigger delay, 10 seconds for it to
 trigger, 5 seconds margin.  (Those numbers are, of course, crap, but we
 need to do something that looks like science here!)
 
 That key will have the following effects:
 • in -[BkmxDoc exportWithAlert:info:], its mere nonnilness will set
 the General Uninhibit for 20 minutes into the future
 • in -[BkmxDoc exportPerInfo:], its nonnilness will cause an Export-Grande
 operation group to be queued, and its value will be transferred into the
 info for this Export-Grande group.
 • in -[SSYOperation (Operation_Common) uninhibit_unsafe] the General
 Uninhibit will be accelerated from 10 minutes minus a few seconds into the
 future TO: 20 seconds into the future.  The 20 seconds is to allow 10
 seconds for the .sawChange file to be touched by Chrome or Firefox extensions.
 
 Another way to solve this problem would be to to pause syncers, then resume them
 20 seconds after the export was done.  But that would be much more complicated
 and trouble-prone.  In particular, what if the user wants to quit immediately
 after the export is done?
 */


- (void)alertDupeTriggerNote:(NSNotification*)note {
	SSYAlert* alert = [SSYAlert alert] ;
	[alert setSmallText:[NSString stringWithFormat:
                         @"Duplicate trigger(s).  Please change to avoid trouble.\n\n%@",
                         [note userInfo]]] ;
	[[self bkmxDoc] runModalSheetAlert:alert
                            resizeable:NO
                             iconStyle:SSYAlertIconCritical
                         modalDelegate:nil
                        didEndSelector:NULL
                           contextInfo:NULL] ;
}

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void *)context {
    if ([keyPath isEqualToString:constKeySortShoeboxDuringSyncs]) {
        BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:constKeySortShoeboxDuringSyncs] ;
        [self setSyncerConfigSort:value] ;
    }
}

- (void)initializeObservers {
    if ([self.managedObjectContext concurrencyType] == NSMainQueueConcurrencyType) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(macsterTouchNote:)
                                                     name:constNoteBkmxSyncerDidChange
                                                   object:self] ;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(macsterTouchNote:)
                                                     name:constNoteBkmxClientDidChange
                                                   object:self] ;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(macsterTouchNote:)
                                                     name:constNoteBkmxMacsterDidChange
                                                   object:self] ;
        [[SSYLazyNotificationCenter defaultCenter] addObserver:self
                                                      selector:@selector(alertDupeTriggerNote:)
                                                          name:constNoteDuplicateTrigger] ;
        [[NSUserDefaults standardUserDefaults] addObserver:self
                                                forKeyPath:constKeySortShoeboxDuringSyncs
                                                   options:0
                                                   context:NULL] ;
    }
}

- (BOOL)ensureAutoSyncersExistDoAlert:(BOOL)doAlert {
    BkmxWhich1App iAm = [[BkmxBasis sharedBasis] iAm] ;
    BOOL didDo = NO ;

    if ((iAm == BkmxWhich1AppSynkmark) || (iAm == BkmxWhich1AppSmarky)) {
        if (
            ![self syncerConfigImportChanges]
            ||
            ![self syncerConfigExportToClients]
            ||
            ![self syncerConfigExportCloud]
            ||
            ![self syncerConfigExportLanding]
            ) {
            // Create default Simple Syncers, paused
            [self pauseSyncers] ;
            [self setSyncerConfigFullSync] ;
            didDo = YES ;
        }
    }
    
    if (didDo && doAlert && ![SSYAppInfo isNewUser]) {
        [[self bkmxDoc] alertSyncingStillPaused:[self activeClientsForSelector:NULL
                                                              onlyIfVulnerable:NO]] ;
    }
    
    return didDo ;
}

- (void)initializeSyncerPausedIvars {
	// Simple Syncers can never be paused upon opening, because syncerPausedConfig
	// is not persisted.  If document is closed while Simple Syncers are paused,
	// they are gone.
	// However, Advanced Syncers can be paused initially.
	for (Syncer* syncer in [self syncers]) {
		if ([syncer doesExport]) {
			if (![syncer isActive]) {
				[self setSyncersPaused:YES] ;
				[self setSyncerPausedConfig:constBkmxSyncerConfigIsAdvanced] ;
			}
		}
	}
}

/*
 @brief    Removes any orphaned or inappropriate clients
 @details  This method must be run after the receiver has been linked to its
 BkmxDoc, and in Smarky, after the document controller's currentDocument
 is opened.  To do this, run via performSelector:withObject:afterDelay:.
 To keep this safe, in willTurnIntoFault, we cancel any such invocations
 with [NSRunLoop cancelPerformSelectorsWithTarget:].  Such a delay will also
 prevent this method from running in Macsters opened under the hood such as by
 "Stop all Syncing now".
 */
- (void)removeAnyBadClients {
    if ([(BkmxAppDel*)[NSApp delegate] isUninstalling]) {
        return ;
    }

    /*
     Because there is no user interface to macsters' clients in Smarky, it is
     possible that if a crash occurs during an "Export to only" operation, the
     temporary client created may be left permanently in the persistent store
     (Settings-XXX.sqlite).  I'm not sure how it happens, but it happened a lot
     during testing.  So, at this point, we test for any client in Smarky which
     is not Safari or not of thisUser media.  Furthermore, the bad clients are
     orphaned (not related to this or any Macster instance).  So as you can see
     I fetch them with a mojo instead of using [self clients].
     
     And then after I did that I thought hey why not look for orphaned clients
     in the other apps too, because these are easily recognized by their nil
     macster.
     */
    SSYMojo* mojo = [[SSYMojo alloc] initWithManagedObjectContext:[self managedObjectContext]
                                                       entityName:constEntityNameClient] ;
    NSArray* clients = [mojo allObjects] ;
    for (Client* client in clients) {
        NSInteger badness = 0 ;
        if ([client macster] != self) {
            badness = 1 ;
        } ;
        if (badness == 0) {
            if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSmarky) {
                BkmxDoc* frontmostDocument = [[NSDocumentController sharedDocumentController] frontmostDocument] ;
                Macster* smarkyMacster = [frontmostDocument macster] ;
                if (smarkyMacster == self) {
                    if (
                        ![[client exformat] isEqualToString:constExformatSafari]
                        ||
                        ![[client extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]
                        ) {
                        badness = 2 ;
                    }
                }
            }
        }
        if (badness != 0) {
            NSLog(@"Warning 629-0594 Removing badness %ld %@ for %@", (long)badness, [client shortDescription], [self shortDescription]) ;
            [[self managedObjectContext] deleteObject:client] ;
            [self saveLater] ;
        }
    }
    [mojo release] ;
}

- (void)ensureAutoSyncersExistAfterDelay {
    BkmxWhich1App iAm = [[BkmxBasis sharedBasis] iAm] ;
    // Markster has no auto syncers.
    if ((iAm == BkmxWhich1AppSynkmark) || (iAm == BkmxWhich1AppSmarky)) {
        BOOL yes = YES ;
        /* This must be done with a delay because the document window
         does not exist yet.  Also, it seems to be an implementation
         detail that, surprisingly, this method runs *after*
         -[Macster setBkmxDoc:] is invoked in -readFromURL:ofType:error:.
         If that were to flip the other way someday, -ensureAutoSyncersExist
         would fail due to nil bkmxDoc.  */
        NSInvocation* invocation = [NSInvocation invocationWithTarget:self
                                                             selector:@selector(ensureAutoSyncersExistDoAlert:)
                                                      retainArguments:YES
                                                    argumentAddresses:&yes] ;
        [invocation performSelector:@selector(invoke)
                         withObject:nil
                         afterDelay:0.2] ;
    }
}

- (void)awakeFromFetch {
	[super awakeFromFetch] ;
	
	[self initializeObservers] ;
    
	// The following is required in case the preference
    // constKeySortShoeboxDuringSyncs is now set, and syncing is un-paused
    // during the current running of the app.
    if (![[[BkmxBasis sharedBasis] mainAppNameUnlocalized] isEqualToString:constAppNameBookMacster]) {
        // Major bug fixed in BookMacster 1.22.4.  The following was not using
        // the 'mainApp' version, so got wrong answer in shoebox Workers.
        BOOL doSortValue = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeySortShoeboxDuringSyncs] ;
        [self setSyncerConfigSort:doSortValue] ;
    }

    if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
        [self ensureAutoSyncersExistAfterDelay] ;
        
        [self performSelector:@selector(removeAnyBadClients)
                   withObject:nil
                   afterDelay:0.4] ;
    }
    else {
        // We are in BkmxAgent.  Obviously, the Syncer exists otherwise the BkmxAgent
        // would not be running.
    }
    
	[self initializeSyncerPausedIvars] ;

    // Defensive programming:
    [self updateAllClientsCompositeImportSettingsHashesInUserDefaults];
}

- (void)awakeFromInsert {
	[super awakeFromInsert] ;
	
	[self initializeObservers] ;
}

- (NSString*)shortDescription {
	return [NSString stringWithFormat:
			@"<%@ %p : docUuid=%@ nClnts=%ld, nAgts=%ld, syncerConfig=%0qx>",
			[self className],
			self,
			[self docUuid],
			(long)[[self clients] count],
			(long)[[self syncers] count],
			[self syncerConfigValue]] ;
}


- (NSString*)truncatedListOrPlaceholderForClients:(NSArray*)clients
									maxCharacters:(NSUInteger)maxCharacters {
	NSString* answer ;
	if ([clients count] > 0) {
		NSString* conjunction = (maxCharacters > 128) ? [NSString localize:@"andEndList"] : nil ;
		answer =[clients listValuesForKey:@"displayName"
							  conjunction:conjunction
							   truncateTo:0] ;
		answer = [answer stringByTruncatingMiddleToLength:maxCharacters
											   wholeWords:YES] ;
	}
	else {
		answer = [NSString stringWithFormat:
				  @"[%@]",
				  [NSString localizeFormat:@"no%0",
				   [[BkmxBasis sharedBasis] labelClients]]] ;
	}
	
	return answer ;
}

/*
 @brief    Returns any of the receiver's clients whose importer *or* exporter
 are active
 @details  The two parameters may be be used to narrow the results with
 additional filtering.
 @param    selector  If this value is @selector(importer) only clients whose
 importer is active will appear in the result.  If this value is
 @selector(importer) only clients whose exporter is active will appear in the
 result.  If this value is NULL, no such filtering is done.
 @param    onlyIfVulnerable  If YES, and if 'selector' is @selector(exporter) or
 NULL, only clients whose exporter's deleteUnmatched property is YES will appear
 in the result.  If NO, no such filtering is done.
 */
- (NSArray*)activeClientsForSelector:(SEL)selector
                    onlyIfVulnerable:(BOOL)onlyIfVulnerable {
	NSMutableArray* clients = [[NSMutableArray alloc] init] ;
	for (Client* client in [self clientsOrdered]) {
		Ixporter* ixporter ;
		if (selector) {
			ixporter = [client performSelector:selector] ;
			if ([[ixporter isActive] boolValue]) {
                if (
                    !onlyIfVulnerable
                    ||
                    (selector == @selector(importer))
                    ||
                    [[[client exporter] deleteUnmatched] boolValue]
                    ) {
                    [clients addObject:client] ;
                }
			}
		}
		else {
			ixporter = [client importer] ;
			if ([[ixporter isActive] boolValue]) {
				[clients addObject:client] ;
			}
			else {
				ixporter = [client exporter] ;
				if ([[ixporter isActive] boolValue]) {
                    if (
                        !onlyIfVulnerable
                        ||
                        [[[client exporter] deleteUnmatched] boolValue]
                        ) {
                        [clients addObject:client] ;
                    }
				}
			}
		}
	}
    
    NSArray* answer = [[clients copy] autorelease] ;
    [clients release] ;

    return answer ;
}

- (NSArray*)activeClients {
    return [self activeClientsForSelector:NULL
                         onlyIfVulnerable:NO] ;
}


- (NSString*)clientListForSelector:(SEL)selector
                  onlyIfVulnerable:(BOOL)onlyIfVulnerable
					 maxCharacters:(NSUInteger)maxCharacters {
	
	return [self truncatedListOrPlaceholderForClients:[self activeClientsForSelector:selector
                                                                    onlyIfVulnerable:onlyIfVulnerable]
                                        maxCharacters:maxCharacters] ;
}

- (NSString*)readableImportsList {
	return [self clientListForSelector:@selector(importer)
                      onlyIfVulnerable:NO
						 maxCharacters:48] ;
}

- (NSString*)readableExportsListOnlyIfVulnerable:(BOOL)onlyIfVulnerable
                                   maxCharacters:(NSUInteger)maxCharacters {
	return [self clientListForSelector:@selector(exporter)
                      onlyIfVulnerable:onlyIfVulnerable
						 maxCharacters:maxCharacters] ;
}

- (ClientChoice*)nextLikelyClientChoice {
	// Available client choices, sorted by popularity,
	NSArray* availableClientChoices = [self availableClientChoicesAlwaysIncludeChooseFile:YES
                                                                           includeWebApps:YES
                                                                      includeNonClientable:NO] ;
    // In the above, we could pass AlwaysIncludeChooseFile:NO to match what we
    // do in -[ClientListView menuNeedsUpdate:], but for defensive programming
    // we pass YES, because, below, we knock out choices that don't have
    // clientoids anyhow.
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self"
																   ascending:NO
																	selector:@selector(comparePopularity:)] ;
	availableClientChoices = [availableClientChoices sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] ;
	[sortDescriptor release] ;
	
	// Choose first availableClientChoice that has a clientoid
	// and is not already in use.
	ClientChoice* choice = nil ;
	for (ClientChoice* candidateChoice in availableClientChoices) {
		// Exclude those that have nil clients, which will be
		// the WebAppNew/Other, or LooseFile		
		Clientoid* candidateClientoid = [candidateChoice clientoid] ;
		if (candidateClientoid) {
			// Exclude those already in use
			BOOL alreadyInUse = NO ;
			for (Client* clientAlreadyInUse in [self clients]) {
				if ([[clientAlreadyInUse clientoid] isEqual:candidateClientoid]) {
					alreadyInUse = YES ;
					break ;
				}
			}	
			if (!alreadyInUse) {
				choice = candidateChoice ;
				break ;
			}
		}
	}
    
    /*
     If none was found, add a placeholder which will show as
     "Click to Choose…" in the popup menu
     Added in BookMacster 1.15.
     But this is only needed in BookMacster, wherein the web app New/Other,
     Choose File (Advanced) and Other Macintosh Account items are possible.
     */
    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
        if (!choice) {
            choice = [[[ClientChoice alloc] init] autorelease] ;
            [choice setClientoid:[Clientoid clientoidPlaceholder]] ;
        }
    }

	return choice ;
}

- (IBAction)insertNextLikelyClient:(id)sender {
	// if () added in BookMacster 5.1.4, moved in BookMacster 1.19
    ClientChoice* clientChoice = [self nextLikelyClientChoice] ;
	if (clientChoice) {
        Client* client = [self freshClientAtIndex:NSNotFound
                                        singleUse:NO] ;
        // We would like to pass YES for singleUse, but the user may often
        // accept the default client and not change anything else.  So, to
        // be conservative, we pass NO.
		[client setLikeClientChoice:clientChoice] ;
	}
}

- (void)deleteClient:(Client*)client {
	NSInteger index = [[client index] integerValue] ;
	[self removeClientsObject:client] ;
	// See Note 290293
	[[self managedObjectContext] deleteObject:client] ;
	
	[[self clientsOrdered] fixIndexesContiguousStartingAtIndex:index] ;
}

- (NSArray*)availableClientChoicesAlwaysIncludeChooseFile:(BOOL)alwaysIncludeChooseFile
                                           includeWebApps:(BOOL)includeWebApps
                                      includeNonClientable:(BOOL)includeNonClientable {
	// Iterate through available clientoids, wrap each in a ClientChoice,
	// and mark those which are in use
    NSArray* __block clientoidsInUse;
    [self.managedObjectContext performBlockAndWait:^{
            clientoidsInUse = [[self clientsOrdered] valueForKey:@"clientoid"];
            [clientoidsInUse retain];
    }];
    [clientoidsInUse autorelease];
	NSMutableArray* clientChoices = [[NSMutableArray alloc] init] ;
	NSArray* availableClientoids = [Clientoid allClientoidsForLocalAppsThisUserByPopularity:NO
                                                                       includeUninitialized:YES
                                                                        includeNonClientable:includeNonClientable] ;
	if (includeWebApps) {
		availableClientoids = [availableClientoids arrayByAddingObjectsFromArray:[Clientoid allClientoidsForWebAppsThisUser]] ;	
	}
	for (Clientoid* clientoid in availableClientoids) {
		ClientChoice* clientChoice = [ClientChoice clientChoiceWithClientoid:clientoid] ;
		if ([clientoidsInUse indexOfObject:clientoid] != NSNotFound) {
            [clientChoice setIsInUse:YES] ;
		}
		[clientChoices addObject:clientChoice] ;
	}
	
	// Add New/Other Account items for web apps
	if (includeWebApps) {
		for (NSString* exformat in [[BkmxBasis sharedBasis] supportedWebAppExformats]) {
			[clientChoices addObject:[ClientChoice clientChoiceNewOtherAccountForWebAppExformat:exformat]] ;
		}
	}	
	
	// Alphabetize to make look the menu look nice
	[clientChoices sortByStringValueForKey:@"displayName"] ;
	
	// Maybe Add a "Advanced" choices at the bottom
    if (alwaysIncludeChooseFile || ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster)) {
        [clientChoices addObject:[ClientChoice clientChoiceInvolvingLooseFile]] ;
    }
	
	NSArray* answer = [clientChoices copy] ;
	
	[clientChoices release] ;
	
	return [answer autorelease] ;
}

- (Trigger*)triggerWithUri:(NSString*)uri
                   error_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
	
	// The errors' localized descriptions should be short and sweet because
	// they are logged in the BookMacster log.

    if (ok) {
        if (!uri) {
            error = SSYMakeError(constBkmxErrorTriggerNoUri, @"No trigger URI") ;
            ok = NO ;
        }
    }

    Trigger* trigger = nil;
    if (ok) {
        trigger = (Trigger*)[[self managedObjectContext] objectWithUri:uri];
        if (!trigger) {
            error = SSYMakeError(constBkmxErrorTriggerNotFound, @"Trigger not found");
            ok = NO;
        }
    }

    if (ok) {
        if (![trigger isKindOfClass:[Trigger class]]) {
            error = SSYMakeError(constBkmxErrorTriggerWrongClass, @"Trigger wrongClass");
            ok = NO;
        }
    }

    if (ok) {
        if (![trigger isAvailable]) {
            error = SSYMakeError(constBkmxErrorTriggerUnavailable, @"Trigger unavailable");
            ok = NO;
        }
    }

#pragma unused (ok)

    if (error) {
		error = [error errorByAddingUserInfoObject:(uri ? uri : @"nil URI!")
											forKey:@"Looked for URI"] ;
		error = [error errorByAddingUserInfoObject:[self shortDescription]
											forKey:@"Macster"] ;
		NSMutableString* foundSyncersAndTheirTriggers = [NSMutableString string] ;
		for (Syncer* syncer in [self syncers]) {
			if ([foundSyncersAndTheirTriggers length] > 0) {
				[foundSyncersAndTheirTriggers appendString:@"\n"] ;
			}
			[foundSyncersAndTheirTriggers appendString:[syncer shortDescription]] ;
			for (Trigger* trigger in [syncer triggers]) {
				[foundSyncersAndTheirTriggers appendFormat:@"\n   %@", [trigger shortDescription]] ;
			}
		}
		error = [error errorByAddingUserInfoObject:foundSyncersAndTheirTriggers
											forKey:@"Found syncers and triggers string"] ;
		
	}
	
	if (error_p) {
		*error_p = error ;
	}
	
	return trigger ;
}

#if 0
#warning Compiling -[Macster logClientsLabel:], a debugging function
- (void)logClientsLabel:(NSString*)label {
	NSLog(@"^^^ Stuff At %@", label) ;
	SSYMojo* mojo = [[SSYMojo alloc] initWithManagedObjectContext:[self managedObjectContext]
													   entityName:constEntityNameClient] ;
	NSError* error = nil ;
	NSArray* clients = [mojo allObjectsError_p:&error] ;
	[SSYAlert alertError:error] ;
	NSLog(
		  @"    Fetched %ld clients; have %ld intlizrs, %ld extlizers",
		  (long)[clients count],
		  (long)[[self importers] count],
		  (long)[[self exporters] count]
		  ) ;
	
	// The following will cause a crash if a client has been deleted; i.e. -isDeleted = YES
	for (Client* client in clients) {
		NSLog(@"    %ld for %@ %hhd", (long)[[client ixporters] count], [client shortDescription], [client isDeleted]) ;
		for (Ixporter* ixporter in [client ixporters]) {
			NSLog(@"      %@", [ixporter shortDescription]) ;
		}
	}
	
	[mojo release] ;
}
#endif

// This method is bound to by a control in the document's window > Settings > Open/Save
- (NSString*)toolTipAutoImport {
	return [NSString localizeFormat:
			@"imex_autoImportTT",
			[self readableImportsList]] ;
}

+ (NSSet*)keyPathsForValuesAffectingToolTipAutoImport {
    return [NSSet setWithObjects:
            @"importers", // See KVOBurp286 at bottom of file
            nil] ;
}

// This method is bound to by a control in the document's window > Settings > Open/Save
- (NSString*)toolTipAutoExport {
	return [NSString localizeFormat:
			@"imex_autoExportTT",
			[self readableExportsListOnlyIfVulnerable:NO
                                        maxCharacters:512]] ;
}

+ (NSSet*)keyPathsForValuesAffectingToolTipAutoExport {
	return [NSSet setWithObjects:
			@"exporters", // See KVOBurp286 at bottom of file
			nil] ;
}

@end

/* Note KVOBurp286

 Until BkmkMgrs 2.8.6, these two key paths were "self.importers" and
 "self.exporters".  This caused the following bug in macOS 10.14 and
 maybe 10.13.  Steps (probably some are too strict)

 1.  Close .bmco document with Settings > Clients open but Content tab
 open at highest level.
 2.  Open that document.  Content tab opens.
 3.  Switch to Settings (Clients) tab.
 4.  Switch back to Content tab.
 5.  Close document.

 Result is this double KVO Burp:

 2018-08-16 21:12:46.221950-0700 BookMacster[3516:82143] [General] An instance 0x600003047cc0 of class Macster_Macster_entity_4 was deallocated while key value observers were still registered with it. Current observation info: <NSKeyValueObservationInfo 0x600000378920> (
 <NSKeyValueObservance 0x600000d63ed0: Observer: 0x600000d62490, Key path: exporters, Options: <New: NO, Old: NO, Prior: YES> Context: 0x6000021824e0, Property: 0x600000d60f90>
 <NSKeyValueObservance 0x600000da83c0: Observer: 0x600000d7b4e0, Key path: importers, Options: <New: NO, Old: NO, Prior: YES> Context: 0x60000217d9f0, Property: 0x600000daa580>
 )
 2018-08-16 21:12:46.224184-0700 BookMacster[3516:82143] [General] (
 0   CoreFoundation                      0x00007fff507d10ad __exceptionPreprocess + 256
 1   libobjc.A.dylib                     0x00007fff7c619720 objc_exception_throw + 48
 2   CoreFoundation                      0x00007fff508527c7 -[NSException initWithCoder:] + 0
 3   Foundation                          0x00007fff52ab9341 NSKVODeallocate + 442
 4   CoreData                            0x00007fff502aa7ff -[_PFManagedObjectReferenceQueue _processReferenceQueue:] + 1103
 5   CoreData                            0x00007fff502dae6b -[NSManagedObjectContext(_NSInternalAdditions) _dispose:] + 475
 6   CoreData                            0x00007fff502da92c -[NSManagedObjectContext _dealloc__] + 428
 7   CoreData                            0x00007fff502da6ee -[NSManagedObjectContext dealloc] + 302
 8   CoreFoundation                      0x00007fff50744a7a -[__NSDictionaryI dealloc] + 128
 9   Bkmxwork                            0x000000010027b0d1 -[SSYMOCManager destroyManagedObjectContextWithIdentifier:] + 161
 10  Bkmxwork                            0x000000010027b7f7 +[SSYMOCManager destroyManagedObjectContextWithIdentifier:] + 55
 11  Bkmxwork                            0x0000000100169724 -[BkmxBasis destroyAnyExistingDocSupportMocForMocName:uuid:] + 100
 12  Bkmxwork                            0x000000010031af8b +[BkmxDoc cleanUpDocSupportMocsForUuid:] + 635
 13  Foundation                          0x00007fff52aceaef __NSFireDelayedPerform + 433

 I verified that the window controller, window, settings tab view and the Auto
 Import and Auto Export checkboxes were all being deallocced before the Macster
 was deallocced.  The fix was to change these two key paths from
 "self.importers" and "self.exporters" to just "importers" and "exporters".
 The tooltips both function properly (showing the current list if importers
 and exporters after they are changed) with or without the "self." prefix.
 */


/*
 Sent to cocoa-dev@lists.apple.com  20100216
 Subject: Change attribute of 1 object: Why Core Data / Bindings re-sets whole array?
 
 This is a resolution of my message posted 2010 Jan 02, subject:
 Bindings/Core Data: Undesired Discovery of a Mythical "Deep Observer"
 
 I'm posting this because, after rewriting the whole thing and giving it some more thought, I believe I have an explanation, which archive-searchers might find interesting.  Summary: If an NSArrayController with 'contentArray' bound to a data model receives from the data model a new array which is equal to but a different pointer value than the array it currently has, it will push the new array back through the setter of the data model.
 
 I'm working on a Core Data project.  Some to-many properties are displayed in tables, and these objects in turn have their own attributes which are displayed in the columns, bound to array controllers' -arrangedObjects.xxx, etc.  Pretty standard stuff...
 
 DEPARTMENT's EMPLOYEES
 Name        Rank       Salary
 -------      ----       ------
 Fat Cat       3          200
 
 except that I have subclassed NSManagedObject and added 'index' attributes so that I can treat the sets as arrays, providing methods, for example -(NSArray*)employeesOrdered, -(Employee*)newEmployeeAtIndex:, etc.  All this works OK, except in a few of my columns I notice that, taking the above example, if user edits the table to change, say, the 'rank' of Fat Cat, after sending setRank:, the *Department* gets a -setEmployeesOrdered: message, with an NSArray argument which is a different pointer value but otherwise equal to the existing employeesOrdered array; it contains the same single object with the same pointer value.
 
 This does no harm to the data model of course; the only reason I noticed it is because in some cases it overwrites and thus screws up my undo action names which are driven by custom setters.
 
 In real life, -setEmployeesOrdered: is actually -setExportersOrdered and is #9 in the call stack below.  To fix the problem, in this setter I simply first check for array equality and return if no change.  Looking at the calls lower down, it appears to be fulfilling the binding on the array controller which causes this unnecessary message.  Of course, I do have an array controller with contentArray bound to 'exportersOrdered'.  Also, it makes sense that there would be different pointer values of exportersOrdered floating around since the getter computes it from the underlying set.  See code at the end.
 
 I've decided that, apparently what's happening is that when when the array controller notices that a bound (by a table column) to attribute is changed, it asks the data model for -exportersOrdered, sees that it gets a different array, but does not bother to check and see that the new array, although a different pointer value, is equal to the old array.  Probably it only keeps a reference.  And then due to some quirk in bindings it says, "Oh, I better push this new array to the data model's setter" (even though it just got it from the data model).
 
 If anyone has read this far and has a better explanation, let us know.
 
 #0	0x00122961 in -[BkmxDoc setUndoActionNameForAction:object:objectKey:updatedKey:count:] at BkmxDoc.m:2928
 #1	0x0001fd71 in -[Bookshig mikeAshObserveValueForKeyPath:ofObject:change:userInfo:] at Bookshig.m:1789
 #2	0x000ff452 in -[MAKVObservation observeValueForKeyPath:ofObject:change:context:] at MAKVONotificationCenter.m:98
 #3	0x002d6208 in NSKeyValueNotifyObserver
 #4	0x002d5ca7 in NSKeyValueDidChange
 #5	0x002ba6d0 in -[NSObject(NSKeyValueObserverNotification) didChangeValueForKey:]
 #6	0x01baa375 in -[NSManagedObject didChangeValueForKey:]
 #7	0x0006e3fb in -[Ixporter setIndex:] at Ixporter.m:351
 #8	0x000b6d93 in -[SSYManagedObject setIndexedSetWithArray:forSetKey:] at SSYManagedObject.m:231
 #9	0x0001d7f5 in -[Bookshig setExportersOrdered:] at Bookshig.m:1233
 #10	0x002dec99 in _NSSetObjectValueAndNotify
 #11	0x01ba726a in -[NSManagedObject setValue:forKey:]
 #12	0x002eead3 in -[NSObject(NSKeyValueCoding) setValue:forKeyPath:]
 #13	0x002eeaaf in -[NSObject(NSKeyValueCoding) setValue:forKeyPath:]
 #14	0x002eeaaf in -[NSObject(NSKeyValueCoding) setValue:forKeyPath:]
 #15	0x0078f0d6 in -[NSBinder _setValue:forKeyPath:ofObject:mode:validateImmediately:raisesForNotApplicableKeys:error:]
 #16	0x0078eeb0 in -[NSBinder setValue:forBinding:error:]
 #17	0x00b14745 in -[NSObjectDetailBinder setMasterObjectRelationship:refreshDetailContent:]
 #18	0x00b1461d in -[NSObjectDetailBinder noteContentValueHasChanged]
 #19	0x008f27ac in -[NSArrayController _setMultipleValue:forKeyPath:atIndex:]
 #20	0x0078f211 in -[NSBinder _setValue:forKeyPath:ofObject:mode:validateImmediately:raisesForNotApplicableKeys:error:]
 #21	0x00903832 in -[NSBinder setValue:forBinding:atIndex:error:]
 #22	0x0078ed3d in -[_NSValueBinderPlugin applyObjectValue:forBinding:operation:needToRunAlert:error:]
 #23	0x00ca9a4d in -[NSValueBinder _applyObjectValue:forBinding:canRecoverFromErrors:handleErrors:typeOfAlert:discardEditingCallback:otherCallback:callbackContextInfo:didRunAlert:]
 #24	0x00ca98a3 in -[NSValueBinder applyDisplayedValueHandleErrors:typeOfAlert:canRecoverFromErrors:discardEditingCallback:otherCallback:callbackContextInfo:didRunAlert:]
 #25	0x0078e647 in -[NSValueBinder performAction:]
 #26	0x0078e3f6 in -[_NSBindingAdaptor _objectDidTriggerAction:bindingAdaptor:]
 #27	0x0078e333 in -[_NSBindingAdaptor objectDidTriggerAction:]
 #28	0x007926d9 in -[NSControl sendAction:to:]
 #29	0x0078e1ba in -[NSCell _sendActionFrom:]
 #30	0x006b2f86 in -[NSApplication sendAction:to:from:]
 #31	0x006b2e39 in -[NSMenuItem _corePerformAction]
 #32	0x006b2b2a in -[NSCarbonMenuImpl performActionWithHighlightingForItemAtIndex:]
 #33	0x006b2a16 in -[NSMenu performActionForItemAtIndex:]
 #34	0x006b29c9 in -[NSMenu _internalPerformActionForItemAtIndex:]
 #35	0x006b292f in -[NSMenuItem _internalPerformActionThroughMenuIfPossible]
 #36	0x006b2873 in -[NSCarbonMenuImpl _carbonCommandProcessEvent:handlerCallRef:]
 #37	0x006a6f79 in NSSLMMenuEventHandler
 #38	0x03396e29 in DispatchEventToHandlers
 #39	0x033960f0 in SendEventToEventTargetInternal
 #40	0x033b8981 in SendEventToEventTarget
 #41	0x033e4e3b in SendHICommandEvent
 #42	0x03409b20 in SendMenuCommandWithContextAndModifiers
 #43	0x03409ad7 in SendMenuItemSelectedEvent
 #44	0x034099d3 in FinishMenuSelection
 #45	0x0358ab82 in PopUpMenuSelectCore
 #46	0x0358aed0 in _HandlePopUpMenuSelection7
 #47	0x0093c61e in _NSSLMPopUpCarbonMenu3
 #48	0x00b30a32 in -[NSPopUpButtonCell trackMouse:inRect:ofView:untilMouseUp:]
 #49	0x007efa02 in -[NSTableView _tryCellBasedMouseDown:atRow:column:withView:]
 #50	0x007ec79f in -[NSTableView mouseDown:]
 #51	0x00789f10 in -[NSWindow sendEvent:]
 #52	0x000b2684 in -[SSYHintableWindow sendEvent:] at SSYHintableWindow.m:18
 #53	0x006a2b2f in -[NSApplication sendEvent:]
 #54	0x006364ff in -[NSApplication run]
 #55	0x0062e535 in NSApplicationMain
 #56	0x00001e67 in main at MainApp-Main.m:19
 
 
 - (NSArray*)exportersOrdered {
 return [[self exporters] arraySortedByKeyPath:constKeyIndex] ;
 }
 
 - (void)setExportersOrdered:(NSArray*)exportersOrdered {
 // Patch to ignore re-setting to an equal array:
 if ([exportersOrdered isEqualToArray:[self exportersOrdered]]) {
 return ;
 }
 
 [self setIndexedSetWithArray:exportersOrdered
 forSetKey:constKeyExporters] ;
 }
 
 + (NSSet *)keyPathsForValuesAffectingExportersOrdered {
 return [NSSet setWithObject:constKeyExporters] ;    
 }
 
 */ 
