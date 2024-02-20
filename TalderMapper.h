#import "SSYMojo.h"

@class TalderMap;

@class Stark ;

@interface TalderMapper : SSYMojo {
	NSMutableDictionary* m_cache ;
}

/*!
 @brief    Designated initializer
 */
- (NSArray<TalderMap*>*)allObjects;

- (id)initWithDocUuid:(NSString*)docUuid ;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (void)deleteTalderMapsRelatedToStark:(Stark*)stark ;


@end
