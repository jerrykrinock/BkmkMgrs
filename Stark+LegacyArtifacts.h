#import <Cocoa/Cocoa.h>

#import "Stark.h"

/*!
 @brief    A class for dealing with artifacts in bookmarks left by Bookdog

 @details  Legacy artifacts are (1) the UUID put in Opera comments and
 (2) the prefixes " " or "~" on item names.
*/
@interface Stark (LegacyArtifacts)

/*!
 @brief    Returns whether or not the receiver has any legacy artifacts.
*/
- (BOOL)hasLegacyArtifacts ;

/*!
 @brief    Examines the receiver's name to see if there is a " " or "~" and
 if so sets the receiver's sortDirective to the indicated value, and optionally
 removes the prefix.

 @param    doRemove  NO to only set sortDirective, YES to remove the prefix also.
 @result   YES if one of the prefixes was found, otherwise NO.
*/
- (BOOL)updateSortDirectivesRemoveLegacy:(BOOL)doRemove ;

- (BOOL)removeLegacyUUIDFromComments ;

- (BOOL)removeLegacyUUIDFromBrowprietaries ;


@end
