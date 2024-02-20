#import <Foundation/Foundation.h>

@protocol BkmxSearchDelegate <NSObject>

/*!
 @brief
 
 @details  Will never return nil.  May return an empty set.
 */
- (NSSet*)autosavedSearchValueForKey:(NSString*)key ;

- (IBAction)changeSearchParm:(NSMenuItem*)sender ;

@end
