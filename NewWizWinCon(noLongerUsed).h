#import <Cocoa/Cocoa.h>


@interface NewWizWinCon : NSWindowController {
	IBOutlet NSTextField* headingField ;
	IBOutlet NSTextField* helpLabel ;
	IBOutlet NSButton* button0 ;
	IBOutlet NSButton* button1 ;
	IBOutlet NSButton* button2 ;
	IBOutlet NSButton* button3 ;
	IBOutlet NSTextField* label0 ;
	IBOutlet NSTextField* label1 ;
	IBOutlet NSTextField* label2 ;
	IBOutlet NSTextField* label3 ;
	IBOutlet NSButton* cancelButton ;
	IBOutlet NSButton* okButton ;
	
	NSInteger m_usageStyle ;
}

@property (readonly) NSInteger usageStyle ;

- (IBAction)selectUsageStyle:(id)sender ;
- (IBAction)help:(id)sender ;
- (IBAction)cancel:(id)sender ;
- (IBAction)ok:(id)sender ;

@end
