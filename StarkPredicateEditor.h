#import <Cocoa/Cocoa.h>

@class SSYReplacePredicateEditorRowTemplate ;
@class SSYReplacePredicateCheckbox ;

/*!
 @brief    Subclass of NSPredicateEditor for BkmkMgrs project, although the
 dependencies on my project could an should easily be moved into delegate
 methods or something, and I should move this into my open source

 @details  Tip: To access the predicate in an NSPredicateEditor,
 send the message -objectValue.
*/
@interface StarkPredicateEditor <SSYReplacePredicateEditorRowTemplateReplacer> : NSPredicateEditor {
	
	NSInteger previousRowCount ;
	BOOL isInitialized ;
	NSArray* attributeKeyPaths ;
    NSMutableSet* _replaceCheckboxes ;
}

@property NSInteger previousRowCount ;

/*!
 @brief    Make this YES to remove the annoying behavior of NSPredicateEditor
 of removing all findings upon initially adding a row because it requires
 that foo = ""
 */
@property BOOL ignoreEmptyStrings ;

@property (copy) NSString* replaceAttributeKey ;
@property (readonly) BOOL replaceIsRegex ;

- (NSInteger)itemIndexForAttributeKeyPath:(NSString*)keyPath ;

- (NSInteger)itemIndexOfOperator:(id)operator
                   attributeType:(NSAttributeType)attributeType ;

/*!
 @brief    Adds a "compound" row (<Any/All/None> of the following are true)
 to the receiver with its controls pre-set to given values.
 
 @details  The row is added appended as the last row.&nbsp;  If this appended row
 is not under the specified parentRow, or if there is another parent row between
 the specified parentRow and the appended row, an exception will be raised and this
 method will fail.&nbsp;  To avoid this, add rows by first removing all rows
 and then start at the top and work down.
 
 @param    predicateType  The value that the single popup menu in the row
 should be set to.&nbsp;   Should be one of:
 *  NSAndPredicateType
 *  NSOrPredicateType
 *  NSNotPredicateType
 @param    parentRow  The parent to which the new row should be
 made a child, or -1 to add a root row.
 */
- (void)addCompoundRowPresetToPredicateType:(NSCompoundPredicateType)predicateType
							  asSubrowOfRow:(NSInteger)parentRow ;

/*!
 @brief    Adds a "simple" row (<attribute> <operator> <value>) to the
 receiver with its controls pre-set to given values.
 
 @details  The row is added appended as the last row.&nbsp;  If this appended row
 is not under the specified parentRow, or if there is another parent row between
 the specified parentRow and the appended row, an exception will be raised and this
 method wil fail.&nbsp;  To avoid this, add rows by first removing all rows
 and then start at the top and work down.
 
 The receiver must have previously had its templates set by
 executing -viewDidMoveToWindow
 @param    attributeKey  The left attribute to which the left
 popup menu will be set.
 @param    hasOperator  Pass YES to place a popup menu as the middle control
 in the row, NO if the middle control should be static text, , which will be the
 case if the attribute type of attributeKey is NSAttributeTypeBoolean.  Besides
 bypassing the setting of the middle control, this is also necessary to
 identify the correct right-hand control.
 @param    operatorType  The operator type to which the middle popup
 will be set.  Ignored if hasOperator is NO.
 @param    parentRow  The parent to which the new row should be
 made a child, or -1 to add a root row.
 @param    targetValue   The  target value to which the right-hand 
 control will be set.&nbsp;  If the right-hand control is a popup menu, pass
 the representedObject of a menu item in the right-popup template for the
 pertinent attribute type.&nbsp;  If the right-hand control is a text field,
 pass a string.
 */
- (void)addSimpleRowPresetToAttributeKey:(NSString*)attributeKey
                             hasOperator:(BOOL)hasOperator
							operatorType:(NSPredicateOperatorType)operatorType
						   asSubrowOfRow:(NSInteger)parentRow
							 targetValue:(id)targetValue ;


- (SSYReplacePredicateCheckbox*)activeReplaceCheckbox ;
- (NSString*)stringToBeReplaced ;

@end
