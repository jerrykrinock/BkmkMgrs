#import <Cocoa/Cocoa.h>
#import "BkmxGlobals.h"
#import "SSYAlert.h"
#import "SSYVersionTriplet.h"
#import "SSYErrorHandler.h"
#import "StarkReplicator.h"
#import "SSYInterappServerDelegate.h"
#import "Hartainertainer.h"
#import "Startainer.h"

#if MAC_OS_X_VERSION_MIN_REQUIRED > 1050
#define CPH_TASKMASTER_AVAILABLE 1
#else
#define CPH_TASKMASTER_AVAILABLE 0
#endif

/////////// COMPILER SWITCHES FOR TESTING ///////////////////////////////

/*
 The following two compiler switches are for debugging.
 Note the distinction between the following two compiler switches…
 • USE_LOCAL_DOT_SQL_CACHES_WHEN_IMPORTING_WEB_EXTORES says to use the .sql files.
 • LOCAL_FILE_PATH_TO_OVERRIDE_EXTOREWEBFLAT_DOWNLOAD says to use specified .webdata file.
 */

#if 0
#define USE_LOCAL_DOT_SQL_CACHES_WHEN_IMPORTING_WEB_EXTORES 1
// Currently, this works on Imports only.  Not sure how Exporting would
// work, unless I make an app to read clidentifier.sql files
// #warning is printed later so it doesn't get logged 87 times.
#endif

#if 0
// #warning is printed later so it doesn't get logged 87 times.
// The following should be a path to a .webData file
#define LOCAL_FILE_PATH_TO_OVERRIDE_EXTOREWEBFLAT_DOWNLOAD @"/Users/jk/Documents/SheepSystems/UserTroubleData/Problem.webData"
#else
// Leave LOCAL_FILE_PATH_TO_OVERRIDE_EXTOREWEBFLAT_DOWNLOAD undefined, so that
// the various #ifdef LOCAL_FILE_PATH_TO_OVERRIDE_EXTOREWEBFLAT_DOWNLOAD compiler
// switches will not switch.
#endif

// The following three should be switched to 1 for
// testing url normalization by Clients.
#if 0
// Warning is in the .m so we only get it once
#define IS_EXPORTABLE_STARK_WILL_ALWAYS_RETURN_YES 1
#endif
#if 0
// Warning is in the .m so we only get it once
#define DEBUG_WRITE_IMPORTED_URLS_TO_FILES 1
#endif
#if 0
// Warning is in the .m so we only get it once
#define DONT_USE_LOCAL_CACHES 1
#endif

///////////// END OF COMPILER SWITCHES FOR TESTING //////////////////////


#define WEBDATA_FILE_EXTENSION @"webData"
#define EXTENSION_VERSION_UNKNOWN_BECAUSE_ITS_BEEN_ZIPPED_BY_FIREFOX_3 0x0FFF0000
#define EXTENSION_2_NOT_APPLICABLE_TO_THIS_EXFORMAT -1

#define EXTORE_ERROR_CODE_BASE                       0x2E500 // = 189696
#define EXTORE_ERROR_CODE_MASK_EXTENSION1_NOT_FOUND      0x1
#define EXTORE_ERROR_CODE_MASK_EXTENSION1_DOWNREV        0x2
#define EXTORE_ERROR_CODE_MASK_EXTENSION2_NOT_FOUND      0x4
#define EXTORE_ERROR_CODE_MASK_EXTENSION2_DOWNREV        0x8
#define EXTORE_ERROR_CODE_MASK_MESSENGER_NOT_FOUND       0x10  // Chromy only
#define EXTORE_ERROR_CODE_MASK_MESSENGER_DOWNREV         0x20  // Chromy only
#define EXTORE_ERROR_CODE_MASK_IPC_PROFILE_CROSSTALK     0x40  // Chromy only
#define EXTORE_ERROR_CODE_MASK_IPC_PROFILE_NULL          0x80  // Chromy only
#define EXTORE_ERROR_CODE_MASK_EXTENSION2_ERRORS   (NSInteger)(EXTORE_ERROR_CODE_MASK_EXTENSION2_NOT_FOUND | EXTORE_ERROR_CODE_MASK_EXTENSION2_DOWNREV | EXTORE_ERROR_CODE_BASE)

#define EXTORE_ERROR_MAX_ADDON_ERROR                 0x2E5FF

#define EXTORE_ERROR_VERSION_NUMBERS_UNARCHIVE       0x2E700  // 190208
#define EXTORE_ERROR_VERSION_NUMBERS_MISSING         0x2E800  // 190464
#define EXTORE_ERROR_ADDON_NO_RESPONSE               0x2E900  // 190720

/* Adding the various extore error codes above to the error code base above
 may produce any of the following error codes, which are listed here for
 Project Find searches:
 
 189696 189697 189698 189699 189700 189701 189702 189703 189704 189705
 189706 189707 189708 189709 189710 189711 189712 189713 189714 189715
 189716 189717 189718 189719 189720 189721 189722 189723 189724 189725
 189726 189727 189728 189729 189730 189731 189732 189733 189734 189735
 189736 189737 189738 189739 189740 189741 189742 189743 189744 189745
 189746 189747 189748 189749 189750 189751 189752 189753 189754 189755
 189756 189757 189758 189759 189760 189761 189762 189763 189764 189765
 189766 189767 189768 189769 189770 189771 189772 189773 189774 189775
 189776 189777 189778 189779 189780 189781 189782 189783 189784 189785
 189786 189787 189788 189789 189790 189791 189792 189793 189794 189795
 189796 189797 189798 189799 189800 189801 189802 189803 189804 189805
 189806 189807 189808 189809 189810 189811 189812 189813 189814 189815
 189816 189817 189818 189819 189820 189821 189822 189823
 */

#define EXTORE_EXTENSION_VERSION_NOT_APPLICABLE -1
#define EXTORE_EXTENSION_VERSION_COULD_NOT_DETERMINE -2

#define USER_ACTION_WAITING 17
#define USER_ACTION_DONE 19

// The number of seconds to display the "BookMacster will now install an
// Extension into <Browser> dialog, and also the time allowed for the user 
// to approve the installation in <Browser>, before ending the sheet and
// just doing the export without installing the extension.
#define ADDON_INSTALL_TIMEOUT 40.0

@class Stark ;
@class Ixporter ;
@class Client ;
@class Clientoid;
@class ExtensionsMule ;
@class BkmxDoc ;
@class Starker ;
@class SSYProgressView ;
@class Exporter ;
@class SSYOperation ;
@class SSYInterappServer ;
@class SSYAlert ;
@class ExtensionsMule;
@class Tagger;

// Dictionary keys used in BkmxFileProperties dictionaries 
// which are used in more than one Extore subclass
// Subclasses may add their own.
extern NSString* const constKeyFileHeader ;    //  value is a NSString*  Used in OmniWeb and Opera.
extern NSString* const constKeyFileSubheader ; //  value is a NSString*  Used in OmniWeb and Opera.
extern NSString* const constKeyFileTrailer ;   //  value is a NSString*  Used in OmniWeb and Opera.

extern NSString* const constDisplayNameNotUsed ;

extern NSString* const constKeyMetaInfo ;
extern NSString* const constKeySyncTransactionVersion ;
/*
 Constants for holding display names of hard containers during an export
 */
extern NSString* const constKeyExtoreLabelOfBar ;
extern NSString* const constKeyExtoreLabelOfMenu ;
extern NSString* const constKeyExtoreLabelOfUnfiled ;
extern NSString* const constKeyExtoreLabelOfOhared ;

extern NSString* const constKeyGuid ;


struct ExtoreConstants_struct {
	BOOL canEditAddDate ;
	BkmxCanEditInStyle canEditComments ;
	BOOL canEditFavicon ;
	BOOL canEditFaviconUrl ;
	BOOL canEditIsAutoTab ;
	BOOL canEditIsExpanded ;
	BOOL canEditIsShared ;
	BOOL canEditLastChengDate ;
	BOOL canEditLastModifiedDate ;
	BOOL canEditLastVisitedDate ;
	BOOL canEditName ;
	BOOL canEditRating ;
	BOOL canEditRssArticles ;
    BkmxCanEditInStyle canEditSeparators ;
	BkmxCanEditInStyle canEditShortcut ;
	BkmxCanEditInStyle canEditTags ;
	BOOL canEditUrl ;
	BOOL canEditVisitCount ;
	BOOL canCreateNewDocuments ;
	NSString* ownerAppDisplayName ;
	NSString* webHostName ;
	BkmxAuthorizationMethod authorizationMethod ;
	NSString* accountNameHint ;
	NSString* oAuthConsumerKey ;
	NSString* oAuthConsumerSecret ;
	NSString* oAuthRequestTokenUrl ;
	NSString* oAuthRequestAccessUrl ;
	NSString* oAuthRealm ;
	NSString* appSupportRelativePath ;
	NSString* defaultFilename ;
	NSString* defaultProfileName ;
	NSString* iconResourceFilename ;
	NSString* iconInternetURL ;
	NSString* fileType ;
	OwnerAppObservability ownerAppObservability ;
	BOOL canPublicize ;
	BOOL silentlyRemovesDuplicates ;
	BOOL normalizesURLs ;
	BOOL catchesChangesDuringSave ;
	NSString* telltaleString ;
	BOOL hasBar ;
	BOOL hasMenu ;
	BOOL hasUnfiled ;
	BOOL hasOhared ;
	NSString* tagDelimiter ;
	BOOL dateRef1970Not2001 ;
	BOOL hasOrder ;
	BOOL hasFolders ;
	BOOL ownerAppIsLocalApp ;
	long long defaultSpecialOptions ;
	NSString* extensionInstallDirectory ;
	NSInteger minBrowserVersionMajor ;
	NSInteger minBrowserVersionMinor ;
	NSInteger minBrowserVersionBugFix ;
	NSInteger minSystemVersionForBrowsMajor ;
	NSInteger minSystemVersionForBrowsMinor ;
	NSInteger minSystemVersionForBrowsBugFix ;
} ;
typedef struct ExtoreConstants_struct ExtoreConstants ;

enum OwnerAppRunningState_enum {
    // We couldn't even discern if the owner app was running
    OwnerAppRunningStateError = -1,

	// Owner app is not running
    OwnerAppRunningStateNotRunning = 0,

	// Owner app is running, but the browser only makes one profile available
    // at a time, and this extore's profile is not that one at this time.
	OwnerAppRunningStateRunningProfileWrongOne = 1,

    // Owner app is running, and the browser can make multiple profiles available
    // simultaneously, but this extore's profile is not loaded at this time.
    OwnerAppRunningStateRunningProfileNotLoaded = 2,

	// Owner app is running, and this extore's profile is accessible.
    OwnerAppRunningStateRunningProfileAvailable = 4
} ;
typedef enum OwnerAppRunningState_enum OwnerAppRunningState ;

/*!
 @details  Indicates whether we have QUit, kIlled or lauNCHed the ower app
*/
enum OwnerAppQuinchState_enum {
	OwnerAppQuinchStateNone = 0,
	OwnerAppQuinchStateNeedsQuill = 1,
	OwnerAppQuinchStateDidQuill = 2,
    OwnerAppQuinchStateDidLaunch = 3
} ;
typedef enum OwnerAppQuinchState_enum OwnerAppQuinchState ;

enum ExtensionStatus_enum {
    ExtensionStatusUnknown           = -9, // Catch-all for states I've never seen
    ExtensionStatusBlacklisted       = -3,
    ExtensionStatusUnheardOf         = -2, // Probably not installed for any profile
    ExtensionStatusTrashed           = -1, // Chrome Prefs state=2.  Happens after clicking the relevant trash can icon in Chrome's Windows > Extensions
    ExtensionStatusInstalledDisabled =  0, // Chrome Prefs state=0.  In Chrome > Windows > Extensions, 'Enabled' checkbox OFF
    ExtensionStatusNoObjection       =  1, // No reference to us in Chrome Prefs.  If we are installed in External Extensions, we'll be 'Enabled' the next time that Chrome launches in this profile.
    ExtensionStatusInstalledEnabled  =  2  // Chrome Prefs state=1.  In Chrome > Windows > Extensions, 'Enabled' checkbox ON
    // See also Note 20131330
} ;
typedef enum ExtensionStatus_enum ExtensionStatus ;

/*!
 @brief    Reads/Writes bookmarks from/to an external store.

 @detail  */
__attribute__((visibility("default"))) @interface Extore : NSObject <Hartainertainer, Startainer, StarkReplicator, SSYErrorHandler, SSYInterappServerDelegate> {
    Clientoid* _clientoid;
	Ixporter* m_ixporter ; // weak The ixporter is the owner.
	
	NSMutableDictionary* m_fileProperties ;
	
	NSError* m_error ;
	OwnerAppQuinchState m_ownerAppQuinchState ;
	
	NSManagedObjectContext* transMoc ;
	NSManagedObjectContext* localMoc ;
	Starker* m_starker ; // more formally, this would be the transStarker
	Starker* m_localStarker ;	
    Tagger* m_tagger;
    Tagger* m_localTagger;

	NSTimer* m_timeoutter ;
	NSConditionLock* m_userActionWaitLock ;
	SSYAlert* m_addonInstallAlert ;
	SSYInterappServer* m_interappServer ;
	NSString* m_runningBundleIdentifier ;
    NSArray* m_hashableAttributes;
    NSIndexSet* m_exidAssignmentsToAvoid ;
    NSInteger m_ixportStyle;
}

#pragma mark * Class Methods

/*
 @brief    Returns the bundle identifiers which may be used by various verspdaions
 of the owner app, or nil if there are none
 */
+ (NSArray*)browserBundleIdentifiers ;

+ (NSString*)labelBar ;
+ (NSString*)labelMenu ;
+ (NSString*)labelUnfiled ;
+ (NSString*)labelOhared ;

+ (BOOL)canEditCommentsInStyle:(NSInteger)style;
+ (BOOL)canEditCommentsInAnyStyle;
+ (BOOL)canEditSeparatorsInStyle:(NSInteger)style;
+ (BOOL)canEditSeparatorsInAnyStyle;
- (BOOL)canEditSeparatorsInAnyStyle;
+ (BOOL)canEditShortcutInStyle:(NSInteger)style;
+ (BOOL)canEditShortcutInAnyStyle;
+ (BOOL)canEditTagsInStyle:(NSInteger)style;
+ (BOOL)canEditTagsInAnyStyle;
+ (BOOL)supportsMultipleProfiles;
+ (BOOL)supportsExids;

/*!
 @brief    Returns a pointer to a const struct of constants that define the
 workings of a particular Extore subclass.

 @details  Must be overridden by subclasses.  Default implementation
 raises an exception so do not invoke it.
 */
+ (const ExtoreConstants *)constants_p ;

+ (BOOL)canDetectOurChanges ;

/*!
 @brief    Returns whether or not a given parent sharype can exist in the
 receiver
 
 @details  Added in BookMacster 1.19.2.
*/
+ (BOOL)canHaveSharype:(Sharype)sharype ;

/*!
 @brief    Returns whether or not the receiver supports editing of a given
 attribute by BookMacster

 @details  Note that this method will return NO for constKeyOwnerValues,
 because ownerValues are always private to the owner only
 @param    key  The key of the relevant attribute.
*/
+ (BOOL)canEditAttribute:(NSString*)key
                 inStyle:(BkmxIxportStyle)style ;

+ (BOOL)liveRssAreImmutable ;

/*!
 @brief    Returns the constant tag delimiter for this extore's exformat
 @result   The tag delimiter, a 1-character string
 */
+ (NSString*)tagDelimiter ;

/*
 @brief    Replaces any -tagDelimiter characters in the string of any
 tag in a given sset of Tags with the app's default tag delimiter
 */
- (void)despoofTags:(NSSet*)tags;

/*!
 @brief    Parses a string and returns the tags found as an NSSet

 @details  This method is used in importing from browser/services
 that store tags as a string.  The tags in 'string' are assumed to
 be joined by the receiver's tagDelimiter, and any whitespace adjacent
 to the delimiters is ignored, as are empty strings or strings of
 whitespace only between consecutive delimiters.  Delimiter spoofs
 in the string must be removed or disallowed by design before invoking
 this method.
 @param    string  The string which is to be parsed for tags
 @result   The array of tags found, an empty array if 'string' is
 an empty string, or nil if 'string' is nil.
 */
+ (NSArray*)tagArrayFromString:(NSString*)string ;

/*!
 @brief    Returns a string containing the tags in a given array

 @details  This method is used in exporting to browser/services
 that store tags as a string.  The default implementation simply
 joins the strings in the given array with the receiver's
 tagDelimiter. The tags are not checked for delimiter spoofs.  Delimiter
 spoofs must be removed or disallowed by design before invoking this
 method.
 @param    array  The set of tags to be used in creating the string.
 Actually, this may be any set of NSString objects.
 @result   The string containing the tags, or an empty string
 if set is nil or empty.
 */
+ (NSString*)tagStringFromArray:(NSArray*)array ;

/*!
 @brief    Returns the Extore subclass for a given exformat 
 @param    exformat  The exformat (external format) for which the Extore
 subclass is desired.  Should be one of the members you get from either
 +[[BkmxBasis sharedBasis] supportedLocalAppExformatsIncludeNonClientable:] or
 +[[BkmxBasis sharedBasis] supportedWebAppExformatsIncludeNonClientable:].
 @result   A Class object
 */
+ (Class)extoreClassForExformat:(NSString*)exformat ;

/*!
 @details  If the name of the given class has less than 6
 characters, which will happen if it is not of the form
 "ExtoreXxxxx", or if the given class is nil, returns nil.
 Otherwise, returns the substring of the class' name starting at index 6.
*/
+ (NSString*)exformatForExtoreClass:(Class)class ;

+ (NSString*)baseNameFromClassName:(NSString*)className;
+ (NSString*)baseName;
/*!
 @brief    A name for displaying the exformat to the 
 user interface: window title bars, dialogs, AppleScript, etc.
 Usually, this is the same as the ownerApp.

 @details  The default implementation returns the relevant constant
 from the receiver's constants_p.&nbsp;  Subclasses should override
 if this value is not a constant.
 */
+ (NSString*)ownerAppDisplayName ;

/*!
 @brief    The name of the web host; i.e. "x.y.com" which is the
 external store for the class.
 */
+ (NSString*)webHostName ;

/*!
 @brief    Gets profile names for the current Mac user
 
 @details  Returns empty array if profiles cannot be read.  The default
 implementation also returns an empty array
 @result   The array of profile names, or an empty array
 */
+ (NSArray*)profileNames ;

+ (NSArray*)profilePseudonyms:(NSString*)homePath ;

/*!
 @brief    Gets path to profile folder for a given profile and Mac user, or nil
           if a failure occurs
 
 @details  The default implementation returns nil
 @param    homePath  The home path of the given Mac user
 @result   The array of profile names, or an empty array
 */
+ (NSString*)pathForProfileName:(NSString*)profileName
                       homePath:(NSString*)homePath
                        error_p:(NSError**)error_p ;

+ (NSString*)defaultProfileName ;

/*!
 @brief    Returns the filename of the receiver's owner app's
 bookmarks file, if the bookmarks are all in one file.&nbsp;  
 Otherwise, returns nil.
 
 @details  The default implementation returns the relevant constant
 from the receiver's constants_p.&nbsp;  Subclasses should override
 if this value is not a constant.
 */
+ (NSString*)defaultFilename ;

/*!
 @brief    Returns the path to the directory containing the receiver's
 owner app's bookmarks files, relative to the fileParentPathRelativeTo
 value in the receiver's constants_p, if such a directory exists.
 Otherwise, returns nil.
 
 @details  The default implementation returns an "internal error" string.
 Subclasses must override.  Web apps may return a URL.  In some cases, an
 empty string is appropriate.
 */
+ (NSString*)fileParentRelativePath ;

+ (NSString*)extraBrowserSupportPathForSpecialManifest;

/*!
 @brief    Returns the path to the directory containing the receiver's
 owner app's bookmarks files, relative to the fileParentPathRelativeTo
 value in the receiver's constants_p, if such a directory exists.&nbsp;  
 Otherwise, returns nil.
 
 @details  The default implementation returns PathRelativeToApplicationSupport
 which is the most common.  Most subclasses should override.
 */
+ (PathRelativeTo)fileParentPathRelativeTo ;

/*!
 @brief    Returns the name of the Special Settings nib file whichF
 should be loaded in the Client Info View for a Client which has
 an Extore of the receiver's class

 @details  The default implementation replaces the "Extore" prefix
 on the class name with "Special" and returns the resulting string.
 Subclasses may override so that common Special nib files may be
 used for different Extore subclasses.
*/
+ (NSString*)specialNibName ;

/*!
 @brief    Returns a multiplier which increases or decreases the
 range of the http initial rates available in the
 "Special Options" section of the receiver's nib.

 @details  The default implementation returns 1.0.  Subclasses
 should override if desired.
*/
+ (CGFloat)multiplierForHttpHighRateInitial ;

#if 0
// This is not being used because it's too slow, and also the scripts
// require System Events, which requires Access For Assisitive Devices
// to be enabled.
/*!
 @brief    Returns a dictionary containing information about the web page
 currently being viewed in the receiver's ownerApp.

 @details  The record contains a key constKeyUrl, and may also contain
 constKeyName and/or constKeyComments.
*/
+ (NSDictionary*)browmarkInfo ;
#endif

/*!
 @brief    Returns the full path to the receiver's owner app (i.e. the .app)
 if the receiver's ownerAppIsLocalApp and it can be found via its bundle
 identifier.  Otherwise, returns nil.
*/
+ (NSString*)ownerAppLocalPath ;

+ (OwnerAppObservability)ownerAppObservability ;

+ (BOOL)isLiveObservability:(OwnerAppObservability)observability ;

+ (BOOL)canDoLiveObservability ;

+ (Sharype)fosterSharypeForSharype:(Sharype)sharype ;

- (Stark*)fosterParentForStark:(Stark*)stark ;

/*!
 @brief    Compares a given client task using given styles to the
 receiver's tolerance and returns whether or not the given task in
 the given style can be performed without quitting the receiver's
 owner app if it is running.
*/
+ (BOOL)toleratesClientTask:(BkmxClientTask)clientTask
                 usingStyle:(BkmxIxportStyle)ixportStyle ;

- (NSInteger)indexOffsetForRoot ;

/*!
 @brief    Same as the class method, except uses additional information only
 available in the instance.
 
 @details  The default implementation simply invokes the class method.
 */
- (BOOL)toleratesClientTask:(BkmxClientTask)clientTask ;

/*!
 @brief    Returns a sum of BkmxIxportTolerance enumerated values
 which are allowed to be performed on the receiver's owner app
 without quitting it if running, for a given style.

 @details  The default implementation returns BkmxIxportToleranceAllowsNone,
 which is OK for a few subclasses.  Most subclasses should override.
 
 For defensive programming, implementation should return
 BkmxIxportToleranceAllowsNone if the given ixportStyle is 0.
 (This may be used for installing extensions.)
*/
+ (BkmxIxportTolerance)toleranceForIxportStyle:(NSInteger)ixportStyle ;

- (BkmxIxportLaunchBrowserPreference)launchBrowserPreference ;

+ (BOOL)profileStuffMayBeInstalledInParentFolder;
+ (BOOL)style1Available;
- (BOOL)style1Available;

- (NSString*)installExtensionPromptForExtensionIndex:(NSInteger)extensionIndex ;

/*!
 @brief    Should examine the two collections passed in and return NO if
 there is no substantive difference between them.
 
 @details  May be implemented by subclasses to return NO in classes where the
 extore may notify us of changes which we just exported.  Such an implementation
 would reduce churn.  The default implementation returns YES.
 
 I'm not sure why I've implemented this only for ExtoreChromy, and in
 particular not for ExtoreFirefox.  Maybe it is only needed due to Limbo.
 But maybe it's not needed for ExtoreChromy now either, because I think I no
 longer use Limbo in the Chrome extension.
 */
+ (BOOL)detectedChanges:(NSArray*)detectedChanges
  notInExportedChanges:(NSDictionary*)exportedChanges ;

/*!
 @brief    Returns the profile name seen by the user for a given profile
 
 @details  The default implementation returns the given profile, which is
 correct for Firefox.  This method is for overriding by ExtoreChromy.
 */
+ (NSString*)displayProfileNameForProfileName:(NSString*)profileName ;

/*!
 @brief    If conditions in the web browser are such that the user needs
 to know a profile name, returns @" (<nameAsRecognizedByUser>)"; otherwise,
 returns an empty string
 
 @details  <nameAsRecognizedByUser> is a "display name", as opposed to an
 under-the-hood identifier, in case these are different.
 */
+ (NSString*)displayedSuffixForProfileName:(NSString*)profileName
                                  homePath:(NSString*)homePath ;

+ (NSString*)frontmostProfileInOwnerApp ;

+ (NSString*)browserExtensionPortNameForProfileName:(NSString*)profileName ;


#pragma mark * Accessors

@property (atomic, copy) Clientoid* clientoid;
@property (retain) Ixporter* ixporter;
@property (assign) NSInteger jobSerial;
@property (assign) OwnerAppQuinchState ownerAppQuinchState ;
@property (readonly) NSMutableDictionary* fileProperties ;
@property (copy, readonly) NSString* runningBundleIdentifier ;
// Must be atomic since it is accessed from multiple threads;
@property (retain) NSConditionLock* userActionWaitLock ;
@property (retain) NSIndexSet* exidAssignmentsToAvoid ;
@property (assign) NSInteger ixportStyle;

- (void)updateOwnerAppQuinchState:(OwnerAppQuinchState)newState ;

- (Client*)client ;

- (NSString*)extoreMedia;

- (NSString*)filePathError_p:(NSError**)error_p;

/*!
 @brief    Returns the receiver's ixporter's client's macster's bkmxDoc.
 */
- (BkmxDoc*)bkmxDoc ;

/*!
 @brief    The receiver's error object
 
 @details  The receiver's error object is a convenience for methods in the
 class to communicate errors to one another, without having to 
 pass around an NSError** argument.  It should be set to nil at the
 beginning of a task.  Since it is a declared property, conformers of
 this protocol may implement it simply by @synthesize error ;
 
 Warning: This is accessed from multiple threads, and probably needs
 to be 'atomic'.  Don't make it 'nonatomic'.
 */
@property (retain) NSError* error ;

/*!
 @brief    

 @details
 From "Timer Programming Topics": "…a timer … maintains a strong
 reference to its target. This means that as long as a timer remains
 valid (and you otherwise properly abide by memory management rules),
 its target will not be deallocated. As a corollary, this means that
 it does not make sense for a timer’s target to try to invalidate the
 timer in its dealloc or finalize method—neither method will be
 invoked as long as the timer is valid. 
*/
@property (nonatomic, assign) NSTimer* timeoutter ;

/*
 @brief    An in-memory, <i>transient</i> or <i>transfer</i> managed
 object context, structured like the external store, used during
 ixports, short-lived

 @details  If the instance variable transMoc is nil, a
 new managed object context is created and immediately
 loaded by reading from the external store.
 
 The container structure of the items in the moc is
 that of the external store.
 */
@property (readonly) NSManagedObjectContext*  transMoc ;

/*
 @brief    A sqlite managed object context used to hold Starks
 which mirror those in a not-always-accessible external store,
 typically a web app client

 @details  This is used by web extores whose
 external store is not always available, and/or whose API
 requires that we keep a local copy.
 
 This moc thus holds items only permanently, and therefore
 it uses an sqlite store on the hard drive provided by 
 SSYMOCManager. 
 */
@property (readonly) NSManagedObjectContext*  localMoc ;

/*
 @brief    The receiver's starker, a wrapper around its transMoc
 */
@property (retain, readonly) Starker* starker ;

@property (retain, readonly) Tagger* tagger;
@property (retain, readonly) Tagger* localTagger;

/*
 @brief    The receiver's localStarker, a wrapper around its localMoc. 
 */
@property (retain, readonly) Starker*  localStarker ;

/*
 @brief    A shortcut to the progressView of the main window of the
 receiver's owning BkmxDoc.
 */
@property (readonly) SSYProgressView* progressView ;

@property (assign, nonatomic) SSYInterappServer* interappServer ;

- (void)unleaseInterappServer ;

#pragma mark * Store Constants

/*!
 @brief    Returns a pointer to the all-important struct of constants
 that define the behavior for any particular subclass.

 @details  Simply forwards the message to the class object.
*/
- (const ExtoreConstants*)extoreConstants_p ;


/*!
 @brief    Returns the number of seconds after an export which the browser
 should be left running before quitting, in order to push changes through
 its sync service for example
 
 @details  The default implementation returns 0.0.
 */
- (NSTimeInterval)quitHoldTime ;

/*!
 @brief    Returns whether or not the receiver's Extore can
 create a new, empty document in its browser's file format
 and later save it to the hard disk.
 */
- (BOOL)canCreateNewDocuments ;

/*!
 @brief    Returns the authorization method used to access the
 user's data.
 
 @details  The default implementation returns BkmxAuthorizationMethodNone.
 Subclasses requiring authorization should override this method.
 */
- (BkmxAuthorizationMethod)authorizationMethod ;

/*!
 @brief    Returns [[self class] ownerAppDisplayName].
 */
- (NSString*)ownerAppDisplayName ;

/*!
 @brief    Returns the default profile name for the receiver's ownerApp,
 or nil if the receiver's ownerApp does not use profiles.
 */
- (NSString*)defaultProfileName ;

- (BOOL)canHaveProfileCrosstalk ;

- (NSString*)localIdentifier ;

/*!
 @brief    Returns the current OwnerAppRunningState of the receiver's owner app,
 without regard to profile name
 
 @details  Returns OwnerAppRunningStateRunningProfileAvailable if the owner app
 is running, and OwnerAppRunningStateNotRunning if the ower app is not running.
 */
+ (OwnerAppRunningState)ownerAppRunningStateError_p:(NSError**)error_p ;

- (BOOL)ownerAppIsRunningError_p:(NSError**)error_p ;

/*!
 @brief    Returns the current OwnerAppRunningState of the receiver's owner app
 relative to the receiver's client's clientoid's profileName
 
 @details  The default implementation returns the result from the class method
 of the same name.
 @result   The running state, or OwnerAppRunningStateError if an error occurs
 @param    error_p  If this method returns OwnerAppRunningStateError, on return,
 will point to an NSError object encapsulating the error.
 */
- (OwnerAppRunningState)ownerAppRunningStateError_p:(NSError**)error_p ;

+ (NSString*)extension1Uuid ;
+ (NSString*)extension2Uuid ;

/*!
 @brief    Computes an error, or nil, given the installed extension version(s)
 and profile returned from the extension

 @result   nil if no error; otherwise an error object whose code is code based
 on EXTORE_ERROR_CODE_BASE which is a composite of all errors detected
*/
- (NSError*)errorForExtension1Version:(NSInteger)extension1Version
                    extension2Version:(NSInteger)extension2Version
                      receivedProfile:(NSString*)receivedProfile ;

/*!
 @brief    Packages extension test results into a dictionary

 @details  The first three parameters should be passed as 0 if the addon is
 available but not installed, -1 if the addon is not applicable to the receiver.
 @param    error An error indicating how, if the test failed,
 or nil if the test succeeded.  If not nil, this error will
 be passed through to the result without computing whether
 or not there is an error due to version numbers.
 @result   A dictionary containing 0-4 keys.  
 Otherwise, possible entries are:
 * constKeyExtension1Version  NSNumber whose integerValue indicates
 the extensionVersion which was passed in, unless this was <= 0.
 * constKeyExtension2Version  NSNumber whose integerValue indicates
 the extensionVersion which was passed in, unless this was <= 0.
 * constKeyError  Any error that was passed into this method via
 the 'error' parameter, or if that was nil but an error is indicated by the
 other parameters, an error of the form generated by
 errorForExtensionVersion1:extensionVersion2:receivedProfile:
 
 If the receiver does not support an addon, the result will be nil.
 */
- (NSDictionary*)processedExtension1Version:(NSInteger)extension1Version
                          extension2Version:(NSInteger)extension2Version
                            receivedProfile:(NSString*)receivedProfile
                                      error:(NSError*)error ;

/*!
 @brief    Gets the versions of the owner app's addons
 (extension and messenger) versions from the disk, without testing whether or
 not they are operational.

 @details  The default implementation returns nil.
 Subclasses with addons should override this method by first
 reading the required data from the disk and then computing the
 result using processedExtension1Version::::::.
 
 @result   Same as result for processedExtension1Version::::::.
*/
- (NSDictionary*)peekExtension ;

/*!
 @brief    Returns whether or not Extension 1 appears to be installed in the
 receiver's owner app for the receiver's profile
 
 @details  Uses -peekExtension.
 */
- (BOOL)extension1Installed ;

/*!
 @brief    Returns the idiom by which receiver's owner app might
 be able to return information on the current web page it is
 displaying

 @details  The default implementation returns BkmxGrabPageIdiomNone.
 Subclasses which can peek page should override.
*/
+ (BkmxGrabPageIdiom)peekPageIdiom ;

/*!
 @brief    Sends an interapplication message to the owner app's
 addon and then sends an appropriate callback.

 @details  The callback sent depends on the test result and the
 given callbackee.
 @param    mule  The object which will receive any callbacks
 which occur
*/
- (void)testExtensionForMule:(ExtensionsMule*)mule ;

/*!
 @brief    Returns the minimum version of a browser extension
 required by the receiver.
 
 @details  Default implementation returns 0.
 
 This number is typically compared with the version
 of the browser extension.  If the version of the browser extension
 does not meet this minimum requirement, an error is typically 
 produced which typically causes the extension to be reinstalled.
 
 For Chrome, the version of the browser extensions is set in the
 manifest.json file, prior to packing the extensions.
 */
- (NSInteger)minVersionForExtensionIndex:(NSInteger)extensionIndex ;

+ (NSInteger)minVersionForMessenger ;

/*!
 @brief    Display names shown in Manage Browser Extensions window
*/
- (NSString*)extension1BriefDescription ;
- (NSString*)extension2BriefDescription ;

- (NSString*)extensionDisplayNameForExtensionIndex:(NSInteger)extensionIndex ;

- (NSString*)uninstallInstructionsForExtensionIndex:(NSInteger)extensionIndex ;
- (NSString*)uninstallHelpAnchorForExtensionIndex:(NSInteger)extensionIndex ;

/*!
 @details  Default implementation returns nil, which indicates that the empty
 extore resource file is not zipped.  Subclasses which have a 10 MB
 empty extore file which is 99% compressible (you know who you are, Firefox)
 should override this method.
 */
- (NSString*)emptyExtoreResourceFilenameAfterUnzipping ;

/*!
 @brief    Returns whether or not the receiver's ownerApp 
 has a permanent collection called a "Bookmarks Bar",
 "Bookmarks Toolbar" or equivalent.
 
 @details  Default implementation returns the value of the
 constant of the same name in the receiver's extoreConstants.
 */
- (BOOL)hasBar ;

/*!
 @brief    Returns whether or not the receiver's starker 
 has a permanent collection called a "Bookmarks Menu"
 
 @details  Default implementation returns the value of the
 constant of the same name in the receiver's extoreConstants.
 */
- (BOOL)hasMenu ;

+ (BOOL)thisUserHasMenu;

+ (BOOL)thisUserHasUnfiled ;

/*!
 @brief    Returns whether or not the receiver's starker 
 has a permanent collection designated for "Unfiled" bookmarks
 
 @details  Default implementation returns the value of the
 constant of the same name in the receiver's extoreConstants.
 */
- (BOOL)hasUnfiled ;

/*!
 @brief    Returns whether or not the receiver's starker 
 has a permanent collection designated for "Shared" bookmarks.
  
 @details  Default implementation returns the value of the
 constant of the same name in the receiver's extoreConstants.
 Do not confuse this with the capacity of a web
 service external store to set individual bookmarks "shared"
 or "private".
 */
- (BOOL)hasOhared ;

/* See other comments marked by NoteRareMissingSafariHartainer. */
- (Sharype)mustHaveBarInFile;
- (Sharype)mustHaveMenuInFile;
- (Sharype)mustHaveUnfiledInFile;
- (Sharype)mustHaveOharedInFile;

/*!
 @brief    Returns whether or not the receiver's ownerApp 
 silently removes duplicate bookmarks that are written to it.
 */
- (BOOL)silentlyRemovesDuplicates ;

- (BOOL)shouldCheckAggregateExids ;

+ (BOOL)rootSoftainersOk ;
+ (BOOL)rootLeavesOk ;
+ (BOOL)rootNotchesOk ;
- (BOOL)rootSoftainersOk ;
- (BOOL)rootLeavesOk ;
- (BOOL)rootNotchesOk ;

/*!
 @brief    Returns whether or not the receiver's ownerApp 
 normalizese URLs that are written to it.
 */
- (BOOL)normalizesURLs ;

/*!
 @brief    Returns whether or not the receiver's BkmxDoc will
 increment its change count if changes are made in this application
 during execution of a Sync Out command.
 */
- (BOOL)catchesChangesDuringSave ;

/*!
 @brief    Returns an array of NSNumbers representing the Sharypes of
 the hartainers which the receiver's ownerApp supports.
 
 @detail   We use an array instead of a set so this can be bound as the
 content of popup menus.
 */
+ (NSArray*)availableHartainers ;

/*!
 @brief    Returns YES is the receiver's extore stores
 dates relative to the unix 1970 reference and NO if it stores
 dates relative to the Macintosh 2001 reference.
 */
- (BOOL)dateRef1970Not2001 ;

/*!
 @brief    Returns YES if the receiver's ownerApp is
 a desktop application and NO if it is a web application.
 */
- (BOOL)ownerAppIsLocalApp ;

- (NSString*)ownerAppLocalPath ;

/*!
 @brief    Localizes the names of the hard containers (hartainers)
 in the receiver.

 @details    This is necessary when creating a new empty file
 because the empty file resources in the BookMacster package are
 not localized, if the receiver's subclass stores the hartainer
 names that the user sees in its bookmarks file.&nbsp;  Most
 Extore subclasses do not do this, and in that case they may
 use the default implementation which is a no-op.
*/
- (void)localizeHartainers ;

- (NSString*)browserBundlePath ;

- (NSBundle*)browserBundle ;

/*!
 @brief    Returns a short string, formatted as a table, which shows the
 different names used by different extores for a given stark attribute.

 @details  This string is designed to be used in a tooltip.
 @param    key  The attribute for which the names are desired.
*/
+ (NSString*)legendForKey:(NSString*)key ;


#pragma mark * Basic Infrastructure

/*!
 @brief    Designated Initializer

 @details  Do not send this message to Extore because the Extore class
 is useless.  Send it to a subclass of Extore.

 @param    ixporter  The owning Ixporter, kept as a weak
 reference by the receiver.  The owner of this will in turn
 be the BkmxDoc which is used as the source of starks
 during an export, and also its progressView is sent
 progress messages during ixports.
 */
- (id) initWithIxporter:(Ixporter*)ixporter
              clientoid:(Clientoid*)clientoid
              jobSerial:(NSInteger)jobSerial;

/*!
 @brief    Convenience method for returning an autoreleased extore
 of the subclass given by a given ixporter's client's -extoreClass,
 with that client set as an instance variable.
 
 @param    ixporter  The ixporter whose bkmxDoc will get progress messages
 during ixports.
 */
+ (Extore*)extoreForIxporter:(Ixporter*)ixporter
                   clientoid:(Clientoid*)clientoid
                   jobSerial:(NSInteger)jobSerial
					 error_p:(NSError**)error_p ;
	
+ (BOOL)syncExtensionAvailable ;

+ (BOOL)hasProprietarySyncThatNeedsOwnerAppRunning;

+ (BOOL)requiresStyle2WhenProprietarySyncIsActive;

/*!
 @brief    Returns whether or not the receiver's extension supports a given
 purpose, or NO if we don't have an extension for the receiver

 @details  The default implementation returns NO.  Subclasses may override.
 @param    purpose  An integer from among the constExtensibilityXxxxx values
*/
+ (BOOL)addonSupportsPurpose:(NSInteger)purpose ;

+ (void)cleanExcessSyncSnapshots ;
+ (void)ensureSpaceForMoreSyncSnapshots;
- (NSInteger)countOfRecentSnapshotsAvailable ;

#pragma mark * Other Methods

- (BOOL)isSyncActiveError_p:(NSError**)error_p ;

/*!
 @brief    Returns the result of the class method +addonSupportsPurpose:
 for a given purpose

 @details  Subclasses should not override this method.  Override the class
 method instead.
*/
- (BOOL)syncExtensionAvailable ;

/*!
 @brief    Returns a user-facing string which explains how the receiver's
 owner should update our Sync Extension installed in it automatically.
 
 @details  If the owner does not update the Sync Extension automtaically and
 we instead keep it updating by directing the user to reinstall, signify this
 by returning nil.  The default implementation returns nil.
 */
- (NSString*)messageHowToForceAutoUpdateExtensionIndex:(NSInteger)extensionIndex ;

- (BOOL)getTextForRemovalOfLegacyHartainer:(Sharype)sharype
                                   title_p:(NSString**)title_p
                                subtitle_p:(NSString**)subtitle_p
                                    body_p:(NSString**)body_p
                          helpBookAnchor_p:(NSString**)helpBookAnchor_p;

- (NSString*)doPostExportTasksAndGetMessageToUserForChangeCounts:(SSYModelChangeCounts)changeCounts;

- (BOOL)addonSupportsPurpose:(NSInteger)purpose ;

/*!
 @brief    Returns whether starks should be actually be deleted from
 the receiver's local starker before (YES) or after (NO) the actual
 export operation, for a given export style

 @details  The default implementation returns YES for export style 1
 and NO for export style 2.  Subclasses may override.
 
 Here is the thinking behind the default implementation…
 
 In most cases, Write Style 1 simply overwrites the external file
 without even looking at it.  It does not look at the
 [chaker stanges] and does not need deleted starks at all.

 In the case of ExtoreFirefox and ExtoreWebFlat, Write
 Style 1 *does* not simply overwrite the external file; it
 essentially does *another* merge.  This is a legacy from
 Bookdog.  If I were to rewrite these methods today, I
 would not do another merge but would do sqlite or HTTP
 transactions based on the changes.  However, the way they
 work now, the recognize deletions by their absence.
 
 So, in both of these cases, for Write Style 1, we want to
 delete first, then export; hence we return YES.
 
 Write Style 2 iterates through the stark
 changes (stanges) and exports changes only via the API.
 For this style, during -writeUsingStyle2InOperation:, we will
 need to access many properties of the deleted starks as
 we prepare the information for deleting in the actual extore.
 So, for Write Style 2, we want to export first, then delete;
 hence we return NO.
*/
- (BOOL)shouldActuallyDeleteBeforeWrite ;

/*!
 @brief    If constKeySyncSnapshots in user defaults is > 0, deletes
 oldest snapshot(s) to make room for one new one and returns the path
 including filename for writing a sync snapshot file with a given label;
 otherwise does nothing and returns nil
*/
- (NSString*)prepareNextSnapshotPathWithLabel:(NSString*)label ;

/*!
 @brief    Returns the receiver's client's filePath
 
 @details  This method should be used to access the
 receiver's external bookmarks during Import and Export.
 It is not used by the base class but is provided for
 subclasses.
 
 @param    error_p  If non-NULL, and if an error occurs,
 will point to the error upon exit
 @result   YES if the operation succeeds; otherwise NO.
 */
- (NSString*)workingFilePathError_p:(NSError**)error_p ;
 
- (BOOL)ensureFilesGetSuffixes_p:(NSSet**)suffixes_p
                         error_p:(NSError**)error_p ;

/*!
 @brief    Sends a callback message; handy for asynchronous calls

 @details  Extracts from the given info dictionary values for
 keys constKeyIsDoneTarget and constKeyIsDoneSelectorName.
 Creates a selector from the latter, and sends this message to
 the former, with the given info dictionary as a single parameter.
 That is, the signature of the isDone selector should take a
 single parameter, an NSDictionary.
 
 Does not add the constKeySucceeded message to info.  If success,
 you need to do that before invoking this method.
 
 @param    info  The dictionary containing the two keys which
 will be used to construct the message.  Also, this is the dictionary
 which will be sent as the parameter in the message.
*/
- (void)sendIsDoneMessageFromInfo:(NSMutableDictionary*)info;

+ (void)sendIsDoneMessageFromInfo:(NSMutableDictionary*)info
                            error:(NSError*)error;

- (void)tearDownFor:(NSString*)caller
          jobSerial:(NSInteger)jobSerial;

- (NSString*)runningBundlePath ;

/*!
 @brief    Returns the URL to an installer which will install an extension into
 the owner app

 @details  Must be implemented by any subclass for which +syncExtensionAvailable
 or -syncExtensionAvailable return YES.  The default implementation returns nil.
 The URL returned may be either a file or internet URL.
*/
+ (NSURL*)sourceUrlForExtensionIndex:(NSInteger)extensionIndex ;

/*!
 @brief    Attempts to kill the receiver's browser, if any
 
 @result   YES if the operation succeeds, otherwise NO.
 */
- (BOOL)killBrowser ;

/*!
 @brief    Quits the receiver's owner app if it is running, and blocks until it
 is really no longer running

 @details  
 @param    wasRunning_p  If not nil, on return, will point to a value
 indicating whether or not the target app was indeed running and needed
 to be quit, or NO if the given bundle path was nil
 @result   YES if the app was not running to begin with or if quitting was
 successful, otherwise NO
*/
- (BOOL)quitOwnerAppWithTimeout:(NSTimeInterval)timeout
                  preferredPath:(NSString*)preferredPath
			   killAfterTimeout:(BOOL)killAfterTimeout
				   wasRunning_p:(BOOL*)wasRunning_p
                  pathQuilled_p:(NSString**)pathQuilled_p
						error_p:(NSError**)error_p ;

- (BOOL)quitOwnerAppCleanlyWithProgressView:(SSYProgressView*)progressView
                              pathQuilled_p:(NSString**)pathQuilled_p
									error_p:(NSError**)error_p ;

- (BOOL)quitOwnerAppCleanlyForOperation:(SSYOperation*)info
                                error_p:(NSError**)error_p ;

- (NSString*)messagePleaseActivateThisProfile ;

- (void)preinstallExtensionIndex:(NSInteger)extensionIndex
                      hostWindow:(NSWindow*)hostWindow
               completionHandler:(void(^)(
                                          NSError* error
                                          ))completionHandler;

/*!
 @brief    Method which does the actual work of installing a browser extension
           into the receiver's owner app

 @details  Subclasses with browser extensions must override.  The 
           default implementation simply returns YES.
 @param    index  Pass either 1 or 2 to specify which extension to install
 @param    hostWindow  Window on which to place sheet
*/
- (void)installExtensionIndex:(NSInteger)extensionIndex
                   hostWindow:(NSWindow*)hostWindow
                         mule:(ExtensionsMule*)mule;

/*!
 @brief    Method which does the actual work of installing our browser Messenger
 into the receiver's owner app
 
 @details  The default implementation is a no-op that returns YES.
 @param    error_p  If not NULL and if an error occurs, upon return,
 will point to an error object encapsulating the error.
 @result   YES if the method completed successfully, otherwise NO
 */
- (BOOL)installMessengerError_p:(NSError**)error_p ;


/*!
 @brief    Unceremoniously quits the receiver's owner app if it is running, and 
 then relaunches it, in such a way that the profile of the receiver will be
 frontmost.

 @details  The unceremonious quitting is a fail-safe.  Before invoking this
 method, you should have already checked to see if the owner app was running,
 and if so, asked the user's permission to quit it.
 
 The default implementation doesn't consider user profile.
 Apps which can be launched in different profiles should override.

 @param    path  The path to the application, in case there is more than one
 installed.  If nil, whatever path is given by Launch Services will for the
 owner app's bundle will be used (Good luck!).
 @param    activate  If the specified application is not already launched, the
 newly-launched application is activated if YES, and if NO is not activated.
 If the specified application is already launched, this parameter is ignored
 and the application is activated.
 @param    error_p  If not NULL and if an error occurs, upon return, will point
 to an error object encapsulating the error.
 @result   The full path to the application which was launched, or nil if an
 error occurred.
*/
- (NSString*)launchOwnerAppPath:(NSString*)path
                       activate:(BOOL)activate
                        error_p:(NSError**)error_p ;

/*!
 @brief    Adds more information to to an error if possible.

 @details  Specific error domains and error code combinations
 may be supported.
*/
- (void)clarifyErrorForRequest:(NSString*)subpathQuery
				  receivedData:(NSData*)data ;

/*!
 @brief    Returns whether or not the store's local managed object
 context exists in the hard disk.

 @details  You must use this to determine file existence, because
 the -localMoc accessor will create one of none exists.
*/
- (BOOL)localMocExists ;

/*!
 @brief    Determines whether or not the receiver can probably
 import given data from a given file type.&nbsp; This method
 is no longer used.

 @details  Subclasses should override.  The default implementation
 returns NO.
 @param    type  The document type, in the context of NSOpenPanel,
 which means the filename extension, without the "dot".

 @param    data  The data in the file
 @result   YES if it is probable, NO if impossible
*/
+ (BOOL)canProbablyImportFileType:type
								  data:data ;

/*!
 @brief    Checks whether a given exid is valid for a given star,

 @details  Needed for OmniWeb, in case the stark was moved among
 bar, menu or ohared, it will need a new unique exid.
 
 @param    isAfterExport  Advises if this is before or after an
 export, which matters to some clients (Shiira).
 
 The default implementation returns YES.
*/
- (BOOL)validateExid:(NSString*)exid
	   isAfterExport:(BOOL)isAfterExport
			forStark:(Stark*)stark ;

/*!
 @brief    Returns whether or not the receiver's external store
 will accept a given stark

 @details  This is used during exporting.  The default implementation returns
 NO for any any bookmark that should not be exported to *any* browser,
 otherwise YES.  Subclasses may override, returning NO if super returns NO,
 and imposing additional tests if super returns YES.
 
 @param    withChanges  A dictionary, which if it contains a value for
 constKeySSYChangedKey, the value key constKeyNewValue will
 be used instead of the existing property value when determining
 exportability.  This is useful for simulating a hypothetical future change.
*/
- (BOOL)isExportableStark:(Stark*)stark
			   withChange:(NSDictionary*)change ;

/*!
 @brief    Returns whether or not a given stark should be exported by the
 receiver
 
 @details  Returns NO if any of…
 * NO is returned by -[isExportableStark:withChange:]
 * stark is a separator and receiver's skipSeparators is YES
 * stark's url is a fileUrl and receiver's skipFileUrls is YES
 * stark's url is JavaScript and receiver's skipJavaScript is YES
 * stark is an RSS feed and receiver's skipRssFeeds is YES
 * stark's dontExportTo exformats includes the receiver's exformat
 Otherwise, returns YES.
 
 @param    withChanges  A dictionary, which if it contains a value for
 constKeySSYChangedKey, the value key constKeyNewValue will
 be used instead of the existing property value when determining
 exportability.  This is useful for simulating a hypothetical future change.
 */
- (BOOL)shouldExportStark:(Stark*)stark
			   withChange:(NSDictionary*)change;

/*!
 @brief    Computes the cheesy exid for a given stark

 @details  Subclasses which use cheesy exids must override this method.
 The default implementation logs an internal error and returns nil
*/
- (NSString*)cheesyExidForStark:(Stark*)stark ;

/*!
 @brief    Gets a new and different stark exid for a stark
 which is unique among the receiver's starks.

 @details  The default implementation gets the next UUID using CFUUID,
 with dashes in it.  This is appropriate for Safari and Camino.
 Subclasses for which this is not appropriate should override.
 @param    exid_p  On exit, either a pointer to a fresh exid, or a pointer
 to nil, depending on whether a fresh exid was obtained.
 @param    higherThan  For extores which assign exids as (sequential)
 serial numbers, a number which the returned exid's value will
 exceed.  If the receiver's exids are uuid instead of serial numbers,
 this parameter is ignored.  If you don't have a higherThan
 requirement, pass 0.
 @param    stark  The stark for which the fresh exid is desired.
 Most stores ignore this parameter.
 @param    tryHard  If getting a fresh exid would be costly,
 such as having to contact a remote server, tryHard tells the method
 whether or not to do that.
 */
- (void)getFreshExid_p:(NSString**)exid_p
            higherThan:(NSInteger)higherThan
              forStark:(Stark*)stark
               tryHard:(BOOL)tryHard ;

/*!
 @brief    Attempts to get the last date that the external store was touched,
 according to externally-derived data, and returns YES if successful.

 @details   Default implementation get the most recent file modification
 date of [self filePathError_p:], or the current date if this can't be obtained,
 and always returns YES.&nbsp; This works for the most common case, which is
 if the owning browser is a local app (as opposed to a web app) that also
 stores bookmarks in a single file.&nbsp; In other cases, or if for any
 reason this date is nil, returns the current date.
 
 Subclasses should override if an owning web app provides such a date,
 or if bookmarks are stored in more than one file, as with OmniWeb.
 
 If an error occurs, subclass implementations should set *date_p to nil
 and return NO.
*/
- (BOOL)getExternallyDerivedLastKnownTouch:(NSDate**)date_p ;

- (void)readExternalUsingCurrentStyleWithPolarity:(BkmxIxportPolarity)polarity
                                        jobSerial:(NSInteger)jobSerial
                                completionHandler:(void(^)(void))completionHandler;
/*!
 @brief    Returns the last date that the external store was possibly modified.
 
 @details  The result can/should be used to determine if import
 is necessary, and also if a file conflict has occurred.
 
 Algorithmically, this method returns the latest of the possible three dates:
 *   self.externallyDerivedLastKnownTouch
 *   self.client.lastKnownTouch
 *   Client's lastExported from User Defaults
 or, if none of these three dates exists, returns the current date.
 */
- (NSDate*)lastDateExternalWasTouched ;

- (void)readExternalStyle2WithCompletionHandler:(void(^)(void))completionHandler;

/*!
 @brief    Gets bookmarks data from the external store and writes Starks to
 the receiver's transMoc and to its localMoc (the latter only if this extore
 uses it), assuming prerequisites have already been verified.
 
 @details  Sets the receiver's error if any user cancels
 or if anything else which should abort related operations fails.

 The default implementation logs an internal error.
 Subclasses must override.

 @param    completionHandler  A block which will be invoked after the receiver
 has completed all work, regardless of whether or not an error occurred.
 */
- (void)readExternalStyle1ForPolarity:(BkmxIxportPolarity)polarity
                    completionHandler:(void(^)(void))completionHandler;

/*!
 @brief    Concrete subclasses may override this method to do any
 special mapping to the starks in the transMoc during an Import.
 
 @details  This is invoked during importing of bookmarks, after
 -readExternalStyle1ForPolarity::.  The default implementation is a no-op.
 */
- (void)doSpecialMappingAfterImport ;

/*!
 @brief    Concrete subclasses may override this method to do any
 special mapping to the starks in the transMoc during an Export.
 
 @details  This is invoked during exporting of bookmarks, before
 -writeUsingStyle1InOperation:.  The default implementation is a no-op.
 If you are doing a Style 2 export, remember to update the chaker
 */
- (void)doSpecialMappingBeforeExportForExporter:(Exporter*)exporter
                                        bkmxDoc:(BkmxDoc*) bkmxDoc ;
	
- (BOOL)exportCheckStuffMidwayError_p:(NSError**)error_p;

- (void)tweakImport ;

- (void)tweakExport ;

- (NSString*)browserExtensionPortName ;

- (NSDictionary*)changeInfoForOperation:(SSYOperation*)operation
                                error_p:(NSError**)error_p ;

/*!
 @details  The default implementation logs an internal error.
 Subclasses must override.
*/
- (void)writeUsingStyle2InOperation:(SSYOperation*)operation ;

/*!
 @brief    Performs export style 2 for subclasses which do it by
 sending a JSON object containing the changesto a browser extension,
 via inteprocess communication

 @details  This is used by ExtoreFirefox and ExtoreChromy.
*/
- (void)exportJsonViaIpcForOperation:(SSYOperation*)operation ;

/*!
 @brief    Assuming prerequisites have already been verified,
 writes bookmarks data from the receiver's transMoc to its
 external store, or if the store has a localMoc, compares the
 transMoc to the localMoc and writes changes to the localMoc
 and to the external store.
 
 @details  For extores that have a localMoc, since one of the
 prerequisites is that there be no file conflict, the localMoc
 is assumed to be in sync with the external store, so the same
 changes (additions, deletions and updates) are written to the
 external store as to the localMoc.&nbsp; Effort is made to 
 keep the two in sync during the process.&nbsp; For example, if
 a failure occurs halfway through writing to the external
 store, but it is believe that the first half were written
 successfully, the localMoc should also be half-changed.
 
 Sets the receiver's error if any user cancels
 or if anything else goes wrong.
 
 When done, must send a -writeAndDeleteDidSucceed: message to
 the doneTarget, indicating whether or not the write operation
 succeeded.
 
 The default implementation logs an internal error.
 Subclasses must override.
 */
- (void)writeUsingStyle1InOperation:(SSYOperation*)operation ;

/*!
 @brief    Pushes changes from the external store to the cloud

 @details  Use this after an export if needed.  The default
 implementation is a no-op which returns YES.
 Subclasses may override.
 @param    error_p  If not NULL and if an error occurs, upon return,
           will point to an error object encapsulating the error.
 @result   YES if the method completed successfully, otherwise NO
*/
- (BOOL)pushToCloudError_p:(NSError**)error_p ;

- (id)extoreItemFromStark:(Stark*)item ;

/*!
 @brief    Returns whether or not the external store was touched since
 the receiver last imported the external store's data.

 @details  Gets a current value for  the receiver's
 lastDateExternalWasTouched and compares it with the constKeyLocalMocSyncs
 time for the receiver's ixporter's client which is stored in user defaults.
 If either number is not available, returns the "worst case" answer of YES.
 @result   NO if the receiver's data is "out of sync" with the external
 store, YES if the receiver's data is current/OK.
*/
- (BOOL)localMocIsSyncedWithExternal ;


- (void)recursivelyPerformSelector:(SEL)selector
					   onRootStark:(Stark*)item
						withObject:(id)object ;


/*!
 @brief    Returns a set of strings, the stark attributes
 that BookMacster can edit and export to the external store of
 the receiver
 
 @details  If applicable, the 'url' attribute appears first
 in the array, in case this is needed to test for exportability.
*/
+ (NSArray*)editableAttributesInStyle:(NSInteger)style ;

/*!
 @brief    Compares each of the attributes values which are supported
 by the receiver between two starks.

 @details  This method compares only attributes, not relationships.
 
 Nil values are properly supported:
 <ul>
 <li>If one stark has a nil value for a given attribute and same value
 in the other stark is not nil, NO is returned.</li>
 <li>If both starks have a nil value for a given attribute,
 YES may be returned.</li>
 </ul>
 There is no distinction between stark1 and stark2.

 @param    stark1  
 @param    stark2  
 @result   YES if all supported attributes in the two starks have
 the same values, otherwise NO.
*/
- (BOOL)supportedAttributesAreEqualComparingStark:(Stark*)stark1
									   otherStark:(Stark*)stark2
                                      ixportStyle:(NSInteger)style;


/*!
 @brief    Subclasses override this method to do any tweaking to
 the local browser which may be required as a prerequisite to
 importing bookmarks.
 
 @details  This method will run in the main thread.&nbsp;

 This method may return immediately and convey results
 asynchronously.  When done, it must invoke
 -prepareBrowserForImportIsDone:, passing the given
 info, after adding an NSNumber whose boolValue is YES
 for key constKeySuccess of the operation succeeded.
 
 The default implementation simply sends this 'done' message
 with didSucceed = YES.
 
 @param    info  The info dictionary that is populated in
 -[Ixporter exportWithInfo:] and passed through
 all methods in the export chain.
 */
- (void)prepareBrowserForImportWithInfo:(NSMutableDictionary*)info ;

/*!
 @brief    Subclasses override this method to do any tweaking to
 the local browser which may be required as a prerequisite to
 exporting bookmarks.

 @details  This is invoked *twice* prior to exporting bookmarks, but only
 
 @details  If the receiver's ixporter's client's extoreMedia is
 BkmxExtoreMediaThisUser during an export, this
 method is invoked twice, once prior to reading, from prepareBrowserForExport1,
 and again prior to writing, from prepareBrowserForExport2.  If there are
 things that should only be done in either invocation, read the -boolValue
 of key constKeySecondPrep in the info dictionary which is YES during the
 second invocation.  In either case, this method will run in the main thread.
 
 If the receiver's ixporter's client's extoreMedia is not
 BkmxExtoreMediaThisUserduring an export, this method is not invoked.

 Subclass implementation must do two things…
 [info setObject:[NSNumber numberWithBool:whatever] forKey:constKeySucceeded] ;
 [self sendIsDoneMessageFromInfo:info] ;

 The default implementation does only these two things.
 
 @param    info  The info dictionary that is populated in
 -[Ixporter exportWithInfo:] and passed through
 all methods in the export chain.
 */
- (void)prepareBrowserForExportWithInfo:(NSMutableDictionary*)info;

- (BOOL)launchOwnerAppIfNecessaryForPolarity:(NSInteger)ixpolarity
                                        info:(NSMutableDictionary*)info
                                     error_p:(NSError**)error_p ;

/*!
 @brief    Subclasses override this method to un-do any temporary
 tweaking to the local browser which was done by
 prepareBrowserForExportWithInfo:.
 
 @details  This is invoked during writing of bookmarks.&nbsp;
 It will run in the main thread.&nbsp; The default implementation
 is a no-op.
 
 @param    info  The info dictionary that is populated in
 -[Ixporter exportWithInfo:] and passed through
 all methods in the export chain.
 */
- (void)restoreBrowserStateInfo:(NSDictionary*)info ;

/*!
 @brief    Subclasses override this method to do any tweaking to
 individual attribute values which may be required as a prerequisite
 to writing bookmarks, or which the client will do anyhow.
 
 @details  In the latter case, use this tweak to avoid writing
 changes unnecessarily.
 
 The default implementation returns [stark valueForKey:key].
 */
- (id)tweakedValueFromStark:(Stark*)stark
					 forKey:(NSString*)key ;

/*!
 @brief    Returns whether or not the receiver's class's constants
 indicate that its items have an 'index'.
*/
- (BOOL)hasOrder ;

/*!
 @brief    Returns whether or not the receiver's class's constants
 indicate that it can contain folders.
 */
- (BOOL)hasFolders ;

- (Stark*)starkFromExtoreNode:(NSDictionary*)item ;

/*!
 @details  The default implementation returns YES for style 1
 and NO for style 2.  Subclasses may override.
*/
- (BOOL)shouldPackFiles ;

- (BOOL)determineYourIxportStyleError_p:(NSError**)error_p;

- (BOOL)needsExtension1InstallError_p:(NSError**)error_p ;

/*!
 @details  The default implementation returns NO.
 Subclasses may override.
 */
- (BOOL)shouldBlindSawChangeTriggerDuringExport ;

/*!
 @brief    Returns whether or not it is a good idea to close windows
 before sending a 'quit' AppleScript command to the receiver's owner app
 
 @details  The default implementation returns YES.
*/
- (BOOL)shouldCloseWindowsWhenQuitting ;

/*!
 @brief    From data in a given tree, inserts corresponding starks
 into the receiver's managed object context
 
 @details  Must be implemented by subclasses.  Default implementation
 assigns error_p and returns NO.
 
 @param    treeIn  An NSDictionary representing the data in the external
 data.
 @param    error_p  If the operation failed, on return, points to an error
 object explaining the problem.
 @result   YES is successful, otherwise NO.
 */
- (BOOL)makeStarksFromExtoreTree:(NSDictionary*)treeIn
                         error_p:(NSError**)error_p ;

/*!
 @brief    Writes data to a file atomically

 @details  A wrapper around -[NSData writeToFile:options:error:]
 which first checks if the file can be written and tries
 to set the receiver's -error if something goes wrong.
 This may be used by subclasses which require simple
 atomic writing of data such as Safari and OmniWeb.
 @param    data  The data to be put in the file.
 @param    path  The path of the file to be written.
 @result   YES if the operation was successful, otherwise NO.
*/
- (BOOL)writeData:(NSData*)data
		   toFile:(NSString*)path ;

/*!
 @brief    Writes a string to a file atomically
 
 @details  A wrapper around -[NSString writeToFile:atomically:encoding:error]
 which first checks if the file can be written and tries
 to set the receiver's -error if something goes wrong.
 This may be used by subclasses which require simple
 atomic writing of strings such as Chrome.
 @param    string  The string to be put in the file.
 @param    path  The path of the file to be written.
 @result   YES if the operation was successful, otherwise NO.
 */
- (BOOL)writeString:(NSString*)string
			 toFile:(NSString*)path ;

- (BOOL)makeStarksFromJsonString:(NSString*)jsonString
						 error_p:(NSError**)error_p ;

/*!
 @brief    Returns the key in User Defaults whose value is the date of the
 last time that all posts (bookmarks) were requested from the owner (web)
 app by any instance of the receiver.
 
 @details  Subclasses should override if this method is invoked.  The
 default implementation returns a common suffix which subclasses may use
 by invoking super.
 
 This is a class method instead of an instance method because web apps
 usually don't discriminate by username when counting requests for banning.
*/
+ (NSString*)keyLastPostsAll ;

/*!
 @brief    Returns -keyLastPostsAll from the receiver's class
 */
- (NSString*)keyLastPostsAll ;

/*!
 @brief    Number of seconds per change allowed to receive exid feedback
 after export via addon begins

 @details  Subclasses with addons should override.
 
 Since we're getting progress from Firefox now, maybe we don't even need
 this timeout any more and should use FLT_MAX for all clients.
 Probably if we start getting feedback from Chrome too, we don't need it.
*/
- (NSTimeInterval)exportFeedbackTimeoutPerChange ;

- (BOOL)hasUsersAttention ;

- (NSString*)tooltipForInstallButtonForExtensionIndex:(NSInteger)extensionIndex ;

- (BOOL)addonMayInstall:(BOOL*)mayInstall_p
				error_p:(NSError**)error_p ;

/*!
 @brief    Returns by references arrays of clients, extores and test results
 for which we support addons.
 
 @details  Collections *extores_p and *results_p will contain the
 same number of elements.  *extores_p is ordered alphabetically by client display name.
 @param    extores_p   You may pass NULL if this parameter is not needed.
 @param    results_p  A dictionary of dictionaries obtained by reading the version
 numbers from the installed extensions and messengers from the disk,
 not by testing.  The keys of the outer dictionaries are clidentifiers of an extore's
 client.  Each inner dictionary contains one or more of the following keys:
 * constKeyExtensionVersion
 * constKeyError
 If probing the hard drive for versions concluded OK, but some expected
 extension(s) or messenger(s) were found to be missing or not of the required
 version, the error code will be EXTORE_ERROR_CODE_BASE plus one or more
 of the EXTORE_ERROR_CODE_MASK_… constants.
 You may pass NULL if this parameter is not needed.
 */
+ (void)addonableExtores_p:(NSArray**)extores_p
				 results_p:(NSDictionary**)results_p ;

- (NSUInteger)slowExportThreshold ;

- (NSInteger)extensionVersionForExtensionIndex:(NSInteger)extensionIndex ;

/*!
 @brief    Returns an alert which warns the user that an export with a 
 given number of changes is above a given threshold will take a long
 time

 @details  If an alert is returned, it must have two buttons.  If the
 user clicks button1, the export will proceed and if the user clicks
 button2, the export will be cancelled.
 
 Subclasses should override this method if it is expected to be invoked.
 The default implementation returns nil.
 @result   
*/
- (SSYAlert*)warnSlowAlertProposed:(NSUInteger)proposed
						 threshold:(NSUInteger)threshold ;

- (NSString*)warnSlowFormatString ;

- (void)doBackupLabel:(NSString*)label ;

/*!
 @brief    Returns whether or not the receiver's owner app is currently able
 to process messages regarding the receiver's profile via interprocess
 communication, ASSUMING that the owner app is running
 
 @details  The default implementation returns YES.
 */
- (BOOL)profileIsLoadedIfOwnerAppRunningError_p:(NSError**)error_p ;

- (uint32_t)importHashBottom ;

- (BOOL)hashCoversAllAttributesInCurrentStyle;

+ (BOOL)parentSharype:(Sharype)parentSharype
  canHaveChildSharype:(Sharype)childSharype ;

/*!
 @details  The default implementaion wraps the class method of the same name,
 but subclasses can modify that result, typically to satisfy Client Special
 Settings.
 */
- (BOOL)parentSharype:(Sharype)parentSharype
  canHaveChildSharype:(Sharype)childSharype ;

- (void)registerHighExidFromItem:(NSDictionary*)item ;

- (void)processExidFeedbackString:(NSString *)jsonText;

- (void)clearTransMoc;
- (void)clearLocalMoc;

#if DEBUG_WRITE_IMPORTED_URLS_TO_FILES
- (void)beginSSYLinearFileWriter ;
- (void)appendBookmarkSSYLinearFileWriterName:(NSString*)name
										  url:(NSString*)url ;
- (void)closeSSYLinearFileWriter ;

#endif

@end

#if 0
#warning Including methods for debugging extore memory leaks

@interface Extore (DebugMemoryLeaks)
- (void)logRC:(NSString*)label;
@end
@interface NSDictionary (DebugExtore)
- (void)logRC:(NSString*)label;
@end
#define logRCExtore(extore__) [(Extore*)extore__ logRC:[NSString stringWithFormat:@"%s li %d", __PRETTY_FUNCTION__, __LINE__]];
#define logRCInfo(info__) [(NSDictionary*)info__ logRC:[NSString stringWithFormat:@"%s li %d", __PRETTY_FUNCTION__, __LINE__]];

#endif
