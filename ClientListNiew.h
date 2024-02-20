#import <Cocoa/Cocoa.h>

@class ClientsWizWinCon ;
@class BkmxDoc ;

/*!
 @brief    A view which is the array of client names, chekboxes and up/down
 buttons displayed in the Clients Wizard sheet during creation of a new 
 document

 @details  Someday, I should factor out the non-app-specific
 portions of this class into a superclass, SSYSmallListView.
 
 The height of the view in the nib should be the desired height
 of a single row, typically 28 points.
*/
@interface ClientListNiew : NSView {
	CGFloat m_initialY ;
	CGFloat m_initialHeight ;
	NSArray* m_objects ;
	BkmxDoc* m_choiceProvider ;
	BOOL m_didBind ;
	ClientsWizWinCon* m_contentProvider ;
	NSString* m_keyPath ;
}

@property (assign) BkmxDoc* choiceProvider ;
@property (readonly) NSInteger itemCount;

/*!
 This method should be built into init.  But then, it seems
 to me, that I'd need to make this class into an IB Library thingy
 */
- (void)setContentProvider:(ClientsWizWinCon*)contentProvider
				   keyPath:(NSString*)keyPath ;

@end
