#import <Cocoa/Cocoa.h>
#import "Client.h"

@interface Client (SpecialOptions)

// Used by Multiple Clients

+ (long long)specialOptionsValueForMask:(long long)mask value:(long long)value;

- (BOOL)doSpecialMapping ;
- (void)setDoSpecialMapping:(BOOL)yn ;
- (BOOL)dontWarnOwnerSync ;

- (NSInteger)launchBrowserPref;
- (void)setLaunchBrowserPref:(NSInteger)value;

- (BkmxIxportDownloadPolicy)downloadPolicyForImport ;
- (BkmxIxportDownloadPolicy)downloadPolicyForExport ;
- (void)setDownloadPolicyForImport:(BkmxIxportDownloadPolicy)yn ;
- (void)setDownloadPolicyForExport:(BkmxIxportDownloadPolicy)yn ;

- (long long)specialOptionValueForMask:(long long)mask;

// ExtoreOpera Clients only

- (BOOL)dontImportTrash ;
- (void)setDontImportTrash:(BOOL)yn ;

// ExtoreGoogle (now extinct) Clients only

- (BOOL)assumeLoggedInToCorrectAccount ;
- (void)setAssumeLoggedInToCorrectAccount:(BOOL)yn ;

// ExtoreChromy Clients only

- (BOOL)noLoosiesInMenu ;
- (void)setNoLoosiesInMenu:(BOOL)yn ;

- (BOOL)fakeUnfiled ;
- (void)setFakeUnfiled:(BOOL)yn ;

// ExtoreHttp Clients only

- (NSTimeInterval)httpRateInitial;

- (NSTimeInterval)httpRateRest;

- (CGFloat)httpRateBackoff;

- (void)didEndDontWarnOwnerSyncSheet:(NSWindow*)alertWindow
						  returnCode:(NSInteger)returnCode
						 contextInfo:(void*)contextInfo ;
@end
