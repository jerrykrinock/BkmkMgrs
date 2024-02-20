#import <Foundation/Foundation.h>

extern NSString* const SSYFixPermissionsErrorDomain ;

enum SSYFixResult_enum {
    SSYFixResultDidNotTry                      = -1,
    SSYFixResultWasOk                          = 0,
    SSYFixResultWasBadFixed                    = 1,
    SSYFixResultIgnoredInitialFixSucceeded     = 2, // Did not probe initial state
    // Numbers were changed in BookMacster 1.22.3
    SSYFixResultWasBadCouldNotFix              = 3,
    SSYFixResultCouldNotDetermineOriginalState = 4,
    SSYFixResultIgnoredInitialFixFailed        = 5 // Did not probe initial state
} ;
typedef enum SSYFixResult_enum SSYFixResult ;


@interface NSFileManager (SSYFixPermissions)

/*
 @brief    Changes permissions of file system item at a given path to have
 given owner and/or POSIX permissions
 @details  Will fail if changes cannot be performed with current
 process privileges.
 @param    targetPermissions  Desired POSIX permissions.  Pass a negative number
 to not touch the path's POSIX permissions.
 @param    targetOwner  Desired owner of file, in the form of the unix short
 name such as that returned by NSUserName(), or nil to not touch the path's
 owner */
 - (SSYFixResult)fixPermissions:(NSInteger)targetPermissions
                         owner:(NSString*)targetOwner
                          path:(NSString*)path
                       error_p:(NSError**)error_p ;

/*
 @brief    Ensures that the user's home directory's owner is
 NSUserName() and permissions are octal 0755.
 @details  Will fail if changes cannot be performed with current
 process privileges.
 */
- (SSYFixResult)fixPermissionsOfHomeFolder:(NSError**)error_p ;

/*
 @brief    Ensures that owner of ~/Library is
 NSUserName() and permissions are octal 0700.
 @details  Will fail if changes cannot be performed with current
 process privileges.
 */
- (SSYFixResult)fixPermissionsOfLibraryFolder:(NSError**)error_p ;

/*
 @brief    Ensures that owner of ~/Library/LaunchAgents is
 NSUserName() and permissions are octal 0700.
 @details  Will fail if changes cannot be performed with current
 process privileges.
 */
- (SSYFixResult)fixPermissionsOfLaunchAgentsFolder:(NSError**)error_p ;

@end
