#import <Foundation/Foundation.h>
#import "BkmxGlobals.h"

@class Clientoid;

/*!
 @details   NSSecureCoding may be required in case instances of this class are
 passed via XPC.  (I'n not sure whwether such passing happens or not.)  But,
 anyhow, if such passing does happen, te requirement is explained here:
 https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingXPCServices.html#//apple_ref/doc/uid/10000172i-SW6-SW7
 */
@interface Watch : NSObject <NSCopying, NSCoding, NSSecureCoding>

@property (atomic, assign) WatchType watchType;
@property (atomic, readonly) NSString* humanReadableType;

/* Depending on the watchType, subject may be a file path, a Extore subclass
 name (from which can be derived app bundle identifier(s), a recurring date,
 a time interval, or nil. */
@property (atomic, copy) NSString* subject;

@property (atomic, copy) NSString* docUuid;
@property (atomic, copy, readonly) NSString* shortDocUuid;

/* It is true that you can also discern appName from which app's user defaults
 a Watch object was read from.  But it is convenient to store it anyhow,
 so that after unarchiving the data object, the Watch object is complete
 and ready to go. */
@property (atomic, copy) NSString* appName;

@property (atomic, retain) Clientoid* clientoid;
@property (atomic, copy) NSString* syncerUri;
@property (atomic, copy) NSString* triggerUri;
@property (atomic, assign) NSInteger syncerIndex;
@property (atomic, assign) NSInteger triggerIndex;
@property (atomic, assign) NSInteger efficiently;
@property (atomic, assign) NSTimeInterval throttleInterval;
@property (atomic, assign) BOOL runAtLoad;
@property (atomic, assign) BOOL inProgress;

@property (atomic, readonly) NSString* cause;
@property (atomic, readonly) NSString* shortTriggerUri;
@property (readonly) BOOL isActive;
@property (readonly) NSString* uniqueIdentifier;

- (void)activate;
- (void)deactivate;


@end
