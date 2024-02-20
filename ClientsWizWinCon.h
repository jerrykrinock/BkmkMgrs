#import <Cocoa/Cocoa.h>

@class ClientListNiew ;
@class BkmxDoc ;

@interface ClientsWizWinCon : NSWindowController {
	IBOutlet NSTextField* headingField ;
	IBOutlet NSImageView* bigAppImageView ;
    
	IBOutlet NSImageView* clientDownArrow ;
	IBOutlet NSImageView* clientUpArrow ;

	IBOutlet ClientListNiew* clientListNiew ;

	IBOutlet NSTextField* helpLabel ;
	IBOutlet NSButton* cancelButton ;
	IBOutlet NSButton* okButton ;
    
    IBOutlet NSTextField* labelReorder;
	
	NSMutableArray* m_clientoidsPlus ;
	NSInvocation* m_doneInvocation ;
}

- (IBAction)help:(id)sender ;
- (IBAction)ok:(id)sender ;

+ (BOOL)canOfferAnyClients ;

/*!
 @brief    Creates and runs a Clients Setup Wizard

 @param    invocation  An invocation which is invoked if
 and when the user completes the process without cancelling.
*/
+ (void)runWithBkmxDoc:(BkmxDoc*)bkmxDoc 
		   thenInvoke:(NSInvocation*)invocation ;

@end
