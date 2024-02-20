#import <Cocoa/Cocoa.h>
#import "SSYIndexee.h"
#import "SSYManagedObject.h"

extern NSString* const constKeyMethod ;
extern NSString* const constKeyArgument ;

@class Syncer ;

@interface Command : SSYManagedObject <SSYIndexee> {
	// Managed object properties are declared in the data model, not here
}

+ (BOOL)doesImportMethodName:(NSString*)methodName ;
+ (BOOL)doesExportMethodName:(NSString*)methodName ;
+ (BOOL)does1MethodName:(NSString*)methodName ;

+ (NSInteger)severityWhenSettingMethodName:(NSString*)methodName ;

#pragma mark * Acccessors for non-managed object properties


#pragma mark * Core Data Generated Accessors for managed properties

// Attributes

/*!
 @brief    A selector name which can be converted into a selector
 on BkmxDoc using NSSelectorFromString()
 */
@property (copy) NSString* method ;

/*!
 @brief    A parameter which is passed to the receiver's action
 as its only argument, if any.&nbsp; Nil if the action does not
 have an argument.&nbsp;
 
 @details  Must be transformable by Core Data's default transformer.&nbsp; 
 */
@property (retain) id argument ;

// property 'index' is declared in protocol SSYIndexee

// Relationships

@property (retain) Syncer* syncer ;

/*!
 @brief    Checks to see that the receiver's arguments is one of the
 currently-available choices and, if not, sets it to an appropriate
 default value

 @details  Choices are only available if the receiver's method is
 constMethodPlaceholderImport1, constMethodPlaceholderImportAll,
 constMethodPlaceholderExport1 or constMethodPlaceholderExportAll,
 and also least one of its triggers has value BkmxTriggerScheduled.
*/
- (void)refreshArgument ;

@end
