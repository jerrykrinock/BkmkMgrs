#import "SyncStatusTextField.h"
#import "BkmxBasis+Strings.h"

NSString* constKeySyncStatus = @"syncStatus" ;

@implementation SyncStatusTextField

+ (void)initialize {
	if (self == [SyncStatusTextField class] ) {
		[self exposeBinding:constKeySyncStatus] ;
	}
}


- (void)update {
    NSString* title;
    NSString* tooltip;
    NSColor* color;
    switch (m_syncStatus) {
		case NSControlStateValueOn:
            title = @"ready" ;
            tooltip = [[BkmxBasis sharedBasis] tooltipSyncStatusOn];
            color = [NSColor colorWithCalibratedRed:(18.0/255)
                                              green:(139.0/255)
                                               blue:(2.0/255)
                                              alpha:1.0] ;
			break ;
		case NSControlStateValueOff:
            title = @"paused" ;
            tooltip = [[BkmxBasis sharedBasis] tooltipSyncStatusOff];
            color = [NSColor redColor] ;
			break ;
		case NSControlStateValueMixed:
        default:
            title = @"not configured" ;
            tooltip = [[BkmxBasis sharedBasis] tooltipSyncStatusDis];
            color = [NSColor controlTextColor] ;
			break ;
	}
    
    title = [NSString stringWithFormat:
              @"Syncing is\n%@.",
              title] ;
    
    [self setDrawsBackground:YES];
    [self setStringValue:title];
    [self setToolTip:tooltip];
    [self setTextColor:color];
}

- (void)setSyncStatus:(NSInteger)syncStatus {
	if (syncStatus == m_syncStatus) {
		return ;
	}
	
	m_syncStatus = syncStatus ;
	
	[self update] ;
}

- (NSInteger)syncStatus {
    return m_syncStatus ;
}

// Added to fix bug in BookMacster 1.19.9
- (void)awakeFromNib {
    [self update] ;
}

@end
