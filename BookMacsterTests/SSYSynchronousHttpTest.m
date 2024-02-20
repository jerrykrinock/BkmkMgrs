#import <XCTest/XCTest.h>
#import "SSYSynchronousHttp.h"
#import "SSYKeychain.h"

@interface SSYSynchronousHttpTest : XCTestCase

@end

@implementation SSYSynchronousHttpTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

//- (void)testExample {
//    // This is an example of a functional test case.
//    // Use XCTAssert and related functions to verify your tests produce the correct results.
//}
//
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}
//
- (void)testIt {
    NSString* tempDir = NSTemporaryDirectory();
    NSLog(@"Will write all received data to directory %@ in case it is needed for troubleshooting", tempDir);
    
    // Basic example
    [self testUrlString:@"https://example.com/"
               username:nil
               password:nil
   expectedMinimumBytes:500
     expectedStatusCode:200
      expectedErrorCode:0
                writeTo:tempDir];
    
    // Test handling authentication challenge
    /* Test by connecting to a server which has an API that uses simple
     HTTP Basic Authentication.  I use the service "pinboard.in". */
    NSString* username = @"jerrykrinock";
    NSError* err = nil;
    NSString* password = [SSYKeychain passwordForServost:@"pinboard.in"
                                             trySubhosts:nil
                                                 account:username
                                                   clase:(NSString*)kSecClassInternetPassword
                                                 error_p:&err];
    [self testUrlString:@"https://api.pinboard.in/v1/posts/update/"
               username:username
               password:password
   expectedMinimumBytes:40
     expectedStatusCode:200
      expectedErrorCode:0
                writeTo:tempDir];

    // Test handling a redirect
    [self testUrlString:@"http://bravebrowser.com/" // redirect --> https://brave.com
               username:nil
               password:nil
   expectedMinimumBytes:10
     expectedStatusCode:200
      expectedErrorCode:0
                writeTo:tempDir];
}

- (void)testUrlString:(NSString*)urlString
             username:(NSString*)username
             password:(NSString*)password
 expectedMinimumBytes:(NSInteger)expectedMinimumBytes
   expectedStatusCode:(NSInteger)expectedStatusCode
    expectedErrorCode:(NSInteger)expectedErrorCode
              writeTo:(NSString*)outputDir {
    NSTimeInterval timeout = 7.0;
    
    NSHTTPURLResponse* response = nil;
    NSData* data = nil;
    NSError* error = nil;
    
    NSLog(@"Testing load from %@", urlString);
    BOOL ok = [SSYSynchronousHttp SSYSynchronousHttpUrl:urlString
                                             httpMethod:@"GET"
                                                headers:nil
                                             bodyString:nil
                                               username:username
                                               password:password
                                                timeout:timeout
                                              userAgent:nil
                                             response_p:&response
                                          receiveData_p:&data
                                                error_p:&error];
    NSLog(@"   Received %ld bytes with response status code %ld", (long)[data length], response.statusCode) ;
    if (ok) {
        NSLog(@"   Request succeeded") ;
    }
    else {
        NSLog(@"   Error %ld : %@",
              (long)[error code],
              [error localizedDescription]);
    }
    
    /* Write data to a file in case it is needed for troubleshooting. */
    if ([data length] > 0) {
        NSMutableString* basename = [urlString mutableCopy];
        [basename replaceOccurrencesOfString:@"/"
                                  withString:@"+"
                                     options:0
                                       range:NSMakeRange(0, basename.length)];
        [basename replaceOccurrencesOfString:@":"
                                  withString:@";"
                                     options:0
                                       range:NSMakeRange(0, basename.length)];
        NSString* filename = [basename stringByAppendingPathExtension:@"txt"];
        NSString* path = [outputDir stringByAppendingPathComponent:filename];
        [data writeToFile:path
                  options:0
                    error:NULL] ;
    }
    
    XCTAssertTrue(response.statusCode == expectedStatusCode);
    XCTAssertTrue(data.length > expectedMinimumBytes);
    XCTAssertTrue(error.code == expectedErrorCode);
}

@end
