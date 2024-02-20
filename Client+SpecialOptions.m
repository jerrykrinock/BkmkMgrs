#import "Client+SpecialOptions.h"
#import "NSArray+Integers.h"
#import "Extore.h"
#import "NSString+TimeIntervals.h"
#import "BkmxBasis.h"
#import "Macster.h"

@implementation Client (SpecialOptions)

#pragma mark Internal Utility Methods

// For 1-bit values
- (BOOL)specialOptionBitForMask:(long long)mask {
	BOOL answer = (([[self specialOptions] longLongValue] & mask) != 0) ;
	
	return answer ;
}
- (void)setSpecialOptionBit:(BOOL)yn
					forMask:(long long)mask {
	long long value = [[self specialOptions] longLongValue] ;
	if (yn) {
		value |= mask ;
	}
	else {
		value &= ~mask ;
	}
	
	[self setSpecialOptions:[NSNumber numberWithLongLong:value]] ;
}

+ (long long)specialOptionsValueForMask:(long long)mask value:(long long)value {
    if (mask == 0) {
        return 0 ;
    }
    
    // Shift both mask and value right until the rightmost '1' in
    // mask is the least significant bit.
    while ((mask & 0x1LL) == 0) {
        mask = mask >> 1 ;
        value = value >> 1 ;
    }
    
    return mask & value ;
}

// For multi-bit values
- (long long)specialOptionValueForMask:(long long)mask {
	long long value = [[self specialOptions] longLongValue] ;
	
	// Defensive programming; avoid infinite loop ahead.
    return [[self class] specialOptionsValueForMask:mask value:value];
}
- (void)setSpecialOptionValue:(long long)newValue
					  forMask:(long long)mask {
	// Defensive programming; avoid infinite loop ahead.
	if (mask == 0) {
		return ;
	}
	
	// Shift mask right and value left until the rightmost '1' in
	// mask is the least significant bit.
	long long shiftedMask = mask ;
	while ((shiftedMask & 0x1LL) == 0) {
		shiftedMask = shiftedMask >> 1 ;
		newValue = newValue << 1 ;
	}
	
	// Zero out the non-masked bits in the left-shifted newValue
	newValue &= mask ;
	// Zero out the masked bits in the existing value
	long long value = [[self specialOptions] longLongValue] ;
	value &= ~mask ;
	// Combine
	value |= newValue ;
	
	[self setSpecialOptions:[NSNumber numberWithLongLong:value]] ;
}


#pragma mark Public Accessors for the actual Special Options

- (NSString*)toolTipLaunchBrowserPref {
	return @"Click the round Help button (?) for explanation of this control." ;
}

- (BOOL)doSpecialMapping {
	return [self specialOptionBitForMask:constBkmxIxportSpecialOptionBitmaskDoSpecialMapping] ;
}

- (void)setDoSpecialMapping:(BOOL)yn {
	[self setSpecialOptionBit:yn
					  forMask:constBkmxIxportSpecialOptionBitmaskDoSpecialMapping] ;
}

- (BOOL)dontWarnOwnerSync {
	return [self specialOptionBitForMask:constBkmxIxportSpecialOptionBitmaskDontWarnOwnerSync] ;
}

- (void)setDontWarnOwnerSync:(BOOL)yn {
	[self setSpecialOptionBit:yn
					  forMask:constBkmxIxportSpecialOptionBitmaskDontWarnOwnerSync] ;
}

- (NSInteger)launchBrowserPref {
    long long value = [self specialOptionValueForMask:constBkmxIxportSpecialOptionBitmaskLaunchBrowserPref] ;
    /* There are 3 defined values for launchBrowserPref: -1, 0 and 1.  But the
     values extracted using the bit mask are, of course, unsigned, The
     following converts the unsigned value to the two-bit signed value.*/
    if (value == 3) {
        value = -1 ;
    }
    return (NSInteger)value ;
}

- (void)setLaunchBrowserPref:(NSInteger)value {
    long long unsignedValue = value ;
    /* There are 3 defined values for launchBrowserPref: -1, 0 and 1.  But the
     values extracted using the bit mask are, of course, unsigned, The
     following converts the two-bit signed value to an unsigned value. */
    if (unsignedValue == -1) {
        unsignedValue = 3 ;
    }
	[self setSpecialOptionValue:(unsignedValue)
                        forMask:constBkmxIxportSpecialOptionBitmaskLaunchBrowserPref] ;
}

// Bound to in SpecialGooChromy, maybe other SpecialXxx.xib
- (NSString*)labelDontWarnOwnerSync {
	return [NSString stringWithFormat:@"Don't warn if %@'s built-sync is in use", [[self clientoid] displayName]] ;
}

// Bound to in SpecialGooChromy.xib, maybe other SpecialXxx.xib
- (NSString*)tooltipDontWarnOwnerSync {
	return [NSString stringWithFormat:@"If switched off, will warn you to make sure that %@'s built-sync is not syncing the same devices as %@",
	[[self clientoid] displayName],
	[[BkmxBasis sharedBasis] appNameLocalized]] ;
}

- (NSString*)labelNoLoosiesInMenu {
    return [NSString stringWithFormat:@"Don't export loose bookmarks to 'Folders'"] ;
}

- (NSString*)tooltipNoLoosiesInMenu {
    return [NSString stringWithFormat:@"If on, any loose bookmarks are put elsewhere"] ;
}

- (NSString*)labelFakeUnfiled {
    return [NSString stringWithFormat:@"Create a 'Reading/Unsorted'"] ;
}

- (NSString*)tooltipFakeUnfiled {
    return [NSString stringWithFormat:@"If on, makes a folder for 'Reading List' or 'Unsorted Bookmarks', like Safari and Firefox, in %@",
            [[self clientoid] displayName]] ;
}

- (BOOL)dontImportTrash {
	return [self specialOptionBitForMask:constBkmxIxportSpecialOptionBitmaskDontImportTrash] ;
}

- (void)setDontImportTrash:(BOOL)yn {
	[self setSpecialOptionBit:yn
					  forMask:constBkmxIxportSpecialOptionBitmaskDontImportTrash] ;
}

- (BOOL)assumeLoggedInToCorrectAccount {
	return [self specialOptionBitForMask:constBkmxIxportSpecialOptionBitmaskAssumeLoggedInToCorrectAccount] ;
}

- (void)setAssumeLoggedInToCorrectAccount:(BOOL)yn {
	[self setSpecialOptionBit:yn
					  forMask:constBkmxIxportSpecialOptionBitmaskAssumeLoggedInToCorrectAccount] ;
}

- (BOOL)noLoosiesInMenu {
    return [self specialOptionBitForMask:constBkmxIxportSpecialOptionBitmaskNoLoosiesInMenu] ;
}

- (void)setNoLoosiesInMenu:(BOOL)yn {
    [self setSpecialOptionBit:yn
                      forMask:constBkmxIxportSpecialOptionBitmaskNoLoosiesInMenu] ;
}

- (BOOL)fakeUnfiled {
    return [self specialOptionBitForMask:constBkmxIxportSpecialOptionBitmaskFakeUnfiled] ;
}

- (void)setFakeUnfiled:(BOOL)yn {
    [self setSpecialOptionBit:yn
                      forMask:constBkmxIxportSpecialOptionBitmaskFakeUnfiled] ;
}

- (BkmxIxportDownloadPolicy)downloadPolicyForImport {
    BkmxIxportDownloadPolicy value = (BkmxIxportDownloadPolicy)[self specialOptionValueForMask:constBkmxIxportSpecialOptionBitmaskDownloadPolicyForImport] ;
    return value ;
}

- (BkmxIxportDownloadPolicy)downloadPolicyForExport {
    BkmxIxportDownloadPolicy value = (BkmxIxportDownloadPolicy)[self specialOptionValueForMask:constBkmxIxportSpecialOptionBitmaskDownloadPolicyForExport] ;
    return value ;
}

- (void)setDownloadPolicyForImport:(BkmxIxportDownloadPolicy)policy {
    [self setSpecialOptionValue:policy
                        forMask:constBkmxIxportSpecialOptionBitmaskDownloadPolicyForImport] ;
    }

- (void)setDownloadPolicyForExport:(BkmxIxportDownloadPolicy)policy {
    [self setSpecialOptionValue:policy
                        forMask:constBkmxIxportSpecialOptionBitmaskDownloadPolicyForExport] ;
}

// Bound in SpecialHtml.xib
- (NSArray*)availableHttpRateInitials {
	return @[@0.2, @0.5, @1, @2, @5, @10];
}

- (NSArray*)availableHttpRateInitialsDisplayNames {
	NSArray* numbers = [self availableHttpRateInitials];
	NSMutableArray* displayNames = [[NSMutableArray alloc] init];
	for (NSNumber* number in numbers) {
		NSString* displayName = [NSString stringWithUnitsForTimeInterval:number.doubleValue
														   longForm:YES] ;
		[displayNames addObject:displayName] ;
	}

	NSArray* answer = [NSArray arrayWithArray:displayNames] ;
	[displayNames release] ;
	
	return answer ;
}

// Bound in SpecialHtml.xib
- (NSTimeInterval)httpRateInitial {
	return self.specialDouble0.doubleValue;
}

// Bound in SpecialHtml.xib
- (void)setHttpRateInitial:(NSTimeInterval)value {
    self.specialDouble0 = @(value);
}

// Bound in SpecialHttp.xib
- (NSArray*)availableHttpRateRests {
	return @[@15, @60, @300, @900, @1800, @3600, @7200, @14400] ;
}

- (NSArray*)availableHttpRateRestsDisplayNames {
	NSArray* numbers = [self availableHttpRateRests] ;
	NSMutableArray* displayNames = [[NSMutableArray alloc] init] ;
	for (NSNumber* number in numbers) {
		NSString* displayName = [NSString stringWithUnitsForTimeInterval:number.doubleValue
																longForm:YES] ;
		[displayNames addObject:displayName] ;
	}
	
	NSArray* answer = [NSArray arrayWithArray:displayNames] ;
	[displayNames release] ;
	
	return answer ;	
}

// Bound in SpecialHttp.xib
- (NSTimeInterval)httpRateRest {
    return self.specialDouble1.doubleValue;
}

// Bound in SpecialHttp.xib
- (void)setHttpRateRest:(short)value {
    self.specialDouble1 = @(value);
}

// Bound in SpecialHttp.xib
- (NSArray*)availableHttpRateBackoffs {
	return @[@1.0, @1.2, @1.5, @2.0, @5.0] ;
}

- (NSArray*)availableHttpRateBackoffsDisplayNames {
	NSArray* numbers = [self availableHttpRateBackoffs];
	NSMutableArray* displayNames = [[NSMutableArray alloc] init] ;
	for (NSNumber* number in numbers) {
		NSString* displayName = [NSString stringWithFormat:@"%0.2f", number.doubleValue];
		[displayNames addObject:displayName];
	}
	
	NSArray* answer = [NSArray arrayWithArray:displayNames] ;
	[displayNames release] ;
	
	return answer ;	
}

// Bound in SpecialHttp.xib
- (NSTimeInterval)httpRateBackoff {
    return self.specialDouble2.doubleValue;
}

// Bound in SpecialHttp.xib
- (void)setHttpRateBackoff:(short)value {
    self.specialDouble2 = @(value);
}

- (void)didEndDontWarnOwnerSyncSheet:(SSYAlertWindow*)alertWindow
						  returnCode:(NSInteger)returnCode
						 contextInfo:(void*)contextInfo {
	BOOL checkboxState = [alertWindow checkboxState] == NSControlStateValueOn ;
	[self setDontWarnOwnerSync:checkboxState] ;
	[[self macster] save] ;
}

@end
