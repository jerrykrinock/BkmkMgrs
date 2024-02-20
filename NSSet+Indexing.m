#import "NSSet+Indexing.h"
#import "SSYIndexee.h"

@implementation NSSet (Indexing)

- (NSArray*)arraySortedByKeyPath:(NSString*)keyPath {
	NSArray* unorderedArray = [self allObjects] ;
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:keyPath
																   ascending:YES] ;
    NSArray* orderedArray = [unorderedArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release] ;
	return orderedArray ;
}

- (void)changeMemberIndexValuesBy:(NSInteger)delta
	  ifCurrentValueIsGreaterThan:(NSInteger)lowerBound
					  andLessThan:(NSInteger)upperBound {
	for (NSObject <SSYIndexee> * object in self) {
		NSNumber* indexNumber = [object index] ;
		NSInteger oldIndex = [indexNumber integerValue] ;
		if ((oldIndex > lowerBound) && (oldIndex < upperBound)) {
			[(id <SSYIndexee>)object setIndex:[NSNumber numberWithInteger:(oldIndex + delta)]] ;
		}
	}
}

- (void)changeMemberIndexValuesBy:(NSInteger)delta
			ifCurrentValueExceeds:(NSInteger)threshold {
	for (NSObject <SSYIndexee> * object in self) {
		NSNumber* indexNumber = [object index] ;
		NSInteger oldIndex = [indexNumber integerValue] ;
		if (oldIndex > threshold) {
			[(id <SSYIndexee>)object setIndex:[NSNumber numberWithInteger:(oldIndex + delta)]] ;
		}
	}
}

- (void)restackIndexes {
	if ([self count] < 1) {
		return ;
	}
	
	NSMutableArray* array = [[self allObjects] mutableCopy] ;

#if (MAC_OS_X_VERSION_MIN_REQUIRED < 1060) 
	NSSortDescriptor* sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:constKeyIndex
																	ascending:YES] autorelease] ;
#else
	NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:constKeyIndex
																	 ascending:YES] ;
#endif
	[array sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] ;
	NSInteger i = 0 ;
	for (id <SSYIndexee> object in array) {
		[object setIndex:[NSNumber numberWithInteger:i++]] ;
	}
	[array release] ;
}


@end


@implementation NSMutableSet (Indexing)

- (void)addObject:(id <SSYIndexee>)newObject
		  atIndex:(NSInteger)index {
	id equalMemberAlreadyInSet = [self member:newObject] ;
	if (equalMemberAlreadyInSet) {
		// self already contains an object which is equal to the
		// new object.  Therefore, when we invoke -addObject:
		// at the end of this method, it will no-op.  However,
		// we may move the existing object to the new index
		[self moveObject:equalMemberAlreadyInSet
				 toIndex:index] ;

		return ;
	}
	
	NSInteger nSiblings = [self count] ;
	
	if (index > nSiblings) {
		// Don't allow gaps in index set
		index = nSiblings ;
	}
	else if (index < nSiblings) {
		// Displace newSiblings to make room
		[self changeMemberIndexValuesBy:+1
				  ifCurrentValueExceeds:(index - 1)] ;
	}
	
	[newObject setIndex:[NSNumber numberWithInteger:index]] ;
	[self addObject:newObject] ;
}

- (void)removeIndexedObject:(id <SSYIndexee>)object {
	// The following was added to fix bugs in BookMacster 1.5.
	// If the receiver does not contain an object which
	// is equal to the given 'object', -removeObject:
	// will perform no-op.  Therefore, we don't want
	// to mess with the indexes, or anything.
	if (![self member:object]) {
		return ;
	}

    NSInteger index = [[object index] integerValue] ;
	[self removeObject:object] ;
	if ([self count] > index) {
		// Decrement indexes of higher-indexed old siblings
		[self changeMemberIndexValuesBy:-1
				  ifCurrentValueExceeds:index] ;
	} 
}

- (void)moveObject:(id <SSYIndexee>)object
		   toIndex:(NSInteger)index {
	NSInteger nSiblings = [self count] ;
	
	if (index > nSiblings) {
		// Don't allow gaps in index set
		index = nSiblings ;
	}
	
	NSInteger existingIndex = [[object index] integerValue] ;
	if (existingIndex == index) {
		return ;
	}
	
	// Prior to BookMacster 0.9.10, this method ended with:
	//  [self removeIndexedObject:object] ;
	//  [self addObject:object
	//		atIndex:index] ;
	// The following code is new.
	
	if (index < existingIndex) {
		// Moving up, to lower index number
		[self changeMemberIndexValuesBy:+1
			ifCurrentValueIsGreaterThan:(index - 1)
							andLessThan:existingIndex] ;
	}
	else {
		// Moving down, to higher index number
		[self changeMemberIndexValuesBy:-1
			ifCurrentValueIsGreaterThan:existingIndex
							andLessThan:(index + 1)] ;
	}
	[object setIndex:[NSNumber numberWithInteger:index]] ;
}

@end


@implementation NSArray (HelpWithSets)

+ (NSArray*)arrayWithSet:(NSSet*)set
			valueKeyPath:(NSString*)keyPath {
	NSEnumerator* e = [set objectEnumerator] ;
	id object ;
	NSMutableArray* mutableArray = [[NSMutableArray alloc] init] ;
	if (keyPath) {
		while ((object = [e nextObject])) {
			[mutableArray addObject:[object valueForKeyPath:@"name"]] ;
		}
	}
	else {
		while ((object = [e nextObject])) {
			[mutableArray addObject:object] ;
		}
	}		
	
	NSArray* output = [mutableArray copy] ;
	[mutableArray release] ;
	
	return [output autorelease] ;
}

@end
