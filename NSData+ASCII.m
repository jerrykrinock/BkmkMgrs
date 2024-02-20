#import "NSData+ASCII.h"


@implementation NSData (ASCII)

- (NSString*)asciiReadable {
	NSString* s = [[NSString alloc] initWithBytes:[self bytes]
										   length:[self length]
										 encoding:NSMacOSRomanStringEncoding] ;
	
	NSMutableString* ms = [s mutableCopy] ;
	[s release] ;
	[ms replaceOccurrencesOfString:@"\x0a"
						withString:@"-"
						   options:0
							 range:NSMakeRange(0, [ms length])] ;
	[ms replaceOccurrencesOfString:@"\x0d"
						withString:@"-"
						   options:0
							 range:NSMakeRange(0, [ms length])] ;
	[ms replaceOccurrencesOfString:@"\x09"
						withString:@"-"
						   options:0
							 range:NSMakeRange(0, [ms length])] ;
	
	s = [ms copy] ;
	[ms release] ;
	
	return [s autorelease] ;
}

@end
