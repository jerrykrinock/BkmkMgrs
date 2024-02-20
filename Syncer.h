#import <Cocoa/Cocoa.h>
#import "SSYIndexee.h"
#import "SSYManagedObject.h"
#import "BkmxGlobals.h"

@class Command ;
@class Job;
@class Trigger ;
@class Macster ;
@protocol SSYErrorAlertee ;


extern NSString* constKeyUserDescription ;
extern NSString* constGroupNameAgentPerformEnd ;


__attribute__((visibility("default"))) @interface Syncer : SSYManagedObject <SSYIndexee> {
	// Managed object properties are declared in the data model, not here
}

+ (NSInteger)totalDocsOfAnyAppWithInstalledSyncers ;

#pragma mark * Core Data Generated Accessors for managed properties

// Attributes
/*!
 @brief    A BOOL which states whether or not the receiver is currently
 enabled.
*/
@property (copy) NSNumber* isActive ;

/*!
 @brief    A description of the receiver, entered by the user, or nil.
 
 @details  Until the user enters such a description, a default description
 is generated.
*/
@property (copy) NSString* userDescription ;

/*!
 @brief    A BOOL which tracks whether or not any of the receiver's 
 triggers is one of the trigger types that is triggered by a Client
 changing its bookmarks or quitting.
 
 @details  This is used in calculating availableCommandMethods.
 */
- (BOOL)hasAClientBasedTrigger ;

- (BOOL)doesImport ;
- (BOOL)doesExport ;

// property 'index' is declared in protocol SSYIndexee


// Relationships

/*!
 @brief    A sequence of commands which will be executed when the receiver
 is executed.
*/
@property (retain) NSSet* commands ;

/*!
 @brief    An ordered set of triggers which can trigger the receiver

 @details  Ordering is done only so that the user will get a consistent
 view of the triggers.
*/
@property (retain) NSSet* triggers ;

/*!
 @brief    The Macster which owns the receiver.
 */
@property (retain) Macster* macster ;



#pragma mark * Shallow Value-Added Getters

/*!
 @brief    Returns an array of the receiver's commands objects,
 sorted ascending by their 'index'.
 @result   The sorted array.
 */
- (NSArray*)commandsOrdered ;

/*!
 @brief    Returns an array of the receiver's triggers objects,
 sorted ascending by their 'index'.
 @result   The sorted array.
 */
- (NSArray*)triggersOrdered ;

/*!
 @brief    Returns a new Command, inserted at a given index, or at as
 low an index as possible, in the receiver's commands,
 in the receiver's managed object context.
 
 @details  If inserting the new Command in the receiver's 
 commands would create a gap in the sequence of their
 indexes, the index is reduced to a value which would close the gap.
 @param    index  The desired index of the new Command within the receiver's
 commands.
 @result   The new Command
 */
- (Command*)freshCommandAtIndex:(NSInteger)index ;

/*!
 @brief    Returns a new Trigger, inserted at a given index, or at as
 low an index as possible, in the receiver's triggers,
 in the receiver's managed object context.
 
 @details  If inserting the new Trigger in the receiver's 
 triggers would create a gap in the sequence of their
 indexes, the index is reduced to a value which would close the gap.
 @param    index  The desired index of the new Trigger within the receiver's
 triggers.
 @result   The new Trigger
 */
- (Trigger*)freshTriggerAtIndex:(NSInteger)index ;

- (void)removeTriggersObject:(Trigger*)value ;
- (void)removeCommandsObject:(Command*)value ;

/*!
 @brief    Removes a given one of the receiver's triggers *and*
 deletes it from the receiver's managed object context.
 */
- (void)deleteTrigger:(Trigger*)trigger ;

/*!
 @brief    Removes all of the receiver's triggers *and*
 deletes them from the receiver's managed object context.
*/
- (void)deleteAllTriggers ;

/*!
 @brief    Removes a given one of the receiver's commands *and*
 deletes it from the receiver's managed object context.
 */
- (void)deleteCommand:(Command*)command ;

/*!
 @brief    Removes all of the receiver's commands *and*
 deletes them from the receiver's managed object context.
 */
- (void)deleteAllCommands ;

/*!
 @brief    Removes all of the receiver's triggers and commands, and
 deletes them from the receiver's managed object context.

 @details  This method should be invoked when deleting a syncer,
 because setting Cascade Delete Rule in the data model is not reliable,
 in particular when an array controller is involved, as explained
 by Ben Trumbull in a post to cocoa-dev@lists.apple.com on 2009 June 23,
 Subject re: Cascade Delete won't delete Department in Apple Sample Code

 "Your array controller "helpfully" nulled out the relationship first,
 so the relationship no longer exists at all by the time you cascade the
 deletion. You'll see it cascade as you expect if you don't bind it into
 the UI in this manner.  As a workaround, you could create a custom
 remove action that deletes the object and calls processPendingChanges
 directly."
*/
- (void)removeOwnees ;

/*!
 @brief    Sends each of the receiver's commands a -refreshArguments message.
 */
- (void)refreshCommandsArguments ;

- (BOOL)anyCommandDoes1Import ;
- (BOOL)anyCommandDoes1Export ;
- (BOOL)anyTriggerNeedsDeference ;

- (NSArray*)availableTriggerTypes ;
- (NSArray*)availableCommandMethods ;

/*
 @details  Think of this as 'newCommand', without the memory management
 implication of having 'new' in the name
 */
- (Command*)freshCommand ;

@end


