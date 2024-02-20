#import <Cocoa/Cocoa.h>
#import "SSYMojo.h"

@class Stark ;

/*!
 @brief    Class for getting and setting Starxid objects in 
 documents' exDocMocs.

 @details  Class methods access a singleton dictionary of
 Starxider instances (one per document) under the hood.
*/
@interface Starxider : SSYMojo {
	NSMutableDictionary* m_cache ;
}

/*!
 @brief    Designated initializer for Starxider
*/
- (id)initWithDocUuid:(NSString*)docUuid ;

/*!
 @brief    Returns a dictionary of all exids found in the
 receiver's cache for a given stark.
 
 @details  Keys are the clientoids of the Clients and
 values are their exid strings for the given stark.
 */
- (NSDictionary*)exidsForStark:(Stark*)stark ;

/*!
 @brief    Synchronizes the Clixid objects in the Starxid
 object for a given Stark in the receiver's cache to exactly
 represent the clientoid:exid pairs in a given dictionary,
 removing any which do not exist in the dictionary, and
 creating the Starxid it it does not exist.
 
 @param    exids  Keys are the clientoids of the Clients
 and values are their exid strings.  If nil, removes
 all clientoid:exid entries in the receiver
 */
- (void)setAllExids:(NSDictionary*)exids
		   forStark:(Stark*)stark ;

/*!
 @brief    Deletes the Starxid object whose starkid matches
 that of a given stark from its managed object context,
 and removes it from the receiver's cache.

 @param    stark  
*/
- (void)deleteStarxidForStark:(Stark*)stark ;

@end
