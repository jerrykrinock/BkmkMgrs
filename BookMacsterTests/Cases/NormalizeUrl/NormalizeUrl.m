#import "NSString+BkmxURLHelp.h"
#import <XCTest/XCTest.h>

@interface NormalizeUrlTest : XCTestCase

@end

@implementation NormalizeUrlTest

- (void)setUp {
    // Create data structures here.
}

- (void)tearDown {
    // Release data structures here.
}

- (void)testNormalizeUrl {
    NSError* error = nil ;
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSURL* urlsUrl = [bundle
                      URLForResource:@"Urls"
                      withExtension:@"txt"] ;
    NSString* urlsString = [NSString stringWithContentsOfURL:urlsUrl
                                                    encoding:NSUTF8StringEncoding
                                                       error:&error] ;
    XCTAssertTrue((urlsString != nil), @"Test bundle at path %@ does not contain the Urls.txt file at %@.",
                  bundle.bundlePath,
                  urlsUrl.path) ;
    NSArray* testStrings = [urlsString componentsSeparatedByString:@"\n"] ;
    NSMutableString* failures = [[NSMutableString alloc] init] ;
    NSInteger nPassed = 0 ;
    NSInteger nFailed = 0 ;
    BOOL isColumnHeaderLine = YES ;
    for (NSString* testString in testStrings) {
        if (isColumnHeaderLine) {
            isColumnHeaderLine = NO ;
        }
        else if ([testString length] == 0) {
            // Last URL in the file is followed by a blank line
            break ;
        }
        else {
            NSArray* comps = [testString componentsSeparatedByString:@"\t"] ;
            NSString* name = [comps objectAtIndex:0] ;
            NSString* urlRaw = [comps objectAtIndex:1] ;
            NSString* urlExpected = [comps objectAtIndex:2] ;
            
            NSString* urlActual = [urlRaw normalizedUrl] ;
            
            if ([urlExpected isEqualToString:urlActual]) {
                nPassed++ ;
            }
            else {
                ;
                nFailed++ ;
                [failures appendFormat:@"Error normalizing URL of %@\n   Expected %3ld chars: %@\n     Actual %3ld chars: %@\n",
                 name,
                 (long)[urlExpected length],
                 urlExpected,
                 (long)[urlActual length],
                 urlActual] ;
            }
        }
    }
    
    XCTAssertTrue([failures length] == 0, @"%@", failures) ;
    
    printf("\nSummary of URL Normalizing test:   %ld passed   %ld failed\n", (long)nPassed, (long)nFailed) ;
    NSLog(@"Done") ;
}

@end
