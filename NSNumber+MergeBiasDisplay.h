#import <Cocoa/Cocoa.h>


/*!
 @brief    Category for transforming a BkmxMergeBias value to a human-readable name
 
 @details  This category is referenced in bindings in BkmxDoc.nib.
 */
@interface NSNumber (mergeBiasDisplay)

/*!
 @brief    Returns a localized, human-readable expression of the
 receiver, interpreted as an BkmxFabricateFolders enumerated value.
 The names are assigned appropriate to the Import context.
 */
- (NSString*)mergeBiasImportDisplayName ;

/*!
 @brief    Returns a localized, human-readable expression of the
 receiver, interpreted as an BkmxFabricateFolders enumerated value.
 The names are assigned appropriate to the Export context.
 */
- (NSString*)mergeBiasExportDisplayName ;

@end
