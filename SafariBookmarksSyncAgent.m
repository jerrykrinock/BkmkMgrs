/* This file is not used in any target.  It is here because, at one point,
 I tried to disable SIP and replace the real SafariBookmarksSyncAgent with my
 own phony *stingray* SafariBookmarksSyncAgent so I could see how it was
 called.  The attempt failed for inexplicable reasons and I gave up. */

#import "SafariBookmarksSyncAgent.h"

@protocol Whatever
@end

@implementation SafariBookmarksSyncAgent

- (void)_hierarchyCheckerDidFail {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_performHiearchyCheck {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_hierarchyCheckTimer:(id)arg1 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_invalidateHierarchyCheckTimer {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_scheduleHierarchyCheckTimer {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_sendDetectedBugNotificationIfNeeded {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_didDetectPossibleBug:(id)arg1 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (id)_cyclerAssistant {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
    return nil;
}

- (void)_registerPeriodicRemoteMigrationStateObserverXPCActivityRegisteringIfNeeded:(BOOL)arg1 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)observeRemoteMigrationStateForSecondaryMigration {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_registerBookmarksZoneSubscriptionXPCActivityRegisteringIfNeeded:(BOOL)arg1 ignoreOngoingRegistration:(BOOL)arg2 qualityOfService:(long long)arg3 delay:(long long)arg4 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (double)_retryIntervalToRegisterBookmarksZoneSubscriptionWithNumberOfFailedAttempts:(long long)arg1 lastCKError:(id)arg2 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
    return 30.0;
}

- (void)_checkInXPCActivityWithIdentifier:(const char *)arg1 criteria:(id)arg2 registerIfNeeded:(BOOL)arg3 performBlock:(CDUnknownBlockType)arg4 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_migrateFromDAVWithCompletion:(CDUnknownBlockType)arg1 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_updateCloudTabsSyncCoordinatorAfterUserAccountChange:(long long)arg1 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_didReceiveCloudTabsSubscriptionPushNotification {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_registerCloudTabsZoneSubscriptionIfNeeded {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_attemptSyncAndFallBackToMigrationIfPossibleForTrigger:(long long)arg1 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_didReceiveBookmarksSubscriptionPushNotification {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_saveZoneSubscriptionsIfNeededForRecordZone:(long long)arg1 withCompletionHandler:(CDUnknownBlockType)arg2 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (id)_pushTopic {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
    return nil;
}

- (void)_setUpPushConnection {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)connection:(id)arg1 didReceiveIncomingMessage:(id)arg2 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)connection:(id)arg1 didReceiveToken:(id)arg2 forTopic:(id)arg3 identifier:(id)arg4 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)connection:(id)arg1 didReceivePublicToken:(id)arg2 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (BOOL)          listener:(NSXPCListener *)listener
 shouldAcceptNewConnection:(NSXPCConnection *)newConnection {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
    NSLog(@"bonehead listener = %@", listener) ;
    NSLog(@"bonehead newConnection = %@", newConnection) ;
    [newConnection setExportedInterface: [NSXPCInterface interfaceWithProtocol:@protocol(Whatever)]];
    [newConnection setExportedObject: self];

    // connections start suspended by default, so resume and start receiving them
    [newConnection resume];

    return YES;
}

- (void)migrateToCloudKitWithCompletionHandler:(CDUnknownBlockType)arg1 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)generateDAVServerIDsForExistingBookmarksWithCompletionHandler:(CDUnknownBlockType)arg1 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)clearLocalDataIncludingMigrationState:(BOOL)arg1 completionHandler:(CDUnknownBlockType)arg2 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)resetToDAVDatabaseWithCompletionHandler:(CDUnknownBlockType)arg1 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)fetchSyncedCloudTabDevicesAndCloseRequestsWithCompletionHandler:(CDUnknownBlockType)arg1 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)deleteCloudTabCloseRequestsWithUUIDStrings:(id)arg1 completionHandler:(CDUnknownBlockType)arg2 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)deleteDevicesWithUUIDStrings:(id)arg1 completionHandler:(CDUnknownBlockType)arg2 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)saveCloudTabCloseRequestWithDictionaryRepresentation:(id)arg1 closeRequestUUIDString:(id)arg2 completionHandler:(CDUnknownBlockType)arg3 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)saveTabsForCurrentDeviceWithDictionaryRepresentation:(id)arg1 deviceUUIDString:(id)arg2 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)collectDiagnosticsDataWithCompletionHandler:(CDUnknownBlockType)arg1 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_beginMigrationFromDAV {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)beginMigrationFromDAV {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)fetchRemoteMigrationStateWithCompletionHandler:(CDUnknownBlockType)arg1 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_sendNotificationForSyncResult:(long long)arg1 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_performBookmarkSyncForTrigger:(long long)arg1 completionHandler:(CDUnknownBlockType)arg2 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_userDidUpdateBookmarkDatabase {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)userDidUpdateBookmarkDatabase {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (BOOL)_isSyncEnabled {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
    return YES;
}

- (void)_updatePushTopicSubscriptions {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)_userAccountDidChange:(long long)arg1 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)userAccountDidChange:(long long)arg1 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)fetchUserIdentityWithCompletionHandler:(CDUnknownBlockType)arg1 {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (void)registerForPushNotificationsIfNeeded {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
}

- (id)init {
    NSLog(@"bonehead >> %s", __PRETTY_FUNCTION__);
    return [super init];
}


@end
