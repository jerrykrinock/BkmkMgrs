#import <Cocoa/Cocoa.h>
#import "IxportLog.h"

@interface ExportLog : IxportLog {
	
}

@property (retain) NSString* exporterDisplayName ;
@property (retain) NSString* exporterUri ;

/*!
 @brief    Returns whether or not the changes in the receiver exactly
 match those of another given export log, assuming that the exporter
 clients are the same
*/
- (BOOL)hadSameEffectAsExportLog:(ExportLog*)other ;

@end
