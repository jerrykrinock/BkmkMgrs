#import <Bkmxwork/Bkmxwork-Swift.h>
#import "StarkTableColumn.h"
#import "BkmxDoc.h"
#import "BkmxDocWinCon+Autosaving.h"
#import "Macster.h"
#import "SSYMultiTextFieldCell.h"
#import "Stark+Attributability.h"
#import "NSString+BkmxURLHelp.h"
#import "NSUserDefaults+MoreTypes.h"
#import "BkmxAppDel.h"
#import "BkmxBasis+Strings.h"
#import "SSYTokenFieldCell.h"
#import "SSYPopUpTableHeaderCell.h"
#import "NSTableView+MoreSizing.h"
#import "NS(Attributed)String+Geometrics.h"
#import "NSMenu+RepresentMore.h"
#import "FindViewController.h"
#import "NSUserDefaults+KeyPaths.h"
#import "ContentOutlineView.h"
#import "ContentDataSource.h"
#import "NSImage+Transform.h"
#import "FolderMap.h"
#import "Starker.h"
#import "FindTableView.h"
#import "BkmxDocWinCon.h"
#import "FindTableView.h"
#import "FindViewController.h"
#import "SSYVectorImages.h"
#import "NSView+SSYDarkMode.h"

@interface StarkTableColumn ()

@property (retain) NSFont* headerFont ;
@property (retain, readonly) NSMutableDictionary* boundCells ;
@property (assign) NSPopUpButtonCell* popupCell ;

@end


@implementation StarkTableColumn

@synthesize headerFont ;
@synthesize popupCell = m_popupCell ;
- (Bookshig*)shig {
	return [[[[[self tableView] window] windowController] document] shig] ;
}

- (NSMutableDictionary*)boundCells {
	if (!m_boundCells) {
		m_boundCells = [[NSMutableDictionary alloc] init] ;
	}

	return m_boundCells ;
}


- (BOOL)isUserDefined {
	BOOL answer = [[self identifier] hasPrefix:@"userDefined"] ;
	return answer ;
}

/*
 @details  Before BookMacster 1.17, we -setHeaderFont: in -awakeFromNib, but
 that raised an exception if the CntntViewController in the nib got its
 -awakeFromNib before this StarkTableColumn did.
 */
- (id)initCommon {
    if (self) {
        NSFont* font = [NSFont menuFontOfSize:11.0] ;
        [self setHeaderFont:font] ;
    }
    
    return self ;
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder] ;
    return [self initCommon] ;
}


/*
 @details  I think this method is never invoked in BookMaster, because Stark
 table columns are always thaw-hydrated out of nibs.  This method is provided
 in case I am wrong about that, in the present or future.
 */
- (id)init {
    self = [super init] ;
    return [self initCommon] ;
}

- (void)awakeFromNib {
    
	// Per Discussion in documentation of -[NSObject respondsToSelector:],
	// the superclass name in the following must be hard-coded.
	if ([NSTableColumn instancesRespondToSelector:@selector(awakeFromNib)]) {
		[super awakeFromNib] ;
	}
	
    if ([[self headerCell] isKindOfClass:[SSYPopUpTableHeaderCell class]]) {
        /* Already awaked.  This will happen if the view controller's
         -awakeFromNib ran first and invoked us via the call stack shown below,
         and now we've received the regular -awakeFromNib from the nib loader.
         #0	-[StarkTableColumn awakeFromNib]
         #1 -[StarkTableColumn setUserDefinedAttribute:]
         #2 -[NSTableView(Autosave) restoreFromAutosaveState:]
         #3 -[ContentOutlineView restoreFromAutosaveState:]
         #4 -[CntntViewController awakeFromNib]
         */
        return ;
    }
    
    SSYPopUpTableHeaderCell* popUpHeaderCell = [[SSYPopUpTableHeaderCell alloc] init] ;
    [self setHeaderCell:(NSTableHeaderCell*)popUpHeaderCell] ;
    [self setPopupCell:popUpHeaderCell] ;
    [popUpHeaderCell release] ;

    /* The following will be overwritten soon for the Name column in the
     Content Outline, but it is needed for the Name column in the Find Table
     View. */
    if ([[self identifier] isEqualToString:constKeyName]) {
        [(SSYPopUpTableHeaderCell*)[self headerCell] setFixedNonMenuTitle:[[BkmxBasis sharedBasis] labelName]] ;
    }
    
    if ([self isUserDefined]) {
        [popUpHeaderCell setIsUserDefined:YES] ;
        
        NSMenu* menu = [popUpHeaderCell menu] ;
        [menu setDelegate:self] ;
        
        /* Needs a kick start, but wait because at this time self.tableView.window
         which will be accesssed in -menuNeedsUpdate: is still nil. */
        [self performSelector:@selector(menuNeedsUpdate:)
                   withObject:menu
                   afterDelay:0.0] ;
    }
}

- (void)menuNeedsUpdate:(NSMenu*)menu {
    NSAssert(menu == [[self headerCell] menu], @"Internal Error 824-2793") ;
    
    NSString* selectedItemTitle = [[[self popupCell] selectedItem] title] ;
    [menu removeAllItems] ;
    
    NSMenuItem* item ;
    NSDictionary* fontAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [self headerFont], NSFontAttributeName,
                                   nil] ;
    
    // HEY YOU!  If you add an item to the following, also remember
    // to add a default width in DefaultDefaults.plist > columnWidths
    NSArray* mockup = [NSArray arrayWithObjects:
                       constKeyUrlOrStats,
                       constKeyComments,
                       constKeyShortcut,
                       constKeyTags,
                       [NSNull null],  // separator
                       constKeyIsAllowedDupe,
                       constKeyIsAutoTab,
                       constKeyDontVerify,
                       constKeyIsShared,
                       [NSNull null],  // separator
                       constKeyVerifierLastResult,
                       constKeyVerifierDisposition,
                       constKeyVerifierAdviceOneLiner,
                       constKeyVerifierPriorUrl,
                       constKeyVerifierSuggestedUrl,
                       [NSNull null],  // separator
                       constKeyAddDate,
                       constKeyLastModifiedDate,
                       constKeyLastVisitedDate,
                       constKeyVisitCountString,
                       [NSNull null],  // separator
                       constKeyClients,
                       nil] ;
    for (NSString* key in mockup) {
        if ([key isKindOfClass:[NSString class]]) {
            item = [[NSMenuItem alloc] init] ;
            [item setRepresentedObject:key] ;
            NSString* title = [[BkmxBasis sharedBasis] labelNoNilForKey:key] ;
            NSAttributedString* attributedTitle = [[NSMutableAttributedString alloc] initWithString:title
                                                                                         attributes:fontAttribute] ;
            [item setAttributedTitle:attributedTitle] ;
            if (selectedItemTitle) {
                if ([[item title] isEqualToString:selectedItemTitle]) {
                    [[self popupCell] selectItem:item] ;
                }
            }
            [attributedTitle release] ;
            [item setTarget:self] ;
            [item setAction:@selector(setUserDefinedAttributeWithMenuItem:)] ;
        }
        else {
            item = [[NSMenuItem separatorItem] retain] ;
        }
        [menu addItem:item] ;
        
        [item release] ;
    }
}

- (NSArray*)keyPathArrayToColumnWidth {
	NSString* key2 = [self isUserDefined] ? [self userDefinedAttribute] : [self identifier] ;
	NSArray* answer ;
	if (key2) {
		answer = [NSArray arrayWithObjects:
			constKeyColumnWidths,
			key2,
			nil] ;
	}
	else {
		// This will happen if user-defined column has not had attribute set yet.
		answer = nil ;
	}
	
	return answer ;
}

// Added in BookMacster 1.19.6
- (void)autosaveSettings {
    NSTableView* tableView = [self tableView] ;
    BkmxDocWinCon* winCon = [[tableView window] windowController] ;
    [winCon autosaveTableColumnsInTableView:tableView] ;
}

- (void)reallySetWidth:(CGFloat)width {
    BkmxDocWinCon* bkmxDocWinCon = [[[self tableView] window] windowController] ;
    [super setWidth:width] ;
    if ([bkmxDocWinCon autosaveArmed]) {
        [self autosaveSettings] ;
    }
}


- (void)setWidth:(CGFloat)width {
    BkmxDocWinCon* bkmxDocWinCon = [[[self tableView] window] windowController] ;
    if (![bkmxDocWinCon windowIsBeingAutosized]) {
        [self reallySetWidth:width] ;
    }
}

// I can't figure out how to determine this so I just
// used trial and error...
#define MENU_LEFT_MARGIN 18.0

- (CGFloat)defaultWidth {
	CGFloat width ;
	NSTableView* tableView = [self tableView] ;
	id headerCell = [self headerCell] ;
	SEL lostWidthSelector = @selector(lostWidth) ;
	CGFloat lostWidth = 0.0 ;
	if ([headerCell respondsToSelector:lostWidthSelector]) {
		lostWidth = [headerCell lostWidth] ;
	}

	NSString* labelKey = [self isUserDefined] ? [self userDefinedAttribute] : [self identifier] ;
	CGFloat widthRequiredForHeader ;
	if (labelKey) {
		NSString* title = [[BkmxBasis sharedBasis] labelNoNilForKey:labelKey] ;
		NSFont* font = [self headerFont] ;
		CGFloat height = [[tableView headerView] frame].size.height ;
		CGFloat textWidth = [title widthForHeight:height
											 font:font] ;
		widthRequiredForHeader = MENU_LEFT_MARGIN + textWidth + lostWidth ;
	}
	else {
		// This will happen if user-defined column has not had attribute set yet.
		widthRequiredForHeader = 0.0 ;
	}
	
	if ([[BkmxBasis sharedBasis] attributeTypeForStarkKey:[self userDefinedAttribute]] == NSBooleanAttributeType) {
		// Since the row data will be only checkboxes, the column
		// width will be whatever is required to fit the menu
		// with the selected title
		width = widthRequiredForHeader ;
	}
	else {
		// Is showing text or tokens
		
		// The following should not need to be initialized since there should
		// be a default value in defaultDefaults.  But in case I forget to add
		// a default when adding a new attribute in some future version, I give
		// it a reasonable default value...
		CGFloat priorDefault = 120.0 ;
		NSArray* keyPathArray = [self keyPathArrayToColumnWidth] ;
		NSNumber* priorDefaultNumber = nil ;
		if (keyPathArray) {
			priorDefaultNumber = [[NSUserDefaults standardUserDefaults] valueForKeyPathArray:keyPathArray] ;
		}
		if (priorDefaultNumber) {
			priorDefault = [priorDefaultNumber doubleValue] ;
			if ((priorDefault > 10000.0) || isnan(priorDefault)) {
				NSLog(@"Internal Warning 925-5416.  Ignoring corrupt value %f for %@ in prefs", priorDefault, keyPathArray) ;
				priorDefault = 120.0 ;
			}
		}
		else {
			// Must be a new user with no prefs
		}
		width = MAX(widthRequiredForHeader, priorDefault) ;
	}
	
	return width ;
}

- (void)sortAsAscending:(BOOL)ascending {
    NSTableView* tableView = (ContentOutlineView*)[self tableView] ;
    
    /* Quite convenient! */
    NSString* sortKey = [self userDefinedAttribute] ;
    
    if (!sortKey) {
        /* Must be the first, "Name", column, which is not user-defined. */
        sortKey = constKeyName ;
    }

    /* The steps for sorting and reloading the Content Outline versus the
     Find Table View are different. */
    if ([tableView respondsToSelector:@selector(checkAllProxies)]) {
        /* tableView is a Content Outline */
        ContentDataSource* dataSource = (ContentDataSource*)[tableView dataSource] ;
        [dataSource setFlatSortAscending:ascending] ;
        [dataSource setFlatSortKey:sortKey] ;
        [dataSource invalidateFlatCache] ;
        ContentOutlineView* outlineView = (ContentOutlineView*)tableView;
        [outlineView checkProxiesReloadDataAndRealizeIsExpanded] ;
    }
    else if ([tableView respondsToSelector:@selector(findViewController)]) {
        /* tableView is a Find Table */
        FindViewController* findViewController = [(FindTableView*)tableView findViewController] ;
        [findViewController refreshResultsWithSortKey:sortKey
                                            ascending:ascending] ;
    }
}

- (void)sizeToFit {
	CGFloat newWidth = [self defaultWidth] ;
	
	if (newWidth != [self width]) {
		[self setWidth:newWidth] ;
		[[self tableView] tryToResizeColumn:self
									toWidth:newWidth] ;
		// It is very important that -setWidth be followed by
		// -sizeLastColumnToFit or a similar method such
		// as -tryToResizeColumn:toWidth which
		// ensures that the sum of all column widths = table width.
		// Explanation is given at the end of the class
		// documentation in SSYPopUpTableHeaderCell.h
	}
}

- (NSString*)userDefinedAttribute {
	NSString* userDefinedAttribute ;
	@synchronized(self) {
		userDefinedAttribute = [[m_userDefinedAttribute copy] autorelease] ;
	}
	return userDefinedAttribute ;
}

- (void)setUserDefinedAttribute:(NSString*)attributeName {
    // Added in BookMacster 1.17, in case -awakeFromNib has not run yet.
    // This will occur if Cocoa when loading the "Content" nib, if Cocoa
    // happens to send -awakeFromNib to the CntntViewController before
    // it sends -awakeFromNib to us.  We're both in the same nib, Content.xib.
    [self awakeFromNib] ;
    
	// Note that setting the attributeName in user defaults
	// is done by a delegate method, not in here.

	// Must unbind before changing the instance variable, because otherwise
	// bindings will sometimes try and propagate a model value to the view
	// based on the new attributeName, which will result in a type mismatch if,
	// for example, the old attributeName was 'isShared', a boolean which was
	// displayed with checkbox, and the new attributeName is 'tags', an array
	// which requires an NSTokenField.  At this time, our cell is still
	// the old cell.
	[self unbind:@"value"] ;
	
	// Set the instance variable
	@synchronized(self) {
		if (m_userDefinedAttribute != attributeName) {
			[m_userDefinedAttribute release] ;
			m_userDefinedAttribute = [attributeName copy] ;
		}
	}		
	
	// Set the new attributeName to be the selection in the menu
	NSMenu* headerMenu = [[self headerCell] menu] ;
	NSMenuItem* selectedItem = [headerMenu itemWithRepresentedObject:attributeName] ;
	NSTableHeaderCell* headerCell = [self headerCell] ;

    if ([headerCell respondsToSelector:@selector(selectItem:)]) {
        [(NSPopUpButton*)headerCell selectItem:selectedItem] ;
    }
    else {
        NSLog(@"Internal Error 524-5980  Not a menu: %@", headerMenu) ;
    }
	
	// The following code is similar to that in -[ContentDataSource outlineView:objectValueForTableColumn:byItem:]
	
	// Finally, make the new binding, but only if this is the Find Table.
	// Don't do this for Content Outline because it does not use bindings
	// (It cannot use bindings without an associated array controller,
	// or, actually, it would probably take a tree controller.)
	if (![[self tableView] isKindOfClass:[ContentOutlineView class]]) {
		NSArrayController* arrayController = [(FindTableView*)[self tableView] arrayControllerPeek] ;
		if (!arrayController) {
			return ;
		}

		NSString* keyPath = [NSString stringWithFormat:
							 @"arrangedObjects.%@",
							 attributeName] ;
		
		NSAttributeType attributeType = [[BkmxBasis sharedBasis] attributeTypeForStarkKey:attributeName] ;
		NSString* betterKey ;
        switch (attributeType) {
            case NSInteger16AttributeType:
                betterKey = [attributeName stringByAppendingString:@"DisplayName"] ;
                if ([Stark instancesRespondToSelector:NSSelectorFromString(betterKey)]) {
                    keyPath = [NSString stringWithFormat:
                               @"arrangedObjects.%@",
                               betterKey] ;
                }
                break ;
                // The following alternative code to the above is attractive because
                // it does not require an additional attribute to be defined in the
                // Stark class.  However, it gives this error in Leopards:
                // Cannot remove an observer <NSKeyValueObservance 0x164aeb20> for the key path "verifierDispositionDisplayName" from <NSCFNumber 0x412260> because it is not registered as an observer.
                // Never tried this code in Lion.
#if 0
                displayMethodName = [attributeName stringByAppendingString:@"DisplayName"] ;
                displayMethodSelector = NSSelectorFromString(displayMethodName) ;
                if ([NSNumber instancesRespondToSelector:displayMethodSelector]) {
                    keyPath = [keyPath stringByAppendingFormat:@".%@", displayMethodName] ;
                }
                break ;
#endif
            case NSDateAttributeType:
                betterKey = [attributeName stringByAppendingString:@"DisplayName"] ;
                if ([Stark instancesRespondToSelector:NSSelectorFromString(betterKey)]) {
                    keyPath = [NSString stringWithFormat:
                               @"arrangedObjects.%@",
                               betterKey] ;
                }
                break ;
                // The following alternative code to the above is attractive because
                // it does not require an additional 3 attributes (for the three dates,
                // each with 'DisplayName' appended to be defined in the
                // Stark class.  However, it gives this error in Lion every time,
                // and rarely in the Leopards:
                // Cannot remove an observer <NSTableBinder 0x4b37940> for the key path "addDate.medDateShortTimeString" from <Stark 0x4d7eea0>, most likely because the value for the key "addDate" has changed without an appropriate KVO notification being sent. Check the KVO-compliance of the Stark class.
                // This code was used until BookMacster 1.6.2…
#if 0
                keyPath = [keyPath stringByAppendingString:@".medDateShortTimeString"] ;
                break ;
#endif
            default:
                if ([attributeName isEqualToString:constKeyTags]) {
                    keyPath = [keyPath stringByAppendingString:@".string"];
                } else {
                    // simple string.  No appendage needed.
                }
		}
		
		[self bind:@"value"
		  toObject:arrayController
	   withKeyPath:keyPath
		   options:nil] ;
	}
}

- (void)setUserDefinedAttributeWithMenuItem:(NSMenuItem*)item {
	NSString* userDefinedAttribute_ = [item representedObject] ;
	[self setUserDefinedAttribute:userDefinedAttribute_] ;
	
    // Out in BookMacster 1.17 because I think it's more annoying than helpful.
    //[self sizeToFit] ;
	
    [[self tableView] reloadData] ;
    
    [self autosaveSettings] ;
}


- (void)selectUserDefinedMenuItemForKey:(NSString*)key {
	NSPopUpButtonCell* popUp = (NSPopUpButtonCell*)[self headerCell] ;
	NSMenuItem* desiredItem = nil ;
	
	if ([key isEqualToString:constKeyVisitCount]) {
		key = constKeyVisitCountString ;
	}

	for (NSMenuItem* item in [popUp itemArray]) {
		if ([[item representedObject] isEqualToString:key]) {
			desiredItem = item ;
		}
	}
	
	if (desiredItem) {
		[self setUserDefinedAttribute:key] ;
		[self sizeToFit] ;
		[popUp selectItem:desiredItem] ;
	}
}

- (id)dataCell {
	id cell = [self dataCellForRow:NSNotFound] ;
	return cell ;
}

- (id)dataCellForRow:(NSInteger)iRow {
	if (iRow < 0)  {
		// OS wants generic cell information
		return ([self dataCell]) ;
	}

	BOOL editableAttribute = YES ;
	
	// Get the userDefinedAttribute and create the generic cell
	NSTableView* tableView = [self tableView] ;
	NSString* userDefinedAttribute_ = [self userDefinedAttribute] ;
	NSCell* cell ;
	NSString* attribute ;
	if (userDefinedAttribute_) {
		attribute = userDefinedAttribute_ ;
		if ([userDefinedAttribute_ isEqualToString:constKeyTags]) {
			cell = [[SSYTokenFieldCell alloc] init] ;
			id boundToObject = [self shig] ;
			// boundToObject may be nil during initial loading of window
			if (boundToObject) {
				NSMutableDictionary* boundCells = [self boundCells] ;
				NSNumber* rowIndex = [NSNumber numberWithInteger:iRow] ;
				NSCell* oldCell = [boundCells objectForKey:rowIndex] ;
				[oldCell unbind:@"tokenizingCharacter"] ;
				[cell bind:@"tokenizingCharacter"
				  toObject:boundToObject
			   withKeyPath:constKeyTagDelimiterActual
				   options:0] ;
				[boundCells setObject:cell
							   forKey:rowIndex] ;
			}
			[cell setLineBreakMode:NSLineBreakByWordWrapping] ;
			[cell setTruncatesLastVisibleLine:YES] ;
			// ToolTip is set in -outlineView:toolTipForCell::::: or
            // -tableView:toolTipForCell:
            [cell setAccessibilityLabel:NSLocalizedString(@"Tags", nil)];
            ((NSTokenFieldCell*)cell).delegate = self;
		}
		else if ([[BkmxBasis sharedBasis] attributeTypeForStarkKey:userDefinedAttribute_] == NSBooleanAttributeType) {
			cell = [[NSButtonCell alloc] init] ;
			NSControlSize controlSize ;
			CGFloat rowHeight = [tableView rowHeight] ;
			if (rowHeight < 13) {
				controlSize = NSControlSizeMini ;
			}
			else if (rowHeight < 17) {
				controlSize = NSControlSizeSmall ;
			}
			else {
				controlSize = NSControlSizeRegular ;
			}
			[cell setControlSize:controlSize] ;
			[(NSButtonCell*)cell setButtonType:NSButtonTypeSwitch] ;
			[cell setTitle:@""] ;
			[(NSButtonCell*)cell setImagePosition:NSImageOnly] ;
		}
		else {
			cell = [[SSYMultiTextFieldCell alloc] init] ;
		}
	}
	else {
		attribute = [self identifier] ;
		cell = [[SSYMultiTextFieldCell alloc] init] ;
	}
	
	// Set generic editability (not depending on the Stark in the row)
	// for this attribute.  (If iRow < NSNotFound, this may be made 
	// not editable later depending on the data in the Stark in the row.)
	editableAttribute = [Stark isEditableAttribute:attribute] ;
	
	if (iRow < NSNotFound) {
		Stark* stark ;
		
        if ([tableView respondsToSelector:@selector(starkAtRow:)]) {
            // It's the content outline view
            stark = [(ContentOutlineView*)tableView starkAtRow:iRow] ;
        }
		else if ([tableView respondsToSelector:@selector(itemAtRow:)]) {
			// It's some other outline view
            // Does this ever happen?
            NSLog(@"Warning 242-4845") ;
			stark = [(NSOutlineView*)tableView itemAtRow:iRow] ;
		}
		else {
			// Assume it's a table view with content bound to an array controller
			NSDictionary* contentInfo = [[self tableView] infoForBinding:@"content"] ;
			NSArrayController* arrayController = [contentInfo valueForKey:NSObservedObjectKey] ;
			stark = [[arrayController arrangedObjects] objectAtIndex:iRow] ;
		}
		// If tableView is an NSOutlineView, it will respond directly to itemAtRow.
		// If tableView is an NSTableView, it will respond via a category method in SSUtilityCategories
		// which will pass the message on to its data source, where I have put the implementation.
		Sharype sharype = [stark sharypeValue] ;
		NSMutableArray* images = nil ;
        NSMutableArray* imageTips = nil ;
        if ([cell respondsToSelector:@selector(setImages:)]) {
           images = [[NSMutableArray alloc] init] ;
            // Until BookMacster 1.13.6, the next message was sent to
            // self instead of tableView, so we never had any tooltips!
            if ([tableView respondsToSelector:@selector(addToolTip:rect:)]) {
                // We will get here if we are Content or Dupes Outline View,
                // which are subclasses of BkmxOutlineView.
                // We will not be here if we are FindTableView.
                imageTips = [[NSMutableArray alloc] init] ;
            }
        }
		NSFont* font = [(BkmxAppDel*)[NSApp delegate] fontTable] ;
		NSFontManager* fontManager = [NSFontManager sharedFontManager] ;
		
		if ([StarkTyper isLeafCoarseSharype:sharype]) {
			// Set Icon
			if ([[self identifier] isEqualToString:@"name"]) {
				if ([[stark url] schemeIs_feed] || (sharype == SharypeLiveRSS)) {
					// The reason for the || above is to get all cases:
					// For Safari RSS Bookmarks, or for other browsers which
					// don't even have RSS readers, only the first will be satisfied.
					// For OmniWeb Live Bookmarks, only the second will be satisfied.
					// For Firefox Live Bookmarks, both will be satisfied.
					[images addObject:[NSImage imageNamed:@"RSSWhiteBkgnd"]] ;
                    [imageTips addObject:@"This item is a RSS feed or Firefox Live Bookmark."] ;
				}
				else if (sharype == SharypeSmart) {
					[images addObject:[NSImage imageNamed:@"NSFolderSmart"]] ;
                    [imageTips addObject:@"This item is a Smart Folder, recognized by Firefox or iCab."] ;
				}
				else if ([[stark url] hasPrefix:@"javascript:"]) {
					[images addObject:[NSImage imageNamed:@"advanced"]] ;
                    [imageTips addObject:@"This item is a JavaScript bookmarklet"] ;
				}
				else if ([[stark url] hasPrefix:@"file:"]) {
					[images addObject:[NSImage imageNamed:@"document"]] ;
                    [imageTips addObject:@"This item is a file on your computer or local network"] ;
				}
				else {
					[images addObject:[SSYVectorImages imageStyle:SSYVectorImageStyleBookmark
                                                          wength:32
                                                            color:nil
                                                     darkModeView:nil // For this template image, SSYMultiTextFieldCell will handle luminance inversion when in Dark Mode
                                                    rotateDegrees:0.0
                                                            inset:0.0]] ;
                    [imageTips addObject:[NSNull null]];
				}
			}
		}
		else if ([StarkTyper isContainerGeneralSharype:sharype]) {
			if ([[self identifier] isEqualToString:constKeyName]) {
				font =[fontManager convertFont:font
								   toHaveTrait:NSBoldFontMask] ;
			}
			else if (
					 [[self identifier] isEqualToString:constKeyUrl]
					 ||
					 [[self userDefinedAttribute] isEqualToString:constKeyUrl]
					 ) { 
				[(SSYMultiTextFieldCell*)cell setTextColor:[NSColor grayColor]] ;
			}
			
			// Set Icon
			if ([[self identifier] isEqualToString:constKeyName]) {
                NSImage* image;
				if ([stark shouldSort]) {
					image = [NSImage imageNamed:@"IconSorted"];
                    [imageTips addObject:@"This folder will be sorted by the Sort All command."] ;
				}
				else {
					image = [NSImage imageNamed:@"IconUnsorted"];
                    [imageTips addObject:@"This folder will *not* be sorted by the Sort All command."] ;
				}
                image.template = YES;
                [images addObject:image];
			}
		}
		else {  // sharype must be of SharypeCoarseNotch
		}

		if (
			![(BkmxDocWinCon*)[[[self tableView] window] windowController] outlineMode]  // is in flat mode
			&&
			([[[self tableView] tableColumns] objectAtIndex:0] == self)  // is first column
			) {
			[(SSYMultiTextFieldCell*)cell setOverdrawsRectOfDisclosureTriangle:YES] ;
		}
		
        BkmxSortDirective sortDirective = [stark sortDirectiveValue] ;
        // Check the sortDirective first since this will be rare
        if ((sortDirective == BkmxSortDirectiveTop) || (sortDirective == BkmxSortDirectiveBottom)) {
            NSString* imageName = [[stark parent] shouldSort] ? @"sortUpEn" : @"sortUpDs" ;
            NSImage* image = [NSImage imageNamed:imageName] ;
            NSString* where = @"top" ;
            if (sortDirective == BkmxSortDirectiveBottom) {
                image = [image imageRotatedByDegrees:180] ;
                if ([image.name isEqualToString:@"sortUpEn"]) {
                    image.name = @"sortDnEn";
                } else {
                    image.name = @"sortDnDs";
                }
                where = @"bottom" ;
            }
            [images addObject:image] ;
            NSString* tip = [NSString stringWithFormat:
                             @"When sorting, this item will be forced to the %@.",
                             where] ;
            tip = [[tip copy] autorelease] ;
            [imageTips addObject:tip] ;
		}
        
		// Final tweak on editability, based on the Stark.
		// If cell is editable so far, it might be not
		// editable for this particular Stark.
		if (![stark isEditableAttribute:attribute]) {
			editableAttribute = NO ;
		}
		
		// Set font to italic for uneditable cells
		if (!editableAttribute) {
			font = [fontManager convertFont:font
								toHaveTrait:NSItalicFontMask] ;
		}
		
		// Set color, if stark has one
		NSColor* color = [stark color] ;
		if (YES
			&& color
			&& [cell respondsToSelector:@selector(setTextColor:)]
			&& [[self identifier] isEqualToString:constKeyName]
			) {
			[(NSTextFieldCell*)cell setTextColor:color] ; 
		}
		
		[cell setFont:font];
		
		BOOL rowIsHighlighted = [[tableView selectedRowIndexes] containsIndex:iRow] ;
		// If the row is highlighted, we don't need to set a background color.
		// Note: This qualification is not really necessary for NSTextFieldCell because
		// the highlight color takes precedence over the background color if the
		// cell is highlighted.  But for NSButtonCell, the background color takes
		// precendence, so we need to qualify with !rowIsHighlighted.
        if ([stark canHaveChildren]) {
			// Set background color
			if (
				[cell respondsToSelector:@selector(setBackgroundColor:)]
				&&
				!rowIsHighlighted
				) {
				NSString* key = [stark shouldSort] ? constKeyColorSort : constKeyColorUnsort;
				NSColor* baseColor = [[NSUserDefaults standardUserDefaults] colorForKey:key] ;
                if ([[self tableView] isDarkMode_SSY]) {
                    /* The default colors are too bright when running in Dark
                     Mode.  So we make them darker for forcing the saturation
                     comoponent to the max value of 1.0. */
                    baseColor = [NSColor colorWithHue:baseColor.hueComponent
                                           saturation:1.0
                                           brightness:baseColor.brightnessComponent
                                                alpha:baseColor.alphaComponent];
                }
				NSInteger rank = [[stark lineageNamesSharypeMaskOut:SharypeRoot
													   includeSelf:NO] count] ;
                CGFloat brightness = 0.4 ;
                CGFloat brightnessStep = 0.28 ;
                /* Starting with a brightness of 0.4, the geometric series
                 brightnessStep + brightnessStep/2  + brightnessStep/4 + ... 
                 will add up to 2*brightnessStep = 0.56 for rank = infinite.
                 Therefore the maximum brightness will be 0.4 + 0.56 = 0.96. */
                for (uint8_t i = 0; i<rank; i++) {
                    brightness += brightnessStep ;
                    brightnessStep = brightnessStep / 2 ;
                }
				NSColor* color = [baseColor highlightWithLevel:brightness] ;
                [(id)cell setBackgroundStyle:NSBackgroundStyleLowered];
				[(id)cell setBackgroundColor:color] ;

				// NSTextFieldCell has a selector to tell it to draw background
				// NSButtonCell does not; it always draws the background
				if ([cell respondsToSelector:@selector(setDrawsBackground:)]) {
					[(id)cell setDrawsBackground:YES] ;
				}
			}
		}
		else {
			// Turn off the background color.
			// Kind of complicated due to different API of NSTextFieldCell vs. NSButtonCell
			if ([cell respondsToSelector:@selector(setDrawsBackground:)]) {
				[(id)cell setDrawsBackground:NO] ;
			}
			else if (
					 [cell respondsToSelector:@selector(setBackgroundColor:)]
					 &&
					 !rowIsHighlighted
					 ) {
				[(id)cell setBackgroundColor:[NSColor controlBackgroundColor]] ;
			}
		}
		
        if ([[self identifier] isEqualToString:constKeyName]) {
            if ([[stark isShared] boolValue]) {
                [images addObject:[NSImage imageNamed:@"sticky"]] ;
                [imageTips addObject:@"This item is set to be shared/public when exported to a web service such as Pinboard."] ;
            }
            
            Macster* macster = [(BkmxDoc*)[stark owner] macster] ;

            if ([stark canHaveTags]) {
                for (NSDictionary* folderMapping in [macster folderMappings]) {
                    NSString* folderId = [folderMapping objectForKey:constKeyFolderId] ;
                    if (folderId) {
                        if ([[[stark parent] starkid] isEqualToString:folderId]) {
                            BkmxIxportPolarity polarity = [(NSNumber*)[folderMapping objectForKey:constKeyIxportPolarity] boolValue] ;
                            NSString* clientDisplayName = [(Client*)[folderMapping objectForKey:constKeyClient] displayName] ;
                            NSString* tag = [folderMapping objectForKey:constKeyTag] ;
                            NSImage* image = [NSImage imageNamed:@"folderMapped"] ;
                            NSString* operation ;
                            if (polarity == BkmxIxportPolarityImport) {
                                operation = [NSString stringWithFormat:
                                             @"imports from %@",
                                             clientDisplayName] ;
                            }
                            else {
                                operation = [NSString stringWithFormat:
                                             @"exports to %@",
                                             clientDisplayName] ;
                                image = [image imageRotatedByDegrees:180] ;
                            }
                            [images addObject:image] ;
                            NSString* tipFormatString = @"This folder containing this bookmark has a Folder to Tag Mapping.\n\nDuring %@, this bookmark will be given an additional tag '%@'." ;
                            NSString* tip = [NSString stringWithFormat:
                                             tipFormatString,
                                             operation,
                                             tag] ;
                            [imageTips addObject:tip] ;
                        }
                    }
                }
            }
            
            for (NSDictionary* tagMapping in [macster tagMappings]) {
                NSString* mappedTag = [tagMapping objectForKey:constKeyTag] ;
                if (mappedTag) {
                    for (Tag* tag in [stark tags]) {
                        NSString* tagString = tag.string;
                        if ([mappedTag isEqualToString:tagString]) {
                            NSString* folderId = [tagMapping objectForKey:constKeyFolderId] ;
                            BkmxIxportPolarity polarity = [(NSNumber*)[tagMapping objectForKey:constKeyIxportPolarity] boolValue] ;
                            NSString* clientDisplayName = [(Client*)[tagMapping objectForKey:constKeyClient] displayName] ;
                            NSImage* image = [NSImage imageNamed:@"tagMapped"] ;
                            NSString* operation ;
                            if (polarity == BkmxIxportPolarityImport) {
                                operation = [NSString stringWithFormat:
                                             @"imports from %@",
                                             clientDisplayName] ;
                                image = [image imageRotatedByDegrees:90] ;
                            }
                            else {
                                operation = [NSString stringWithFormat:
                                             @"exports to %@",
                                             clientDisplayName] ;
                            }
                            [images addObject:image] ;
                            NSDictionary* starksByStarkid = [[(BkmxDoc*)[stark owner] starker] starksKeyedByKey:constKeyStarkid] ;
                            NSString* folderName = [(Stark*)[starksByStarkid objectForKey:folderId] name] ;
                            NSString* tipFormatString = @"This item's tag '%@' has a Tag to Folder Mapping set in %@.\n\nDuring %@, it will be redirected into folder '%@'." ;
                            [imageTips addObject:[NSString stringWithFormat:
                                                  tipFormatString,
                                                  tagString,
                                                  clientDisplayName,
                                                  operation,
                                                  folderName]] ;
                        }
                    }
                }
            }            
            
            BOOL dontExportDueToAncestor = NO ;
            Stark* ancestor = stark ;
            while (ancestor) {
                ancestor = [ancestor parent] ;
                NSArray* dontExportExformats = [ancestor dontExportExformats] ;
                if ([dontExportExformats count] > 0) {
                    dontExportDueToAncestor = YES ;
                    [images addObject:[NSImage imageNamed:@"excludedDs"]] ;
                    [imageTips addObject:@"This item will be excluded when exporting to one or more browsers, because one of its ancestors has an Export Exclusion designated."] ;
                    break ;
                }
            }
            if (!dontExportDueToAncestor) {
                if ([[stark dontExportExformats] count] > 0) {
                    [images addObject:[NSImage imageNamed:@"excluded"]] ;
                    [imageTips addObject:@"This item will be excluded when exporting to one or more clients, because it has an Export Exclusion designated."] ;
                }
            }
            
            if ([images count] > 0) {
                [(SSYMultiTextFieldCell*)cell setImages:images] ;
                if ([imageTips count] > 0) {
                    CGFloat imageWidth = [cell cellSize].height ;
                    NSInteger iColumm = [[[self tableView] tableColumns] indexOfObject:self] ;
                    NSInteger i = 0 ;
                    NSRect cellFrame = [[self tableView] frameOfCellAtColumn:iColumm
                                                                         row:iRow] ;
                    NSPoint cellOrigin = cellFrame.origin ;
                    // Note: cellOrigin is inset so as to not include the indentation and disclosure triangle
                    NSSize cellSize = cellFrame.size ;
                    for (NSString* tip in imageTips) {
                       // Add the tool tip, but only if it's a string and not an NSNull.
                        if ([tip isKindOfClass:[NSString class]]) {
                           NSPoint origin ;
                            origin.x = cellOrigin.x + i*imageWidth ;
                            origin.y = cellOrigin.y ;
                            NSSize size ;
                            size.width = imageWidth ;
                            size.height = cellSize.height ;
                            NSRect imageFrame ;
                            imageFrame.origin = origin ;
                            imageFrame.size = size ;
                            // We make the following typecast assuming that
                            // if we did not respond to addToolTip:rect:
                            // when asked previously (see above), imageTips
                            // would be nil and we wouldn't be here.
                            [(ContentOutlineView*)[self tableView] addToolTip:tip
                                                                         rect:imageFrame] ;
                        }
                        i++ ;
                    }
                }
            }
        }
        [images release] ;
        [imageTips release] ;
	}

	// Now finally we realize 'editableAttribute' into the cell.  How we
	// do this depends on the class of the cell.
	if ([cell isKindOfClass:[NSButtonCell class]]) {
		// There is ambiguity in the use of the word "editable".  When we
		// talk about the editability of an attribute, we mean whether or not
		// the user can change the value.  However, in -[NSCell isEditable],
		// this is documented as whether or not the user can change the text.
		// But the *text* of an NSButtonCell is actually the title, (which we
		// don't even show in a table column), not the value.
		// Thus, if a boolean attribute, displayed in an NSButtonCell, 
		// what we really want to do is to set the cell to be disabled.
		[cell setEnabled:editableAttribute] ;
		// And, there should be no text to edit anyhow, but just in case...
		[cell setEditable:NO] ;
	}
	else if ([cell isKindOfClass:[NSTokenFieldCell class]]) {
		// This is to work around the bug that NSTokenFieldCell does not work
		// properly when used for editing.
		[cell setEditable:NO] ;
	}
	else {
		// It's an SSYMultiTextFieldCell, where 'editable' means to edit
		// the text, which is the attribute value.
		[cell setEditable:editableAttribute] ;
	}
	
	return [cell autorelease] ;
}
	
/* Other cool stuff which can be done in dataCellForRow:
switch(row)
{
	case 0:
		NSImageCell * cell =[[NSImageCell alloc] init];
		[cell setBordered:YES];
		return [cell autorelease] ;
		break;
	case 1:
		NSPopUpButtonCell *cell=[[NSPopUpButtonCell alloc] init];
		[cell setBordered:YES];
		return [cell autorelease] ;
		break;
	case 2:
		NSTextFieldCell * cell =[[NSTextFieldCell alloc] init];
		[cell setBordered:YES];
		return [cell autorelease] ;
		break;
	case 3:
		NSButtonCell * cell =[[NSButtonCell alloc] init];
		[cell setBordered:YES];
		return [cell autorelease] ;
		break;
}

*/


- (void)unbindValue {
	// The following was added in BookMacster version 1.3.21, when I found
	// that, if user began to close a document with a new Export Client that
	// had never been exported to, and then clicked *Close* in response to
	// the warning of that, with certain documents, if one of the columns
	// in the Content or Reports ▸ Find tab had been set to show 'Tags',
	// sometimes, one of the now-deallocated SSYTokenFields would receive
	// a message from Cocoa bindings, causing a crash.  Also, it is correct
	// programming practice to manually unbind whatever one manaully binds.
	for (NSCell* cell in [self boundCells]) {
		[cell unbind:@"tokenizingCharacter"] ;
	}
	[[self boundCells] removeAllObjects] ;
	
	[self unbind:@"value"] ;
}

- (void) dealloc {
	[m_userDefinedAttribute release] ;
	[m_boundCells release] ;
	[headerFont release] ;
	
	[super dealloc] ;
}

- (NSString*)       tokenFieldCell:(NSTokenFieldCell*)tokenFieldCell
  displayStringForRepresentedObject:(id)representedObject {
    return [representedObject string];
}

- (id)              tokenFieldCell:(NSTokenFieldCell*)tokenFieldCell
 representedObjectForEditingString:(NSString*)editingString {
    Tagger* tagger = [[[[[self tableView] window] windowController] document] tagger];
    Tag* newTag = [tagger tagWithString:editingString];
    return newTag;
}

@end
