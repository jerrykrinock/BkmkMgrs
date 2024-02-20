#import "Starlobuter.h"
#import "Starlobute.h"
#import "BkmxBasis.h"
#import "BkmxGlobals.h"

@implementation Starlobuter

- (id)initWithDocUuid:(NSString*)docUuid {
    NSManagedObjectContext* managedObjectContext;
    NSError* error = nil;
    managedObjectContext = [[BkmxBasis sharedBasis] settingsMocForIdentifier:docUuid
                                                                     error_p:&error];
    if (error) {
        [[BkmxBasis sharedBasis] logError:error
                          markAsPresented:NO];
    }

    self = [super initWithManagedObjectContext:managedObjectContext
                                    entityName:constEntityNameStarlobute] ;
    // We don't dealloc super here because this is Error Point #2 in
	// http://lists.apple.com/archives/Cocoa-dev/2011/May/msg00814.html
	
	return self ;
}

- (void)dealloc {
	[m_cache release] ;
	
	[super dealloc] ;
}

/*!
 @brief    
 
 @details  A mutable dictionary whose keys are starkid strings
 and whose values are Starlobuter objects.
 */
- (NSMutableDictionary*)cache {
	if (!m_cache) {
		m_cache = [[NSMutableDictionary alloc] init] ;
		for (Starlobute* starlobute in [self allObjects]) {
			[m_cache setObject:starlobute
						forKey:[starlobute starkid]] ;
		}
	}
	
	return m_cache ;
}

- (void)clearCache {
	[m_cache release] ;
	m_cache = nil ;
}

- (Starlobute*)starlobuteForStark:(Stark*)stark {
	return 	[[self cache] objectForKey:[stark starkid]] ;
}


- (NSNumber*)isExpandedStark:(Stark*)stark {
	Starlobute* starlobute = [self starlobuteForStark:stark] ;
	NSNumber* answer = [starlobute isExpanded] ;
	
	return answer ;
}

- (void)removeStarlobute:(Starlobute*)starlobute {
	// Most starks do not have a starlobute, so we check first
	if (starlobute) {
		NSString* starkid = [starlobute starkid] ;
		if (starkid) {
			[[self cache] removeObjectForKey:starkid] ;
		}
		else {
			NSLog(@"Internal Error 092-3487 %@", starkid) ;
		}
		
		[[self managedObjectContext] deleteObject:starlobute] ;
	}
}

- (void)setIsExpanded:(NSNumber*)isExpanded
			 forStark:(Stark*)stark {
	Starlobute* starlobute = [self starlobuteForStark:stark] ;
	BOOL newValue = [isExpanded boolValue] ;
	// The following line was simply if(starlobute){ until BookMacster 1.10
	// when, after restoring a document from Versions Browser, Core Data raised a
	// "could not fulfill a fault" exception when I clicked on a restored folder to
	// expand it, which rightfully brought us here.  Could not reproduce.
	// What if a stark was in a previous version, then it was deleted.
	// Its starlobute would be deleted.  But it should have been deleted from cache too?
	if ([starlobute isAvailable]) {
		BOOL currentValue = [[starlobute isExpanded] boolValue] ;
		if (newValue && !currentValue) {
			// This should never happen since we never set isExpanded to [NSNumber numberWithBool:NO]
			// So this is just defensive programming
			[starlobute setIsExpanded:isExpanded] ;
		}
		else if (!newValue && currentValue) {
			if ([starlobute countOfNonNilValues] > 2) {
				// Other non-nil values exist in this starlobute.
				// Do not remove it.
				[starlobute setIsExpanded:nil] ;
			}
			else {
				// We are nilling the last non-nil value in this starlobute.
				// Remove it.
				[self removeStarlobute:starlobute] ;
			}
		}
	}
	else if (newValue) {
		starlobute = (Starlobute*)[self freshObject] ;
		[starlobute setStarkid:[stark starkid]] ;
		[starlobute setIsExpanded:isExpanded] ;
		[[self cache] setObject:starlobute
						 forKey:[stark starkid]] ;
	}		
}

- (void)deleteStarlobuteForStark:(Stark*)stark {
	NSString* starkid = [stark starkid] ;
	Starlobute* starlobute = [[self cache] objectForKey:starkid] ;
	[self removeStarlobute:starlobute] ;
}

@end
