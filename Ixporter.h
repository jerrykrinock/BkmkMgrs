#import <Cocoa/Cocoa.h>
#import "BkmxGlobals.h"
#import "SSYManagedObject.h"
#import "StarkReplicator.h"
#import "Startainer.h"
#import "StarCatcher.h"
#import "GulperDelegate.h"

// An index offset which we use to make sure that when unmappable orphans
// are added to a second-choice default parent, they stay below (higher index)
// their aboriginal siblings.
#define ORPHAN_OFFSET NSIntegerMax/4

#define SPONSORED_BY_IS_HARTAINER -2
#define SPONSORED_BY_DESTIN -1
#define SPONSORED_BY_SOURCE (NSNotFound - 1)
#define PUT_AT_BOTTOM NSNotFound


extern NSString* const constKeyDeleteUnmatched ;
extern NSString* const constKeyFabricateFolders ;
extern NSString* const constKeyFabricateTags ;
extern NSString* const constKeyIxportCount ;
//extern NSString* const constKeyIxportSeparators ;
extern NSString* const constKeyMergeBias ;
extern NSString* const constKeyMergeBy;
extern NSString* const constKeyShareNewItems ;
extern NSString* const constKeySponsoredChildren ;

@class Client ;
@class ClientChoice ;
@class Extore ;
@class Bookshig ;
@class BkmxDoc ;
@class BkmxBasis ;
@class SSYProgressView ;

/*!
 @brief    A managed object which stores settings and knows how to
 do the Import *or* Export for a single Client.

 @details  Ixporters are stored in the managed object context
 of a BkmxDoc document and are related to the documents Bookshig
 as importers objects or exporters objects.

 <p><i>Details which apply to both -import... and -export... methods</i>.
 These methods create a temporary Client, and an Extore, which
 create a temporary transMoc.  When these methods  are complete,
 all of these objects will be autoreleased.
 Therefore, the next time one of these methods is invoked, bookmarks
 will be read in from the external store from scratch, all over again.
 Merging and item adjustments are performed according
 to the values of the relevant attributes in the receiver.  
 The receiver's owning BkmxDoc is found by sending -owner to the
 receiver's -managedObjectContext.
 Progress messages may be sent to the receiver's owning BkmxDoc.
</p> 
 */
@interface Ixporter : SSYManagedObject <GulperDelegate, Startainer, StarkReplicator> {
	Extore* m_extore ;  // "Owned" and retained
	NSInteger m_traceLevel ;
	BkmxDoc* m_bkmxDoc ;  // Weak, cached for efficiency.

	// Remember, managed object properties are declared in a data model, not here!
}


#pragma mark * Core Data Generated Accessors for managed object properties



@property (retain, readonly) Client* client ;
@property (retain) NSNumber* deleteUnmatched ;
@property (retain) NSNumber* fabricateFolders ;
@property BOOL fabricateFoldersAny ;
@property BOOL fabricateFoldersMany ;
@property (retain) NSNumber* fabricateTags ;
@property (retain) NSSet* folderMaps ;
@property (retain) NSNumber* isActive ;
/*!
 @brief    The number of times that the receiver has executed
 an Import or Export operation.
 
 @details  Starting in BookMacster 1.11, I don't read this attribute
 for an importer any more, because I have -importCount on Bookshig
 which makes more sense.  However, I have left it in the data model 
 and still increment it, just in case I'm wrong.  This attribute is
 still read for exporters.
 
 Actually, the only use in either case is to see if it is > 0
 after an ixport operation, which says whether or not the safe limit
 should be observed.
 */
@property (retain) NSNumber* ixportCount ;
@property (retain) NSNumber* mergeBias ;
@property (retain) NSNumber* mergeBy;
@property (retain) NSNumber* skipFileUrls ;
@property (retain) NSNumber* skipJavaScript ;
@property (retain) NSNumber* skipRssFeeds ;
@property (retain) NSNumber* skipSeparators ;
/*!
 @brief    A number with sharypeValue equal to the sharype of the
 hartainer in which the user prefers unmappable items to be placed,
 regardless of whether or not this hartainer is available in the
 receiver's extore.
 */
@property (retain) NSNumber* preferredCatchype ;
@property (retain) NSNumber* shareNewItems ;
@property (retain) NSSet* tagMaps ;

- (NSArray*)folderMapsOrdered ;
- (NSArray*)tagMapsOrdered ;

- (BOOL)isAnImporter ;
- (BOOL)isAnExporter ;	
- (BOOL)isFirstActiveImporter ;
- (BOOL)isLastActiveImporter ;
- (BOOL)isFirstActiveExporter ;
- (BOOL)isLastActiveExporter ;
	
/*!
 @brief    Examines other more primary instance variables in the receiver and
 if necessary changes the value of mergeBy to be valid under these
 conditions.
 
 @details  Send this message to the receiver whenever its effective deleteUnmatched value
 is changed, or whenever its client is possibly set to one whose extore silentlyRemovesDuplicates,
 to make sure that duplicates will not be attempted to be exported.
 
 If the receiver is an exporter, and if it's client's extore silently
 removes duplicates, sets the receiver's mergeBy to BkmxMergeByExidOrUrl.
 The reason is that, for exporting to clients which silently remove duplicates
 such as Pinboard, rather than having a separate step to remove duplicates
 before uploading as in Bookdog, this switch will cause merging to occur in
 -[Ixporter mergeFromStartainer:::] or -[Ixporter gulpStartainer::::].
*/
- (void)doMergeByBusinessLogic ;

/*!
 @brief    Creates and returns a new Extore instance initialized with the receiver's
 current client, owner, with instance variables
 such as 'error' and 'ownerAppQuinchState' set to nil and NO, and sets this new
 extore as the receiver's 'extore' instance variable.
 
 @details  	This method is not thread-safe because it will cause two Core Data
 accesses: self will get its client, and client will get its exformat.
 */
- (Extore*)renewExtoreForJobSerial:(NSInteger)jobSerial
                           error_p:(NSError**)error_p ;

- (BOOL)mergeFromStartainer:(NSObject <Startainer, StarkReplicator> *)source
					 toStartainer:(NSObject <Startainer, StarCatcher, StarkReplicator> *)destin
							 info:(NSMutableDictionary*)info
						  error_p:(NSError**)error_p ;

/*!
 @brief    If active and necessary, reads in items from the external store,
 as indicated by the receiver's client, to the receiver's owner, a BkmxDoc.

 @details  Necessity is determined by comparing the lastKnownTouch
 and lastImported timestamps of the receiver's client.
 
 More info in the class documentation.
 
 @param    info  A mutable dictionary containing two NSNumber objects
 and keys:
 * The intValue of an NSNumber for key constKeyDeference should be
 the level of deference to use in case a nasty browser will not
 allow bookmarks to be written.
 * The boolValue of an NSNumber for key constKeyIfNotNeeded should be
 YES if you want the import to be performed even if the
 modification dates indicate it is not necessary.
 
 We'd wrapped these arguments in the mutable dictionary so that this
 method had the same argument signature as
 +[LegacyImporter importLegacyFor1ClientInfo:].  This was handy when
 -[Extore attemptRecoveryFromError:recoveryOption:delegate:didRecoverSelector:contextInfo:]
 needs to change the deference to a newDeference.  We don't use LegacyImporter
 starting with BookMacster 1.17.
 */
- (void)importGroup:(NSString*)group
			   info:(NSMutableDictionary*)info ;

/*!
 @brief    Reads out items from the receiver's owner, a BkmxDoc, to the
 external store indicated by the receiver's client.

 @details  Returns after the the BkmxDoc's data is converted, but writing
 data out continues asynchronouslyin other thread(s).
 
 If ultimately successful, sets (in User Defaults) the timestamp
 x for the client indicated by the receiver's client.  
 Otherwise, presents the error to the user.  (Either of these are performed
 by -[BkmxDoc finishGroupOfOperationsWithInfo:], after returning to the main thread.)
 
 More info in the class documentation.  

 @param    info  A mutable dictionary containing an NSNumber object
 for key constKeyDeference.  The value of the NSNumber should be
 the level of deference to use in case a nasty browser will not
 allow bookmarks to be written.
 
 Ditto the ""We'd wrapped…" note in -importGroup:info: above.
 */
- (void)exportGroup:(NSString*)group
			   info:(NSMutableDictionary*)info ;
	
/*!
 @brief    Returns an array of NSNumbers representing the Sharypes of
 the hartainers which the receiver's extore supports.
 */
- (NSArray*)availableHartainers ;

- (NSString*)displayNameForHartainer:(NSNumber*)hartainer ;

@property (retain) Extore* extore ;

/*!
 @brief    Sets the receiver's extore to nil.

 @details  Use to avoid Core Data "object ... has been invalidated" errors.
*/
- (void)releaseExtore ;

// To satisfy compiler stupidity, so that Exporter will not be seen as
// not conforming to StarCatcher

- (BOOL)hasBar ;
- (BOOL)hasMenu ;
- (BOOL)hasUnfiled ;
- (BOOL)hasOhared ;

- (uint32_t)settingsHash ;

@end


