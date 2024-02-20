#import <Cocoa/Cocoa.h>
#import "SSYOperation.h"

/*!
 @details  This file was added in BookMacster 1.5 after I 
 discovered that --eek--, the "revert" operation was not being done
 in the queue but was a "just do it".
*/
@interface SSYOperation (OperationRevert) 

- (void)revert ;

@end
