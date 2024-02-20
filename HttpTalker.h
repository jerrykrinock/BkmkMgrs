@class Client ;

/*
 @brief    A class for http connections with Pinboard or Diigo.
 
 @details  Logs in to server if required, handles user interaction
 Operation is synchronous; i.e. the entry method blocks
 the invoking thread until the response is either finished
 or is cancelled by the user.
 HttpTalker is written as a state machine.
 */
@interface HttpTalker : NSObject {
	// state variables
	NSInteger _whatsNext ;  
	BOOL usernameIsFromClient ; // In this case, we don't allow changes
	
	// other variables
	NSDate* timeToGiveUp ;
	Client* m_client ; // weak
	NSString* url ;
	NSString* bodyString; 
	NSString* httpMethod ;
	NSTimeInterval m_timeout ;
	NSInteger _responseType ;
	NSHTTPURLResponse* response ;
	NSData* responseData ;
	CGFloat _progress ;
	CGFloat _backoffDelay ;
	NSError* m_error ;
}

/*!
 @brief    Sends a query to the server for a given client and returns
 the response data synchronously

 @param    subpathQuery  The subpath and query following the defaultFilename
 (which is in fact a URL for web apps), from which you wish to
 retrieve data.  For example, to get all posts from Pinboard,
 subpathQuery is "posts/all?"
 @param    client  
 @param    timeout  
 @param    hdlResponseData  
 @param    error_p  If not NULL and if an error occurs, upon return,
           will point to an error object encapsulating the error.
 @result   YES if the method completed successfully, otherwise NO
*/
+ (BOOL)talkToSubpathQuery:(NSString*)subpathQuery
				httpMethod:(NSString*)httpMethod
					client:(Client*)client
				   timeout:(CGFloat)timeout
			 receiveData_p:(NSData**)hdlResponseData 
				   error_p:(NSError**)error_p ;

@end
