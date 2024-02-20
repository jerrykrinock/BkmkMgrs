#import "TalderMapProto.h"
#import "Stark.h"

@implementation TalderMapProto

@synthesize folder = m_folder ;
@synthesize tag = m_tag ;
@synthesize polarity = m_polarity ;

- (NSString*)description {
    return [NSString stringWithFormat:
            @"<%@: %p %@=%@ %@ to %@",
            [self className],
            self,
            [self polarity],
            ([[self polarity] boolValue] == BkmxIxportPolarityImport) ? @"Im" : @"Ex",
            [self tag],
            [(Stark*)[self folder] name]] ;
}

- (id)copyWithZone:(NSZone *)zone {
    TalderMapProto* copy = [[TalderMapProto allocWithZone: zone] init] ;
	[copy setPolarity:[self polarity]] ;
	[copy setTag:[self tag]] ;
	[copy setFolder:[self folder]] ;
	
    return copy ;
}

- (void)dealloc {
    [m_folder release] ;
    [m_tag release] ;
    [m_polarity release] ;
    
    [super dealloc] ;
}

@end
