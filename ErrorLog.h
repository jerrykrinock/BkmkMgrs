#import <Cocoa/Cocoa.h>
#import "LogEntry.h"

extern NSString* const constKeyPresented ;

@interface ErrorLog : LogEntry {
	NSError* m_error ;
}

@property (retain) NSError* error ;

- (NSString*)abstraction ;

// Bound to by text views in Logs windows
- (NSAttributedString*)summary ;
- (NSAttributedString*)details ;

- (BOOL)wasPresented ;
- (void)markAsPresented ;

@end

