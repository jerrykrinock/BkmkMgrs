#import "ExtoreChromy.h"
#import "Stark.h"
#import "SSYTreeTransformer.h"
#import "NSString+LocalizeSSY.h"
#import "BkmxDoc.h"
#import "Starker.h"
#import "Client.h"
#import "Client+SpecialOptions.h"
#import "BkmxBasis.h"
#import "BkmxBasis+Strings.h"
#import "SSYUuid.h"
#import "NSString+BkmxDisplayNames.h"
#import "NSError+InfoAccess.h"
#import "NSError+DecodeCodes.h"
#import "NSDictionary+SimpleMutations.h"
#import "Stark+Attributability.h"
#import "NSDictionary+BSJSONAdditions.h"
#import "NSInvocation+Quick.h"
#import "NSString+SSYExtraUtils.h"
#import "NSDictionary+KeyPaths.h"
#import "SSYMH.AppAnchors.h"
#import "NSData+HexString.h"
#import "NSObject+MoreDescriptions.h"
#import "NSObject+DeepCopy.h"
#import "NSDictionary+BSJSONAdditions.h"
#import "NSData+MBBase64.h"
#import "NSArray+SSYMutations.h"
#import "OperationExport.h"
#import "NSFileManager+SomeMore.h"
#import "NSError+MyDomain.h"
#import "SSYOtherApper.h"
#import "NSString+MorePaths.h"
#import "SSYInterappClient.h"
#import "SSYSqliter.h"
#import "NSString+BkmxURLHelp.h"
#import "NSDate+NiceFormats.h"
#import "BkmxGlobals.h"
#import "Chromessengerer.h"
#import "SSYMOCManager.h"
#import "ClientChoice.h"
#import "Importer.h"
#import "SSYAlert.h"
#import "ExtoreChrome.h"
#import "NSError+MoreDescriptions.h"
#import "NSDictionary+ToStark.h"
#import "Stark+ConvertToChrome.h"
#import "Client+SpecialOptions.h"
#import "NSBundle+SSYMotherApp.h"
#import "NSBundle+MainApp.h"
#import "SSYDigester.h"
#import "ChromeDigesterHelpers.h"
#import "NSDictionary+Treedom.h"
#import "Chaker.h"
#import "ExtoreOpera.h"
#import "NSString+URIQuery.h"
#import "BkmxAppDel.h"
#import "ProfileInfoCache.h"

@interface NSString (RemoveProfilePathComponent)

- (NSString*)pathByDeletingLastNPathComponent:(NSInteger)n;

@end

@implementation NSString (RemoveProfilePathComponent)

/*
 If n=2, deletes the second last path component
 If n=3, deletes the third last path component
 etc.
 */
- (NSString*)pathByDeletingLastNPathComponent:(NSInteger)n {
    NSMutableArray* comps = [[self pathComponents] mutableCopy];
    NSInteger targetIndex = comps.count - n - 1;
    NSString* answer = self;
    if (targetIndex >= 0) {
        [comps removeObjectAtIndex:(targetIndex)];
         answer = [NSString pathWithComponents:comps];
    }
    [comps release];
    
    return answer;
}

@end


NSMutableDictionary* static_profileInfoCache = nil ;

/*
 The followng interpretations are derived from reverse-engineering the behavior
 of last one seems kind of weird.  I wonder why they just don't remove
 the whole subdictionary?
 This was tested with another profile actively holding
 the extension.
 */
enum ChromyExtensionState_enum {
    ChromyExtensionStateDisabled = 0, // installed but disabled
    ChromyExtensionStateEnabled  = 1, // installed and enabled
    ChromyExtensionStateTrashed  = 2  // trashed, no longer listed in Window > Extensions
} ;
typedef enum ChromyExtensionState_enum ChromyExtensionState ;

NSString* const constFilenameExtensionCrx = @"crx" ;

NSString* const constChromyExtensionLegacyUuid = @"gielihnpdhkbdcnlcdnpnkidbomiccip" ;

NSString* const constKeyBrowserAction = @"browser_action" ;

NSString* const constReadingUnsortedDisplayName = @"Reading/Unsorted" ;

/*
 Note 190351.  Chrome supports lastModifiedDate for folders only, although for
 most folders this value is 0, and I don't know what triggers it to get set to
 the current date.  Now one might think that setting canEditLastModifiedDate in
 the extore constants to YES would cause changes to be written to the Sync Logs
 on round trip Import-Exports (churning), because, during Export, all starks
 will have a value from BookMacster, but the corresponding bookmark read from
 the Chrome bookmarks file will be nil.  However that doesn't happen because
 lastModifiedDate is a trivial attribute.  See -[BkmxDoc objectWillChangeNote:].
 
 So, until BookMacster 1.11, I set canEditLastModifiedDate in the extore
 constants to YES because it did not cause churn during round trips, and I
 thought it would be good to have if Google ever fixed Chrome to support this
 attribute the way it may have been intended.  But in developing BookMacster
 1.11, I noticed that it was causing a different kind of churn.  Say that we
 have two Syncers, one watching for changes in Chrome and the other watching the
 document file for changes from another Mac via Dropbox.  Also say that Chrome
 is a client and is running.
 • Change the file on the remote Mac.
 • Changes are exported to Chrome on this Mac.
 • Changes detected in Chrome.
 • BookMacster imports from Chrome.
 • BookMacster sees no changes in Chrome (because lastModifiedDate is trivial)
     and therefore does not export to Chrome.  Good, but…
 • When saving, NSPersistenDocument will see this as a change and save, which
 • Causes the change to propagate back through Dropbox which
 • Causes the remote Mac to waste time reading in the document file.  No
     exportable changes will be found.  It's just a waste of resources.
 • Incidentally, when
.    -[BkmxDoc finalizeStarksLastModifiedDatesAndReturnIfNeededSaveOperationType:]
 runs, it invokes
.    -[Starker finalizeStarksLastModifiedDates], which invokes
.    -[Stark finalizeLastModifiedDate] on each stark,
 which doesn't filter for trivial attributes because it needs to save if there
 are *any* changes*.  So it will also add such stark to the total of 'updated'
 starks in the string it sends to -logFormat:  So, in BookMacster 1.11 I made
 lastModifiedDate an owner value.
 
 Note 190352  In BookMacster 1.11, when importing from or exporting to Chromium
 or Google Chrome, the bookmark attribute and addDate is no longer mapped into
 the corresponding fields in BookMacster.  Instead, this attribute is passed in
 an opaque manner, and only emerge when Chromium or Google Chrome.  (We did
 this because the Chrome/Chromium API does not allow us to update *Date Added*,
 but instead updates it uncontrollably whenever we merely change any other
 attribute.  Properly handling these two quirks would require complexity which
 is obviously unwarranted.)
 */

NSString* const constFilenameChromePreferences = @"Preferences" ;
NSString* const constKeyProfile = @"profile" ;
NSString* const constKeyLastUsed = @"last_used" ;
NSString* const constKeyLastActiveProfiles = @"last_active_profiles" ;
NSString* const constKeyState = @"state" ;


@interface NSDictionary (HighestUsedExidForChromy)

- (void)registerHighExidForExtore:(ExtoreChromy*)extore ;

@end

@interface ExtoreChromy ()

@property (retain) NSDictionary* ignoredBranchesInRoot ;

@end

@implementation  NSDictionary (HighestUsedExidForChromy)

- (void)registerHighExidForExtore:(ExtoreChromy*)extore  {
    [extore registerHighExidFromItem:self] ;
}

@end


@implementation ExtoreChromy

@synthesize ignoredBranchesInRoot = m_ignoredBranchesInRoot ;

+ (BOOL)hasProprietarySyncThatNeedsOwnerAppRunning {
    return YES ;
}

+ (BOOL)requiresStyle2WhenProprietarySyncIsActive {
    return YES;
}

- (void)dealloc {
    [m_ignoredBranchesInRoot release] ;
    
    [super dealloc] ;
}

- (BOOL)shouldCheckAggregateExids {
    return YES ;
}

- (BOOL)canRemoveHartainers {
    return YES ;
}

- (BOOL)parentSharype:(Sharype)parentSharype
  canHaveChildSharype:(Sharype)childSharype {
    BOOL ok = [super parentSharype:parentSharype
               canHaveChildSharype:childSharype] ;
    if (ok) {
        // Only other hartainers are allowed in Root
        if (parentSharype == SharypeRoot) {
            if ([StarkTyper coarseTypeSharype:childSharype] != SharypeCoarseHartainer) {
                ok = NO ;
            }
        }
        if (ok) {
            // Only folders are allowed in the Menu aka Folders aka Other Bookmarks
            if (parentSharype == SharypeMenu) {
                if ([[self client] noLoosiesInMenu]) {
                    if ([StarkTyper coarseTypeSharype:childSharype] != SharypeCoarseSoftainer) {
                        ok = NO ;
                    }
                }
            }
        }
    }
    
    return ok ;
}

- (Stark*)fosterParentForStark:(Stark *)stark {
    Sharype sharype = [stark sharypeValue] ;
    BOOL okToPutInMenu = YES ;
    if ([[self client] noLoosiesInMenu]) {
        if ([StarkTyper coarseTypeSharype:sharype] != SharypeCoarseSoftainer) {
            okToPutInMenu = NO ;
        }
    }
    
    Stark* answer ;
    if (okToPutInMenu) {
        answer = [[self starker] menu] ;
    }
    else {
        if ([[self client] fakeUnfiled]) {
            answer = [[self starker] unfiled] ;
        }
        else {
            answer = [[self starker] bar] ;
        }
    }
    
    return answer ;
}

- (NSSet*)hartainersWeEdit {
    NSAssert(NO, @"Subclass must implement") ;
    return [NSSet set] ;
}

/* This method was added in BookMacster 1.9.8, when the Chrome "synced" aka
 "Mobile Bookmarks" folder was discovered.  It will also support the 'other'
 branch and 'trash' branches which are ignored in Opera. */
- (NSDictionary*)ignoredBranchesInRootFromDisk {
    NSError* error = nil ;
    NSData* jsonData = nil;
    
    NSMutableDictionary* ignoredBranchesInRoot = nil ;
    NSString* path = [self workingFilePathError_p:&error] ;
    if (path) {
        jsonData = [[NSData alloc] initWithContentsOfFile:path] ;
        if (jsonData) {
            NSDictionary* tree = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:jsonData
                                                                                options:BkmxBasis.optionsForNSJSON
                                                                                  error:&error];
            
            if (error) {
                NSString* msg = [NSString stringWithFormat:
                                 @"Could not decode JSON received from %@ API due to %@",
                                 [self displayName],
                                 error] ;
                NSLog(@"Internal Error 562-9205 %@", msg) ;
            }
            
            NSDictionary* roots = [tree objectForKey:@"roots"] ;
            NSArray* branchNames = [roots allKeys] ;
            ignoredBranchesInRoot = [[NSMutableDictionary alloc] init] ;
            for (NSString* branchName in branchNames) {
                if (![[self hartainersWeEdit] member:branchName]) {
                    [ignoredBranchesInRoot setObject:[roots objectForKey:branchName]
                                              forKey:branchName] ;
                }
            }
        } else {
            NSLog(@"Internal Error 684-1094 could not read data in %@", path) ;
        }
    } else {
        NSLog(@"Internal Error 684-1096") ;
    }
    
    [jsonData release];
    NSDictionary* answer = nil ;
    if (ignoredBranchesInRoot) {
        answer = [[ignoredBranchesInRoot copy] autorelease] ;
    }
    [ignoredBranchesInRoot release] ;
    
    return answer ;
}

- (void)doSpecialMappingAfterImport {
}

// This method is only used when writing bookmarks in Style 1
- (NSMutableDictionary*)newJsonRootsFromBar:(NSDictionary*)bar
                                       menu:(NSDictionary*)menu
                                    unfiled:(NSDictionary*)unfiled
                                     ohared:(NSDictionary*)ohared {
    NSAssert(NO, @"Subclass must implement") ;
    return [[NSMutableDictionary alloc] init] ;
}

/* See file ChromeChecksum.cpp to learn how I learned what to hash
 Update 20200709.  It appears that the current version of the checksumming
 code is here:
 https://github.com/chromium/chromium/blob/master/components/bookmarks/browser/bookmark_codec.cc
 */
- (NSArray*)keyPathsInChecksum {
    return  @[
              @"bookmark_bar",
              @"other",
              @"synced",
              ] ;
}

// This method is only used when writing bookmarks in Style 1
- (NSString*)jsonStringFromTree {
    
    SEL reformatter = [self reformatStarkToExtore] ;
    
    SSYTreeTransformer* transformer = [SSYTreeTransformer
                                       treeTransformerWithReformatter:reformatter
                                       childrenInExtractor:@selector(childrenOrdered)
                                       newParentMover:@selector(moveToChildrenLowerOfNewParent:)
                                       contextObject:self] ;
    
    /* Transform root items.  For GooChromy browsers, unfiled and ohared
     will be nil.  For CustomRoot (Opera), all four will be non-nil. */
    NSDictionary* browserBar = [transformer copyDeepTransformOf:[[self starker] bar]] ;
    NSDictionary* browserMenu = [transformer copyDeepTransformOf:[[self starker] menu]] ;
    NSDictionary* browserUnfiled = [transformer copyDeepTransformOf:[[self starker] unfiled]] ;
    NSDictionary* browserOhared = [transformer copyDeepTransformOf:[[self starker] ohared]] ;
    
    NSMutableDictionary* roots = [self newJsonRootsFromBar:browserBar
                                                      menu:browserMenu
                                                   unfiled:browserUnfiled
                                                    ohared:browserOhared] ;

    [browserBar release] ;
    [browserMenu release] ;
    [browserUnfiled release] ;
    [browserOhared release] ;

    NSDictionary* ignoredBranchesInRoot = [self ignoredBranchesInRoot] ;
    if (![ignoredBranchesInRoot objectForKey:constKeySyncTransactionVersion]) {
        /* I think this is defensive programming.  If no
         sync_transaction_vesion was read from the disk and stored, create one.
         I think this is just a serial number for the proprietary sync account
         that starts with 2 and goes to infinity, incrementing every time
         there is a sync operation.  So, make it 2. */
        ignoredBranchesInRoot = [ignoredBranchesInRoot dictionaryBySettingValue:@"2"
                                                                         forKey:constKeySyncTransactionVersion] ;
    }
    
    BOOL alreadyHasOther = (browserMenu != nil);
    if (alreadyHasOther) {
        ignoredBranchesInRoot = [ignoredBranchesInRoot dictionaryByRemovingObjectForKey:@"other"];
    }

    [roots addEntriesFromDictionary:ignoredBranchesInRoot] ;
    
    // Now, we assemble a root "from scratch"
    NSMutableDictionary* extoreRoot = [[NSMutableDictionary alloc] init] ;
    [extoreRoot setObject:roots
                   forKey:@"roots"] ;
    
    // Compute checksum
    SSYDigester* digester = [[SSYDigester alloc] initWithAlgorithm:SSYDigesterAlgorithmMd5] ;
    for (NSString* keyPath in [self keyPathsInChecksum]) {
        NSDictionary* branch = [roots valueForKeyPath:keyPath] ;
        [branch recursivelyPerformOnChildrenLowerSelector:@selector(updateChromeDigester:)
                                               withObject:digester] ;
    }
    NSData* digest = [digester finalizeDigest] ;
    NSString* checksum = [digest lowercaseHexString] ;
    [digester release] ;

    [roots release] ;
    
    // Add other keys for root
    [extoreRoot setObject:checksum
                   forKey:@"checksum"] ;
    [extoreRoot setObject:[NSNumber numberWithInteger:1]
                   forKey:@"version"] ;
    
    // Convert to a JSON string
    NSString* jsonString = [extoreRoot jsonStringValue] ;
#if 0
#warning Testing Cocoa's JSON capability.
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:extoreRoot
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error] ;
    NSString* jsonStringNS = [[NSString alloc] initWithData:jsonData
                                                   encoding:NSUTF8StringEncoding] ;
    NSLog(@"BS: %@", jsonString) ;
    NSLog(@"NS: %@", jsonStringNS) ;
    NSLog(@"same = %hhd", [jsonString isEqualToString:jsonStringNS]) ;
    [jsonStringNS release] ;
    /* Result: NS looks the same as BS except it has more whitespace.
     The more whitespace appears at first glance to be like the JSON
     produced by Google Chrome.  However, like BS, NS
     escapes slashes in strings, such as slashes in URLs. */
#endif

    [extoreRoot release] ;
    
    return jsonString ;
}

- (void)writeUsingStyle1InOperation:(SSYOperation*)operation {
    BOOL ok = NO ;
    NSString* jsonString = [self jsonStringFromTree] ;
    if (jsonString) {
        NSError* error = nil ;
        NSString* path = [self workingFilePathError_p:&error] ;
        ok = (path != nil) ;
        if (ok) {
            ok = [self writeString:jsonString
                            toFile:path] ;
            NSString* msg = [NSString stringWithFormat:
                             @"\nDid write ok=%@ to path:%@\n"
                             "Error: %@\n"
                             "New JSON string:\n%@\n\n",
                             [NSString stringWithFormat:@"%ld", (long)ok],
                             path,
                             [[self error] longDescription],
                             jsonString] ;
            [[BkmxBasis sharedBasis] trace:msg] ;
        }
        else {
            [self setError:error] ;
        }
    }
    
    [operation writeAndDeleteDidSucceed:ok] ;
}

- (void)readExternalStyle1ForPolarity:(BkmxIxportPolarity)polarity
                    completionHandler:(void(^)(void))completionHandler {
    [self setError:nil] ;
    
    NSError* error = nil ;
    BOOL ok = YES ;
    
    NSString* path = [self workingFilePathError_p:&error] ;
    if (!path) {
        ok = NO ;
        goto end ;
    }
    else {
        NSData* data = [NSData dataWithContentsOfFile:path];
        if (!data) {
            NSLog(@"Internal Error 684-1094 %@\n%@", self, error) ;
        }
        else {
            ok = [self makeStarksFromJsonData:data
                                        error_p:&error] ;
        }
        if (!ok) {
            goto end ;
        }
    }
    
end:;
    if (!ok) {
        NSError* error1 = SSYMakeError(95041, @"Error reading JSON file") ;
        error1 = [error1 errorByAddingUnderlyingError:error] ;
        error1 = [error1 errorByAddingUserInfoObject:[self.clientoid shortDescription]
                                              forKey:@"Clientoid"] ;
        error1 = [error1 errorByAddingUserInfoObject:[self filePathError_p:NULL]
                                              forKey:@"filePath"] ;
        if (path) {
            NSString* msg = [NSString stringWithFormat:
                             @"Make sure file at path %@ is a valid **%@** bookmarks file.",
                             path,
                             [[[self clientoid] exformat] exformatDisplayName]] ;
            error1 = [error1 errorByAddingLocalizedRecoverySuggestion:msg] ;
        }
        
        [self setError:error1] ;
    }
    
    completionHandler();
}

+ (BOOL)canProbablyImportFileType:type
                             data:data {
    if (!data) {
        return NO ;
    }
    NSDictionary* root = [NSPropertyListSerialization propertyListWithData:data
                                                                   options:NSPropertyListImmutable
                                                                    format:NULL
                                                                     error:NULL] ;
    if ([root objectForKey:[self constants_p]->telltaleString]) {
        return YES ;
    }
    
    return NO ;
}

- (NSTimeInterval)quitHoldTime {
    NSTimeInterval answer ;
    NSNumber* quitHoldTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"chromyQuitHoldTime"] ;
    if (quitHoldTime) {
        answer = [quitHoldTime doubleValue] ;
    }
    else {
        answer = 10.0 ;
    }
    
    return answer ;
}

/*
 The returned string constant in this method generates a warning, 
 "Input conversion stopped due to an input byte that does not belong to the input codeset UTF-8",
 which seems to be due to any of the code points \x80 and above.
 This warning happens only when compiling for ppc (PowerPC) (on LLVM 1.6)
 But then I found that I don't even need the metbod.
 // When normalizing URLs, decode only the following
 // HTML entities in the 'path' portion:
 (hexadecimal):
 2d, 2e (- and .)
 30-39 (decimal digits)
 41-5A (uppercase Roman letters)
 5F (_)
 61-7A (lowercase Roman letters)
 7E (~)
-(NSString*)leaveEscapedInPath {	
	// The following string contains all 1-byte characters except those noted above
	return @"\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\x1B\x1C\x1D\x1E\x1F\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2A\x2B\x2C\x2F\x3A\x3B\x3C\x3D\x3E\x3F\x40\x5B\x5C\x5D\x5E\x60\x7B\x7C\x7D\x7F\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8A\x8B\x8C\x8D\x8E\x8F\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9A\x9B\x9C\x9D\x9E\x9F\xA0\xA1\xA2\xA3\xA4\xA5\xA6\xA7\xA8\xA9\xAA\xAB\xAC\xAD\xAE\xAF\xB0\xB1\xB2\xB3\xB4\xB5\xB6\xB7\xB8\xB9\xBA\xBB\xBC\xBD\xBE\xBF\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF" ;
}
*/

+ (BOOL)canDetectOurChanges {
	return YES ;
}

- (BkmxIxportTolerance)ixportTolerance {
    BOOL tolerable = NO ;
    
    if (self.ixportStyle == 2) {
        tolerable = YES ;
    }
    else {
        if (![self isSyncActiveError_p:NULL]) {
            OwnerAppRunningState runningState = [self ownerAppRunningStateError_p:NULL] ;
            switch (runningState) {
                case OwnerAppRunningStateError:
                case OwnerAppRunningStateRunningProfileAvailable:
                    // leave tolerable = NO ;
                    break ;
                case OwnerAppRunningStateRunningProfileWrongOne: // Does not occur in Chromy; just for completeness
                case OwnerAppRunningStateRunningProfileNotLoaded:
                case OwnerAppRunningStateNotRunning:
                    tolerable = YES ;
            }
        }
	}

    BkmxIxportTolerance tolerance =
    tolerable
    ? BkmxIxportToleranceAllowsReading + BkmxIxportToleranceAllowsWriting
    : BkmxIxportToleranceAllowsNone ;

	return tolerance ;
}

+ (BOOL)addonSupportsPurpose:(NSInteger)purpose {
	BOOL answer = ([[BkmxBasis sharedBasis] iAm] != BkmxWhich1AppSmarky) ;
    return answer ;
}

+ (NSString*)browserSupportPathForHomePath:(NSString*)homePath {
    if (!homePath) {
        // Default to the current user's Mac account
        homePath = NSHomeDirectory() ;
    }
    NSString* appSupportRelativePath = [self constants_p]->appSupportRelativePath ;
	return [[NSString applicationSupportPathForHomePath:homePath] stringByAppendingPathComponent:appSupportRelativePath] ;
}

+ (NSString*)localStateFilePathForHomePath:(NSString*)homePath {
    NSAssert(NO, @"Subclass must implement") ;
	return nil ;
}

+ (NSDictionary*)localStateDicOnceForHomePath:(NSString*)homePath {
    NSDictionary* tree = nil;
    NSError* error = nil;
    NSString* path = [self localStateFilePathForHomePath:homePath] ;

    NSData* jsonData = [[NSData alloc] initWithContentsOfFile:path] ;
    if (jsonData) {
        tree = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:BkmxBasis.optionsForNSJSON
                                                                error:&error];
        if (error) {
            NSString* msg = [NSString stringWithFormat:
                             @"Could not decode JSON received from %@ due to %@",
                             path,
                             error] ;
            NSLog(@"Internal Error 562-9205 %@", msg) ;
        }
        if (![tree isKindOfClass:[NSDictionary class]]) {
            tree = nil ;
            NSString* msg = [NSString stringWithFormat:
                             @"Expected dictionary, got %@ from %@",
                             [tree className],
                             path] ;
            NSLog(@"Internal Error 562-8489 %@", msg) ;
        }
    } else {
        NSLog(@"Internal Error 684-1094 could not read %@\n%@", self, path) ;
    }

    return tree;
}

+ (NSDictionary*)localStateDicForHomePath:(NSString*)homePath
                                  timeout:(NSTimeInterval)timeout {
    
    // At one time, I saw that profileDic was nil here.  I suppose that is
    // possible, if Chrome had just been launched for the first time and had
    // not created a profileDic first.  So I put this in a loop to keep
    // trying.
    NSDate* startDate = [NSDate date] ;
    NSDictionary* localStateDic = nil ;
    while (!localStateDic) {
        localStateDic = [[self class] localStateDicOnceForHomePath:homePath] ;
        NSTimeInterval elapsed = 0.0 ;
        if (localStateDic) {
            break ;
        }
        
        elapsed = -[startDate timeIntervalSinceNow] ;
        if (elapsed > timeout) {
            break ;
        }

        usleep(250000) ;
    }
    
    if (![localStateDic isKindOfClass:[NSDictionary class]]) {
        localStateDic = nil ;
    }
    
    return localStateDic ;
}

+ (NSDictionary *)profileDicForHomePath:(NSString *)homePath
                                timeout:(NSTimeInterval)timeout {
    NSDictionary* localStateDic = [self localStateDicForHomePath:homePath
                                                         timeout:timeout] ;
    NSDictionary* answer = [localStateDic objectForKey:constKeyProfile] ;
    if (![answer isKindOfClass:[NSDictionary class]]) {
        answer = nil ;
    }
    
    return answer ;
}

+ (NSDictionary*)infoCacheForHomePath:(NSString*)homePath {
	NSDictionary* profileDic = [self profileDicForHomePath:homePath
                                                   timeout:0.0] ;
    NSDictionary* infoCache = [profileDic objectForKey:@"info_cache"] ;
    if (![infoCache isKindOfClass:[NSDictionary class]]) {
        infoCache = nil ;
    }
    
    return infoCache ;
}


#define PROFILE_INFO_SHELF_LIFE_SECONDS 10.0
/* displayProfileNames is performance optimization added in BookMacster 1.13.4,
 so that, if the 'Clients' column is displayed in Content View, we don't need
 to access the disk with each bookmark displayed in the Content Outline, as in
 this call stack fragment…
 -[NSTableView _dirtyVisibleCellsForKeyStateChange]
 -[NSOutlineView preparedCellAtColumn:row:]
 -[NSTableView preparedCellAtColumn:row:]
 -[ContentDataSource outlineView:objectValueForTableColumn:byItem:]
 -[Stark clients]
 -[Clientoid displayName]
 -[Clientoid displayNameWithProfile:]
 -[Clientoid profileNameAsDisplayedSuffix]
 +[ExtoreChromy displayProfileNameForProfileName:]
 The tradeoff is that, in the once-in-a-lifetime event when user changes
 the display name for a user profile in Chrome's preferences, we'll continue
 to display the old name for DISPLAY_PROFILE_NAMES_SHELF_LIFE_SECONDS seconds.
 */

+ (void)initialize {
    /* When app launches, this method runs once for each descendant subclasses
      and once for the base class ExtoreChromy.  So we check to see that it's
     not already initialized.  */
    if (!static_profileInfoCache) {
        static_profileInfoCache = [[NSMutableDictionary alloc] init] ;
    }
}

+ (NSMutableDictionary*)profileInfoCacheDic {
    NSString* key = [self exformatForExtoreClass:self] ;
    NSMutableDictionary* dic = [static_profileInfoCache objectForKey:key] ;
    if (!dic) {
        dic = [NSMutableDictionary dictionary] ;
        [static_profileInfoCache setObject:dic
                                    forKey:key] ;
    }
    
    return dic ;
}

+ (NSString*)displayProfileNameFromDictionary:(NSDictionary*)dic {
    /* Opera 104 has the key 'name', but it is an empty string.  But we
     try it anyhow, in case someday Opera starts using it.
     The key 'name' is used as expected by Microsoft Edge. */
    return [dic objectForKey:@"name"] ;
}

+ (void)refreshFromDiskOurInMemoryProfileInfoCache:(ProfileInfoCache *)cache {
    NSDictionary* infoCache = [self infoCacheForHomePath:NSHomeDirectory()] ;
    
    NSMutableDictionary* displayProfileNames = [NSMutableDictionary dictionary] ;
    [cache setDisplayProfileNames:displayProfileNames] ;
    
    for (NSString* aProfileName in infoCache) {
        NSDictionary* aProfileDic = [infoCache objectForKey:aProfileName] ;
        if ([aProfileDic respondsToSelector:@selector(objectForKey:)]) {
            NSString* aDisplayName = [self displayProfileNameFromDictionary:aProfileDic] ;
            if (aDisplayName.length < 1) {
                /* This branch executes for Opera 104, wherein in its
                 Local State file dictionary, the value of key path
                 profile.info_cache.Default.name is an empty string.
                 Let's use the key itself.  */
                aDisplayName = aProfileName;
            }
            [displayProfileNames setObject:aDisplayName
                                    forKey:aProfileName];
        }
    }
    
    [cache setDisplayProfileNames:displayProfileNames];
}

+ (ProfileInfoCache*)profileInfoCache {
    ProfileInfoCache* cache = [[self profileInfoCacheDic] objectForKey:NSHomeDirectory()] ;

    if (!cache) {
        // Must create a cache for this homePath
        cache = [[ProfileInfoCache alloc] init] ;
        [[self profileInfoCacheDic] setObject:cache
                                    forKey:NSHomeDirectory()] ;
        [cache release] ;
    }
    
    NSTimeInterval lastUpdate = [cache lastUpdate] ;  // will be 0 if new empty cache
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate] ;
    NSTimeInterval age = now - lastUpdate ;    // will be 400 million seconds if new empty cache
    if (age > PROFILE_INFO_SHELF_LIFE_SECONDS) {
       // The following statement accesses the disk and takes a long time,
        // which is why we use the ProfileInfoCache
        [self refreshFromDiskOurInMemoryProfileInfoCache:cache] ;
        // NSLog(@"Refreshed %ld displayProfileNames %@ %@", (long)[displayProfileNames count], [self exformatForExtoreClass:self], homePath) ;

        BOOL shouldSuffix = NO ;
        NSArray* profilesInUse = [[cache displayProfileNames] allKeys] ;
        if ([profilesInUse count] > 1) {
            shouldSuffix = YES ;
        }
        else {
            // There is only one profile.  Normally it is "Default".
            NSString* defaultProfileName = [self constants_p]->defaultProfileName ;
            // The following test is defensive programming
            if (defaultProfileName) {
                if ([profilesInUse indexOfObject:defaultProfileName] == NSNotFound) {
                    // This user has only one profile, but it is *not* the Default profile
                    shouldSuffix = YES ;
                }
            }
        }
        [cache setShouldSuffix:shouldSuffix] ;
        // NSLog(@"Refreshed shouldSuffix=%hhd %@ %@", [cache shouldSuffix], [self exformatForExtoreClass:self], homePath) ;

        [cache setLastUpdate:[NSDate timeIntervalSinceReferenceDate]] ;
    }
    
    return cache ;
}

/*
   structure of dictionary static_profileInfoCache
      key aClassName : dictionary
         key homePath : ProfileInfoCache
 */

+ (NSString*)displayProfileNameForProfileName:(NSString*)profileName {
    if (!profileName) {
        // Client was created prior to BookMacster 1.13.2.
        // This is probably defensive programming now that we have
        // -[BkmxDoc upgradePriorTo1_13_3].
        // Update: 20130429.  No, it's not defensive programming!  I just
        // updated a document created with BookMacster 1.3.18 and this branch
        // executed 245 times (and the document only had 21 folders + 42
        // bookmarks.  So, in BookMacster 1.15 I commented out the warning.
        // NSLog(@"Warning 927-3848 %@ %@", [self exformatForExtoreClass:self], profileName) ;
        profileName = [self constants_p]->defaultProfileName ;
    }
    else if ([profileName isEqualToString:constSorryNullProfile]) {
        profileName = @"None/Null" ;
    }
    
    ProfileInfoCache* cache = [self profileInfoCache] ;
    NSMutableDictionary* displayProfileNames = [cache displayProfileNames] ;
    
    NSString* displayProfileName = [displayProfileNames objectForKey:profileName] ;

    if (!displayProfileName) {
        // This could happen if the profile has since been removed from
        // Chrome, but client still exists in a document's Settings
        // Fall back to under-the-hood profile name
        displayProfileName = profileName ;
    }
    
    return displayProfileName ;
}

+ (BOOL)shouldSuffixProfileNameForHomePath:(NSString*)homePath {
    ProfileInfoCache* cache = [self profileInfoCache] ;
    BOOL shouldSuffix = [cache shouldSuffix] ;
    
    return shouldSuffix ;
}

+ (NSString*)displayedSuffixForProfileName:(NSString*)profileName
                                  homePath:(NSString*)homePath {
    NSString* suffix ;
    if ([self shouldSuffixProfileNameForHomePath:homePath]) {
        // The following method handles nil profileName
        suffix = [self displayProfileNameForProfileName:profileName] ;
        suffix = [NSString stringWithFormat:@" (%@)", suffix] ;
    }
    else {
        suffix = @"" ;
    }

    return suffix ;
}

+ (BOOL)supportsMultipleProfiles {
    return YES;
}

+ (NSArray*)profileNames {
    NSSet* names = [self allProfilesThisHome] ;
    NSArray* array = [names allObjects] ;
    
	return array ;
}

+ (NSString*)pathForProfileName:(NSString*)profileName
                       homePath:(NSString*)homePath
                        error_p:(NSError**)error_p {
    return [[self browserSupportPathForHomePath:homePath] stringByAppendingPathComponent:profileName] ;
}

+ (NSString*)browserExtensionPortNameForProfileName:(NSString*)profileName {
	return [NSString stringWithFormat:
			@"%@.%@.%@",
			[[NSBundle mainAppBundle] motherAppBundleIdentifier],
			NSStringFromClass([self class]),  // Chrome, Canary or Chromium
            profileName] ;
}

- (NSInteger)minVersionForMessenger {
    NSString* infoPlistKey = @"MESSENGER_LATEST_VERSION" ;
    /* Starting with BookMacster 1.19.8, we put this in Info.plist so that we
     can check it agains the extension's manifest during building. */
    NSBundle* bundle = [NSBundle mainAppBundle] ;
    NSNumber* number = [bundle objectForInfoDictionaryKey:infoPlistKey] ;
    if (!number) {
        NSLog(@"Internal Error 624-6088") ;
    }
    
	return [number integerValue] ;
}

+ (BOOL)messengerIsAliveForProfileName:(NSString*)profileNameExpected
                                error_p:(NSError**)error_p {
    BOOL ok ;
    NSInteger errorCode = 0 ;
    NSString* errorDescrip = nil ;
    NSString* errorReason = nil ;
    NSError* error = nil ;
    
    char rxHeaderByte = 0 ;
    NSData* rxData ;
	NSString* portName = [[self browserExtensionPortNameForProfileName:profileNameExpected] stringByAppendingString:@".ToClient"] ;
    ok = [SSYInterappClient sendHeaderByte:constInterappHeaderByteForProfileRequest
								 txPayload:nil
								  portName:portName
									  wait:YES
							rxHeaderByte_p:&rxHeaderByte
							   rxPayload_p:&rxData
								 txTimeout:0.359
								 rxTimeout:3.17
								   error_p:&error] ;
	if (!ok && [error involvesCode:SSYInterappClientErrorCantFindReceiver
                            domain:SSYInterappClientErrorDomain]) {
        // This is the expected error when port is not available because
        // Chrome has not opened any windows in our profile since it launched,
        // or when Chrome is not even running.
        // We therefore do not assign *error_p, but just…
        return NO ;
	}
    
    if (ok) {
        if (rxHeaderByte != constInterappHeaderByteForProfileResponse) {
            errorDescrip = [NSString stringWithFormat:
                             @"Wrong ack '%c'",
                             rxHeaderByte] ;
            errorCode = 450895 ;
            ok = NO ;
        }
    }
    
    if (ok) {
        if (rxData == nil) {
            ok = NO ;
            errorDescrip = @"Nil data received" ;
            errorCode = 450896 ;
        }
    }
    
    if (ok) {
        if ([rxData length] == 0) {
            ok = NO ;
            errorDescrip = @"0 bytes received" ;
            errorCode = 450897 ;
        }
    }
    
    NSString* profileNameReported = nil ;
    if (ok) {
        profileNameReported = [[NSString alloc] initWithData:rxData
                                                    encoding:NSUTF8StringEncoding] ;
    }
    
    if (ok) {
        // constSorryNullProfile matches string in Extension's background.html
        if ([profileNameReported isEqualToString:constSorryNullProfile]) {
            errorCode = EXTORE_ERROR_CODE_MASK_IPC_PROFILE_NULL ;
            errorDescrip = @"Port in browser extension has no profile" ;
            [profileNameReported release] ;
            profileNameReported = nil ;
            // This should never happen
            ok = NO ;
        }
    }

    BOOL answer = NO ;
    if (ok) {
        if (profileNameReported) {
            if (![profileNameExpected isEqualToString:profileNameReported]) {
                errorCode = EXTORE_ERROR_CODE_MASK_IPC_PROFILE_CROSSTALK ;
                errorDescrip = @"Browser extension has crosstalk between profiles" ;
                // This should never happen
                ok = NO ;
            }
            
            answer = [profileNameExpected isEqualToString:profileNameReported] ;
        }
    }
    
    
    if (!ok && error_p) {
        error = [SSYMakeError(errorCode, errorDescrip) errorByAddingUnderlyingError:error] ;
        error = [SSYMakeError(450890, @"Could not verify profile from browser") errorByAddingUnderlyingError:error] ;
        error = [error errorByAddingLocalizedFailureReason:errorReason] ;
        error = [error errorByAddingUserInfoObject:portName
                                            forKey:@"Port Name"] ;
        error = [error errorByAddingUserInfoObject:profileNameReported
                                            forKey:@"Profile Name Reported"] ;
        error = [error errorByAddingUserInfoObject:profileNameExpected
                                            forKey:@"Profile Name Expected"] ;
        *error_p = error ;
    }
    
    [profileNameReported release] ;
    
    return answer ;
}

- (NSSet*)loadedProfilesRunningOurSyncExtension {
    NSMutableSet* loadedProfiles = [[NSMutableSet alloc] init] ;
    NSSet* profiles = [[self class] profilesThisHomeWithInstalledOurExtensionIndex:1] ;
    for (NSString* profile in profiles) {
        NSError* error = nil ;
        if ([[self class] messengerIsAliveForProfileName:profile
                                                 error_p:&error]) {
            [loadedProfiles addObject:profile] ;
        }
        if (error) {
            error = [error errorByAddingUserInfoObject:profile
                                                forKey:@"Tested Profile"] ;
            NSLog(@"Internal Error 624-8581 %@", error) ;
        }
    }
    
    NSSet* answer = [loadedProfiles copy] ;
    [loadedProfiles release] ;
    [answer autorelease] ;
    
    return answer ;
}

- (BOOL)profileIsLoadedIfOwnerAppRunningError_p:(NSError**)error_p {
    NSString* expectedProfile = [self.clientoid profileName] ;
    NSSet* loadedProfiles = [self loadedProfilesRunningOurSyncExtension] ;
    BOOL answer = ([loadedProfiles member:expectedProfile] != nil) ;
    return answer ;
}

+ (NSString*)frontmostProfileInOwnerApp {
    NSDictionary* profileDic = [self profileDicForHomePath:nil
                                                   timeout:2.0] ;
    NSString* answer = [profileDic objectForKey:constKeyLastUsed] ;
    if (![answer isKindOfClass:[NSString class]]) {
        answer = nil ;
    }
    
    return answer ;
}

- (BOOL)toleratesClientTask:(BkmxClientTask)clientTask {
	BkmxIxportTolerance toleranceRequired ;
	BkmxIxportTolerance toleranceAvailable ;
	switch (clientTask) {
		case BkmxClientTaskRead:
			toleranceAvailable = [self ixportTolerance] ;
			toleranceRequired = BkmxIxportToleranceAllowsReading ;
			break;
		case BkmxClientTaskWrite:
			toleranceAvailable = [self ixportTolerance] ;
			// Eeek.  The following assigned BkmxIxportToleranceAllowsReading!
			// This caused Opera and others to be written to while they were running,
			// which was wrong.  Bug fixed in BookMacster 1.9.8.
			toleranceRequired = BkmxIxportToleranceAllowsWriting ;
			break;
		case BkmxClientTaskInstall:
		default:
			// toleranceAvailable was uninitialized in this case until BookMacster 1.9.5
			// It worked as expected in Debug build, but not in Release build!!
			toleranceAvailable = BkmxIxportToleranceAllowsNone ;
			toleranceRequired = BkmxIxportToleranceAllowsInstallingAddOn ;
			break;
	}
	
	BOOL canDo = ((toleranceAvailable & toleranceRequired) > 0) ;
	
#if 0
    NSLog(@"EC: Chrome %@: tolerates %@ task %@ using style %ld",
          [self.clientoid profileName],
          canDo ? @"YES" : @"NO",
          (((clientTask!=1)&&(clientTask!=2)&&(clientTask!=4)) ? @"ERR1" : ((clientTask==1) ? @"READ" : ((clientTask==2) ? @"WRIT" : @"INST"))),
          self.ixportStyle
          ) ;
#endif
    
    return canDo ;
}

- (BOOL)shouldBlindSawChangeTriggerDuringExport {
	// Because of the 10-second delay in the extension before the
	// Changes/Detected/*.json file is touched, it wouldn't do any good.
	// Also, since Chrome is multithreaded, user may be able to
	// change bookmarks during an export operation.
	// Also, user could change bookmarks during that 10 seconds.
	return NO ;
}

- (SEL)reformatStarkToExtore {
	return @selector(extoreItemStyle1ForChromeExtore:) ;
}

- (void)writeUsingStyle2InOperation:(SSYOperation*)operation {
 	[self exportJsonViaIpcForOperation:operation] ;
}

- (id)tweakedValueFromStark:(Stark*)stark
					 forKey:(NSString*)key {
	id tweakedValue = [stark valueForKey:key] ;
	
	if ([key isEqualToString:constKeyName]) {
		tweakedValue = [stark name] ;
        
        // Change nonbreaking spaces to regular spaces
		if ([tweakedValue containsString:constNonbreakingSpace]) {
			NSMutableString* mutant = [tweakedValue mutableCopy] ;
			[mutant replaceOccurrencesOfString:constNonbreakingSpace
									withString:@" "] ;
			tweakedValue = [NSString stringWithString:mutant] ;
			[mutant release] ;
		}

        // Collapse consecutive spaces into one sopace
		tweakedValue = [tweakedValue stringByCollapsingConsecutiveSpaces] ;
    } else if ([key isEqualToString:constKeyUrl]) {
        tweakedValue = [stark url] ;
        NSMutableCharacterSet* characterSet = [[NSMutableCharacterSet alloc] init];
        [characterSet addCharactersInString:@"-._~"];
        [characterSet addCharactersInRange:NSMakeRange(0x0080, 0xffff - 0x0080)];
        tweakedValue = [tweakedValue decodeOnlyPercentEscapesInUnicodeSet:characterSet
                                                       uppercaseAnyOthers:NO
                                                  resolveDoubleDotsInPath:YES];
        [characterSet release];
    }
	
    return tweakedValue ;
}

- (void)registerHighExidFromItem:(NSDictionary*)item {
    NSInteger exidValue = [[item valueForKey:@"id"] integerValue] ;
    m_highestUsedId = MAX(m_highestUsedId, exidValue) ;
}

- (BOOL)extractHartainersFromExtoreTree:(NSDictionary*)treeIn
                                  bar_p:(NSDictionary* _Nonnull * _Nonnull)bar_p
                                 menu_p:(NSDictionary* _Nonnull * _Nonnull)menu_p
                              unfiled_p:(NSDictionary* _Nonnull * _Nonnull)unfiled_p
                               ohared_p:(NSDictionary* _Nonnull * _Nonnull)ohared_p
                                error_p:(NSError**)error_p {
    NSAssert(NO, @"Subclass must implement") ;
    return NO ;
}


- (void)rememberNameFromNode:(NSDictionary*)node
             defaultSelector:(SEL)selector
                  rememberAs:(NSString*)key {
    /* When the JSON is read from the file (Style 1), name's key is "name",
     but when it's read from the Chrome Extension Bookmarks API (Style 2), this
     key is "title".  We handle either case here… */
    NSString* name = [node objectForKey:@"name"] ;
    if (!name) {
        name = [node objectForKey:@"title"] ;
    }

    /* Defensive programming in case of corrupt Bookmarks file */
    if (!name) {
        name = [[self class] performSelector:selector] ;
    }

    [[self fileProperties] setObject:name
                              forKey:key] ;

}

- (BOOL)makeStarksFromExtoreTree:(NSDictionary*)treeIn
                         error_p:(NSError **)error_p {
	BOOL ok = YES ;
    NSError* error = nil ;
	
    NSDictionary* extoreBar ;
    NSDictionary* extoreMenu ;
    NSDictionary* extoreUnfiled ;
    NSDictionary* extoreOhared ;
    
    ok = [self extractHartainersFromExtoreTree:treeIn
                                         bar_p:&extoreBar
                                        menu_p:&extoreMenu
                                     unfiled_p:&extoreUnfiled
                                      ohared_p:&extoreOhared
                                       error_p:&error] ;

	if (ok) {
        [self rememberNameFromNode:extoreBar
                   defaultSelector:@selector(labelBar)
                        rememberAs:constKeyExtoreLabelOfBar] ;
        [self rememberNameFromNode:extoreMenu
                   defaultSelector:@selector(labelMenu)
                        rememberAs:constKeyExtoreLabelOfMenu] ;
        [self rememberNameFromNode:extoreUnfiled
                   defaultSelector:@selector(labelUnfiled)
                        rememberAs:constKeyExtoreLabelOfUnfiled] ;
        [self rememberNameFromNode:extoreOhared
                   defaultSelector:@selector(labelOhared)
                        rememberAs:constKeyExtoreLabelOfOhared] ;
        
        // Create a transformer which we will use to create our collections from Chrome/ium's
        SSYTreeTransformer* transformer = [SSYTreeTransformer
                                           treeTransformerWithReformatter:@selector(modelAsStarkInStartainer:)
                                           childrenInExtractor:@selector(childrenWithLowercaseC)
                                           newParentMover:@selector(moveToBkmxParent:)
                                           contextObject:self] ;

        self.menuWasOnDisk = extoreMenu != nil;

        Stark* rootOut = [[self starker] freshStark] ;
        /* Name of root must match, I think, that assigned in
         -registerBasicsFromStark:, to ensure that hashes will match. */
        [rootOut setName:[NSString localize:@"lineageRoot"]];
        Stark* barOut = [transformer copyDeepTransformOf:extoreBar] ;
        Stark* menuOut = nil;
        /* The following condition is for the benefit of ExtoreVivaldi,
         which is the only derivative of this class for which
         [self hasMenu] returns NO. */
        if ([self hasMenu]) {
            menuOut = [transformer copyDeepTransformOf:extoreMenu];
        }
        Stark* unfiledOut = [transformer copyDeepTransformOf:extoreUnfiled] ;
        Stark* oharedOut = [transformer copyDeepTransformOf:extoreOhared] ;
        
        // Set instance variables
        [rootOut assembleAsTreeWithBar:barOut
                                  menu:menuOut
                               unfiled:unfiledOut
                                ohared:oharedOut];
        
        [barOut release] ;
        [menuOut release] ;
        [unfiledOut release] ;
        [oharedOut release] ;
    }
    
    if (error && error_p) {
        NSString* s ;
        s = [NSString stringWithFormat:
             @"Could not decode bookmarks from %@.",
             [self displayName]] ;
        error = [SSYMakeError(295881, s) errorByAddingUnderlyingError:error] ;
        s = [NSString stringWithFormat:
             @"Activate %@ and check out its bookmarks.  Reset if corrupt.",
             [self displayName]] ;
        error = [error errorByAddingLocalizedRecoverySuggestion:s] ;
        *error_p = error ;
    }

	return ok ;
}

- (void)getFreshExid_p:(NSString**)exid_p
            higherThan:(NSInteger)higherThan
              forStark:(Stark*)stark
               tryHard:(BOOL)tryHard {
	NSInteger nextValue = MAX(m_highestUsedId, higherThan) + 1 ;
	m_highestUsedId = nextValue ;
	*exid_p = [NSString stringWithFormat:@"%ld", (long)nextValue] ;
}

- (BOOL)isExportableStark:(Stark*)stark
			   withChange:(NSDictionary*)change {
#if IS_EXPORTABLE_STARK_WILL_ALWAYS_RETURN_YES
	return YES  ;
#endif
    
    // Added in BookMacster 1.17.  See Note 20120827 in Extore.m
    if ([[stark url] isSmartSearchUrl]) {
        return NO ;
    }
	
	if (![super isExportableStark:stark
					   withChange:change]) {
		return NO ;
	}
	
	// Any sharype which cannot have a URL, such as folders, are OK.
	if (![stark canHaveUrl]) {
		return YES ;
	}
	
	// Chromy does not support Smart Bookmarks
	if ([stark sharypeValue] == SharypeSmart) {
		return NO ;
	}
	
	if ([stark is1PasswordBookmarklet]) {
		return NO ;
	}
    
    /* Although it accepts invalid URLs in general (so we cannot use
     NSURL or NSURLComponents for the following), Chrome will
     silently reject any bookmark whose URL does not begin with a
     scheme, or with javascript:. */
    if (![stark.url hasPrefix:@"javascript:"]) {
        BOOL goodScheme = YES;
        NSScanner* scanner = [[NSScanner alloc] initWithString:stark.url];
        NSString* schemePrefix = nil;
        NSInteger n = [scanner scanUpToString:@"://"
                                   intoString:&schemePrefix];
        if ((n<1) || [scanner isAtEnd]) {
            goodScheme = NO;
        }
        else {
            /* Scheme must end in :// */
            BOOL ok = [scanner scanString:@"://"
                               intoString:NULL];
            if (!ok) {
                goodScheme = NO;
            } else {
                /* This branch added 2021-07-15. */
                NSCharacterSet* goodSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz0123456789+-."];
                /* By doing some experimenting, I determined that only the
                 characters in goodSet will be accepted unaltered by Chrome.
                 Results for other characters vary.  Some anecdotal observations
                 caused by editing URLs in Chrome's Edit Bookmarks tab:
                 Example 1. Uppercase ASCII characters are changed to lowercase.
                 Example 2.   Most punctuation characters will cause the whole
                 scheme to be prefixed by a *new* http:// and the offending
                 punctuation character will be percent escape encoded.
                 Example 3.  % ; or / characters will cause "invalid URL" to be
                 displayed.
                 
                 Furthermore, in that last case, exporting a bookmark with a
                 "%" in the scheme will cause the bookmark to not appear in Chrome.
                 
                 I presume that the tests I did in Chrome's Edit Bookmarks
                 correlate to the export rejections.
                 */
                for (NSInteger i=0; i<schemePrefix.length; i++) {
                    unichar aChar = [schemePrefix characterAtIndex:i];
                    if (![goodSet characterIsMember:aChar]) {
                        goodScheme = NO;
                        break;
                    }
                }
                
                if (goodScheme) {
                    /* A scheme beginning with a decimal digit will also cause the
                     the scheme to be prefixed with http://, as in Example 2 above.
                     */
                    unichar firstChar = [schemePrefix characterAtIndex:0];
                    if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:firstChar]) {
                        goodScheme = NO;
                    }
                }
            }
        }
        [scanner release];
        if (goodScheme == NO) {
            return NO;
        }
    }
    
    /* 2019-01-10: Exporting a bookmark with empty URL to Google Chrome or
     Opera will result in an empty folder, which will cause churn in addition
     to being just wrong. */
    if ([stark sharypeValue] == SharypeBookmark) {
        if ([stark.url length] == 0) {
            return NO;
        }
    }
    
	return YES ;
}

- (NSString*)resourcePathForExtensionIndex:(NSInteger)extensionIndex
                        ownerAppBundlePath:(NSString*)bundlePath
                                   error_p:(NSError**)error_p {
	NSError* error = nil ;
    NSString* resourceName ;
    switch (extensionIndex) {
        case 1:
            resourceName = @"BookMacsterSync" ;
            break ;
        case 2:
            resourceName = @"BookMacsterButton" ;
            break ;
        default:
            NSLog(@"Internal Error 624-9290 %ld", (long)extensionIndex) ;
            resourceName = nil ;
    }

	NSString* const resourceExtension = constFilenameExtensionCrx ;
	NSString* path = [[NSBundle mainAppBundle] pathForResource:resourceName
													 ofType:resourceExtension] ;
	if (!path) {
		NSString* msg = [NSString stringWithFormat:
						 @"Missing Resource %@.%@",
						 resourceName,
						 resourceExtension] ;
		error = SSYMakeError(904517, msg) ;
	}
	
	if (error && error_p) {
		*error_p = error ;
	}
	
	return path ;
}

- (NSTimeInterval)exportFeedbackTimeoutPerChange {
    /*
     2820 changes on my 2009 Mac Mini took 15 seconds from Google Chrome
     That would be 15/2820 = .005.  So far, I've received only one error
     report with the setting .05, user Michael Scotti on 20081112.  At
     the time, error reports were not showing the timer's time interval,
     so I don't know what that is.  He never followed up with more info.
     May have been a fluke, Chrome crash.  Just leave it at .05 for now.
     
     Update 20131114.  I've received a few more error reports now, including
     one today from user Jonathan Glassner that reported:
     nCuts = 1;
     nPuts = 183;
     nRepairs = 182;
     secsPer = "0.05";
     timeout = "18.3";
     I tri such a change myself, with 1500 bookmarks pre-existing,
     and it took 7 seconds.  That's oh 40% of the limit.  So, for
     BookMacster 1.19.6, I'm incresing this from .05 to .10.
     */
	return .10 ;
}

+ (NSString*)uuidForExtensionIndex:(NSInteger)extensionIndex {
    NSString *uuid;
    switch (extensionIndex) {
        case -1:
            uuid = constChromyExtensionLegacyUuid ;
            break ;
        case 1:
            uuid = [self extension1Uuid] ;
            break ;
        case 2:
            uuid = [self extension2Uuid] ;
            break ;
        default:
            NSLog(@"Internal Error 624-0023 %ld", (long)extensionIndex) ;
            uuid = nil ;
    }
    
    return uuid ;
}

- (NSString*)fullPathForExtensionIndex:(NSInteger)extensionIndex {
	NSString* path = [[self clientoid] filePathParentError_p:NULL] ;
	path = [path stringByAppendingPathComponent:@"Extensions"] ;
    NSString* uuid = [[self class] uuidForExtensionIndex:extensionIndex] ;
	path = [path stringByAppendingPathComponent:uuid] ;
	
	return path ;
}

+ (NSString*)pathForThisHomeProfileName:(NSString*)profileName {
    NSAssert(NO, @"Subclass must implement") ;
    return nil ;
}

+ (NSString*)prefsPathForProfile:(NSString*)profileName
                        homePath:(NSString*)homePath
                         error_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
	NSString* filePathParent = [self pathForThisHomeProfileName:profileName] ;
	NSString* path = [filePathParent stringByAppendingPathComponent:constFilenameChromePreferences] ;
	
	if (!path) {
		ok = NO ;
		NSString* msg = [NSString stringWithFormat:
						 @"Could not get preferences path for %@ %@",
                         [self exformatForExtoreClass:self],
                         profileName]  ;
		error = SSYMakeError(252541, msg) ;
	}
	
	if (!ok && error_p) {
		*error_p = error ;
	}
	
	return path ;
}

+ (NSDictionary*)prefsForProfile:(NSString*)profileName
                        homePath:(NSString*)homePath
                         error_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
    NSString* errMsg ;
    NSDictionary* dic = nil ;
	
	NSString* path = [self prefsPathForProfile:profileName
                                      homePath:homePath
                                       error_p:&error] ;
	if (!path) {
		ok = NO ;
		goto end ;
	}
	
    NSData* jsonData = [NSData dataWithContentsOfFile:path];
    if (jsonData) {
        dic = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:BkmxBasis.optionsForNSJSON
                                                               error:&error];
    }
    
    if (!dic && [self profileStuffMayBeInstalledInParentFolder]) {
        path = [path stringByDeletingLastPathComponent];
        BOOL profileDirExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
        if (!profileDirExists) {
            path = [path stringByDeletingLastPathComponent];
            jsonData = [NSData dataWithContentsOfFile:path];
            dic = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:BkmxBasis.optionsForNSJSON
                                                                   error:&error];
        }
    }
    
    if (!dic) {
        ok = NO ;
        errMsg = [NSString stringWithFormat:
                  @"Could not read preferences for %@ %@ in %@",
                  [self exformatForExtoreClass:self],
                  profileName,
                  homePath]  ;
        error = [SSYMakeError(253005, errMsg) errorByAddingUnderlyingError:error] ;
        NSString* sugg = [NSString stringWithFormat:
                          @"Launch %@.  If you see a 'Users' menu, activate user %@.",
                          [self ownerAppDisplayName],
                          [[self class] displayProfileNameForProfileName:profileName]] ;
        error = [error errorByAddingLocalizedRecoverySuggestion:sugg] ;
        goto end ;
    }
	
end:
	if (!ok && error_p) {
		*error_p = error ;
	}

	return dic ;
}

- (NSDictionary*)prefsError_p:(NSError**)error_p {
    return [[self class] prefsForProfile:[self.clientoid profileName]
                                homePath:[self.clientoid homePath]
                                 error_p:error_p] ;
}

- (BOOL)isSyncActiveError_p:(NSError**)error_p {
    NSError* error = nil ;
    NSInteger errorCode = 0 ;
    NSDictionary* errorInfo = nil ;
    
    BOOL syncActive = NO ;
    
    NSDictionary* prefs = [self prefsError_p:&error] ;
    
    if (!prefs) {
        errorCode = 928093 ;
        goto end ;
    }
    
    NSDictionary* syncPrefs = [prefs objectForKey:@"sync"] ;
    if (!syncPrefs) {
        // This branch added in BookMacster 1.9.5.
        // This seems to happen if Google account has never been activated in Google Chrome.
        // For our purposes, it means that Google Chrome bookmarks sync is off.
        goto end ;
    }
    if (![syncPrefs isKindOfClass:[NSDictionary class]]) {
        errorCode = 156612 ;
        goto end ;
    }
    
    BOOL sync_hsc;
    BOOL sync_b;
    BOOL sync_kes;
    /* Case 1 and Case 2 occur as follows.  Of course this is ambiguous because
     I've only tested a few versions.  Results on 2024-04-09:

     Case 1a:
     • Chrome 123
     
     Case 1b:
     • Opera 106
     
     Case 2:
     • older verisons of Chrome
     • Edge 123 or earlier
     */

    NSDictionary* dTSFSTS = [syncPrefs objectForKey:@"data_type_status_for_sync_to_signin"];
    if (dTSFSTS  != nil) {
        // Case 1
        sync_kes = NO;
        id sync_hasSetupCompleted_object = [syncPrefs objectForKey:@"has_setup_completed"] ;
        if ([sync_hasSetupCompleted_object respondsToSelector:@selector(integerValue)]) {
            // Case 1a
            NSInteger hscInteger = [sync_hasSetupCompleted_object integerValue];
            sync_hsc = hscInteger > 0;
        } else if ([sync_hasSetupCompleted_object respondsToSelector:@selector(boolValue)]) {
            // Case 1b
            sync_hsc = [sync_hasSetupCompleted_object boolValue];
        } else {
            sync_hsc = NO;
        }

        id bookmarksObject = [dTSFSTS objectForKey:@"bookmarks"];
        if ([bookmarksObject respondsToSelector:@selector(integerValue)]) {
            // Case 1a
            NSInteger bookmarksInteger = [bookmarksObject integerValue];
            sync_b = bookmarksInteger > 0;
        } else if ([bookmarksObject respondsToSelector:@selector(boolValue)]) {
            // Case 1b
            sync_b = [bookmarksObject boolValue];
        } else {
            sync_hsc = NO;
        }

    } else {
        /* Case 2.
         The JSON "sync" prefs text being analyzed here typically looks e.g. like this:
         "sync": {
         "autofill": false,
         "bookmarks": false,
         "extensions": false,
         "has_setup_completed": true,
         "keep_everything_synced": false,
         "preferences": false,
         "suppress_start": false,
         "themes": false
         },
         */
        
        NSNumber* sync_hasSetupCompleted_object = [syncPrefs objectForKey:@"has_setup_completed"] ;
        NSNumber* sync_bookmarks_object = [syncPrefs objectForKey:@"bookmarks"] ;
        NSNumber* sync_keepEverythingSynced_object = [syncPrefs objectForKey:@"keep_everything_synced"] ;
        if (sync_hasSetupCompleted_object) {
            if (![sync_hasSetupCompleted_object respondsToSelector:@selector(boolValue)]) {
                errorCode = 156412 ;
                errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                             [sync_hasSetupCompleted_object className], @"Object Class",
                             sync_hasSetupCompleted_object, @"Object",
                             nil] ;
                goto end ;
            }
        }
        if (sync_bookmarks_object) {
            if (![sync_bookmarks_object respondsToSelector:@selector(boolValue)]) {
                errorCode = 156512 ;
                errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                             [sync_bookmarks_object className], @"Object Class",
                             sync_bookmarks_object, @"Object",
                             nil] ;
                goto end ;
            }
        }
        if (sync_keepEverythingSynced_object) {
            if (![sync_keepEverythingSynced_object respondsToSelector:@selector(boolValue)]) {
                errorCode = 156612 ;
                errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                             [sync_keepEverythingSynced_object className], @"Object Class",
                             sync_keepEverythingSynced_object, @"Object",
                             nil] ;
                goto end ;
            }
        }
        sync_hsc = [sync_hasSetupCompleted_object boolValue] ;
        sync_b = [sync_bookmarks_object boolValue] ;
        sync_kes = [sync_keepEverythingSynced_object boolValue] ;
    }

    // The rather redundant logic here *is* necessary to properly decode all
    // possible cases.  Ask the Chrome Team why they made it so complicated…
    syncActive = sync_hsc && (sync_b || sync_kes) ;
    
end:
    if ((errorCode != 0) && error_p) {
        NSString* genericErrorDescription = @"Error trying to determine whether or not Chrome Sync is active" ;
        if (errorInfo) {
            errorInfo = [errorInfo dictionaryBySettingValue:genericErrorDescription
                                                     forKey:NSLocalizedDescriptionKey] ;
        }
        else {
            errorInfo = [NSDictionary dictionaryWithObject:genericErrorDescription
                                                    forKey:NSLocalizedDescriptionKey] ;
        }
        error = [[NSError errorWithDomain:[NSError myDomain]
                                     code:errorCode
                                 userInfo:errorInfo] errorByAddingUnderlyingError:error] ;
        *error_p = error ;
    }
    
    return syncActive ;
}

- (NSString*)ownerAppSyncServiceDisplayName {
    return @"Google Account" ;
}

- (NSTimeInterval)waitTimeForBuiltInSyncAfterLaunch {
    // Pass NULL for &error in the following since this is only to cover the
    // edge case when bookmarks need to be synced in from the Google Account
    // immediately after the browser is launched.  We didn't do this at all
    // until BookMacster 1.19.6, and no one complained.
    // Also, if this error is persistent it will occur elsewhere.
    NSTimeInterval waitTime = [self isSyncActiveError_p:NULL] ? 6.0 : 0.0 ;
    
    return waitTime ;
}

+ (NSArray*)keyPathInPrefsToExtensionIndex:(NSInteger)extensionIndex {
    NSString* uuid ;
    uuid = [self uuidForExtensionIndex:extensionIndex];
	return [NSArray arrayWithObjects:
			@"extensions",
			@"settings",
			uuid,
			nil] ;
}

+ (BOOL)setPrefs:(NSDictionary*)prefs
         profile:(NSString*)profileName
        homePath:(NSString*)homePath
        error_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
	
	NSString* prefsString = [prefs jsonStringValue] ;
	
	if (!prefsString) {
		ok = NO ;
		NSString* msg = [NSString stringWithFormat:
						 @"Could not jsonify prefs for %@ %@ in %@",
                         [self exformatForExtoreClass:self],
                         profileName,
						 homePath]  ;
		error = [SSYMakeError(687564, msg) errorByAddingUnderlyingError:error]  ;
		error = [error errorByAddingUserInfoObject:prefs
											forKey:@"Dictionary"] ;
	}
	
	NSString* path = nil ;
    if (ok) {
        path = [[self class] prefsPathForProfile:profileName
                                        homePath:homePath
                                         error_p:&error] ;
        if (!path) {
            ok = NO ;
            NSString* msg = [NSString stringWithFormat:
                             @"No prefs path for %@ %@ in %@",
                             [self exformatForExtoreClass:self],
                             profileName,
                             homePath]  ;
            error = [SSYMakeError(203694, msg) errorByAddingUnderlyingError:error]  ;
        }
        if (
            ok
            && ![[NSFileManager defaultManager] fileExistsAtPath:path]
            && [self profileStuffMayBeInstalledInParentFolder]
            ) {
            path = [path pathByDeletingLastNPathComponent:2];
            /* Now see if it was found at that alternative path */
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                /* Probably this should never happen.  We need to create
                 a prefs file from scratch, eeeek.  Go back to the original
                 path since it is more likely to be correct. */
                path = [[self class] prefsPathForProfile:profileName
                                                homePath:homePath
                                                 error_p:&error] ;
            }
        }
    }

	if (ok) {
        ok = [prefsString writeToFile:path
                           atomically:YES
                             encoding:NSUTF8StringEncoding
                                error:&error] ;
    }
    
	if (error && error_p) {
		*error_p = error ;
	}
	
	return ok ;
}

+ (BOOL)setPrefsValue:(id)value
      forKeyPathArray:(NSArray*)keyPathArray
              profile:(NSString*)profileName
             homePath:(NSString*)homePath
              error_p:(NSError**)error_p {
    BOOL ok = YES ;
    NSError* error = nil ;
    NSDictionary* prefsIn = nil ;
    prefsIn = [self prefsForProfile:profileName
                           homePath:homePath
                            error_p:&error] ;
    if (!prefsIn) {
        ok = NO ;
    }
    
    if (ok) {
        NSMutableDictionary* prefs = [prefsIn mutableCopy] ;
        [prefs setValue:value
        forKeyPathArray:keyPathArray] ;
        ok = [[self class] setPrefs:prefs
                            profile:profileName
                           homePath:homePath
                            error_p:&error] ;
        [prefs release] ;
    }
    
    if (error && error_p) {
        *error_p = error ;
    }
    
    return ok ;
}

/*!
 @details  Of the two things done by this method, removing the "bits", that is,
 the subdirectory containing our extension downloaded from the Chrome Web
 Store, is the least important.  Removing the reference from the Preferences
 file is the most important.  If you remove the Bits without removing the
 Pref, this is very bad because Chrome will act as though the extension is
 already installed if you visit the store, and not let you reinstall it,
 even though it does not work.  But if you remove the Pref and leave the Bits,
 the extension will be unworking and indicated as not installed, so it can be
 readily re-installed from the store. */
- (void)removeExtensionBitsAndPrefForIndex:(NSInteger)extensionIndex {
    BOOL ok = YES ;
    NSError* error = nil ;

    // Part 1.  Remove Pref
    NSArray* keyPathArray = [[self class] keyPathInPrefsToExtensionIndex:extensionIndex] ;
    ok = [[self class] setPrefsValue:nil
                     forKeyPathArray:keyPathArray
                             profile:[self.clientoid profileName]
                            homePath:[self.clientoid homePath]
                             error_p:&error] ;
    
    if (!ok) {
        NSLog(@"Internal Error 669-5426 %ld %@", extensionIndex, error) ;
    }
    
    // Part 2.  Remove Bits
    if (ok) {
        NSString* doomedPath = [[self class] pathForThisHomeProfileName:[[self client] profileName]] ;
        doomedPath = [doomedPath stringByAppendingPathComponent:@"Extensions"] ;
        doomedPath = [doomedPath stringByAppendingPathComponent:[[self class] uuidForExtensionIndex:extensionIndex]] ;
        /* The following will expectedly return NO if the target extension is
         not installed, so we ignore the return value. */
        [[NSFileManager defaultManager] removeItemAtPath:doomedPath
                                                   error:&error] ;
        if ([[self class] profileStuffMayBeInstalledInParentFolder]) {
            doomedPath = [doomedPath pathByDeletingLastNPathComponent:3];
            [[NSFileManager defaultManager] removeItemAtPath:doomedPath
                                                       error:&error];
        }
    }
}

+ (NSString*)extension1Uuid {
    /* For version packaged by Chrome Web Store */
    return @"lagihdefccpmghlnagdlhhnpboepofhm" ;
}

+ (NSString*)extension2Uuid {
    /* For version packaged by Chrome Web Store */
    return @"ogbifncndomfnlmdkkgnjkmdjpjdhmge" ;
}

+ (NSURL*)sourceUrlForExtensionIndex:(NSInteger)extensionIndex {
    NSURL* url ;
    switch (extensionIndex) {
        case 1:
            url = [NSURL URLWithString:@"https://chrome.google.com/webstore/detail/bookmacster-sync/lagihdefccpmghlnagdlhhnpboepofhm"] ;
            break ;
        case 2:
            url = [NSURL URLWithString:@"https://chrome.google.com/webstore/detail/bookmacster-button/ogbifncndomfnlmdkkgnjkmdjpjdhmge"] ;
            break ;
        default:
            url = nil ;
    }
    
    return url ;
}

- (NSString*)messageHowToForceAutoUpdateExtensionIndex:(NSInteger)extensionIndex {
    return NSLocalizedString(
                             @"• Click in the main menu > Window > Extensions."
                             @"\n• In the new tab, switch on the checkbox ‘Developer mode’."
                             @"\n• Click the button titled ‘Update Extensions now’."
                             @"\n• Verify that our updated extension is *enabled*.", nil);
}

- (NSInteger)extensionVersionForExtensionIndex:(NSInteger)extensionIndex {
    if ([[NSApp delegate] respondsToSelector:@selector(relaxedExtensionDetection)]) {
        if (((BkmxAppDel*)[NSApp delegate]).relaxedExtensionDetection) {
            return 999;
        }
    } else {
        // We are in BkmxAgent
    }
    
    NSInteger extensionVersion = 0;
    NSString* profileName = [self.clientoid profileName] ;
    if (!profileName) {
        // Owner app does not support multiple profiles
        profileName = [[self class] defaultProfileName];
    }
    NSString* path = [[self class] pathForThisHomeProfileName:profileName];
    path = [path stringByAppendingPathComponent:@"Extensions"];
    NSString* extensionUuid = nil;
    switch(extensionIndex) {
        case 1:
            extensionUuid = [[self class] extension1Uuid];
            break;
        case 2:
            extensionUuid = [[self class] extension2Uuid];
            break;
        default:
            break;
    }
    path = [path stringByAppendingPathComponent:extensionUuid];
    NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                            error:NULL];
    if ((contents.count < 1) && [[self class] profileStuffMayBeInstalledInParentFolder]){
        path = [path pathByDeletingLastNPathComponent:2];
        contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                       error:NULL];
    }
    
    for (NSString* name in contents) {
        NSString* aPath = [path stringByAppendingPathComponent:name];
        BOOL isDirectory = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:aPath
                                             isDirectory:&isDirectory];
        if (isDirectory) {
            /* Case 1.  Most browsers install our extension into a subfolder
             whose name is a representation of its version number.  If that
             is the case, this branch will execute and we don't need to
             read a plist file.
             
            Assuming integer version numbers as I use, `name` will be
             <integer-version-number>_0, for example: "24_0".
             -[NSString integerValue] will return the first integer, 24
             in our example. */
            extensionVersion = [name integerValue];
            if (extensionVersion > 0) {
                break;
            }
        } else if ([name isEqualToString:@"manifest.json"]) {
            /* Case 2.  But when I added support for Orion, I found that Orion
             does not use this version-named subfolder, but instead
             the extension's files appear directly inside the extensions's
             folder.  In this case, we look for the manifest file (which
             we apparently just found) and decde it*/
            NSData* data = [NSData dataWithContentsOfFile:aPath];
            NSDictionary* manifest = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:0
                                                                       error:NULL];
            if ([manifest respondsToSelector:@selector(objectForKey:)]) {
                NSString* versionString = [(NSDictionary*)manifest objectForKey:@"version"];
                if ([versionString respondsToSelector:@selector(integerValue)]) {
                    extensionVersion = [(NSString*)versionString integerValue];
                    break;
                }
            }
        }
    }

    return extensionVersion ;
}

+ (NSSet*)allProfilesThisHome {
    ProfileInfoCache* profileInfoCache = [self profileInfoCache] ;
    NSArray* names = [[profileInfoCache displayProfileNames] allKeys] ;
    NSSet* set = [NSSet setWithArray:names] ;

    return set ;
}

+ (NSSet*)profilesThisHomeWithInstalledOurExtensionIndex:(NSInteger)extensionIndex {
    NSSet* profiles = [self allProfilesThisHome] ;
    NSMutableSet* filteredProfiles = [[NSMutableSet alloc] init] ;
    for (NSString* profile in profiles) {
        [filteredProfiles addObject:profile] ;
    }
    
    NSSet* answer = [[filteredProfiles copy] autorelease] ;
    [filteredProfiles release] ;
    
    return answer ;
}

- (NSString*)launchOwnerAppPath:(NSString*)path
					   activate:(BOOL)activate
                        error_p:(NSError**)error_p {
    
    BOOL ok ;
    NSError* error = nil ;
    NSString* homePath = [self.clientoid homePath] ;
    NSString* errDesc ;
    
	if (!path) {
		path = [self ownerAppLocalPath] ;
	}
	
    ok = [self quitOwnerAppWithTimeout:10.0
                         preferredPath:nil
                      killAfterTimeout:YES
                          wasRunning_p:NULL
                         pathQuilled_p:NULL
                               error_p:&error] ;
    if (!ok) {
        errDesc = [NSString stringWithFormat:
                   @"Could not quit %@",
                   [self displayName]] ;
        error = [SSYMakeError(883413, errDesc) errorByAddingUnderlyingError:error] ;
        goto end ;
    }
    
    /* Our next task is to ensure that the "last used" profile in the Chrome
     preferences is our profile, so that when we relaunch Chrome, it will
     relaunch into our profile. */
    
    NSDictionary* localStateDic = [[self class] localStateDicOnceForHomePath:homePath] ;
    if (!localStateDic) {
        // No error, because this might be expected if the owner app client
        // had never been used
        localStateDic = [NSDictionary dictionary] ;
    }

    NSDictionary* profileDic = [localStateDic objectForKey:constKeyProfile] ;
    if (!profileDic) {
        // No error, because this might be expected if the owner app client
        // had never been used
        profileDic = [NSDictionary dictionary] ;
    }
    
    NSString* lastUsedProfile = [profileDic objectForKey:constKeyLastUsed] ;
    NSString* profile = self.clientoid.profileName;
    if ([lastUsedProfile isKindOfClass:[NSString class]]) {
        BOOL didFixDic = NO ;
        /* The following if(profile) guard was added to the code after user
         Zettti in forum reported the exception which is noted below.
         This could maybe happen if client was created prior to
         BookMacster 1.13.2. */
        if (profile) {
            /* To ensure that our profile is the "last used", we must
             ensure two Requirements 1 and 2 in the profileDic */
            
            /* Requirement 1.  Our profile must be the "last used" value. */
            if (![profile isEqualToString:lastUsedProfile]) {
                profileDic = [profileDic dictionaryBySettingValue:profile
                                                           forKey:constKeyLastUsed] ;
                didFixDic = YES ;
            }
            
            /* Requirement 2.  Our profile must be among the "last active". */
            NSArray* lastActiveProfiles = [profileDic objectForKey:constKeyLastActiveProfiles] ;
            if (lastActiveProfiles) {
                if (![lastActiveProfiles isKindOfClass:[NSArray class]]) {
                    /* Whoops, Google must have changed something.  Log and
                     continue, hoping for the best. */
                    NSString* description = [lastActiveProfiles description] ;
                    NSInteger length = description.length ;
                    if (length > 255) {
                        description = [description substringToIndex:255] ;
                    }
                    NSLog(
                          @"Warning 883-3555 Expected array for %@ in %@, found %@",
                          constKeyLastActiveProfiles,
                          [self displayName],
                          description) ;
                }
            }
            else {
                lastActiveProfiles = [NSArray array] ;
            }
            if ([lastActiveProfiles indexOfObject:profile] == NSNotFound) {
                lastActiveProfiles = [lastActiveProfiles arrayByAddingObject:profile] ;
                profileDic = [profileDic dictionaryBySettingValue:lastActiveProfiles
                                                           forKey:constKeyLastActiveProfiles] ;
                didFixDic = YES ;
            }
        }
        
        if (didFixDic) {
            localStateDic = [localStateDic dictionaryBySettingValue:profileDic
                                                             forKey:constKeyProfile] ;
            NSString* jsonString = [localStateDic jsonStringValue] ;
            NSString* localStateFilePath = [[self class] localStateFilePathForHomePath:homePath] ;
            BOOL ok = [[NSFileManager defaultManager] createDirectoryAtPath:[localStateFilePath stringByDeletingLastPathComponent]
                                                withIntermediateDirectories:YES
                                                                 attributes:nil
                                                                      error:&error] ;
            if (!ok) {
                errDesc = [NSString stringWithFormat:@"Could not switch %@ into profile %@",
                           [self displayName],
                           profile] ;
                error = [SSYMakeError(883556, errDesc) errorByAddingUnderlyingError:error] ;
                goto end ;
            }
            
            ok = [jsonString writeToFile:localStateFilePath
                              atomically:YES
                                encoding:NSUTF8StringEncoding
                                   error:&error] ;
            if (!ok) {
                errDesc = [NSString stringWithFormat:@"Could not rewrite profile for %@ as %@",
                           [self displayName],
                           profile] ;
                error = [SSYMakeError(883557, errDesc) errorByAddingUnderlyingError:error] ;
                goto end ;
            }
            
        }
    }
    
	ok = [SSYOtherApper launchApplicationPath:path
                                     activate:activate
                                hideGuardTime:2.0
                                      error_p:&error] ;
    if (!ok) {
        errDesc = [NSString stringWithFormat:@"Could not launch %@ into profile %@ at path %@",
                   [self displayName],
                   profile,
                   path] ;
        error = [SSYMakeError(883558, errDesc) errorByAddingUnderlyingError:error] ;
        goto end ;
    }
    
end:
    if (error && error_p) {
        *error_p = error ;
    }
    
    return path ;
}

- (NSString *)extracted:(NSString *)displayName {
    NSString* title = [NSString stringWithFormat:
                       @"Warning : %@ Syncing",
                       displayName] ;
    return title;
}

- (void)prepareBrowserForExportWithInfo:(NSMutableDictionary*)info {
    BOOL ok = YES ;
	NSError* error = nil ;
    
    BOOL syncActive = [self isSyncActiveError_p:&error] ;
	if (syncActive) {
        // Maybe warn the user about conficts with browser's sync
 		BOOL secondPrep = [[info objectForKey:constKeySecondPrep] boolValue] ;
		if (secondPrep) {
            if ([[self.clientoid  extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
                if (![[self client] dontWarnOwnerSync]) {
                    SEL dontWarnOwnerSyncSelector = @selector(didEndDontWarnOwnerSyncSheet:returnCode:contextInfo:) ;
                    SEL runSheetSelector = @selector(runModalSheetAlert:resizeable:iconStyle:modalDelegate:didEndSelector:contextInfo:) ;
                    
                    if (!error) {
                        if (syncActive) {
                            SSYAlert* alert = [SSYAlert alert] ;
                            NSString* displayName = [self displayName] ;
                            NSString * title = [self extracted:displayName];
                            [alert setTitleText:title] ;
                            NSString* msg = [NSString stringWithFormat:
                                             @"It appears that your %@ is signed in to %@, which is syncing your bookmarks to %@ on other devices.\n\n"
                                             @"That is OK, provided that you have not created a Sync Loop.  Click the '?' Help button below to learn about Sync Loops.",
                                             displayName,
                                             [self ownerAppSyncServiceDisplayName],
                                             displayName] ;
                            
                            Client* client = [self client] ;
                            // Next lines to fix crash in BookMacster 1.13.2
                            // If this is a One Time Export, the checkbox for future is
                            // not applicable.  Furthermore, it will case a Core Data
                            // Could Not Fulfill a Fault error because it will be
                            // celeted by the time the checkbox result is known
                            // and attempted to be set into the data model.
                            if ([[info objectForKey:constKeyClientShouldSelfDestruct] boolValue] != YES) {
                                // Client is permanent
                                [alert setCheckboxTitle:[@"I know I don't have a Sync Loop and shall not create one.  " stringByAppendingString:[NSString localize:@"dontShowAdvisoryAgain"]]] ;
                            }
                            else {
                                // Client is temporary, for One Time Export
                                // No isDoneSelector needed in Chrome Sync warning sheet
                                client = nil ;
                                dontWarnOwnerSyncSelector = NULL ;
                            }
                            
                            [alert setSmallText:msg] ;
                            [alert setHelpAddress:constHelpAnchorSyncLoop] ;
                            [alert setRightColumnMaximumWidth:360.0] ;
                            NSInteger iconStyle = SSYAlertIconInformational ;
                            BOOL no = NO;
                            NSInvocation* invocation = [NSInvocation invocationWithTarget:[info objectForKey:constKeyDocument]
                                                                                 selector:runSheetSelector
                                                                          retainArguments:YES
                                                                        argumentAddresses:
                                                        &alert,
                                                        &no,
                                                        &iconStyle,
                                                        &client,
                                                        &dontWarnOwnerSyncSelector,
                                                        NULL] ; // contextInfo
                            [info addObject:invocation
                               toArrayAtKey:constKeyMoreDoneInvocations] ;
                        }
                    }
                    else {
                        ok = NO ;
                    }
                }
            }
        }
    }
    
	[info setObject:[NSNumber numberWithBool:ok]
			 forKey:constKeySucceeded] ;
	[self sendIsDoneMessageFromInfo:info] ;
    
    /* We need to get this before feedbackPreWrite, which will create new
     exids for any items which don't have exids, so that any "id" values in
     ignored branches be accounted for in m_highestUsedId, and thus prevent any
     new items we have from duplicating any exids in ignored branches. */
    NSDictionary* ignoredBranchesInRoot = [self ignoredBranchesInRootFromDisk] ;
    if ([ignoredBranchesInRoot respondsToSelector:@selector(objectForKey:)]) {
        NSDictionary* ignoredSyncedBranch = [ignoredBranchesInRoot objectForKey:@"synced"] ;
        if ([ignoredSyncedBranch isKindOfClass:[NSDictionary class]]) {
            [ignoredSyncedBranch recursivelyPerformOnChildrenLowerSelector:@selector(registerHighExidForExtore:)
                                                                withObject:self] ;
            [self setIgnoredBranchesInRoot:ignoredBranchesInRoot] ;
        }
        else {
            /* Set an empty dictionary so that, for efficiency and consistency,
             this `else` branch will only execute in prepareBrowserForExport1,
             not prepareBrowserForExport2. */
            NSLog(@"Warning 215-0034") ;
            [self setIgnoredBranchesInRoot:[NSDictionary dictionary]] ;
        }
    }
    
    if (error) {
        self.error = error ;
    }
}

- (NSString*)messagePleaseActivateThisProfile {
    return [NSString stringWithFormat:
            @"You have %ld 'Person' profiles in %@."
            @"\n\nPlease activate %@ and ensure that all open windows are currently assigned to Person profile '%@'."
            @"  Close any windows assigned to other profiles."
            @"\n\n(The profile name is indicated in the upper right corner any browser window in %@.)",
            (long)[[[self class] profileNames] count],
            [self ownerAppDisplayName],
            [self ownerAppDisplayName],
            [[self class] displayProfileNameForProfileName:self.clientoid.profileName],
            [self ownerAppDisplayName]
            ] ;
}

- (NSString*)helpAnchorForMultipleProfiles {
    return nil ;
}

- (BOOL)installMessengerError_p:(NSError**)error_p {
    /*
     All we install here is the special manifest file.  The symlink to the
     Chromessenger tool, in our Application Support folder, is updated each
     time the app launches, whether we are using it or not.  It's only a
     symlink!
     */

    /* In the following, we include extension IDs for both Chrome and Opera,
     for the reason given in the next comment. */

    NSDictionary* moreInfos = @{@"allowed_origins" : @[
                                        [NSString stringWithFormat:@"chrome-extension://%@/", [ExtoreChromy extension1Uuid]],
                                        [NSString stringWithFormat:@"chrome-extension://%@/", [ExtoreChromy extension2Uuid]],
                                        [NSString stringWithFormat:@"chrome-extension://%@/", [ExtoreOpera extension1Uuid]],
                                        [NSString stringWithFormat:@"chrome-extension://%@/", [ExtoreOpera extension2Uuid]],
                                        // For debugging, using "Load Unpacked Extension" on BookMacster Sync in Chrome and Opera
                                        [NSString stringWithFormat:@"chrome-extension://%@/", @"boelefkanomccbopnmpddkhcbdnidnlh"],
                                        // For debugging, using "Load Unpacked Extension" on BookMacster Button in Chrome and Opera
                                        [NSString stringWithFormat:@"chrome-extension://%@/", @"bkheidmhoojmljadkjjeeenbfgbmbdob"]]};

    BOOL ok = [Chromessengerer installSpecialManifestForAppSupportPath:[[self class] browserSupportPathForHomePath:nil]
                                                               profile:self.clientoid.profileName
                                                             moreInfos:moreInfos
                                                               error_p:(NSError**)error_p];
    if (ok) {
        /* For Opera and Brave, the above installed where it *should* go.
         But the current version of Opera (47) and Brave (December 2020)
         does not look for it there. It piggy-backs on Chrome's!!  See here:
         https://forums.opera.com/discussion/comment/15244591#Comment_15244591
         and here:
         * If you would like to update your report with more information, please
         send an email to: DNAWIZ-3797@bugs.opera.com. */
        ok = [Chromessengerer installSpecialManifestForAppSupportPath:[[self class] extraBrowserSupportPathForSpecialManifest]
                                                              profile:self.clientoid.profileName
                                                            moreInfos:moreInfos
                                                              error_p:(NSError**)error_p];
    }

    return ok;
}

- (void)tweakImport {
    /* During an import, we must do this after the hash-recording and
     hash-checking SSYOperations to avoid false hash mismatches. */
    if ([[self client] fakeUnfiled]) {
        Stark* unfiled = nil;
        NSArray* menuOutChildrenCopy = [[[[self starker] menu] children] copy];
        for (Stark* candidate in menuOutChildrenCopy) {
            if ([[candidate name] isEqualToString:constReadingUnsortedDisplayName]) {
                unfiled = candidate;
                break;
             }
        }
        [menuOutChildrenCopy release];

        if (!unfiled) {
            unfiled = [[self starker] freshDatedStark];
        }
        [unfiled setSharypeValue:SharypeUnfiled];
        [unfiled moveToBkmxParent:[[self starker] root]
                          atIndex:2
                          restack:YES];
    }
}

@end

