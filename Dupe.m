#import "Dupe.h"
#import "NSSet+SimpleMutations.h"
#import "BkmxGlobals.h"
#import "Stark+Sorting.h"

NSString* const constKeyDupetainer = @"dupetainer" ;

@interface Dupe ()

@end


@interface Dupe (CoreDataGeneratedPrimitiveAccessors)

- (Dupetainer*)primitiveDupetainer;
- (void)setPrimitiveDupetainer:(Dupetainer*)value;
- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;
- (NSMutableSet*)primitiveStarks;
- (void)setPrimitiveStarks:(NSMutableSet*)value;

@end

@implementation Dupe

@dynamic dupetainer ;

- (void)setDupetainer:(Dupetainer*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyDupetainer] ;
	
    [self willChangeValueForKey:constKeyDupetainer] ;
    [self setPrimitiveDupetainer:value];
    [self didChangeValueForKey:constKeyDupetainer] ;
}

@dynamic url ;

- (void)setUrl:(NSString*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyUrl] ;
	
    [self willChangeValueForKey:constKeyUrl] ;
    [self setPrimitiveUrl:value];
    [self didChangeValueForKey:constKeyUrl] ;
}


@dynamic starks ;


- (NSArray*)starksOrderedSloppy {
	NSArray* starksOrderedSloppy ;
	NSInteger count = [[self starks] count] ;
	if (count < 16) {
		// Only 16.  Performance will be OK if starks are sorted to make them look nice.
		starksOrderedSloppy = [[[self starks] allObjects] sortedArrayUsingSelector:@selector(lineageLineCompare:)] ;
	}
	else {
		// Sorting will take too long.  Sacrifice nice looks for performance.
		starksOrderedSloppy = [[self starks] allObjects] ;
	}
	
	return starksOrderedSloppy ;
}

- (void)postWillSetNewStarks:(NSSet*)newValue {
	
	/* The following if() breaks an infinite loop which occured when all the
	 bookmarks of a Duplicate Group existing in the Duplicates Report were
	 deleted in one operation.  This can be done by selecting all the
	 bookmarks in the Content Outline and hitting 'delete', but there are
	 other sneaky ways that the triggering factors can occur.  For example,
	 they can occur when BookMacster is launched, if a Collection with
	 such content is set to open on launch, and also to Auto Import
	 from a Client not currently containing these bookmarks.  The signature
	 of this crash is that it takes several seconds and results in a long
	 crash report with stack of 511 calls, including calls to
	 com.sheepsystems.Bkmxwork alternating in groups of 2 and 5, like this:
	 -- Cocoa notification processing --
	 com.apple.Foundation          	0x90ffd094 -[NSNotificationCenter postNotificationName:object:userInfo:] + 128
	 com.sheepsystems.Bkmxwork     	0x000abb5b -[SSYManagedObject postWillSetNewValue:forKey:] + 340 (SSYManagedObject.m:271)
	 com.sheepsystems.Bkmxwork     	0x00033235 -[Dupe postWillSetNewStarks:] + 64 (Dupe.m:49)
	 com.sheepsystems.Bkmxwork     	0x0003340c -[Dupe removeStarksObject:] + 103 (Dupe.m:68)
	 com.sheepsystems.Bkmxwork     	0x00037551 -[Dupetainer checkAndRemoveDupeVestiges] + 1301 (Dupetainer.m:310)
	 com.sheepsystems.Bkmxwork     	0x00109b73 -[BkmxDoc checkAndRemoveDupeVestiges] + 64 (BkmxDoc.m:206)
	 com.apple.Foundation          	0x910081c7 _nsnote_callback + 176
	 -- Cocoa notification processing --
	 com.apple.Foundation          	0x90ffd186 -[NSNotificationCenter postNotification:] + 204
	 com.sheepsystems.Bkmxwork     	0x00111eb1 -[BkmxDoc postDupesMayContainVestiges] + 224 (BkmxDoc.m:2430)
	 com.sheepsystems.Bkmxwork     	0x00112a13 -[BkmxDoc objectWillChangeNote:] + 2423 (BkmxDoc.m:2675)
	 com.apple.Foundation          	0x910081c7 _nsnote_callback + 176
	 */	
	if (![self isDeleted]) {
		[self postWillSetNewValue:newValue
					forKey:constKeyStarks] ;
	}
}

- (void)addStarksObject:(Stark *)value 
{    
	[self postWillSetNewStarks:[[self starks] setByAddingObject:value]] ;

    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyStarks withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveStarks] addObject:value];
    [self didChangeValueForKey:constKeyStarks withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)removeStarksObject:(Stark *)value 
{
	[self postWillSetNewStarks:[[self starks] setByRemovingObject:value]] ;

    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyStarks withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveStarks] removeObject:value];
    [self didChangeValueForKey:constKeyStarks withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)addStarks:(NSSet *)value 
{    
	[self postWillSetNewStarks:[[self starks] setByAddingObjectsFromSet:value]] ;

    [self willChangeValueForKey:constKeyStarks withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveStarks] unionSet:value];
    [self didChangeValueForKey:constKeyStarks withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeStarks:(NSSet *)value 
{
	[self postWillSetNewStarks:[[self starks] setByRemovingObjectsFromSet:value]] ;

    [self willChangeValueForKey:constKeyStarks withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveStarks] minusSet:value];
    [self didChangeValueForKey:constKeyStarks withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (NSInteger)numberOfStarks {
	return [[self starks] count] ;
}

// From NSManagedObject documentation: "You are discouraged from overriding
// description ... if this method fires a fault during a debugging
// operation, the results may be unpredictable.
- (NSString*)shortDescription {
	return [NSString stringWithFormat:
			@"<Dupe: %p> %ld starks, urlN: %@",
			self,
			(long)[self numberOfStarks],
			[self url]] ;
}

- (NSComparisonResult)compareUrls:(Dupe*)otherDupe {
	return [[self url] localizedCaseInsensitiveCompare:[otherDupe url]] ;
}

/*
 + (NSDictionary*)classObservers {
 NSDictionary* classObservers ;
 NSDictionary* observerInfo = [NSDictionary dictionaryWithObjectsAndKeys:
 (BkmxAppDel*)[NSApp delegate], constKeyObserver,
 [NSNumber numberWithInt:NSKeyValueObservingOptionNew], constKeyObserverOptions,
 nil] ;
 // Thus, (BkmxAppDel*)[NSApp delegate] must respond to
 // -observeValueForKeyPath:ofObject:change:context:
 // This is indeed implemented in BkmxAppDel (ObservationRouter)
 
 // We observe the 'starks' relationship so that we can delete a
 // dupe when its count of starks falls below 2.
 classObservers = [NSDictionary dictionaryWithObjectsAndKeys:
 observerInfo, constKeyStarks,
 nil] ;
 
 return classObservers ;
 }
 */


@end
