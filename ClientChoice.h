#import <Cocoa/Cocoa.h>

@class Clientoid ;

/*!
 @brief    A thin wrapper around a Clientoid object, or a
 placeholder which allows users to choose "Other Mac Account" or
 "Choose File" instead of an existing client.

 @details  A client choice which wraps a Clientoid object
 will have a non-nil clientoid ivar and a nil selector.
 A client choice which wraps a placeholder will have a nil
 clientoid and a non-nil selector.
*/
@interface ClientChoice : NSObject {
	Clientoid* m_clientoid ;
	SEL m_selector ;
	id m_object ;
	BOOL m_isInUse ;
}

/*!
 @brief    The receiver's title, suitable for display as the title
 of a (popup) menu item.
*/
@property (readonly) NSString* displayName ;

@property (retain) Clientoid* clientoid ;
@property (assign) SEL selector ;
@property (retain) id object ;
@property (assign) BOOL isInUse ;

/*!
 @brief    Returns a ClientChoice with parameters matching that of a given
 Clientoid object

 @details  Returns a ClientChoice even if clientoid is nil.
 This is so that the localized "No Selection" placeholder can be
 returned for displayName and appear in the popup in this case.
 @param    clientoid  The clientoid that is being wrapped
*/
+ (ClientChoice*)clientChoiceWithClientoid:(Clientoid*)clientoid ;

+ (ClientChoice*)clientChoiceInvolvingLooseFile ;

+ (ClientChoice*)clientChoiceNewOtherAccountForWebAppExformat:(NSString*)exformat ;

- (NSComparisonResult)comparePopularity:(ClientChoice*)otherClientChoice ;

- (BOOL)isLocalThisUserNotInChoices:(NSArray*)choices ;

@end
