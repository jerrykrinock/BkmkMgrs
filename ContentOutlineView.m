#define RE_ENABLE_SPRING_LOADING_DELAY 0.25

#import <Bkmxwork/Bkmxwork-Swift.h>

#import "ContentOutlineView.h"
#import "NSString+VarArgs.h"
#import "Stark+Attributability.h"
#import "Starker.h"
#import "BkmxDoc+Actions.h"
#import "SSMoveableToolTip.h"
#import "BkmxBasis+Strings.h"
#import "StarkTableColumn.h"
#import "NSMenu+StarkContextual.h"
#import "StarkEditor.h"
#import "NSString+LocalizeSSY.h"
#import "NSTableView+Autosave.h"
#import "NSTableView+MoreSizing.h"
#import "NSNumber+Sharype.h"
#import "NSString+SSYExtraUtils.h"
#import "Starki.h"
#import "CntntViewController.h"
#import "BkmxDocWinCon+Autosaving.h"
#import "BkmxAppDel.h"
#import "NS(Attributed)String+Geometrics.h"
#import "ContentDataSource.h"
#import "SSYPopUpTableHEaderCell.h"


NSString* const constKeySelectedStarks = @"selectedStarks" ;
NSString* const constKeyVisibleObjects = @"visibleObjects" ;


@interface ContentOutlineView ()

@property BOOL springLoadingEnabled ;
@property NSInteger clickedRowIndex ;
@property NSTimeInterval refTimeOfLastClick ;

@end

@implementation ContentOutlineView

- (ContentDataSource*)dataSource {
    return (ContentDataSource*)[super dataSource] ;
}

@synthesize springLoadingEnabled ;
@synthesize clickedRowIndex ;
@synthesize refTimeOfLastClick ;

- (NSArray*)selectedStarks {
    return [self selectedObjects] ;
}

- (NSColor*)colorSort {
    NSColor* colorSort ;
    @synchronized(self) {
        colorSort = [[m_colorSort copy] autorelease] ;
    }
    return colorSort ;
}

- (void)setColorSort:(NSColor*)colorSort {
    @synchronized(self) {
        if (colorSort != m_colorSort) {
            [m_colorSort release];
            m_colorSort = [colorSort copy] ;
            
            self.needsDisplay = YES;
        }
    }
}

@synthesize colorUnsort = m_colorUnsort ;

- (NSColor*)colorUnsort {
    NSColor* colorUnsort ;
    @synchronized(self) {
        colorUnsort = [[m_colorUnsort copy] autorelease] ;
    }
    return colorUnsort ;
}

- (void)setColorUnsort:(NSColor*)colorUnsort {
    @synchronized(self) {
        if (colorUnsort != m_colorUnsort) {
            [m_colorUnsort release];
            m_colorUnsort = [colorUnsort copy] ;
            
            self.needsDisplay = YES;
        }
    }
}

- (void)reEnableSpringLoading:(NSTimer*)timer {
    // Don't use the 'timer' parameter because I also invoke
    // this method from outside this class, with timer=nil.
    
    // Get rid of the timer
    [_reEnableSpringLoadingTimer invalidate] ;
    [_reEnableSpringLoadingTimer release] ;
    _reEnableSpringLoadingTimer = nil ;
    
    // Actual work
    [self setSpringLoadingEnabled:YES] ;
    
}

- (Starki*)selectedStarki {
    Starki* starki = [Starki starkiWithStarks:[self selectedStarks]] ;
    return starki ;
}

+ (NSSet*)keyPathsForValuesAffectingSelectedStarki {
    return [NSSet setWithObjects:
            @"selectedObjects",
            nil] ;
}

- (BOOL)canTagSelection {
    // Selection must contain at least one stark
    // and all starks must be bookmarks
    BOOL answer = NO ;
    for (Stark* stark in [self selectedStarks]) {
        answer = YES ;
        if ([stark sharypeValue] != SharypeBookmark) {
            answer = NO ;
            break ;
        }
    }
    
    return answer ;
}
+ (NSSet*)keyPathsForValuesAffectingCanTagSelection {
    return [NSSet setWithObjects:
            @"selectedStarks",
            nil] ;
}



- (void)resetReEnableSpringLoadingTimer {
    NSDate* nextFireDate = [NSDate dateWithTimeIntervalSinceNow:RE_ENABLE_SPRING_LOADING_DELAY] ;
    
    if (_reEnableSpringLoadingTimer) {
        [_reEnableSpringLoadingTimer setFireDate:nextFireDate] ;
    }
    else {
        NSTimer* timer = [[NSTimer alloc] initWithFireDate:nextFireDate
                                                  interval:0.0 // ignored since repeats=NO
                                                    target:self
                                                  selector:@selector(reEnableSpringLoading:)
                                                  userInfo:nil
                                                   repeats:NO] ;
        
        NSRunLoop* runLoop = [NSRunLoop currentRunLoop] ;
        [runLoop addTimer:timer
                  forMode:NSDefaultRunLoopMode] ;
        _reEnableSpringLoadingTimer = timer ;
    }
}

- (CntntViewController*)delegate {
    return (CntntViewController*)[super delegate] ;
}

// Needed for typecast
- (void)setDelegate:(CntntViewController*)delegate {
    [super setDelegate:delegate] ;
}

- (IBAction)paste:(id)sender {
    Stark* targetParent = [self starkAtRow:[self selectedRow]] ;
    if (!targetParent) {
        targetParent = self.document.starker.root ;
    }
    NSInteger targetIndex ;
    
    if (![targetParent canHaveChildren]) {
        targetIndex = [targetParent indexValue] + 1 ;
    } else {
        targetIndex = 0 ;
    }
    
    NSArray* items = nil ;
    Stark* newBookmark = nil ;
    BOOL didPaste = NO ;
    BkmxParentingAction action = BkmxParentingActionNone;
    if (targetParent) {
        StarkLocation* target = [[StarkLocation alloc] initWithParent:targetParent
                                                                index:targetIndex] ;
        
        NSPasteboard *pboard = [NSPasteboard generalPasteboard ];
        if([pboard availableTypeFromArray:[NSArray arrayWithObject:constBkmxPboardTypeStark]]) {
            items = [(BkmxAppDel*)[NSApp delegate] intraAppCopyArray] ;
            // because, if this was from a 'cut', we've already deleted it when cutting …
            action = BkmxParentingCopy ;
        }
        else if ([pboard availableTypeFromArray:[NSArray arrayWithObject:NSPasteboardTypeString]]) {
            NSString* string = [pboard stringForType:NSPasteboardTypeString] ;
            items = [[self dataSource] freshStarksFromString:string];
            action = BkmxParentingAdd ;
        }
        
        if (items) {
            if ([target canInsertItems:items
                                   fix:StarkLocationFixParentAndIndex
                           outlineView:nil] > StarkCanParentNopeDemarcation) {
                [StarkEditor parentingAction:action
                                       items:items
                                   newParent:[target parent]
                                    newIndex:[target index]
                                revealDestin:YES] ;
                didPaste = YES ;
            }
        }
        
        [target release] ;
    }
    
    if (!didPaste) {
        NSBeep() ;
        if (newBookmark) {
            // Delete the stark that had been created
            [[[self document] undoManager] undo] ;
        }
    }
}

- (NSMenu*)menuForTableColumnIndex:(NSInteger)iCol
                          rowIndex:(NSInteger)iRow {
    if ([[self selectedStarks] indexOfObjectIdenticalTo:[self starkAtRow:iRow]] == NSNotFound) {
        // Clicked item is not in selection, so we change
        // the selection to be only the clicked item
        // (because this is how The Finder does it).
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:iRow] byExtendingSelection:NO] ;
    }
    
    return [NSMenu menuWithAllActionsForSelectedStarks:[(BkmxDocWinCon*)[(CntntViewController*)[self delegate] windowController] selectedStarks]] ;
}

- (void)bindColorForKey:(NSString*)key {
    NSString* transformerName = @"SSYSecureColorTransformer";
    NSString* keyPath = [NSString stringWithFormat:@"values.%@", key] ;
    [self bind:key
      toObject:[NSUserDefaultsController sharedUserDefaultsController]
   withKeyPath:keyPath
       options:[NSDictionary dictionaryWithObject:transformerName
                                           forKey:NSValueTransformerNameBindingOption]] ;
}

- (void)viewDidMoveToWindow {
    BkmxDoc* document = [[[self window] windowController] document] ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changedChildrenNote:)
                                                 name:SSYManagedTreeChildrenChangedNotification
                                               object:document] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adviseChangedStarkNote:)
                                                 name:BkmxDocNotificationStarkTouched
                                               object:document] ;
}

- (void)awakeFromNib {
    // Per Discussion in documentation of -[NSObject respondsToSelector:],
    // the superclass name in the following must be hard-coded.
    if ([BkmxOutlineView instancesRespondToSelector:@selector(awakeFromNib)]) {
        [super awakeFromNib] ;
    }
    
    /* This is stil used in the new drag/drop regime. */
    NSArray* acceptableDragTypes = [NSArray arrayWithObjects:
                                    constBkmxPboardTypeDraggableStark,
                                    constBkmxPboardTypeSafari,
                                    constBkmxPboardTypeSafariLegacy,
                                    NSPasteboardTypeFileURL,
                                    NSPasteboardTypeURL,
                                    NSPasteboardTypeString,
                                    NSPasteboardTypeTabularText,
                                    nil] ;
    [self registerForDraggedTypes:acceptableDragTypes] ;

    [self setVerticalMotionCanBeginDrag:YES] ;
    [self setAllowsMultipleSelection:YES] ;
    
    NSDragOperation operations =  NSDragOperationCopy + NSDragOperationLink + NSDragOperationMove + NSDragOperationDelete;
    [self setDraggingSourceOperationMask:(operations)
                                forLocal:YES];
     [self setDraggingSourceOperationMask:(operations)
                                 forLocal:NO];
      
    [self setSpringLoadingEnabled:YES] ;
    
    // Set the doubleclick action.
    [self setTarget:(BkmxAppDel*)[NSApp delegate]] ;
    // Would be nice to set target to nil --> first responder
    // but that might disable the doubleclick action feature.
    // This doubleclick is very difficult for user anyhow.  You must either
    // set the user-defined column to an uneditable attribute and click on
    // that column, or else click on a column-separator vertical line.
    [self setDoubleAction:@selector(visitAllOfRepresentative:)] ;
    
    [self bindColorForKey:constKeyColorSort] ;
    [self bindColorForKey:constKeyColorUnsort] ;
}

- (id)representedObject {
    return [[self selectedStarks] firstObject] ;
}

- (void)restoreViewStatePerInfo:(NSDictionary*)info {
}

- (void)reloadDataReally {
    BOOL needsDoOverFromRoot = NO ;
    if ([m_reloadStarks count] == 0) {
        // Full reload
        // Remember view state
        CGFloat extraPoints ;
        NSArray* visibleProxies = [self visibleItemsAndExtraPoints_p:&extraPoints] ;
        NSArray* visibleStarks = [visibleProxies valueForKey:@"stark"] ;
        // Warning: visibleStarks may include NSNull objects because
        // that's what -valueForKey: does for nil members
        NSArray* selectedStarks = [[[self window] windowController] selectedStarks] ;
        
        [super reloadData] ;
        
        // Must do this before converting visible starks back to visible proxies
        // or the visibleProxiesAfterReload you get will be all mixed up.
        [self realizeIsExpandedValuesFromModelFromRoot:nil] ;
        
        NSMutableArray* visibleProxiesAfterReload = [[NSMutableArray alloc] init] ;
        for (Stark* visibleStark in visibleStarks) {
            if ([visibleStark isKindOfClass:[Stark class]]) {
                ContentProxy* proxy = [[self dataSource] proxyForStark:visibleStark] ;
                if (proxy) {
                    [visibleProxiesAfterReload addObject:proxy] ;
                }
            }
        }
        if (m_hasLoadedOnce) {
            [self scrollToMakeVisibleItems:visibleProxiesAfterReload
                           plusExtraPoints:extraPoints] ;
            [self selectObjects:selectedStarks
           byExtendingSelection:NO] ;
        }
        [visibleProxiesAfterReload release] ;
        m_hasLoadedOnce = YES ;
    }
    else {
        // Reload only m_reloadStarks
        for (Stark* stark in m_reloadStarks) {
            ContentProxy* proxy = [[self dataSource] proxyForStark:stark] ;
            NSArray* visibleStarks = nil ;
            /* The following test is because on 2016-10-26 I found crash reports
             in user Roscoe B's Trouble Zip indicating that proxy was a
             SSYDisjoiningPlaceholder which did not respond to 
             -ensureDeeplyAndRegardlessly.  Actually, an
             SSYDisjoiningPlaceholder is a straight subclass of NSObject, so it
             won't respond to -setStark: either. */
            if ([proxy respondsToSelector:@selector(setStark:)]) {
                [proxy ensureDeeplyAndRegardlessly] ;
                BOOL isExpanded = [self isItemExpanded:proxy] ;
                CGFloat extraPoints ;
                NSArray* selectedStarks = nil ;
                if (isExpanded) {
                    // Remember view state
                    NSArray* visibleProxiesBeforeReload = [self visibleItemsAndExtraPoints_p:&extraPoints] ;
                    visibleStarks = [visibleProxiesBeforeReload valueForKey:@"stark"] ;
                    // Warning: visibleStarks may include NSNull objects because
                    // that's what -valueForKey: does for nil members
                    selectedStarks = [[[self window] windowController] selectedStarks] ;
                }
                [super reloadItem:proxy
                   reloadChildren:isExpanded] ;
                if (isExpanded) {
                    // I think you should do this before converting visible
                    // starks back to visible proxies or the
                    // visibleProxiesAfterReload you get will be all mixed up.
                    [self realizeIsExpandedValuesFromModelFromRoot:stark] ;
                    
                    NSMutableArray* visibleProxiesAfterReload = [[NSMutableArray alloc] init] ;
                    for (Stark* visibleStark in visibleStarks) {
                        if ([visibleStark isKindOfClass:[Stark class]]) {
                            ContentProxy* proxy = [[self dataSource] proxyForStark:visibleStark] ;
                            if (proxy) {
                                [visibleProxiesAfterReload addObject:proxy] ;
                            }
                        }
                    }
                    [self scrollToMakeVisibleItems:visibleProxiesAfterReload
                                   plusExtraPoints:extraPoints] ;
                    [visibleProxiesAfterReload release] ;
                    [self selectObjects:selectedStarks
                   byExtendingSelection:NO] ;
                }
            }
            else {
                needsDoOverFromRoot = YES ;
                break ;
            }
        }
    }
    
    m_reloadStaged = BkmxReloadStagedNone ;
    [m_reloadStarks removeAllObjects] ;
    
    if (needsDoOverFromRoot) {
        // This will do a full reload because we've emptied m_reloadStarks
        [self reloadDataReally] ;
        // Don't worry, the above cannot be an infinite loop because
        // m_reloadStarks is now empty so needsDoOverFromRoot will be NO during
        // the recursion
    }
}

- (void)reloadData {
    if (m_reloadStaged == BkmxReloadStagedNone) {
        [self performSelector:@selector(reloadDataReally)
                   withObject:nil
                   afterDelay:CONTENT_OUTLINE_VIEW_RELOAD_DELAY_0] ;
    }
    
    m_reloadStaged = BkmxReloadStagedFull ;
    // m_reloadStarks are not needed for a full reload.
    [m_reloadStarks removeAllObjects] ;
}

// CLEAR-STAGING //- (void)clearReloadStaging {
// CLEAR-STAGING //    m_reloadStaged = BkmxReloadStagedNone ;
// CLEAR-STAGING //}

- (void)reloadStarks:(NSSet*)starks {
    if (m_reloadStaged == BkmxReloadStagedNone) {
        [self performSelector:@selector(reloadDataReally)
                   withObject:nil
                   afterDelay:CONTENT_OUTLINE_VIEW_RELOAD_DELAY_0] ;
    }

    if (!starks) {
        // Caller has specified a full reload
        m_reloadStaged = BkmxReloadStagedFull ;
        [m_reloadStarks removeAllObjects] ;
    }
    else {
        // Caller has specified a partial reload
        m_reloadStaged = BkmxReloadStagedPartial ;
        [m_reloadStarks unionSet:starks] ;
    }
}

- (void)clearProxiesAndReload {
    [[self dataSource] clearProxies] ;
    /* I think it is now important to reload data immediately, really, because
     the outline view still has references to proxies it received back from
     -outlineView:child:ofItem:, which have just been deallocced.  Legally,
     at any time, it could send other messages such as
     -outlineView:objectValueForTableColumn:byItem:, with byItem: being the
     deallocced proxy.  When super reloads, however, the outline view will
     forget the old objects (I think).  Anyhow, it will definitely start with a
     clean slate, rebuilding from the root, by sending
     -outlineView:child:ofItem: with item = nil. */
    [super reloadData] ;
}

- (void)adviseChangedStarkNote:(NSNotification*)note {
    Stark* stark = [[note userInfo] objectForKey:constKeyStark] ;
    NSArray* ancestors = [stark lineageSharypeMaskOut:SharypeUndefined
                                          includeSelf:YES] ;
    BOOL thisStarkIsAlreadyStagedForReload = NO ;
    for (Stark* reloadRoot in m_reloadStarks) {
        if ([ancestors indexOfObjectIdenticalTo:reloadRoot] != NSNotFound) {
            thisStarkIsAlreadyStagedForReload = YES ;
            break ;
        }
    }
    
    if (!thisStarkIsAlreadyStagedForReload) {
        [m_reloadStarks addObject:stark] ;
    }
}

#define NUMBER_OF_COLUMNS 3

- (void)restoreFromAutosaveState:(NSDictionary*)state {
    if (state) {
        [super restoreFromAutosaveState:state] ;
    }
    else {
        // New document
        NSAssert1(NUMBER_OF_COLUMNS == [self numberOfColumns], @"nCols=%ld", (long)[self numberOfColumns]) ;
        
        CGFloat defaultWidths[NUMBER_OF_COLUMNS] ;
        NSInteger i = 0 ;
        for (StarkTableColumn* tableColumn in [self tableColumns]) {
            defaultWidths[i] = [tableColumn defaultWidth] ;
            i++ ;
        }
        
        [self proportionWidths:defaultWidths] ;
    }
    
    // Set default attributes for the user-defined columns only, if they were not
    // set by -restoreFromAutosaveState: (which is expected for new documents
    if (![(StarkTableColumn*)[[self tableColumns] objectAtIndex:1] userDefinedAttribute]) {
        [(StarkTableColumn*)[[self tableColumns] objectAtIndex:1] setUserDefinedAttribute:constKeyUrlOrStats] ;
    }
    if (![(StarkTableColumn*)[[self tableColumns] objectAtIndex:2] userDefinedAttribute]) {
        [(StarkTableColumn*)[[self tableColumns] objectAtIndex:2] setUserDefinedAttribute:constKeyClients] ;
    }
}

/*
 The following is a workaround for the fact that an NSTokenFieldCell in an NSTableView
 is not editable.  What I try and do is to open tags for editing in the littleCloud
 if it appears that someone is click on on the tags in one of the user-defined columns.
 
 But, wait, then there's another thing that needs to be worked around.
 I override the following because -[NSOutlineView outlineView:didClickTableColumn:],
 which would be preferred, doesn't seem to work for me. (Mac OS 10.5.7).  I've read in
 cocoa-dev list archives that this may be a bug, and that it works if column reordering
 is enabled.  But I don't want column reordering and have not tried that.
 */
- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event] ;
    
    NSPoint eventPoint = [event locationInWindow];
    NSPoint point = [self convertPoint:eventPoint
                              fromView:nil];
    NSInteger columnIndex = [self columnAtPoint:point] ;
    NSInteger rowIndex = [self rowAtPoint:point] ;
    // At one time, due to some other bug, columnIndex was -1.
    // So I decided to add some defensive programming here:
    if (
        (columnIndex < 0)
        ||
        (columnIndex > [[self tableColumns] count] -1)
        ) {
        NSLog(@"Internal Error 521-0184 cI=%ld", (long)columnIndex) ;
        // This happened again in BookMacster 1.16, 2013-06-22, but
        // I don't know what caused it.
        return ;
    }
    NSTableColumn* column = [[self tableColumns] objectAtIndex:columnIndex] ;
    BOOL isSecondClick = NO ;
    // The following if() is defensive, in case I ever
    // add a column to ContentOutlineView which is not a
    // StarkTableColumn
    NSTimeInterval refTimeNow = [NSDate timeIntervalSinceReferenceDate] ;
    if ([column isKindOfClass:[StarkTableColumn class]]) {
        if ([[(StarkTableColumn*)column userDefinedAttribute] isEqualToString:constKeyTags]) {
            if (rowIndex == [self clickedRowIndex]) {
                if (refTimeNow - [self refTimeOfLastClick] < 2.0) {
                    isSecondClick = YES ;
                }
            }
        }
    }
    
    if (isSecondClick) {
        if ([self canTagSelection]) {
            NSWindow* window = [self window];
            BkmxDocWinCon* windowController = [window windowController];
            
            [[windowController cntntViewController] showTagsPopover:self];
        }
    }
    else {
        [self setClickedRowIndex:rowIndex] ;
        [self setRefTimeOfLastClick:refTimeNow] ;
    }
}

- (id)starkAtRow:(NSInteger)row {
    NSObject* whatever = [self itemAtRow:row] ;
    Stark* stark ;
    if ([whatever respondsToSelector:@selector(stark)]) {
        stark = [(ContentProxy*)whatever stark] ;
    }
    else if ([whatever isKindOfClass:[Stark class]]) {
        NSLog (@"Warning 285-0082 %@ in %@", whatever, self) ;
        stark = (Stark*)whatever ;
    }
    else {
        stark = nil ;
    }
    
    return stark ;
}

- (id)modelObjectAtRow:(NSInteger)row {
    return [self starkAtRow:row] ;
}

- (void)expandAncestorsOfStark:(Stark*) stark {
    // Build array of ancestors of the last stark
    // We have to do this in order to accomplish our goal of expanding only
    // the stark's ancestors, not its siblings or cousins.  We need to use
    // expandChildren:NO, which means we need to start from the top.  I
    // tried this other ways but it did not work.
    Stark* ancestor = stark ;
    Stark* parent ;
    NSMutableArray* ancestors = [[NSMutableArray alloc] init] ;
    while ((parent = [ancestor parent]) != nil) {
        [ancestors insertObject:parent atIndex:0] ;
        ancestor = parent ;
    }
    // So ancestors now has the most great...great ancestor at index 0.
    
    // Expand ancestors without expanding siblings or cousins, starting at the top
    for (ancestor in ancestors) {
        if ([ancestor canHaveChildren]) {
            ContentProxy* ancestorProxy = [(ContentDataSource*)[self dataSource] proxyForStark:ancestor] ;
            if (![self isItemExpanded:ancestorProxy]) {
                [self expandItem:ancestorProxy] ;
            }
        }
    }
    [ancestors release] ;
}

- (void)showStarks:(NSArray*)starks
        selectThem:(BOOL)selectThem
    expandAsNeeded:(BOOL)expandAsNeeded {
    BkmxDoc* document = [[[self window] windowController] document] ;
    
    // Eliminate items not in this document/outline/window
    NSMutableArray* myStarks = [[NSMutableArray alloc] init] ;
    NSManagedObjectContext* myMOC = [[document starker] managedObjectContext] ;
    for (Stark* stark in starks) {
        if ([stark managedObjectContext] == myMOC) {
            [myStarks addObject:stark] ;
        }
    }
    
    if ([myStarks count] < 1) {
        goto end ;
    }
    
    // The following takes a long time, way longer on Leopard Intel than on Tiger PPC
    // Since Activity Monitor's "Sample Process" is broken in the version I have
    // maybe I can revisit this another day
    
    // Iterate through array, expanding ancestors (if invoker said to and if displaying hierarchy)
    // to show all myItems
    NSMutableIndexSet* rowsToShow = [[NSMutableIndexSet alloc] init] ;
    BOOL allSubjectItemsVisible = YES ; // Will be used to avoid unnecessary scrolling
    
    for (Stark* stark in myStarks) {
        // Thought this might help but it didn't NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
        
        // First, we make sure the item ^could^ be visible if it were scrolled to.
        // If not, we need to expand its ancestors.
        // For efficiency, we skip this step if outline is in flat view.
        if ([[[self window] windowController] outlineMode] && expandAsNeeded) {
            ContentProxy* proxy = [[self dataSource] proxyForStark:stark] ;
            NSInteger iRow = -1 ;
            if (proxy) {
                iRow = [self rowForItem:proxy] ;
            }
            
            if (iRow == -1) {
                // Probably one or more of its ancestors are collapsed
                [self expandAncestorsOfStark:stark];
            }
            
            // Now we should get a better answer
            proxy = [[self dataSource] proxyForStark:stark] ;
            if (proxy) {
                iRow = [self rowForItem:proxy] ;
            }
            
            if (iRow != -1) {
                [rowsToShow addIndex:iRow] ;
            }

            if (allSubjectItemsVisible) {
                if (![self isVisibleItem:proxy]) {
                    allSubjectItemsVisible = NO ;
                }
            }
        }
        
        // Thought this might help but it didn't [pool release] ;
    }
    
    // I'm not sure if the following if() qualification is actually needed,
    // or just an unnecessary imaginary optimization.
    if (!allSubjectItemsVisible && ([rowsToShow count] > 0)) {
        // Scroll so that the first selected row to be shown is at the top of the scroll
        // Do this by first making the bottom row visible, which will scroll to the
        // the bottom, so that scrolling to the first row to show will be scrolling back
        // up, putting the first row to show at the top.
        [self scrollRowToVisible:([self numberOfRows] - 1)] ;
        [self scrollRowToVisible:[rowsToShow firstIndex]] ;
        // Above is o low-level method that scrolls Content, 2 of 2
    }
    
    [rowsToShow release] ;
    
    if (selectThem) {
        [self     selectStarks:myStarks
          byExtendingSelection:NO] ;
        
        // Now, we must explicitly set the selectedObjects instance variable
        // to these new items.  The reason is that I may be immediately
        // re-invoked by a call stack such as the following:
        
        // #0	0x0020c71e in -[ContentOutlineView showItems:selectThem:expandAsNeeded:] at ContentOutlineView.m:294
        // #1	0x0020ce5b in -[ContentOutlineView realizeIsExpandedValuesFromModelFromRoot:] at ContentOutlineView.m:399
        // #2	0x0020c1fc in -[ContentOutlineView reloadData] at ContentOutlineView.m:235
        //      ...
        // #3	0x00255024 in -[BkmxDocWinCon reloadContent] at BkmxDocWinCon.m:771
        // #4	0x00252f6a in -[BkmxDocWinCon updateWindowForStark:] at BkmxDocWinCon.m:290
        // #5	0x001fa444 in -[BkmxDoc updateViews:] at BkmxDoc.m:1208
        // ...
        // #9	0x929c735c in -[NSNotificationCenter postNotification:]
        
        // and this will occur before the my -outlineViewSelectionDidChange:
        // delegate method is invoked.  Therefore, usetSelectedObjectspon re-invocation,
        // realizeIsExpandedValuesFromModelFromRoot: will send me as 'items' my
        // current 'selectedObjects', which will be an empty array when
        // processing a copyTo, moveTo, nudgeUp or nudgeDown command,
        // and the objects I just selected will be immediately deselected.
        
        [self setSelectedObjects:myStarks] ;
    }
    
end:;
    [myStarks release] ;
}

- (void)showSelectAndExpandStarks:(NSArray*)starks {
    [self showStarks:starks
          selectThem:YES
      expandAsNeeded:YES] ;
}

- (void)changedChildrenNote:(NSNotification*)note {
    Stark* stark = [[note userInfo] objectForKey:SSYManagedTreeObjectKey] ;
    if ([stark owner] == [self document]) {
        [[self dataSource] noteChangedChildrenForStark:stark] ;
    }
}

- (void)expandStark:(Stark*)stark {
    ContentProxy* proxy = [(ContentDataSource*)[self dataSource] proxyForStark:stark] ;
    if (proxy) {
        if (![self isItemExpanded:proxy]) {
            [self expandItem:proxy] ;
        }
    }
}

- (void)collapseStark:(Stark*)stark {
    ContentProxy* proxy = [(ContentDataSource*)[self dataSource] proxyForStark:stark] ;
    if (proxy) {
        if ([self isItemExpanded:proxy]) {
            [self collapseItem:proxy] ;
        }
    }
}

- (void)   selectStarks:(NSArray*)starks
   byExtendingSelection:(BOOL)byExtendingSelection {
    NSMutableArray* proxies = [[NSMutableArray alloc] init] ;
    for (Stark* stark in starks) {
        if (![stark isDeleted]) {
            ContentProxy* proxy = [(ContentDataSource*)[self dataSource] proxyForStark:stark] ;
            if (proxy) {
                [proxies addObject:proxy] ;
            }
        }
    }
    [self     selectObjects:proxies
       byExtendingSelection:byExtendingSelection] ;
    [proxies release] ;
}

- (void)showStark:(Stark*)stark
         selectIt:(BOOL)selectIt {
    [self showStarks:[NSArray arrayWithObject:stark]
          selectThem:selectIt
      expandAsNeeded:YES] ;
}

- (void)realizeIsExpandedValuesFromModelFromRoot:(Stark*)root {
    // We use [[[self dataSource] document] bkmxDocWinCon] instead of [[self document] bkmxDocWinCon]
    // because the latter can be nil if the tab in which self resides is not dislayed
    // when the window is loaded from the nib.
    BkmxDoc* document = [self document] ;
    if([[document bkmxDocWinCon] outlineMode]) {
        if (!root) {
            root = [[document starker] root] ;
        }
        if (root) {
            // Since we are expanding values "from model", there
            // there should be nothing to undo here
            [[document managedObjectContext] processPendingChanges] ;
            [[document undoManager] disableUndoRegistration] ;
            
            // Expand the ones that isExpanded
            [root recursivelyPerformSelector:@selector(realizeIsExpandedIntoOutline:)
                                  withObject:self] ;
            
            [[document managedObjectContext] processPendingChanges] ;
            [[document undoManager] enableUndoRegistration] ;
            
            self.needsDisplay = YES;
        }
    }
}

- (void)updateNameColumnHeading {
    BkmxDocWinCon* bkmxDocWinCon = [[self window] windowController];
    
    /* During the first call when a document window is loading, bkmxDocWinCon
     will be nil.  So, [bkmxDocWinCon outlineMode] below will return NO, which
     may or may not be correct.  Furthermore, when that is NO, we call
     [[[document starker] root] addFolderStatistics] which can take a long
     time in documents with 23,000 items, and it may be all for nought if
     the view is in outline mode.  So, if bkmxDocWinCon is nil, we just fall
     right through to `return` without doing anything. */
    if (bkmxDocWinCon) {
        BkmxDoc* document = [[[self delegate] windowController] document] ;
        /* The following is more logical than the above
         >   BkmxDoc* document = [[[self window] windowController] document] ;
         But it does not work when we are invoked during initial loading
         in the stack shown below, because [self window] returns nil
         #1	-[ContentOutlineView updateNameColumnHeading]
         #2	-[CntntViewController reload]
         #3	-[CntntViewController updateOutlineMode]
         #4	-[CntntViewController setOutlineMode:]
         #5	_NSSetCharValueAndNotify
         #6	-[CntntViewController restoreAutosavedOutlineMode]
         #7	-[CntntViewController awakeFromNib]
         */
        
        NSString* trailer ;
        Stark* root = [[document starker] root] ;
        if ([bkmxDocWinCon outlineMode]) {
            trailer = [root displayStatsShort] ;
        }
        else {
            FolderStatistics stats = [[[document starker] root] addFolderStatistics] ;
            NSInteger nTotal = stats.nBookmarks ;
            if ([[(BkmxDocWinCon*)[[self window] windowController] autosavedSearchValueForKey:constAutosaveSearchFor] member:[NSNumber numberWithSharype:SharypeGeneralContainer]]) {
                nTotal += stats.nSubfolders ;
            }
            NSString* fraction = [[NSString alloc] initWithFormat:@"%ld/%ld",
                                  (long)[[self dataSource] outlineView:self
                                                numberOfChildrenOfItem:nil],
                                  (long)nTotal] ;
            trailer = [NSString localizeFormat:@"found%0", fraction] ;
            [fraction release] ;
        }
        
        NSTableColumn* nameColumn = [self tableColumnWithIdentifier:@"name"] ;
        [nameColumn setHeaderToolTip:[root displayStatsLong]] ;
        NSString* nameHeading = [[NSString alloc] initWithFormat:@"%@  (%@)",
                                 [[BkmxBasis sharedBasis] labelName],
                                 trailer] ;
        [(SSYPopUpTableHeaderCell*)[nameColumn headerCell] setFixedNonMenuTitle:nameHeading] ;
        [nameHeading release] ;
        
        NSTableHeaderView* headerView = [self headerView] ;
        // Note: headerView is an SSYTableHeaderView
        [headerView display] ;
    }
}

+ (void)initialize {
    if (self == [ContentOutlineView class] ) {
        [self exposeBinding:constKeyColorSort] ;
        [self exposeBinding:constKeyColorUnsort] ;
    }
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder] ;
    m_reloadStarks = [[NSMutableSet alloc] init] ;
    return self ;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
    
    [m_colorSort release] ;
    [m_colorUnsort release] ;
    
    [super dealloc] ;
}

- (void)checkAllProxies {
    [[self dataSource] checkAllProxies];
}

- (void)checkProxiesReloadDataAndRealizeIsExpanded {
    [self checkAllProxies];
    [self reloadData];
    [self realizeIsExpandedValuesFromModelFromRoot:nil];
}


// ***** NSControl delegate methods *****//

/*
 http://www.cocoabuilder.com/archive/message/cocoa/2007/5/19/183432
 I ended up with the following in my subclass of NSOutlineView:
 
 - (void)textDidEndEditing:(NSNotification *)aNotification
 {
 NSInteger editedRow = [self editedRow];
 [self validateEditing];
 [self abortEditing];
 // because I use variable-height rows...
 [self noteHeightOfRowsWithIndexesChanged:[NSIndexSet
 indexSetWithIndex:editedRow]];
 // grab the keyboard back
 [[self window] makeFirstResponder:self];
 }
 
 I omitted the call to [super textDidEndEditing...] because I don't
 want the outline view to ask to edit following cells; I use those
 calls to trigger other behaviors.
 
 I suppose I am at risk for not getting the complete functionality of
 textDidEndEditing, but so far I'm not observing any ill effects...
 */


//- (void)controlTextDidEndEditing:(NSNotification*)aNotification
//{
//	// Since editing is over, re-enable the appropriate buttons
//	BkmxDocOutlineView* bmOV  = [[[self doc] bkmxDocWinCon] contentOutlineView] ;
//	[[[self doc] bkmxDocWinCon] enableDisableSelectionActionButtonsForItem:[bmOV starkAtRow:[bmOV selectedRow]]] ;

//NSLog(@"controlTextDidEndEditing");
//[[[self doc] bkmxDocWinCon] resizeLastColumn] ;
//}

//
//- (BOOL)control:(NSControl *)control isValidObject:(id)object
//{
//	NSOutlineView* theView = [[[self doc] bkmxDocWinCon] contentOutlineView] ;
//	NSInteger iRow = [theView selectedRow] ;
//	NSInteger iCol = [theView selectedColumn] ;
//	Stark* targetObject = [theView starkAtRow:iRow] ;
//	return YES ;
//}
//
//- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
//{
//	return YES ;
//}
//
//- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
//{
//	return YES ;
//}


// ***** NSDraggingSource Methods (These must be here, in the subclass, not in its dataSource!) ***** //


- (NSDragOperation)        draggingSession:(NSDraggingSession *)session
     sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    NSDragOperation answer ;
    switch(context) {
        case NSDraggingContextOutsideApplication:
            answer = NSDragOperationCopy ;
            break;
            
        case NSDraggingContextWithinApplication:
        default:
            answer = (NSDragOperationCopy | NSDragOperationMove) ;
            break;
    }
    
    return answer ;
}

// Use this to over-ride the default, which is apparently a "ghost" drawing of the first column
//- (NSImage *)dragImageForRowsWithIndexes:(NSIndexSet *)dragRows
//							tableColumns:(NSArray *)tableColumns
//								   event:(NSEvent *)dragEvent
//								  offset:(NSPointPointer)dragImageOffset {
//return [NSImage imageNamed:@"bookmark"] ;
//}


// ***** NSDraggingDestination Methods (These must be here, in the subclass, not in its dataSource!) ***** //

- (NSFont*)moveableToolTipFont {
    NSFont* protoFont = [(BkmxAppDel*)[NSApp delegate] fontTable] ;
    NSString* fontName = [protoFont fontName] ;
    CGFloat size = ceil([protoFont pointSize] * 1.2) ;
    NSFont* font = [NSFont fontWithName:fontName
                                   size:size] ;
    font = [[NSFontManager sharedFontManager] convertFont:font
                                              toHaveTrait:NSBoldFontMask] ;
    return font ;
}

#define OFFSET_TO_CLEAR_GREEN_PLUS_BADGE_DURING_COPY_DRAGS 6.0
#define OFFSET_TO_NOT_BE_ANNOYING 20.0

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {
    // OS sends me this message every 50 milliseconds or so during a drag.
    
    BOOL interAppDrag ;
    if ([sender draggingSource]) {
        /*
         -draggingSource "returns the source, or owner, of the dragged data or
         nil if the source is not in the same application as the destination."
         */
        interAppDrag = NO ;
    }
    else {
        interAppDrag = YES ;
    }
    
    NSPasteboard* pboard = [sender draggingPasteboard] ;
    NSArray* types = [pboard types] ;
    BOOL draggingStarks = [types containsObject:constBkmxPboardTypeDraggableStark] ;
				
    // NSDragOperation mSnd = [sender draggingSourceOperationMask] ;
    // NSLog(@"draggingUpdated: received draggingSourceOperationMask = %i", mSnd) ;
    /*
     mSnd apparently comes from the dragging source application:
     value of mSnd(*)
     Drop Source
     Modifier key(s) pressed --------------->      none  opt only   for other
     bookmark from same window               0x00000011 0x0000001   modifier
     bookmark from other window              0x00000011 0x0000001   key
     .webloc file                            0xffffffff 0x0000001   combinations
     text from CodeWarrior                   0xffffffff 0x0000001   see below (*)
     text from TextEdit                      0x00000005 0x0000001
     URL from Safari address bar             0x00000005 0x0000001
     bookmark from Safari bookmarks outline  0xffffffff 0x0000001
     bookmark from Camino address bar        0x00000005 0x0000001
     bookmark from Camino bookmarks outline  0x00000024 0x0000000
     bookmark from Firefox address bar       0xffffffff 0x0000001
     bookmark from Firefox bookmarks outline 0xffffffff 0x0000001
     
     (*) if no modifier keys pressed.  When opt, ctrl and/or cmd are pressed,
     mSnd is modified by ANDing with the pressed modifier key mask(s):
     Modifier    Drag Mask             Meaning
     opt         0x1 =                 NSDragOperationCopy
     ctrl        0x2 =                 NSDragOperationLink
     cmd         0x4 =                 NSDragOperationGeneric
     If opt+ctrl, opt+cmd or opt+shift is pressed, you still get 0x1.
     That is why, as of Bookdog 3.10.7, I stopped using this and now
     use current event's modifier flags instead...
     */
    
    NSUInteger modifierFlags = [[NSApp currentEvent] modifierFlags] ;
    BOOL shiftKeyDown = ((modifierFlags & NSEventModifierFlagShift) != 0) ;
    BOOL optKeyDown = ((modifierFlags & NSEventModifierFlagOption) != 0) ;
    
    if (shiftKeyDown) {
        [self resetReEnableSpringLoadingTimer] ;
        [self setSpringLoadingEnabled:NO] ;
    }
    
    NSMutableString* tipText = [[NSMutableString alloc] init] ;
    NSInteger nItems = [[[sender draggingPasteboard] pasteboardItems] count] ;
    if (draggingStarks && (nItems > 3)) {
        [tipText appendString:[NSString localizeFormat:@"items%0", [NSString stringWithInt:nItems]]] ;
    }
    if (!shiftKeyDown && ([(BkmxAppDel*)[NSApp delegate] dragTipShownCountShift] < [(BkmxAppDel*)[NSApp delegate] howManyTimesToShowDragTipsThisLaunch])) {
        if ([tipText length] > 0) {
            [tipText appendString:@"\n"] ;
        }
        [tipText appendString:[NSString localize:@"holdDownShiftToInhibitSpring"]] ;
        m_didShowToolTipDuringLastDragShift = YES ;
    }
    if (draggingStarks && !optKeyDown && ([(BkmxAppDel*)[NSApp delegate] dragTipShownCountOption] < [(BkmxAppDel*)[NSApp delegate] howManyTimesToShowDragTipsThisLaunch])) {
        if ([tipText length] > 0) {
            [tipText appendString:@"\n"] ;
        }
        [tipText appendString:[NSString localize:@"holdDownOptToCopy"]] ;
        m_didShowToolTipDuringLastDragOption = YES ;
    }
    if (draggingStarks && ([(BkmxAppDel*)[NSApp delegate] dragTipShownCountContextual] < [(BkmxAppDel*)[NSApp delegate] howManyTimesToShowDragTipsThisLaunch])) {
        if ([tipText length] > 0) {
            [tipText appendString:@"\n"] ;
        }
        NSString* what = optKeyDown ? @"copyTo" : @"moveTo" ;
        what = [NSString localize:what] ;
        NSString* aTip = [NSString stringWithFormat:
                          @"\n(You might also like to try '%@ \xe2\x96\xb8' in the contextual menu.)",
                          what] ;
        [tipText appendString:aTip] ;
        m_didShowToolTipDuringLastDragContextual = YES ;
    }
    if ([tipText length] == 0) {
        [tipText release] ;
        tipText = nil ;
    }
    
    if (tipText) {
        // Offset the tooltip to stay below the image of the dragged row.
        // Depending on where the mouse is clicked in the row, the required y
        // offset may be anywhere from 0 to the rowHeight.  So, we use
        // the worst case, rowHeight.
        CGFloat yOffset = -[self rowHeight] ;
        
        [SSMoveableToolTip setOffset:NSMakePoint(
                                                 OFFSET_TO_CLEAR_GREEN_PLUS_BADGE_DURING_COPY_DRAGS + OFFSET_TO_NOT_BE_ANNOYING,
                                                 yOffset - OFFSET_TO_NOT_BE_ANNOYING
                                                 )] ;
        [SSMoveableToolTip setString:tipText
                                font:[self moveableToolTipFont]
                              origin:[sender draggingLocation]
                            inWindow:[self window]];
    }
    else {
        [SSMoveableToolTip goAway] ;
    }
    
    [tipText release] ;
    
    NSDragOperation answer = [super draggingUpdated:sender] ;
    // NSLog(@"interAppDrag=%hhd  optKeyDown=%hhd  superAnswer=%lx", interAppDrag, optKeyDown, (long)answer) ;
    // answerFromSuper = whatever value is returned by my data source delegate
    // to the message outlineView:validateDrop:proposedItem:proposedChildIndex:
    
    if (interAppDrag) {
        // If this is an inter-app drag, we only copy:
        answer &= NSDragOperationCopy ;
    }
    else {
        // Prior to BookMacster version 1.3.12, the following was
        // only one line, a &= optKeyDown ? NSDragOperationCopy : NSDragOperationMove ;
        // See companion change in -[StarkEditor parentingAction:::::].
        id draggingSource = [sender draggingSource] ;
        if (draggingSource == self) {
            answer &= optKeyDown ? NSDragOperationCopy : NSDragOperationMove ;
        }
        else {
            answer &= NSDragOperationCopy ;
        }
    }
    
    // Allow destination to determine action if user holds down command key
    // Added in BookMacster 1.19
    answer += NSDragOperationGeneric ;
    
    return answer ;
    /* What is returned here determines the cursor appearance:
     0, 4, 16 or 32: normal arrow pointing northwest
     1, 3 or 17: + in green circle with normal arrow pointing northwest
     2: crooked arrow pointing northeast, signifying NSOperationLink
     
     From NSDragging.h:
     typedef unsigned int NSDragOperation;
     
     enum {
     NSDragOperationNone		= 0,
     NSDragOperationCopy		= 1,
     NSDragOperationLink		= 2,
     NSDragOperationGeneric	= 4,
     NSDragOperationPrivate	= 8,
     NSDragOperationAll_Obsolete	= 15,
     NSDragOperationMove		= 16,
     NSDragOperationDelete	= 32,
     NSDragOperationEvery	= UINT_MAX
     };
     */
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    // self.draggingDestinationFeedbackStyle = NSTableViewDraggingDestinationFeedbackStyleRegular; // no effe tsince *Regular is the default feedback style
    m_didShowToolTipDuringLastDragShift = NO ;
    m_didShowToolTipDuringLastDragOption = NO ;
    m_didShowToolTipDuringLastDragContextual = NO ;
    [SSMoveableToolTip setString:nil
                            font:[self moveableToolTipFont]
                          origin:[sender draggingLocation]
                        inWindow:[self window]] ;
    
    // Show the window when you drag something into it.
    // Why doesn't Cocoa do this???   I think it's what user expects.
    [[[self window] windowController] showWindow:self] ;
    
    /* NSOutlineView will ask its data source, ContentDataSource. */
    return [super draggingEntered:sender] ;
}

// These work but are not needed
//	- (void)draggedImage:(NSImage *)anImage beganAt:(NSPoint)a
//{
//	NSLog(@"************ BEGAN *******************") ;
//}
/*
 Method only invoked if drag concludes with a successful drop
 - (void)concludeDragOperation:(id <NSDraggingInfo>)sender {
 }
 */

- (void)incrementDragTipShownCounts {
    if (m_didShowToolTipDuringLastDragShift) {
        [(BkmxAppDel*)[NSApp delegate] incrementDragTipShownCountShift] ;
        m_didShowToolTipDuringLastDragShift = NO ;
    }
    if (m_didShowToolTipDuringLastDragOption) {
        [(BkmxAppDel*)[NSApp delegate] incrementDragTipShownCountOption] ;
        m_didShowToolTipDuringLastDragOption = NO ;
    }
    if (m_didShowToolTipDuringLastDragContextual) {
        [(BkmxAppDel*)[NSApp delegate] incrementDragTipShownCountContextual] ;
        m_didShowToolTipDuringLastDragContextual = NO ;
    }
}

- (void)draggingExited:(id <NSDraggingInfo>)sender {
    // I do this here in case it gets dragged to another window
    [SSMoveableToolTip goAway] ;
    
    // Without the following, the circle and thick black line O------- remain on screen
    [super draggingExited:sender] ;
    
    [self incrementDragTipShownCounts] ;
}

- (void)draggingEnded:(id <NSDraggingInfo>)sender {
    // If dragging ends with a drop, the following is also done in
    // -[ContentDataSource acceptDrop:::].
    [SSMoveableToolTip goAway] ;
    [super draggingExited:sender] ;
    
    [self incrementDragTipShownCounts] ;
}


#if 0
#warning Testing AXContent
- (NSArray *)accessibilityArrayAttributeValues:(NSString *)attribute
                                         index:(NSUInteger)index
                                      maxCount:(NSUInteger)maxCount {
    NSArray* answer = [super accessibilityArrayAttributeValues:attribute
                                                         index:index
                                                      maxCount:maxCount] ;
    NSLog(@"ax attr=%@  idx=%ld  maxCount=%ld answer:\n%@", attribute, (long)index, (long)maxCount, answer) ;
    return answer;
}
#endif

@end
