#import <Cocoa/Cocoa.h>

@class Stark ;


/*!
 @brief    Methods required to catch starks during an Import or Export.

 @details  Conformance to this protocol is one requirement for an object
 to be a successful Import or Export Destination.
*/
@protocol StarCatcher

/*!
 @brief    Returns whether or not the receiver's ownerApp 
 has a permanent collection called a "Bookmarks Bar",
 "Bookmarks Toolbar" or equivalent.
 */
- (BOOL)hasBar ;

/*!
 @brief    Returns whether or not the receiver's starker 
 has a permanent collection called a "Bookmarks Menu"
 */
- (BOOL)hasMenu ;

/*!
 @brief    Returns whether or not the receiver's starker 
 has a permanent collection designated for "Unfiled" bookmarks
 */
- (BOOL)hasUnfiled ;

/*!
 @brief    Returns whether or not the receiver's starker 
 has a permanent collection designated for "Shared" bookmarks.
 
 @details  Do not confuse this with the capacity of a web
 service external store to set individual bookmarks "shared"
 or "private".
 */
- (BOOL)hasOhared ;

/*!
 @brief    Returns whether or not a given parent sharype can have
 a give child sharype
  */
- (BOOL)parentSharype:(Sharype)parentSharype
  canHaveChildSharype:(Sharype)childSharype ;

/*!
 @brief    Returns the default parent which should adopt a given stark that
 cannot be adopted by the parent it is mapped to during an export operation
 
 @param    item  The proposed child
 */
- (Stark*)fosterParentForStark:(Stark*)item ;

- (NSString*)displayName ;

@end
