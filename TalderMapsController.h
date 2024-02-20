#import <Cocoa/Cocoa.h>

@class Client ;

@interface TalderMapsController : NSWindowController {
	Client* m_client ;
    NSArray* m_tagMapProtos ;
    NSArray* m_folderMapProtos ;
}

@property (assign) Client* client ;
@property (retain) NSArray* tagMapProtos ;
@property (retain) NSArray* folderMapProtos ;

- (id)initWithClient:(Client*)client ;

- (NSArray*)availablePolaritiesForFolderMaps ;

- (NSArray*)availablePolaritiesForTagMaps ;

- (IBAction)done:(id)sender ;

- (IBAction)help:(id)sender ;

@end
