#import <Foundation/Foundation.h>

#define kServiceName @"com.apple.SafariBookmarksSyncAgent"
#define CDUnknownBlockType id

@interface SafariBookmarksSyncAgent : NSObject <NSXPCListenerDelegate> {
    NSObject *_bookmarkStore;
    NSXPCListener *_xpcListener;
    NSObject *_pushConnection;
    BOOL _isSyncing;
    BOOL _isMigrating;
    BOOL _periodicallyObservingRemoteMigrationState;
    NSObject *_bookmarksSubscription;
    NSObject *_databaseLockArbiter;
    NSObject *_syncMigrationCoordinator;
    NSObject *_migrationCoordinator;
    NSObject *_bookmarkSyncCoordinator;
    NSObject<OS_dispatch_queue> *_activityCheckInQueue;
    unsigned long long _numberOfFailedBookmarksZoneSubscriptionRegistrationAttempts;
    BOOL _ignoreOngoingBookmarksZoneSubscriptionRegistrationResult;
    NSObject<OS_dispatch_source> *_bookmarksZoneSubscriptionRegistrationTimer;
    NSObject *_cyclerAssistant;
    NSMutableSet *_detectedBugIDs;
    NSUserDefaults *_safariUserDefaults;
    NSTimer *_hierarchyCheckTimer;
    BOOL _isRegisteringForCloudTabsZoneSubscription;
    NSObject *_tabSyncCoordinator;
}

- (void)_hierarchyCheckerDidFail;
- (void)_performHiearchyCheck;
- (void)_hierarchyCheckTimer:(id)arg1;
- (void)_invalidateHierarchyCheckTimer;
- (void)_scheduleHierarchyCheckTimer;
- (void)_sendDetectedBugNotificationIfNeeded;
- (void)_didDetectPossibleBug:(id)arg1;
- (id)_cyclerAssistant;
- (void)_registerPeriodicRemoteMigrationStateObserverXPCActivityRegisteringIfNeeded:(BOOL)arg1;
- (void)observeRemoteMigrationStateForSecondaryMigration;
- (void)_registerBookmarksZoneSubscriptionXPCActivityRegisteringIfNeeded:(BOOL)arg1 ignoreOngoingRegistration:(BOOL)arg2 qualityOfService:(long long)arg3 delay:(long long)arg4;
- (double)_retryIntervalToRegisterBookmarksZoneSubscriptionWithNumberOfFailedAttempts:(long long)arg1 lastCKError:(id)arg2;
- (void)_checkInXPCActivityWithIdentifier:(const char *)arg1 criteria:(id)arg2 registerIfNeeded:(BOOL)arg3 performBlock:(CDUnknownBlockType)arg4;
- (void)_migrateFromDAVWithCompletion:(CDUnknownBlockType)arg1;
- (void)_updateCloudTabsSyncCoordinatorAfterUserAccountChange:(long long)arg1;
- (void)_didReceiveCloudTabsSubscriptionPushNotification;
- (void)_registerCloudTabsZoneSubscriptionIfNeeded;
- (void)_attemptSyncAndFallBackToMigrationIfPossibleForTrigger:(long long)arg1;
- (void)_didReceiveBookmarksSubscriptionPushNotification;
- (void)_saveZoneSubscriptionsIfNeededForRecordZone:(long long)arg1 withCompletionHandler:(CDUnknownBlockType)arg2;
- (id)_pushTopic;
- (void)_setUpPushConnection;
- (void)connection:(id)arg1 didReceiveIncomingMessage:(id)arg2;
- (void)connection:(id)arg1 didReceiveToken:(id)arg2 forTopic:(id)arg3 identifier:(id)arg4;
- (void)connection:(id)arg1 didReceivePublicToken:(id)arg2;
- (BOOL)listener:(id)arg1 shouldAcceptNewConnection:(id)arg2;
- (void)migrateToCloudKitWithCompletionHandler:(CDUnknownBlockType)arg1;
- (void)generateDAVServerIDsForExistingBookmarksWithCompletionHandler:(CDUnknownBlockType)arg1;
- (void)clearLocalDataIncludingMigrationState:(BOOL)arg1 completionHandler:(CDUnknownBlockType)arg2;
- (void)resetToDAVDatabaseWithCompletionHandler:(CDUnknownBlockType)arg1;
- (void)fetchSyncedCloudTabDevicesAndCloseRequestsWithCompletionHandler:(CDUnknownBlockType)arg1;
- (void)deleteCloudTabCloseRequestsWithUUIDStrings:(id)arg1 completionHandler:(CDUnknownBlockType)arg2;
- (void)deleteDevicesWithUUIDStrings:(id)arg1 completionHandler:(CDUnknownBlockType)arg2;
- (void)saveCloudTabCloseRequestWithDictionaryRepresentation:(id)arg1 closeRequestUUIDString:(id)arg2 completionHandler:(CDUnknownBlockType)arg3;
- (void)saveTabsForCurrentDeviceWithDictionaryRepresentation:(id)arg1 deviceUUIDString:(id)arg2;
- (void)collectDiagnosticsDataWithCompletionHandler:(CDUnknownBlockType)arg1;
- (void)_beginMigrationFromDAV;
- (void)beginMigrationFromDAV;
- (void)fetchRemoteMigrationStateWithCompletionHandler:(CDUnknownBlockType)arg1;
- (void)_sendNotificationForSyncResult:(long long)arg1;
- (void)_performBookmarkSyncForTrigger:(long long)arg1 completionHandler:(CDUnknownBlockType)arg2;
- (void)_userDidUpdateBookmarkDatabase;
- (void)userDidUpdateBookmarkDatabase;
- (BOOL)_isSyncEnabled;
- (void)_updatePushTopicSubscriptions;
- (void)_userAccountDidChange:(long long)arg1;
- (void)userAccountDidChange:(long long)arg1;
- (void)fetchUserIdentityWithCompletionHandler:(CDUnknownBlockType)arg1;
- (void)registerForPushNotificationsIfNeeded;
- (id)init;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) Class superclass;

@end
