#import <Cocoa/Cocoa.h>

/*!
 @details  	The algorithm implemented in this class was
 reversed-engineered from Google's Chromium project source
 code, in particular:
 *  chromium/src/chrome/browser/bookmarks/bookmark_codec.cc
 and in there the functions
 *  BookmarkCodec::UpdateChecksumWithFolderNode()
 *  BookmarkCodec::UpdateChecksumWithUrlNode()
 *  BookmarkCodec::UpdateChecksum()
 Note from their parameter types that the "name" value,
 or as they call it in there, "title", is a string16
 and the others are std::string.  That's why we use
 NSUnicodeStringEncoding for the "name".
 
 SetTitle() and GetTitleAsString16() are defined (yes, defined!!) in
 *   chromium/src/app/tree_node_model.h
 They are simple setters and getters for the private variable title_
 in class TreeNode.  The variable title_ is declared as type string16.
 
 In chromium/src/o3d/breakpad/win/exception_handler_win32.cc,
 we find that string16 is typdeffed as a wstring:
 |    namespace std {
 |        typedef wstring string16;
 |    }
 
 Chromium's MD5Xxx (i.e., MD5Update(), etc.) functions are defined in
 four different files, and skimming quickly appear to be identical
 except for wrapping, in each:
 *    chromium/src/base/md5.cc
 *    chromium/src/breakpad/src/common/md5.c
 *    chromium/src/third_party/libjingle/files/talk/base/md5c.c
 *    chromium/src/third_party/sqlite/src/test_md5.c
 */
@class SSYDigester ;

@interface NSDictionary (ChromeDigester)

/*!
 @brief    Updates the digest being calculated in a given
 digester to include data from the receiver's "type", "id",
 "name" and "url" values, using the algorithm in Google's
 Chrome web browser.
*/
- (void)updateChromeDigester:(SSYDigester*)digester ;

@end

/*!
 @brief    This interface was added in BookMacster 1.13 to support the
 "meta_info" key recently discovered in Chrome bookmarks.
 */
@interface NSString (ChromeDigester)

/*!
 @brief    Updates the digest being calculated in a given
 digester to include data from the receiver, using the algorithm
 in Google's Chrome web browser.
 
 @param    digester  The digester which will be updated.
 */
- (void)updateChromeDigester:(SSYDigester*)digester ;

@end
