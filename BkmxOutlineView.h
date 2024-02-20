@class BkmxDoc ;

/*!
 @brief    Adds some fairly generic features to NSOutlineView
 
 @details  The delegate of a BkmxOutlineView must be connected
 in Interface Builder to the window controller
*/
@interface BkmxOutlineView : NSOutlineView <NSViewToolTipOwner> {
	NSArray* selectedObjects ;
    NSMutableDictionary* m_cellTips ;
}

@property (retain) NSArray* selectedObjects ;

- (BkmxDoc*)document ;

- (NSArray*)objectsAtRowIndexes:(NSIndexSet*)indexSet ;

- (BOOL)isVisibleItem:(id)item ;

- (NSArray*)visibleItemsAndExtraPoints_p:(CGFloat*)fraction_p ;

- (void)scrollToMakeVisibleItems:(NSArray*)items
                 plusExtraPoints:(CGFloat)extraPoints ;

/*!
 @brief    Returns the single selected object in the receiver, or an NSNull
 if there is a multiple selection.

 @details  Changes in this value can be observed by KVO and also a 
 binding is exposed.
*/
- (id)selectedObject ;

/*!
 @brief    Returns the array of objects in the receiver that are selected.

 @details  Changes in this value can be observed by KVO and also a 
 binding is exposed.
*/
- (NSArray*)selectedObjects ;

- (NSInteger)countOfSelectedObjects ;

- (void)selectObjects:(NSArray*)objects
 byExtendingSelection:(BOOL)extend ;

- (void)addToolTip:(NSString*)tip
              rect:(NSRect)rect ;

@end

#if 0
#warning Utter nonsense to patch incorrect Xcode warnings

// Suddenly, Xcode thinks that -itemAtRow: is not declared by NSOutlineView.
// A couple weeks later, maybe after Xcode 6.1 and/or relaunch, fixed itself.
@interface NSOutlineView ()
- (id)itemAtRow:(NSInteger)row ;
@end

#endif
