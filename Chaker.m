#import "Bkmxwork/Bkmxwork-Swift.h"
#import "Chaker.h"
#import "Stark.h"
#import "BkmxBasis+Strings.h"
#import "NSObject+MoreDescriptions.h"
#import "Ixporter.h"
#import "NSString+LocalizeSSY.h"
#import "BkmxDoc.h"
#import "ImportLog.h"
#import "ExportLog.h"
#import "Bookshig.h"
#import "Starkoid.h"
#import "SSYMojo.h"
#import "NSArray+Stringing.h"
#import "NSArray+SafeGetters.h"
#import "Macster.h"
#import "AgentPerformer.h"
#import "Stange.h"
#import "SSYProgressView.h"
#import "NSBundle+MainApp.h"

// This leading whitespace is to indent changes from
// their stark description when displaying in table.
NSString* const constLeadingWhitespace = @"    " ;

#if 0 // Change this one
#warning Logging Chaker inputs to Console
#define LOG_CHAKER_INPUTS 1 // Not this one
#endif

@interface NSString (ChangeLogging) 

- (NSComparisonResult)compareLogLines:(NSString*)other ;

- (NSString*)localizedUpdateDescriptionFromValue:(id)oldValue
										 toValue:(id)newValue
								 fromDisplayName:(NSString*)fromDisplayName ;

- (NSString*)localizedUpdateDescriptionForDeletions:(NSArray*)deletions ;

- (NSString*)localizedUpdateDescriptionForAdditions:(NSArray*)additions ;

@end

@implementation NSString (ChangeLogging) 

- (NSComparisonResult)compareLogLines:(NSString*)other {
	return [[self substringFromIndex:2] localizedCaseInsensitiveCompare:[other substringFromIndex:2]] ;
}

- (NSString*)localizedUpdateDescriptionFromValue:(id)oldValue
										 toValue:(id)newValue
								 fromDisplayName:(NSString*)fromDisplayName {
	NSString* description ;
	
	if (!oldValue) {
		oldValue = [[BkmxBasis sharedBasis] labelNothing] ;
	}
	else if ([oldValue isKindOfClass:[Stark class]]) {
		oldValue = [(Stark*)oldValue name] ;
	}
	
	if (!newValue) {
		newValue = [[BkmxBasis sharedBasis] labelNothing] ;
	}
	else if ([newValue isKindOfClass:[Stark class]]) {
		newValue = [(Stark*)newValue name] ;
	}
	
	NSString* sd1 = [oldValue shortDescription] ;
	NSString* sd2 = [newValue shortDescription] ;
	// In BookMacster 0.9.33, shortDescription was modified to
	// resolve a performance bottleneck.  See the Release Notes
	// for 0.9.33 and comments in the implementation of
	// -[NSObject shortDescription].
	NSString* label = [[BkmxBasis sharedBasis] labelNoNilForKey:self] ;
    NSString* formatString = NSLocalizedStringFromTableInBundle(
                                                                @"changeX3",
                                                                nil, // default to "Localizable"
                                                                [NSBundle mainAppBundle],
                                                                nil);
	description = [NSString stringWithFormat:
			  formatString,
			  label,
			  sd1,
			  sd2] ;
	description = [constLeadingWhitespace stringByAppendingString:description] ;
	
	return description ;
}

- (NSString*)localizedUpdateDescriptionForDeletions:(NSArray*)deletions {
	NSString* lud = nil ;
	if ([deletions count] > 0) {
		NSString* labelKey ;
		if ([self isEqualToString:constKeyChildren]) {
            labelKey = @"%ld Children" ;
        }
        else if ([self isEqualToString:constKeyTags]) {
            labelKey = @"%ld Tags" ;
		}
		else {
			// This should never happen, unless we make a mistake and
			// send this message to constKeyOwnerValues.
			return nil ;
		}

        NSString* what = [NSString stringWithFormat:
                          labelKey,
                          [deletions count]] ;
        NSString* deleteWhat = [NSString stringWithFormat:
                                @"%@",
                                what] ;
        NSString* update = [NSString stringWithFormat:
							@"Delete %@",
							deleteWhat] ;

		NSMutableArray* availableDeletions = [[NSMutableArray alloc] init] ;
		for (id deletion in deletions) {
			// deletion could be a stark (from deletedChildren), or a Tag (as in deletedTags)
			// Prior to BookMacster 1.11, cound have been an id (as in ownerValues)
			
			if ([deletion isKindOfClass:[Stark class]]) {
				// Deleted starks will/may/unsure return nil for all of their
				// properties, including 'name'.  But in my testing, I see that
				// isFault=0 and isDeleted=0.  Not sure why that is, but they are
				// no help.  However, they also return owner = nil; apparently
				// they have been removed from their managed object context.
				// Now, I'm no sure if it's a good idea to wait for
				// listValuesForKey:conjunction:truncateTo: to send a -name
				// message because I'm worried that could cause a 'Core Data could
				// not fulfill a fault' or similar nasty.  So, I check the 
				// deletions first.
				if ([deletion owner] == nil) {
					// No managed object context.  Eeek!
					continue ;
				}
				
				if ([deletion isFault]) {
					continue ;
				}
				
				if ([deletion isDeleted]) {
					continue ;
				}
				
				if ([[deletion name] length] == 0) {
					continue ;
				}
            } else if ([deletion isKindOfClass:[Tag class]]) {
                deletion = ((Tag*)deletion).string;
            }
				
			[availableDeletions addObject:deletion] ;
		}
		
		NSString* list = [availableDeletions listValuesForKey:constKeyName
												  conjunction:nil
												   truncateTo:6] ;
		[availableDeletions release] ;
		
		if ([list length] > 0) {
			update = [update stringByAppendingFormat:@" (%@)", list] ;
		}
		
		lud = [constLeadingWhitespace stringByAppendingString:update] ;
	}

	return lud ;
}
	
- (NSString*)localizedUpdateDescriptionForAdditions:(NSArray*)additions {
	NSString* lua = nil ;
	if ([additions count] > 0) {
		NSString* labelKey ;
		if ([self isEqualToString:constKeyChildren]) {
			labelKey = @"%ld Children" ;
		}
		else if ([self isEqualToString:constKeyTags]) {
			labelKey = @"%ld Tags" ;
		}
		else {
            /* This should never happen, unless we make a mistake and
             send this message to constKeyOwnerValues. */
			return nil ;
		}
        
        NSString* descriptionKey;
        if ([[additions firstObject] respondsToSelector:@selector(string)]) {
            // It is a tag
            descriptionKey = constKeyString;
        } else {
            // It is a stark (child) or ???
            descriptionKey = constKeyName;
        }
		
        NSString* what = [NSString stringWithFormat:
                          labelKey,
                          [additions count]] ;
        NSString* list = [additions listValuesForKey:descriptionKey
                                         conjunction:nil
                                          truncateTo:6] ;
        NSString* addWhat = [NSString stringWithFormat:
                             @"%@ (%@)",
                             what,
                             list] ;
        NSString* update = [NSString stringWithFormat:
							@"Add %@",
							addWhat] ;
		lua = [constLeadingWhitespace stringByAppendingString:update] ;
	}

	return lua ;
}

@end


@interface Chaker ()

@property (assign) BkmxDoc* bkmxDoc ;
@property (copy) NSString* fromDisplayName ;
@property (readonly, retain) NSMutableSet* extoresWithAffectedTags;

@end


@implementation Chaker

@synthesize bkmxDoc = m_bkmxDoc ;
@synthesize fromDisplayName = m_fromDisplayName ;
@synthesize isActive = m_isActive ;
@synthesize extoresWithAffectedTags = m_extoresWithAffectedTags;

- (id)initWithBkmxDoc:(BkmxDoc*)bkmxDoc {
	self = [super init] ;
	if (self) {
		[self setBkmxDoc:bkmxDoc] ;
	}
	
	return self ;
}

- (NSMutableDictionary*)stanges {
	if (!m_stanges) {
		m_stanges = [[NSMutableDictionary alloc] init] ;
	}
	
	return m_stanges ;
}

- (void)dealloc {	
	[m_stanges release] ;
	[m_fromDisplayName release] ;
    [m_extoresWithAffectedTags release];
	
	[super dealloc] ;
}

- (Stange*)stangeForStark:(Stark*)stark
                     make:(BOOL)make {
	NSString* key = [stark starkid] ;
	Stange* stange = [[self stanges] objectForKey:key] ;

    /* I check for nil `key` due to a crash report received from user Edward C.
     on 2019-03-11 indicating key was nil.  The relevant slice of the
     symbolized call stack for that crash is:

     4 Chaker.m:247  -[Chaker stangeForStark:make:]
     5 Chaker.m:340   -[Chaker updateStark:key:oldValue:newValue:]
     6 BkmxDoc.m:9000  -[BkmxDoc objectWillChangeNote:]

     I do not see how this could possibly happen, because (1) the code in
     the line 6 method which calls the like 5 method is wrapped in
     if ([object isKindOfClass:[Stark class]]) and, following the code, we
     are guaranteed that the `stark` passed to this method is a Stark,
     and (2) all Starks are assigned starkids in -[Stark awakeFromInsert],
     and I cannot find any other code which touches Stark.starkid.

     Well, one way it could happen is if someone edited the persistent store
     and removed a Stark's starkid.  So I queried the SQLite files of his two
     Collections, one with # in its name, but nope in both cases all 6900
     starks have starkid not null.

     Well, still a mystery, but we now check that `key` is not nil, so at
     least it will not cause a crash. */
	if (!stange && make) {
        if (key != nil) {
            stange = [[Stange alloc] init] ;
            [[self stanges] setObject:stange
                               forKey:key] ;
            [stange release];
        } else {
            NSLog(@"Internal Error 284-2748 for %@", stark);
        }
	}
	
	return stange ;
}

- (void)removeStangeForStark:(Stark*)stark {
#if LOG_CHAKER_INPUTS
	NSLog(@"16050 %s %p %@ %@", __PRETTY_FUNCTION__, self, [stark name], [stark starkid]) ;
#endif
	NSString* key = [stark starkid] ;
	[m_stanges removeObjectForKey:key] ;
}

- (void)setFrom:(id)from {
	NSString* displayName ;
	if ([from isKindOfClass:[Ixporter class]]) {
		if ([(Ixporter*)from isAnImporter]) {
			displayName = [[(Ixporter*)from client] displayName] ;
		}
		else {
			displayName = nil ;
		}
	}
	else if ([from isKindOfClass:[NSString class]]) {
		displayName = (NSString*)from ;
	}
	else {
		displayName = nil ;
	}
	
	
	[self setFromDisplayName:displayName] ;
}

// Note 2968189.  In the following three methods, it might be nice to have a
// mechanism which would immediately 'return' if the given stark was not
// owned by the BkmxDoc during an Import, or not owned by an Extore during an
// Export.  This *should'nt* ever happen, though.

- (void)addStark:(Stark*)stark {
#if LOG_CHAKER_INPUTS
	NSLog(@"16060 %s %p %@ %@", __PRETTY_FUNCTION__, self, [stark name], [stark starkid]) ;
#endif
	if (!m_isActive) {
#if LOG_CHAKER_INPUTS
		NSLog(@"16051 Sorry, not active") ;
#endif
		return ;
	}

	if ([stark isRoot]) {
#if LOG_CHAKER_INPUTS
		NSLog(@"16052 Sorry, root") ;
#endif
		return ;
	}
	
	// Add to stanges
	Stange* stange = [self stangeForStark:stark
									 make:YES] ;
	[stange registerAdd] ;
	[stange registerBasicsFromStark:stark] ;
	// The following is intended to be nil for an export/exporter.
	[stange setFromDisplayName:[self fromDisplayName]] ;
}

- (void)updateStark:(Stark*)stark
				key:(NSString*)key
		   oldValue:(id)oldValue
		   newValue:(id)newValue {
#if LOG_CHAKER_INPUTS
	NSLog(@"18050 %p %s %@ %@ %@ %@ to %@", self, __PRETTY_FUNCTION__, [stark name], [stark starkid], key, [oldValue shortDescription], [newValue shortDescription]) ;
#endif
	if (!m_isActive) {
#if LOG_CHAKER_INPUTS
		NSLog(@"18051 Sorry, not active") ;
#endif
		return ;
	}

	if (
		// We get sharype changes when starks are created,
		// in Extore 'readExternal' methods and also in
		// mergeFromStartainer:::
		[key isEqualToString:constKeySharype]
		) {
		return ;
	}
	
	// Get existing stange, or add new stange
	Stange* stange = [self stangeForStark:stark
									 make:YES] ;
	BOOL keep = [stange registerUpdateKey:key
								 oldValue:oldValue
								 newValue:newValue] ;
	if (keep) {
		[stange registerBasicsFromStark:stark] ;
	}
	else {
		// Apparently, this change cancelled out the only previous change
		// that existed in this Stange.  So, we delete it.
		[self removeStangeForStark:stark] ;		
	}
}

- (void)deleteStark:(Stark*)stark {
#if LOG_CHAKER_INPUTS
	NSLog(@"19050 %p %s %@ %@", self, __PRETTY_FUNCTION__, [stark name], [stark starkid]) ;
#endif
	if (!m_isActive) {
#if LOG_CHAKER_INPUTS
		NSLog(@"19051 Sorry, not active") ;
#endif
		return ;
	}
    
	// Note: In case this stark has already been deleted
	// from the managed object context, be careful not to do anything which
	// would access its properties.  Such doing would probably cause Core Data
	// to throw one of its "could not fulfill a fault" tantrums.
	
	// See if this stark is already registered.  (For example, it could be
	// a new addition, which is now being deleted because it later
	// became an empty folder.)
	Stange* stange = [self stangeForStark:stark
									 make:NO] ;

	// Prior to BookMacster 1.6.4, at this point I would branch
	// depending on the stange's existing changeType.  If the change
	// type was SSYModelChangeActionInsert, instead of executing the
	// code below, registering as a deletion, I would simply "cancel"
	// the previous insertion by removing the stange.  The problem 
	// with that was then the stange would not be present when this
	// Chaker's stanges were enumerated in
	// -[SSYOperation(Operation_Common) actuallyDelete_unsafe
	// and, thus the stark would not get deleted.  To fix this,
	// I defined a new change type, SSYModelChangeActionCancel,
	// and set the change type to that in -registerDelete in the
	// event that this deletion is cancelling an insertion.  The
	// new SSYModelChangeActionCancel is detected in 
	// -[SSYOperation(Operation_Common) actuallyDelete_unsafe
	// but is ignored when creating the summaries in
	// -endForImporters:exporter:isTestRun: and -changeCounts.

	// Register as a deletion
	if (!stange) {
		stange = [self stangeForStark:stark
								 make:YES] ;
	}
	[stange registerDelete] ;
	[stange registerBasicsFromStark:stark] ;
	// The following is intended to be nil for an export/exporter.
	[stange setFromDisplayName:[self fromDisplayName]] ;
}

- (void)tagsHaveBeenAffectedInExtore:(Extore*)extore {
#if LOG_CHAKER_INPUTS
    NSLog(@"19450 %p %s %@", self, __PRETTY_FUNCTION__, [extore displayName]) ;
#endif
    if (!m_isActive) {
#if LOG_CHAKER_INPUTS
        NSLog(@"19051 Sorry, not active") ;
#endif
        return ;
    }
    
    if (!m_extoresWithAffectedTags) {
        m_extoresWithAffectedTags = [NSMutableSet new];
    }
    
    [m_extoresWithAffectedTags addObject:extore];
}

- (SSYModelChangeCounts)changeCounts {
	// Note: Since the deleted starks have presumably been actually deleted
	// from the managed object context, be careful not to do anything which
	// would access their properties.  Such doing would probably cause Core Data
	// to throw one of its "could not fulfill a fault" tantrums.
	SSYModelChangeCounts counts = {0,0,0} ;
	for (Stange* stange in [[self stanges] allValues]) {
		switch ([stange changeType]) {
			case SSYModelChangeActionInsert:
				counts.added++ ;
				break;
			case SSYModelChangeActionMosh:
			case SSYModelChangeActionSlosh:
			case SSYModelChangeActionModify:
				counts.updated++ ;
				break;
			case SSYModelChangeActionMove:
				counts.moved++ ;
				break;
			case SSYModelChangeActionSlide:
				counts.slid++ ;
				break;
			case SSYModelChangeActionRemove:
				counts.deleted++ ;
				break;
			case SSYModelChangeActionCancel:
				break;
			default:
				NSLog(@"Internal Error 138-9256 %ld %@", (long)[stange changeType], [[stange stark] shortDescription]) ;
				break;
		}
	}
		 
	return counts ;
}

- (void)begin {
#if LOG_CHAKER_INPUTS
	NSLog(@"16040 %s %p (Nilling stanges)", __PRETTY_FUNCTION__, self) ;
#endif
	// Note: Since the deleted starks have presumably been actually deleted
	// from the managed object context, be careful not to do anything which
	// would access their properties.  Such doing would probably cause Core Data
	// to throw one of its "could not fulfill a fault" tantrums.
	[m_stanges release] ; m_stanges = nil ;
    [m_extoresWithAffectedTags release]; m_extoresWithAffectedTags = nil;

	m_isActive = YES ;
}

- (BOOL)hasChangesForExtore:(Extore*)extore {
    if ([m_extoresWithAffectedTags containsObject:extore]) {
        return YES;
    }

    for (Stange* stange in [[self stanges] allValues]) {
		Stark* stark = [stange stark] ;
		id owner = [stark owner] ;
		if (owner == extore) {
			return YES ;
		}
	}
	
	return NO ;
}

- (NSString*)displayStatistics {
	SSYModelChangeCounts counts = [self changeCounts] ;
	return [NSString stringWithFormat:
			@"%@%ld, %@%ld, %@%ld, %@%ld, %@%ld",
			[SSYModelChangeTypes symbolForAction:SSYModelChangeActionInsert],
			(long)counts.added,
			[SSYModelChangeTypes symbolForAction:SSYModelChangeActionModify],
			(long)counts.updated,
			[SSYModelChangeTypes symbolForAction:SSYModelChangeActionMove],
			(long)counts.moved,
			[SSYModelChangeTypes symbolForAction:SSYModelChangeActionSlide],
			(long)counts.slid,
			[SSYModelChangeTypes symbolForAction:SSYModelChangeActionRemove],
			(long)counts.deleted] ;
}

- (IxportLog*)endForImporters:(NSArray*)importers
                     exporter:(Ixporter*)exporter
                    isTestRun:(NSNumber*)isTestRun {
	BkmxDoc* bkmxDoc = [self bkmxDoc] ;
	Macster* macster = [[BkmxBasis sharedBasis] macsterWithDocUuid:[bkmxDoc uuid]
													  createIfNone:NO] ;
	SSYProgressView* progressView = [bkmxDoc progressView] ;

	IxportLog* ixportLog = nil ;
	
    progressView = [progressView setIndeterminate:YES
                                withLocalizedVerb:[NSString localizeFormat:
                                                   @"summarizingX",
                                                   [NSString localize:@"changes"]]
                                         priority:SSYProgressPriorityRegular] ;

	NSInteger daysLimit = [[macster daysDiary] integerValue] ;
	if (daysLimit > 0) {
		NSString* entityName = (!exporter) ? constEntityNameImportLog : constEntityNameExportLog ;
		NSManagedObjectContext* moc = [[BkmxBasis sharedBasis] diariesMocForIdentifier:[bkmxDoc uuid]] ;
		ixportLog = [NSEntityDescription insertNewObjectForEntityForName:entityName
												  inManagedObjectContext:moc] ;	
		if (exporter) {
			[(ExportLog*)ixportLog setExporterDisplayName:[exporter displayName]] ;
			[(ExportLog*)ixportLog setExporterUri:[exporter objectUriMakePermanent:YES
                                                                          document:nil]] ;
		}
		else if (importers.count > 0) {
			[(ImportLog*)ixportLog setImportersDisplayList:[importers listValuesForKey:@"displayName"
                                                                           conjunction:nil
                                                                            truncateTo:0]] ;
		}
		
		NSString* whoDo ;
		if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
			whoDo = NSUserName() ;
		}
		else {
			NSInteger agentIndex = [[AgentPerformer sharedPerformer] activeAgentIndex] ;
			whoDo = [NSString stringWithFormat:
					 @"%@ %ld",
					 [[BkmxBasis sharedBasis] labelSyncer],
					 (long)(agentIndex + 1)] ;
			// We added 1 to get the 1-based syncer index.
		}
		[ixportLog setWhoDo:whoDo] ;
		
		if (isTestRun) {
			[ixportLog setErrorCode:[NSNumber numberWithLong:constBkmxErrorIsTestRun]] ;
		}

		[ixportLog setDisplayStatistics:[self displayStatistics]] ;

		NSInteger nextIxportSerial = [[BkmxBasis sharedBasis] lastIxportSerialValueForBkmxDocUuid:[bkmxDoc uuid]] + 1 ;
		[ixportLog setSerialNumber:[NSNumber numberWithInteger:nextIxportSerial]] ;


		if ([[self stanges] count] > 0) {
			SSYMojo* starkoidMojo = [[SSYMojo alloc] initWithManagedObjectContext:[[BkmxBasis sharedBasis] diariesMocForIdentifier:[bkmxDoc uuid]]
																	   entityName:constEntityNameStarkoid] ;

			[progressView setMaxValue:[[self stanges] count]] ;  // Also changes it to be determinate
			for (Stange* stange in [[self stanges] allValues]) {
				[progressView incrementDoubleValueBy:1.0] ;
				
				SSYModelChangeAction changeType = [stange changeType] ;
				if (changeType == SSYModelChangeActionCancel) {
					// Insertion + Deletion should not go into the permanent record
					continue ;
				}
				
				Starkoid* starkoid = (Starkoid*)[starkoidMojo freshObject] ;
				[ixportLog addStarkoidsObject:starkoid] ;
				[starkoid setChangeType:[NSNumber numberWithInteger:changeType]] ;
				[starkoid setSharypeCoarse:[NSNumber numberWithInteger:[stange sharypeCoarse]]] ;
				NSString* lineage ;
				if ([[stange stark] isRoot]) {
					// [stark lineageLineDoSelf:doOwner:] returns "" for root
					lineage = [[stange lineage] firstObjectSafely] ;
				}
				else if (changeType != SSYModelChangeActionRemove) {
					// stange's stark should be still alive and have a current lineage.
					// Use it, since it may have moved from the previous-recorded [stange lineage].
					lineage = [[stange stark] lineageLineDoSelf:YES
															 doOwner:NO] ;
					// This is indeed necessary for new add/inserts, because when a stark is inserted
					// it is usually an orphan and thus [stange lineage] would be only its own name.
				}
				else {
					// stange's stark is deleted.  Use the lineage recorded at time of death.
					lineage = [Stark lineageLineWithLineageNames:[stange lineage]] ;
					// I suppose that sending -lineageLineDoSelf:doOwner: to a deleted Stark would
					// result in a "Core Data could not fulfill a fault" tantrum.
				}
				[starkoid setLineage:lineage] ;
				[starkoid setFromDisplayName:[stange fromDisplayName]] ;
				
				NSMutableArray* updates = [[NSMutableArray alloc] init] ;
				NSDictionary* rawUpdates = [stange updates] ;
				// The 'if' below was added in BookMacster 1.3.19 in order
				// to eliminate updates such as
				// "CHANGE Parent Folder FROM Nothing TO Foo" for additions,
				// "CHANGE Parent Folder FROM Foo to Nothing" for deletions.
				if (
					(changeType != SSYModelChangeActionInsert
					 )
					&&
					(changeType != SSYModelChangeActionRemove)
					) {
					for (NSString* key in rawUpdates) {
						NSDictionary* rawUpdate = [rawUpdates objectForKey:key] ;
						id oldValue = [rawUpdate objectForKey:NSKeyValueChangeOldKey] ;
						id newValue = [rawUpdate objectForKey:NSKeyValueChangeNewKey] ;
						[updates addObject:[key localizedUpdateDescriptionFromValue:oldValue
																			toValue:newValue
																	fromDisplayName:[self fromDisplayName]]] ;
					}
				}
				// Get changed children and tags, transform them into update descriptions (strings), and
				// add the update descriptions to the update for the other keys.
				NSArray* array ;
				array = [stange deletedChildren] ;
				if ([array count] > 0) {
					[updates addObject:[constKeyChildren localizedUpdateDescriptionForDeletions:array]] ;
				}
				array = [stange addedChildren] ;
				if ([array count] > 0) {
					[updates addObject:[constKeyChildren localizedUpdateDescriptionForAdditions:array]] ;
				}
				array = [stange deletedTags] ;
				if ([array count] > 0) {
					[updates addObject:[constKeyTags localizedUpdateDescriptionForDeletions:array]] ;
				}
				array = [stange addedTags] ;
				if ([array count] > 0) {
					[updates addObject:[constKeyTags localizedUpdateDescriptionForAdditions:array]] ;
				}
					 
				[starkoid setUpdateDescriptions:updates] ;
				[updates release] ;
			}
			[starkoidMojo release] ;
		}
	}
		
	[progressView setIndeterminate:YES
                 withLocalizedVerb:[NSString localize:@"logging"]
                          priority:SSYProgressPriorityRegular] ;
	Bookshig* shig = [bkmxDoc shig] ;
	// The following can take a second or more
	[[BkmxBasis sharedBasis] saveDiariesMocForIdentifier:bkmxDoc.uuid] ;
	[shig setIxportDoneDummyForKVO:![shig ixportDoneDummyForKVO]] ;		
	m_isActive = NO ;
	[progressView clearAll] ;

	return ixportLog ;
}

@end
