#import <Cocoa/Cocoa.h>

enum SafariSyncGuardianResult_enum {
	SafariSyncGuardianResultUndefined                 = 0,
	SafariSyncGuardianResultSucceeded                 = 1,
	SafariSyncGuardianResultFailedIcloudIsSyncing     = 2,
	SafariSyncGuardianResultFailedLockInUseByOther    = 3
} ;

/*!
 @details  If *both* iCloud is syncing, *and* the file is 
 locked by another process, the answer is
 SafariSyncGuardianResultFailedIcloudIsSyncing.
*/
typedef enum SafariSyncGuardianResult_enum SafariSyncGuardianResult ;


@interface SafariSyncGuardian : NSObject

/*!
 @brief    Waits until there is no Sync Services Lock in the parent
 directory of Safari's Bookmarks.plist, and until SafariDAVClient is
 inactive

 @details  This method may be invoked from a secondary thread.  It will
 invoke the progressUpdate target/selector on progressDone target/selector
 on the same thread, so make sure that is safe.
*/
+ (SafariSyncGuardianResult)blockUntilSafeToWriteInDirectory:(NSString*)directory
                                               iCloudIsInUse:(BOOL)iCloudIsInUse
													 timeout:(NSTimeInterval)timeout
											   yieldeeName_p:(NSString**)yieldeeName_p
										progressUpdateTarget:(id)progressUpdateTarget
													selector:(SEL)progressUpdateSelector
													userInfo:(NSMutableDictionary*)progressUpdateUserInfo
                                    progressAlmostDoneTarget:(id)progressAlmostDoneTarget
                                                    selector:(SEL)progressAlmostDoneSelector
										  progressDoneTarget:(id)progressDoneTarget
													selector:(SEL)progressDoneSelector ;

/*!
 @brief    Writes its own Sync Services Lock and returns YES,
 unless a given timeout is exceeded, then does nothing and returns
 NO.

 @details  This method may be invoked from a secondary thread.
 
 This method rudely overwrites (absconds) any existing lock on the Safari
 Bookmarks.plist.  Thus, before invoking this method you should invoke
 blockUntilSafeToWriteInDirectory:::::::: and get a successful result.
 
 * SafariDAVClient
 
 * SafariDAVClient is the local sync client for iCloud bookmarks.
 One would not want to mess with Safari bookmarks while
 SafariDAVClient is active, because, oddly, instead of waiting until
 it has all the data and then writing the file, during a long sync
 operation involving uploading or downloading hundreds or thousands
 of bookmarks, SafariDAVClient writes data to Bookmarks.plist every 
 few seconds.
 
 * Sync Services
 
 Sync Services is depracated in 10.7 but may still exist on some systems.
 
 A Sync Services Lock is a directory named "lock" in
 a given directory which seems to inhibit other Sync-Services-aware
 applications, and probably Sync Services itself, from writing to
 the directory.  It contains a single plist file named 
 "details.plist" in XML format which contains keys giving the name
 and unix process ID of the process which wrote the file, the time
 the file was written, username under which and hostname in which
 the process was running.
 
 The behavior I see is that if Sync Services or a Sync-Services-aware
 application wants to write a file to a directory, it first checks
 to see if the directory has a Sync Services Lock.  If so, it
 checks to see if the process indicated in its details.plist file is
 alive.  If so, it waits a long time (at least 30 seconds,
 possibly indefinitely) for the Sync Services Lock to be removed.   
 If not, it ignores it.  In either case, it then writes its
 own Sync Services Lock and then, when it is done writing, removes
 the Sync Services Lock, both the details.plist file and the lock
 directory which contains it.
 
 So, the Sync Services Lock seems to provide an effective lock on the
 directory, and also fail-safely removes the lock in case the process
 which acquired the lock crashes.  Probably the hostname and 
 username are checked also and compared with the current availability
 and login-edness of these entities.
 
 @param    directory  The directory in which the relevant Bookmarks.plist
 file is located.  Ususally, you pass /Users/CurrentUser/Library/Safari,
 but you can also pass /path/to/SomeOtherUser/Library/Safari.
*/
+ (void)abscondLockForDirectory:(NSString*)directory ;

/*!
 @brief    Relinquishes a lock previously set by -abscondLockForDirectory:

 @details  This method may be invoked from a secondary thread.
*/
+ (void)relinquishLockForDirectory:(NSString*)directory ;

@end
