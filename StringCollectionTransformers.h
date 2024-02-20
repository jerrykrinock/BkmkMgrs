#import <Cocoa/Cocoa.h>

/*
 http://en.wikipedia.org/wiki/UTF-8, "Unlike UTF-16, byte values of 0 (The ASCII
 NUL character) do not appear in the encoding unless U+0000 (the Unicode NUL
 character) is represented. This means that string functions from the standard C
 library (such as strcpy()) which use a null terminator will correctly handle
 UTF-8 strings (whereas many UTF-16 strings will be prematurely truncated by
 use of the standard functions)."
*/ 

/*!
 @brief    Transforms an set of strings by concatenating them into an
 NSData separated by NULL delimiters.
 
 @details  No escaping is performed, so the strings themselves must not
 contain any NULL characters.  Fortunately, UTF-8 strings will never
 contain NULL characters.
 */
@interface TransformStringsSetToData : NSValueTransformer {
}

@end

/*!
 @brief    Transforms an array of strings by concatenating them into an
 NSData separated by NULL delimiters.
 
 @details  No escaping is performed, so the strings themselves must not
 contain any NULL characters.  Fortunately, UTF-8 strings will never
 contain NULL characters.
 
 In a test involving 100K strings of 6 characters each, compared to
 Core Data's default transformer of NSKeyed(Secure?)UnarchiveFromData,
 the time to do the reverse transformation was about the same,
 but the size of the sqlite file is reduced by a factor of ~ 3
 if you use this transformer instead.
 */
@interface TransformStringsArrayToData : NSValueTransformer {
}

@end

#if 0
// Here's a simple little round-trip test method for this class
- (void)testArray:(NSArray*)a {
    NSValueTransformer* tx = [NSValueTransformer valueTransformerForName:@"TransformStringsArrayToData"] ;
    NSData* data = [tx transformedValue:a] ;
    NSArray* aa = [tx reverseTransformedValue:data] ;
    BOOL ok = [aa isEqualToArray:a] ;
    NSLog(@"%@ for array: %@", ok ? @"PASS" : @"FAIL", a) ;
}
#endif

