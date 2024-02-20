#import <Cocoa/Cocoa.h>
#import "SSYIndexee.h"

@interface NSSet (Indexing)

/*!
 @brief    For a set of objects that have 'index' keys, changes some of their values.
 
 @details  This method is used under the hood of -addObject:atIndex:
 and -removeIndexedObject.  (In most cases, you'll want to use one of those
 methods directly instead of this method.)  This method is useful when inserting
 or removing NSManagedObjects into/from an ordered to-many relationship.
 The 'many' end of the relationship is an NSSet, which wannabe NSArray.
 To use this method, the members' entity's class must conform to protocol SSYIndexee
 (i.e., respond to selectors -index and -setIndex:). Then, for example, when you
 insert an object into the middle of the set/array-wannabe, you use this method to
 displace the indexes of the existing siblings, in that case passing delta = +1.
 Similarly, when you remove an object from the middle of the
 set/array-wannabe, you use this method to displace the indexes of the existing
 siblings, in that case passing delta = -1.
 @param    delta  The count by which each qualifying members' value will be changed
 @param    threshold  The value which the current value of a member's index
 value must exceed in order to qualify for being changed.
 */
- (void)changeMemberIndexValuesBy:(NSInteger)delta
			ifCurrentValueExceeds:(NSInteger)threshold ;



/*!
 @brief    Gets an array of the receiver's objects, sorted ascending by
 the value in a given key path.
 
 @details  This method may be used to reconstruct an ordered array
 from a to-many relationship in a Core Data store.  In this 
 type of relationship, the 'many' objects are stored in
 an (unordered) set, and each object has an index key
 to indicate its position in the represented array.
 For example, each object may have an 'index' attribute
 which is integer.  In this case, the key path is @"index".
 @param    keyPath  The key path whose value will be used to
 sort the set into an array.
 @result   The sorted array
 */
- (NSArray*)arraySortedByKeyPath:(NSString*)keyPath ; 

- (void)restackIndexes ;

@end


@interface NSMutableSet (Indexing)

/*!
 @brief    Adds an object to the receiver at a given index, or as near as
 possible, displacing the indexes of existing member objects if needed.
 
 @details  This method is useful when inserting NSManagedObjects into
 an ordered to-many relationship.  The 'many' end of the relationship is an
 NSSet, which wannabe NSArray.  The receiver will be be a mutable set returned
 by sending -mutableSetValeForKey to the managed object.  The receiver's members' entity's
 class must conform to protocol SSYIndexee (i.e., respond to selectors -index and
 -setIndex:).
 
 If index wants to insert newMember before existing siblings, the
 indexes of the affected siblings are incremented.  If index wants to insert the
 object beyond the end of the existing siblings, index is adjusted downward so that
 there will be no gap between the last sibling and newMember, and newMember's index
 is set to the end.
 
 If an object equal to newObject already exists in the receiver, in accord
 with the behavior of -addObject:, the existing object remains and the new
 object is not added.  However, -moveObject:toIndex: is invoked to move the
 existing object to 'index'.
 
 @param    newObject  The new object to be inserted
 @param    index  The index at which the new object is desired to be added.  To
 add an object as the last index, you may pass NSNotFound.
 */
- (void)addObject:(id <SSYIndexee>)newObject
		  atIndex:(NSInteger)index ;

/*!
 @brief    Removes an object from the receiver, displacing the indexes of existing
 member objects if needed.
 
 @details  This method is useful when removing NSManagedObjects from
 an ordered to-many relationship.  The 'many' end of the relationship is an
 NSSet, which wannabe NSArray.  The receiver will be be a mutable set returned
 by sending -mutableSetValeForKey to the managed object.  The receiver's members' entity's
 class must conform to protocol SSYIndexee (i.e., respond to selectors -index and
 -setIndex:).  If object currently has siblings with indexes higher than object,
 the indexes of these higher-indexed siblings are decremented to close up the
 gap created by removing object.
 
 If the receiver does not contain an object which is equal to the given 'object',
 then, like -removeObject:, we perform no-op.  (The documentation for 
 -[NSSet removeObject:], does not make that clear, however it is true.  Here
 is Document Feedback I just submitted to Apple:
 In -removeObject:, documentation says that it "removes a given object".  In fact,
 it "removes any object equal to a given object".  There's a difference.  Try this:
 
 NSString* ob1 = @"Hello" ;
 // To do this test, we need to trick the compiler into creating
 // another constant string equal to ob1 but distinct from it;
 // i.e. having different address…
 NSString* ob2 = [[ob1 stringByAppendingString:@"Bye"] substringToIndex:5] ;
 NSMutableSet* set = [NSMutableSet setWithObject:ob1] ;
 NSLog(@"ob1 = %p %@", ob1, ob1) ;
 NSLog(@"ob2 = %p %@", ob2, ob2) ;
 [set removeObject:ob2] ;
 NSLog(@"%@", set) ;
 exit(0) ;
 
 The result is an empty set, indicating that, although we asked it to remove
 ob2, it removed ob1, because ob1 and ob2 are equal.
 
 @param    object  The object to be removed from the receiver.
 */
- (void)removeIndexedObject:(id <SSYIndexee>)object ;

/*!
 @brief    Moves an object within the receiver, displacing the indexes of existing
 member objects if needed.
 
 @details  Invokes -removedIndexedObject: and then -addObject:atIndex:
 in succession.&nbsp;  All details in those documentations apply.
 No op if object is already at the requested index.
 
 @param    index  The index at which the new object is desired to be added.  To
 add an object as the last index, you may pass NSNotFound.
 */
- (void)moveObject:(id <SSYIndexee>)object
		   toIndex:(NSInteger)index ;

@end

