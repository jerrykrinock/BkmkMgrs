#import "NSFileManager+SSYFixPermissions.h"
#import "NSError+InfoAccess.h"

NSString* const SSYFixPermissionsErrorDomain = @"SSYFixPermissionsErrorDomain" ;

@implementation NSFileManager (SSYFixPermissions)

- (SSYFixResult)fixPermissions:(NSInteger)targetPermissions
                         owner:(NSString*)targetOwner
                          path:(NSString*)path
                       error_p:(NSError**)error_p {
    SSYFixResult result ;
    NSError* error = nil ;
    NSNumber* permissions = nil ;
    NSString* owner = nil ;

    if (!targetOwner && (targetPermissions < 0)) {
        result = SSYFixResultWasOk ;
    }
    else {
        NSDictionary* attributes = [self attributesOfItemAtPath:path
                                                          error:&error] ;
        if (!attributes) {
            result = SSYFixResultCouldNotDetermineOriginalState ;
        }
        else {
            owner = [attributes objectForKey:NSFileOwnerAccountName] ;
            permissions = [attributes objectForKey:NSFilePosixPermissions] ;
            if (!owner || !permissions) {
                result = SSYFixResultCouldNotDetermineOriginalState ;
            }
            else {
                NSMutableDictionary* attributesToFix = [[NSMutableDictionary alloc] init] ;
                if (targetOwner && ![owner isEqualToString:targetOwner]) {
                    [attributesToFix setObject:targetOwner
                                        forKey:NSFileOwnerAccountName] ;
                }
                if ((targetPermissions >= 0) && ([permissions integerValue] != targetPermissions)) {
                    [attributesToFix setObject:[NSNumber numberWithInteger:targetPermissions]
                                        forKey:NSFilePosixPermissions] ;
                }
                
                if ([attributesToFix count] == 0) {
                    result = SSYFixResultWasOk ;
                }
                else {
                    BOOL ok = [[NSFileManager defaultManager] setAttributes:attributesToFix
                                                               ofItemAtPath:path
                                                                      error:&error] ;
                    result = ok ? SSYFixResultWasBadFixed : SSYFixResultWasBadCouldNotFix ;
                }
                
                [attributesToFix release] ;
            }
        }
    }
    
    if ((error || (result == SSYFixResultCouldNotDetermineOriginalState) || (result == SSYFixResultWasBadCouldNotFix)) && error_p) {
        error = [[NSError errorWithDomain:SSYFixPermissionsErrorDomain
                                    code:(137100 + result)
                                userInfo:nil] errorByAddingUnderlyingError:error] ;
        error = [error errorByAddingLocalizedDescription:@"Could not fix file permissions"] ;
        error = [error errorByAddingUserInfoObject:path
                                            forKey:@"Path"] ;
        error = [error errorByAddingUserInfoObject:owner
                                            forKey:@"Current Owner"] ;
        error = [error errorByAddingUserInfoObject:permissions
                                            forKey:@"Current POSIX Permissions"] ;
        *error_p = error ;
    }
    
    return result ;
}


- (SSYFixResult)fixPermissionsOfHomeFolder:(NSError**)error_p {
    return [self fixPermissions:0755  // See Note Octals, below
                          owner:NSUserName()
                           path:NSHomeDirectory()
                        error_p:error_p] ;
}

- (SSYFixResult)fixPermissionsOfLibraryFolder:(NSError**)error_p {
    return [self fixPermissions:0755  // See Note Octals, below
                          owner:NSUserName()
                           path:[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
                        error_p:error_p] ;
}

- (SSYFixResult)fixPermissionsOfLaunchAgentsFolder:(NSError**)error_p {
    return [self fixPermissions:0700  // See Note Octals, below
                          owner:NSUserName()
                           path:[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"LaunchAgents"]
                        error_p:error_p] ;
}

@end

/* Note Octals: In 0700 or 0755, the 0 is a prefix which says to interpret the
 remainder of the digits as octal, just as 0x is a prefix which says to
 interpret the remainder of the digits as hexidecimal.  It's in the C
 language standard! */
