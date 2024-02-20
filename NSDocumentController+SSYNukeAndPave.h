#import <Cocoa/Cocoa.h>

enum SSYNukeAndPaveResult_enum {
    SSYNukeAndPaveResultNotApplicableDidNotTry = -1,
    SSYNukeAndPaveResultTriedAndFailed = 0,
    SSYNukeAndPaveResultTriedAndSucceeded = 1
} ;
typedef enum SSYNukeAndPaveResult_enum SSYNukeAndPaveResult ;


@interface NSDocumentController (SSYNukeAndPave)

/*
 @brief    If a given error indicates that a document failed to open due to a
 corrupt SQLite database, attempts to repave it like a new, empty document
 
 @details  If an error occurs during the nuking, paving or reopening, it is
 logged to stdout.  No error is passed to the completion handler.  This is
 because you should present the original error (errorIn), since that was the
 root cause the user is interested in.  Any errors we produce are a failure to
 fix the original error.
 */
- (void)tryNukeAndPaveURL:(NSURL*)url
                  errorIn:(NSError*)errorIn
             storeOptions:(NSDictionary*)storeOptions
       modelConfiguration:(NSString*)modelConfiguration
                  display:(BOOL)display
        completionHandler:(void(^)(
                                   SSYNukeAndPaveResult result,
                                   NSString* movedToPath,
                                   NSDocument* documentOut
                                   ))completionHandler ;
@end
