#import <Cocoa/Cocoa.h>
#import "SSYPopUpTableHeaderCell.h"


@interface StarkTableColumn : NSTableColumn <NSMenuDelegate, NSTokenFieldCellDelegate, SSYPopupTableHeaderSortableColumn> {
	NSString* m_userDefinedAttribute ;
	NSMutableDictionary* m_boundCells ;
    NSPopUpButtonCell* m_popupCell ;
	NSFont* headerFont ;
}

- (CGFloat)defaultWidth ;

/*!
 @brief    The current key, the -representedObject,  in the popup
 menu in the header cell of the receiver, or nil if the
 receiver's header cell is not a popup menu.

 @details  This is an attribute in the user defaults, but
 it is cached here for efficency, since it is required by
 -[BkmxOutlineDataSource outlineView:objectValueForTableColumn:byItem:]
 which is required to be fast.
*/
@property (copy) NSString* userDefinedAttribute ;


/*!
 @brief    Will select the popup menu item in the receiver's
 header which represents a given key.

 @details  Will raise an exception if the receiver's header
 cell is not a NSPopUpButtonCell.
*/
- (void)selectUserDefinedMenuItemForKey:(NSString*)key ;

/*!
 @brief    Message which must be sent before this column's superview is closed.

 @details  If you don't send this message, you can get Core Data burps such as:
 The NSManagedObject with ID:0x16f7f2f0 <SOME_UUID/Stark_entity/p20> has been invalidated.
 This cannot be done during -dealloc because that is usually too late.
*/
- (void)unbindValue ;

@end

