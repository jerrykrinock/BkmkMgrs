#import "ExtoreLocalPlist.h"

extern NSString* const constKeySafariBookmarksBarIdentifier;
extern NSString* const constKeySafariBookmarksMenuIdentifier;
extern NSString* const constKeySafariReadingListIdentifier;
extern NSString* const constKeySafariImageUrlKey;
extern NSString* const constKeySafariCommentsKey;
extern NSString* const constKeySafariReadingListDic ;
extern NSString* const constKeySafariReadingListNonSyncDic ;
extern NSString* const constKeySafariReadingListIdentifier ;
// Only seen in folders so far, but because of the name I check for it in bookmarks too.
extern NSString* const constKeySafariWebBookmarkIdentifier ;
extern NSString* const constKeySafariUriDictionary ;

extern NSString* const constKeySafariSyncInfo ;
extern NSString* const constKeySafariSync_Item ;
extern NSString* const constKeySafariSync_Root;
extern NSString* const constKeySafariDavChanges;

@class Clientoid ;

/* IxportSubstyleOverwriteFile and IxportSubstyleSendToSheepSafariHelper are,
respectively, the Legacy and Modern-CloudKit "substyles" of Ixport Style 1,
 which is always used for Safari.  Usually, only the former uses Thomas. */
enum IxportSubstyle_enum {
    IxportSubstyleUnknown = -1,
    IxportSubstyleAutomatic = 0,
    IxportSubstyleOverwriteFile = 1, // legacy SafariDAVClient
    IxportSubstyleSendToSheepSafariHelper = 2  // modern CloudKit
};
typedef enum IxportSubstyle_enum IxportSubstyle;

@interface ExtoreSafari : ExtoreLocalPlist {
    short m_hasUnfiledTernary ;
    IxportSubstyle _ixportSubstyle;
    NSInteger _indexOfOffsetForRoot;
}

@property (assign, readonly) IxportSubstyle ixportSubstyle;

/*!
 @brief   Creates a new stark based on the attributes given in a
 given dictionary in Safari's bookmark format, inserted into the
 managed object context of a given starker, and with exid
 opitonally associated with a given clientoid.

 @details  This is implemented as a class method in ExtoreSafari so
 that it is accessible by two routes, (1) when importing, via
 the instance method -starkFromExtoreNode and (2) when a BkmxDoc
 accepts an inter-application drop of items from Safari's Show
 All Bookmarks window.
 @param    dic  The dictionary received from Safari
 @param    starker  The starker which will be invoked to create
 a new stark.&nbsp; Note that this controls which managed object
 context the new stark will be inserted into
 @param    clientoid  Either nil,  or the clientoid which the exid
 read from the dic should be associated.&nbsp; The
 former is used in case (1) described in the method description
 and the latter in case (2).
 @result   The new stark
 */
+ (Stark*)starkFromExtoreNode:(NSDictionary*)dic
                      starker:(Starker*)starker
                    clientoid:(Clientoid*)clientoid ;

/*!
 @brief    Override of base class method which (1) sets the isDeletedThisIxport
 flag in each deleted stark, so that -[SSYTreeTransformer copyDeepTransformOf:]
 will know to not put them in the data generated for the external file and (2)
 generates the "Changes" dictionary for iCloud and adds it to rootAttributes.
 */
- (BOOL)processExportChangesForOperation:(SSYOperation*)operation
                                 error_p:(NSError**)error_p ;

/*!
 @brief    Override of base class method to return NO

 @details  For other clients, the choice of whether to actually delete
 the local starks before or after the actual export depends on whether
 the write style is 1 or 2.  Safari is unique in that it only has one
 export style, which we call Style 1, although it uses a transaction-based
 API like Style 2
 
 However,
 */
- (BOOL)shouldActuallyDeleteBeforeWrite ;

+ (NSString*)fullDiskAccessReport;

+ (BOOL)preflightFileAccessForPath:(NSString*)path
                           error_p:(NSError**)error_p;

+ (BOOL)touchBookmarksPlistError_p:(NSError**)error_p;

@end

/*
 REVERSE-ENGINEERED API CONTRACT FOR SafariDAVClient <--> Safari
 
 *
 Here is my reverse-engineered "API contract" for writing the *Sync.Changes* key in Bookmarks.plist, which is used by SafariDAVClient to push changes into iCloud.
 
 * HOW THIS WAS REVERSE-ENGINEERED
 
 The trick is that when Safari 5.1+ makes changes to the tree in
 Bookmarks.plist, it also writes an array of changes in that file at key path
 *Sync.Changes*.  However, you won't see them in normal operation because
 SafariDAVClient agent will immediately process them and rewrite the file with
 this key path deleted.  To see the changes, you need to temporarily disable
 that agent by unloading it…
 
 $jk launchctl unload /System/Library/LaunchAgents/com.apple.safaridavclient.plist
 
 Then you can make bookmarks changes in Safari, and observe what Safari added
 to *Sync.Changes* in Bookmarks.plist.
 
 If you're using iCloud, remember to reload the agent when you are done by
 running the opposite of the above command…
 
 $jk launchctl load /System/Library/LaunchAgents/com.apple.safaridavclient.plist
 
 
 * GENERAL BEHAVIORS
 
 The 'Changes' property is an array.  Each element is a dictionary, describing
 a "change" of an item.  We call this a Change Dictionary.
 
 Except for identifiers, item property values are *not* expressed in a Change
 Dictionary.  Apparently, the idea of *Sync.Changes* is simply to tell
 SafariDAVClient which items need attention; SafariDAVClient then ferrets out
 the property values it needs from the tree.
 
 Each Change Dictionary has a key for its "Type".  SafariDAVClient recognizes
 three change types: "Add", "Delete" and "Modify".
 
 Moving a bookmark to a new folder is two changes: a Delete, and an Add.  When
 creating the new item from the deleted item, strip off the "Sync" key and also
 give it a new exid/WebBookmarkUUID.
 
 Sliding an item (changing its index without changing its parent) is simply a
 Modify* change of the slid item.  It is not a *Modify* of its parent.
 
 Deleting a folder with descendants is only one change, a "Delete" of the
 root-most folder.   iCloud automatically deletes the descendants.
 
 Adding any items is just one "Add" for each added item.  Adding children to an
 item is not considered to be a *Modify*.
 
 In assembling an array of Change Dictionaries, Deletes should be last.
 
 
 * KEYS IN A CHANGE DICTIONARY
 
 A Change Dictionary may have the following keys.  All values are strings.
 
 *Type*  The type of change.  Value may be *Add*, *Modify* or *Delete*.
 Required in all Change Dictionaries.
 
 *Token*  An arbitrary, new 36-char UUID.  Required in all Change Dictionaries.
 
 *BookmarkType*  Type of the affected item.  May be either "Leaf" or "Folder".
 Required in all Change Dictionaries.
 
 *BookmarkUUID*  The WebBookmarkUUID of the affected item.  If this is part of
 a "Move" operation, this should be a brand new UUID.  Required in all Change
 Dictionaries.
 
 *BookmarkServerID*  ServerID of affected item.  Example:
 $HomeURLString$ServerID_BarOrMenu/…/$ServerID_Parent/$ServerID_AffectedItem.xbel
 Required only in *Modify* or *Delete* Change Dictionaries.  Should be absent
 in *Add* Change Dictionaries.
 
 
 * *SYNC* KEYS IN ITEMS IN THE TREE
 
 Do not worry about these, except that you should delete it in the *Add* Change
 Dictionary which is half of moving a bookmark to a new parent.  New items do
 not have a *Sync* key.  Apparently, *Sync* keys are generated only by
 SafariDAVClient.
 
 */


/* TYPICAL Bookmarks.plist ▸ Root ▸ Sync ▸ SyncData
 
 SyncData is an NSDictionary, not-so-cleverly encoded into an NSData via
 NSPropertyListSerialization.  (Why did they bother??)  Here's a typical
 dictionary you get by decoding the data to get the dictionary:
 
 {
 AccountPrsId = 11062068;
 BookmarkBarId = "https://jerry%40sheepsystems.com@p08-bookmarks.icloud.com/11062068/bookmarks/86AFE69A-3B8C-4465-9511-C65394872AD5/";
 BookmarkMenuId = "https://jerry%40sheepsystems.com@p08-bookmarks.icloud.com/11062068/bookmarks/EB5B1EDE-8CD2-49FA-BD94-A70D324226CD/";
 BulkRequests =     {
 crud =         {
 insert = 1;
 "max-resources" = 200;
 "max-size" = 10485760;
 update = 1;
 };
 simple =         {
 insert = 1;
 "max-resources" = 200;
 "max-size" = 10485760;
 };
 };
 CTag = "FT=-@RU=b4c4e4ec-59c1-4541-abc8-bb4bb29dfc62@S=1571";
 ClientVersion = 1;
 HomeURLString = "https://jerry%40sheepsystems.com@p08-bookmarks.icloud.com/11062068/bookmarks/";
 InitialSyncDone = 1;
 PTag = ServerDoesNotSupportPTags;
 PrincipalURLString = "https://jerry%40sheepsystems.com@p08-bookmarks.icloud.com/11062068/principal/";
 PushKey = 11062068;
 PushTransports =     {
 APSD =         {
 apsbundleid = "com.me.bookmarks";
 env = PRODUCTION;
 "refresh-interval" = 120000;
 "subscription-url" = "https://jerry%40sheepsystems.com@p08-bookmarks.icloud.com/11062068/mm/push/register";
 };
 };
 SupportsSyncCollection = 1;
 SyncToken = "FT=-@RU=b4c4e4ec-59c1-4541-abc8-bb4bb29dfc62@S=1637";
 }
 */


/*
 LOGGING FOR SafariDAVClient
 This gives a fire-hose of information.  I've never found it to be very useful,
 though.

 #Enable
 defaults write com.apple.SafariDAVClient SDAVLogLevel 6
 defaults write com.apple.Safari BookmarkAccessAPILoggingEnabled -bool yes

 #Disable
 defaults delete com.apple.SafariDAVClient SDAVLogLevel
 defaults delete com.apple.Safari BookmarkAccessAPILoggingEnabled
 */


/*
 MISCELLANEOUS NOTES REGARDING MACINTOSH IPC

 /System/Library/PrivateFrameworks/BookmarkDAV.framework/Versions/A/Helpers/SafariDAVClient
 
 DAV = distributed authoring and versioning
 
 "mach services" site:developer.apple.com
 mach_inject
 mach_override
 
 
 About 16:00 into Session 206, "By default, we will throw you into a GCD run
 loop by calling dispatch_main()."  Then, "If you need to integrate with
 NSRunLoop, set "RunLoop"  key in Info.plist to "NSRunLoop", and we will call
 [NSRunLoop run] instead of dispatch_main() to get things moving in your run
 loop.
 
 The kernel starts /sbin/mach_init, the Mach service naming (bootstrap) daemon.
 mach_init maintains mappings between service names and the Mach ports that
 provide access to those services.
 
 This is interesting:
 nm /System/Library/PrivateFrameworks/BookmarkDAV.framework/Versions/A/BookmarkDAV
 
 Very Old IPC APIs:
 mach_msg()
 MIG  Wraps around the mach message system, to make it like a transparent
 function call.  MIG = Mach Interface Generator.  See:
 http://developer.apple.com/library/mac/#documentation/Darwin/Conceptual/KernelProgramming/boundaries/boundaries.html#//apple_ref/doc/uid/TP30000905-CH217-BABDECEG
 
 
 
 Old IPC APIs:
 NSConnection
 NSProxy
 NSPort
 CFMessagePort
 CFMachPort
 
 PID File
 
 Prior to XPC, we did not have automated bootstrapping and structure messaging.
 Also, the object and transport layers were not unified.
 */
