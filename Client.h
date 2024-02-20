#import "BkmxGlobals.h"
#import "StarkTyper.h"
#import "SSYManagedObject.h"
#import "SSYToolTipper.h"
#import "SSYIndexee.h"
#import "SSYOAuthTalker.h"

#if MAC_OS_X_VERSION_MIN_REQUIRED > 1050
#define CPH_TASKMASTER_AVAILABLE 1
#else
#define CPH_TASKMASTER_AVAILABLE 0
#endif

extern NSString* const constKeyImporter ;
extern NSString* const constKeyExporter ;

@class Stark ;
@class Extore ;
@class BkmxDoc ;
@class SSYVersionTriplet ;
@class Clientoid ;
@class ClientoidPlus ;
@class ClientChoice ;
@class Macster ;
@class Ixporter ;
@class Importer ;
@class Exporter ;
@class WebAuthorizor;

typedef enum {
    BkmxClientFileMustBeExisting,
    BkmxClientFileMustBeNew,
    BkmxClientFileUsersChoiceDefaultToExisting,
    BkmxClientFileUsersChoiceDefaultToNew
} BkmxClientFileExistence ;

/*!
 @brief    A managed object which knows static information about an OwnerApp
 and its exformat.&nbsp; To avoid duplication, a client can only be
 obtained using one of the Client class methods.
 @details  GLOSSARY
 Browser: An installed browser application such as Safari, Camino, etc.
 Service: Pinboard, del.icio.us, etc.
 OwnerApp: A Browser (installed application) or a Service (web application)
 Exformat: The format and structure of the bookmarks in an OwnerApp
 Client: structure of a profile or account supported by a particular ownerApp, or a builtout client.
 Examples:
 >  structure of a particular Firefox profile
 >  structure of a particular loose bookmarks file
*/
@interface Client : SSYManagedObject <SSYToolTipper, SSYIndexee, SSYOAuthAccounter> {
	// For security, make this an ivar instead of a managed attribute.
	// Its persistent storage is in the macOS Keychain.
	NSString* m_serverPassword ;
	
	NSMutableSet* m_freshUnexportedDeletions ;

	NSInvocation* m_waitingInvocation ;
	
	// Attributes of "quickie" clients
    NSString* m_nuevoPath ;
    BOOL m_willIgnoreLimit ;
	BOOL m_willOverlay ;
	BOOL m_willSelfDestruct ;
}

@property BkmxClientFileExistence clientFileExistence ;
@property (retain) WebAuthorizor* webAuthorizor;

+ (NSSet*)extoringKeyPaths ;

// property 'index' is declared in protocol SSYIndexee

- (NSInteger)indexValue ;

/*!
 @brief    The password required to access data on the remote server

 @details  Stored as an instance variable instead of a managed property,
 for security.  Persistent store is in macOS Keychain
*/
@property (copy) NSString* serverPassword ;

/*!
 @brief    An invocation which will be invoked after -setIvarsThenInvokeWaitingIfAnyLikeClientoid:
 completes

 @details  Used to implement One-Time Import/Export\, when a quickie
 client is created but needs to wait for configuration before importing or
 exporting.
*/
@property (retain) NSInvocation* waitingInvocation ;

@property (assign) BOOL willIgnoreLimit ;
@property (assign) BOOL willOverlay ;
@property (assign) BOOL willSelfDestruct ;

#pragma mark * Primary Identifier "Parts" managed by Core Data
	
/*!
 @brief    The external format of the receiver.

 @details  This is required for all clients.
*/
@property (copy) NSString* exformat ;

/*!
 @brief    The profile name or account name of the receiver.

 @details  Profile name for Firefox, Person name for Google Chrome-ish browsers,
 account name for web apps.  May be nil for browsers such as Opera which do not
 support multiple user profiles.
*/
@property (copy) NSString* profileName ;

/*!
 @brief    An additional profile name or account name of the receiver.
 
 @details  This was used for Google clients because Google can have regular
 email or a gmail email which both access the same account.  It may be use d
 for Firefox now, not sure, with the FirefoxDeveloperEdition thing.
 */
@property (copy) NSString* profileNameAlternate ;

/*!
 @brief    The external storage media of the receiver.
 
 @details  One of the constBkmxExtoreMediaXXXXX constants.
 */
@property (copy) NSString* extoreMedia ;

/*!
 @brief    Data of an alias record identifying the external
 store file of the receiver.
 
 @details  Clients of extoreMedia BkmxExtoreMediaLoose
 must have this attribute.  Other extoreMedia types must
 not have this attribute.
 */
@property (retain) NSData* extorageAlias ;

@property (retain) NSString* nuevoPath ;

#pragma mark * Timestamps managed by Core Data

/*!
 @brief    The last NSDate that we completed
 exporting the receiver's extore.
 */
@property (copy) NSDate* lastImported ;

/*!
 @brief    The last date that we <i>know</i> the external
 store's data was touched.
 
 @details  With some extores, particularly those whose owners are
 web apps, the "last touched" value given by their API may 
 exclude some touches that we know about (usually because we did
 them).&nbsp; Therefore, we record whenever we <i>know</i> that
 the extore was touched.&nbsp; Therefore,
 -[Extore lastDateExternalWasTouched] should always look at this
 date and return it if it is later than the date it found.
 */
@property (copy) NSDate* lastKnownTouch ;

/*!
 @brief    Sets the receiver's lastKnownTouch to a new value,
 but only if it is later than the current value of lastKnownTouch.

 @param    proposedDate  
*/
- (void)setIfLaterLastKnownTouch:(NSDate*)proposedDate ;

@property (retain) NSNumber* specialOptions ;
@property (retain) NSNumber* specialDouble0;  // used for httpRateInitial
@property (retain) NSNumber* specialDouble1;  // used for httpRateRest
@property (retain) NSNumber* specialDouble2;  // used for httpRateBackoff

@property (retain) NSSet* unexportedDeletions ;
- (void)addUnexportedDeletion:(NSString*)deletion ;
- (void)clearUnexportedDeletions ;

@property (retain) NSNumber* failedLastExport ;

#pragma mark * Other properties managed by Core Data

@property (retain) Importer* importer ;
@property (retain) Exporter* exporter ;
@property (retain) Macster* macster ;
@property (retain) NSSet* triggers ;


#pragma mark * Accessors for non-managed object properties

#pragma mark * Other Methods 

- (void)chooseClientFromFile ;

- (void)setClientWithNilProfileForWebAppExformat:(NSString*)exformat ;

            /*!
 @brief    Nils the receiver's waitingInvocation and removes the
 receiver from its owner, Macster object

 @details  Use this if the user cancelled or other error occurs
 when configuring a new client, to avoid leaving a non-functional
 Client.  This method was added in BookMacster 1.5.8.
 
 Nilling the waitingInvocation is needed to break a retain cycle.
*/
- (void)abandon ;

- (void)rollUnexportedDeletions;

/*!
 @brief    A shortcut to return the receiver's macster's bkmxDoc.
*/
- (BkmxDoc*)bkmxDoc ;

/*!
 @brief    Return YES if the receiver's clientoid is equal to that of another
 given client (which is apparently a looser definition than that used by the 
 superclass NSManagedObject's -isEqual:) 

 @details  I learned the hard way that, tucked into NSManagedObject documentation at the top, is
 a rule that you "absolutely must not" override -isEqual:.  However, NSManagedObject's
 -isEqual seems to be more strict than the following.  At any rate, its criteria is
 undocumented.  Hence, the need for this method.
 
 Note that this does not fix the behavior of NSSet, which will use Apple's -isEqual:
 and therefore may contain duplicate, "equal" objects according to this method.
*/
- (BOOL)isEqualToClient:(Client*)otherClient ;

	/*!
 @brief    Returns a clientoid (client identifier) which specifies all of the
 receiver's constant properties and is unique among clients.
 
 @details  See Clientoid class overview for precise specification.&nbsp; 
 */
- (Clientoid*)clientoid ;

/*!
 @brief    Encodes the two otherMacXXXXX values from a given a dictionary into
 a full filesystem path to a Home directory in the /Volumes directory.
 */
- (NSString*)homePath ;

/*!
 @brief    Returns the Extore subclass, an instance of which is or could become
 one of the the receiver's ixporter's extore.
 */
- (Class)extoreClass ;

/*!
 @brief    The name of the web host; i.e. "x.y.com" which is the
 external store for the receiver.
 */
- (NSString*)webHostName ;

/*!
 @brief    Returns the name by which the user recognizes to the client.
 
 @details  Abbreviated, not guaranteed to be unique.&nbsp; 
 It's an engineering compromise.
 */
- (NSString*)displayName ;

- (NSString*)displayNameWithoutProfile ;

/*!
 @brief    Should be used to set and get the last time that the receiver's
 local managed object context was synced with the external store.

 @details  Since this time may be affected for more than one client
 (with the same clientoid) in different BkmxDocs, it is stored in 
 user defaults.&nbsp; It is not KVObserveable.
*/
@property (retain) NSDate* lastLocalMocSync ;

/*!
 @brief    Returns either the full path to the receiver's ownerApp
 if it is installed as a desktop application, or a URL to the receiver's
 API if it is a web service application, or nil.
 
 @details  Returns nil if the receiver -ownerAppIsLocalApp but
 is not installed.
 */
- (NSString*)ownerAppFullPathError_p:(NSError**)error_p ;

/*!
 @brief    Returns the path to the external bookmarks file, or nil if the receiver's
 browser does not have a single bookmarks file.
 */
- (NSString*)filePathError_p:(NSError**)error_p ;

/*!
 @brief    Returns the path to the parent directory containing the receiver's
 browser's bookmarks file or files, or nil if the receiver's browser does not
 have a single bookmarks file, regardless of whether or not this path is
 accessible in the posix sense.&nbsp;  For a web service, returns the path on
 the server at which the bookmarks API is accessed.
 */
- (NSString*)filePathParentError_p:(NSError**)error_p ;

/*!
 @brief    The path which will change in a manner detectible
 by launchd whenever the owner app changes the bookmarks content for the
 current user's Mac account
 
 @details  Assumes that the Extension has been installed, if needed.
 
 Subclasses should override.  The default implementation returns nil,
 which indicates that such a path is not available.
 */
- (NSString*)sawChangeTriggerPath ;

/*!
 @brief    Sets the receiver's extorageAlias to identify the
 receiver's filePath.
 
 @details  
 */
- (void)setExtorageAliasFromFilePath ;

/*!
 @brief    Sets the values of seven of the receiver's
 instance variables to match those of a given Clientoid object.
*/
- (void)setIvarsThenInvokeWaitingIfAnyLikeClientoid:(Clientoid*)clientoid ;

/*!
 @brief    Sets the values of seven of the receiver's
 instance variables, and the isActive of the receiver's importer
 and exporter to match those of a given ClientoidPlus object and its
 constituent Clientoid object.
 
 @details  The isActive of the receiver's importer and exporter
 are set to match the given ClientoidPlus's doImport and doExport,
 respectively.  Does not set the index.
 */
- (void)setLikeClientoidPlus:(ClientoidPlus*)clientoidPlus ;

- (void)setLikeClientChoice:(ClientChoice*)clientChoice ;

/*!
 @brief    Returns the last component of the file path to the receiver's
 browser's bookmarks file, or localized "untitled" if the receiver does not have a
 single bookmarks file
 */
- (NSString*)defaultFilename ;

/*!
 @brief    Returns whether or not the receiver's Extore class
 says it hasOrder
*/
- (BOOL)hasOrder ;

/*!
 @brief    Returns whether or not the receiver's Extore class
 says it hasFolders
 */
- (BOOL)hasFolders ;

/*!
 @brief    Returns whether or not the receiver's Extore class
 says it allows separators
 */
- (BOOL)supportsSeparators ;

/*!
 @brief    Returns whether or not the receiver's Extore class
 says it canEditTags
 */
- (BOOL)canEditTagsInStyle:(NSInteger)style;
- (BOOL)canEditTagsInAnyStyle;

/*!
 @brief    Returns the minimum version of the receiver's
 ownerApp which will write bookmarks in a format that this
 application can read and write.
 */
- (SSYVersionTriplet*)minBrowserVersion ;

/*!
 @brief    Returns the minimum macOS version required
 to run version -minBrowserVersion of the receiver's ownerApp.
 */
- (SSYVersionTriplet*)minSystemVersionForMinBrowserVersion ;

/*!
 @brief    If the receiver's extoreMedia is BkmxExtoreMediaThisUser,
 checks if the browser indicated by the receiver's ownerApp is
 installed on the system, and whether its version meets the
 minimum requirement of the receiver's minBrowserVersion.
 
 @details  If the receiver's extoreMedia is not constBkmxExtoreMediaThisUser,
 returns YES unconditionally.
 
 @param    error_p  If result is NO, upon return, will point to an NSError
 explaining the problem.
 @result   YES if browser is installed and meets minimum version requirement,
 NO otherwise.
 */
- (BOOL)browserInstalledIsOkError_p:(NSError**)error_p ;

- (NSString*)labelAdvancedSettings ;

- (NSArray*)availablePolaritiesForFolderMaps ;

- (NSArray*)availablePolaritiesForTagMaps ;

- (uint32_t)exportHashFromBkmxDoc:(BkmxDoc*)bkmxDoc ;

@end
