#import "NSDictionary+KeyPaths.h"
#import "NSArray+SSYMutations.h"
#import "NSDictionary+SimpleMutations.h"


@implementation NSDictionary (KeyPaths)

- (id)valueForKeyPathArray:(NSArray*)keyPathArray {
	// Don't use componentsJoinedByString:@"." because it is legal
	// for a key path to contain a dot/period.
	id obj = self;
	for(id key in keyPathArray) {
		obj = [obj objectForKey:key] ;
	}
	
	return obj ;
}

@end


@implementation NSMutableDictionary (KeyPaths)

- (void)setValue:(id)value
 forKeyPathArray:(NSArray*)keyArray {
	NSInteger N = [keyArray count] ;
	if (N < 1) {
		return ;
	}	
	
	NSMutableArray* dics = [[NSMutableArray alloc] init] ;
	id object = self ;
	id nextObject = value ;
	NSInteger i ;
	for (i=0; i<N-1; i++) {
		NSString* key = [keyArray objectAtIndex:i] ;
		object = [object objectForKey:key] ;
		if (object) {
			// Required dictionary already exists.  Stash it for later.
			[dics addObject:object] ;
		}
		else {
			// Dictionary does not exist staring at this level.
			// Make one, from the bottom up, starting with 
			// the value and the last key in keyArray.
			// Then break out of the loop.
			NSInteger j  ;
			nextObject = value ;
            // The following if() qualifiction is a bug fixed in
            // BookMacster 1.13.2.  If the passed-in value is nil, because the
            // caller wants us to remove key, nextObject will be nil at this
            // point, and -dictionaryWithObject:nil will cause a crash.  In
            // fact, if there is no dictionary, and we don't want one, the
            // correct action is to do nothing!
			if (nextObject) {
                for (j=N-1; j>i; j--) {
                    NSString* aKey = [keyArray objectAtIndex:j] ;
                    nextObject = [NSDictionary dictionaryWithObject:nextObject
                                                             forKey:aKey] ;
                }
            }
            // The above SEEMS LIKE A BUG.  What if nextObject is nil, because value is nil, because
            // we were requested to remove a key
			
			break ;
		}
	}
	
	
	// Reverse-enumerate through the dictionaries, starting at
	// the inside and setting little dictionaries as objects
	// inside the bigger dictionaries
	NSEnumerator* e = [dics reverseObjectEnumerator] ;
	NSMutableDictionary* copy ;
	for (NSDictionary* dic in e) {
		copy = [dic mutableCopy] ;
		NSString* key = [keyArray objectAtIndex:i] ;
		if (nextObject) {
			[copy setObject:nextObject
				 forKey:key] ;
		}
		else {
			[copy removeObjectForKey:key] ;
		}
		nextObject = [copy autorelease] ;
		i-- ;
	}
	[dics release] ; // Memory leak fixed in BookMacster 1.11
	
	// if () added as bug fix in BookMacster 1.14.4.  I think this occurs if the
    // first key in the given keyPathArray is absent from the dictionary,
    // *and* the given value is nil.
    if (nextObject) {
        [self setObject:nextObject
			 forKey:[keyArray objectAtIndex:0]] ;
    }
}

- (void)setValue:(id)value
	  forKeyPath:(NSString*)keyPath {
	NSArray* keyPathArray = [keyPath componentsSeparatedByString:@"."] ;
	[self setValue:value
   forKeyPathArray:keyPathArray] ;
}

-      (void)addObject:(id)object
 toArrayAtKeyPathArray:(NSArray*)keyPathArray {
	NSArray* array = [self valueForKeyPathArray:keyPathArray] ;
	if (array) {
		array = [array arrayByAddingObject:object] ;
	}
	else {
		array = [NSArray arrayWithObject:object] ;
	}
	
	[self setValue:array
   forKeyPathArray:keyPathArray] ;
}

-      (void)addObject:(id)object
	  toArrayAtKey:(NSString*)key {
	NSArray* keyPathArray = [NSArray arrayWithObject:key] ;
	[self addObject:object toArrayAtKeyPathArray:keyPathArray] ;
}

- (void)addUniqueObject:(id)object
  toArrayAtKeyPathArray:(NSArray*)keyPathArray {
	NSArray* array = [self valueForKeyPathArray:keyPathArray] ;
	if (array) {
		array = [array arrayByAddingUniqueObject:object] ;
	}
	else {
		array = [NSArray arrayWithObject:object] ;
	}
	
	[self setValue:array
   forKeyPathArray:keyPathArray] ;
}

- (void)addUniqueObject:(id)object
	   toArrayAtKey:(NSString*)key {
	NSArray* keyPathArray = [NSArray arrayWithObject:key] ;
	[self addUniqueObject:object toArrayAtKeyPathArray:keyPathArray] ;
}

-     (void)removeObject:(id)object
 fromArrayAtKeyPathArray:(NSArray*)keyPathArray {
	NSArray* array = [self valueForKeyPathArray:keyPathArray] ;
	if (array) {
		array = [array arrayByRemovingObject:object] ;
		[self setValue:array
	   forKeyPathArray:keyPathArray] ;
	}
	else {
		// The array doesn't exist.  Don't do anything.
	}
}

-     (void)removeObject:(id)object
	  fromArrayAtKey:(NSString*)key {
	NSArray* keyPathArray = [NSArray arrayWithObject:key] ;
	[self removeObject:object fromArrayAtKeyPathArray:keyPathArray] ;
}

-             (void)removeKey:(id)key
 fromDictionaryAtKeyPathArray:(NSArray*)keyPathArray {
	NSDictionary* dictionary = [self valueForKeyPathArray:keyPathArray] ;
	if (dictionary) {
		dictionary = [dictionary dictionaryBySettingValue:nil
												   forKey:key] ;
		[self setValue:dictionary
	   forKeyPathArray:keyPathArray] ;
	}
	else {
		// The dictionary doesn't exist.  Don't do anything.
	}
}

-     (void)removeKey:(id)innerKey
  fromDictionaryAtKey:(NSString*)key {
	NSArray* keyPathArray = [NSArray arrayWithObject:key] ;
	[self removeKey:innerKey fromDictionaryAtKeyPathArray:keyPathArray] ;
}

@end