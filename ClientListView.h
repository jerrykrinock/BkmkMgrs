#import <Cocoa/Cocoa.h>

@protocol BkmxDocumentProvider ;
@class BkmxDocWinCon ;

/*
 It may be better to store clients as an ivar, and I wrote code to do that,
 but disabled it with #if 0 until 20131018 when I got sick of looking at it
 and hosed it away.  It's still in the git repo if you want it.
 
 DEFINITIONS:
 1 means -clients is a local ivar which must be kept bound
 to the -macster.
 0 means  -clients is obtained from -macster when needed.
 
 Advantages of 1:
 * More modern.
 * Observes if Clients would ever be changed by AppleScript or Undo.
 Advantages of 0:
 * Less code
 * Simpler
 * It works.  Option "1" currently does not show existing clients when
      document is opened.
 
 I am currently using 0
*/

extern NSString* const constNoteClientListViewDidReheight ;
extern NSString* const constKeyClientListViewNewHeight ;

/*!
 @brief    View that comprises most of the window in a
 Collection's Settings > Clients tab.

 @details  
 
 The height of the view in the nib should be the desired height of a single
 row, typically 28 points.  This is hard-coded in +[ClientListView rowHeight]
 so the value is available before the nib is loaded.  If the height of our view
 in the nil does not equal the value returned by +[ClientListView rowHeight],
 an assertion will be raised.
*/
@interface ClientListView : NSView <NSMenuDelegate> {
#if CLIENTS_STORED_AS_IVAR
	NSArray* m_clients ;
#endif

	CGFloat m_initialY ;
	CGFloat m_rowHeight ;
	BOOL m_isObserving ;
	BOOL m_updatePending ;
    BOOL m_hasPlaceholderChoice ;
    BOOL m_hasAdvancedButton ;

	IBOutlet NSObject <BkmxDocumentProvider> * documentProvider ;
}

@property (assign) BOOL hasAdvancedButton ;
@property (readonly) NSInteger itemCount;

+ (CGFloat)rowHeight;
- (CGFloat)currentHeight ;

- (NSControl*)gearButtonForClientAtIndex:(NSInteger)index ;

- (void)removeObservers ;

/*!
 @brief    Width required so that none of the display name in the receiver's
 popup menu would not be truncated, even if the longest display name in the
 menu is selected

 @details  Note that this is only necessary to show the longest name after it
 is selected.  During selection, when all menu items are showing, AppKit
 shows a menu which is as wide as necessary.

 The quick approach to solving this problem would be to instead set the
 truncation style and truncation mode to values which are good for your
 application.  Unfortunately, in both NSPopUpButton and NSPopUpButtonCell,
 these truncation properties are either unavailable or do not work as expected
 (in macOS 10.12).  No matter what you do, you get the truncation of the 
 *end*, at the nearest *word boundary* :(
 
 The value returned by this method should be used to adjust the receiver's
 width, and, if necessary, the window width.  Note that this is an "open loop"
 pre-adjustment.  This method predicts what width will be necessary *should*
 the longest menu item be selected, using the font from a NSMenu which
 simulates the actual NSMenu of the popup button.
 */
- (CGFloat)requiredWidth;

@end
