#import "StringCollectionTransformers.h"


 @interface NSData (Parsing)

- (NSArray*)componentsSeparatedByByte:(char)delimiter ;

@end

@implementation NSData (Parsing)

- (NSArray*)componentsSeparatedByByte:(char)delimiter {
	NSMutableArray* components = [[NSMutableArray alloc] init] ;
	NSUInteger length = [self length] ;
	char* whole = malloc(length) ;
	[self getBytes:whole
			length:length] ;
	NSInteger i = 0 ;
	NSInteger iLastDelimiter = -1 ;
    // Next line had bug fixed in BookMacster 1.13.16.  lastByte had been
    // initialized unconditionally to NO, which caused the reverse transformer
    // to return an empty array if receiver only had 1 byte, instead of an array
    // containing a single string with a single character.
	BOOL isLastByte = (length <= 1) ;
	while (i < length) {
		if ((whole[i] == delimiter) || isLastByte) {
			NSInteger delimiterSkip = isLastByte ? 0 : 1 ;
			NSInteger componentLength = i - iLastDelimiter - delimiterSkip ;
			NSData* component = [[NSData alloc] initWithBytes:&whole[iLastDelimiter+1]
													   length:componentLength] ;
			[components addObject:component] ;
			[component release] ;
			iLastDelimiter = i ;
		}
		i++ ;
		isLastByte = (i == (length-1)) ;
	}
	free(whole) ;
	
	NSArray* array = [components copy] ;
	[components release] ;
	return [array autorelease] ;
}

@end

static const char nullByte = 0x00 ;

@implementation TransformStringsSetToData

+ (Class)transformedValueClass {
    return [NSData class] ;
}

+ (BOOL)allowsReverseTransformation {
    return YES ;
}

- (id)transformedValue:(id)set {
	NSMutableData* data = [[NSMutableData alloc] init] ;
	NSUInteger nStrings = [set count] ;
	NSUInteger i = 0 ;
	for (NSString* string in set) {
		[data appendData:[string dataUsingEncoding:NSUTF8StringEncoding]] ;
		if (i < (nStrings-1)) {
			[data appendBytes:&nullByte
					   length:1] ;
		}
		i++ ;
	}				
	
	NSData* answer = [data copy] ;
	[data release] ;
	return [answer autorelease] ;
}

- (id)reverseTransformedValue:(id)data {
    NSArray* stringDatas = [data componentsSeparatedByByte:nullByte] ;
	NSMutableSet* set = [[NSMutableSet alloc] init] ;
	for (NSData* data in stringDatas) {
		NSString* string = [[NSString alloc] initWithData:data
												 encoding:NSUTF8StringEncoding] ;
		[set addObject:string] ;
        [string release] ;
	}
	
	NSSet* answer = [set copy] ;
	[set release] ;
	return [answer autorelease] ;
}

@end



@implementation TransformStringsArrayToData

+ (Class)transformedValueClass {
    return [NSData class] ;
}

+ (BOOL)allowsReverseTransformation {
    return YES ;
}

- (id)transformedValue:(id)array {
	NSMutableData* data = [[NSMutableData alloc] init] ;
	NSUInteger nStrings = [array count] ;
	NSUInteger i = 0 ;
	for (NSString* string in array) {
		[data appendData:[string dataUsingEncoding:NSUTF8StringEncoding]] ;
		if (i < (nStrings-1)) {
			[data appendBytes:&nullByte
					   length:1] ;
		}
		i++ ;
	}				
	
	NSData* answer = [data copy] ;
	[data release] ;
	return [answer autorelease] ;
}

- (id)reverseTransformedValue:(id)data {
    NSArray* stringDatas = [data componentsSeparatedByByte:nullByte] ;
	NSMutableArray* array = [[NSMutableArray alloc] init] ;
	for (NSData* data in stringDatas) {
		NSString* string = [[NSString alloc] initWithData:data
												 encoding:NSUTF8StringEncoding] ;
		if (string) {
			[array addObject:string] ;
		}
        [string release] ;
	}
	
	NSArray* answer = [array copy] ;
	[array release] ;
	return [answer autorelease] ;
}

@end
