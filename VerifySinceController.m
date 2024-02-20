#import "VerifySinceController.h"


@interface VerifySinceController ()

@property (assign) NSInteger selectedRadioTag ;

@end


@implementation VerifySinceController

@synthesize selectedRadioTag ;

+ (NSSet*)keyPathsForValuesAffectingCanSetDate {
	return [NSSet setWithObjects:
			@"selectedRadioTag",
			nil] ;
}

- (void)awakeFromNib {
	[datePicker setObjectValue:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*(-14))]] ; // 14 days ago
}

- (BOOL)canSetDate {
	return ([self selectedRadioTag] == 2) ;
}

- (NSDate*)since {
	NSDate* since ;
	switch ([self selectedRadioTag]) {
		case 0:
			// All bookmarks
			since = [NSDate distantFuture] ;
			break ;
		case 1:
			// Only bookmarks never verified
			since = [NSDate distantPast] ;
			break ;
		case 2:
        default:
			// Only bookmarks not verified since picked date
			since = [datePicker objectValue] ;
			break ;
	}
	
	return since ;
}
	

- (void)endWithReturnCode:(NSInteger)returnCode {
    [[[self window] sheetParent] endSheet:[self window]
                               returnCode:returnCode] ;
	[[self window] close] ;
    
	// Window is set to "Release when closed" in xib
	// The windowController (self) is released in the completion handler
    // inside -[BkmxDoc(Actions) verify:].
}

- (IBAction)ok:(id)sender {
	[self endWithReturnCode:NSAlertFirstButtonReturn] ;
}


- (IBAction)cancel:(id)sender {
	[self endWithReturnCode:NSAlertSecondButtonReturn] ;
}

@end
