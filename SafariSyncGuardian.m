#import "SafariSyncGuardian.h"
#import "SSYOtherApper.h"
#import "BkmxGlobals.h"
#import "BkmxBasis.h"
#import <unistd.h>

@implementation SafariSyncGuardian

+ (NSString*)syncServicesLockPathForDirectory:(NSString*)directory {
	return [directory stringByAppendingPathComponent:@"lock"] ;
}

+ (NSString*)syncServicesDetailsPathForDirectory:(NSString*)directory {
	return [[self syncServicesLockPathForDirectory:directory] stringByAppendingPathComponent:@"details.plist"] ;
}

+ (NSString*)processWhichHasLockedDirectory:(NSString*)directory {
#if 0
#warning SafariSyncGuardian is watching TextEdit instead of Safari's 'lock' file
	pid_t pid = [SSYOtherApper pidOfProcessNamed:@"TextEdit"
											user:NSUserName()] ;
	if (pid > 0) {
		return @"Damned TextEdit" ;
	}
#endif
	NSString* lockPath = [self syncServicesDetailsPathForDirectory:directory] ;
	BOOL isDirectory ;
	// For thread safety, create a file manager instead of using +defaultManager
	NSFileManager* fileManager = [[NSFileManager alloc] init] ;
	BOOL exists = [fileManager fileExistsAtPath:lockPath
									isDirectory:&isDirectory] ;
	[fileManager release] ;
	NSData* data = [NSData dataWithContentsOfFile:lockPath] ;
    NSDictionary* lockDic = nil ;
    if (data) {
        lockDic = [NSPropertyListSerialization propertyListWithData:data
                                                            options:0
                                                             format:NULL
                                                              error:NULL] ;
    }
    
	NSString* processName = @"Unknown process" ;
	
	if (!lockDic) {
		// Bad lock file.  Ignore it.
		return nil ;
	}
	else {

		NSNumber* lockPid = [lockDic objectForKey:@"LockFileProcessID"] ;
		if (!lockPid) {
			// Bad or missing lock file.  Ignore it.
			return nil ;
		}
		NSInteger pid = [lockPid integerValue] ;
		if (![SSYOtherApper isProcessRunningPid:(pid_t)pid
								   thisUserOnly:NO]) {
			NSLog(@"Ignoring lock file set by terminated process with pid %ld", (long)pid) ;
			NSError* error = nil ;
			// For thread safety, create a file manager instead of using +defaultManager
			NSFileManager* fileManager = [[NSFileManager alloc] init] ;
			BOOL ok = [fileManager removeItemAtPath:lockPath
											  error:&error] ;
			[fileManager release] ;
			if (ok) {
				NSLog(@"... and removed lock file") ;
			}
			else {
				NSLog(@"... but could not remove lock file because %@", error) ;
			}
			
			return nil ;
		}

		NSDate* lockDate = [lockDic objectForKey:@"LockFileDate"] ;
		if (!lockDate) {
			// Bad lock file.  Ignore it.
			return nil ;
		}
		NSTimeInterval timeSinceLock = -[lockDate timeIntervalSinceNow] ;
		if (timeSinceLock > 60.0) {
			NSLog(@"Ignoring lock on file %@ since it has been locked too long, %f secs.  Info: %@",
				  lockPath,
				  timeSinceLock,
				  lockDic) ;
			return nil ;
		}
		
		processName = [lockDic objectForKey:@"LockFileProcessName"] ;
	}

	if (exists && !isDirectory) {
		return processName ;
	}
	
	return nil ;
}

+ (BOOL)safariDavClientIsRunningForUser:(NSString*)user {
#if 0
#warning Simulating SafariDAVClient stuck on
	return YES ;
#endif
#if 0
#warning SafariSyncGuardian is watching TextEdit instead of SafariDAVClient
	pid_t pid = [SSYOtherApper pidOfProcessNamed:@"TextEdit"
											user:user] ;
#else
	pid_t pid = [SSYOtherApper pidOfProcessNamed:@"SafariDAVClient"
											user:user] ;
#endif
	return (pid != 0) ;
}

+ (SafariSyncGuardianResult)blockUntilSafeToWriteInDirectory:(NSString*)directory
                                               iCloudIsInUse:(BOOL)iCloudIsInUse
													 timeout:(NSTimeInterval)timeout
											   yieldeeName_p:(NSString**)yieldeeName_p
										progressUpdateTarget:(id)progressUpdateTarget
													selector:(SEL)progressUpdateSelector
													userInfo:(NSMutableDictionary*)progressUserInfo
                                    progressAlmostDoneTarget:(id)progressAlmostDoneTarget
                                                    selector:(SEL)progressAlmostDoneSelector
										  progressDoneTarget:(id)progressDoneTarget
													selector:(SEL)progressDoneSelector {
    SafariSyncGuardianResult result = SafariSyncGuardianResultSucceeded ;
    if (!iCloudIsInUse) {
        return result;
    }

    NSString* user ;
	NSArray* pathComponents = [directory pathComponents] ;
	// Path components are: "/", "Users", "jk", …
	if ([directory hasPrefix:@"/Users/"]  && [pathComponents count] > 2) {
		user = [pathComponents objectAtIndex:2] ;
	}
	else {
		NSLog(@"Internal Error 624-9874 %@", directory) ;
		user = NSUserName() ;
	}
	
#define SLEEPS_REQUIRED_AFTER_ICLOUD      9
#define SLEEPS_REQUIRED_AFTER_FILE_LOCK   5
#define SLEEPS_REQUIRED_TO_BE_ALMOST_DONE 4  // Should be less than either of the previous two
    
	NSDate* startDate = [NSDate date] ;
	NSInteger successCount = 0 ;
	SafariSyncGuardianResult failureReason = SafariSyncGuardianResultUndefined ;
	
	NSInteger successesRequired = 1 ;
	NSString* yieldeeName = nil ;
	BOOL almostDone = NO ;
	BOOL didShowProgress = NO ;
	while (YES) {
		// There are two conditions we need to check.
		// Condition 1.  SafariDavClient not running.
		if (user) {
            if ([self safariDavClientIsRunningForUser:user]) {
                successCount = 0 ;
				almostDone = NO ;
				successesRequired = MAX(successesRequired, SLEEPS_REQUIRED_AFTER_ICLOUD) ;
				yieldeeName = @"iCloud" ;
				failureReason = SafariSyncGuardianResultFailedIcloudIsSyncing ;
			}
			else {
				// Condition 2.  Lock file is not present.
				NSString* yieldee2Name = [self processWhichHasLockedDirectory:directory] ;
				if (yieldee2Name) {
					yieldeeName = yieldee2Name ;
					almostDone = NO ;
					successCount = 0 ;
					successesRequired = MAX(successesRequired, SLEEPS_REQUIRED_AFTER_FILE_LOCK) ;
					failureReason = SafariSyncGuardianResultFailedLockInUseByOther ;
				}
				else {
					successCount ++ ;
				}			
			}
		}
		
		// Process state, either returning or continuing
		if (successCount >= successesRequired) {
			// Done
			result = SafariSyncGuardianResultSucceeded ;
			break ;
		}
		else if ([startDate timeIntervalSinceNow] < -timeout) {
			// Timed out
			result = failureReason ;
			if (yieldeeName_p) {
				*yieldeeName_p = yieldeeName ;
			}
			break ;
		}
		else if (successCount > SLEEPS_REQUIRED_TO_BE_ALMOST_DONE) {
			if (!almostDone) {
				almostDone = YES ;
                [progressAlmostDoneTarget performSelector:progressAlmostDoneSelector
                                               withObject:yieldeeName
                                               withObject:progressUserInfo] ;
			}
		}
		
		if (![[BkmxBasis sharedBasis] isBkmxAgent] && !almostDone) {
            NSTimeInterval elapsedTime = -[startDate timeIntervalSinceNow] ;
            [progressUserInfo setObject:[NSNumber numberWithDouble:elapsedTime]
                                 forKey:constKeyCurrentValue] ;
			[progressUpdateTarget performSelector:progressUpdateSelector
                                       withObject:yieldeeName
                                       withObject:progressUserInfo] ;
			didShowProgress = YES ;
		}
		
		sleep(1.0) ;
	}
	
	if (didShowProgress) {
		if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
			[progressDoneTarget performSelector:progressDoneSelector] ;
		}
	}
	
	return result ;	
}

+ (void)abscondLockForDirectory:(NSString*)directory {	
	NSDictionary* lockDic = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSDate date], @"LockFileDate",
							 @"localhost", @"LockFileHostname",
							 [NSNumber numberWithInteger:[[NSProcessInfo processInfo] processIdentifier]], @"LockFileProcessID",
							 [[[[NSProcessInfo processInfo] arguments] objectAtIndex:0] lastPathComponent], @"LockFileProcessName",
							 NSFullUserName(), @"LockFileUsername",
							 nil] ;
	NSString* lockPath = [self syncServicesLockPathForDirectory:directory] ;
	NSError* error = nil ;
	// For thread safety, create a file manager instead of using +defaultManager
	NSFileManager* fileManager = [[NSFileManager alloc] init] ;
	[fileManager createDirectoryAtPath:lockPath
		   withIntermediateDirectories:YES
							attributes:nil
								 error:&error] ;
	[fileManager release] ;
	if (error) {
		NSLog(@"Internal Error 248-0938 %@", error) ;
	}
	NSString* detailsPath = [self syncServicesDetailsPathForDirectory:directory] ;
	NSData* data = [NSPropertyListSerialization dataWithPropertyList:lockDic
                                                              format:NSPropertyListXMLFormat_v1_0
                                                             options:0
                                                               error:NULL] ;
	[data writeToFile:detailsPath
		   atomically:YES] ;
}


+ (void)relinquishLockForDirectory:(NSString*)directory {
	NSString* removePath ;
	removePath = [self syncServicesDetailsPathForDirectory:directory] ;

	// For thread safety, create a file manager instead of using +defaultManager
	NSFileManager* fileManager = [[NSFileManager alloc] init] ;
	NSError* error = nil ;

	[fileManager removeItemAtPath:removePath
							error:&error] ;
	if (error) {
		NSLog(@"Internal Error 345-9678 %@", error) ;
	}
	error = nil ;

	removePath = [self syncServicesLockPathForDirectory:directory] ;
	[fileManager removeItemAtPath:removePath
											   error:&error] ;
	if (error) {
		NSLog(@"Internal Error 194-8497 %@", error) ;
	}

	[fileManager release] ;
}


@end
