#import "IxportLog.h"
#import "BkmxBasis+Strings.h"

NSString* const constKeySerialNumber = @"serialNumber" ;
NSString* const constKeyStarkoids = @"starkoids" ;

@interface IxportLog (CoreDataGeneratedPrimitiveAccessors)

- (NSMutableSet*)primitiveStarkoids;
- (void)setPrimitiveStarkoids:(NSMutableSet*)value;

@end

@implementation IxportLog

@dynamic displayStatistics ;
@dynamic errorCode ;
@dynamic starkoids ;
@dynamic serialNumber ;
@dynamic whoDo ;

- (NSString*)title {
	NSInteger errorCode = [[self errorCode] longValue] ;
	NSString* statsString ;
	if ((errorCode == constBkmxErrorNone) || (errorCode == constBkmxErrorIsTestRun)) {
		statsString = [NSString stringWithFormat:@" (%@)", [self displayStatistics]] ;
	}
	else {
		statsString = @"" ;
	}
	return [NSString stringWithFormat:
			@"#%@ %@  %@",
			[self serialNumber],
			[self formattedDate],
			statsString] ;
}
+ (NSSet*)keyPathsForValuesAffectingTitle {
	return [NSSet setWithObjects:
			@"errorCode",
			@"serialNumber",
			@"displayStatistics",
			@"formattedDate",
			nil] ;
}

- (void)addStarkoidsObject:(Starkoid*)value {    
	//[self postWillSetNewStarkoids:[[self starkoids] setByAddingObject:value]] ;
	
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyStarkoids withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveStarkoids] addObject:value];
    [self didChangeValueForKey:constKeyStarkoids withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release] ;
}

@end