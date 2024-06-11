#import "ExtoreSafari.h"
#import "SSYSwift-Swift.h"
#import "Bkmxwork/Bkmxwork-Swift.h"
#import "NSError+MyDomain.h"
#import "NSError+SSYInfo.h"
#import "Stark+Sorting.h"
#import "SSYTreeTransformer.h"
#import "Starker.h"
#import "Client.h"
#import "SSYMH.AppAnchors.h"
#import "SSYOtherApper.h"
#import "SSYOperationQueue.h"
#import "BkmxBasis+Strings.h"
#import "NSString+LocalizeSSY.h"
#import "NSError+InfoAccess.h"
#import "NSError+DecodeCodes.h"
#import "BkmxDoc.h"
#import "NSNumber+Sharype.h"
#import "SSYUuid.h"
#import "SSYOperation.h"
#import "Stange.h"
#import "Chaker.h"
#import "NSBundle+HelperPaths.h"
#import "SafariSyncGuardian.h"
#import "NSObject+MoreDescriptions.h"
#import "SSYProgressView.h"
#import "NSString+BkmxURLHelp.h"
#import "Stark+ConvertToSafari.h"
#import "NSDictionary+Treedom.h"
#import "NSDictionary+ToStark.h"
#import "NSBundle+MainApp.h"
#import "Macster.h"
#import "Clientoid.h"
#import "Importer.h"
#import "NSDate+NiceFormats.h"
#import "NSUserDefaults+Bkmx.h"
#import "NSUserDefaults+MainApp.h"
#import "SheepSafariHelperProtocol.h"
#import "OperationExport.h"
#import "SSYIOKit.h"
#import "SSYSystemDescriber.h"
#import "NSData+Base64.h"
#import "NSString+URIQuery.h"
#import "NSInvocation+Quick.h"
#import "AgentPerformer.h"
#import "StarkEditor.h"
#import "SSYMOCManager.h"
#import "Job.h"
#import "NSString+URIQuery.h"
#import "NSFileManager+SomeMore.h"

/*!
 @details  This constant is because I've seen that the system/s XPC manager
 will sometimes delay up to 7 seconds before launching a SheepSafariHelper process.  We
 use this in two places:

 1.  So that, when our watchdog is watching for SheepSafariHelper to crash, we don't
 jump to the conclusion that it has crashed (because it is not running)
 if in fact it has not even been launched yet.

 2.  We add this to the timeout in the main app, but do not add it to the
 timeouts in SheepSafariHelper.  The idea is that we want SheepSafariHelper to produce the
 error first, because it that gives us more error detail than just the "SheepSafariHelper
 timed out which we get from the main app.
 */

NSTimeInterval const constSheepSafariHelperStartupDelayAllowance = 8.0;

/*
 @details  This constant is to

 (1) delay after importing from SheepSafariHelper and
 (2) provide an interval for retry in the event of other errors.

 The first one is be design, explained below.  Th second piggybacks on it.
 is because I have seen it happen that, for the next SheepSafariHelper operation
 (typically it's write after read, during an export) the connection will appear
 to connect and then go dead.

 My explanation is that the system's XPC manager thinks that the SheepSafariHelper
 process is still running running when in fact it is in the process of exit(0),
 for reasons explained in SheepSafariHelper.m comments.  So instead of launching a new
 SheepSafariHelper process, it connects to the one that is exitting, which of course does
 not work.

 Note that we could do this either before or after a Read or Write.  The most
 common sequences of SheepSafariHelper operations within the same process are:

 • For a Safari import only: Read
 • For a Safari export only: Read, Write
 • For a Safari import + export:  Read, Read, Write

 Notice that there is nothing ever after a Write.  So the simplest choice is
 to do it after a Read, because we don't need to do it after a Write.

 Experiment with different values of PAJARA_DIE_SECONDS:
 With Safari export only, macOS 10.13.4, Air2
 constSheepSafariHelperDyingBreatherDuration      experimental result
 0.4734                                failed 2/2
 2.4734                                failed 1/75
 8.4734                                failed 1/240

 Failures are acceptable – it will succeed on the first retry.  But that
 takes 59.4 seconds.
 */
NSTimeInterval const constSheepSafariHelperDyingBreatherDuration = 2.9;

/*
 @details  See static_sheepSafariHelperBusiness for reasoning behind this.
 */
NSTimeInterval const constSheepSafariHelperExportRetryDuration = 2.8;


NSString* const constKeySafariSyncInfo = @"SyncInfo" ;

NSString* const constKeySafariWebBookmarkIdentifier = @"WebBookmarkIdentifier" ;
NSString* const constKeySafariWebBookmarkTypeIdentifier = @"WebBookmarkType" ;
NSString* const constKeySafariWebBookmarkTypeListIdentifier = @"WebBookmarkTypeList" ;
NSString* const constKeySafariWebBookmarkUUIDIdentifier = @"WebBookmarkUUID" ;
NSString* const constKeySafariTitleIdentifier = @"Title" ;
NSString* const constKeySafariBookmarksBarIdentifier = @"BookmarksBar" ;
NSString* const constKeySafariBookmarksMenuIdentifier = @"BookmarksMenu" ;
NSString* const constKeySafariReadingListIdentifier = @"com.apple.ReadingList";
NSString* const constKeySafariImageUrlKey = @"imageURL";
// NSString* const constKeySafariCommentsKey = @"PreviewText";  // Not used.  See Note 20171101SC.
NSString* const constKeySafariReadingListDic = @"ReadingList" ;
NSString* const constKeySafariReadingListNonSyncDic = @"ReadingListNonSync" ;
NSString* const constKeySafariUriDictionary = @"URIDictionary" ;
NSString* const constKeySafariSync_Root = @"Sync" ;  // Apple uses the same key in two different dics
NSString* const constKeySafariSync_Item = @"Sync" ;  // but I'd like to keep the separate for clarity
NSString* const constKeySafariServerData = @"ServerData" ;

NSString* const constKeySafariDavServerID = @"ServerID" ;
NSString* const constKeySafariDavData = @"Data";

NSString* const constKeySafariDavChanges = @"Changes" ;
NSString* const constKeySafariCloudKitMigrationState = @"CloudKitMigrationState";
NSString* const constKeySafariDavChangeType = @"Type" ;
NSString* const constKeySafariDavChangeTypeAdd = @"Add" ;
NSString* const constKeySafariDavChangeTypeModify = @"Modify" ;
NSString* const constKeySafariDavChangeTypeDelete = @"Delete" ;
NSString* const constKeySafariDavChangeToken = @"Token" ;
NSString* const constKeySafariDavChangedBookmarkType = @"BookmarkType" ;
NSString* const constKeySafariDavChangedBookmarkTypeFolder = @"Folder" ;
NSString* const constKeySafariDavChangedBookmarkTypeBookmark = @"Leaf" ;
NSString* const constKeySafariDavChangedBookmarkServerID = @"BookmarkServerID" ;
NSString* const constKeySafariDavChangedBookmarkUuid = @"BookmarkUUID" ;

// Key used in my change records dictionary, used for culling unnecessary slides
NSString* const constKeyStangesIndex = @"stangesIndex" ;
NSString* const constKeyInOrOut = @"inOrOut" ;

// Added to owner values when sync info needs to be stripped for most purposes
// most purposes but, the ServerID component of the sync info still needs to
// appear in the "Delete" record in Sync ▸ Changes.
NSString* const constKeyDeletedSyncInfo = @"deletedSyncInfo" ;

#define ExtoreSafariMoveIn YES
#define ExtoreSafariMoveOut NO
typedef BOOL ExtoreSafariMoveInOrOut ;

static const ExtoreConstants extoreConstants = {
    /* canEditAddDate */                  NO,
    /* canEditComments */                 NO,  // See Note 20171101SC.
    /* canEditFavicon */                  NO,
    /* canEditFaviconUrl */               NO,
    /* canEditIsAutoTab */                YES,
    /* canEditIsExpanded */               NO,
    /* canEditIsShared */                 NO,
    /* canEditLastChengDate */            NO,
    /* canEditLastModifiedDate */         NO,
    /* canEditLastVisitedDate */          NO,
    /* canEditName */                     YES,
    /* canEditRating */                   NO,
    /* canEditRssArticles */              NO,
    /* canEditSeparators */               BkmxCanEditInStyleEither,  // using the special BookMacster Hack
    /* canEditShortcut */                 BkmxCanEditInStyleNeither,
    /* canEditTags */                     BkmxCanEditInStyleNeither,
    /* canEditUrl */			          YES,
    /* canEditVisitCount */               NO,
    /* canCreateNewDocuments */           YES,
    /* ownerAppDisplayName */             @"Safari",
    /* webHostName */                     nil,
    /* authorizationMethod */             BkmxAuthorizationMethodNone,
    /* accountNameHint */                 nil,
    /* oAuthConsumerKey */                nil,
    /* oAuthConsumerSecret */             nil,
    /* oAuthRequestTokenUrl */            nil,
    /* oAuthRequestAccessUrl */           nil,
    /* oAuthRealm */                      nil,
    /* appSupportRelativePath */          nil,  // Safari bookmarks are in ~/Library, not in ~/Library/Application Support
    /* defaultFilename */                 @"Bookmarks.plist",
    /* defaultProfileName */              nil,
    /* iconResourceFilename */            nil,
    /* iconInternetURL */                 nil,
    /* fileType */                        @"plist",
    /* ownerAppObservability */           OwnerAppObservabilityBookmarksFile,
    /* canPublicize */                    NO,
    /* silentlyRemovesDuplicates */       NO,
    /* normalizesURLs */                  NO,
    /* catchesChangesDuringSave */        NO,
    /* telltaleString */                  @"WebBookmarkType",
    /* hasBar */                          YES,
    /* hasMenu */                         NO,
    /* hasUnfiled */                      YES, // Note 219809
    /* hasOhared */                       NO,
    /* tagDelimiter */                    nil,
    /* dateRef1970Not2001 */              NO, // Actually does not apply, since dates are stored as NSDates
    /* hasOrder */                        YES,
    /* hasFolders */                      YES,
    /* ownerAppIsLocalApp */              YES,
    /* defaultSpecialOptions */           0x0000000000000000LL,
    /* extensionInstallDirectory */       nil,
    /* minBrowserVersionMajor */          0,
    /* minBrowserVersionMinor */          0,
    /* minBrowserVersionBugFix */         0,
    /* minSystemVersionForBrowsMajor */   0,
    /* minSystemVersionForBrowMinor */    0,
    /* minSystemVersionForBrowBugFix */   0
} ;

/*
 Note 219809.  This is mostly ignored because -hasUnfiled has been overridden.
 It is used in -[BkmxAppDel(Capabilities) exformatsThatHaveSharype:].
 For that reason, it was changed from NO to YES in BookMacster 1.11.
 */

/*
 Note 20171101SC.  We *could* map our `comments` to the value of key
 ReadingList.PreviewText in Safari's Bookmarks.plist, but I am not doing
 this because:

 1.  Such comments would only be visible in Safari, in the Reading List.

 2.  We use +[Extore editableAttributesInStyle:] for creating hashes and
 deciding whether or not there are changes.  An attribute must be either in
 this array, or not in this array.  It cannot be *in* for some bookmarks
 (those in the Reading List) and *out* for others.  One really bad result
 is that, if a document contains bookmarks in, say, the Bar which
 have comments from, say, Firefox, and you import from Safari, such comments
 would be wiped out.

 3.  If we set canEditComments to YES and added some lines of code, it might
 work in Thomas pushes if we added the ReadingList.PreviewText
 key to regular bookmarks which are not in Reading List.  However, I'm not
 sure if that would work in SheepSafariHelper, and because I'm already doing enough
 unsupported stuff in there, and because iCloud can be fussy in unpredictable
 ways, this would be dangerous.
 */


@interface NSDictionary (BkmxTooManyChildren)
- (void)getOverlimitFolderNames:(NSMutableDictionary*)overages;
@end


@implementation NSDictionary (BkmxTooManyChildren)

- (void)getOverlimitFolderNames:(NSMutableDictionary*)overages {
    NSInteger thisChildrenCount = ((NSArray*)[self objectForKey:constKeyTreedomChildrenUpper]).count;
    NSInteger limit = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constICloudFolderLimit];
    if (thisChildrenCount > limit) {
        /* Note that the following will return a nil name for bookmarks.
         It only works for folders, due to the strange way in which Apple
         has designed the Bookmarks.plist.  However, since only folders
         can have thisChildrenCount > 0, it works OK. */
        NSString* name = [self objectForKey:constKeySafariTitleIdentifier];
        [overages setObject:[NSNumber numberWithInteger:thisChildrenCount]
                     forKey:name];
    }
}

@end

const NSInteger constAgentCannotAccessSafariBookmarks = 235221;
const NSInteger constMainAppCannotAccessSafariBookmarks = 235222;
const NSInteger constHelperCannotAccessSafariBookmarks = 235223;


@interface ExtoreSafari()

@property (assign) NSTimer* sheepSafariHelperTimeoutTimer;
/* Assign becaause timers retain themselves. */

@property (atomic, assign) BOOL isDoneReadingFromSheepSafariHelper;
/* Important that isDoneReadingFromSheepSafariHelper is atomic because it is
 definitely accessed near-simultaneously from multiple threads */

@property (atomic, assign) BOOL isDoneWritingToSheepSafariHelper;
/* Important that isDoneWritingToSheepSafariHelper is atomic because it is
 definitely accessed near-simultaneously from multiple threads */

@property (copy) NSDate* sheepSafariHelperStartDate;
@property (readonly) NSTimeInterval sheepSafariHelperRunningTime;
@property (assign) NSInteger sheepSafariHelperCurrentTrialIndex;
@property (assign) NSInteger initialCkmsFromPlistFile;
@property (retain) NSXPCConnection* sheepSafariHelperXpcConnection;

@end


@implementation ExtoreSafari

/* 
 This implementation is the same in all subclasses, but we define it
 in each subclass in order to pick up the static const extoreConstants
 struct which is different in each Extore subclass' implementation file.
 */
+ (const ExtoreConstants *)constants_p {
    return &extoreConstants ;
}

+ (NSArray*)browserBundleIdentifiers {
    return [NSArray arrayWithObject:@"com.apple.Safari"] ;
}

+ (NSString*)labelBar {
    return [NSString localize:@"000_Safari7_bookmarksBar"] ;
}

+ (NSString*)labelOhared {
    return constDisplayNameNotUsed ;
}

- (BOOL)parentSharype:(Sharype)parentSharype
  canHaveChildSharype:(Sharype)childSharype {
    BOOL answer ;
    if (parentSharype == SharypeRoot) {
        /* Anything is OK at root */
        answer = YES;
    }
    else if (parentSharype == SharypeUnfiled) {
        /* OK to go to unfiled unless it's a folder.  Exporting separators
         to Reading List is certainly useless, although it works in Safari
         16 macOS Ventura Beta 5. creating a bookmark with name ––––– and
         url separator://xxxxxxx.xxx.  But I think that in the concept of
         BkmkMgrs, if I returned NO here, all separators in Reading List
         would be dumped to the bottom of Root, which would be even more
         useless.  At this time in BkmkMgrs, an item which is not exportable
         or not depending on its source folder is not a thing.  OF course,
         this might be a TODO, to think about this some more.*/
        answer = ((childSharype & (SharypeCoarseLeaf) + SharypeSeparator) > 0) ;
    }
    else if (parentSharype == SharypeMenu){
        /* Anything is OK in menu provided that user's Safari has a menu */
        answer = [self hasMenu] ;
    }
    else {
        /* Anything is OK to go into any other type of container not
         already considered above.  */
        answer = ((parentSharype & (SharypeGeneralContainer)) > 0) ;
    }
    
    return answer ;
}

+ (BkmxIxportTolerance)toleranceForIxportStyle:(NSInteger)ixportStyle {
    BkmxIxportTolerance tolerance = BkmxIxportToleranceAllowsNone ;
    if (ixportStyle == 1) {
        tolerance = BkmxIxportToleranceAllowsReading + BkmxIxportToleranceAllowsWriting ;
    }

    return tolerance ;
}

+ (BkmxGrabPageIdiom)peekPageIdiom {
    return BkmxGrabPageIdiomAppleScript ;
}

+ (PathRelativeTo)fileParentPathRelativeTo {
    return PathRelativeToLibrary ;
}

+ (NSString*)fileParentRelativePath {
    return @"Safari" ;
}

- (NSInteger)indexOffsetForRoot {
    /* Note 20180228

     We do this differently in Safari, because of the strange behavior of the
     of the SafariPrivateFramework.  There are many possibie return values
     when we ask the root WebBookmarkList* for its -folderAndLeafChildren,
     or _children …
     
     • History is always present
     • Favoites/BookmarksBar is always preesent
     • Menu may be present in legacy bookmarks collections
     • Tab Group Favorites is present macOS 10.13 or later, absent in earlier
     • Reading will be absent if user has never added any bookmark to it

     Anyhow, you see, at this point, we don't know how much to offset the soft
     items.  So, at this point, for Sanity, we offset them as though there were
     were *zero* hard folders and *no* History, then do the real offsetting in
     SheepSafariHelper, after we see where the Menu is.

     However, at this point, we already have an offset, due to the current
     hartainers in the extore.  So in order to fulfill our Sanity as defined
     above, we need to *subtract* out the +1 offset due to each hartainer.

     Note that we check for the hartainers being not nil instead of using
     -hasBar, -hasMenu and -hasUnfiled.  This is because -hasMenu has been
     found to be YES when it actually does not exist in the extore.  I have
     not studied why. */
    if (_indexOfOffsetForRoot == -1) {
        _indexOfOffsetForRoot = 0;
        /* In the following, the -isNewItemThisExport clauses are necessary
         for the rare case of needing to add a mustHave hartainer to Safari.
         See other comments marked by NoteRareMissingSafariHartainer.*/
        if ((self.starker.bar != nil) && ![self.starker.bar isNewItemThisIxport]) {
            _indexOfOffsetForRoot -= 1;
        }
        if ((self.starker.menu != nil) && ![self.starker.menu isNewItemThisIxport]) {
            _indexOfOffsetForRoot -= 1;
        }
        if ((self.starker.unfiled != nil) && ![self.starker.unfiled isNewItemThisIxport]) {
            _indexOfOffsetForRoot -= 1;
        }
    }

    return _indexOfOffsetForRoot;
}

- (NSInteger)currentCkmsFromPlistFile {
    NSError* error = nil;
    NSInteger ckms = 0;
    NSDictionary* treeIn = [self extoreTreeError_p:&error] ;
    if (!treeIn) {
        /* No Bookmarks.plist.  Probably Safari has not been used yet.  This
         can NOT be a macOS 10.14 access issue, because (as of this commit),
         this method is only called in macOS 10.10-. */
        _ixportSubstyle = IxportSubstyleOverwriteFile;
    } else if ([treeIn respondsToSelector:@selector(objectForKey:)]) {
        NSDictionary* syncInfo = [treeIn objectForKey:constKeySafariSync_Root];
        if (syncInfo) {
            NSNumber* cloudKitMigrationState = [syncInfo objectForKey:constKeySafariCloudKitMigrationState];
            if (cloudKitMigrationState) {
                ckms = cloudKitMigrationState.integerValue;

                if (ckms != [[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeySafariPushPriorCkms]) {
                    [[NSUserDefaults standardUserDefaults] setAndSyncMainAppInteger:ckms
                                                                             forKey:constKeySafariPushPriorCkms];
                }
            }
        }
    }

    return ckms;
}

- (id) initWithIxporter:(Ixporter*)ixporter
              clientoid:(Clientoid*)clientoid
              jobSerial:(NSInteger)jobSerial {
    self = [super initWithIxporter:ixporter
                         clientoid:clientoid
                         jobSerial:jobSerial] ;
    if (self) {
        _ixportSubstyle = IxportSubstyleUnknown;
        _indexOfOffsetForRoot = -1;
        _initialCkmsFromPlistFile = -1;
    }

    return self;
}

- (void)dealloc {
    /* This is defensive programming, because I can't *think* of any way
     that this ExtoreSafari would dealloc without one of the other
     [self.sheepSafariHelperTimeoutTimer invalidate] statements running first. */
    [self.sheepSafariHelperTimeoutTimer invalidate];

    [_sheepSafariHelperStartDate release];

    [_sheepSafariHelperXpcConnection invalidate];
    //    [_sheepSafariHelperXpcConnection release];

    [super dealloc];
}

- (BOOL)shouldBlindSawChangeTriggerDuringExport {
    /*
     Because of the file locking by SafariSyncGuardian, user
     cannot change Safari bookmarks while we are exporting.
     Blinding the trigger will eliminate re-importing, unless
     iCloud Bookmarks Syncing is on.  In that case, re-importing
     will be required after SafariDAVClient touches the file.
     */

    return YES ;
}

- (BOOL)shouldActuallyDeleteBeforeWrite {
    return NO ;
}

- (BOOL)isExportableStark:(Stark*)stark
               withChange:(NSDictionary*)change {
#if IS_EXPORTABLE_STARK_WILL_ALWAYS_RETURN_YES
    return YES  ;
#endif
    
    /* Note that this method could call super here (other subclasses do).
     But, for historical reasons, and for fear of dire unforseen consequences
     of a changing this, we do not call super in ExtoreSafari. */

    if ([stark sharypeValue] == SharypeSmart) {
        return NO ;
    }
    
    if ([[stark url] isSmartSearchUrl]) {
        return NO ;
    }

    /* If SheepSafariHelper is asked to insert a bookmark with a nil URL, it will crash
     as I have seen myself in macOS 10.13, and also as in this crash report
     from a macOS 10.12 user:

     Feb 26 19:40:05 Kinchaku SheepSafariHelper[42082]: *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[__NSArrayM insertObject:atIndex:]: object cannot be nil'
     *** First throw call stack:
     (
     0   CoreFoundation                      0x00007fff98581452 __exceptionPreprocess + 178
     1   libobjc.A.dylib                     0x00007fff9ad8473c objc_exception_throw + 48
     2   CoreFoundation                      0x00007fff98497a90 checkForCloseTag + 0
     3   Safari                              0x00007fff9eb9e3dc -[BookmarksUndoController _moveBookmarks:to:startingIndex:isCopy:undoTarget:selector:addedBookmarks:] + 536
     4   Safari                              0x00007fff9eb9c3d5 -[BookmarksUndoController insertBookmarks:startingAtIndex:inBookmarkFolder:] + 144
     5   Safari                              0x00007fff9eb9c091 -[BookmarksUndoController insertBookmark:atIndex:inBookmarkFolder:allowDuplicateURLs:] + 604
     6   SheepSafariHelper                              0x000000010592417d -[SheepSafariHelper newBookmarkWithParent:index:name:url:comments:] + 212
     7   SheepSafariHelper                              0x0000000105925ecd -[SheepSafariHelper doPut:error_p:] + 1320
     8   SheepSafariHelper                              0x0000000105924890 -[SheepSafariHelper processChanges:completionHandler:] + 736

     Apparently, -[BookmarksUndoController _moveBookmarks:to:startingIndex:isCopy:undoTarget:selector:addedBookmarks:]
     is trying to insert a nil object into an array.  Not sure why.

     Therefore, we prevent export of any bookmarks with nil URL.
     */
    if ((stark.sharypeValue == SharypeBookmark || stark.sharypeValue == SharypeLiveRSS)) {
        if (stark.url == nil) {
            return NO;
        }
    }
    
    // Note: This is the only Extore subclass which does not
    // return NO for -is1PasswordBookmarklet
    
    return YES ;
}

/* If you remove the Bookmarks.plist file, the replacement which will be
 created by Safari is missing the Reading List (aka com.apple.ReadingList,
 SharypeUnfiled), even in macOS 10.14.4 beta 2.  This will cause export to fail
 if user attempts to export a bookmark to the Reading List.  So we return YES
 here for mustHaveUnfiledInFile.  However, the bar and menu act differently.
 The Safari Private Framework will create, in memory, a bar and menu upon
 calling -[WebBookmarkGroup load].  So we must not create those.
 See other comments marked by NoteRareMissingSafariHartainer. */
- (Sharype)mustHaveBarInFile {return NO;}
- (Sharype)mustHaveMenuInFile {return NO;}
- (Sharype)mustHaveUnfiledInFile {return YES;}
- (Sharype)mustHaveOharedInFile {return NO;}

+ (BOOL)thisUserHasUnfiled {
    return YES;
}

- (BOOL)hasUnfiled {
    /* States of m_hasUntiledTernary:
     0 = unknown
     -1 = no
     +1 = yes
     */
    if (m_hasUnfiledTernary == 0) {
        if ([[[self clientoid] extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
            // Use the more reliable method, which looks at the Safari version.
            if ([[self class] thisUserHasUnfiled]) {
                m_hasUnfiledTernary = 1 ;
            }
        }
        else {
            // Use the less reliable version, which looks at whether or not a
            // Reading List currently exists in the file.  The reason this is
            // not reliable is because a new Safari 5.1+ bookmarks file with
            // no bookmarks in the Reading List will not have a Reading List.
            m_hasUnfiledTernary = -1 ;
            NSError* error = nil ;
            NSDictionary* extoreTree = [self extoreTreeError_p:&error] ;
            if (extoreTree) {
                for (NSDictionary* rootChild in [extoreTree objectForKey:@"Children"]) {
                    NSString* name = [rootChild objectForKey:constKeySafariTitleIdentifier] ;
                    if ([name isEqualToString:constKeySafariReadingListIdentifier]) {
                        NSString* type = [rootChild objectForKey:constKeySafariWebBookmarkTypeIdentifier] ;
                        if ([type isEqualToString:constKeySafariWebBookmarkTypeListIdentifier]) {
                            m_hasUnfiledTernary = +1 ;
                        }
                    }
                }
            }
            else {
                // This will happen if BkmxDoc has an Other Mac Account
                // Safari client which is currently not on the LAN.
                // In BookMacster 1.5.6 it logged Internal Error 202-8540.
                m_hasUnfiledTernary = 0 ;
            }
        }
    }

    BOOL answer = (m_hasUnfiledTernary == +1) ;
    return answer ;
}

- (BOOL)getTextForRemovalOfLegacyHartainer:(Sharype)sharype
                                   title_p:(NSString**)title_p
                                subtitle_p:(NSString**)subtitle_p
                                    body_p:(NSString**)body_p
                          helpBookAnchor_p:(NSString**)helpBookAnchor_p {
    NSString* title = nil;
    NSString* subtitle = nil;
    NSString* body = nil;
    NSString* helpBookAnchor = nil;
    if (sharype == SharypeMenu) {
        title = @"Safari bookmarks were modernized.";
        subtitle = @"Obsolete 'Bookmarks Menu' removed";
        body = @"to avoid trouble in macOS 12+";
        helpBookAnchor = @"safariMenuObsolete";
    }
    
    if (title_p && title) {
        *title_p = title;
    }
    if (subtitle_p && subtitle) {
        *subtitle_p = subtitle;
    }
    if (body_p && body) {
        *body_p = body;
    }
    if (helpBookAnchor_p && helpBookAnchor) {
        *helpBookAnchor_p = helpBookAnchor;
    }
    
    return YES;
}

- (SEL)reformatStarkToExtore {
    return @selector(extoreItemForSafari:) ;
}

//- (SEL)reformatExtoreToBookdog {
//	return @selector(reformatSafariToBkmxForStore:) ;
//}

+ (Stark*)starkFromExtoreNode:(NSDictionary*)dic
                      starker:(Starker*)starker
                    clientoid:(Clientoid*)clientoid {
    Stark* stark = nil ;  // We'll return nil if things go wrong

    NSString* webBookmarkType = [dic objectForKey:constKeySafariWebBookmarkTypeIdentifier] ;

    id value;
    NSString* name = nil;

    if ([webBookmarkType isEqualToString:@"WebBookmarkTypeLeaf"]) {
        // is a bookmark or separator
        stark = [starker freshStark] ;

        NSDictionary* uriDic = [dic objectForKey:constKeySafariUriDictionary] ;
        name = [uriDic objectForKey:@"title"] ; // Safari uses "Title" in the outer dic, but "title" in the inner dic
        NSString* url = [dic objectForKey:@"URLString"] ;

        Sharype sharype ;
        if ([url hasPrefix:constSeparatorUrlScheme]) {
            sharype = SharypeSeparator ;
            [stark setName:[[BkmxBasis sharedBasis] labelSeparator]] ;

            /* Starting in BkmkMgrs 2.9.8, separators have URLs
             (separator://<compactUuid> to play nice with Safari and iCloud.
             But old separators in Safari might still have url as empty
             string. */
            value = [dic objectForKey:@"URLString"];
            if ([((NSString*)value) hasPrefix:constSeparatorUrlScheme]) {
                /* Use existing special separator URL to avoid churn */
                [stark setUrl:value];
            } else {
                /* Migrate to special separator URL */
                [stark separatorify];
            }
        }
        else {
            sharype = SharypeBookmark ;
            [stark setName:name] ;

            [stark setUrl:url] ;
        }

        // Do not do this.  See Note 20171101SC.
        //        value = [[dic objectForKey:constKeySafariReadingListDic] objectForKey:constKeySafariCommentsKey];
        //        if (value) {
        //            [stark setComments:value];
        //        }

        value = [dic objectForKey:constKeySafariImageUrlKey];
        if (value) {
            [stark setOwnerValue:value
                          forKey:constKeySafariImageUrlKey];
        }

        value = [dic objectForKey:constKeySafariReadingListDic] ;
        if (value) {
            [stark setOwnerValue:value
                          forKey:constKeySafariReadingListDic] ;
        }

        value = [dic objectForKey:constKeySafariReadingListNonSyncDic] ;
        if (value) {
            [stark setOwnerValue:value
                          forKey:constKeySafariReadingListNonSyncDic] ;
        }
        
        [stark setSharypeValue:sharype] ;
    }
    else if ([webBookmarkType isEqualToString:constKeySafariWebBookmarkTypeListIdentifier]) {
        // is a container (folder, collection, etc.)
        stark = [starker freshStark] ;

        name = [dic objectForKey:constKeySafariTitleIdentifier] ;  // Safari uses "Title" in the outer dic, but "title" in the inner dic
        [stark setName:name] ;

        BOOL isAutoTab = NO;
        if ([dic objectForKey:@"WebBookmarkAutoTab"]) {
            isAutoTab = YES ;
        }
        [stark setIsAutoTab:[NSNumber numberWithBool:isAutoTab]] ;
        // Note that we do not copy children here since we need copies
        // of the children.  This will be done by the deep copier.

        [stark setSharypeValue:SharypeSoftFolder] ;
        // may actually be Root or Barbut we detect and fix that elsewhere
    }

    value = [dic objectForKey:constKeySafariWebBookmarkUUIDIdentifier] ;
    [stark setExid:value
      forClientoid:clientoid] ;
    /* We also set the bare `exid`.  Although it is not persistent,
     it is handy, particularly in -processExportChangesForOperation::. */
    [stark setExid:value];

    // So far, I have only seen "WebBookmarkIdentifier" keys in the proxy collections
    // but the name implies they may become more general, so I always check for them.
    NSString* webBookmarkIdentifier = [dic objectForKey:@"WebBookmarkIdentifier"] ;
    if (webBookmarkIdentifier) {
        [stark setOwnerValue:webBookmarkIdentifier
                      forKey:constKeySafariWebBookmarkIdentifier] ;
    }

    NSDictionary* syncDic = [dic objectForKey:constKeySafariSync_Item] ;
    if (syncDic) {
        [stark setOwnerValue:syncDic
                      forKey:constKeySafariSyncInfo] ;
    }
    // Note that if dic does not have a "WebBookmarkType", this method will return nil.
    // The sender should omit such a node in constructing the output tree.
    return stark ;
}

- (Stark*)starkFromExtoreNode:(NSDictionary*)dic {
    return [ExtoreSafari starkFromExtoreNode:dic
                                     starker:[self starker]
                                   clientoid:[self clientoid]] ;
}

- (BOOL)makeStarksFromExtoreTree:(NSDictionary*)treeIn
                         error_p:(NSError**)error_p {
    BOOL ok = YES ;
    NSError* error = nil ;

    if (![treeIn respondsToSelector:@selector(objectForKey:)]) {
        return NO ;
    }
    NSMutableDictionary* rootAttributes = [treeIn mutableCopy] ;
    if (rootAttributes) {
        [rootAttributes removeObjectForKey:@"Children"] ;
        [[self fileProperties] setObject:rootAttributes
                                  forKey:constKeyRootAttributes] ;

        NSDictionary* syncInfo = [rootAttributes valueForKey:constKeySafariSync_Root] ;
        if ([syncInfo respondsToSelector:@selector(objectForKey:)]) {
            NSData* data = [syncInfo objectForKey:constKeySafariServerData] ;
            if (data) {
                [[self fileProperties] setObject:data
                                          forKey:constKeySafariServerData] ;
            }
        }
    }
    [rootAttributes release] ;

    // Stepping through Safari root's children, set aside proxy collections, identify bookmarksBar, bookmarksMenu and other collections
    NSArray* safariAllCollections = [treeIn objectForKey:@"Children"] ;
    NSMutableArray* proxyCollections__ = [NSMutableArray array] ;  // a new, empty, temporary array
    NSDictionary* safariBookmarksBar = nil ;
    NSDictionary* safariBookmarksMenu = nil ;
    NSDictionary* safariBookmarksUnfiled = nil ;
    NSMutableArray* safariOtherRootItems = [NSMutableArray array] ;
    NSMutableDictionary* fileProperties_ = [self fileProperties] ;

    /* In case of a corrupt file in which there is more than bar, menu, or
     unfiled, we handle it the way Safari does, which is to interpret the first
     such one as the real one, and any additional such as Other Collections. */
    for (NSDictionary* itemAtRoot in safariAllCollections) {
        NSString* webBookmarkType = [itemAtRoot objectForKey:constKeySafariWebBookmarkTypeIdentifier] ;
        if ([webBookmarkType isEqualToString:@"WebBookmarkTypeProxy"]) {
            [proxyCollections__ addObject:itemAtRoot] ;  // stash aside.  atIndex:0 is so they get restored in the same order as we found them.
        }
        else {
            NSString* name = [itemAtRoot objectForKey:constKeySafariTitleIdentifier]  ;  // Safari uses "Title" in the outer dic, but "title" in the inner dic
            if ([name isEqualToString:constKeySafariBookmarksBarIdentifier]  && !safariBookmarksBar) {
                safariBookmarksBar = itemAtRoot ;
            }
            else if ([name isEqualToString:constKeySafariBookmarksMenuIdentifier] && !safariBookmarksMenu) {
                safariBookmarksMenu = itemAtRoot ;
            }
            else if ([name isEqualToString:constKeySafariReadingListIdentifier] && !safariBookmarksUnfiled) {
                safariBookmarksUnfiled = itemAtRoot ;
            }
            else {
                [safariOtherRootItems addObject:itemAtRoot] ;
            }
        }
    }

	/* In BkmkMgrs 2.9.9, removed code here which might create a
     safariBookmarksBar if none was found, because Safari Private Frameworks'
     -[WebBookmarkGroup load] will always create one even if there is none
     in the file, and creating another would be really bad. */

    // Copy the extracted proxy collections into a retained instance variable
    NSArray* proxyCollections_ = [NSArray arrayWithArray:proxyCollections__] ; // make immutable copy
    [fileProperties_ setObject:proxyCollections_ forKey:constKeyProxyCollections] ;

    /* In BkmkMgrs 2.9.9, removed code here which might would create a
     safariBookmarksBar and Menu if nil, because Safari Private Frameworks'
     -[WebBookmarkGroup load] will always create one even if there is none
     in the file, and creating another would be really bad. */

    // Create a transformer which we will use to create our collections from Safari's
    SSYTreeTransformer* transformer = [SSYTreeTransformer
                                       treeTransformerWithReformatter:@selector(modelAsStarkInStartainer:)
                                       childrenInExtractor:@selector(childrenWithUppercaseC)
                                       newParentMover:@selector(moveToBkmxParent:)
                                       contextObject:self] ;
    
    Stark* rootOut = [[self starker] freshStark] ;
    [rootOut setSharypeValue:SharypeRoot] ;
    Stark* barOut = [transformer copyDeepTransformOf:safariBookmarksBar] ;
    Stark* menuOut = nil;
    if ([[safariBookmarksMenu objectForKey:@"Children"] count] > 0) {
        menuOut = [transformer copyDeepTransformOf:safariBookmarksMenu] ;
    } else {
        /* The BookmarksMenu is empty, which means we have read a *modern*
         Safari bookmarks file.  There is no need to remove the empty
         BookmarksMenu (see safariMenuObsolete).  (For some reason, Apple
         leaves the empty BookmarksMenu in there forever, even though the
         user cannot add any items to it.) In order to prevent an unnecessary
         removal operation, and the user notification indicating that
         it was done, we ignore the BookmarksMenu by leaving menuOut = nil. */
    }
    
    Stark* unfiledOut = [transformer copyDeepTransformOf:safariBookmarksUnfiled] ;
    
    /* In BkmkMgrs 2.9.9, removed code here which might would create a
     unfiledOut if nil, because it did not work with SheepSafariHelper, and as of the
     previous commit we have a different way to fix this – See other comments
     marked by NoteRareMissingSafariHartainer.*/
    for (Stark* otherIn in safariOtherRootItems) {
        Stark* otherOut = [transformer copyDeepTransformOf:otherIn] ;
        [otherOut moveToBkmxParent:rootOut] ;
        [otherOut release] ;
    }

    // Set instance variables
    [rootOut assembleAsTreeWithBar:barOut
                              menu:menuOut
                           unfiled:unfiledOut
                            ohared:nil] ;
    [barOut release] ;
    [menuOut release] ;
    [unfiledOut release] ;

end:
    if (error_p && error) {
        *error_p = error ;
    }

    return ok ;
}

- (NSTimeInterval)timeoutForIcloudWithBkmxDoc:bkmxDoc {
#if 0
#warning iCloud timeout is set to special value for testing
    return 200.0 ;
#endif
    NSTimeInterval timeout ;
    if ([bkmxDoc currentPerformanceType] == BkmxPerformanceTypeUser) {
        // We are in Main App, not scripted.  The user has commanded an
        // export and is sitting and wondering why it's taking so long.
        timeout = 60.0 ;
        // Was 15.0 until BookMacster 1.15, then 25.0 until BookMacster 1.20.2
        // when the progress bar was made determinate.
    }
    else {
        // We are either in BkmxAgent, or in Main App but scripted.

        // On 20100129, Greta Søderlund <ovre.frydendal@gmail.com> reported
        // that this error occurred with a Syncer timeout of 20.0 seconds.
        // (Note that this was before iCloud, so the error must have been
        // SafariSyncGuardianResultFailedLockInUseByOther.
        // On 20111129, I noted that iCloud took 420 seconds to upload my
        // 1500 bookmarks.
        timeout = 1200.0 ;
    }

    return timeout ;
}

- (id)tweakedValueFromStark:(Stark*)stark
                     forKey:(NSString*)key {
    id tweakedValue = [stark valueForKey:key] ;
    
    /* This implementation ran without qualification when it was first added in
     commit 760f7f6, 2019-09-20.  Apparently, I thought that Safari was
     decoding percent escapes in URLs.  But today, 2022-07-08, I see that, when
     testing in macOS 13.0 Beta 3 and in macOS 11.6, although the Edit
     Bookmarks window in Safari shows decoded per cent escape sequences in
     URLs, they are *not* decoded, that is, they appear as percent escapes, in
     the Bookmarks.plist file and, more importantly, in the URL returned by the
     SafariPrivateFramework to SyeepSafariHelper.  Therefore, this tweak was
     causing churn today.  Why did I do this back in 2019?  Today, I tested
     this in both macOS 11.4 and madOS 13.0 Beta 3.  Did I just not test this
     carefully enough back in 2019, or did I just assume that what I saw in the
     Edit Bookmarks in Safari was what I was getting from
     SafariPrivateFrameworks and not test it at all, or did Apple change the
     behavior in Apple change the behavior beginning in macOS 11 (summer 2020).
     In case the latter is what happened, I have left this implementation
     function for macOS 10.15 and earlier, no-op for 10.11+. */
    if (NSAppKitVersionNumber >= NSAppKitVersionNumber11_0) {
        return tweakedValue;
    }
    
    if ([key isEqualToString:constKeyUrl]) {
        tweakedValue = [stark url] ;
        NSMutableCharacterSet* characterSet = [[NSMutableCharacterSet alloc] init];
        [characterSet addCharactersInRange:NSMakeRange(0x0080, 0xffff - 0x0080)];
        tweakedValue = [tweakedValue decodeOnlyPercentEscapesInUnicodeSet:characterSet
                                                       uppercaseAnyOthers:NO
                                                  resolveDoubleDotsInPath:NO];
        [characterSet release];
    }
    
    return tweakedValue ;
}

/*!
 @details  Warning.  This method runs in a secondary thread.
 */
- (BOOL)processGuardianResult:(SafariSyncGuardianResult)result
                     polarity:(BkmxIxportPolarity)polarity
                  yieldeeName:(NSString*)yieldeeName
                      timeout:(NSTimeInterval)timeout
                         info:(NSMutableDictionary*)info {
    NSInteger errorCode ;
    NSString* reason ;
    NSString* suggestion ;
    BOOL timeoutError = NO ;
    switch (result) {
        case SafariSyncGuardianResultSucceeded:
            errorCode = 0 ;
            break ;
        case SafariSyncGuardianResultFailedLockInUseByOther:
            errorCode = 613901 ;
            reason = [NSString localizeFormat:
                      @"bookmarksBusyX",
                      yieldeeName] ;
            suggestion = [NSString localizeFormat:
                          @"retryInX",
                          10]  ;
            timeoutError = YES ;
            break ;
        case SafariSyncGuardianResultFailedIcloudIsSyncing:
            errorCode = 613902 ;
            NSString* what ;
            if (polarity == BkmxIxportPolarityImport) {
                what = [[BkmxBasis sharedBasis] labelImportFromOnly] ;
            }
            else {
                what = [[BkmxBasis sharedBasis] labelExportToOnly] ;
            }
            reason = [NSString localize:@"bookmarksBusyIcloud"] ;
            suggestion = [NSString stringWithFormat:
                          @"Wait a few minutes, longer is better.  Then retry the operation by clicking in the menu: File > %@ > Safari.",
                          what] ;
            timeoutError = YES ;
            break ;
        default:
            errorCode = 613903 ;
            reason = nil ;
            suggestion = nil ;
            NSLog(@"Internal Error 238-3785") ;
            break ;
    }

    if (errorCode != 0) {
        if (!yieldeeName) {
            yieldeeName = @"some other process" ;
        }
        NSString* description ;
        if (timeoutError) {
            description =  [NSString stringWithFormat:
                            @"Took too long waiting for %@",
                            yieldeeName] ;
        }
        else {
            description = @"Unforseen error" ;
            suggestion = @"Maybe our support team should have a look at this.  "
            @"Please click the life-preserver button in the lower left." ;
        }
        NSError* error = SSYMakeError(errorCode, description) ;
        error = [error errorByAddingLocalizedFailureReason:reason] ;
        error = [error errorByAddingUserInfoObject:[NSNumber numberWithDouble:timeout]
                                            forKey:@"Waited for seconds"] ;
        error = [error errorByAddingUserInfoObject:[[BkmxBasis sharedBasis] labelImport]
                                            forKey:@"Polarity"] ;
        BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument] ;
        if (![[BkmxBasis sharedBasis] isBkmxAgent] && ![[bkmxDoc operationQueue] scriptCommand]) {
            error = [error errorByAddingLocalizedRecoverySuggestion:suggestion] ;
        }
        if (timeoutError) {
            // Added in BookMacster 1.20.2
            error = [error errorByAddingIsOnlyInformational] ;
        }

        [info setValue:error
                forKey:constKeyError] ;
        [info setValue:[NSNumber numberWithBool:YES]
                forKey:constKeyDontPauseSyncing] ;
    }

    return (errorCode == 0) ;
}

- (void)displayProgressWithYieldee:(NSString*)yieldee
                          userInfo:(NSDictionary*)userInfo {
    if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        return ;
    }

    NSString* readingOrWriting = [userInfo objectForKey:constKeyActionName] ;
    BkmxDoc* bkmxDoc = [userInfo objectForKey:constKeyDocument] ;
    NSString* message = [NSString stringWithFormat:
                         @"%@ Safari : Waiting for updates by %@",
                         [readingOrWriting capitalizedString],
                         yieldee] ;
    SSYProgressView* progressView = [[bkmxDoc progressView] setIndeterminate:NO
                                                           withLocalizedVerb:message
                                                                    priority:SSYProgressPriorityRegular] ;
    [progressView setMaxValue:[[userInfo objectForKey:constKeyMaxValue] doubleValue]] ;
    [progressView setDoubleValue:[[userInfo objectForKey:constKeyCurrentValue] doubleValue]] ;
}

- (void)displayProgressIndeterminateWithYieldee:(NSString*)yieldee
                                           info:(NSDictionary*)info {
    if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        return ;
    }

    BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument] ;
    NSString* readingOrWriting = [info objectForKey:constKeyActionName] ;
    NSString* message = [NSString stringWithFormat:
                         @"%@ Safari : Waiting by %@ : Might be almost done!",
                         [readingOrWriting capitalizedString],
                         yieldee] ;
    SSYProgressView* progressView = [bkmxDoc progressView] ;
    [progressView setIndeterminate:YES
                 withLocalizedVerb:message
                          priority:SSYProgressPriorityRegular] ;
}

+ (NSString*)fullDiskAccessReport {
    NSString* report = nil;
    NSError* error = nil;
    BOOL ok = [ExtoreSafari preflightThisUserSafariAccessError_p:&error];
    if (ok) {
        if (error) {
            report = [NSString stringWithFormat:
                      @"%@ DOES apparently have access to Safari bookmarks, although Error %ld in %@ was reported: %@",
                      [[NSProcessInfo processInfo] processName],
                      error.code,
                      error.domain,
                      error.localizedDescription];
        } else {
            report = [NSString stringWithFormat:
                       @"%@ DOES have access to Safari bookmarks.",
                       [[NSProcessInfo processInfo] processName]];
        }
    } else {
        if (error) {
            report = [NSString stringWithFormat:
                      @"%@ does NOT have access to Safari bookmarks.  Error %ld in %@ was reported: %@",
                      [[NSProcessInfo processInfo] processName],
                      error.code,
                      error.domain,
                      error.localizedDescription];
        } else {
            report = [NSString stringWithFormat:
                       @"%@ does NOT have access to Safari bookmarks.",
                       [[NSProcessInfo processInfo] processName]];
        }
    }
    
    report = [report stringByAppendingString:@"\n"];
    
    return report;
}

+ (BOOL)preflightFileAccessForPath:(NSString*)path
                           error_p:(NSError**)error_p {
    BOOL ok = YES;
    NSError* error = nil;
    NSData* data = nil;
    if (path) {
        ok = [[NSFileManager defaultManager] fileExistsAtPath:path];
        if (ok) {
            data = [NSData dataWithContentsOfFile:path];
            if (!data) {
                NSLog(@"Apparently no access to %@", path);
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    NSString* desc = [[NSString alloc] initWithFormat:
                                      @"%@ cannot access Safari bookmarks",
                                      [[BkmxBasis sharedBasis] appNameLocalized]];
                    NSInteger code = [[BkmxBasis sharedBasis] isBkmxAgent] ? constAgentCannotAccessSafariBookmarks : constMainAppCannotAccessSafariBookmarks;
                    error = SSYMakeError(code, desc);
                    [desc release];
                    error = [self fillOutFileAccessError:error];
                }
            }
        } else {
            /* Surprisingly, Mojave allows us to read the ~/Library/Safari
             directory even if we don't have access to read the files in it.
             So this branch is actually taken on the rare occacion of missing
             Bookmarks.plist file. */
            error = [NSError errorWithDomain:[NSError myDomain]
                                        code:823411
                                    userInfo:@{
                                               NSLocalizedDescriptionKey : NSLocalizedString(@"Cannot tell if we can access Safari bookmarks or not because the Safari Bookmarks file does not exist.", nil),
                                               NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Maybe you have never used Safari on this macOS user account.", nil),
                                               NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Launch Safari and change your bookmarks somehow.", nil)
                                               }];
        }
    }

    if (error && error_p) {
        *error_p = error ;
    }

    return (data != nil);
}

+ (BOOL)preflightThisUserSafariAccessError_p:(NSError**)error_p {
    BOOL ok = NO;
    NSError* error = nil;
    Clientoid* clientoid = [Clientoid clientoidThisUserWithExformat:constExformatSafari
                                                        profileName:nil];
    NSString* path = [clientoid filePathError_p:&error];
    if (path) {
        ok = [ExtoreSafari preflightFileAccessForPath:path
                                              error_p:&error];
    }

    if (error && error_p) {
        *error_p = error;
    }

    return ok;
}

- (BOOL)preflightFileAccess {
    BOOL ok = NO;
    NSError* error = nil;
    NSString* path = [self filePathError_p:&error];
    if (path) {
        ok = [[self class] preflightFileAccessForPath:path
                                              error_p:&error];
    }

    if (error) {
        self.error = error;
    }

    return ok;
}

- (void)prepareBrowserForImportWithInfo:(NSMutableDictionary*)info {
    if (![[BkmxBasis sharedBasis] verifyVersionIsAdequate]) {
        [[BkmxBasis sharedBasis] logString:@"Abort import cuz need to upgrade app"];
        self.error = [[BkmxBasis sharedBasis] versionInadequateError];
        [self sendIsDoneMessageFromInfo:info];
        return;
    }

    if (![self preflightFileAccess]) {
        [self sendIsDoneMessageFromInfo:info];
        return;
    }

    // Since this branch only executes if extoreMedia is constBkmxExtoreMediaThisUser,
    // we use this:
    NSString* directory = [[self clientoid] filePathParentError_p:NULL] ;
    // instead of this:
    // NSString* path = [[self workingFilePathError_p:NULL] stringByDeletingLastPathComponent] ;
    // although both should give the same answer
    [info setObject:directory
             forKey:constKeyFilePathParent] ;

    [NSThread detachNewThreadSelector:@selector(prepareBrowserForImportThreadedWithInfo:)
                             toTarget:self
                           withObject:info] ;
}

/*!
 @details  Warning.  This method runs in a secondary thread.
 */
- (void)prepareBrowserForImportThreadedWithInfo:(NSMutableDictionary*)info {
    if ([self ixportSubstyle] == IxportSubstyleSendToSheepSafariHelper) {
        // Report success and do nothing :)
        [info setObject:[NSNumber numberWithBool:YES]
                 forKey:constKeySucceeded] ;

        [self performSelectorOnMainThread:@selector(sendIsDoneMessageFromInfo:)
                               withObject:info
                            waitUntilDone:NO] ;
    } else if ([self ixportSubstyle] == IxportSubstyleOverwriteFile) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
        // Since this branch only executes if extoreMedia is constBkmxExtoreMediaThisUser,
        // we use this:
        NSString* directory = [info objectForKey:constKeyFilePathParent] ;
        // instead of this:
        // NSString* path = [[self workingFilePathError_p:NULL] stringByDeletingLastPathComponent] ;
        // although both should give the same answer

        BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument] ;

        NSTimeInterval timeout = [self timeoutForIcloudWithBkmxDoc:bkmxDoc] ;
        NSString* yieldeeName = nil ;
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         @"reading", constKeyActionName,
                                         bkmxDoc, constKeyDocument,
                                         [NSNumber numberWithDouble:timeout], constKeyMaxValue,
                                         nil] ;
        NSError* error = nil;
        BOOL iCloudIsInUse = [self isSyncActiveError_p:&error];
        NSAssert(error == nil, @"Internal Error 381-8414: %@", error);
        SafariSyncGuardianResult result = [SafariSyncGuardian blockUntilSafeToWriteInDirectory:directory
                                                                                 iCloudIsInUse:iCloudIsInUse
                                                                                       timeout:timeout
                                                                                 yieldeeName_p:&yieldeeName
                                                                          progressUpdateTarget:self
                                                                                      selector:@selector(displayProgressWithYieldee:userInfo:)
                                                                                      userInfo:userInfo
                                                                      progressAlmostDoneTarget:self
                                                                                      selector:@selector(displayProgressIndeterminateWithYieldee:info:)
                                                                            progressDoneTarget:[bkmxDoc progressView]
                                                                                      selector:@selector(clearAll)] ;

        BOOL ok = [self processGuardianResult:result
                                     polarity:BkmxIxportPolarityImport
                                  yieldeeName:yieldeeName
                                      timeout:timeout
                                         info:info] ;

        [info setObject:[NSNumber numberWithBool:ok]
                 forKey:constKeySucceeded] ;

        // Because the lock was locked on the main thread, we must
        // unlock it on the main thread.
        [self performSelectorOnMainThread:@selector(sendIsDoneMessageFromInfo:)
                               withObject:info
                            waitUntilDone:NO] ;

        [pool release] ;
    } else {
        NSAssert(NO, @"Should have ixportSubstyle here");
    }
}

/*
 Prior to BookMacster 1.9.8, this method was named -prepareBrowserForWritingWithInfo:error_p,
 and it was invoked by operation selector -prepareBrowserForWriting which was queued to
 run *after* merging.  That was bad because iCloud or Safari could write changes to bookmarks
 between -readExternal and -prepareBrowserForWritingWithInfo:error_p and these changes would
 be overwritten.  By making this -prepareBrowserForExportWithInfo: instead, it is
 invoked by the operation selector -prepareBrowserForExport, which runs *before* readExternal.
 The disadvantage of this is that we are now locking the Bookmarks.plist file for a longer
 time, in fact, for our entire import, merge, and export.  But that's the way it goes if
 you want to do things correctly.  When you're working on data as though it is constant, you
 need to keep others from touching it.   However, an advantage of this, besides the fact that
 it is leakproof, is that we can now blind the trigger so that we are not retriggered by our
 own touching of the file.  Here's how it works:
 
 Lock the file
 Read the file (readExternal)
 Merge, sort, whatever
 Blind the trigger, in -[OperationExport prepareTriggersForExportStyle:]
 Write the file
 Wait 2.5 seconds due to launchd bug
 Unblind the trigger, in -[OperationExport writeAndDeleteDidSucceed_unsafe]
 Remove the lock
 
 See, no leaks and no false self-triggering
 */
- (void)prepareBrowserForExportWithInfo:(NSMutableDictionary*)info {
    NSError* error = nil;
    if (![[BkmxBasis sharedBasis] verifyVersionIsAdequate]) {
        [[BkmxBasis sharedBasis] logString:@"Aborting cuz need to upgrade app"];
        self.error = [[BkmxBasis sharedBasis] versionInadequateError];
        [self sendIsDoneMessageFromInfo:info];
        return;
    }

    NSString* filePathParent = [[self clientoid] filePathParentError_p:NULL] ;
    [info setObject:filePathParent
             forKey:constKeyFilePathParent] ;

    if (![[[self clientoid]  extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
        [self sendIsDoneMessageFromInfo:info];
    }

    if (![self preflightFileAccess]) {
        [self sendIsDoneMessageFromInfo:info];
        return;
    }

    OwnerAppRunningState runningState = [self ownerAppRunningStateError_p:&error] ;
    if (runningState == OwnerAppRunningStateError) {
        self.error = error;
        [self sendIsDoneMessageFromInfo:info];
    }
    else if (runningState != OwnerAppRunningStateNotRunning) {
        // Safari is running

        // We want the "An Syncer's Worker is currently syncing possible changes…"
        // sheet to block the document window, but we don't need to block the main
        // thread, which we are now on.  This operation has a handy callback, so, we
        // take advantage of that now by running this on a secondary thread…
        [NSThread detachNewThreadSelector:@selector(prepareBrowserForExportThreadedWithInfo:)
                                 toTarget:self
                               withObject:info] ;
    } else {
        [NSThread detachNewThreadSelector:@selector(prepareBrowserForExportThreadedWithInfo:)
                                 toTarget:self
                               withObject:info] ;
    }
}

- (BOOL)exportCheckStuffMidwayError_p:(NSError**)error_p {
    BOOL ok = YES;
    NSError* error = nil;
    
    /* Requirement 1.  Check for any more than 500 items in any folder.  The
     500 item limit is explained by Apple in the fourth bullet point on this
     web page:
     https://support.apple.com/en-us/HT203519 */
    NSMutableDictionary* overages = [NSMutableDictionary new];
    for (NSDictionary* hardFolder in [self extoreRootsForExport]) {
        [hardFolder recursivelyPerformOnChildrenUpperSelector:@selector(getOverlimitFolderNames:)
                                                   withObject:overages];
    }
    if (overages.count > 0) {
        ok = NO;
        NSString* key =
        @"You have more than %ld items in %ld folders.  "
        @"Apple has stated that iCloud will mix up the excess items.  "
        @"This will cause syncing trouble sooner or later.\n\n"
        @"The current export has therefore been aborted.  To export, "
        @"you must reduce the number of items in the large folders, listed below.  "
        @"Suggestion: Divide them up into smaller folders.  "
        @"Then, retry the export to Safari." ;
        NSString* format = NSLocalizedString(key, nil);
        format = [format stringByAppendingString:@"\n\n"];
        NSString* list = [overages description];
        format = [format stringByAppendingString:list];
        NSString* desc = [NSString stringWithFormat:
                          format,
                          [[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constICloudFolderLimit],
                          overages.count];
        error = SSYMakeError(394841, desc);
        error = [error errorByAddingHelpAddress:constHelpAnchorICloudFolderLimit];
    }
    [overages release];
    
    
    /* In the extremely unlikely event that someone's export failes both
     Requirement 1 and Requirement 2, the error will only mention
     Requirement 1.  Requirement 2 will be flagged after they fix
     Requirement 1 and re-run. */
    if (!error) {
        error = [SafariDupeAtRootChecker errorFromRootStarks:self.starker.root.children];
        ok = (error == nil);
    }

    if (error && error_p) {
        *error_p = error ;
    }

    return ok;
}

#define MINUTES_FOR_ICLOUD_SIGNIFICANT_CHANGES 20

- (NSString*)doPostExportTasksAndGetMessageToUserForChangeCounts:(SSYModelChangeCounts)changeCounts {
    NSString* msg = nil;
    if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
        NSInteger significantChangeCount = changeCounts.added + changeCounts.moved + changeCounts.updated;
        if (significantChangeCount > 250) {
            NSError* error = nil;
            if ([self isSyncActiveError_p:&error]) {
                if (error == nil) {
                    NSString* triggerCause = [[self clientoid] sawChangeTriggerPath];
                    if ((error == nil) && (triggerCause != nil)) {
                        NSString* format = NSLocalizedString(
                                                             @"You have exported %ld significant changes to Safari.  It is best "
                                                             @"to give the system some time to digest these changes.\n\n"
                                                             @"If possible, please leave this computer online for at least %ld minutes.\n\n"
                                                             @"In any case, do not attempt any more exports to Safari from %@, "
                                                             @"and do not edit or add any bookmarks in Safari on any device.  "
                                                             @"%@ will not sync any changes you make during this period.",
                                                             nil);
                        msg = [NSString stringWithFormat:
                               format,
                               significantChangeCount,
                               MINUTES_FOR_ICLOUD_SIGNIFICANT_CHANGES,
                               [[BkmxBasis sharedBasis] appNameLocalized],
                               [[BkmxBasis sharedBasis] appNameLocalized]
                               ];

                        NSDate* uninhibitDate = [NSDate dateWithTimeIntervalSinceNow:(60 * MINUTES_FOR_ICLOUD_SIGNIFICANT_CHANGES)];

                        [[NSUserDefaults standardUserDefaults] setUninhibitDate:uninhibitDate
                                                                forTriggerCause:triggerCause];

                        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                    logFormat:
                         @"User warned!  No touch Safari til %@ uninhibit",
                         [uninhibitDate geekDateTimeString]];
                    }
                }
            }
        }
    }

    return msg;
}

/*!
 @details  Warning.  This method runs in a secondary thread.
 */
- (void)prepareBrowserForExportThreadedWithInfo:(NSMutableDictionary*)info {
    if ([self ixportSubstyle] == IxportSubstyleSendToSheepSafariHelper) {
        /* Do nothing, just signal that we're done.  We do not need to abscond
         or create ~/Library/Safari/lock/ because the Safari private private
         apparently does that for us (you can watch it and see).  I don't know
         what the effect of it is!  Presumably, at some points it may cause
         Safari to display "You can't change your bookmarks now", but that does
         not seem to happen usually. */
        [self performSelectorOnMainThread:@selector(sendIsDoneMessageFromInfo:)
                               withObject:info
                            waitUntilDone:NO] ;
    } else {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;

        BOOL ok = YES ;

        // Prior to BookMacster 1.9.8, the following code was inside the above "Safari is running"
        // branch, so that SafariSyncGuardian was only consulted in Safari was running.  This
        // was incorrect, for SafariDAVClient in particular, because SafariDAVClient can keep
        // running long after Safari as been quit.

        // Since this branch only executes if extoreMedia is constBkmxExtoreMediaThisUser,
        // we use this:
        NSString* directory = [info objectForKey:constKeyFilePathParent] ;

        // instead of this:
        // NSString* path = [[self workingFilePathError_p:NULL] stringByDeletingLastPathComponent] ;
        // although both should give the same answer
        // Now we apply a file lock.
        // See "STUDY OF SAFARI FILE LOCKS", below for more info

        BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument] ;
        NSTimeInterval timeout = [self timeoutForIcloudWithBkmxDoc:bkmxDoc] ;
        // Yes, SSYProgressView is thread-safe.
        SSYProgressView* progressView = nil;
        if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
            NSString* verb = [[NSString alloc] initWithFormat:
                              @"Will wait up to %ld seconds for iCloud to sync",
                              (long)timeout] ;
            progressView = [[bkmxDoc progressView] setIndeterminate:YES
                                                  withLocalizedVerb:verb
                                                           priority:SSYProgressPriorityRegular] ;
#if !__has_feature(objc_arc)
            [verb release] ;
#endif
        }

        NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         @"writing", constKeyActionName,
                                         bkmxDoc, constKeyDocument,
                                         [NSNumber numberWithDouble:timeout], constKeyMaxValue,
                                         nil] ;
        NSString* yieldeeName = nil ;

        NSError* error = nil;
        BOOL iCloudIsInUse = [self isSyncActiveError_p:&error];
        NSAssert(error == nil, @"Internal Error 381-8413: %@", error);
        SafariSyncGuardianResult result = [SafariSyncGuardian blockUntilSafeToWriteInDirectory:directory
                                                                                 iCloudIsInUse:iCloudIsInUse
                                                                                       timeout:timeout
                                                                                 yieldeeName_p:&yieldeeName
                                                                          progressUpdateTarget:self
                                                                                      selector:@selector(displayProgressWithYieldee:userInfo:)
                                                                                      userInfo:userInfo
                                                                      progressAlmostDoneTarget:self
                                                                                      selector:@selector(displayProgressIndeterminateWithYieldee:info:)
                                                                            progressDoneTarget:progressView
                                                                                      selector:@selector(clearAll)] ;
        ok = [self processGuardianResult:result
                                polarity:BkmxIxportPolarityExport
                             yieldeeName:yieldeeName
                                 timeout:timeout
                                    info:info] ;

        [info setObject:[NSNumber numberWithBool:ok]
                 forKey:constKeySucceeded] ;

        if (ok) {
            BOOL acquireLockThisTime = [[info objectForKey:constKeySecondPrep] boolValue] ;
            if (acquireLockThisTime) {
                [SafariSyncGuardian abscondLockForDirectory:directory] ;
                /* Add this directory to `info`, to unlock it later. */
                NSMutableArray* directories = [info objectForKey:constKeySafariLockDirectories] ;
                if (!directories) {
                    directories = [NSMutableArray array] ;
                    [info setObject:directories
                             forKey:constKeySafariLockDirectories] ;
                }
                [directories addObject:directory] ;
            }
        }

        // Because the lock was locked on the main thread, we must
        // unlock it on the main thread.
        [self performSelectorOnMainThread:@selector(sendIsDoneMessageFromInfo:)
                               withObject:info
                            waitUntilDone:NO] ;

        [pool release] ;
    }
}

- (void)appendAddChangeForStark:(Stark*)stark
                        toArray:(NSMutableArray*)addAndModifyChanges {
    NSString* bookmarkType = ([StarkTyper isContainerGeneralSharype:[stark sharypeValue]])
    ? constKeySafariDavChangedBookmarkTypeFolder
    : constKeySafariDavChangedBookmarkTypeBookmark ;
    NSDictionary* changeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               [SSYUuid uuid], constKeySafariDavChangeToken,
                               constKeySafariDavChangeTypeAdd, constKeySafariDavChangeType,
                               bookmarkType, constKeySafariDavChangedBookmarkType,
                               [stark exid], constKeySafariDavChangedBookmarkUuid,
                               nil] ;
    // It's pretty easy to make SafariDAVClient crash.  One way is by not
    // giving it a BookmarkUUID (exid).  So we have defensive programming
    // to ensure that changeDic is fully populated before adding it…
    if ([changeDic count] > 3) {
        [addAndModifyChanges addObject:changeDic] ;
    }
    else {
        NSLog(@"Internal Error 624-1814  No exid for %@ in %@", [stark shortDescription], changeDic) ;
    }
}

- (void)appendModifyChangeForStange:(Stange*)stange
                            toArray:(NSMutableArray *)addAndModifyChanges {
    if ([[stange updates] count] > 0) {
        Stark* stark = [stange stark] ;
        NSString* exid = [stark exid];

        // It's pretty easy to make SafariDAVClient crash.  One way is by not
        // giving it a BookmarkUUID (exid).  So we use some defensive
        // programming here…
        if (!exid) {
            NSLog(@"Internal Error 624-1815  No exid for %@", [stark shortDescription]) ;
        } else {
            NSDictionary* changeDic;
            NSString *bookmarkServerId = [[stark ownerValueForKey:constKeySafariSyncInfo] objectForKey:constKeySafariDavServerID] ;
            NSString* bookmarkType = ([StarkTyper isContainerGeneralSharype:[stark sharypeValue]])
            ? constKeySafariDavChangedBookmarkTypeFolder
            : constKeySafariDavChangedBookmarkTypeBookmark ;
            changeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [SSYUuid uuid], constKeySafariDavChangeToken,
                         constKeySafariDavChangeTypeModify, constKeySafariDavChangeType,
                         bookmarkType, constKeySafariDavChangedBookmarkType,
                         exid, constKeySafariDavChangedBookmarkUuid,
                         bookmarkServerId, constKeySafariDavChangedBookmarkServerID,
                         nil] ;
            [addAndModifyChanges addObject:changeDic] ;
        }
    }
    else {
        // Apparently, the only modification(s) in this item is in
        // one or more of these collections:
        // • addedChildren
        // • deletedChildren
        // SafariDAVClient is not interested in any of these.  Of course it does
        // not need these, because these are implied by the Adds and Deletes.
    }
}

- (void)rollExidForStark:(Stark*)stark
          dummyClientoid:(Clientoid*)dummyClientoid {
    Clientoid* actualClientoid = [self clientoid];
    // SafariDAVClient requires a new exid for the "Add" change,
    // and for Moshes, in the "Modify" Change
    // but we'll need the old one after we cull children for the
    // "Delete" change.  Stash the old exid in a dummy clientoid.
    NSString* oldExid = [stark exidForClientoid:actualClientoid] ;
    [stark setExid:oldExid
      forClientoid:dummyClientoid] ;
    // Now set a new exid.
    NSString* newExid = [SSYUuid uuid];
    // Not sure which or maybe both of the following statements are needed
    [stark setExid:newExid
      forClientoid:actualClientoid] ;
    [stark setExid:newExid];
    // The new exid we just set will be detected and fed back to
    // the mating stark in the BkmxDoc by -feedbackPostWrite.
}

- (void)diminishSyncInfoInStark:(Stark*)stark {
    // Bug Fix 2 of 4 for iCloud in BookMacster 1.13.6.  Moved or moshed
    // items should have their 'Sync' key stripped when appearing in the tree,
    // although 'Sync' is still needed in the Sync ▸ Changes section in the
    // Delete record.
    NSDictionary* syncDic = [stark ownerValueForKey:constKeySafariSyncInfo] ;
    [stark setOwnerValue:syncDic
                  forKey:constKeyDeletedSyncInfo] ;
    [stark setOwnerValue:nil
                  forKey:constKeySafariSyncInfo] ;
}

- (void)recordDeletionOfStark:(Stark*)stark
                           in:(NSMutableArray*)deletingStarks {
    [self diminishSyncInfoInStark:stark] ;
    [deletingStarks addObject:stark] ;
}

- (BOOL)isSyncActiveError_p:(NSError **)error_p {
    BOOL answer = NO;
    NSError* error = nil;
    if ([[self fileProperties] respondsToSelector:@selector(objectForKey:)]) {
        NSDictionary* syncInfo = [[[self fileProperties] objectForKey:constKeyRootAttributes] objectForKey:constKeySafariSync_Root];
        /* In macOS 10.12.5 and earlier, syncInfo was present only when
         iCloud Safari was on, and it had only one key,
         SyncInfo (=constKeySafariSync_Root).

         Prior to BkmkMgrs 2.4.8 therefore, I determined if iCloud was in use by
         merely looking for presence of constKeySafariSync_Root.

         In macOS 10.12.6, probably starting with 10.12.6 Beta 6 (16G24b), or
         possibly Beta 5, and remotely possibly Beta 4, key SyncInfo is always
         present.  When iCloud Safari is on, it has four keys:

         • CloudKitDeviceIdentifier
         • CloudKitMigrationState
         • HomeURL
         • ServerData (=constKeySafariServerData)

         When iCloud Safari is off, the last two disappear. and you have only

         • CloudKitDeviceIdentifier
         • CloudKitMigrationState

         Well, to fix this then in BkmkMgrs 6.4.8, I did the obvious change, which
         is now instead of looking merely for the key "Sync", I look for
         "Sync.SyncData".  Without this change, we can think that syncing is on
         when it is fact off, which causes us to launch Thomas unnecessarily, which
         causes Thomas to go into its infinite loop (which I've seen before)
         wherein SafariDAVClient runs for 5-30 seconds, then terminates, and then
         a new one launches.  This of course causes Thomas to display a error
         dialog asking if we should Wait X seconds Longer or just Ignore.

         If SafariDAVClient does get into such a infinite loop, there are two ways
         to stop it:

         • Log out and back in.
         • Turn syncing off and back on several times, maybe doing a export from
         BkmkMgrs app.  I'm not sure if there are reproducible steps, but I was
         able to succesfully stop it twice by doing this.

         However, things changed again in macOS 10.13.1, when the
         CloudKitMigrationState may go to 3!  When CloudKitMigrationState is 3,
         you *always* have all four keys, and there is no apparent change in
         Bookmarks.plist when syncing is switched on or off.  Also,
         surprisingly, Changes are written to the Bookmarks.plist file even
         when syncing is off, as explained in Note 20171020.  There is
         apparently a very nice private API to determine whether syncing is on
         or off, but it looks like it does not work because of an apparent
         security wall.  See Note 20171021 in SheepSafariHelper.m.

         The only way I've determined to tell whether or not syncing is on when
         CloudKitMigrationState is 3 is to add and remove a bookmark and see if
         this results in unwhoosed Changes.  I started to write code to do that,
         but then realized it was not necessary because, with Safari, it doesn't
         matter because, in the case where CloudKitMigrationState is 3, our
         behavior is the same whether iCloud syncing is on or off.

         Interesting fact discovered on 2019-03-01: When CloudKitMigrationState
         is 2, Safari will not let you change bookmarks.  User gets this
         alert dialog:
         You can’t change bookmarks now.
         You can’t change your bookmarks right now because they are being synchronized. Wait a few minutes, and then try again.
         */

        NSInteger cloudKitMigrationStateValue = 0;
        NSNumber* cloudKitMigrationState = [syncInfo objectForKey:constKeySafariCloudKitMigrationState];
        if ([cloudKitMigrationState respondsToSelector:@selector(integerValue)]) {
            cloudKitMigrationStateValue = [cloudKitMigrationState integerValue];
        }

        if (cloudKitMigrationStateValue <= 1) {
            answer = [syncInfo valueForKey:constKeySafariServerData] != nil;
        } else {
            answer = YES;
        }
    }
    else {
        error = SSYMakeError(284806, @"Cannot determine if iCloud is active. (Did we read Safari yet?)");
    }

    if (error && error_p) {
        *error_p = error ;
    }

    return answer;
}

- (void)pushPushDataWithCkms:(NSInteger)ckms
               ixportSubstyle:(NSString*)style {
    dispatch_queue_t aSerialQueue = dispatch_queue_create(
                                                          "com.sheepystems.PushSafariPushStats",
                                                          DISPATCH_QUEUE_SERIAL
                                                          );
    dispatch_async(aSerialQueue, ^{
        NSData* hash = [SSYIOKit hashedMACAddressAndShortUserName];
        /* For our purposes, we don't need all 32 bytes, and it makes the
         database too hard to read.  So let's take only 32/4 bytes: */
        hash = [hash subdataWithRange:NSMakeRange(0, hash.length/4)];

        NSString* encodedHash = nil;
        if (hash) {
            encodedHash = [hash stringBase64Encoded];
            encodedHash = [encodedHash encodePercentEscapesPerStandard:SSYPercentEscapeStandardRFC3986];
        }

        NSString* hardwareModel = [SSYSystemDescriber hardwareModel];
        NSString* macOSVersion = [[SSYSystemDescriber softwareVersionTriplet] string];

        NSString* urlString = [NSString stringWithFormat:
                               @"https://sheepsystems.com/cgi-bin/live/Statter.pl?userID=%@&sysHW=%@&sysSW=%@&lastCkms=%ld&lastPush=%@&countThomas=%ld&countSheepSafariHelper=%ld&pushPref=%ld",
                               encodedHash,
                               hardwareModel,
                               macOSVersion,
                               ckms,
                               style,
                               [[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeySafariPushCountThomas],
                               [[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeySafariPushCountSheepSafariHelper],
                               [[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeySafariPushStyle]
                               ];
        NSURL* url = [NSURL URLWithString:urlString];
        NSURLRequest* request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringCacheData
                                             timeoutInterval:60.0] ;
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionUploadTask* uploadTask = [session uploadTaskWithRequest:request
                                                                   fromData:[NSData data]];
        [uploadTask resume];
    });
}

- (IxportSubstyle)ixportSubstyle {
    /* It is OK to cache _ixportSubstyle because the lifetime of a Extore used for
     ixporting only lasts as long as the ixport operation. */
    if (_ixportSubstyle == IxportSubstyleUnknown) {
        NSString* extoreMedia = self.clientoid.extoreMedia;
        /* As of BkmkMgrs 2.5.1, 20171229, we use IxportSubstyleSendToSheepSafariHelper for
         all but rare cases of (a) user forcing it with the hidden preference
         or (b) macOS < 10.11.  The only reason for (b) is that I've never
         tested SheepSafariHelper in macOS 10.10, which is necessary due to SheepSafariHelper's
         using the Safari private framework.  If it worked, it would probably
         be better to use in 10.10 also. */
        NSString* cuz;
        IxportSubstyle preferredIxportSubstyle = (IxportSubstyle)[[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeySafariPushStyle];
        if ([extoreMedia isEqualToString:constBkmxExtoreMediaThisUser]) {
            switch (preferredIxportSubstyle) {
                case IxportSubstyleOverwriteFile:
                    _ixportSubstyle = IxportSubstyleOverwriteFile;
                    cuz = @"Pref";
                    break;
                case IxportSubstyleSendToSheepSafariHelper:
                    _ixportSubstyle = IxportSubstyleSendToSheepSafariHelper;
                    cuz = @"Pref";
                    break;
                case IxportSubstyleUnknown:
                case IxportSubstyleAutomatic:
                default: {
                    if (NSAppKitVersionNumber < NSAppKitVersionNumber10_11) {
                        if (self.initialCkmsFromPlistFile == -1) {
                            self.initialCkmsFromPlistFile = [self currentCkmsFromPlistFile];
                        }

                        if (self.initialCkmsFromPlistFile >= 2) {
                            _ixportSubstyle = IxportSubstyleSendToSheepSafariHelper;
                        } else {
                            _ixportSubstyle = IxportSubstyleOverwriteFile;
                        }
                        cuz = [NSString stringWithFormat:@"on disk CKMS=%ld", self.initialCkmsFromPlistFile];
                    } else {
                        _ixportSubstyle = IxportSubstyleSendToSheepSafariHelper;
                        cuz = @"macOS >= 10.11";
                    }
                    break;
                }
            }
        } else {
            _ixportSubstyle = IxportSubstyleOverwriteFile;
            cuz = @"Loose File";
        }

        NSString* style;
        switch (_ixportSubstyle) {
            case IxportSubstyleOverwriteFile:
                style = @"Thomas";
                break;
            case IxportSubstyleSendToSheepSafariHelper:
                style = @"SheepSafariHelper";
                break;
            default:
                NSAssert(false, @"Programming error");
                style = [NSString stringWithFormat:@"%d", _ixportSubstyle];
                break;
        }
        NSString* msg = [NSString stringWithFormat:
                         @"Safari Substyle = %@ cuz %@",
                         style,
                         cuz];
        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                    logFormat:msg];
    }

    return _ixportSubstyle;
}


- (BOOL)processExportChangesForOperation:(SSYOperation*)operation
                                 error_p:(NSError**)error_p {
    NSError* error = nil;
    BOOL iCloudActive = [self isSyncActiveError_p:&error];
    if (error) {
        if (error && error_p) {
            *error_p = error ;
        }

        return NO;

    }

    /* Note 20171020
     In the legacy push style, we did not write changes if iCloud was
     inactive.  In the new style, we always write changes.  Yes, that means
     that if iCloud is inactive we can have an unlimited number of
     Changes pile up in the Bookmarks.plist file.  I tried this in
     macOS 10.13.1 Beta 2 – by importing Chrome bookmarks, then undoing
     and redoing a bunch of times, I got 45,000 changes!  When I later
     activated iCloud Safari syncing, these changes quickly disappeared,
     and only thge first change, which I did not undo, was seen on another
     Mac.  Also, there was a comparatively small number, I think it was 1600
     lines logged to Console.app by SafariBookmarksSyncAgent.  Since SBSA
     normally logs, I think, 100 or more log lines per change, I conclude that
     the redundant changes must be eliminated here on the client; they are not
     sent to the server. */
    BOOL doThis = NO;
    if ([self ixportSubstyle] == IxportSubstyleOverwriteFile) {
        if (iCloudActive) {
            doThis = YES;
        }
    }
    if (!doThis) {
        return YES;
    }

    /**

     LOOK AT THAT EARLY RETURN.  UNDERSTAND THAT THE REMAINDER OF THIS METHOD
     EXECUTES ONLY FOR THE OLD  THOMAS PUSH STYLE.  FOR PAJARA, THE EQUIVALENT
     WORK IS DONE BY -[Extore changeInfoForOperation::]

     **/

    NSMutableDictionary* rootAttributes = [[self fileProperties] objectForKey:constKeyRootAttributes] ;

    // Added in BookMacster 1.13.6.  For some strange reason, Safari puts a new
    // WebBookmarkUUID in its root item whenever it writes changes.  It
    // probably doesn't matter, but let's do it…
    [rootAttributes setValue:[SSYUuid uuid]
                      forKey:constKeySafariWebBookmarkUUIDIdentifier] ;

    NSMutableDictionary* syncInfo = [[[rootAttributes valueForKey:constKeySafariSync_Root] mutableCopy] autorelease] ;

    NSString* const constOldExid = @"Old-Exid" ;
    Chaker* chaker = [(BkmxDoc*)[[operation info] objectForKey:constKeyDocument] chaker] ;
    NSMutableArray* deletingStarks = [[NSMutableArray alloc] init] ;
    NSMutableArray* addAndModifyChanges = [[NSMutableArray alloc] init] ;
    // This is used to stash the old exid for a "Delete" change…
    Clientoid* dummyClientoid = [Clientoid clientoidThisUserWithExformat:constExformatSafari
                                                             profileName:constOldExid] ;
    NSString* bookmarkServerId ;
    NSString* bookmarkType ;

    NSMutableArray* stangesArray = [[[chaker stanges] allValues] mutableCopy] ;
    [stangesArray sortUsingSelector:@selector(compareStarkPositions:)] ;

    BOOL cullRedundantSlides = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeySafariCullForThomas];

    NSMutableSet* redundantStanges = nil;
    if (cullRedundantSlides) {
        NSAssert(NO, @"See comment below");
        /* Using cullRedundantSlides requires that you uncomment the
         'Remember Old Relationships' section in Gulper.m, in order to get
         Stark.oldChildrenExids set. */

        /* In BookMacster 1.11, I noticed a problem with iCloud, which is that
         if we put moves which are not necessary into the addAndModifyChanges,
         (which get added into 'changes'), iCloud will apparently reject our change
         and overwrite whatever we did, restoring from the cloud.  Here's a
         simple example of what I mean by "not necessary".  Say that we start
         with three bookmarks in a folder: B, C, A, in that order.  Now we
         sort, so that the order is A, B, C.  Our stangesArray will have 3
         entries, one for the index change of each bookmark.  But iCloud will
         reject it if we put three entries in the Changes dictionary.
         Note that this change can be described with only one change, moving
         A to index 0, assuming that iCloud is smart enough to displace B
         and C as required to make room.  This is what iCloud wants.  Let's
         consider a more complicated example.  We start out with 10 bookmarks
         named a-j in a folder, then make some changes
            INDEX  BEFORE  AFTER
              0      a       a
              1      b       b
              2      c       r
              3      d       c
              4      e       d
              5      f       f
              6      g       e
              7      h       s
              8      i       g
              9      j       h
             10              j
         (Note that we ended up with 11 bookmarks, 1 more than we started with).
         Now there are only 3 bookmarks which did not change their indexes:
         a, b and f.  So we will have 11-3=8 stanges with index changes.
         However, we didn't make 8 changes.  We only made 4:
         • Moved or moshed in bookmark r from another folder, at index 2
         • Slid or sloshed bookmark d from index 3 to index 4
         • Inserted a new bookmark s at index 7
         • Deleted, moved out, or moshed out bookmark i.
         These 4 changes will exist in stangesArray.  However, there
         will also be a number of subordinate slides…
         • Slid c from 2 to 3
         • Slid e from 4 to 6
         • Slid g from 6 to 8
         • Slid h from 7 to 9
         • Slid j from 9 to 10

         You see, it is easier for the Safari engineers, because the only way
         bookmarks can change in Safari is by user interface actions.  They can
         record all of these actions as they happen.  In BkmkMgrs, on the other
         hand, we can have many changes as the result of multiple import, etc.
         which are too complicated to track.  The stanges which we have at this
         point may include redundant slides.  The way we get rid of them is to
         simulate the resulting children array by eliminating stanges one at a
         time, to see if any given stange makes a difference.  If not, it is added
         to a set of redundant stanges which we ignore when assembling the final
         array of stanges to be passed to Safari.  Note: I'm not sure that this is
         correct.  */

        NSMutableDictionary* indexChangesByParent = [[NSMutableDictionary alloc] init] ;
        /*
           Entries in indexChangesByParentId shall look like this:
             key: parentId, starkid of parent
             value: a mutable index set of relevantStangeIndexes
         */
        NSInteger stangeIndex = 0 ;
        for (Stange* stange in stangesArray) {
            SSYModelChangeAction changeType = [stange changeType] ;

            if (
                (changeType == SSYModelChangeActionInsert)
                || (changeType == SSYModelChangeActionMove)
                || (changeType == SSYModelChangeActionMosh)
                || (changeType == SSYModelChangeActionRemove)
                || (changeType == SSYModelChangeActionSlide)
                || (changeType == SSYModelChangeActionSlosh)
                ) {
                Stark* stark = [stange stark];
                Stark* parent = [stark parent];
                if (parent) {
                    NSValue* parentPointer = [NSValue valueWithPointer:parent] ;
                    NSMutableArray* relevantStanges = [indexChangesByParent objectForKey:parentPointer] ;
                    if (!relevantStanges) {
                        relevantStanges = [[NSMutableArray alloc] init] ;
                        [indexChangesByParent setObject:relevantStanges
                                                 forKey:parentPointer] ;
                        [relevantStanges release] ;
                    }

                    [relevantStanges addObject:stange] ;
                }

                /* Furthermore, the oldParent, if any might be affected… */
                if (
                    (changeType == SSYModelChangeActionMove)
                    || (changeType == SSYModelChangeActionMosh)
                    || (changeType == SSYModelChangeActionRemove)
                    ) {
                    Stark* stark = [stange stark];
                    Stark* oldParent = [stark oldParent];
                    if (oldParent) {
                        NSValue* parentPointer = [NSValue valueWithPointer:oldParent];
                        NSMutableArray* relevantStanges = [indexChangesByParent objectForKey:parentPointer] ;
                        if (!relevantStanges) {
                            relevantStanges = [[NSMutableArray alloc] init] ;
                            [indexChangesByParent setObject:relevantStanges
                                                     forKey:parentPointer] ;
                            [relevantStanges release] ;
                        }

                        [relevantStanges addObject:stange] ;
                    }
                }

            }

            stangeIndex++ ;
        }

        // Finding Redundant Slides Step 2.  Build a set of stanges which should be ignored
        redundantStanges = [NSMutableSet new];
        for (Stange* candidateStange in stangesArray) {
            if (candidateStange.changeType == SSYModelChangeActionSlide) {
                BOOL thisStangeIsNeeded = NO;
                for (NSValue* parentPointer in indexChangesByParent) {
                    Stark* parent = [parentPointer pointerValue];
                    NSArray* newChildrenExids = [[parent childrenOrdered] valueForKey:constKeyExid];
                    NSArray* oldChildrenExids = parent.oldChildrenExids;
                    NSArray* affectingStanges = [indexChangesByParent objectForKey:parentPointer];

                    NSMutableArray* simulatedChildrenExids = [oldChildrenExids mutableCopy];
                    for (Stange* stange in affectingStanges) {
                        if (stange != candidateStange) {
                            NSString* exid = [stange.stark exid];
                            if (exid) {
                                if ((Stark*)(stange.stark.oldParent) == (Stark*)parent) {
                                    [simulatedChildrenExids removeObject:exid];
                                }
                                if ([stange.stark parent] == parent) {
                                    [simulatedChildrenExids removeObject:exid];
                                    [simulatedChildrenExids insertObject:exid
                                                                 atIndex:stange.stark.index.integerValue];
                                }
                            }
                        }
                    }

                    if (![simulatedChildrenExids isEqualToArray:newChildrenExids]) {
                        thisStangeIsNeeded = YES;
                        break;
                    }
                }

                if (!thisStangeIsNeeded) {
                    [redundantStanges addObject:candidateStange];
                }
            }
        }
        [indexChangesByParent release];
    }

    for (Stange* stange in stangesArray) {
        if (!cullRedundantSlides || ([redundantStanges member:stange] == nil)) {
            Stark* stark = [stange stark] ;
            // Translate from the 7 possible SSYModelAction types
            switch ([stange changeType]) {
                case SSYModelChangeActionRemove:
                    // This case requires a *Delete* change.

                    // So it will be omitted when constructing the tree…
                    [stark setIsDeletedThisIxport] ;

                    [self recordDeletionOfStark:stark
                                             in:deletingStarks] ;

                    break ;
                case SSYModelChangeActionMove:
                    // This case requires stripping the sync info, a *Delete*
                    // change with the old exid and sync info, and an *Add*
                    // change with a new exid.
                case SSYModelChangeActionMosh: // (modified and moved)
                    // This case requires stripping the sync info, a *Delete*
                    // change with the old exid and sync info, an *Add* change
                    // with a new exid, and a *Modify* change with the new exid.

                    [self recordDeletionOfStark:stark
                                             in:deletingStarks] ;

                    [self rollExidForStark:stark
                            dummyClientoid:dummyClientoid] ;

                    [self appendAddChangeForStark:stark
                                          toArray:addAndModifyChanges] ;
                    if ([stange changeType] == SSYModelChangeActionMosh) {
                        [self appendModifyChangeForStange:stange
                                                  toArray:addAndModifyChanges] ;
                    }
                    break ;
                case SSYModelChangeActionInsert:;
                    // This case requires an *Add* change.
                    [self appendAddChangeForStark:stark
                                          toArray:addAndModifyChanges] ;
                    break ; // Added in BookMacster 1.14.10
                case SSYModelChangeActionSlosh:  // (modified and slid)
                case SSYModelChangeActionModify:
                case SSYModelChangeActionSlide:
                    // The above line was moved back up here in BookMacster 1.14.10.
                    /// A slide was ignored in BookMacster 1.13.6 thru 1.14.9 !!
                    // This case requires a *Modify* change.
                    [self appendModifyChangeForStange:stange
                                              toArray:addAndModifyChanges] ;
                    break;
                default:
                    break;
            }
        }
    }

    [redundantStanges release];
    [stangesArray release];

    // If an entire branch is being deleted, SafariDAVClient just wants one
    // change, to delete the root.  (At least, that's how Safari does it.)
    // We're therefore going to cull descendants, in two steps.

    // Culling Deletions Step 1.  Sort the raw deletions so that the rootmost are first.
    // I may be wrong, but I suspect that, this way we'll recursively eliminate
    // children as quickly as possible and this will be more efficient.  If I'm
    // wrong, well, I don't think it will be any worse than any other algorithm.
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lineageDepthObject"
                                                                   ascending:YES
                                                                    selector:@selector(compare:)] ;
    NSArray* descriptors = [NSArray arrayWithObjects:sortDescriptor, nil] ;
    [sortDescriptor release] ;
    [deletingStarks sortUsingDescriptors:descriptors] ;

    // Culling Deletions Step 2.  Do the actual culling.
    // Don't use a fast enumeration because we're going to modify deletingStarks
    // as we enumerate through it.  However, except in a very weird corner case
    // where someone has manually deleted many leaves or small folders instead
    // of deleting populous folders, this should be quick…
    for (NSUInteger i=0; i<[deletingStarks count]; i++) {
        Stark* stark = [deletingStarks objectAtIndex:i] ;
        NSArray* descendants = [stark descendantsWithSelf:NO] ;
        [deletingStarks removeObjectsInArray:descendants] ;
    }

    // If iCloud is currently not available, there may be prior changes already
    // in Bookmarks.plist ▸ Sync ▸ Changes.  We need to get that array out and
    // make it mutable so we can *append* our changes.
    NSMutableArray* changes = [[syncInfo valueForKey:constKeySafariDavChanges] mutableCopy] ;
    if (!changes) {
        changes = [[NSMutableArray alloc] init] ;
    }
    // Set back either the mutable copy of existing 'changes', or the new empty mutable 'changes'
    [syncInfo setObject:changes
                 forKey:constKeySafariDavChanges] ;
    [changes release] ;
    [rootAttributes setObject:syncInfo
                       forKey:constKeySafariSync_Root] ;

    // What it says…
    [changes addObjectsFromArray:addAndModifyChanges] ;
    [addAndModifyChanges release] ;

    // Process the culled deletingStarks, adding entries to 'changes'
    for (Stark* stark in deletingStarks) {
        bookmarkType = ([StarkTyper isContainerGeneralSharype:[stark sharypeValue]])
        ? constKeySafariDavChangedBookmarkTypeFolder
        : constKeySafariDavChangedBookmarkTypeBookmark ;
        // Get the old exid, which was set for a Move or Mosh
        NSString* exid = [stark exidForClientoid:dummyClientoid] ;
        if (!exid) {
            // Apparently this was a Delete.  The old exid
            // is still the current exid
            exid = [stark exid] ;
            NSAssert(exid != nil, @"Changed from -exidForClientoid:actualClientoid didn't work?");
        }
        // Note that, in either case above, whether exid is that of dummy
        // or actual clientoid, it is the exid that was entered into the
        // starkSyncDics dictionary in +starkFromExtoreNode:::.
        bookmarkServerId = [[stark ownerValueForKey:constKeyDeletedSyncInfo] objectForKey:constKeySafariDavServerID] ;
        NSDictionary* changeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [SSYUuid uuid], constKeySafariDavChangeToken,
                                   constKeySafariDavChangeTypeDelete, constKeySafariDavChangeType,
                                   bookmarkType, constKeySafariDavChangedBookmarkType,
                                   exid, constKeySafariDavChangedBookmarkUuid,
                                   bookmarkServerId, constKeySafariDavChangedBookmarkServerID,
                                   nil] ;
        // It's pretty easy to make SafariDAVClient crash.  One way is by not
        // giving it a BookmarkUUID (exid).  So we make sure of that…
        if ([changeDic count] > 3) {
            [changes addObject:changeDic] ;
        }
        else {
            NSLog(@"Internal Error 624-1817  No exid for %@ in %@", [stark shortDescription], changeDic) ;
        }

        // Although I am 99% sure that 'stark' is going to be deleted and
        // and then likewise its in-memory managed object context will be
        // deleted, and therefore the following clean up will have no
        // effect, I do it for defensive programming…
        [stark setExid:nil
          forClientoid:dummyClientoid] ;
    }
    [deletingStarks release] ;

    /* We have previously set 'changes' into 'syncInfo' which has in
     turn been set into 'rootAttributes'.  So, we're done.  Those changes
     will be written to the Bookmarks.plist file.  */

    return YES;
}

- (NSArray*)extoreRootsForExport {
    SEL reformatter = [self reformatStarkToExtore] ;

    SSYTreeTransformer* transformer = [SSYTreeTransformer
                                       treeTransformerWithReformatter:reformatter
                                       childrenInExtractor:@selector(childrenOrdered)
                                       newParentMover:@selector(moveToChildrenUpperOfNewParent:)
                                       contextObject:self] ;

    // Transform root items, but keep the bar off to the side for now
    NSArray* bkmxDocRootChildren = [[[self starker] root] childrenOrdered] ;

    NSDictionary* safariRootChild = nil ;
    NSDictionary* safariBar = nil ;
    NSDictionary* safariUnfiled = nil ;
    NSMutableArray* usersRootChildren = [[NSMutableArray alloc] init] ;
    for (Stark* bkmxDocRootChild in bkmxDocRootChildren) {
        safariRootChild = [transformer copyDeepTransformOf:bkmxDocRootChild] ;
        [safariRootChild autorelease] ;
        if ([bkmxDocRootChild sharypeValue] == SharypeBar) {
            safariBar = safariRootChild ;
        }
        else if ([bkmxDocRootChild sharypeValue] == SharypeUnfiled) {
            NSMutableDictionary* unfiledMutant = [NSMutableDictionary dictionaryWithDictionary:safariRootChild] ;
            // Until BookMacster 1.9.9, I had a couple dozen lines of code here which
            // moved any folders in the Reading/Unsorted collection into Root.
            // TOO LATE!  At this point, Chaker's stanges have already been recorded,
            // so any change made here will be behind the back of Chaker.  More importantly,
            // the correction will not cancel out the previous move of the disallowed
            // folder into Reading/Unsorted by the Gulper.  Say that we have a folder in
            // Firefox' Unsorted Bookmarks and import that into BookMacster.  Or maybe
            // the user creates a folder in, or moves a folder to Reading/Unsorted.
            // Now we export to Safari.  Chaker will find that a change was made, and
            // thus we will export, when in fact during the export the folder will have
            // been moved back, here to Root, so in fact what we're exporting was exactly
            // the same as the previous export.  Then if iCloud is in use, and a Syncer
            // is watching Safari, when SafariDAVClient touches the file, we'll re-import,
            // Gulper will move it back into Reading/Unsorted, Chaker will have a change,
            // export will occur, at this point we'll again move it back into Root, and
            // there you go – an infinite loop of Syncer operations.  Yikes!!
            [unfiledMutant setObject:[NSNumber numberWithBool:YES]
                              forKey:@"ShouldOmitFromUI"] ;
            [unfiledMutant setObject:constKeySafariReadingListIdentifier
                              forKey:constKeySafariTitleIdentifier] ;

            safariUnfiled = unfiledMutant ;
        }
        else if (safariRootChild) {
            // This branch was just 'else' until BookMacster 1.16.4
            [usersRootChildren addObject:safariRootChild] ;
        }
        else {
            // The folling line added BookMacster 1.16.4
            NSLog(@"Warning 485-1995") ;
        }
    }

    NSArray* proxyCollections = [[self fileProperties] objectForKey:constKeyProxyCollections] ;
    // Now we've got our bar, unfiled, and other items (safariOtherRootItems) copied for Safari.

    /* The order that Safari puts root children in is:
     History (a Proxy Collection)
     Bar
     com.apple.ReadingList (Safari 5.1+ only)
     other folders added by user

     The other folders are already in rootChildren.
     */

    NSMutableArray* rootChildren = [[NSMutableArray alloc] init] ;
    NSInteger iProxy = 0 ;
    // Insert History, which should be the first item in proxyCollections
    if ([proxyCollections count] > iProxy) {
        /*
         ISSUE:

         If bookmarks are changed such that the *only* changes are to one or
         more URLs, then Safari will not read in the changes until after it is
         quit and relqunched, and if changes are made to bookmarks within Safari
         before such quitting, the URL changes exported from BookMacster will
         be lost.  This is particularly noticeable if user runs a Verify
         operation which updates many URLs, then exports to Safari.
         
         FIX:

         This little kludge changes the name of the "History" proxy to a
         unique name, which is apparently enough to "tickle" Safari so that it
         immediately reads in all changes from Bookmarks.plist, even if the
         only changes are only one or more URLs.  As far as I can see, the
         "History" proxy is no longer used anywhere and is merely a vestige of
         early Safari versions wherein, if I recall correctly, "History"
         appeared as a folder in the "Edit Bookmarks" window, which was then
         called "Show Bookmarks".
         
         OTHER FIXES TRIED:
         
         Changing the name, actually "Title" of the root, from an empty string
         to a similar unique string, but that had no effect.
         
         Changing the name of "History" by toggling the presence or absence of
         an additional space character " " at the end, that is, making it
         "History" or "History ", worked when I appended the space character but
         not when I deleted it.
         */
        NSMutableDictionary* history = [[proxyCollections objectAtIndex:iProxy++] mutableCopy] ;
        NSString* historyName = [history objectForKey:constKeySafariTitleIdentifier] ;
        historyName = [historyName stringByAppendingFormat:
                       @" %@",
                       [[NSDate date] geekDateTimeStringMilli]
                       ] ;
        [history setObject:historyName
                    forKey:constKeySafariTitleIdentifier] ;
        [rootChildren addObject:history] ;
        [history release] ;
    }
    if (safariBar) {
        [rootChildren addObject:safariBar] ;
    }
    // Insert the remaining proxy collections, if any
    while (iProxy < [proxyCollections count]) {
        [rootChildren addObject:[proxyCollections objectAtIndex:iProxy++]] ;
    }
    // Oddly, Reading List *follows* the proxy collections
    if (safariUnfiled) {
        [rootChildren addObject:safariUnfiled] ;
    }
    [rootChildren addObjectsFromArray:usersRootChildren] ;
    [usersRootChildren release] ;

    NSArray* answer = [NSArray arrayWithArray:rootChildren] ;
    [rootChildren release] ;

    return answer ;
}


/*
 Note: Thomas is my code word for Thomas the Tank Engine which can Push to
 iCloud.  I use the code word since I'd rather no one know about my
 SafariDAVClient trick.

 Thomas operates by creating an XPC connection to SafariDAVClient and then
 sending a message to it.  I don't know why it works, but I chose Thomas
 because it seems less invasive than unloading and reloading the agent,
 and is probably the way that Safari does it.

 In case Thomas ever fails me, another way to do this would be to unload and
 reload the safaridavclient agent.  Something like this…

 launchctl unload /System/Library/LaunchAgents/com.apple.safaridavclient.plist
 launchctl load /System/Library/LaunchAgents/com.apple.safaridavclient.plist

 Whoops!  It looks like that requires sudo in 10.13.1 due to SIP, and
 also there is no such agent loaded anyhow!!

 That worked in macOS 10.7.2 because the agent had a RunAtLoad key??
 The reason it has RunAtLoad is probably because, when a Mac account logs in,
 it should immediately check with iCloud and pull in any bookmarks changes
 it missed.

 The agent /System/Library/LaunchAgents/com.apple.safaridavclient.plist
 has three versions today (20120321) in Time Machine.
 • file modified 2011-07-21 does *not* have a RunAtLoad key
 • file modified 2011-10-16 *does* have a RunAtLoad key
 • file modified 2012-02-10 does *not* have a RunAtLoad key
 (The last one is the current version today, 2012-03-21)

 According to System Preferences ▸ Software Update ▸ Installed Software,
 • I updated to macOS 10.7.1 on 2011-08-17
 • I updated to macOS 10.7.2 on 2011-10-16
 • I updated to macOS 10.7.3 on 2012-02-10

 Conclusions:
 • That agent did *not* have a RunAtLoad key in macOS 10.7 or 10.7.1.
 • Apple added it for some reason in 10.7.2
 • then removed it for some reason in 10.7.3.

 Eeeeek!!!  What are they doing???

 Another observation: Since there are only these 3 versions in Time Machine,
 obviously this file is not changed in any way depending on whether
 it does not matter whether iCloud Bookmarks is switched ON or OFF, because
 I switch that on and off frequently.

 UPDATE 2014-08-19

 Yosemite Developer Preview 6.  The file
 /System/Library/LaunchAgents/com.apple.safaridavclient.plist
 still does NOT have a RunAtLoad key
 Interestingly, it now has a StartInterval of 82800, which is 23 hours.
 23 hours is certainly too long to avoid a call to AppleCare if someone's
 bookmarks are not syncing, but it is short enough to resolve the problem
 before AppleCare calls back?

 Also of interest is:
 /Users/jk/Library/LaunchAgents/com.apple.SafariBookmarksSyncer.plist
 This file is dated 2010 Sep 07.  That's correct: I said two thousand TEN.

 This user file HAS the RunAtLoad key, but its value is NO.  WatchPaths is
 {/Users/jk/Library/Safari/Bookmarks.plist}.

 ProgramArguments are pretty interesting…

 /Applications/Safari.app/Contents/SafariSyncClient.app/Contents/MacOS/SafariSyncClient
 --sync
 com.apple.Safari
 --entitynames
 com.apple.bookmarks.Bookmark,com.apple.bookmarks.Folder
 */

/*
 2012-04-20  Well now it seems that SafariDAVClient cancels the connection
 (Thomas gets a "connection interrupted" error) within a few seconds after
 Thomas sends SafariDAVClient its "pretty please" message, even though
 SafariDAVClient may run for several minutes after that doing the actual
 upload.  I don't know if this is new in macOS 10.7.3 or not.  So I adjusted
 both numbers downward, and added the _MAX

 2014-08-18  It took 21:35 minutes to upload 5065 items (4416 bookmarks)
 on our new Comcast service with is 5 Mb/sec up, 24-50 Mb/sec down.  That's
 0.26 seconds per bookmark.  Did it three times today with about the same
 results.  Apparently system speed is limited by Apple's server, not
 Comcast.

 2012-03-21  It took 535 seconds to upload 4336 bookmarks on our residential
 DSL line, with no other activity.  That's .12 seconds per bookmark.  No Netflix.

 ?Maybe 2012-01?  It took 430 seconds to upload 1500 bookmarks on our residential DSL line, while
 Colette was watching Netflix, although that shouldn't matter.  That's .29 seconds
 per bookmark.

 OK, we've got 130 Kb/sec upload speed.  A dial-up line may get 30
 Kb/sec.  So let's derate to .29*130/30 = 1.26 seconds per bookmark.  Derate by
 another factor of 2 for safetly, and we get…   */
#define SAFARI_DAV_CLIENT_SECONDS_PER_CHANGE 2.0
#define SAFARI_DAV_CLIENT_SECONDS_MIN 20.0
#define SAFARI_DAV_CLIENT_SECONDS_MAX 900.0

#define PUSH_PUSH_LAZINESS 10

- (BOOL)pushToCloudError_p:(NSError**)error_p {
#if 0
#warning Skipping Push to iCloud if Thomas
    NSLog(@"Skipping Thomas!");
    // To push manually, see comment below
    return YES ;
#endif

    BOOL ok;
    NSError* error = nil;
    BOOL iCloudIsInUse = [self isSyncActiveError_p:&error];
    NSAssert(error == nil, @"Internal Error 381-8412: %@", error);

    /* We only do this if we are using Thomas push style and iCloud is ON! */
    BOOL thomasPushCuzWroteFile = ([self ixportSubstyle] == IxportSubstyleOverwriteFile) && iCloudIsInUse;
    if (thomasPushCuzWroteFile) {
        NSString* msg = @"Will do Thomas";
        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                    logFormat:msg];

        NSDictionary* rootAttributes = [[self fileProperties] objectForKey:constKeyRootAttributes] ;
        NSDictionary* syncInfo = [rootAttributes valueForKey:constKeySafariSync_Root] ;
        NSInteger nChanges = [[syncInfo objectForKey:constKeySafariDavChanges] count] ;
        NSInteger timeoutSeconds = ceil(nChanges * SAFARI_DAV_CLIENT_SECONDS_PER_CHANGE) ;
        timeoutSeconds = MAX(timeoutSeconds, SAFARI_DAV_CLIENT_SECONDS_MIN) ;
        timeoutSeconds = MIN(timeoutSeconds, SAFARI_DAV_CLIENT_SECONDS_MAX) ;

        NSString* helperName = [[[BkmxBasis sharedBasis] appFamilyName] stringByAppendingString:@"-Thomas"] ;
        NSString* path = [[NSBundle mainAppBundle] pathForHelper:helperName] ;
        NSArray* args = [NSArray arrayWithObjects:
                         @"com.apple.safaridavclient.push",
                         [NSString stringWithFormat:@"%ld", (long)timeoutSeconds],
                         nil] ;
        NSDictionary* programResults = [SSYTask run:[NSURL fileURLWithPath:path]
                                          arguments:args
                                        inDirectory:nil
                                           stdinput:nil
                                            timeout:0.0];
        NSInteger exitStatus = [[programResults objectForKey:SSYTask.exitStatusKey] integerValue];
        NSError* error = [programResults objectForKey:SSYTask.errorKey];
        ok = (exitStatus == 0) ;

        if (ok) {
            [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:[NSDate date]
                                                                   forKey:constKeySafariPushLastThomas];
            NSInteger priorCount = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeySafariPushCountThomas];
            [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:@(priorCount + 1)
                                                                   forKey:constKeySafariPushCountThomas];
            if (priorCount % PUSH_PUSH_LAZINESS == 0) {
                if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeySendPerformanceData]) {
                    [self pushPushDataWithCkms:[[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeySafariPushPriorCkms]
                                 ixportSubstyle:@"Thomas"];
                }
            }
        }

        if (!ok && error_p) {
            *error_p = SSYMakeError(613098, @"An error occurred when BookMacster signalled macOS to push this export "
                                    @"up to iCloud.  Your changes were probably not pushed to iCloud.") ;
            *error_p = [*error_p errorByAddingUnderlyingError:error] ;
            [self setError:error] ;
        }
    } else {
        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                    logFormat:@"Not doing Thomas"];
        ok = YES;
    }

    return ok ;
}

- (NSTimeInterval)sheepSafariHelperRunningTime {
    return 0.0 - [self.sheepSafariHelperStartDate timeIntervalSinceNow];
}

- (NSString*)sheepSafariHelperStatusDescriptionForRunningTime:(NSTimeInterval)runningTime {
    return [NSString stringWithFormat:
            @"[%ldt,%0.1fs]",
            self.sheepSafariHelperCurrentTrialIndex,
            runningTime];
}

- (NSString*)sheepSafariHelperStatusDescription {
    return [self sheepSafariHelperStatusDescriptionForRunningTime:self.sheepSafariHelperRunningTime];
}

- (void)timeOutLoadTreeWithCompletionHandler:(void(^)(void))completionHandler {
    [self.sheepSafariHelperXpcConnection invalidate];
    self.sheepSafariHelperXpcConnection = nil;
    [self.sheepSafariHelperTimeoutTimer invalidate];
    self.sheepSafariHelperTimeoutTimer = nil;
    NSString* msg = NSLocalizedString(@"Pulling bookmarks from Safari took too long.", nil);
    NSError* error = SSYMakeError(398441, msg);
    msg = NSLocalizedString(@"Try to import or export from Safari (again).  If it does not work on the second try, maybe your Mac is having trouble starting new processes, and it may be time for a restart.", nil);
    /* The reason for the advice to restart is because I saw this happen
     repeatedly when my Air2, running macOS 10.14.4 Beta 2, was in a terrible
     state.  iTunes hung on launch.  Fan was blosing moderately.  Some stupid
     process named `diagnosticd` was consuming majority of CPU time.  The
     */
    error = [error errorByAddingLocalizedRecoverySuggestion:msg] ;
    error = [error errorByAddingUserInfoObject:[self sheepSafariHelperStatusDescription]
                                        forKey:@"SheepSafariHelper Running Status"] ;
    [self setError:error];
    completionHandler();
}

- (void)timeOut_macOS10_11_LoadTreeWithCompletionHandler:(void(^)(void))completionHandler {
    NSString* msg = [NSString stringWithFormat:
                     @"ReadDog: SheepSafariHelper timed out %@",
                     self.sheepSafariHelperStatusDescription];
    [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                logFormat:msg];
    [self timeOutLoadTreeWithCompletionHandler:completionHandler];
}

- (NSString*)customerDescription {
    NSString* version = [[NSBundle mainAppBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:
            @"?J%@ pid=%d %s %@",
            [Job serialStringForSerial:[[AgentPerformer sharedPerformer] nowWorkingJobSerial]],
            getpid(),
            getprogname(),
            version];
}

+ (NSError*)fillOutFileAccessError:(NSError *)error {
    /*
     Empirical data:
     macOS version -->          10.13.6      10.14.0 Beta 3
     NSFoundationVersionNumber  1454.900000  1542.110000
     NSAppKitVersionNumber      1561.600000  1643.100000
     */
    BOOL isSafariAccessError =
    (NSFoundationVersionNumber >= 1500.0) && (
                                              (error.code == constAgentCannotAccessSafariBookmarks)
                                              || (error.code == constMainAppCannotAccessSafariBookmarks)
                                              || (error.code == constHelperCannotAccessSafariBookmarks)
                                              );
    if (isSafariAccessError) {
        NSString* suggestion = @"Please click the '?' help button at the lower left to learn the latest advice regarding how to resolve this error.";
        error = [error errorByAddingLocalizedRecoverySuggestion:suggestion];
        error = [error errorByAddingIsOnlyInformational];
        error = [error errorByAddingDontShowSupportEmailButton];
        error = [error errorByAddingHelpUrl:[NSURL URLWithString:@"https://sheepsystems.com/discuss/YaBB.pl?num=1531491187/"]];
    }

    return error;
}

+ (BOOL)touchBookmarksPlistError_p:(NSError**)error_p {
    BOOL ok = YES;
    NSError* error = nil;
	Clientoid* clientoid = [Clientoid clientoidThisUserWithExformat:constExformatSafari
                                                        profileName:nil];
    NSString* path = nil;
    if (ok) {
        path = [clientoid filePathError_p:&error];
        if (!path) {
            ok = NO;
            error = [SSYMakeError(575874, @"Could not get path Safari data for testing touch detection") errorByAddingUnderlyingError:error];
        }
    }

    NSData* data = nil;
    if (ok) {
        data = [NSData dataWithContentsOfFile:path];
        if (!data) {
            ok = NO;
            error = SSYMakeError(236785, @"Could not get Safari data for testing touch detection");
        }
    }

    NSMutableDictionary* dic = nil;
    NSPropertyListFormat format = NSPropertyListBinaryFormat_v1_0;
    if (ok) {
        dic = [NSPropertyListSerialization propertyListWithData:data
                                                        options:NSPropertyListMutableContainers
                                                         format:&format
                                                          error:&error];
        if (!dic) {
            ok = NO;
            error = [SSYMakeError(938477, @"Could not decode Safari data for testing touch detection") errorByAddingUnderlyingError:error];
        }
        if (![dic isKindOfClass:[NSMutableDictionary class]]) {
            ok = NO;
            error = SSYMakeError(573709, @"Could not handle Safari data for testing touch detection");
        }
    }

    if (ok) {
        NSString* newUuid = [SSYUuid uuid];
        [dic setObject:newUuid
                forKey:constKeySafariWebBookmarkUUIDIdentifier];
        data = [NSPropertyListSerialization dataWithPropertyList:dic
                                                          format:format
                                                         options:0
                                                           error:&error];
        if (!data) {
            ok = NO;
            error = [SSYMakeError(938477, @"Could not encode Safari data for testing touch detection") errorByAddingUnderlyingError:error];
        }
    }

    if (ok) {
        ok = [data writeToURL:[NSURL fileURLWithPath:path]
                      options:NSDataWritingAtomic
                        error:&error];
        if (!ok) {
            error = [SSYMakeError(338222, @"Could not decode Safari data for testing touch detection") errorByAddingUnderlyingError:error];
        }
    }

    if (error && error_p) {
        *error_p = error ;
    }

    return ok;
}

- (void)processFileReadingError:(NSError*)error {
     NSString* domain = error.domain;
    /* In testing in macOS 10.14 Beta 3, the error has two underlying errors
     and will pass all of the tests indicated below.  This is quite strict, but
     this error should have been caught earlier.  In particular, in the next
     commit, I plan to preflight reading Bookmarks.plist in
     -prepareBrowserForImportWithInfo:. */
    if ((error.code == constBkmxErrorCouldNotAccessBookmarksData) && [domain isEqualToString:[NSError myDomain]]) {
        error = error.underlyingError;
        domain = error.domain;
        if ((error.code == 257) && [domain isEqualToString:NSCocoaErrorDomain]) {
            error = error.underlyingError;
            domain = error.domain;
            if ((error.code == 1) && [domain isEqualToString:NSCocoaErrorDomain]) {
                error = [[self class] fillOutFileAccessError:error];
            }
        }
    }

    [super processFileReadingError:error];
}

- (void)processImportedTree:(NSDictionary*)tree
                     caller:(NSString*) caller {
    NSError* error = nil;
    BOOL ok = [self makeStarksFromExtoreTree:tree
                                     error_p:&error];
    if (error) {
        [self setError:error];
    }
    NSString* msg = [NSString stringWithFormat:
                     @"Post SheepSafariHelper: makeStarks: %@ [%@] %@",
                     ok ? @"OK" : @"FAIL",
                     caller,
                     error ? [NSString stringWithFormat:@"Error %ld", [error code]] : @"No error"
                     ];
    [[BkmxBasis sharedBasis] trace:[msg stringByAppendingString:@"\n\n"]];
    [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                logFormat:msg];
}

/* Confused?  See Note SheepSafariHelperMethodsMap */
- (void)readWithSheepSafariHelperThenCompletionHandler:(void(^)(void))completionHandler {
    NSXPCConnection* connection = [[NSXPCConnection alloc] initWithServiceName:@"com.sheepsystems.SheepSafariHelper"];
    self.sheepSafariHelperXpcConnection = connection;
    [connection release];
    connection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(SheepSafariHelperProtocol)];
    [connection resume];

    __block void (^recursiveBlock)(NSDictionary*, NSDictionary*, NSError*);

    recursiveBlock = ^void (NSDictionary *tree, NSDictionary *results, NSError *error) {
        [self.sheepSafariHelperTimeoutTimer invalidate];
        self.sheepSafariHelperTimeoutTimer = nil;

        /* Apple documentation says to invalidate now.  It probably has no
         effect in our case because SheepSafariHelper kills itself with exit(0) when it
         is done.  I mean, it's probably already invalidated when SheepSafariHelper
         exits, which, by the way, probably has not happened yet. */
        [connection invalidate];
        self.sheepSafariHelperXpcConnection = nil;

        NSDictionary* issues = [results objectForKey:constKeySheepSafariHelperResultIssues];
        NSString* msg = [NSString stringWithFormat:
                         @"SheepSafariHelper read try: %@: %@ saFw=%@ \u279e Sleep %0.1f",
                         error ? @"Fail" : @"Good",
                         [self sheepSafariHelperStatusDescription],
                         [results objectForKey:constKeySheepSafariHelperResultSafariFrameworkTattle],
                         constSheepSafariHelperDyingBreatherDuration
                         ];
        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                    logFormat:msg];
        if (issues) {
            msg = [NSString stringWithFormat:
                   @"SheepSafariHelper had %ld nonfatal issues reading",
                   (long)issues.count];
            [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                        logFormat:
             @"%@.  See Error %@",
             msg,
             @(constBkmsErrorSheepSafariHelperHadIssuesReading)];
            NSError* error = SSYMakeError(constBkmsErrorSheepSafariHelperHadIssuesReading, msg);
            error = [error errorByAddingUserInfoObject:issues
                                                forKey:constKeySheepSafariHelperResultIssues];
            [[BkmxBasis sharedBasis] logError:error
                              markAsPresented:NO];
        }

        /* We place the delay here, instead of immediately before the
         retry, because we want the delay after a success as well
         as after a failure. */
        [NSThread sleepForTimeInterval:constSheepSafariHelperDyingBreatherDuration];

        BOOL done = NO;
        if (!error) {
            if ([[BkmxBasis sharedBasis] traceLevel] >= 5) {
                NSError* unlikelyError = nil;
                NSString* path = [[NSFileManager defaultManager] ensureDesktopDirectoryNamed:@"Bkmx-Trees-From-Clients"
                                                                                     error_p:&unlikelyError];
                if (unlikelyError) {
                    NSLog(@"Internal Error 523-4355 No JSON tree: %@", unlikelyError);
                } else {
                    NSData* data = [NSPropertyListSerialization dataWithPropertyList:tree
                                                                              format:NSPropertyListBinaryFormat_v1_0
                                                                             options:0
                                                                               error:&error];
                    NSString* filename = [NSString stringWithFormat:
                                          @"Tree-From-%@-%@",
                                          self.clientoid.displayName,
                                          [[NSDate date] compactDateTimeString]] ;
                    filename = [filename stringByAppendingPathExtension:@"plist"] ;
                    path = [path stringByAppendingPathComponent:filename];
                    [data writeToFile:path
                           atomically:YES];
                    if (unlikelyError) {
                        NSLog(@"Internal Error 523-4366 No write file: %@", unlikelyError);
                    }
                }
            }
            if ([NSThread isMainThread]) {
                [self processImportedTree:tree
                                   caller:@"Main"];
            } else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self processImportedTree:tree
                                       caller:@"Non-Main"];
                });
            }
            done = YES;
        } else if (self.sheepSafariHelperCurrentTrialIndex <= [[error.userInfo objectForKey:constKeyRetrialsRecommended] integerValue]) {
            NSString* msg = [NSString stringWithFormat:
                             @"SheepSafariHelper import fail; %ld/%ld cuz %ld",
                             (long)(self.sheepSafariHelperCurrentTrialIndex),
                             (long)[[[error userInfo] objectForKey:constKeyRetrialsRecommended] integerValue],
                             (long)[error code]
                             ];
            [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                        logFormat:msg];
            self.sheepSafariHelperCurrentTrialIndex = self.sheepSafariHelperCurrentTrialIndex + 1;
            self.isDoneReadingFromSheepSafariHelper = NO;
           [self readWithSheepSafariHelperThenCompletionHandler:completionHandler];
        } else {
            done = YES;
            [self setError:error] ;
        }

        if (done) {
            if ([NSThread isMainThread]) {
                self.isDoneReadingFromSheepSafariHelper = YES;
                completionHandler();
            } else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.isDoneReadingFromSheepSafariHelper = YES;
                    completionHandler();
                });
            }
        }
    };

    recursiveBlock = Block_copy(recursiveBlock);

    [[connection remoteObjectProxy] importForKlientAppDescription:[self customerDescription]
                                                completionHandler:recursiveBlock];

    Block_release(recursiveBlock);
}

/* Confused?  See Note SheepSafariHelperMethodsMap */
- (void)readWithWatchdoggedSheepSafariHelperThenCompletionHandler:(void (^)(void))completionHandler {
    [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                logFormat:@"Reading with SheepSafariHelper"];
    [self setError:nil];

    NSTimeInterval timeout = constSheepSafariHelperTimeoutRead + constSheepSafariHelperStartupDelayAllowance;
    if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        NSInteger moreTime = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeySafariMoreAgentSecs];
        if (moreTime > 0) {
            timeout += moreTime;
            NSString* msg = [NSString stringWithFormat:
                             @"Agent +time for SheepSafariHelper read: %ld",
                             moreTime];
            [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                        logFormat:msg];
        }
    }
    self.sheepSafariHelperStartDate = [NSDate date];

    NSTimer* timer;
    if (@available(macOS 10.12, *)) {
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                repeats:YES
                                                  block:^(NSTimer* _Nonnull timer) {
                                                      [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                                                  logFormat:@"Fired sheepSafariHelperTimeoutTimer %@", [NSNumber numberWithLongLong:(long long)timer]];

                                                      NSTimeInterval sheepSafariHelperRunningTime = self.sheepSafariHelperRunningTime;
                                                      NSString* sheepSafariHelperStatusDescription = [self sheepSafariHelperStatusDescriptionForRunningTime:sheepSafariHelperRunningTime];
                                                      pid_t sheepSafariHelperPid = [SSYOtherApper pidOfMyRunningExecutableName:@"SheepSafariHelper"];
                                                      if (sheepSafariHelperRunningTime > timeout) {
                                                          // Timed out
                                                          NSString* msg = [NSString stringWithFormat:
                                                                           @"ReadDog: SheepSafariHelper timed out %@",
                                                                           sheepSafariHelperStatusDescription];
                                                          [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                                                      logFormat:msg];

                                                          [self timeOutLoadTreeWithCompletionHandler:completionHandler];
                                                      } else if (sheepSafariHelperPid > 0) {
                                                          NSString* msg = [NSString stringWithFormat:
                                                                           @"ReadDog: SheepSafariHelper pid=%d, OK %@",
                                                                           sheepSafariHelperPid,
                                                                           sheepSafariHelperStatusDescription];
                                                          [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                                                      logFormat:msg];
                                                      } else if (!self.isDoneReadingFromSheepSafariHelper){
                                                          if (sheepSafariHelperRunningTime < constSheepSafariHelperStartupDelayAllowance) {
                                                              NSString* msg = [NSString stringWithFormat:
                                                                               @"ReadDog: SheepSafariHelper maybe not started yet? %@",
                                                                               sheepSafariHelperStatusDescription];
                                                              [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                                                          logFormat:msg];
                                                          } else {
                                                              // SheepSafariHelper has crashed
                                                              NSString* msg = [NSString stringWithFormat:
                                                                               @"ReadDog: SheepSafariHelper not running \u279e Retry %@",
                                                                               sheepSafariHelperStatusDescription];
                                                              [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                                                          logFormat:msg];

                                                              self.sheepSafariHelperCurrentTrialIndex = self.sheepSafariHelperCurrentTrialIndex + 1;
                                                              self.isDoneReadingFromSheepSafariHelper = NO;
                                                              [self readWithSheepSafariHelperThenCompletionHandler:completionHandler];
                                                          }
                                                      } else {
                                                          NSString* msg = [NSString stringWithFormat:
                                                                           @"ReadDog: Averted double SheepSafariHelper for timer %@",
                                                                           @((long long)timer)];
                                                          [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                                                      logFormat:msg];

                                                      }
                                                  }
                 ];
    } else {
        /* Sorry, macOS 10.11- users do not get the retry feature. */
        NSInvocation* invocation = [NSInvocation invocationWithTarget:self
                                                             selector:@selector(timeOut_macOS10_11_LoadTreeWithCompletionHandler:)
                                                      retainArguments:YES
                                                    argumentAddresses:&completionHandler];
        timer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                             invocation:invocation
                                                repeats:NO];
    }

    self.sheepSafariHelperTimeoutTimer = timer;
    [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                logFormat:@"Created sheepSafariHelperTimeoutTimer %@", [NSNumber numberWithLongLong:(long long)timer]];

    self.sheepSafariHelperCurrentTrialIndex = 1;
    self.isDoneReadingFromSheepSafariHelper = NO;
    /* I think that isDoneReadingFromSheepSafariHelper = NO is defensive
     proramming because this here methdod runs only once, before
     isDoneReadingFromSheepSafariHelper could ever be set to YES. */
    [self readWithSheepSafariHelperThenCompletionHandler:completionHandler];
}

/* Confused?  See Note SheepSafariHelperMethodsMap */
- (void)readExternalStyle1ForPolarity:(BkmxIxportPolarity)polarity
                    completionHandler:(void(^)(void))completionHandler {
#if FAST_SAFARI_IMPORTS
#warning This codee almost works, except the Operation fails due to "nil extore" in the Operatiobns's info dictionary.
    NSError* error = nil;
    NSDictionary* tree = [self extoreTreeError_p:&error];
    
    if (error) {
        [self setError:error];
    } else {
        if ([NSThread isMainThread]) {
            [self processImportedTree:tree
                               caller:@"Main"];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self processImportedTree:tree
                                   caller:@"Non-Main"];
            });
        }
    }
    
    if ([NSThread isMainThread]) {
        self.isDoneReadingFromSheepSafariHelper = YES;
        completionHandler();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.isDoneReadingFromSheepSafariHelper = YES;
            completionHandler();
        });
    }
#else
    if ([self ixportSubstyle] == IxportSubstyleOverwriteFile) {
        [super readExternalStyle1ForPolarity:polarity
                           completionHandler:completionHandler];
    }
    else {
        [self readWithWatchdoggedSheepSafariHelperThenCompletionHandler:completionHandler];
    }
#endif
}

- (void)timeOutSendChangesWithOperation:(SSYOperation*)operation {
    [self.sheepSafariHelperXpcConnection invalidate];
    self.sheepSafariHelperXpcConnection = nil;
    [self.sheepSafariHelperTimeoutTimer invalidate];
    self.sheepSafariHelperTimeoutTimer = nil;
    NSString* msg = NSLocalizedString(@"Pushing to Safari took too long.", nil);
    NSError* error = SSYMakeError(298441, msg);
    msg = NSLocalizedString(@"Try File > Export to Safari (again).  If it does not work on this second try, please click the life preserver to contact our support team", nil);
    error = [error errorByAddingLocalizedRecoverySuggestion:msg];
    error = [error errorByAddingUserInfoObject:@YES
                                        forKey:constKeyDontPauseSyncing];
    error = [error errorByAddingUserInfoObject:[self sheepSafariHelperStatusDescription]
                                        forKey:@"SheepSafariHelper Running Status"] ;
    [self setError:error];
    [operation writeAndDeleteDidSucceed:NO];
}

/* This method only runs in macOS 10.11 or earlier. */
- (void)timeOut_macOS10_11_SendChangeWithOperation:(SSYOperation*)operation {
    NSString* msg = [NSString stringWithFormat:
                     @"WritDog: SheepSafariHelper timed out %@",
                     self.sheepSafariHelperStatusDescription];
    [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                logFormat:msg];
    [self timeOutSendChangesWithOperation:operation];
}

/* Confused?  See Note SheepSafariHelperMethodsMap */
- (void)writeWithSheepSafariHelperChanges:(NSDictionary *)changes
                     operation:(SSYOperation*)operation {
    NSXPCConnection* connection = [[NSXPCConnection alloc] initWithServiceName:@"com.sheepsystems.SheepSafariHelper"];
    self.sheepSafariHelperXpcConnection = connection;
    [connection release];
    connection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(SheepSafariHelperProtocol)];
    [connection resume];
    [[BkmxBasis sharedBasis] logString:[NSString stringWithFormat:@"Call SheepSafariHelper for Job %05ld", self.jobSerial]];
    [[connection remoteObjectProxy] exportForKlientAppDescription:[self customerDescription]
                                                          changes:changes
                                   completionHandler:^(NSString* exidFeedback, NSDictionary* results, NSError* error) {
                                       [self.sheepSafariHelperTimeoutTimer invalidate];
                                       self.sheepSafariHelperTimeoutTimer = nil;

                                       /* Apple documentation says to invalidate now.  It probably has no effect
                                        in our case because SheepSafariHelper kills itself with exit(0) when it is
                                        done.  I mean, it's probably already invalidated. */
                                       [connection invalidate];
                                       self.sheepSafariHelperXpcConnection = nil;

                                       NSDictionary* issues = [results objectForKey:constKeySheepSafariHelperResultIssues];
                                       NSString* msg = [NSString stringWithFormat:
                                                        @"SheepSafariHelper write try: %@: %@ sv=%@ drq=%@ limbo:%ld,%ld,%ld,%ld fwk=%@",
                                                        error ? @"Fail" : @"Good",
                                                        [self sheepSafariHelperStatusDescription],
                                                        [results objectForKey:constKeySheepSafariHelperResultSaveResults],
                                                        [results objectForKey:constKeySheepSafariHelperDidRequestSyncClientTrigger],
                                                        ((NSNumber*)[results objectForKey:constKeySheepSafariHelperResultLimboInsertionsCount]).longValue,
                                                        ((NSNumber*)[results objectForKey:constKeySheepSafariHelperResultLimboRemovalsCount]).longValue,
                                                        ((NSNumber*)[results objectForKey:constKeySheepSafariHelperResultLimboOrphanCount]).longValue,
                                                        ((NSNumber*)[results objectForKey:constKeySheepSafariHelperResultLimboOrphanDisappearedCount]).longValue,
                                                        [results objectForKey:constKeySheepSafariHelperResultSafariFrameworkTattle]
                                                        ];
                                       [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                                   logFormat:msg];
                                       msg = [NSString stringWithFormat:
                                              @"SheepSafariHelper write depth:trials: %@",
                                              [results objectForKey:constKeySheepSafariHelperTrialsByDepthReport]];
                                       [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                                   logFormat:msg];
                                       if (issues) {
                                           msg = [NSString stringWithFormat:
                                                  @"SheepSafariHelper had %ld nonfatal issues writing",
                                                  (long)issues.count];
                                           [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                                       logFormat:
                                            @"%@.  See Error %@",
                                            msg,
                                            @(constBkmsErrorSheepSafariHelperHadIssuesWriting)];
                                           NSError* error = SSYMakeError(constBkmsErrorSheepSafariHelperHadIssuesWriting, msg);
                                           error = [error errorByAddingUserInfoObject:issues
                                                                               forKey:constKeySheepSafariHelperResultIssues];
                                           [[BkmxBasis sharedBasis] logError:error
                                                             markAsPresented:NO];
                                       }

                                       BOOL ok = YES;
                                       BOOL done = NO;
                                       if (!error) {
                                           done = YES;
                                           if ([NSThread isMainThread]) {
                                               [self processExidFeedbackString:exidFeedback];
                                           } else {
                                               dispatch_sync(dispatch_get_main_queue(), ^{
                                                   [self processExidFeedbackString:exidFeedback];
                                               });
                                           }

                                           [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:[NSDate date]
                                                                                                  forKey:constKeySafariPushLastSheepSafariHelper];
                                           NSInteger priorsCount = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeySafariPushCountSheepSafariHelper];
                                           [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:@(priorsCount + 1)
                                                                                                  forKey:constKeySafariPushCountSheepSafariHelper];
                                           if (priorsCount % PUSH_PUSH_LAZINESS == 0) {
                                               if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeySendPerformanceData]) {
                                                   [self pushPushDataWithCkms:[[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeySafariPushPriorCkms]
                                                                ixportSubstyle:@"SheepSafariHelper"];
                                               }
                                           }
                                       } else if (self.sheepSafariHelperCurrentTrialIndex <= [[error.userInfo objectForKey:constKeyRetrialsRecommended] integerValue]) {
                                           NSString* msg = [NSString stringWithFormat:
                                                            @"SheepSafariHelper export fail; %ld/%ld cuz %ld \u279e Retry in %0.1f secs",
                                                            (long)(self.sheepSafariHelperCurrentTrialIndex),
                                                            (long)[[[error userInfo] objectForKey:constKeyRetrialsRecommended] integerValue],
                                                            (long)[error code],
                                                            constSheepSafariHelperExportRetryDuration
                                                            ];
                                           [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                                       logFormat:msg];
                                           self.sheepSafariHelperCurrentTrialIndex = self.sheepSafariHelperCurrentTrialIndex + 1;

                                           [NSThread sleepForTimeInterval:constSheepSafariHelperExportRetryDuration];

                                           [self writeWithSheepSafariHelperChanges:changes
                                                              operation:operation];
                                       } else {
                                           done = YES;
                                           error = [error errorByAddingUserInfoObject:changes
                                                                               forKey:@"Changes Attempted"];
                                           [self setError:error] ;
                                           ok = NO;
                                       }

                                       if (done) {
                                           if ([NSThread isMainThread]) {
                                               self.isDoneWritingToSheepSafariHelper = YES;
                                               [operation writeAndDeleteDidSucceed:ok] ;
                                           } else {
                                               dispatch_sync(dispatch_get_main_queue(), ^{
                                                   self.isDoneWritingToSheepSafariHelper = YES;
                                                   [operation writeAndDeleteDidSucceed:ok] ;

                                               });
                                           }
                                       }
                                   }];
}

/* Confused?  See Note SheepSafariHelperMethodsMap */
- (void)writeWithWatchdoggedSheepSafariHelperInOperation:(SSYOperation*)operation {
    NSError* error = nil;

    NSDictionary* changes = [self changeInfoForOperation:operation
                                                 error_p:&error];
    if (!changes) {
        /* The hash comparison should have caught !changes and this method
         should not be executing. */
        [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                    logFormat:@"Warning 634-7704"];
    }

    if (changes && !error) {
        if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
            NSDictionary* info = [operation info];
            BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument] ;
            SSYProgressView* progressView = [bkmxDoc progressView] ;
            NSString* message = NSLocalizedString(@"Pushing changes into Safari", nil);
            [progressView setIndeterminate:YES
                         withLocalizedVerb:message
                                  priority:SSYProgressPriorityRegular] ;
        }

        NSTimeInterval timeout = constSheepSafariHelperTimeoutWrite + constSheepSafariHelperStartupDelayAllowance;
        if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
            NSInteger moreTime = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeySafariMoreAgentSecs];
            if (moreTime > 0) {
                timeout += moreTime;
                NSString* msg = [NSString stringWithFormat:
                                 @"Agent +time for SheepSafariHelper write: %ld",
                                 moreTime];
                [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                            logFormat:msg];
            }
        }
        self.sheepSafariHelperStartDate = [NSDate date];

        NSTimer* timer;
        if (@available(macOS 10.12, *)) {
            // macOS 10.12 or later
            timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                    repeats:YES
                                                      block:^(NSTimer* _Nonnull timer) {
                                                          NSTimeInterval sheepSafariHelperRunningTime = self.sheepSafariHelperRunningTime;
                                                          NSString* sheepSafariHelperStatusDescription = [self sheepSafariHelperStatusDescriptionForRunningTime:sheepSafariHelperRunningTime];
                                                          pid_t sheepSafariHelperPid = [SSYOtherApper pidOfMyRunningExecutableName:@"SheepSafariHelper"];
                                                          if (sheepSafariHelperRunningTime > timeout) {
                                                              // Timed out
                                                              NSString* msg = [NSString stringWithFormat:
                                                                               @"WritDog: SheepSafariHelper timed out %@",
                                                                               sheepSafariHelperStatusDescription];
                                                              [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                                                          logFormat:msg];

                                                              [self timeOutSendChangesWithOperation:operation];
                                                          } else if (sheepSafariHelperPid > 0) {
                                                              NSString* msg = [NSString stringWithFormat:
                                                                               @"WritDog: SheepSafariHelper pid=%d, OK %@",
                                                                               sheepSafariHelperPid,
                                                                               sheepSafariHelperStatusDescription];
                                                              [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                                                          logFormat:msg];
                                                          } else if (!self.isDoneWritingToSheepSafariHelper) {
                                                              if (sheepSafariHelperRunningTime < constSheepSafariHelperStartupDelayAllowance) {
                                                                  NSString* msg = [NSString stringWithFormat:
                                                                                   @"WritDog: SheepSafariHelper maybe not started yet? %@",
                                                                                   sheepSafariHelperStatusDescription];
                                                                  [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                                                              logFormat:msg];
                                                              } else {
                                                                  // SheepSafariHelper has crashed
                                                                  NSString* msg = [NSString stringWithFormat:
                                                                                   @"WritDog: SheepSafariHelper not running \u279e Retry %@",
                                                                                   sheepSafariHelperStatusDescription];
                                                                  [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                                                              logFormat:msg];

                                                                  self.sheepSafariHelperCurrentTrialIndex = self.sheepSafariHelperCurrentTrialIndex + 1;
                                                                  self.isDoneWritingToSheepSafariHelper = NO;
                                                                  [self writeWithSheepSafariHelperChanges:changes
                                                                                     operation:operation];
                                                              }
                                                          } else {
                                                              NSString* msg = [NSString stringWithFormat:
                                                                               @"WritDog: Averted double SheepSafariHelper for timer %@",
                                                                               @((long long)timer)];
                                                              [[BkmxBasis sharedBasis] forJobSerial:self.jobSerial
                                                                                          logFormat:msg];

                                                          }
                                                      }
                     ];
        } else {
            /* Sorry, macOS 10.11- users do not get the retry feature. */
            NSInvocation* invocation = [NSInvocation invocationWithTarget:self
                                                                 selector:@selector(timeOut_macOS10_11_SendChangeWithOperation:)
                                                          retainArguments:YES
                                                        argumentAddresses:&operation];
            timer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                 invocation:invocation
                                                    repeats:NO];
        }
        self.sheepSafariHelperTimeoutTimer = timer;

        self.sheepSafariHelperCurrentTrialIndex = 1;
        self.isDoneWritingToSheepSafariHelper = NO;
        /* I think that isDoneWritingToSheepSafariHelper = NO is defensive
         proramming because this here methdod runs only once, before
         isDoneWritingToSheepSafariHelper could ever be set to YES. */
        [self writeWithSheepSafariHelperChanges:changes
                           operation:operation];
    } else {
        if (error) {
            [self setError:error] ;
        }
        /* (error==nil) here is more defensive programming.  We could just pass
         NO.  See comment on !changes above. */
        [operation writeAndDeleteDidSucceed:(error == nil)] ;
    }
}

/* Confused?  See Note SheepSafariHelperMethodsMap */
- (void)writeUsingStyle1InOperation:(SSYOperation*)operation {
    BOOL ok;
    NSError* error = nil ;
    ok = [self processExportChangesForOperation:operation
                                        error_p:&error] ;
    if (ok) {
        switch ([self ixportSubstyle]) {
            case IxportSubstyleOverwriteFile: {
                [super writeUsingStyle1InOperation:operation];
                break;
            }
            case IxportSubstyleSendToSheepSafariHelper: {
                [self writeWithWatchdoggedSheepSafariHelperInOperation:operation];
                break;
            }
            default: {
                NSAssert(NO, @"Should have push style here");
                break;
            }
        }
    } else {
        if (error) {
            [self setError:error] ;
        }
        [operation writeAndDeleteDidSucceed:ok] ;
    }
}

@end


/*
 * REVERSE-ENGINEERING SAFARI AND ICLOUD

 ** BEHAVIOR OF CloudKitMigrationState IN macOS 10.12

 Exporting from Bkmx causes CKMS in Bookmarks.plist to change from 3 to 0,
 and then of course during the next export I use Thomas which causes
 SafariDAVClient to relaunch repeatedly until I log out and back in.  Changed
 items later show up as additional (duplicate) items at the end of their
 parent.  I am not sure when this happens.  Logging out and back in reverts it
 back to CKMS 2 immediately, reverts changes from Bkmx which were not pushed by
 pulling from cloud, and then after a few minutes and a lot of activity by
 SafariBookmarksSyncAgent, changes CKMS to 3, and also changes made within
 *Safari* start being pushed to the cloud again.

 
 ** GENERAL TIPS ON WATCHING SAFARIDAVCLIENT
 
 Here's a little trick which will help you see what's going on.  Launch Activity Monitor
 and filter for a process named "SafariDAVClient".  Whenever it's running, bookmarks
 are being pushed to or pulled from the server.
 
 Another little trick, not as useful, will write details of each push and pull to your
 console.  It tends to be a fire hose, though.
 
 #Enable SafariDAVClient logging
 defaults write com.apple.SafariDAVClient SDAVLogLevel 6
 defaults write com.apple.Safari BookmarkAccessAPILoggingEnabled -bool yes
 
 Presumably a lower SDAVLogLevel would be better.  Anyhow, when you get tired of it,
 
 #Disable SafariDAVClient logging
 defaults delete com.apple.SafariDAVClient SDAVLogLevel
 defaults delete com.apple.Safari BookmarkAccessAPILoggingEnabled

 
 ** HOW TO CHECK SAFARIDAVCLIENT'S LAUNCHD AGENT
 
 • In BookMacster, Stop all Syncing now.
 • Turn on iCloud - Safari in System Preferences.
 • Wait a few minutes to make sure it's stabilized.
 • To verify that SafariDAVClient is loaded, run this command and compare the
 result with what I got earlier.  These results were the same in:
 macOS 10.7.5 (11G63)
 macOS 10.8.3 (12D68)
 macOS 10.8.4 (12E36)
 |{
 |	"Label" = "com.apple.safaridavclient";
 |	"LimitLoadToSessionType" = "Aqua";
 |	"OnDemand" = true;
 |	"LastExitStatus" = 0;
 |	"TimeOut" = 30;
 |	"ProgramArguments" = (
 |                          "/System/Library/PrivateFrameworks/BookmarkDAV.framework/Helpers/SafariDAVClient";
 |                          );
 |	"MachServices" = {
 |		"com.apple.safaridavclient.push" = mach-port-object;
 |		"com.apple.safaridavclient" = mach-port-object;
 |	};
 |};
 
 Also, compare the plist files and framework executable with those I have
 archived here, to see likewise if anything changed:
 
 ~/Documents/Programming/Projects/BkmkMgrs/DesignDocumentation/SafariDAV-Components
 
 Note that the results shown by launchctl list are not one-for-one which is in
 the plist file.  Interestingly, note that the plist file has a StartInterval
 of 82,800 seconds = 23 hours.  Weird.  Also, see references to RunAtLoad elsewhere in this
 file.

 
 ** GENERAL TIPS ON CHECKING SAFARI OPERATION
 
 If you want to remove all bookmarks for some reason, don't forget to check
 the Reading List!
 
 
 ** HOW TO CHECK HOW SAFARI WRITES CHANGES FOR ICLOUD

 • In System Preferences, switch on iCloud ▸ Safari
 • Open ~/Documents/Programming/Projects/BkmkMgrs/BookMacsterTests/Data/Bkmslfs/Safari-iCloud-Tester.bkmslf
 • Export to Safari.
 • Wait a few minutes to make sure that SafariDAVClient doesn't change anything.
 • Verify that the Sync ▸ Changes value in Bookmarks.plist is empty or absent.
 • Copy the Bookmarks.plist file and name it the copy Bookmarks1.plist.
 • Stop SafariDAVClient by commanding this in Terminal…
 
 launchctl unload /System/Library/LaunchAgents/com.apple.safaridavclient.plist

 • Repeat the 'list' subcommand to verify that SafariDAVClient is now unloaded…
 
 Air1:Chrome jk$ launchctl list com.apple.safaridavclient
 launchctl list returned unknown response
 
 Now we're going to make a bunch of changes to see what Safari does
 
 • Change the name of bookmark "Modify"
 • Delete the bookmark "Remove".
 • Move the bookmark "Move" into "Folder 2".
 • Change the name of bookmark "Slosh"
 • Move the bookmark "Mosh" into "Folder 2", under "Move"
 • Also, change the name of bookmark "Mosh".
 • Duplicate the "NoChange" and name the dupe "Insert".
 • Move bookmark "PureSlide2" so it is above "PureSlide1".
 
 • Quit Safari.  (Probably not necessary)
 • Copy the Bookmarks.plist file and name it the copy BookmarksS2.plist.
 • Copy Bookmarks1.plist to Bookmarks.plist.
 • Activate BookMacster.
 • Create a new BkmxDoc document.
 • Import from Safari
 • Verify that imported bookmarks are back as they were prior to the changes.
 • Make the same bunch of changes that you'd made in Safari.
 • Export to Safari.
 • The "BookMacster : iCloud Error" is expected because SafariDAVClient did not
 step in to do its thing.  Click "Ignore".
 • Copy the Bookmarks.plist file and name it the copy BookmarksB2.plist.
 • Compare the files BookmarksS2.plist and BookmarksB2.plist.
 
 The test is complete.  To re-enable iCloud, do this

 • Copy Bookmarks1.plist to Bookmarks.plist.
 • Run this command…
 
 launchctl load /System/Library/LaunchAgents/com.apple.safaridavclient.plist
 
 
 ** STUDY OF SAFARI FILE LOCKS
 
 TESTING ON QUAD CORE 2009 MAC PRO
 
 At first, after Bookwatchdog wrote bookmarks, bookmarks changes did not show immediately in an existing window, and did not show even in a new window.  Then when I moved a bookmark in Safari, it crashed.  Then after re-launching, I noted that I still had the problem where changes did not show.  But then after that, things started working.  Very strange.
 
 THE MYSTERIOUS ~/Library/Safari/lock
 
 When Safari 4 writes a bookmarks file, in either Leopard or Snow Leopard, it momentarily creates a directory ~/Library/Safari/lock.
 
 By using flock, or maybe just because I was lucky, I was once able to get Safari to display the "Your bookmarks can't be changed now" warning and, when this happened, the ~/Library/Safari/lock folder remained until I dismissed the dialog.  Aha!!  Looking inside, I found a single file named "details.plist".  It was in XML format and contained the following plist:
 <?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
 <plist version="1.0">
 <dict>
 <key>LockFileDate</key>
 <date>2009-08-14T22:41:50Z</date>
 <key>LockFileHostname</key>
 <string>localhost</string>
 <key>LockFileProcessID</key>
 <integer>2983</integer>
 <key>LockFileProcessName</key>
 <string>Safari</string>
 <key>LockFileUsername</key>
 <string>Jerry</string>
 </dict>
 </plist>
 
 The time was probably the time that Safari tried to write the file, and pid=2983 is the pid of Safari (not the pid of my tool which did the flock()).
 
 WHAT IS ~/Library/Safari/lock?
 
 In the following post,
 
 http://lists.apple.com/archives/Syncservices-dev/2008/Apr/msg00004.html
 
 the writer reports the following console output:
 
 4/7/08 4:35:16 PM SystemUIServer[177] Couldn't write file lock dictionary for /Users/randyh/Library/Application Support/SyncServices/ Local/conflicts/lock - possible bad dictionary format? Dictionary is {
 LockFileDate = 2008-04-07 16:35:14 -0700;
 LockFileHostUUIDKey = "00000000-0000-1000-8000-0016CBA076C3";
 LockFileHostname = localhost;
 LockFileProcessID = 177;
 LockFileProcessName = SystemUIServer;
 LockFileUsername = "randyh";
 }
 4/7/08 4:35:16 PM SystemUIServer[177] Ignoring exception NSObjectNotAvailableException trying to remove lock after failing to write file: Can't remove existing lock for /Users/randyh/Library/ Application Support/SyncServices/Local/conflicts
 
 Thus, I conclude that ~/Library/Safari/lock is produced by Sync Services.
 
 FILE LOCKS
 
 Safari 4.0 ignores the advisory locks set by flock(2).  Use my project flock_wrapper.  However, if a "Finder" lock is put on, it will obey it silently -- not writing any changes.  Any bookmarks changes are silently lost.
 */


/* Note SheepSafariHelperMethodsMap

 There are six methods for interacting with SheepSafariHelper, in three pair which are
 analagous for reading and writing:

 High Level (runs once)
 -readExternalStyle1ForPolarity:
 -writeUsingStyle1InOperation:
 •    calls, if SheepSafariHelper, the Middle Level method…

 Middle Level (runs once)
 -readWithWatchdoggedSheepSafariHelperThenCompletionHandler:
 -writeWithWatchdoggedSheepSafariHelperInOperation:
 •    creates the watchdog timer and defines its callback
 •    calls next method initially
 •    also calls next method if SheepSafariHelper disappears, from timer callback

 Low Level (may run multiple times until success or timeout)
 -readWithSheepSafariHelperThenCompletionHandler:
 -writeWithSheepSafariHelperChanges:operation:
 •    creates the XPC connection and defines its callback
 •    if SheepSafariHelper returns a error saying to retry, calls itself

 */

/* Note CrosstalkBetweenFDIAndAutomation

 I just discovered another facet to this thing.  Among the other restrictions introduced in Mojave are new additional restrictions on sending Apple Events to other apps.  You might think I am going off topic of Full Disk Access but bear with me.  Specifically, nonsandboxed apps using the old NSAppleScript class to send Apple Events in Mojave find that they are blocked.  The app gets an AppleScript error saying so, but the dialog asking the user to grant access (which is displayed in System Preferences > Security & Privacy > Automation is never displayed.  You the developer can fix this in nonsandboxed apps by removing calls to NSAppleScript and replacing them with calls to NSUserAppleScriptTask instead.  With this fix, the dialog is presented, your app gets a checkbox in Automation if the user approves, and Apple Events can flow, although it seems that the dialogs may be shown repeatedly.

 Since my apps use NSAppleScript, they were broken in this way, although since this breakage affected a not-so-essential feature, I did not try to fix it until today.  With this fix, my XPC helper uses NSUserAppleScriptTask to get, set, and then again set the URL of the frontmost tab in Safari, and then my XPC helper process relaunches.  The Apple Events worked OK, but I found that after this sequence, both my main app and the XPC helper no longer have Full Disk Access, even though the their Full Disk Access checkbox is still checked.  To restore Full Disk Access, the user  must switch my app's Full Disk Access off and then back on, and of course relaunch both my main app and its XPC Helper.

 Since this is of course unacceptable, I completely removed the not-so-essential feature which accessed Safari via NSUserAppleScriptTask and now my app's Full Disk Access is permanent again.

 I conclude that there is some "crosstalk" between the Full Disk Access and Automation features.  I wonder if this was intentional or not.

 Posted as reply on 2018-12-10 in this thread:
 https://forums.developer.apple.com/message/343372#343372

 */
