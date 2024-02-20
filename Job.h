#import "BkmxGlobals.h"


extern NSString* const constKeyJobCause;
extern NSString* const constKeyJobDocUuid;
extern NSString* const constKeyJobAppName;
extern NSString* const constKeyJobReason;
extern NSString* const constKeyJobSerial;
extern NSString* const constKeyJobSyncerUri;
extern NSString* const constKeyJobSyncerIndex;
extern NSString* const constKeyJobTriggerUri;
extern NSString* const constKeyJobTriggerIndex;
extern NSString* const constKeyJobTriggerType;
extern NSString* const constKeyJobClidentifier;


/*!
 @details   NSSecureCoding is required because instances of this class are
 passed via XPC.  See:
 https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingXPCServices.html#//apple_ref/doc/uid/10000172i-SW6-SW7
 */
@interface Job : NSObject <NSCoding, NSSecureCoding>

@property (copy) NSString* cause;
@property (copy) NSString* docUuid;
@property (copy) NSString* appName;
@property (assign) AgentReason reason;
@property (assign) NSInteger serial;
@property (copy) NSString* syncerUri;
@property (assign) NSInteger syncerIndex;
@property (copy) NSString* triggerUri;
@property (assign) NSInteger triggerIndex;
@property (assign) BkmxTriggerType triggerType;
@property (copy) NSString* clidentifier;
@property (copy) NSDate* dateStagingWasSet;  // for logging, debugging only
@property (copy) NSDate* stagingFireDate;  // for logging, debugging only

@property (readonly) NSString* serialString;

+ (NSString*)serialStringForSerial:(NSInteger)serial;

@end
