#import <Cocoa/Cocoa.h>


/*!
 @brief    Window controller subclass for the sheet which asks
 user which bookmarks -- since last when verified -- to verify.
 
 @details  
 
 Note: In the nib containing the sheet/window, make sure that in the
 window attribute "Visible on Launch" is NOT checked.  If it is,
 the window will display immediately as a freestanding window
 instead of the next line attaching it to hostWindow as a sheet.
 */
@interface VerifySinceController : NSWindowController {
	IBOutlet NSDatePicker* datePicker ;
	NSInteger selectedRadioTag ;
}

@property (assign) BOOL plusAllFailed ;

- (IBAction)ok:(id)sender ;

- (IBAction)cancel:(id)sender ;

- (NSDate*)since ;

@end
