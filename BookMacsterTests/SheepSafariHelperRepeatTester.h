#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SheepSafariHelperRepeatTester : NSObject

/*!
 @brief    Repeatedly tests importing with SheepSafariHelper, so you can see how often
 it crashes

 @details  To run this test, include this header in app delegate, add the
 m. file to the Bkmxwork target, and invoke this method in
 -applicationDidFinishLaunching:, passing jobSerial = 1 to inicialize the
 internal counter.
 */
+ (void)testForJobSerial:(NSInteger)jobSerial;

@end

NS_ASSUME_NONNULL_END

/* Running this test on 2019-02-08, BkmkMgrs 2.9.8, I got 800 imports
 overnight and one SheepSafariHelper crash. */
