#import <Cocoa/Cocoa.h>


/*!
 @brief    Class used in Chromessenger, and in the
 JS-CTypes for Firefox, for coalescing bookmarks change
 notifications into lazy intervals, and writing the file which is detected by launchd.
 
 @details  First I thought that writing a file to be detected by launchd was kind
 of cheesy, but then I decided that it was actually a good idea because
 *  It uses the already-running launchd resource, instead of opening up another port.
 *  It's the same mechanism as BookMacster's other Bookmarks Changed triggers use.
 */
__attribute__((visibility("default"))) @interface BkmxChangeNotifier : NSObject {
	NSTimer* m_timer ;
	NSString* m_extoreName ;
	NSMutableString* m_jsonBuffer ;
	BOOL m_muted ;
}

@property (assign) BOOL muted ;

- (id)initWithExtoreName:(NSString*)extoreName ;


/*!
 @brief    Sent by the bookmarks observer in C++ whenever a bookmarks change has occurred.
 */
- (void)handleRawChange:(NSString*)jsonString
				profile:(NSString*)profileName ;

@end

