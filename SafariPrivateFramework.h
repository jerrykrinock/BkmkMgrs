/* This file is included in SheepSafariHelper so that I can use the Apple private
 Safari.framework.  It was constructed by running class-dump (class dump)
 on that framework's executable, extracting the classes I thought I might need
 (about 10% of it), and commenting out the class-dump placeholders and other
 weird method names which do not compute for the compiler.

 The location of this framework is normally:
 
•  /System/Library/PrivateFrameworks/Safari.framework

 So the command is:

 class-dump /System/Library/PrivateFrameworks/Safari.framework

 However, currently, in macOS 10.12.6 Security Update 2018-001, that is an
 old version of Safari.framework which does not support CloudKit, at least
 the current CloudKit.  Safari does not use that framework in macOS 10.12.6.
 Instead, it uses this one:

 • /System/Library/StagedFrameworks/Safari/Safari.framework

 which is apparently a later version.  In fact, the Mach-O executable
 in /Applications/Safari/Contents/MacOS/Safari will load whichever of those two
 frameworks exists and has a later date, due to it containing a
 carefully-crafted Load Command 14 in addition to the normal Load Command 12:

 # Normal load command which results from adding /System/…/Safari to the
 #    Build Phase "Link Binary with Libraries":
 Load command 12
 cmd LC_LOAD_DYLIB
 cmdsize 96
 name /System/Library/PrivateFrameworks/Safari.framework/Versions/A/Safari (offset 24)
 time stamp 2 Wed Dec 31 16:00:02 1969
 current version 605.1.33
 compatibility version 528.0.0

 # How to link to SafariPrivateFramework_h
 
 There is a special load command which defaults to /System/…/StagedFrameworks/… if available
 Load command 14
 cmd LC_DYLD_ENVIRONMENT
 cmdsize 88
 name DYLD_VERSIONED_FRAMEWORK_PATH=/System/Library/StagedFrameworks/Safari (offset 12)

 Of course, I need SheepSafariHelper to have this same behavior.  Mark Rowe, aka bdash
 <website@bdash.net.nz>, explained the *why* and *how* of this in the answer to
 this question:

 https://stackoverflow.com/questions/49375324/macos-load-one-or-other-system-framework-at-run-time-based-on-availability

 The *how* is to add these two clauses to the "Other Linker Flags" in the
 SheepSafariHelper target:

 -Wl,-dyld_env
 -Wl,DYLD_VERSIONED_FRAMEWORK_PATH=/System/Library/StagedFrameworks/Safari

 Note: I think that the "-Wl," prefix says to "Instead of affecting the
 operation the linker (`ld`), pass this clause through to the dynamic linker
 `dyld` for use at launch time.  But I can't find that reference right now.
 It's a weird syntax!
 
>>> UPDATE 2024-04 (BkmkMgrs 3.1.9)
 
 I'm not sure how long this has been happening, but now, using Xcode 16.2, when building my target with the solution discussed above, I am getting the following warning:

 The OTHER_LDFLAGS build setting is not allowed to contain -dyld_env, use the dedicated LD_ENVIRONMENT build setting instead.
 
 I solved the problem by removing the prior solution, these two entries from Other Linker Flags build setting:

 -Wl,-dyld_env
 -Wl,DYLD_VERSIONED_FRAMEWORK_PATH=/System/Library/StagedFrameworks/Safari
 and instead I added the following entry to the Dynamic Linker Environment build setting:

 DYLD_VERSIONED_FRAMEWORK_PATH=/System/Library/StagedFrameworks/Safari
 In the version of macOS which I now have (15.4), there is no StagedFrameworks, so I cannot state for sure that this will work. Maybe someday we shall find out.
 
 <<< End of UPDATE 2024-04

 In the SheepSafariHelper target, I went a little further.  Instead of doing a normal
 strong link to /System/Library/PrivateFrameworks/Safari.framework by
 adding it to the Build Phase "Link Binary with Libraries", I made it a weak
 link by instead adding this clause:

 -weak_framework Safari

 to "Other Linker Flags".  Mark Rowe says it would work either way.  But I
 think it's better to be a weak link, since Safari.framework is subject to
 change without notice at any time.  I think that maybe weakly-linked
 frameworks cause longer load times than strongly, but a few hundred
 milliseconds more is not a big deal with SheepSafariHelper.
 */

#ifndef SafariPrivateFramework_h
#define SafariPrivateFramework_h

#pragma mark Function Pointers and Blocks

typedef void (*CDUnknownFunctionPointerType)(void); // return type and parameters are unknown

typedef void (^CDUnknownBlockType)(void); // return type and parameters are unknown

#pragma mark Named Structures

#pragma mark -

//
// File: /System/Library/PrivateFrameworks/Safari.framework/Versions/A/Safari
// UUID: 342709B3-4A15-30C4-ADFF-802EC5C784C8
//
//                           Arch: x86_64
//                Current version: 604.3.1
//          Compatibility version: 528.0.0
//                 Source version: 7604.3.1.0.0
//       Minimum Mac OS X version: 10.13.0
//                    SDK version: 10.13.0
//
// Objective-C Garbage Collection: Unsupported
//

/* This class name switched forth and back in Xcode 13 betas.  Through Xcode
 12, was WebBookmarkList.  In Xcode 13 betas, was SafariWebBookmarkList.  In
 Xcode 13.0 release, was back to WebBookmarkList, ah, because the Xcode 13.0
 has reverted to the macOS 11 SDK.  In Xcode 13.1 back to SafariWebBookmarkList. */
#define SAFARI_FOLDER_CLASS SafariWebBookmarkList

#import <Cocoa/Cocoa.h>

@class WebBookmarkGroup;
@class WebBookmark;
@class SAFARI_FOLDER_CLASS;
@class WebBookmarkLeaf;
@class BookmarksUndoController;

@protocol BookmarkGroupDelegate <NSObject>

@optional
- (void)bookmarkGroup:(WebBookmarkGroup *)arg1 bookmarkDidChange:(WebBookmark *)arg2 changeWasInteractive:(BOOL)arg3;
- (void)bookmarkGroup:(WebBookmarkGroup *)arg1 bookmarkWasRemoved:(WebBookmark *)arg2 fromParent:(SAFARI_FOLDER_CLASS *)arg3;
- (void)bookmarkGroup:(WebBookmarkGroup *)arg1 bookmarkWasAdded:(WebBookmark *)arg2 toParent:(SAFARI_FOLDER_CLASS *)arg3;
- (void)bookmarksWereReloadedInGroup:(WebBookmarkGroup *)arg1;
@end

@protocol BookmarkSource
- (NSString *)bookmarkSourceMenuTitle;
- (void)removeBookmarkSourceMenu:(NSMenu *)arg1;
- (struct TabPlacementHint)tabPlacementHintForMenu:(NSMenu *)arg1;
- (void)addBookmarkSourceMenu:(NSMenu *)arg1 withTabPlacementHint:(const struct TabPlacementHint *)arg2;
- (NSString *)imageURLStringForContentItem:(id)arg1;
- (NSImage *)imageForContentItem:(id)arg1;
- (NSString *)titleStringForContentItem:(id)arg1;
- (NSString *)addressStringForContentItem:(id)arg1;
- (NSImage *)bookmarkSourceImage;
- (NSArray *)bookmarksFromContentItems:(NSArray *)arg1;
- (void)openDescendantsOfContentItemInNewTabs:(id)arg1 tabPlacementHint:(const struct TabPlacementHint *)arg2;
- (void)replaceTabsWithDescendantsOfContentItem:(id)arg1 tabPlacementHint:(const struct TabPlacementHint *)arg2;
- (void)goToContentItemInNewTab:(id)arg1 tabPlacementHint:(const struct TabPlacementHint *)arg2;
- (void)goToContentItemInNewWindow:(id)arg1;
- (void)goToContentItem:(id)arg1 tabPlacementHint:(const struct TabPlacementHint *)arg2;
- (BOOL)canGoToContentItem:(id)arg1;
- (WebBookmarkLeaf *)bookmarkFromContentItem:(id)arg1;
- (NSArray *)contentItemsToExpandOnReload;
- (NSArray *)contentItemsToInitiallyExpand;
- (void)didExpandContentItem:(id)arg1;
- (void)didCollapseContentItem:(id)arg1;
- (id)parentOfContentItem:(id)arg1;
- (unsigned int)numberOfChildrenOfContentItem:(id)arg1;
- (id)child:(unsigned int)arg1 ofContentItem:(id)arg2;
- (BOOL)contentItemCanHaveChildren:(id)arg1;
- (BOOL)contentItemCanBeSearchResult:(id)arg1;
- (BOOL)deleteContentItems:(NSArray *)arg1 withParentWindow:(NSWindow *)arg2 undoManager:(NSUndoManager *)arg3;
- (BOOL)canDeleteContents;
- (BOOL)canCopyContents;
- (void)refreshContents;
@end

// New in macOS 10.14.4:
@protocol BookmarksUndoControllerDataStore
- (WebBookmarkGroup *)bookmarkGroupForUndoController:(BookmarksUndoController *)arg1;
@end



__attribute__((visibility("hidden")))
@interface BookmarkImportInfo : NSObject
{
    BOOL _testDriveBookmark;
    unsigned long long _importOrigin;
    NSString *_importOriginUUID;
}

@property(readonly, nonatomic, getter=isTestDriveBookmark) BOOL testDriveBookmark; // @synthesize testDriveBookmark=_testDriveBookmark;
@property(readonly, copy, nonatomic) NSString *importOriginUUID; // @synthesize importOriginUUID=_importOriginUUID;
@property(readonly, nonatomic) unsigned long long importOrigin; // @synthesize importOrigin=_importOrigin;
//- (void).cxx_destruct;
- (id)_initWithImportOrigin:(unsigned long long)arg1 originUUID:(id)arg2 forTestDrive:(BOOL)arg3;
@property(readonly, nonatomic) NSDictionary *dictionaryRepresentation;
- (BOOL)isEqual:(id)arg1;
- (id)initWithImportInfo:(id)arg1 testDriveStatus:(BOOL)arg2;
- (id)initForTestDriveWithImportOrigin:(unsigned long long)arg1 originUUID:(id)arg2;
- (id)initWithImportOrigin:(unsigned long long)arg1 originUUID:(id)arg2;
- (id)initFromDictionary:(id)arg1;
- (id)init;

@end

__attribute__((visibility("hidden")))
@interface BookmarkLocation : NSObject
{
    NSString *_parentUUID;
    unsigned long long _childIndex;
}

@property unsigned long long childIndex; // @synthesize childIndex=_childIndex;
@property(copy) NSString *parentUUID; // @synthesize parentUUID=_parentUUID;
//- (void).cxx_destruct;

@end

__attribute__((visibility("hidden")))
@interface BookmarkChange : NSObject
{
    BOOL _move;
    int _changeType;
    NSString *_token;
    NSString *_bookmarkUUID;
    long long _bookmarkType;
    NSString *_bookmarkSyncServerID;
    NSSet *_changedAttributes;
    NSData *_deletedBookmarkSyncData;
}

+ (id)bookmarkChangeWithDictionaryRepresentation:(id)arg1;
+ (id)bookmarkMoveChangeWithBookmark:(id)arg1;
+ (id)bookmarkModifyChangeWithBookmark:(id)arg1 changedAttributes:(id)arg2;
+ (id)bookmarkDeleteChangeWithBookmark:(id)arg1;
+ (id)bookmarkAddChangeWithBookmark:(id)arg1;
+ (id)_bookmarkChangeWithBookmark:(id)arg1 changeType:(int)arg2;
+ (void)sortChangesInArray:(id)arg1 inBookmarkGroup:(id)arg2;
+ (void)removeRedundantChangesInArray:(id)arg1;
@property(copy, nonatomic) NSData *deletedBookmarkSyncData; // @synthesize deletedBookmarkSyncData=_deletedBookmarkSyncData;
@property(readonly, copy, nonatomic) NSSet *changedAttributes; // @synthesize changedAttributes=_changedAttributes;
@property(readonly, nonatomic, getter=isMove) BOOL move; // @synthesize move=_move;
@property(readonly, copy, nonatomic) NSString *bookmarkSyncServerID; // @synthesize bookmarkSyncServerID=_bookmarkSyncServerID;
@property(readonly, nonatomic) long long bookmarkType; // @synthesize bookmarkType=_bookmarkType;
@property(readonly, copy, nonatomic) NSString *bookmarkUUID; // @synthesize bookmarkUUID=_bookmarkUUID;
@property(readonly, copy, nonatomic) NSString *token; // @synthesize token=_token;
@property(readonly, nonatomic) int changeType; // @synthesize changeType=_changeType;
//- (void).cxx_destruct;
- (id)bookmarkModifyChangeWithChangedAttributes:(id)arg1;
- (id)bookmarkMoveChangeWithChangedAttributes:(id)arg1;
- (id)description;
@property(readonly, copy, nonatomic) NSDictionary *dictionaryRepresentation;
- (id)_initWithBookmarkChangeType:(int)arg1 token:(id)arg2 bookmarkUUID:(id)arg3 bookmarkType:(long long)arg4 bookmarkSyncServerID:(id)arg5 deletedBookmarkSyncData:(id)arg6;

@end

__attribute__((visibility("hidden")))
@interface BookmarkChangeTracker : NSObject
{
    NSMutableSet *_uuidsToTreatAsModifiesWhenAdding;
    NSMutableSet *_uuidsToIgnoreWhenDeleting;
    WebBookmarkGroup *_bookmarkGroup;
}

@property(readonly, nonatomic) __weak WebBookmarkGroup *bookmarkGroup; // @synthesize bookmarkGroup=_bookmarkGroup;
//- (void).cxx_destruct;
- (BOOL)_usesRealMoveOperation;
- (void)_recordDelete:(id)arg1;
- (void)_recordModify:(id)arg1 isMove:(BOOL)arg2 changedAttributes:(id)arg3;
- (void)_recordAdd:(id)arg1;
- (void)bookmarkWasModified:(id)arg1 changedAttributes:(id)arg2;
- (void)bookmarkWasRemoved:(id)arg1;
- (void)bookmarkWasAdded:(id)arg1;
- (void)endMoveBookmarkBetweenParents:(id)arg1;
- (void)beginMoveBookmarkBetweenParents:(id)arg1;
- (void)endMoveBookmarkWithinParent:(id)arg1;
- (void)beginMoveBookmarkWithinParent:(id)arg1;
- (id)initWithBookmarkGroup:(id)arg1;

@end

__attribute__((visibility("hidden")))
@interface BookmarkMergeDriver : NSObject
{
    BookmarksUndoController *_bookmarksUndoController;
    BOOL _delegateImplementsShouldMergeTitles;
    //id <BookmarkMergeDriverDelegate> _delegate;
    NSURL *_davHomeURL;
}

@property(retain, nonatomic) NSURL *davHomeURL; // @synthesize davHomeURL=_davHomeURL;
//@property(nonatomic) __weak id <BookmarkMergeDriverDelegate> delegate; // @synthesize delegate=_delegate;
//- (void).cxx_destruct;
- (void)_mergeBookmark:(id)arg1 withExistingBookmark:(id)arg2;
- (void)mergeBookmarkFolder:(id)arg1 withExistingFolder:(id)arg2;
- (id)initWithUndoController:(id)arg1;
- (id)init;

@end

__attribute__((visibility("hidden")))
@interface BookmarkMoveUndoInfo : NSObject
{
    NSString *_parentUUID;
    unsigned long long _midMoveInitialIndex;
    NSMutableArray *_midMoveSourceBookmarkLocations;
}

@property(readonly) unsigned long long midMoveInitialIndex; // @synthesize midMoveInitialIndex=_midMoveInitialIndex;
@property(readonly) NSString *parentUUID; // @synthesize parentUUID=_parentUUID;
//- (void).cxx_destruct;
- (id)midMoveSourceBookmarkLocations;
- (void)addMidMoveSourceBookmarkLocation:(id)arg1;
- (id)initWithParentUUID:(id)arg1 midMoveInitialIndex:(unsigned long long)arg2;
- (id)init;

@end

__attribute__((visibility("hidden")))
@interface BookmarkRemovalUndoInfo : NSObject
{
    WebBookmark *_bookmark;
    SAFARI_FOLDER_CLASS *_parent;
    unsigned long long _index;
}

+ (id)infoWithBookmark:(id)arg1;
@property(readonly, nonatomic) unsigned long long index; // @synthesize index=_index;
@property(readonly, retain, nonatomic) SAFARI_FOLDER_CLASS *parent; // @synthesize parent=_parent;
@property(readonly, retain, nonatomic) WebBookmark *bookmark; // @synthesize bookmark=_bookmark;
//- (void).cxx_destruct;
- (id)initWithBookmark:(id)arg1;
- (id)init;

@end

@interface BookmarksController : NSObject <BookmarkGroupDelegate /*, FileChangeObserverClient, FileLockerClient, FileLockerLogDelegate, BookmarksUndoControllerDataStore(added between macOS 10.13.3 nd 10.14.4), Command1Through9Receiver */>
{
    BOOL _loaded;
    NSMutableDictionary *_proxiesByIdentifier;
    //    SpotlightBookmarksWriter *_spotlightBookmarksWriter;
    // WBSSiteMetadataManager *_siteMetadataManager; // added between macOS 10.13.3 nd 10.14.4
    unsigned long long _bookmarksFileSize;
    double _bookmarksFileTime;
    unsigned long long _bookmarksGeneration;
    //    struct unique_ptr<Safari::FileLocker, std::__1::default_delete<Safari::FileLocker>> _fileLocker;
    BOOL _waitingForLock;
    NSMutableArray *_completionHandlersPendingLockAcquisition;
    unsigned long long _numberOfPendingSaveRequests;
    long long _pendingSavePriority;
    NSTimer *_pendingSaveTimer;
    double _pendingSaveTimerInterval;
    //    FileChangeObserver *_fileChangeObserver;
    BOOL _userIsOffline;
    NSMutableArray *_bookmarksThatRequestedMetadataFetchWhileOffline;
    NSURL *_builtInBookmarksURL;  // added between macOS 10.13.3 nd 10.14.4
    NSMutableArray *_migratedNonSafariBookmarkFiles;
    NSString *_bookmarksFileLockPath;
    BOOL _isReadOnly;
    BOOL _shouldResetCloudKitMigrationStateOnNextLoad;  // New in 10.13
    BOOL _didFillWithBuiltInBookmarks;
    BOOL _reloadingBookmarks;
    BOOL _savePending;
    WebBookmarkGroup *_allBookmarks;
    SAFARI_FOLDER_CLASS *_bookmarksBarCollection;
    SAFARI_FOLDER_CLASS *_bookmarksMenuCollection;
    NSString *_bookmarksFilePath;
    //  CloudBookmarksMigrationCoordinationConsul *_bookmarksMigrationCoordinationConsul;
    NSURL *_migratedBookmarksFolder;
    //   struct SHA256Hash _builtInBookmarksStateHash;
}

+ (void)_syncAgentDidDetectHierarchyIssue:(id)arg1;
+ (void)_syncAgentDidDetectBug:(id)arg1;
+ (id)bookmarkTitleForProxyIdentifier:(id)arg1;
+ (id)bookmarkSourceForProxyIdentifier:(id)arg1;
+ (void)_tellUserThatExternalChangePreemptedLocalChange;
+ (void)tellUserThatSyncWon;  // Displays NSAlert with informative text "You can’t change your bookmarks right now because they are being synchronized. Wait a few minutes, and then try again."
+ (void)_requestSyncClientTriggerSyncForBookmarkGroup:(id)arg1 skipRequestIfNoChanges:(BOOL)arg2;  // New in 10.13
+ (void)requestSyncClientTriggerSyncForBookmarkGroup:(id)arg1 skipRequestIfNoChanges:(BOOL)arg2;  // New in 10.13
+ (void)requestSyncClientTriggerSyncForBookmarkGroup:(id)arg1; // Available both 10.12 and 10.13
+ (id)_builtInBookmarksLocaleKey;  // added between macOS 10.13.3 nd 10.14.4
+ (id)_bookmarksMenuCollectionTitle;  // Not present in macOS 13
+ (id)existingSharedController;
+ (id)sharedController;
+ (id)_sharedControllerWithInstance:(id *)arg1;  // did have a second argument in older macOS versions: spotlightCacheController:(id)arg2
+ (id)_defaultMigratedBookmarksFolderURL;  // removed between macOS 10.13.3 nd 10.14.4
+ (id)fileLockURLForBookmarkFileURL:(id)arg1;  // added between macOS 10.13.3 nd 10.14.4
+ (id)defaultBookmarksFileLockURL; // Not present in macOS 13
+ (id)defaultBookmarksFileURL;
+ (id)standardBookmarksFilePath; // in macOS 10.11.3, not in 10.11.6, not in macOS 13
@property(retain, nonatomic) NSURL *migratedBookmarksFolder; // @synthesize migratedBookmarksFolder=_migratedBookmarksFolder;
@property(nonatomic, getter=isSavePending) BOOL savePending; // @synthesize savePending=_savePending;
@property(nonatomic, getter=isReloadingBookmarks) BOOL reloadingBookmarks; // @synthesize reloadingBookmarks=_reloadingBookmarks;
@property(nonatomic) BOOL didFillWithBuiltInBookmarks; // @synthesize didFillWithBuiltInBookmarks=_didFillWithBuiltInBookmarks;
@property(nonatomic) struct SHA256Hash builtInBookmarksStateHash; // @synthesize builtInBookmarksStateHash=_builtInBookmarksStateHash;
@property(nonatomic) BOOL shouldResetCloudKitMigrationStateOnNextLoad; /* New in 10.13 */ // @synthesize shouldResetCloudKitMigrationStateOnNextLoad=_shouldResetCloudKitMigrationStateOnNextLoad;
//@property(readonly, nonatomic) CloudBookmarksMigrationCoordinationConsul *bookmarksMigrationCoordinationConsul; // @synthesize bookmarksMigrationCoordinationConsul=_bookmarksMigrationCoordinationConsul;
@property(readonly, copy, nonatomic) NSString *bookmarksFileLockPath; // @synthesize bookmarksFileLockPath=_bookmarksFileLockPath;
@property(readonly, copy, nonatomic) NSString *bookmarksFilePath; // @synthesize bookmarksFilePath=_bookmarksFilePath;
@property(readonly, retain, nonatomic) SAFARI_FOLDER_CLASS *bookmarksMenuCollection; // @synthesize bookmarksMenuCollection=_bookmarksMenuCollection;
@property(readonly, retain, nonatomic) SAFARI_FOLDER_CLASS *bookmarksBarCollection; // @synthesize bookmarksBarCollection=_bookmarksBarCollection;
@property(readonly, nonatomic) WebBookmarkGroup *allBookmarks; // @synthesize allBookmarks=_allBookmarks;
@property(nonatomic) BOOL isReadOnly; // @synthesize isReadOnly=_isReadOnly;
//- (id).cxx_construct;
//- (void).cxx_destruct;
- (void)_updateSandboxExtensionFromStoreIfNeeded:(id)arg1;  // added between macOS 10.13.3 nd 10.14.4
- (void)_removeSandboxExtensionFromStoreIfNeeded:(id)arg1;  // added between macOS 10.13.3 nd 10.14.4
- (void)_stopObservingNetworkChangeNotifications;
- (void)_didReceiveNetworkChangeNotification:(id)arg1;
- (void)_beginObservingNetworkChangeNotifications;
- (BOOL)_shouldTryToFetchMetadataForBookmarkLeaf:(id)arg1;
- (void)fetchMetadataForBookmark:(id)arg1 completionHandler:(CDUnknownBlockType)arg2;
- (id)bookmarkGroupForUndoController:(id)arg1;  // added between macOS 10.13.3 nd 10.14.4
- (void)handleCommand1Through9ActionForIndex:(unsigned long long)arg1;
- (BOOL)canHandleCommand1Through9ActionForIndex:(unsigned long long)arg1;
- (void)displayNewBookmarksSheetForBookmark:(id)arg1 inWindow:(id)arg2;
- (void)_addBookmark:(id)arg1 parent:(id)arg2;
- (void)_addBookmarkToTopSites:(id)arg1 customizedTitle:(id)arg2;
- (void)addTopLevelBookmark:(id)arg1;
- (void)addTopLevelBookmark:(id)arg1 title:(id)arg2;
- (void)_updateDisplayedTitlesForBuiltInBookmarks:(id)arg1;
- (void)_updateBookmarkSourcesSkippingSave:(BOOL)arg1;
- (void)_fillBookmarksBarWithBuiltInBookmarksIfNecessary;
- (id)_builtInBookmarksBarBookmark;
- (void)_fillWithBuiltInBookmarks;
- (void)_copyChildBookmarksFromBookmark:(id)arg1 toBookmark:(id)arg2;
- (void)_sendFavoritesChangedNotification;
- (BOOL)_favoritesContainsBookmark:(id)arg1;
- (BOOL)_menuContainsBookmark:(id)arg1;
- (void)fetchBookmarksMenuCollectionWithCompletionHandler:(CDUnknownBlockType)arg1;
- (void)fetchBookmarksBarCollectionWithCompletionHandler:(CDUnknownBlockType)arg1;
- (void)dealloc;
@property(readonly, nonatomic) WebBookmark *historyCollection;
- (id)_initWithBookmarksFilePath:(id)arg1 migratedBookmarksFolder:(id)arg2 spotlightCacheController:(id)arg3;  // macOS 10.13.3 and earlier only
- (id)_initWithBookmarksFilePath:(id)arg1 builtInBookmarksURL:(id)arg2 migratedBookmarksFolder:(id)arg3 spotlightCacheController:(id)arg4 siteMetadataManager:(id)arg5; // macOS 10.14 - 10.14.4b2
- (id)_initWithBookmarksFilePath:(id)arg1 builtInBookmarksURL:(id)arg2 migratedBookmarksFolder:(id)arg3 spotlightCacheController:(id)arg4 siteMetadataManagerProvider:(id)arg5; // macOS 10.14.4b3 and later
- (void)resetWithBookmarksFilePath:(id)arg1 migratedBookmarksFolder:(id)arg2 spotlightCacheController:(id)arg3;  // old method, macOS 10.13.3 and earlier, replaced by next line
- (id)_initWithBookmarksFilePath:(id)arg1 builtInBookmarksURL:(id)arg2 migratedBookmarksFolder:(id)arg3 siteMetadataManagerProvider:(id)arg5; // macOS 13 Beta 4 and later, and maybe earlier – don't know
- (void)resetWithBookmarksFilePath:(id)arg1;  // new method, macOS 10.14.4 and later
- (void)_deleteMigratedNonSafariBookmarkFiles;
- (void)_importMigratedNonSafariBookmarks;
- (int)_importMigratedSafariBookmarks;
- (void)_deleteMigratedBookmarksDirectoryIfContainsNoMigratableFiles;
- (void)exportBookmarks;
- (void)exportBookmarksToPath:(id)arg1 shouldHideExtension:(BOOL)arg2;
- (void)bookmarkGroup:(id)arg1 bookmarkDidChange:(id)arg2 changeWasInteractive:(BOOL)arg3;
- (void)bookmarkGroup:(id)arg1 bookmarkWasRemoved:(id)arg2 fromParent:(id)arg3;
- (void)bookmarkGroup:(id)arg1 bookmarkWasAdded:(id)arg2 toParent:(id)arg3;
- (void)bookmarkGroup:(id)arg1 bookmarksWereCleanedUpInList:(id)arg2;  // added between macOS 10.13.3 nd 10.14.4
- (void)bookmarksWereReloadedInGroup:(id)arg1;
- (void)_postDidRemoveNotificationForBookmark:(id)arg1 parent:(id)arg2;
- (void)_postDidAddNotificationForBookmark:(id)arg1 parent:(id)arg2;
- (void)_postDidChangeNotificationForBookmark:(id)arg1;
- (void)_postBookmarksWereReloadedNotification;
- (void)_savePendingChangesSoonForPossiblyInteractiveBookmarkChange:(BOOL)arg1 completionHandler:(CDUnknownBlockType)arg2;
- (void)_postFavoritesChangedNotificationsIfNecessaryForChangeToBookmark:(id)arg1 parent:(id)arg2;
- (id)bookmarkForNewWindowTabsPreference;
- (void)clearProxiesByIdentifier;
- (void)insertProxyBookmarkWithIdentifier:(id)arg1 atIndex:(unsigned long long)arg2;
- (id)bookmarkForPersistentIdentifier:(id)arg1;
- (id)persistentIdentifierForBookmark:(id)arg1;
- (BOOL)_shouldTellUserAboutBookmarkSaveProblems;
- (void)_savePendingChangesWithCompletionHandler:(CDUnknownBlockType)arg1;
- (void)savePendingChangesSynchronously;
- (void)__savePendingChangesSoonWithPriority:(long long)arg1 completionHandler:(CDUnknownBlockType)arg2;
- (void)_savePendingChangesSoonWithPriority:(long long)arg1 completionHandler:(CDUnknownBlockType)arg2;
//- (void)fileLocker:(const struct FileLocker *)arg1 logPrivacyPreservingString:(const char *)arg2 ofType:(unsigned char)arg3;
- (void)_resetPendingSavePriority;
- (void)_unlockFileLockerWithCompletionHandler:(CDUnknownBlockType)arg1;
- (void)_lockFileLockerWithCompletionHandler:(CDUnknownBlockType)arg1;
//- (void)fileLocker:(const struct FileLocker *)arg1 lockWasStolen:(id)arg2;
//- (int)fileLocker:(const struct FileLocker *)arg1 actionForApparentlyAbandonedLock:(id)arg2;
- (id)_bookmarkSourceCreateIfNeededWithPossibleTitles:(id)arg1 displayTitle:(id)arg2 indexInTopBookmark:(unsigned long long)arg3 fileNeedsUpdate:(char *)arg4;
- (id)_bookmarkSourceWithPossibleTitles:(id)arg1 displayTitle:(id)arg2 bookmarkIndex:(unsigned long long *)arg3 isFirstTitle:(char *)arg4;
- (void)fetchBookmarkSourceWithStoredTitle:(id)arg1 displayedTitle:(id)arg2 completionHandler:(CDUnknownBlockType)arg3;
- (BOOL)_reloadBookmarksCheckingIfFileChanged:(BOOL)arg1;
- (BOOL)reloadBookmarksFromFileIfChanged;
- (BOOL)_bookmarksFileHasChanged;
- (void)fileChangeObserverFileDidChange:(id)arg1;
- (void)_flushPendingSaveCompletionHandlersWithSuccess:(BOOL)arg1;
- (void)_enqueueSaveCompletionHandler:(CDUnknownBlockType)arg1;
- (void)performUpdatesAtomically:(CDUnknownBlockType)arg1 completionHandler:(CDUnknownBlockType)arg2;
- (void)_schedulePendingSaveTimerWithPriority:(long long)arg1 previousTimerInterval:(double)arg2;
- (void)_invalidatePendingSaveTimer;
- (void)_pendingSaveTimerFired:(id)arg1;
- (void)_rememberBookmarksFileInfo;
- (id)_findNthFavoriteLeaf:(unsigned long long)arg1;
@property(readonly, nonatomic) SAFARI_FOLDER_CLASS *topBookmarkIfLoaded;
- (id)builtInBookmarks;
- (id)_bookmarksBarCollectionPossibleTitles;
@property(readonly, nonatomic) NSString *bookmarksBarCollectionTitle;
- (id)_bookmarksMenuCollectionPossibleTitles;
- (BOOL)clearLocalDataForAutomatedTestingPurposes;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
//@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end

__attribute__((visibility("hidden")))
@interface BookmarksUndoController : NSObject
{
    NSUndoManager *_undoManager;
    id <BookmarksUndoControllerDataStore> _dataStore;  // New in macOS 10.14.4
    BookmarksController *_bookmarksController;    // New in macOS 10.14.4
    NSUndoManager *_strongUndoManager;
    unsigned long long _undoCompatibleChangeCount;
    NSMutableArray *_transactionActionNameStack;
}

+ (BOOL)canPerformUserInitiatedBookmarkOperations;
+ (id)frontmostUndoController;
@property(nonatomic) __weak NSUndoManager *undoManager; // @synthesize undoManager=_undoManager;
//- (void).cxx_destruct;
- (id)_insertBookmarksFromPasteboard:(id)arg1 inFolder:(id)arg2 startingIndex:(unsigned long long)arg3 undoTarget:(id)arg4 selector:(SEL)arg5 isCopy:(BOOL)arg6;
- (id)_addNewFolderTo:(id)arg1 withTitle:(id)arg2 insertionIndex:(unsigned long long)arg3 undoTarget:(id)arg4 selector:(SEL)arg5;
- (BOOL)_moveBookmarks:(id)arg1 to:(id)arg2 startingIndex:(unsigned long long)arg3 isCopy:(BOOL)arg4 undoTarget:(id)arg5 selector:(SEL)arg6 addedBookmarks:(id *)arg7;
- (id)_redoMoveBookmarksWithUndoInfo:(id)arg1 preflightBlock:(CDUnknownBlockType)arg2 completionBlock:(CDUnknownBlockType)arg3 undoPreflightBlock:(CDUnknownBlockType)arg4 undoCompletionBlock:(CDUnknownBlockType)arg5;
- (id)_undoMoveBookmarksWithUndoInfo:(id)arg1 preflightBlock:(CDUnknownBlockType)arg2 completionBlock:(CDUnknownBlockType)arg3 redoPreflightBlock:(CDUnknownBlockType)arg4 redoCompletionBlock:(CDUnknownBlockType)arg5;
- (id)_undoMoveBookmarks:(id)arg1;
- (void)_redoNewBookmarkWithUndoInfo:(id)arg1 preflightBlock:(CDUnknownBlockType)arg2 completionBlock:(CDUnknownBlockType)arg3 undoPreflightBlock:(CDUnknownBlockType)arg4 undoCompletionBlock:(CDUnknownBlockType)arg5;
- (void)_undoNewBookmarkWithUndoInfo:(id)arg1 preflightBlock:(CDUnknownBlockType)arg2 completionBlock:(CDUnknownBlockType)arg3 redoPreflightBlock:(CDUnknownBlockType)arg4 redoCompletionBlock:(CDUnknownBlockType)arg5;
- (void)_undoNewBookmark:(id)arg1;
- (void)_redoRemoveBookmarks:(id)arg1;
- (void)_undoRemoveBookmarks:(id)arg1;
- (void)_undoChangeAddress:(id)arg1;
- (void)_undoChangePreviewText:(id)arg1;
- (void)_undoChangeTitle:(id)arg1;
- (id)_popTransactionActionNameStack;
- (id)_bookmarkForContentChangeUndoInfo:(id)arg1;
- (void)_bookmarksChanged:(id)arg1;
- (void)_stopObservation;
- (void)_startObservation;
- (id)copyBookmarksFromPasteboard:(id)arg1 toFolder:(id)arg2 startingIndex:(unsigned long long)arg3;
- (id)moveBookmarksFromPasteboard:(id)arg1 toFolder:(id)arg2 startingIndex:(unsigned long long)arg3;
- (BOOL)toggleFolderAutomaticallyReplacesTabs:(id)arg1;
- (BOOL)insertBookmarks:(id)arg1 startingAtIndex:(unsigned long long)arg2 inBookmarkFolder:(id)arg3;
- (BOOL)insertBookmark:(id)arg1 atIndex:(unsigned long long)arg2 inBookmarkFolder:(id)arg3 allowDuplicateURLs:(BOOL)arg4;
- (id)moveBookmarks:(id)arg1 toNewFolderWithTitle:(id)arg2 replacingBookmark:(id)arg3;
- (id)addNewFolderTo:(id)arg1 withTitle:(id)arg2 insertionIndex:(unsigned long long)arg3;
- (BOOL)moveBookmarks:(id)arg1 to:(id)arg2 startingIndex:(unsigned long long)arg3;
- (BOOL)removeBookmarks:(id)arg1;
- (BOOL)changeAddressOfBookmark:(id)arg1 to:(id)arg2;
- (BOOL)changePreviewTextOfBookmark:(id)arg1 to:(id)arg2 isUserCustomized:(BOOL)arg3;
- (BOOL)changeTitleOfBookmark:(id)arg1 to:(id)arg2;
- (id)addNewContentsFolderTo:(id)arg1 withTitle:(id)arg2 insertionIndex:(unsigned long long)arg3 undoTarget:(id)arg4 selector:(SEL)arg5;
- (void)finishMovingBookmarks:(id)arg1 originalBookmarks:(id)arg2 undoTarget:(id)arg3 selector:(SEL)arg4;
- (id)copyBookmarksFromPasteboard:(id)arg1 toFolder:(id)arg2 startingIndex:(unsigned long long)arg3 undoTarget:(id)arg4 selector:(SEL)arg5;
- (id)moveBookmarksFromPasteboard:(id)arg1 toFolder:(id)arg2 startingIndex:(unsigned long long)arg3 undoTarget:(id)arg4 selector:(SEL)arg5;
- (void)redoMoveBookmarksWithUndoInfo:(id)arg1 preflightBlock:(CDUnknownBlockType)arg2 completionBlock:(CDUnknownBlockType)arg3 undoPreflightBlock:(CDUnknownBlockType)arg4 undoCompletionBlock:(CDUnknownBlockType)arg5;
- (void)undoMoveBookmarksWithUndoInfo:(id)arg1 preflightBlock:(CDUnknownBlockType)arg2 completionBlock:(CDUnknownBlockType)arg3 redoPreflightBlock:(CDUnknownBlockType)arg4 redoCompletionBlock:(CDUnknownBlockType)arg5;
- (void)redoNewBookmarkWithUndoInfo:(id)arg1 preflightBlock:(CDUnknownBlockType)arg2 completionBlock:(CDUnknownBlockType)arg3 undoPreflightBlock:(CDUnknownBlockType)arg4 undoCompletionBlock:(CDUnknownBlockType)arg5;
- (void)undoNewBookmarkWithUndoInfo:(id)arg1 preflightBlock:(CDUnknownBlockType)arg2 completionBlock:(CDUnknownBlockType)arg3 redoPreflightBlock:(CDUnknownBlockType)arg4 redoCompletionBlock:(CDUnknownBlockType)arg5;
- (id)replaceBookmarksWithUndoInfo:(id)arg1 target:(id)arg2 selector:(SEL)arg3 reverseOrder:(BOOL)arg4;
- (void)removeBookmarksWithUndoInfo:(id)arg1 target:(id)arg2 selector:(SEL)arg3;
- (void)performUndoCompatibleBookmarksChangeWithActionName:(id)arg1 logActionName:(id)arg2 inBlock:(CDUnknownBlockType)arg3;
- (void)performUndoCompatibleBookmarksChangeInBlock:(CDUnknownBlockType)arg1;
- (void)didPerformUndoCompatibleBookmarksChange;
- (void)willPerformUndoCompatibleBookmarksChange;
- (void)setCurrentTransactionActionName:(id)arg1;
- (void)endTransaction;
- (void)beginTransactionWithActionName:(id)arg1 logActionName:(id)arg2;
- (id)initWithUndoManager:(id)arg1;  // macOS 10.14.3 and earlier only
- (id)initWithUndoManager:(id)arg1 dataStore:(id)arg2 bookmarksController:(id)arg3; // macOS 10.14.4 and later only
- (void)dealloc;
- (id)init;  // present in macOS 10.13.3b1, gone in macOS 10.14.4b1

@end

__attribute__((visibility("hidden")))
@interface BookmarksURLMatchingOperation : NSOperation /* <ReusableResultBookmarksOperation, CacheableResultBookmarksOperation> */
{
    SAFARI_FOLDER_CLASS *_bookmarkList;
    NSURL *_url;
    WebBookmarkLeaf *_result;
}

+ (BOOL)cachedResultIsInvalidatedWhenBookmarksChange;
@property(retain, nonatomic) WebBookmarkLeaf *result; // @synthesize result=_result;
@property(readonly, nonatomic) NSURL *url; // @synthesize url=_url;
@property(readonly, nonatomic) SAFARI_FOLDER_CLASS *bookmarkList; // @synthesize bookmarkList=_bookmarkList;
//- (void).cxx_destruct;
@property(readonly, nonatomic) id <NSCopying> cacheKey;
- (BOOL)canReuseResultOfOperation:(id)arg1;
- (void)main;
- (id)initWithBookmarkList:(id)arg1 url:(id)arg2;
- (id)init;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end

__attribute__((visibility("hidden")))
@interface FeatureAvailability : NSObject // actually, WBSFeatureAvailability
{
//    NSObject<OS_dispatch_queue> *_internalQueue;
    BOOL _threadUnsafeUserSignedIntoICloud;
    BOOL _threadUnsafeSafariSyncEnabled;
    BOOL _threadUnsafeKeychainSyncEnabled;
    BOOL _threadUnsafeUserUsingManagedAppleID;
}

+ (BOOL)wantsAggressiveKeychainCredentialCaching;
+ (BOOL)_shouldShowRussianFeatures;
+ (BOOL)_shouldShowChineseFeatures;
+ (id)_sharedInstance;
+ (BOOL)_safariIsInRecoverySystem;
+ (BOOL)isTouchBarSupportAvailable;
+ (BOOL)isApplePayAvailable;
+ (BOOL)isUserAllowedToToggleMiscellaneousFormsAutoFillEnabledState;
+ (BOOL)isMiscellaneousFormsAutoFillEnabled;
+ (BOOL)isUserAllowedToTogglePasswordsAutoFillEnabledState;
+ (BOOL)isPasswordAutoFillEnabled;
+ (BOOL)isUserAllowedToToggleAddressBookAutoFillEnabledState;
+ (BOOL)isAddressBookAutoFillEnabled;
+ (BOOL)canShowParsecITunesResults;
+ (BOOL)isCloudKitBookmarksAvailable;
+ (BOOL)isCloudTabsAvailable;
+ (BOOL)isUserAllowedToEditCreditCardInformation;
+ (BOOL)isUserAllowedToToggleCreditCardAutoFillEnabledState;
+ (BOOL)isCreditCardAutoFillEnabled;
+ (BOOL)isKeychainSyncEnabled;
+ (BOOL)isUserUsingManagedAppleID;
+ (BOOL)isSafariSyncEnabled;
+ (BOOL)isUserSignedIntoICloud;
+ (void)startMonitoringForAvailabilityChanges;
@property(getter=isUserUsingManagedAppleID) BOOL userUsingManagedAppleID; // @synthesize userUsingManagedAppleID=_threadUnsafeUserUsingManagedAppleID;
@property(getter=isKeychainSyncEnabled) BOOL keychainSyncEnabled; // @synthesize keychainSyncEnabled=_threadUnsafeKeychainSyncEnabled;
@property(getter=isUserSignedIntoICloud) BOOL userSignedIntoICloud; // @synthesize userSignedIntoICloud=_threadUnsafeUserSignedIntoICloud;
@property(getter=isSafariSyncEnabled) BOOL safariSyncEnabled; // @synthesize safariSyncEnabled=_threadUnsafeSafariSyncEnabled;
- (void)_updateKeychainSyncingStatus;
- (void)_iCloudServiceStatusChanged:(id)arg1;
- (void)_iCloudLoggedInStateDidChange:(id)arg1;
- (id)init;

@end

__attribute__((visibility("hidden")))
@interface WebBookmark : NSObject <NSPasteboardWriting, NSPasteboardReading, NSCopying>
{
    BOOL _threadUnsafeShouldOmitFromUI;
    BOOL _canOpenInTabs;
    NSString *_UUID;
    NSString *_threadUnsafeTitle;
    NSDictionary *_threadUnsafeReadingListItemAttributes;
    NSDictionary *_threadUnsafeReadingListItemNonSyncAttributes;
    // BookmarkImportInfo *_threadUnsafeImportInfo;
    WebBookmarkGroup *_group;
    SAFARI_FOLDER_CLASS *_parent;
    NSString *_identifier;
    NSString *_syncServerID;
    NSDictionary *_syncExtraAttributes;
    NSString *_syncKey;
    NSData *_syncData;
}

+ (id)bookmarkWithURLString:(id)arg1 title:(id)arg2;
+ (id)bookmarkFromHistoryItem:(id)arg1;
+ (id)bookmarkFromDictionaryRepresentation:(id)arg1 topLevelOnly:(BOOL)arg2 withGroup:(id)arg3;
+ (id)bookmarkFromDictionaryRepresentation:(id)arg1 withGroup:(id)arg2;
+ (id)_bookmarkFromDictionaryRepresentation:(id)arg1 topLevelOnly:(BOOL)arg2 withGroup:(id)arg3;
+ (BOOL)_getBookmarkType:(long long *)arg1 fromDictionaryRepresentation:(id)arg2;
+ (id)emptyFolderTitle;
+ (Class)_classForBookmarkType:(long long)arg1;
+ (id)bookmarkOfType:(long long)arg1 identifier:(id)arg2 UUID:(id)arg3 group:(id)arg4;
+ (id)bookmarkOfType:(long long)arg1;
+ (void)initializeCollections;
+ (id)allCollectionsRoot;
+ (id)bookmarkForFileOrFolderAtPath:(id)arg1;
+ (BOOL)isAcceptableBookmarkObjectPath:(id)arg1;
+ (id)_bookmarkForFileOrFolderAtPath:(id)arg1 directoryDepth:(unsigned int)arg2;
+ (id)bookmarkWithURL:(id)arg1 title:(id)arg2;
+ (id)defaultTitleFromURL:(id)arg1;
+ (void)replaceTabsWithBookmarks:(id)arg1 tabPlacementHint:(const struct TabPlacementHint *)arg2;
+ (void)replaceTabsWithBookmarks:(id)arg1 tabPlacementHint:(const struct TabPlacementHint *)arg2 confirmQuantity:(BOOL)arg3;
+ (void)performTabVisitingOperationWithURLs:(id)arg1 titles:(id)arg2 tabPlacementHint:(const struct TabPlacementHint *)arg3 confirmQuantity:(BOOL)arg4 confirmationMessageText:(id)arg5 continueButtonMessageText:(id)arg6 operationBlock:(CDUnknownBlockType)arg7;
+ (void)replaceTabsWithURLs:(id)arg1 titles:(id)arg2 tabPlacementHint:(const struct TabPlacementHint *)arg3 confirmQuantity:(BOOL)arg4;
+ (void)openAllUrlsInNewTabs:(id)arg1 withTitles:(id)arg2 tabPlacementHint:(const struct TabPlacementHint *)arg3 confirmQuantity:(BOOL)arg4;
+ (id)urlsForBookmarks:(id)arg1 withTitles:(id *)arg2;
+ (id)_flattenedDescendantsOfBookmarks:(id)arg1;
+ (void)_addFlattenedDescendantsOfBookmarks:(id)arg1 toArray:(id)arg2;
+ (unsigned long long)readingOptionsForType:(id)arg1 pasteboard:(id)arg2;
+ (id)readableTypesForPasteboard:(id)arg1;
@property(copy, nonatomic) NSData *syncData; // @synthesize syncData=_syncData;
@property(copy, nonatomic) NSString *syncKey; // @synthesize syncKey=_syncKey;
@property(copy, nonatomic) NSDictionary *syncExtraAttributes; // @synthesize syncExtraAttributes=_syncExtraAttributes;
@property(copy, nonatomic) NSString *syncServerID; // @synthesize syncServerID=_syncServerID;
@property(readonly, nonatomic) BOOL canOpenInTabs; // @synthesize canOpenInTabs=_canOpenInTabs;
@property(copy) NSString *identifier; // @synthesize identifier=_identifier;
@property(setter=_setParent:) __weak SAFARI_FOLDER_CLASS *parent; // @synthesize parent=_parent;
@property(nonatomic) __weak WebBookmarkGroup *group; // @synthesize group=_group;
// - (void).cxx_destruct;
// - (void)_updateStateHash:(struct SHA256 *)arg1;
- (BOOL)_looksLikeTopLevelBookmarkFolderWithTitle:(id)arg1;
- (BOOL)_canLookLikeTopLevelBookmarkFolder;
- (BOOL)mergeAttributesFromBookmark:(id)arg1;
- (BOOL)updateByCopyingAttributesFromBookmark:(id)arg1 withExistingBookmarksByUUID:(id)arg2;
// @property(retain) BookmarkImportInfo *importInfo; // @synthesize importInfo=_threadUnsafeImportInfo;
- (void)setImportInfo:(id)arg1 changeWasInteractive:(BOOL)arg2;
- (BOOL)_serverIDMatchesCurrentDAVHomeURL:(id)arg1;
- (BOOL)hasPriorityOverBookmarkForDeduplication:(id)arg1 currentDAVHomeURL:(id)arg2 preferBookmarkWithSyncData:(BOOL)arg3;
- (BOOL)isUserVisiblyEqualToBookmark:(id)arg1;
- (BOOL)isDescendantOf:(id)arg1 comparingUUIDs:(BOOL)arg2;
- (BOOL)isDescendantOf:(id)arg1;
- (BOOL)isFolderWithTitle:(id)arg1;
- (void)clearUUID;
- (id)init;
// - (id)initWithTopSite:(struct TopSite *)arg1;
- (id)initWithIdentifier:(id)arg1 UUID:(id)arg2 group:(id)arg3;
- (id)initFromDictionaryRepresentation:(id)arg1 withGroup:(id)arg2;
- (id)initFromDictionaryRepresentation:(id)arg1 topLevelOnly:(BOOL)arg2 withGroup:(id)arg3;
- (id)_syncDataAsDictionary;
- (void)_loadSyncDataFromDictionary:(id)arg1;
- (id)_mutableDictionaryRepresentation;
@property(readonly, copy, nonatomic) NSDictionary *dictionaryRepresentation;
@property(readonly, nonatomic) unsigned long long numberOfChildren;
@property(readonly, nonatomic) long long bookmarkType;
/* Jerry finds by looking at some items on 2022-04-0:
 bookmarkType = 0 --> bookmark
 bookmarkType1 = 1 --> folder */
@property(readonly, nonatomic) NSImage *icon;
@property(readonly, nonatomic) NSString *iconURLString;
- (void)_setTitle:(id)arg1 notifyBookmarkGroup:(BOOL)arg2 changeWasInteractive:(BOOL)arg3;
- (void)setTitleWithoutNotifications:(id)arg1;
- (void)setTitle:(id)arg1 changeWasInteractive:(BOOL)arg2;
@property(readonly, copy) NSString *title; // @synthesize title=_threadUnsafeTitle;
- (void)clearDAVSyncState;
- (void)clearSyncStateForDelete;
- (void)clearSyncStateForMove;
- (void)clearSyncStateForCopy;
- (void)clearAllChangesRecursively;
- (void)updateByCopyingSyncDataFromBookmark:(id)arg1 withChildBookmarksByUUID:(id)arg2;
- (void)clearSyncServerIDWithoutNotifications;
@property(copy) NSString *readingListItemPreviewText;
@property(retain) NSDate *readingListItemDateLastViewed;
@property(retain) NSDate *readingListItemDateAdded;
- (void)_removeReadingListAttributeValueForKey:(id)arg1;
- (void)_setReadingListItemAttributeValue:(id)arg1 forKey:(id)arg2;
- (void)setReadingListItemNonSyncAttributes:(id)arg1 shouldSuppressChangeNotification:(BOOL)arg2;
@property(copy) NSDictionary *readingListItemNonSyncAttributes; // @synthesize readingListItemNonSyncAttributes=_threadUnsafeReadingListItemNonSyncAttributes;
- (void)_setReadingListItemAttributes:(id)arg1 changedAttributes:(id)arg2;
@property(copy) NSDictionary *readingListItemAttributes; // @synthesize readingListItemAttributes=_threadUnsafeReadingListItemAttributes;
@property(readonly, nonatomic) BOOL looksLikeReadingList;
@property(readonly, nonatomic) BOOL looksLikeBookmarksMenu;
@property(readonly, nonatomic) BOOL looksLikeBookmarksBar;
@property(readonly, nonatomic) BOOL shouldOmitFromUIOrHasOmittedAncestor;
@property BOOL shouldOmitFromUI; // @synthesize shouldOmitFromUI=_threadUnsafeShouldOmitFromUI;
@property(readonly, nonatomic) struct SHA256Hash stateHash;
@property(readonly, nonatomic) unsigned long long numberOfAncestors;
@property(copy, nonatomic) NSString *UUID; // @synthesize UUID=_UUID;
@property(readonly, nonatomic) BOOL hasUUID;
@property(readonly, copy) NSString *description;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (void)dealloc;
- (BOOL)_contentItem:(id)arg1 matchesString:(id)arg2 options:(unsigned long long)arg3 searchCriteria:(unsigned long long)arg4;
- (void)_collectContentItems:(id)arg1 matchingSearchStrings:(id)arg2 orWithAddressInSet:(id)arg3 fromContentItem:(id)arg4 searchCriteria:(unsigned long long)arg5 searchDomain:(int)arg6;
- (BOOL)_addressOfContentItem:(id)arg1 isInSet:(id)arg2;
- (id)titleStringForContentItem:(id)arg1 forEditing:(BOOL)arg2;
- (id)parentStringForContentItem:(id)arg1;
- (id)parentOfContentItem:(id)arg1;
- (int)numberOfChildrenOfContentItem:(id)arg1;
- (BOOL)isCollection;
- (id)contentItemsToExpandOnReload;
- (id)contentItemsToInitiallyExpand;
- (id)contentItemsMatchingSearchStrings:(id)arg1 orWithAddressInSet:(id)arg2 searchCriteria:(unsigned long long)arg3 searchDomain:(int)arg4;
- (BOOL)contentItemCanHaveChildren:(id)arg1;
- (BOOL)contentItem:(id)arg1 matchesStrings:(id)arg2 options:(unsigned long long)arg3 searchCriteria:(unsigned long long)arg4;
- (void)didExpandContentItem:(id)arg1;
- (void)didCollapseContentItem:(id)arg1;
- (id)childAtIndex:(int)arg1 ofContentItem:(id)arg2;
- (BOOL)canDeleteContentItems;
- (BOOL)canCopyContentItems;
- (BOOL)canAddContentItems;
- (id)previewTextForContentItem:(id)arg1;
- (id)bookmarkFromContentItem:(id)arg1;
- (id)addressStringForContentItem:(id)arg1;
- (void)enumerateDescendantsIncludingFolders:(BOOL)arg1 usingBlock:(CDUnknownBlockType)arg2;
- (BOOL)_enumerateDescendantsIncludingFolders:(BOOL)arg1 usingBlock:(CDUnknownBlockType)arg2;
- (void)insertChild:(id)arg1 atIndex:(unsigned int)arg2 isCopy:(BOOL)arg3;
- (id)createInternetLocationFileHierarchyInDirectory:(id)arg1;
- (BOOL)isDescendantOfFavorites;
- (BOOL)isAncestorOf:(id)arg1;
- (BOOL)isOrHasAnyLeaves;
- (void)writeToPasteboard;
- (id)_browserWindowController;
- (void)replaceTabsWithDescendantsUsingTabPlacementHint:(const struct TabPlacementHint *)arg1 confirmQuantity:(BOOL)arg2;
- (void)replaceTabsWithDescendantsUsingTabPlacementHint:(const struct TabPlacementHint *)arg1;
- (void)openAllDescendantsInNewTabsWithTabPlacementHint:(const struct TabPlacementHint *)arg1 confirmQuantity:(BOOL)arg2;
- (void)openAllDescendantsInNewTabsWithTabPlacementHint:(const struct TabPlacementHint *)arg1;
- (id)_urlsOfDescendantsForOpeningTabsWithTitles:(id *)arg1;
- (id)_flattenedDescendants;
@property(readonly, copy, nonatomic) NSArray *flattenedDescendants;
- (void)_addFlattenedDescendantsToArray:(id)arg1;
- (void)replaceTabsWithDescendantsFromMenuItem:(id)arg1;
- (void)openAllInNewTabsFromMenuItem:(id)arg1;
- (void)goToFromMenuItem:(id)arg1;
- (void)goToUsingWindowPolicyFromCurrentEventWithTabPlacementHint:(const struct TabPlacementHint *)arg1;
- (void)goToInNewTabWithTabPlacementHint:(const struct TabPlacementHint *)arg1;
- (void)goToInNewWindow;
- (void)goToWithWindowPolicy:(long long)arg1 tabPlacementHint:(const struct TabPlacementHint *)arg2;
- (void)goToWithTabPlacementHint:(const struct TabPlacementHint *)arg1;
- (BOOL)insertBookmarkWithUndo:(id)arg1 atIndex:(unsigned long long)arg2 didCheckIfBookmarkEditingIsPermitted:(BOOL)arg3 allowDuplicateURLs:(BOOL)arg4;
- (id)convertWithUndoToFolderTitled:(id)arg1 addedBookmarks:(id)arg2;
- (BOOL)moveWithUndoToFolder:(id)arg1 index:(unsigned long long)arg2;
- (id)addNewSubfolderWithUndoTitled:(id)arg1 insertionIndex:(unsigned long long)arg2;
- (BOOL)deleteWithUndoWithoutAuthorization;
- (void)deleteWithUndo;
- (void)toggleAutomaticallyReplacesTabsWithUndo;
- (BOOL)setAddressWithUndo:(id)arg1;
- (BOOL)setPreviewTextWithUndo:(id)arg1 isUserCustomized:(BOOL)arg2;
- (BOOL)setTitleWithUndo:(id)arg1;
- (BOOL)_bookmarkEditingPermitted;
- (BOOL)canEditAddress;
- (id)initWithPasteboardPropertyList:(id)arg1 ofType:(id)arg2;
- (id)pasteboardPropertyListForType:(id)arg1;
- (id)writableTypesForPasteboard:(id)arg1;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
// @property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end

__attribute__((visibility("hidden")))
@interface WebBookmarkExporter : NSObject
{
    NSError *_error;
}

// - (void).cxx_destruct;
- (id)error;
- (id)initWithRootBookmark:(id)arg1 path:(id)arg2 hideExtension:(BOOL)arg3;
- (id)fileContentsWithRootBookmark:(id)arg1;
- (id)stringForRootBookmark:(id)arg1 withIndentLevel:(int)arg2;
- (id)stringForBookmark:(id)arg1 withIndentLevel:(int)arg2;
- (id)stringForBookmarkList:(id)arg1 withIndentLevel:(int)arg2;
- (id)stringForBookmarkLeaf:(id)arg1 withIndentLevel:(int)arg2;
- (id)escapeHTML:(id)arg1;
- (id)leadingWhiteSpaceForIndentLevel:(int)arg1;

@end

@class _LoadingBookmarkInfo;

@interface WebBookmarkGroup : NSObject
{
    // NSObject<OS_dispatch_queue> *_bookmarkLoadWaitingQueue;
    int _loadStatus;
    _LoadingBookmarkInfo *_bookmarkInfoPendingLoad;
    NSMutableDictionary *_bookmarksByURLString;
    NSMutableDictionary *_bookmarksByUUID;
    NSMutableDictionary *_bookmarksBySyncServerID;
    long long _changeTrackingSuppressionCount;
    long long _notificationSuppressionCount;
    long long _futureChangesDiscardabilityCount;
    //  BookmarkChangeTracker *_changeTracker;
    NSMutableArray *_changes;
    NSMutableArray *_pendingChanges;
    //  struct SHA256Hash _lastSeenBookmarkStateHash;
    BOOL _delegateImplementsBookmarkWasAdded;
    BOOL _delegateImplementsBookmarkWasRemoved;
    BOOL _delegateImplementsBookmarkDidChange;
    BOOL _syncInMergeMode;
    BOOL _keepsRemovedBookmarkReferences;
    BOOL _allPendingChangesDiscardable;
    SAFARI_FOLDER_CLASS *_topBookmark;
    NSData *_syncServerData;
    id <BookmarkGroupDelegate> _delegate;
    NSString *_filePath;
    NSURL *_davHomeURL;
    NSString *_davBookmarksBarServerID;
    NSString *_davBookmarksMenuServerID;
    long long _cloudKitMigrationState;
    NSData *_cloudKitAccountHash;
}

@property(nonatomic, getter=areAllPendingChangesDiscardable) BOOL allPendingChangesDiscardable; // @synthesize allPendingChangesDiscardable=_allPendingChangesDiscardable;
@property(retain, nonatomic) NSData *cloudKitAccountHash; // @synthesize cloudKitAccountHash=_cloudKitAccountHash;
@property(nonatomic) long long cloudKitMigrationState; // @synthesize cloudKitMigrationState=_cloudKitMigrationState;
@property(nonatomic) BOOL keepsRemovedBookmarkReferences; // @synthesize keepsRemovedBookmarkReferences=_keepsRemovedBookmarkReferences;
@property(nonatomic, getter=isSyncInMergeMode) BOOL syncInMergeMode; // @synthesize syncInMergeMode=_syncInMergeMode;
@property(readonly, nonatomic) NSString *davBookmarksMenuServerID; // @synthesize davBookmarksMenuServerID=_davBookmarksMenuServerID;
@property(readonly, nonatomic) NSString *davBookmarksBarServerID; // @synthesize davBookmarksBarServerID=_davBookmarksBarServerID;
@property(retain, nonatomic, setter=setDAVHomeURL:) NSURL *davHomeURL; // @synthesize davHomeURL=_davHomeURL;
@property(readonly, nonatomic) NSString *filePath; // @synthesize filePath=_filePath;
@property(nonatomic) __weak id <BookmarkGroupDelegate> delegate; // @synthesize delegate=_delegate;
// - (id).cxx_construct;
// - (void).cxx_destruct;
- (void)_sendDelegateMessage:(int)arg1 withModifiedBookmark:(id)arg2 child:(id)arg3 changeWasInteractive:(BOOL)arg4;
- (void)_releaseTouchIconsForBookmark:(id)arg1;
- (void)_retainTouchIconsForBookmark:(id)arg1;
- (void)_initializeURLStringMapWithChildrenOfBookmark:(id)arg1;
- (void)_removeBookmarkFromURLStringMap:(id)arg1;
- (void)_addChildrenOfBookmarkToURLStringMap:(id)arg1;
- (void)_addBookmarkToURLStringMap:(id)arg1;
- (void)bookmarkURLStringDidChange:(id)arg1 changeWasInteractive:(BOOL)arg2;
- (void)bookmarkURLStringWillChange:(id)arg1;
- (id)bookmarksForURLString:(id)arg1;
- (void)endMoveBookmarkBetweenParents:(id)arg1;
- (void)beginMoveBookmarkBetweenParents:(id)arg1;
- (void)endMoveBookmarkWithinParent:(id)arg1;
- (void)beginMoveBookmarkWithinParent:(id)arg1;
- (BOOL)_shouldTrackChangeToBookmark:(id)arg1;
- (BOOL)_shouldRecordChanges;
- (void)_clearChangesPassingTest:(CDUnknownBlockType)arg1;
- (void)endNonInteractiveBatchChangeOfReadingListBookmark:(id)arg1;
- (void)beginNonInteractiveBatchChangeOfReadingListBookmark:(id)arg1;
- (void)bookmark:(id)arg1 changedUUIDFrom:(id)arg2 to:(id)arg3;
- (void)bookmarkDidChange:(id)arg1 changedAttributes:(id)arg2 changeWasInteractive:(BOOL)arg3;
- (void)bookmarkChild:(id)arg1 wasRemovedFromParent:(id)arg2;
- (void)bookmarkChild:(id)arg1 wasAddedToParent:(id)arg2;
- (void)clearAllChanges;
- (void)clearChangesForBookmarkUUID:(id)arg1;
- (void)clearChangesForSyncServerID:(id)arg1;
- (unsigned long long)clearChangesThroughToken:(id)arg1;
- (void)recordChange:(id)arg1;
- (void)_bookmarksWereReloaded;
- (void)_updateDAVAttributesFromSyncData;
- (void)_loadSyncDataFromDictionary:(id)arg1;
- (id)_syncDataAsDictionary;
- (void)bookmark:(id)arg1 changedSyncServerIDFrom:(id)arg2 to:(id)arg3;
- (void)clearDAVSyncState;
- (BOOL)_unsafeUseCloudKitMode;
@property(readonly, nonatomic) BOOL useCloudKitMode;
@property(nonatomic, getter=areFutureChangesDiscardable) BOOL futureChangesDiscardable;
@property(nonatomic, getter=areNotificationsSuppressed) BOOL notificationsSuppressed;
@property(nonatomic, getter=isChangeTrackingSuppressed) BOOL changeTrackingSuppressed;
@property(readonly, copy, nonatomic) NSArray *changes;
@property(copy, nonatomic) NSData *syncServerData; // @synthesize syncServerData=_syncServerData;
- (void)fetchTopBookmarkWithCompletionHandler:(CDUnknownBlockType)arg1;
@property(readonly, nonatomic) SAFARI_FOLDER_CLASS *topBookmark; // @synthesize topBookmark=_topBookmark;
- (id)_insertNewBookmarkAtIndex:(unsigned int)arg1 ofBookmark:(id)arg2 withTitle:(id)arg3 type:(long long)arg4;
- (id)insertBookmarkProxyAtIndex:(unsigned long long)arg1 ofBookmark:(id)arg2 title:(id)arg3;
- (id)insertNewBookmarkListAtIndex:(unsigned long long)arg1 ofBookmark:(id)arg2 withTitle:(id)arg3;
- (id)addNewBookmarkListToBookmark:(id)arg1 withTitle:(id)arg2;
- (void)removeBookmark:(id)arg1;
- (void)addBookmark:(id)arg1;
- (id)bookmarkForSyncServerID:(id)arg1;
- (id)bookmarkForUUID:(id)arg1;
- (void)_clearPendingChanges;
- (void)_removeRedundantPendingChanges;
@property(readonly, nonatomic) BOOL hasUnsavedChanges;
- (int)_saveBookmarkGroupGutsToFilePath:(id)arg1;
- (int)saveToFilePath:(id)arg1;
- (int)save;
- (void)_deduplicateAndRewriteServerIDs;
- (void)_updateSyncDataWithLoadedBookmarks:(id)arg1;
- (BOOL)_updateWithLoadedBookmarks:(id)arg1;
- (void)_readBookmarkGroupGutsFromFileAtURL:(id)arg1;
- (int)_finishLoadingBookmarkGroupGutsOnMainQueueIfNeeded;
- (void)_startLoadingBookmarkGroupGuts;
- (void)_performBlockAfterLoadingBookmarkGroupGuts:(CDUnknownBlockType)arg1;
- (void)_waitForBookmarkGroupGutsToLoad;
- (int)_loadBookmarkGroupGuts;
- (int)load;
- (void)startLoading;
- (id)initWithBookmarkFilePath:(id)arg1;

@end

__attribute__((visibility("hidden")))
@interface _LoadingBookmarkInfo : NSObject
{
    SAFARI_FOLDER_CLASS *_topBookmark;
    NSDictionary *_syncData;
    //  struct SHA256Hash _stateHash;
}

@property(readonly, nonatomic) struct SHA256Hash stateHash; // @synthesize stateHash=_stateHash;
@property(copy, nonatomic) NSDictionary *syncData; // @synthesize syncData=_syncData;
@property(retain, nonatomic) SAFARI_FOLDER_CLASS *topBookmark; // @synthesize topBookmark=_topBookmark;
//- (id).cxx_construct;
//- (void).cxx_destruct;

@end

__attribute__((visibility("hidden")))
@interface WebBookmarkImporter : NSObject
{
    SAFARI_FOLDER_CLASS *_topBookmark;
    NSError *_error;
}

@property(readonly, nonatomic) NSError *error; // @synthesize error=_error;
@property(readonly, nonatomic) SAFARI_FOLDER_CLASS *topBookmark; // @synthesize topBookmark=_topBookmark;
//- (void).cxx_destruct;
- (id)initWithPath:(id)arg1;
- (id)unescapeHTML:(id)arg1;

@end

__attribute__((visibility("hidden")))
@interface WebBookmarkLeaf : WebBookmark
{
    BOOL _shouldReleaseIconForHost;
    NSString *_threadUnsafeUserVisibleURLString;
    BOOL _threadUnsafeShouldNeverFetchMetadata;
    BOOL _threadUnsafeHasUserDefinedPreviewText;
    NSURL *_threadUnsafeImageURL;
    NSString *_threadUnsafePreviewText;
    NSString *_threadUnsafeURLString;
    NSString *_threadUnsafeSiteName;
}

//- (void).cxx_destruct;
- (void)_notifyURLStringDidChangeFrom:(id)arg1 to:(id)arg2;
- (id)_mutableDictionaryRepresentation;
//- (void)_updateStateHash:(struct SHA256 *)arg1;
- (void)setGroup:(id)arg1;
@property(readonly, nonatomic) NSURL *canonicalURL;
@property(readonly, copy, nonatomic) NSString *userVisibleURLString;
@property(copy, nonatomic) NSString *siteName; // @synthesize siteName=_threadUnsafeSiteName;
- (void)setURLString:(id)arg1 changeWasInteractive:(BOOL)arg2;
@property(readonly, copy, nonatomic) NSString *URLString; // @synthesize URLString=_threadUnsafeURLString;
- (long long)bookmarkType;
- (id)icon;
- (id)iconURLString;
- (BOOL)setPreviewText:(id)arg1 ignoringIfExistingIsUserDefined:(BOOL)arg2;
- (void)setUserDefinedPreviewText:(id)arg1;
@property(nonatomic) BOOL hasUserDefinedPreviewText; // @synthesize hasUserDefinedPreviewText=_threadUnsafeHasUserDefinedPreviewText;
- (void)_setPreviewText:(id)arg1 interactive:(BOOL)arg2;
@property(copy, nonatomic) NSString *previewText; // @synthesize previewText=_threadUnsafePreviewText;
@property(retain, nonatomic) NSURL *imageURL; // @synthesize imageURL=_threadUnsafeImageURL;
@property(nonatomic) BOOL shouldNeverFetchMetadata; // @synthesize shouldNeverFetchMetadata=_threadUnsafeShouldNeverFetchMetadata;
- (BOOL)canOpenInTabs;
- (BOOL)isUserVisiblyEqualToBookmark:(id)arg1;
- (BOOL)mergeAttributesFromBookmark:(id)arg1;
- (BOOL)updateByCopyingAttributesFromBookmark:(id)arg1 withExistingBookmarksByUUID:(id)arg2;
- (id)description;
- (id)copyWithZone:(struct _NSZone *)arg1;
//- (id)initWithTopSite:(struct TopSite *)arg1;
- (id)initFromDictionaryRepresentation:(id)arg1 topLevelOnly:(BOOL)arg2 withGroup:(id)arg3;

@end

__attribute__((visibility("hidden")))
@interface SAFARI_FOLDER_CLASS : WebBookmark
{
    NSMutableArray *_threadUnsafeChildren;
    NSCountedSet *_threadUnsafeChildWrappers;
    BOOL _threadUnsafeAutomaticallyOpensInTabs;
}

+ (id)_test_allDescendentsOfBookmarkList:(id)arg1;
+ (id)smallImageForBookmarkList;
//- (void).cxx_destruct;
- (id)test_allDescendents;
- (id)_childrenIncludingFolders:(BOOL)arg1;
//- (void)_updateStateHash:(struct SHA256 *)arg1;
- (id)_mutableDictionaryRepresentation;
- (void)clearDAVSyncState;
- (void)clearAllChangesRecursively;
- (void)updateByCopyingSyncDataFromBookmark:(id)arg1 withChildBookmarksByUUID:(id)arg2;
- (BOOL)mergeAttributesFromBookmark:(id)arg1;
- (BOOL)updateByCopyingAttributesFromBookmark:(id)arg1 withExistingBookmarksByUUID:(id)arg2;
- (void)insertChild:(id)arg1 atIndex:(unsigned long long)arg2;
- (void)removeChild:(id)arg1;
- (void)_enumerateLeafDescendantsOnChildrenAccessQueueUsingBlock:(CDUnknownBlockType)arg1;
- (void)enumerateLeafDescendantsUsingBlock:(CDUnknownBlockType)arg1;
- (void)enumerateChildrenWithOptions:(unsigned long long)arg1 usingBlock:(CDUnknownBlockType)arg2;
- (void)enumerateChildrenUsingBlock:(CDUnknownBlockType)arg1;
- (void)_appendDescendantsPassingTest:(CDUnknownBlockType)arg1 toArray:(id)arg2;
- (void)getDescendantsPassingTest:(CDUnknownBlockType)arg1 completionHandler:(CDUnknownBlockType)arg2;
- (void)getLeafChildrenWithCompletionHandler:(CDUnknownBlockType)arg1;
- (void)getFolderAndLeafChildrenWithCompletionHandler:(CDUnknownBlockType)arg1;
- (unsigned long long)numberOfChildrenMatchingBookmark:(id)arg1;
- (id)firstChildWithURL:(id)arg1;
- (unsigned long long)indexOfChild:(id)arg1;  // **Warning**.  For root, the returned index includes History, so this is offset by 1 from what you probably want.
- (id)childAtIndex:(unsigned long long)arg1;
@property(readonly, copy, nonatomic) NSArray *leafChildren;
@property(readonly, copy, nonatomic) NSArray *folderAndLeafChildren;
- (unsigned long long)numberOfChildren;
- (long long)bookmarkType;
- (id)icon;
- (id)iconURLString;
- (id)initFromDictionaryRepresentation:(id)arg1 topLevelOnly:(BOOL)arg2 withGroup:(id)arg3;
- (BOOL)isUserVisiblyEqualToBookmark:(id)arg1;
- (id)_children;
@property(readonly, nonatomic, getter=isReadingListFolder) BOOL readingListFolder;
- (void)setAutomaticallyOpensInTabs:(BOOL)arg1 changeWasInteractive:(BOOL)arg2;
@property(readonly) BOOL automaticallyOpensInTabs; // @synthesize automaticallyOpensInTabs=_threadUnsafeAutomaticallyOpensInTabs;
- (BOOL)canOpenInTabs;
@property(readonly, nonatomic) unsigned long long numberOfDescendants;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (id)initWithIdentifier:(id)arg1 UUID:(id)arg2 group:(id)arg3;

@end

__attribute__((visibility("hidden")))
@interface WebBookmarkProxy : WebBookmark
{
}

- (id)_mutableDictionaryRepresentation;
- (id)icon;
- (id)iconURLString;
- (long long)bookmarkType;
- (id)initFromDictionaryRepresentation:(id)arg1 topLevelOnly:(BOOL)arg2 withGroup:(id)arg3;

@end



@interface NSDictionary (DiagnosticsExtras)
- (id)safari_filterWithWhitelist:(id)arg1;
@end

@interface NSWorkspace (DiagnosticsExtras)
- (BOOL)safari_isSafariRunning;
@end

@interface NSString (DownloadFileUnarchiver)
- (id)stringByDeletingAllPathExtensions;
@end

@interface NSWindow (ExtendedWindowDelegateSupport)
- (BOOL)willHandleMouseDraggedEvent:(id)arg1;
- (BOOL)willHandleMouseDownEvent:(id)arg1;
- (BOOL)willHandleKeyEvent:(id)arg1;
- (BOOL)willHandleEvent:(id)arg1;
@end

@interface NSDate (FirefoxImportingNSDateExtras)
+ (id)safari_dateWithFirefoxTime:(long long)arg1;
- (long long)safari_firefoxTime;
@end


@interface NSFileManager (SafariNSFileManagerExtras)
- (void)safari_markItemAsUsedAtURL:(id)arg1;
- (id)safari_defaultLocalStorageURLForHomeDirectory:(id)arg1;
- (id)safari_defaultLocalStorageURL;
- (id)_safari_defaultLocalStorageURLForSettingsDirectory:(id)arg1;
- (id)safari_defaultApplicationCacheDirectory;
- (id)safari_defaultWebCacheDirectory;
- (id)safari_defaultWebCacheDirectoryForHomeDirectoryPath:(id)arg1;
- (id)_safari_defaultWebCacheDirectoryForLibraryPath:(id)arg1;
- (BOOL)safari_removeItemAtURL:(id)arg1 getItemSize:(unsigned long long *)arg2;
- (BOOL)safari_removeItemAtURL:(id)arg1 getItemSize:(unsigned long long *)arg2 error:(id *)arg3;
- (unsigned long long)safari_sizeOfItemsInDirectoryAtURL:(id)arg1 includeSubDirectory:(BOOL)arg2;
- (id)safari_URLForProposedURLIfDistinctFileExists:(id)arg1 currentURL:(id)arg2;
- (BOOL)safari_fileExistsAtURLIncludingBrokenSymlink:(id)arg1;
- (id)safari_localCachesDirectoryPreferringHome;
- (id)safari_defaultReadingListArchivesDirectoryForHomeDirectory:(id)arg1;
- (id)safari_defaultReadingListArchivesDirectory;
- (id)_safari_defaultReadingListArchivesDirectoryForSettingsDirectory:(id)arg1;
- (id)safari_roamingCachesDirectory;
- (id)safari_localCachesDirectory;
- (BOOL)safari_moveItemAtURL:(id)arg1 toURL:(id)arg2 allowCopying:(BOOL)arg3 allowOverwriting:(BOOL)arg4;
- (BOOL)safari_isPathOnBootVolume:(id)arg1;
- (id)safari_pathWithUniqueFilenameForPath:(id)arg1;
- (unsigned long long)safari_capacityForDirectory:(id)arg1 withCurrentSize:(unsigned long long)arg2 maxCapacity:(unsigned long long)arg3 maxRatioToAvailableDiskSpace:(double)arg4;
- (id)_quarantineOriginURLForRequestMainDocumentURL:(id)arg1 requestURL:(id)arg2 shouldUseRequestURLAsFallback:(BOOL)arg3;
- (void)safari_setQuarantineInformationForFilePath:(id)arg1 originURL:(id)arg2 dataURL:(id)arg3 shouldSetPrivacySensitiveQuarantineProperties:(BOOL)arg4;
- (void)safari_setQuarantineInformationForFilePath:(id)arg1 downloadRequest:(id)arg2 shouldSetPrivacySensitiveQuarantineProperties:(BOOL)arg3 shouldUseRequestURLAsOriginURLIfNecessary:(BOOL)arg4;
- (void)safari_setQuarantineInformationForFilePath:(id)arg1 downloadRequest:(id)arg2 shouldSetPrivacySensitiveQuarantineProperties:(BOOL)arg3;
- (id)safari_pathForSingleItemAtPath:(id)arg1;
- (BOOL)safari_moveDownloadedFileAtURL:(id)arg1 toURL:(id)arg2;
@end


@interface NSMenu (WebBookmarkNSMenuExtras)
- (id)safari_addMenuItemForBookmark:(id)arg1 withTabPlacementHint:(const struct TabPlacementHint *)arg2 topBookmark:(id)arg3 bookmarksBarCollection:(id)arg4 bookmarksMenuCollection:(id)arg5;
- (void)safari_addMenuItemsForChildrenOfBookmark:(id)arg1 withTabPlacementHint:(const struct TabPlacementHint *)arg2 topBookmark:(id)arg3 bookmarksBarCollection:(id)arg4 bookmarksMenuCollection:(id)arg5;
- (id)safari_recursivelyAddMenuItemsForChildFoldersOfBookmark:(id)arg1 withIndentationLevel:(long long)arg2;
- (id)safari_addMenuItemForBookmarkFolder:(id)arg1;
- (long long)safari_indexOfMenuItemForBookmark:(id)arg1;
@end

#endif /* SafariPrivateFramework_h */
