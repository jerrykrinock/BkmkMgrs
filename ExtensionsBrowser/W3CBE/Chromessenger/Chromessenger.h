#import <Cocoa/Cocoa.h>

/* I'm pretty sure this is fixed now, and the code enabled by this macro
 should be removed. */
#define DEBUG_RARE_CHROMESSENGER_EXTORE_AND_PROFILE_NAMES_DISAPPEARING_651507 1

@class BkmxChangeNotifier ;

@interface Chromessenger : NSObject {
    BkmxChangeNotifier* m_changeNotifier ;
    NSData* m_carryoverData ;
    NSData* m_carryoverLengthBytes ;
    uint32_t m_owedBytes ;
}

@property (retain) BkmxChangeNotifier* changeNotifier ;

+ (NSString*)extensionInstallInfoPath ;

+ (Chromessenger*)sharedMessenger ;

- (void)handleStdinData:(NSData*)dataIn ;

- (void)sendWholeTree ;

- (void)sendGeneralInfo ;

- (BOOL)putExportAndSendExidsFromJsonText:(NSString*)jsonString
                                  error_p:(NSError**)error_p;

- (void)grabCurrentPageInfo ;

@end
