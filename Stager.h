#import <Cocoa/Cocoa.h>
#import "BkmxBasis.h"

@class Syncer;
@class Trigger;
@class Macster;
@class Client;
@class Job;


/*!
 @details  This class should probably be part of Macster or Syncer, since it
 occasionally needs Macster or Syncer, and I think that most of the invokers
 have Macster and/or Syncer available.  But it's nice to have all this
 encapsulated in one file.  I don't know.
*/
__attribute__((visibility("default"))) @interface Stager : NSObject {

}

+ (NSInteger)bookmarksChangeDelay2 ;

/*!
 @brief    Removes any staging info for any syncer with a given URI,
 optionally doing so only if its stagingPid matches a given pid, or
 does nothing the given URI is nil or if no staging info exists
 for it

 @param    stagingSerial  If not nil, will remove the staging info for
 the syncer with the given URI only if its stagingSerial is equal to the
 value passed in; otherwise, removes the staging info for the syncer
 with the given URI regardless of its stagingSerial.  This parameter
 allows you to invoke this method multiple times without worrying
 that one of the later invocations might remove the info for a
 subsequent staging.
 
*/
+ (void)removeStagingForSyncerUri:(NSString*)agentUri;

+ (void)removeAllStagingsExceptDocUuid:(NSString*)docUuid;

/*!
 @brief    Returns whether or not a given client needs to be imported to a
 given document.

 @details  If the need has timed out (has not been cleared within a reasonable
 time after being set), clears the need and returns NO.
 */
+ (BOOL)needsImportClidentifier:(NSString*)clidentifier
                 toDocumentUuid:(NSString*)documentUuid;

+ (void)setNeedsImportClidentifier:(NSString*)clidentifier
                    toDocumentUuid:(NSString*)documentUuid;

/*!
 @brief    Returns an array of clidentifiers of all Clients needing import
 for a given document, regardless of whether or not these needs have timed out
 */
+ (NSArray*)clidentifiersNeedingImportToDocumentUuid:(NSString*)documentUuid;

+ (NSString*)displayListOfClientsNeedingImportForJob:(Job*)job;

+ (BOOL)clearNeedsImportClient:(Client*)client
                toDocumentUuid:(NSString*)documentUuid;

+ (NSString*)stageJob:(Job*)job
                phase:(NSString*)phase ;

+ (BOOL)anyAppIsWatchingPath:(NSString*)path;

@end
