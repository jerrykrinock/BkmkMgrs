#import "VerifyProgressController.h"
#import "BkmxAppDel.h"
#import "Broker.h"
#import "NSString+LocalizeSSY.h"
#import "SSYMH.AppAnchors.h"

CGFloat ThrottlePeriodFromSliderSetting(NSInteger setting) {
	CGFloat period ;
	
	switch (setting)
	{
		case 0:
			period = 1.0 ;
			break ;
		case 1:
			period = 0.5 ;
			break ;
		case 2:
			period = 0.2 ;
			break ;
		case 3:
			period = 0.1 ;
			break ;
		case 4:
			period = 0.05 ;
			break ;
		case 5:
			period = 0.02 ;
			break ;
        default:
            period = 1.0 ;
	}
	
	return period ;
}

NSInteger ThrottleSliderSettingFromPeriod(CGFloat period)
{
	NSInteger throttleHz = 1/period ;
	CGFloat ts ; // throttle slider setting
	switch (throttleHz)
	{
		case 1:
			ts = 0;
			break ;
		case 2:
			ts = 1;
			break ;
		case 5:
			ts = 2;
			break ;
		case 10:
			ts = 3;
			break ;
		case 20:
			ts = 4;
			break ;
		case 50:
			ts = 5;
			break ;
        default:
            ts = 1;
	}
	return ts ;
}

@interface VerifyProgressController ()

@property (retain) Broker* broker ;

@end


@implementation VerifyProgressController

@synthesize broker ;

- (void)startVerifyWithBroker:(Broker*)broker_
{
	[self setBroker:broker_] ;
	
    if ([[NSThread currentThread] isMainThread]) {
        [buttonCancel setEnabled:YES];
        [self clearLog];
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [buttonCancel setEnabled:YES] ;
            [self clearLog];
        });
    }

}

- (void)setThrottleValue:(NSInteger)setting
{
	CGFloat period = ThrottlePeriodFromSliderSetting(setting) ;
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults] ;
    [userDefaults setFloat:period
					forKey:constKeyThrottlePeriod];
	[userDefaults synchronize] ;
	
	[[self broker] restartThrottle] ;
}

- (IBAction)readThrottleControl:(id)sender {
	NSInteger userSetting = [sliderThrottle integerValue] ;
	[self setThrottleValue:userSetting] ;
}

- (IBAction)helpVerify:(id)sender {
	[(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorVerifyShow] ;
}

- (void)dealloc {
	[broker release] ;
	[logLines release] ;

    [super dealloc] ;
}


- (void)updateThrottleView
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults] ;

	if ([[self broker] verifyPhase] <= kFirstPass)
	{
		[sliderThrottle setEnabled:YES] ;
		// Get current value of period
		CGFloat period = [[userDefaults objectForKey:constKeyThrottlePeriod] doubleValue] ;
		
		[sliderThrottle setIntegerValue:ThrottleSliderSettingFromPeriod(period)] ;
	}
	else
	{
		[sliderThrottle setEnabled:NO] ;
		[sliderThrottle setIntegerValue:ThrottleSliderSettingFromPeriod(THROTTLE_PERIOD_FOR_SECOND_PASS)] ;
	}
}

- (id)init {
	self = [super init] ;
	if (self) {
		logLines = [[NSMutableArray alloc] init] ;
	}
	return self ;
}

- (void)awakeFromNib {
	[labelUnansweredRequests setStringValue:[NSString localize:@"unansweredRequests"] ] ;
	[buttonCancel setTitle:[NSString localize:@"cancel"]] ;
	[buttonCancel setEnabled:NO] ;
	[textThrottle setStringValue:[NSString localize:@"throttle"]] ;
	[textRequestsPerSecond setStringValue:[NSString stringWithFormat:@"(%@)", [NSString localize:@"requestsPerSecond"]]] ;

	[self updateThrottleView] ;
	
	// The following code from cocoadev: NSTextView How do you turn off line wrap? Satoshi Matsumoto Sun Jan 18 04:48:18 2004
	NSTextContainer* textContainer = [textLog textContainer];
    NSSize textSize = [textContainer containerSize];
    //textSize.height = [textLog frame].size.height ;
	textSize.width = 1.0e7;
    [textContainer setContainerSize:textSize];
	[textLog setVerticallyResizable:YES] ;
    [textContainer setWidthTracksTextView:NO];
    //[textContainer setHeightTracksTextView:];
}

- (void)setLevelIndication:(CGFloat)level
{
	[levelIndicator setDoubleValue:level] ;
	[textNumberUnreplied setStringValue:[NSString stringWithFormat:@"%ld", (long)level]] ;
}

- (void)displayLog {	
	NSMutableString* logText = [[NSMutableString alloc] init] ;
	NSEnumerator* e = [logLines objectEnumerator] ;
	NSString* nextLine ;
	NSInteger i=0 ;
	while ((nextLine = [e nextObject])) {
		[logText appendString:[NSString stringWithFormat:@"%@\n", nextLine]] ;
		i++ ;
	}
    
	NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont systemFontOfSize:11.0], NSFontAttributeName,
                                [NSColor controlTextColor], NSForegroundColorAttributeName, // oddly, needed for Dark Mode
                                nil];
	NSAttributedString* as = [[NSAttributedString alloc] initWithString:logText
															 attributes:attributes] ;
	[[textLog textStorage] setAttributedString:as] ;
	[as release] ;
	[textLog display] ;
	[logText release] ;
}

- (void)appendToLog:(NSString*)newLine
{
	[logLines addObject:newLine] ;
//	if ([logLines count] <= nLogLines) {
//		// We only display if the new item will show
		[self displayLog] ;
//	}
}

- (void)removeFromLog:(NSString*)line
{
	NSInteger i = [logLines indexOfObject:line] ;
	if (i != NSNotFound) {
		[logLines removeObjectAtIndex:i] ;
	}
	else {
        // Prior to BookMacster 1.15, this logged Internal Error 624-4058
        // here.  However I now realize that this branch is expected if
        // bookmarks are deleted during a Verify operation.
	}
	
	[self displayLog] ;
}

- (void)clearLog
{
	[logLines removeAllObjects] ;
	NSAttributedString* as = [[NSAttributedString alloc] initWithString:@""] ;
	[[textLog textStorage] setAttributedString:as] ;
	[as release] ;
}


- (IBAction)cancel:(id)sender
{
    [[self broker] abortLongTask];
    [buttonCancel setEnabled:NO];
}

@end
