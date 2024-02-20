#warning Compiling with SheepSafariHelperRepeatTester.  Do not ship.

#import "SheepSafariHelperRepeatTester.h"
#import "ExtoreSafari.h"
#import "Clientoid.h"
#import "BkmxGlobals.h"
#import "Job.h"

@implementation SheepSafariHelperRepeatTester

+ (void)testForJobSerial:(NSInteger)jobSerial {
    __block Extore* extore = nil;
    NSError* hashCheckError = nil;
    Clientoid* clientoid = [Clientoid clientoidThisUserWithExformat:constExformatSafari
                                                        profileName:nil];
    extore = [Extore extoreForIxporter:nil
                             clientoid:clientoid
                             jobSerial:jobSerial
                               error_p:&hashCheckError];
    [extore determineYourIxportStyleError_p:NULL];
    /* Use __weak per Apple Documentation >
     Programming With Objective-C >
     Working with Blocks >
     Avoid Strong Reference Cycles when Capturing self */
    Extore* __weak weakExtore = extore;
    [extore readExternalUsingCurrentStyleWithPolarity:BkmxIxportPolarityImport
                                            jobSerial:jobSerial
                                    completionHandler:^void() {
                                        @autoreleasepool {
                                            NSError* error = [weakExtore error];
                                            NSString* verdict = nil;
                                            if (error) {
                                                verdict = [[[NSString alloc] initWithFormat:
                                                            @"Got error %@",
                                                            error] autorelease];
                                            } else {
                                                uint32_t currentContentHash = [weakExtore contentHash];
                                                /* We are done with weakExtore. */
                                                [weakExtore tearDownFor:@"TriggHandlingSuccess"
                                                              jobSerial:jobSerial];
                                                verdict = [NSString stringWithFormat:
                                                           @"Got hash %08lx",
                                                           (long)currentContentHash];
                                            }

                                            [weakExtore tearDownFor:@"TriggHandlingError"
                                                          jobSerial:jobSerial];
                                            [self endVerdict:verdict
                                                forJobSerial:jobSerial];
                                        }
                                    }];
}

+ (void)endVerdict:(NSString*)verdict
      forJobSerial:(NSInteger)jobSerial {
    NSLog(@"%@: %@",
          [Job serialStringForSerial:jobSerial],
          verdict);
    sleep(2);
    [self testForJobSerial:(jobSerial+1)];
}

@end
