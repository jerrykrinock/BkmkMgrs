#import <Cocoa/Cocoa.h>
#import "BkmxAppDel.h"

extern NSString* const constKeyVisitorDefaultDocument ;
extern NSString* const constKeyVisitorDefaultBrowser ;


@interface BkmxAppDel (Capabilities)

/*!
 @brief    Returns an array of supported exformats that have a given
 sharype.

 @details  Examines the constants hasBar, hasMenu, etc. for the Extore
 class of each supported exformat.
*/
- (NSArray*)exformatsThatHaveSharype:(Sharype)sharype ; 

/*!
 @brief    Returns the subarray of -supportedOwnerApps for which
 this application can create new documents
 */
- (NSArray*)ownerAppsForWhichICanCreateNewDocumuments ;

/*!
 @brief    Returns the array of the possible values for a given key
 in a stark, or nil if the given key does not have enumerated values
 for a stark.
*/
- (NSArray*)starkChoicesForKey:(NSString*)key ;

/*!
 @brief    Returns an array containing two NSNumbers whose boolean
 values are YES and NO.
*/
- (NSArray*)booleanChoices ;

@end
