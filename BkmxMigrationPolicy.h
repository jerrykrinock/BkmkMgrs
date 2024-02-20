#import <Cocoa/Cocoa.h>


/*!
 @brief    Adds some handy utilities to NSEntityMigrationPolicy

 @details  
*/
@interface BkmxMigrationPolicy : NSEntityMigrationPolicy {

}

- (NSString*)mappingNameForEntityName:(NSString*) entityName;

- (NSString*)valueFromSingularEntity:(NSString*)entityName
								 key:(NSString*)key 
					migrationManager:(NSMigrationManager*)inManager
							 error_p:(NSError**)error_p ;

@end
