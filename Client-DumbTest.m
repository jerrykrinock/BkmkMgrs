#import "Client-DumbTest.h"

NSString* const BkmxExtoreWebFlatErrorDomain = @"BkmxExtoreWebFlatErrorDomain" ;

@implementation Client

@synthesize profileName = m_profileName ;
@synthesize serverPassword = m_serverPassword ;

- (NSString*)webHostName {
	return @"www.google.com" ;
}

@end
