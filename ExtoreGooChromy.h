#import "ExtoreChromy.h"

/*!
 @brief    Subclass of ExtoreChromy which structures bookmarks like Google
 Chrome
 
 @details  This includes all Chromy browsers except Opera.  See header of
 ExtoreCustomChromy for the differences
 */
@interface ExtoreGooChromy: ExtoreChromy

@property (assign) BOOL hasDualTrees;

@property (retain) NSNumber* syncedBarId;
@property (retain) NSNumber* localBarId;
@property (retain) NSNumber* syncedOtherId;
@property (retain) NSNumber* localOtherId;

@property (retain) NSMutableArray* syncedBarChildExids;
@property (retain) NSMutableArray* localBarChildExids;
@property (retain) NSMutableArray* syncedOtherChildExids;
@property (retain) NSMutableArray* localOtherChildExids;

@end
