/* VerifyProgressController */

#import <Cocoa/Cocoa.h>

@class Broker ;

@interface VerifyProgressController : NSObject
{
    IBOutlet NSButton* buttonCancel;
	IBOutlet NSSlider* sliderThrottle;
    IBOutlet id textLog;
    IBOutlet NSTextField* labelUnansweredRequests;
	// One or the other of the next two are used:
    IBOutlet NSLevelIndicator* levelIndicator ;
    IBOutlet NSTextField *textNumberUnreplied ; // value mirrors levelIndicator
	IBOutlet NSTextField* textThrottle ;
	IBOutlet NSTextField* textRequestsPerSecond ;

	// Object Instance Variables (ivars)
    Broker* broker ;
    NSMutableArray* logLines ;
}

- (IBAction)cancel:(id)sender;
- (IBAction)helpVerify:(id)sender;
- (IBAction)readThrottleControl:(id)sender;

// Messages sent from the worker

- (void)startVerifyWithBroker:(Broker*)worker ;
- (void)updateThrottleView ;
- (void)setLevelIndication:(CGFloat)level ;
- (void)appendToLog:(NSString*)newLine ;
- (void)removeFromLog:(NSString*)line ;
- (void)clearLog ;

@end
