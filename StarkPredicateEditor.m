#import "StarkPredicateEditor.h"
#import "BkmxBasis+Strings.h"
#import "BkmxAppDel+Capabilities.h"
#import "NSPredicateEditor+AppleForgot.h"
#import "SSYReplacePredicateEditorRowTemplate.h"
#import "NSView+SSYDarkMode.h"
#import "NSString+BkmxDisplayNames.h"

CGFloat const rightTextFieldMinimumWidth = 50.0 ;


@interface StarkPredicateEditor ()

@property (retain) NSArray* attributeKeyPaths ;
@property BOOL isInitialized ;
@property BOOL replaceIsRegex ;

@end

@implementation StarkPredicateEditor


/*
 - (void)_performClickOnSlice:(id)fp8 withEvent:(id)event {
	NSLog(@"pcos: %@", event) ;
}

- (void)_mouseDownOnSlice:(id)fp8 withEvent:(id)event {
	NSLog(@"mdos: %@", event) ;
}

- (void)mouseDown:(NSEvent*)event {
	NSLog(@"510: event: %@", event) ;
	[super mouseDown:event] ;
}
- (void)mouseUp:(NSEvent*)event {
	NSLog(@"511: event: %@", event) ;
	[super mouseUp:event] ;
}

// I've never seen this invoked
- (NSPredicate *)predicateForRow:(NSInteger)row {
	NSPredicate* predicate = [super predicateForRow:row] ;
		NSLog(@"524: pred: %@", predicate) ;
	return predicate ;
}
*/

@synthesize attributeKeyPaths ;
@synthesize previousRowCount ;
@synthesize isInitialized ;

/* Fix for Dark Mode.  See
 https://stackoverflow.com/questions/53345734/macos-mojave-dark-mode-ui-bugs-with-nspredicateeditor-in-a-sheet
 */
- (void)layout {
    [super layout];

    if (@available(macOS 10.14, *)) {
        NSClipView* clipView = (NSClipView*)self.superview;
        NSScrollView* scrollView = (NSScrollView*)clipView.superview;
        if ([clipView isKindOfClass:[NSClipView class]] && [scrollView isKindOfClass:[NSScrollView class]]) {
            CGFloat alpha = [self isDarkMode_SSY] ? 0.0 : 1.0;
            NSColor* backgroundColor = [NSColor colorWithRed:scrollView.backgroundColor.redComponent
                                                       green:scrollView.backgroundColor.greenComponent
                                                        blue:scrollView.backgroundColor.blueComponent
                                                       alpha:alpha];
            scrollView.backgroundColor = backgroundColor;
        }
    }
}

- (NSMutableSet*)replaceCheckboxes {
    if (!_replaceCheckboxes) {
        _replaceCheckboxes = [[NSMutableSet alloc] init] ;
    }
    
    return _replaceCheckboxes ;
}

- (void) dealloc {
	[attributeKeyPaths release] ;
    [_replaceCheckboxes release] ;
    [_replaceAttributeKey release] ;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SSYReplacePredicateCheckboxWillGoAwayNotification
                                                  object:nil] ;

	[super dealloc] ;
}

+ (NSArray*)operatorsForStrings {
	return [NSArray arrayWithObjects:
			[NSNumber numberWithInteger:NSContainsPredicateOperatorType],
			[NSNumber numberWithInteger:NSEqualToPredicateOperatorType],
			[NSNumber numberWithInteger:NSBeginsWithPredicateOperatorType],
			[NSNumber numberWithInteger:NSEndsWithPredicateOperatorType],
			[NSNumber numberWithInteger:NSNotEqualToPredicateOperatorType],
            [NSNumber numberWithInteger:NSMatchesPredicateOperatorType],
			nil] ;
}

+ (NSArray*)operatorsForNumbers {
	return [NSArray arrayWithObjects:
			[NSNumber numberWithInteger:NSEqualToPredicateOperatorType],
			[NSNumber numberWithInteger:NSNotEqualToPredicateOperatorType],
			[NSNumber numberWithInteger:NSLessThanPredicateOperatorType],
			[NSNumber numberWithInteger:NSLessThanOrEqualToPredicateOperatorType],
			[NSNumber numberWithInteger:NSGreaterThanPredicateOperatorType],
			[NSNumber numberWithInteger:NSGreaterThanOrEqualToPredicateOperatorType],
			nil] ;
}

+ (NSArray*)operatorsForDates {
	return [self operatorsForNumbers] ;
}

+ (NSArray*)operatorsForBools {
	return [NSArray arrayWithObjects:
			[NSNumber numberWithInteger:NSEqualToPredicateOperatorType],
			nil] ;
}

+ (NSArray*)operatorsForAttributeType:(NSAttributeType)attributeType {
	NSArray* operators ;
	switch(attributeType) {
		case NSInteger16AttributeType:
		case NSInteger32AttributeType:
		case NSInteger64AttributeType:
		case NSDecimalAttributeType:
		case NSDoubleAttributeType:
		case NSFloatAttributeType:
			operators = [StarkPredicateEditor operatorsForNumbers] ;
			break ;
		case NSStringAttributeType:
			operators = [StarkPredicateEditor operatorsForStrings] ;
			break ;
		case NSBooleanAttributeType:
			operators = [StarkPredicateEditor operatorsForBools] ;
			break ;
		case NSDateAttributeType:
			operators = [StarkPredicateEditor operatorsForDates] ;
			break ;
		default:
            operators = nil ;
			NSLog(@"Internal Error 432-9825. No operators for attr type %ld", (long)attributeType) ;
	}

	return operators ;
}

- (NSInteger)itemIndexForAttributeKeyPath:(NSString*)keyPath {
	return [[self attributeKeyPaths] indexOfObject:keyPath] ;
}

- (NSPredicate*)objectValue {
    NSPredicate* predicate = [super objectValue] ;
    if (self.ignoreEmptyStrings && (predicate != nil)) {
        NSError* error = nil ;
        NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"\\w+ (BEGINSWITH|ENDSWITH|CONTAINS|MATCHES) \"\""
                                                                          options:NSRegularExpressionCaseInsensitive
                                                                            error:&error] ;
        if (error) {
            NSLog(@"Internal Error 225-3498 %@", error) ;
        }
        NSMutableString* predicateFormat = [[predicate predicateFormat] mutableCopy] ;
        [regex replaceMatchesInString:predicateFormat
                              options:0
                                range:NSMakeRange(0, predicateFormat.length)
                         withTemplate:@"TRUEPREDICATE"] ;

        predicate = [NSPredicate predicateWithFormat:predicateFormat] ;
#if !__has_feature(objc_arc)
        [regex release] ;
        [predicateFormat release] ;
#endif
    }
    
    return predicate ;
}


/*!
 @brief     Returns an array of predicate editor row templates for receiver's
 array of attributeKeyPaths, consulting a given entity description to get the
 attribute type, if available.
 
 @details   
 Limited support for non-managed objects (regular instance variables) is 
 provided by assuming a default attribute type of NSStringAttributeType
 for any attribute key path which is not an attribute in the given entity
 description.
 
 The text field widths for right-side values for key paths of numerical types
 are 50 pixels instead of ~20 pixels.
 
 The titles of menu items are determined by sending -labelNoNilForKey: to
 [BkmxBasis sharedBasis], allowing (localized) display names to be provided.
 */
- (NSArray*)templates {	
	NSMutableArray* templates = [[NSMutableArray alloc] init] ;
	for (NSString* key in [self attributeKeyPaths]) {
		NSArray* leftExpressions = [NSArray arrayWithObject:[NSExpression expressionForKeyPath:key]] ;
		
		// Get the attribute type for the given key
		NSAttributeType rightExpressionAttributeType = [[BkmxBasis sharedBasis] attributeTypeForStarkKey:key] ;
				
		if (rightExpressionAttributeType == NSUndefinedAttributeType) {
			rightExpressionAttributeType = NSStringAttributeType ;
		}
		
		// Get appropriate operators and choices
		NSArray* operators = [[self class] operatorsForAttributeType:rightExpressionAttributeType] ;
		NSArray* choices = nil ;
		NSString* labelGetterMethodPrefix = nil ;
		switch(rightExpressionAttributeType) {
			case NSInteger16AttributeType:
			case NSInteger32AttributeType:
			case NSInteger64AttributeType:
			case NSDecimalAttributeType:
			case NSDoubleAttributeType:
			case NSFloatAttributeType:
				choices = [(BkmxAppDel*)[NSApp delegate] starkChoicesForKey:key] ;
				labelGetterMethodPrefix = key ;
				break ;
			case NSStringAttributeType:
				break ;
			case NSBooleanAttributeType:
				choices = [(BkmxAppDel*)[NSApp delegate] booleanChoices] ;
				labelGetterMethodPrefix = @"boolean" ;
				break ;
			case NSDateAttributeType:
				break ;
			default:
				;
		}
				
		// Create the template
		SSYReplacePredicateEditorRowTemplate* template ;
		if (choices) {
			NSMutableArray* rightExpressions = [[NSMutableArray alloc] init] ;
			for (id choice in choices) {
				[rightExpressions addObject:[NSExpression expressionForConstantValue:choice]] ;
			}
			
            template = [[SSYReplacePredicateEditorRowTemplate alloc] initWithLeftExpressions:leftExpressions
                                                                            rightExpressions:rightExpressions
                                                                                    modifier:NSDirectPredicateModifier
                                                                                   operators:operators
                                                                                     options:0] ;
			[rightExpressions release] ;
			NSArray* templateViews = [template templateViews] ;
			NSView* rightPopUpButton = (NSPopUpButton*)[templateViews objectAtIndex:2] ;
			NSInteger i = 0 ;
			for (NSMenuItem* menuItem in [[rightPopUpButton menu] itemArray]) {
				id choice = [choices objectAtIndex:i] ;
				// Default 'label' encloses description in funky brackets so it will be
				// recognized as an error if it does not get overwritten:
				NSString* label = [NSString stringWithFormat:
								   @"X<%@>X",
								   [choice description]] ;  
				if (labelGetterMethodPrefix) {
					NSString* methodName = [labelGetterMethodPrefix stringByAppendingString:@"DisplayName"] ;
					SEL labelGetter = NSSelectorFromString(methodName) ;
					if ([choice respondsToSelector:labelGetter]) {
						label = [choice performSelector:labelGetter] ;
					}
				}
				[menuItem setTitle:label] ;
				i++ ;
			}
			
		}
		else {
            template = [[SSYReplacePredicateEditorRowTemplate alloc] initWithLeftExpressions:leftExpressions
                                                                rightExpressionAttributeType:rightExpressionAttributeType
                                                                                    modifier:NSDirectPredicateModifier
                                                                                   operators:operators
                                                                                     options:0] ;
		}
        
        /* The typecast in  the following statement should not be necessary, 
         because StarkPredicateEditor is clearly declared in its @interface
         as conforming to SSYReplacePredicateEditorRowTemplateReplacer.  But
         without it, I get a warning. */
        template.replacer = (StarkPredicateEditor <SSYReplacePredicateEditorRowTemplateReplacer> *) self ;
        template.attributeKey = key ;
		
        /* Post-creation template tweak #1
         When -[SSYReplacePredicateEditorRowTemplate initWithLeftExpressions:rightExpressionAttributeType:modifier:operators:options:
         produces a template, the title of its left popup button is the
         key to which the left expression has been assigned.  That's OK
         for in-house work, but for a production app we want an actual
         display string.  If the language is English, in many cases that
         will mean simply capitalizing it.  But to get the correct
         answer for all languages and keys we use
         -[[BkmxBasis sharedBasis] labelNoNilForKey:]. */
		NSArray* templateViews = [template templateViews] ;
		NSView* leftPopUpButton = (NSPopUpButton*)[templateViews objectAtIndex:0] ;
		NSInteger tag = 0 ;
		for (NSMenuItem* menuItem in [[leftPopUpButton menu] itemArray]) {
			[menuItem setTitle:[[BkmxBasis sharedBasis] labelNoNilForKey:key]] ;
			[menuItem setTag:tag++] ;
            /*SSYDBL*/ NSLog(@"1 somefood menuItem %@:\nhas repObject: %@", menuItem, [menuItem representedObject]);

		}
		
        /* Post-creation template tweak #2
         Probably because the symbol NSMatchesPredicateOperatorType is used for
         "regular expression", the title of this menu itme is (for English
         localization) "matches".  But I don't think most regular users will
         get that.  I think that instead we should use the technical term, so
         that regular users who don't know what it means will stay away, and
         power users will be confident of exactly what it means.  So we now
         find that menu item, if it exists, and re-title it. */
        NSView* operatorPopUpButton = (NSPopUpButton*)[templateViews objectAtIndex:1] ;
        for (NSMenuItem* menuItem in [[operatorPopUpButton menu] itemArray]) {
            NSPredicateOperatorType operatorType = ((NSNumber*)menuItem.representedObject).integerValue ;
            if (operatorType == NSMatchesPredicateOperatorType) {
                [menuItem setTitle:[SSYReplacePredicateEditorRowTemplate localizedRegexMenuItemTitle]] ;
            }

        }
        
		// Post-creation template tweak #3
		BOOL doMakeSureRightFieldIsWideEnough = NO ;
		BOOL doShowTimeOfDay = NO ;
		switch(rightExpressionAttributeType) {
			case NSInteger16AttributeType:
			case NSInteger32AttributeType:
			case NSInteger64AttributeType:
			case NSDecimalAttributeType:
			case NSDoubleAttributeType:
			case NSFloatAttributeType:
				doMakeSureRightFieldIsWideEnough = YES ;
				break ;
			case NSDateAttributeType:
				doShowTimeOfDay = YES ;
			default:
				;
		}
		NSView* rightControl = [templateViews objectAtIndex:2] ;
		if (doMakeSureRightFieldIsWideEnough) {
			// When -[SSYReplacePredicateEditorRowTemplate initWithLeftExpressions:rightExpressionAttributeType:modifier:operators:options:
			// produces a template, if the rightExpressionAttributeType is a number, 
			// the right text field is only wide enough for about 3 characters.
			// The following block of code makes it wider.
			NSRect rightTextFieldFrame = [rightControl frame] ;
			CGFloat rightTextFieldWidth = rightTextFieldFrame.size.width ;
			if (rightTextFieldMinimumWidth > rightTextFieldWidth) {
				rightTextFieldFrame.size.width = rightTextFieldMinimumWidth ;
				[rightControl setFrame:rightTextFieldFrame] ;
			}
		}

        // Post-creation template tweak #3
        if (doShowTimeOfDay) {
			// rightControl should be a date picker, but we do defensive programming
			// since I don't think it's really documented.
			if ([rightControl respondsToSelector:@selector(datePickerElements)]) {
				// The default date picker used in NSPredicateEditor does not show time and date.
				// We want to show those.  Otherwise users will only see the date and may get
				// unexpected results if, for example, they set a bookmark at 9:00 on 2009 May 05 but
				// it does not match when the date picker says "2009 May 05" because the date
				// picker value is actually "2009 May 05 at 00:00:00"
				NSDatePicker* datePicker = (NSDatePicker*)rightControl ;
				NSDatePickerElementFlags flags = [datePicker datePickerElements] ;
				flags = flags | NSDatePickerElementFlagHourMinuteSecond ;
				// However, the stupid frame is then not wide enough to show the seconds
				[datePicker setDatePickerElements:flags] ;
				NSRect frame = [datePicker frame] ;
				frame.size.width += 20 ;
				// frame.origin.y += 2.0 ;  // Has no effect, but in this case we don't need it.
                frame.size.height = 18.0 ;  // Works in macOS 10.11, did not work several years ago.
				[datePicker setFrame:frame] ;
			}
		}
		
		// Post-creation tweak #5 UNFORTUNATELY_THIS_AUTORESIZE_HAS_NO_EFFECT
        if ([rightControl isKindOfClass:[NSTextField class]] && [(NSTextField*)rightControl isEditable]) {
            [rightControl setAutoresizingMask:NSViewWidthSizable] ;
        }
        
        [templates addObject:template] ;
		[template release] ;
	}
	
	NSArray* answer = [templates copy] ;
	[templates release] ;
	
	return [answer autorelease] ;
}	

- (IBAction)userClickedReplaceCheckboxForRowTemplateButton:(SSYReplacePredicateCheckbox*)checkbox {
    /* Switch off all other rows' checkboxes. */
    for (NSButton* aCheckbox in [self replaceCheckboxes]) {
        if (aCheckbox != checkbox) {
            [aCheckbox setState:NSControlStateValueOff] ;
        }
    }
    
    /* Remember this checkbox, in case we've not seen it before.  Note that
     we don't need to remember a checkbox until it is switched on, because
     the only reason for remembering checkboxes in replaceCheckboxes is to 
     switch them OFF when another one gets switched ON. */
    [[self replaceCheckboxes] addObject:checkbox] ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkViewnessOfCheckboxNote:)
                                                 name:SSYReplacePredicateCheckboxWillGoAwayNotification
                                               object:nil] ;
    
    if ([checkbox state] == NSControlStateValueOn) {
        [self sendAction:[self action]
                      to:[self target]] ;        
    }
    
    [self updateReplaceAttributeKeyAndSeeIfRegex] ;
}

- (void)updateReplaceAttributeKeyAndSeeIfRegex {
    NSString* revisedReplaceAttributeKey = nil ;
    BOOL isRegex = NO ;
    for (SSYReplacePredicateCheckbox* checkbox in self.replaceCheckboxes) {
        if (checkbox.state == NSControlStateValueOn) {
            revisedReplaceAttributeKey = checkbox.attributeKey ;
            isRegex = checkbox.isRegex ;
        }
    }
    
    self.replaceAttributeKey = revisedReplaceAttributeKey ;
    self.replaceIsRegex = isRegex ;
}

- (void)checkViewnessOfCheckboxNote:(NSNotification*)note {
    SSYReplacePredicateCheckbox* checkbox = note.object ;
    if (checkbox.superview == nil) {
        [self.replaceCheckboxes removeObject:checkbox] ;
        [self updateReplaceAttributeKeyAndSeeIfRegex] ;
    }
}

- (void)viewDidMoveToWindow {
	[super viewDidMoveToWindow] ;
	
	if ([self isInitialized]) {
		return ;
	}
	
	[self setIsInitialized:YES] ;
	
    NSPredicateEditorRowTemplate* compoundTemplate = [[NSPredicateEditorRowTemplate alloc] initWithCompoundTypes:[NSArray arrayWithObjects:
                                                                                                                  [NSNumber numberWithInteger:NSAndPredicateType],
                                                                                                                  [NSNumber numberWithInteger:NSOrPredicateType],
                                                                                                                  [NSNumber numberWithInteger:NSNotPredicateType],
                                                                                                                  nil]] ;
    
	NSArray* rowTemplates = [NSArray arrayWithObject:compoundTemplate] ;
	[compoundTemplate release] ;
	NSArray* keyPaths = [NSArray arrayWithObjects:
						 constKeySharypeCoarse,
						 constKeyName,
						 constKeyTagsString,
						 constKeyUrl,
						 constKeyComments,
						 constKeyShortcut,
						 constKeyDontVerify,
						 constKeyIsAllowedDupe,
						 constKeyIsShared,
						 constKeyAddDate,
						 constKeyLastModifiedDate,
						 constKeyLastVisitedDate,
						 constKeySortable,
						 constKeyVerifierCode,
						 constKeyVerifierDisposition,
						 constKeyVerifierSubtype302,
						 constKeyVisitCount,
						 constKeyClients,
						 // constKeyVisitor,
						 nil] ;
	
	[self setAttributeKeyPaths:keyPaths] ;
	NSArray* keyTemplates = [self templates] ;
	
	rowTemplates = [rowTemplates arrayByAddingObjectsFromArray:keyTemplates] ;
	
	[self setRowTemplates:rowTemplates] ;
	
	// No vertical scrolling, we always want to show all rows
	[[self enclosingScrollView] setHasVerticalScroller:NO];
	
	// Set this to the number of rows initially showing
	[self setPreviousRowCount:2] ;
	[self addRow:self] ;  // IBAction method, sender=self

	// put the focus in the first text field
//    id displayValue = [[self displayValuesForRow:1] lastObject];
//    if ([displayValue isKindOfClass:[NSControl class]])
//		[[self window] makeFirstResponder:displayValue];
	
	// The following method sets the delegate OK and it stays set,
	// but delegate methods never get invoked.
	// [self setDelegate:self] ;
	// NSLog(@"12549: after setting delegate, %@", [self delegate]) ;

}

- (SSYReplacePredicateCheckbox*)activeReplaceCheckbox {
    SSYReplacePredicateCheckbox* answer = nil ;
    for (SSYReplacePredicateCheckbox* checkbox in [self replaceCheckboxes]) {
        if ([checkbox state] == NSControlStateValueOn) {
            answer = checkbox ;
            break ;
        }
    }
    
    return answer ;
}

- (NSPopUpButton*)attributePopupButton {
    /* Because NSPredicateRuleEditor gives us only access to the final predicate
     (which would be tedious to get the associated subpredicate, maybe
     impossible for complex compound predicates) and row *templates*, but not
     the actual rows themselves, we use a different, brute force method to
     determine the key and string value of the row which has the active
     'Replace' checkbox, which is to reverse-engineer its sibling views. */
    SSYReplacePredicateCheckbox* activeReplaceCheckbox = [self activeReplaceCheckbox] ;
    NSPopUpButton* attributePopupButton = nil ;
    for (NSView* sibling in [[activeReplaceCheckbox superview] subviews]) {
        if ([sibling isKindOfClass:[NSPopUpButton class]]) {
            CGFloat priorX = CGFLOAT_MAX ;
            if (attributePopupButton) {
                priorX = attributePopupButton.frame.origin.x ;
            }
            if (sibling.frame.origin.x < priorX) {
                attributePopupButton = (NSPopUpButton*)sibling ;
            }
        }
    }
    
    return attributePopupButton ;
}

- (NSString*)stringToBeReplaced {
    /* Because NSPredicateRuleEditor gives us only access to the final predicate
     (which would be tedious to get the associated subpredicate, maybe
     impossible for complex compound predicates) and row *templates*, but not
     the actual rows themselves, we use a different, brute force method to
     determine the key and string value of the row which has the active
     'Replace' checkbox, which is to reverse-engineer its sibling views. */
    SSYReplacePredicateCheckbox* activeReplaceCheckbox = [self activeReplaceCheckbox] ;
    NSString* stringToBeReplaced = nil ;
    for (NSView* sibling in [[activeReplaceCheckbox superview] subviews]) {
        if (![sibling isKindOfClass:[NSPopUpButton class]]) {
            if (!stringToBeReplaced) {
                stringToBeReplaced = [SSYReplacePredicateEditorRowTemplate anyEditableStringValueInView:sibling] ;
            }
        }
    }
    
    return stringToBeReplaced ;
}

/*
 None of the following four delegate methods ever get invoked
 - (id)ruleEditor:(NSRuleEditor *)editor
 child:(NSInteger)index
 forCriterion:(id)criterion
 withRowType:(NSRuleEditorRowType)rowType {
 NSLog(@"667 %s", __PRETTY_FUNCTION__) ;
 return nil ;
 }
 - (id)ruleEditor:(NSRuleEditor *)editor displayValueForCriterion:(id)criterion inRow:(NSInteger)row {
 NSLog(@"837 %s", __PRETTY_FUNCTION__) ;
 return nil ;
 }
 - (NSInteger)       ruleEditor:(NSRuleEditor *)editor
 numberOfChildrenForCriterion:(id)criterion
 withRowType:(NSRuleEditorRowType)rowType {
 NSLog(@"1054 %s", __PRETTY_FUNCTION__) ;
 return 0 ;
 }
 - (NSDictionary *)ruleEditor:(NSRuleEditor *)editor predicatePartsForCriterion:(id)criterion withDisplayValue:(id)value inRow:(NSInteger)row {
 NSLog(@"1264 %s", __PRETTY_FUNCTION__) ;
 return nil ;
 }
 
 - (NSInteger)numberOfRows {
 NSInteger N = [super numberOfRows] ;
 for (NSInteger i=0; i<N; i++) {
 NSLog(@"criteria for row %d: %@", i, [self criteriaForRow:i]) ;
 }
 NSLog(@"843: delegate = %@", [self delegate]) ;
 
 return N ;
 }
 
 + (void)logPredicateEditorRowTemplates:(NSArray*)rowTemplates {
 NSInteger i = 1 ;
 for (SSYReplacePredicateEditorRowTemplate* rowTemplate in rowTemplates) {
 NSLog(@"template %d of %d", i, [rowTemplates count]) ;
 if (![rowTemplate isKindOfClass:[NSPredicateEditorRowTemplate class]]) {
 NSLog(@"Internal Error 005-6290.  Wrong class %@", [rowTemplate class]) ;
 continue ;
 }
 
 NSLog(@"   pred: %@", [rowTemplate predicateWithSubpredicates:[NSArray array]]) ;
 NSAttributeType rightExpressionAttributeType = [rowTemplate rightExpressionAttributeType] ;
 CGFloat rightTextFieldMinimumWidth = 0.0 ;
 switch(rightExpressionAttributeType) {
 case NSInteger16AttributeType:
 case NSInteger32AttributeType:
 case NSInteger64AttributeType:
 case NSDecimalAttributeType:
 case NSDoubleAttributeType:
 case NSFloatAttributeType:
 rightTextFieldMinimumWidth = 50.0 ;
 break ;
 default:
 ;
 }
 NSView* lastTextField = nil ;
 for (NSView* view in [rowTemplate templateViews]) {
 NSLog(@"   view: %@", view) ;
 if ([view isKindOfClass:[NSTextField class]]) {
 NSLog(@"      text field size: %@", NSStringFromSize([view frame].size)) ;
 lastTextField = view ;
 }
 if ([view respondsToSelector:@selector(menu)]) {
 for (NSMenuItem* menuItem in [[view menu] itemArray]) {
 NSLog(@"      menuItem:") ;
 NSLog(@"            title: %@", [menuItem title]) ;
 NSLog(@"           repObj: %@ <%@>", [menuItem representedObject], [[menuItem representedObject] class]) ;
 }
 }
 }
 NSRect lastTextFieldFrame = [lastTextField frame] ;
 CGFloat lastTextFieldWidth = lastTextFieldFrame.size.width ;
 if (rightTextFieldMinimumWidth > lastTextFieldWidth) {
 lastTextFieldFrame.size.width = rightTextFieldMinimumWidth ;
 [lastTextField setFrame:lastTextFieldFrame] ;
 }
 for (NSExpression* expression in [rowTemplate leftExpressions]) {
 NSLog(@"   leftExp: %@", expression) ;
 }
 for (id operator in [rowTemplate operators]) {
 NSLog(@"   operator: %@", operator) ;
 }
 NSLog(@"   rightExpressionAttributeType: %d", rightExpressionAttributeType) ;
 for (NSExpression* expression in [rowTemplate rightExpressions]) {
 NSLog(@"   rightExp: %@", expression) ;
 }
 for (NSNumber* compoundType in [rowTemplate compoundTypes]) {
 NSLog(@"   compoundType: %@", compoundType) ;
 }
 NSLog(@"   modifier: %d", [rowTemplate modifier]) ;
 NSLog(@"    options: %d", [rowTemplate options]) ;
 i++ ;
 }
 }
 */

@end
