#import "Trigger.h"
#import "NSError+MyDomain.h"
#import "SSYRecurringDate.h"
#import "Syncer.h"
#import "Client.h"
#import "NSDate+Components.h"
#import "NSNumber+TrigTypeDisplay.h"
#import "NSArray+SortDescriptorsHelp.h"
#import "Extore.h"
#import "NSManagedObject+Debug.h"
#import "Macster.h"
#import "NSDictionary+SimpleMutations.h"
#import "NSError+InfoAccess.h"
#import "SSYUuid.h"
#import "NSUserDefaults+KeyPaths.h"
#import "Stager.h"
#import "Importer.h"
#import "NSError+MoreDescriptions.h"
#import "NSBundle+MainApp.h"
#import "NSUserDefaults+MainApp.h"
#import "BkmxBasis.h"
#import "NSString+SSYDotSuffix.h"
#import "BkmxDoc.h"

NSString* const constKeyTriggerType = @"triggerType" ;
NSString* const constKeyRecurringDate = @"recurringDate" ;
NSString* const constKeyPeriod = @"period" ;
NSString* const constNoImportSources = @"NoImportSources" ;

@interface Trigger (CoreDataGeneratedPrimitiveAccessors)

- (void)setPrimitiveSyncer:(Syncer*)value ;
- (void)setPrimitiveClient:(Client*)value ;
- (void)setPrimitiveIndex:(NSNumber*)value ;
- (void)setPrimitiveRecurringDate:(SSYRecurringDate*)value ;
- (void)setPrimitivePeriod:(NSNumber*)period ;
- (void)setPrimitiveEfficiently:(NSNumber*)efficiently ;
- (void)setPrimitiveTriggerType:(NSNumber*)value ;

@end

@interface Trigger ()

@property (retain) NSString* blinderKey ;

@end


@implementation Trigger

#pragma mark * Core Data Generated Accessors for managed object properties

// Attributes
@dynamic triggerType;  // Custom setter is below
@dynamic recurringDate ;
@dynamic period ;
@dynamic efficiently ;
@dynamic index ;
@dynamic syncer ;
@dynamic client ;

+ (NSString*)specialWatchFilePathForExformat:(NSString*)exformat
                                 profileName:(NSString*)profileName {
    NSString *path;
    path = [[BkmxBasis sharedBasis] detectedChangesPath];
    path = [path stringByAppendingPathComponent:exformat] ;
    Class extoreClass = [Extore extoreClassForExformat:exformat] ;
    BOOL appendProfile = ([extoreClass constants_p]->defaultProfileName != nil) ;
    if (appendProfile) {
        if (!profileName) {
            /* This will execute for Opera. */
            profileName = [extoreClass constants_p]->defaultProfileName ;
        }
        
        path = [path stringByAppendingDotSuffix:profileName] ;
    }

    path = [path stringByAppendingString:@"/"];
    return path ;
}

+ (NSInteger)severityWhenSettingNewType:(NSNumber*)newType
								oldType:(NSNumber*)oldType {
	// During development of BookMacster 1.11, this method originally
	// did more.  It only returned YES if the type was being changed to
	// BkmxTriggerSawChange or BkmxBrowserQuit.  But after careful,
	// careful consideration I realized that, when determining whether
	// or not to alert the user that a manual export is required to
	// prime the pump, as long as a Client is being imported, it does
	// not matter *why*.  The Safe Limit can still be exceeded.
	// So this method is actually kind of a no-brainer now, but
	// it gives me a place to document these thoughts and centralize
	// the function.
	if (!oldType && newType) {
		return 7 ;
	}
	
	return 4 ;
}


#if 0
#warning Debugging when Core Data could not fulfill a fault for a Trigger
- (NSNumber *)triggerType {
    NSNumber * tmpValue = nil ;
    
	if ([self isDeleted]) {
		NSLog(@"Warning 392-0284") ;
	}
	else {
		NSLog(@"03126: Will access triggerType for %p  isD=%hhd  isF=%hhd", self, (long)[self isDeleted], (long)[self isFault]) ;
		[self willAccessValueForKey:constKeyTriggerType] ;
		tmpValue = [self primitiveTriggerType] ;
		[self didAccessValueForKey:constKeyTriggerType] ;
		NSLog(@"03305: Did access triggerType.  Got %@", tmpValue) ;
	}
	
    return tmpValue ;
}
#endif

- (BkmxTriggerType)triggerTypeValue {
	NSNumber* triggerType = [self triggerType] ;
	
	return (BkmxTriggerType)[triggerType integerValue] ;
}

- (void)setTriggerTypeValue:(BkmxTriggerType)newValue {
	[self setTriggerType:[NSNumber numberWithInteger:newValue]] ;
}

#pragma mark * KVC Compliance for properties related to the "detail" column 

- (BOOL)hasDetail {
	BkmxTriggerType triggerTypeValue = [self triggerTypeValue] ;
	BOOL hasDetail ;
	switch (triggerTypeValue) {
		case BkmxTriggerLogIn:
		case BkmxTriggerBrowserQuit:
		case BkmxTriggerSawChange:
		case BkmxTriggerScheduled:
		case BkmxTriggerPeriodic:
			hasDetail = YES ;
			break ;
		case BkmxTriggerCloud:
		case BkmxTriggerLanding:
        default:
			hasDetail = NO ;
			break ;
	}
	
	return hasDetail ;
}

+ (NSSet *)keyPathsForValuesAffectingHasDetail {
	return [NSSet setWithObject:constKeyTriggerType] ;	
}

- (NSArray*)detailChoices {
	NSArray* choices ;
	NSArray* clients ;
	switch ([self triggerTypeValue]) {
        case BkmxTriggerLogIn:;
            choices = [NSArray arrayWithObjects:
                       [NSNumber numberWithInteger:TRIGGER_DETAIL_EFFICIENTLY_NO],
                       [NSNumber numberWithInteger:TRIGGER_DETAIL_EFFICIENTLY_YES],
                       nil] ;
            break ;
		case BkmxTriggerBrowserQuit:;
			NSArray* browserQuitChoices = [[[[[self syncer] macster] thisUserLocalClients] allObjects] arraySortedByStringValueForKey:@"displayName"] ;
			NSMutableArray* activeBrowserQuitChoices = [NSMutableArray array] ;
			for (Client* choice in browserQuitChoices) {
				if ([[(Ixporter*)[choice importer] isActive] boolValue]) {
					[activeBrowserQuitChoices addObject:choice] ;
				}
			}
			choices = [NSArray arrayWithArray:activeBrowserQuitChoices] ;
			if ([choices count] < 1) {
				choices = [NSArray arrayWithObject:constNoImportSources] ;
			}
			break ;
		case BkmxTriggerSawChange:
			clients = [[[[self syncer] macster] thisUserLocalClients] allObjects] ;
			NSMutableArray* rawChoices = [NSMutableArray array] ;
			for (Client* client in clients) {
				OwnerAppObservability observability = [[client extoreClass] ownerAppObservability] ;
				// Prior to BookMacster 1.11.3, the following branch effectively excluded OwnerAppObservabilityOnQuit
				if (observability != OwnerAppObservabilityNone) {
					// The following qualification was added to fix a bug in 1.11.3
					if ([[(Importer*)[client importer] isActive] boolValue]) {
						[rawChoices addObject:client] ;
					}
				}
			}
			[rawChoices sortByStringValueForKey:@"displayName"] ;
			if ([rawChoices count] < 1) {
				rawChoices = [NSMutableArray arrayWithObject:constNoImportSources] ;
			}
			choices = [NSArray arrayWithArray:rawChoices] ;
			break ;
		case BkmxTriggerScheduled:
			choices = [SSYRecurringDate weekdayChoices] ;
			break ;
		case BkmxTriggerPeriodic:
            choices = [NSArray arrayWithObjects:
                       [NSNumber numberWithInteger:600],
                       [NSNumber numberWithInteger:1800], // 30 minutes, default value in data model
                       [NSNumber numberWithInteger:3600],
                       [NSNumber numberWithInteger:10800], // 3 hours
                       [NSNumber numberWithInteger:43200], // 12 hours
                       [NSNumber numberWithInteger:86400], // 24 hours
                       nil] ;
			break ;
		default:
			choices = nil ;
	}
	
	// Note: This must never return an empty array since
	// a couple other methods send objectAtIndex:0 to it.
	return choices ;
}
+ (NSSet *)keyPathsForValuesAffectingDetailChoices {
	return [NSSet setWithObjects:
			constKeyTriggerType,
			// @"syncer.macster.clientsDummyForKVO",
			/* The above was added in 1.1.10, commented out in
			 1.2.8 after it was found to be causing this Console log:
			 "Cannot remove an observer <NSTableBinder 0x1516e2b0> for the key path "syncer.macster.clientsDummyForKVO" from <Trigger 0x7e39a0>, most likely because the value for the key "syncer" has changed without an appropriate KVO notification being sent. Check the KVO-compliance of the Trigger class."
			 Steps to reproduce:
			 • Create document with Clients Safari, Firefox, Camino
			 • Create the normal 2 syncers, all four boxes checked in Simple Syncers
			 • Change to Advanced Syncers
			 • Set document to open on launch
			 • Re-launch BookMacster
			 • Syncer #1 is selected.  Select Syncer #2.
			 • If that doesn't produce the error, fiddle with Command or Trigger details
			 For explanation of what might cause this, see comments
			 for similar issue in +[Command keyPathsForValuesAffectingArgumentChoices] */
			nil
			] ;	
}

- (void)setDetailChoice:(id)newChoice {
	switch ([self triggerTypeValue]) {
		case BkmxTriggerLogIn:;
            BOOL ok = NO ;
			if ([newChoice respondsToSelector:@selector(integerValue)]) {
                NSInteger value = [newChoice integerValue] ;
                if ((value == TRIGGER_DETAIL_EFFICIENTLY_YES) || (value == TRIGGER_DETAIL_EFFICIENTLY_NO)) {
                    NSNumber* number = [NSNumber numberWithInteger:value] ;
                    [self setEfficiently:number] ;
                    ok = YES ;
                }
            }
            if (!ok) {
                NSLog(@"Internal Error 859-8237 %@", newChoice) ;
            }
            break ;
		case BkmxTriggerBrowserLaunch:
        case BkmxTriggerBrowserQuit:
		case BkmxTriggerSawChange:
			if ([newChoice isKindOfClass:[Client class]]) {
				[self setClient:newChoice] ;
			}
			break ;
		case BkmxTriggerScheduled:
			if ([newChoice isKindOfClass:[NSNumber class]]) {
				// In order to be noticed as a change, we must create a new
				// date, not change attributes of the existing one.
				// This is because recurringDate is an attribute in the data
				// model, but its 'weekday' sub-attribute is not.
				SSYRecurringDate* newRecurringDate = [[SSYRecurringDate alloc] init] ;
				[newRecurringDate setWeekday:[newChoice integerValue]] ;
				// Copy the existing hour and minute
				[newRecurringDate setHour:[[self recurringDate] hour]] ;
				[newRecurringDate setMinute:[[self recurringDate] minute]] ;
				[self setRecurringDate:newRecurringDate] ;
				[newRecurringDate release] ;
			}
			break ;
		case BkmxTriggerPeriodic:
			if ([newChoice isKindOfClass:[NSNumber class]]) {
                // detailChoice is an NSNumber of seconds.  We just use
                // that directly.
				[self setPeriod:newChoice] ;
			}
			break ;
		case BkmxTriggerCloud:
        case BkmxTriggerLanding:
			// These cases can happen when a Syncer is initially
			// being constructed.  Maybe not any more, since  the only known
            // case involved the now-removed LegacyImporter.
        case BkmxTriggerImpossible:
            // Maybe ditto but I'm not sure if the impossible is possible :))
            // Anyhow, it does not have a detail choice.
			break ;
	}	
}

- (id)detailChoice {
	id choice = nil ;
	
	switch ([self triggerTypeValue]) {
        case BkmxTriggerLogIn:
            choice = [self efficiently] ;
            break ;
		case BkmxTriggerBrowserQuit:
		case BkmxTriggerSawChange:
			choice = [self client] ;
			if (!choice) {
				choice = [[self detailChoices] objectAtIndex:0] ;
			}
			break ;
		case BkmxTriggerScheduled:
			choice = [self recurringDate] ;
			
			// However, in this case we really want the 'weekday' number, not
			// the whole recurringDate object
			choice = [NSNumber numberWithInteger:[choice weekday]] ;
			break ;
        case BkmxTriggerPeriodic:
            choice = [self period] ;
            break ;
		default:
			choice = nil ;
			
	}
	
	return choice ;
}	

+ (NSSet *)keyPathsForValuesAffectingDetailChoice {
	return [NSSet setWithObjects:
			constKeyTriggerType,
			constKeyClient,
			constKeyRecurringDate,
			nil] ;	
}

#pragma mark * Basic Infrastructure


#pragma mark * KVC Compliance for properties related to the "time" column

// Note: the 'Enabled' binding does not work for a table column which has
// a NSDateFormatter attached.  However, the 'Editable' and 'Text Color'
// bindings do work.  So, I connect the 'Editable' binding to -hasTimeChoice
// and the 'Text Color' binding to -timeTextColor, and this gives the desired
// effect.

- (BOOL)hasTimeChoice {
	BkmxTriggerType triggerTypeValue = [self triggerTypeValue] ;
	BOOL hasTimeChoice ;
	switch (triggerTypeValue) {
		case BkmxTriggerScheduled:
			hasTimeChoice = YES ;
			break ;
		case BkmxTriggerLogIn:
		case BkmxTriggerBrowserQuit:
		case BkmxTriggerSawChange:
		case BkmxTriggerCloud:
        case BkmxTriggerLanding:
        case BkmxTriggerPeriodic:
        default:
			hasTimeChoice = NO ;
	}
	
	return hasTimeChoice ;
}
+ (NSSet *)keyPathsForValuesAffectingHasTimeChoice {
	return [NSSet setWithObject:constKeyTriggerType] ;	
}

- (NSColor*)timeTextColor {
	if ([self hasTimeChoice]) {
		return [NSColor controlTextColor] ;
	}
	
	return [NSColor disabledControlTextColor] ;
}
+ (NSSet *)keyPathsForValuesAffectingTimeTextColor {
	return [NSSet setWithObject:constKeyTriggerType] ;	
}

- (id)time {
	NSDate* time = nil ;
	
	if ([self hasTimeChoice]) {
		SSYRecurringDate* recurringDate_ = [self recurringDate] ;
		
		// The above will return nil if detail has not been set to a client
		if (!recurringDate_) {
			// Set recurringDate to a default: Every day at 00:00.
			recurringDate_ = [[SSYRecurringDate alloc] init] ;
			[recurringDate_ setWeekday:SSRecurringDateWildcard] ;
			//  Not needed since Obj-C ivars initialize to 0: [recurringDate_ setHour:0] ;
			//  Not needed since Obj-C ivars initialize to 0: [recurringDate_ setMinute:0] ;
			[self setRecurringDate:recurringDate_] ;
			[recurringDate_ autorelease] ;
		}
		
		time = [NSDate dateWithYear:NSNotFound
							  month:NSNotFound
								day:NSNotFound
							   hour:[[self recurringDate] hour]
							 minute:[[self recurringDate] minute]
							 second:NSNotFound
					 timeZoneOffset:NSNotFound] ;
	}	
	
	return time ;
}	

- (void)setTime:(NSDate*)newTime {
	// In order to be noticed as a change, we must create a new
	// recurringDate, not change attributes of the existing one.
	// This is because recurringDate is an attribute in the data
	// model, but its 'hour' and 'minute' sub-attributes are not.
	SSYRecurringDate* newRecurringDate = [[SSYRecurringDate alloc] init] ;
	[newRecurringDate setHour:[newTime hour]] ;
	[newRecurringDate setMinute:[newTime minute]] ;
	// Copy the existing weekday
	[newRecurringDate setWeekday:[[self recurringDate] weekday]] ;
	[self setRecurringDate:newRecurringDate] ;
	[newRecurringDate release] ;
}

+ (NSSet *)keyPathsForValuesAffectingTime {
	return [NSSet setWithObjects:
			constKeyRecurringDate,
			constKeyTriggerType,
			nil] ;	
}

// From NSManagedObject documentation: "You are discouraged from overriding
// description ... if this method fires a fault during a debugging
// operation, the results may be unpredictable.
- (NSString*)shortDescription {
    return [NSString stringWithFormat:
            @"Trigger %p avai=%@ %@ ix=%ld type='%@' client='%@' synIx=%@",
            self,
            [self availabilityDescription],
            [self truncatedID],
            (long)[[self index] integerValue],
            [[self triggerType] triggerTypeDisplayName],
            [[self client] clientoid],
            [[self syncer] index]] ;
}


#pragma mark * Custom Accessors for Managed Properties

- (void)setSyncer:(Syncer*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeySyncer] ;
	[self willChangeValueForKey:constKeySyncer] ;
    [self setPrimitiveSyncer:newValue] ;
    [self didChangeValueForKey:constKeySyncer] ;
}

- (void)setClient:(Client*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyClient] ;
	[self willChangeValueForKey:constKeyClient] ;
    [self setPrimitiveClient:newValue] ;
    [self didChangeValueForKey:constKeyClient] ;
	
	NSInteger severity = (newValue != nil) ? 7 : 4 ;
	[[[self syncer] macster] postTouchedSyncer:[self syncer]
                                     severity:severity] ;
}

- (void)setIndex:(NSNumber*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyIndex] ;
	[self willChangeValueForKey:constKeyIndex] ;
    [self setPrimitiveIndex:newValue] ;
    [self didChangeValueForKey:constKeyIndex] ;
	
	[[[self syncer] macster] postTouchedSyncer:[self syncer]
                                     severity:3] ;
}

- (void)setRecurringDate:(SSYRecurringDate*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyRecurringDate] ;
	[self willChangeValueForKey:constKeyRecurringDate] ;
    [self setPrimitiveRecurringDate:newValue] ;
    [self didChangeValueForKey:constKeyRecurringDate] ;
	
	[[[self syncer] macster] postTouchedSyncer:[self syncer]
                                     severity:3] ;
}

- (void)setEfficiently:(NSNumber*)newValue  {
    if (!newValue) {
        NSLog(@"Internal Error 524-2445") ;
        newValue = [NSNumber numberWithInteger:TRIGGER_DETAIL_EFFICIENTLY_NO] ;
    }
	[self postWillSetNewValue:newValue
					   forKey:constKeyEfficiently] ;
	[self willChangeValueForKey:constKeyEfficiently] ;
    [self setPrimitiveEfficiently:newValue] ;
    [self didChangeValueForKey:constKeyEfficiently] ;
	
	[[[self syncer] macster] postTouchedSyncer:[self syncer]
                                     severity:3] ;
}

- (void)setPeriod:(NSNumber*)newValue  {
    if (!newValue) {
        NSLog(@"Internal Error 524-9873") ;
        newValue = [NSNumber numberWithInteger:1800] ;
    }
	[self postWillSetNewValue:newValue
					   forKey:constKeyPeriod] ;
	[self willChangeValueForKey:constKeyPeriod] ;
    [self setPrimitivePeriod:newValue] ;
    [self didChangeValueForKey:constKeyPeriod] ;
	
	[[[self syncer] macster] postTouchedSyncer:[self syncer]
                                     severity:3] ;
}

- (void)setTriggerType:(NSNumber*)newValue  {
	NSNumber* oldType = [self triggerType] ;
	[self postWillSetNewValue:newValue
					   forKey:constKeyTriggerType] ;
	
	[self willChangeValueForKey:constKeyTriggerType] ;
    // This will set the undo action name to "Change Trigger"
	[self setPrimitiveTriggerType:newValue] ;
    [self didChangeValueForKey:constKeyTriggerType] ;
	
	/* This section is defensive programming. */
	BkmxTriggerType triggerType = [self triggerTypeValue] ;
	if (
		(triggerType != BkmxTriggerBrowserQuit)
		&&
		(triggerType != BkmxTriggerSawChange)
		) {
        /* This should never happen. */
		if ([self client] != nil) {
			[self setClient:nil] ;
		}
	}
	
	// Trigger of type BkmxTriggerBrowserQuit or BkmxTriggerSawChange
	// will require a non-nil client which is live-observable.
	// Recall that 'client' <--> 'detailChoice'.
	BOOL existingDetailChoiceIsOk = NO ;
	Client* client = [self client] ;
	if (client) {
		if ([[client extoreClass] canDoLiveObservability]) {
			existingDetailChoiceIsOk = YES ;
		}
	}
	
	if (!existingDetailChoiceIsOk) {
		// It will appear in the table but won't be in the data model without this:
		NSArray* detailChoices = [self detailChoices] ;
		id defaultDetailChoice ;
		if ([detailChoices count] > 0) {
			defaultDetailChoice = [detailChoices objectAtIndex:0] ;
		}
		else {
			defaultDetailChoice = nil ;
		}
		[self setDetailChoice:defaultDetailChoice] ;
	}
	
	// This may set the undo action name to "Change Command"
	[[self syncer] refreshCommandsArguments] ;
	
	NSInteger severity = [Trigger severityWhenSettingNewType:newValue
													 oldType:oldType] ;
	[[[self syncer] macster] postTouchedSyncer:[self syncer]
                                     severity:severity] ;
}

// Until BookMacster 1.11, this was 120.0

- (NSString*)docUuid {
	// This method is better than [[[[self syncer] macster] bkmxDoc] uuid]
	// because it does not require the macster and bkmxDoc to be linked.
	return [[[self syncer] macster] docUuid] ;
}


+ (NSString*)smallDescriptionOfTrigger:(Trigger*)trigger {
	NSString* smallDescription ;
	if (trigger) {
		NSString* suffix = [[[trigger client] clientoid] displayName] ;
		if (!suffix) {
			suffix = [Trigger causeStringForType:[trigger triggerTypeValue]] ;
		}
		
		smallDescription = [NSString stringWithFormat:
							@"Trig %ld (%@)",
							(long)[[trigger index] integerValue],
							suffix] ;
	}
	else {
		smallDescription = @"all Trigs" ;
	}
	
	return smallDescription ;
}


+ (NSString*)causeStringForType:(BkmxTriggerType)triggerTypeValue {
    NSString* answer = nil;
    switch (triggerTypeValue) {
        case BkmxTriggerLogIn:
            answer = @"User logged in";
            break;
        case BkmxTriggerPeriodic:
            answer = @"Periodic";
            break;
        case BkmxTriggerScheduled:
            answer = @"Scheduled";
            break;

        /* The remaining cases should never happen. */
        case BkmxTriggerSawChange:
            // This requires instance to compute.  It will be the path to the kqueued file, beginning with "/"
            break;
        case BkmxTriggerImpossible:
            // This should never happen
        case BkmxTriggerBrowserLaunch:
            // This requires instance to compute.  It will be "<Browser-Name> launched"
        case BkmxTriggerBrowserQuit:
            // This requires instance to compute.  It will be "<Browser-Name> quit"
        case BkmxTriggerCloud:
            // This requires instance to compute.  It will be the path to the kqueued file, beginning with "/"
        case BkmxTriggerLanding:;
            // This is never seen in BkmxAgent because the trigger is handled within the main app.

            NSString* msg = [NSString stringWithFormat:
                             @"Internal Error 682-4845 No simple string rep for trigger type %ld",
                             (long)triggerTypeValue];
            [[BkmxBasis sharedBasis] logFormat:msg];
            break;
    }

	return answer;
}

@synthesize blinderKey = m_blinderKey ;

- (void)dealloc {
    [m_blinderKey release] ;
    
    [super dealloc] ;
}


- (NSString*)blind {
	NSString* blinderKey ;
    blinderKey = [SSYUuid uuid] ;
    [self setBlinderKey:blinderKey] ;

	return blinderKey ;
}

- (BOOL)unblindIfKey:(NSString*)key
             error_p:(NSError**)error_p {
	BOOL ok = YES ;
    NSError* error = nil ;
	
	if ([[self blinderKey] isEqualToString:key]) {

		if (ok) {
			[self setBlinderKey:nil] ;
		}
        else if (error_p) {
            *error_p = error ;
        }
	}
	
	return ok ;
}

- (BOOL)doesSameAsTrigger:(Trigger*)otherTrigger {
	if (![[self triggerType] isEqual:[otherTrigger triggerType]]) {
		return NO ;
	}
	
	// Core Data guarantees that there will be only one pointer for each object…
	if ([self client] != [otherTrigger client]) {
		return NO ;
	}
	
	if ([self triggerTypeValue] == BkmxTriggerScheduled) {
		if (![[self recurringDate] isEqual:[otherTrigger recurringDate]]) {
			return NO ;
		}
	}
	if ([self triggerTypeValue] == BkmxTriggerPeriodic) {
		if (![[self period] isEqualToNumber:[otherTrigger period]]) {
			return NO ;
		}
	}
	
	return YES ;
}

#pragma mark * AppleScriptability

- (NSScriptObjectSpecifier*)objectSpecifier {	
	NSScriptObjectSpecifier *containerSpecifier = [[self syncer] objectSpecifier] ;
	NSScriptClassDescription *containerClassDescription = [containerSpecifier keyClassDescription] ;
	NSScriptObjectSpecifier* specifier = [[NSIndexSpecifier allocWithZone:[self zone]] initWithContainerClassDescription:containerClassDescription
																									  containerSpecifier:containerSpecifier
																													 key:@"triggersOrdered"
																												   index:[[self index] intValue]] ;
	// Note: If this object had a "unique" specifier instead of an "index" specifier, we
	// would use initWithContainerClassDescription:containerSpecifier:key:uniqueID: instead of the above.
	return [specifier autorelease] ;
}


@end
