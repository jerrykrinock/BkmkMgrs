#import <Cocoa/Cocoa.h>
#import "ExtoreHttp.h"


@interface ExtoreDiigo : ExtoreHttp {
}

@end


/*
 curl one-liners that work for Diigo
 
 UPDATE 2021-03-25.  These do not work any more.  I get response this JSON response:
 {"message":"Please use API key http://www.diigo.com/api_dev. If you spam diigo, your key will be disabled."}
 and that link says that an API key is now a "premium feature" ($40/year)
 
 Get the first 10 bookmarks:
 curl -ujerrysDiigoTest:kO5R8lsO3Ii0lW7K https://secure.diigo.com/api/v2/bookmarks?user=jerrysDiigoTest&key=904fef01a43ef01f
 
 Add a bookmark:
 curl -ujerrysDiigoTest:kO5R8lsO3Ii0lW7K -d "key=904fef01a43ef01f&user=jerrysDiigoTest&title=RFC+6304&url=http%3A%2F%2Ftools.ietf.org%2Fhtml%2Frfc6304" https://secure.diigo.com/api/v2/bookmarks
 
 Delete a bookmark:
 curl -ujerrysDiigoTest:kO5R8lsO3Ii0lW7K -X DELETE -d "key=904fef01a43ef01f&user=jerrysDiigoTest&title=RFC+6302&url=http%3A%2F%2Ftools.ietf.org%2Fhtml%2Frfc6302" https://secure.diigo.com/api/v2/bookmarks
 
 */
