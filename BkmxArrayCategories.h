#import "BkmxGlobals.h"

@interface NSArray (BkmxArray)

- (NSString*)readableName  ;
- (BOOL)allCanAcceptSortDirective  ;

/*!
 @brief    	Returns NSControlStateValueOn, NSControlStateValueOff or NSMixed state depending on whether
 all members are shouldSort, are not shouldSort, or some are and some aren't.
 
 @details If self is empty, returns NSControlStateValueMixed.  Does not make any distinction
 of members' sharype.
 */
- (NSInteger)allShouldSort ;

/*!
 @brief    	Returns NSControlStateValueOn, NSControlStateValueOff or NSMixed state depending on whether
 all members have a given sortDirective value, all don't have a give sortDirective
 value, or some do and some don't.
 
 @details If self is empty, returns NSControlStateValueMixed.  Does not make any distinction
 of members' sharype.
*/
- (NSInteger)allHaveSortDirectiveValue:(BkmxSortDirective)sortDirectiveValue ;

- (NSString*)tabReturnLeavesSummary ;

/*!
 @brief    Produce an alternating array of sub-arrays and separators

 @details  The receiver should be an array of Starks.  This method
 will return an array that begins with a sub-array of the Starks in the
 receiver that appear before the first separator, then the firs separator,
 then a sub-array of the Starks that appear before the second separator,
 then the second separator, ... , finally, the last sub-array.
 @result   An alternating array of sub-arrays and separators
 extracted from the receiver.
 */
- (NSArray*)chopAtSeparators ;

@end


