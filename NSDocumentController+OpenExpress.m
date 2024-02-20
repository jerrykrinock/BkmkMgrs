#import "NSDocumentController+OpenExpress.h"
#import "SSYAlert.h"
#import "SSYProcessTyper.h"

enum WindowVisibility_enum {
	WindowVisibilityNone,
	WindowVisibilityMiniaturized,
	WindowVisibilityVisible
} ;
typedef enum WindowVisibility_enum WindowVisibility ;


@implementation NSDocumentController (OpenExpress)

- (void)openDocumentUrl:(NSURL*)url
                display:(BOOL)display
      completionHandler:(void(^)(NSDocument*))completionHandler {
    [self openDocumentWithContentsOfURL:url
                                display:display
                      completionHandler:^(
                                          NSDocument* document,
                                          BOOL documentWasAlreadyOpen,
                                          NSError* error ) {
                          if (!document) {
                              [SSYAlert alertError:error] ;
                          }
                          
                          if (completionHandler) {
                              completionHandler(document) ;
                          }
                      }] ;
}

- (void)openAndDisplayDocumentUrl:(NSURL*)url
                completionHandler:(void(^)(NSDocument*))completionHandler {
    [self openDocumentUrl:url
                  display:YES
        completionHandler:^(NSDocument* document) {
            if (completionHandler) {
                completionHandler(document) ;
            }
        }] ;
}

- (void)openDocumentUrlInMenuItem:(NSMenuItem*)item
					   visibility:(WindowVisibility)visibility {
	if (visibility == WindowVisibilityVisible) {
		[SSYProcessTyper transformToForeground:nil] ;
	}
	
	NSURL* url = [item representedObject] ;
	BOOL display = (visibility != WindowVisibilityNone) ;
    [self openDocumentUrl:url
                  display:display
        completionHandler:^(NSDocument* document) {
            if (visibility == WindowVisibilityMiniaturized) {
                for (NSWindowController* windowController in [document windowControllers]) {
                    [[windowController window] miniaturize:self] ;
                }
            }
        }] ;
}

- (IBAction)openAndDisplayDocumentUrlInMenuItem:(NSMenuItem*)item {
	[self openDocumentUrlInMenuItem:item
						 visibility:WindowVisibilityVisible] ;
}

- (IBAction)openMiniaturizedDocumentUrlInMenuItem:(NSMenuItem*)item {
	[self openDocumentUrlInMenuItem:item
						 visibility:WindowVisibilityMiniaturized] ;
}

- (IBAction)openWindowlessDocumentUrlInMenuItem:(NSMenuItem*)item {
	[self openDocumentUrlInMenuItem:item
						 visibility:WindowVisibilityNone] ;
}


@end