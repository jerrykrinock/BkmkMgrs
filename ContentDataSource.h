#import "SSYDocChildObject.h"

@class ContentProxy ;
@class BkmxDoc ;


@interface ContentDataSource : SSYDocChildObject <NSOutlineViewDataSource> {
	NSString* m_filterString ;
    NSNumber* m_filterDays ;
	NSSet* m_filterTags ;
	NSInteger m_filterTagsLogic ;
	NSString* m_filterAnnunciation ;

	NSArray* flatCache ;
	NSTimeInterval _lastCacheRefreshTime ;
    
    /* In general, proxies need to be retained independently of their parents,
     because you never know when the outline view will ask for a proxy
     which you had passed it previously in -outlineView:child:ofItem:.  We
     do that with this set: */
    NSMutableSet* m_proxies ;

    NSMutableArray* m_rootProxies ;
}

@property (copy) NSString* filterString ;
@property (copy) NSNumber* filterDays ;
@property (retain) NSSet* filterTags ;
@property (assign) NSInteger filterTagsLogic ;
@property (copy) NSString* filterAnnunciation ;
@property (copy) NSString* flatSortKey ;
@property (assign) BOOL flatSortAscending ;

- (void)tearDown;

- (void)refreshFilterAnnunciationForOutlineMode:(BOOL)mode ;

- (void)invalidateFlatCache ;

- (BOOL)outlineView:(NSOutlineView*)outlineView
	   containsItem:(id)item ;

- (NSArray<Stark*>*)flatCache ;


/*!
 @brief    Utility method for creating starks from a string in the special
 tab-return format, which we accept by pasting or drag and drop from other
 applications
 
 @details  This method does not modify the receiver.
 If the given string is nil, this method returns a empty array.
 */
- (NSArray*)freshStarksFromString:(NSString*)string;

- (void)clearProxies ;

/*!
 @details  If the given stark is root, this method will return nil.  It will
 also return nil if a proxy for the given Stark does not exist in the
 receiver's 'proxies' or 'rootProxies' collections.
 */
- (ContentProxy*)proxyForStark:(Stark*)stark ;

- (void)noteChangedChildrenForStark:(Stark*)stark ;

- (void)checkAllProxies;

@end

