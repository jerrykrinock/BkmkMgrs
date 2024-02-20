#import <Cocoa/Cocoa.h>
#import "SSYIndexee.h"
#import "BkmxGlobals.h"
#import "SSYManagedObject.h"

@class Syncer ;
@class Client ;
@class SSYRecurringDate ;

extern NSString* const constKeyTriggerType ;
extern NSString* const constKeyRecurringDate ;
extern NSString* const constKeyPeriod ;
extern NSString* const constNoImportSources ;

#define TRIGGER_DETAIL_EFFICIENTLY_YES -1
#define TRIGGER_DETAIL_EFFICIENTLY_NO  -2

__attribute__((visibility("default"))) @interface Trigger : SSYManagedObject <SSYIndexee> {
	// Managed object properties are declared in the data model, not here

	NSString* m_blinderKey ;
}

+ (NSString*)specialWatchFilePathForExformat:(NSString*)exformat
                                 profileName:(NSString*)profileName ;

#pragma mark * Core Data Generated Accessors for managed properties

// Attributes

- (void)setDetailChoice:(id)newChoice ;

/*!
 @brief    An NSNumber whose integer value is one of 
 BkmxTriggerType, indicating the type of the receiver.
 */
@property (retain) NSNumber* triggerType ;

@property (retain) SSYRecurringDate* recurringDate ;
@property (retain) NSNumber* period ;
@property (retain) NSNumber* efficiently ;

// property 'index' is declared in protocol SSYIndexee

// Relationships

/*!
 @brief    The Syn cerwhich owns the receiver.
 */
@property (retain) Syncer* syncer ;

/*!
 @brief    The Client that is being watched.
 
 @details  Only relevant if triggerType is BkmxTriggerSawChange.
 However, it appears that a trigger which was BkmxTriggerSawChange
 but was later changed to a different type may still have an
 irrelevant client, so be careful.
 */
@property (retain) Client* client ;


#pragma mark * Value-Added Accessors

- (BkmxTriggerType)triggerTypeValue ;
- (void)setTriggerTypeValue:(BkmxTriggerType)newValue ;

#pragma mark * Other Methods

+ (NSInteger)severityWhenSettingNewType:(NSNumber*)newType
								oldType:(NSNumber*)oldType ;

+ (NSString*)smallDescriptionOfTrigger:(Trigger*)trigger ;

+ (NSString*)causeStringForType:(BkmxTriggerType)triggerTypeValue ;

/*!
 @brief    Blinds the receiver

 @details  Trigger Blinding means to "blind" a trigger temporarily by unloading it
 in launchd, so that it does not work.  Unblinding is the opposite.  This
 mechanism was added in BookMacster 1.7/1.6.8.  It replaces the old
 inhibitAgent mechanism in 3 cases…
 
 Case 1.  Before saving BkmxDoc, only if in Main App (see Note 58934), blind any
 syncer's trigger whose triggerTypeValue is BkmxTriggerCloud.  Remember the
 blinderKeys you get, and unblind after done saving. 
 
 Case 2.  Before a browser is quit, only if in Main App (see Note 58934),
 blind any syncer's trigger which is watching for this browser to quit.  That
 means any trigger whose triggerTypeValue is BkmxTriggerBrowserQuit and whose
 client is the same as that of the extore whose browser is being quit.
 Remember the blinderKeys you get, and unblind it after the browser is quit.
 
 Case 3.  Before exporting in Style 1 to a browser, blind any syncer's trigger
 which is watching that browser's file.  That means any trigger whose
 triggerTypeValue is BkmxTriggerSawChange and whose client is the same as that
 of the extore whose browser is being quit.  It is OK to do this in both Main
 App and Worker, because the Worker has been triggered by a .doSoon syncer and
 you won't have the hang or kill issue that arises when launchctl tries to
 unload a job of a running process.  Remember the blinderKeys you get, and
 unblind after done writing the file.
 
 Note 58934.  If in Worker, it will do no good to blind the syncer because it
 will be in effect blinded by the ThrottleInterval in the launchd plist.  Also,
 since the Worker for this trigger type is launched directly by that launchd
 job, launchctl will either hang or kill this Worker, its invoker.

 @result   A key, a UUID, which was generated during this method and set
 into the receiver, or nil if an error occurred.
*/
- (NSString*)blind ;

/*!
 @brief    If a given key equals the receiver's blinderKey, unblinds the
 receiver and sets its blinderKey to nil.

 @details  See -blind.
 @result   Yes if the operation succeeded, NO if an error occurred.
*/
- (BOOL)unblindIfKey:(NSString*)key
             error_p:(NSError**)error_p ;

/*!
 @brief    A slightly liberalized -isEqual: which ignores the receiver's index
*/
- (BOOL)doesSameAsTrigger:(Trigger*)otherTrigger ;

@end
