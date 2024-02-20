#if USE_LOCAL_DOT_SQL_CACHES_WHEN_IMPORTING_WEB_EXTORES
#warning Using Local Caches for ExtoreWebFlat Clients
#endif

#import <Bkmxwork/Bkmxwork-Swift.h>
#import "Extore.h"
#import "NSError+DecodeCodes.h"
#import "NSError+MyDomain.h"
#import "NSError+SuggestMountVolume.h"
#import "NSError+SSYInfo.h"
#import "NSError+Recovery.h"
#import "BkmxAppDel+Capabilities.h"
#import "ExtensionsMule.h"
#import "BkmxBasis+Strings.h"
#import "Client+SpecialOptions.h"
#import "ClientChoice.h"
#import "NSArray+Whitespace.h"
#import "NSDate+SafeCompare.h"
#import "NSError+InfoAccess.h"
#import "NSNumber+Sharype.h"
#import "NSObject+DoNil.h"
#import "NSString+SSYDotSuffix.h"
#import "NSString+LocalizeSSY.h"
#import "NSString+MorePaths.h"
#import "Chromessenger.h"
#import "SSYMOCManager.h"
#import "SSYOtherApper.h"
#import "TagMap.h"
#import "Macster.h"
#import "SSYProgressView.h"
#import "SSYUuid.h"
#import "Stark+Attributability.h"
#import "Starker.h"
#import "NSObject+MoreDescriptions.h"  // for mkdir()
#import "NSFileManager+SomeMore.h"
#import "BkmxDoc.h"
#import "SSYSynchronousHttp.h"
#import "Operation_Common.h"
#import "NSUserDefaults+Bkmx.h"
#import "NSFileManager+TempFile.h"
#import "SSYInterappClient.h"
#import "SSYShellTasker.h"
#import "Stange.h"
#import "SSYInterappServer.h"
#import "OperationExport.h"
#import "NSDictionary+BSJSONAdditions.h"
#import "Chaker.h"
#import "NSDate+LongLong1970.h"
#import "Importer.h"
#import "NSArray+SortDescriptorsHelp.h"
#import "NSArray+SSYMutations.h"
#import "SSYMH.AppAnchors.h"
#import "AgentPerformer.h"
#import "SSYPathWaiter.h"
#import "SSYOperationQueue.h"
#import "NSUserDefaults+KeyPaths.h"
#import "NSBundle+SSYMotherApp.h"
#import "NSUserDefaults+MainApp.h"
#import "NSBundle+MainApp.h"
#import "SSYSQLiter.h"
#import "NSDate+NiceFormats.h"
#import "NSString+SSYExtraUtils.h"
#import "NSCharacterSet+SSYMoreCS.h"
#import "NSDate+Microsoft1601Epoch.h"
#import "Job.h"
#import "NSSet+SSYJsonClasses.h"
#import "NSInvocation+Nesting.h"
#import "NSInvocation+MoreDescriptions.h"

// The following are defined in the .h file.  Please change them there, not here!
#ifdef LOCAL_FILE_PATH_TO_OVERRIDE_EXTOREWEBFLAT_DOWNLOAD
#warning Reading web app data from local test file.  Don't ship this!
#endif
#if IS_EXPORTABLE_STARK_WILL_ALWAYS_RETURN_YES
#warning All -isExportableStark:withChange: methods for all Extore subclasses will always return YES
#endif
#if DEBUG_WRITE_IMPORTED_URLS_TO_FILES
#warning Will debug by writing imported URLs to files
#endif
#if DONT_USE_LOCAL_CACHES
#warning Will never use Extores' Local Caches
#endif

static NSDateFormatter* static_snapshotDateFormatter = nil ;
static NSMutableDictionary* static_editableAttributeArrays = nil ;

/*
 Constants for holding display names of hard containers during an export
 */
NSString* const constKeyExtoreLabelOfBar = @"extoreLabelOfBar" ;
NSString* const constKeyExtoreLabelOfMenu = @"extoreLabelOfMenu" ;
NSString* const constKeyExtoreLabelOfUnfiled = @"extoreLabelOfUnfiled" ;
NSString* const constKeyExtoreLabelOfOhared = @"extoreLabelOfOhared" ;

NSString* const constKeyGuid = @"guid";

NSString* const constKeyFileHeader = @"fileHeader" ;
NSString* const constKeyFileSubheader = @"fileSubheader" ;
NSString* const constKeyFileTrailer = @"fileFooter" ;

NSString* const constDisplayNameNotUsed = @"<HARTAINER-NOT-USED-THIS-EXTORE>" ;  // Was: Internal Error 615-0393

NSString* const constKeyExtoreStashedUnderlyingError = @"extoreStashedUnderlyingError" ;

NSString* const constKeyMetaInfo = @"meta_info" ;
NSString* const constKeySyncTransactionVersion = @"sync_transaction_version" ;

NSString* const constKeyReadExternalOperation = @"readExternalOperation";
NSString* const constKeyReadExternalMule = @"readExternalMule";


@interface SnapshotFileMetadata : NSObject

@property (copy) NSString* path;
@property (assign) double modificationDateTimeInterval;
@property (assign) NSInteger size;

@end

@implementation SnapshotFileMetadata

- (void)dealloc {
    [_path release];
    
    [super dealloc];
}

- (NSString*)description {
    return [NSString stringWithFormat:
            @"%15.0f %9ld %@",
            self.modificationDateTimeInterval,
            self.size,
            self.path];
}

@end


@interface Extore ()

@property (copy) NSString* runningBundleIdentifier ;
@property (copy) NSString* tearDowner;
@property (assign) BOOL didReadExternal;
@property (copy) void (^readExternalCompletionHandler) (void);

@end


@implementation Extore

+ (ExtoreConstants)extoreConstants {
    return *[self constants_p];
}

#pragma mark * Class Methods

+ (NSArray*)browserBundleIdentifiers {
    return nil ;
}

+ (NSString*)labelBar {
    return [NSString localize:@"000_Safari_bookmarksBar"] ;
}

+ (NSString*)labelMenu {
    return [NSString localize:@"004_Chrome_otherBookmarks"] ;
}

+ (NSString*)labelUnfiled {
    return [NSString localize:@"000_Safari_bookmarksReadingList"] ;
}

+ (NSString*)labelOhared {
    return [NSString localize:@"003_OmniWeb_Shared"] ;
}

- (NSString*)labelBar {
    return [[self class] labelBar] ;
}

- (NSString*)labelMenu {
    return [[self class] labelMenu] ;
}

- (NSString*)labelUnfiled {
    return [[self class] labelUnfiled] ;
}

- (NSString*)labelOhared {
    return [[self class] labelOhared] ;
}

+ (const ExtoreConstants*)constants_p {
	// This method must be overridden by subclasses.
	// Returning 0 is definitely going to cause a crash, so we raise a nice exception
	NSString* eName = @"Internal Error 458-6425" ;
	NSString* eReason = [NSString stringWithFormat:@"No override of +constants_p for class %@", [self class]] ;
	[[NSException exceptionWithName:eName
							 reason:eReason
						   userInfo:nil] raise] ;
	return 0 ; 
}

+ (BOOL)canEditCommentsInStyle:(NSInteger)style {
    BkmxCanEditInStyle capability = [self constants_p]->canEditComments;
    return (capability & style) > 0;
}

+ (BOOL)canEditCommentsInAnyStyle {
    return [self constants_p]->canEditComments != BkmxCanEditInStyleNeither;
}

+ (BOOL)canEditSeparatorsInStyle:(NSInteger)style {
    BkmxCanEditInStyle capability = [self constants_p]->canEditSeparators;
    return (capability & style) > 0;
}

+ (BOOL)canEditSeparatorsInAnyStyle {
    return [self constants_p]->canEditSeparators != BkmxCanEditInStyleNeither;
}

- (BOOL)canEditSeparatorsInAnyStyle {
    return [[self class] canEditSeparatorsInAnyStyle];
}

+ (BOOL)canEditShortcutInStyle:(NSInteger)style {
    BkmxCanEditInStyle capability = [self constants_p]->canEditShortcut;
    return (capability & style) > 0;
}

+ (BOOL)canEditShortcutInAnyStyle {
    return [self constants_p]->canEditShortcut != BkmxCanEditInStyleNeither;
}

+ (BOOL)canEditTagsInStyle:(NSInteger)style {
    BkmxCanEditInStyle capability = [self constants_p]->canEditTags;
    return (capability & style) > 0;
}

+ (BOOL)canEditTagsInAnyStyle {
    return [self constants_p]->canEditTags != BkmxCanEditInStyleNeither;
}

+ (BOOL)supportsMultipleProfiles {
    return NO;
}

+ (BOOL)supportsExids {
    return YES;
}

+ (BOOL)canDetectOurChanges {
	return NO ;
}

+ (OwnerAppObservability)ownerAppObservability {
    return [self constants_p]->ownerAppObservability;
}

+ (BOOL)isLiveObservability:(OwnerAppObservability)observability {
	BOOL answer = ( 
				   ((observability & OwnerAppObservabilitySpecialFile) != 0)
				   ||
				   ((observability & OwnerAppObservabilityBookmarksFile) != 0)
				   ) ;
	return answer ;
}

+ (BOOL)canDoLiveObservability {
	OwnerAppObservability observability = [self ownerAppObservability] ;
	return [self isLiveObservability:observability] ;
}

+ (BOOL)canHaveSharype:(Sharype)sharype {
    BOOL answer ;
    if ((sharype & (SharypeCoarseHartainer)) > 0) {
        switch (sharype) {
            case SharypeBar:
                answer = [self constants_p]->hasBar ;
                break ;
            case SharypeMenu:
                answer = [self constants_p]->hasMenu ;
                break ;
            case SharypeUnfiled:
                answer = [self constants_p]->hasUnfiled ;
                break ;
            case SharypeOhared:
                answer = [self constants_p]->hasOhared ;
                break ;
            case SharypeRoot:
                answer = YES ;
                break ;
            default:
                NSLog(@"Internal Error 524-2929 0x%lx", (long)sharype) ;
                answer = YES ;
        }
    }
    // The remaining branches never execute as of this writing, because
    // this message is only sent to containers.  But they are included for
    // logical completeness, which may prevent future bugs.
    else if ((sharype & (SharypeCoarseSoftainer)) > 0) {
        answer = [self constants_p]->hasFolders ;
    }
    else if ((sharype & (SharypeCoarseNotch)) > 0) {
        answer = [self canEditSeparatorsInAnyStyle] ;
    }
    else if ((sharype & (SharypeCoarseLeaf)) > 0) {
        answer = YES ;
    }
    else {
        // The following was commented out in BookMacster 1.19.4
        // NSLog(@"Internal Error 524-7771 0x%lx", (long)sharype) ;
        answer = YES ;
    }
    
    return answer ;
}

+ (BOOL)liveRssAreImmutable {
    return NO ;
}

+ (BOOL)canEditAttribute:(NSString*)key
                 inStyle:(BkmxIxportStyle)style {
    return ([[self editableAttributesInStyle:style] indexOfObject:key] != NSNotFound) ;
}

- (BOOL)canEditAttribute:(NSString *)key
                 inStyle:(BkmxIxportStyle)style {
    return [[self class] canEditAttribute:key
                                  inStyle:style] ;
}

+ (NSString*)tagDelimiter {
	return [self constants_p]->tagDelimiter ;
}

+ (NSArray*)tagArrayFromString:(NSString*)string {
	NSString* delimiter = [self tagDelimiter] ;
	NSArray* array = [string componentsSeparatedByString:delimiter] ;
	array = [array arrayByTrimmingWhitespaceFromStringsAndRemovingEmptyStrings] ;
	
	return array ;
}

+ (NSString*)tagStringFromArray:(NSArray*)array {
	return [array componentsJoinedByString:[self tagDelimiter]] ;
}

+ (Class)extoreClassForExformat:(NSString*)exformat {
	Class extoreClass = nil ;
	if (exformat) {
		NSString* extoreClassName = [@"Extore" stringByAppendingString:exformat] ;
		extoreClass = NSClassFromString(extoreClassName) ;
	}
	return extoreClass ;
}

+ (NSString*)exformatForExtoreClass:(Class)class {
	if (!class) {
		return nil ;
	}
	NSString* s = NSStringFromClass(class) ;
	if ([s length] > 6) {
		s = [s substringFromIndex:6] ;
	}
	else {
		s = nil ;
	}
	
	return s ;
}

+ (NSString*)baseNameFromClassName:(NSString*)className {
    NSString* baseName = nil;
    if (className.length > 6) {
        // @"Omit the first 6 characters which are E,x,t,o,r,e
        baseName = [className substringFromIndex:6] ;
    }
    
    return baseName;
}

+ (NSString*)baseName {
    return [self baseNameFromClassName:[self className]];
}

+ (NSString*)webHostName {
	return [self constants_p]->webHostName ;
}

+ (NSString*)ownerAppDisplayName {
	return [self constants_p]->ownerAppDisplayName ;
}

+ (NSString*)defaultFilename {
	return [self constants_p]->defaultFilename ;
}

+ (NSString*)defaultProfileName {
    return [self constants_p]->defaultProfileName ;
}

+ (NSString*)fileParentRelativePath {
	return @"Internal Error 147-2520" ;
}

+ (NSString*)extraBrowserSupportPathForSpecialManifest {
    return nil;
}

+ (PathRelativeTo)fileParentPathRelativeTo {
	return PathRelativeToApplicationSupport ;
}

+ (NSString*)specialNibName {
	NSString* answer = [NSString stringWithFormat:
						@"Special%@",
						[self baseName]];
	return answer ;						
}

+ (CGFloat)multiplierForHttpHighRateInitial {
	return 1.0 ;
}


+ (NSString*)ownerAppLocalPath {
	NSString* ownerAppFullPath = nil ;
	if ([self constants_p]->ownerAppIsLocalApp) {
        for (NSString* bundleIdentifier in [self browserBundleIdentifiers]) {
            ownerAppFullPath = [SSYOtherApper fullPathForAppWithBundleIdentifier:bundleIdentifier] ;
            if (ownerAppFullPath) {
                break ;
            }
        }
	}
	
	return ownerAppFullPath ;
}

- (BOOL)rootLeavesOk {
	return [self parentSharype:SharypeRoot
           canHaveChildSharype:SharypeCoarseLeaf] ;
}

- (BOOL)rootSoftainersOk {
    return [self parentSharype:SharypeRoot
           canHaveChildSharype:SharypeCoarseSoftainer] ;
}

- (BOOL)rootNotchesOk {
    return [self parentSharype:SharypeRoot
           canHaveChildSharype:SharypeCoarseNotch] ;
}

+ (BOOL)rootLeavesOk {
    return [self parentSharype:SharypeRoot
           canHaveChildSharype:SharypeCoarseLeaf] ;
}

+ (BOOL)rootSoftainersOk {
    return [self parentSharype:SharypeRoot
           canHaveChildSharype:SharypeCoarseSoftainer] ;
}

+ (BOOL)rootNotchesOk {
    return [self parentSharype:SharypeRoot
           canHaveChildSharype:SharypeCoarseNotch] ;
}

+ (Sharype)fosterSharypeForSharype:(Sharype)sharype {
    NSMutableArray* candidates = [[NSMutableArray alloc] init] ;
    Sharype fosterSharype = SharypeBar ;  // default, should always be overwritten

    if ([self constants_p]->hasBar) {
        [candidates addObject:[NSNumber numberWithSharype:SharypeBar]] ;
    }
    if ([self constants_p]->hasMenu) {
        [candidates addObject:[NSNumber numberWithSharype:SharypeMenu]] ;
    }
    if ([self constants_p]->hasUnfiled) {
        [candidates addObject:[NSNumber numberWithSharype:SharypeUnfiled]] ;
    }
    if ([self constants_p]->hasOhared) {
        [candidates addObject:[NSNumber numberWithSharype:SharypeOhared]] ;
    }
    
    Sharype coarseSharype = [StarkTyper coarseTypeSharype:sharype] ;
    if (coarseSharype == SharypeCoarseLeaf) {
        if ([self rootLeavesOk]) {
            [candidates addObject:[NSNumber numberWithInteger:SharypeRoot]] ;
        }
    }
    else if (coarseSharype == SharypeCoarseSoftainer) {
        if ([self rootSoftainersOk]) {
            [candidates addObject:[NSNumber numberWithInteger:SharypeRoot]] ;
        }
    }
    else if (coarseSharype == SharypeCoarseNotch) {
        if ([self rootNotchesOk]) {
            [candidates addObject:[NSNumber numberWithInteger:SharypeRoot]] ;
        }
    }
    else {
        [candidates addObject:[NSNumber numberWithInteger:SharypeRoot]] ;
    }
    
    for (NSNumber* candidate in candidates) {
        Sharype proposedParentSharype = [candidate unsignedShortValue] ;
        if ([self parentSharype:proposedParentSharype
            canHaveChildSharype:sharype]) {
            fosterSharype = proposedParentSharype ;
        }
    }
#warning Confusion.preferredCatchype+anyStarkCatchypeOrder
    /*  This method is probably not doing what was intended.
     This method will return te *last* sharype in the following list
     Bar
     Menu
     Unfiled
     Ohared
     Root
     which (a) exists in the receiver and (b) can have the given child sharype.
     But since the loop starts with the first item, there is wasted work.  Why
     did I not use a reverse enumerator, to start at the end, and put a break;
     at the end of the loop, to eliminate wasted work.  Or maybe I really
     wanted the *first* item in the loop satisfying conditiona (a) and (b) and
     just neglected to code the break;
     
     The preferredCatchype managed properties of Macster and Exporter are used
     during imports (Macster) and exports (Exporter).  The values are
     controllable by the user, for exporters, in the Client Advanced Settings,
     and importers in the Import Postprocessing sheet.  Does anyone set them
     other than to the default value of Root?
     
     Another broad question: The anyStarkCatchypeOrder property, which is
     defined in the Exporter enity, the Macster entity (for imports) and
     as a hidden preference in User Defaults, appears to be unused.  It seems
     like it should be used to set the order of `candidates` in this method.
     What would be the consequences of doing that?
     
     Also see CONFIGURE_PREFERRED_CATCHYPE_DEPENDING_ON_CLIENT_EXFORMAT. */
    
    [candidates release] ;
    
    return fosterSharype ;
}

- (NSInteger)indexOffsetForRoot {
    return 0;
}

- (Stark*)fosterParentForStark:(Stark *)stark {
    Sharype sharype = [stark sharypeValue] ;
    Sharype fosterSharype = [[self class] fosterSharypeForSharype:sharype] ;
    Stark* fosterParent = [[self starker] hartainerOfSharype:fosterSharype
                                                     quickly:YES] ;
    
    // Added in BookMacster 1.19.7, to avoid returning nil in edge cases.
    // Assign one arbitrarily.
    if (!fosterParent) {
        fosterParent = [[self starker] unfiled] ;
        if (!fosterParent) {
            fosterParent = [[self starker] bar] ;
            if (!fosterParent) {
                fosterParent = [[self starker] menu] ;
                if (!fosterParent) {
                    fosterParent = [[self starker] ohared] ;
                    if (!fosterParent) {
                        // This may be disallowed, but we have no choice at this point
                        fosterParent = [[self starker] root] ;
                    }
                }
            }
        }
    }
    
    return fosterParent ;
}

- (BOOL)parentSharype:(Sharype)parentSharype
  canHaveChildSharype:(Sharype)childSharype {
    return [[self class] parentSharype:parentSharype
                   canHaveChildSharype:childSharype] ;
}

+ (BOOL)parentSharype:(Sharype)parentSharype
  canHaveChildSharype:(Sharype)childSharype {
    Sharype coarseParentSharype = [StarkTyper coarseTypeSharype:parentSharype] ;
    BOOL ok = (
               (coarseParentSharype == SharypeCoarseSoftainer)
               ||
               (coarseParentSharype == SharypeCoarseHartainer)
               ) ;
    return ok ;
}

+ (Extore*)extoreForIxporter:(Ixporter*)ixporter
                   clientoid:(Clientoid*)clientoid
                   jobSerial:(NSInteger)jobSerial
					 error_p:(NSError**)error_p {
	NSError* error = nil ;
    Class class = nil;
	Extore* instance = nil ;

    if (clientoid) {
        class = clientoid.extoreClass;
        if (!class) {
            error = SSYMakeError(541675, @"Passed-in Clientoid has no extoreClass");
            error = [error errorByAddingUserInfoObject:clientoid
                                                forKey:@"Clientoid"];
        }
    } else if (ixporter) {
        if ([ixporter isAvailable]) {
            Client* client = ixporter.client;
            if (client) {
                class = [client extoreClass];
                if (!class) {
                    error = SSYMakeError(541676, @"Client has no extoreClass");
                    error = [error errorByAddingUserInfoObject:[client shortDescription]
                                                        forKey:@"Client"];
                    error = [error errorByAddingUserInfoObject:client.clientoid
                                                        forKey:@"Client's Clientoid"];
                }
            } else {
                error = SSYMakeError(541679, @"Ixporter has no client") ;
            }
            error = [error errorByAddingUserInfoObject:[ixporter shortDescription]
                                                forKey:@"Ixporter"];
        } else {
            error = SSYMakeError(541948, @"Ixporter not available (has it been deleted?)") ;
            error = [error errorByAddingUserInfoObject:[NSValue valueWithPointer:ixporter]
                                                forKey:@"Ixporter Pointer"] ;
            error = [error errorByAddingUserInfoObject:[NSNumber numberWithBool:[ixporter isDeleted]]
                                                forKey:@"ixporter -> isDeleted"] ;
            error = [error errorByAddingUserInfoObject:[[ixporter managedObjectContext] description]
                                                forKey:@"ixporter -> managedObjectContext"] ;
        }
        error = [error errorByAddingUserInfoObject:clientoid
                                            forKey:@"Passed-In Clientoid"];
    } else {
        error = SSYMakeError(541951, @"No Clientoid nor Ixporter") ;
    }
    
    if (class) {
        instance = [[class alloc] initWithIxporter:ixporter
                                         clientoid:clientoid
                                         jobSerial:jobSerial] ;
        if (!instance) {
            error = [SSYMakeError(541654, @"Could not initialize extore") errorByAddingUnderlyingError:error];
        }
    }

    if (!instance && error_p) {
        NSString* displayName = nil;;
        if (clientoid) {
            displayName = clientoid.displayName;
        }
        if (!displayName) {
            displayName = ixporter.client.displayName;
        }
        error = [error errorByAddingUnderlyingError:error];
		NSString* msg = [NSString stringWithFormat:
						 @"Click the Settings > Clients tab, and make sure that Client %ld, %@, names an existing web browser, account, or file.  "
						 @"Even if it looks OK, try to click its name popup and re-set it.",
						 (long)([[[ixporter client] index] integerValue] + 1),
                         displayName];
		error = [error errorByAddingLocalizedRecoverySuggestion:msg] ;
		*error_p = error ;
	}
	
	return [instance autorelease] ;
}

+ (BOOL)syncExtensionAvailable {
	return NO ;
}

+ (BOOL)hasProprietarySyncThatNeedsOwnerAppRunning {
    return NO ;
}

+ (BOOL)requiresStyle2WhenProprietarySyncIsActive {
    return NO;
}

+ (BOOL)addonSupportsPurpose:(NSInteger)purpose {
	return NO ;
}

+ (void)addExidsFromArray:(NSArray*)array
                    toSet:(NSMutableSet*)set {
    for (NSDictionary* change in array) {
        if ([change respondsToSelector:@selector(objectForKey:)]) {  // Defensive programming because this comes from a file
            NSString* exid = [change objectForKey:@"exid"] ;
            if ([exid respondsToSelector:@selector(isEqualToString:)]) {  // Defensive programming because this comes from a file
                [set addObject:exid];
            } else {
                NSLog(@"Internal Error 524-4958 %@ is %@", exid, [exid className]);
            }
        }
    }
}

+ (BOOL)detectedChanges:(NSArray*)detectedChanges
   notInExportedChanges:(NSDictionary*)exportedChanges {
    NSMutableSet* cutIds = [[NSMutableSet alloc] init] ;
    [self addExidsFromArray:[exportedChanges objectForKey:@"cuts"]
                      toSet:cutIds] ;
    NSMutableSet* putIds = [[NSMutableSet alloc] init] ;
    [self addExidsFromArray:[exportedChanges objectForKey:@"puts"]
                      toSet:putIds] ;
    NSMutableSet* repairIds = [[NSMutableSet alloc] init] ;
    [self addExidsFromArray:[exportedChanges objectForKey:@"repairs"]
                      toSet:repairIds] ;

    NSString* limboExid = nil ;
    NSInteger i = 0 ;
    BOOL answer = NO ;
    NSInteger lastIndex = [detectedChanges count] ;
    for (NSDictionary* change in detectedChanges) {
        ++i ;  // In case I put in more 'continue ;' statements

        // Defensive programming
        if (![change respondsToSelector:@selector(objectForKey:)]) {
            NSLog(@"Internal Error 194-3921 %@ %@", [change className], change) ;
            answer = YES ;
            break ;
        }

        if (i == 1) {
            // First change could be adding Limbo
            NSString* title = [change objectForKey:@"title"] ;
            if (title) {  // Most change dics do not have titles
                if ([title respondsToSelector:@selector(isEqualToString:)]) {
                    if ([title isEqualToString:@"Limbo (Sheep Systems)"]) {
                        limboExid = [change objectForKey:@"affectedId"] ;
                        if (![limboExid respondsToSelector:@selector(isEqualToString:)]) {
                            NSLog(@"Internal Error 194-0077 %@ %@", [limboExid className], limboExid) ;
                            answer = YES ;
                            break ;
                        }
                        // Ignore Limbo creation
                        continue ;
                    }
                }
                else {
                    NSLog(@"Internal Error 194-0990 %@ %@", [title className], title) ;
                    answer = YES ;
                    break ;
                }
            }
        }
        else if (i == lastIndex) {
            // Last change could be removing Limbo
            // Limbo destruction will always be lastIndex, or there are no
            // changes in Chrome, because we will get a
            // change from Chrome every 10 seconds, and in no case
            // could a user export from BookMacster,
            // make a change in Chrome during the export,
            // make another change in BookMacster and then
            // export again, all in 10 seconds.
            if (limboExid) {
                NSString* exid = [change objectForKey:@"affectedId"] ;
                if ([exid respondsToSelector:@selector(isEqualToString:)]) {
                    if ([exid isEqualToString:limboExid]) {
                        // Ignore Limbo destruction
                        continue ;
                    }
                }
                else {
                    NSLog(@"Internal Error 194-5660 %@ %@", [exid className], exid) ;
                    answer = YES ;
                    break ;
                }
            }
        }

        NSString* affectedId = [change objectForKey:@"affectedId"] ;
        if ([affectedId respondsToSelector:@selector(isEqualToString:)]) {
            NSString* changeType = [change objectForKey:@"changeType"] ;
            if ([changeType respondsToSelector:@selector(isEqualToString:)]) {
                if (
                    [changeType isEqualToString:@"moved"] ||
                    [changeType isEqualToString:@"changed"]
                    ) {
                    if (![repairIds member:affectedId]) {
                        answer = YES ;
                        break ;
                    }
                }
                else if (
                         [changeType isEqualToString:@"created"]
                         ) {
                    if (![putIds member:affectedId]) {
                        answer = YES ;
                        break ;
                    }
                }
                else if (
                         [changeType isEqualToString:@"removed"]
                         ) {
                    if (![cutIds member:affectedId]) {
                        answer = YES ;
                        break ;
                    }
                }
                else if (
                         [changeType isEqualToString:@"importBegan"] ||
                         [changeType isEqualToString:@"importEnded"]
                         ) {
                    answer = YES ;
                    break ;
                }
            }
            else {
                NSLog(@"Internal Error 194-0441 %@ %@", [changeType className], changeType) ;
                answer = YES ;
                break ;
            }
        }
        else {
            NSLog(@"Internal Error 194-4868 %@ %@", [affectedId className], affectedId) ;
            answer = YES ;
            break ;
        }
    }
    
    [cutIds release] ;
    [putIds release] ;
    [repairIds release] ;
    
    return answer ;
}

+ (NSArray*)profileNames {
    return [NSArray array] ;
}

+ (NSArray*)profilePseudonyms:(NSString*)homePath {
    return [NSArray array] ;
}

+ (NSString*)pathForProfileName:(NSString*)profileName
                       homePath:(NSString*)homePath
                        error_p:(NSError**)error_p {
    if (error_p) {
        NSString* msg = [NSString stringWithFormat:@"Multiple profiles not supported for %@", [self ownerAppDisplayName]] ;
        *error_p = SSYMakeError(291858, msg) ;
    }
    return nil ;
}

+ (NSString*)displayProfileNameForProfileName:(NSString*)profileName {
    return profileName ;
}

+ (NSString*)displayedSuffixForProfileName:(NSString*)profileName
                                  homePath:(NSString*)homePath {
    return @"" ;
}

- (BOOL)syncExtensionAvailable {
	return [[self class] syncExtensionAvailable] ;
}

- (NSString*)messageHowToForceAutoUpdateExtensionIndex:(NSInteger)extensionIndex {
    return nil ;
}

- (BOOL)getTextForRemovalOfLegacyHartainer:(Sharype)sharype
                                   title_p:(NSString**)title_p
                                subtitle_p:(NSString**)subtitle_p
                                    body_p:(NSString**)body_p
                          helpBookAnchor_p:(NSString**)helpBookAnchor_p {
    return NO;
}

- (NSString*)doPostExportTasksAndGetMessageToUserForChangeCounts:(SSYModelChangeCounts)changeCounts {
    return nil;
}

- (BOOL)addonSupportsPurpose:(NSInteger)purpose {
	return [[self class] addonSupportsPurpose:purpose] ;
}

- (BOOL)shouldActuallyDeleteBeforeWrite {
	BOOL answer ;
	switch (self.ixportStyle) {
		case 1:
			answer = YES ;
			break ;
		case 2:
			answer = NO ;
			break ;
		default:
			// Should never happen
			answer = YES ;
	}
	
	return answer ;
}


#pragma mark * Accessors

@synthesize ixporter = m_ixporter ;
@synthesize error = m_error ;
@synthesize timeoutter = m_timeoutter ;
@synthesize userActionWaitLock = m_userActionWaitLock ;
@synthesize interappServer = m_interappServer ;
@synthesize runningBundleIdentifier = m_runningBundleIdentifier ;
@synthesize ownerAppQuinchState = m_ownerAppQuinchState ;
@synthesize exidAssignmentsToAvoid = m_exidAssignmentsToAvoid ;
@synthesize ixportStyle = m_ixportStyle;

/*
 Needed to satisfy Startainer protocol
 */
- (NSString*)displayName {
    return self.clientoid.displayName;
}

- (Chaker*)chaker {
    return nil;
}

- (NSString*)displayNameForHartainerSharype:(Sharype)sharype {
	NSString* answer = nil ;
    SEL selector = NULL ;
	switch (sharype) {
		case SharypeRoot:
			answer = [[BkmxBasis sharedBasis] labelRoot] ;
			break;
		case SharypeBar:
            selector = @selector(labelBar) ;
			break;
		case SharypeMenu:
            selector = @selector(labelMenu) ;
			break;
		case SharypeUnfiled:
            selector = @selector(labelUnfiled) ;
			break;
		case SharypeOhared:
            selector = @selector(labelOhared) ;
			break;
		default:
			answer = [NSString stringWithFormat:@"?type=%ld?", (long)sharype] ;
			NSLog(@"Internal Error 324-7945 %ld", (long)sharype) ;
	}
	
    if (selector) {
        answer = [self performSelector:selector] ;
    }
    
	return answer ;
}

- (void)updateOwnerAppQuinchState:(OwnerAppQuinchState)newState {
    switch (newState) {
        case OwnerAppQuinchStateDidQuill:
            if (m_ownerAppQuinchState == OwnerAppQuinchStateDidLaunch) {
                // This update cancels out the previous state
                m_ownerAppQuinchState = OwnerAppQuinchStateNone ;
            }
            else {
                m_ownerAppQuinchState = OwnerAppQuinchStateDidQuill ;
            }
            break ;
        case OwnerAppQuinchStateDidLaunch:
            if (m_ownerAppQuinchState == OwnerAppQuinchStateDidQuill) {
                // This update cancels out the previous state
                m_ownerAppQuinchState = OwnerAppQuinchStateNone ;
            }
            else {
                m_ownerAppQuinchState = OwnerAppQuinchStateDidLaunch ;
            }
            break ;
        case OwnerAppQuinchStateNone:
        case OwnerAppQuinchStateNeedsQuill:
        default:
            m_ownerAppQuinchState = newState ;
            break ;
    }
}

- (Clientoid*)clientoid {
    if (_clientoid) {
        return [[_clientoid copy] autorelease];
    } else {
        __block Clientoid* clientoid = nil;
        /* We must do this in a Core Data friendly manner, because
         -[Client clientoid] accesses five of Client's Core Data attributes
         to create the clientoid.  Clientoid *copies* those five attributes,
         so the clientoid we return will be free of thread restrictions. */
        Client* client = self.client;
        [client.managedObjectContext performBlockAndWait:^{
            clientoid = self.client.clientoid;
            [clientoid retain];
        }];

        [clientoid autorelease];
        return clientoid;
    }
}

- (void)setClientoid:(Clientoid*)clientoid {
    [_clientoid release];
    _clientoid = [clientoid copy];
}

- (Client*)client {
    __block Client* client;
    
    if ([NSThread isMainThread]) {
        client = [[self ixporter] client];
        [client retain];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            client = [[self ixporter] client];
            [client retain];
        });
    }
    
    [client autorelease];

	return client ;
}

- (BkmxDoc*)bkmxDoc {
	return [[[self client] macster] bkmxDoc] ;
}

- (NSMutableDictionary*)fileProperties {
	if (!m_fileProperties) {
		m_fileProperties = [[NSMutableDictionary alloc] init] ;
	}
	
	return m_fileProperties ;
}

- (NSManagedObjectContext*)transMoc {
	if (!transMoc) {
		NSString* identifier = self.clientoid.clidentifier ;
		transMoc = [SSYMOCManager managedObjectContextType:NSInMemoryStoreType
													 owner:self
												identifier:identifier
												  momdName:nil
                                         recreateIfCorrupt:NO
												   error_p:NULL] ;  // error should not occur for NSInMemoryStoreType
		// This is a cheap moc which will only live during the
		// current import or export operation,  and it has no
		// user interaction possible, so we ...
		[transMoc setUndoManager:nil] ;
	}
	
	return transMoc ;
}

- (BOOL)localMocExists {
	BOOL answer = [SSYMOCManager sqliteStoreExistsForIdentifier:self.clientoid.clidentifier] ;
	return answer ;
}

- (NSManagedObjectContext*)localMoc {
	NSError* error_ ;
	if (!localMoc) {
        NSString* identifier = self.clientoid.clidentifier ;
		localMoc = [SSYMOCManager managedObjectContextType:NSSQLiteStoreType
													 owner:self
												identifier:identifier
												  momdName:constNameMomd
                                         recreateIfCorrupt:YES
												   error_p:&error_] ;
		// There is no way for the user to undo changes in this moc,
		// so we spare the expense of an undo manager...
		[localMoc setUndoManager:nil] ;
		
		if (!localMoc) {
			[self setError:error_] ;
		}
	}
	
	return localMoc ;
}

- (void)tearDownFor:(NSString*)caller
          jobSerial:(NSInteger)jobSerial {
    NSString* tearDowner = [[NSString alloc] initWithFormat:
                         @"%@ [J%@]",
                         caller,
                         [Job serialStringForSerial:jobSerial]];
    NSString* msg = nil;
    @synchronized(self) {
        if (self.tearDowner) {
            msg = [NSString stringWithFormat:@"Whoops Prior tearDowner: %@ for %@", self.tearDowner, self];
        } else {
            self.tearDowner = tearDowner;
        }
    }
    [tearDowner release];
    
    if (msg) {
        // This extore has already been torn down
        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                    logFormat:msg];
    } else {
        [self unleaseInterappServer];
        [m_starker release];
        m_starker = nil;

        if (transMoc) {
            // See Note WhyNoResetMOC
            [SSYMOCManager destroyManagedObjectContext:transMoc];
            transMoc = nil;
        }

        if (localMoc) {
            // See Note WhyNoResetMOC
            [SSYMOCManager destroyManagedObjectContext:localMoc];
            localMoc = nil;
        }

        // To break any retain cycle
        self.ixporter.extore = nil;
        self.ixporter = nil;
    }
}

/*
 Note WhyNoResetMOC

 For a couple weeks, during development of BkmkMgrs 2.9.8, I sent the two
 MOCs each a -reset here.  I did this in order to try and make the Extore
 objects in BkmxAgent dealloc when done.  The -reset messages did not help,
 and Ilater fixed the failure to dealloc by other means.  But then on
 20171228 I saw this inexplicable crash.  Needless to say I removed the
 -reset messages.

 Crashed Thread:        0  Dispatch queue: com.apple.main-thread

 Exception Type:        EXC_BAD_ACCESS (SIGSEGV)
 Exception Codes:       KERN_INVALID_ADDRESS at 0x0000000000000020
 Exception Note:        EXC_CORPSE_NOTIFY

 Termination Signal:    Segmentation fault: 11
 Termination Reason:    Namespace SIGNAL, Code 0xb
 Terminating Process:   exc handler [19841]

 VM Regions Near 0x20:
 -->
 __TEXT                 0000000103111000-0000000103115000 [   16K] r-x/rwx SM=COW  /Applications/BookMacster.app/Contents/Library/LoginItems/BkmxAgent.app/Contents/MacOS/BkmxAgent

 Thread 0 Crashed:: Dispatch queue: com.apple.main-thread

 0   com.apple.CoreData                0x00007fff3c7393b5 -[NSManagedObjectContext discardEditing] + 37
 1   com.apple.CoreData                0x00007fff3c732982 -[NSManagedObjectContext reset] + 114
 2   com.sheepsystems.Bkmxwork         0x000000010319c1ab -[Extore tearDown] + 155 (Extore.m:969)
 3   com.sheepsystems.Bkmxwork         0x0000000103309788 -[BkmxDoc finishGroupOfOperationsWithInfo:] + 1592 (BkmxDoc.m:6485)
 */

- (Starker*)starker {
	if (!m_starker) {
		NSManagedObjectContext* moc = [self transMoc] ;
		m_starker = [[Starker alloc] initWithManagedObjectContext:moc
														  owner:self] ;
	}
	
	return m_starker ;
}

- (Starker*)localStarker {
	if (!m_localStarker) {
		NSManagedObjectContext* moc = [self localMoc] ;
        m_localStarker = [[Starker alloc] initWithManagedObjectContext:moc
                                                                 owner:self] ;
    }
	
	return m_localStarker ;
}

- (Tagger*)tagger {
    if ([[self class] canEditTagsInAnyStyle]) {
        if (!m_tagger) {
            m_tagger = [[Tagger alloc] initWithManagedObjectContext:[self transMoc]];
        }
    }

    return m_tagger ;
}

- (Tagger*)localTagger {
    if ([[self class] tagDelimiter]) {
        if (!m_localTagger) {
            NSManagedObjectContext* moc = [self localMoc] ;
            m_localTagger = [[Tagger alloc] initWithManagedObjectContext:moc] ;
        }
    }
    return m_localTagger ;
}

- (SSYProgressView*)progressView {
	return [[self bkmxDoc] progressView] ;
}


#pragma mark * Store Constants

- (const ExtoreConstants*)extoreConstants_p {
	// ??? Class extoreClass = [Extore extoreClassForExformat:self.clientoid.exformat] ;
	return [[self class] constants_p] ;
}

- (NSTimeInterval)quitHoldTime {
    return 0.0 ;
}

- (BOOL)canCreateNewDocuments {
	return [self extoreConstants_p]->canCreateNewDocuments ;
}

- (NSString*)defaultProfileName {
	return [[self class] defaultProfileName] ;
}

- (BOOL)canHaveProfileCrosstalk {
    return NO ;
}

- (BkmxAuthorizationMethod)authorizationMethod {
	return [self extoreConstants_p]->authorizationMethod ;
}

- (NSString*)ownerAppDisplayName {
	return [[self class] ownerAppDisplayName] ;
}

-(BOOL)silentlyRemovesDuplicates {
	return [self extoreConstants_p]->silentlyRemovesDuplicates ;
}

-(BOOL)normalizesURLs {
	return [self extoreConstants_p]->normalizesURLs ;
}

-(BOOL)catchesChangesDuringSave {
	return [self extoreConstants_p]->catchesChangesDuringSave ;
}

- (BOOL)shouldCheckAggregateExids {
    return NO ;
}

- (BOOL)hasOrder {
	return [self extoreConstants_p]->hasOrder ;
}

- (BOOL)hasFolders {
	return [self extoreConstants_p]->hasFolders ;
}

- (BOOL)canPublicize {
	return [self extoreConstants_p]->canPublicize ;
}

- (BOOL)hasBar {
	return [[self class] constants_p]->hasBar ;
}

- (BOOL)hasMenu {
	return [[self class] constants_p]->hasMenu ;
}

+ (BOOL)thisUserHasMenu {
    return [self constants_p]->hasMenu ;
}

+ (BOOL)thisUserHasUnfiled {
	return [self constants_p]->hasUnfiled ;
}

-(BOOL)hasUnfiled {
	return [[self class] constants_p]->hasUnfiled ;
}

-(BOOL)hasOhared {
	return [[self class] constants_p]->hasOhared ;
}

- (Sharype)mustHaveBarInFile {return NO;}
- (Sharype)mustHaveMenuInFile {return NO;}
- (Sharype)mustHaveUnfiledInFile {return NO;}
- (Sharype)mustHaveOharedInFile {return NO;}

- (BOOL)shouldPackFiles {
	BOOL answer ;
	switch (self.ixportStyle) {
		case 1:
			answer = YES ;
			break;
		case 2:
			answer = NO ;
			break;
		default:
			// Should never happen, but we catch this error elsewhere, so ignore it
			answer =  NO ;
			break;
	}
	
	return answer ;
}

- (BOOL)shouldBlindSawChangeTriggerDuringExport {
	// I should probably return YES for writeStyle 1.
	// But I think I must have done that by other means.
	// One of these days, I should remove that other means
	// and do it here instead?
	return NO ;
}

- (BOOL)shouldCloseWindowsWhenQuitting {
    return YES ;
}

- (Stark*)starkFromExtoreNode:(NSDictionary*)dic {
    Stark* stark = nil;  // We'll return nil if things go wrong

    NSString* dateString ;

    NSString* name = nil;
    NSString* url = nil ;
    NSString* exid = nil ;
    NSDate* addDate = nil ;
    NSDate* lastModifiedDate = nil ;
    NSString* guid = nil;

    // Attributes common to both containers and nodes

    stark = [[self starker] freshStark] ;

    // When the JSON is using Style 1, name's key is "name", but when
    // it's using Style 2, this key is "title".
    // We handle either case here:
    name = [dic objectForKey:@"name"] ;
    if (!name) {
        name = [dic objectForKey:@"title"] ;
    }

    exid = [dic objectForKey:@"id"] ;
#define FIX_FIREFOX_EXIDS 0
#if FIX_FIREFOX_EXIDS
#warning Fixing Firefox exids during import
    /* On 20170530, I got places.sqlite from user David Gray.  Oddly, all of
     his soft folders had guid strings of length 22 characters instead of 12.
     When reading bookmarks in Style 2, using the bookmarks.getTree() function,
     this raised exceptions which you could see in the extension debugger
     console, and caused soft folders to be skipped, which caused a "no parent"
     exception to be raised for all children of the soft folders.  So the only
     thing I got was bookmarks which were direct children of hard folders.
     Code such as this here would fix it, although it would be better to make
     a -fixExid which was a no-op in Extore and overridden by ExtoreFirefox. */
    if (exid.length > 12) {
        exid = [exid substringToIndex:12];
    }
#endif
    // When the JSON is using Style 1, addDate's key is "date_added", but when
    // it's using Style 2, this key is "dateAdded".
    // We handle either case here:
    dateString = [dic objectForKey:@"date_added"] ;
    if (dateString) {
        // Style 1
        addDate = [NSDate dateWithMicrosecondsSince1601:[dateString longLongValue]] ;
    }
    else {
        // Style 2
        dateString = [dic objectForKey:@"dateAdded"] ;
        addDate = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]/1000] ;
    }
    // Starting in BookMacster 1.11, I pass this as a local value
    // instead of mapping to Stark's addDate property.
    // See Note 190351.
    [stark setOwnerValue:addDate
                  forKey:constKeyAddDate] ;

    if (!name) {
        // Defensive programming against corrupt json files.
        name = [[BkmxBasis sharedBasis] labelNoName] ;
    }
    [stark setExid:exid
      forClientoid:self.clientoid] ;

    if (
        /* Distinguish folders from bookmarks read from JSON Style 1.
           and JSON Style 2 for Firefox only. */
        [[dic objectForKey:constKeyType] isEqualToString:BkmxConstTypeFolder]
        ||
        /* Distinguish folders from bookmarks read from JSON Style 2

         There are several ways to do this.  The edge case is an empty folder:
                                       url          children
                                       ---          --------
         Nonemtpy folder from Chromy   null         array
         Empty folder from Chromy      null         empty array
         Bookmark from Chromy          non-null     null
         ---------------------
         Nonempty folder from Firefox  null         array
         Empty folder from Firefox     null         null
         Bookmark from Firefox         non-null     null

         --> For Chrome, we could use either a null url or non-null children to
         filter out folders.  But for Firefox, the only choice is null url.
         So that's what we use, starting in BkmkMgrs 2.3…
         */
        ([dic objectForKey:constKeyUrl] == nil)
        )  {
        // is a container (folder, collection, etc.)

        [stark setName:name] ;

        // When the JSON is using Style 1, lastModifiedDate's key is "date_modified", but when
        // it's using Style 2, this key is "dateGroupModified".
        // We handle either case here:
        dateString = [dic objectForKey:@"date_modified"] ;
        if (dateString) {
            // Style 1
            lastModifiedDate = [NSDate dateWithMicrosecondsSince1601:[dateString longLongValue]] ;
        }
        else {
            // Style 2
            dateString = [dic objectForKey:@"dateGroupModified"] ;
            /* Firefox WebExtension can return a JSON null, presumably from a
             JavaScript null, for the dateGroupModified, and that appears
             here as a NSNull.  So we check for it. */
            if ([dateString respondsToSelector:@selector(doubleValue)]) {
                lastModifiedDate = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]/1000] ;
            }
        }

        if (lastModifiedDate) {
            // Starting in BookMacster 1.11, I pass this as a local value
            // instead of mapping to Stark's lastModifiedDate property.
            // See Note 190351.
            [stark setOwnerValue:lastModifiedDate
                          forKey:constKeyLastModifiedDate] ;
        }

        // Note that we do not copy children here since we need copies
        // of the children.  This will be done by the deep copier.

        [stark setSharypeValue:SharypeSoftFolder] ;
        // may actually be Root, Bar or Menu but we detect that in
        // -makeStarksFromExtoreTree:error_p, and fix the sharype value in
        // -[Stark assembleAsTreeWithRoot:::]
    }
    else if ([[dic objectForKey:constKeyType] isEqualToString:BkmxConstTypeSeparator]) {
        /* Style 2 Firefox only */
        [stark setSharypeValue:SharypeSeparator];
    } else {
        // is a bookmark
        [stark setName:name] ;
        url = [dic objectForKey:@"url"] ;

#if DEBUG_WRITE_IMPORTED_URLS_TO_FILES
        [self appendBookmarkSSYLinearFileWriterName:name
                                                url:url] ;
#endif
        // set values in output
        [stark setUrl:url] ;
        [stark setSharypeValue:SharypeBookmark] ;
    }

    // As we create starks, bump up the highestUsedId when we find a higher one
    [self registerHighExidFromItem:dic] ;

    /* Chromy is a little strange in that what we call 'owner values' are not
     at the root of the item dictionary but are in a sub-dictionary named
     meta_info.  However, for Opera, meta_info contains values for 'shortcut'
     and 'comments'.  Here's how we handle it: */
    NSDictionary* metaInfo = [dic objectForKey:constKeyMetaInfo] ;
    NSMutableDictionary* ownerMetaInfo = nil ;
    for (NSString* key in [metaInfo allKeys]) {
        id value = [metaInfo valueForKey:key] ;
        if ([key isEqualToString:@"Description"]) {
            [stark setComments:value] ;
        }
        else if ([key isEqualToString:@"Nickname"]) {
            [stark setShortcut:value] ;
        }
        else {
            if (!ownerMetaInfo) {
                ownerMetaInfo = [[NSMutableDictionary alloc] init] ;
            }
            [ownerMetaInfo setObject:value
                              forKey:key] ;
        }
    }
    if (ownerMetaInfo) {
        NSDictionary* ownerMetaInfoCopy = [ownerMetaInfo copy] ;
        [ownerMetaInfo release] ;
        [stark setOwnerValue:ownerMetaInfoCopy
                      forKey:constKeyMetaInfo] ;
        [ownerMetaInfoCopy release] ;
    }

    NSString* syncTransactionVersion = [dic objectForKey:constKeySyncTransactionVersion] ;
    /* Note 20160606
     The following will execute if (1) user is using Chrome Sync (syncing)
     *and* (2) user has set Advanced Client Setting to "never" launch Chrome
     to coordinate syncing.  The reason that both conditions are required
     is because the key constKeySyncTransactionVersion is only present in the
     bookmarks when using Chrome Sync, and by default that will launch the
     app and cause Style 2 to be used, but this method only runs for Style 1. */
    if (syncTransactionVersion) {
        [stark setOwnerValue:syncTransactionVersion
                      forKey:constKeySyncTransactionVersion] ;
    }
    
    /* Chrome bookmarks have a separate "guid" which is not available in
     Style 2.  See https://bugs.chromium.org/p/chromium/issues/detail?id=1103030.
     So, we store it as a Owner Value.  */
    guid = [dic objectForKey:constKeyGuid] ;
    if (guid) {
        [stark setOwnerValue:guid
                      forKey:constKeyGuid] ;
    }

    
    return stark ;
}

+ (void)addonableExtores_p:(NSArray**)extores_p
				 results_p:(NSDictionary**)results_p {
	NSArray* clientoids = [Clientoid allClientoidsForLocalAppsThisUserByPopularity:NO
                                                              includeUninitialized:YES
                                                               includeNonClientable:YES] ;
	clientoids = [clientoids arraySortedByKeyPath:@"displayName"] ;
	NSManagedObjectContext* moc = [SSYMOCManager managedObjectContextType:NSInMemoryStoreType
																	owner:nil
															   identifier:nil
																 momdName:nil
                                                        recreateIfCorrupt:NO
																  error_p:NULL] ;
	NSMutableArray* extores = [[NSMutableArray alloc] init] ;
	
	for (Clientoid* clientoid in clientoids) {
		Class extoreClass = [Extore extoreClassForExformat:[clientoid exformat]] ;
		if ([extoreClass syncExtensionAvailable]) {
			Client* client = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameClient
														   inManagedObjectContext:moc] ;
			[client setLikeClientChoice:[ClientChoice clientChoiceWithClientoid:clientoid]] ;
			Extore* extore = [Extore extoreForIxporter:[client importer]
                                             clientoid:nil
                                             jobSerial:0
											   error_p:NULL] ;
			if (extore) {
				[extores addObject:extore] ;
			}
		}
	}
	
	if (extores_p) {
		*extores_p = [[extores copy] autorelease] ;
	}
	
	if (results_p) {
		NSMutableDictionary* resultz = [[NSMutableDictionary alloc] init] ;
		
		for (Extore* extore in extores) {
			// Get preliminary results (version numbers only, not a full test)
			NSDictionary* peeks = [extore peekExtension] ;
			// Use setValue:forKey: in case peeks is nil due to corrupt prefs
			[resultz setValue:peeks
					   forKey:extore.clientoid.clidentifier] ;
		}
		
		*results_p = [[resultz copy] autorelease] ;
		[resultz release] ;
	}
	
	[extores release] ;
}

+ (NSArray*)availableHartainers {
	NSMutableArray* hartainers = [[NSMutableArray alloc] init] ;
	
	if (YES) {
		[hartainers addObject:[NSNumber numberWithSharype:SharypeRoot]] ;
	}
	if ([self constants_p]->hasBar == YES) {
		[hartainers addObject:[NSNumber numberWithSharype:SharypeBar]] ;
	}
	if ([self constants_p]->hasMenu == YES) {
		[hartainers addObject:[NSNumber numberWithSharype:SharypeMenu]] ;
	}
	if ([self constants_p]->hasUnfiled == YES) {
		[hartainers addObject:[NSNumber numberWithSharype:SharypeUnfiled]] ;
	}
	if ([self constants_p]->hasOhared == YES) {
		[hartainers addObject:[NSNumber numberWithSharype:SharypeOhared]] ;
	}
	
	NSArray* answer = [hartainers copy] ;
	[hartainers release] ;
	
	return [answer autorelease] ;
}

- (BOOL)dateRef1970Not2001 {
	return [self extoreConstants_p]->dateRef1970Not2001 ;
}

- (BOOL)ownerAppIsLocalApp {
	return [self extoreConstants_p]->ownerAppIsLocalApp ;
}

- (void)localizeHartainers {
}

- (NSString*)filePathError_p:(NSError**)error_p {
    NSError* error = nil;
    NSString* path;
    if (self.client) {
     	path = [self.client filePathError_p:&error];
    } else {
        path = [self.clientoid filePathError_p:&error];
    }

    if (error && error_p) {
        *error_p = error ;
    }

    return path;
}

- (NSString*)extoreMedia {
    NSString* extoreMedia;
    if (self.client) {
        extoreMedia = self.client.extoreMedia;
    } else {
        extoreMedia = self.clientoid.extoreMedia;
    }

    return extoreMedia;
}

- (NSString*)workingFilePathError_p:(NSError**)error_p {
    __block NSString* path = nil;
    __block NSError* error = nil ;
    
    if ([NSThread isMainThread]) {
        path = [self filePathError_p:&error] ;
        [path retain];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            path = [self filePathError_p:&error] ;
            [path retain];
        });
    }
    
    [path  autorelease];
    if (error && error_p) {
        *error_p = error ;
    }
    
    return path ;
}

- (BOOL)ensureFilesGetSuffixes_p:(NSSet**)suffixes_p
                         error_p:(NSError**)error_p {
    if (![self ownerAppIsLocalApp]) {
        return YES ;
    }
    
    if (self.ixportStyle != 1) {
        return YES;
    }
    
    BOOL ok = YES ;
    NSError* error = nil ;
    NSMutableSet* suffixesFileCopied = [[NSMutableSet alloc] init] ;
    NSString* path = [self filePathError_p:&error] ;
    if (!path) {
        NSString* msg = [NSString stringWithFormat:@"No file path for %@", self.clientoid.displayName] ;
        error = [SSYMakeError(153930, msg) errorByAddingUnderlyingError:error] ;
        ok = NO ;
        goto end ;
    }

    BOOL preexisting = [[NSFileManager defaultManager] fileExistsAtPath:path] ;
    
    if (!preexisting) {
        // We have some copying to do, either to create a missing file,
        // or to copy it to the accessible scratchPath, or both.
        
        NSString* destinPath = path ;

        // source depends on whether or not file is preeexisting
        NSString* sourcePath ;
        if (preexisting) {
            sourcePath = path ;
        }
        else {
            // Note: I tried to create an empty places.sqlite file by removing a profile's
            // places.sqlite file, launching Firefox to create a new one, deleting
            // the default bookmarks, quitting Firefox, dumping places.sqlite to text,
            // then creating a .sqlite and running the dump as a query.  This did not
            // work, I believe because because the sqlite3 built into Firefox has been
            // compiled to use a 4 KB page size instead of sqlite3's default 1 KB.
            // (Evidence: The .sqlite file created by Firefox 3 is 144 KB,
            // but the recreated one is only 36 KB.  The dump is exactly the same, but
            // Firefox refuses to read the 36 KB file; it reverts to default bookmarks.)
            // So, instead, I now store an empty file I created with Firefox, and the
            // same for other browsers.  Works OK except it needs to have its hartainers
            // localized (this is done by localizeHartainers).
            NSString* filename = NSStringFromClass([self class]) ;
            sourcePath = [[NSBundle mainAppBundle] pathForResource:filename
                                                         ofType:nil] ;
            if (!sourcePath) {
                NSString* msg = [NSString stringWithFormat:
                                 @"Missing resource '%@' in .app package",
                                 filename] ;
                error = SSYMakeError(54367, msg) ;
                ok = NO ;
                goto end ;
            }
        }
        
        // Do the copying, and also, in the case of Firefox only, unzipping
        
        NSString* destinDirectory = [destinPath stringByDeletingLastPathComponent] ;

        ok = [[NSFileManager defaultManager] createDirectoryAtPath:destinDirectory
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error] ;
        if (ok) {
            if ([self emptyExtoreResourceFilenameAfterUnzipping] != nil) {
                NSInteger result = [SSYShellTasker doShellTaskCommand:@"/usr/bin/unzip"
                                                            arguments:[NSArray arrayWithObjects:@"-o", @"-d", destinDirectory, sourcePath, nil]
                                                          inDirectory:nil
                                                            stdinData:nil
                                                         stdoutData_p:NULL
                                                         stderrData_p:NULL
                                                              timeout:5.0
                                                              error_p:&error] ;
                ok = (result == 0) ;
                if (ok) {
                    /* The unzipped file is now in the Firefox profile directory,
                     however it is still named ExtoreFirefox.  We need to change
                     the name to places.sqlite. */
                    NSString* unzippedSourcePath = [destinDirectory stringByAppendingPathComponent:[sourcePath lastPathComponent]] ;
                    ok = [[NSFileManager defaultManager] moveItemAtPath:unzippedSourcePath
                                                                 toPath:destinPath
                                                                  error:&error] ;
                }
            }
            else {
                ok = [[NSFileManager defaultManager] copyItemAtPath:sourcePath
                                                             toPath:destinPath
                                                              error:&error] ;
            }
        }

        if (!ok) {
            // I've seen where NSFileManager can fail leaving a partially-copied
            // directory.  Try to clean up any such garbage.
            [[NSFileManager defaultManager] removeItemAtPath:destinPath
                                                       error:NULL] ;
        }

        if (!ok) {
            goto end ;
        }
    }

end:;
    if (suffixes_p) {
        *suffixes_p = [NSSet setWithSet:suffixesFileCopied] ;
    }
    
    [suffixesFileCopied release] ;
    
    if (error && error_p) {
        *error_p = error ;
    }
    
    return ok ;
}

/*!
 @brief    Troubleshooting method added in BookMacster 1.10 for user Carol Kino
*/
- (NSString*)listPath:(NSString*)path {
	NSString* command = @"/bin/ls" ;
	NSArray* arguments = [NSArray arrayWithObjects:
						  @"-alww",
						  path,
						  nil] ;
	NSError* error = nil ;
	NSData* stdoutData = nil ;
	NSInteger result = [SSYShellTasker doShellTaskCommand:command
												arguments:arguments
											  inDirectory:nil
												stdinData:nil
											 stdoutData_p:&stdoutData
											 stderrData_p:NULL
												  timeout:5.0
												  error_p:&error] ;
	NSString* stdoutString = [[NSString alloc] initWithData:stdoutData
												   encoding:NSUTF8StringEncoding] ;
	NSString* answer = [NSString stringWithFormat:
						@"ls for path:\n%@\nexit status=%ld  stdout:\n%@\nerror: %@",
						path,
						(long)result,
						stdoutString,
						error] ;

	[stdoutString release] ;
	return answer ;
}

- (NSString*)browserBundlePath {
	return [self.clientoid ownerAppFullPathError_p:NULL] ;
}

- (NSBundle*)browserBundle {
	return [NSBundle bundleWithPath:[self browserBundlePath]] ;
}

+ (NSString*)legendForKey:(NSString*)key {
	NSArray* supportedOwnerApps = [[BkmxBasis sharedBasis] supportedOwnerApps] ;
	
	NSMutableString* legend = [[NSMutableString alloc] init] ;
	BOOL firstItem = YES ;
	for (NSString* exformat in supportedOwnerApps) {
		Class extoreClass = [Extore extoreClassForExformat:exformat] ;
		if ([extoreClass canEditAttribute:key
                                  inStyle:1]) {
			if (firstItem) {
				firstItem = NO ;
			}
			else {
				[legend appendString:@"\n"] ;
			}
			NSString* valueKey = [[NSString alloc] initWithFormat:
								  @"070_%@_%@",
								  key,
								  exformat] ;
			NSString* value = [NSString localize:valueKey] ;
            if ([value hasSuffix:SSStringNotFoundAnnouncer]) {
                value = [key capitalizedString] ;
                NSLog(@"Warning 624-9948 No localized string for '%@' in %@",
                      key,
                      exformat) ;
            }
            [valueKey release] ;  // Memory leak fixed in BookMacster 1.17
			NSString* ownerAppDisplayName = [extoreClass ownerAppDisplayName] ;
			NSString* lineItem = [[NSString alloc] initWithFormat:
								  @"\"%@\" (%@)",
								  value,
								  ownerAppDisplayName] ;
			[legend appendString:lineItem] ;
			[lineItem release] ;
		}
	}
	
	NSString* output = [legend copy] ;
	[legend release] ;
	
	return [output autorelease] ;
}


#pragma mark * Basic Infrastructure

- (id)initWithIxporter:(Ixporter*)ixporter
             clientoid:(Clientoid*)clientoid
             jobSerial:(NSInteger)jobSerial {
	self = [super init] ;

	if (self != nil) {
		if ([self isMemberOfClass:[Extore class]]) {
			NSLog(@"Internal Error 562-5883.  Attempt to init Extore base class instance.") ;

			// See http://lists.apple.com/archives/Objc-language/2008/Sep/msg00133.html ...
			[super dealloc] ;
			self = nil ;
		}
		else {
			self.ixporter = ixporter;
            /* Set a clientoid, because, as a (copy) attribute, it is more
             reliable than ixporter which is a (assign) attribute.  In
             particular, it is to avoid this crash:

             Exception Type:        EXC_BAD_ACCESS (SIGSEGV)
             Exception Codes:       KERN_INVALID_ADDRESS at 0x000053552d6e6518
             Exception Note:        EXC_CORPSE_NOTIFY
             Termination Signal:    Segmentation fault: 11

             Thread 0 Crashed:: Dispatch queue: com.apple.main-thread
             0   libobjc.A.dylib             objc_msgSend + 29
             1   com.sheepsystems.Bkmxwork   -[Extore client] + 174 (Extore.m:928)
             2   com.sheepsystems.Bkmxwork   -[Extore clientoid] + 169 (Extore.m:908)
             3   com.sheepsystems.Bkmxwork   -[Extore localIdentifier] + 44 (Extore.m:5134)
             4   com.sheepsystems.Bkmxwork   -[Extore processExidFeedbackString:] + 374 (Extore.m:5503)
             5   com.sheepsystems.Bkmxwork   __49-[ExtoreSafari writeWithSheepSafariHelperChanges:operation:]_block_invoke_2 + 43 (ExtoreSafari.m:2932)
             */
            if (clientoid) {
                self.clientoid = clientoid;
            } else {
                self.clientoid = ixporter.client.clientoid;
            }
            self.jobSerial = jobSerial;
		}
	}

	return self ;
}

#if 0
#warning Logging retain, release for Extore
- (id)retain {
	id x = [super retain] ;
	NSLog(@"113033: After retain, rc=%ld", (long)[self retainCount]) ;
	return x ;
}
/*- (id)autorelease {
 id x = [super autorelease] ;
 NSLog(@"111008: After autorelease, rc=%d", [self retainCount]) ;
 return x ;
 }
 */
- (oneway void)release {
	NSInteger rc = [self retainCount] ;
	[super release] ;
	NSLog(@"113300: After release, rc=%ld", (long)(rc-1)) ;
	return ;
}
#endif

/*
 This method was added in BookMacster 1.22.9, so that it could be invoked from
 -[ExtensionsWinCon muleIsDoneForExtore:], to fix a misbehavior.  The misbehavior
 was reproduced like this…
 • Set up Syncer to sync, say, Chrome (Default)
 • Manage Browser Extensions
 • Test Chrome (Default)
 • Leave the window open.
 • Change a bookmark in Chrome
 Result: Worker fails with Error 325844 underlain by
 SSYInterappServerErrorPortNameAlreadyInUse because it cannot open a port to
 com.sheepsystems.BookMacster.ExtoreChrome.Default.FromClient, because this
 port is still in use in the system be the Extore in this window.

 (ExtensionsWinCon creates and retains an Extore for each of its rows as long as
 it is open, and uses these extores for testing.  It does not create a new
 Extore when you click Test.)  The reason for the port remaining open is that
 I never unleased them until the extore was deallocced.  Well, now that is fixed.
 The setInterappServer:nil] is necessary to keep from crashing if user clicks
 "Test" button a *second* time, because the server is released upon unleasing;
 Extore has a weak reference to it. */
- (void)unleaseInterappServer {
    [[self interappServer] unleaseForDelegate:self] ;
    [self setInterappServer:nil] ;
}

- (void)dealloc {
    /* Be careful to use proper Core Data access if you want to log any
     Core Data properties in here for debugging.  Like this… */
#if 0
    NSString* __block dn;
    if ([[NSThread currentThread] isMainThread]) {
        dn = self.displayName;
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            dn = self.displayName;
        });
    }
    NSLog(@"Extore dealloc %p %@", self, dn) ;
#endif

    if (_readExternalCompletionHandler) {
        Block_release(_readExternalCompletionHandler);
    }

    [_clientoid release];
    [m_fileProperties release] ;
	[m_error release] ;
	
	[m_starker release] ;
	[m_localStarker release] ;
	
	[m_userActionWaitLock release] ;
	[m_runningBundleIdentifier release] ;
    [m_hashableAttributes release] ;
    [m_exidAssignmentsToAvoid release] ;
    [m_ixporter release];
    [_tearDowner release];

    [super dealloc] ;
}

- (NSString*)description {
	return [NSString stringWithFormat:@"Extore %p for %@", self, [self.clientoid shortDescription]] ;
}

- (NSString*)shortDescription {
	return [NSString stringWithFormat:@"Extore da %@", [self.clientoid  displayName]] ;
}


#pragma mark * Other Instance Methods

- (id)extoreItemFromStark:(Stark*)item {
	NSLog(@"Forgot to override extoreItemFromStark?") ;
	return nil ;
}

- (void)sendIsDoneMessageFromInfo:(NSMutableDictionary*)info {
    [[self class] sendIsDoneMessageFromInfo:info
                                      error:self.error];
}

+ (void)sendIsDoneMessageFromInfo:(NSMutableDictionary*)info
                            error:(NSError*)error {
	id target = [info objectForKey:constKeyIsDoneTarget] ;
	// The following was added in BookMacster 1.7.3 to eliminate crashes
	// which occurred if another bug caused Google Bookmarks to proceed
	// with an export attempted on an account different than the one that
	// is currently logged in, while the sheet asking for permission to
	// log out+in was showing.  Note that it is necessary due to the
	// *following* line, which will dealloc 'target' in this case.
	[[target retain] autorelease] ;
	// Important!  The following is necessary to break the temporary
	// retain cycle which was created in
	// -[SSYOperation(OperationImport) prepareBrowserForImport_unsafe]
	// (if we were invoked from there)
	[info removeObjectForKey:constKeyIsDoneTarget] ;

	NSInvocation* invocation = [info objectForKey:constKeyDidSucceedInvocation] ;
	NSString* selectorName = [info objectForKey:constKeyIsDoneSelectorName] ;

	if (selectorName && invocation) {
		NSLog(@"Internal Error 626-0198.  Two jobs! -%@ && -%@",
			  selectorName, NSStringFromSelector([invocation selector])) ;
	}

    /* The following was added on 20180121.  I think it should have been there
     from the beginning, but was not needed until I just added dialog to
     install BookMacster Sync extension (for Opera) during import, which the
     user could cancel or otherwise faile to do. */
    if (error) {
        [info setObject:error
                 forKey:constKeyError];
        BkmxDoc* bkmxDoc = (BkmxDoc*)[info objectForKey:constKeyDocument] ;
        [[bkmxDoc progressView] clearAll];
    }

	// I think that I could maybe save myself alot of future
	// headaches with NSLock "unlocked from a thread which
	// did not lock it" exceptions by changing the following
	// to perform on the main thread, at least the first branch.
	// When I discovered the problem in these methods…
	//   -[ExtoreSafari prepareBrowserForExportThreadedWithInfo:]
	//   -[ExtoreSafari prepareBrowserForImportThreadedWithInfo:]
	// I fixed them by invoking -sendIsDoneMessageFromInfo:, which
	// eventually brings us here, on the main thread.  But if I
	// fixed it here I could do a regular message send there.
	// But there are too many cases to test and too little time.
	if (selectorName) {
		SEL selector = NSSelectorFromString(selectorName) ;
		[target performSelector:selector
                     withObject:info] ;
	}
	else if (invocation) {
		[invocation invoke] ;
	}
}

- (BOOL)killBrowser {
    BOOL ok = YES ;
    NSString* path = [self runningBundlePath];
    /* Check for path, because we are also called *before* launching, by
     -[ExtoreFirefox launchOwnerAppPath:::] */

    if (path) {
        path = [self prepareForBrowserQuitPath:path];
    }

    /* We could check for path != nil here before doing anything, because if
     path is nil, the browser is not running.  But since this is supposed to
     be a robust, forceful method, we ignore that and proceed regardless. */

    for (NSString* bundleIdentifier in [[self class] browserBundleIdentifiers]) {
        BOOL thisOk = [SSYOtherApper killThisUsersAppWithBundleIdentifier:bundleIdentifier
                                                                  timeout:TIMEOUT_FOR_APP_TO_BE_KILLED] ;
        if (!thisOk) {
            ok = NO ;
        }
    }

	if (ok) {
		[self updateOwnerAppQuinchState:OwnerAppQuinchStateDidQuill] ;
        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                    logFormat:@"Force Quit %@", [self ownerAppDisplayName]] ;
    } else if (path) {
        [self oopsUnprepareForBrowserQuitPath:path];
    }

    return ok ;
}

- (pid_t)pidOfOwnerApp {
    pid_t pid = 0 ;
    for (NSString* bundleIdentifier in [[self class] browserBundleIdentifiers]) {
        pid = [SSYOtherApper pidOfThisUsersAppWithBundleIdentifier:bundleIdentifier] ;
        if (pid != 0) {
            break ;
        }
    }
	
	return pid ;
}


- (BOOL)
BrowserToBeRunningError_p:(NSError**)error_p {
	NSInteger seconds = 0 ;
	BOOL ok ;
	while (YES) {
		sleep(1) ;
		pid_t pid = [self pidOfOwnerApp] ;
		
		if (pid != 0) {
			ok = YES ;
			break ;
		}
		
		seconds++ ;
		if (seconds > 10) {
			if (error_p) {
				*error_p = SSYMakeError(255294, @"Browser did not install extension") ;
			}
			ok = NO ;
			break ;
		}
	}
	
	return ok ;
}

- (NSString*)extensionDisplayNameForExtensionIndex:(NSInteger)extensionIndex {
    NSString* extensionName = nil;
    switch (extensionIndex) {
        case 1:
            extensionName = @"BookMacster Sync";
            break;
        case 2:
            extensionName = @"BookMacster Button";
            break;
    }

    return extensionName;
}

- (NSString*)extension1BriefDescription {
    NSString* name = [[NSString alloc] initWithFormat:
                      @"Sync : to sync any changes automatically with %@",
                      [[BkmxBasis sharedBasis] appNameLocalized]] ;
    [name autorelease] ;
    return name ;
}

- (NSString*)extension2BriefDescription {
    NSString* name = [[NSString alloc] initWithFormat:
                      @"Button : to add bookmarks manually, directly to %@",
                      [[BkmxBasis sharedBasis] appNameLocalized]] ;
    [name autorelease] ;
    return name ;
}

+ (NSURL*)sourceUrlForExtensionIndex:(NSInteger)extensionIndex {
	return nil ;
}

+ (NSString*)extension1Uuid {
    NSLog(@"Internal Error 839-4838") ;
    return nil ;
}

+ (NSString*)extension2Uuid {
    NSLog(@"Internal Error 839-4839") ;
    return nil ;
}


- (NSInteger)extensionVersionForExtensionIndex:(NSInteger)extensionIndex {
    return EXTORE_EXTENSION_VERSION_NOT_APPLICABLE ;
}

- (BOOL)hasUsersAttention {
	return (NSApp && ![[BkmxBasis sharedBasis] isScripted]) ;
}

- (NSString*)tooltipForInstallButtonForExtensionIndex:(NSInteger)extensionIndex {
    NSString* tip ;
    switch (extensionIndex) {
        case 1:
            tip = [NSString stringWithFormat:
                   @"Installs or updates the '%@' extension, which empowers %@ to import/export while %@ is running, and informs %@ when you change bookmarks in %@",
                   [self extensionDisplayNameForExtensionIndex:extensionIndex],
                   [[BkmxBasis sharedBasis] appNameLocalized],
                   [self ownerAppDisplayName],
                   [[BkmxBasis sharedBasis] appNameLocalized],
                   [self ownerAppDisplayName]] ;
            break ;
        case 2:
            tip = [NSString stringWithFormat:
                   @"Installs or updates the '%@' extension, which adds a button to the toolbar in %@.  This button is useful for landing new bookmarks *directly* from %@ into %@.",
                   [self extensionDisplayNameForExtensionIndex:extensionIndex],
                   [self ownerAppDisplayName],
                   [self ownerAppDisplayName],
                   [[BkmxBasis sharedBasis] appNameLocalized]] ;
            ;
            break ;
        default:
            tip = nil ;
            break ;
    }

    return tip ;
}

- (NSString*)emptyExtoreResourceFilenameAfterUnzipping {
    return nil ;
}

- (BOOL)addonMayInstall:(BOOL*)mayInstall_p
				error_p:(NSError**)error_p {
    
	BOOL ok = YES ;
	[self setError:nil] ;

    if (
        [[self.clientoid extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]
        // The following may have been prevented by other means and is now
        // defensive programming, but I'm leaving it in.
        &&
        ([[BkmxBasis sharedBasis] iAm] != BkmxWhich1AppSmarky)
        ) {
        BOOL syncExtensionAvailable = [self syncExtensionAvailable] ;
        
        // -syncExtensionAvailable may have set an error
        NSError* error = [self error] ;
        if (error) {
            if (error_p) {
                *error_p = error ;
            }
            ok = NO ;
        }
        
        if (ok && mayInstall_p) {
            NSError* error = nil ;
            OwnerAppRunningState runningState = [self ownerAppRunningStateError_p:&error] ;
            if (runningState == OwnerAppRunningStateError) {
                if (error_p) {
                    *error_p = error ;
                }
                ok = NO ;
            }
            else {
                *mayInstall_p = [self hasUsersAttention] && syncExtensionAvailable ;
            }
        }
    }
    else {
        *mayInstall_p = NO ;
    }
	
	return ok ;
}

/* Prior to BkmkMgrs 2.10.21, this method was synchronous; that is, it returned
 a BOOL, and a NSError* by reference.  In developer 2.10.21, I needed to
 subclass this method to present another sheet when installing Brave, because
 Brave Beta used different application data but had the same bundle identifier
 as Brave non-Beta.  After I tested this new asynchronous version, I found
 that Brave had recently realized their mistake and put a different bundle
 identifier in Brave Beta.  So I removed the sheet, but left the asynchronous
 structure in case it is needed in the future.  Just subclass this method,
 invoke super at the end, and pass the completion handler to super. */
- (void)preinstallExtensionIndex:(NSInteger)extensionIndex
                      hostWindow:(NSWindow*)hostWindow
               completionHandler:(void(^)(
                                          NSError* error
                                          ))completionHandler {
    BOOL ok = YES;
    NSError* error = nil;

    NSString* profileName = self.clientoid.profileName;
    if (!profileName) {
        profileName = [[self class] defaultProfileName];
    }

    NSData* data = nil;
    if (profileName) {
        NSDictionary* info = @{
                               @"extoreName" : [self className],
                               @"profileName" : profileName
                               };
        data = [NSPropertyListSerialization dataWithPropertyList:info
                                                          format:NSPropertyListBinaryFormat_v1_0
                                                         options:0
                                                           error:&error] ;
        if (error) {
            ok = NO ;
        }
    }

    if (ok) {
        ok = [data writeToFile:[Chromessenger extensionInstallInfoPath]
                    atomically:YES];
    }

    // Both extensions 1 and 2 require our Chromessenger
    if (ok) {
        [self installMessengerError_p:&error] ;
    }

    if (completionHandler) {
        completionHandler(error);
    }
}

- (NSString*)installExtensionPromptForExtensionIndex:(NSInteger)extensionIndex {
    NSString* suffix ;
    if (extensionIndex == 1) {
        suffix = @"\n\n•  Return here and 'Test' the newly-installed extension.  (This is necessary to initialize it.)" ;
    }
    else {
        suffix = @"" ;
    }

    return [NSString stringWithFormat:
            @"•  Click 'OK' below. %@ should activate and show our '%@' extension.  (If it does not show our extension, return here and click 'Install' again.)"
            @"\n\n•  Click the buttons given to 'Add' or 'Install' it.%@",
            [self ownerAppDisplayName],
            [self extensionDisplayNameForExtensionIndex:extensionIndex],
            suffix] ;
}

- (void)promptInstallExtensionFromSourceUrl:(NSURL*)sourceUrl
                             extensionIndex:(NSInteger)extensionIndex
                                       mule:(ExtensionsMule*)mule
                                 hostWindow:(NSWindow*)hostWindow {
    NSString* msg = [self installExtensionPromptForExtensionIndex:extensionIndex] ;
    
    // The following was added in BookMacster version 1.3.19, because
    // the BkmxDoc window is not showing yet when this method is invoked
    // to migrate Firefox exids to guids.
    [hostWindow orderFront:self] ;
    
    SSYAlert* alert = [SSYAlert alert] ;
    [alert setSmallText:msg] ;
    [alert setButton1Title:@"OK"] ;
    [alert setButton2Title:@"Cancel"] ;
    [alert setHelpAddress:constHelpAnchorBrowserExtensions] ;
    [alert setIconStyle:SSYAlertIconInformational] ;
    [alert doooLayout] ;
    
    [hostWindow beginSheet:[alert window]
         completionHandler:^void(NSModalResponse modalResponse) {
             if (modalResponse == NSAlertFirstButtonReturn) {
                 NSString* ownerPath = [self runningBundlePath];
                 if (!ownerPath) {
                     /* Owner app is not currently running, but we still want
                      to do this, so use alternate method. */
                     ownerPath = [self ownerAppLocalPath];
                 }
                 NSURL* ownerUrl = [NSURL fileURLWithPath:ownerPath] ;
                 NSArray* sourceUrlArray = @[sourceUrl] ;
                 
                 [[NSWorkspace sharedWorkspace] openURLs:sourceUrlArray
                                    withApplicationAtURL:ownerUrl
                                           configuration:[NSWorkspaceOpenConfiguration configuration]
                                       completionHandler:^void (NSRunningApplication *ownerApp, NSError *error) {
                     if (!ownerApp) {
                         error = [SSYMakeError(204091, @"Could not install extension") errorByAddingUnderlyingError:error] ;
                         error = [error errorByAddingUserInfoObject:ownerUrl
                                                             forKey:@"Browser app URL"];
                         error = [error errorByAddingUserInfoObject:sourceUrl
                                                             forKey:@"Exension URL"];
                         if ([[NSThread currentThread] isMainThread]) {
                             [SSYAlert alertError:error];
                         } else {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [SSYAlert alertError:error];
                             });
                         }
                     }
                 }];
             }
             else {
                 [mule muleRefreshAndDisplay] ;
             }
         }] ;
}

- (NSString*)messagePleaseActivateThisProfile {
    NSLog(@"Internal Error 202-5762") ;
    return nil ;
}

- (NSString*)helpAnchorForMultipleProfiles {
    return nil ;
}

- (SSYAlert*)pleaseActivateThisProfileAlert {
    NSString* msg1 = [self messagePleaseActivateThisProfile] ;
    SSYAlert* alert1 = [SSYAlert alert] ;
    [alert1 setSmallText:msg1] ;
    [alert1 setButton1Title:@"OK"] ;
    [alert1 setButton2Title:@"Cancel"] ;
    [alert1 setHelpAddress:[self helpAnchorForMultipleProfiles]] ;
    [alert1 setIconStyle:SSYAlertIconInformational] ;
    [alert1 doooLayout] ;
    return alert1;
}

- (void)installExtensionIndex:(NSInteger)extensionIndex
                   hostWindow:(NSWindow*)hostWindow
                         mule:(ExtensionsMule*)mule {
    NSURL* sourceUrl = [[self class] sourceUrlForExtensionIndex:extensionIndex] ;

    if (sourceUrl) {
        [self preinstallExtensionIndex:extensionIndex
                            hostWindow:(NSWindow*)hostWindow
                     completionHandler:^void(NSError* error) {
            if (!error) {
                if ([[[self class] profileNames] count] > 1) {
                    SSYAlert *alert1 = [self pleaseActivateThisProfileAlert];
                    
                    [hostWindow beginSheet:[alert1 window]
                         completionHandler:^void(NSModalResponse modalResponse) {
                        if (modalResponse == NSAlertFirstButtonReturn) {
                            [self promptInstallExtensionFromSourceUrl:sourceUrl
                                                       extensionIndex:extensionIndex
                                                                 mule:mule
                                                           hostWindow:hostWindow] ;
                        }
                        else {
                            [mule muleRefreshAndDisplay] ;
                        }
                    }] ;
                }
                else {
                    [self promptInstallExtensionFromSourceUrl:sourceUrl
                                               extensionIndex:extensionIndex
                                                         mule:mule
                                                   hostWindow:hostWindow] ;
                }
            } else {
                [SSYAlert alertError:error];
            }
        }];
    }
}

- (BOOL)installMessengerError_p:(NSError**)error_p {
    return YES ;
}

- (NSDictionary*)peekExtension {
	NSDictionary* result = [self processedExtension1Version:[self extensionVersionForExtensionIndex:1]
                                          extension2Version:[self extensionVersionForExtensionIndex:2]
                                            receivedProfile:nil
                                                      error:[self error]] ;
    
    return result ;
}

- (BOOL)extension1Installed {
    NSDictionary* result = [self peekExtension] ;
    NSInteger version = [[result objectForKey:constKeyExtension1Version] integerValue] ;

    return (version > 0) ;
}

- (NSString*)ownerAppLocalPath {
    return [[self class] ownerAppLocalPath] ;
}

- (NSString*)runningBundlePath {
	NSString* runningBundlePath = nil ;
    for (NSString* bundleIdentifier in [[self class] browserBundleIdentifiers]) {
        runningBundlePath = [SSYOtherApper pathOfThisUsersRunningAppWithBundleIdentifier:bundleIdentifier] ;
        if (runningBundlePath) {
            break ;
        }
    }

    // If owner app not running, returns nil
    return runningBundlePath ;
}

/* One might think that we should register the quit in User Defaults *after*
 the quit worked.  But what if, after sending the quit message, the system
 paused our thread, and before it was resumed, quit the browser and launchd
 notified our Quatch?  Then we would have a undesired trigger.  So we call this
 method *before* quitting.  If the quit fails, we call the next method, to
 clear the quit. */
- (NSString*)prepareForBrowserQuitPath:(NSString*)path {
     if (path) {
        [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:[NSDate date]
                                                      forKeyPathArray:@[
                                                                        constKeyBrowserWeQuitDates,
                                                                        path
                                                                        ]
         ];
    }

    return path;
}

- (void)oopsUnprepareForBrowserQuitPath:(NSString*)path {
    if (path) {
        [[NSUserDefaults standardUserDefaults] removeAndSyncMainAppKey:path
                                                   fromDictionaryAtKey:constKeyBrowserWeQuitDates];
    }
}

- (BOOL)quitOwnerAppWithTimeout:(NSTimeInterval)timeout
                  preferredPath:(NSString*)path
			   killAfterTimeout:(BOOL)killAfterTimeout
				   wasRunning_p:(BOOL*)wasRunning_p
                  pathQuilled_p:(NSString**)pathQuilled_p
						error_p:(NSError**)error_p {
    BOOL ok = YES;
    NSError* error = nil ;
    BOOL wasRunning = NO ;
    if (!path) {
        path = [self runningBundlePath];
    }

    /* If no preferred path, and owner app is not running, path will be nil and
     the following will not execute. */
    if (path) {
        [self prepareForBrowserQuitPath:path];
        if (wasRunning) {
            [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                        logFormat:@"Will quit %@ now", [self ownerAppDisplayName]] ;
        }
        ok = [SSYOtherApper quitThisUsersAppWithBundlePath:path
                                              closeWindows:[self shouldCloseWindowsWhenQuitting]
                                                   timeout:timeout
                                          killAfterTimeout:killAfterTimeout
                                              wasRunning_p:&wasRunning
                                                   error_p:&error] ;
        /* wasRunning should always be assigned to YES here, because we
         checked for running path before entering this branch.  But, oh well,
         it is a double check. */
    }

    if (ok && wasRunning) {
        [self updateOwnerAppQuinchState:OwnerAppQuinchStateDidQuill] ;
        if (pathQuilled_p) {
            *pathQuilled_p = path;
        }
    }

    if (path && !ok) {
        [self oopsUnprepareForBrowserQuitPath:path];
        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                    logFormat:@"Failed quitting %@", [self ownerAppDisplayName]] ;
    }

	if (ok && wasRunning_p) {
        *wasRunning_p = wasRunning ;
    }

    if (error && error_p) {
		*error_p = error ;
	}

	return ok ;
}


- (BOOL)quitOwnerAppCleanlyWithProgressView:(SSYProgressView*)progressView
                              pathQuilled_p:(NSString**)pathQuilled_p
									error_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
    SSYProgressView* localProgressView = [progressView setIndeterminate:YES
                                                      withLocalizedVerb:[NSString localizeFormat:
                                                                         @"quitting%0",
                                                                         [self ownerAppDisplayName]]
                                                               priority:SSYProgressPriorityRegular] ;
	BOOL wasRunning ;
    NSString* pathQuilled = nil;
	ok = [self quitOwnerAppWithTimeout:20.0
                         preferredPath:nil
					  killAfterTimeout:NO
						  wasRunning_p:&wasRunning
                         pathQuilled_p:&pathQuilled
							   error_p:&error] ;
	// Wait to stabilize, in case it is still writing files or something
	if (ok && wasRunning) {
		[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:(TIME_FOR_APP_TO_STABILIZE)]] ;
	}

    [localProgressView clearAll] ;

    if (pathQuilled_p) {
        *pathQuilled_p = pathQuilled;
    }
    
	if (error_p) {
		*error_p = error ;
	}
	
	return ok ;
}

- (BOOL)quitOwnerAppCleanlyForOperation:(SSYOperation*)operation
                                error_p:(NSError**)error_p  {
    BOOL ok = YES ;
    NSError* error = nil ;
    BkmxDoc* bkmxDoc = [[operation info] objectForKey:constKeyDocument] ;
    SSYProgressView* progressView = [bkmxDoc progressView] ;
    NSString* pathQuilled = nil;
    ok = [self quitOwnerAppCleanlyWithProgressView:progressView
                                     pathQuilled_p:&pathQuilled
                                           error_p:&error] ;
    
    if (error) {
        [self setError:error] ;
        if (error_p) {
            *error_p = error ;
        }
    }
    
    if (pathQuilled) {
        [[operation info] setObject:pathQuilled
                             forKey:constKeyBrowserPathQuit];
    }
    
    return ok ;
}



+ (OwnerAppRunningState)ownerAppRunningStateError_p:(NSError**)error_p {

	OwnerAppRunningState ownerAppRunningState = OwnerAppRunningStateNotRunning ;
    for (NSString* bundleIdentifier in [self browserBundleIdentifiers]) {
        if ([SSYOtherApper pidOfThisUsersAppWithBundleIdentifier:bundleIdentifier] != 0) {
            ownerAppRunningState = OwnerAppRunningStateRunningProfileAvailable ;
            break ;
        }
    }

	return ownerAppRunningState ;
}

- (OwnerAppRunningState)ownerAppRunningStateError_p:(NSError**)error_p {
    return [[self class] ownerAppRunningStateError_p:error_p] ;
}

- (BOOL)ownerAppIsRunningError_p:(NSError**)error_p {
    BOOL ok = YES ;
    NSError* error = nil ;
    OwnerAppRunningState runningState = [self ownerAppRunningStateError_p:&error] ;
    if (runningState == OwnerAppRunningStateError) {
        ok = NO ;
    }
    BOOL isRunning = NO ;
    
    if (ok) {
        switch (runningState) {
            case OwnerAppRunningStateError:
            case OwnerAppRunningStateNotRunning:
                isRunning = NO ;
                break ;
            case OwnerAppRunningStateRunningProfileAvailable:
            case OwnerAppRunningStateRunningProfileNotLoaded:
            case OwnerAppRunningStateRunningProfileWrongOne:
                isRunning = YES ;
                break ;
        }
    }
    
    if (error_p && error) {
        *error_p = error ;
    }
    
    return isRunning ;
}

- (NSString*)launchOwnerAppPath:(NSString*)path
					   activate:(BOOL)activate
                        error_p:(NSError**)error_p {
    BOOL ok = YES ;
	NSError* error = nil ;
    NSString* errDesc = nil ;
    
	if (!path) {
		path = [self ownerAppLocalPath] ;
	}
	
    ok  = [self quitOwnerAppWithTimeout:10.0
                          preferredPath:nil
                       killAfterTimeout:YES
                           wasRunning_p:NULL
                          pathQuilled_p:NULL
                                error_p:&error] ;
    if (!ok) {
        errDesc = [NSString stringWithFormat:
                   @"Could not quit %@",
                   self.clientoid.displayName] ;
        error = [SSYMakeError(883531, errDesc) errorByAddingUnderlyingError:error] ;
        ok = NO ;
        goto end ;
    }
    
    ok = [SSYOtherApper launchApplicationPath:path
                                     activate:activate
                                hideGuardTime:0.0
                                      error_p:&error] ;
    if (!ok) {
        errDesc = [NSString stringWithFormat:
                   @"Could not launch %@",
                   self.clientoid.displayName] ;
        error = [SSYMakeError(883604, errDesc) errorByAddingUnderlyingError:error] ;
        goto end ;
    }

end:
    if (!ok) {
        path = nil ;
	}
    
    if (error && error_p) {
        *error_p = error ;
    }

	return path ;
}

- (void)clarifyErrorForRequest:(NSString*)requested
				  receivedData:(NSData*)data {
	NSInteger code = [[self error] code] ;
	NSString* errorDomain = [[self error] domain] ;
	if ([errorDomain isEqualToString:NSXMLParserErrorDomain]) {
		if (code == 5) {
			// The localized description provided by Apple is:
			//    Operation could not be completed. (NSXMLParserErrorDomain error 5.)
			// We need to do better than that.
			NSError* error_ = [self error] ;
			error_ = [error_ errorByAddingUnderlyingError:error_] ;
			NSString* msg ;
			msg = [NSString stringWithFormat:
				   @"We seem to have received bogus XML data from %@.",
				   [[self class] webHostName]] ;
			error_ = [error_ errorByAddingLocalizedDescription:msg] ;
			msg = [NSString stringWithFormat:
				   @"Retry the operation.  If it does not work after several tries, wait a while."
				   @"  If you click the life preserver for support, you might also want to copy"
				   @" the techical information in the email message and send it directly to the"
				   @" support team at %@.  In particular, send them the \"Request...\" and \"Response...\"",
				   [self ownerAppDisplayName]] ;
			error_ = [error_ errorByAddingLocalizedRecoverySuggestion:msg] ;
			error_ = [error_ errorByAddingUserInfoObject:requested
												  forKey:@"Request we sent to server"] ;
			if (data) {
				msg = [[NSString alloc] initWithData:data
										encoding:NSASCIIStringEncoding] ;
			}
			else {
				msg = @"<Nil Data>" ;
			}
			error_ = [error_ errorByAddingUserInfoObject:msg
												  forKey:@"Response data we received:"] ;
			error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:[data length]]
																			  forKey:@"Response data byte count"] ;
			[msg release] ;
			
			[self setError:error_] ;
		}
	}
}

+ (NSString*)frontmostProfileInOwnerApp {
    return nil ;
}

+ (NSString*)browserExtensionPortNameForProfileName:(NSString*)profileName {
	return [NSString stringWithFormat:
			@"%@.%@",
			[[NSBundle mainAppBundle] motherAppBundleIdentifier],
			NSStringFromClass([self class])] ;
}

- (NSString*)browserExtensionPortName {
    NSString* profileName = self.clientoid.profileName ;
    if (!profileName) {
        /* Although a client may have nil profile name for most of our
         purposes, for naming the port, we want a profile name (which must
         match the profile name will be set into the extensions's localStorage
         database).
         
         Although neither Opera nor Vivaldi support multiple profiles, the
         behavior here is a little different.
         
         For Vivaldi, because it has a "Default" subfolder, for reasons of
         accessing the various files in there, we assign "Default" to its 
         profileName.  Therefore, this branch does not execute.
         
         For Opera, they have went further and dispensed with the "Default"
         subfolder altogether, instead putting all of the "profile" files into
         the parent "com.operasoftware.Opera" folder.  Therefore, for Opera we
         assign nil to profileName.  Therefore, this branch does execute. */

        profileName = [self defaultProfileName] ;
    }
	return [[self class] browserExtensionPortNameForProfileName:profileName] ;
}

- (void)forgetTimeoutter{
    [[self timeoutter] invalidate];
	[self setTimeoutter:nil] ;
}

- (NSString*)fromClientPortName {
    return [[self browserExtensionPortName] stringByAppendingString:@".FromClient"];
}

- (BOOL)prepareInterappServerWithUserInfo:(NSDictionary*)userInfo
                                  error_p:(NSError**)error_p {
	SSYInterappServer* server = [self interappServer] ;
    NSError* error = nil ;
	if ([server delegate] != self) {
		server = [SSYInterappServer leaseServerWithPortName:[self fromClientPortName]
												   delegate:self
                                                   userInfo:userInfo
													error_p:&error] ;
		if (server) {
            // Experiment to see if I can fix problem where,
            // once in awhile, version check seems to fail inexplicably
            sleep (1) ;
        }
        else if (error) {
            NSSet* searchNames = [[[BkmxBasis sharedBasis] allAppNames] setByAddingObject:constAppNameBkmxAgent] ;
            NSSet* processInfos = [SSYOtherApper infosOfProcessesNamed:searchNames
                                                                  user:nil
                                                               error_p:NULL] ;
            
            error = [error errorByAddingUserInfoObject:processInfos
                                                forKey:@"Suspects"] ;
            error = [error errorByAddingUserInfoObject:[NSNumber numberWithUnsignedShort:getpid()]
                                                forKey:@"Current Process Pid"] ;
        }
        
		[self setInterappServer:server] ;
	}
	else {
        server.userInfo = userInfo;
    }
    
    if (error && error_p) {
        *error_p = error ;
    }
    
	return (server != nil) ;
}

- (NSError*)errorForExtension1Version:(NSInteger)extension1Version
                    extension2Version:(NSInteger)extension2Version
                      receivedProfile:(NSString*)receivedProfile {
	NSInteger errorCode = 0 ;
	NSMutableArray* errorStrings = [NSMutableArray array] ;
    NSInteger requiredVersion ;

	requiredVersion = [self minVersionForExtensionIndex:1] ;
    if (
		(extension1Version < requiredVersion)
		&&
		(extension1Version != EXTENSION_VERSION_UNKNOWN_BECAUSE_ITS_BEEN_ZIPPED_BY_FIREFOX_3)
		) {
		if (extension1Version > 0) {
			errorCode += EXTORE_ERROR_CODE_MASK_EXTENSION1_DOWNREV ;
			[errorStrings addObject:[NSString stringWithFormat:
									@"Old Ext1 (%ld, %ld required).",
									(long)extension1Version,
                                     (long)[self minVersionForExtensionIndex:1]]] ;
		}
		else if (extension1Version == 0) {
			errorCode += EXTORE_ERROR_CODE_MASK_EXTENSION1_NOT_FOUND ;
			[errorStrings addObject:@"Extension 1 not found."] ;
		}
	}

	requiredVersion = [self minVersionForExtensionIndex:2] ;
    if (extension2Version != EXTENSION_2_NOT_APPLICABLE_TO_THIS_EXFORMAT) {
        if (
            (extension2Version < requiredVersion)
            &&
            (extension2Version != EXTENSION_VERSION_UNKNOWN_BECAUSE_ITS_BEEN_ZIPPED_BY_FIREFOX_3)
            ) {
            if (extension2Version > 0) {
                errorCode += EXTORE_ERROR_CODE_MASK_EXTENSION2_DOWNREV ;
                [errorStrings addObject:[NSString stringWithFormat:
                                         @"Old Ext2 (%ld, %ld required).",
                                         (long)extension2Version,
                                         (long)[self minVersionForExtensionIndex:2]]] ;
            }
            else if (extension2Version == 0) {
                errorCode += EXTORE_ERROR_CODE_MASK_EXTENSION2_NOT_FOUND ;
                [errorStrings addObject:@"Extension 2 not found."] ;
            }
        }
	}
    
	if (receivedProfile) {
        if ([receivedProfile isEqualToString:constSorryNullProfile]) {
			errorCode += EXTORE_ERROR_CODE_MASK_IPC_PROFILE_NULL ;
			[errorStrings addObject:@"No profile."] ;
        }
		else if ([self canHaveProfileCrosstalk] && ![receivedProfile isEqualToString:self.clientoid.profileName]) {
            NSString* suffix = [[self class] displayedSuffixForProfileName:receivedProfile
                                                                  homePath:self.clientoid.homePath] ;
			errorCode += EXTORE_ERROR_CODE_MASK_IPC_PROFILE_CROSSTALK ;
			[errorStrings addObject:[NSString stringWithFormat:
                                     @"Wrong profile: %@%@.",
                                     receivedProfile,
                                     suffix]] ;
		}
	}
	
	NSError* error ;
    if (errorCode > 0) {
		errorCode += EXTORE_ERROR_CODE_BASE ;
		NSString* description = [errorStrings componentsJoinedByString:@"  "] ;
        error = SSYMakeError(errorCode, description) ;
	}
    else {
        error = nil ;
    }

	return error ;
}

- (NSDictionary*)processedExtension1Version:(NSInteger)extension1Version
                          extension2Version:(NSInteger)extension2Version
                            receivedProfile:(NSString*)receivedProfile
                                      error:(NSError*)error {
	if (!error) {
		error = [self errorForExtension1Version:extension1Version
                              extension2Version:extension2Version
                                receivedProfile:receivedProfile] ;
	}
	
 	NSMutableDictionary* result = [[NSMutableDictionary alloc] init] ;
    [result setObject:[NSNumber numberWithInteger:extension1Version]
               forKey:constKeyExtension1Version] ;
    [result setObject:[NSNumber numberWithInteger:extension2Version]
               forKey:constKeyExtension2Version] ;
	[result setValue:error  // may be nil
			  forKey:constKeyError] ;
	
	NSDictionary* answer = [NSDictionary dictionaryWithDictionary:result] ;
	[result release] ;
	
	return answer;
}

+ (BkmxGrabPageIdiom)peekPageIdiom {
	return BkmxGrabPageIdiomNone ;
}

- (void)testExtensionForMule:(id)mule {
	NSInteger errorCode = 0 ;
	NSString* errorMsg = nil ;
	BOOL ok ;
	NSError* error = nil ;
	
	// Get ready for the versions data (In this case, we're the server.)
	// Note that we do this before sending the message to the browser messenger,
	// in case the browser messenger returns a response really fast.
    ok = [self prepareInterappServerWithUserInfo:@{constKeyReadExternalMule: mule}
                                         error_p:&error] ;
	if (!ok) {
		error = [SSYMakeError(516867, @"Server failed") errorByAddingUnderlyingError:error] ;
		goto end ;
	}
	
	NSTimer* existingTimeoutter = [self timeoutter] ;
	if (existingTimeoutter != nil) {
        /* This will happen if user clicks, say, a "Test" button, and then
         quickly re-clicks it while it is still blue. */
		[self forgetTimeoutter] ;
	}

	/* Prior to BkmkMgrs 1.3.19, rxTimeout was 1.0 seconds.  I increased it
     to 10.0 seconds in case Firefox was slow, since I noticed that it does
     alot of stuff synchronously on the main thread.  I further increased it in
     BkmkMgrs 1.22.38, after noting that Firefox could take up to 53 seconds
     when (1) Firefox was not active and (2) another app was doing significant
     work. */
    NSTimeInterval rxTimeout = 60.277000 ;
	NSTimer* timeoutter = [NSTimer scheduledTimerWithTimeInterval:rxTimeout
														   target:self
														 selector:@selector(timedOutExtensionVersionCheck:)
														 userInfo:mule
														  repeats:NO] ;
	[self setTimeoutter:timeoutter] ;
	
	char rxHeaderByte = 0 ;
	NSString* portName = [[self browserExtensionPortName] stringByAppendingString:@".ToClient"] ;
	
	ok = [SSYInterappClient sendHeaderByte:constInterappHeaderByteForTest
								 txPayload:nil
								  portName:portName
	/*
	 We pass wait:NO to fix a bug that took me several hours to find during initial development.
	 When this was YES, this method, due to CFMessagePortSendRequest(), would not return until
	 the message had been sent, the response ('v' = version check) received by the callback
	 interappServer:::, the response processed, the user messenger and extension installed (the latter
	 with user approval in Firefox) and Firefox was quit.  Yup, we would block here for however
	 long it took the user to click the button in Firefox, typically 10-15 seconds.  After all
	 that, CFMessagePortSendRequest() would return a kCFMessagePortBecameInvalidError, presumably
	 because its server, which was in the now-quit messenger, was no longer running.
	 This would give us ok=NO and a non-nil 'error' here, which would cause attempted re-installation.
	 Now I suppose I could also have fixed this by changing something in the messenger, but I'd rather
	 not go there.  The only disadvantage of wait:NO is that I don't get to check and see that
	 the rxHeaderByte is the expected 'acknowledgment ('a'). */
									  wait:NO
							rxHeaderByte_p:&rxHeaderByte
							   rxPayload_p:NULL
#define TX_TIMEOUT 10.0
								 txTimeout:TX_TIMEOUT
								 rxTimeout:(rxTimeout + 1.0) // Let timeoutter time out first
										error_p:&error] ;

	if (!ok) {
		error = [SSYMakeError(564139, @"Port send failed") errorByAddingUnderlyingError:error] ;
		goto end ;
	}
			
end:;
	if (!ok) {
		errorCode = EXTORE_ERROR_ADDON_NO_RESPONSE ;
		errorMsg = [NSString stringWithFormat:
					 @"No response from %@\n",
					 [self ownerAppDisplayName]] ;
		error = [SSYMakeError(errorCode, errorMsg) errorByAddingUnderlyingError:error] ;
		[self setError:error] ;
		[[BkmxBasis sharedBasis] trace:errorMsg] ;
        
		[self forgetTimeoutter] ;

        [mule extore:self
          testResult:[self processedExtension1Version:0
                                    extension2Version:0
                                      receivedProfile:nil
                                                error:error]] ;
	}
}

+ (BkmxIxportTolerance)toleranceForIxportStyle:(NSInteger)ixportStyle {
	return BkmxIxportToleranceAllowsNone ;
}

+ (BOOL)toleratesClientTask:(BkmxClientTask)clientTask
				 usingStyle:(BkmxIxportStyle)style {
	BkmxIxportTolerance toleranceRequired ;
	BkmxIxportTolerance toleranceAvailable ;
	switch (clientTask) {
		case BkmxClientTaskRead:
			toleranceAvailable = [self toleranceForIxportStyle:style] ;
			toleranceRequired = BkmxIxportToleranceAllowsReading ;
			break;
		case BkmxClientTaskWrite:
			toleranceAvailable = [self toleranceForIxportStyle:style] ;
			toleranceRequired = BkmxIxportToleranceAllowsWriting ;
			break;
		case BkmxClientTaskInstall:
		default:
			toleranceAvailable = BkmxIxportToleranceAllowsNone ;
			toleranceRequired = BkmxIxportToleranceAllowsInstallingAddOn ;
			break;
	}
	
	BOOL canDo = ((toleranceAvailable & toleranceRequired) > 0) ;
	
	return canDo ;
}

- (BOOL)toleratesClientTask:(BkmxClientTask)clientTask {
    BOOL answer = [[self class] toleratesClientTask:clientTask
                                         usingStyle:self.ixportStyle] ;

#if 0
    NSLog(@"EB: %@ %@: tolerates %@ task %@ using style %ld",
          self.clientoid.exformat,
          self.clientoid.profileName,
          answer ? @"YES" : @"NO",
          (((clientTask!=1)&&(clientTask!=2)&&(clientTask!=4)) ? @"ERR1" : ((clientTask==1) ? @"READ" : ((clientTask==2) ? @"WRIT" : @"INST"))),
          style
          ) ;
#endif
    
    return answer ;
}


- (void)doSpecialMappingAfterImport {
}

- (void)doSpecialMappingBeforeExportForExporter:(Exporter*)exporter
                                        bkmxDoc:(BkmxDoc*) bkmxDoc  {
}

- (BOOL)exportCheckStuffMidwayError_p:(NSError**)error_p {
    return YES;
}

- (void)tweakImport {
}

- (void)tweakExport {
}

- (BOOL)canHaveParentSharype:(Sharype)sharype
					   stark:(Stark*)stark {
    return [self parentSharype:sharype
           canHaveChildSharype:[stark sharypeValue]];
}

+ (BOOL)canProbablyImportFileType:type
								  data:data {
	return NO ;
}

- (BOOL)validateExid:(NSString*)exid
	   isAfterExport:(BOOL)isAfterExport
			forStark:(Stark*)stark {
	return YES ;
}

- (BOOL)isExportableStark:(Stark*)stark
			   withChange:(NSDictionary*)change {
#if IS_EXPORTABLE_STARK_WILL_ALWAYS_RETURN_YES
	return YES  ;
#endif
	
	NSString* urlString ;
	if ([[change objectForKey:constKeySSYChangedKey] isEqualToString:constKeyUrl]) {
		urlString = [change objectForKey:constKeyNewValue] ;
	}
	else {
		urlString = [stark url] ;
	}
	
	if (![stark canHaveUrl]) {
		// It's a container, separator, etc.
		return YES ;
	}
	
    //  All bookmarks must have a non-nil URL
	if (!urlString) {
		return NO ;
	}
    
    /* On 20140804, discovered that Chrome would silently ignore a bookmark
     whose url is "http://".  On 2020-03-16, discovered the same problem in
     Firefox, except in Firefox it seems more like the more weird behavior
     found with @"http://", see farther on down.
     Has no problem with "http://joséブックマークメニュー/".
     
     Well, since a bookmark to "http://" is obviously useless, starting in
     BookMacster 2.10.19, I moved the code from ExtoreChromy to Extore here,
     disallowing exports of such bookmarks to other subclasses which call
     super when overriding this method: Firefox, Diigo and Pinboard. */
    if ([urlString isEqualToString:@"http://"]) {
        return NO ;
    }
    
    /* On 2020-01-20, discovered the same problem with a bookmark whose url is
     "https://", in both Chrome and Edge.  On 2020-03-16, discovered the same
     problem in Firefox.  What is even more strange is that
     if you attempt to export such a bookmark in Style 2, it will "work" the
     first time – that is, the bookmark will not be exported and no errors
     will appear.  But if you look in the BookMacster Sync extension console
     you will see an error.  And the second any any subsequent time, the
     extension will return Error 633892, which the main app will wrap in
     Error 260748 and present as an export failure.  But there's more.  If
     you delete the bad bookmarks with URL "https://" and export again, it
     will still present the same error, complaining about the bad URL in the
     bookmark which you have deleted, which is not in the .bmco, not in the
     browser's user interface, and not in the browser's "Bookmarks" file.
     Apparently it is cached somewhere in the browser's extensions interface,
     because it will keep doing it until the extension is reloaded!
     
     Well, since a bookmark to "https://" is obviously useless, starting in
     BookMacster 2.10.19, I moved the code from Extore Chrome to Extore here,
     disallowing exports of such bookmarks to other subclasses which call
     super when overriding this method: Firefox, Diigo and Pinboard. */
    if ([urlString isEqualToString:@"https://"]) {
        return NO ;
    }
	
	NSURL* url = [[NSURL alloc] initWithString:urlString] ;
    BOOL ok = YES ;
    
    /*
     Developing BookMacster 1.17, I got a complaint from user Brian Cashion on
     2013-08-27, and it turned out that the following was preventing his Plex
     bookmarklet from being exported.  The problem URL is:
     
     javascript:%20var%20s=document.createElement("script");s.type="text/javascript";s.src="https://my.plexapp.com/queue/bookmarklet_payload?uid=da46711fbb5d7800";var%20h=document.getElementsByTagName("head")[0];h.appendChild(s);void(0);
     
     He said that this bookmark works fine in Firefox, "It's meant to send
     videos from any site to a queue run by the Plex media service… and it
     does!"
     
     So, in BookMacster 1.17, I removed these three lines of code, which
     were supposedly added in BookMacster 1.15, with no specific explanation…
     
     if (!url) {
     ok = NO ;
     }
     
     It appears that these 3 lines were maybe added in BookMacster 1.15 to
     prevent exports ofFirefox Smart Bookmarks to Chrome.  This is the only
     plausible explanation I can find in the Version History of
     BookMacster 1.15.  Weird, that in most subclasses of Extore,
     -[ExtoreXxxx isExportable:withChange:], I'd added a test for
     -isSmartSearchUrl and if so, made this a hard return YES or NO.
     But in ExtoreChromy I did not.  So, to compensate for the loss of the
     above, I added that test -[ExtoreChromy isExportable:withChange:].
     See Note 20120827 over there.  So now it is like the others.  Added
     to ExtoreShiira too, even though no one cares.  Did NOT add it to
     ExtoreOmniWeb because I'm thinking maybe OmniWeb actually does
     Smart Searches.  But probably no one cares about that either.
     */
	
    if (ok) {
        NSString* path = [url path] ;
        // As stated in our documentation, "%00" in a path causes problems
        // when exported to Chrome or Firefox.  However, -[NSURL path] will
        // decode any percent escapes in the path, so that "%00" will become
        // the single byte 0x0, so we detect that…
        for (NSInteger i=0; i<[path length]; i++) {
            if([path characterAtIndex:i] == 0x0) {
                ok = NO ;
                break ;
            }
        }
    }
    
	[url release] ;
	
	return ok ;
}

- (NSString*)exformat {
    return [[self class] exformatForExtoreClass:[self class]] ;
}

- (BOOL)shouldExportStark:(Stark*)stark
			   withChange:(NSDictionary*)change {
    if (![self isExportableStark:stark
                      withChange:change]) {
        return NO ;
    }
    
    if (![self client]) {
        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                    logFormat:
         @"Trouble: %@ needs Client to do exportability properly", self];
    }

    Exporter* exporter = [[self client] exporter] ;
    
    if (!exporter) {
        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                    logFormat:
         @"Trouble: %@ needs Exporter to do exportability properly", self];
    }

    if ([stark sharypeValue] == SharypeSeparator) {
        if (![[self class] canEditSeparatorsInStyle:self.ixportStyle]) {
            return NO;
        }
        if ([[exporter skipSeparators] boolValue]) {
            return NO;
        }
    }
    
    if ([[exporter skipFileUrls] boolValue]) {
        if ([[stark url] hasPrefix:@"file://"]) {
            return NO ;
        }
    }
    
    if ([[exporter skipJavaScript] boolValue]) {
        if ([[stark url] hasPrefix:@"javascript:"]) {  // was javascript:// until BookMacster 1.3.6
            return NO ;
        }
    }
    
    if ([[exporter skipRssFeeds] boolValue]) {
        if (
            ([stark sharypeValue] == SharypeLiveRSS)
            ||
            ([[stark url] hasPrefix:@"feed://"])
            ) {
            return NO ;
        }
    }
    
    Stark* ancestor = stark ;
    while (ancestor) {
        NSArray* dontExportExformats = [ancestor dontExportExformats] ;
        if (dontExportExformats) {
            if ([dontExportExformats indexOfObject:[self exformat]] != NSNotFound) {
                // The following section was added in BookMacster 1.13.6
                BOOL thisBookmarkWillBeMappedOutOfThisParent = NO ;
                NSSet* tagMaps = [[[self client] exporter] tagMaps] ;
                for (TagMap* tagMap in tagMaps) {
                    for (Tag* tag in [stark tags]) {
                        if ([tag.string isEqualToString:tagMap.tag]) {
                            thisBookmarkWillBeMappedOutOfThisParent = YES ;
                            break ;
                        }
                    }
                }
                
                if (!thisBookmarkWillBeMappedOutOfThisParent) {
                    return NO ;
                }
            }
        }
        ancestor = [ancestor parent] ;
    }
    
    return YES ;
}

- (NSString*)cheesyExidForStark:(Stark*)stark {
	NSLog(@"Internal Error 513-0583") ;
	return nil ;
}

- (void)getFreshExid_p:(NSString**)exid_p
            higherThan:(NSInteger)higherThan
              forStark:(Stark*)stark
               tryHard:(BOOL)tryHard {
	*exid_p = [SSYUuid uuid] ;
}

- (BOOL)getExternallyDerivedLastKnownTouch:(NSDate**)date_p {
	NSDate* edlkt = nil ;

	if ([self ownerAppIsLocalApp]) {
		NSString* path = [self filePathError_p:NULL] ;
		if (path) {
			// Must be not Omniweb
			edlkt = [[NSFileManager defaultManager] modificationDateForPath:path] ;
		}
	}

	if (!edlkt) {
		// Assume worst case, which is, now.
		// This did always execute with Google Bookmarks, since
		// Google does not provide an API to say when they were touched.
		// It can happen at any time.
		// This did cause lots of downloads of Google Bookmarks, but there is no choice.
		edlkt = [NSDate date] ;
	}
	
	if (date_p) {
		*date_p = edlkt ;
	}
	
	return YES ;
}	

#define MARGIN_FOR_EXPORT_TO_COMPLETE 30.0

#if 0
#define LOG_LAST_DATE_EXTERNAL_WAS_TOUCHED 1
#endif

- (NSDate*)lastDateExternalWasTouched {
#if LOG_LAST_DATE_EXTERNAL_WAS_TOUCHED
    NSLog(@"LDEKT >> %s", __PRETTY_FUNCTION__) ;
#endif
	NSDate* lastDateExternalWasTouched = nil ;
	
	// Start out by taking the later of the externally-derived or internally-derived
	// last known touch date.
	NSDate* edlkt ;
	BOOL ok = [self getExternallyDerivedLastKnownTouch:&edlkt] ;
	if (ok) {
		NSDate* idlkt = [[self client] lastKnownTouch] ;
		lastDateExternalWasTouched = [NSDate laterDate:edlkt
												  date:idlkt] ;

#if LOG_LAST_DATE_EXTERNAL_WAS_TOUCHED
        NSLog(@"LDEKT    idlkt = %@", [idlkt geekDateTimeString]) ;
        NSLog(@"LDEKT    edlkt = %@", [edlkt geekDateTimeString]) ;
#endif
		// Because del.icio.us, in particular, sometimes lies to us, in particular,
		// does not restamp its posts/update date when we merely change the shared/private
		// attribute of a bookmark, we give the last time we exported, if it was more
		// than MARGIN_FOR_EXPORT_TO_COMPLETE seconds later.  The reason for the
		// MARGIN_FOR_EXPORT_TO_COMPLETE seconds margin is that
		// -[NSUserDefaults setLastChangeWrittenDate:toClient:]
		// is run at the end of the export, which is several seconds after the last
		// request in our export was processed at the server.  It's typically 6 seconds on
		// my Mac Mini.  Without this margin, localMocIsSyncedWithExternal would always return NO,
		// resulting in unnecessary downloads.
		// At any rate, the external was indeed "touched" when it was last exported,
		// so the following will do no harm...
		NSDate* dateLastExported = [[NSUserDefaults standardUserDefaults] lastChangeWrittenDateToClientoid:[self clientoid]] ;
		if ([dateLastExported timeIntervalSinceReferenceDate]
			>
			([lastDateExternalWasTouched timeIntervalSinceReferenceDate] + MARGIN_FOR_EXPORT_TO_COMPLETE)) {
			lastDateExternalWasTouched = dateLastExported ;
		}
		// If del.icio.us ever fixes that bug, we could eliminate the above section.


		if (!lastDateExternalWasTouched) {
			// We've got no history on this dog whatsoever,
			// so assume the worst case
			lastDateExternalWasTouched = [NSDate date] ;
		}
	}
#if LOG_LAST_DATE_EXTERNAL_WAS_TOUCHED
    else {
        NSLog(@"LDEKT    getExternallyDerivedLastKnownTouch failed.") ;
    }
    NSLog(@"LDEKT << %s returning %@", __PRETTY_FUNCTION__, [lastDateExternalWasTouched geekDateTimeString]) ;
#endif

	return lastDateExternalWasTouched ;
}

- (BOOL)localMocIsSyncedWithExternal {
	NSDate* lastDateExternalWasTouched = [self lastDateExternalWasTouched] ;
	NSDate* lastLocalMocSync = [[self client] lastLocalMocSync] ;
	BOOL inSync = NO ; // assume worst case
	if (lastDateExternalWasTouched && lastLocalMocSync) {
		// YES if lastDateExternalWasTouched is earlier than or same as lastLocalMocSync
		// NO if lastDateExternalWasTouched is later than lastLocalMocSync
		inSync = ([lastDateExternalWasTouched compare:lastLocalMocSync] != NSOrderedDescending) ;
	}

	return inSync ;
}

- (void)recursivelyPerformSelector:(SEL)selector
					   onRootStark:(Stark*)item
						withObject:(id)object {
	[self performSelector:selector
			   withObject:item
			   withObject:object] ;
    
    if ([item canHaveChildren])
    {
        // Call this method recursively to perform selector on each of item's children's...children
        NSArray* children = [item childrenOrdered] ;
        NSInteger i ; // Don't use unsigned here since we're testing i>=0
		// In case we're moving items out, we stark at the last and work up to 0
		for (i=[children count]-1; i>=0; i--)
        {
            [self recursivelyPerformSelector:selector
								 onRootStark:[children objectAtIndex:i]
								  withObject:object] ;
        }
    }
}	

+ (NSMutableDictionary*)editableAttributeArrays {
    if (!static_editableAttributeArrays) {
        static_editableAttributeArrays = [[NSMutableDictionary alloc] init] ;
    }
    
    return static_editableAttributeArrays ;
}

+ (NSString*)editableAttributesKeyForStyle:(NSInteger)style {
    return [NSString stringWithFormat:@"%@-Style%ld",
            [self className],
            style];
}

+ (NSArray*)editableAttributesInStyle:(NSInteger)style {
    NSString* key = [self editableAttributesKeyForStyle:style];
    NSArray* answer = [[self editableAttributeArrays] objectForKey:key] ;
    
    if (answer == nil) {
        NSMutableArray* array = [[NSMutableArray alloc] init] ;
        const ExtoreConstants * constants_p_ = [self constants_p] ;
        
        // This must be first, in case a stark is going to be tested
        // for exportability, which may depend on the url.
        if (constants_p_->canEditUrl) {
            [array addObject:constKeyUrl] ;
        }
        
        [array addObject:constKeySharype] ; // always supported
        
        // Note that we do *not* include constKeyOwnerValues, because
        // that is always private to the owner and *never* edited by
        // BookMacster
        
        if (constants_p_->canEditAddDate) {
            [array addObject:constKeyAddDate] ;
        }
        
        if ([self canEditCommentsInStyle:style]) {
            [array addObject:constKeyComments] ;
        }
        
        if (constants_p_->canEditFavicon) {
            [array addObject:constKeyFavicon] ;
        }
        
        if (constants_p_->canEditFaviconUrl) {
            [array addObject:constKeyFaviconUrl] ;
        }
        
        if (constants_p_->hasOrder) {
            [array addObject:constKeyIndex] ;
        }
        
        if (constants_p_->canEditIsAutoTab) {
            [array addObject:constKeyIsAutoTab] ;
        }
        
        if (constants_p_->canEditIsExpanded) {
            [array addObject:constKeyIsExpanded] ;
        }
        
        if (constants_p_->canEditIsShared) {
            [array addObject:constKeyIsShared] ;
        }
        
        if (constants_p_->canEditLastChengDate) {
            [array addObject:constKeyLastChengDate] ;
        }
        
        if (constants_p_->canEditLastModifiedDate) {
            [array addObject:constKeyLastModifiedDate] ;
        }
        
        if (constants_p_->canEditLastVisitedDate) {
            [array addObject:constKeyLastVisitedDate] ;
        }
        
        if (constants_p_->canEditName) {
            [array addObject:constKeyName] ;
        }
        
        if (constants_p_->canEditRating) {
            [array addObject:constKeyRating] ;
        }
        
        if (constants_p_->canEditRssArticles) {
            [array addObject:constKeyRssArticles] ;
        }
        
        if ([self canEditShortcutInStyle:style]) {
            [array addObject:constKeyShortcut] ;
        }
        
        if ([self canEditTagsInStyle:style]) {
            [array addObject:constKeyTags] ;
        }
        
        if (constants_p_->canEditVisitCount) {
            [array addObject:constKeyVisitCount] ;
        }
        
        answer = [[NSArray alloc] initWithArray:array] ;
        NSString* key = [self editableAttributesKeyForStyle:style];
        [[self editableAttributeArrays] setObject:answer
                                           forKey:key] ;
        [array release] ;
        [answer release] ;
    }

	return answer ;
}

/*!
 @details  Returns the intersection of the set of editable attributes in styles
 1 and 2, minus Stark class's -attributesYouDontWantInHash, ordered in a
 certain way.  Somewhere I remember seeing a comment explaining why we want
 `url` to be first, and maybe `sharype` second.  I'm not sure if
 there is a reason why the rest should be sorted alphabetically.
 I forgot if the hash function is linear (order-independent) or not. */
- (NSArray*)hashableAttributes {
    /* m_hashableAttributes is cached as ivars for efficiency. */
    if (!m_hashableAttributes) {
        NSMutableSet* set = [[NSSet setWithArray:[[self class] editableAttributesInStyle:1]] mutableCopy];
        NSSet* set2 = [NSSet setWithArray:[[self class] editableAttributesInStyle:2]];
        [set minusSet:[Stark attributesYouDontWantInHash]];
        [set intersectSet:set2];
        NSMutableArray* hashableAttributes = [[set allObjects] mutableCopy];
        [set release];
        [hashableAttributes sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 isEqualToString:constKeyUrl]) {
                return NSOrderedAscending;
            } else if ([obj2 isEqualToString:constKeyUrl]) {
                return NSOrderedDescending;
            } else if ([obj1 isEqualToString:constKeySharype]) {
                return NSOrderedAscending;
            } else if ([obj1 isEqualToString:constKeySharype]) {
                return NSOrderedDescending;
            } else {
                return [obj1 caseInsensitiveCompare:obj2];
            }
        }];
        m_hashableAttributes = [hashableAttributes copy];
        [hashableAttributes release];
    }

    return m_hashableAttributes;
}

- (BOOL)hashCoversAllAttributesInCurrentStyle {
    NSMutableSet* coverAllSet = [[NSSet setWithArray:[[self class] editableAttributesInStyle:self.ixportStyle]] mutableCopy];
    [coverAllSet minusSet:[Stark attributesYouDontWantInHash]];
    NSSet* hashSet = [NSSet setWithArray:[self hashableAttributes]];
    [coverAllSet minusSet:hashSet];
    BOOL doesCoverAll = (coverAllSet.count == 0);
    [coverAllSet release];
    return doesCoverAll;
}

- (uint32_t)contentHash {
    return [[[self starker] root] valuesHashOfAttributes:[self hashableAttributes]] ;
}

- (NSSet*)unsupportedAttributesForSeparators {
    return [NSSet setWithObject:constKeyName];
}

#define TIME_TOLERANCE 2.001

- (void)debugLogWithKey:(NSString*)key
                 stark1:(Stark*)stark1
                 stark2:(Stark*)stark2 {
    NSString* name = [stark1 name] ;
    if (!name) {
        name = [stark2 name] ;
    }

    NSString* logEntry = [[NSString alloc] initWithFormat:
                          @"36770:    Different %@ for %@:\n   stark1: %@\n   stark2: %@\n",
                          key,
                          name,
                          [stark1 valueForKey:key],
                          [stark2 valueForKey:key]];
    [[BkmxBasis sharedBasis] trace:logEntry] ;
    // NSLog(@"%@", logEntry) ;
    [logEntry release] ;
}

- (BOOL)supportedAttributesAreEqualComparingStark:(Stark*)stark1
                                       otherStark:(Stark*)stark2
                                      ixportStyle:(NSInteger)style {
    ExtoreConstants const * extoreConstants_p = [self extoreConstants_p] ;
    
    BkmxBasis* basis = [BkmxBasis sharedBasis];
    NSInteger traceLevel = [basis traceLevel];
    NSString* name = nil;
    NSString* logEntry = nil;
    
    if (extoreConstants_p->hasOrder) {
        if (![NSObject isEqualHandlesNilObject1:[stark1 index]
                                        object2:[stark2 index]]) {
            if (traceLevel > 4) {
                [self debugLogWithKey:constKeyIndex
                               stark1:stark1
                               stark2:stark2];
            }
            return NO ;
        }
    }
    
    if (extoreConstants_p->canEditAddDate) {
        // See note 20120924
        if (![NSDate isEqualHandlesNilDate1:[stark1 addDate]
                                      date2:[stark2 addDate]
                                  tolerance:TIME_TOLERANCE]) {
            if (traceLevel > 4) {
                [self debugLogWithKey:constKeyAddDate
                               stark1:stark1
                               stark2:stark2];
            }
            return NO ;
        }
    }
    
    if ([[self class] canEditCommentsInStyle:style]) {
        // Some clients may allow 0-length comments; others may turn them to nil.
        // As far as we are concerned, these are equal.  The following
        // line takes care of that.
        if ([[stark1 comments] length] != [[stark2 comments] length]) {
            if (![NSObject isEqualHandlesNilObject1:[stark1 comments]
                                            object2:[stark2 comments]]) {
                if (traceLevel > 4) {
                    [self debugLogWithKey:constKeyComments
                                   stark1:stark1
                                   stark2:stark2];
                }
                return NO ;
            }
        }
    }
    
    if (extoreConstants_p->canEditFavicon) {
        if (![NSObject isEqualHandlesNilObject1:[stark1 favicon]
                                        object2:[stark2 favicon]]) {
            if (traceLevel > 4) {
                [self debugLogWithKey:constKeyFavicon
                               stark1:stark1
                               stark2:stark2];
            }
            return NO ;
        }
    }
    
    if (extoreConstants_p->canEditFaviconUrl) {
        if (![NSObject isEqualHandlesNilObject1:[stark1 faviconUrl]
                                        object2:[stark2 faviconUrl]]) {
            if (traceLevel > 4) {
                [self debugLogWithKey:constKeyFaviconUrl
                               stark1:stark1
                               stark2:stark2];
            }
            return NO ;
        }
    }
    
    if (extoreConstants_p->canEditIsAutoTab) {
        if (![NSObject isEqualHandlesNilObject1:[stark1 isAutoTab]
                                        object2:[stark2 isAutoTab]]) {
            if (traceLevel > 4) {
                [self debugLogWithKey:constKeyIsAutoTab
                               stark1:stark1
                               stark2:stark2];
            }
            return NO ;
        }
    }
    
    if (extoreConstants_p->canEditIsExpanded) {
        if (![NSObject isEqualHandlesNilObject1:[stark1 isExpanded]
                                        object2:[stark2 isExpanded]]) {
            if (traceLevel > 4) {
                [self debugLogWithKey:constKeyIsExpanded
                               stark1:stark1
                               stark2:stark2];
            }
            return NO ;
        }
    }
    
    if (extoreConstants_p->canEditIsShared) {
        if (![NSObject isEqualHandlesNilObject1:[stark1 isShared]
                                        object2:[stark2 isShared]]) {
            if (traceLevel > 4) {
                [self debugLogWithKey:constKeyIsShared
                               stark1:stark1
                               stark2:stark2];
            }
            return NO ;
        }
    }
    
    if (extoreConstants_p->canEditLastChengDate) {
        // See note 20120924
        if (![NSDate isEqualHandlesNilDate1:[stark1 lastChengDate]
                                      date2:[stark2 lastChengDate]
                                  tolerance:TIME_TOLERANCE]) {
        }
        if (traceLevel > 4) {
            [self debugLogWithKey:constKeyLastChengDate
                           stark1:stark1
                           stark2:stark2];
        }
        return NO ;
    }
    
    
    if (extoreConstants_p->canEditLastModifiedDate) {
        // See note 20120924
        if (![NSDate isEqualHandlesNilDate1:[stark1 lastModifiedDate]
                                      date2:[stark2 lastModifiedDate]
                                  tolerance:TIME_TOLERANCE]) {
            if (traceLevel > 4) {
                [self debugLogWithKey:constKeyLastModifiedDate
                               stark1:stark1
                               stark2:stark2];
            }
            return NO ;
        }
    }
    
    if (extoreConstants_p->canEditLastVisitedDate) {
        // See note 20120924
        if (![NSDate isEqualHandlesNilDate1:[stark1 lastVisitedDate]
                                      date2:[stark2 lastVisitedDate]
                                  tolerance:TIME_TOLERANCE]) {
            if (traceLevel > 4) {
                [self debugLogWithKey:constKeyLastVisitedDate
                               stark1:stark1
                               stark2:stark2];
            }
            return NO ;
        }
    }

    BOOL isSeparator = (stark1.sharypeValue == SharypeSeparator) || (stark2.sharypeValue == SharypeSeparator);
    /* It may be defensive programming there to check the sharypeValue of
     both; I'm not sure. */
    if (extoreConstants_p->canEditName && !isSeparator) {
        if (![NSObject isEqualHandlesNilObject1:[stark1 name]
                                        object2:[stark2 name]]) {
            if (traceLevel > 4) {
                [self debugLogWithKey:constKeyName
                               stark1:stark1
                               stark2:stark2];
            }
            return NO ;
        }
    }
    
    if (extoreConstants_p->canEditRating) {
        if (![NSObject isEqualHandlesNilObject1:[stark1 rating]
                                        object2:[stark2 rating]]) {
            if (traceLevel > 4) {
                [self debugLogWithKey:constKeyRating
                               stark1:stark1
                               stark2:stark2];
            }
            return NO ;
        }
    }
    
    if (extoreConstants_p->canEditRssArticles) {
        if (![NSObject isEqualHandlesNilObject1:[stark1 rssArticles]
                                        object2:[stark2 rssArticles]]) {
            if (traceLevel > 4) {
                [self debugLogWithKey:constKeyRssArticles
                               stark1:stark1
                               stark2:stark2];
            }
            return NO ;
        }
    }
    
    if ([[self class] canEditShortcutInStyle:style]) {
        // Some clients may allow 0-length shortcut; others may turn them to nil.
        // As far as we are concerned, these are equal.  The following
        // line takes care of that.
        if ([[stark1 shortcut] length] != [[stark2 shortcut] length]) {
            if (![NSObject isEqualHandlesNilObject1:[stark1 shortcut]
                                            object2:[stark2 shortcut]]) {
                if (traceLevel > 4) {
                    logEntry = [[NSString alloc] initWithFormat:@"36770:    Different shortcut for %@:\n   stark1: %@\n   stark2: %@", name, [stark1 shortcut], [stark2 shortcut]];
                    [basis trace:logEntry] ;
                    [logEntry release] ;
                }
                if (traceLevel > 4) {
                    [self debugLogWithKey:constKeyShortcut
                                   stark1:stark1
                                   stark2:stark2];
                }
                return NO ;
            }
        }
    }
    
    if ([[self class] canEditTagsInStyle:style]) {
        NSSet* tags1 = [[NSSet alloc] initWithArray:[[stark1 tags] valueForKey:constKeyString]];
        NSSet* tags2 = [[NSSet alloc] initWithArray:[[stark2 tags] valueForKey:constKeyString]];
        if (![NSObject isEqualHandlesNilObject1:tags1
                                        object2:tags2]) {
            if (traceLevel > 4) {
                [self debugLogWithKey:constKeyTags
                               stark1:stark1
                               stark2:stark2];
            }
            [tags1 release];
            [tags2 release];
            return NO ;
        }
        [tags1 release];
        [tags2 release];
    }
    
    if (extoreConstants_p->canEditUrl) {
        if (![NSObject isEqualHandlesNilObject1:[stark1 url]
                                        object2:[stark2 url]]) {
            if (traceLevel > 4) {
                [self debugLogWithKey:constKeyUrl
                               stark1:stark1
                               stark2:stark2];
            }
            return NO ;
        }
    }
    
    if (extoreConstants_p->canEditVisitCount) {
        if (![NSObject isEqualHandlesNilObject1:[stark1 visitCount]
                                        object2:[stark2 visitCount]]) {
            if (traceLevel > 4) {
                [self debugLogWithKey:constKeyVisitCount
                               stark1:stark1
                               stark2:stark2];
            }
            return NO ;
        }
    }
    
    return YES ;
}

/*
 Note 20120924. The tolerance was 0.0 until BookMacster 1.12.0, when it was
 reported to me that all bookmarks were always being exported to
 Pinboard, and I found that the localStark (previously cached from
 Pinboard) had the fractional part of its addDate truncated, while
 the transStark (from the Collection) had precision to .001 sec.
*/

- (void)prepareBrowserForImportWithInfo:(NSMutableDictionary*)info {
	// This method is kind of a "no op".
	// Just add a key indicating success, and send the callback.
	[info setObject:[NSNumber numberWithBool:YES]
			 forKey:constKeySucceeded] ;
	[self sendIsDoneMessageFromInfo:info] ;
}

- (void)prepareBrowserForExportWithInfo:(NSMutableDictionary*)info {
	// This method is a "no op".
	// Just add a key indicating success, and send the callback.
	[info setObject:[NSNumber numberWithBool:YES]
			 forKey:constKeySucceeded] ;
	[self sendIsDoneMessageFromInfo:info] ;
}

- (void)restoreBrowserStateInfo:(NSDictionary*)info {
}

- (id)tweakedValueFromStark:(Stark*)stark
					forKey:(NSString*)key {
	return [stark valueForKey:key] ;
}

- (void)despoofTags:(NSSet<Tag*>*)tags {
    NSString* delimiter = [[self class] tagDelimiter] ;
    if (delimiter) {
        /* It looks like constKeyTagDelimiterReplacement is a hiddren preference. */
        NSNumber* charCode = [[NSUserDefaults standardUserDefaults] objectForKey:constKeyTagDelimiterReplacement] ;
        NSString* replacement;
        if ([charCode respondsToSelector:@selector(integerValue)]) {
            unichar charArray[1] ;
            charArray[0] = [charCode unsignedIntegerValue] ;
            replacement = [NSString stringWithCharacters:charArray
                                                  length:1] ;
        }
        else {
            NSError* error = SSYMakeError(897312, @"Corrupt preference for Tag Delimiter Replacement") ;
            /* Tag despoofing is not serious.  Display
             if we are in main app; oherwise, just log it. */
            if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
                [SSYAlert alertError:error] ;
            }
            [[BkmxBasis sharedBasis] logError:error
                              markAsPresented:NO];
            replacement = @"_" ;  // Default for corrupt prefs
        }
        
        [tags replaceOccurrencesOf:delimiter
                              with:replacement] ;
    }
}

// Must be implemented by subclasses
- (BOOL)makeStarksFromExtoreTree:(NSDictionary*)treeIn
                         error_p:(NSError**)error_p {
	NSString* msg = [NSString stringWithFormat:@"Forgot to override %s?", __PRETTY_FUNCTION__] ;
    
    if (error_p) {
        *error_p = SSYMakeError(257846, msg) ;
    }
    
	return NO ;
}

- (void)readExternalUsingCurrentStyleWithPolarity:(BkmxIxportPolarity)polarity
                                        jobSerial:(NSInteger)jobSerial
                                completionHandler:(void(^)(void))completionHandler {
    NSString* msg = [NSString stringWithFormat:
                     @"Will read from %@ in style %ld extore %p",
                     [self displayName],
                     (long)self.ixportStyle,
                     self] ;
    [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                logFormat:msg] ;


    /* augmentedCompletionHandler prevents retain cycle with ixporter */

    /*
     The retain, and then release of ixporter in augmentedCompletionHander
     hopes to fix a crash illustrated by 4 crash reports submitted by user
     Howard M.  Problem is that, at the top of this call stack, the ixporter
     was not an ixporter.  Property Extore.ixporter is declared `assign`.
     Apparently, it was deallocced.  Probably it was using an importer from
     an earlier task???

     Call Stack:
     -[Ixporter client]
     -[Extore client]
     -[Extore transMoc]
     -[Extore starker]
     -[ExtoreSafari makeStarksFromExtoreTree:error_p:]
     -[ExtoreSafari processImportedTree:caller:]

     I considered solving this problem more better by instead removng the
     assign-declared ixporter.  But that proved to be too involved.  See
     abandoned branch NoCoreDataInExtore.  */
    __block Ixporter* ixporter = self.ixporter;

    void (^augmentedCompletionHandler)(void);

    if (ixporter) {
        [ixporter retain];
        augmentedCompletionHandler = ^void (void) {
            if (completionHandler) {
                completionHandler();
            }
            [ixporter release];
        };
    } else {
        augmentedCompletionHandler = completionHandler;
    }

    /* augmentedAgainCompletionHandler prevents completionHandler from
     running more than once. */
    void (^augmentedAgainCompletionHandler)(void);
    /* Use __weak per Apple Documentation >
     Programming With Objective-C >
     Working with Blocks >
     Avoid Strong Reference Cycles when Capturing self */
    Extore* __weak weakSelf = self;
    augmentedAgainCompletionHandler = ^void (void) {
        NSString* msg = nil;
        @synchronized(self) {
            if (weakSelf.didReadExternal) {
                msg = [NSString stringWithFormat:
                       @"Whoops %p already read external", weakSelf];
            } else {
                weakSelf.didReadExternal = YES;
            }
        }
        if (msg) {
            [[BkmxBasis sharedBasis] forJobSerial:weakSelf.jobSerial
                                        logFormat:msg];
        } else {
            augmentedCompletionHandler();
        }
    };

    switch (self.ixportStyle) {
        case 1:
            [self readExternalStyle1ForPolarity:polarity
                              completionHandler:augmentedAgainCompletionHandler];
            break ;
        case 2:
            [self readExternalStyle2WithCompletionHandler:augmentedAgainCompletionHandler] ;
            break ;
        default:;
            NSString* msg = [NSString stringWithFormat:
                             @"Unrecognized Ixport Style: %ld",
                             self.ixportStyle] ;
            NSError* error = SSYMakeError(635238, msg) ;
            [self setError:error] ;
            augmentedAgainCompletionHandler();
    }
}

- (void)readExternalStyle1ForPolarity:(BkmxIxportPolarity)polarity
                    completionHandler:(void(^)(void))completionHandler {
	NSLog(@"Internal Error  584-9665 No override of %s for %@", __PRETTY_FUNCTION__, [self className]) ;
    /* Oh well, at least try to not hang the queue or whatever. */
    if (completionHandler) {
        completionHandler();
    }
}

- (void)readExternalStyle2WithCompletionHandler:(void(^)(void))completionHandler {
    [self setError:nil] ;
    BOOL ok = YES ;
    NSError* error = nil;
    if (completionHandler) {
        self.readExternalCompletionHandler = completionHandler;

        /* This method will always result in one of two possible callbacks.

         #1  -interappServer:didReceiveHeaderByte:data:.  This method calls
         -forgetTimeoutter to prevent possibility #2 from happening.

         #2  -timedOutImportTimer: This method calls -unleaseInterappServer to
         prevent possibility #1 from happening. */
    }

    /* Prepare to receive data as interapp server.

     We do this in a loop, 5 trials of 5 seconds each, because when we had
     Sheep-Sys-Worker, workers may have simultaneously by staging Workers
     triggered by bookmarks changes, and both of these may have run this code,
     attempting to set up servers with the same name.  If the first had not
     released the named port before the second tried, the second  would fail.
     Now, with BkmxAgent, there is no credible reason why it should not always
     work on the first try, but we leave the loop in since it does no harm. */
    NSInteger nServerTrials = 0;
    while (YES) {
        ok = [self prepareInterappServerWithUserInfo:nil
                                             error_p:&error] ;
        if (ok) {
            if (nServerTrials > 0) {
                NSString* msg = [[NSString alloc] initWithFormat:
                                 @"Busy port!  %ld tries to get %@",
                                 nServerTrials+1,
                                 [self fromClientPortName]
                                 ];
                [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                            logFormat:msg];
                [msg release];
            }
            break;
        }

        if (nServerTrials > 4) {
            error = [SSYMakeError(325844, @"Server failed") errorByAddingUnderlyingError:error] ;
            goto end ;
        }

        [NSThread sleepForTimeInterval:5.0];

        nServerTrials++;
    }

    NSTimer* existingTimeoutter = [self timeoutter] ;
    if (existingTimeoutter != nil) {
        NSLog(@"Warning 721-0249 Overwriting %@ %@ %ld %@ for %@",
              existingTimeoutter,
              [existingTimeoutter fireDate],
              (long)[existingTimeoutter isValid],
              [existingTimeoutter userInfo],
              self) ;
        [self forgetTimeoutter] ;
    }

    pid_t pidOfOwnerApp = [self pidOfOwnerApp] ;
    NSInteger secondsOwnerAppHasBeenRunning = [SSYOtherApper secondsRunningPid:pidOfOwnerApp] ;
    NSInteger delayNeeded = 0 ;
    if (secondsOwnerAppHasBeenRunning == -1) {
        /* The owner app is not running yet, or maybe it was quit since we
         laumched it or found it to be already running.  So we throw in
         something radical, without checking for errors, and hope it works.
         If this does not work, we'll get Error 145725 anyhow.
         Note that this radical relaunch will not quit after the sync
         operations are done, oh well. */
        [self launchOwnerAppPath:nil
                        activate:NO
                         error_p:NULL] ;
        NSString* msg = [NSString stringWithFormat:
                         @"Trying radical launch of %@",
                         self.clientoid.displayName] ;
        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                    logFormat:msg] ;
        // Was Internal Error 978-4537 %ld %@", (long)pidOfOwnerApp, self) ; prior to BkmkMgrs 1.22.23
        delayNeeded = NSApp ? 9.95 : 29.95 ;
    }
    else {
        delayNeeded = 5 - secondsOwnerAppHasBeenRunning ;
    }
    if (delayNeeded > 0) {
        [NSThread sleepForTimeInterval:delayNeeded] ;
    }

    // Prior to BookMacster 1.3.19, rxTimeout was 2.5.  This was
    // sufficient for Google Chrome, which sends exid feedback
    // asynchronously.  However, it is not sufficient for Firefox,
    // which does not return until the bookmarks have been processed.
    // It takes Firefox 5.6 seconds to read in my 1515 bookmarks and
    // and 0 tags. Once, it timed out at 120 seconds for Carol Kino's
    // 11K bookmarks.  Then it worked, taking 165 seconds.  Then it
    // failed three times with 180.  I decided to set it to 120 and
    // then change the error message to advise users to quit the
    // browser if it times out at 90.  (This will cause style 1 to
    // be used instead of this style 2.)  Note that I do *not* get
    // from the Firefox API (bookmarks.getTree()) and therefore cannot
    // display determinate progress for this operation.
    NSTimeInterval rxTimeout = [[BkmxBasis sharedBasis] isBkmxAgent] ? 300.103 : 90.127;
#if 0
#warning Faking constBkmxErrorImportTimedOut
    rxTimeout = 0;
#endif

    NSTimer* timeoutter = [NSTimer scheduledTimerWithTimeInterval:rxTimeout
                                                           target:self
                                                         selector:@selector(timedOutImportTimer:)
                                                         userInfo:nil
                                                          repeats:NO];
    [self setTimeoutter:timeoutter] ;

    char rxHeaderByte = 0 ;
    NSTimeInterval txTimeout ;
    NSNumber* txTimeoutNumber = [[NSUserDefaults standardUserDefaults] objectForKey:constKeyReadStyle2TxTimeout] ;
    if ([txTimeoutNumber respondsToSelector:@selector(doubleValue)]) {
        txTimeout = [txTimeoutNumber doubleValue] ;
    }
    else {
        txTimeout = 10.0 ;
        /* The above was 0.5 until BookMacster 1.20, then 3.0 until BkmkMgrs
         2.1.4, when Ken Weingart reported that error 145725 occurred with
         Firefox during a reboot.  Maybe Firefox needs more time during the
         busy reboot period? */
    }

    ok = [SSYInterappClient sendHeaderByte:constInterappHeaderByteForImport
                                 txPayload:nil
                                  portName:[[self browserExtensionPortName] stringByAppendingString:@".ToClient"]
                                      wait:YES
                            rxHeaderByte_p:&rxHeaderByte
                               rxPayload_p:NULL
                                 txTimeout:txTimeout
                                 rxTimeout:(rxTimeout + 1.0)  // +1.0 so that our timeoutter will time out first
                                   error_p:&error] ;
    if (!ok) {
        NSString* errDesc = [NSString stringWithFormat:
                             @"Our %@ extension did not respond",
                             [self ownerAppDisplayName]] ;
        error = [SSYMakeError(constBkmxErrorExtensionDidNotRespond, errDesc) errorByAddingUnderlyingError:error] ;
        NSString* rsugg = [NSString stringWithFormat:
                           @"%C  Quit and relaunch %@ (%@)\n"
                           @"%C  In its \"Extensions\" window, ensure that \"BookMacster Sync\" is enabled.\n"
                           @"%C  Retry the Import or Export\n\n"
                           @"If that does not fix it,\n\n"
                           @"%C  Click in the menu: %@ > Manage Browser Extensions.\n"
                           @"%C  Find the line for %@ (%@)\n"
                           @"%C  Use the buttons to Test, Uninstall and/or Install as required to get a positive Test result.\n"
                           @"%C  Retry the Import or Export\n",
                           (unsigned short)0x2022, // bullet
                           [self ownerAppDisplayName],
                           self.clientoid.profileName,
                           (unsigned short)0x2022, // bullet
                           (unsigned short)0x2022, // bullet
                           (unsigned short)0x2022, // bullet
                           [[BkmxBasis sharedBasis] appNameLocalized],
                           (unsigned short)0x2022, // bullet
                           [self ownerAppDisplayName],
                           self.clientoid.profileName,
                           (unsigned short)0x2022,  // bullet
                           (unsigned short)0x2022  // bullet
                           ] ;
        error = [error errorByAddingLocalizedRecoverySuggestion:rsugg] ;
        error = [error errorByAddingUserInfoObject:@YES
                                            forKey:constKeyDontPauseSyncing];
        goto end ;
    }

    if (rxHeaderByte != constInterappHeaderByteForAcknowledgment) {
        ok = NO ;
        NSString* msg = [NSString stringWithFormat:
                         @"Received ack '%c' instead of '%c'",
                         rxHeaderByte,
                         constInterappHeaderByteForAcknowledgment] ;
        error = SSYMakeError(165825, msg) ;
        goto end ;
    }

end:;
    if (!ok) {
        error = [error errorByAddingUserInfoObject:self.clientoid
                                            forKey:@"Clientoid"] ;
        [self forgetTimeoutter] ;
        [self setError:error] ;
        if (completionHandler) {
            completionHandler();
        }
    }
}

- (BOOL)writeData:(NSData*)data
		   toFile:(NSString*)path {
	[self setError:nil] ;
	BOOL ok = YES ;
	NSError* error_ = nil ;
	
	if (ok) {
		ok = [path pathIsWritableError_p:&error_] ;
		if (!ok) {
			[self setError:error_] ;
		}
	}
	
/*
 if (ok) {
		// -[NSData writeToFile:options:error will not create the
		// parent directory when creating a file, and this is an issue
		// when writing to accessiblePath.
		// So, test if file exists and create file if not.
		NSFileManager* fm = [NSFileManager defaultManager] ;
		NSString* parentDirectory = [path stringByDeletingLastPathComponent] ;
		if (![fm fileExistsAtPath:parentDirectory]) {
			// Stupid NSFileManager methods for creating files do not return
			// an error, so we must use BSD's mkdir() to create a file.
			int retval = mkdir(
							   [parentDirectory fileSystemRepresentation],
							   0700  // 0 prefix on numeric constant makes it octal representation
			) ;
			if (retval != 0) {
				ok = NO ;
				error_ = [NSError errorWithDomain:NSPOSIXErrorDomain
											 code:errno
										 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
												   @"Look up this error's code in errno.h", NSLocalizedDescriptionKey,
												   nil]] ;
			}
		}
*/
	
	if (ok) {
		ok = [data writeToFile:path
					   options:NSAtomicWrite
						 error:&error_] ;
	}
	
	if (!ok) {
		[self setError:error_] ;
	}

	return ok ;
}

- (BOOL)writeString:(NSString*)string
			 toFile:(NSString*)path {
	[self setError:nil] ;
	BOOL ok = YES ;
	NSError* error_ = nil ;
	
	if (ok) {
		ok = [path pathIsWritableError_p:&error_] ;
		if (!ok) {
			[self setError:error_] ;
		}
	}
		
	if (ok) {
		ok = [string writeToFile:path
					  atomically:YES
						encoding:NSUTF8StringEncoding
						   error:&error_] ;
	}
	
	if (!ok) {
		[self setError:error_] ;
	}
	
	return ok ;
}

- (NSInteger)minVersionForExtensionIndex:(NSInteger)extensionIndex {
    NSString* extensionShortName = nil ;
    switch (extensionIndex) {
        case 1:
            extensionShortName = @"Sync" ;
            break ;
        case 2:
            extensionShortName = @"Button" ;
            break ;
    }

    NSBundle* bundle = [NSBundle mainAppBundle] ;
    NSString* browserName = [[self class] baseName];
    NSString* infoPlistKey = [NSString stringWithFormat:
                              @"W3CBE%@ExtensionMinVersionFor%@",
                              extensionShortName,
                              browserName] ;
    NSString* versionString = [bundle objectForInfoDictionaryKey:infoPlistKey] ;
    if (!versionString) {
        infoPlistKey = [NSString stringWithFormat:
                        @"W3CBE%@ExtensionMinVersionForOthers",
                        extensionShortName] ;
        versionString = [bundle objectForInfoDictionaryKey:infoPlistKey];
    }
    if (!versionString) {
        NSLog(@"Internal Error 624-6298") ;
    }
    NSInteger version = [versionString integerValue] ;

    return version ;
}

+ (NSInteger)minVersionForMessenger {
	return 0 ;
}

- (void)attribufyArticleStangeDic:(NSMutableDictionary*)stangeDic
				   fromArticleDic:(NSDictionary*)articleDic {
	// Firefox, OmniWeb:
	[stangeDic setValue:[articleDic objectForKey:constKeyName]
				 forKey:constKeyName] ;
	// Firefox, OmniWeb:
	[stangeDic setValue:[articleDic objectForKey:constKeyUrl]
				 forKey:constKeyUrl] ;
	// Firefox:
	[stangeDic setValue:[[articleDic objectForKey:constKeyAddDate] longLongMicrosecondsSince1970]
				 forKey:constKeyAddDate] ;
	// Firefox:
	[stangeDic setValue:[[articleDic objectForKey:constKeyLastModifiedDate] longLongMicrosecondsSince1970]
				 forKey:constKeyLastModifiedDate] ;
	// OmniWeb:
	[stangeDic setValue:[articleDic objectForKey:constKeyShortcut]
				 forKey:constKeyShortcut] ;
	// Firefox:
	[stangeDic setValue:[articleDic objectForKey:constKeyComments]
				 forKey:constKeyComments] ;
	
	id value ;
	
	// All - exid
	value = [[articleDic objectForKey:constKeyExids] objectForKey:self.clientoid];
	[stangeDic setValue:value
				  forKey:constKeyExid] ;
}

- (NSInteger)attribufyStangeDic:(NSMutableDictionary*)stangeDic
                      fromStark:(Stark*)stark {
	NSInteger errorCode = 0 ;
	id value ;
	
	// parentExid
	value = [[stark parent] exidForClientoid:self.clientoid] ;
    /* value=exid will be nil if parent is the root.  This can maybe happen
     with Safari.  SheepSafariHelper knows that nil parentExid means root.  See
     Comment 171027. */
	if (value) {
		[stangeDic setObject:value
					  forKey:constKeyParentExid] ;
	}

	// exid
	value = [stark exidForClientoid:self.clientoid] ;
	if (!value) {
		// This stark is apparently a new insertion to this extore.
		// Give it a temporary exid, just to serve as a key in
		// exid feedback
		value = [SSYUuid compactUuid] ;
		[stark setExid:value
		  forClientoid:self.clientoid] ;
	}
	[stangeDic setObject:value
				  forKey:constKeyExid] ;
	
	// index
	value = [stark index] ;
	if (value) {
        if ([[stark parent] isRoot]) {
            NSInteger indexOffset = [self indexOffsetForRoot];
            if (indexOffset != 0) {
                value = [NSNumber numberWithInteger:([(NSNumber*)value integerValue] + indexOffset)];
            }
        }
		[stangeDic setObject:value
					  forKey:constKeyIndex] ;
	}
	else {
		errorCode = 266541 ;
		goto end ;
	}
	
	// name
	value = [stark nameNoNil] ;
    // The above was just [stark name] until BookMacster 1.15.3.
	if (value) {
		[stangeDic setObject:value
					  forKey:constKeyName] ;
	}
	else {
		errorCode = 264085 ;
		goto end ;
	}
	
	// shortcut
	value = [stark shortcut] ;
	if (value) {
		[stangeDic setObject:value
					  forKey:constKeyShortcut] ;
	}
	
	// comments
	value = [stark comments] ;
	if (value) {
		[stangeDic setObject:value
					  forKey:constKeyComments] ;
	}
		
	// addDate
	// Next lines changed in BookMacster 1.11, see Note 190351, for Chrome
	value = [stark ownerValueForKey:constKeyAddDate] ;
	if (!value) {
		value = [stark addDate] ;
	}
	if (value) {
		// Note: The microsecondsSince1970 format is used because it is
		// (a) used by Firefox, which is the only extore which is going
		//     to use this value, and
		// (b) accurately convertible to other types, should that ever
		//     be necessary for some other browser.
		[stangeDic setObject:[value longLongMicrosecondsSince1970]
					  forKey:constKeyAddDate] ;
	}
	
	// dateLastModified
	// Next 5 lines changed in BookMacster 1.11, see Note 190351, for Chrome
	value = [stark ownerValueForKey:constKeyLastModifiedDate] ;
	if (!value) {
		value = [stark lastModifiedDate] ;
	}
	if (value) {
		// See previous comment regarding the microsecondsSince1970 format.
		[stangeDic setObject:[value longLongMicrosecondsSince1970]
					  forKey:constKeyLastModifiedDate] ;
	}
	
	// visitCount
	value = [stark visitCount] ;
	if (value) {
		[stangeDic setObject:value
					  forKey:constKeyVisitCount] ;
	}
	
	// tags
	[stangeDic setValue:[stark tags]
				 forKey:constKeyTags] ;
	
	// ownerValues
	// Removed in BookMacster 1.11
	// [stangeDic setValue:[stark localValues]
	//			 forKey:constKeyOwnerValues] ;	
	
	// We need the following key in order to sort the insertions
	// array, below.  (This key is not used by the Client.)
	value = [NSNumber numberWithInteger:[stark lineageDepth]] ;

    [stangeDic setObject:value
				  forKey:constKeyDepth] ;
	
end:	
	return errorCode ;
}

- (NSString*)msgWaitingForClientNum:(NSInteger)num
								den:(NSInteger)den {
	NSString* answer = [NSString localizeFormat:
						 @"waitingFor%0",
						 [self ownerAppDisplayName]] ;
	
	if (den != 0) {
		answer = [answer stringByAppendingFormat:
						@" (%ld/%ld)",
						(long)num,
						(long)den] ;
	}

	return answer ;
}

- (void)writeUsingStyle1InOperation:(SSYOperation*)operation {
	NSLog(@"Internal Error 612-0198 No override of %s for %@", __PRETTY_FUNCTION__, [self className]) ;
}

- (void)writeUsingStyle2InOperation:(SSYOperation*)operation {
	NSLog(@"Internal Error 612-0271 No override of %s for %@", __PRETTY_FUNCTION__, [self className]) ;
}

- (BOOL)pushToCloudError_p:(NSError**)error_p {
	return YES ;
}

- (BOOL)canRemoveHartainers {
    return NO ;
}

- (NSDictionary*)changeInfoForOperation:(SSYOperation*)operation
                                error_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
    NSDictionary* dic = nil ;
	
	Chaker* chaker = [(BkmxDoc*)[[operation info] objectForKey:constKeyDocument] chaker] ;
	
	NSMutableArray* deletedContainers = [[NSMutableArray alloc] init] ;
	NSMutableArray* deletedLeaves = [[NSMutableArray alloc] init] ;
	
	// In order to avoid Weird Corner Cases in reconstructing the
	// bookmarks hierarchy in the client, we organize changes into
	// the following groups.
	// See DesignDocumentation/ExportChangeAlgorithm.txt.
	NSMutableArray* cuts = [[NSMutableArray alloc] init] ;      // These are deletions
	NSMutableArray* puts = [[NSMutableArray alloc] init] ;      // These are moves and insertions
	NSMutableArray* repairs = [[NSMutableArray alloc] init] ;   // These are updates
    NSMutableDictionary* parentsWithSlides = [NSMutableDictionary new];
    NSMutableSet* exidsAlreadyInPuts = [NSMutableSet new];
	
	NSMutableArray* stangesArray = [[[chaker stanges] allValues] mutableCopy] ;
	[stangesArray sortUsingSelector:@selector(compareStarkPositions:)] ;
	NSMutableArray* deletedStarks = nil ;
	
	/* 
	 What happens to RSS Articles?
	 
	 Assume that Firefox will take care of deleting articles when the owning Live RSS Feed (livemark) is deleted.
	 Articles should be added as insertions when the owning Live RSS Feed (livemark) is inserted.
	 Moves would never occur since there is no way in BookMacster to move an RSS Article.
	 Updates would never occur since there is no way in BookMacster to edit an RSS Article.
	 */ 
	
	/* 
	 Although we iterate over stanges, in fact there is a guaranteed one-to-one correspondence
	 between stanges and changed starks.  So we are effectively iterating over changed starks,
	 and all the data for any given stark appears in a single loop iteration.
	 */
	id value ;
	NSInteger errorCode = 0 ;
    NSString* errorDescription = nil;
	NSString* msg = [NSString stringWithFormat:@"Packaging changes for %@", self.clientoid.displayName] ;
    SSYProgressView* progressView = [[self progressView] setIndeterminate:NO
                                                        withLocalizedVerb:msg
                                                                 priority:SSYProgressPriorityRegular] ;
    [progressView setMaxValue:[stangesArray count]] ;
	[progressView setDoubleValue:1.0] ;
	[progressView setEnabled:YES] ;
	for (Stange* stange in stangesArray) {
		[progressView incrementDoubleValueBy:1.0] ;
		Stark* stark = [stange stark] ;
        Stark* parent = nil ;
        BOOL shouldSkip = NO;
        if ([stark isHartainer]) {
            if (![self canRemoveHartainers]) {
                shouldSkip = YES;
                switch (stark.sharypeValue) {
                    case SharypeBar:
                        shouldSkip = ![self mustHaveBarInFile];
                        break;
                    case SharypeMenu:
                        shouldSkip = ![self mustHaveMenuInFile];
                        break;
                    case SharypeUnfiled:
                        shouldSkip = ![self mustHaveUnfiledInFile];
                        break;
                    case SharypeOhared:
                        shouldSkip = ![self mustHaveOharedInFile];
                        break;
                }
            }
        }
		if (shouldSkip) {
			continue ;
		}

		NSMutableDictionary* stangeDic = [[NSMutableDictionary alloc] init] ;
		
        switch ([stange changeType]) {
			case SSYModelChangeActionRemove:
				if ([stark canHaveChildren]) {
					[deletedContainers addObject:stark] ;
				}
				else {
					[deletedLeaves addObject:stark] ;
				}
				break;
			case SSYModelChangeActionInsert:;
                NSString* rareMissingHartainer = nil;

                // The following properties are a union set of those supported
				// and used, by Safari, Firefox and Chrome.
				
				// type
				Sharype sharype = [stark sharypeValue] ;
				switch (sharype) {
					case SharypeBookmark:
					case SharypeSmart:
                        value = [stark url] ;
						if (value) {
							[stangeDic setObject:value
										  forKey:constKeyUrl] ;
						}
						value = BkmxConstTypeBookmark ;
						break ;
					case SharypeSoftFolder:
						value = BkmxConstTypeFolder ;
						break ;
					case SharypeSeparator:
                        /* Starting in BkmkMgrs 2.9.8, separators have URLs
                         (separator://<compactUuid> to play nice with Safari
                         and iCloud. */
                        value = [stark url] ;
                        if (value) {
                            [stangeDic setObject:value
                                          forKey:constKeyUrl] ;
                        }
						value = BkmxConstTypeSeparator ;
						break ;
					case SharypeLiveRSS:
						value = [stark url] ;
						if (value) {
							[stangeDic setObject:value
										  forKey:BkmxConstTypeFeedUrl] ;
						}
						
						NSNumber* articleDepth = [NSNumber numberWithInteger:([stark lineageDepth] + 1)]  ;
						
						NSInteger i = 0 ;
						for (NSDictionary* articleDic in [stark rssArticles]) {
							NSMutableDictionary* articleStangeDic = [[NSMutableDictionary alloc] init] ;
							[articleStangeDic setObject:BkmxConstTypeBookmark
												 forKey:constKeyType] ;
							
							[self attribufyArticleStangeDic:articleStangeDic
											 fromArticleDic:articleDic] ;
							
							value = [stark exidForClientoid:self.clientoid] ;
							if (value) {
								[articleStangeDic setObject:value
													 forKey:constKeyParentExid] ;
							}
                            else {
                                NSLog(@"Internal Error 256-2021 %@", articleDic) ;
                            }
							[articleStangeDic setObject:articleDepth
												 forKey:constKeyDepth] ;
							[articleStangeDic setObject:[NSNumber numberWithInteger:i]
												 forKey:constKeyIndex] ;
							
                            [puts addObject:articleStangeDic] ;
                            [exidsAlreadyInPuts addObject:[articleStangeDic objectForKey:constKeyExid]];
							[articleStangeDic release] ;
							i++ ;
						}
						
						value = BkmxConstTypeLivemark ;
						break ;
                        /* The following hartainer types are only used
                         rarely, in Safari, to create a missing hartainer.
                         The only one I've seen in real life is the Unfiled.
                         See other comments marked by
                         NoteRareMissingSafariHartainer. */
                    case SharypeBar:
                        rareMissingHartainer = BkmxConstTypeBar;
                        break;
                    case SharypeMenu:
                        rareMissingHartainer = BkmxConstTypeMenu;
                        break;
                    case SharypeUnfiled:
                        rareMissingHartainer = BkmxConstTypeUnfiled;
                        break;
                    case SharypeOhared:
                        rareMissingHartainer = BkmxConstTypeOhared;
                        break;
					default:
						// The Sharype values not covered in a case …: are the various
						// hartainers, and SharypeRSSArticle.  If any of these occur
						// here, it is an internal error.   Here's why…
						// 1.  We should never be inserting a hartainer of any kind.
						// 2.  Any RSS Articles should have been changed back into
						// bookmarks during -restoreRssArticlesInsertAsChildStarks.
						NSLog(@"Internal Error 658-5105 %@", [stark shortDescription]) ;
                        value = BkmxConstTypeBookmark ;
						break ;
				}

                if (rareMissingHartainer) {
                    NSString* msg = [NSString stringWithFormat:@"Will add rare missing hartainer: %@", rareMissingHartainer];
                    [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                logFormat:msg];
                    value = rareMissingHartainer;
                }
				[stangeDic setObject:value
							  forKey:constKeyType] ;
				
				errorCode = [self attribufyStangeDic:stangeDic
										   fromStark:stark] ;
				if (errorCode != 0) {
					goto endStangeIterations ;
				}
				
				[stangeDic setObject:[NSNumber numberWithBool:YES]
							  forKey:constKeyIsNew] ;
                [puts addObject:stangeDic] ;
                [exidsAlreadyInPuts addObject:[stangeDic objectForKey:constKeyExid]];
				break;
			case SSYModelChangeActionMosh:  // Fix added in BookMacster 1.7/1.6.8
			case SSYModelChangeActionSlosh:
			case SSYModelChangeActionSlide:
			case SSYModelChangeActionMove:
				// exid
				value = [stark exidForClientoid:self.clientoid] ;
				if (value) {
					[stangeDic setObject:value
								  forKey:constKeyExid] ;
				}
				else {
					errorCode = 561931 ;
					goto endStangeIterations ;
				}
				
				// parentExid
                parent = [stark parent] ;
                value = [parent exidForClientoid:self.clientoid] ;
                /* value=exid will be nil if parent is the root.  This can
                 happen with Safari because soft items are allowed at root.
                 SheepSafariHelper knows that nil parentExid means root.  See
                 Comment 171027. */
                if (value) {
					[stangeDic setObject:value
								  forKey:constKeyParentExid] ;
				}

                NSInteger indexOffset = 0;
                if ([parent isRoot]) {
                    indexOffset = [self indexOffsetForRoot];
                }

                if (
                    ([stange changeType] == SSYModelChangeActionSlide)
                    ||
                    ([stange changeType] == SSYModelChangeActionSlosh)
                    ) {
                    if (!value) {
                        value = @"Root-Placeholder";
                    }

                    NSMutableDictionary* subdicForThisParent = [parentsWithSlides objectForKey:value];
                    if (!subdicForThisParent) {
                        subdicForThisParent = [NSMutableDictionary new];
                        [subdicForThisParent setObject:parent
                                                forKey:constKeyStark];
                        NSMutableIndexSet* indexSet = [NSMutableIndexSet new];
                        [subdicForThisParent setObject:indexSet
                                                forKey:@"indexes"];
                        [indexSet release];
                        [parentsWithSlides setObject:subdicForThisParent
                                              forKey:value];
                        [subdicForThisParent release];
                    }

                    [[subdicForThisParent objectForKey:@"indexes"] addIndex:([[stark index] integerValue] + indexOffset)];
                }

                // index
				value = [stark index] ;
				if (value) {
                    if (indexOffset != 0) {
                        value = [NSNumber numberWithInteger:([value integerValue] + indexOffset)];
                    }
					[stangeDic setObject:value
								  forKey:constKeyIndex] ;
				}
				else {
					errorCode = 408562 ;
                    errorDescription = [NSString stringWithFormat:
                                        @"When exporting to  %@, cannot %@ without destin index.  Skipping bad stange:\n%@",
                                        [self displayName],
                                        [SSYModelChangeTypes asciiNameForAction:stange.changeType],
                                        stange];
                    goto endStangeIterations ;
                    /* I tried making this only a warning in order to fix
                     a bug, but then there was churn because the same
                     bogus stange was produced with each export.  If this
                     error occurs, you must fix the root cause – stop
                     generating bogus stanges. */
				}
				
				// We need the following key in order to sort the insertions
				// array, below.  (This key is not used by the Client.)
				value = [NSNumber numberWithInteger:[stark lineageDepth]] ;
				[stangeDic setObject:value
							  forKey:constKeyDepth] ;	
				
                NSDictionary* putDic = [stangeDic copy];
                [puts addObject:putDic];
                [exidsAlreadyInPuts addObject:[putDic objectForKey:constKeyExid]];
                [putDic release];

				/* There is one case where a single stange must map into two
				 changes in Chromys.  That is the case of an item which has a
                 move or a slide in addition to name or url modified.  We
                 handle that case here by not breaking. */
			case SSYModelChangeActionModify:;
				BOOL needsRepair = NO ;
				for (NSString* key in [stange updates]) {
					if ([[self class] canEditAttribute:key
                                               inStyle:self.ixportStyle]) {
						NSDictionary* update = [[stange updates] objectForKey:key] ;
						id newValue = [update objectForKey:NSKeyValueChangeNewKey] ;
						
						// Workaround for BkmxDocs produced by BookMacster version 1.3.18 or earlier,
						// when 'comments' and 'shortcut' were allowed to be empty strings
						if ([key isEqualToString:constKeyComments] || [key isEqualToString:constKeyShortcut]) {
							if ([newValue length] == 0) {
								newValue = nil ;
							}
						}
						
						if (!newValue) {
                            // Note HowWeGetNullName
							newValue = [NSNull null] ;
							// BSJSONAdditions should make this into a JSON 'null' value
						}
						
						[stangeDic setValue:newValue
									 forKey:key] ;
						
						/*
						 Attributes for Firefox: 
						 name
						 url
						 feedUrl
						 shortcut
						 comments
						 addDate
						 lastModifiedDate
						 tags
						 visitCount
						 */
					}
					
					// Moves and Slides are handled as puts, so we don't
					// make this a 'repair' if key is 'parent' or 'index'
                    // We do make it a repair if key is not parent and not index
					if (![key isEqualToString:constKeyParent] && ![key isEqualToString:constKeyIndex]) {
						needsRepair = YES ;
					}
				}
				
				if ([[self class] canEditAttribute:constKeyTags
                                           inStyle:self.ixportStyle]) {
					NSArray* addedTags = [stange addedTags] ;
					NSArray* deletedTags = [stange deletedTags] ;
					if (([addedTags count] > 0) || ([deletedTags count] > 0)) {
						// Note that the stark's tags have already been mutated
						// during mergeFromStartainer:::: by overwriteAttributes::::.
						// So we just copy them from the stark
						[stangeDic setValue:[[stange stark] tags]
									 forKey:constKeyTags] ;
						
						needsRepair = YES ;
					}
				} 

				if (needsRepair) {
					// exid
					value = [stark exidForClientoid:self.clientoid] ;
					if (value) {
                        if (([stark sharypeValue] == SharypeLiveRSS) && [[self class] liveRssAreImmutable]) {
                            // Starting with Firefox 22 (BookMacster 1.15.3),
                            // Firefox does not allow editing of livemarks.
                            // Must delete it and create a new one, cut + put
                            
                            // First, add the cut
                            value = [stark exidForClientoid:self.clientoid] ;
                            if (value) {
                                /* Memory leak found by Xcode 8.3 and fixed in
                                 BkmkMgrs 2.4.4 2017-05-24 with next line. */
                                [stangeDic release];
                                stangeDic = [NSMutableDictionary dictionaryWithObject:value
                                                                               forKey:constKeyExid] ;
                            }
                            else {
                                ok = NO ;
                                error = SSYMakeError(309878, @"Could not process deletion of livemark") ;
                                error = [error errorByAddingUserInfoObject:[stark shortDescription]
                                                                    forKey:@"Stark"] ;
                                [stangeDic release] ;
                                goto end ;
                            }
                            [cuts addObject:stangeDic] ;

                            // Second, add the put
                            NSMutableDictionary* mutablePutDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         [NSNumber numberWithBool:YES], constKeyIsNew,
                                         BkmxConstTypeLivemark, constKeyType,
                                         [stark exidForClientoid:self.clientoid], constKeyExid,
                                         [stark nameNoNil], constKeyName,
                                         [stark index], constKeyIndex,
                                         nil] ;
                            id optionalValue;
                            optionalValue = [stark url];
                            if (optionalValue) {
                                [mutablePutDic setObject:optionalValue
                                                  forKey:BkmxConstTypeFeedUrl];
                            }
                            optionalValue = [[stark parent] exidForClientoid:self.clientoid];
                            if (optionalValue) {
                                [mutablePutDic setObject:optionalValue
                                                  forKey:constKeyParentExid];
                            }
                            NSDictionary* putDic = [mutablePutDic copy];
                            [mutablePutDic release];
                            [puts addObject:putDic] ;
                            [exidsAlreadyInPuts addObject:[stangeDic objectForKey:constKeyExid]];
                            [putDic release] ;
 
                            stangeDic = nil ;
                        }
                        else {
                            // Normal case
                            [stangeDic setObject:value
                                          forKey:constKeyExid] ;
                        }

                        if ([stangeDic count] > 0) {
                            [repairs addObject:stangeDic] ;
                        }
					}
					else {
						errorCode = 246854 ;
						goto endStangeIterations ;
					}
				}
                
				break;
			default:
				break;
		}
		
	endStangeIterations:
		[stangeDic release] ;
		
		if (errorCode != 0) {
			ok = NO ;
            if (!errorDescription) {
                errorDescription = @"Could not process changes for item";
            }
			error = SSYMakeError(errorCode, errorDescription) ;
			error = [error errorByAddingUserInfoObject:[stark shortDescription]
												forKey:@"Stark"] ;
			error = [error errorByAddingUserInfoObject:[parent shortDescription]
												forKey:@"Parent"] ;
			goto end ;
		}
	}
	[progressView clearAll] ;

    /* One more thing with puts, repairs.  If a folder (parent) contains slides
     (and for this purpose sloshes are a special case of slides), we will add
     to add slides for *all* of its children.  This is to  handle edge cases in
     which the final order may not be correct.  I only realized this on
     20171027, when I discovered this example:

     Say you have a folder of five items named E,D,C,B,A, in that order, and
     change is to reorder them as A,B,C,D,E.  The algorithm above will produce
     four puts, and the sorting below will sort them into this order:

     put1: move A to index 0
     put2: move B to index 1
     put3: move D to index 3
     put4: move E to index 4

     Note that no put is produced for C because it is already at the correct
     index.  But, when the four puts are run in the extension or SheepSafariHelper,
     the result will be

     .    at                After...             (final)
     . index   Initial      put1   put2   put3   put4
     .     0     E           A      A      A      A
     .     1     D           E      B      B      B
     .     2     C           D      D      E      D
     .     3     B           C      D      D      C
     .     4     A           B      C      C      E

     and you see that in the final state, C and D are out of order.
     
     The problem is that, for any parent affected by slides, there should be
     a 'put' for each of its children, whether or not their index is being
     changed.  (That may be overkill – I'm not sure, but for simplicity we
     shall accept the possible overkill and whatever performance hit that
     causes.)
     
     The code which follows adds in the missing 'puts'.
     */
    for (NSDictionary* exid in parentsWithSlides) {
        NSDictionary* subdicForThisParent = [parentsWithSlides objectForKey:exid];
        Stark* parent = [subdicForThisParent objectForKey:constKeyStark];
        NSInteger indexOffset = 0;
        if ([parent isRoot]) {
            indexOffset = [self indexOffsetForRoot];
        }
        NSIndexSet* fulfilledIndexes = [subdicForThisParent objectForKey:@"indexes"];
        for (NSInteger i=0; i<[parent numberOfChildren]; i++) {
            if (![fulfilledIndexes containsIndex:(i+indexOffset)]) {
                Stark* child = [[parent childrenOrdered] objectAtIndex:i];
                /* We used -childrenOrdered, objectAtIndex: instead of
                 -childAtIndex because in some edge cases there could still
                 be multiple children with the same index at this point.  All
                 except one of the multiple children with the same index
                 should be marked as deleted during this ixport; that is,
                 -isDeletedThisIxport should return YES. */
                id value;

                value = [child exidForClientoid:self.clientoid];
                if ([exidsAlreadyInPuts member:value] == nil) {
                    if (![child isHartainer]  && ![child isDeletedThisIxport]) {
                        NSMutableDictionary* mutablePutDic = [NSMutableDictionary new];
                        if (value) {
                            [mutablePutDic setObject:value
                                              forKey:constKeyExid] ;
                        } else {
                            NSLog(@"Internal Error 523-8588 for %@", [child shortDescription]);
                        }

                        value = [parent exidForClientoid:self.clientoid];
                        /* value=exid will be nil if parent is the root.  This can
                         happen with Safari because soft items are allowed at root.
                         SheepSafariHelper knows that nil parentExid means root.  See
                         Comment 171027. */
                        if (value) {
                            [mutablePutDic setObject:value
                                              forKey:constKeyParentExid] ;
                        }

                        NSInteger index = [child indexValue] + indexOffset;
                        [mutablePutDic setObject:[NSNumber numberWithInteger:index]
                                          forKey:constKeyIndex];

                        value = [NSNumber numberWithInteger:[child lineageDepth]] ;
                        [mutablePutDic setObject:value
                                          forKey:constKeyDepth];
                        NSDictionary* putDic = [mutablePutDic copy];
                        [mutablePutDic release];
                        [puts addObject:putDic];
                        [putDic release];
                    }
                }
            }
        }
    }

	deletedStarks = [deletedContainers mutableCopy] ;
	[deletedStarks addObjectsFromArray:deletedLeaves] ;
	
	NSSortDescriptor* descriptor1 ;
	NSSortDescriptor* descriptor2 ;
	NSArray* descriptors ;
	
	/*
	 // (This was added in BookMacster 1.3.19.)
	 
	 There are two ways to do this.
	 
	 The "old way" is slightly faster (:50 vs 1:10 to delete all
	 of my bookmarks), but has the disadvantage that if the
	 user deletes a large tree of items, progress bar indication
	 will be very choppy because Firefox will take a long time to 
	 delete this one item but not send any progress updates ('p'
	 interapp messages) until it is done. 
	 
	 The new way is to send all starks to be deleted to the Client,
	 but sort the starks so that children will be deleted before
	 their parents, to avoid errors, because the Client (Firefox)
	 will cascade-delete children.
	 
	 For Chrome, it doesn't matter because either way is very fast.
	 */
	
#if 0
#warning Sorting 'cuts' the faster way that gives erratic progress
	// You know I could get better performance by using this method if ([[BkmxBasis sharedBasis] isBkmxAgent])
	for (Stark* stark in deletedStarks) {
		if (![stark descendsFromAnyOf:deletedContainers]) {
			
			NSMutableDictionary* stangeDic = [[NSMutableDictionary alloc] init] ;
			
			// exid
			value = [stark exidForClientoid:self.clientoid] ;
			if (value) {
				[stangeDic setObject:value
							  forKey:constKeyExid] ;
			}
			else {
				ok = NO ;
				error = SSYMakeError(398418, @"Could not process deletion of item") ;
				error = [error errorByAddingUserInfoObject:[stark shortDescription]
													forKey:@"Stark"] ;
				[stangeDic release] ;
				goto end ;
			}
			
			[cuts addObject:stangeDic] ;
            
			[stangeDic release] ;
		}
	}
#else
	// Start at the leaves and go to the root --> lineageDepth is *de*scending
	descriptor1 = [[NSSortDescriptor alloc] initWithKey:@"lineageDepthObject"
											  ascending:NO] ;
	descriptors = [NSArray arrayWithObjects:descriptor1, nil] ;
	[descriptor1 release] ;
	[deletedStarks sortUsingDescriptors:descriptors] ;
	for (Stark* stark in deletedStarks) {
		NSMutableDictionary* stangeDic = [[NSMutableDictionary alloc] init] ;
		
		// exid
		value = [stark exidForClientoid:self.clientoid] ;
		if (value) {
			[stangeDic setObject:value
						  forKey:constKeyExid] ;
		}
		else {
			ok = NO ;
			error = SSYMakeError(398714, @"Could not process deletion of item") ;
			error = [error errorByAddingUserInfoObject:[stark shortDescription]
												forKey:@"Stark"] ;
			[stangeDic release] ;
			goto end ;
		}
		
		[cuts addObject:stangeDic] ;
        
		[stangeDic release] ;
	}
#endif
	
/* We must do puts in a certain order.

 1.  Since the Clients will ignore our exids and assign its own, we must start
 at the top of the hierarchy, i.e. sort by lineageDepth.

 2.  Second, we must sort ascending by index.  Reasons for this:
 2a. Chrome will not allow bookmarks to be inserted beyond the current range,
 which could of course happen if higher-indexed items are inserted first.
 2b. If you are inserting multiple items into a folder, and higher-indexed
 items are inserted first, they will be displaced when lower-indexed items
 are inserted later.

 Note: -compare: is implemented by Apple in NSNumber */
	descriptor1 = [[NSSortDescriptor alloc] initWithKey:constKeyDepth
											  ascending:YES
											   selector:@selector(compare:)] ;
	descriptor2 = [[NSSortDescriptor alloc] initWithKey:constKeyIndex
											  ascending:YES
											   selector:@selector(compare:)] ;
	descriptors = [NSArray arrayWithObjects:descriptor1, descriptor2, nil] ;
	[descriptor1 release] ;
	[descriptor2 release] ;
	[puts sortUsingDescriptors:descriptors] ;
	
	dic = [NSDictionary dictionaryWithObjectsAndKeys:
           cuts, constKeyCuts,
           puts, constKeyPuts,
           repairs, constKeyRepairs,
           nil] ;

end:;	
	[deletedContainers release] ;
	[deletedLeaves release] ;
	[stangesArray release] ;
	[cuts release] ;
	[puts release] ;
	[repairs release] ;
    [parentsWithSlides release];
    [exidsAlreadyInPuts release];
	[deletedStarks release] ;
	
	if (!ok && error_p) {
		*error_p = error ;
	}

	return dic ;
}

- (NSString*)localIdentifier {
    NSString* identifier = self.clientoid.exformat ;
    NSString* profileName = self.clientoid.profileName ;
    if (!profileName) {
        profileName = [[self class] defaultProfileName];
    }
    identifier = [identifier stringByAppendingDotSuffix:profileName] ;

    return identifier ;
}

- (void)exportJsonViaIpcForOperation:(SSYOperation*)operation {
#if 0
#warning Bypassing write for testing
    NSLog(@"Bypassing write for testing") ;
    [operation writeAndDeleteDidSucceed:YES];
    return;
#endif

	BOOL ok = YES ;
	NSError* error = nil ;
	
	NSDictionary* dic = [self changeInfoForOperation:operation
											 error_p:&error] ;
	if (error) {
		ok = NO ;
		goto end ;
	}
		
	NSMutableString* dirtyJsonChangesString = [[dic jsonStringValue] mutableCopy];
    NSString* jsonChangesString = [dirtyJsonChangesString stringByRemovingCharactersInSet:[NSCharacterSet zeroWidthAndIllegalCharacterSet]];
    [dirtyJsonChangesString release];
    
    if ([[BkmxBasis sharedBasis] traceLevel] > 0) {
        NSString* path;
        path = [[NSFileManager defaultManager] ensureDesktopDirectoryNamed:@"Bkmx-Ixport-Traces"
                                                                   error_p:&error];
        NSString* filename = [NSString stringWithFormat:
                              @"Export-%@-%@.json",
                              [self ownerAppDisplayName],
                              [[NSDate date] compactDateTimeString]];
        path = [path stringByAppendingPathComponent:filename] ;
        [jsonChangesString writeToFile:path
                            atomically:YES
                              encoding:NSUTF8StringEncoding
                                 error:NULL] ;
    }

    if ([[self class] canDetectOurChanges]) {
		NSString* appSupportPath = [[NSBundle mainAppBundle] applicationSupportPathForMotherApp] ;
		NSString* path = [appSupportPath stringByAppendingPathComponent:@"Changes"] ;
		path = [path stringByAppendingPathComponent:@"Exported"] ;
		[[NSFileManager defaultManager] createDirectoryAtPath:path
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL] ;
		path = [path stringByAppendingPathComponent:[self localIdentifier]] ;
		path = [path stringByAppendingPathExtension:@"json"] ;
		[jsonChangesString writeToFile:path
							atomically:YES
							  encoding:NSUTF8StringEncoding
								 error:NULL] ;
		
		NSArray* keyPathArray = [NSArray arrayWithObjects:
								 constKeyLastJsonExport,
								 [self localIdentifier],
								 nil] ;
		NSNumber* dateInSeconds = [NSNumber numberWithUnsignedInteger:(NSUInteger)floor([NSDate timeIntervalSinceReferenceDate])] ;
        [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:dateInSeconds
                                                      forKeyPathArray:keyPathArray] ;
	}
    
	NSData* txPayload = [NSKeyedArchiver archivedDataWithRootObject:jsonChangesString
                                              requiringSecureCoding:YES
                                                              error:&error];
	/* Question: Why do I encode jsonChangesString as an archive?  Why not just
     encode as UTF8?  Well, maybe to try and future proof Apple security
     tightenings?  Oh, well, it works. */
    
	// Initialize the progressView, because, especially when doing exports, progress
	// can be very choppy.  For example, if I delete all of my 1400 bookmarks, there
	// are only 6 items which get deleted; some of them contain hundreds of bookmarks.
	// So we want to start out by showing at least 0 progress.
	NSString* msg = [self msgWaitingForClientNum:0
											 den:0] ;
    SSYProgressView* progressView = [[[self bkmxDoc] progressView] setIndeterminate:NO
                                                                  withLocalizedVerb:msg
                                                                           priority:SSYProgressPriorityRegular] ;
	[progressView setMaxValue:100] ;
	[progressView setDoubleValue:2.0] ;
	[progressView setEnabled:YES] ;
	
	// Get ready for Exid Feedback (In this case, we're the server.)
	// Note that we do this before sending the message to the browser messenger,
	// in case the browser messenger returns a response really fast.
    ok = [self prepareInterappServerWithUserInfo:@{constKeyReadExternalOperation: operation}
                                         error_p:&error] ;
	if (!ok) {
		error = [SSYMakeError(974267, @"Server failed") errorByAddingUnderlyingError:error] ;
		goto end ;
	}

	// Experiment to see if I can fix problem where,
	// once in awhile, Firefox does not find the port
	// when sending an import of 0 bookmarks (not here,
	// but it's a similar case)
	sleep (1) ;
		
	NSTimer* existingTimeoutter = [self timeoutter] ;
	if (existingTimeoutter != nil) {
		NSLog(@"Warning 721-3454 Overwriting %@ %@ %ld %@ for %@",
			  existingTimeoutter,
			  [existingTimeoutter fireDate],
			  (long)[existingTimeoutter isValid],
			  [existingTimeoutter userInfo],
			  self) ;
		[self forgetTimeoutter] ;
	}

	NSUInteger nCuts = [[dic objectForKey:constKeyCuts] count] ;
	NSUInteger nPuts = [[dic objectForKey:constKeyPuts] count] ;
	NSUInteger nRepairs = [[dic objectForKey:constKeyRepairs] count] ;
	NSTimeInterval secsPer = [self exportFeedbackTimeoutPerChange] ;
	NSTimeInterval timeout = (0
							  + nCuts
							  + nPuts
							  + nRepairs
							  ) * secsPer ;
    if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
        if (timeout < TIMEOUT_EXID_FEEDBACK_MIN_MAIN_APP) {
            timeout = TIMEOUT_EXID_FEEDBACK_MIN_MAIN_APP;
        }
    } else {
        if (timeout < TIMEOUT_EXID_FEEDBACK_MIN_WORKER) {
            timeout = TIMEOUT_EXID_FEEDBACK_MIN_WORKER;
        }
    }
	NSDictionary* timeoutDic = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithUnsignedInteger:nCuts], @"nCuts",
								[NSNumber numberWithUnsignedInteger:nPuts], @"nPuts",
								[NSNumber numberWithUnsignedInteger:nRepairs], @"nRepairs",
								[NSNumber numberWithDouble:secsPer], @"secsPer",
                                [NSNumber numberWithDouble:timeout], @"timeout",  // Added in BookMacster 1.19.0
								nil] ;
	[[operation info] setObject:timeoutDic
						 forKey:constKeyTimeoutForExidsInfo] ;
	NSTimer* timeoutter = [NSTimer scheduledTimerWithTimeInterval:timeout
														   target:self
														 selector:@selector(timedOutExportFeedbackTimer:)
														 userInfo:operation
														  repeats:NO] ;
	[self setTimeoutter:timeoutter] ;
	
    char rxHeaderByte = 0 ;
    
    timeout = [[BkmxBasis sharedBasis] timeoutForAppToLaunch] ;
    
    /* Added timeout loop in BookMaster 1.13.2
     If Google Chrome has just had its extension installed and just been
     relaunched by -prepareBrowserForExportWithInfo:, it may take
     some time before the extension loads and its SSYInterappClient
     port becomes available on the system.  During about 8 trials on my
     2012 MacBook Air, it looped here from 0.5 to 1.2 seconds.
     
     We make each loop 1/40 of the ultimate timeout. */
    useconds_t periodusecs = (timeout / 40) * 1e6 ;
    NSDate* startDate = [NSDate date] ;
    NSInteger numberOfTries = 0 ;  // Added in BookMacster 1.14.9
    NSTimeInterval grandTimeout = 1.5 * timeout;
    while (YES) {
        //NSLog(@"Sending header byte n=%ld, for %ld byte payload", (long)numberOfTries, txPayload.length) ;
        ok = [SSYInterappClient sendHeaderByte:constInterappHeaderByteForExport
                                     txPayload:txPayload
                                      portName:[[self browserExtensionPortName] stringByAppendingString:@".ToClient"]
                                          wait:YES
                                rxHeaderByte_p:&rxHeaderByte
                                   rxPayload_p:NULL
                                     txTimeout:0.5
              // Prior to BookMacster 1.3.19, rxTimeout was 2.5.  This was
              // sufficient for Google Chrome, which sends exid feedback
              // asynchronously.  However, it is not sufficient for Firefox,
              // which does not return until the bookmarks have been processed.
                                     rxTimeout:timeout
                                       error_p:&error] ;
        /* For Firefox, the above method may block for tens of seconds */
        numberOfTries++ ;
        if (ok) {
            /* This branch is normally taken on the first branch of the loop. */
            break ;
        }
        
        /* The remainder of the code in this loop will only execute if 
         SSYInterappClient failed to establish a connection with the client
         on the first try. */

        usleep(periodusecs) ;

        NSTimeInterval elapsed = -[startDate timeIntervalSinceNow] ;
        if (elapsed > grandTimeout) {
            // Browser or profile has apparently quit or unloaded since
            // the export started.
            NSString* msg = [NSString stringWithFormat:
                             @"%@ stopped responding while %@ was exporting to it.",
                             self.clientoid.displayName,
                             [[BkmxBasis sharedBasis] appNameLocalized]
                             ] ;
            error = [SSYMakeError(constBkmxBrowserStoppedRespondingDuringStyle2Export, msg) errorByAddingUnderlyingError:error] ;
            error = [error errorByAddingUserInfoObject:[NSNumber numberWithDouble:elapsed]
                                                forKey:@"Total elapsed wait time"] ;
            error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:numberOfTries]
                                                forKey:@"Number of Tries"] ;
            error = [error errorByAddingUserInfoObject:[NSNumber numberWithDouble:grandTimeout]
                                                forKey:@"Grand Timeout"] ;
            error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:[txPayload length]]
                                                forKey:@"Tx Payload Byte Count"] ;
            msg = [NSString stringWithFormat:@"Make sure that %@ is either in a responsive state or is quit.  Then activate %@ in %@ and command an export to %@ manually.\n\n"
                   @"If that doesn't resolve the problem, click in the menu %@ > Manage Browser Extensions.  Uninstall, (Re)Install and Test the first extension for %@.  Then retry the export.",
                   self.clientoid.displayName,
                   [(BkmxDoc*)[[operation info] objectForKey:constKeyDocument] displayName],
                   [[BkmxBasis sharedBasis] appNameLocalized],
                   self.clientoid.displayName,
                   [[BkmxBasis sharedBasis] appNameLocalized],
                   self.clientoid.displayName] ;
            error = [error errorByAddingLocalizedRecoverySuggestion:msg] ;
            goto end ;
        }
    }

	if (rxHeaderByte != constInterappHeaderByteForAcknowledgment) {
		ok = NO ;
		NSString* msg = [NSString stringWithFormat:
						 @"Received ack '%c' instead of '%c'",
						 rxHeaderByte,
						 constInterappHeaderByteForAcknowledgment] ;
		error = SSYMakeError(612801, msg) ;
        error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:numberOfTries]
                                            forKey:@"Number of Tries"] ;
		goto end ;
	}
	
end:	
	if (!ok) {
		[self forgetTimeoutter] ;
        [self setError:error] ;
        [operation writeAndDeleteDidSucceed:ok] ;
	}
}

- (void)timedOutExtensionVersionCheck:(NSTimer*)timer {
	NSString* msg = [NSString stringWithFormat:
					 @"Timed out waiting for %@",
					 self.clientoid.displayName] ;
	NSError* error = SSYMakeError(453165, msg) ;
	[self setError:error] ;
	
	// Note: 'timer' is the same 'timeoutter' which we are about to forget.
	// So we need to get its user info now.
	ExtensionsMule* mule = [timer userInfo] ;

	[self forgetTimeoutter] ;

    [mule extore:self
      testResult:[self processedExtension1Version:0
                                extension2Version:0
                                  receivedProfile:nil
                                            error:error]] ;
}

- (void)addHoggingAdviceAndRegisterError:(NSError*)error {
    NSString* reason = NSLocalizedString(@"This can be caused by your computer being temporarily too busy.", nil);
    error = [error errorByAddingLocalizedFailureReason:reason];
    error = [error errorByAddingHelpAddress:constHelpAnchorLaunchBrowserPref];
    if (![[self class] hasProprietarySyncThatNeedsOwnerAppRunning] && [self style1Available]) {
        NSString* suggestion = [NSString stringWithFormat:
                                    NSLocalizedString(@"Quit %@ and then retry the operation."
                                                      @"  With %@ quit, %@ will use our efficient and robust \"Direct\" method."
                                                      @"  (If %@ launches %@, click the '?' button to learn how to prevent that.)", nil),
                                [self.clientoid displayNameWithoutProfile],
                                [self.clientoid displayNameWithoutProfile],
                                [[BkmxBasis sharedBasis] appNameLocalized],
                                [[BkmxBasis sharedBasis] appNameLocalized],
                                [self.clientoid displayNameWithoutProfile]
        ];
        error = [error errorByAddingLocalizedRecoverySuggestion:suggestion];
    }
    [self setError:error];
}

- (void)timedOutExportFeedbackTimer:(NSTimer*)timer {
    // Create and set error
    NSString* desc = [NSString stringWithFormat:
                      @"%@ did not send new identifiers as expected after we exported to it.",
                      self.clientoid.displayName] ;
    NSError* error = SSYMakeError(constBkmxErrorTimedOutGettingExidsFromClient, desc) ;
    
    SSYOperation* operation = [[[timer userInfo] retain] autorelease] ;
    NSDictionary* timeoutInfo = [[operation info] objectForKey:constKeyTimeoutForExidsInfo] ;
    error = [error errorByAddingUserInfoObject:timeoutInfo
                                        forKey:@"Timeout Info"] ;
    error = [error errorByAddingUserInfoObject:@YES
                                        forKey:constKeyDontPauseSyncing];
    [self addHoggingAdviceAndRegisterError:error];
    
    [self forgetTimeoutter] ;
    [operation writeAndDeleteDidSucceed:NO] ;
}

- (void)timedOutImportTimer:(NSTimer*)timer {
    [self unleaseInterappServer];
    
    NSString* desc = [NSString stringWithFormat:
                      @"Timed out waiting for bookmarks import from %@",
                      self.clientoid.displayName] ;
    NSError* error = SSYMakeError(constBkmxErrorImportTimedOut, desc);
    error = [error errorByAddingUserInfoObject:@YES
                                        forKey:constKeyDontPauseSyncing];
    
    [self addHoggingAdviceAndRegisterError:error];
    
    if (self.readExternalCompletionHandler) {
        self.readExternalCompletionHandler();
        NSString* msg = [NSString stringWithFormat:@"Timed out waiting on import from %@", self.displayName];
        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                    logFormat:msg];
        self.readExternalCompletionHandler = nil;
    }
}

- (BOOL)makeStarksFromJsonString:(NSString*)jsonString
                         error_p:(NSError**)error_p {
    BOOL ok = YES ;
    NSError* error = nil ;
    
    NSDictionary* tree = [NSDictionary dictionaryWithJSONString:jsonString
                                                     accurately:NO] ;
    if (!tree) {
        NSString* msg = [NSString stringWithFormat:
                         @"Could not decode JSON data from %@",
                         self.clientoid.displayName] ;
        error = SSYMakeError(564205, msg) ;
        error = [error errorByAddingUserInfoObject:jsonString
                                            forKey:@"Undecodeable String"] ;
        ok = NO ;
    }
    
    if (ok) {
#if DEBUG_WRITE_IMPORTED_URLS_TO_FILES
        [self beginSSYLinearFileWriter] ;
#endif
        ok = [self makeStarksFromExtoreTree:tree
                                    error_p:&error] ;
#if DEBUG_WRITE_IMPORTED_URLS_TO_FILES
        [self closeSSYLinearFileWriter] ;
#endif
        if (!ok) {
            // This, or Error 290041, may occur if Firefox has the "empty Library" corruption.
            error = [SSYMakeError(594520, @"Could not decode bookmarks data") errorByAddingUnderlyingError:error] ;
        }
    }
    
    if (!ok && error_p) {
        *error_p = error ;
    }
    
    return ok ;
}

- (void)processExidFeedbackString:(NSString *)jsonText {
    NSDictionary* feedbacks = [NSDictionary dictionaryWithJSONString:jsonText
                                                          accurately:NO] ;
    
    /* Task 1 of 2.  Write the feedback to a file, for reading soon by
     TriggHandler to prevent some false triggers; or, remove the old file. */
    
    // Compute path for writing, or deleting, …BookMacster/Changes/ExidFeedback/Whatever
    NSString* appSupportPath = [[NSBundle mainAppBundle] applicationSupportPathForMotherApp] ;
    NSString* path = [appSupportPath stringByAppendingPathComponent:@"Changes"] ;
    path = [path stringByAppendingPathComponent:@"ExidFeedback"] ;
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL] ;
    path = [path stringByAppendingPathComponent:[self localIdentifier]] ;
    path = [path stringByAppendingPathExtension:@"json"] ;
    if (feedbacks) {
        [jsonText writeToFile:path
                   atomically:YES
                     encoding:NSUTF8StringEncoding
                        error:NULL] ;
    }
    else {
        // Remove old feedback file, if any
        [[NSFileManager defaultManager] removeItemAtPath:path
                                                   error:NULL] ;
    }
    
    /* Task 2.  Do actual work of swapping the exids.  */
    
    if (feedbacks) {
        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                    logFormat:@"Export succeeded, got exids"];
        
        Clientoid* clientoid = self.clientoid ;
        for (Stark* stark in [[self starker] allStarks]) {
            //if (![self isHartainer]) {
            NSString* currentExid = [stark exidForClientoid:clientoid] ;
            NSString* correctExid = [feedbacks objectForKey:currentExid] ;
            
            // This is kind of tricky.  Note that we correct the exid of the stark
            // in the Extore, not the exid of its mateInBkmxDoc, even though the
            // stark in the extore will soon be destroyed and the mateInBkmxDoc is
            // the one that needs the exid.  This is because, in
            // feedbackPostWrite, the exid that we set here will be copied
            // over to its mateInBkmxDoc, as ultimately desired.
            // (If we did copy it to the mateInBkmxDoc here, then when
            // feedbackPostWrite ran, it would see that the one in the
            // extore had a bad exid, create a spurious new one, and copy this
            // spurious one to its mateInBkmxDoc.
            
            if (correctExid) {
                if (![correctExid isEqualToString:currentExid]) {
                    // The following 'if' should not be needed but is defensive programming
                    // because I hate "Core Data could not fulfill a fault…" errors
                    if (![stark isDeleted]) {
                        // We first check to see if there has been any change, to avoid
                        // unnecessarily dirtying the dot
                        [stark setExid:correctExid
                          forClientoid:clientoid] ;
                    }
                }
            }
        }
    }
    else {
        /* Firefox Extension sends an empty string if there is no exid
         feedback.  This is expected if the last export did not insert any
         new items. */
    }
}

- (void)interappServer:(SSYInterappServer*)server
  didReceiveHeaderByte:(char)headerByte
                  data:(NSData*)data {
    // Note: 'server' is the same 'interappServer' which we are about to forget.
    // So we need to get its info now.
    id userInfo = server.userInfo;
    SSYOperation* operation = [userInfo objectForKey:constKeyReadExternalOperation] ;
    ExtensionsMule* addonsManager = [userInfo objectForKey:constKeyReadExternalMule] ;
    
    NSError* error = nil ;
    BOOL ok = YES ;
    
    // Initialize versions to "not applicable" indication
    NSString* receivedProfile = nil ;
    
    if (headerByte == constInterappHeaderByteForProgress) {
        /* This is the only branch for which we do not do this:
         [self forgetTimeoutter] ;
         server.userInfo = nil;
         because after this branch there is more to come. */
        
        NSDictionary* progressNumbers = nil;
        if (data) {
            progressNumbers = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet jsonClasses]
                                                                  fromData:data
                                                                     error:&error];
            /* Since this is only a progress message, onl{y log any error to
             console. */
            if (error) {
                NSLog(@"Internal Error 822-9585: %@", error);
            }
        }
        NSInteger majorNum = [[progressNumbers objectForKey:constKeyProgressMajorNum] integerValue] ;
        NSInteger majorDen = [[progressNumbers objectForKey:constKeyProgressMajorDen] integerValue] ;
        NSInteger minorNum = [[progressNumbers objectForKey:constKeyProgressMinorNum] integerValue] ;
        NSInteger minorDen = [[progressNumbers objectForKey:constKeyProgressMinorDen] integerValue] ;
        
        // Patch for bug in Chrome extension version 21 and lower
        if (majorDen == 0) {
            majorDen = 3 ;
        }
        
        if (![self error]) {
            NSString* msg = [self msgWaitingForClientNum:majorNum
                                                     den:majorDen] ;
            SSYProgressView* progressView = [[[self bkmxDoc] progressView] setIndeterminate:NO
                                                                          withLocalizedVerb:msg
                                                                                   priority:SSYProgressPriorityRegular] ;
            [progressView setMaxValue:minorDen] ;
            [progressView setDoubleValue:minorNum] ;
            [progressView setEnabled:YES] ;
        }
    }
    else if (headerByte == constInterappHeaderByteForVersionCheck) {
        [self forgetTimeoutter] ;
        server.userInfo = nil;
        
        NSDictionary* info = nil;
        if (data) {
            info = [NSJSONSerialization JSONObjectWithData:data
                                                   options:0
                                                     error:&error] ;
        }
        if (error) {
            error = [SSYMakeError(EXTORE_ERROR_VERSION_NUMBERS_UNARCHIVE, @"Could not deserialize version numbers received from browser extension") errorByAddingUnderlyingError:error];
        }
        
        if (!error) {
            if (!info) {
                error = SSYMakeError(EXTORE_ERROR_VERSION_NUMBERS_MISSING, @"Version numbers missing from data unarchived from browser extension");
            }
        }
        
        /*
         Case 1.  If only extension 1 version 39+ is installed, info will contain extension 1 name and  version.
         Case 2.  If only extension 2 version 27+ is installed, info will contain extension 2 name and version.
         Case 3.  If both extensions 1 and 2 are installed, versions 39+/27+, although two Chromessenger
         processes will be running, only the one connected to extension 1
         will have a ToClient SSYInterappServer running.  Therefore, info will
         contain extension 1 name and version.
         Case 4.  Installed extension versions are 38/26 or lower.  The extensionName in info will be nil, and
         extensionVersion may be of either extension */
        
        /*  To provide a answer for any case in which an extension version
         is not contained in `info`, we provide this default, which scrapes the
         version from information on the disk. */
        NSInteger extension1Version = [self extensionVersionForExtensionIndex:1];
        NSInteger extension2Version = [self extensionVersionForExtensionIndex:2];
        
        if (!error) {
            NSString* extensionName = [info objectForKey:constKeyExtensionName];
            NSNumber* versionNumber ;
            versionNumber = [info objectForKey:constKeyExtensionVersion] ;
            if (versionNumber) {
                NSInteger extensionVersion = [versionNumber integerValue];
                if ([extensionName isEqualToString:[self extensionDisplayNameForExtensionIndex:1]]) {
                    // Case 1 or 3
                    extension1Version = extensionVersion;
                } else if ([extensionName isEqualToString:[self extensionDisplayNameForExtensionIndex:2]]) {
                    // Case 2
                    extension2Version = extensionVersion;
                } else {
                    NSAssert1((extensionName == nil), @"Unknown extension name %@", extensionName);
                    // Case 4
                    if (extensionVersion > 26) {
                        extension1Version = extensionVersion;
                    } else {
                        extension1Version = extensionVersion;
                    }
                }
            }
            receivedProfile = [info objectForKey:constKeyProfileName] ;
            error = [self errorForExtension1Version:extension1Version
                                  extension2Version:extension2Version
                                    receivedProfile:receivedProfile] ;
        }
        
        // When reading the following code, remember that either one of
        // operation or addonsManager will be nil.
        
        if (error) {
            [self setError:error] ;
        }
        
        if (addonsManager) {
            NSDictionary* result = [self processedExtension1Version:extension1Version
                                                  extension2Version:extension2Version
                                                    receivedProfile:receivedProfile
                                                              error:error] ;
            [addonsManager extore:self
                       testResult:result] ;
        }
        
    }
    else if (headerByte == constInterappHeaderByteForBookmarksTree) {
        @autoreleasepool {
            [self forgetTimeoutter] ;
            server.userInfo = nil;
            
            NSString* jsonText = nil;
            if (data) {
                jsonText = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet jsonClasses]
                                                               fromData:data
                                                                  error:&error];
            }
            
            if (error) {
                ok = NO;
                error = [SSYMakeError(205292, @"Failed to unarchive bookmarks tree") errorByAddingUnderlyingError:error];
            } else {
                if ([[BkmxBasis sharedBasis] traceLevel] >= 5) {
                    NSError* unlikelyError = nil;
                    NSString* path = [[NSFileManager defaultManager] ensureDesktopDirectoryNamed:@"Bkmx-Trees-From-Clients"
                                                                                         error_p:&unlikelyError];
                    if (unlikelyError) {
                        NSLog(@"Internal Error 523-4355 No JSON tree: %@", unlikelyError);
                    } else {
                        NSString* filename = [NSString stringWithFormat:
                                              @"Tree-From-%@-%@",
                                              self.clientoid.displayName,
                                              [[NSDate date] compactDateTimeString]] ;
                        filename = [filename stringByAppendingPathExtension:@"json"] ;
                        path = [path stringByAppendingPathComponent:filename];
                        [jsonText writeToFile:path
                                   atomically:NO
                                     encoding:NSUTF8StringEncoding
                                        error:&unlikelyError];
                        if (unlikelyError) {
                            NSLog(@"Internal Error 523-4366 No write file: %@", unlikelyError);
                        }
                    }
                }
                
                if (!jsonText) {
                    error = SSYMakeError(515609, @"Failed to unarchive imported bookmarks") ;
                    ok = NO ;
                }
                else {
                    ok = [self makeStarksFromJsonString:jsonText
                                                error_p:&error] ;
                }
            }
            
            if (!ok) {
                [self setError:error] ;
            }
            
            if (self.readExternalCompletionHandler) {
                self.readExternalCompletionHandler();
                self.readExternalCompletionHandler = nil;
            }
        }
    }
    else if (headerByte == constInterappHeaderByteForExportFeedback) {
        [self forgetTimeoutter] ;
        server.userInfo = nil;
        
        NSString* jsonText = nil;
        if (data) {
            jsonText = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet jsonClasses]
                                                           fromData:data
                                                              error:&error] ;
            if (error) {
                ok = NO;
                error = [SSYMakeError(260859, @"Failed to unarchive exid feedback") errorByAddingUnderlyingError:error];
                [self setError:error] ;
            } else {
                if ([NSThread isMainThread]) {
                    [self processExidFeedbackString:jsonText];
                } else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self processExidFeedbackString:jsonText];
                    });
                }
            }
        }
        
        [operation writeAndDeleteDidSucceed:ok] ;
    }
    else if (headerByte == constInterappHeaderByteForErrors) {
        NSArray* errorInfos = nil;
        if (data) {
            errorInfos = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                           error:&error];
            if (error) {
                NSString* desc = [NSString stringWithFormat:
                                  @"An error occured in our extension in %@, but we could not decode it.",
                                  [self displayName]];
                error = [SSYMakeError(260860, desc) errorByAddingUnderlyingError:error];
                [self setError:error] ;
            } else {
                NSSet* fatalErrorCodes = [NSSet setWithObjects:
                                          @633892,
                                          @633893,
                                          nil];
                NSMutableArray* fatalErrors = [NSMutableArray new];
                for (NSDictionary* errorInfo in errorInfos) {
                    NSNumber* code = [errorInfo objectForKey:@"errorCode"];
                    if ([fatalErrorCodes member:code]) {
                        NSError* fatalError = SSYMakeError(code.integerValue,
                                                           [errorInfo objectForKey:@"errorDescription"]);
                        [fatalErrors addObject:fatalError];
                    }
                }
                
                if (fatalErrors.count > 0) {
                    NSString* description;
                    if (fatalErrors.count > 1) {
                        description = [NSString stringWithFormat:
                                       @"Our browser extension encountered %ld fatal error(s) while operating in %@.  The first such error is the \"underlying error\" given herein.",
                                       fatalErrors.count,
                                       self.ownerAppDisplayName];
                    } else {
                        description = [NSString stringWithFormat:
                                       @"Our browser extension encountered one fatal error while operating in %@.",
                                       self.ownerAppDisplayName];
                    }
                    error = SSYMakeError(260748, description);
                    error = [error errorByAddingUserInfoObject:fatalErrors
                                                        forKey:@"Fatal Errors"];
                    error = [error errorByAddingUnderlyingError:[fatalErrors firstObject]];
                    [self setError:error] ;
                }
                [fatalErrors release];
            }
        }
    }
    else {
        [self forgetTimeoutter] ;
        server.userInfo = nil;
        
        NSLog(@"Warning.  Interapp server received message with unknown header byte '%c'", headerByte) ;
    }
    
    /* A response will be sent to the client immediately upon the
     return of this method.  See SSYInterappServerCallBackCreateData() in
     SSYInterappServer.m.  */
}

- (char)responseHeaderByte {
    return 0 ;
}

- (NSData*)responsePayload {
    return nil ;
}

+ (NSString*)keyLastPostsAll {
    return @"LPA" ;
}

- (NSString*)keyLastPostsAll {
    return [[self class] keyLastPostsAll] ;
}

- (NSTimeInterval)exportFeedbackTimeoutPerChange {
    NSLog(@"Warning 612-0194 Need override %s for %@", __PRETTY_FUNCTION__, [self className]) ;
    return CGFLOAT_MAX ;
}

- (NSUInteger)slowExportThreshold {
    return NSIntegerMax ;
}

- (SSYAlert*)warnSlowAlertProposed:(NSUInteger)proposed
                         threshold:(NSUInteger)threshold {
    return nil ;
}

- (NSString*)warnSlowFormatString {
    NSString* answer ;
    NSString* displayName = self.clientoid.displayName ;
    if (displayName) {
        answer = [NSString stringWithFormat:
                  @"%@ will take too long to swallow %\%ld changes.",
                  displayName] ;
    }
    else {
        answer = nil ;
    }
    
    return answer ;
}

+ (NSString*)syncSnapshotsMotherPath {
    // Fancy way of getting ~/Library/Application Support/BookMacster/SyncSnapshots
    NSString* motherPath = [[[NSBundle mainAppBundle] applicationSupportPathForMotherApp] stringByAppendingPathComponent:@"SyncSnapshots"] ;
    return motherPath ;
}


/*!
 @brief    Returns the full path to the sync snapshots subdirectory for the receiver,
 creating one if it does not exist
 */
- (NSString*)prepareSyncSnapshotsPath {
    NSFileManager* fm = [NSFileManager defaultManager] ;
    NSError* error = nil ;
    BOOL ok ;
    
    NSString* motherPath = [[self class] syncSnapshotsMotherPath] ;
    NSInteger syncSnapshotsLimitMB = [[NSUserDefaults standardUserDefaults] syncSnapshotsLimitMB] ;
    
    if (syncSnapshotsLimitMB > 0) {
        ok = [fm ensureDirectoryAtPath:motherPath
                               error_p:&error] ;
        if (!ok) {
            NSLog(@"Internal Error 513-1149 %@", error) ;
        }
    }
    
    // Now append the clidentifier
    NSString* path = [motherPath stringByAppendingPathComponent:[self.clientoid clidentifier]] ;
    if (syncSnapshotsLimitMB > 0) {
        ok = [fm ensureDirectoryAtPath:path
                               error_p:&error] ;
        if (!ok) {
            NSLog(@"Internal Error 248-0938 %@", error) ;
        }
    }
    
    return path ;
}

+ (NSDateFormatter*)dateFormatterForSnapshots {
    if (!static_snapshotDateFormatter) {
        static_snapshotDateFormatter = [[NSDateFormatter alloc] init] ;
        // Colons cannot be used because this will be part of a filename…
        [static_snapshotDateFormatter setDateFormat:@"yyyyMMdd-HHmmss"] ;
    }
    
    return static_snapshotDateFormatter ;
}


- (NSInteger)countOfRecentSnapshotsAvailable {
    NSString* motherPath = [[self class] syncSnapshotsMotherPath] ;
    NSString* path = [motherPath stringByAppendingPathComponent:[self.clientoid clidentifier]] ;
    NSError* error = nil ;
    NSArray* filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                             error:&error] ;
    if (error) {
        NSLog(@"Internal Error 622-9408 %@", error) ;
    }
    
    NSUInteger count = 0 ;
    for (NSString* filename in filenames) {
        NSUInteger dateLength = [[[[self class] dateFormatterForSnapshots] dateFormat] length] ;
        if ([filename length] >= dateLength) {
            NSString* dateString = [filename substringToIndex:dateLength] ;
            NSDate* date = [[[self class] dateFormatterForSnapshots] dateFromString:dateString] ;
            /* We could also check file modification date, but this method is
             probably faster, given that we only create the (static) date
             formatter once.  Also, it provides a level of filtering out other
             files that may happen to have found their way into our
             SyncSnapshots subfolder. */
            if (date) {
                NSTimeInterval age = -[date timeIntervalSinceNow] ;
                if (age < 3600) {
                    // Was made within the last hour
                    count++ ;
                }
            }
        }
    }
    
    return count ;
}

+ (void)iterateSnapshotsOnDiskWith:(void (^)(NSString* path, NSDictionary* attributes, NSError* error))snapshotHandler {
    NSError* error = nil;
    NSString* motherPath = [self syncSnapshotsMotherPath];
    NSArray* extoreDirNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:motherPath
                                                                                  error:&error];
    /* Do not report the error since this is not important, and, also, on the
     first application run, indeed error will be NSCocoaErrorDomain Code=260
     "The folder “SyncSnapshots” doesn’t exist", with NSUnderlyingError :
     "The operation couldn’t be completed. (OSStatus error -43.) */
    
    if (!error) {
        for (NSString* extoreDirName in extoreDirNames) {
            /* The following two "if" tests
             prevent us from passing .DS_Store which would cause logging of
             Internal Error 624-9458 in cleanExcessSyncSnapshotsInPath::.
             Why did I never notice this before yesterday???
             */
            NSString* extoreDirPath = [motherPath stringByAppendingPathComponent:extoreDirName] ;
            BOOL isDirectory = NO ;
            if ([[NSFileManager defaultManager] fileExistsAtPath:extoreDirPath
                                                     isDirectory:&isDirectory]) {
                if (isDirectory) {
                    NSArray* snapshotFileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:extoreDirPath
                                                                                                     error:&error];
                    if (!error) {
                        for (NSString* snapshotFilename in snapshotFileNames) {
                            NSString* snapshotPath = [extoreDirPath stringByAppendingPathComponent:snapshotFilename];
                            NSDictionary* attributes  = [[NSFileManager defaultManager] attributesOfItemAtPath:snapshotPath
                                                                                                         error:&error];
                            if (error) {
                                snapshotHandler(snapshotPath, attributes, error);
                                break;
                            } else if (attributes) {
                                snapshotHandler(snapshotPath, attributes, nil);
                            }
                        }
                    }
                }
            }
        }
    }
}

+ (void)cleanExcessSyncSnapshots {
    __block NSError* error = nil;
    
    /* Build array snapshotMetadatas, which will give size, modification time,
     and path for all snapshots now on disk.  Also calculate total size of
     all. */
    NSMutableArray* snapshotMetadatas = [NSMutableArray new];
    __block NSInteger totalSize = 0;
    [self iterateSnapshotsOnDiskWith:^(NSString *path, NSDictionary *attributes, NSError* blockError) {
        if (blockError) {
            error = blockError;
        } else {
            SnapshotFileMetadata* metadata = [SnapshotFileMetadata new];
            metadata.path = path;
            metadata.modificationDateTimeInterval = attributes.fileModificationDate.timeIntervalSinceReferenceDate;
            metadata.size = attributes.fileSize;
            [snapshotMetadatas addObject:metadata];
            totalSize += [attributes fileSize];
            [metadata release];
        }
    }];
    
    // Convert bytes to MB, rounding up
    if (totalSize > 0) {
        totalSize++;
    }
    totalSize /= 1000000;
    
    NSInteger limit = [[NSUserDefaults standardUserDefaults] syncSnapshotsLimitMB];
    NSInteger needsRemoveMB = totalSize - limit;
    NSString* suffix = (needsRemoveMB > 0) ? [NSString stringWithFormat:@" Must remove %ld MB", needsRemoveMB] : @"Moving on.";
    NSString* msg = [NSString stringWithFormat:
                     @"Snapshots: Found %ld, total %ld MB, %ld MB allowed \u279e %@",
                     snapshotMetadatas.count,
                     totalSize,
                     limit,
                     suffix];
    [[BkmxBasis sharedBasis] logString:msg];
    if (!error) {
        if (needsRemoveMB > 0) {
            NSSortDescriptor* descriptor1 = [[NSSortDescriptor alloc] initWithKey:@"modificationDateTimeInterval"
                                                                        ascending:YES] ;
            NSArray* descriptors = [NSArray arrayWithObjects:descriptor1, nil] ;
            [descriptor1 release] ;
            [snapshotMetadatas sortUsingDescriptors:descriptors];
            NSString* uselessSuffix = @"|thisUser|||";
            NSInteger suffixLength = uselessSuffix.length;
            for (SnapshotFileMetadata* metadata in snapshotMetadatas) {
                [[NSFileManager defaultManager] removeItemAtPath:metadata.path
                                                           error:&error];
                NSString* browserProfileName = metadata.path.lastPathComponent.lastPathComponent;
                if ([browserProfileName hasSuffix:uselessSuffix]) {
                    browserProfileName = [browserProfileName substringToIndex:(browserProfileName.length - suffixLength)];
                }
                if (!error) {
                    [[BkmxBasis sharedBasis] logFormat:
                     @"Deleted %@ snapshot %@",
                     browserProfileName,
                     metadata.path.lastPathComponent];
                }
                
                /* `error` is expected here in the edge case where Agent and
                 main app are both deleting files – a file could have been
                 deleted by another process since its metadata was added to
                 snapshotMetadatas.
                 
                 But in that edge case, it would be gone from the total, so
                 we still subtracts its size.  */
                needsRemoveMB -= metadata.size/1000000;
                
                if (needsRemoveMB <=0) {
                    break;
                }
            }
        }
    }
    
    [snapshotMetadatas release];
}

#define DESIRED_HEADROOM_MEGABYTES 20
+ (void)ensureSpaceForMoreSyncSnapshots {
    __block NSError* error = nil;
    __block NSInteger totalSize = 0;
    [self iterateSnapshotsOnDiskWith:^(NSString *path, NSDictionary *attributes, NSError* blockError) {
        if (blockError) {
            error = blockError;
            
        } else {
            totalSize += [attributes fileSize];
        }
    }];
    
    // Convert bytes to MB, rounding up
    if (totalSize > 0) {
        totalSize++;
    }
    totalSize /= 1000000;
    
    if (error) {
        [[BkmxBasis sharedBasis] logError:error
                          markAsPresented:NO];
    } else {
        NSInteger limit = [[NSUserDefaults standardUserDefaults] syncSnapshotsLimitMB];
        if (limit - totalSize < DESIRED_HEADROOM_MEGABYTES) {
            [[NSUserDefaults standardUserDefaults] setSyncSnapshotsLimitMB:(totalSize + DESIRED_HEADROOM_MEGABYTES)];
        }
    }
}

- (NSString*)prepareNextSnapshotPathWithLabel:(NSString*)label {
    NSString* answer = nil ;
    
    if ([[NSUserDefaults standardUserDefaults] syncSnapshotsLimitMB] > 0) {
        NSString* dirPath = [self prepareSyncSnapshotsPath] ;
        
        NSString* filename = [[[self class] dateFormatterForSnapshots] stringFromDate:[NSDate date]] ;
        filename = [filename stringByAppendingString:label] ;
        
        NSString* filenameEnding = nil ;
        if ([self ownerAppIsLocalApp]) {
            filenameEnding = [[self class] defaultFilename] ;
        }
        else {
            filenameEnding = WEBDATA_FILE_EXTENSION ;
        }
        
        if (filenameEnding) {
            filename = [filename stringByAppendingString:@"-"];
            /* In previous versions, I used a dot "." instead of a dash "-".
             That caused restoring a Chromy file from a Sync Snapshot using
             Import From > Choose File (Advanced) to fail for a Chromy
             file because the file browser only enables files whose names have
             no extension, like Chrome's "Bookmarks" file.  But when we used
             a dot and got a name like "20180403-212110PreEx.Bookmarks", the
             system interpreted that to have extension "Bookmarks", and
             therefore not enable it to be opened. */
            filename = [filename stringByAppendingString:filenameEnding];
        }
        
        answer = [dirPath stringByAppendingPathComponent:filename] ;
    }
    
    return answer ;
}

- (void)doBackupLabel:(NSString*)label {
    if (![self ownerAppIsLocalApp]) {
        return ;
    }
    
    if (![[self.clientoid extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
        return ;
    }
    
    BOOL ok = YES ;
    NSError* error = nil ;
    
    NSString* sourcePath = [self filePathError_p:&error] ;
    if (error) {
        NSLog(@"Internal Error 624-2274 %@", error) ;
    }
    if (!sourcePath) {
        return ;
    }
    
    NSString* snapshotPath = [self prepareNextSnapshotPathWithLabel:label] ;
    error = nil ;
    if (snapshotPath) {
        ok = [[NSFileManager defaultManager] copyItemAtPath:sourcePath
                                                     toPath:snapshotPath
                                                      error:&error] ;
        if (!ok) {
            NSLog(@"Internal Error 624-2581 trying to copy:\n%@\nto:\n%@\nError:\n%@",
                  sourcePath,
                  snapshotPath,
                  error) ;
        }
        else {
            // The following, copying attributes, was added in BookMacster 1.13.1
            // However, in BookMacster 1.14.4, I changed it to only copy the
            // file modification date instead of all attributes.  The reason is that
            // I was getting Internal Error 624-2583 inexplicably when after
            // configuring with my ReproUserTrouble ApplesScript.  If I eliminated
            // 0-3 attributes, it would work, but there was no pattern as to which
            // 0-3 attributes needed to be eliminated.  So I just gave up and took
            // the one which I needed most.
            NSDate* modificationDate = [[NSFileManager defaultManager] modificationDateForPath:sourcePath] ;
            if (!modificationDate) {
                NSLog(@"Internal Error 624-2582, got mod date %@\nfor path:\n%@",
                      modificationDate,
                      error) ;
            }
            else {
                error = nil ;
                NSDictionary* attributes = [NSDictionary dictionaryWithObject:modificationDate
                                                                       forKey:NSFileModificationDate] ;
                ok = [[NSFileManager defaultManager] setAttributes:attributes
                                                      ofItemAtPath:snapshotPath
                                                             error:&error] ;
                if (!ok) {
                    NSLog(@"Internal Error 624-2582 trying to set attributes:\n%@\nof path:\n%@\nError:\n%@",
                          attributes,
                          snapshotPath,
                          error) ;
                }
            }
        }
    }
}

- (BOOL)profileIsLoadedIfOwnerAppRunningError_p:(NSError**)error_p {
    return YES ;
}

- (uint32_t)importHashBottom {
    uint32_t compositeSettingsHash = [[NSUserDefaults standardUserDefaults] compositeImportSettingsHashForClientoid:self.clientoid] ;
    uint32_t contentHash = [self contentHash] ;
    uint32_t newHashBottom = contentHash ^ compositeSettingsHash ;
    
    return newHashBottom ;
}

- (BOOL)isSyncActiveError_p:(NSError**)error_p {
    return NO ;
}

- (NSString*)ownerAppSyncServiceDisplayName {
    return @"NO-SERVICE" ;
}

- (NSTimeInterval)waitTimeForBuiltInSyncAfterLaunch {
    return 0.0 ;
}

- (BOOL)launchOwnerAppMomentarilyForBuiltInSyncIfNotRunningInfo:(NSMutableDictionary*)info
                                                        error_p:(NSError **)error_p {
    NSError* error = nil ;
    OwnerAppRunningState runningState = [self ownerAppRunningStateError_p:&error] ;
    BOOL ok = YES ;
    switch (runningState) {
        case OwnerAppRunningStateNotRunning:
            [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                        logFormat:@"Will launch %@ now", [self displayName]] ;
            NSString* launchedPath = [self launchOwnerAppPath:nil
                                                     activate:NO
                                                      error_p:&error] ;
            ok = (launchedPath != nil) ;
            if (ok) {
                [self updateOwnerAppQuinchState:OwnerAppQuinchStateDidLaunch] ;
                NSMutableDictionary* browserPathsLaunched = [info objectForKey:constKeyBrowserPathsLaunched] ;
                if (!browserPathsLaunched) {
                    browserPathsLaunched = [[NSMutableDictionary alloc] init] ;
                    [info setObject:browserPathsLaunched
                             forKey:constKeyBrowserPathsLaunched] ;
                    [browserPathsLaunched release] ;
                }
                [browserPathsLaunched setObject:launchedPath
                                         forKey:[self.clientoid clidentifier]] ;
                usleep(TIME_FOR_APP_TO_STABILIZE*1e6) ;
                
                BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument] ;
                
                NSTimeInterval waitTime = [self waitTimeForBuiltInSyncAfterLaunch] ;
                if (waitTime > 0) {
                    // Note: In BkmxAgent, progressView will be nil.
                    NSString* whatDoing = [NSString stringWithFormat:
                                           @"Waiting in case %@ has any changes for %@.",
                                           [self ownerAppSyncServiceDisplayName],
                                           self.clientoid.displayName] ;
                    /* For some strange reason, if you make the progress bar
                     determinate OR set a doubleValue or maxValue, there is
                     no visible change in the SSYProgressView.  It remains at
                     with text = "Pulling file xxx" and bar indeterminate. */
                    [[bkmxDoc progressView] setIndeterminate:YES
                                           withLocalizedVerb:whatDoing
                                                    priority:SSYProgressPriorityRegular] ;
                    NSInteger waitSeconds = ceil(waitTime) ;
                    for (NSInteger i=0; i<waitSeconds; ) {
                        sleep(1) ;
                        i++ ;
                    }
                }
            }
            else {
                [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                            logFormat:@"Failed launching %@", [self displayName]] ;
                NSString* msg = [NSString stringWithFormat:
                                 @"Needed to launch %@, but could not launch %@.",
                                 [self ownerAppDisplayName],
                                 [self ownerAppDisplayName],
                                 nil] ;
                error = [SSYMakeError(502938, msg) errorByAddingUnderlyingError:error] ;
            }
            break ;
        case OwnerAppRunningStateRunningProfileNotLoaded:
            // In this case, the export will fail and Chrome will need
            // to be quit and relaunched
        case OwnerAppRunningStateRunningProfileAvailable:
            break ;
        case OwnerAppRunningStateRunningProfileWrongOne:
            NSLog(@"Internal Error 125-9894 %@", self) ;
            break ;
        case OwnerAppRunningStateError:
            ok = NO ;
            break ;
    }
    
    if (error && error_p) {
        *error_p = error ;
    }
    
    return ok ;
}

#if 0
/*!
 @details  I had planned to use this `recentQuits` idea to cause style 1 to be
 forced, and thus browser launching to be skipped, regardless of
 launchBrowserPref, if an operation was being performed due to browser quit.
 (This feature is needed for Firefox because of its new dual-style as of
 BkmkMgrs 2.3.)  The idea is to have the Quatch record when the browser quit
 in User Defaults, and then have the operation check if a quit was "recent".
 However, by the time that the last check was done (for writing), with just
 a few bookmarks, it was 4.5 seconds.  So, I'm not sure there is a reliable
 "recent" threshold.
 
 To solve this problem, I used the constKeyForceStyle1ForClient key
 instead.  This here method is not used at this time.
 */
- (BOOL)didBrowserJustQuitRecently {
    for (NSString* bundleIdentifier in [[self class] browserBundleIdentifiers]) {
        NSDate* quitDate = [[NSUserDefaults standardUserDefaults] recentQuitForAppIdentifier:bundleIdentifier];
        if (quitDate) {
            NSTimeInterval secondsSinceQuit = -[quitDate timeIntervalSinceNow];
            [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                        logFormat:
             @"%g secs since %@ quit",
             secondsSinceQuit,
             bundleIdentifier] ;
            if (secondsSinceQuit < 10.0) {
                return YES;
            }
        }
    }
    
    return NO;
}
#endif

- (BOOL)launchOwnerAppIfNecessaryForPolarity:(NSInteger)ixpolarity
                                        info:(NSMutableDictionary*)info
                                     error_p:(NSError**)error_p {
    BOOL ok = YES ;
    NSError* error = nil ;
    
    if (self.ixportStyle == 2) {
        BkmxIxportLaunchBrowserPreference launchBrowserPref = [self launchBrowserPreference] ;
        /* If launchBrowserPref is BkmxIxportLaunchBrowserPreferenceAlways, the
         style was earlier forced to 2.  So we will be here.  Furthermore, the
         following if() will pass also. */
        if (launchBrowserPref != BkmxIxportLaunchBrowserPreferenceNever) {
            /* This method runs twice during an export.  The first time,
             we want to launch the browser momentarily for built-in syncing
             to run.  The second time, we want to skip that.  We recognize
             the second time by the presence of constKeyDidReadExternal in the
             info dictionary. */
            BOOL firstTime = [[info objectForKey:constKeyDidReadExternal] boolValue] == NO ;
            if (firstTime) {
                ok = [self launchOwnerAppMomentarilyForBuiltInSyncIfNotRunningInfo:info
                                                                           error_p:&error] ;
                error = [SSYMakeError(292114, @"") errorByAddingUnderlyingError:error] ;
            }
        }
    }
    
    if (error && error_p) {
        *error_p = error ;
    }
    
    return ok ;
}

- (void)unsafeLaunchBrowserPrefInfo:(NSMutableDictionary*)info {
    Client* client = [info objectForKey:constKeyClient] ;
    NSInteger launchBrowserPref = [client launchBrowserPref] ;
    NSNumber* answer = [NSNumber numberWithInteger:launchBrowserPref] ;
    [info setObject:answer
             forKey:constKeyLaunchBrowserPref] ;
}

- (BkmxIxportLaunchBrowserPreference)launchBrowserPreference {
    Client* targetClient = [self client] ;
    
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 targetClient, constKeyClient,
                                 nil] ;
    [self performSelectorOnMainThread:@selector(unsafeLaunchBrowserPrefInfo:)
                           withObject:info
                        waitUntilDone:YES] ;
    BkmxIxportLaunchBrowserPreference answer = (BkmxIxportLaunchBrowserPreference)[[info objectForKey:constKeyLaunchBrowserPref] integerValue] ;
    
    return answer ;
}

+ (BOOL)profileStuffMayBeInstalledInParentFolder {
    return NO;
}

+ (BOOL)style1Available {
    return YES;
}

- (BOOL)style1Available {
    return [[self class] style1Available];
}

/*                                                                 Answer:
 Extension             Launch    Browser    Browser                should laumch
 Supports    Extore    Browser   Already    Sync        Answer:    Owner App if
 Purpose     Media     Pref      Running    Active   |  Style      Not Running
 -------     --------  -------   -------    ------   -  -------    -------------
 .  0          X         X          X         X      |    1        NO
 .  X       !thisUser    X          X         X      |    1        NO
 .  1        thisUser   Always      X         X      |    2        YES
 .  X          X        Never    !ProfAv      X      |    1        NO
 .  X          X        Auto     !ProfAv      0      |    1        NO
 .  1        thisUser   Never     ProfAv      X      |    2        NO
 .  1        thisUser   Auto      ProfAv      X      |    2
 */
- (NSInteger)readOrWriteStyleForPurpose:(NSInteger)purpose
                                error_p:(NSError**)error_p {
    NSInteger style ;
    NSError* error = nil ;
    
    if (![self syncExtensionAvailable]) {
        style = 1 ;
    }
    else if (!([self addonSupportsPurpose:constExtensibilityImport])) {
        style = 1 ;
    }
    else if (![self.clientoid.extoreMedia isEqualToString:constBkmxExtoreMediaThisUser]) {
        style = 1 ;
    }
    else if (![self style1Available]) {
        style = 2;
    }
    else {
        BkmxIxportLaunchBrowserPreference launchBrowserPref = [self launchBrowserPreference] ;
        if (launchBrowserPref == BkmxIxportLaunchBrowserPreferenceAlways) {
            style = 2 ;
        }
        else {
            /* Both styles 1 and 2 are possible.  Which one we chooose depends
             on whether or not the browser is running, and whether or not
             browser's proprietary sync is active and requires Style 2. */
            OwnerAppRunningState runningState = [self ownerAppRunningStateError_p:&error] ;
            switch (runningState) {
                case OwnerAppRunningStateError:
                    error = [SSYMakeError(194939, @"Could not determine whether or not browser was running") errorByAddingUnderlyingError:error] ;
                    /* Assume worst case */
                    style = 2;
                    break;
                case OwnerAppRunningStateRunningProfileAvailable:
                    style = 2 ;
                    break ;
                case OwnerAppRunningStateNotRunning:
                case OwnerAppRunningStateRunningProfileWrongOne:
                case OwnerAppRunningStateRunningProfileNotLoaded:
                default:;
                    /* Browser is not running, or is not running in the
                     required profile.  Use Style 1 unless Style 2 (with
                     browser launch or relaunch is required due to
                     browser's proprietary syncing. */
                    BOOL syncIsActive = [self isSyncActiveError_p:&error] ;
                    if (error) {
                        error = [SSYMakeError(194982, @"Assuming browser's built-in sync is active cuz could not determine") errorByAddingUnderlyingError:error] ;
                        /* Assume worst case */
                        syncIsActive = YES;
                    }

                    BOOL style2Required = (syncIsActive && [[self class] requiresStyle2WhenProprietarySyncIsActive]);
                    if (style2Required) {
                        style = 2 ;
                        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                    logFormat:
                         @"%@ is active -> ixport style 2",
                         [self ownerAppSyncServiceDisplayName]] ;
                    } else {
                        style = 1;
                    }
                    break ;
            }
        }
    }

    return style ;
}

- (BOOL)determineYourIxportStyleError_p:(NSError**)error_p {
    NSError* error = nil ;
    NSInteger style = 0 ;

    style = [self readOrWriteStyleForPurpose:constExtensibilityExport
                                     error_p:&error] ;
    if (error) {
        error = [SSYMakeError(252905, @"Could not determine write style") errorByAddingUnderlyingError:error] ;
        goto end ;
    }
    
    /* We want the greater of the two styles.  If we got 2 for write style,
    we're done. If we got 1, check the read style */
    if (style == 1) {
        style = [self readOrWriteStyleForPurpose:constExtensibilityImport
                                         error_p:&error] ;
        if (error) {
            error = [SSYMakeError(252906, @"Could not determine read style") errorByAddingUnderlyingError:error] ;
            goto end ;
        }
    }
	
    /* If sync extension not installed, overwrite ixport style to 1. */
    if (!error) {
        if ([self needsExtension1InstallError_p:&error]) {
            if ([[self class] style1Available]) {
                [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                            logFormat:@"UhOh! No ext1 in %@ -> style 1", [self displayName]] ;
                style = 1 ;
            } else {
                NSString* desc = [NSString stringWithFormat:
                                 @"Our BookMacster Sync extension is required to access %@ bookmarks.  But it is not installed.",
                                 [self ownerAppDisplayName]];
                error = SSYMakeError(252907, desc);
                NSString* sugg = [NSString stringWithFormat:
                                  @"Click in the main menu:\n   %@ > Manage Browser Extensions.\n In the window that opens, in the upper \'Sync\" section, \"Install\" for \"%@\".",
                                  [[BkmxBasis sharedBasis] appNameLocalized],
                                  [self displayName]];
                error = [error errorByAddingLocalizedRecoverySuggestion:sugg];
            }
        }
    }

end:;
    self.ixportStyle = style;

    if (error && error_p) {
        *error_p = error ;
    }
    
	return (error == nil) ;
}

- (BOOL)needsExtension1InstallError_p:(NSError**)error_p {
    BOOL needsInstall = NO ;
    NSError* error = nil ;
    /* Until BkmkMgrs 2.10.26, the following code was wrapped with
     if(![[BkmxBasis sharedBasis] isBkmxAgent]) block – did not run in
     BkmxAgent.  However, that prevented the detection of error
     constBkmxErrorBrowserRunningJustYielded, which has now been changed to
     constBkmxErrorAgentApparentlyFellBackToStyle1ThusNeededBrowserQuitButAgentCannotQuitBrowsers
     when executing in Agent.  So I removed the if() wrapper. */
    BOOL mayInstall ;
    BOOL ok = [self addonMayInstall:&mayInstall
                            error_p:&error] ;
    if (ok && mayInstall) {
        NSDictionary* result = [self peekExtension] ;
        NSError* peekErrorResult = [result objectForKey:constKeyError] ;
        NSInteger errorCode = [peekErrorResult code] ;
        if (
            ((errorCode & EXTORE_ERROR_CODE_MASK_EXTENSION1_NOT_FOUND) > 0)
            ||
            ((errorCode & EXTORE_ERROR_CODE_MASK_EXTENSION1_DOWNREV) > 0)
            ||
            ((errorCode & EXTORE_ERROR_CODE_MASK_MESSENGER_NOT_FOUND) > 0)
            ||
            ((errorCode & EXTORE_ERROR_CODE_MASK_MESSENGER_DOWNREV) > 0)
            ) {
            needsInstall = YES ;
        }
    }
    
    if (error && error_p) {
        *error_p = error ;
    }
    
    return needsInstall ;
}

- (void)registerHighExidFromItem:(NSDictionary*)item {
}

- (NSString*)uninstallInstructionsForExtensionIndex:(NSInteger)extensionIndex {
    NSString* answer = @"Internal Error 583-9585";
    return answer;
}

- (NSString*)uninstallHelpAnchorForExtensionIndex:(NSInteger)extensionIndex {
    return nil;
}

- (void)clearTransMoc {
    BOOL ok = YES;
    NSError* error = nil;
    
    Tagger* tagger = [self tagger];
    if (tagger) {
        ok = [tagger deleteAllObjectsError_p:&error];
        if (ok) {
            ok = [[self starker] deleteAllObjectsError_p:&error];
            if (!ok) {
                error = [SSYMakeError(383748, @"Could not delete all starks to clear transMOC.  Will recover by destroying MOC.") errorByAddingUnderlyingError:error];
            }
        } else {
            error = [SSYMakeError(383749, @"Could not delete all tags to clear transMOC.  Will recover by destroying MOC.") errorByAddingUnderlyingError:error];
        }
    } else {
        
    }
    
    if (!ok) {
        NSString* clidentifier = [[self clientoid] clidentifier];
        error = [error errorByAddingUserInfoObject:clidentifier
                                            forKey:clidentifier];
        error = [error errorByAddingIsOnlyInformational];
        [[BkmxBasis sharedBasis] logError:error
                          markAsPresented:NO];
        
        [SSYMOCManager destroyManagedObjectContextWithIdentifier:clidentifier
                                                          ofType:NSInMemoryStoreType];
        /* Create a new moc.  It will be added to mocDics in SSYMOCManager. */
        [self transMoc];
    }
    
    [[self starker] clearCaches];
}

- (void)clearLocalMoc {
    BOOL ok = YES;
    NSError* error = nil;
    
    ok = [[self localTagger] deleteAllObjectsError_p:&error];
    if (ok) {
        ok = [[self localStarker] deleteAllObjectsError_p:&error];
        if (!ok) {
            error = [SSYMakeError(383758, @"Could not delete all starks to clear localMOC.  Will recover by nuking moc and store.") errorByAddingUnderlyingError:error];
        }
    } else {
        error = [SSYMakeError(383759, @"Could not delete all tags to clear localMOC.  Will recover by nuking moc and store.") errorByAddingUnderlyingError:error];
    }
    
    NSString* clidentifier = [[self clientoid] clidentifier];
    error = [error errorByAddingUserInfoObject:clidentifier
                                        forKey:clidentifier];
    error = [error errorByAddingIsOnlyInformational];
    [[BkmxBasis sharedBasis] logError:error
                      markAsPresented:NO];

    [[self starker] clearCaches];

    if (!ok) {
        [SSYMOCManager destroyManagedObjectContextWithIdentifier:clidentifier
                                                          ofType:NSSQLiteStoreType];
        [SSYMOCManager removeSqliteStoreForIdentifier:clidentifier];
    }
}

#if DEBUG_WRITE_IMPORTED_URLS_TO_FILES

- (void)beginSSYLinearFileWriter {
    NSString* filename = [[self class] baseName];
    if (filename) {
        NSString* path = [@"/Users/jk/Documents/Programming/Projects/BookMacster/NormalizedUrls" stringByAppendingPathComponent:filename] ;
        [SSYLinearFileWriter setToPath:path];
    }
}

- (void)appendBookmarkSSYLinearFileWriterName:(NSString*)name
										  url:(NSString*)url {
	NSString* line = [NSString stringWithFormat:
					  @"%@\t%@",
					  name,
					  url] ;
	[SSYLinearFileWriter writeLine:line] ;
}

- (void)closeSSYLinearFileWriter {
	[SSYLinearFileWriter close] ;
}

#endif

@end

#if 0
#warning Compiling methods for debugging extore memory leaks
@implementation Extore (DebugMemoryLeaks)
- (void)logRC:(NSString*)label {
    @autoreleasepool {
        NSString* baseName = [[self class] baseName];
        NSString* cn;
        if (baseName.length > 2) {
            cn = [baseName substringToIndex:2];
        } else if (baseName.length > 0) {
            cn = baseName;
        } else {
            cn = @"nl";
        }
        NSString* msg = [NSString stringWithFormat:
                         @"rct %03ld %@ %p %@", (long)self.retainCount, cn, self, label];
        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                    logFormat:msg];
    }
}
@end
@implementation NSDictionary (DebugExtore)
- (void)logRC:(NSString*)label {
    @autoreleasepool {
        Extore* extore = [self objectForKey:constKeyExtore];
        NSString* baseName = [[extore class] baseName];
        NSString* cn;
        if (baseName.length > 2) {
            cn = [baseName substringToIndex:2];
        } else if (baseName.length > 0) {
            cn = baseName;
        } else {
            cn = @"nl";
        }
        NSString* groupName = [self objectForKey:@"SSYOperationGroup"];
        NSString* msg = [NSString stringWithFormat:
                         @"rct %03ld %@ %p %@ %@", (long)extore.retainCount, cn, extore, baseName, label];
        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                    logFormat:msg];
    }
}
@end
#endif
