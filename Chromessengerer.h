#import <Foundation/Foundation.h>

@interface Chromessengerer : NSObject

/*
 @details  We never uninstall this symlink, because it lies in our own
 Application Support folder; it's not going to hurt anyone.
*/
+ (BOOL)ensureSymlinkError_p:(NSError**)error_p ;

/*
 @param    path  The parent path of the "NativeMessagingHosts" folder into
 which the special manifest file should be installed.
 */
+ (BOOL)installSpecialManifestForAppSupportPath:(NSString*)path
                                        profile:(NSString*)profileName
                                      moreInfos:(NSDictionary*)moreInfos
                                        error_p:(NSError**)error_p ;

/*
 @brief    Uninstalls the special manifest file in the
 NativeMessagingHosts folder at a given path

 @param    path  The parent path of the "NativeMessagingHosts" folder from
 which the special manifest file should be removed.  This parameter is needed
 because each app (Chrome, Firefox, Chromium, Canary, whatever) has its own
 special manifest file in its own NativeMessagingHosts folder.
 */
+ (BOOL)uninstallSpecialManifestFileForPath:(NSString*)path
                                    error_p:(NSError**)error_p ;

@end
