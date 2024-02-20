#import "ChromeDigesterHelpers.h"
#import "SSYDigester.h"

@implementation NSDictionary (ChromeDigester)

/* See file ChromeChecksum.cpp to learn how I learned what to hash. */
- (void)updateChromeDigester:(SSYDigester*)digester {
	NSString* type = [self objectForKey:@"type"] ;
	if ([type isEqualToString:@"url"]) {
		[digester updateWithString:[self objectForKey:@"id"]
						  encoding:NSASCIIStringEncoding] ;
		[digester updateWithString:[self objectForKey:@"name"]
						  encoding:NSUnicodeStringEncoding] ;
		[digester updateWithString:type
						  encoding:NSASCIIStringEncoding] ;
		// They also update the digest with the type string.
		[digester updateWithString:[self objectForKey:@"url"]
						  encoding:NSASCIIStringEncoding] ;
	}
	if ([type isEqualToString:@"folder"]) {
		[digester updateWithString:[self objectForKey:@"id"]
						  encoding:NSASCIIStringEncoding] ;
		[digester updateWithString:[self objectForKey:@"name"]
						  encoding:NSUnicodeStringEncoding] ;
		// They also update the digest with the type string.
		[digester updateWithString:type
						  encoding:NSASCIIStringEncoding] ;
	}
}

@end

@implementation NSString (ChromeDigester)

- (void)updateChromeDigester:(SSYDigester*)digester {
		[digester updateWithString:self
						  encoding:NSASCIIStringEncoding] ;
}

@end

