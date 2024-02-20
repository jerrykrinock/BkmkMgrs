#import <Cocoa/Cocoa.h>
#import "SSYMojo.h"

@class Stark ;
@class SSYMojo ;

/*!
 @brief    Class for getting and setting Starlobute objects in 
 documents' Settings mocs.
 
 @details  Class methods access a singleton dictionary of
 Starlobute instances (one per document) under the hood.
 */
@interface Starlobuter : SSYMojo {
	NSMutableDictionary* m_cache ;
	SSYMojo* m_mojo ;
}

/*!
 @brief    Designated initializer for Starlobuter
 */
- (id)initWithDocUuid:(NSString*)docUuid ;

/*!
 @brief    Returns a number whose -boolValue indicates whether
 or not a given stark is expanded
 */
- (NSNumber*)isExpandedStark:(Stark*)stark ;

/*!
 @brief    Sets whether or not a given stark is stored as
 expanded, based on the -boolValue of a given number
 */
- (void)setIsExpanded:(NSNumber*)isExpanded
			 forStark:(Stark*)stark ;

/*!
 @brief    Deletes the Starlobute object whose starkid matches
 that of a given stark from its managed object context,
 and removes it from the receiver's cache.
 
 @param    stark  
 */
- (void)deleteStarlobuteForStark:(Stark*)stark ;

@end
