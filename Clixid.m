#import "Clixid.h"
#import "NSObject+MoreDescriptions.h"
#import "Starxid.h"
#import "NSManagedObjectContext+Cheats.h"

@implementation Clixid

@dynamic exid ;
@dynamic starxid ;
@dynamic clidentifier ;

- (NSString*)shortDescription {
	return [NSString stringWithFormat:@"<Clixid %p> clid=%@ stid=%@ exid=%@ isF=%ld isD=%ld owr=%@ mocStor=%@",
			self,
			[self clidentifier],
			[[self starxid] starkid],
			[self exid],
			(long)[self isFault],
			(long)[self isDeleted],
			[self owner],
			[[[self managedObjectContext] store1] longDescription]
			] ;
}

@end

