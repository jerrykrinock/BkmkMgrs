#import "Chromessengerer.h"
#import "NSError+InfoAccess.h"
#import "NSFileManager+SomeMore.h"
#import "BkmxAppDel+Capabilities.h"
#import "ExtoreChromy.h"
#import "ExtoreOpera.h"
#import "ExtoreFirefox.h"
#import "NSArray+Stringing.h"
#import "BkmxBasis+Strings.h"
#import "SSYOtherApper.h"
#import "NSError+MoreDescriptions.h"
#import "NSError+MyDomain.h"
#import "NSBundle+MainApp.h"
#import "NSArray+SafeGetters.h"
#import "NSBundle+SSYMotherApp.h"
#import "NSString+MorePaths.h"
#import "NSDictionary+BSJSONAdditions.h"
#import "NSBundle+HelperPaths.h"

NSString* const chromessengerJavaScriptName = @"com.sheepsystems.chromessenger" ;

@implementation Chromessengerer

+ (NSString*)messengerFullName {
	return @"Chromessenger" ;
}

+ (NSString*)symlinkParentPath {
    NSBundle* mainAppBundle = [NSBundle mainAppBundle] ;
	NSString* path = [mainAppBundle applicationSupportPathForMotherApp] ;
	
	return path ;
}

+ (NSString*)symlinkFullPath {
	NSString* path = nil ;
	NSString* fullName = [self messengerFullName] ;
	if (fullName) {
		path = [self symlinkParentPath] ;
		path = [path stringByAppendingPathComponent:fullName] ;
	}
    
	return path ;
}

+ (NSString*)specialManifestParentPathForPath:(NSString*)path {
    return [path stringByAppendingPathComponent:@"NativeMessagingHosts"] ;
}

+ (NSString*)specialManifestPathForPath:(NSString*)path {
    NSString* filename = [chromessengerJavaScriptName stringByAppendingPathExtension:@"json"] ;
    return [[self specialManifestParentPathForPath:path] stringByAppendingPathComponent:filename] ;
}

+ (NSString*)toolPath {
    NSString* toolPath = [[NSBundle mainAppBundle] pathForHelper:[self messengerFullName]] ;
    if (!toolPath) {
        NSLog(@"Internal Error 298-0034") ;
    }

    return toolPath ;
}

+ (BOOL)ensureSymlinkError_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
	
	NSString* toolPath = [self toolPath] ;
	NSString* symlinkPath = [self symlinkFullPath] ;

	// Read any existing path; maybe it's OK.
    NSString* existingPath = [[NSFileManager defaultManager] destinationOfSymbolicLinkAtPath:symlinkPath
                                                                                       error:NULL] ;
    if (![existingPath isEqualToString:toolPath]) {
        // Either symlink does not exist, or is wrong.
        
        // Remove any existing symlink, because -createSymbolicLinkAtPath:::
        // will fail if existing file is found.  Ignore the result, but
		// remembering the removeError which we shall report in the
		// event that the copy fails.
        NSError* removeError = nil ;
		[[NSFileManager defaultManager] removeItemAtPath:symlinkPath
												   error:&removeError] ;

        // Create the "BookMacster " subdirectory if it does not exist
		NSError* createDirectoryError = nil ;
		// Although this method should succeed even in the normal case, when
		// "BookMacster" already exists, we ignore its return BOOL, just
		// in case it's a false alarm.  We will, however, report the error if
		// copying the file, the important step, fails.
        [[NSFileManager defaultManager] ensureDirectoryAtPath:[self symlinkParentPath]
                                                      error_p:&createDirectoryError] ;
        
		ok = [[NSFileManager defaultManager] createSymbolicLinkAtPath:symlinkPath
                                                  withDestinationPath:toolPath
                                                                error:&error] ;
        
        if (!ok) {
            error = [SSYMakeError(513059, @"Could not copy messenger") errorByAddingUnderlyingError:error] ;
            error = [error errorByAddingUserInfoObject:removeError
                                                forKey:@"Error Removing Existing File"] ;
            error = [error errorByAddingUserInfoObject:createDirectoryError
                                                forKey:@"Error Creating Our App Support Directory"] ;
        }
    }
    
	if (error && error_p) {
        error = [error errorByAddingUserInfoObject:toolPath
                                            forKey:@"Tool Path"] ;
        error = [error errorByAddingUserInfoObject:symlinkPath
                                            forKey:@"Symlink Path"] ;
		*error_p = error ;
	}
	
	return ok ;
}

+ (BOOL)installSpecialManifestForAppSupportPath:(NSString*)path
                                        profile:(NSString*)profileName
                                      moreInfos:(NSDictionary*)moreInfos
                                        error_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;

    if (path) {
        NSString* symlinkPath = [self symlinkFullPath] ;
        /* Install the "special manifest file" which the browsers require to
         find our Chromessenger tool and make it all of our extensions "allowed
         origins".  Extensions for Chrome, Canary, Chromium and Vivaldi all come
         from the Chrome Web Store and have the samd uuid.  The extensions from the
         Opera web store, and the extension signed by Mozilla for Firefox,  have a
         different uuid.  We must include all of them as allowed origins, for those
         users which have the Opera extension installed
         along with one of the others. */

        NSDictionary* manifestDicConstants = @{ @"name": chromessengerJavaScriptName,
                                                @"description": @"Enables Sheep Systems bookmarks management apps",
                                                @"path": symlinkPath,
                                                @"type": @"stdio"};
        NSMutableDictionary* manifestDic = [manifestDicConstants mutableCopy];
        [manifestDic addEntriesFromDictionary:moreInfos];

        NSString* manifestString = [manifestDic jsonStringValue] ;
        [manifestDic release];

        NSString* manifestParentPath = [self specialManifestParentPathForPath:path] ;
        ok = [[NSFileManager defaultManager] createDirectoryAtPath:manifestParentPath
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error] ;
        if (!ok) {
            error = [SSYMakeError(158143, @"Could not install NativeMessagingHosts folder") errorByAddingUnderlyingError:error] ;
            error = [error errorByAddingUserInfoObject:manifestParentPath
                                                forKey:@"Manifest Parent Path"] ;
        }

        if (ok) {
            NSString* manifestPath = [self specialManifestPathForPath:path] ;
            ok = [manifestString writeToFile:manifestPath
                                  atomically:YES
                                    encoding:NSUTF8StringEncoding
                                       error:&error] ;
            if (!ok) {
                error = [SSYMakeError(158144, @"Could not install special manifest file for Chromessenger") errorByAddingUnderlyingError:error] ;
                error = [error errorByAddingUserInfoObject:manifestPath
                                                    forKey:@"Manifest Path"] ;
            }
        }
    }
    
    if (error && error_p) {
        error = [error errorByAddingUserInfoObject:path
                                            forKey:@"Path"] ;
        *error_p = error ;
    }
	
    return ok ;
}

+ (BOOL)uninstallSpecialManifestFileForPath:(NSString*)path
                                    error_p:(NSError**)error_p {
	BOOL ok ;
    NSError* error = nil ;
    ok = [[NSFileManager defaultManager] removeThoughtfullyPath:[self specialManifestPathForPath:path]
                                                        error_p:&error] ;
    return ok ;
}

@end
