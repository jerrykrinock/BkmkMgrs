#import <Cocoa/Cocoa.h>
#import "SSYManagedObject.h"

@class Starxid ;

/*!
 @brief    An object which gives the exid for a given Client,
 as related to a given Starxider.
*/
@interface Clixid : SSYManagedObject {
}

/*!
 @brief    The starkid which relates the receiver to its stark.
 */
@property (retain) Starxid* starxid ;

/*!
 @brief    The "external identifier"; a string representation of the
 identifier by which the web browser or service of the receiver's
 Client uniquely identifies a bookmark, folder or separator.
*/
@property (retain) NSString* exid ;

/*!
 @brief    The clidentifier of the Client which is relevant to the receiver.
 */
@property (retain) NSString* clidentifier ;

@end


