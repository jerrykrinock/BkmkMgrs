#import "ExtoreWebFlat.h"

@interface ExtoreHttp : ExtoreWebFlat {			
}

/*!
 @details  Must be implemented by subclasses.  The default implementation
 returns an error.
 */
- (BOOL)talkToSubpathQuery:(NSString*)subpathQuery
					client:(Client*)client
				   timeout:(CGFloat)timeout
			 receiveData_p:(NSData**)hdlResponseData 
				   error_p:(NSError**)error_p ;	

@end

