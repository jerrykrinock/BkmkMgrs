#import <Cocoa/Cocoa.h>


/*!
 @brief    Category for transforming a Boolean value into "Import" or "Export"
 */
@interface NSNumber (IxportPolarityDisplay)

/*!
 @brief    Returns the localized word "Import" if the value of the
 receiver is BkmxIxportPolarityImport YES and "Export" if the value of the
 receiver is BkmxIxportPolarityExport */
- (NSString*)ixportPolarityDisplay ;

@end
