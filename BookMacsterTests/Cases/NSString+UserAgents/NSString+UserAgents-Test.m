#import "NSString+UserAgents-Test.h"
#import "NSString+UserAgents.h"

@implementation TestNSString_UserAgents

- (void)setUp {
    // Create data structures here.
}

- (void)tearDown {
    // Release data structures here.
}

- (void)testNSString_UserAgents {
	NSString* uaString ;
	NSString* name ;
	
	uaString = @"" ;
	name = [uaString browserNameFromUserAgentStringAmongCandidates:nil] ;
	STAssertTrue(name == nil, @"Failed empty string") ;
    
	uaString = @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en; rv:1.9.0.16pre) Gecko/2009113000 Camino/2.1a1pre (like Firefox/3.0.16pre)" ;
	name = [uaString browserNameFromUserAgentStringAmongCandidates:nil] ;
	STAssertTrue([name isEqualToString:@"Camino"], @"Failed ") ;
	
	uaString = @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.7) Gecko/20091221 Firefox/3.5.7" ;
	name = [uaString browserNameFromUserAgentStringAmongCandidates:nil] ;
	STAssertTrue([name isEqualToString:@"Firefox"], @"Failed ") ;
    
	uaString = @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.3a2pre) Gecko/20100214 Minefield/3.7a2pre" ;
	name = [uaString browserNameFromUserAgentStringAmongCandidates:nil] ;
	STAssertTrue([name isEqualToString:@"Minefield"], @"Failed ") ;
    
	uaString = @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; en-US) AppleWebKit/531.9+(KHTML, like Gecko, Safari/528.16) OmniWeb/v622.11.0" ;
	name = [uaString browserNameFromUserAgentStringAmongCandidates:nil] ;
	STAssertTrue([name isEqualToString:@"OmniWeb"], @"Failed ") ;
    
	uaString = @"Opera/9.80 (Macintosh; Intel Mac OS X; U; en) Presto/2.2.15 Version/10.10" ;
	name = [uaString browserNameFromUserAgentStringAmongCandidates:nil] ;
	STAssertTrue([name isEqualToString:@"Opera"], @"Failed ") ;
    
	uaString = @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; en-us) AppleWebKit/531.21.8 (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10" ;
	name = [uaString browserNameFromUserAgentStringAmongCandidates:nil] ;
	STAssertTrue([name isEqualToString:@"Safari"], @"Failed ") ;
	
}

@end
