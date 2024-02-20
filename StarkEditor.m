#import "StarkEditor.h"
#import "Bkmxwork/Bkmxwork-Swift.h"
#import "BkmxDoc.h"
#import "NSArray+Starks.h"
#import "Stark+Sorting.h"
#import "Stark+Attributability.h"
#import "Starker.h"
#import "BkmxAppDel+Actions.h"
#import "BkmxAppDel+Capabilities.h"
#import "BkmxBasis+Strings.h"
#import "SSWebBrowsing+Bkmx.h"
#import "ContentOutlineView.h"
#import "BkmxArrayCategories.h"
#import "NSString+LocalizeSSY.h"
#import "SSYProgressView.h"
#import "BkmxDocWinCon.h"
#import "NSObject+MoreDescriptions.h"
#import "NSInvocation+Quick.h"
#import "SSYMOCManager.h"

@implementation StarkEditor

+ (void)removeStarks:(NSSet*)starks
             bkmxDoc:(BkmxDoc*)bkmxDoc {
    if ([starks count] > 0) {
        NSMutableSet* affectedParents = [[NSMutableSet alloc] init] ;
        
        // Need to get the owner before we delete the items, because after we
        // do that, sending them -owner will return nil.
        id owner = [[starks anyObject] owner] ;
        
        // Phase 1.  Delete the starks
        SSYProgressView* progressView = [[bkmxDoc progressView] setIndeterminate:NO
                                                               withLocalizedVerb:[[NSString localizeFormat:
                                                                                   @"deleting%0",
                                                                                   [NSString localize:@"items"]] lowercaseString]
                                                                        priority:SSYProgressPriorityLow] ;
        [progressView setMaxValue:[starks count]] ;
        [progressView setDoubleValue:1] ;
        for (Stark* stark in starks) {
            // Local autorelease pool added to improve performance, BookMacster version 1.3.19
            NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
            Stark* parent = [stark parent] ;
            if (parent) {
                [affectedParents addObject:parent] ;
            }
            
            // If a stark is being removed, we no longer need to restack it in Phase 2
            [affectedParents removeObject:stark] ;
            [stark moveToBkmxParent:nil
                            atIndex:NSNotFound
                            restack:NO] ;
            [pool drain] ;
            [progressView incrementDoubleValueBy:1] ;
        }
        
        [progressView clearAll] ;
        
        // Phase 2.  Restack the parent(s)
        // if() is an optimization, also avoids churn during export to flat extores.
        if ([owner hasOrder]) {
            [progressView setIndeterminate:NO
                         withLocalizedVerb:@"Restacking siblings"
                                  priority:SSYProgressPriorityLow] ;
            [progressView setMaxValue:[affectedParents count]] ;
            [progressView setDoubleValue:1] ;
            for (Stark* stark in affectedParents) {
                // When we do this stealthily, we must -postSortMaybeNot to bkmxDoc later
                [stark restackChildrenStealthily:YES] ;
                [progressView incrementDoubleValueBy:1] ;
            }
            [progressView clearAll] ;
        }
        [affectedParents release] ;
        
        // if () qualification added in BookMacster 1.19.9, to prevent churn.
        // This would change the shig's lastSortMaybeNot, which would cause
        // -isDocumentEdited to return YES, which would cause the next autosave
        // to proceed instead of being stopped in -[BkmxDoc ],
        // which would cause an import on other Mac if syncing via Dropbox.
        if (owner == bkmxDoc) {
            [bkmxDoc postSortMaybeNot] ;
        }
    }
}

+ (NSArray*)starksFromSender:(id)sender {
    NSArray* starks = nil ;
    
    // Choice 1:  sender itself is a single stark
    if ([sender isKindOfClass:[Stark class]]) {
        starks = [NSArray arrayWithObject:self] ;
    }
    
    // Choice 2:  sender is the collection of starks
    if ([sender respondsToSelector:@selector(count)]) {
        starks = sender ;
    }
    
    // Choice 3: sender is an NSMenuItem.
    if ([sender respondsToSelector:@selector(representedObject)]) {
        // sender is an NSMenuItem from a contextual menu
        id object = [(NSMenuItem*)sender representedObject] ;
        // Choice 3a:  representedObject is the collection of starks
        if ([object respondsToSelector:@selector(count)]) {
            starks = object ;
        }
        // Choice 3b:  representedObject is a BkmxDocChildWindowController
        else if ([object respondsToSelector:@selector(selectedStarks)]) {
            starks = [(BkmxDocWinCon*)object selectedStarks] ;
        }
        // Choice 3c:  representedObject is a view in a window controller by
        // a BkmxDocChildWindowController
        else if ([object respondsToSelector:@selector(window)]) {
            object = [[(NSWindowController*)object window] windowController] ;
            if ([(NSWindowController*)object respondsToSelector:@selector(selectedStarks)]) {
                starks = [(BkmxDocWinCon*)object selectedStarks] ;
            }
        }
    }
    
    // Choice 4: sender is a BkmxDocChildWindowController.
    if ([sender respondsToSelector:@selector(selectedStarks)]) {
        starks = [(BkmxDocWinCon*)sender selectedStarks] ;
    }
    
    // Choice 5: sender is an NSView.
    if (!starks) {
        if ([sender respondsToSelector:@selector(window)]) {
            NSWindowController* windowController = [[(NSView*)sender window] windowController] ;
            if ([windowController respondsToSelector:@selector(selectedStarks)]) {
                starks = [(BkmxDocWinCon*)windowController selectedStarks] ;
            }
        }
    }
    
    // Choice 6: sender is nil, or something that is useless for our purposes.
    if (!starks) {
        NSWindow* window = [NSApp mainWindow] ;
        NSWindowController* windowController = [window windowController] ;
        if ([windowController respondsToSelector:@selector(selectedStarks)]) {
            starks = [(BkmxDocWinCon*)windowController selectedStarks] ;
        }
    }
    
    return starks ;
}

+ (StarkCanParent)canInsertStarks:(NSArray*)items
                       intoParent:(Stark*)parent {
    StarkLocation* location = [StarkLocation starkLocationWithParent:parent
                                                               index:NSNotFound] ;
    return [location canInsertItems:items
                                fix:StarkLocationFixNone
                        outlineView:nil] ;
}

+ (StarkCanParent)parentingAction:(BkmxParentingAction)action
                            items:(id)items
                        newParent:(Stark*)newParent
                         newIndex:(NSInteger)newIndex
                     revealDestin:(BOOL) revealDestin {
#if 0
#warning Logging parentingAction:::::
    NSLog(
          @"->\n"
          @"parentingAction: %ld\n"
          @"          items: %@\n"
          @"      newParent: %@\n"
          @"       newIndex: %ld\n",
          (long)action,
          [items listValuesForKey:constKeyName
                      conjunction:nil
                       truncateTo:0],
          [newParent shortDescription],
          (long)newIndex
          ) ;
#endif
    
    // Original algorithm design for this method was in document "ParentingActions.xls"
    
    // Examine the two "new" id arguments, which come elsewhere, and make them into single-object arrays
    // if they are non-nil and not arrays.
    Class arrayClass = [NSArray class] ;
    if (items && ![items isKindOfClass:arrayClass]) {
        items = [NSArray arrayWithObject:items] ;
    }    
    
    //  Assign refs needed for bkmxDocSource and bkmxDocDestin, coming up after this.
    BkmxDoc* bkmxDocSource = nil ;
    if ([items count]) {
        bkmxDocSource = (BkmxDoc*)[[items objectAtIndex:0] owner] ;
    }
    
    BkmxDoc* bkmxDocDestin = (BkmxDoc*)[newParent owner] ;
    
    // Changed in BookMacster 1.14
    // If action is MoveOrCopy, resolve it into one or the other
    if (action == BkmxParentingMoveOrCopy) {
        if (bkmxDocSource != bkmxDocDestin) {
            // inter-document
            action = BkmxParentingCopy ;
        }
        else {
            // intra-document
            action = BkmxParentingMove ;
        }
    }
    // Below here, action BkmxParentingMoveOrCopy need not be considered.
    
    //  Assign data arrays for itemsActuallyDelivered for selecting at the end
    NSMutableArray* itemsActuallyDelivered = nil ;
    if ((action == BkmxParentingAdd) || (action == BkmxParentingCopy) || (action == BkmxParentingMove)) {
        itemsActuallyDelivered = [[NSMutableArray alloc] init] ;
    }
    
    // At the head of Loop 1 below, immoveable containers will be ignored.
    // But we don't want their children to be ignored, so we add them
    // to 'items' directly
    items = [items arrayOfStarksByPromotingChildrenOfImmoveableContainers] ;
    
    /* Well, there are two possible algorithms to do this.  We have two arrays to inspect,
     'items' and 'copies', for objects to "move" and "remove".  Algorithm "A" is to
     loop through 'items', moving and removing on the fly, then loop through 'copies'
     and do the same thing.  Algorithm "B" is to (1) loop through 'items', adding to the
     following four arrays the objects to move, where to move them, and the objects 
     to remove, and then (2) loop through 'copies', adding more to these arrays,
     then (3) remove the collected removees and finally (4) move the collected movees.
     I first did Algorithm "A", since most of the effort is in the collecting,
     the moveeTargetIndexes would get to be a mess and alot of unnecessary processing
     when you have to increment them, and also the loop through copies is rather easy
     since these can only be removed; they are never moved.  But then I realized that,
     in order for indexes to be preserved, "moving" must be done in forward order, but
     "removing" must be done in reverse order.  So, we now use Algorithm "B". */
    // Arrays for collecting objects for moving and removing
    NSMutableArray* moves = [[NSMutableArray alloc] init] ;
    NSMutableArray* removees = [[NSMutableArray alloc] init] ;
    
    // Variables to be used in loops
    Stark* movee ;
    Stark* removee ;
    StarkLocation* moveeTargetStarkLocation ;
    NSInteger moveeTargetIndex ;
    
    // Loop 1 of 4.  Loop through 'items'.  Make copies and collect movees, their targets, and removees
    
    // Alloc init an array to be used to make sure that we don't repeat
    // items already processed.
    NSMutableArray* itemsAlreadyProcessed = [[NSMutableArray alloc] init] ;
    NSInteger i = 0 ;    
    StarkCanParent result = StarkCanParentOkAsRequested ;
    for (Stark* item in items) {
        // If a user selects a child and its parent, it might be
        // in 'items' twice, which means that it would be deleted
        // from the managed object context twice, for example.
        // We now filter those out.
        if ([itemsAlreadyProcessed containsObject:item]) {
            continue ;
        }
                
        // Immoveable containers get filtered out too.  (We have
        // previously "promoted" their children.
        if (![item isMoveable]) {
            continue ;
        }

        NSMutableArray* itemAndDescendants = [[NSMutableArray alloc] init] ;
        [item classifyBySharypeDeeply:YES
                           hartainers:nil // These should already have been removed
                          softFolders:itemAndDescendants
                               leaves:itemAndDescendants
                              notches:itemAndDescendants] ;
        [itemsAlreadyProcessed addObjectsFromArray:itemAndDescendants] ;
        [itemAndDescendants release] ;    
        
        moveeTargetIndex = newIndex ;
        
        // Retarget newParent and moveeTargetIndex if needed
        StarkLocation* location ;
        Stark* fixedNewParent = newParent ;
        // Assume it will work
        StarkCanParent thisResult = StarkCanParentOkAsRequested ;
        if (newParent) {
            location = [StarkLocation starkLocationWithParent:newParent
                                                        index:moveeTargetIndex] ;
            thisResult = [location canInsertItems:[NSArray arrayWithObject:item]
                                              fix:StarkLocationFixParentAndIndex
                                      outlineView:nil] ;
            fixedNewParent = [location parent] ;
        }
        else {
            location = nil ;
        }
        if (thisResult < result) {
            result = thisResult ;
        }
        
        if (thisResult >= StarkCanParentOkDidFixToCurrentFolder) {
            NSInteger fixedMoveeTargetIndex = [location index] ;
            
            // Assign movee and removee, making freshCopy if needed
            movee = nil ;
            removee = nil ;
            Stark* freshCopy = nil ;
            switch (action) {
                case BkmxParentingRemove:
                    removee = item ;
                    break ;
                case BkmxParentingCopy:
                    // We need a fresh copy since the copied item must have new exids and addDate
                    freshCopy = [item copyDeepOrphanedFreshened:YES
                                                     replicator:bkmxDocDestin] ; // copy, not autoreleased
                    [freshCopy autorelease] ;
                    movee = freshCopy ;
                    break ;
                case BkmxParentingMove:
                case BkmxParentingAdd:
                    movee = item ;
                    break ;
                case BkmxParentingActionNone:
                    NSLog(@"Internal Error 215-0484") ;
                    break;
                case BkmxParentingMoveOrCopy:
                    NSLog(@"Internal Error 215-0483") ;
                    break ;
            }
            
            // Added in BookMacster 1.21.4.
            // If a separator had to be retargetted because it is not allowed
            // at the new parent, don't move it, remove it.  Note: BothMovesRemoves
            if (newParent != fixedNewParent) {
                if ([movee sharypeCoarseValue] == SharypeCoarseNotch) {
                    removee = movee ;
                    movee =  nil ;
                }
            }
            
            // Add removee if one was generated
            if (removee) {
                [removees addObject:removee] ;
            }
            
            moveeTargetStarkLocation = nil ;
            if (fixedNewParent && movee) {
                moveeTargetStarkLocation = [[StarkLocation alloc] initWithParent:fixedNewParent
                                                                           index:fixedMoveeTargetIndex] ;
                // Noted in development of BookMacster 1.11.4: Why is it necessary to
                // send the following message *again*?
                [moveeTargetStarkLocation canInsertItems:nil
                                                     fix:StarkLocationFixParentOnly
                                             outlineView:nil] ;
                // Do not involve outlineView because we will be dropping other items
                // ahead of this one, so the range may not be OK now but it
                // it will be at the time we insert it.  We do not want our
                // target index to be changed due to out of range.
                
                // Add move info to collection ''
                NSMutableDictionary* move = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                             movee, @"movee", nil] ;
                if (moveeTargetStarkLocation) {
                    [move setObject:moveeTargetStarkLocation
                             forKey:@"moveeTargetStarkLocation"] ;
                }
                [moveeTargetStarkLocation release] ;  // Memory leak fixed in BookMacster 1/17
                [moves addObject:move] ;
                [move release] ;            
            }
        }
        
        i++ ;
    }
    [itemsAlreadyProcessed release] ;
    
    // Loop 2 of 4.  Move the items in moves.

    NSMutableSet* affectedParents = [[NSMutableSet alloc] init] ;
    NSMutableDictionary* displacedIndexSets = [[NSMutableDictionary alloc] init] ;
    for (NSDictionary* move in moves) {
        // Unpack the move
        movee = [move objectForKey:@"movee"] ;
        moveeTargetStarkLocation = [move objectForKey:@"moveeTargetStarkLocation"] ;
        Stark* moveeTargetParent = [moveeTargetStarkLocation parent] ;
        moveeTargetIndex = [moveeTargetStarkLocation index] ;
        
        Stark* oldParent = [movee parent] ;
        if (oldParent) {
            [affectedParents addObject:oldParent] ;
        }

        NSInteger adjustedTargetIndex = moveeTargetIndex ;
        NSMutableIndexSet* displacedIndexSet = [displacedIndexSets objectForKey:[moveeTargetParent objectID]] ;
        if (displacedIndexSet) {
            NSInteger lastUsedIndexForThisParent = [displacedIndexSet lastIndex] ;
            if (adjustedTargetIndex <= lastUsedIndexForThisParent) {
                adjustedTargetIndex = ++lastUsedIndexForThisParent ;
            }
            [displacedIndexSet addIndex:adjustedTargetIndex] ;
        }
        else {
            displacedIndexSet = [NSMutableIndexSet indexSetWithIndex:adjustedTargetIndex] ;
        }
        // Note 20120614
        [displacedIndexSets setObject:displacedIndexSet
                               forKey:[moveeTargetParent objectID]] ;
        
        [movee setDonkey:1] ;  // donkey=1 means that this was child was moved
        [affectedParents addObject:moveeTargetParent] ;
#if DEBUG
        // Defensive programming in BookMacster 1.21.4
        if (adjustedTargetIndex < 0) {
            NSLog(@"Internal Error 282-4974 %@ to %ld", [moveeTargetParent shortDescription], (long)adjustedTargetIndex) ;
        }
#endif
        movee = [movee moveToBkmxParent:moveeTargetParent
                                atIndex:adjustedTargetIndex
                                restack:NO] ;
        // Note: If moving to a different managed object context (i.e. a different
        // BkmxDoc), the above will assign a new movee inserted in to the new moc.
        [itemsActuallyDelivered addObject:movee] ;
    }

    // Loop 3 of 4.  Remove the items in removees
    
    for (removee in removees) {
        Stark* parent = [removee parent] ;
        if (parent) {
            [affectedParents addObject:parent] ;
        }
        [removee moveToBkmxParent:nil
                          atIndex:0
                          restack:NO] ;
    }    
    
    // Loop 4 of 4.  Restack children in affected parents
    
    for (Stark* aParent in affectedParents) {
        NSIndexSet* displacedIndexSet = [displacedIndexSets objectForKey:[aParent objectID]] ;
        if (displacedIndexSet) {
            NSInteger firstDisplacedIndex = [displacedIndexSet firstIndex] ;
            NSInteger lastDisplacedIndex = [displacedIndexSet lastIndex] ;
            NSInteger offset = lastDisplacedIndex - firstDisplacedIndex + 1 ;
            if (offset > 0) {
                for (Stark* child in [aParent children]) {
                    if ([child donkey] == 0) {
                        // This child was not one of the movees; it was not moved
                        if ([child indexValue] >= firstDisplacedIndex) {
#if USE_OPTIMIZED_RESTACK_CHILDREN
                            [child setIndex:[NSNumber numberWithInteger:([child indexValue] + offset)]] ;
                            // Sending -[BkmxDoc postSortMaybeNot] as required by this optimization
                            // is done by -restackChildrenStealthily:, which will be invoked soon.
#else
                            [child setIndexValue:([child indexValue] + offset)] ;
#endif
                        }
                    }
                    else {
                        [child setDonkey:0] ;
                    }
                }
            }
        }
        // if() is an optimization, also avoids churn during export to flat extores.
        if ([[aParent owner] hasOrder]) {
            [aParent restackChildrenStealthily:YES] ;
        }
    }
    [displacedIndexSets release] ;
    
    // Set Undo Action(s)
    /* Note that it is possible to have both moves and removes, as indicated
     above, Note BothMovesRemoves.  In that rare case, the moves win… */
    if ([moves count] > 0) {
        SSYModelChangeAction modelAction = SSYModelChangeActionUndefined;
        if (action == BkmxParentingAdd) {
            /* This occurs if a new bookmark is created by dragging or pasting
             in from another app, or using button Add [+]. */
            modelAction = SSYModelChangeActionInsert;
        }
        else if (bkmxDocSource == bkmxDocDestin) {
            // Move within same document
            modelAction = SSYModelChangeActionMove;
        }
        else {
            // Move from one document to another.
            // Destin has items added
            modelAction = SSYModelChangeActionInsert;
        }

        NSAssert(modelAction != SSYModelChangeActionUndefined, @"Bad action");
        [bkmxDocDestin setUndoActionNameForAction:modelAction
                                           object:nil
                                        objectKey:nil
                                       updatedKey:nil
                                            count:[moves count]] ;
    }
    else if ([removees count] > 0) {
        [bkmxDocSource setUndoActionNameForAction:SSYModelChangeActionRemove
                                           object:nil
                                        objectKey:nil
                                       updatedKey:nil
                                            count:[removees count]] ;
    }

    [moves release] ;
    [removees release] ;

    BkmxDocWinCon* augmentedMWC = [bkmxDocDestin bkmxDocWinCon] ;
    BkmxDocWinCon* diminishedMWC = [bkmxDocSource bkmxDocWinCon] ;

    // This if() may be defensive programming, not sure
    if ([affectedParents count] > 0) {
        [augmentedMWC reloadStarks:affectedParents] ;
        [diminishedMWC reloadStarks:affectedParents] ;
    }

    [affectedParents release] ;

    if (revealDestin) {

        // Deselect moved items in bkmxDocSource
        // This section only does anything if we are doing a move or remove,
        // because, by design (above), if we are doing an add or copy, bkmxDocSource = nil.
        [diminishedMWC deselectAll] ;

        // Show and Select new items in bkmxDocDestin
        [augmentedMWC deselectAll] ;
        
        BOOL itemsToShow = (
                            (newParent != nil)
                            &&
                            (
                             (action == BkmxParentingAdd)
                             ||
                             (action == BkmxParentingCopy)
                             ||
                             (action == BkmxParentingMove)
                             )
                            ) ;
        BOOL yes = YES ;
        NSInvocation* showAndTell = [NSInvocation invocationWithTarget:[augmentedMWC contentOutlineView]
                                                              selector:@selector(showStarks:selectThem:expandAsNeeded:)
                                                       retainArguments:YES
                                                     argumentAddresses:&itemsActuallyDelivered, &itemsToShow, &yes] ;
        [showAndTell performSelector:@selector(invoke)
                          withObject:nil
                          afterDelay:CONTENT_OUTLINE_VIEW_RELOAD_DELAY_1] ;
    }

    [itemsActuallyDelivered release] ;
    
end:
    return result ;
}    

+ (void)moveItem:(id)item
        toParent:(id)parent
         atIndex:(NSInteger)indexNew {
    [self parentingAction:BkmxParentingMove
                    items:[NSArray arrayWithObject:item]
                newParent:parent
                 newIndex:indexNew
             revealDestin:YES] ;
}

+ (void)moveItem:(id)item
      toLocation:(StarkLocation*)location {
    [self moveItem:item
          toParent:[location parent]
           atIndex:[location index] ] ;
}

+ (BOOL)moveNoRevealStarks:(id)starkOrStarks
               toNewParent:(Stark*)newParent {
    StarkCanParent result = [self parentingAction:BkmxParentingMove
                                            items:starkOrStarks
                                        newParent:newParent
                                         newIndex:newParent.children.count
                                     revealDestin:NO] ;
    if (result != StarkCanParentOkAsRequested) {
        BkmxDoc* bkmxDoc = nil ;
        BOOL plural = NO ;
        NSString* subjectName ;
        NSString* actualNewParentName ;
        if ([starkOrStarks respondsToSelector:@selector(owner)]) {
            bkmxDoc = [starkOrStarks owner] ;
            subjectName = [starkOrStarks name] ;
            actualNewParentName = [[starkOrStarks parent] name] ;
        }
        else if ([starkOrStarks respondsToSelector:@selector(firstObject)]) {
            bkmxDoc = [[starkOrStarks firstObject] owner] ;
            actualNewParentName = [[[starkOrStarks firstObject] parent] name] ;
            if ([starkOrStarks count] > 1) {
                plural = YES ;
                // subjectName should be unused in this case
                subjectName = @"??" ;
            }
            else {
                subjectName = [[starkOrStarks firstObject] name] ;
            }
        }
        
        if ([bkmxDoc respondsToSelector:@selector(runModalSheetWithMessage:)]) {
            NSString* verb ;
            NSString* undoodle = nil ;
            if (result == StarkCanParentOkDidFixToDifferentFolder) {
                verb = [NSString stringWithFormat:
                        @"been moved instead to %@",
                        actualNewParentName] ;
                undoodle = @"\n\nClick Edit > Undo to restore to original location." ;
            }
            else {
                verb = @"not been moved" ;
            }
            NSString* noun ;
            NSString* issue ;
            if (plural) {
                noun = @"Items have" ;
                issue = @"items of those types" ;
            }
            else {
                noun = [NSString stringWithFormat:
                        @"'%@' has",
                        subjectName] ;
                issue = @"items of that type" ;
            }
            NSString* cuz ;
            /* Probably some of these cases never happen.  Others cannot
             happen during drag and drop, but they can happen during a
             contextual menu > Move To or Copy to operation. */
            switch (result) {
                case StarkCanParentNopeItemNotMoveable:
                    cuz = [NSString stringWithFormat:
                           @"%@ are not moveable.",
                           issue
                           ];
                    break;
                case StarkCanParentNopeDestinationCannotHaveChildren:
                    cuz = [NSString stringWithFormat:
                           @"%@ cannot have children.",
                           [newParent name]
                           ];
                    break;
                case StarkCanParentNopeIncest:
                    cuz = @"you cannot move a folder to inside itself.";
                    break;
                case StarkCanParentNopeParentProbablyRetargettedNotShowingInFlatMode:
                    cuz = @"the destination is not visible in Table mode.  (Switch to Outline mode).";
                    break;
                default:
                    switch ([[BkmxBasis sharedBasis] iAm]) {
                        case BkmxWhich1AppSmarky:
                            cuz = [NSString stringWithFormat:
                                   @"because %@ are not allowed in the %@ in Safari.",
                                   issue,
                                   [newParent name]] ;
                            break ;
                        case BkmxWhich1AppSynkmark:
                            cuz = [NSString stringWithFormat:
                                   @"because %@ cannot be synced to %@ in your web browsers.",
                                   issue,
                                   [newParent name]] ;
                            break ;
                        case BkmxWhich1AppBookMacster:
                            cuz = [NSString stringWithFormat:
                                   @"because this document's Structure does not allow %@ in %@.",
                                   issue,
                                   [newParent name]] ;
                            break ;
                        case BkmxWhich1AppMarkster:
                            // I think this should never happen, but not 100% sure.
                            cuz = [NSString stringWithFormat:
                                   @"because %@ are not allowed in the %@.",
                                   issue,
                                   [newParent name]] ;
                            break ;
                    }
            }
            
            NSString* msg ;
            msg = [NSString stringWithFormat:
                   @"%@ %@ %@",
                   noun,
                   verb,
                   cuz] ;
            
            if (undoodle) {
                msg = [msg stringByAppendingString:undoodle] ;
            }
            
            [bkmxDoc runModalSheetWithMessage:msg] ;
        }
    }

    return (result == StarkCanParentOkAsRequested) ;
}

+ (void)moveAndSortNoRevealStarks:(id)starkOrStarks
                      toNewParent:(Stark*)newParent {
    [self moveNoRevealStarks:starkOrStarks
                 toNewParent:newParent] ;
    
    [newParent sortShallowly] ;
}

+ (void)mergeFolders:(NSArray*)folders
          intoFolder:(Stark*)survivorFolder {
    for (Stark* folder in folders) {
        [self parentingAction:BkmxParentingMove
                        items:[folder childrenOrdered]
                    newParent:survivorFolder
                     newIndex:survivorFolder.children.count
                 revealDestin:NO] ;
    }
    
    [self parentingAction:BkmxParentingRemove
                    items:folders
                newParent:nil
                 newIndex:0
             revealDestin:NO] ;

    [survivorFolder sortShallowly] ;

    [[(BkmxDoc*)[survivorFolder owner] undoManager] setActionName:[NSString localize:@"mergeInto"]] ;
}

+ (void)copyNoRevealStarks:(NSArray*)starks
               toNewParent:(Stark*)newParent {
    [self parentingAction:BkmxParentingCopy
                    items:starks
                newParent:newParent
                 newIndex:newParent.children.count
             revealDestin:NO] ;
}

+ (void)setSortableBool:(BOOL)yn
                 sender:(id)sender {
    NSArray* starks = [StarkEditor starksFromSender:sender] ;
    if ([starks count] > 0) {
        BkmxDoc* bkmxDoc = [[starks objectAtIndex:0] owner] ;
        [[bkmxDoc starker] setValue:[NSNumber numberWithBool:yn]
                               forKey:constKeySortable
                             inStarks:starks] ;
    }
}

+ (void)addTags:(NSArray<Tag*>*)newTags
    toBookmarks:(NSArray*)bookmarks {
    for (Stark* item in bookmarks) {
        NSArray* oldTags = [item tags] ;
        NSArray* combinedTags ;
        if ([oldTags count] > 0) {
            combinedTags = [oldTags arrayByAddingObjectsFromArray:newTags] ;
        }
        else {
            combinedTags = newTags ;
        }
        
        [item setTags:combinedTags] ;
    }
    
}

+ (void)removeTags:(NSArray*)deletedTags
    fromBookmarks:(NSArray*)bookmarks {
    for (Stark* item in bookmarks) {
        NSArray* tags = [item tags] ;
        if (([tags count] > 0) && ([deletedTags count] > 0)) {
            NSMutableArray* newTags = [tags mutableCopy] ;
            for (NSString* deletedTag in deletedTags) {
                [newTags removeObject:deletedTag] ;
            }

            NSArray* newTagsCopy = [newTags copy] ;
            [newTags release] ;
            [item setTags:newTagsCopy] ;
            [newTagsCopy release] ;
        }        
    }
}

+ (void)copyCut:(BOOL)cut
         sender:(id)sender {
    NSArray* starks = [self starksFromSender:sender] ;

    NSArray* starksCopiedToPasteboardMOC = [SSYMOCManager deepCopiesForPasteboardObjects:starks
                                                             doNotEnterRelationshipNames:[NSSet setWithObjects:
                                                                                          constKeyParent,
                                                                                          constKeyDupe,
                                                                                          constKeyTags,
                                                                                          @"shigForLanding",
                                                                                          nil]];  // See Note WhyDupe

    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray* providedDragTypes = [NSArray arrayWithObjects:constBkmxPboardTypeStark, NSPasteboardTypeString, nil] ;
    [pasteboard declareTypes:providedDragTypes
                       owner:nil];
    // Above, we can say owner:nil since we are going to provide data immediately
    
    // For pasting to other apps, copy tab/return name/urls of starks
    NSString* urls = [starks tabReturnLeavesSummary] ;
    if (urls) {
        [pasteboard setString:urls forType:NSPasteboardTypeString];
    }

    NSMutableArray* intraAppCopyArray = [(BkmxAppDel*)[NSApp delegate] intraAppCopyArray];
    [intraAppCopyArray removeAllObjects] ;
    [intraAppCopyArray addObjectsFromArray:starksCopiedToPasteboardMOC] ;
    
    if (cut) {
        [self parentingAction:BkmxParentingRemove
                        items:starks
                    newParent:nil
                     newIndex:0
                 revealDestin:YES] ;
    }
}

+ (void)setSortDirectiveTopStark:(Stark*)stark {
    [stark setSortDirectiveValue:BkmxSortDirectiveTop] ;
}

+ (void)setSortDirectiveTopStarks:(NSArray*)starks {
    if ([starks count] > 0) {
        for (Stark* stark in starks) {
            [self setSortDirectiveTopStark:stark] ;
        }
    }
}

+ (void)setSortDirectiveBottomStark:(Stark*)stark {
    [stark setSortDirectiveValue:BkmxSortDirectiveBottom] ;
}

+ (void)setSortDirectiveBottomStarks:(NSArray*)starks {
    if ([starks count] > 0) {
        for (Stark* stark in starks) {
            [self setSortDirectiveBottomStark:stark] ;
        }
    }
}

+ (void)setSortDirectiveNormalStark:(Stark*)stark {
    [stark setSortDirectiveValue:BkmxSortDirectiveNormal] ;
}

+ (void)setSortDirectiveNormalStarks:(NSArray*)starks {
    if ([starks count] > 0) {
        for (Stark* stark in starks) {
            [self setSortDirectiveNormalStark:stark] ;
        }
    }
}

+ (void)visitItems:(NSArray*)items
    urlTemporality:(BkmxUrlTemporality)urlTemporality {
    // Build array of bookmarks included in the selectedObjects (which may include folders)
    // Instead of this, could save bookmarks as an ivar when building menu.
    NSMutableArray* bookmarks = [[NSMutableArray alloc] init] ;
    for (Stark* stark in items) {
        [stark classifyBySharypeDeeply:NO
                              hartainers:nil
                           softFolders:nil
                                leaves:bookmarks
                               notches:nil] ;
    }
    
    // Count them
    NSInteger count = [bookmarks count] ;
    
    if (count > 0) {
        // If too many ask user if really want to do this
        NSInteger alertReturn = NSAlertFirstButtonReturn ;
        if (count > [[NSUserDefaults standardUserDefaults] integerForKey:constKeyVisitWarningThreshold]) {
            SSYAlert* alert = [SSYAlert alert] ;
            [alert setTitleText:[NSString localize:@"areYouSure"]] ;
            [alert setSmallText:[NSString stringWithFormat:[NSString localize:@"visitNWebPages"], (long)count]] ;
            [alert setButton1Title:[NSString localize:@"yes"]] ;
            [alert setButton2Title:[NSString localize:@"cancel"]] ;
            [alert setCheckboxTitle:@"Open Preferences so I can adjust this warning."] ;
            [alert runModalDialog] ;
            
            alertReturn = [alert alertReturn] ;

            if ([alert checkboxState] == NSControlStateValueOn) {
                [(BkmxAppDel*)[NSApp delegate] preferences:self] ;
                PrefsWinCon* prefsWinCon = [(BkmxAppDel*)[NSApp delegate] prefsWinCon] ;
                [prefsWinCon revealTabViewIdentifier1:constIdentifierTabViewGeneral
                                          identifier2:nil] ;
            }
        }
        
        // If OK, do it
        if (alertReturn == NSAlertFirstButtonReturn) {
            NSString* browserBundleIdentifier = nil ;
            [SSWebBrowsing getActiveBrowserExtoreClass:NULL
                                            exformat_p:NULL
                                    bundleIdentifier_p:&browserBundleIdentifier
                                                path_p:NULL] ;
            for (Stark* bookmark in bookmarks) {
                NSString* url = nil ;
                switch (urlTemporality) {
                    case BkmxUrlTemporalityCurrent:
                        url = [bookmark url] ;
                        break ;
                    case BkmxUrlTemporalitySuggested:
                        url = [bookmark verifierSuggestedUrl] ;
                        break ;
                    case BkmxUrlTemporalityPrior:
                        url = [bookmark verifierPriorUrl] ;
                }
                
                if (url) {
                    if (!browserBundleIdentifier) {            
                        // Active app is not a web browser.  Use value from either Stark or document default
                        
                        // Transform 'visitor' to the bundle identifier of the browser
                        // to use, as indicated by stark and BkmxDoc.shig settings
                        browserBundleIdentifier = [bookmark visitor] ;
                        if ([browserBundleIdentifier isEqualToString:constKeyVisitorDefaultDocument]) {
                            browserBundleIdentifier = [[(BkmxDoc*)[bookmark owner] shig] visitor] ;
                        }
                        
                        if ([browserBundleIdentifier isEqualToString:constKeyVisitorDefaultBrowser]) {
                            browserBundleIdentifier = nil ; // Tells SSWebBrowsing to use default browser
                        }
                    }
                    
                    NSUInteger cemf = [[[NSApplication sharedApplication] currentEvent] modifierFlags] ;
                    BOOL activateBrowser = ((cemf & NSEventModifierFlagOption) != 0) == 0 ;
                    
                    [SSWebBrowsing browseToURLString:url
                             browserBundleIdentifier:browserBundleIdentifier
                                            activate:activateBrowser] ;
                    // See documentation of the above method to learn why this:
                    if (count > 1) {
                        usleep(400000) ;
                    }
                    
                    [bookmark setLastVisitedDate:[NSDate date]] ;
                    [bookmark setVisitCount:[NSNumber numberWithInteger:([[bookmark visitCount] integerValue] + 1)]] ;
                }
            }
        }
    }
    
    [bookmarks release] ;
}

/*
 I mistakenly removed this method in BookMacster 1.14.4, then restored it in
 BookMacster 1.14.8.  It is invoked when clicking a *bookmark* in one of the
 hierarchical menus.
 
 Starting with BookMacster 1.16, it is used by MiniSearchWinCon.
 */
+ (void)visitStark:(Stark*)stark {
    [self visitItems:[NSArray arrayWithObject:stark]
      urlTemporality:BkmxUrlTemporalityCurrent] ;
}

+ (void)swapPriorAndCurrentUrls:(id)sender {
    NSArray* starks = [self starksFromSender:sender] ;
    SSYDooDooUndoManager *undoer = (SSYDooDooUndoManager*)[[[starks lastObject] owner] undoManager] ;
    for (Stark* stark in starks) {
        NSString* priorToCurrent = [stark verifierPriorUrl] ;
        NSString* currentToPrior = [stark url] ;
        if (priorToCurrent && currentToPrior) {
            [stark setVerifierPriorUrl:currentToPrior] ;
            [stark setUrl:priorToCurrent] ;
        }
    }
    
    NSString* actionName = [NSString stringWithFormat:
                            @"%@ (%@)",
                            [[BkmxBasis sharedBasis] labelSwapPriorAndCurrentUrl],
                            [starks readableName]] ;
    [undoer setActionName:actionName] ;
}    

+ (void)swapSuggestedAndCurrentUrls:(id)sender {
    NSArray* starks = [self starksFromSender:sender] ;
    SSYDooDooUndoManager *undoer = (SSYDooDooUndoManager*)[[[starks lastObject] owner] undoManager] ;
    for (Stark* stark in starks) {
        NSString* suggestedToCurrent = [stark verifierSuggestedUrl] ;
        NSString* currentToSuggested = [stark url] ;
        if (suggestedToCurrent && currentToSuggested) {
            [stark setVerifierSuggestedUrl:currentToSuggested] ;
            [stark setUrl:suggestedToCurrent] ;
        }
    }
    
    NSString* actionName = [NSString stringWithFormat:
                            @"%@ (%@)",
                            [[BkmxBasis sharedBasis] labelSwapSuggestedAndCurrentUrl],
                            [starks readableName]] ;
    [undoer setActionName:actionName] ;
}    


@end

/* Note WhyDupe
 
 #0    0x00007fff6ce8158f in objc_exception_throw ()
 #1    0x00007fff33ccc63e in _CFThrowFormattedException ()
 #2    0x00007fff33cd3403 in -[NSSet initWithSet:copyItems:].cold.1 ()
 #3    0x00007fff33bad320 in -[NSSet initWithSet:copyItems:] ()
 #4    0x00007fff33bad0ec in -[__NSPlaceholderSet initWithSet:copyItems:] ()
 #5    0x00007fff33bd2fa2 in +[NSSet setWithSet:] ()
 #6    0x00000001001f62ad in -[Dupetainer setDupes:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/Dupetainer.m:84
 #7    0x00007fff33660336 in _PF_Handler_Public_SetProperty ()
 #8    0x00000001003f7681 in __86-[NSManagedObject(SSYCopying) deepCopyInManagedObjectContext:doNotEnterRelationships:]_block_invoke_2.67 at /Users/jk/Documents/Programming/CategoriesObjC/NSManagedObject+SSYCopying.m:99
 #9    0x00007fff33664789 in developerSubmittedBlockToNSManagedObjectContextPerform ()
 #10    0x00007fff3366462f in -[NSManagedObjectContext performBlockAndWait:] ()
 #11    0x00000001003f6a4f in -[NSManagedObject(SSYCopying) deepCopyInManagedObjectContext:doNotEnterRelationships:] at /Users/jk/Documents/Programming/CategoriesObjC/NSManagedObject+SSYCopying.m:95
 #12    0x00000001003f69a1 in -[NSManagedObject(SSYCopying) deepCopyInManagedObjectContext:doNotEnterRelationships:] at /Users/jk/Documents/Programming/CategoriesObjC/NSManagedObject+SSYCopying.m:93
 #13    0x00000001003f72b3 in __86-[NSManagedObject(SSYCopying) deepCopyInManagedObjectContext:doNotEnterRelationships:]_block_invoke_2.56 at /Users/jk/Documents/Programming/CategoriesObjC/NSManagedObject+SSYCopying.m:74
 #14    0x00007fff33664789 in developerSubmittedBlockToNSManagedObjectContextPerform ()
 #15    0x00007fff3366462f in -[NSManagedObjectContext performBlockAndWait:] ()
 #16    0x00000001003f67e5 in -[NSManagedObject(SSYCopying) deepCopyInManagedObjectContext:doNotEnterRelationships:] at /Users/jk/Documents/Programming/CategoriesObjC/NSManagedObject+SSYCopying.m:72
 #17    0x00000001003f72b3 in __86-[NSManagedObject(SSYCopying) deepCopyInManagedObjectContext:doNotEnterRelationships:]_block_invoke_2.56 at /Users/jk/Documents/Programming/CategoriesObjC/NSManagedObject+SSYCopying.m:74
 #18    0x00007fff33664789 in developerSubmittedBlockToNSManagedObjectContextPerform ()
 #19    0x00007fff3366462f in -[NSManagedObjectContext performBlockAndWait:] ()
 #20    0x00000001003f67e5 in -[NSManagedObject(SSYCopying) deepCopyInManagedObjectContext:doNotEnterRelationships:] at /Users/jk/Documents/Programming/CategoriesObjC/NSManagedObject+SSYCopying.m:72
 #21    0x00000001003f7929 in -[NSManagedObject(SSYCopying) deepCopyInManagedObjectContext:doNotEnterRelationshipNames:] at /Users/jk/Documents/Programming/CategoriesObjC/NSManagedObject+SSYCopying.m:124
 #22    0x00000001002a7da9 in +[SSYMOCManager deepCopiesForPasteboardObjects:doNotEnterRelationshipNames:] at /Users/jk/Documents/Programming/ClassesObjC/SSYMOCManager.m:646
 #23    0x000000010032304d in +[StarkEditor copyCut:sender:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/StarkEditor.m:784
 #24    0x0000000100324a8b in -[BkmxDoc(Actions) copy:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxDoc+Actions.m:40

 */
