#import "QuillTester.h"
#import "BkmxGlobals.h"
#import "Clientoid.h"
#import "SSYMOCManager.h"
#import "Client.h"
#import "ClientChoice.h"
#import "Extore.h"
#import "Importer.h"
#import "SSYOperationQueue.h"
#import "NSArray+SafeGetters.h"
#import "BkmxDocumentController.h"
#import "Stark.h"
#import "Starker.h"
#import "Chaker.h"
#import "Bkmslf.h"
#import "SSYOperation.h"
#import "NSObject+MoreDescriptions.h"

@interface QuillTester ()

@property (retain, readonly) SSYOperationQueue* operationQueue ;

@end


@implementation QuillTester

- (SSYOperationQueue*)operationQueue {
	if (!m_operationQueue) {
		m_operationQueue = [[SSYOperationQueue alloc] init] ;
	}
	
	return m_operationQueue ;
}

- (void)dealloc {
	[m_operationQueue release] ;
	
	[super dealloc] ;
}

- (Extore*)extoreForExformat:(NSString*)exformat
                 profileName:(NSString*)profileName {
    
	NSManagedObjectContext* moc = [SSYMOCManager managedObjectContextType:NSInMemoryStoreType
																	owner:nil
															   identifier:nil
																 momdName:nil
																  error_p:NULL] ;
    Clientoid* clientoid = [Clientoid clientoidWithExformat:exformat
                                                profileName:profileName
                                                extoreMedia:constBkmxExtoreMediaThisUser
                                             otherMacVolume:nil
                                            otherMacAccount:nil
                                          serverDisplayName:nil
                                              extorageAlias:nil] ;
    
	Client* client = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameClient
                                                   inManagedObjectContext:moc] ;
	[client setLikeClientChoice:[ClientChoice clientChoiceWithClientoid:clientoid]] ;
	Extore* extore = [Extore extoreForIxporter:[client importer]
                                       error_p:NULL] ;
    
    return extore ;
}

- (Stark*)addMockChangeForExtore:(Extore*)extore
                          bkmslf:(Bkmslf*)bkmslf {
    Stark* stark = [[extore starker]  freshStark] ;
    Chaker* chaker = [bkmslf chaker] ;
    [chaker setIsActive:YES] ;
    [chaker addStark:stark] ;
    
    return stark ;
}

- (NSMutableDictionary*)testInfo {
    // Parameters - Edit these
    BkmxClientTask clientTask = BkmxClientTaskInstall ;
    BkmxDeference deference = BkmxDeferenceAsk ;
    NSString* exformat = constExformatChrome ;
    NSString* profileName = @"Default" ;    // @"Default" for Chrome, @"default" for Firefox
    NSInteger readStyle = 1 ;
    NSInteger writeStyle = 2 ;
    NSString* documentPath = @"/Users/jk/Library/Application Support/BookMacster/Bookmarkshelf Documents/jk-01.bkmslf" ;
    // End of parameters
    
    NSError* error = nil ;

    NSString* operationGroup = @"Quill Test Group" ;
    Extore* extore = [self extoreForExformat:exformat
                                 profileName:profileName] ;
    BkmxReadWriteStyles readWriteStyles = BkmxReadWriteStylesFromComponents(readStyle, writeStyle) ;
    NSURL* documentUrl = [NSURL fileURLWithPath:documentPath] ;
    Bkmslf* document = [[BkmxDocumentController sharedDocumentController] openDocumentWithContentsOfURL:documentUrl
                                                                                                display:YES
                                                                                                  error:&error] ;
    if (!document) {
        NSLog(@"Error opening %@ : %@", documentPath, error) ;
        return nil ;
    }
    
    Stark* stark = [self addMockChangeForExtore:extore
                                         bkmslf:document] ;
    
    NSMutableDictionary* info = [NSMutableDictionary dictionary] ;
    [info setObject:[NSNumber numberWithInteger:clientTask]
             forKey:constKeyClientTask] ;
    [info setObject:[NSNumber numberWithInteger:deference]
             forKey:constKeyDeference] ;
    [info setValue:extore
            forKey:constKeyExtore] ;
    [info setObject:[NSNumber numberWithInteger:readWriteStyles]
             forKey:constKeyReadWriteStyles] ;
    [info setValue:document
            forKey:constKeyDocument] ;
    [info setValue:operationGroup
            forKey:constKeySSYOperationGroup] ;    
   
    return info ;
}

- (void)quillTestFinishedWithInfo:(NSDictionary*)info {
    NSLog(@"%@ with final info: %@", NSStringFromSelector(_cmd), [info shortDescription]) ;
    //exit(0) ;
}

- (void)testQuillOperation {
    [[self operationQueue] cancelAllOperations] ;
    NSArray* selectorNames = [NSArray arrayWithObjects:
                              @"quillBrowser",
                              nil] ;
	[[self operationQueue] queueGroup:NSStringFromSelector(_cmd)
                                addon:NO
                        selectorNames:selectorNames
                                 info:[self testInfo]
                                block:NO
                                owner:nil
                           doneThread:nil     // defaults to the current (main) thread
                           doneTarget:self
                         doneSelector:@selector(quillTestFinishedWithInfo:)
                         keepWithNext:NO] ;
}


@end
