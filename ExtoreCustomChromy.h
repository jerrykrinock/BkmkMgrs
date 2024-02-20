#import "ExtoreChromy.h"

/*!
 @brief    Subclass of ExtoreChromy for browsers which structures bookmarks
 like Opera
 
 @details  Compared to ExtoreGooChromy, the differences in this subclass are:
 • The 'other' sub-branch in the json tree is unused.
 • There is a 'custom_root' branch in the json tree which has 4 sub-branches:
   • speedDial (which we map to BkmxOhared)
   • trash (which we ignore)
   • unsorted (which we map to BkmxUnfiled)
   • userRoot (which we map, instead of the unused 'other', to BkmxMenu)
 • Does not support the fakeUnfiled feature, because it has a BkmxUnfiled, there
 is no need to do this.
 • Does not support the noLoosiesInMenu feature.
 */
@interface ExtoreCustomChromy : ExtoreChromy {
}

@end
