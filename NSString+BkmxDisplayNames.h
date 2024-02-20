#import <Cocoa/Cocoa.h>

@interface NSString (BkmxDisplayNames)

- (NSString*)bkmxAttributeDisplayName ;

/*!
 @brief    Transforms an exformat string to its display name.
 */
- (NSString*)exformatDisplayName ;

/*!
 @brief    Used in the BkmxDoc nib file.  Transforms the 'method'
 instance variable of a Command object to human readable, returning
 nil if a human readable version is not known.
 */
- (NSString*)methodDisplayName ;

/*!
 @brief    Used in BkmxDoc.xib, Inspector.xib Transforms the 'visitor'
 instance variable of a Stark or Bookshig object to human readable.
 */
- (NSString*)displayNameForVisitor ;


/*!
 @brief    Returns the display name for a given value, assuming that the key
 for interpreting the value is the receiver of the message
 
 @details  In most cases, simply returns the given value.
 */
- (NSString*)bkmxDisplayNameForValue:(NSString*)value ;

@end
