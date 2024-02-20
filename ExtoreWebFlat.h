#import "Extore.h"

#define XML_HEADER @"<?xml"
#define BEGIN_DOWNLOAD_CHUNK_MARKER @"<---- BEGIN DOWNLOADED CHUNK ---->"
#define END_DOWNLOAD_CHUNK_MARKER @"<---- END DOWNLOADED CHUNK ---->"

@class SSYOperation ;
@class SSYOAuthTalker ;

enum BkmxExtoreWebFlatErrorDomainCodes {
	constNonhierarchicalWebAppErrorCodeOther = 54260,
	constNonhierarchicalWebAppErrorCodeNeedsAccountInfo = 54261,
	constNonhierarchicalWebAppErrorCodeWrongLoginAccountCookie = 54262,
	constNonhierarchicalWebAppErrorCodeThrottled = 54263,
	constNonhierarchicalWebAppErrorCodeUserCancelled = 54264,
	constNonhierarchicalWebAppErrorCodeLoginFailed = 54265,
	constNonhierarchicalWebAppErrorCodeLogoutRequiredButNotAllowed = 54266,
	constNonhierarchicalWebAppErrorCodeLoginCookieDidNotStick = 54267,
	constNonhierarchicalWebAppErrorCodeAccountNameDidNotEcho = 54268,
	constNonhierarchicalWebAppErrorCodeLoginWrongAccount = 54269,
} ;

/*!
 @brief    Constants used to build requests during uploading by subclasses
 
 @details  These are defined in the .m file
*/
extern NSString* const constKeyPendingAdditions ;
extern NSString* const constKeyPendingDeletions ;
extern NSString* const constKeyFailedAdditions ;
extern NSString* const constKeyFailedDeletions ;
extern NSString* const constKeyMassUploads ;
extern NSString* const constKeyNDone ;
extern NSString* const constKeyNTasks ;
extern NSString* const constHttpBackoff ;
/*!
 @brief    Constants used in NSErrors
 
 @details  These are defined in the .m file
 */
extern NSString* const BkmxExtoreWebFlatErrorDomain ;
extern NSString* const BkmxExtoreWebFlatErrorItemSummary ;

@interface ExtoreWebFlat : Extore {
	SSYOAuthTalker* m_talker ;
	NSTimer* m_requestTimer ;
	NSDate* m_requestTimerFireDate ;
	NSDictionary* m_requestTimerUserInfo ;
}

@property (assign) NSTimer* requestTimer ;

- (void)setARequestTimerToFireAtDate:(NSDate*)date
							userInfo:(NSDictionary*)userInfo ;

+ (NSArray*)trySubhosts ;

+ (NSArray*)defaultSpecialDoubles;

- (SSYOAuthTalker*)talker ;

/*!
 @brief    Indicates whether or not changed items must be deleted
 when uploading changes to the server

 @details  If this method returns YES, changed items will be
 added to the 'deletions' passed to
 -syncToServerAndLocalAdditions:deletions:doneTarget:, as well
 as to the 'additions'.  This is more expensive, but is necessary
 if the receiver's extore does not overwrite old items.
 @result   
*/
- (BOOL)changedBookmarksMustBeDeleted ;

/*!
 @brief    Returns the minimum time interval between requests
 for a complete dump of all the user's bookmarks, as specified
 in the API contract by the receiver's host web app

 @details  The default implementation returns 60.0.  Subclasses
 should override.
*/
- (NSTimeInterval)requestsAllMinimumTimeInterval ;

/*!
 @brief    Sets the receiver's <i>error</i> ivar to an NSError
 indicating that the user cancelled.

 @details  Obviously, cancellable methods must check this
 <i>error</i> at cancellable moments.
*/
- (IBAction)cancel:(id)sender ;

/*!
 @brief    Returns the set of error codes which the receiver's server may
 use to indicate that a user has been throttled, or nil or an empty set
 if there are no such codes

 @details  The default implementation returns nil.  Subclasses should override.
*/
- (NSSet*)throttledErrorCodes ;

/*!
 @brief    Returns whether or not a given error indicates that the
 requestor has been throttled by the server
*/
- (BOOL)isThrottledError:(NSError*)error ;


- (void)saveLocalAndSyncToTrans ;

/*!
 @brief    Copies all items from the receiver's external store, a web
 server, into the receiver's localMoc, and deletes all other items, so
 that the localMoc contents mirrors the external store contents.

 @details  Sets the receiver's error ivar if any error occurs.
 
 Used by -readExternalStyle1ForPolarity::.
 
 Default implementation logs an error.&nbsp; Must be implemented by subclasses.
 
 @param   completionHandler  An block which will be invoked when the method
 completes, whether or not an error occurred.
*/
- (void)syncWebServerToLocalThenCompletionHandler:(void(^)(void))completionHandler ;

/*!
 @brief    Writes the given stark additions and deletions to 
 the web server and the localMoc.
 
 @details  Sets the receiver's error ivar if any error occurs.
 
 Used by -writeUsingStyle1InOperation:.
 
 When done, must send a -syncToServerAndLocalDidSucceed: message to
 the receiver, indicating whether or not the write operation
 succeeded.
 
 Default implementation logs an error.&nbsp;  Must be implemented by subclasses.

 @param    additions  The set of starks to be added.&nbsp; This
 also includes changes, since they will be overwritten.&nbsp;
 These starks are currently inserted into the receiver's transMoc.&nbsp; 
 The set is mutable because we get it that way for free, and
 this method may need a mutable set.
 @param    deletions  The set of starks to be deleted.&nbsp; 
 These starks are currently inserted into the receiver's localMoc.&nbsp; 
 The set is mutable because we get it that way for free, and
 this method may need a mutable set.
*/
- (void)syncToServerAndLocalAdditions:(NSMutableSet*)additions
							deletions:(NSMutableSet*)deletions
						   doneTarget:(SSYOperation*)doneTarget ;

- (void)syncToServerAndLocalDidSucceed:(BOOL)didSucceed
							doneTarget:(SSYOperation*)doneTarget ;

/*!
 @brief    Handles an NSError returned in response to an HTTP Request.
 
 @details  A new(er) error is constructed from the given error and sent to the receiver
 in a setError:message.  The userInfo of the new error will contain the information
 given in the last three parameters, and other interesting information.
 
 Subclasses may override this method to see if they can recover from the
 error.  If the subclass implementation can recover, it should construct a
 new error and sending the error to super.
 
 @param   error  The error to be handled
 @param   requested  If the error is not recoverable, a string which
 will be set in the user info dictionary of the error set,
 for key "Request Details".
 @param   stark  The stark which was involved, or nil if none.
 Name and URL of any given stark will be appended to the receiver's
 localized failure reason.
 @param   receivedData  If the error is not recoverable, data which
 will be set in the user info dictionary of the error set,
 for key "Rx Data"
 @param   prettyFunction If the error is not recoverable, a string which
 will be set in the user info dictionary of the error set,
 for key SSYMethodNameErrorKey.  Hint: Pass the macro __PRETTY_FUNCTION__.
*/
- (void)handleHttpError:(NSError*)error_
			  requested:(NSString*)requested
				  stark:(Stark*)stark
		   receivedData:(NSData*)receivedData
		 prettyFunction:(const char*)prettyFunction ;

- (void)doNextOutputInfo:(NSTimer*)timer ;

- (void)scheduleRegularOutputInfo:(NSMutableDictionary*)info ;

- (void)scheduleBackedOffOutputInfo:(NSMutableDictionary*)info ;

/*!
 @brief    Adds a given bookmark at the server, as represented by
 a given stark.
 
 @details  Must be implemented by subclasses.  The default implementation
 returns an error.
 @param    error_p  Must NOT be NULL or program will crash when
 an error occurs.  If an error occurs, upon return,
 will point to an error object encapsulating the error.
 @result   YES if the method completed successfully, otherwise NO
 */
- (BOOL)deleteAtServerStark:(Stark*)stark
					error_p:(NSError**)error_p ;

/*!
 @brief    Adds a given bookmark at the server, as represented by
 a given stark, or updates an existing bookmark by overwriting it.
 
 @details  Must be implemented by subclasses.  The default implementation
 returns an error.
 @param    error_p  If not NULL and if an error occurs, upon return,
 will point to an error object encapsulating the error.
 @result   YES if the method completed successfully, otherwise NO
 */
- (BOOL)addAtServerStark:(Stark*)stark
				 error_p:(NSError**)error_p ;


@end
