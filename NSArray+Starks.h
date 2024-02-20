#import <Cocoa/Cocoa.h>

@interface NSArray (Starks)

/*!
 @brief    Gets a new array with Starks of type ImmoveableContainer
 ignored but does not ignore their children

 @details  Iterates through the receiver.  If any Starks
 of type immoveableContainer are found, removes them from the 
 receiver and, in their place, adds all their children.
 @result   A new array, the receiver if no Starks of type
 immoveableContainer are found.
 */
- (NSArray*)arrayOfStarksByPromotingChildrenOfImmoveableContainers ;

/*!
 @brief    Returns YES if the receiver or any of its descendants
 contains one or more starks which is not a hartainer.
*/
- (BOOL)canMoveAnyMemberDescendant ;

@end
