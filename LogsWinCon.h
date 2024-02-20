#import <Cocoa/Cocoa.h>

extern NSString* const constIdentifierTabViewErrors ;
extern NSString* const constIdentifierTabViewMessages ;

@class MessageLog ;

@interface LogsWinCon : NSWindowController {
	IBOutlet NSSegmentedControl* ibo_tabSelector ;
	IBOutlet NSArrayController* ibo_messagesAC ;
	IBOutlet NSArrayController* ibo_errorsAC ;
	IBOutlet NSTabView* ibo_logsTabView ;
	IBOutlet NSButton* ibo_supportButton ;
	IBOutlet NSButton* ibo_refreshButton ;
	IBOutlet NSPopUpButton* ibo_errorsPopUp ;
	IBOutlet NSTableView* ibo_messagesTableView ;
	
	// Workaround for the bug in NSArrayController, that it sends NSNull instances
	// in NSKeyValueChangeOldKey and NSKeyValueChangeNewKey when you observe
	// it (KVO) with options NSKeyValueObservingOptionOld + NSKeyValueObservingOptionNew
	MessageLog* m_priorLastMessageLog ;
	
	NSString* m_messageSearchString ;
}


- (IBAction)support:(id)sender ;
- (IBAction)refresh:(id)sender;
- (void)revealTabViewIdentifier:(NSString*)identifier ;
- (void)displayErrors ;
- (IBAction)cleanDefunctLogEntries:(id)sender ;
- (NSPredicate*)messageFilterPredicate ;

@property (copy) NSString* messageSearchString ;

@end
