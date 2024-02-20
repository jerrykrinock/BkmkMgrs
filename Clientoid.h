#import <Cocoa/Cocoa.h>
#import "BkmxGlobals.h"
#import "SSYOAuthTalker.h"


// Keys to instance variables

extern NSString* const constKeyIdentifierExformat ;
extern NSString* const constKeyIdentifierProfileName ;
extern NSString* const constKeyIdentifierExtoreMedia ;
extern NSString* const constKeyIdentifierExtorageAlias ;
extern NSString* const constKeyIdentifierPath ;

/*!
 @brief    A class which has instance variables required
 to define the Extore for a Client.

 @details    Clientoid must conforms to NSCoding and NSCopying
 because Clientoids are used as keys in the exid dictionaries which
 are attributes of Starks that are archived in Core Data stores
 using the default transformer.

 The six string instance variables must consist of only
 the characters allowed in filenames.
 
 Note that a Clientoid does not include the additional instance
 variables of doImport, doExport and index, because these are not
 necessary to identify the Extore, and would thus be not needed
 in exid dictionaries.  Use ClientoidPlus if you need these
 additional instance variables.
*/
@interface Clientoid : NSObject <NSCoding, NSSecureCoding, NSCopying, SSYOAuthAccounter> {
	NSString* m_exformat ;
	NSString* m_profileName ;
	NSString* m_extoreMedia ;
	NSData* m_extorageAlias ;
    NSString* m_path ;
}

// Defining attributes
@property (copy) NSString* exformat ;
@property (copy) NSString* profileName ;
@property (copy) NSString* extoreMedia ;
@property (copy) NSData* extorageAlias ;
@property (copy) NSString* path ;

/*!
 @brief    Returns either the full path to the receiver's ownerApp
 if it is installed as a desktop application, or a URL to the receiver's
 API if it is a web service application, or nil.
 
 @details  Returns nil if the receiver -ownerAppIsLocalApp but
 is not installed.
 */
- (NSString*)ownerAppFullPathError_p:(NSError**)error_p ;

- (NSString*)pathFromResolvedAlias ;

/*!
 @brief    Returns the base part of the receiver's defining file path,
 given its constant PathRelativeTo value
 */
- (NSString*)pathPrefixRelativeTo:(PathRelativeTo)relativeTo
						  error_p:(NSError**)error_p ;

/*!
 @brief    Returns the last component of the file path to the receiver's
 browser's bookmarks file, or localized "untitled" if the receiver does not have a
 single bookmarks file
 */
- (NSString*)defaultFilename ;

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
 @brief    Returns the Extore subclass, an instance of which is or could become
 one of the the receiver's ixporter's extore.
 */
- (Class)extoreClass ;

/*!
 @brief    Returns the name by which the user recognizes to the client.
 
 @details  Abbreviated, not guaranteed to be unique.&nbsp; 
 It's an engineering compromise.
 */
- (NSString*)displayName ;

- (NSString*)displayNameWithoutProfile ;

/*!
 @brief    A string which uniquely identifies the 
 receiver and six of the its instance variables

 @details  May be used as a filename.
*/
- (NSString*)clidentifier ;

/*!
 @brief    Returns a Clientoid with its seven instance variables
 set from given values.
 */
+ (Clientoid*)clientoidWithExformat:(NSString*)exformat
						profileName:(NSString*)profileName
						extoreMedia:(NSString*)extoreMedia
					  extorageAlias:(NSData*)extorageAlias
                               path:(NSString*)path ;

/*!
 @brief    Returns a Clientoid with its six instance variables
 extracted from a clidentifier.
 */
+ (Clientoid*)clientoidWithClidentifier:(NSString*)clidentifier ;

/*!
 @brief    Returns the display name of a hypothetical Clientoid
 created with a given Clidentifier string, or nil if the given
 string is not a well-formed Clidentifier.+ (NSString*)displayNameForClidentifier:(NSString*)clidentifier

 @details  The hypothetical Clientoid is actually created internally
 and then autoreleased.
*/
+ (NSString*)displayNameForClidentifier:(NSString*)clidentifier ;

+ (NSString*)exformatInClidentifier:(NSString*)clidentifier;

+ (NSString*)clidentifier:(NSString*)clidentifier
          withNewExformat:(NSString*)exformat;

/*!
 @brief    Returns a Clientoid which will represents a client with extoreMedia
 type constBkmxExtoreMediaThisUser, with a given exformat and profileName.
 
 @param    exformat  The exformat (file format of the external file) of the
 returned Clientoid object
 @param    profileName  The target profileName, or nil for the default/no profile.
 */
+ (Clientoid*)clientoidThisUserWithExformat:(NSString*)exformat
                                profileName:(NSString*)profileName ;

/*!
 @brief    Returns a Clientoid which will represents a client with extoreMedia,
 type constBkmxExtoreMediaLoose, with a given exformat and path.
 
 @param    exformat  The exformat (file format of the external file) of the
 returned Clientoid object
 @param    path  The path of the file proposed to be exported
 */
+ (Clientoid*)clientoidLooseWithExformat:(NSString*)exformat
                                    path:(NSString*)path ;

/*!
 @brief    Returns a Clientoid with all nil/NULL properties that will respond
 YES when sent the -isPlaceholder message.
 
 @details  Added in BookMacster 1.15
 */
+ (Clientoid*)clientoidPlaceholder ;

/*!
 @brief    Returns an array of all available clientoids of extoreMedia
 constBkmxExtoreMediaThisUser for the current Mac user.
 
 @details  The array consists of the results from
 +[self allClientoidsForLocalAppsThisUserByPopularity:::],
 with byPopularity = NO, followed by
 results from +[self allClientsForWebAppsThisUser].  Does not contain
 web app items with nil profiles for "New/Other", and also is not sorted.
 As is, this is suitable for the New Collection Wizard.  Adding New/Other
 and sorting must be done by the caller if desired.
 
 @result   The array of clientoids, or an empty array if no qualified clients
 were found.
 */
+ (NSArray*)availableClientoidsIncludeUninitialized:(BOOL)includeUninitialized
                               includeNonClientable:(BOOL)includeNonClientable ;

/*!
 @brief    Returns an array of all clientoids that have local sqlite stores
 in the SSYMOCManager.
 
 @result   The array of clientoids, or an empty array if no qualified clients
 were found.
 */
+ (NSArray*)allClientoidsWithSqliteStores ;

+ (NSArray*)allClientoidsForLocalAppsThisUserByPopularity:(BOOL)byPopularity
                                     includeUninitialized:(BOOL)includeUninitialized
                                      includeNonClientable:(BOOL)includeNonClientable ;

+ (NSArray*)allClientoidsForWebAppsThisUser ;

/*!
 @brief    Returns the home path of the Macintosh account in which the
 receiver's bookmarks reside
*/
- (NSString*)homePath ;

/*!
 @brief    Returns a dictionary containing a key/value pair for each
 of the seven internal instance variables that are not nil.
*/
- (NSMutableDictionary*)attributesDictionary ;

/*!
 @brief    Overriden to compare the receiver's seven instance variables with those
 of another clientoid and returns YES if all are equal, including nil==nil.

 @result   If all are not equal, including nil==nil, returns NO.
*/
- (BOOL)isEqual:(id)otherClientoid ;

- (BOOL)isPlaceholder ;

@end
