#import <Cocoa/Cocoa.h>
#import "HtmlCodec.h"

@interface HtmlEncoder : HtmlCodec {

}

+ (BOOL)generateHtmlExportData_p:(NSData**)data_p
                          extore:(Extore*)extore
                         error_p:(NSError**)error_p ;

@end
