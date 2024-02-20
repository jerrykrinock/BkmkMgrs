#import <Cocoa/Cocoa.h>
#import "SSYDynamicMenu.h"

/*!
 @brief    A menu which implements the lazy delegate methods of NSMenuDelegate
 required to populate a hierarchical menu of starks.
*/
@interface StarkContainersHierarchicalMenu : SSYDynamicMenu {
	BOOL m_doRoot ;
	BOOL m_doLeaves ;
	BOOL m_doAddItemHere ;
    BOOL m_doVisitAll ;
	NSDictionary* m_addHereInfo ;
}

@property (assign) BOOL doRoot ;
@property (assign) BOOL doLeaves ;
@property (assign) BOOL doVisitAll ;
@property (retain) NSDictionary* addHereInfo ;

@end
