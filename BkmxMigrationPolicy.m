#import "BkmxMigrationPolicy.h"
#import "NSError+InfoAccess.h"
#import "NSError+MyDomain.h"
#import "NSEntityDescription+SSYMavericksBugFix.h"

/* For examples of even more wild and crazy things you can do during a
 migration, unzip and look in this project's folder for:
     Sample Migration Policy.zip
 */

/*!
 @brief   Superclass for my Core Data migrations, which has a handy utility
 method
 */
@implementation BkmxMigrationPolicy

/*!
 @details It seems like Apple should provide this.
 */
- (NSString*)mappingNameForEntityName:(NSString*) entityName {
    return [NSString stringWithFormat:@"%@To%@",
            entityName,
            entityName];
}

- (NSString*)valueFromSingularEntity:(NSString*)entityName
								 key:(NSString*)key 
					migrationManager:(NSMigrationManager*)inManager
							 error_p:(NSError**)error_p {
	NSError* error = nil ;
	NSManagedObjectContext* sourceContext = [inManager sourceContext] ;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
	NSArray* fetchResults ;
	NSEntityDescription* entity = [NSEntityDescription SSY_entityForName:entityName
                                                  inManagedObjectContext:sourceContext] ;
	[fetchRequest setEntity:entity];
	fetchResults = [sourceContext executeFetchRequest:fetchRequest
												error:&error] ;
	[fetchRequest release] ;
	NSInteger n = [fetchResults count] ;
	
	// Handle any errors that occurred in fetch
	NSString* msg ;
	if (error) {
		msg = [NSString stringWithFormat:@"Error in migration, finding singular %@",
			   entityName] ;
		error = [SSYMakeError(451864, msg) errorByAddingUnderlyingError:error] ;
		
	}
	else if (n > 1) {
		msg = [NSString stringWithFormat:@"Corrupt? Trouble ahead! Found %ld %@:\n%@",
			   (long)n,
			   entityName,
			   fetchResults] ;
		error = SSYMakeError(451865, msg) ;
	}
	else if (!fetchResults || n == 0) {
		msg = [NSString stringWithFormat:@"No %@ found in moc %@.  (May be OK if this is not a document moc).",
			   entityName,
			   sourceContext] ;
		error = SSYMakeError(451866, msg) ;
	}
	
	// Extract the key from the singular object
	NSString* answer = nil ;
	if ((fetchResults != nil) && (n > 0) && (error== nil)) {
		NSManagedObject* object = [fetchResults objectAtIndex:0] ;
		answer = [object valueForKey:key] ;
	}

	if (error_p) {
		*error_p = error ;
	}
	
	return answer ;
}

@end
