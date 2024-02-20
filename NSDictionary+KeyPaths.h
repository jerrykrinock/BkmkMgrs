#import <Cocoa/Cocoa.h>

@interface NSDictionary (KeyPaths)

/*!
 @brief    A wrapper around -valueForKeyPath: which changes the parameter
 to be a key path array, instead of a dot-separated string of keys.
 */
- (id)valueForKeyPathArray:(NSArray*)keyPathArray ;

@end


/*!
 @brief   NSMutableDictionary can read values from nested dictionaries
 with -[NSObject valueForKeyPath:], but not set such values.
 This category adds the missing setValue:forKeyPath: method, and
 methods to mutate dictionaries and arrays located down key paths.  Each method
 also has a companion which takes a "key path array", which is a
 an array of string keys, instead of a key path, which is an 
 equivalent dot-separated string.
 
@details  This class is a clone of NSUserDefaults (KeyPaths). 
 
 Once upon a time, I had defined methods with arguments:
 *  toArrayAtKeyPath:(NSString*)keyPath
 *  fromArrayAtKeyPath:(NSString*)keyPath
 *  fromArrayAtKeyPath:(NSString*)keyPath
 *  fromDictionaryAtKeyPath:(NSString*)keyPath
 which derived key path arrays from the key paths by using
 -componentsSeparatedByString:@".".  However these methods proved
 troublesome since keys themselves can include period/dots.
 If you need to dig down more than one level of keys,
 be safe and use the keyPathArray: methods instead!!
 */
@interface NSMutableDictionary (KeyPaths)

/*!
 @brief    Sets a given value at a given key path, specified by
 a key path array

 @details  Test Code for this method is available at end of this file.
 @param    value  May be nil, in which case the key at the end of the
 key path array is removed (starting in BookMacster 1.11.5.  Prior
 to BookMacster 1.11.5, this method was a no-op if value was nil.)
*/
- (void)setValue:(id)value
 forKeyPathArray:(NSArray*)keyPathArray ;

/*!
 @brief    Sets a value for the given keyPath in the receiver,
 creating dictionaries as needed if they do not exist, and inserting
 values into existing dictionaries if they do exist.
 
 @details  The opposite method, -valueForKeyPath:, is provided by
 NSObject and works as expected.
 @param    value  
 @param    keyPath  
 */
- (void)setValue:(id)value
	  forKeyPath:(NSString*)keyPath ;

-      (void)addObject:(id)object
 toArrayAtKeyPathArray:(NSArray*)keyPathArray ;

- (void)addObject:(id)object
	 toArrayAtKey:(NSString*)key ;

- (void)addUniqueObject:(id)object
  toArrayAtKeyPathArray:(NSArray*)keyPathArray ;

- (void)addUniqueObject:(id)object
	       toArrayAtKey:(NSString*)key ;

-      (void)removeObject:(id)object
  fromArrayAtKeyPathArray:(NSArray*)keyPathArray ;

- (void)removeObject:(id)object
	  fromArrayAtKey:(NSString*)key ;

-              (void)removeKey:(id)object
  fromDictionaryAtKeyPathArray:(NSArray*)keyPathArray ;

-     (void)removeKey:(id)innerKey
  fromDictionaryAtKey:(NSString*)key ;

@end


#if 0
TEST CODE

NSDictionary* name = [NSDictionary dictionaryWithObjectsAndKeys:
					  @"Jerry", @"first",
					  @"Krinock", @"last",
					  nil] ;
NSDictionary* person = [NSDictionary dictionaryWithObjectsAndKeys:
						@"blue", @"color",
						name, @"name",
						nil] ;
NSDictionary* company = [NSDictionary dictionaryWithObjectsAndKeys:
						 @"Sheep Systems", @"name",
						 person, @"chief",
						 nil] ;
NSDictionary* companies = [NSDictionary dictionaryWithObjectsAndKeys:
						   @"Apple", @"hardware",
						   company, @"software",
						   nil] ;

NSMutableDictionary* aDictionary = [companies mutableCopy] ;
NSLog(@"BEFORE: %@", aDictionary) ;
NSArray* keyPathArray = [NSArray arrayWithObjects:@"software", @"chief", @"color", nil] ;
[aDictionary setValue:nil //@"red"
	  forKeyPathArray:keyPathArray] ;

NSLog(@"AFTER:  %@", aDictionary) ;
[aDictionary release] ;
#endif