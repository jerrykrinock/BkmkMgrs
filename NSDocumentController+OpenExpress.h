#import <Cocoa/Cocoa.h>


@interface NSDocumentController (OpenExpress)

/*!
 @brief    A wrapper around openDocumentWithContentsOfURL:display:error: which
 immediately displays any error that occurs in a dialog.
 */
- (void)openAndDisplayDocumentUrl:(NSURL*)url
                completionHandler:(void(^)(NSDocument*))completionHandler ;

- (IBAction)openAndDisplayDocumentUrlInMenuItem:(NSMenuItem*)item ;

- (IBAction)openMiniaturizedDocumentUrlInMenuItem:(NSMenuItem*)item ;

- (IBAction)openWindowlessDocumentUrlInMenuItem:(NSMenuItem*)item ;

- (void)openDocumentUrl:(NSURL*)url
                display:(BOOL)display
      completionHandler:(void(^)(NSDocument*))completionHandler ;

@end
