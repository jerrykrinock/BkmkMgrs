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
@interface 
StarkPredicateEditor <SSYReplacePredicateEditorRowTemplateReplacer> : NSPredicateEditor {
	
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

- (SSYReplacePredicateCheckbox*)activeReplaceCheckbox ;
- (NSString*)stringToBeReplaced ;

@end
