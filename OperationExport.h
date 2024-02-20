#import "SSYOperation.h"
#import "SSYOperation.h"

@class Extore ;

@interface SSYOperation (OperationExport) 
	
- (void)writeAndDeleteDidSucceed:(BOOL)didSucceed ;

- (void)actualWriteAndDeleteExtore:(Extore*)extore ;

/*!
 @brief    Consults with the Chaker of the BkmxDoc indicated in
 the receiver's info dictionary and returns whether or not there are
 any changes to write.
 
 @details  Since Chaker is a managed object, invoke this
 method on the main thread only.
 */
- (BOOL)anyChangesToWrite ;

@end
