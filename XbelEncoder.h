#import <Cocoa/Cocoa.h>
#import "XbelCodec.h"

@interface XbelEncoder : XbelCodec {

}

+ (BOOL)generateXbelExportData_p:(NSData**)data_p
			 extore:(Extore*)extore
			error_p:(NSError**)error_p ;

@end
