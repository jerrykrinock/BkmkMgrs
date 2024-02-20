#import <Cocoa/Cocoa.h>
#import "BkmxBasis.h"
#import "BkmxGlobals.h"
#import "StarkLocation.h"
#import "StarkTyper.h"
#import "SSYRepresentative.h"
#import "SSYLicenseable.h"
#import "SSYSpotlighter.h"

@class Stark ;
@class Starki ;
@class BkmxDoc ;
@class Client ;
@class InspectorController ;
@class PrefsWinCon ;
@class LogsWinCon ;
@class MiniSearchWinCon ;
@class SUUpdater ;
@class BkmxBasis ;
@class SSYAlert ;
@class DoxtusMenu ;
@class Job;

extern NSString* const constNoteLaunchInBackgroundSwitchedOff ;

@interface BkmxAppDel : NSObject <NSMenuDelegate, SSYLicenseable> {
	NSMutableArray* intraAppCopyArray ;
	InspectorController* inspectorController ;
	LogsWinCon* m_logsWinCon ;
    MiniSearchWinCon* m_miniSearchWinCon ;
	NSString* helpBookName ;
	id m_selectedStark ;  // Can be Stark or NoStark
	Starki* m_selectedStarki ;
    BOOL m_didWarnMultiDocSyncers ;
	BOOL m_noWelcome ;
	BOOL m_didDisplayBrokenLoginItemError ;
	NSInteger nWorks ;
	NSFont* m_fontTable ;
	DoxtusMenu* m_doxtusMenu ;
    NSRunningApplication* m_lastActiveBrowserApp ;
    NSArray* _jobQueue;
    NSMutableDictionary* _agentTimeoutters;
    
    NSTimeInterval m_dateHitShortcutActuator ;
    
    NSInteger m_dragTipShownCountOption ;
    NSInteger m_dragTipShownCountShift ;
    NSInteger m_dragTipShownCountContextual ;
    NSInteger m_howManyTimesToShowDragTipsThisLaunch ;
    NSInteger m_launchUrlHandlerFailureCount;
	
	// Global Color Objects
	NSColor* colorBlueText ;

	BOOL m_legacyLogoutGoogleDontAsk ;
	BOOL m_didFinishLaunchingEarlyChores ;
    BOOL m_isUninstalling ;
    BOOL m_isResetting ;
    BOOL m_isTerminating ;
    BOOL m_isBackgrounding ;
    BOOL m_needsTriggersCheckedForFirefox53;
    
    BkmxDoc* m_currentBkmxDoc ;
    
    NSApplicationActivationPolicy m_currentProcessType ;
}

// Accessors, of sorts

@property (retain, readonly) NSMutableArray* intraAppCopyArray ;
@property (retain, readonly) InspectorController* inspectorController ;
@property (readonly) NSString* helpBookName ;
@property (retain) id selectedStark ;
@property (retain) Starki* selectedStarki ;
@property (retain, readonly) NSFont* fontTable ;
@property BOOL noWelcome ;
@property (assign) BOOL isUninstalling ;
@property (assign) BOOL isResetting ;
@property (assign) BOOL isTerminating ;
@property (assign) BOOL isBackgrounding ;
@property (assign) BOOL needsTriggersCheckedForFirefox53;
@property (assign) BOOL relaxedExtensionDetection;  // for testing of unpacked extensions
@property (copy, readonly) NSArray <Job*>* jobQueue;
@property (assign) NSTimeInterval jobsQueueRefreshDate;

// This observeable property is bound to by the InspectorController
@property (assign) BkmxDoc* currentBkmxDoc ;

/*!
 @brief    A little object which responds to the NSMenuDelegate protocol
 for populating the content hierarchical menus in the Dock Menu and
 Status Item Menu.

 @details  Implementation of the NSMenuDelegate (Mac OS 10.6+, so we don't
 say so explicitly) protocol is provided by the category
 NSObject(StarkMenuDataSource).  One reason for this object is
 that BkmxAppDel itself implements -menuNeedsUpdate, which causes the
 lazy methods -numberOfItemsInMenu: and menu:updateItem:atIndex:shouldCancel:
 to be never invoked.  They must therefore be implemented in a different
 object.  The other reason is to provide ivar exformat (which could have been
 done other ways, like putting it in BkmxAppDel).
*/
@property (retain, readonly) DoxtusMenu* doxtusMenu ;

@property (assign) NSInteger dragTipShownCountOption ;
@property (assign) NSInteger dragTipShownCountShift ;
@property (assign) NSInteger dragTipShownCountContextual ;

- (NSInteger)openNotificationSettings;
- (BOOL)inspectorShowing ;

- (void)incrementDragTipShownCountOption ;
- (void)incrementDragTipShownCountShift ;
- (void)incrementDragTipShownCountContextual ;

- (void)registerDefaultDefaults ;


/*!
 @brief    Returns the app's or tool's sharedBasis

 @details  This is used by hundreds of bindings in nib files
*/
- (BkmxBasis*)basis ;

/*!
 @brief    Returns YES if -selectedStark will return an object
 or NSMultipleValuesMarker, NO otherwise.
*/
- (BOOL)starkOrStarksSelected ;

- (void)setIfNoBkmxDocWindowsSelectedStark:(Stark*)stark ;

- (void)showInspectorIfItWasShowing ;

// Global Color Objects
@property (readonly) NSColor* colorBlueText ;

- (LogsWinCon*)logsWinCon ;

- (MiniSearchWinCon*)miniSearchWinCon ;

- (void)displayErrorLogs ;

/*!
 @result   The recovery result one of the enumeration values
 beginning with SSYAlertRecovery… 
 */
- (NSInteger)presentLastLoggedErrorWithCode:(NSInteger)code ;

- (void)showNewUserHelpOrElseLaunchDocsOrWelcomeAndAnyErrors ;

- (NSString *)helpAnchorForNewbie ;

- (void)openShoeboxDocumentCreateIfNeeded ;

- (PrefsWinCon*)prefsWinCon ;

- (void)revealPrefsTabIdentifier:(NSString*)identifier ;

/*!
 @brief    Opens the application's Apple Help book to 
 the given anchor
*/
- (void)openHelpAnchor:(NSString*)anchor ;

- (void)inspectorShowUrls ;

/*!
 @brief    Method to avoid crashes if items on the intraApp arrays,
 orphaned when their ancestral document closes, are later
 attempted to be pasted.	
 */
- (void)clearIntraAppItemArraysOfBkmxDoc:(BkmxDoc*)bkmxDoc ;

/*!
 @brief    Returns the exformat of the Extore of the most active web browser,
 if it is one of the -supportedLocalAppExformatsIncludeNonClientable:YES of the
 BkmxBasis.

 @details  By "most active", we mean that we first check for the
 active application and, if that is not one of the supportedLocalAppExformats,
 then we look for any running app which is.  If no such app is found,
 returns nil.
*/
- (NSString*)activeBrowserExformat ;

/*!
 @brief    Adds a new bookmark into the current BkmxDoc, and if indicated
 by the state of the user default constKeyAltKeyInspectsLander and the
 up/down state of the option key, either shows the Inspector or 
 re-activates the browser app.

 @param    browmarkInfo  A dictionary which will be examined for the
 following keys
 * constKeyUrl
 * constKeyName
 * constKeyComments
 * constKeyPath  Bundle path to the browser app which may be activated
 during this operation
*/
- (void)landNewBookmarkWithInfo:(NSDictionary*)browmarkInfo ;

- (void)landNewBookmarkFromMenuItem:(NSMenuItem*)menuItem ;

- (IBAction)makeForeground:(id)sender ;

- (NSArray*)tagCompletionsForTagPrefix:(NSString*)prefix
						selectIndex_p:(NSInteger*)index_p ;

- (void)showInspectorWithOomph ;

- (void)doShowInspector:(BOOL)desiredState ;

- (IBAction)background:(id)sender ;

- (void)visitAllOfRepresentative:(NSObject <SSYRepresentative> *)menuItem ;

- (NSInteger)howManyTimesToShowDragTipsThisLaunch ;

- (NSImage*)statusItemImageForStyle:(BkmxStatusItemStyle)style ;

- (BOOL)doesLaunchInBackground ;

- (BOOL)canRunInBackground ;

- (BOOL)hasStatusItem ;

- (BOOL)hasFloatingMenu ;

- (void)endEditingForInspector ;

- (void)crash ;

- (void)dumpClasses ;

- (void)warnMultiDocsInWatches:(NSSet*)watches;

- (void)stopAllSyncingEllipsis;

- (void)showSyncingStatus;

- (void)writeSyncingStatusReportToFileThenDo:(void (^)(void))thenDo;

- (void)cancelStagedAndQueuedJobsInAgentForDocumentUuid:(NSString*)docUuid;

- (void)demoPresentUserNotificationWithTitle:(NSString*)title
                              alertNotBanner:(BOOL)alertNotBanner
                                    subtitle:(NSString*)subtitle
                                        body:(NSString*)body
                                   soundName:(NSString*)soundName
                                      window:(NSWindow*)window;

- (void)restartSyncWatchesThen:(void (^)(NSError*))then;

- (void)removeSyncersForDocumentUuid:(NSString*)documentUuid;

- (void)realizeSyncersOfAllDocumentsToWatchesThenDo:(void (^)(void))thenDo;

- (void)stopAllSyncingForApps:(BkmxWhichApps)whichApps;

/*!
 @details  Starting in BkmkMgrs 2.10.5, any error generated by this method is
 hidden, because this method is only used for "clean-up" operations, and such
 an error occurred for user Georges G.*/
- (void)removeAllSyncersExceptDocUuid:(NSString*)docUuid
                    completionHandler:(void (^)(void))completionHandler;

- (void)killAnyOldieLoginItemsWithBasename:(NSString*)name;

/*!
 @brief    An appropriate click selector for any SSYAlert that has two
 buttons: button 2 titled "Copy to Clipboard", and button 1 titled "Done"

 @details  With this method as the click selector, clicking "Copy to
 Clipboard" copies the alert's title and small text, formatted as markdown,
 to the system clipboard.  Clicking "OK" dismisses the alert.
 */
- (void)handleClickWithClipboardButtonAlert:(SSYAlert*)alert;

@end
