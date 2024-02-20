#import <Cocoa/Cocoa.h>


@interface ActiveBrowserObserver : NSObject {
	BOOL m_isObserving ;
}

+ (ActiveBrowserObserver*)sharedObserver ;

/*
 @brief    Starts the receiver to start observing for the active browser
 
 @details  Starting is also done whenever a
 SSYShortcutActuatorDidNonemptyNotification notification is posted.
 */
- (void)startObserving ;

/*
 @brief    Stops the receiver's observing for the active browser
 
 @details  Stopping is also done whenever a
 SSYShortcutActuatorDidEmptyNotification notification is posted.
 */
- (void)stopObserving ;

/*!
 @brief    Manually runs the observer method which checks to see whether or
 not the active app is a web browser

 @details  This observer method is also the "worker" which is run whenever
 an app.

 You should call this method just after calling -startObserving, if you want
 keyboard shortcuts to be enabled because a web browser is active initially.
 In other words, it is for "initial conditions".  The following paragraphs
 explain the "edge edge" cases which make this necessary.  It is not very
 interesting.  You could just say this method should be called as a mtter of
 good practice.  But here goes…

 The BkmkMgrs app’s Global Keyboard Shortcuts are only enabled whenever the
 user activates a app which is a web browser, and are disabled whenever user
 activates a app which is not a web browser.  This is to reduce unnecessary
 resource usage, and also so that the user can share the same keyboard
 shortcuts in other, non-web-browser applications for other purposes.

 If the user does not set the “Launch in Background” checkbox, the keyboard
 shortcuts will always be enabled immediately after launching the BkmkMgrs app,
 because, no matter how the user launches the BkmkMgrs app, the BkmkMgrs app
 becomes, at least momentarily, the active app, *and* there is a delay of a
 second or two before user manually re-activates a web browser.  This second or
 two allows time for the BkmkMgrs app to load and begin observing for apps to
 activate.  So the BkmkMgrs app will be observing and catch the activation or
 re-activation of the web browser.  I suppose if the user is really fast, the
 BkmkMgrs app might miss it, but this rarely happens.

 Even if the user sets “Launch in Background”, the keyboard shortcuts will
 always be enabled immediately after launching the BkmkMgrs app when the user
 launches the BkmkMgrs app from Finder.  This is because, although the BkmkMgrs
 app only activates for a brief second to show a progress bar, when the
 BkmkMgrs app de-activates, macOS re-assigns Finder as the active app.
 Therefore the user must manually switch the active app from Finder to the web
 browser, which is observed by the BkmkMgrs app.

 However, LaunchPad or Dock are themselves background applications which do not
 show a user interface at all, and therefore never become the active app.  So
 if a web browser is the active app, and the user launches the BkmkMgrs app
 from LaunchPad or Dock, the web browser is still the active app, and when the
 BkmkMgrs app de-activates, macOS re-assigns the web browser as the active app.
 But this re-assignment happens very quickly, before the BkmkMgrs app has begun
 observing for apps to activate.  So the BkmkMgrs app misses the activation of
 the web browser, and does not enable its keyboard shortcuts.

 The obvious fix for this is add an additional trigger to the observer method
 which checks to see if the active app is a web browser, when observing begins,
 and to invoke this “manually” during -applicationDidFinishLaunching.
 */
- (void)observeNow;

@end
