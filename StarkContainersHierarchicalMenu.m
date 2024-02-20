#import "StarkContainersHierarchicalMenu.h"
#import "BkmxDoc.h"
#import "Stark+Attributability.h"
#import "Starker.h"
#import "BkmxBasis+Strings.h"
#import "NSMenu+Ancestry.h"
#import "NSMenuItem+Font.h"
#import "NSDictionary+SimpleMutations.h"
#import "NSString+LocalizeSSY.h"
#import "NSMenuItem+Bkmx.h"
#import "NSString+Truncate.h"
#import "SSYDynamicMenu.h"
#import "NSDocumentController+FrontOrder.h"

@interface Stark (CanDoMenuStuff)

- (BOOL)canAddNewItemHere ;
- (BOOL)canVisitAllChildren ;

@end

@implementation Stark (CanDoMenuStuff)

- (BOOL)canAddNewItemHere {
	BOOL canAddNewItemHere = NO ;
	if ([self respondsToSelector:@selector(sharypeValue)]) {
		if ([self sharypeValue] == SharypeRoot) {
			if ([(BkmxDoc*)[self owner] rootLeavesOk]) {
				canAddNewItemHere = YES ;
			}
		}
		else {
			// This is a softainer or non-root hartainer.
			canAddNewItemHere = YES ;
		}
	}

	return canAddNewItemHere ;
}

- (BOOL)canVisitAllChildren {
    BOOL canVisitAllChildren = NO ;
    if ([self numberOfBookmarks] > 1) {
        Sharype sharype = [self sharypeValue] ;
        if (sharype != SharypeRoot) {
            canVisitAllChildren = YES ;
        }
    }
    
    return canVisitAllChildren ;

}

@end

enum SCHMItemType_enum {
    SCHMItemTypeDocument,
    SCHMItemTypeVisitAll,
    SCHMItemTypeAddHere,
    SCHMItemTypeIntoNewSub,
    SCHMItemTypeSeparator,
    SCHMItemTypeRegular
    } ;
typedef enum SCHMItemType_enum SCHMItemType;


@implementation StarkContainersHierarchicalMenu

@synthesize doRoot = m_doRoot ;
@synthesize doLeaves = m_doLeaves ;
@synthesize addHereInfo = m_addHereInfo ;
@synthesize doVisitAll = m_doVisitAll ;

- (id)initWithTarget:(id)target
            selector:(SEL)selector
          targetInfo:(id)targetInfo {
    self = [super initWithTarget:target
                        selector:selector
                      targetInfo:targetInfo] ;
    if (self) {
        NSFont* font = [NSFont systemFontOfSize:[[NSUserDefaults standardUserDefaults] doubleForKey:constKeyMenuFontSize]] ;
        [self setFont:font] ;
    }

    return self ;
}

- (void)dealloc {
	[m_addHereInfo release] ;
	
	[super dealloc] ;
}

- (NSInteger)numberOfItemsInMenu:(NSMenu*)menu {
	id representedObject = [[menu supermenuItem] representedObject] ;
	if (!m_doRoot && !representedObject) {
		NSArray* documents = [[NSDocumentController sharedDocumentController] frontOrderDocuments] ;
		if ([documents count] == 1) {
			BkmxDoc* document = [documents objectAtIndex:0] ;
			representedObject = [[document starker] root] ;
		}
		else {
			NSLog(@"Internal Error 540-0951") ;
		}
	}
	
	NSInteger answer ;
	if (!representedObject) {
        // The following if() was added in BookMacster 1.16.4
        StarkContainersHierarchicalMenu* superSubMenu = (StarkContainersHierarchicalMenu*)[[self supermenuItem] submenu] ;
        NSString* actionName = NSStringFromSelector([superSubMenu selector]) ;
        if ([actionName hasPrefix:@"move"]) {
            // According to Human Interface Guidelines, do not implement *Move*
            // to another document.  (*Copy* is allowed.)
            answer = 1 ; // Root of this document only.
        }
        else {
            answer = [[[NSDocumentController sharedDocumentController] documents] count] ;
        }
	}
	else if ([representedObject respondsToSelector:@selector(numberOfChildren)]) {
		if (m_doLeaves) {
			answer = [representedObject numberOfChildren] ;
		}
		else {
			answer = [representedObject numberOfSubfolders] ;
		}

        if ([self addHereInfo]) {
			if ([representedObject canAddNewItemHere]) {
				// Add 2 items, for "Add Here: Blah Blah", and "… into a new subfolder"
				answer += 2 ;
			}
		}
        if ([self doVisitAll]) {
            if ([representedObject canVisitAllChildren]) {
                answer += 1 ;
            }
        }

        BOOL hasTopSection = (
                              ([self doVisitAll] && [representedObject canVisitAllChildren])
                              ||
                              [representedObject canAddNewItemHere]
                              ) ;
        BOOL hasBottomSection = ([representedObject numberOfChildren] > 0) ;
        BOOL separatorIsNeeded = (hasTopSection && hasBottomSection) ;
        if (separatorIsNeeded) {
            answer += 1 ;
        }
    }
	else {
		answer = 0 ;
	}
	
	return answer ;
}

- (SCHMItemType)itemTypeForParent:(Stark*)representedParent
                            index:(NSInteger)index
                    childOffset_p:(NSInteger*)childOffset_p {
    BOOL hasVisitAll = [self doVisitAll] && [representedParent canVisitAllChildren] ;
    BOOL hasAddHere = ([representedParent canAddNewItemHere]  && ([self addHereInfo] != nil)) ;
    SCHMItemType itemType ;
    NSInteger childOffset ;
    
    if (hasVisitAll) {
        if (hasAddHere) {
            /* Case 1 of 4.  Menu looks like:
             • Visit All
             • Add New Item Here
             •   …into new subfolder
             • -----(separator)------
             • 1st regular item 
             • 2nd regular item
             • etc. */
            childOffset = -4 ;  // 4 special items at top
            switch (index) {
                case 0:
                    itemType = SCHMItemTypeVisitAll ;
                    break ;
                case 1:
                    itemType = SCHMItemTypeAddHere ;
                    break ;
                case 2:
                    itemType = SCHMItemTypeIntoNewSub ;
                    break ;
                case 3:
                    itemType = SCHMItemTypeSeparator ;
                    break ;
                default:
                    itemType = SCHMItemTypeRegular ;
            }
        }
        else {
            /* Case 2 of 4.  Menu looks like:
             • Visit All
             • -----(separator)------
             • 1st regular item
             • 2nd regular item
             • etc. */
            childOffset = -2 ;  // 2 special items at top
            switch (index) {
                case 0:
                    itemType = SCHMItemTypeVisitAll ;
                    break ;
                case 1:
                    itemType = SCHMItemTypeSeparator ;
                    break ;
                default:
                    itemType = SCHMItemTypeRegular ;
            }
        }
    }
    else {
        if (hasAddHere) {
            /* Case 3 of 4.  Menu looks like:
             • Add New Item Here
             •   …into new subfolder
             • -----(separator)------
             • 1st regular item
             • 2nd regular item
             • etc. */
            childOffset = -3 ;
            switch (index) {
                case 0:
                    itemType = SCHMItemTypeAddHere ;
                    break ;
                case 1:
                    itemType = SCHMItemTypeIntoNewSub ;
                    break ;
                case 2:
                    itemType = SCHMItemTypeSeparator ;
                    break ;
                default:
                    itemType = SCHMItemTypeRegular ;
            }
            
        }
        else {
            /* Case 4 of 4.  Menu looks like:
             • 1st regular item
             • 2nd regular item
             • etc. */
            childOffset = 0 ;
            itemType = SCHMItemTypeRegular ;
        }
    }

    if (childOffset_p) {
        *childOffset_p = childOffset ;
    }
    
    return itemType ;
}

- (BOOL)menu:(NSMenu*)menu
  updateItem:(NSMenuItem*)item
	 atIndex:(NSInteger)index
shouldCancel:(BOOL)shouldCancel {
	BOOL ok = YES ;
	id representedParent = [[menu supermenuItem] representedObject] ;
	if (!m_doRoot && !representedParent) {
		NSArray* documents = [[NSDocumentController sharedDocumentController] frontOrderDocuments] ;
		if ([documents count] == 1) {
			BkmxDoc* document = [documents objectAtIndex:0] ;
			representedParent = [[document starker] root] ;
		}
		else {
			NSLog(@"Internal Error 546-9512") ;
		}
	}

	NSString* title = nil ;
	id rawRepresentedItem = nil ;  // Use id because this may be a BkmxDoc or a Stark
	id representedObject = nil ;  // Use id because this may be a Stark or a NSDictionary
	NSColor* color = nil ;
	NSDictionary* addHereInfo = [self addHereInfo] ;
    SCHMItemType itemType ;

    if (!representedParent) {
		/* representedParent is a root, thus representing a document (to
         support multiple documents being open) */
		NSArray* documents = [[NSDocumentController sharedDocumentController] frontOrderDocuments] ;
        /* The system may call this method to populate main menu > Edit in
         BookMacster, and if no documents are open, `documents` will contain 0
         items.  So we must check for that to avoid raising an exception in
         -objectAtIndex:. */
        if (documents.count > index) {
            rawRepresentedItem = [documents objectAtIndex:index] ;
        }
		title = [[BkmxBasis sharedBasis] labelRoot] ;
		if ([documents count] > 1) {
			title = [(BkmxDoc*)rawRepresentedItem displayNameShort] ;
		}

        // The following code was in BookMacster 1.16.4.  Before then, we just unconditionally assigned representedObject = [[rawRepresentedItem starker] root] ;
        if (rawRepresentedItem) {
            representedObject = [[rawRepresentedItem starker] root] ;
        }

        itemType = [self itemTypeForParent:representedParent
                                     index:index
                             childOffset_p:NULL] ;

        if (itemType == SCHMItemTypeRegular) {
            [item setTarget:self] ;
            [item setAction:@selector(hierarchicalMenuAction:)] ;
        }
    } else {
        NSInteger childOffset ;
        itemType = [self itemTypeForParent:representedParent
                                     index:index
                             childOffset_p:&childOffset] ;
        NSDictionary* info = nil ;
        switch (itemType) {
            case SCHMItemTypeVisitAll:;
                // Item at index is the "Visit All" item
                representedObject = representedParent ;
                [item visitAllifyOfParent:representedParent] ;
                break ;
            case SCHMItemTypeAddHere:
                // Item at index is the "Add Here:" item
                info = [addHereInfo dictionaryBySettingValue:representedParent
                                                      forKey:constKeyParent] ;
                representedObject = info ;
                [item addHereifyWithInfo:info] ;
                break ;
            case SCHMItemTypeIntoNewSub:
                // Item at index is the "… into a new subfolder" item
                info = [addHereInfo dictionaryBySettingValue:representedParent
                                                      forKey:constKeyParent] ;
                info = [info dictionaryBySettingValue:[NSNumber numberWithBool:YES]
                                               forKey:constKeyWantsNewSubfolder] ;
                representedObject = info ;
                [item newSubfolderifyWithInfo:info] ;
                break ;
            case SCHMItemTypeSeparator:
                // Item at index is the separator between special top items
                // and regular items
                // We signify a separator by representedObject = nil
                representedObject = nil ;
                break ;
            case SCHMItemTypeRegular:;
                // Item at index is a stark
                NSArray* children ;
                if (m_doLeaves) {
                    children = [representedParent childrenOrdered] ;
                }
                else {
                    children = [representedParent subfoldersOrdered] ;
                }
                NSInteger childIndex = index + childOffset ;
                if (childIndex < [children count]) {  // Bug fix in BookMacster 1.12.9.  In 1.12.8, it was "index < …"
                    rawRepresentedItem = [children objectAtIndex:childIndex] ;
                    [item setTarget:self] ;
                    [item setAction:@selector(hierarchicalMenuAction:)] ;

                    title = [[rawRepresentedItem nameNoNil] stringByTruncatingMiddleToLength:MENU_ITEM_MAX_DISPLAY_CHARS_LONG
                                                                                  wholeWords:YES] ;
                    color = [rawRepresentedItem color] ;
                    
                    // Again, we signify a separator by representedObject = nil
                    representedObject = ([rawRepresentedItem sharypeValue] == SharypeSeparator)
                    ? nil
                    : rawRepresentedItem ;
                }
                else {
                    // This branch added in BookMacster 1.12.8.
                    // Children must have disappeared since the update started.
                    // This condition is possibly due to my optimization of
                    // -childrenOrdered in BookMacster 1.12.7.
                    representedObject = nil ;
                    ok = NO ;
                }
                break ;
            case SCHMItemTypeDocument:
                NSLog(@"Internal Error 282-9405") ;
        }
	}
	
	if (!representedObject && ![item isSeparatorItem]) {
		// Item should be a separator but is not
		// Because there is no method to mutate the given NSMenuItem* item into a
		// separator item, we must do the following incredibly stupid thing, as was
		// also suggested by Andy Lee on 20050930,
		// http://www.cocoabuilder.com/archive/cocoa/147220-turning-nsmenuitem-into-separator.html?q=updateItem%3A+separator#147232
		NSMenu* supermenu = [item menu] ;
		[supermenu removeItemAtIndex:index] ;
		[supermenu insertItem:[NSMenuItem separatorItem]
					  atIndex:index] ;
	}
	else {
        // This has already been done in the case of the Add Here menu item but oh, well.
        [item setRepresentedObject:representedObject] ;
        
        if (title) {
            [item setTitle:title] ;
        }
        
        // This has already been done in the case of the Add Here menu item but oh, well.
        CGFloat fontSize = [[NSUserDefaults standardUserDefaults] doubleForKey:constKeyMenuFontSize] ;
        [item setFontColor:color
                      size:fontSize] ;
        
        if (
            [representedObject respondsToSelector:@selector(canHaveChildren)]
            &&
            (
             (itemType == SCHMItemTypeRegular)
             ||
             // The following line is needed to enable different documents in
             // contextual menus.  It is not needed to enable different
             // menus in the Status Menulet, Dock Menu or Anywhere Menu.
             // I don't know why/not.
             (itemType == SCHMItemTypeDocument)
             )
            ) {
            if ([representedObject canHaveChildren]) {
                NSImage* folderImage = [NSImage imageNamed:@"folder.tif"] ;
                [item scaleAndSetImage:folderImage] ;
            }
            
            if (
                m_doLeaves
                ? (([representedObject numberOfChildren] > 0) || (addHereInfo && [representedObject canHaveChildren]))
                : ([representedObject numberOfSubfolders] > 0)
                ) {
                // Create and add a submenu to item
                NSMenu* submenu = [[NSMenu alloc] init] ;
                CGFloat fontSize = [[NSUserDefaults standardUserDefaults] doubleForKey:constKeyMenuFontSize] ;
                NSFont* font = [NSFont systemFontOfSize:fontSize] ;
                [submenu setFont:font] ;
                [submenu setDelegate:self] ;
                [item setSubmenu:submenu] ;
                [submenu release] ;
            }
        }
    }
    
    // If we return NO, it does not come back and ask to update any
    // more items, so you can end up with "empty" menu items if the menu
    // is actually shown
    return ok ;
}

@end
