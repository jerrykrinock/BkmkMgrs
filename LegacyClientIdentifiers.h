#import <Cocoa/Cocoa.h>

@class Clientoid ;

/*!
 @brief    A class which converts legacy clientIdentifier
 strings into equivalent Clientoid objects.
 
 @detail  
 <p><b>Overview</b></p>
 <p>A client is uniquely identified by either by its <i>legacy clientIdentifier</i>,
 although other supplemental data (aliasData, browserName) is needed for some types.&nbsp;
 This class provides a method for creating a new Clientoid object from this identifier and
 supplemental data.</p>
 */
@interface LegacyClientIdentifiers : NSObject {
}

/*!
 @brief    Given a legacy client identifier and its associated
 info dictionary from the Clients key of Bookdog user defaults,
 builds a clientoid based on the extracted information.

 @param    legacyIdentifier  
 @param    moreInfo  An optional dictionary of extra information to help
 with loose clientoid types.&nbsp; May contain values for keys @"browserName",
 @"aliasData", and @"filePath".
 @result   A clientoid with the same identification as the given data,
 or nil if enough nonambiguous data to make a useable client could not be
 extracted, or the client type is no longer supported.
*/
+ (Clientoid*)clientoidFromLegacyClientIdentifier:(NSString*)legacyIdentifier
                                         moreInfo:(NSDictionary*)moreInfo
                             localizedErrorReason:(NSString**)reason_p ;

@end