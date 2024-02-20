#import "BkmxOutlineView.h"


@class Stark ;
@class Starki ;
@class CntntViewController ;
@class ContentDataSource ;

#define CONTENT_OUTLINE_VIEW_RELOAD_DELAY_0 0.00
#define CONTENT_OUTLINE_VIEW_RELOAD_DELAY_1 0.01
#define CONTENT_OUTLINE_VIEW_RELOAD_DELAY_2 0.02

enum BkmxReloadStaged_enum {
    BkmxReloadStagedNone,
    BkmxReloadStagedPartial,
    BkmxReloadStagedFull
} ;
typedef enum BkmxReloadStaged_enum BkmxReloadStaged ;


@interface ContentOutlineView : BkmxOutlineView <NSDraggingSource, NSDraggingDestination> {
	BOOL springLoadingEnabled ;

	NSInteger clickedRowIndex ;
	NSTimeInterval refTimeOfLastClick ;

	NSTimer* _reEnableSpringLoadingTimer ;
	
	// Apple's kludge so that changes to the NSColorWells in Preferences window
	// are propagated to the outline immediately.  See:
	// http://developer.apple.com/documentation/Cocoa/Conceptual/DrawColor/Tasks/StoringNSColorInDefaults.html
	// at the bottom of the page, "Declare an NSColor property of the custom view class...."
	// This is the custom view class.
	NSColor* m_colorSort ;
	NSColor* m_colorUnsort ;
    
    BOOL m_hasLoadedOnce ;
    
    NSMutableSet* m_reloadStarks ;
    BkmxReloadStaged m_reloadStaged ;

    BOOL m_didShowToolTipDuringLastDragOption ;
    BOOL m_didShowToolTipDuringLastDragShift ;
    BOOL m_didShowToolTipDuringLastDragContextual ;
}

@property (assign, readonly) BOOL springLoadingEnabled ;
@property (copy) NSColor* colorSort ;
@property (copy) NSColor* colorUnsort ;
@property (assign) BOOL sortable ;

// Override to typecast
- (ContentDataSource*)dataSource ;

- (void)checkAllProxies;
- (void)checkProxiesReloadDataAndRealizeIsExpanded;

- (void)updateNameColumnHeading ;

/*!
 @brief    Re-enables spring loading during dragging, if it
 has been disabled by holding the shift key down.

 @param    timer  This parameter is ignored.  The timer
 is an instance variable and is accessed as such.
*/
- (void)reEnableSpringLoading:(NSTimer*)timer ;

- (void)realizeIsExpandedValuesFromModelFromRoot:(Stark*)root ;

/*!
 @brief    Similar to -itemAtRow: but gives the represented model object instead
 of the proxy
 
 @details   We cannot override -itemAtRow: because Cocoa uses that method and
 expects the proxy.
 */
- (id)starkAtRow:(NSInteger)row ;

/*!
 @brief    Self-explanatory?
 
 @details   OK if some stark(s) are not in this outline.  They will be ignored.
 
 In order to support looped messages, these methods extend the existing selection,
 if any.  If you don't want to extend the existing selection, send -deselectAll before this.
 
 @param    items  Stark objects to be shown
 @param    selectThem  YES if items should also be selected
 @param    expandAsNeeded  YES to expand if necessary to show the items
 */
- (void)showStarks:(NSArray*)starks
        selectThem:(BOOL)selectThem
    expandAsNeeded:(BOOL)expandAsNeeded ;

- (void)showSelectAndExpandStarks:(NSArray*)starks ;

- (NSArray*)selectedStarks ;

- (void)reloadStarks:(NSSet*)starks ;

- (void)clearProxiesAndReload ;

- (Starki*)selectedStarki ;

/*!
 @brief    Invokes showStarks:selectThem:expandAsNeeded: with a single
 stark and expandAsNeeded=YES.
*/
- (void)showStark:(Stark*)stark
         selectIt:(BOOL)selectIt ;

/*!
 @details  Override NSOutlineView methods to indicate that delegate
 must be a CntntViewController, not merely (id < NSOutlineViewDelegate >).
*/
- (CntntViewController*)delegate ;
- (void)setDelegate:(CntntViewController*)delegate ;

- (void)restoreFromAutosaveState:(NSDictionary*)state ;

- (NSFont*)moveableToolTipFont ;

- (void)expandStark:(Stark*)stark ;
- (void)collapseStark:(Stark*)stark ;

// CLEAR-STAGING //- (void)clearReloadStaging ;

@end

