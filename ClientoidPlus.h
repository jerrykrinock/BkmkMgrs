#import <Cocoa/Cocoa.h>

@class Clientoid ;

/*!
 @brief    A wrapper around a Clientoid that provides three
 additional ivars needed to specify the order of Clientoids,
 and whether they import or export.
*/
@interface ClientoidPlus : NSObject {
	Clientoid* m_clientoid ;
	BOOL m_doImport ;
	BOOL m_doExport ;
	NSInteger m_index ;	
}

+ (NSArray*)availableClientableClientoidsPlus ;

@property (retain) Clientoid* clientoid ;
@property BOOL doImport ;
@property BOOL doExport ;
@property NSInteger index ;

- (NSString*)displayName ;

@end
