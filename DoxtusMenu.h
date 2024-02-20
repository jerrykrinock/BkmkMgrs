#import <Cocoa/Cocoa.h>
#import "StarkContainersHierarchicalMenu.h"
#import "BkmxGlobals.h"

/*!
 @brief    We use the same menu for Dock Menu and Status Menu, so
 we call it the Doxtus Menu.
 
 @details  Although we don't provide the customary singleton API,
 this class is used as a singleton, since the instance that is created when
 it is bound to for the status item in -[BkmxAppDel applicationDidFinishLaunching]
 is never destroyed, and no others are ever created.
*/
@interface DoxtusMenu : NSMenu <NSMenuDelegate> {
	NSString* m_exformat ;
	NSStatusItem* m_statusItem ;
	StarkContainersHierarchicalMenu* m_hierMenu ;
	//NOTUSEDNSDictionary* m_addHereInfo ;
	NSDictionary* m_lastBrowmarkInfo ;
	BOOL m_pumpIsPrimed ;
    BkmxStatusItemStyle m_statusItemStyle ;
}

@property (retain) NSString* exformat ;

/*!
 @brief    If the active app is a web browser, sends it a message of
 some kind via interprocess communication, asking it to return to
 information on, and returns said information, or nil if not
 available or if a web browser is not active.
 */
- (NSDictionary*)grabActivePage ;

#if (MAC_OS_X_VERSION_MIN_REQUIRED >= 1060) 
- (void)popUpAnywhereMenu ;
#endif

@end
