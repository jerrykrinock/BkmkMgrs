#import "Starkoid.h"
#import "BkmxGlobals.h"
#import "NSString+LocalizeSSY.h"
#import "NSString+SSYExtraUtils.h"
#import "NSNumber+SharypeCoarseDisplay.h"
#import "NSNumber+ChangeTypesSymbols.h"
#import "NSObject+DoNil.h"


NSString* const constKeyLineage = @"lineage" ;
NSString* const constKeyChangeType = @"changeType" ;
NSString* const constKeyFromDisplayName = @"fromDisplayName" ;

// This is to upgrade diaries prior to BookMacster 1.5.7.
// This @interface can be removed in, oh, August 2011
// after old diaries have been flushed out.
@interface Starkoid (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber *)primitiveChangeType;
- (void)setPrimitiveChangeType:(NSNumber *)value;

@end


@implementation Starkoid

@dynamic changeType ;
@dynamic sharypeCoarse ;
@dynamic lineage ;
@dynamic updateDescriptions ;
@dynamic fromDisplayName ;

/*!
 @details  Bound to by user interface Sync Logs table
*/
- (NSString*)sharypeCoarseDisplayName {
	return [[self sharypeCoarse] sharypeCoarseDisplayName] ;
}
+ (NSSet*)keyPathsForValuesAffectingSharypeCoarseDisplayName {
	return [NSSet setWithObjects:
			constKeySharypeCoarse,
			nil] ;
}


/*!
 @details  Bound to by user interface Sync Logs table
 */
- (NSString*)changeTypeDisplaySymbol {
	return [[self changeType] changeTypeDisplaySymbol] ;
}
+ (NSSet*)keyPathsForValuesAffectingChangeTypeDisplaySymbol {
	return [NSSet setWithObjects:
			constKeyChangeType,
			nil] ;
}


- (NSString*)lineageAndUpdates {
	NSString* fromClause ;
	NSString* fromDisplayName = [self fromDisplayName] ;
	if (fromDisplayName) {
		// This Starkoid is the result of an Import
		fromClause = [NSString stringWithFormat:
					  @"  (%@)",
					  [NSString localizeFormat:
					   @"fromX",
					   fromDisplayName]] ;
	}
	else {
		// This Starkoid is the result of an Export
		fromClause = @"" ;
	}
	NSMutableString* mutableAnswer = [[NSMutableString alloc] initWithFormat:
									  @"%@%@",
									  [self lineage],
									  fromClause] ;
	for (NSString* updateDescription in [self updateDescriptions]) {
		[mutableAnswer appendFormat:@"\n    %@", updateDescription] ;
	}
	
	NSString* answer = [mutableAnswer copy] ;
	[mutableAnswer release] ;
	return [answer autorelease] ;
}

- (NSInteger)numberOfSubrows {
	NSInteger numberOfLinesInUpdateDescriptions = 0 ;
	for (NSString* update in [self updateDescriptions]) {
		numberOfLinesInUpdateDescriptions += [update numberOfLinesCountTrailer:YES] ;
	}
	NSInteger answer = (1 + numberOfLinesInUpdateDescriptions) ;
	// The "1" is for the first line, the lineage.
	return answer ;
}

- (BOOL)isInEssence:(Starkoid*)other {

	if (![NSObject isEqualHandlesNilObject1:[self changeType]
									object2:[other changeType]]) {
		return NO ;
	}

	if (![NSObject isEqualHandlesNilObject1:[self sharypeCoarse]
									object2:[other sharypeCoarse]]) {
		return NO ;
	}
	
	if (![NSString isEqualHandlesNilObject1:[self lineage]
									object2:[other lineage]]) {
		return NO ;
	}
	
	if (![NSArray isEqualHandlesNilObject1:[self updateDescriptions]
									object2:[other updateDescriptions]]) {
		return NO ;
	}
	
	return YES ;
}

@end