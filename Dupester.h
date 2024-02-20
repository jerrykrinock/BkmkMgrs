#import <Cocoa/Cocoa.h>
#import "SSYMojo.h"
#import "SSYErrorHandler.h"


/*!
 @brief    An SSYMojo which is initialized with entity Dupe_entity.
*/
@interface Dupester : SSYMojo {
}

/*!
 @brief    Designated initializer

 @details  Parameters are forwarded to superclass.
*/
- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext_ ;

@end
