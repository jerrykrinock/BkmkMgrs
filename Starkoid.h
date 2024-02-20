#import <Cocoa/Cocoa.h>
#import "SSYManagedObject.h"

extern NSString* const constKeyLineage ;
extern NSString* const constKeyChangeType ;
extern NSString* const constKeyFromDisplayName ;

@interface Starkoid : SSYManagedObject {
}

@property (retain) NSNumber* changeType ;
@property (retain) NSNumber* sharypeCoarse ;
@property (retain) NSString* lineage ;
@property (retain) NSArray* updateDescriptions ;
@property (retain) NSString* fromDisplayName ;

/*!
 @brief    Returns 1 + the number of updateDescriptions in the
 receiver.

 @details  The constant 1 is for the lineage line. 
*/
- (NSInteger)numberOfSubrows ;

- (NSString*)lineageAndUpdates ;

- (BOOL)isInEssence:(Starkoid*)other ;

@end
