#import "Bkmx018_019MigrationPolicy.h"
#import <Bkmxwork/Bkmxwork-Swift.h>

#import "BkmxGlobals.h"
#import "Client+SpecialOptions.h"
#import "NSError+MyDomain.h"
#import "NSError+InfoAccess.h"
#import "NSNumber+SomeMore.h"
#import "Ixporter.h"


/*
 TIPS ON HOW TO WRITE A NEW MIGRATION
 
 • Remember that, for a entity to be migrated with code in, for example,
 Bkmx018_019MigrationPolicy, in the attributes of that entity in the
 relevant .xcmappingmodel, you must set the Custom Migration Policy to,
 continuing the example: Bkmx018_019MigrationPolicy.
 
 • For examples of even more wild and crazy things you can do during a
 migration, unzip and look at
 /Users/jk/Documents/Programming/Projects/BkmkMgrs/Sample Migration Policy.zip
 
 */


@implementation Bkmx018_019MigrationPolicy

/*
 @brief    Override for a method which creates new instances
 and migrates attributes, during migrations from version
 018 to 019, supporting the more complex entity mappings which
 could not be expressed in the .xcmappingmodel file.
 
 @details  For all entities except Client_entity and Stark_entity, this method
 simply invokes super.  (But actually this method never gets invoked for the
 other entities because, in the Bkmx018_019.xcmappingmodel, only Client_entity
 and Stark_entity and have their custom migration policy set to
 Bkmx018_019MigrationPolicy.)
 
 Note that the plural "DestinationInstances" in this method's
 name does not imply that we're necessarily one to many.
 In fact this method is also used for simple attributes.
 They mean "DestinationInstance(s)".
 */
- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject*)oldInstance
                                      entityMapping:(NSEntityMapping*)inMapping
                                            manager:(NSMigrationManager*)inManager
                                              error:(NSError**)error_p {
    NSError* error = nil;
    BOOL ok = [super createDestinationInstancesForSourceInstance:oldInstance
                                                   entityMapping:inMapping
                                                         manager:inManager
                                                           error:&error];
    NSEntityDescription *sourceInstanceEntity = [oldInstance entity] ;
    NSString* sourceInstanceEntityName = [sourceInstanceEntity name] ;
    if ([sourceInstanceEntityName isEqualToString:constEntityNameClient]) {
        if (ok) {
            NSString* mappingName = [self mappingNameForEntityName:constEntityNameClient];
            NSManagedObject* newInstance = [[inManager destinationInstancesForEntityMappingNamed:mappingName
                                                                                sourceInstances:@[oldInstance]] firstObject];
            /* Since oldInstance is an NSManagedObject, we cannot use Client
             instance methods.  So we get the value using -[NSMAnagedObject valueForKey:]
             and then use a Client class method in three places to get the mask. */
            long long rawValue = [[oldInstance valueForKey:constKeySpecialOptions] longLongValue];
            
            long long oldDigitalValue;
            double newDoubleValue;
            
            /* Migrate httpRateInitial from specialOptions to specialDouble0 */
            oldDigitalValue = [Client specialOptionsValueForMask:constBkmxIxportSpecialOptionBitmaskHttpRateInitial
                                                           value:rawValue];
            switch (oldDigitalValue) {
                case 0:
                    newDoubleValue = 0.5 ;
                    break ;
                case 1:
                    newDoubleValue = 1.0 ;
                    break ;
                case 2:
                    newDoubleValue = 2.0 ;
                    break ;
                default:
                    newDoubleValue = 5.0 ;
                    break ;
            }
            [newInstance setValue:@(newDoubleValue)
                           forKey:@"specialDouble0"];

            /* Migrate httpRateRest from specialOptions to specialDouble1 */
            oldDigitalValue = [Client specialOptionsValueForMask:constBkmxIxportSpecialOptionBitmaskHttpRateRest
                                                           value:rawValue];
            switch (oldDigitalValue) {
                case 0:
                    newDoubleValue = 15.0 ;   // 15 seconds
                    break ;
                case 1:
                    newDoubleValue = 60.0 ;   // 1 minute
                    break ;
                case 2:
                    newDoubleValue = 300.0 ;  // 5 minutes
                    break ;
                case 3:
                    newDoubleValue = 900.0 ;  // 15 minutes
                    break ;
                case 4:
                    newDoubleValue = 1800.0 ;  // 30 minutes
                    break ;
                case 5:
                    newDoubleValue = 3600.0 ;  // 1 hour
                    break ;
                case 6:
                    newDoubleValue = 7200.0 ;  // 2 hours
                    break ;
                default:
                    newDoubleValue = 14400.0 ; // 4 hours
                    break ;
            }
            [newInstance setValue:@(newDoubleValue)
                           forKey:@"specialDouble1"];

            /* Migrate httpRateBackoff from specialOptions to specialDouble2 */
            oldDigitalValue = [Client specialOptionsValueForMask:constBkmxIxportSpecialOptionBitmaskHttpRateBackoff
                                                           value:rawValue];
            switch (oldDigitalValue) {
                case 0:
                    newDoubleValue = 1.0 ;
                    break ;
                case 1:
                    newDoubleValue = 1.1 ;
                    break ;
                case 2:
                    newDoubleValue = 1.5 ;
                    break ;
                default:
                    newDoubleValue = 2.0 ;
                    break ;
            }
            [newInstance setValue:@(newDoubleValue)
                           forKey:@"specialDouble2"];
        }
        else {
            ok = NO ;
            NSString* msg = [NSString stringWithFormat:
                             @"Problem migrating %@",
                             oldInstance] ;
            error = [SSYMakeError(148874, msg) errorByAddingUnderlyingError:error] ;
        }
    } else if ([sourceInstanceEntityName isEqualToString:constEntityNameStark]) {
        if (ok) {
            NSManagedObject* newInstance = [[inManager destinationInstancesForEntityMappingNamed:@"Stark_entityToStark_entity"
                                                                                 sourceInstances:@[oldInstance]] firstObject];
            NSArray* tagsArray = [oldInstance valueForKey:constKeyTags];
            for (NSString* tagString in tagsArray) {
                NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:constEntityNameTag];
                fetchRequest.predicate = [NSPredicate predicateWithFormat:@"string like[cd] %@", tagString];
                Tag* tag = [[inManager.destinationContext executeFetchRequest:fetchRequest
                                                                        error:&error] firstObject];
                if (error != nil) {
                    error = [error errorByAddingUserInfoObject:tagString
                                                        forKey:@"Attempted tag string"];
                    error = [error errorByAddingUserInfoObject:[oldInstance valueForKey:constKeyName]
                                                        forKey:@"Stark name"];
                    ok = NO;
                    break;
                }

                if (tag == nil) {
                    tag = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameTag
                                                        inManagedObjectContext:inManager.destinationContext];
                    [tag setValue:tagString
                           forKey:constKeyString];
                }

                [tag addStarksObject:(Stark*)newInstance];
                /* Since the tags in the old array we are enumerating are
                 ordered, the new tags in newInstance should have the
                 same order (I hope). */
                [(Stark*)newInstance addTagsObject:tag];
            }
        }
    } else if ([sourceInstanceEntityName isEqualToString:constEntityNameImporter]) {
       if (ok) {
            NSManagedObject* newInstance = [[inManager destinationInstancesForEntityMappingNamed:@"Importer_entityToImporter_entity"
                                                                                sourceInstances:@[oldInstance]] firstObject];
           [newInstance setValue:[oldInstance valueForKey:@"mergeStark"]
                          forKey:constKeyMergeBias];
           NSNumber* oldMergeBy = [oldInstance valueForKey:@"mergeUrl"];
           if (!oldMergeBy) {
               /* Strange.  Old data does not have a mergeUrl value.
                Set it to the old default value. */
               oldMergeBy = @1;
           }
           [newInstance setValue:[oldMergeBy plus1]
                          forKey:constKeyMergeBy];
        }
    } else if ([sourceInstanceEntityName isEqualToString:constEntityNameExporter]) {
        if (ok) {
            NSManagedObject* newInstance = [[inManager destinationInstancesForEntityMappingNamed:@"Exporter_entityToExporter_entity"
                                                                                sourceInstances:@[oldInstance]] firstObject];
            [newInstance setValue:[oldInstance valueForKey:@"mergeStark"]
                           forKey:constKeyMergeBias];
            [newInstance setValue:[[oldInstance valueForKey:@"mergeUrl"] plus1]
                           forKey:constKeyMergeBy];
        }
    }

    if (error && error_p) {
        *error_p = error ;
    }
    
    return ok ;
}


/*!
 @brief    Converts colors archived as data with old NSArchiver method to
 secure archive.  This method is "called" from
 Bkmx018_019.xcmappingmodel > Stark_entityToStark_entity > Attributes > color > Value Expression.
*/
- (NSData*)secureColorArchiveFromOldColorArchive:(NSData*)oldData {
    NSColor* color = nil;
    NSData* newData = nil;
    if (oldData) {
        @try {
            // Sorry, Apple: Need to get old color with deprecated method
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            color = (NSColor*)[NSUnarchiver unarchiveObjectWithData:oldData] ;
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
        } @catch (NSException *exception) {
            NSLog(@"Exception upgrading color in Core Data store, which was expected to be produced by +[NSArchiver archivedDataWithRootObject:]");
        }
    }
    if (color) {
        NSError* error = nil;
        newData = [NSKeyedArchiver archivedDataWithRootObject:color
                                        requiringSecureCoding:YES
                                                        error:&error];
        if (error) {
            NSLog(@"Internal error 382-8370 archiving color in Core Data store.");
        }
    }
    
    return newData;
}

@end
