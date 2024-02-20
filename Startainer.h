#import "BkmxGlobals.h"
#import "SSYModelChangeTypes.h"

@class Stark ;
@class Starker ;
@class Client ;
@class Chaker;

/*!
 @brief    Formal protocol for an object which can contain Starks in 
 a managed object context, and has a Starker available.

 @details  Conforming classes will provide methods to
 
 * Access the Starker (of course!)
 * Answer questions regarding placing additional Starks in the receiver
 * Identify the class's Client (optional)
 
 This protocol was established to express the commonality between
 the internal representation of Starks in a BkmxDoc and their external
 representation in an Extore.  BkmxDoc and Extore adopt this protocol.
*/
@protocol Startainer


- (BOOL)canEditSeparatorsInAnyStyle;

/*!
 @brief    Returns whether or not the receiver's ownerApp can 
 selectively share some or all of the user's bookmarks with other users.
 */
- (BOOL)canPublicize ;

#if 0
// Removed in BookMacster 1.17 as it appears that this method is no longer used.
/*!
 @brief    Returns whether or not the receive's starker can insert a Stark of
 a given Sharype anywhere at all and have it make it into the external store.
 */
- (BOOL)supportsSharype:(Sharype)sharype ;
#endif

/*!
 @brief    Returns whether or not the receiver can and should edit
 the attribute for a given key.
 */
- (BOOL)canEditAttribute:(NSString*)key
                 inStyle:(BkmxIxportStyle)style;

/*!
 @brief    Returns a new stark modelling a given item from the external
 store.
 
 @details  Subclasses must override, unless this method is not used.
 Used by Camino, Chrome and Safari.  Default implementation logs an
 Internal Error and returns nil.
 
 @param    item  The item from the external store to be modelled.
 @result   The new stark
 */
- (Stark*)starkFromExtoreNode:(NSDictionary*)item ;

/*!
 @brief    Returns YES if the receiver's ownerApp's items have an 'index'
 attribute.
 */
- (BOOL)hasOrder ;

/*!
 @brief    Returns YES if the receiver's ownerApp can contain folders
 */
- (BOOL)hasFolders ;

/*!
 @brief    Returns whether or not the receiver
 accepts starks matching coarse type SharypeCoarseLeaf in its root
 */
- (BOOL)rootLeavesOk ;

/*!
 @brief    Returns whether or not the receiver
 accepts starks matching coarse type SharypeCoarseSoftainer in its root
 */
- (BOOL)rootSoftainersOk ;

/*!
 @brief    Returns whether or not the receiver
 accepts starks matching coarse type SharypeCoarseNotch in its root
 */
- (BOOL)rootNotchesOk ;

- (NSString*)displayName ;

- (uint32_t)contentHash ;

- (NSSet*)unsupportedAttributesForSeparators;

- (Chaker*)chaker;

@end

