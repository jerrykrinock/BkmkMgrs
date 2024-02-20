#import "SSYShellTasker-Test.h"
#import "SSYOtherApper.h"
#import "SSYShellTasker.h"
#import "StarkTyper.h"
#import "NSString+Data.h"

@implementation SSYShellTaskerTests

- (void)setUp {
    // Create data structures here.
}

- (void)tearDown {
    // Release data structures here.
}

/*
 This test doesn't work, and I don't know why.  If breakpoints are on, it
 raises some kind of exception within the SSYOtherApper method, at
 [task launch].  But nothing prints to the console and if I try to debug
 in -[NSException raise] using po $rdi, p (SEL)$rsi, po $rdx, po $rcx, po $r8,
 etc. lldb tells me that it "can't materialize" these.  If I turn breakpoints
 off, the method executes OK, but all of the "sleep(5)" act like no-ops,
 although a "sleep(5)" at the beginning of the method works OK.  Dictionary.app
 never launches in any case. */
- (void)XXXtestBasics {
	 NSError* error = nil ;
	 NSString* guineaPigBundle = @"com.apple.Dictionary" ;	
	 NSInteger result ;
	 NSInteger pid ;
	 NSData* stdoutData = nil ;
	 NSData* stderrData = nil ;
	 NSString* stdoutString ;
	 NSTimeInterval timeout ;

	// Kill Dictionary.app if it is running
	 [SSYOtherApper killThisUsersAppWithBundleIdentifier:guineaPigBundle
												 timeout:10] ;
	 
	 // See if it is running
	 pid =[SSYOtherApper pidOfThisUsersAppWithBundleIdentifier:guineaPigBundle] ;
	 STAssertTrue(pid==0, @"failed") ;
	 
    // Re-launch it with timeout 0, then wait a few seconds
	 timeout = 0.0 ;
	 result = [SSYShellTasker doShellTaskCommand:@"/usr/bin/open"
									   arguments:[NSArray arrayWithObjects:@"-b", guineaPigBundle, nil]
									 inDirectory:nil
									   stdinData:nil
									stdoutData_p:NULL
									stderrData_p:NULL
										 timeout:timeout 
										 error_p:&error] ;
	 sleep(5) ;
	 STAssertTrue(result==0, @"failed") ;
	 STAssertTrue(error == nil, @"failed") ;
	 
	 // See if it is running
	 pid =[SSYOtherApper pidOfThisUsersAppWithBundleIdentifier:guineaPigBundle] ;
	 STAssertTrue(pid!=0, @"failed") ;
	 
	 // Kill it again
	 [SSYOtherApper killThisUsersAppWithBundleIdentifier:guineaPigBundle
												 timeout:10] ;
	 
	 // See if it is running
	 pid =[SSYOtherApper pidOfThisUsersAppWithBundleIdentifier:guineaPigBundle] ;
	 STAssertTrue(pid==0, @"failed") ;
	 
	 // Re-launch it with timeout 5, then immediately see if it is running
	 timeout = 5.0 ;
	 result = [SSYShellTasker doShellTaskCommand:@"/usr/bin/open"
									   arguments:[NSArray arrayWithObjects:@"-b", guineaPigBundle, nil]
									 inDirectory:nil
									   stdinData:nil
									stdoutData_p:NULL
									stderrData_p:NULL
										 timeout:timeout 
										 error_p:&error] ;
	 STAssertTrue(result==0, @"failed") ;
	 STAssertTrue(error == nil, @"failed") ;
	 
	 // See if it is running
	 pid =[SSYOtherApper pidOfThisUsersAppWithBundleIdentifier:guineaPigBundle] ;
	 STAssertTrue(pid!=0, @"failed") ;
	 
	 // Kill it again
	 [SSYOtherApper killThisUsersAppWithBundleIdentifier:guineaPigBundle
												 timeout:10] ;
	 
	 // See if we can get some stdout.
	 NSString* testString = @"This is a test." ;
	 stdoutData = nil ;
	 stderrData = nil ;
	 result = [SSYShellTasker doShellTaskCommand:@"/bin/echo"
									   arguments:[NSArray arrayWithObject:testString]
									 inDirectory:nil
									   stdinData:nil
									stdoutData_p:&stdoutData
									stderrData_p:&stderrData
										 timeout:timeout
										 error_p:&error] ;
	 STAssertTrue(result==0, @"failed") ;
	 STAssertTrue(error == nil, @"failed") ;
	 stdoutString = [NSString stringWithDataUTF8:stdoutData] ;
	 // Remove the newline from end of stdoutString
	 stdoutString = [stdoutString substringToIndex:([stdoutString length] - 1)] ;
	 STAssertTrue([stdoutString isEqualToString:testString], @"'echo' command") ;
	 
	 // See if the timeout works
	 timeout = 1.0 ;
	 result = [SSYShellTasker doShellTaskCommand:@"/bin/sleep"
									   arguments:[NSArray arrayWithObject:@"1.05"]
									 inDirectory:nil
									   stdinData:nil
									stdoutData_p:&stdoutData
									stderrData_p:&stderrData
										 timeout:timeout
										 error_p:&error] ;
	 STAssertTrue(result == 90552, @"failed") ;
	 STAssertTrue([error code] == 90552, @"failed") ;
	 
	 // Test if a close timeout occurs
	 timeout = 1.0 ;
	 result = [SSYShellTasker doShellTaskCommand:@"/bin/sleep"
									   arguments:[NSArray arrayWithObject:@"1.20"]
									 inDirectory:nil
									   stdinData:nil
									stdoutData_p:&stdoutData
									stderrData_p:&stderrData
										 timeout:timeout
										 error_p:&error] ;
	 STAssertTrue(result == 90552, @"failed") ;
	 STAssertTrue([error code] == 90552, @"failed") ;
	 
	 // Test if near-timeout does not occur
	NSTimeInterval sleepTime = 0.8 ;
	NSDate* timeoutTime = [NSDate dateWithTimeIntervalSinceNow:timeout] ;
	NSDate* commandTime = [NSDate dateWithTimeIntervalSinceNow:sleepTime] ;
	NSString* sleepTimeString = [NSString stringWithFormat:@"%f", sleepTime] ;
	result = [SSYShellTasker doShellTaskCommand:@"/bin/sleep"
									   arguments:[NSArray arrayWithObject:sleepTimeString]
									 inDirectory:nil
									   stdinData:nil
									stdoutData_p:&stdoutData
									stderrData_p:&stderrData
										 timeout:timeout
										 error_p:&error] ;
	STAssertTrue(result==0, @"failed") ;
	STAssertTrue(error == nil, @"failed") ;
	NSTimeInterval commandTimeError = fabs([commandTime timeIntervalSinceNow]) ;
	NSTimeInterval timeoutTimeError = fabs([timeoutTime timeIntervalSinceNow]) ;
	// And also that the time taken is the time for the command and not the timeout
	STAssertTrue(commandTimeError < timeoutTimeError, @"failed") ;
	
	 // Test a failed launch with no timeout
	 result = [SSYShellTasker doShellTaskCommand:@"/no/such/command"
									   arguments:[NSArray arrayWithObject:@"foobar"]
									 inDirectory:nil
									   stdinData:nil
									stdoutData_p:&stdoutData
									stderrData_p:&stderrData
										 timeout:timeout
										 error_p:&error] ;
	 STAssertTrue(result==90551, @"failed") ;
	 STAssertTrue([error code] == 90551, @"failed") ;
 }


@end