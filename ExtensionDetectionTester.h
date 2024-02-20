#import <Foundation/Foundation.h>

@interface ExtensionDetectionTester : NSWindowController {
    IBOutlet NSTextView* textView ;
    IBOutlet NSButton* startTestButton ;
    NSSet* m_agentLabels ;
	FSEventStreamRef m_agentActivityStream ;
}

- (IBAction)start:(id)sender  ;
- (IBAction)copyToClipboard:(id)sender ;
- (IBAction)done:(id)sender  ;

@end
