#import <Cocoa/Cocoa.h>
#import "Stark.h"

/*!
 @brief    A category which answers questions about attribute
 capability for a Stark.
*/
@interface Stark (Attributability)

/*!
 @brief    Returns a set of all attributes of a Stark instance not related
 to a particular client or extore, not transient, not 'index', and not
 'sharype'.
 */
+ (NSSet*)genericAttributes ;

/*!
 @brief    Returns an array of attributes which would be most 
 interesting to the user, after the first two attributes or name
 and URL, if they are supported by a given Extore class.
*/
+ (NSArray*)thirdAttributePriority ;

/*!
 @brief    Returns whether or not the receiver can be given
 a URL
 
 @details  Bound to enabled binding "Visit this bookmark with"
 label and also the associated popup menu.
 */
- (BOOL)canHaveUrl ;

/*!
 @brief    Returns whether or not the receiver can be given
 a tags
 
 @details  Bound in Inspector
 */
- (BOOL)canHaveTags ;

/*!
 @brief    Returns whether or not the receiver can be given
 a shortcut
 
 @details  Bound in Inspector
*/
- (BOOL)canHaveShortcut ;

/*!
 @brief    Returns whether or not the receiver can be given
 a value for isShared.

 @details  Bound in Inspector
*/
- (BOOL)canBeShared ;

/*!
 @brief    Returns whether or not the receiver can be given
 children
 
 @details  Bound to enabled binding "Sort this folder?"
 label and also the associated popup menu.
 */
- (BOOL)canHaveChildren ;

/*!
 @brief    Returns whether or not the receiver can be given
 rss articles
 */
- (BOOL)canHaveRSSArticles ;

/*!
 @brief    Returns whether or not the receiver can be moved
 to a different index and/or parent.
 */
- (BOOL)isMoveable ;

/*!
 @brief    Returns whether or not any of the receiver's attributes
 should be editable by the user.
*/
- (BOOL)isEditable ;

/*!
 @brief    Returns whether or not the given attribute can possibly
 be edited for any member of the class.
 */
+ (BOOL)isEditableAttribute:(NSString*)attribute ;

/*!
 @brief    Returns whether or not the given attribute in the
 receiver is allowed to be edited by the user.
*/
- (BOOL)isEditableAttribute:(NSString*)attribute ;

- (BOOL)canHaveSortDirective;

@end
