@interface NSData (ASCII)

/*!
 @brief    Returns a string formed by interpreting the receiver
 as a string of MacRoman characters, with the carriage return,
 line feed and tab characters replaced by the MacRoman symbol for 0xff.
*/
- (NSString*)asciiReadable ;

@end
