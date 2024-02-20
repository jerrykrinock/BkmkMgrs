#import "TalderMapper.h"
#import "BkmxBasis.h"
#import "TalderMap.h"
//#import "BkmxGlobals.h"
#import "Stark.h"
#import "NSManagedObjectContext+Cheats.h"

@implementation TalderMapper

- (NSArray<TalderMap*>*)allObjects {
    return [super allObjects];
}

- (id)initWithDocUuid:(NSString*)docUuid {
    NSManagedObjectContext* managedObjectContext ;
    NSError* error = nil;
    managedObjectContext = [[BkmxBasis sharedBasis]  settingsMocForIdentifier:docUuid
                                                                      error_p:&error];
    if (error) {
        [[BkmxBasis sharedBasis] logError:error
                          markAsPresented:NO];
    }

    return [self initWithManagedObjectContext:managedObjectContext] ;
    // We don't dealloc super here because this is Error Point #2 in
	// http://lists.apple.com/archives/Cocoa-dev/2011/May/msg00814.html
	
	return self ;
}

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    return [super initWithManagedObjectContext:managedObjectContext
                                    entityName:constEntityNameTalderMap];
}

/*!
 @brief
 
 @details  A mutable dictionary whose keys are starkid strings
 and whose values are Starxider objects.
 */
- (NSMutableDictionary*)cache {
	if (!m_cache) {
		m_cache = [[NSMutableDictionary alloc] init] ;
		for (TalderMap* talderMap in [self allObjects]) {
			NSString* folderId = [talderMap folderId] ;
            NSSet* set = [m_cache objectForKey:folderId] ;
            if (set) {
                set = [set setByAddingObject:talderMap] ;
            }
            else {
                set = [NSSet setWithObject:talderMap] ;
            }
            [m_cache setObject:set
						forKey:folderId] ;
		}
	}
	
	return m_cache ;
}

- (void)clearCache {
	m_cache = nil ;
}

- (void)deleteTalderMapsRelatedToStark:(Stark*)stark {
	NSString* folderId = [stark starkid] ;
    NSSet* talderMaps = [[self cache] objectForKey:folderId] ;
    for (TalderMap* talderMap in talderMaps) {
        [[self managedObjectContext] deleteObject:talderMap] ;
        [[self managedObjectContext] processPendingChanges] ;
        NSError* error = nil ;
        [self save:&error] ;
        if (error) {
            NSLog(@"Internal Error 524-3480 %@", [[self managedObjectContext] store1]) ;
        }
    }
    [[self cache] removeObjectForKey:folderId] ;
}


@end
