#import <Cocoa/Cocoa.h>

@class SSYProgressView ;
@class Extore ;
@class ExtensionsMule ;

/*!
 @brief    Control that comprises most of the window in the
 Manage Browser Extensions Window.
 
 @details  
 
 The height of the view in the nib should be the desired height
 of a single row, typically 28 points.
 
 20170502.  In various places, this class contains unnecessary code which
 was needed in the past because, in the past,
 • More work requiring progress indications was done to install extensions.
 • More work requiring progress indications was done to uninstall extensions.
 • We did not have a `progressViews` array or ResultDisplayModeProgress.  The
 `errorsView` array contained progress views that were, strangely, also used
 to display errors.  Do not be afraid to remove unnecessary code when found.
 */
@interface ManageExtensionsControl : NSControl {
	CGFloat m_rowHeight ;
	ExtensionsMule* m_mule ;
    CGFloat m_originalHeight ;
    BOOL m_anyExtensionsAvailable ;
    NSButton* m_defaultButton ;
    NSMutableDictionary* m_iconViews ;
    NSMutableDictionary* m_versionViews ;
    NSMutableDictionary* m_progressViews ;
    NSMutableDictionary* m_errorViews ;
    NSMutableSet* m_clidentifiersWithStalePrefs;
}

@property (assign) BOOL anyExtensionsAvailable ;
@property (assign) NSButton* defaultButton ;
@property (assign) CGFloat rowHeight ;
@property (retain, readonly) ExtensionsMule* mule ;
@property (retain) NSMutableSet* clidentifiersWithStalePrefs;

- (CGFloat)currentHeight ;

- (NSInteger)indexForExtore:(Extore*)extore ;

- (void)quitStaleBrowsers;

/*!
 @brief    Refreshes the receiver's mule and removes all existing extore rows
 
 @result   Returns the change in the height of the receiver, if any as a result
 of the refresh operation.  Postivie numbers mean taller.
 */
- (CGFloat)refresh ;

- (void)stopSpinningForExtore:(Extore*)extore ;

- (void)beginIndeterminateTaskVerb:(NSString*)verb
						 forExtore:(Extore*)extore ;


@end
