#import <Cocoa/Cocoa.h>

#import "BkmxMigrationPolicy.h"

/*!
 @brief  Mapping model for Bkmx018 to Bkmx019 data models
 
 @details  In practice, this  class only affects migration of Stark_entity and
 Client_entity because, in Bkmx018_019.xcmappingmodel, only Stark_entity and
 Client_entity have their custom migration policy set (to
 Bkmx018_019MigrationPolicy).
 */
@interface Bkmx018_019MigrationPolicy : BkmxMigrationPolicy;

@end
