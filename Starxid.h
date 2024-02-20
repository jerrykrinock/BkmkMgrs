#import <Cocoa/Cocoa.h>
#import "SSYManagedObject.h"

@class Clixid ;

/*!
 @brief    An object which joins a given Stark to a given exid
 for a given Client.
*/
@interface Starxid : SSYManagedObject {
}

/*!
 @brief    The starkid of the stark which is relevant to the receiver.
*/
@property (retain) NSString* starkid ;

/*!
 @brief    The set of Clixid objects which represent the receiver's
 Client <--> exid mappings.
 */
@property (retain) NSSet* clixids ;

@end


