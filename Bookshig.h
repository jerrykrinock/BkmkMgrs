#import <Cocoa/Cocoa.h>
#import "BkmxGlobals.h"
#import "SSYManagedObject.h"
#import "StarkTyper.h"
#import "SSYLicense.h"

@class Ixporter ;
@class Extore ;
@class SSYMojo ;
@class Stark ;
@class Client ;

// Constants (defined in .m)

// Notification Names
extern NSString* const constNoteDupesDone ;
extern NSString* const constNoteDupesMaybeMore ;
extern NSString* const constNoteSortDone ;
extern NSString* const constNoteSortMaybeNot ;
extern NSString* const constNoteVerifyDone ;
extern NSString* const constNoteVerifyMaybeNot ;


// Property names
extern NSString* const constKeyDefaultSortable ;
extern NSString* const constKeyFilterIgnoredPrefixes ;
extern NSString* const constKeyImportCount ;
extern NSString* const constKeyIgnoreDisparateDupes ;
extern NSString* const constKeyLastDupesDone ;
extern NSString* const constKeyLastDupesMaybeLess ;
extern NSString* const constKeyLastDupesMaybeMore ;
extern NSString* const constKeyLastIxportSerial ;
extern NSString* const constKeyLastSortDone ;
extern NSString* const constKeyLastSortMaybeNot ;
extern NSString* const constKeyLastTouched ;
extern NSString* const constKeyLastVerifyDone ;
extern NSString* const constKeyLastVerifyMaybeNot ;
extern NSString* const constKeyNotes ;
extern NSString* const constKeyLanding ;
extern NSString* const constKeyRootLeavesOk ;
extern NSString* const constKeyRootNotchesOk ;
extern NSString* const constKeyRootSoftainersOk ;
extern NSString* const constKeyRootSortable ;
extern NSString* const constKeySortBy ;
extern NSString* const constKeySortingSegmentation ;
extern NSString* const constKeyTagDelimiter ;
// constKeyVisitor is declared in BkmxGlobals.h because it is also a Stark attribute.


/*!
 @brief    A managed object which stores the configuration settings of a BkmxDoc
 The name is a contraction of "BkmxDoc Configuration".
 
 @details  One, and only one of these, is inserted into a new BkmxDoc when
 it is initially created.
 */
@interface Bookshig : SSYManagedObject {
	BOOL m_ixportDoneDummyForKVO ;
	BOOL m_userIsFussingWithClients ;
}

extern NSString* const constKeyTagDelimiterActual ;

#pragma mark * Accessors for non-managed object properties

@property BOOL ixportDoneDummyForKVO ;
@property BOOL userIsFussingWithClients ;

#pragma mark * Core Data Generated Accessors for managed properties

// Attributes

/*!
 @brief    A number indicating how starks in the receiver's document
 whose sortable attribute is BkmxSortableAsDefault should be sortable;
 the default value of sortable for starks in the receiver's document.
 
 @details  The value of the number should be an integer, one of the
 BkmxSortable values.
 */
@property (retain) NSNumber* defaultSortable ;

/*!
 @brief    Indicates whether or not ignored prefixes should
 be filtered when sorting the items in the receiver.
 */
@property (retain) NSNumber* filterIgnoredPrefixes ;

/*!
 @brief    Indicates whether or duplicate pairs in
 different collections should be detected when finding duplicates
 in the receiver.
 
 @details  The value of the number should be a BOOL, YES or NO.
 */
@property (retain) NSNumber* ignoreDisparateDupes ;


@property (retain) NSNumber* importCount ;


/*!
 @brief    A number indicating whether or not the root item of the
 receiver is sortable
 
 @details  The value value should be one of the BkmxSortable values,
 except not BkmxSortableAsParent since root does not have a parent.
 */
@property (retain) NSNumber* rootSortable ;

/*!
 @brief    The last date/time that findDupes: completed execution in the 
 BkmxDoc whose managed object context the receiver is inserted into.
 */
@property (retain) NSDate* lastDupesDone ;

/*!
 @brief    The last date/time that an action occurred which could
 cause a subsequent execution of findDupes: to find fewer dupes than
 the previous execution did.
 */
@property (retain) NSDate* lastDupesMaybeLess ;

/*!
 @brief    The last date/time that an action occurred which could
 cause a subsequent execution of findDupes: to find more dupes than
 the previous execution did.
 */
@property (retain) NSDate* lastDupesMaybeMore ;

/*!
 @brief    The last date/time that sort: completed execution in the 
 BkmxDoc whose managed object context the receiver is inserted into.
 */
@property (retain) NSDate* lastSortDone ;

/*!
 @brief    The last date/time that an action occurred which would
 cause a subsequent execution of sort: to have move any items.
 */
@property (retain) NSDate* lastSortMaybeNot ;

/*!
 @brief    The last date/time that any change was made to the content (starks)
 in the receiver's document.
 */
@property (retain) NSDate* lastTouched ;

/*!
 @brief    The last date/time that a 'verify' completed execution in the 
 BkmxDoc whose managed object context the receiver is inserted into.
 */
@property (retain) NSDate* lastVerifyDone ;

/*!
 @brief    The last date/time that an action occurred which would
 change the distribution between automatically-fixed/fixable
 and manually-fixable bookmarks.
 */
@property (retain) NSDate* lastVerifyMaybeNot ;

/*!
 @brief    The container in which new bookmarks land when created
 by -landNewBookmarkSaveWithInfo:.
 */
@property (retain) Stark* landing ;

/*!
 @brief    A user-defined string describing the receiver, stored in
 its metadata.&nbsp; Note: Not a managed object.
 */
@property (copy) NSString* notes ;

/*!
 @brief    An number BOOL indicating whether or not the receiver
 accepts starks matching coarse type SharypeCoarseLeaf in its root
 */
@property (retain) NSNumber* rootLeavesOk ;

/*!
 @brief    An number BOOL indicating whether or not the receiver
 accepts starks matching coarse type SharypeCoarseSoftainer in its root
 */
@property (retain) NSNumber* rootSoftainersOk ;

/*!
 @brief    An number BOOL indicating whether or not the receiver
 accepts starks matching coarse type SharypeCoarseNotch in its root
 */
@property (retain) NSNumber* rootNotchesOk ;

/*!
 @brief    A number indicating which attribute to sort items by
 in the owning BkmxDoc.
 
 @details  The value of the number should be an integer, one of the
 BkmxSortBy values.
 */
@property (retain) NSNumber* sortBy ;

/*!
 @brief    A number indicating where folders should be sorted with
 respect to bookmarks in the receiver.
 
 @details  The value of the number should be an integer, one of the
 BkmxSortingSegmentation values.
 */
@property (retain) NSNumber* sortingSegmentation ;

/* Methods derived from sortingSegmentation */
@property (assign) NSInteger segmentConfiguration;
@property (assign) NSInteger sortWhichSegments;

/*!
 @brief    A string used to delimit the receiver's tags when the
 user types into token fields.
 
 @details  If this string is found in a receiver's stark's tag,
 it will be converted to an underscore.
 */
@property (copy) NSNumber* tagDelimiter ;

/*!
 @brief    A unique identifier for the receiver's document, used
 to associate with Exids, Settings.  This is no longer used and as of
 BkmkMgrs 12.9.21 is moved to auxiliary data.  That is why it is now marked
 as readonly – it is only used to upgrade legacy documents.
 */
@property (readonly) NSString* uuid ;

/*!
 @brief    The bundle identifier of the web browser which the user
 prefers to use when visiting a bookmark.
 
 @details  A nil value indicates to use the user's default web browser.
 */
@property (copy) NSString* visitor ;


// Relationships


#pragma mark * Shallow Value-Added Getters

/*!
 @brief    Logical AND of rootLeavesOk && rootSoftainersOk &&
 rootNotchesOk.
 */
- (BOOL)rootCanTakeAnySharype ;

 /*!
 @brief    Returns the value of the receiver's sortBy attribute
 */
- (BkmxSortBy)sortByValue ;

/*!
 @brief    Returns whether or not the receiver has observed an action
 which might change the actual dupes since the last time dupes were
 analyzed for.
 */
- (BOOL)dupesMaybeMore ;

/*!
 @brief    Configures the receiver's structure attributes for the current
 clients, as much as can be done without changing the receiver's
 bkmxDoc's content.
 
 @details   Prior to BookMacster 1.1.9, I invoked this method in
 -[Macster macsterTouchNote:], if
 [noteName isEqualToString:constNoteBkmxClientDidChange].
 However that caused too many extraneous changes.
 In particular:  Say a BkmxDoc has a single Client A
 which is not the user's default browser.  Then this BkmxDoc is
 opened on another Mac via Dropbox or similar syncing.  Initially
 it has no clients there.  So user clicks the "+" button to add a
 client, which is immediately the user's default browser, Client B.
 -[Macster macsterTouchNote:] will invoke this method, and
 restructuring will occur, which will dirty the document and also
 put a notice in the status bar which the  user will head-scratch
 over.  Then the user clicks the desired Client A.  Now
 -[Macster macsterTouchNote:] will invoke this method
 again, restructuring occurs again,
 probably back to the original structure.  User sees another
 head-scratching message in status bar, and document is dirty
 when in fact it was changed back to original state.  When the
 user saves it, Dropbox may (or maybe not, if no bits were
 changed – not sure how Dropbox will handle this) sync
 the unchanged "changed" document back to the first Mac,
 creating unnecessary network traffic and possibly further
 consternation to the user.
 
 So instead, this method is now invoked in -[BkmxDocWinCon tabView:shouldSelectTabViewItem:]
 and also in -[BkmxDocWinCon windowShouldClose].
 
 @result   YES if any attributes were changed.
 */
- (BOOL)configureStructureForClients ;

- (BOOL)userDidEndFussingWithClients ;

- (void)configurePreferredCatchype ;

#pragma mark * Other Methods

- (void)setNewBookmarkLandingFromMenuItem:(NSMenuItem*)sender ;

@end


