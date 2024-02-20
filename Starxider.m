#import "Starxider.h"
#import "BkmxBasis.h"
#import "Starxid.h"
#import "Clientoid.h"
#import "Clixid.h"

@interface Starxider ()

@end


@implementation Starxider

- (id)initWithDocUuid:(NSString*)docUuid {
    NSManagedObjectContext* managedObjectContext ;
    managedObjectContext = [[BkmxBasis sharedBasis]  exidsMocForIdentifier:docUuid] ;
    
    self = [super initWithManagedObjectContext:managedObjectContext
                                    entityName:constEntityNameStarxid] ;
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
 and whose values are Starxider objects.
*/
- (NSMutableDictionary*)cache {
	if (!m_cache) {
		m_cache = [[NSMutableDictionary alloc] init] ;
		for (Starxid* starxid in [self allObjects]) {
            NSString* starkid = starxid.starkid;
            if (starkid) {
                [m_cache setObject:starxid
                            forKey:[starxid starkid]] ;
            }
		}
	}
	
	return m_cache ;
}

- (void)clearCache {
	[m_cache release] ;
	m_cache = nil ;
}

- (NSDictionary*)exidsForStark:(Stark*)stark {
	Starxid* starxid = [[self cache] objectForKey:[stark starkid]] ;

	NSMutableDictionary* exidsByClidentifier = [[NSMutableDictionary alloc] init] ;	
	for (Clixid* clixid in [starxid clixids]) {
		NSString* exid = [clixid exid] ;
		// Defensive programming
		if (exid) {
			[exidsByClidentifier setObject:exid
									forKey:[Clientoid clientoidWithClidentifier:[clixid clidentifier]]] ;
		}
		else {
			NSLog(@"Internal Error 244-9285 %@ %@", [clixid clidentifier], [stark name]) ;
		}
	}
	
	NSDictionary* answer = [NSDictionary dictionaryWithDictionary:exidsByClidentifier] ;
	[exidsByClidentifier release] ;
	
	return answer ;
}

- (void)deleteStarxidForStark:(Stark*)stark {
	NSString* starkid = [stark starkid] ;
	Starxid* starxid = [[self cache] objectForKey:starkid] ;
	[[self cache] removeObjectForKey:starkid] ;
	[[starxid managedObjectContext] deleteObject:starxid] ;
}

- (void)setAllExids:(NSDictionary*)exids
		   forStark:(Stark*)stark {
	NSString* starkid = [stark starkid] ;
    /*  Since exids are in the Settings database, which is related to a given
     stark by its starkid, there is nothing we can do if stark has no starkid.
     There should never be a stark without a starkid, but on 2022-10-27 I
     examined a Exids database from a user in which 2 out of 3570
     starxids had NULL starkid, and this caused a crash below in setPBject:
     forKey:starkid because key was nil.  To prevent that from happening
     to other user, we have the following if(…) */
    if (starkid) {
        Starxid* starxid = [[self cache] objectForKey:starkid] ;
        BOOL hasExids = [exids count] > 0 ;
        if (hasExids) {
            // If our moc does not already have one, make a starxid for this starkid
            // Prior to BookMacster 1.10, the following line was just if(!stark) {.
            // In BookMacster 1.10, once or twice, I got an exception raised below,
            // at Bug 897345, because Core Data said that 'clixid' and 'starid'
            // were in different managed object contexts.  This occurred
            // during an export, after restoring a version from Versions Browser.
            // In fact, the managed object context of 'starxid' was nil, which if I
            // recall correctly means that it had been removed from its moc, or maybe
            // that its moc had gone away.  Anyhow, -isAvailable checks for nil moc.
            if (![starxid isAvailable]) {
                // This happens during the first export after restoring a document
                // with Clients from the Versions Browser.  The 'starxid' will
                // be non-nil, but not available.
                starxid = (Starxid*)[self freshObject] ;
                [starxid setStarkid:starkid] ;
            }
            
            // and it should be in our cache too
            [[self cache] setObject:starxid
                             forKey:starkid] ;
        }
        else {
            [self deleteStarxidForStark:stark] ;
        }
        
        NSMutableSet* unmatchedClixids = [[starxid clixids] mutableCopy] ;
        
        for (Clientoid* clientoid in exids) {
            NSString* targetClidentifier = [clientoid clidentifier] ;
            NSString* newExid = [exids objectForKey:clientoid] ;
            BOOL didFindClixid = NO ;
            for (Clixid* clixid in [starxid clixids]) {
                if ([[clixid clidentifier] isEqualToString:targetClidentifier]) {
                    didFindClixid = YES ;
                    if (![[clixid exid] isEqualToString:newExid]) {
                        // Modify existing Clixid
                        [clixid setExid:newExid] ;
                    }
                    else {
                        // New exid = clixid's existing exid.  Do nothing.
                    }
                    
                    [unmatchedClixids removeObject:clixid] ;
                }
            }
            
            if (!didFindClixid) {
                // clixid for targetClidentifier not found.  Create one.
                Clixid* clixid = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameClixid
                                                               inManagedObjectContext:[self managedObjectContext]] ;
                [clixid setClidentifier:targetClidentifier] ;
                [clixid setExid:newExid] ;
                [clixid setStarxid:starxid] ;  // Bug 897345 because moc of starxid is nil
            }
        }
        
        for (Clixid* clixid in unmatchedClixids) {
            [[clixid managedObjectContext] deleteObject:clixid] ;
        }
        
        [unmatchedClixids release] ;
    }
}

@end
