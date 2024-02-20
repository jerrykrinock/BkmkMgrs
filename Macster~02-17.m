#import "Bkmslf+Actions.h"
#import "Bookshig.h"
#import "Macster.h"
#import "Client.h"
#import "Clientoid.h"
#import "PrefsWinCon.h"
#import "ClientChoice.h"
#import "Importer.h"
#import "Trigger.h"
#import "Exporter.h"
#import "Agent.h"
#import "NSSet+Indexing.h"
#import "NSSet+Classify.h"
#import "NSUserDefaults+KeyPaths.h"
#import "BkmxBasis+Strings.h"
#import "BkmxDocumentController.h"
#import "Extore.h"
#import "NSNumber+CharacterDisplay.h"
#import "NSArray+SSYMutations.h"
#import "StarkTyper.h"
#import "NSArray+Stringing.h"
#import "NSNumber+Sharype.h"
#import "NSArray+SafeGetters.h"
#import "NSUserDefaults+Bkmx.h"
#import "Command.h"
#import "NSNumber+NoLimit.h"
#import "NSObject+DoNil.h"
#import "Stark.h"
#import "NSObject+MoreDescriptions.h"
#import "BkmxAppDel+Capabilities.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "IxportLog.h"
#import "SSYDooDooUndoManager.h"
#import "SSYDooDooUndoManager.h"
#import "NSSet+SimpleMutations.h"
#import "NSArray+Indexing.h"
#import "NSString+LocalizeSSY.h"
#import "NSArray+SortDescriptorsHelp.h"
#import "SSYLaunchdGuy.h"
#import "SSYRecurringDate.h"
#import "NSDictionary+SimpleMutations.h"
#import "NSError+SSYAdds.h"
#import "NSString+Truncate.h"
#import "SSYAlertSounder.h"
#import "BkmslfWinCon.h"
#import "AddonsMuleDriver.h"
#import "SSYMojo.h"
#import "NSManagedObjectContext+Cheats.h"
#import "NSDate+Components.h"
#import "NSInvocation+Quick.h"
#import "SSYSheetEnder.h"
#import "SSYLazyNotificationCenter.h"
#import "SSYBetterHashCategories.h"
#import "NSString+SSYExtraUtils.h"
#import "SSYMH.AppAnchors.h"
#import "Stager.h"
#import "FolderMap.h"
#import "TagMap.h"

static NSArray* static_importSettingsKeyPaths = nil ;

NSString* const constKeyAgentsDummyForKVO = @"agentsDummyForKVO" ;
NSString* const constKeyClientsDummyForKVO = @"clientsDummyForKVO" ;

NSString* const constKeyAutosaveUponClose = @"autosaveUponClose" ;
NSString* const constKeyDeleteUnmatchedMxtr = @"deleteUnmatchedMxtr" ;
NSString* const constKeyDaysDiary = @"daysDiary" ;
NSString* const constKeyAutoExport = @"autoExport" ;
NSString* const constKeyDoFindDupesAfterOpen = @"doFindDupesAfterOpen" ;
NSString* const constKeyAutoImport = @"autoImport" ;
NSString* const constKeyDoSortAfterOpen = @"doSortAfterOpen" ;
NSString* const constKeySafeLimitImport = @"safeLimitImport" ;

NSString* const constKeyAgentConfig = @"agentConfig" ;
NSString* const constKeyAgents = @"agents" ;

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

- (void)addAgentsObject:(Agent *)value;
- (void)removeAgentsObject:(Agent *)value;
- (void)addAgents:(NSSet *)value;
- (void)removeAgents:(NSSet *)value;

@end


@interface Macster (CoreDataGeneratedPrimitiveAccessors)

- (id)primitiveAgentConfig ;
- (void)setPrimitiveAgentConfig:(id)value ;
- (id)primitiveAgents ;
- (void)setPrimitiveAgents:(id)value ;
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
@property (assign) NSInteger clientTouchSeverity ;
@property (assign) BOOL clientTouchedAll ;
@property (assign) NSInteger agentTouchSeverity ;
@property (assign) BOOL agentTouchedAll ;
@property (assign) NSInteger macsterTouchSeverity ;

- (void)syncActualAgentsFromAgentConfig ;
- (void)macsterTouchNote:(NSNotification*)note ;
@end


@implementation Macster

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
	[m_bkmslf release] ;  m_bkmslf = nil ;

	[[NSNotificationCenter defaultCenter] removeObserver:self] ;
	[[SSYLazyNotificationCenter defaultCenter] removeObserver:self] ;
	
	[super didTurnIntoFault] ;
}

#pragma mark * Accessors for non-managed object properties

@synthesize agentsDummyForKVO = m_agentsDummyForKVO ;
@synthesize clientsDummyForKVO = m_clientsDummyForKVO ;
@synthesize clientTouchSeverity = m_clientTouchSeverity ;
@synthesize clientTouchedAll = m_clientTouchedAll ;
@synthesize agentTouchSeverity = m_agentTouchSeverity ;
@synthesize agentTouchedAll = m_agentTouchedAll ;
@synthesize macsterTouchSeverity = m_macsterTouchSeverity ;
@synthesize agentPausedConfig = m_agentPausedConfig ;
@synthesize agentsPaused = m_agentsPaused ;

- (NSString*)docUuid {
	NSString* docUuid = [[BkmxBasis sharedBasis] docUuidOfSettingsObject:self] ;
	return docUuid ;
}

- (BOOL)linkBkmslfMacsterError_p:(NSError**)error_p {
	Bkmslf* bkmslf = [[NSDocumentController sharedDocumentController] openDocumentWithUuid:[self docUuid]
																				   display:NO
																				   timeout:15.0
																			 resolvedUrl_p:NULL
																				   error_p:error_p] ;
	BOOL ok = (bkmslf != nil) ;
	
	if (ok) {
		[bkmslf setMacster:self] ;	
		[self setBkmslf:bkmslf] ;
	}
	
	return ok ;
}	

@synthesize bkmslf = m_bkmslf ;


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

@dynamic agentConfig ;

// Relationships

@dynamic clients ;
+ (NSSet*)keyPathsForValuesAffectingClients {
	return [NSSet setWithObjects:
			constKeyClientsDummyForKVO,
			nil] ;
}

@dynamic agents ;


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

- (void)postTouchedMacsterWithAgentSeverity:(NSInteger)severity {
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
	[self postTouchedMacsterWithAgentSeverity:5] ;
}

- (void)setAutosaveUponClose:(NSNumber*)value {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:value
					   forKey:constKeyAutosaveUponClose] ;
	
    [self willChangeValueForKey:constKeyAutosaveUponClose] ;
    [self setPrimitiveAutosaveUponClose:value];
    [self didChangeValueForKey:constKeyAutosaveUponClose] ;
	
	// The real reason why we need this custom setter:
	[self postTouchedMacsterWithAgentSeverity:0] ;
}

- (void)setDeleteUnmatchedMxtr:(NSNumber *)value {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:value
					   forKey:constKeyDeleteUnmatchedMxtr] ;
	
    [self willChangeValueForKey:constKeyDeleteUnmatchedMxtr] ;
    [self setPrimitiveDeleteUnmatchedMxtr:value];
    [self didChangeValueForKey:constKeyDeleteUnmatchedMxtr] ;
	
	for (Ixporter* importer in [self importers]) {
		[importer doMergeResolutionBusinessLogic] ;
	}
	
	[self postTouchedMacsterWithAgentSeverity:5] ;
	[[self bkmslf] forgetAllLastImportedHashes] ;
}

- (void)setDaysDiary:(NSNumber *)value {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:value
					   forKey:constKeyDaysDiary] ;
	
    [self willChangeValueForKey:constKeyDaysDiary] ;
    [self setPrimitiveDaysDiary:value];
    [self didChangeValueForKey:constKeyDaysDiary] ;
	
	[self postTouchedMacsterWithAgentSeverity:0] ;
}

- (void)setAutoExport:(NSNumber*)value {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:value
					   forKey:constKeyAutoExport] ;
	
    [self willChangeValueForKey:constKeyAutoExport] ;
    [self setPrimitiveAutoExport:value];
    [self didChangeValueForKey:constKeyAutoExport] ;
	
	// The real reason why we need this custom setter:
	[self postTouchedMacsterWithAgentSeverity:0] ;
}

- (void)setDoFindDupesAfterOpen:(NSNumber*)value {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:value
					   forKey:constKeyDoFindDupesAfterOpen] ;
	
    [self willChangeValueForKey:constKeyDoFindDupesAfterOpen] ;
    [self setPrimitiveDoFindDupesAfterOpen:value];
    [self didChangeValueForKey:constKeyDoFindDupesAfterOpen] ;
	
	// The real reason why we need this custom setter:
	[self postTouchedMacsterWithAgentSeverity:0] ;
}

- (void)setAutoImport:(NSNumber*)value {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:value
					   forKey:constKeyAutoImport] ;
	
    [self willChangeValueForKey:constKeyAutoImport] ;
    [self setPrimitiveAutoImport:value];
    [self didChangeValueForKey:constKeyAutoImport] ;
	
	// The real reason why we need this custom setter:
	[self postTouchedMacsterWithAgentSeverity:5] ;
}

- (void)setDoSortAfterOpen:(NSNumber*)value {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:value
					   forKey:constKeyDoSortAfterOpen] ;
	
    [self willChangeValueForKey:constKeyDoSortAfterOpen] ;
    [self setPrimitiveDoSortAfterOpen:value];
    [self didChangeValueForKey:constKeyDoSortAfterOpen] ;
	
	// The real reason why we need this custom setter:
	[self postTouchedMacsterWithAgentSeverity:5] ;
}

- (void)setPreferredCatchype:(NSNumber*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyPreferredCatchype] ;
	
    [self willChangeValueForKey:constKeyPreferredCatchype] ;
    [self setPrimitivePreferredCatchype:value];
    [self didChangeValueForKey:constKeyPreferredCatchype] ;

	[[self bkmslf] forgetAllLastImportedHashes] ;
}

- (void)setSafeLimitImport:(NSNumber*)newValue {
	// Probably unnecessary since settingsMoc doesn't support undo…
	[self postWillSetNewValue:newValue
					   forKey:constKeySafeLimitImport] ;

	[self willChangeValueForKey:constKeySafeLimitImport] ;
    [self setPrimitiveSafeLimitImport:newValue] ;
    [self didChangeValueForKey:constKeySafeLimitImport] ;

	// The real reason why we need this custom setter:
	[self postTouchedMacsterWithAgentSeverity:0] ;
}

- (void)setAgentConfig:(NSNumber*)value {
	// Bug fix in BookMacster 1.11 follows.  Previously, -isEqualToNumber raised exception when [self agentConfig] is nil.
	if ([NSNumber isEqualHandlesNilObject1:value
								   object2:[self agentConfig]]) {
		return ;
	}
	
	[self postWillSetNewValue:value
					   forKey:constKeyAgentConfig] ;
	
    [self willChangeValueForKey:constKeyAgentConfig] ;
    [self setPrimitiveAgentConfig:value];
    [self didChangeValueForKey:constKeyAgentConfig] ;
	
	unsigned long long oldConfig = [self agentConfigValue] ;
	unsigned long long newConfig = [value unsignedLongLongValue] ;
	unsigned long long additionalConfigBits = (oldConfig ^ newConfig) & newConfig ;
	NSInteger severity = (additionalConfigBits > 0) ? 7 : 4 ;
	[self postTouchedMacsterWithAgentSeverity:severity] ;
}

#pragma mark * Reactions

/*
 For explanation of how the next two methods work, see comments ahead of
 -postTouchedClient:severity:, below.  It's the same idea, and was also changed
 in BookMacster 1.9.8.
*/
- (void)postTouchedAgent:(Agent*)agent
				severity:(NSInteger)severity {
	NSDictionary* userInfo = agent ? [NSDictionary dictionaryWithObject:agent
																 forKey:constKeyAgent] : nil ;
	// Here, see analagous comment in -postClientTouched:severity:
	if ([self agentTouchSeverity] == 0) {
		[NSTimer scheduledTimerWithTimeInterval:0.0
										 target:self
									   selector:@selector(postAgentTouchedTimer:)
									   userInfo:userInfo
										repeats:NO] ;
	}
	
	if (severity > [self agentTouchSeverity]) {
		[self setAgentTouchSeverity:severity] ;
	}
	
	if (!agent) {
		[self setAgentTouchedAll:YES] ;
	}
}

- (void)postAgentTouchedTimer:(NSTimer*)timer {
	Agent* agent = [self agentTouchedAll] ? nil : [[timer userInfo] objectForKey:constKeyAgent] ;
	NSNumber* severityNumber = [NSNumber numberWithInteger:[self agentTouchSeverity]] ;
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							  severityNumber, constKeySeverity,
							  agent, constKeyAgent,
							  nil] ;
	[[NSNotificationCenter defaultCenter] postNotificationName:constNoteBkmxAgentDidChange
														object:self
													  userInfo:userInfo] ;
	// Reset for next run loop iteration, next notification coalesce group
	[self setAgentTouchSeverity:0] ;
	[self setAgentTouchedAll:NO] ;
	
	[self setAgentsDummyForKVO:![self agentsDummyForKVO]] ;
}

/*
 Here is a description of how -postTouchedClient:severity:, clientTouchSeverity,
 -postClientTouchedTimer: and constNoteBkmxClientDidChange work to
 coalesce client changes into a single notification that has the
 highest severity passed by any change since the last such notification.
 
 Until BookMacster 1.9.8, I used the following code to simply post
 the notification in -postTouchedClient:severity:…

 //		NSNumber* severityNumber = [NSNumber numberWithInteger:severity] ;
 //		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:severityNumber
 //															 forKey:constKeySeverity] ;
 //		NSNotification* notification = [NSNotification notificationWithName:constNoteBkmxClientDidChange
 //																	 object:self
 //																   userInfo:userInfo] ;
 //		[[NSNotificationQueue defaultQueue] enqueueNotification:notification
 //												   postingStyle:NSPostWhenIdle
 //												   coalesceMask:(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
 //													   forModes:nil] ;
 //		// See "Note on Coalesce Mask" at bottom of SSYOperationQueue.m
 //		[self setClientsDummyForKVO:![self clientsDummyForKVO]] ;

 However, in so doing, the value of constKeySeverity passed in the coalesced
 notification was that of, I don't know, either the first, the last or maybe an
 undefined notification put into the coalesce pool.
 
 The following design therefore uses my own home-brewed notification coalescing
 which passes the highest severity, as desired.  It is based on an NSTimer…
 
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
 
 3.  At the beginning of the next run loop, the timer fires, invoking 
 -postClientTouchedTimer: which does three things…
 
 3a.  Posts a constNoteBkmxClientDidChange notification, passing the current
 clientTouchSeverity, which is now the highest severity passed to
 -postTouchedClient:severity: since the last time this notification was posted.
 
 3b.  Clears clientTouchSeverity to 0, preparing for the next post
 
 3c.  Toggles the clientsDummyForKVO instance variable. 
 */
- (void)postTouchedClient:(Client*)client
				 severity:(NSInteger)severity {
	NSDictionary* userInfo = client ? [NSDictionary dictionaryWithObject:client
																 forKey:constKeyClient] : nil ;
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

	if (severity > [self clientTouchSeverity]) {
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

- (long long)agentConfigValue {
	return [[self agentConfig] unsignedLongLongValue] ;
}

// Note that the following to-many accessor overrides are needed to -postTouchedAgent:severity:
// and save the moc, etc., when an agent is added or removed in Settings > Advanced
// by clicking the [+] or [-] button, because this action comes via the array
// controller.  Added these methods to fix bug in BookMacster 1.1.20.
- (void)setAgents:(NSSet*)value {    	
    [self willChangeValueForKey:constKeyAgents];
    [self setPrimitiveAgents:[NSMutableSet setWithSet:value]];
    [self didChangeValueForKey:constKeyAgents];
	
	[self postTouchedAgent:nil
				  severity:8] ;
}

- (void)addAgentsObject:(Agent*)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyAgents withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveAgents] addObject:value];
    [self didChangeValueForKey:constKeyAgents withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
	
	[self postTouchedAgent:value
				  severity:8] ;
}

- (void)removeAgentsObject:(Agent*)value {
	[Stager removeStagingForAgentUri:[value objectUriMakePermanent:NO
														  document:nil]
								 pid:nil] ;

    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyAgents withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveAgents] removeObject:value];
    [self didChangeValueForKey:constKeyAgents withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
	
	[self postTouchedAgent:value
				  severity:4] ;
}

- (void)addAgents:(NSSet*)value {    
    [self willChangeValueForKey:constKeyAgents withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveAgents] unionSet:value];
    [self didChangeValueForKey:constKeyAgents withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
	
	[self postTouchedAgent:nil
				  severity:8] ;
}

- (void)removeAgents:(NSSet *)value {
	for (Agent* agent in value) {
		[Stager removeStagingForAgentUri:[agent objectUriMakePermanent:NO
																  document:nil]
									 pid:nil] ;
	}
    [self willChangeValueForKey:constKeyAgents withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveAgents] minusSet:value];
    [self didChangeValueForKey:constKeyAgents withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
	
	[self postTouchedAgent:nil
				  severity:4] ;
}

- (void)setAgentConfigBit:(BOOL)bit
				     mask:(long long)bitMask {
	// Get the existing value from the model
	long long agentConfig = [self agentConfigValue] ;
	// Set the existing bit to 0
	agentConfig = agentConfig & (~bitMask) ;
	// Set the bit to the new value
	long long newValueMask = bit ? bitMask : 0x0 ;
	agentConfig = agentConfig | newValueMask ;
	// Set the new value into the model
	NSNumber* newValue = [NSNumber numberWithLongLong:agentConfig] ;
	[self setAgentConfig:newValue] ;

	[self syncActualAgentsFromAgentConfig] ;
}

- (void)setAgentPausedConfigBit:(BOOL)bit
						   mask:(long long)bitMask {
	// Get the existing value from the ivar
	long long agentPausedConfig = [self agentPausedConfig] ;
	// Set the existing bit to 0
	agentPausedConfig = agentPausedConfig & (~bitMask) ;
	// Set the bit to the new value
	long long newValueMask = bit ? bitMask : 0x0 ;
	agentPausedConfig = agentPausedConfig | newValueMask ;
	// Set the new value into the ivar
	[self setAgentPausedConfig:agentPausedConfig] ;
}

- (BOOL)agentConfigImportChanges {
	BOOL answer ;
	if ([self agentsPaused]) {
		answer = (([self agentPausedConfig] & constBkmxAgentConfigImportChanges) != 0) ;
	}
	else {
		answer = (([self agentConfigValue] & constBkmxAgentConfigImportChanges) != 0) ;
	}
	return answer ;
}

- (void)setAgentConfigImportChanges:(BOOL)yn {
	if ([self agentsPaused]) {
		[self setAgentPausedConfigBit:yn
								 mask:constBkmxAgentConfigImportChanges] ;
	}
	else {
		[self setAgentConfigBit:yn
						   mask:constBkmxAgentConfigImportChanges] ;
	}
}

+ (NSSet*)keyPathsForValuesAffectingAgentConfigImportChanges {
	return [NSSet setWithObjects:
			@"agentConfig",
			@"agentPausedConfig",
			@"agentsPaused",
			nil] ;
}

- (BOOL)agentConfigSort {
	BOOL answer ;
	if ([self agentsPaused]) {
		answer = (([self agentPausedConfig] & constBkmxAgentConfigSort) != 0) ;
	}
	else {
		answer = (([self agentConfigValue] & constBkmxAgentConfigSort) != 0) ;
	}
	
	return answer ;
}

- (void)setAgentConfigSort:(BOOL)yn {
	if ([self agentsPaused]) {
		[self setAgentPausedConfigBit:yn
						   mask:constBkmxAgentConfigSort] ;
	}
	else {
		[self setAgentConfigBit:yn
						   mask:constBkmxAgentConfigSort] ;
	}
}

+ (NSSet*)keyPathsForValuesAffectingAgentConfigSort {
	return [NSSet setWithObjects:
			@"agentConfig",
			@"agentPausedConfig",
			@"agentsPaused",
			nil] ;
}

- (BOOL)agentConfigExportToClients {
	BOOL answer ;
	if ([self agentsPaused]) {
		answer = (([self agentPausedConfig] & constBkmxAgentConfigExportToClients) != 0) ;
	}
	else {
		answer = (([self agentConfigValue] & constBkmxAgentConfigExportToClients) != 0) ;
	}
	
	return answer ;
}

- (void)setAgentConfigExportToClients:(BOOL)yn {
	if ([self agentsPaused]) {
		[self setAgentPausedConfigBit:yn
								 mask:constBkmxAgentConfigExportToClients] ;
	}
	else {
		[self setAgentConfigBit:yn
						   mask:constBkmxAgentConfigExportToClients] ;
	}
}

+ (NSSet*)keyPathsForValuesAffectingAgentConfigExportToClients {
	return [NSSet setWithObjects:
			@"agentConfig",
			@"agentPausedConfig",
			@"agentsPaused",
			nil] ;
}

- (BOOL)agentConfigExportCloud {
	BOOL answer ;
	if ([self agentsPaused]) {
		answer = (([self agentPausedConfig] & constBkmxAgentConfigExportFromCloud) != 0) ;
	}
	else {
		answer = (([self agentConfigValue] & constBkmxAgentConfigExportFromCloud) != 0) ;
	}
	
	return answer ;
}

- (void)setAgentConfigExportCloud:(BOOL)yn {
	if ([self agentsPaused]) {
		[self setAgentPausedConfigBit:yn
								 mask:constBkmxAgentConfigExportFromCloud] ;
	}
	else {
		[self setAgentConfigBit:yn
						   mask:constBkmxAgentConfigExportFromCloud] ;
	}
}

+ (NSSet*)keyPathsForValuesAffectingAgentConfigExportCloud {
	return [NSSet setWithObjects:
			@"agentConfig",
			@"agentPausedConfig",
			@"agentsPaused",
			nil] ;
}

- (void)deleteAdvanedAgent:(Agent*)agent {
	NSInteger index = [[agent index] integerValue] ;
	[agent removeOwnees] ;
	[self removeAgentsObject:agent] ;
	// See Note 290293
	[[self managedObjectContext] deleteObject:agent] ;
	
	[[self agentsOrdered] fixIndexesContiguousStartingAtIndex:index] ;
	
	[self postTouchedAgent:agent
				  severity:4] ;
}

- (void)pauseAgents {
	long long agentConfig = [self agentConfigValue] ;
	BOOL agentsIsAdvanced = ((agentConfig & constBkmxAgentConfigIsAdvanced) != 0) ;
	
	if (agentsIsAdvanced) {
		for (Agent* agent in [self agents]) {
			[agent setIsActive:NO] ;
		}
	}
	else {
		[self setAgentConfig:[NSNumber numberWithLongLong:constBkmxAgentConfigNone]] ;
	}
	[self setAgentPausedConfig:agentConfig] ;
	
	[self setAgentsPaused:YES] ;
	
	// Don't save here because this is just a pause.
	// If we crash before saving, they might come back.
	// [self save] ;
}

- (NSString*)pauseAgentsAndAppendToMessage:(NSString*)message {
	if ([self agentConfigValue] == constBkmxAgentConfigNone) {
		return message ;
	}
	
	[self pauseAgents] ;

	// Normally, if the user just casually clicks the 'Syncing' button to
	// pause agents, we don't save that state immediately.  But in this
	// case, we do.
	[self save] ;
	
	// Append to the message what we did, creating a message if none.
	if (!message) {
		message = [NSString string] ;
	}
	else if ([message length] > 0) {
		message = [message stringByAppendingString:@"\n\n"] ;
	}

	// Because -pauseAgents actually removes them, if we are not in Main
	// App, there is no way to recover them, so…
	NSString* pausedOrRemoved = NSApp ? @"paused" : @"switched off" ;
	message = [message stringByAppendingFormat:
			   @"\u2714  To prevent recurrence, syncing has been %@.  "
			   @"To resume syncing, after the issue is resolved, click the 'Syncing' button in the toolbar.",
			   pausedOrRemoved] ;
	
	return message ;
}

- (void)pauseAgents:(BOOL)pauseAgents
			  alert:(SSYAlert*)alert {
	if (alert) {
		NSInteger checkboxState = [alert checkboxState] ;
		if (checkboxState == NSOnState) {
			[[NSUserDefaults standardUserDefaults] setBool:YES
													forKey:constKeyDontWarnExport] ;
		}
	}
	
	if (pauseAgents) {
		[self pauseAgents] ;
	}
}

- (void)resumeAgentsThenAutoExport:(BOOL)autoExport {
	long long pausedConfig = [self agentPausedConfig] ;
	if (pausedConfig == constBkmxAgentConfigIsAdvanced) {
		// Resume Advanced Agents
		for (Agent* agent in [self agents]) {
			[agent setIsActive:[NSNumber numberWithBool:YES]] ;
		}
	}
	else if (pausedConfig != constBkmxAgentConfigNone) {
		// Resume Simple Agents
		[self setAgentConfig:[NSNumber numberWithLongLong:pausedConfig]] ;
		[self syncActualAgentsFromAgentConfig] ;
	}
	
	[self setAgentPausedConfig:constBkmxAgentConfigNone] ;
	[self setAgentsPaused:NO] ;
}

- (BOOL)anAgentDoingImportOrExportIsActive {
	BOOL answer = NO ;
	for (Agent* agent in [self agents]) {
		if ([[agent isActive] boolValue]) {
			if ([agent doesImport] || [agent doesExport]) {
				answer = YES ;
				break ;
			}
		}
	}
	
	return answer ;
}

- (BOOL)anAgentWouldIxportIfActivatedOrResumedDoQualifyExport:(BOOL)doQualifyExport {
	BOOL answer = NO ;

	long long agentConfig = [self agentConfigValue] ;
	BOOL agentsIsAdvanced = ((agentConfig & constBkmxAgentConfigIsAdvanced) != 0) ;
	
	if (agentsIsAdvanced) {
		for (Agent* agent in [self agents]) {
			if ([agent doesImport] || ([agent doesExport] && doQualifyExport)) {
				answer = YES ;
				break ;
			}
		}
	}
	else {
		// Agents are simple
		
		long long relevantAgentConfig ;
		if ([self agentsPaused]) {
			relevantAgentConfig = [self agentPausedConfig] ;
		}
		else {
			relevantAgentConfig = [self agentConfigValue] ;
		}
		
		if (
			((relevantAgentConfig & constBkmxAgentConfigImportChanges) != 0)
			||			
			(((relevantAgentConfig == constBkmxAgentConfigExportToClients) != 0) && doQualifyExport)
			||			
			(((relevantAgentConfig == constBkmxAgentConfigExportFromCloud) != 0) && doQualifyExport)
			) {
			answer = YES ;
		}
	}
	
	return answer ;
}

- (void)checkWarnCloudability {
	if ([self agentsPaused]) {
		// Don't re-warn the user if user is merely resuming paused agents
		// for which this warning should have already been shown.
		return ;
	}
	
	NSInteger agentIndex = 0 ;
	for (Agent* agent in [self agentsOrdered]) {
		NSInteger triggerIndex = 0 ;
		for (Trigger* trigger in [agent triggersOrdered]) {
			if ([trigger triggerTypeValue] == BkmxTriggerCloud) {
				NSString* labelOther = [NSString localize:@"other"] ;
				NSString* labelOtherEllipsized = [labelOther ellipsize] ;
				NSString* msg = [NSString localizeFormat:
								 @"cloudRequiredX3",
								 [[BkmxBasis sharedBasis] labelAgent],
								 [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName],
								 labelOtherEllipsized] ;
				
				SSYAlert* alert = [SSYAlert alert] ;
				[alert setSmallText:msg] ;
				[alert setButton2Title:[@"Dropbox" ellipsize]] ;
				[alert setButton3Title:labelOtherEllipsized] ;
				[alert setHelpAnchor:constHelpAnchorCloudSync] ;
				Bkmslf* bkmslf = [self bkmslf] ;
				
				NSArray* invocations = [NSArray arrayWithObjects:
										[NSNull null],  // "OK"
										[NSInvocation invocationWithTarget:bkmslf  // "Dropbox…"
																  selector:@selector(dropbox:)
														   retainArguments:NO
														 argumentAddresses:NULL],
										[NSInvocation invocationWithTarget:bkmslf  // "Other…"
																  selector:@selector(saveAsMove:)
														   retainArguments:NO
														 argumentAddresses:NULL],
										nil] ;
				
				[bkmslf runModalSheetAlert:alert
								 iconStyle:SSYAlertIconInformational
							 modalDelegate:[SSYSheetEnder class]
							didEndSelector:@selector(didEndGenericSheet:returnCode:retainedInvocations:)
							   contextInfo:[invocations retain]] ;
				break ;
			}
		}
		triggerIndex++ ;
	}
	
	agentIndex++ ;
}

- (void)toggleSync {
	if ([self anAgentWouldIxportIfActivatedOrResumedDoQualifyExport:YES]) {
		if ([self agentsPaused]) {
			[self resumeAgentsThenAutoExport:NO] ;
		}
		else {
			[self pauseAgents:YES
						alert:nil] ;
		}
	}
	else {
		[[[self bkmslf] bkmslfWinCon] setUpSync:self] ;
	}
}

- (void)deleteAllAgents {
	// Setup…
	[self setAgentConfig:[NSNumber numberWithLongLong:constBkmxAgentConfigNone]] ;
	
	// This method was simplified in BookMacster 1.5 because
	// removing Triggers and Commands (i.e., ownees) will be done by
	// Core Data's Cascade Delete Rule
	
	// Removing actual launchd agents was thought to be done by
	// -syncActualAgentsFromAgentConfig when it's notified of
	// the above change in agentConfig by this, however in testing
	// BookMacster 1.9.8 I found that it did not work, so now the
	// calling method +[Agent removeAgentsForDocumentUuid:regular:transient:]
	// does that.
	[self postTouchedMacsterWithAgentSeverity:0] ;
}

- (void)agentsSetExpertise:(BOOL)advanced {	
	long long newConfig ;
	if (advanced) {
		// In this case, we change the configuration but do not remove
		// any of the agents
		newConfig = constBkmxAgentConfigIsAdvanced ;
	}
	else {
		// In this case, we change the configuration *and* remove any
		// existing agents
		newConfig = constBkmxAgentConfigNone ;
		// [self deleteAllAgents] ;  Removed in BookMacster 1.5 because this will be done by -syncActualAgentsFromAgentConfig
	}
	
	[self setAgentConfig:[NSNumber numberWithLongLong:newConfig]] ;
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
		// The following was removed in BookMacster 1.9.3 because it seems to be wrong;
		// that is, inactivity of a client should not affect availableTriggerTypes.
		// if (![[(Ixporter*)[client importer] isActive] boolValue]) {
		//	continue ;
		// }
		
		Class extoreClass = [client extoreClass] ;
		const ExtoreConstants* constants_p = [extoreClass constants_p] ;

		// Defensive programming section
		if (constants_p == NULL) {
			NSLog(@"Internal Error 950-3823 %@", [client shortDescription]) ;
			continue ;
		}
		
		NSString* extoreMedia = [client  extoreMedia] ;
		if ([extoreMedia isEqualToString:constBkmxExtoreMediaThisUser]) {
			if (constants_p->ownerAppIsLocalApp) {
				OwnerAppObservability observability = constants_p->ownerAppObservability ;
				if ([Extore canDoLiveObservability:observability]) {
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
	
	if ([entityName isEqualToString:constEntityNameAgent]) {
		parentSelector = @selector(macster) ;
	}
	else if ([entityName isEqualToString:constEntityNameTrigger]) {
		parentSelector = @selector(agent) ;
	}
	else if ([entityName isEqualToString:constEntityNameCommand]) {
		parentSelector = @selector(agent) ;
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

+ (NSInteger)countOfAgentsInAgentConfig:(long long)agentConfig {
	NSInteger count = 0 ;
	if ((agentConfig & constBkmxAgentConfigImportChanges) > 0) {
		count++ ;
	}
	if ((agentConfig & constBkmxAgentConfigExportFromCloud) > 0) {
		count++ ;
	}
	
	return count ;
}

- (void)syncActualAgentsFromAgentConfig {
	long long agentConfig = [self agentConfigValue] ;
	
	// Only execute if agentConfig state indicates is Simple, not Advanced.
	if ((agentConfig & constBkmxAgentConfigIsAdvanced) != 0) {		
		return ;
	}
	
	/* Until BookMacster version 1.3.6, at this point I sent [self deleteAllAgents] ;
	 and then added all *new* agents based on agentConfig.  That was easy but
	 sleazy, because I could only invoke this method when agentConfig was
	 changed manually.  Thus, simple agents would not update if clients
	 were changed.  To fix that, I needed to invoke this method
	 in -macsterTouchNote.  But that caused an infinite loop because when
	 I removed all agents in here (or did anything to the agents, it would
	 invoke -postTouchedAgent:severity:, which would re-invoke -macsterTouchNote when
	 the runloop cycled, which would reinvoke this method.
	 
	 So in BookMacster 1.3.6 this implementation was changed too.  Instead of
	 removing all agents at the beginning and adding all new agents from
	 scratch, now I do a comparison between agents, their triggers and their
	 commands, and only touch an agent, trigger or command if it is found
	 to not match the requirements of the current agentConfig.  That is
	 why you see many, many blocks in this method looking like
	 * if ([foo bar] != newBar) {
	 *      [foo setBar:newBar] ;
	 * }
	 The if() avoid unnecessary touches to agents, triggers or commands
	 which would cause a -postTouchedAgent:severity:.  It is lengthy and tedious,
	 but it works.
	 
	 Admittedly, the implementation here is probably not rigorously correct.
	 I wrote it by modifying the original method in an ad hoc fashion, then in
	 BookMacster 1.11 added more code to fix a couple of corner case bugs as
	 noted below.  I was able to get away with this because there are really
	 only two Simple Agents possible, the "Local Sync" and "Remote Sync", and
	 the user can only switch one of them ON or OFF at a time.  So there are
	 actually only a handful of configuration changes possible.
	 
	 When agentConfig is changed, the agents, triggers and commands will be
	 re-sent on the first pass through here, postTouchedAgent:severity: will be 
	 invoked, which will notify macsterTouchNote:, which will invoke this
	 method again.  But on the second run, all of the ([foo bar] != newBar)
	 will evaluate to NO, and there will te no more -postTouchedAgent:severity:,
	 and thus no infinite loop. */
	
	// Stuff we'll be using in this method
	NSManagedObjectContext* moc = [self managedObjectContext] ;
	SSYMojo* mojo ;
	mojo = [[SSYMojo alloc] initWithManagedObjectContext:moc
											  entityName:[SSYManagedObject entityNameForClass:[Agent class]]] ;
	Agent* agent ;
	
	// Added in BookMacster 1.11 to fix a corner case bug
	if (
		([[self agents] count] == 2)
		&&
		([Macster countOfAgentsInAgentConfig:agentConfig] == 1)
		) {
		if ((agentConfig & constBkmxAgentConfigExportFromCloud) != 0) {			
			// We have two agents, but we want only one, the second one.
			// Therefore we should delete the first one.  Otherwise,
			// we will modify the first one to be the second one and
			// then delete the second one, which was probably OK.
			Agent* deadAgent = [[self agentsOrdered] objectAtIndex:0] ;
			[moc deleteObject:deadAgent] ;
			[moc processPendingChanges] ;
			[(Agent*)[[self agents] anyObject] setIndex:0] ;
		}
	}

	// Added in BookMacster 1.11 to fix a corner case bug, which is kind of
	// the dual of the previous corner case bug fix
	BOOL shouldCreateFirstAgent = NO ;
	if (
		([[self agents] count] == 1)
		&&
		([Macster countOfAgentsInAgentConfig:agentConfig] == 2)
		) {
		if (![[[self agentsOrdered] objectAtIndex:0] doesImport]) {
			// We want two agents, but only have one, the second one.
			// Therefore, when comparing the first agent, we should
			// insert a new one.  If we don't, we'll modify the existing
			// agent, which is perfectly good as the second agent, to
			// be the first agent, and then need to re-create the
			// second agent.
			shouldCreateFirstAgent = YES ;
		}
	}	
	
	NSInteger agentIndex = 0 ;
	if ((agentConfig & constBkmxAgentConfigImportChanges) != 0) {
		if ([self hasAThisUserActiveImportClient]) {
			NSMutableString* userDescription = [NSMutableString stringWithString:[[BkmxBasis sharedBasis] labelAgentImportClients]] ;
			agent = [[self agentsOrdered] objectSafelyAtIndex:agentIndex] ;
			if (!agent || shouldCreateFirstAgent) {			
				// Create Agent and User Description
				agent = [self freshAgentAtIndex:0] ;
				// Remove the default trigger and commands
				[agent deleteAllTriggers] ;
				[agent deleteAllCommands] ;
			}
			
			// Check trigger(s), re-create if wrong
			NSMutableSet* triggersToRemove = [[[agent triggers] mutableCopy] autorelease] ;
			for (Client* client in [self clientsOrdered]) {
				// This code matches other code at other Note 879540
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
				
				// Determine the most liberal trigger type for this Client
				BkmxTriggerType triggerTypeValue ;
				OwnerAppObservability observability = constants_p->ownerAppObservability ;
				if ([Extore canDoLiveObservability:observability]) {
					triggerTypeValue = BkmxTriggerSawChange ;
				}
				else if (observability == OwnerAppObservabilityOnQuit) {
					triggerTypeValue = BkmxTriggerBrowserQuit ;
				}
				else {
					// Branch added in BookMacster 1.11.3
					NSLog(@"Internal Error 624-0287 %@", [client shortDescription]) ;
				}
				
				BOOL matchedExistingTrigger = NO ;
				for (Trigger* trigger in [agent triggersOrdered]) {
					if ((client == [trigger client]) && (triggerTypeValue == [trigger triggerTypeValue])) {
						[triggersToRemove removeObject:trigger] ;
						matchedExistingTrigger = YES ;
					}
				}
				if (!matchedExistingTrigger) {
					Trigger* trigger = [agent freshTriggerAtIndex:NSNotFound] ;
					[trigger setTriggerTypeValue:triggerTypeValue] ;
					[trigger setClient:client] ;
				}			
			}
			for (Trigger* trigger in triggersToRemove) {
				[agent deleteTrigger:trigger] ;
			}
			
			// Check commands, re-create if wrong
			Command* command ;
			NSInteger commandIndex = 0 ;
			{
				//   Import
				command = [[agent commandsOrdered] objectSafelyAtIndex:commandIndex] ;
				if (!command) {
					command = [agent freshCommandAtIndex:commandIndex] ;
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
			if ((agentConfig & constBkmxAgentConfigSort) != 0) {
				// Sort
				command = [[agent commandsOrdered] objectSafelyAtIndex:commandIndex] ;
				if (!command) {
					command = [agent freshCommandAtIndex:commandIndex] ;
				}
				if (![[command method] isEqualToString:@"sort"]) {
					[command setMethod:@"sort"] ;
				}
				[userDescription appendFormat:
				 @" %@ %@",
				 constEmDash,
				 [[BkmxBasis sharedBasis] labelSort]] ;
				commandIndex++ ;
			}
			if ((agentConfig & constBkmxAgentConfigExportToClients) != 0) {		
				// Export
				command = [[agent commandsOrdered] objectSafelyAtIndex:commandIndex] ;
				if (!command) {
					command = [agent freshCommandAtIndex:commandIndex] ;
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
				 [[BkmxBasis sharedBasis] labelExport]] ;
				commandIndex++ ;
			}		
			{
				// Save
				command = [[agent commandsOrdered] objectSafelyAtIndex:commandIndex] ;
				if (!command) {
					command = [agent freshCommandAtIndex:commandIndex] ;
				}
				if (![[command method] isEqualToString:@"saveDocument"]) {
					[command setMethod:@"saveDocument"] ;
				}
				commandIndex++ ;
			}
			// Remove any commands beyond those currently required
			while ((command = [[agent commandsOrdered] objectSafelyAtIndex:commandIndex])) {
				[agent deleteCommand:command] ;
			}
			
			// Finish this agent
			if(![[agent userDescription] isEqualToString:userDescription]) {
				[agent setUserDescription:userDescription] ;
			}
			agentIndex++ ;
		}
		else if ([self hasAnImportClientWithObserveableBookmarksChanges]) {
			// This branch was added in BookMacster 1.11.3 after I spent an hour wondering
			// why I didn't get the "Export" "It's OK" "Pause Syncing" dialog after 
			// creating an Agent when no Clients had an active Import.
			NSString* msg = @"An agent has been created but will not do anything until you also activate a Client's 'Import'." ;
			SSYAlert* alert = [SSYAlert alert] ;
			[alert setSmallText:msg] ;
			[alert setIconStyle:SSYAlertIconInformational] ;
			[alert setButton1Title:[[BkmxBasis sharedBasis] labelOk]] ;
			[[self bkmslf] runModalSheetAlert:alert
									iconStyle:SSYAlertIconInformational
								modalDelegate:nil
							   didEndSelector:NULL
								  contextInfo:NULL] ;
		}
	}	
		
	if ((agentConfig & constBkmxAgentConfigExportFromCloud) != 0) {		
		agent = [[self agentsOrdered] objectSafelyAtIndex:agentIndex] ;
		if (!agent) {			
			// Create Agent and User Description
			agent = [self freshAgentAtIndex:NSNotFound] ;
			// Remove the default trigger and commands
			[agent deleteAllTriggers] ;
			[agent deleteAllCommands] ;
		}
		
		// Check/Create the single Trigger
		Trigger* trigger = [[agent triggersOrdered] objectSafelyAtIndex:0] ;
		if (!trigger) {
			trigger = [agent freshTriggerAtIndex:0] ;
		}				
		if ([trigger triggerTypeValue] != BkmxTriggerCloud) {
			[trigger setTriggerTypeValue:BkmxTriggerCloud] ;
		}				
		// Remove any triggers beyond those currently required
		while ((trigger = [[agent triggersOrdered] objectSafelyAtIndex:1])) {
			[agent deleteTrigger:trigger] ;
		}
		
		// Check/Create the single Command
		Command* command ;
		{
			// Export
			command = [[agent commandsOrdered] objectSafelyAtIndex:0] ;
			if (!command) {
				command = [agent freshCommandAtIndex:0] ;
			}
			if (![[command method] isEqualToString:constMethodPlaceholderExportAll]) {
				[command setMethod:constMethodPlaceholderExportAll] ;
			}
			if (![[command argument] isEqual:[NSNumber numberWithInteger:BkmxDeferenceQuit]]) {
				[command setArgument:[NSNumber numberWithInteger:BkmxDeferenceQuit]] ;
			}
		}
		// Remove any commands beyond the one currently required
		while ((command = [[agent commandsOrdered] objectSafelyAtIndex:1])) {
			[agent deleteCommand:command] ;
		}
		
		NSString* userDescription = [[BkmxBasis sharedBasis] labelAgentCloud] ;
		if (![[agent userDescription] isEqualToString:userDescription]) {
			[agent setUserDescription:userDescription] ;
		}
		agentIndex++ ;
	}
	
	NSMutableSet* deadObjects = [[NSMutableSet alloc] init] ;
	for (Agent* agent in [mojo allObjects]) {
		if ([[agent index] integerValue] >= agentIndex) {
			[deadObjects addObject:agent] ;
		}
	}
	// Delete all orphans found
	for (Agent* agent in deadObjects) {
		[moc deleteObject:agent] ;
	}
	[deadObjects release] ;
	[self save] ;

	[mojo release] ;
}

- (void)fixDeferencelessIECommands {
	for (Agent* agent in [self agents]) {
		for (Command* command in [agent commands]) {
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

- (NSArray*)agentsOrdered {
	NSSet* agents = [self agents] ;
	NSArray* answer = nil ;
	if (agents) {
		answer = [agents arraySortedByKeyPath:constKeyIndex] ;
	}
	else {
		answer = nil ;
	}
	
	return answer ;
}

+ (NSSet *)keyPathsForValuesAffectingAgentsOrdered {
	return [NSSet setWithObject:constKeyAgents] ;	
}

- (void)setAgentsOrdered:(NSArray*)agentsOrdered {
	// See "Bindings: NSArrayController gets a new but equal array, pushes back to model"
	// at end of Bookshig.m 
	if ([agentsOrdered isEqualToArray:[self agentsOrdered]]) {
		return ;
	}
	
	[self setIndexedSetWithArray:agentsOrdered
					   forSetKey:constKeyAgents] ;
}

- (Agent*)agentAtIndex:(NSInteger)index {
	return [[self agentsOrdered] objectSafelyAtIndex:index] ;
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

- (void)makeNewLocalClientWithExformat:(NSString*)exformat {
	Client* client = [self freshClientAtIndex:NSNotFound] ;
	Clientoid* clientoid = [Clientoid clientoidThisUserWithExformat:exformat
														profileName:nil] ;
	[client setLikeClientoid:clientoid] ;
	[self save] ;
}

/*!
 @details  The returned Client object has an importer and exporter
 (courtesy of -[Client awakeFromInsert])
 and both of their isActive are set to the model default value of YES.
 */
- (Client*)freshClientAtIndex:(NSInteger)index {
	// Put in same managed object context
	NSManagedObjectContext *moc = [self managedObjectContext] ;
	
	Client* client = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameClient
												   inManagedObjectContext:moc] ;
	
	NSMutableSet* newSiblings = [self mutableSetValueForKey:constKeyClients] ;
	[newSiblings addObject:client
				   atIndex:index] ;
	
	[self postTouchedClient:client
				   severity:7] ;
	
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

- (Agent*)freshAgentAtIndex:(NSInteger)index {
	// Put in same managed object context
	NSManagedObjectContext *moc = [self managedObjectContext] ;
	
	Agent* agent = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameAgent
												 inManagedObjectContext:moc] ;
	
	NSMutableSet* newSiblings = [self mutableSetValueForKey:constKeyAgents] ;
	[newSiblings addObject:agent
				   atIndex:index] ;

	[self postTouchedAgent:agent
				  severity:8] ;
	
	return agent ;
}

- (IBAction)addNewAgent {
	[self freshAgentAtIndex:NSNotFound] ;
}

- (void)unblindTriggersWithKeys:(NSSet*)triggerBlinderKeys {
	if ([triggerBlinderKeys count] == 0) {
		return ;
	}
	
	SSYMojo* mojo = [[SSYMojo alloc] initWithManagedObjectContext:[self managedObjectContext]
													   entityName:constEntityNameTrigger] ;
	NSArray* triggers = [mojo allObjects] ;
	[mojo release] ;
	
	for (NSString* key in triggerBlinderKeys) {
		for (Trigger* trigger in triggers) {
			[trigger unblindIfKey:key] ;
		}
	}
}

- (NSArray*)clientsOrdered {
    NSSet* clients = [self clients] ;
	return  [clients arraySortedByKeyPath:constKeyIndex] ;
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
	if ([self bkmslf]) {
        NSError* error = nil ;
        BOOL ok = [[self managedObjectContext] save:&error] ;
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

- (void)macsterBusinessNote:(NSNotification*)note {
	if ([[note name] isEqualToString:constNoteBkmxClientDidChange]) {
		[[[self bkmslf] shig] setUserIsFussingWithClients:YES] ;
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
				[[self bkmslf] forgetLastImportedHashForClient:client] ;
				[[self bkmslf] forgetLastExportedHashForClient:client] ;
			}
		}		
	}
	
	for (Agent* agent in [self agents]) {
		for (Trigger* trigger in [agent triggers]) {
			BkmxTriggerType triggerType = [trigger triggerTypeValue] ;
			Client* client = [trigger client] ;
			if (client) {
				OwnerAppObservability observability = [[client extoreClass] constants_p]->ownerAppObservability ;
				if (
					(observability == OwnerAppObservabilityOnQuit)
					&&
					(triggerType == BkmxTriggerSawChange)
					) {
					// Automatically "downgrade" the trigger type to the 
					// decreased observability of the new client
					[trigger setTriggerTypeValue:BkmxTriggerBrowserQuit] ;
				}
				else if (
						 [Extore canDoLiveObservability:observability]
						 &&
						 (triggerType == BkmxTriggerBrowserQuit)
						 ) {
					// Automatically "upgrade" the trigger type to take advantage
					// of the increased observability of the new client
					[trigger setTriggerTypeValue:BkmxTriggerSawChange] ;
				}				
			}
		}
	}

	// The following was added in BookMacster version 1.3.6.
	// See the long comment in -syncActualAgentsFromAgentConfig.
	[self syncActualAgentsFromAgentConfig] ;
	
	// Business logic to make sure that triggerTypes of all
	// Triggers and methods of all Commands are still
	// applicable, for each agent.
	NSSet* agentsCopy = [[self agents] copy] ;
	NSMutableSet* alreadyEnsuringClidentifiers = [[NSMutableSet alloc] init] ;
	for (Agent* agent in agentsCopy) {
		NSSet* triggersCopy = [[agent triggers] copy] ;
		for (Trigger* trigger in triggersCopy) {
			// Added in BookMacster 1.9.9, in case someone sets an identical
			// trigger.  This is easy to do in Advanced Agents tab.
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
					NSNotification* note = [NSNotification notificationWithName:constNoteDuplicateTrigger
																		 object:self] ;
					[[SSYLazyNotificationCenter defaultCenter] enqueueNotification:note
																			 delay:1.0] ;
					
				}
			}
			
			BOOL isBadTrigger = NO ;
			NSArray* availableTriggerTypes = [agent availableTriggerTypes] ;
			if ([availableTriggerTypes indexOfObject:[trigger triggerType]] == NSNotFound) {
				// Possibly triggerType is BkmxTriggerBookmarksChanged and a
				// cooperative client is no longer present.  See if we can fall back to 
				// BkmxBrowserQuit.
				isBadTrigger = YES ;
			}
			else {
				if (
					([trigger triggerTypeValue] == BkmxTriggerSawChange)
					||
					([trigger triggerTypeValue] == BkmxTriggerBrowserQuit)
					) {
					Client* client = [trigger client] ;
					if (!client) {
						isBadTrigger = YES ;
					}
					else if ([[[client importer] isActive] boolValue] == NO) {
						isBadTrigger = YES ;
					}
					else if ([trigger triggerTypeValue] == BkmxTriggerSawChange) {
						NSString* clidentifier = [[client clientoid] clidentifier] ;
						if (![alreadyEnsuringClidentifiers member:clidentifier]) {
							[[AddonsMuleDriver sharedDriver] ensureAddonForClient:client
																		  purpose:constAddonabilitySawChange] ;
							[alreadyEnsuringClidentifiers addObject:clidentifier] ;
						}
					}
				}
			}				
			
			if (isBadTrigger) {
				// Remove the trigger.
				[agent deleteTrigger:trigger] ;
				
				// And it needs to be an Advanced agent.
				// Probably the next line is superfluous because if this was a Simple Agent,
				// it would have been made good during -syncActualAgentsFromAgentConfig
				// which was invoked above.  I think.  Not 100% sure.
				[self setAgentConfig:[NSNumber numberWithLongLong:constBkmxAgentConfigIsAdvanced]] ;
			}
		}
		[triggersCopy release] ;
		
		for (Command* command in [agent commands]) {
			// If an Agent no longer has a client-based trigger, check all of
			// its Commands and change any command operating on the single
			// triggering client to the equivalent command operating on 
			// all clients
			if (![agent hasAClientBasedTrigger]) {
				if ([[command method] isEqualToString:constMethodPlaceholderImport1]) {
					[command setMethod:constMethodPlaceholderImportAll] ;
				}
				else if ([[command method] isEqualToString:constMethodPlaceholderExport1]) {
					[command setMethod:constMethodPlaceholderExportAll] ;
				}
			}
			
			// Fix any other un-availableCommandMethods by setting
			// them to an arbitrary but available default method.
			NSArray* availableCommandMethods = [agent availableCommandMethods] ;
			if ([availableCommandMethods indexOfObject:[command method]] == NSNotFound) {
				[command setMethod:[availableCommandMethods firstObjectSafely]] ;
			}
		}
	}
	[alreadyEnsuringClidentifiers release] ;
    [agentsCopy release] ;
	
	// We sync launchd agents for constNoteBkmxAgentDidChange for the obvious reason
	// We sync launchd agents for constNoteBkmxClientDidChange because the Trigger
	// causing a launchd agent may be dependent on which Client.
	// We do this here instead of in -postTouchedAgent:severity: because
	// synchLaunchdAgentsError_p is an expensive operation and
	// at this point, notifications have been coalesced by our
	// home-brew coalescing system.  (See comments ahead of
	// -postClientTouched).
	if (
		[[note name] isEqualToString:constNoteBkmxAgentDidChange]
		||
		[[note name] isEqualToString:constNoteBkmxClientDidChange]
		) {
		NSError* error = nil ;
		[[self bkmslf] syncLaunchdAgentsLogActions:NO
										   error_p:&error] ;
		[SSYAlert alertError:error] ;
	}
	
	// We save later instead of now, in case some other object
	// receives notification before we do, and changes objects.
	// We want all changes to be registered before we save.
	[self saveLater] ;
}

- (void)macsterTouchNote:(NSNotification*)note {
	// This section was added in BookMacster 1.11
	
	// See if turning off Auto Import is necessary, and if so, warn user and do it.
	if (
		[[note name] isEqualToString:constNoteBkmxAgentDidChange]
		||
		[[note name] isEqualToString:constNoteBkmxMacsterDidChange]
		) {
		if ([[[note userInfo] objectForKey:constKeySeverity] integerValue] > 4) {
			if ([self anAgentWouldIxportIfActivatedOrResumedDoQualifyExport:NO]) {
				if ([[self autoImport] boolValue]) {
					[self setAutoImport:nil] ;
					[self saveLater] ;
					// The following alert is shown in two situations, that I can think of…
					// •  If user switches on the Auto Import box while at least one agent could import if activated or resumed
					//       Better message: @"Auto Import is not a good idea because you also have an importing Agent."
					// •  If Auto Import is active and user adds at least one agent could import if activated or resumed
					//       Better message: @"Auto Import (upon document opening) has been disabled because you've got an importing Agent now."
					NSString* msg = @"Auto Import has been disabled, because you have an importing Agent." ;
					SSYAlert* alert = [SSYAlert alert] ;
					[alert setSmallText:msg] ;
					[alert setIconStyle:SSYAlertIconInformational] ;
					[alert setButton1Title:[[BkmxBasis sharedBasis] labelOk]] ;
					[[self bkmslf] runModalSheetAlert:alert
											iconStyle:SSYAlertIconInformational
										modalDelegate:nil
									   didEndSelector:NULL
										  contextInfo:NULL] ;
				}
			}
		}
	}
	
	// See if turning off prompting a manual "pump priming" export is necessary, and if so, prompt it.
	NSString* syncedClientsListForPromptingExport = nil ;
	if ([[note name] isEqualToString:constNoteBkmxAgentDidChange]) {
		if ([[[note userInfo] objectForKey:constKeySeverity] integerValue] > 5) {
			if ([self anAgentDoingImportOrExportIsActive]) {
				syncedClientsListForPromptingExport = [[self clientsWithIxportEitherActive] listValuesForKey:@"displayName"
																								 conjunction:[NSString localize:@"andEndList"]
																								  truncateTo:0];
			}
		}
	}
	if ([syncedClientsListForPromptingExport length] > 0) {
		NSMutableString* msg = [NSMutableString stringWithFormat:
								@"The action you have just taken affects syncing of %@.  "
								@"For proper syncing, all clients should have the same Content as is now in this document.\n\n",
								[self clientListForSelector:NULL
											  maxCharacters:128]] ;
		[msg appendString:@"Click 'Pause' to temporarily deactivate your Agents."] ;
		[msg appendString:@"  You should do this if you have more changes to make.\n\n"] ;
		[msg appendFormat:@"Click 'Export' to push this document's Content into %@ and give your syncing a good clean start.",
		 syncedClientsListForPromptingExport] ;
		[msg appendString:@"  You should do this if you are done making changes.\n\n"] ;
		[msg appendString:@"Click 'It's OK' to skip exporting."] ;
		[msg appendString:@"  Do this only if you are sure that neither your Clients' nor this document's Content has changed since the last Export.\n\n"] ;
		NSString* button1Title = @"Pause" ;
		NSString* button2Title = [[BkmxBasis sharedBasis] labelExport] ;
		NSString* button3Title = @"It's OK" ;
		SSYAlert* alert = [SSYAlert alert] ;
		[alert setSmallText:msg] ;
		[alert setIconStyle:SSYAlertIconInformational] ;
		[alert setButton1Title:button1Title] ;
		[alert setButton2Title:button2Title] ;
		[alert setButton3Title:button3Title] ;
		BOOL yes = YES ;
		
		NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									 [NSNumber numberWithDouble:20.0], constKeyUninhibitSecondsAfterDone,
									 [NSNumber numberWithBool:YES], constKeyPauseAgentsIfUserCancelsExport,
									 nil] ;
		/*	
		 If user clicks "Export", the export will be a result of just activating Agents.
		 Because the user is in BookMacster, we consider any triggers such as those that always
		 occur after 10 secs after exporting to Chrome and Firefox if they're running to be
		 extraneous, and because those are annoying, and because we want to make a good
		 first impression, we don't want retrigger/resyncs to occur.  To prevent them, 
		 we have set the key constKeyUninhibitSecondsAfterDone into info, with a value of
		 20 seconds.  This is: 10 seconds for the trigger delay, 1 second for it to trigger,
		 9 seconds margin.
		 
		 That key will have the following effects:
		 • in -[Bkmslf exportWithAlert:info:], its mere nonnilness will set
		 the General Uninhibit for 20 minutes into the future 
		 • in -[Bkmslf exportPerInfo:], its nonnilness will cause an Export-Grande
		 operation group to be queued, and its value will be transferred into the
		 info for this Export-Grande group.
		 • in -[SSYOperation (Operation_Common) uninhibit_unsafe] the General
		 Uninhibit will be accelerated from 10 minutes minus a few seconds into the
		 future TO: 20 seconds into the future.  The 20 seconds is to allow 10
		 seconds for the .sawChange file to be touched by Chrome or Firefox extensions.
		 
		 Another way to solve this problem would be to to pause agents, then resume them
		 20 seconds after the export was done.  But that would be much more complicated
		 and trouble-prone.  In particular, what if the user wants to quit immediately
		 after the export is done?
		 */
		
		NSArray* doneInvocations = [NSArray arrayWithObjects:
									// "Pause"
									[NSInvocation invocationWithTarget:self
															  selector:@selector(pauseAgents:alert:)
													   retainArguments:YES
													 argumentAddresses:&yes, &alert],
									// "Export".
									[NSInvocation invocationWithTarget:[self bkmslf]
															  selector:@selector(exportIfPermittedInfo:)
													   retainArguments:YES
													 argumentAddresses:&info],
									// "It's OK".  Do nothing.
									[NSNull null],
									nil] ;
		[[self bkmslf] runModalSheetAlert:alert
								iconStyle:SSYAlertIconInformational
							modalDelegate:[SSYSheetEnder class]
						   didEndSelector:@selector(didEndGenericSheet:returnCode:retainedInvocations:)
							  contextInfo:[doneInvocations retain]] ;
	}

	// Do other business logic
	[self macsterBusinessNote:note] ;
}

- (void)alertDupeTriggerNote:(NSNotification*)note {
	SSYAlert* alert = [SSYAlert alert] ;
	[alert setSmallText:@"Duplicate trigger(s).  Please change to avoid trouble."] ;
	[[self bkmslf] runModalSheetAlert:alert
							iconStyle:SSYAlertIconCritical
						modalDelegate:nil
					   didEndSelector:NULL
						  contextInfo:NULL] ;
}

- (void)initializeObservers {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(macsterTouchNote:)
												 name:constNoteBkmxAgentDidChange
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
}

- (void)initializeAgentPausedIvars {
	// Simple Agents can never be paused upon wake, because agentPausedConfig
	// is not persisted.  If document is closed while Simple Agents are paused,
	// they are gone.
	// However, Advanced Agents can be paused initially.
	for (Agent* agent in [self agents]) {
		if ([agent doesExport]) {
			if (![agent isActive]) {
				[self setAgentsPaused:YES] ;
				[self setAgentPausedConfig:constBkmxAgentConfigIsAdvanced] ;
			}
		}
	}
}

- (void)awakeFromFetch {
	[super awakeFromFetch] ;
	
	[self initializeObservers] ;
	[self initializeAgentPausedIvars] ;
}

- (void)awakeFromInsert {
	[super awakeFromInsert] ;
	
	[self initializeObservers] ;
}		

- (NSString*)shortDescription {
	return [NSString stringWithFormat:
			@"<%@ %p : docUuid=%@ nClnts=%ld, nAgts=%ld, agentConfig=%0qx>",
			[self className],
			self,
			[self docUuid],
			(long)[[self clients] count],
			(long)[[self agents] count],
			[self agentConfigValue]] ;
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

- (NSArray*)activeClientsForSelector:(SEL)selector {
	NSMutableArray* clients = [[NSMutableArray alloc] init] ;
	for (Client* client in [self clientsOrdered]) {
		Ixporter* ixporter ;
		if (selector) {
			ixporter = [client performSelector:selector] ;
			if ([[ixporter isActive] boolValue]) {
				[clients addObject:client] ;
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
					[clients addObject:client] ;
				}
			}
		}
	}
    
    NSArray* answer = [[clients copy] autorelease] ;
    [clients release] ;

    return answer ;
}

- (NSArray*)activeClients {
    return [self activeClientsForSelector:NULL] ;
}


- (NSString*)clientListForSelector:(SEL)selector
					 maxCharacters:(NSUInteger)maxCharacters {
	
	return [self truncatedListOrPlaceholderForClients:[self activeClientsForSelector:selector]
                                        maxCharacters:maxCharacters] ;
}

- (NSString*)readableImportsList {
	return [self clientListForSelector:@selector(importer)
						 maxCharacters:48] ;
}

- (NSString*)readableExportsListMaxCharacters:(NSUInteger)maxCharacters {
	return [self clientListForSelector:@selector(exporter)
						 maxCharacters:maxCharacters] ;
}

- (ClientChoice*)nextLikelyClientChoice {
	// Available client choices, sorted by popularity,
	NSArray* availableClientChoices = [self availableClientChoicesIncludeWebApps:YES] ;
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
		// the WebAppNew/Other, OtherMacAccount, or LooseFile		
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
	
	return choice ;
}

- (BOOL)canAddAnotherClientChoice {
	BOOL answer = ([self nextLikelyClientChoice] != nil) ;
	return answer ;
}

- (IBAction)insertNextLikelyClient:(id)sender {
	Client* client = [self freshClientAtIndex:NSNotFound] ;
	ClientChoice* clientChoice = [self nextLikelyClientChoice] ;
	// if () added in BookMacster 5.1.4
	if (clientChoice) {
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

- (NSArray*)availableClientChoicesIncludeWebApps:(BOOL)includeWebApps {
	// Iterate through availableClientoids, wrap each clientoid in a ClientChoice,
	// and mark those which are in use
	NSArray* clientoidsInUse = [[self clientsOrdered] valueForKey:@"clientoid"] ;
	NSMutableArray* clientChoices = [[NSMutableArray alloc] init] ;
	NSArray* availableClientoids = [Clientoid allClientoidsForLocalAppsThisUserByPopularity:NO] ;
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
		for (NSString* exformat in [[NSApp delegate] supportedWebAppExformats]) {
			[clientChoices addObject:[ClientChoice clientChoiceNewOtherAccountForWebAppExformat:exformat]] ;
		}
	}	
	
	// Alphabetize to make look the menu look nice
	[clientChoices sortByStringValueForKey:@"displayName"] ;
	
	// Add the two "Advanced" choices at the bottom
	[clientChoices addObject:[ClientChoice clientChoiceInvolvingOtherMacAccount]] ;
	[clientChoices addObject:[ClientChoice clientChoiceInvolvingLooseFile]] ;
	
	NSArray* answer = [clientChoices copy] ;
	
	[clientChoices release] ;
	
	return [answer autorelease] ;
}

- (BOOL)fromUri:(NSString*)triggerOrAgentUri
	   getAgent:(Agent**)agent_p
	 getTrigger:(Trigger**)trigger_p
		error_p:(NSError**)error_p {
	BOOL ok = YES ;
	Agent* agent = nil ;
	Trigger* trigger = nil ;
	NSError* error = nil ;
	
	// The errors' localized descriptions should be short and sweet because
	// they are logged in the BookMacster log.  See
	// -[Macster, stageDoOverForUri:sponsorPid:], where "  Abort." is appended.
	if (!triggerOrAgentUri) {
		error = SSYMakeError(384000, @"No trigger or agent URI") ;
		ok = NO ;
		goto end ;
	}
	
	id agentOrTrigger = [[self managedObjectContext] objectWithUri:triggerOrAgentUri] ;
	if ([agentOrTrigger isKindOfClass:[Agent class]]) {
		agent = (Agent*)agentOrTrigger ;
		if (![agent isAvailable]) {
			// Presume the agent was deleted since the job was staged.
			error = SSYMakeError(constBkmxErrorRequestedAgentNotAvailable, @"Requested Agent not available.") ;
			ok = NO ;
			goto end ;
		}
		// This job is to be performed for all triggers.
		// Leave trigger=nil.
	}
	else if ([agentOrTrigger isKindOfClass:[Trigger class]]) {		
		trigger = (Trigger*)agentOrTrigger ;
		if (![trigger isAvailable]) {
			// Presume the agent was deleted since the job was staged.
			error = SSYMakeError(constBkmxErrorRequestedTriggerOrAgentNotAvailable, @"Requested Trigger or Agent not available.") ;
			ok = NO ;
			goto end ;
		}
		
		agent = [trigger agent] ;
		if (!agent) {
			// This should never happen, but just in case it does…
			error = SSYMakeError(constBkmxErrorTriggersAgentNotFound, @"Trigger's Agent not found.") ;
			ok = NO ;
			goto end ;
		}
		if (![agent isAvailable]) {
			// This should never happen, but just in case it does…
			error = SSYMakeError(constBkmxErrorTriggersAgentNotAvailable, @"Trigger's Agent not available.") ;
			ok = NO ;
			goto end ;
		}
	}
	else {
		error = SSYMakeError(constBkmxErrorCantFindTriggerNorAgent, @"Requested Trigger or Agent not found.") ;
		error = [error errorByAddingUserInfoObject:(triggerOrAgentUri ? triggerOrAgentUri : @"nil URI!")
											forKey:@"Looked for URI"] ;
		error = [error errorByAddingUserInfoObject:[self shortDescription]
											forKey:@"Macster"] ;
		NSMutableString* foundAgentsAndTriggers = [NSMutableString string] ;
		for (Agent* agent in [self agents]) {
			if ([foundAgentsAndTriggers length] > 0) {
				[foundAgentsAndTriggers appendString:@"\n"] ;
			}
			[foundAgentsAndTriggers appendString:[agent shortDescription]] ;
			for (Trigger* trigger in [agent triggers]) {
				[foundAgentsAndTriggers appendFormat:@"\n   %@", [trigger shortDescription]] ;
			}
		}
		error = [error errorByAddingUserInfoObject:foundAgentsAndTriggers
											forKey:@"Found agents and triggers string"] ;
		
		ok = NO ;
		goto end ;
	}
	
end:
	if (agent_p) {
		*agent_p = agent ;
	}
	if (trigger_p) {
		*trigger_p = trigger ;
	}
	if (error_p) {
		*error_p = error ;
	}
	
	return ok ;
}

- (NSString*)stageDoOverForAgent:(Agent*)agent
						 trigger:(Trigger*)trigger
					  sponsorPid:(NSNumber*)sponsorPid {
	NSString* result = @"Internal Error 624-0928" ;
	
	BOOL didSetNeedsImportAll = NO ;
	if (![Stager needsImportAllAgent:agent]) {
		[Stager setNeedsImportAllForAgent:agent] ;
		didSetNeedsImportAll = YES ;
	}
	
	NSError* saveError = nil ;
	BOOL ok = [[agent managedObjectContext] save:&saveError] ;
	if (!ok) {
		NSLog(@"Internal Error 025-9823 for %@ : %@", [self shortDescription], saveError) ;
	}
	
	if ([Stager isStagedAgent:agent]) {
		result = @"Staging do-over: Job already staged" ;
		if (didSetNeedsImportAll) {
			result = [result stringByAppendingString:@"; escalated to import all"] ;
		}
		else {
			result = [result stringByAppendingString:@" & already import all"] ;
		}
	}
	else {
		NSString* label = [[Stager launchdLabelForDocumentUuid:[self docUuid]
														 agent:agent
													   trigger:trigger] stringByAppendingPathExtension:constDoOver] ;
		if (label) {
			NSInteger pid ;
			if (sponsorPid) {
				pid = [sponsorPid integerValue] ;
			}
			else {
				pid = [[NSProcessInfo processInfo] processIdentifier] ;
			}
			NSString* pidString = [NSString stringWithFormat:@"%05ld", (long)pid] ;
			label = [label stringByAppendingPathExtension:pidString] ;
			NSString* uri = nil ;
			if (trigger) {
				uri = [trigger objectUriMakePermanent:YES
											   document:nil] ;
			}
			else {
				uri = [agent objectUriMakePermanent:YES
											 document:nil] ;
			}
			if (!uri) {
				NSLog(@"Internal Error 309-9285 %@ %@ :\n%@", [agent shortDescription], [trigger shortDescription], SSYDebugBacktrace()) ;
			}
			NSError* error = nil ;
			NSDictionary* dic = [Stager stageType:BkmxAgentLabelTransientSubtypeDoOver
											label:label
										  docUuid:[self docUuid]
											  uri:uri
									   sponsorPid:sponsorPid
										  macster:self
										  error_p:&error] ;
			if (dic) {
				result = [NSString stringWithFormat:
						  @"Staged doOver job to run at next :%02ld",
						  (long)[[[dic objectForKey:@"StartCalendarInterval"] objectForKey:@"Minute"] integerValue]] ;
			}
			else {
				result = @"Internal Error 250-0892 scheduling doOver" ;
				NSLog(@"%@.  %@", result, [error longDescription]) ;
			}
		}
		else {
			result = @"Agent no longer available: Forgetting" ;
		}
	}
		
#if 0
    // Added in BookMacster 1.12.6, to fix bug that, after fixing Bug 20121126,
    // now sometimes the *first* bookmark added would be deleted.
    for (Client* client in [self clients]) {
        [[client importer] setLastHash:nil] ;
    }
    ok = [[self managedObjectContext] save:&saveError] ;
    if (!ok) {
        NSLog(@"Error 229850 saving %@ for %@: %@",
              [self managedObjectContext],
              [self shortDescription],
              [saveError longDescription]) ; // Added in BookMacster 1.11
    }
#endif
    
    return result ;
}

- (NSString*)stageDoOverForUri:(NSString*)uri
					sponsorPid:(NSNumber*)sponsorPid {
	if (!uri) {
		NSLog(@"Internal Error 309-1688 %@\n%@", uri, SSYDebugBacktrace()) ;
	}
	
	NSError* error = nil ;
	Agent* agent = nil ;
	Trigger* trigger = nil ;
	BOOL ok = [self fromUri:uri
				   getAgent:&agent
				 getTrigger:&trigger
					error_p:&error] ;
	NSString* result ;
	if (ok) {
		result = [self stageDoOverForAgent:agent
								   trigger:trigger
								sponsorPid:sponsorPid] ;
	}
	else {
		result = [[error localizedDescription] stringByAppendingString:@"  Abort."] ;
	}
	
	return result ;
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
			@"self.importers",
			nil] ;
}

// This method is bound to by a control in the document's window > Settings > Open/Save
- (NSString*)toolTipAutoExport {
	return [NSString localizeFormat:
			@"imex_autoExportTT",
			[self readableExportsListMaxCharacters:512]] ;
}

+ (NSSet*)keyPathsForValuesAffectingToolTipAutoExport {
	return [NSSet setWithObjects:
			@"self.exporters",
			nil] ;
}

- (void)upgradeTriggers:(NSArray*)triggers
				 reveal:(BOOL)reveal {
	if (reveal) {
		[[self bkmslf] revealTabViewIdentifier:constIdentifierTabViewAgents] ;
		sleep(1) ;
		[[SSYAlertSounder sharedSounder] playAlertSoundNamed:@"Pop"] ;
	}
	
	for (Trigger* trigger in triggers) {
		[trigger setTriggerTypeValue:BkmxTriggerSawChange] ;
	}

	[self save] ;
}

@end



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
 
 #0	0x00122961 in -[Bkmslf setUndoActionNameForAction:object:objectKey:updatedKey:count:] at Bkmslf.m:2928
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