#import <Cocoa/Cocoa.h>
#import "SSWebBrowsing.h"


@interface SSWebBrowsing (Bkmx) 



/*!
 @brief    Returns by reference the Class and exformat of the an extore,
 if any, whose extore media is that of a local app supported by
 BookMacster, and one of whose +browserBundleIdentifier objects matches a
 given bundle identifier.
 
 @details  If the given bundle identifier does not match either bundle
 identifier (1 or 2) of any local app supported by BookMacster, upon
 return, both output references point to NULL or nil.
 
 Both references are checked for NULL before assigning pointers, so you
 can pass NULL to any reference you are not interested in.
 */
+ (void)getFromBundleIdentifier:(NSString*)bundleIdentifier
				  extoreClass_p:(Class*)extoreClass_p
					 exformat_p:(NSString**)exformat_p ;
	

/*!
 @brief    Returns by reference the Class of the extore of the active
 web browser, the exformat of the active web browser, and the bundle
 identifier and path of the active web browser.

 @details  If the active application is not a web browser, upon
 return, all three output references point to NULL or nil.
 
 All references are checked for NULL before assigning pointers, so you
 can pass NULL to any reference you are not interested in.
*/
+ (void)getActiveBrowserExtoreClass:(Class*)extoreClass_p
						 exformat_p:(NSString**)exformat_p
				 bundleIdentifier_p:(NSString**)bundleIdentifier_p
							 path_p:(NSString**)path_p ;

@end
