#import "BkmxGlobals.h"

@class Stark ;
@class Starker ;
@class Tagger;
@class Client ;

/*!
 @brief    Formal protocol for an object which can contain replicate
 Starks in a managed object context.
 */
@protocol StarkReplicator

/*!
 @brief    Returns the receiver's Starker which must be configured
 to access the receiver's Starks
 */
- (Starker*)starker ;

- (Tagger*)tagger;

/*!
 @brief    Tests whether or not a given Stark can be inserted
 as a child of the root item in the receiver.
 
 @details  Depends on the browser or service.
 @param    stark  The Stark to be tested
 @result   YES if OK to insert, NO if not.
 */
- (BOOL)canHaveParentSharype:(Sharype)sharype
					   stark:(Stark*)stark ;

@optional

/*!
 @brief    Creates a new BookMacsterizer bookmarklet, inserts 
 it into the most appropriate allowed, available parent in the
 receiver, and returns it.
 */
- (Stark*)insertFreshBookMacsterizer ;


@end
