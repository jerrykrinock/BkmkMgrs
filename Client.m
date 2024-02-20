#import "BkmxGlobals.h"
#import "NSError+MyDomain.h"
#import "NSError+SSYInfo.h"
#import "NSError+DecodeCodes.h"
#import "NSError+Recovery.h"
#import "BkmxDoc.h"
#import "Macster.h"
#import "Client.h"
#import "ClientoidPlus.h"
#import "Starker.h"
#import "NSDate+SafeCompare.h"
#import "BkmxDocumentController.h"
#import "SSYSystemDescriber.h"
#import "NSError+InfoAccess.h"
#import "NSData+FileAlias.h"
#import "NSUserDefaults+KeyPaths.h"
#import "NSString+LocalizeSSY.h"
#import "NSNumber+Sharype.h"
#import "Importer.h"
#import "ExtoreWebFlat.h"
#import "NSSet+SimpleMutations.h"
#import "NSString+BkmxDisplayNames.h"
#import "BkmxAppDel+Capabilities.h"
#import "NSNumber+SomeMore.h"
#import "BkmxBasis+Strings.h"
#import "NSWorkspace+AppleShoulda.h"
#import "SSYLabelledList.h"
#import "NSData+SockAddr.h"
#import "NSInvocation+Quick.h"
#import "SSYProgressView.h"
#import "SSYLabelledRadioButtons.h"
#import "NSDictionary+SimpleMutations.h"
#import "NSUserDefaults+MainApp.h"
#import "WebAuthorizor.h"
#if CONFIGURE_PREFERRED_CATCHYPE_BASED_ON_CLIENT
#import "Exporter.h"
#endif

#if (MAC_OS_X_VERSION_MIN_REQUIRED >= 1060)
#define CAN_USE_OBJECTIVE_C_BLOCKS 1
#else
#define CAN_USE_OBJECTIVE_C_BLOCKS 0
#endif

NSString* const constKeyImporter = @"importer" ;
NSString* const constKeyExporter = @"exporter" ;
NSString* const constKeyExtorageAlias = @"extorageAlias" ;
NSString* const constKeyExtoreMedia = @"extoreMedia" ;
NSString* const constKeyLastImported = @"lastImported" ;
NSString* const constKeyLastKnownTouch = @"lastKnownTouch" ;
NSString* const constKeyProfileNameAlternate = @"profileNameAlternate" ;
NSString* const constKeyVolumePath = @"volumePath" ;

NSString* const constKeyLooseExformats = @"exformats" ;
NSString* const constKeyLabelledRadioButtons = @"labRadButts" ;
NSString* const constKeyLooseLabelledList = @"labList" ;

@interface Client (CoreDataGeneratedAccessors)

- (NSString*)primitiveExformat ;
- (void)setPrimitiveExformat:(NSString*)value ;
- (NSData*)primitiveExtorageAlias ;
- (void)setPrimitiveExtorageAlias:(NSData*)value ;
- (NSString*)primitiveExtoreMedia ;
- (void)setPrimitiveExtoreMedia:(NSString*)value ;
- (NSString*)primitiveExporter ;
- (void)setPrimitiveExporter:(Ixporter*)value ;
- (NSString*)primitiveImporter ;
- (void)setPrimitiveImporter:(Ixporter*)value ;
- (void)setPrimitiveIndex:(NSNumber*)value;
- (NSDate*)primitiveLastImported ;
- (void)setPrimitiveLastImported:(NSDate*)value ;
- (NSDate*)primitiveLastKnownTouch ;
- (void)setPrimitiveLastKnownTouch:(NSDate*)value ;
- (NSString*)primitiveProfileName ;
- (void)setPrimitiveProfileName:(NSString*)value ;
- (NSString*)primitiveProfileNameAlternate ;
- (void)setPrimitiveProfileNameAlternate:(NSString*)value ;
- (Macster*)primitiveMacster ;
- (void)setPrimitiveMacster:(Macster*)value ;
- (NSNumber*)primitiveSpecialOptions ;
- (void)setPrimitiveSpecialOptions:(NSNumber*)value;

- (NSMutableSet*)primitiveTriggers ;
- (void)setPrimitiveTriggers:(NSMutableSet*)value ;

@end

@interface Client ()

@end

@implementation Client

+ (NSSet*)extoringKeyPaths {
	return [NSSet setWithObjects:
			constKeyExformat,
			constKeyExtorageAlias,
			constKeyExtoreMedia,
			constKeyProfileName,
			nil] ;
}

@synthesize nuevoPath = m_nuevoPath ;
@synthesize serverPassword = m_serverPassword ;
@synthesize waitingInvocation = m_waitingInvocation ;
@synthesize willSelfDestruct = m_willSelfDestruct ;
@synthesize willOverlay = m_willOverlay ;
@synthesize willIgnoreLimit = m_willIgnoreLimit ;
@synthesize clientFileExistence ;
@synthesize webAuthorizor = m_webAuthorizor;

- (NSMutableSet*)freshUnexportedDeletions {
	if (!m_freshUnexportedDeletions) {
		m_freshUnexportedDeletions = [[NSMutableSet alloc] init] ;
	}
	
	return m_freshUnexportedDeletions ;
}

- (void)postUnexportedDeletionsNeedsRoll {
	NSNotification* notification = [NSNotification notificationWithName:constNoteBkmxMacsterDidChange
																 object:self] ;
	[[NSNotificationQueue defaultQueue] enqueueNotification:notification
											   postingStyle:NSPostWhenIdle
											   coalesceMask:(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
												   forModes:nil] ;
	// See "Note on Coalesce Mask" at bottom of SSYOperationQueue.m
}

/*!
 @param   deletion  An exid
 */
- (void)addUnexportedDeletion:(NSString*)deletion {
	[[self freshUnexportedDeletions] addObject:deletion] ;
	
	[self postUnexportedDeletionsNeedsRoll] ;
}

- (void)clearUnexportedDeletions {
	[[self freshUnexportedDeletions] removeAllObjects] ;
	
	[self postUnexportedDeletionsNeedsRoll] ;
}

- (void)rollUnexportedDeletions {
	NSMutableSet* newDeletions = [self freshUnexportedDeletions] ;
	if ([newDeletions count] > 0) {
		NSSet* oldSet = [self unexportedDeletions] ;
		NSSet* newSet ;
		if (oldSet) {
			newSet = [oldSet setByAddingObjectsFromSet:newDeletions] ;
		}
		else {
			newSet = newDeletions ;
		}
        NSSet* copy = [newSet copy];
		[self setUnexportedDeletions:copy];
        [copy release];
	}
	else {
		[self setUnexportedDeletions:nil] ;
	}
	
	[[self macster] postTouchedClient:self
							 severity:1] ;
}

- (NSData *)extorageAlias {
    NSData * tmpValue;
    
    [self willAccessValueForKey:@"extorageAlias"];
    tmpValue = [self primitiveExtorageAlias];
    [self didAccessValueForKey:@"extorageAlias"];
    
    return tmpValue;
}

- (BkmxDoc*)bkmxDoc {
	// This happens if an error occurs while configuring a new
	// Other Macintosh Account (Advanced) or Choose File (Advanced) client,
	// I do [[self bkmxDoc] alertError:] and then [self abandon].  Apparently,
	// one of the error recovery method invokes [self bkmxDoc]
	// for some reason, while self is a fault.  If we didn't return here,
    // it would raise one of those
	// ugly Core Data "could not fulfill a fault" exceptions.
	if ([self isFault]) {
		return nil ;
	}
	
	return [[self macster] bkmxDoc] ;
}

- (void)abandon {
	// Defensive programming, in case I haven't fixed some corner case where
	// this method tries to execute twice while abandoning the same instance.
	if ([self isFault]) {
		NSLog(@"Internal Error 941-3648") ;
		return ;
	}
	
	[self setWaitingInvocation:nil] ;
	
	Macster* macster = [self macster] ;
	BkmxDoc* bkmxDoc = [macster bkmxDoc] ;
	NSString* uuid = [bkmxDoc uuid] ;
	[self retain] ;
	[macster removeClientsObject:self] ;
	[[self managedObjectContext] deleteObject:self] ;
	[[BkmxBasis sharedBasis] saveSettingsMocForIdentifier:uuid] ;
	[self release] ;
}

- (void)invokeWaitingInvocation {
	[[self waitingInvocation] invoke] ;
	[self setWaitingInvocation:nil] ;
}

#pragma mark * Core Data Generated Accessors for managed object properties

// Identifier Parts
@dynamic exformat ;
@dynamic extoreMedia ;
@dynamic profileName ;
@dynamic extorageAlias ;

// Additional Data
@dynamic profileNameAlternate ;
@dynamic triggers ;
@dynamic index ;
@dynamic importer ;
@dynamic exporter ;
@dynamic macster ;

// User settings
@dynamic specialOptions;
@dynamic specialDouble0;
@dynamic specialDouble1;
@dynamic specialDouble2;

// Timestamps
// @dynamic lastExported // Starting in BookMacster 1.1 this is in User Defaults
@dynamic lastImported ;
@dynamic lastKnownTouch ;

@dynamic failedLastExport ;
#if 0
#warning Logging Debug Extras for Client
/*- (id)retain {
 id x = [super retain] ;
 NSLog(@"213033: After retain, rc=%d", [self retainCount]) ;
 return x ;
 }
 - (id)autorelease {
 id x = [super autorelease] ;
 NSLog(@"211008: After autorelease, rc=%d", [self retainCount]) ;
 return x ;
 }
 - (oneway void)release {
 NSInteger rc = [self retainCount] ;
 [super release] ;
 NSLog(@"213300: After release, rc=%d", rc-1) ;
 return ;
 }
 - (void)dealloc {
 NSLog(@"%s", [self retainCount]) ;
 [super dealloc] ;
 }
 */
#endif

- (void)willTurnIntoFault {
	[[NSNotificationCenter defaultCenter] postNotificationName:SSYManagedObjectWillFaultNotification
														object:self] ;
	
	[super willTurnIntoFault] ;
}

- (void)didTurnIntoFault {
	[[NSNotificationCenter defaultCenter] removeObserver:self] ;
    
	[super didTurnIntoFault] ;
}

- (void)dealloc {
    [m_serverPassword release] ;
    [m_waitingInvocation release] ;
    [m_freshUnexportedDeletions release] ;
    [m_nuevoPath release] ;
    [m_webAuthorizor release];

    [super dealloc] ;
}

- (void)makeWebAuthorizorIfNeeded {
    WebAuthorizor* webAuthorizor = [[WebAuthorizor alloc] init];
    webAuthorizor.client = self;
    self.webAuthorizor = webAuthorizor;
    [webAuthorizor release];
}

- (void)setExformat:(NSString*)value {
    [self willChangeValueForKey:constKeyExformat] ;
    [self setPrimitiveExformat:value];
    [self didChangeValueForKey:constKeyExformat] ;
    
    [self makeWebAuthorizorIfNeeded];

	NSInteger severity = (value != nil) ? 5 : 4 ;
	[[self macster] postTouchedClient:self
							 severity:severity] ;
	
	// Defensive programming added in BookMacster version 1.3.15.  If a client
	// is still "Under Construction", its extoreClass will be nil.
	Class class = [self extoreClass] ;
	long long defaultSpecialOptions = 0x0;
    NSArray* specialDoubles = nil;
    if (class) {
		defaultSpecialOptions = [class constants_p]->defaultSpecialOptions ;
        if ([class respondsToSelector:@selector(defaultSpecialDoubles)]) {
            specialDoubles = [class defaultSpecialDoubles];
        }
        
#if CONFIGURE_PREFERRED_CATCHYPE_BASED_ON_CLIENT
       [[self exporter] configurePreferredCatchypeForExtoreClass:class];
#endif
    }
    
	// Do not do this via notification because it should only be done
	// when the exformat is changed; don't want to wipe out non-default
	// values which a user has set.
	self.specialOptions = [NSNumber numberWithLongLong:defaultSpecialOptions];
    self.specialDouble0 = [specialDoubles objectAtIndex:0];
    self.specialDouble1 = [specialDoubles objectAtIndex:1];
    self.specialDouble2 = [specialDoubles objectAtIndex:2];
}

- (void)setExtorageAlias:(NSData*)value {
    [self willChangeValueForKey:constKeyExtorageAlias] ;
    [self setPrimitiveExtorageAlias:value];
    [self didChangeValueForKey:constKeyExtorageAlias] ;
	
	NSInteger severity = (value != nil) ? 5 : 4 ;
	[[self macster] postTouchedClient:self
							 severity:severity] ;
}

- (void)setExtoreMedia:(NSString*)value {
    [self willChangeValueForKey:constKeyExtoreMedia] ;
    [self setPrimitiveExtoreMedia:value];
    [self didChangeValueForKey:constKeyExtoreMedia] ;
	
	NSInteger severity = (value != nil) ? 5 : 4 ;
	[[self macster] postTouchedClient:self
							 severity:severity] ;
}

- (void)setIndex:(NSNumber*)newValue  {
	[self willChangeValueForKey:constKeyIndex] ;
    [self setPrimitiveIndex:newValue] ;
    [self didChangeValueForKey:constKeyIndex] ;
	
	[[self macster] postTouchedClient:self
							 severity:3] ;
}

- (void)setLastImported:(NSDate*)value {
	[[self importer] setIxportCount:[[[self importer] ixportCount] plus1]] ;
	
	[self postWillSetNewValue:value
					   forKey:constKeyLastImported] ;
    [self willChangeValueForKey:constKeyLastImported] ;
    [self setPrimitiveLastImported:value];
    [self didChangeValueForKey:constKeyLastImported] ;
}

- (void)setLastKnownTouch:(NSDate*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyLastKnownTouch] ;
    [self willChangeValueForKey:constKeyLastKnownTouch] ;
    [self setPrimitiveLastKnownTouch:value];
    [self didChangeValueForKey:constKeyLastKnownTouch] ;
}

- (void)setProfileName:(NSString*)value {
    [self willChangeValueForKey:constKeyProfileName] ;
    [self setPrimitiveProfileName:value];
    [self didChangeValueForKey:constKeyProfileName] ;
	
	NSInteger severity = (value != nil) ? 5 : 4 ;
	[[self macster] postTouchedClient:self
							 severity:severity] ;
}

- (void)setProfileNameAlternate:(NSString*)value {
    [self willChangeValueForKey:constKeyProfileNameAlternate] ;
    [self setPrimitiveProfileNameAlternate:value];
    [self didChangeValueForKey:constKeyProfileNameAlternate] ;
	
	NSInteger severity = (value != nil) ? 5 : 4 ;
	[[self macster] postTouchedClient:self
							 severity:severity] ;
}

- (void)setSpecialOptions:(NSNumber*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeySpecialOptions] ;
	[self willChangeValueForKey:constKeySpecialOptions] ;
    [self setPrimitiveSpecialOptions:newValue] ;
    [self didChangeValueForKey:constKeySpecialOptions] ;
	
	[[self macster] postTouchedClient:self
							 severity:3] ;
}

- (void)setIfLaterLastKnownTouch:(NSDate*)proposedDate {
	[self setLastKnownTouch:[NSDate laterDate:self.lastKnownTouch
										 date:proposedDate]] ;
}

- (void)postWillSetNewTriggers:(NSSet*)newValue {
	[self postWillSetNewValue:newValue
					   forKey:constKeyTriggers] ;
}

- (void)setTriggers:(NSSet*)value {    
	[self postWillSetNewTriggers:value] ;
	
    [self willChangeValueForKey:constKeyTriggers];
    [self setPrimitiveTriggers:[NSMutableSet setWithSet:value]];
    [self didChangeValueForKey:constKeyTriggers];
}

- (void)addTriggersObject:(Trigger*)value {    
	[self postWillSetNewTriggers:[[self triggers] setByAddingObject:value]] ;
	
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyTriggers withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveTriggers] addObject:value];
    [self didChangeValueForKey:constKeyTriggers withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)removeTriggersObject:(Trigger*)value {
	[self postWillSetNewTriggers:[[self triggers] setByRemovingObject:value]] ;
	
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyTriggers withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveTriggers] removeObject:value];
    [self didChangeValueForKey:constKeyTriggers withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)addTriggers:(NSSet*)value {    
	[self postWillSetNewTriggers:[[self triggers] setByAddingObjectsFromSet:value]] ;
	
    [self willChangeValueForKey:constKeyTriggers withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveTriggers] unionSet:value];
    [self didChangeValueForKey:constKeyTriggers withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTriggers:(NSSet *)value {
	[self postWillSetNewTriggers:[[self triggers] setByRemovingObjectsFromSet:value]] ;
	
    [self willChangeValueForKey:constKeyTriggers withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveTriggers] minusSet:value];
    [self didChangeValueForKey:constKeyTriggers withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

@dynamic unexportedDeletions ;

#pragma mark * Accessors for non-managed object properties

#pragma mark * Derived Attributes

- (NSInteger)indexValue {
	return [[self index] integerValue] ;
}

- (Clientoid*)clientoid {
    return [Clientoid clientoidWithExformat:[self exformat]
								profileName:[self profileName]
								extoreMedia:[self extoreMedia]
							  extorageAlias:[self extorageAlias]
                                       path:[self nuevoPath]] ;
}

- (BOOL)isEqualToClient:(Client*)otherClient {
	BOOL answer = [[self clientoid] isEqual:[otherClient clientoid]] ;
	return answer ;
}

- (NSString *)homePath {
    return [[self clientoid] homePath] ;
}

- (Class)extoreClass {
	return [[self clientoid] extoreClass] ;
}

- (NSString*)webHostName {
	return [[self extoreClass] webHostName] ;
}

- (NSString*)displayName {
	return [[self clientoid] displayName] ;
}

- (NSString*)displayNameWithoutProfile {
	return [[self clientoid] displayNameWithoutProfile] ;
}


+ (NSSet*)keyPathsForValuesAffectingDisplayName {
	return [self extoringKeyPaths] ;
}



- (NSString*)longDisplayName {
	NSString* longDisplayName ;
	
	NSData* fileAlias = [self extorageAlias] ;
	if (fileAlias) {
		longDisplayName = [NSString stringWithFormat:
						   @"%@\n\n%@: %@",
						   [[self clientoid] pathFromResolvedAlias],
						   [NSString localize:@"fileFormat"],
						   [[self exformat] exformatDisplayName]] ;
	}
	else {
		// Todo: We could do better than this ...
		longDisplayName = [[self clientoid] clidentifier] ;
	}
	
	return longDisplayName ;
}

- (NSArray*)keyPathArrayForLastLocalMocSync {
	return [NSArray arrayWithObjects:
			constKeyLocalMocSyncs,
			[[self clientoid] clidentifier],
			nil] ;
}

- (NSDate*)lastLocalMocSync {
	return [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKeyPathArray:[self keyPathArrayForLastLocalMocSync]] ;
}

- (void)setLastLocalMocSync:(NSDate*)date {
	[[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:date
                                                  forKeyPathArray:[self keyPathArrayForLastLocalMocSync]] ;
}

- (NSString*)ownerAppFullPathError_p:(NSError**)error_p {
	return [[self clientoid] ownerAppFullPathError_p:error_p] ;
}

- (BOOL)hasOrder {
	// If a client is still "Under Construction", its extoreClass will be nil.
	Class class = [self extoreClass] ;
	BOOL answer ;
	if (class) {
		answer = [class constants_p]->hasOrder ;
	}
	else {
		answer = NO ;
	}
	
	return answer ;
}

- (BOOL)hasFolders {
	// If a client is still "Under Construction", its extoreClass will be nil.
	Class class = [self extoreClass] ;
	BOOL answer ;
	if (class) {
		answer = [class constants_p]->hasFolders ;
	}
	else {
		answer = NO ;
	}
	
	return answer ;
}

- (NSString*)filePathError_p:(NSError**)error_p {
    NSString* path = [[self clientoid] filePathError_p:error_p] ;
    if (!path) {
        path = [self nuevoPath] ;
    }
	return path ;
}

- (NSString*)filePathParentError_p:(NSError**)error_p {	
	return [[self clientoid] filePathParentError_p:error_p] ;
}

- (NSString*)sawChangeTriggerPath {
	return [[self clientoid] sawChangeTriggerPath] ;
}

- (void)setExtorageAliasFromFilePath {
	NSString* filePath = [self filePathError_p:NULL] ;
	NSData* aliasRecord = [NSData aliasRecordFromPath:filePath] ;
	[self setExtorageAlias:aliasRecord] ;
}

- (NSString*)defaultFilename {
	return [[self clientoid] defaultFilename] ;
}

- (BOOL)canEditIsShared {
	Class extoreClass = [self extoreClass] ;
	// Defensive programming added in BookMacster version 1.3.15.  If a client
	// is still "Under Construction", its extoreClass will be nil.
	BOOL answer ;
	if (extoreClass) {
		answer = [extoreClass constants_p]->canEditIsShared ;
	}
	else {
		answer = NO ;
	}
	
	return answer ;
}

- (BOOL)canEditTagsInStyle:(NSInteger)style {
    return [[self extoreClass] canEditTagsInStyle:style];
}

- (BOOL)canEditTagsInAnyStyle {
    return [[self extoreClass] canEditTagsInAnyStyle];
}

- (BOOL)supportsSeparators {
	return [[self extoreClass] canEditSeparatorsInAnyStyle];
}

- (SSYVersionTriplet*)minBrowserVersion {
	Class extoreClass = [self extoreClass] ;
	// Defensive programming added in BookMacster version 1.3.15.  If a client
	// is still "Under Construction", its extoreClass will be nil.
	SSYVersionTriplet* answer = nil ;
	if (extoreClass) {
		const ExtoreConstants* constants_p = [extoreClass constants_p] ;
		answer = SSYMakeVersionTriplet(
									   constants_p->minBrowserVersionMajor,
									   constants_p->minBrowserVersionMinor,
									   constants_p->minBrowserVersionBugFix
									   ) ;
	}
	
	return answer ;
}

- (SSYVersionTriplet*)minSystemVersionForMinBrowserVersion {
	Class extoreClass = [self extoreClass] ;
	// Defensive programming added in BookMacster version 1.3.15.  If a client
	// is still "Under Construction", its extoreClass will be nil.
	SSYVersionTriplet* answer = nil ;
	if (extoreClass) {
		const ExtoreConstants* constants_p = [extoreClass constants_p] ;
		answer = SSYMakeVersionTriplet(
									   constants_p->minSystemVersionForBrowsMajor,
									   constants_p->minSystemVersionForBrowsMinor,
									   constants_p->minSystemVersionForBrowsBugFix
									   ) ;
	}
	
	return answer ;
}

- (BOOL)browserInstalledIsOkError_p:(NSError**)error_p {
	BOOL ok = YES ;
	
	if ([[self extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
		SSYVersionTriplet* minBrowserVersion = [self minBrowserVersion] ;
		NSInteger errCode = 0 ;
		NSString* msg ;
		if (minBrowserVersion) {
			Class extoreClass = [self extoreClass] ;
			NSString* bbi = nil ;
			// Defensive programming added in BookMacster version 1.3.15.  If a client
			// is still "Under Construction", its extoreClass will be nil.
			if (extoreClass) {
				bbi = [[extoreClass browserBundleIdentifiers] firstObject] ;
			}
			
			SSYVersionTriplet* browserVersion = [SSYVersionTriplet versionTripletFromBundleIdentifier:bbi] ;
			
			if (browserVersion) {
				if ([browserVersion isEarlierThan:minBrowserVersion]) {
					ok = NO ;
					errCode = constBkmxErrorBrowserTooOld ;
					msg = [NSString stringWithFormat:
						   @"Possibly %@ version is too old.\n  Required by this app: %@\n  Found: %@",
						   [self exformat],
						   [minBrowserVersion string],
						   [browserVersion string]] ;
					SSYVersionTriplet* minSystemVersion = [self minSystemVersionForMinBrowserVersion] ;
					if (minSystemVersion) {
						SSYVersionTriplet* systemVersion = [SSYSystemDescriber softwareVersionTriplet] ;
						if ([systemVersion isEarlierThan:minSystemVersion]) {
							msg = [msg stringByAppendingString:@"\n\n"] ;
							msg = [msg stringByAppendingString:[NSString localizeFormat:@"requiresVersion%0%1%2%3",
																[self exformat],
																[minBrowserVersion string],
																@"Mac OS",
																[systemVersion string]]] ;
						}
					}
				}
			}
			else {
				ok = NO ;
				errCode = constBkmxErrorCantFindIt ;
				msg = [NSString stringWithFormat:@"Weird.  Cannot confirm installed version of %@", [self exformat]] ;
			}
		}
		
		if (!ok && error_p != NULL) {
			*error_p = SSYMakeError(errCode, msg) ;	
		}		
	}
	
	return ok ;
}

- (NSString*)labelAdvancedSettings {
	return [NSString stringWithFormat:
			@"%@ : %@ : %@",
			[[BkmxBasis sharedBasis] labelClient],
			[self displayName],
			[[BkmxBasis sharedBasis] labelAdvancedSettings]] ;
}

- (NSString*)labelTalderMaps {
	return [NSString stringWithFormat:
			@"%@ : %@ : %@",
			[[BkmxBasis sharedBasis] labelClient],
			[self displayName],
			[[BkmxBasis sharedBasis] labelTalderMaps]] ;
}

- (NSArray*)availablePolaritiesForFolderMaps {
    NSMutableArray* polarities = [[NSMutableArray alloc] init] ;
    // On import, client must have folders to map from
    if ([self hasFolders]) {
        [polarities addObject:[NSNumber numberWithBool:BkmxIxportPolarityImport]] ;
    }
    // On export, client must have to to map to
    if ([self canEditTagsInAnyStyle]) {
        [polarities addObject:[NSNumber numberWithBool:BkmxIxportPolarityExport]] ;
    }
    
    NSArray* answer = [polarities copy] ;
    [polarities release] ;
    return [answer autorelease] ;
}

- (NSArray*)availablePolaritiesForTagMaps {
    NSMutableArray* polarities = [[NSMutableArray alloc] init] ;
    // On import, client must have tags to map from
    if ([self canEditTagsInAnyStyle]) {
        [polarities addObject:[NSNumber numberWithBool:BkmxIxportPolarityImport]] ;
    }
    // On export, client must have to to folders into
    if ([self hasFolders]) {
        [polarities addObject:[NSNumber numberWithBool:BkmxIxportPolarityExport]] ;
    }
    
    NSArray* answer = [polarities copy] ;
    [polarities release] ;
    return [answer autorelease] ;
}

#pragma mark * Basic Infrastructure

- (Ixporter*)freshIxporterSubentityName:(NSString*)subentityName {
	// Put in same managed object context
	NSManagedObjectContext *moc = [self managedObjectContext] ;
	
	Ixporter* ixporter = [NSEntityDescription insertNewObjectForEntityForName:subentityName
													   inManagedObjectContext:moc] ;
	
	return ixporter ;
}

- (void)initializeObservers {
}

- (void)awakeCommon {
	[self initializeObservers] ;
    [self makeWebAuthorizorIfNeeded];
}

- (void)awakeFromFetch {
	[super awakeFromFetch] ;
	
	// Documentation states that relationships shold not be altered during
	// -awakeFromFetch,but that is an understatement.  In fact, altering
	// attributes such as specialOptions does not work either.  The problem
	// is that, although the value in memory gets changed OK, it usually
	// does not get saved when the managed object context is saved.
	// If you want to alter an attribute in here, use 
	// -performSelector:withObject:afterDelay:.
	
	[self awakeCommon] ;
}

- (void)awakeFromInsert {
	[super awakeFromInsert] ;
	
	[self setImporter:(Importer*)[self freshIxporterSubentityName:constEntityNameImporter]] ;
	[self setExporter:(Exporter*)[self freshIxporterSubentityName:constEntityNameExporter]] ;
	
	[self awakeCommon] ;
}

// From NSManagedObject documentation: "You are discouraged from overriding
// description ... if this method fires a fault during a debugging
// operation, the results may be unpredictable.
- (NSString*)shortDescription {
	
	NSString* desc = [NSString stringWithFormat:
					  @"<Client %p i=%ld %c%c '%@'>",
					  self,
					  (long)[self indexValue],
					  [[(Ixporter*)[self importer] isActive] boolValue] ? 'I' : '_',
					  [[(Ixporter*)[self exporter] isActive] boolValue] ? 'E' : '_',
					  [self clientoid]] ;
	return desc ;
}

- (uint32_t)exportHashFromBkmxDoc:(BkmxDoc*)bkmxDoc {
	// Note: [bkmxDoc starker] gives current content of bkmxDoc which is to be exported to the client.
	uint32_t contentHash = [bkmxDoc contentHash] ;
	uint32_t settingsHash = [[self exporter] valuesHash] ;
	
    /* Use bitwise XOR instead of addition because overflowed integer addition
     is undefined in C. */
	return (contentHash ^ settingsHash) ;
}


#pragma mark * Setting a Client Choice / Ivars / Clientoid

- (void)updateIxportersForNewAttributes {
	// Allow the first import or export with the new Client to be unlimited
	[[self importer] setIxportCount:[NSNumber numberWithInteger:0]] ;
	[[self exporter] setIxportCount:[NSNumber numberWithInteger:0]] ;
	
	// Validate and, if necessary, change other attributes

    if (![self hasFolders]) {
        // Set back to default value
		[[self exporter] setFabricateFolders:[NSNumber numberWithBool:NO]] ;
	}

    if (![self canEditTagsInAnyStyle]) {
        // Set back to default value
		[[self exporter] setFabricateTags:[NSNumber numberWithBool:NO]] ;
	}

    /* This one we need to be a little more aggressive with, because, when
     creating a new client with the popup, because of what cah happen if
     a browser which is higher in popularity is changed by the user to a
     browser which is lower in populaity.  For example, say that the document
     has one client, Safari, and the user adds a new client in BookMacster's
     Settings > Clients or Synkmark's Preferences > Syncing.  The popup will 
     initially show the next most popular browser, Chrome, and this method
     will run, and because Chrome does not support separators, the exporter's
     skipSeparators will be set to NSNumber YES.  Now say that the user 
     immediately changes it to Firefox, which supports separators.  This method
     will run again, and the first branch must execute to set the exporter's
     skipSeparators back to NSNumber NO. */
    if ([self supportsSeparators]) {
        [[self exporter] setSkipSeparators:[NSNumber numberWithBool:NO]] ;
    }
    else {
		[[self exporter] setSkipSeparators:[NSNumber numberWithBool:YES]] ;
	}
	
	[[self importer] doMergeByBusinessLogic] ;
	[[self exporter] doMergeByBusinessLogic] ;
}

- (void)setIvarsThenInvokeWaitingIfAnyLikeClientoid:(Clientoid*)clientoid {
	if ([[self clientoid] isEqual:clientoid]) {
		return ;
	}
	
	[self setExformat:[clientoid exformat]] ;
	[self setProfileName:[clientoid profileName]] ;
	[self setExtoreMedia:[clientoid extoreMedia]] ;
	[self setExtorageAlias:[clientoid extorageAlias]] ;
    [self setNuevoPath:[clientoid path]] ;

	// Fixed in BookMacster 1.7/1.6.8
	[self setServerPassword:nil] ;
	
	if ([[self extoreMedia] isEqualToString:constBkmxExtoreMediaLoose]) {
		[self setExtorageAliasFromFilePath] ;
	}
	
	[self updateIxportersForNewAttributes] ;
	
	// Needed for Quickie clients
	[self invokeWaitingInvocation] ;
}

- (void)setLikeClientoidPlus:(ClientoidPlus*)clientoidPlus {
	[self setIvarsThenInvokeWaitingIfAnyLikeClientoid:[clientoidPlus clientoid]] ;
	
	[[self importer] setIsActive:[NSNumber numberWithBool:[clientoidPlus doImport]]] ;
	[[self exporter] setIsActive:[NSNumber numberWithBool:[clientoidPlus doExport]]] ;
	
	// We don't copy the clientoidPlus's index
}


- (void)setLikeClientChoice:(ClientChoice*)clientChoice {
	Clientoid* clientoid = [clientChoice clientoid] ;
	
	if (clientoid) {
        [self setIvarsThenInvokeWaitingIfAnyLikeClientoid:clientoid] ;
	}
	else if ([clientChoice selector] != NULL) {
		// WebAppNew/Other or LooseFile item was selected
		[self performSelector:[clientChoice selector]
				   withObject:[clientChoice object]] ;
	}
}

- (void)chooseClientSheetDidEnd:(NSWindow*)sheet
					 returnCode:(NSInteger)returnCode
					contextInfo:(NSArray*)clientoids {
	if (returnCode == NSAlertFirstButtonReturn) {
		SSYAlert* alert = (SSYAlert*)[sheet windowController] ;
		SSYLabelledList* labelledList = [[alert otherSubviews] objectAtIndex:0] ;
		NSInteger selectedIndex = [[labelledList selectedIndexes] firstIndex] ;
		if (selectedIndex < [clientoids count]) {
			Clientoid* clientoid = [clientoids objectAtIndex:selectedIndex] ;
			[self setIvarsThenInvokeWaitingIfAnyLikeClientoid:clientoid] ;
		}
	}
	else {
		[self abandon] ;
	}
	
	[clientoids release] ;
}

- (void)chooseLooseBasicsPanelDidEnd:(NSWindow*)sheet
						  returnCode:(NSInteger)returnCode
						 contextInfo:(NSDictionary*)info {
	[info autorelease] ;
	
	if (returnCode == NSAlertSecondButtonReturn) {
		[self setWaitingInvocation:nil] ;  // Needed to break retain cycle
		[self abandon] ;
		return ;
	}
	
	// Unpack the info dictionary
	NSArray* exformats = [info objectForKey:constKeyLooseExformats] ;
	SSYLabelledRadioButtons* buttons = [info objectForKey:constKeyLabelledRadioButtons] ;
	SSYLabelledList* list = [info objectForKey:constKeyLooseLabelledList] ;
	
	NSString* exformat = [exformats objectAtIndex:[[list selectedIndexes] firstIndex]] ;
	NSString* fileType = nil ;
	fileType = ([[Extore extoreClassForExformat:exformat] constants_p] -> fileType) ;
	// Note: fileType is nil for OmniWeb ==> requires a directory.
	
	BOOL wantsNewFile = NO ;
	if (buttons) {
		wantsNewFile = ([buttons selectedIndex] == 0) ;
	}
	
	NSString* buttonTitle = [NSString localize:@"choose"] ;
	NSWindow* documentWindow = [(NSWindowController*)[[self bkmxDoc] bkmxDocWinCon] window] ;
	NSString* message ;
	
	// Now we need to use either a Save Panel or an Open Panel.
	// We have three binary variables:
	//   Importing vs. Exporting
	//   New vs. Existing
	//   Regular File vs. Directory
	// So mathematically there are 8 cases, but two of the cases,
	// importing to a new regular file or new directory,
	// are practically impossible so actually there are only 6 cases.
	if (wantsNewFile && (fileType != nil)) {
		// This branch covers the single one of six the cases that requires a Save panel:
		// Case: Exporting to a new regular file
		
		// Use an NSSavePanel
		NSSavePanel* panel = [NSSavePanel savePanel] ;
		// Override the default button title of "Save", since this
		// is not a Save operation.
		[panel setPrompt:buttonTitle] ;
		
		[panel setCanCreateDirectories:YES] ;
		[panel setCanSelectHiddenExtension:YES] ;
		[panel setExtensionHidden:NO] ;
		// Give the user some help in creating a file with a proper extension
		if ([fileType length] > 0) {
			// The new regular file must be of a specified extension
            [panel setAllowedFileTypes:[NSArray arrayWithObject:fileType]] ;
			[panel setAllowsOtherFileTypes:NO] ;
			// Note that the above NO only causes Cocoa to present a dialog if the user types in a filename extension known to the system
			// such as, for example, ".webloc".  If the user types in a filename "MyJunk.bonehead" and the
			// required fileType is "plist", the result will be "MyJunk.bonehead.plist" with no dialog.
		}
		else {
			// The new regular file may have arbitrary extension (Opera)
			// (If exformat is "Opera", fileType is a string of length 0.)
		}

        [panel beginSheetModalForWindow:documentWindow
                      completionHandler:^(NSInteger returnCode) {
                          if (returnCode == NSModalResponseCancel) {
                              [self abandon] ;
                              return ;
                          }
                            
                          NSString* path = [[panel URL] path] ;  // was [panel filename] until BookMacster 1.12
                          
                          Clientoid* clientoid = [Clientoid clientoidLooseWithExformat:exformat
                                                                                  path:path] ;
                          if (clientoid) {
                              [self setIvarsThenInvokeWaitingIfAnyLikeClientoid:clientoid] ;
                          }
                      }];
    }
	else {
		// This branch covers the other five of the six cases.  These five require an Open panel.
		// Case: Importing from an existing regular file
		// Case: Importing from a existing directory
		// Case: Exporting to an existing regular file
		// Case: Exporting to an existing directory
		// Case: Exporting to a new directory
		
		// Note it seems odd that the last item would require a Open panel,
		// because it requires the creation of something new.  Explanation is that
		// an Open panel ^can^ create directories, and moreover it does not have the
		// text field at the top for the filename, which a Save panel does.
		
		NSOpenPanel* panel = [NSOpenPanel openPanel] ;
		
		NSArray* fileTypes = nil ;
        // That was an empty array until BookMacster 1.20.5, but documentation
        // says that raises an exception, and that nil is the correct value.
		if (fileType) {
			// Importing from an existing regular file
			// Exporting to an existing regular file
			message = [NSString localizeFormat:
					   @"fileTypeXXXChoose",
					   [exformat exformatDisplayName],
					   [[NSString localize:@"000_Safari_Bookmarks"] lowercaseString],
					   [NSString stringWithFormat:
						@".%@",
						fileType]] ;
			fileTypes = [NSArray arrayWithObject:fileType] ;
			[panel setCanChooseDirectories:NO] ;
		}
		else if (wantsNewFile) {
			// Exporting to a new directory
			// User must specify a directory (OmniWeb)
			message = [NSString localizeFormat:
					   @"fileTypeXXXChooseDirNew",
					   [exformat exformatDisplayName],
					   [[NSString localize:@"000_Safari_Bookmarks"] lowercaseString]] ;
			[panel setMessage:message] ;
            [panel setAllowedFileTypes:nil] ;
			[panel setCanCreateDirectories:YES] ;
			[panel setCanChooseDirectories:YES] ;
			[panel setAllowsOtherFileTypes:YES] ;
		}
		else {
			// Importing from a existing directory
			// Exporting to an existing directory
			message = [NSString localizeFormat:
					   @"fileTypeXXXChooseDirExisting",
					   [exformat exformatDisplayName],
					   [[NSString localize:@"000_Safari_Bookmarks"] lowercaseString]] ;
			[panel setCanChooseDirectories:YES] ;
		}
		[panel setMessage:message] ;
		
		// Override the default button title of "Save", since this
		// is not a Save operation.
		[panel setPrompt:buttonTitle] ;
        
        NSString* directoryPath = [(BkmxDocumentController*)[NSDocumentController sharedDocumentController] defaultDocumentFolderError_p:NULL] ;
		
        [panel setDirectoryURL:[NSURL fileURLWithPath:directoryPath]] ;
        [panel setAllowedFileTypes:fileTypes] ;
        [panel beginSheetModalForWindow:documentWindow
                      completionHandler:^(NSInteger returnCode) {
                          if (returnCode == NSModalResponseCancel) {
                              
                              [self abandon] ;
                              return ;
                          }
                          
                          NSString* fullPath = [[panel URL] path] ;
                          NSError* error = nil ;
                          Clientoid* clientoid = nil ;
                          
                          clientoid = [Clientoid clientoidLooseWithExformat:exformat
                                                                       path:fullPath] ;
                          
                          if (clientoid) {
                              [self setIvarsThenInvokeWaitingIfAnyLikeClientoid:clientoid] ;
                          }
                          else if (error) {
                              [[self bkmxDoc] alertError:error] ;
                          }
                      }];
	}
}

- (void)setClientWithNilProfileForWebAppExformat:(NSString*)exformat {
	Clientoid* clientoid = [Clientoid clientoidThisUserWithExformat:exformat
														profileName:nil] ;
	[self setIvarsThenInvokeWaitingIfAnyLikeClientoid:clientoid] ;
	Importer* importer = [self importer] ;
	
	// We'll need an extore for -testLogin to work
    [importer renewExtoreForJobSerial:0
                              error_p:NULL] ;
	
#if USE_LOCAL_DOT_SQL_CACHES_WHEN_IMPORTING_WEB_EXTORES
	[self setProfileName:@"jerry@ieee.org"] ;
#else
    if (importer) {
        [self.webAuthorizor askUserAccountInfoForIxporter:importer
                                                     info:nil] ;
        // The info is nil because, since we have already setClient:,
        // the above method needs to do nothing if if the test succeeds.
    } else {
        NSError* error = SSYMakeError(323840, @"Cannot ask user for account info because Client has no ixporter");
        [[BkmxBasis sharedBasis] logError:error
                          markAsPresented:NO];
    }
#endif
}

- (void)chooseClientFromFile {	
	SSYAlert* alert = [SSYAlert alert] ;
	[alert setButton1Title:[NSString localize:@"ok"]] ;
	[alert setButton2Title:[NSString localize:@"cancel"]] ;
	
	SSYLabelledRadioButtons* labelledRadioButtons = nil ;
	NSInteger subviewIndex = 0 ;
	
	// Since we may be exporting, also need to know if user wants a new or existing file
    if (([self clientFileExistence] == BkmxClientFileUsersChoiceDefaultToExisting) || ([self clientFileExistence] == BkmxClientFileUsersChoiceDefaultToNew)){
        NSArray* choices = [NSArray arrayWithObjects:
                            [NSString localizeFormat:
                             @"new%0",
                             [NSString localize:@"file"]],
                            [NSString localizeFormat:
                             @"newExistingX",
                             [NSString localize:@"file"]],
                            nil] ;
        labelledRadioButtons = [SSYLabelledRadioButtons radioButtonsWithLabel:nil
                                                                      choices:choices
                                                                        width:500.0] ;
        if ([self clientFileExistence] == BkmxClientFileUsersChoiceDefaultToExisting) {
            // User is doing a One-Time Import.  Set the selection
            // to "Existing File", the non-default selection.
            [labelledRadioButtons setSelectedIndex:1] ;
        }
        
        [alert addOtherSubview:labelledRadioButtons
                       atIndex:subviewIndex] ;
        subviewIndex++ ;
	}
		
	NSArray* exformats = [(BkmxAppDel*)[NSApp delegate] ownerAppsForWhichICanCreateNewDocumuments];
    NSMutableArray* sortedExformats = [exformats mutableCopy];
    [sortedExformats sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString* name1 = [obj1 exformatDisplayName];
        NSString* name2 = [obj2 exformatDisplayName];
        if ([name1 hasPrefix:@"."] && ![name2 hasPrefix:@"."]) {
            return NSOrderedDescending;
        } else if (![name1 hasPrefix:@"."] && [name2 hasPrefix:@"."]) {
            return NSOrderedAscending;
        }
        return [name1 caseInsensitiveCompare:name2];
    }];
    exformats = [sortedExformats copy];
    [sortedExformats release];
    [exformats autorelease];
	NSArray* displayNames = [exformats valueForKey:@"exformatDisplayName"];
	SSYLabelledList* labelledList = [SSYLabelledList listWithLabel:[[BkmxBasis sharedBasis] labelChooseFileFormat]
														   choices:displayNames
                                           allowsMultipleSelection:NO
                                              allowsEmptySelection:NO
														  toolTips:nil
													 lineBreakMode:NSLineBreakByTruncatingMiddle
													maxTableHeight:550] ;
	
	[alert addOtherSubview:labelledList
				   atIndex:subviewIndex] ;
	
	NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
						  exformats, constKeyLooseExformats,
						  labelledList, constKeyLooseLabelledList,
						  nil] ;
	if (labelledRadioButtons) {
		info = [info dictionaryBySettingValue:labelledRadioButtons
									   forKey:constKeyLabelledRadioButtons] ;
	}
    BkmxDoc* bkmxDoc = [self bkmxDoc] ;
    if (bkmxDoc) {
        [bkmxDoc runModalSheetAlert:alert
                          resizeable:NO
                          iconStyle:SSYAlertIconInformational
                      modalDelegate:self
                     didEndSelector:@selector(chooseLooseBasicsPanelDidEnd:returnCode:contextInfo:)
                        contextInfo:[info retain]] ;
    }
}

#pragma mark * SSYOAuthAccounter Support

- (NSString*)serviceName {
	return NSStringFromClass([self extoreClass]) ;
}

- (NSString*)accountName {
	return [self profileName] ;
}

#pragma mark * AppleScriptability
// NOT NEEDED AT THIS TIME
- (NSScriptObjectSpecifier*)objectSpecifier {	
	NSScriptObjectSpecifier *containerSpecifier = [[[self macster] bkmxDoc] objectSpecifier] ;
	NSScriptClassDescription *containerClassDescription = [containerSpecifier keyClassDescription] ;
	NSScriptObjectSpecifier* specifier = [[NSIndexSpecifier allocWithZone:[self zone]] initWithContainerClassDescription:containerClassDescription
																									  containerSpecifier:containerSpecifier
																													 key:@"clientsOrdered"
																												   index:[[self index] integerValue]] ;
	// Note: If this object had a "unique" specifier instead of an "index" specifier, we
	// would use initWithContainerClassDescription:containerSpecifier:key:uniqueID: instead of the above.
	return [specifier autorelease] ;
}

@end
