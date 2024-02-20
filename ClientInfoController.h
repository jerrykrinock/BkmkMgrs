#import <Cocoa/Cocoa.h>

@class Client ;
@class ClientSpecialBoxController ;

@interface ClientInfoController : NSWindowController {
	IBOutlet NSBox* importBox ;
	IBOutlet NSBox* exportBox ;
	IBOutlet NSPopUpButton* exportSafeLimitPopup ;
    IBOutlet NSPopUpButton* defaultParentPopup ;
    IBOutlet NSButton* tagFolderMapsButton ;
	
	Client* m_client ;
	ClientSpecialBoxController* m_specialBoxController ;
}

@property (assign) Client* client ;

- (NSPopUpButton*)exportSafeLimitPopup ;

- (id)initWithClient:(Client*)client ;

- (IBAction)showTalderMapsSheet:(id)button ;

- (IBAction)done:(id)sender ;

- (IBAction)help:(id)sender ;

- (IBAction)helpMergeBy:(id)sender;

@end
