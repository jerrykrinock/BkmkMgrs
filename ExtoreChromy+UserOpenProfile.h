#import "ExtoreChromy.h"

/*!
 @brief    A stupid category
 
 @detail   This category is required because of this issue:
 http://code.google.com/p/chromium/issues/detail?id=180500

 Because we can't load a profile under the hood, and because syncing should not
 wait if Chrome Sync is in use, we need to ask the user to do it.
 */
@interface ExtoreChromy (UserOpenProfile)

- (void)askUserOpenProfileForOperation:(SSYOperation*)operation ;

@end
