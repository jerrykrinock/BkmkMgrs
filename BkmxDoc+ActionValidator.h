#import <Cocoa/Cocoa.h>
#import "BkmxDoc.h"


/*!
 @brief    

 @details
 <ul>
 <li>Application Main Menu: Will invoke the -validateMenuItem for the
 current document because of the document window in the responder chain</li>
 <li>Inspector Gear Button menu: Will not invoke the -validateMenuItem for the
 current document because it is a contextual menu, and the responder chain
 for contextual menus does not inlude any other windows.</li>
 <li>Main Window Contextual Menus (ContentOutlineView and DupesOutlineView):
 Will invoke the -validateMenuItem for the
 current document because the responder chain
 for contextual menus does inlude the current window.</li>
 
*/
@interface BkmxDoc (ActionValidator)

/*!
 @brief    Calculates current parameters (enabled, target, action, title)
 for a menu item which could visit the receiver's currently-selected
 starks with a given url temporality.
 @param    urlTemporality  The temporality (prior URL, current URL,
 or suggested URL) of the url to be used in the hypothetical visit.
 @param    target_p  On return, if non-NULL, points to the target of the
 menu item.
 @param    action_p  On return, if non-NULL, points to the action of the
 menu item.&nbsp;  This will be NULL if the menu item should not be
 enabled.
 @param    title_p  On return, if non-NULL, points to the title of the
 menu item.  
 @result   YES if the menu item should be enabled, NO otherwise.
 */
- (BOOL)visitMenuItemParametersForUrlTemporality:(BkmxUrlTemporality)urlTemporality
										target_p:(id*)target_p
										action_p:(SEL*)action_p
										 title_p:(NSString**)title_p ;

@end
