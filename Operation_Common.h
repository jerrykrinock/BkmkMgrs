#import <Cocoa/Cocoa.h>
#import "SSYOperation.h"
#import "BkmxGlobals.h"

@interface SSYOperation (Operation_Common)

/*!
 @details  Used to queue non-cancellable Auto Saves.
 */
- (void)reallyAutosave ;

/*!
 @brief    Adds a given object for a given key to the 'info' argument
 in the given invocation, or any nested invocation if the given
 invocation -hasEggs

 @param    invocation 	An invocation meeting one of these requirements:
 |  • Simple invocation.  One argument of its selector is "info:",
 |      which must be of type NSMutableDictionary.
 |  • Nested invocation.  Selector is invokeInvocations:, and the
 |      single argument is an array of "egg" invocations which are
 |      each are a Simple Invocation as defined above.
 @param    object  The object to be set in the info dictionary(s).
 If nil, this method is a no-op.
*/
+ (void)inInfoOfInvocation:(NSInvocation*)invocation
				 setObject:(id)object
					forKey:(NSString*)key ;

/*!
 @brief    Escalates the value of the constKeyDeference in the 'info'
 argument in the given invocation, or any nested invocation if the 
 give invocation -hasEggs
 
 @param    invocation 	An invocation meeting one of these requirements:
 |  • Simple invocation.  One argument of its selector is "info:",
 |      which must be of type NSMutableDictionary.
 |  • Nested invocation.  Selector is invokeInvocations:, and the
 |      single argument is an array of "egg" invocations which are
 |      each are a Simple Invocation as defined above.
 @param    newDeference  A new value for the key constKeyDeference which
 will be set into the info if this parameter is not BkmxDeferenceUndefined
 @param    setIgnoreLimit  If YES, an NSNumber whose value is YES will be
 set into the info.
 
 @details  This is a utility method which could have been put in several
 places.
 */
+ (void)modifyInvocation:(NSInvocation*)invocation
			newDeference:(BkmxDeference)newDeference 
		  setIgnoreLimit:(BOOL)setIgnoreLimit ;

- (void)actuallyDelete_unsafe ;

- (void)readExternalIsDone ;

- (void)askQuitIsDone ;

- (void)readExternal_unsafe ;

/*!
 @brief    If there is an ixport log (constKeyIxportLog) in the
 receiver's info, this method changes its status to end as
 having ended with the error indicated by the receiver's current
 error.

 @details  Because SSYOperations, in general, won't execute if
 the receiver's error is not nil, this method must be called
 from within other operation methods, typically the one in 
 which the error has just been set.  It accesses the sync
 log containing the ixport log on the main thread, so make
 sure that the main thread is idle or you'll deadlock.
*/
- (void)errorizeIxportLog ;

- (void)skipNoncleanupOperationsInOtherGroups ;

+ (void)terminateWorkInfo:(NSDictionary*)info ;

@end
