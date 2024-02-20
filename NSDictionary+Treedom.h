extern NSString* const constKeyTreedomChildrenLower ;
extern NSString* const constKeyTreedomChildrenUpper ;

@interface NSDictionary (Treedom)

/*!
 @brief    Performs a given selector on the receiver and all of its
 descendants, using the simple depth-first search.

 @details  Descendants are identified by sending -objectForKey: with a given
 childrenkey.  Therefore, all of the receiver's descendants must respond to
 -objectForKey:
 
 Fast enumeration is used to iterate through the children at
 each node.  Therefore, performing the given selector must *not* alter
 its receiver's children.
 @param    selector  The selector which will be performed on all
 objects in the tree
 @param    childrenKey  The key which is used for the receiver's descendants.
 You may wish to pass one of constKeyTreedomChildrenLower/Upper.
 @param    object  An object which will be passed to the selector each time
 it is invoked.
*/
- (void)recursivelyPerformSelector:(SEL)selector
                       childrenKey:(NSString *)childrenKey
                            object:(id)object;

/*!
 @brief    Invokes -recursivelyPerformSelector:childrenKey:object, passing
to childrenKey the value constKeyTreedomChildrenLower
*/
- (void)recursivelyPerformOnChildrenLowerSelector:(SEL)selector
                                       withObject:(id)object;

/*!
 @brief    Invokes -recursivelyPerformSelector:childrenKey:object, passing
 to childrenKey the value constKeyTreedomChildrenUpper
 */
- (void)recursivelyPerformOnChildrenUpperSelector:(SEL)selector
                                       withObject:(id)object;

- (void)moveToChildrenUpperOfNewParent:(NSMutableDictionary*)newParent ;

- (void)moveToChildrenLowerOfNewParent:(NSMutableDictionary*)newParent ;

@end

