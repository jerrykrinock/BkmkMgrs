//
//  ExtoreLocalAtomic.h
//  
//
//  Created by Jerry on 12/10/25.
//
//

#import "Extore.h"

@interface ExtoreLocalAtomic : Extore

- (void)processFileReadingError:(NSError*)error;

/*!
 @brief    Do any processing which is necessary just prior to
 invoking -extoreDataFromTree during an export operation
 
 @details  The default implementation is a no-op.
 */
- (BOOL)processExportChangesForOperation:(SSYOperation*)operation
                                 error_p:(NSError**)error_p;

/*!
 @brief
 
 @details  Must be implemented by subclasses.  Default implementation
 returns nil and logs an internal error.
 
 @result   Array of children of the root item
 */
- (NSArray*)extoreRootsForExport ;

/*!
 @brief    Returns the tree obtained by reading the receiver's
 plist file from the disk, or nil if an error occurs
 
 @param    error_p  If not NULL and if an error occurs, upon return,
 will point to an error object encapsulating the error.
 */
- (NSDictionary*)extoreTreeError_p:(NSError**)error_p ;

- (NSData*)extoreDataFromTree;

@end
