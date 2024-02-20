#import <Cocoa/Cocoa.h>

// I do not use NSNotFound because this is used as attribute values,
// Exporter_entity.safeLimit and Macster_entity.safeLimitImport
// where they are type Integer 32.
#define BKMX_NO_LIMIT 0x7fffffff

@interface NSNumber (LimitsDisplay)

@end
