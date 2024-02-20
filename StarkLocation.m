#import "StarkLocation.h"
#import "Stark+Attributability.h"
#import "Starker.h"
#import "BkmxDoc.h"
#import "ContentDataSource.h"
#import "ContentOutlineView.h"

@implementation StarkLocation

@synthesize index ;
@synthesize parent ;

- (StarkCanParent)canInsertItems:(NSArray*)items
                             fix:(StarkLocationFix)fix
                     outlineView:(ContentOutlineView*)outlineView {
    BOOL didRetarget = NO ;
	BOOL ok = YES ;
    StarkCanParent result ;

	// Start by assuming no retargetting is necessary:
	NSInteger indexOut = [self index] ;
	Stark* parentOut = [self parent] ;
	
	// If sender used [location parent] = nil to indicate root...
	BOOL locationParentWasNil = NO ;
	if (parentOut == nil) {
		// Set parentOut to the actual root which it signifies
		// until the end of this method.  This is because
		// we need to have the real thing to send messages to.
		parentOut = [[[[outlineView delegate] document] starker] root] ;
		
		// Remember to set it back later if unchanged
		locationParentWasNil = YES ;
	}
	
	// Check if all items are moveable and handle
	for (Stark* item in items) {
		if (![item isMoveable]) {
			ok = NO ;
			// This cannot be fixed by retargetting.
			// No sense doing any further testing
            result = StarkCanParentNopeItemNotMoveable;
			goto end ;
		}
	}
	
	// Check that parentOut is a container and can accept this child
	if (![parentOut canHaveChildren]) {
		ok = NO ;
		if (fix != StarkLocationFixNone) {
			// Retarget to its parent, just below the original target
			indexOut = [parentOut indexValue] + 1 ;	
			parentOut = [parentOut parent] ;
            didRetarget = YES ;
			
			ok = (parentOut != nil) ;
			if (ok == NO) {
                result = StarkCanParentNopeDestinationCannotHaveChildren;
                goto end ;
			}
		}
		else {
            result = StarkCanParentNopeDestinationCannotHaveChildren;
			goto end ;
		}
	}
	
	// Check parentOut for incest with any of items and try to fix by retargetting
	ok = NO ;
    BOOL didRetargetForIncest = NO;
	while (ok == NO) {
		ok = YES ;
		for (Stark* item in items) {
            if (didRetargetForIncest) {
                if (parentOut == item) {
                    ok = NO;
                    result = StarkCanParentNopeIncest;
                    goto end ;
                }
            }
			if ([parentOut hasIncestWithProposedChild:item]) {
				ok = NO ;
                // Retarget to its parent, just below the original target
                indexOut = [parentOut indexValue] + 1 ;
                parentOut = [parentOut parent] ;
                didRetargetForIncest = YES ;

                // Now try them all over again
                break ; // to break out of the inner loop
			}
		}
	}
    if (didRetargetForIncest) {
        didRetarget = YES;
    }
	
	// If the document is in flat mode (outlineMode=NO),
	// and in particular if we just retargetted from a non-container to its parent,
	// parentOut may not exist in the outline.
	// Cocoa will barf loudly in that case, so we check for it...
	if (outlineView != nil) {		
		if (![parentOut isRoot]) { // Don't change indexOut if parentOut is already root 
			ContentDataSource* dataSource = [outlineView dataSource] ;
			if (![dataSource outlineView:outlineView
							containsItem:parentOut]) {
				// The outlineView must be in flat mode.
				ok = NO ;
				if (fix != StarkLocationFixNone) {
					// Retarget to root, making it the last sibling
					parentOut = [[[[[outlineView window] windowController] document] starker] root] ;
					indexOut = [dataSource outlineView:outlineView
								numberOfChildrenOfItem:nil] ;
                    didRetarget = YES ;
				}
				else {
                    result = StarkCanParentNopeParentProbablyRetargettedNotShowingInFlatMode;
                    goto end ;
				}
				
			}
		}
	}
	
	// Make sure that ownerApp can accept these items in the proposed parent
	// Note that if location is an orphan, does not belong to any BkmxDoc,
	// [parentOut isRoot] will return NO, which will correctly skip the this test.
	BkmxDoc* bkmxDoc = (BkmxDoc*)[parentOut owner] ;
	ok = NO ;
	while (ok == NO) {
		ok = YES ;
		for (Stark* item in items) {
			if (![bkmxDoc canHaveParentSharype:[parentOut sharypeValue]
										stark:item]) {
				Stark* newParentOut = [bkmxDoc fosterParentForStark:item] ;
				
				if (newParentOut != parentOut) {
					ok = NO ;
					
					if (fix != StarkLocationFixNone) {
						parentOut = newParentOut ;
                        didRetarget = YES ;
                        
						// Now restart trying items
						break ; // to the outer loop
					}
					else {
                        result = StarkCanParentNopeStructureDoesNotAllowGivenChildInGivenParent;
                        goto end ;
					}
				}
			}
		}			
	}
	
	// Done with parent, now start on index
	if (fix == StarkLocationFixParentAndIndex) {
		// The following may happen if an item has been dropped on a desired parent in an NSOutlineView
		if (indexOut == -1) { 
			indexOut = NSNotFound ;
		}
		
		if ([parentOut isRoot]) { 
			BkmxDoc* owner = (BkmxDoc*)[parentOut owner] ;

			// Item must be placed below any hartainers
			NSInteger minIndexAllowed = 0 ;
			if ([owner hasBar] == YES) {
				minIndexAllowed++ ;
			}
			if ([owner hasMenu] == YES) {
				minIndexAllowed++ ;
			}
			if ([owner hasUnfiled] == YES) {
				minIndexAllowed++ ;
			}
			if ([owner hasOhared] == YES) {
				minIndexAllowed++ ;
			}
			
			if (indexOut < minIndexAllowed) {
                didRetarget = YES;
                indexOut = minIndexAllowed ;
			}
		}	
		
		// Make sure not to overrun the new siblings array.
		// Important because Cocoa will log a message to the console (which may be enormous because
		// it includes the (recursive) desription of the target, if you try and drop an item
		// on an NSOutlineView item out of range.
		NSInteger maxIndexAllowed = [parentOut numberOfChildren] ;
		if (indexOut > maxIndexAllowed) {
			indexOut = maxIndexAllowed ;
            didRetarget = YES;
		}
	}
	
	// Possibly restore the nil placeholder
	if (locationParentWasNil && ([parentOut isRoot])) {
		// Sender was using nil as a placeholder for the outline's root,
		// and this turned out to have been an OK location.
		// Restore the placeholder.
		parentOut = nil ;
	}
	
	// Finally, retarget
    BOOL didRetargetToDifferentFolder = NO ;
	if (fix != StarkLocationFixNone) {
		[self setParent:parentOut] ;
	}
    if (fix == StarkLocationFixParentAndIndex) {
        if (didRetarget) {
            [self setIndex:indexOut] ;
        }
    }
	
end:;
    if (ok) {
        if (didRetarget) {
            if (didRetargetToDifferentFolder) {
                result = StarkCanParentOkDidFixToDifferentFolder ;
            }
            else {
                result = StarkCanParentOkDidFixToCurrentFolder ;
            }
        }
        else {
            result = StarkCanParentOkAsRequested ;
        }
    }

    return result ;
}	

- (StarkCanParent)canInsertItem:(Stark*)item
                            fix:(StarkLocationFix)fix
                    outlineView:(ContentOutlineView*)outlineView {
	return [self canInsertItems:[NSArray arrayWithObject:item]
                            fix:fix
					outlineView:outlineView] ;
}

- (id)initWithParent:(id)parent_
			   index:(NSInteger)index_ {
	if ((self = [super init])) {
		[self setIndex:index_] ;
		[self setParent:parent_] ;
	}
	return self ;
}

+ (StarkLocation*)starkLocationWithParent:(id)parent
									index:(NSInteger)index {
	StarkLocation* x = [[StarkLocation alloc] initWithParent:(id)parent
												 index:(NSInteger)index] ;
 	return [x autorelease];
}

- (void)dealloc
{
	[parent release] ;
	
    [super dealloc] ;
}

- (NSString*)description {
	return [NSString stringWithFormat:@"StarkLocation: child %ld of parent %p %@", (long)[self index], [self parent], [[self parent] name]] ;
}


@end
