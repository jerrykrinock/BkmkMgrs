#import "BkmxGlobals.h"
#import "SSYManagedObject.h"
#import "StarkTyper.h"
#import "SSYManagedTreeObject.h"

@protocol Hartainertainer ;
@protocol StarkReplicator ;
@protocol Startainer ;

@class StarkLocation ;
@class Client ;
@class Clientoid ;
@class BkmxDoc ;
@class Dupe ;
@class Extore ;
@class SSYProgressView ;
@class Tag;

#if 0
#warning Logging Stark deallocs with LOGGING_STARK_DEALLOCATION
#define LOGGING_STARK_DEALLOCATION 1
#else
#define LOGGING_STARK_DEALLOCATION 0
#endif

#if 0
#warning Verifying hashes with immediate loopback
#define VERIFY_HASH_WITH_IMMEDIATE_LOOPBACK 1
#endif

#define DONT_SET_THE_INDEX (NSNotFound - 4)

extern NSString* const constKeyDonkey ;
extern NSString* const constKeyFoldersDeletedDuringConsolidation;

@interface NSArray (BookMacstrifyTags)

/*!
 @brief    Coalesces duplicate tags for case insensitity, then
 sorts with localizedCaseInsensitiveCompare:

 @details  This was added in BookMacster 1.11.  See Note 432897.
*/
- (NSArray*)bookMacstrifiedTags ;

@end

/*!
 @brief    A Stored Bookmark Managed Object

 @details  May be a Collection, Folder, Bookmark or Separator
*/
__attribute__((visibility("default"))) @interface Stark : SSYManagedTreeObject {
    NSInteger ixportFlags ;
    NSMutableArray* childrenTemp ;
    NSDictionary* m_exids ;
    NSNumber* m_sponsorIndex ;
    NSNumber* m_sponsoredIndex ;
    Stark* m_oldParent ;
    NSArray* m_oldChildrenExids;
    NSMutableDictionary* m_ownerValues ;
    NSInteger m_donkey ;
    BOOL m_isExpanded ;  // only used if instance is in an Extore
    
    
#if LOGGING_STARK_DEALLOCATION
    // Stash owner and name in ivars (when available) so that a stark can be
    // identified after it has been faulted
    NSString* m_debugOwnerString ;
    NSString* m_debugName ;
#endif
}

+ (NSSet*)attributesYouDontWantInHash ;

+ (NSArray*)immediateBookmarksInHartainers:(NSArray*)hartainers
                               softFolders:(NSArray*)softFolders
                                 bookmarks:(NSArray*)bookmarks ;


+ (Class)collectionClassForAttribute:(NSString*)attribute ;

/*!
 @brief    Returns an sorted array of all of the receiving class's
 attribute values which should be used when calculating a hash
 representing the attributes seen by the user.
 
 @details  The returned array is sorted and stored in a static
 variable, so that this is fast, and will give identical results in
 distinct application runs.
 */
+ (NSArray*)hashableAttributes ;

#pragma mark * Accessors for Non-Managed Properties


// I considered making these transient properties, but because Core Data
// cannot store an object or even an objectID as an attribute, I'd have to
// do this via -[NSManagedObjectID URIRepresentation] and then
// -[NSPersistentStoreCoordinator managedObjectIDForURIRepresentation:],
// which would take extra code and probably be more expensive to run.

/*!
 @brief    Used during ixporting, so that a child whose correctParent
 has been set during a multiple ixport operation will not be incorrectly re-set
 during subsequent ixporting from later sources. */
- (BOOL)correctParentHasMe ;

/*!
 @brief    Setter for correctParentHasMe
 @details  See -correctParentHasMe
 */
- (void)setCorrectParentHasMe:(BOOL)value ;

- (NSInteger)ixportingIndex ;

/*!
 @details  Does not clear any existing bits.  Assumes that either 
 this message has never been sent to the receiver before, or else
 -clearIxportFlags or -clearIxportingIndex has recently been sent.
*/
- (void)setIxportingIndex:(NSInteger)index ;

- (void)clearIxportingIndex ;

/*!
 @brief    Used during ixporting, so that a folder which is childless
 before the process begins can be so marked, so that it will not be
 deleted at the end because it became childless. */
- (BOOL)isUpdatedThisIxport ;

/*!
 @brief    Setter for isUpdatedThisIxport
 @details  See -isUpdatedThisIxport
 */
- (void)setIsUpdatedThisIxport ;

/*!
 @brief    A very very transient BOOL which, when set to YES, tells
 during ixport that this item was found in the current source
 and that the Merging Keep option says to favor the source.
 */
- (BOOL)shouldMirrorSourceMate ;

/*!
 @brief    Sets the -shouldMirrorSourceMate attribute to YES.
 */
- (void)setShouldMirrorSourceMate ;

/*!
 @brief    A very very transient BOOL which, when set to YES, tells
 during ixport that this is a new item from the current client.
 */
- (BOOL)isNewItemThisClient ;

- (BOOL)isNewItemThisIxport ;

/*!
 @brief    Sets the -isDeletedThisIxport attribute to YES.
 */
- (void)setIsDeletedThisIxport ;

/*!
 @brief    A very transient BOOL which, when set to YES, tells
 during ixport that this item has been deleted,
 although it may not really deleted in the Core Data sense yet.
 */
- (BOOL)isDeletedThisIxport ;

/*!
 @brief    Clears the -shouldMirrorSourceMate and -isNewItemThisClient settings
 */
- (void)clearThisClientFlags ;

/*!
 @brief    Setter for isNewItem
 @details  See -isNewItem
 */
- (void)setIsNewItem ;

- (void)clearIxportFlags ;

/*!
 @brief    Used during ixporting, as childen are removed, added, and
 possibly re-added, so that as changes are coalesced -- not copied to
 actual 'children' until the last source has been ixported, and we
 make sure that we didn't in fact end up back where we started. 
*/
@property (retain) NSMutableArray* childrenTemp ;

/*!
 @brief    An dumb-ass integer which can be used for hauling things
 around temporarily
 
 @details  The protocol is to set it back to 0 when you are done with it.
 */
@property (assign) NSInteger donkey ;

/*!
 @brief    Value of a single exid string, used only if the receiver
 is in a local moc.
 
 @details  If the receiver is in a trans moc or bkmxDoc moc, there may
 be more than one exid, and they are stored instead, nonpersistently,
 in the dictionary ivar 'exids'.  Persistent storage of 'exids' for
 bkmxDoc starks is in a Starxid entity in the document's store file
 named Exids-docUUID.sqlite store in Application Support.
 */
@property (assign) NSString* exid ;

/*!
 @brief    Dictionary to store client private/proprietary values,
 for Starks owned by extore.
 
 @details  This dictionary is setted during -readExternal and
 getted during the -write methods.  Therefore it is only of use
 during Export operations.  During Import operations, these
 values are setted but never getted.
*/
@property (copy) NSDictionary* ownerValues ;

#pragma mark * Core Data Generated Accessors for managed properties

// Attributes
@property (retain) NSDate* addDate ;
@property (retain) NSColor* color ;
@property (retain) NSString* comments ;
/*!
 @brief    A dictionary of the receiver's external store identifiers
 (exids). 

 @details    Each key is a clientoid (client identifier).  Most starks,
 being read in from a single client, will have only one entry in this
 dictionary.
*/
@property (retain) NSDictionary* exids ; 
@property (retain) NSData* favicon ;  
@property (retain) NSString* faviconUrl ;
// property 'index' is declared in superclass
// property 'donkey' is declared in superclass
@property (retain) NSNumber* isAllowedDupe ;
@property (retain) NSNumber* isAutoTab ; // Bool. Safari; folders only
@property (retain) NSNumber* isExpanded ; // Opera, folders only

/*!
 @brief    The receiver's exid's keys, joined into a space-separated string
 */
@property (retain, readonly) NSString* clients ;

@property (retain) NSNumber* dontVerify ;
@property (retain) NSArray* dontExportExformats ;
@property (retain) NSNumber* isShared ; // bool, bookmarks only.
@property (retain) NSNumber* toRead ; // bool, bookmarks only.
@property (retain) NSNumber* sortable ; // integer, see BkmxSortable enum
@property (retain) NSDate* lastChengDate ; // OmniWeb, both bookmarks and folders.  Last date checked for changes.
@property (retain) NSDate* lastModifiedDate ; // Firefox, both bookmarks and folders.  Note: OmniWeb has a 'last-modified' attribute inside of its "validator" tag for RSS items, but I keep these separate.
@property (retain) NSDate* lastVisitedDate ;  // OmniWeb ; bookamrks only
@property (copy) NSString* name ;  // unlike Bookdog's BmItem, this may return nil.  Use -nameNoNil
@property (retain) NSNumber* rating ;
/*!
 @brief    The receiver's rssArticles, as a transformed array of dictionaries
 containing the attributes of each rss article.

 @details  The setter is custom.
 
 Setter customizations.    For each stark in the given array, the setter appends a
 dictionary to the receiver's rssArticles array, and finally deletes each stark in the
 given array from the receiver's managed object context.
 */
@property (retain) NSArray* rssArticles ; 
/*!
 @brief    A unique identifier string assigned by the user.

 @details  Different extores use different names for this attribute:
 Camino: Shortcut
 Firefox: Keyword
 Magnolia: Short Name
 OmniWeb: Keyword
 Vivaldi: Nickname
*/
@property (retain) NSString* shortcut ;

@property (retain) NSNumber* sharype ;

/*
 @details   sharypeCoarse is derived from sharype.
*/
@property (readonly) NSNumber* sharypeCoarse ;

@property (retain) NSNumber* sortDirective ;

/*!
 @brief    A number used during importing and exporting to indicate
 which client a stark came from.
*/
@property (copy) NSNumber* sponsorIndex ;

/*!
 @brief    The index that the receiver's mate had within it's
 mate's parent in its sponsor, or the receiver's regular -indexValue
 if there is no sponsor (sponsorIndex value == -1).
 */
@property (copy) NSNumber* sponsoredIndex ;

@property (retain) Stark* oldParent ;
@property (copy) NSArray* oldChildrenExids; // Not needed unless we cullRedundantSlides

/*!
 @brief    A unique identifier (uuid) string of the receiver. 
 
 @details    We  could have used Core Data's objectID instead of this
 if they weren't temporary for unsaved managed objects.  Arghhhh.
 */
@property (retain) NSString* starkid ;

/*!
 @brief    The receiver's tags, as set in Firefox, del.icio.us, etc.

 @details  tags must be unique.  If you setTags: including duplicates,
 duplicates will be discarded.
 Reasons why tags is an array instead of a set:
 *  Transformerless binding to an NSTokenField
 *  Possibility that user(s) may expect tags order to be preserved.  (Not
 a good reason starting with BookMacster 1.12 or so because tags are now
 displayed in alphanumeric order)
 *  At least one other reason which I forgot right now.
*/
@property (retain) NSArray<Tag*>* tags ;

/*!
 @brief    Like -setTags:, except bypasses bookmacstrify tags, so
 that duplicates are not eliminated and sorting is skipped

 @details  Used for special purposes
*/
- (void)setRawTags:(NSArray*)newTags ;

- (BOOL)separatorify;

/*!
 @brief    The receiver's tags, joined into a space-separated string
 */
@property (retain, readonly) NSString* tagsString ;

/*!
 @brief    The web site address of the receiver.  May be nil.

 @details  The getter is standard but a custom setter which first
 normalizes (canonicalizes) the given value before setting it.
 Note that the getter may return nil.
 */
@property (copy) NSString* url ;

@property (copy) NSString* urlOrStats ;

@property (copy) NSNumber* verifierCode ;  // HTTP status, or other error
@property (copy) NSNumber* verifierSubtype302 ;
@property (retain) NSDictionary* verifierDetails ;
@property (copy) NSNumber* verifierDisposition ;
@property (copy) NSDate* verifierLastDate ;
@property (copy) NSNumber* visitCount ; // OmniWeb, Camino, bookmarks only

// Relationships
@property (retain) Dupe* dupe ;

#pragma mark * Accessors for Owner Values (Extore-owned Starks only)

/*!
 @brief    Gets owner value for a given key
 @param    key  The key for which the value is desired
 @result   The receiver's owner value for the passed key,
 which may be nil
 */
- (id)ownerValueForKey:(id)key  ;

/*!
 @brief    Sets or removes a key/value pair in the receiver's owner values

 @param    value  The value to be set.   May be nil to remove the value from the 
 dictionary
 @param    key  The key for the value to be set
 */
- (void)setOwnerValue:(id)value
               forKey:(id)key ;


#pragma mark * Accessors for Sub-Attribs Stored in Dics

/*!
 @brief    Returns the receiver's verifierAdviceArray

 @details  This attribute is stored as a dictionary value in the
 verifierDetails managed object, a transformable attribute.
 */
- (NSArray*)verifierAdviceArray ; 

/*!
 @brief    Sets the receiver's verifierAdviceArray

 @details  This attribute is stored as a dictionary value in the
 verifierDetails managed object, a transformable attribute.
 @param    value  The value to be set.  May be nil to remove
 the key from the receiver's verifierDetails dictionary.
 */
- (void)setVerifierAdviceArray:(NSString*)value ; 

/*!
 @brief    Returns human-readable verifier advice,
 formatted onto a single line suitable for display in a table.
 
 @details  This is computed on the fly from verifierAdviceArray.
*/
- (NSString*)verifierAdviceOneLiner ;

/*!
 @brief    Returns human-readable verifier advice,
 formatted onto multiple lines suitable for display in a tooltip.
 
 @details  This is computed on the fly from verifierAdviceArray.
 */
- (NSString*)verifierAdviceMultiLiner ;
    
/*!
 @brief    Either "The website says:" or "Your Mac Says:".
 
 @details  This is computed on the fly.
 */
- (NSString*)verifierByline ;

/*!
 @brief    Returns the receiver's verifierCodeUsingHttps
 
 @details  This attribute is stored as a dictionary value in the
 verifierDetails managed object, a transformable attribute.
 */
- (NSNumber*)verifierCodeUsingHttps ;

/*!
 @brief    Sets the receiver's verifierCodeUsingHttps
 
 @details  This attribute is stored as a dictionary value in the
 verifierDetails managed object, a transformable attribute.
 @param    value  The value to be set.  May be nil to remove
 the key from the receiver's verifierDetails dictionary.
 */
- (void)setVerifierCodeUsingHttps:(NSNumber*)value ;

/*!
 @brief    Returns the receiver's last Verify results:
 Code, Reason and Date, formatted into a readable and localized
 string.
 */
- (NSString*)verifierLastResult ; 

/*!
 @brief    Returns the receiver's verifierNSErrorDomain

 @details  This attribute is stored as a dictionary value in the
 verifierDetails managed object, a transformable attribute.
 */
- (NSString*)verifierNSErrorDomain ; 

/*!
 @brief    Sets the receiver's verifierNSErrorDomain

 @details  This attribute is stored as a dictionary value in the
 verifierDetails managed object, a transformable attribute.
 @param    value  The value to be set.  May be nil to remove
 the key from the receiver's verifierDetails dictionary.
 */
- (void)setVerifierNSErrorDomain:(NSString*)value ; 

/*!
 @brief    Returns the receiver's verifierPriorUrl

 @details  This attribute is stored as a dictionary value in the
 verifierDetails managed object, a transformable attribute.
 */
- (NSString*)verifierPriorUrl ;

/*!
 @brief    Sets the receiver's verifierPriorUrl

 @details  This attribute is stored as a dictionary value in the
 verifierDetails managed object, a transformable attribute.
 @param    value  The value to be set.  May be nil to remove
 the key from the receiver's verifierDetails dictionary.
 */
- (void)setVerifierPriorUrl:(NSString*)value ; 

/*!
 @brief    Returns the receiver's verifierReason

 @details  This attribute is stored as a dictionary value in the
 verifierDetails managed object, a transformable attribute.
 */
- (NSString*)verifierReason ;

/*!
 @brief    Sets the receiver's verifierReason

 @details  This attribute is stored as a dictionary value in the
 verifierDetails managed object, a transformable attribute.
 @param    value  The value to be set.  May be nil to remove
 the key from the dictionary.
 */
- (void)setVerifierReason:(NSString*)value ; 

/*!
 @brief    Returns the receiver's verifierSuggestedUrl

 @details  This attribute is stored as a dictionary value in the
 verifierDetails managed object, a transformable attribute.
 */
- (NSString*)verifierSuggestedUrl ;

/*!
 @brief    Sets the receiver's verifierSuggestedUrl

 @details  This attribute is stored as a dictionary value in the
 verifierDetails managed object, a transformable attribute.
 @param    value  The value to be set.  May be nil to remove
 the key from the receiver's verifierDetails dictionary.
 */
- (void)setVerifierSuggestedUrl:(NSString*)value ;

/*!
 @brief    Returns the receiver's verifierUrl, which is the
 value of the url that was used during the last Verify operation.
 
 @details  This attribute is stored as a dictionary value in the
 verifierDetails managed object, a transformable attribute.
 */
- (NSString*)verifierUrl ;

/*!
 @brief    Sets the receiver's verifierUrl, which is the
 value of the url that was used during the last Verify operation.
 
 @details  This attribute is stored as a dictionary value in the
 verifierDetails managed object, a transformable attribute.
 @param    value  The value to be set.  May be nil to remove
 the key from the receiver's verifierDetails dictionary.
 */
- (void)setVerifierUrl:(NSString*)value ;

@property (copy) NSString* visitor ;

@property (copy) NSString* visitorWindowFrame ;


#pragma mark * Exid Accessors

/*!
 @brief    Returns the receiver's exid for a given clientoid, or
 nil if none exists.
 */
- (NSString*)exidForClientoid:(Clientoid*)clientoid ;

/*!
 @brief    Attempts to set a new and different exid (in the transient
 'exids' dictionary) for a stark which is unique in a given extore
 
 @details  This method should only be invoked if the receiver
 is in a transMoc or bkmxDocMoc, because it sets the non-persistent
 'exids' instead of the persistent 'exid' used in local mocs.

 If such an exid cannot be obtained, will set the exid
 in the receiver for the given client signature to nil.
 @param    clientoid  The client signature for which the new
 exid or nil will be set
 @param    extore  The extore which will be called upon to generate
 the new exid
 @param    tryHard  If getting a fresh exid would be costly,
 such as having to contact a remote server, tryHard tells the method
 whether or not to do that.
 */
- (void)setFreshExidForClientoid:(Clientoid*)clientoid
                          extore:(Extore*)extore
                         tryHard:(BOOL)tryHard;

/*!
 @brief    Same as setFreshExidForClientoid:extore:tryHard:
 except sets result into the persistent singular 'exid'.
 
 @details  This method should only be invoked if the receiver
 is in a localMoc.
 */
 - (void)setFreshExidForExtore:(Extore*)extore
                      tryHard:(BOOL)tryHard;

/*!
 @brief    A wrapper around -exidForClientoid: which will examine
 the exid, validate it and create a new one if it is not valid
 or does not exist, and set it into the receiver.
 
 @details  This method should only be invoked if the receiver
 is in a transMoc or bkmxDocMoc, because it sets the non-persistent
 'exids' instead of the persistent 'exid' used in local mocs.
 
 If the existing exid is invalid, and a valid one cannot be
 obtained, sets the receiver's exid for this client signature to nil
 and returns nil in *exid_p.
 
 The tryHard param only made a difference for Google
 Bookmarks.  I suppose therefore it is no longer needed
 @param    exid_p  On return, will point to the valid exid or nil.
 @param    extore  The extore which must validate the exid, provide
 the new exid of needed, and whose client signature is used to 
 identify the relevant exid in the receiver.
 @param    isAfterExport  Advises if this is before or after an
 export, which matters when validating exid to some clients (Shiira).
 @param    tryHard  Controls whether or not to visit the web service
 in an attempt to get the exid if the receiver does 
 not have one.
 */
- (void)getOrMakeValidExid_p:(NSString**)exid_p
                      extore:(Extore*)extore
               isAfterExport:(BOOL)isAfterExport
                     tryHard:(BOOL)tryHard;

/*!
 @brief    Sets the receiver's exid associated with a given clientoid
 
 @details  This is necessary because each external store will
 assign its own identifier (exid) to its items.  If
 exid parameter is nil, removes exid for the given clientoid.
 */
- (void)setExid:(NSString*)exid
   forClientoid:(Clientoid*)clientoid ;

#pragma mark * Shallow Value-Added Getters 

/*!
 @brief    Examines the uuid and url of the receiver, returning
 whether or not it appears to be a 1Password bookmarklet.
*/
- (BOOL)is1PasswordBookmarklet ;

- (NSString*)textSummaryWithTemplate:(NSString*)aTemplate ;

/*!
 @brief    Returns a list consisting of a URIRepresentation of the
 receiver's objectID, followed by a list of each clientoid for which
 the receiver has an exid, and that exid.
*/
- (NSString*)identifiersList ;

/*!
 @brief    Returns whether or not the receiver should be sorted by
 looking at, first its 'sortable' attribute, and if necessary, that of
 its parent, or if necessary, the defaultSortable attribute of it's
 owner's shig.
 */
- (BOOL)shouldSort ;

- (NSString*)nameNoNil ;

- (NSString*)urlNoNil ;

- (Sharype)sharypeCoarseValue ;

- (Sharype)sharypeValue ;

- (BOOL)isAStark ;

- (BOOL)isHartainer ;

- (BOOL)isBookmacsterizer ;

- (BOOL)isRoot ;

- (BOOL)isInBar ;

- (BOOL)isInMenu ;

- (BOOL)isInOhared ;

- (BOOL)canAdoptChild:(Stark*)item ;

- (NSArray*)subfoldersOrdered ;

- (NSInteger)numberOfSubfolders ;

- (NSInteger)numberOfBookmarks ;

- (NSInteger)indexOfStarkWithSameUrlInArray:(NSArray*)array ;

- (Stark*)starkWithSameUrlInArray:(NSArray*)array ;

- (Stark*)firstChildOfSharype:(Sharype)sharype ;

- (short)verifierCodeValue ;

- (void)setVerifierCodeValue:(short)newValue ;

- (short)verifierCodeUsingHttpsValue ;

- (void)setVerifierCodeUsingHttpsValue:(short)newValue ;

- (BkmxFixDispo)verifierDispositionValue ;

- (void)setVerifierDispositionValue:(BkmxFixDispo)newValue ;

- (StarkLocation*)location ;

/*!
 @brief    Returns a StarkLocation which is one row "up" in
 the outline view in a main window currently displaying the receiver.
 
 @details  The receiver's owner must respond to -bkmxDocWinCon
 with a BkmxDocWinCon or an exception will be raised if an
 undefined selector is invoked.
 */
- (StarkLocation*)locationUp1 ;

/*!
 @brief    Returns a StarkLocation which is one row "down" in
 the outline view in a main window currently displaying the receiver.

 @details  The receiver's owner must respond to -bkmxDocWinCon
 with a BkmxDocWinCon or an exception will be raised if an
 undefined selector is invoked.
 */
- (StarkLocation*)locationDown1 ;

- (NSString*)describeIxportingIndexes ;

- (NSString*)nameAndUrl ;

#pragma mark * Shallow Value-Added Setters 

/*!
 @brief    Given a string, dds a new tag to the receiver,'s tags array
 */
- (void)addTagString:(NSString*)string;

- (void)setSharypeValue:(Sharype)value ;

/*!
 @brief    Sets the value of the attribute sortDirective
*/
- (void)setSortDirectiveValue:(BkmxSortDirective)newValue ;

/*!
 @brief    Gets the value of the attribute sortDirective
 */
- (BkmxSortDirective)sortDirectiveValue ;

/*!
 @brief    Enumerates through given attributes of another stark and sets
 a given set of corresponding attributes in the receiver to be the same,
 including nil values
 
 @details  'tags' are one exception. Whether or 'not' tags are overwritten,
 merged or ignored depends on the mergeTags parameter and not whether or
 not 'tags' is in the overwritees parameter.
 
 APPROPRIATE COPYING OF exid/exids
 
 Another exception is 'exid'/'exids'.  This method always makes an appropriate
 copy involving 'exid' and/or 'exids', depending on the type of moc of
 the source and destin.  (Destin is self).  The logic is based on the fact
 that a stark in a local moc will have only 'exid' but not 'exids', but a
 stark in a trans moc or bkmxDoc moc will have only 'exids' but not 'exid'…
 
 *  Case  source  destin  |  copy required
 *  ----  ------  ------  |  -----------------
 *   1    local   local   |  exid to exid
 *   2    local   bk/tr   |  exid to exids, in key indicated by source's extore
 *   3    bk/tr   local   |  exids to exid, from key indicated by destin's extore
 *   4    bk/tr   bk/tr   |  exids to exids; adding new, keeping old, updating conflicts
 
 bk/tr = moc is either bkmxDoc or trans
 local = moc is local
 
 In cases 2 and 4 above, existing keys in exids are overwritten.
 In case 4 above, any key existing in destin not in source is removed.
 
 This method is used for trans to local (Case 3) in twp places:
 * -[ExtoreGoogle doNextOutputInfo:]
 * -[ExtoreHttp doNextOutputInfo:] (Pinboard)
 and it is used for trans to bkmxDoc or bkmxDoc to trans (both Case 4) in:
 * -[Ixporter mergeFromStartainer::::]
 Finally, it is used when necessary to clone a stark into a different
 moc, in -[Stark moveToBkmxParent::] via -[Stark moveToOtherMoc:]
 
 @param    overwritees  The array of attributes to be affected.  Attributes
 will be overwritten in the order given in the array.  (You may want the
 url attribute to be written first, if the receiver is to be tested
 for exportability.)
 @param    mergeTags  States which of the tags to keep in the receiver.
 In this context, source=stark the parameter, and destin=the receiver.
 Note that BkmxMergeResolutionKeepDestinTags will no-op the tags if that's what
 you want.
 @param    fabricateTags  States whether or not tags should be created
 from the lineage of the given stark and added to those of the receiver.
 @param    stark  The stark from whom attributes and tags should be
 copied.
 */
- (void)overwriteAttributes:(NSArray*)overwritees
                  mergeTags:(BkmxMergeResolutionTags)mergeTags
              fabricateTags:(BOOL)fabricateTags
                  fromStark:(Stark*)stark ;

/*!
 @brief    Invokes -overwriteAttributes::::, passing
 attributes: as -allAttributes, locals:YES, mergeTags as BkmxMergeResolutionKeepSourceTags
 fabricateTags:NO, and exformat:nil; in other words, a simple overwrite of
 everything from stark to receiver.

 @details  This is similar to but not quite the same as the one-liner
 [self setValuesForKeysWithDictionary:[stark attributesDictionaryWithNulls:NO]] ;.  
 You see, -[<NSKeyValueCoding> setValuesForKeysWithDictionary:]
 sets an NSNull for nil values.  This method actually sets those
 values to nil instead of an NSNull.  But I'm not sure if attributes
 can be nil.  So maybe I should use that method.  See message from
 Ben Trumbull.
 */
- (void)overwriteAttributesFromStark:(Stark*)stark ;

- (Stark*)bestMatchBetweenStark1:(Stark*)stark1
                          stark2:(Stark*)stark2 ;

- (Stark*)bestMatchFromSet:(NSSet*)set ;

/*!
 @brief    Converts an array of starks to an array of NSCoding-encodeable
 dictionaries, sets this array as the rssArticles of the receiver, and
 finally removes the given starks from the receiver's managed object
 context.

 @details  This method is necessary because, in parsing Firefox bookmarks,
 it is impossible to distinguish an rss article from a regular bookmark
 until you see that the parent is a live rss feed.  Therefore, it is
 easier to insert them as starks and then later use this method to get
 the array which is encoded as a simple attribute into the document's
 object graph.
 
 The reverse of this method is -[SSYOperation(OperationExport) restoreRssArticlesInsertAsChildStarks].
 @param    starks  The array of starks which will be converted, set and removed.
*/
- (void)setRssArticlesFromAndRemoveStarks:(NSArray*)starks ;

/*!
 @brief    If the receiver does not have an addDate or lastModifiedDate,
 sets these attributes to the current date.   Otherwise, no-op.
*/
- (void)createRequiredDatesIfMissing ;

#pragma mark * Deep Value-Added Getters 

- (NSString*)parentName ;

- (BOOL)hasIncestWithProposedChild:(Stark*)child ;

- (BOOL)hasIncestWithAnyOfProposedChildren:(NSArray*)children ;

/*!
 @brief    Returns the number of ancestors in the receiver's lineage.
 
 @details  If the item is an orphan or is the root item, returns 0.
 */
- (NSInteger)lineageDepth ;

/*!
 @brief    Returns an array of starks: (self, parent, ... ),
 ending with the first parent whose Sharype has a 1
 bit in the given mask, and this terminator parent is not included
 in the result.
 @param    maskOut  A bit mask for which the Sharype of all items
 in the results must not have any 1 bits.
 @param    includeSelf  NO to exclude self from the result
 @result   An array of strings, names.  Any items with nil name
 are represented by a "No name" placeholder.
 */
- (NSArray*)lineageSharypeMaskOut:(Sharype)mask
                      includeSelf:(BOOL)includeSelf ;

- (NSDictionary*)lineageStatus ;

+ (NSSet *)keyPathsForValuesAffectingLineageStatus ;

/*!
 @brief    Returns an array of names: ([self name], [parent name], ... ),
 ending with the name of the first ancestor whose Sharype has a 1
 bit in the given mask, and this terminator parent is not included
 in the result.
 @param    maskOut  A bit mask for which the Sharype of all items
 in the results must not have any 1 bits.
 @param    includeSelf  NO to exclude self from the result
 */
- (NSArray*)lineageNamesSharypeMaskOut:(Sharype)mask
                           includeSelf:(BOOL)includeSelf ; 

/*!
 @brief    Returns an array of names with SharypeRoot excluded,
 of the form ([owner displayNameShort], ..., [parent name], [self name]).

 @details  Note that this is in reverse order of what you get
 from lineageNamesSharypeMaskOut:includeSelf.
 @param    doSelf  NO to exclude self from the result
 @param    doOwner  NO to exclude the Collection name the result
 @result   An array of strings, names
*/
- (NSArray*)lineageNamesDoSelf:(BOOL)doSelf
                       doOwner:(BOOL)doOwner ;

+ (NSString*)lineageLineWithLineageNames:(NSArray*)lineageNames ;

/*!
 @brief    Gets a human-readable lineage of the receiver
 
 @details  Returns the lineage of names on one line, looking like:
   [owner displayNameShort], ... , [parent name], [self name]
 If no names are found in this lineage, returns an empty string.
 @param    doSelf  If YES, result will include [self name].
 @param    doOwner  If YES, result will include [self name].
 If NO, result will not include [self name], and in this case
 the result may be an empty string
 */
- (NSString*)lineageLineDoSelf:(BOOL)doSelf
                       doOwner:(BOOL)doOwner ; 

/*!
 @brief    Returns the hartainer ancestor which contains the receiver,
 or root if the receiver descends from root without an intervening hartainer,
 or the receiver if the receiver itself is a hartainer.
 
 @details  Note that, for our purposes, even though the user interface
 does not say so, root is a hartainer; [root isHartainer] = YES.
 
 If the receiver is an orphan, or if its lineage does not begin at root
 (meaning that its whole lineage is orphaned) returns nil.  This can occur if
 the receiver or its lineage has just been deleted, but is still in a Dupe.
*/
- (Stark*)collection ;

- (FolderStatistics)addFolderStatistics ;

/*!
 @brief    If the receiver -canHaveChildren, returns an short string
 giving the number of containers and bookmarks descending from the
 receiver, using shorthand symbols instead of the words "folders"
 and "bookmarks", or else returns an empty string
 */
- (NSString*)displayStatsShort ;

/*!
 @brief    If the receiver -canHaveChildren, returns a longer string
 giving the number of containers and bookmarks descending from the
 receiver, using the words "Subfolders" and "Bookmarks" or "Nothing".
 Else, returns nil.
 */
- (NSString*)displayStatsLong ;

/*!
 @brief    Returns a tool tip appropriate to a given table column

 @details  The given table column is used to determine the relevant
 attribute to be expressed in the returned toolTip.
 
 If the table column's  identifier begins "userDefined" and
 tableColumn responds to -userDefinedAttribute, that attribute
 becomes the relevant attribute.  Else, if the receiver responds
 to identifier as an attribute directly, that attribute
 becomes the relevant attribute.  Else, returns nil.
*/
- (NSString*)toolTipForTableColumn:(NSTableColumn*)tableColumn ;

/*!
 @brief    Returns an new, inserted stark containing most of the
 receiver's current non-nil attributes as keys and values. 

 @details This method is used as a first step in making a copy of a Stark.  
 The new Stark returned may be inserted into the managed object context
 of the given replicator.
 
 Relationships are never copied, only attributes.  A new parent may
 be set later.

 In the name, the word "replica" is used instead of "copy", so as to not
 have a Cocoa memory management implication.
 
 If copied, the value of 'exid' or 'exids' are copied as explained above in
 documentation of -overwriteAttributes::::, in the details section
 titled "APPROPRIATE COPYING OF exid/exids".
 
 This method is used for local to trans in
 * -[ExtoreWebFlat syncLocalToTrans]
 and for bkmxDoc to bkmxDoc in
 * -[Stark fabricateFolders]
 
 @param    freshened  Works per this table
 *  YES  Result has no 'exid' nor 'exids' key.  Keys 'addDate' and
 *       lastModified Date are set to the current date.
 *   NO  Result has appropriate 'exid' or 'exids' key, if any such
 *       data was available from the receiver.  Keys 'addDate' and
 *       lastModified Date are omitted.
 @param    replicator  The replicator into whose managed object context
 the new stark should be inserted.
 @result   An autoreleased NSDictionary replicating the
 attributes of the receiver as described.
 */
- (Stark*)replicatedOrphanStarkFreshened:(BOOL)freshened
                              replicator:(NSObject <StarkReplicator> *)replicator ;

/*!
 @brief    Invokes replicatedOrphanStarkFreshened:replicator: with freshened = NO

 @param    replicator  The replicator into whose managed object context
 the new stark should be inserted.
 */
- (Stark*)replicatedOrphanStarkNotFreshenedInReplicator:(NSObject <StarkReplicator> *)replicator ;

/*!
 @brief    Invokes replicatedOrphanStarkFreshened:replicator: with freshened = YES

 @param    replicator  The replicator into whose managed object context
 the new stark should be inserted.
 */
- (Stark*)replicatedOrphanStarkFreshenedInReplicator:(NSObject <StarkReplicator> *)replicator ;

- (NSString*)pathIndentedIncludingSelf:(BOOL)includeSelf ;

/*!
 @brief    Extracts all starks of SharypeCoarseLeaf recursively from the receiver
 and returns in an array.

 @details  Sends classifyBySharypeDeeply:hartainers:softFolders:bookmarks:separators:
 with other arguments set to nil.
 */
- (NSArray*)extractLeavesOnly ;

- (BOOL)aggresivelyNormalizeUrl ;

/*!
 @brief    Returns a deep copy (descendants in parent/child relationships) of the
 receiver, with nodes inserted into a specified BkmxDoc's store

 @details  This is indeed a 'copy' method in the memory-management sense.
 @param    freshened  If YES, in the returned stark, the constKeyExids
 key/value pair is omitted and the addDate is set to the current date.
 If NO, these values are copied from the receiver.
 If NO, the exid key values will be removed.
 @result   An tree of allocated copies of the receiver, not autoreleased.
 */
- (Stark*)copyDeepOrphanedFreshened:(BOOL)freshened
                         replicator:(id <StarkReplicator>)startainer ;

- (void)removeLegacySortedUnsortedAndAllowedDupeNameTags ;


#pragma mark * Movers and Removers

/*!
 @brief    Appends an ordered array of new children to the children
 of the receiver
 
 @details  The index of the first element in the array is set to be
 one more than the highest existing index in the receiver's set of
 children, and then they increase from there.
 @param    children  The children to be appended.
 */
- (void)appendChildren:(NSArray*)children ;

#if 0
#define USE_OPTIMIZED_RESTACK_CHILDREN 0
#else
#define USE_OPTIMIZED_RESTACK_CHILDREN 1
/*
 I tested this performance optimization was added for BookMacster 1.11,
 I think that the only improvement I saw was when
 adding an item at the top of a folder of 8000 items – with optimization,
 the time to execute this was reduced from 5 seconds to 2 seconds.  Although
 having anywhere near 8000 items in a single folder is rare for users of
 hierarchy, it is not uncommon for flat documents based on web app clients
 like Pinboard.
 */
#endif

/*!
 @brief    THE FOLLOWING SEEMS TO BE MOSTLY NONSENSE:
 Changes the -index of each of the receiver's children
 as required so that the first child has index 0 and the sequence
 of children indexes proceeds with no gaps, with a compiler option,
 USE_OPTIMIZED_RESTACK_CHILDREN, to use a performance
 optimization.
 
 @details  THE FOLLOWING SEEMS TO BE MOSTLY NONSENSE:
 The optimization is that, instead of invoking -setIndex:
 on each item, invokes -setIndexStealthily which is the same as
 -[SSYManagedTreeObject setIndex] except that it does not invoke
 postWillSetNewValue:forKey: and, to compensate for this, invokes
 -[BkmxDoc postSortMaybeNot] once at the end, if the owner (is a
 BkmxDoc instance) and therefore responds to -postSortMaybeNot.
 The reason is that sending this notification for potentially
 thousands of items is expensive, and the only thing that the notifee,
 -[BkmxDoc objectWillChangeNote], does with it is to send
 -[BkmxDoc postSortMaybeNot], which there is no need to do more
 than once, for all. 
*/
- (void)restackChildrenStealthily:(BOOL)stealthily ;

/*!
 @brief    Resets the index of each of the receiver's children, 
 unstealthily, per sorting with +[Gulper sortDescriptors]
*/
- (void)restackChildrenOfHartainerForGulp ;


/*!
 @brief    Does the actions required to move a stark from one parent
 to another, or to delete it.
 
 @details  If index given would leave a gap between receiver and siblings,
 adds as last sibling instead.
 
 To delete the receiver, pass newParent = nil.  This also removes from
 previous parent, and also deletes any descendants because in the data
 model for Starks the parent -> child relationship has Cascade Delete Rule.

 If new parent's moc != receiver's moc, deletes the receiver and all of its
 descendants from their moc, and for each one inserts a new stark into the
 new moc.  
 @param    newParent  The new parent to which the receiver should be added as a child,
 or nil if the desired action is to delete the receiver.
 @param    newIndex  The index (position) at which the receiver should be
 added, or NSNotFound to set as last child, or -1 to not set the index.
 Passing -1 with restack=YES will cause unexpected results.
 @param    restack  You should normally pass YES.  If YES, reduces the index of 
 all higher-indexed siblings by 1 to fill in the gap.  If, however, there are
 thousands of siblings, and in particular if these siblings are in fact going
 away themselves soon, you can improve performance by passing NO, and then
 re-indexing the siblings later in a single operation.  If newIndex is
 NSNotFound, you must pass YES.  This parameter was added in BookMacster
 version 1.3.19, however, and to avoid bugs I did not change any calls to pass
 NO except the one that where performance improvement was really needed.
 @result   Returns the receiver unless the new parent's moc != receiver's moc, in
 which case it returns the new stark which was insertedto model the receiver
 in the new moc.
*/
- (Stark*)moveToBkmxParent:(Stark*)newParent
                   atIndex:(NSInteger)newIndex
                   restack:(BOOL)restack ;

/*!
 @brief    Does the actions required to move a stark from one parent (or no
 parent) to a new parent, placing it at the end (highest index) among its
 new siblings
 
 @param    newParent  The new parent to which the receiver should be added as a child
 */
- (Stark*)moveToBkmxParent:(Stark*)newParent ;

/*!
 @brief    Deletes the receiver and any childless ancestors it may have

 @details  Removing an item may make its ancestors childless
 This method removes childless ancestors, but each childless ancestor
 is removed only if its sharype is not one of the permanent hartainers.
 @result   The number of ancestors removed
 */
- (NSInteger)removeAndRemoveChildlessAncestors ;

/*!
 @brief    Expensively removes the receiver from its parent, adjusting sibling
 indexes as necessary, removes any associated starxids, and removes
 the receiver from its managed object context
 
 @details  For a lower cost method of removing many starks, use 
 +[StarkEditor removeStarks:] instead.
 -
 */
- (void)remove ;

/*!
 This method is no longer used as of BookMacster 1.0.4

 @brief    Delete the receiver from the receiver's managed object context,
 from its parent's children, but does not adjust the indexes of its siblings.
- (void)deleteStealthily ;
 */

- (void)removeIfIsSeparator ;

- (void)removeIfIsEmptyFolder ;

/*!
 @brief    

 @details  See "Merge Folders" in BookMacster Help Book.
 You must invoke this method recursively, starting from root,
 in order to get the result you expect!!
 
 @param    info  May contain these keys:
 * constKeyDocument, for getting chaker and progress view
 * constKeyLogLevel, for logging actions.
 * constKeyConsolidateAndRemoveNow.  If this key is missing, the
 method acts appropriately for an Ixport Operation: Folders are
 merged only if they are from different sources, empty folders are
 not removed (this is done by another method), and deleted folders
 are not really removed from the moc but only tracked in the
 bkmxDoc's chaker.  If the boolValue of this key is YES, the
 method acts appropriately for a Consolidate Folders operation:
 Folders are merged regardless of their source, empty folders are
 removed, and deleted folders are actually deleted from the moc.
 * constKeyDeletedFolderLineages.  If the bool value of key
 constKeyConsolidateAndRemoveNow is YES, and you provide a
 mutable array in this key, this method will add an item to it
 representing each folder that was deleted.  You typically use
 this to generate a report of what was done.
 * constKeyMergedFolderLineages.  Ditto, except for merged folders
 instead of deleted folders.
 * constKeyFoldersDeletedDuringConsolidation  If the bool value of key
 constKeyConsolidateAndRemoveNow is NO, and you provide a
 mutable set in this key, this method will add each deleted folder, if any,
 to that mutable set.
 * constKeyKeepSourceNotDestin.  If the -boolValue of this NSNumber
 is YES, when folders are merged, will keep whichever one
 responds YES to isNewItemThisIxport.
*/
- (void)mergeFoldersWithInfo:(NSDictionary*)info ;


#pragma mark * Deep Value-Added Mutators 

/*
 Referring to http://en.wikipedia.org/wiki/Tree_traversal,
        F
       / \
      B   G
     / \   \
    A   D   I
       / \   \
      C   E   H
 
 I believe that four of the methods below use a 
 Reversed Preorder traversal sequence:  F, G, I, H, B, D, E, C, A
 But the two with Postorder in the name use a
 Reversed Postorder traversal sequence: H, I, G, E, C, D, A, B, F
 I have not verified this.
 */
 
- (void)recursivelyPerformSelector:(SEL)selector ;

- (void)recursivelyPostorderPerformSelector:(SEL)selector ;

- (void)recursivelyPostorderPerformSelector:(SEL)selector
                                  withObject:(id)object ;

- (void)recursivelyPerformSelector:(SEL)selector
                        withObject:(id)object ;

- (void)recursivelyPerformSelector:(SEL)selector
                        withObject:(id)object1
                        withObject:(id)object2 ;

- (void)recursivelyPerformSelector:(SEL)selector
                        withObject:(id)object
                           toDepth:(NSInteger)maxDepth
                      currentDepth:(NSInteger)currentDepth ;

/*!
 @brief    Folder-izes the immediate children of a container stark, by creating
 subfolders named after child bookmarks' tags and moving the children into them.

 @details  Places each child in a new subfolder of the receiver, named
 after one of the receiver's tags.
 
 If the integer value of fabricateFolders is BkmxFabricateFoldersOff,
 or if the receiver responds NO to -canHaveChildren, this method is a no-op.
 
 @param    fabricateFolders  The integer value of this number should
 be one of those enumerated in BkmxFabricateFolders.  It specifies
 whether no folders should be created, one folder may be created, or multiple
 folders, each containing a copy of the tagged child should be created for
 children that have multiple tags.
 @param    index  The current value of ixporting index.  This is probably not
 necessary.  I just included it for completeness.
 @param    newFolders  You should pass an initialized mutable set, into which
 this method will place any fabricated folders as Stark objects.  The created
 folders will have proper values for sharype, addDate (now), lastModifiedDate
 (now), name, isNewItem (in ixporting flags), sponsorIndex, sponsoredIndex,
 ixportingIndex (passed in as a parameter), but will not be added to a Chaker
 and will not have an exid for any Clientoid.
 */
- (void)fabricateFolders:(NSNumber*)fabricateFolders
          ixportingIndex:(NSInteger)index
              newFolders:(NSMutableSet**)newFolders_p;

/*!
 @brief    Assuming receiver is the root of a tree, given optionally the four
 permanent hartainers, grafts them together properly and cleans everything up.

 @details  Finds immoveable branches either as arguments or already in receiver's children:
 If arguments bar, menu, unfiled or ohared are nil, will examine receiver's children for
 item with sharype = SharypeBar, SharypeMenu, SharypeUnfiled or SharypeOhared respectively.  
 If one of these hartainers is not found in either location, it will remain nil.  This
 nil is the expected result when the startainer being assembled does not support the
 hartainer(s).
 
 After finding or not finding these four hartainer(s),
 <ol>
 <li>Sets the name of each found hartainer.</li>
 <li>Sets the sharype of the receiver to SharypeRoot.</li>
 <li>Sets the sharypes of each found hartainer.</li>
 <li>Sets relationships so that each of the found hartainer(s) is a child of
 the receiver and the receiver is a parent of each found hartainer(s).</li>
 <li>Sets index(es) of each found hartainers to the standard order: bar first
 if it exists, then menu, then unfiled, then ohared.  The indexes of the receiver's
 other children, presumably soft folders, are adjusted so that they begin after
 the hartainers.</li>
 </ol>
 
 This method is invoked at the end of readExternalStyle1ForPolarity:: by
 Extore subclasses.
 
 The relationship-setting step is needed because te mergeFromStartainer::::
 methods need a known configuration for the source: Are the hartainers children
 of root, or are they not?  I believe that, in some subclasses,
 the readExternalStyle1ForPolarity:: method places them as children
 of root, but others do not.  It might be nice to someday go through all
 of those subclasses, change if needed so that they do ^not^ place the hartainers into
 root, then eliminate that step, and finally modify mergeFromStartainer::::
 methods so as to access the hartainers using -bar, -menu, -unfiled, and -oshared
 instead of iterating through root's children.
 @param    bar  The bar of the tree to be assembled.  May be nil.
 @param    menu  The menu of the tree to be assembled.  May be nil.
 @param    unfiled  The unfiled of the tree to be assembled.  May be nil.
 @param    shared  The shared of the tree to be assembled.  May be nil.
 */
- (void)assembleAsTreeWithBar:(Stark*)bar
                         menu:(Stark*)menu
                      unfiled:(Stark*)unfiled
                       ohared:(Stark*)ohared ;


#pragma mark * Viewing

/*!
 @brief    Expands or collapses the representation of the receiver
 in a given outline view if its current expanded/collapsed state
 does not match the receiver's isExpanded property.

 @details  Seems like this would logically be in the outline view,
 but it needs to be a Stark method to be used recursively.
 
 Supposedly, will post the will/did/expand/collapse notifications.  This
 is a waste of processor cycles because I use these notifications
 to set the isExpanded property.  In other words, it does the
 converse of what I just did, which is unnecessary.  However, when I
 sampled with Activity Monitor while expanding an outline of 50,000 items,
 this method did not have any notification postings, outlineViewItemDidExpand
 or outlineViewItemDidCollapse invocations under it.
 
 @param    outlineView  The outline view in which the receiver's
 representation may be affected.
*/
- (void)realizeIsExpandedIntoOutline:(NSOutlineView*)outlineView ;


#pragma mark * Other Methods

- (void)makeCheesyMissingExidsForExtore:(Extore*)extore ;

- (NSObject <Hartainertainer, StarkReplicator, Startainer>*)owner ;

- (BOOL)mocIsLocal ;

/*!
 @brief   Sets the receiver's lastModifiedDate back to its old value if all
 of updates which caused it to be changed were undone milliseconds later,
 and returns whether or not the stark has any updated values.
*/
- (BOOL)finalizeLastModifiedDate ;

@end


/*!
 @brief    Accessors generated dynamically by Core Data for Stark managed objects

 @details  These to-many accessors, which I do not implement
 because they are dynamically generated at runtime by Core Data, 
 must be declared in a category with no implementation. If declared in, for
 example, the class @interface, you get compiler warnings that their implementations
 are missing.
 http://www.cocoabuilder.com/archive/message/cocoa/2008/8/10/215317
 */
@interface Stark (PublicCoreDataGeneratedAccessors)

- (void)addChildrenObject:(Stark *)value;
- (void)removeChildrenObject:(Stark *)value;
- (void)addChildren:(NSSet *)value;
- (void)removeChildren:(NSSet *)value;

- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)value;
- (void)removeTags:(NSSet<Tag*>*)value;

@end

@interface Stark (RedeclareForReturnTypes)

/*
 Redeclare superclass methods to indicate that they return the class
 of this type instead of the superclass type, or provide subclass-specific
 documentation.  The former is necessary so that we can send instance\
 messages of this class to them without getting compiler warnings.
 
 To avoid *other* compiler warnings, telling us "No implementation", 
 we declare these in a category with no implementation.  See
 http://www.cocoabuilder.com/archive/message/cocoa/2008/8/10/215317
 If declared in, for example, the subclass @interface, or in an
 anonymous category ("()"), you get compiler warnings of missing
 implementations are.
 */

/*!
 @brief    Returns the receiver's parent Stark

 @details  All starks except root should have their parent set upon creation,
 so this should not return nil except if root.
 @result   
*/
- (Stark*)parent ;

- (Stark*)childAtIndex:(NSInteger)index ;

- (NSArray<Stark*>*)childrenOrdered;

/*!
 @brief    Returns whether or not the any of the receiver's
 ancestors are in a given array of target parents.

 @details  The presence of the receiver itself is in the given
 array of target parents does not cause this method to return
 YES; only ancestors count.
*/
- (BOOL)descendsFromAnyOf:(NSArray*)parents ;

/*!
 @brief    Returns a hash value comprised of the hash values of most of the
 given attributes (see implementation for strategic omissions),
 exclusive-orred with the valuesHash of all of its children, if any.

 @details  The -valuesHash of a tree's root will give a hash for an entire
 tree.
*/
- (uint32_t)valuesHashOfAttributes:(NSArray*)attributes ;

- (NSDictionary*)debugHashableValuesDicForAttributes:(NSArray*)attributes ;

- (void)debugLogTree ;


+ (void)debug_clearHashComponents ;
+ (void)debug_writeHashComponentsToDesktopWithPhaseName:(NSString*)phaseName
                                             clientName:(NSString*)clientName;

@end

