#import "NSDictionary+Treedom.h"

NSString* const constKeyTreedomChildrenLower = @"children" ;
NSString* const constKeyTreedomChildrenUpper = @"Children" ;

@implementation NSDictionary (Treedom)

- (void)moveToChildrenKey:(NSString*)childrenKey
			  ofNewParent:(NSMutableDictionary*)newParent {
	// Add me to new parent
	if (newParent) {
		NSMutableArray* newSiblings = [newParent objectForKey:childrenKey] ;
		if (newSiblings) {
			// Add to existing children
			[newSiblings addObject:self] ;
		}
		else  {
			// New parent has no children yet, so make an array 
			[newParent setObject:[NSMutableArray arrayWithObject:self]
						  forKey:childrenKey] ;
		}
	}
}

/*
 Used when constructing tree for export to Safari or Camino
 */
- (void)moveToChildrenLowerOfNewParent:(NSMutableDictionary*)newParent {
	[self moveToChildrenKey:constKeyTreedomChildrenLower
				ofNewParent:newParent] ;
}

- (void)moveToChildrenUpperOfNewParent:(NSMutableDictionary*)newParent {
	[self moveToChildrenKey:constKeyTreedomChildrenUpper
				ofNewParent:newParent] ;
}

- (void)recursivelyPerformSelector:(SEL)selector
                       childrenKey:(NSString *)childrenKey
                            object:(id)object {
    /* Static analyzer started complaining about this in Xcode 9.1.
     There are other ways to fix it, see
     https://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
     But in my opinion it's just the static analyzer being too fussy.  Everyone
     should know that you must be careful with Objective-C. */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:selector
               withObject:object] ;
#pragma clang diagnostic pop

    NSArray* children = [self objectForKey:childrenKey] ;
    if ([children count] > 0) {
        // Recursion
        for (NSDictionary* child in children) {
            [child recursivelyPerformSelector:selector
                                  childrenKey:childrenKey
                                       object:object] ;
        }
    }
}

- (void)recursivelyPerformOnChildrenLowerSelector:(SEL)selector
									   withObject:(id)object {
    [self recursivelyPerformSelector:selector
                         childrenKey:constKeyTreedomChildrenLower
                              object:object];
}

- (void)recursivelyPerformOnChildrenUpperSelector:(SEL)selector
                                       withObject:(id)object {
    [self recursivelyPerformSelector:selector
                         childrenKey:constKeyTreedomChildrenUpper
                              object:object];
}

@end

