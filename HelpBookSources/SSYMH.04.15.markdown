# Hiding and Scripting <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [hideAndScript]

## Should I Leave It Running? <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [leaveRunning]

### Smarky or Synkmark

After you switch Syncing to *Ready*, Bkmthe [BkmxAgent]() syncs your browsers' bookmarks in the background whenever changes are detected, but only after Smarky or Synkmark are quit.   Whenever Smarky or Synkmark are running, syncing is suspended so that you may edit your bookmarks without conflicts due to imports from browsers.

Therefore, you should not leave Smarky or Synkmark running, and should not add them to your Login Items in your System Preferences.   **After the initial configuration, you should only run Smarky or Synkmark when you want to do bookmarks housecleaning**, typically once a week, month or whatever.

To be truthful, you *can* do bookmarks housecleaning in a browser such as Safari or Firefox if you want to.  If so configured, Synkmark will sync your changes to other browsers.  However, we do not recommend doing this for more than a minute because:

* The user interface in Smarky and Synkmark is much better, and has way more tools available, than the bookmarks editor windows in any web browser.  Doing major bookmarks editing in a web browser would be like doing your weekly grocery shopping in the junk food aisle of a gas (petrol) station, instead of in the supermarket which is next door.

* A few minutes after you make any change in a web browser, every if you have a [Syncer](syncers) configured it to sort, [BkmxAgent]() will dutifully try to swoop in and sort your bookmarks, right under your nose.  In some cases, changes you made in the last few seconds may  be overwritten.  Very annoying!

* In those same operations, [BkmxAgent]() will sync your latest changes to other browsers.  This is a waste of resources, and you may even notice it slowing down your Mac, especially if you have thousands of bookmarks.  The web browsers themselves are not optimized for editing large collections.  It is much better to do your editing in Smarky or Synkmark, while syncing is automatically suspended, and then when you are done, export all of your changes at once.  Smarky or Synkmark will thoughfully remind you to do so.

### Markster

In contrast, Markster is designed to be left running continuously so that you may add or visit bookmarks from web browsers.  You *do* probably want to add Markster to your Login Items in your System Preferences.

### BookMacster  

BookMacster can be used for both *syncing* and *direct* bookmarking.

If you use BookMacster primarily for [syncing](useSync) among browser clients, the advice given above for *Smarky or Synkmark* applies to *BookMacster* in your case, except that you need not completely quit BookMacster for syncing to resume.  You need only close the window of that  `.bmco` document which has syncing *Ready*.

If you use BookMacster primarily for  [*direct* bookmarking](useDirectly), you should leave BookMacster running, and you *do* probably want to add BookMacster to your Login Items in your System Preferences.

## Hiding [hideBkmx]

### Minimize to the Dock <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [minimizeToDock]

In macOS, you may minimize a window to your [Dock](http://support.apple.com/kb/HT2307) by typing ⌘M.

### Running it *in the background* <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [backgrounding]

#### Preference for how the app is *launched*

In Markster or BookMacster, in *Preferences* > *General*, there is a checkbox to *Launch in Background*.  If you switch that box on, the next time you launch the app it will be a *background application*, meaning that it will not appear in your Dock and not appear in your ⌘-tab [Application Switcher](http://support.apple.com/kb/HT2307?viewlocale=en_US&locale=en_US).

To enable that checkbox, you must have set either a [keyboard shortcut to the app's Floating Menu]() or else enabled the app's [Menu Extra]().  That is because you must have at least one means available to interact with the app.  (If *Launch in Background* is on and you violate this by switching both of these off, the app will silently switch *Launch in Background* off.)

If you are running Markster or BookMacster in the background, without the Menu Extra, wherein the only way to interact with the app is via your keyboard shortcut to its Floating Menu, you are in a "super stealth" background mode wherein the app is completely invisible.  When the app is launched in this mode, a notification appears in the macOS Notification Center reminding you of the keyboard shortcut which is necessary to show the app.

<div class="screenshot">
<img src="images/BackgndNote.png" alt="" />
</div>

If BookMacster is currently running and you forgot the keyboard shortcut, force quit and then re-launch BookMacster while watching the upper right corner of your screen for such a momentary notification.  The following standard abbreviations are used to indicate which modifier key(s) must be held down:

* ⌘ = *command* key
* ⌥ = *option* / *alt* key
* ⌃ = *control* key

For example, if the notification says *⌘⌥⌃B*, you must activate a web browser (such as Safari or Firefox), hold down the *command*, *option*, *control* keys, and then hit the *B* key.

#### Switching Between Background and Foreground

Regardless of how Markster or BookMacster is launched, you may want to switch it from one Background to Foreground or vice versa.  To switch the app from the foreground into the background, clicking *Background Markster|BookMacster* in either the [application menu](), [Dock Menu]() or [Menu Extra]().

## Scripting [scriptingBkmx]

Smarky, Synkmark, Markster and BookMacster implement some [AppleScript](https://developer.apple.com/library/mac/#documentation/AppleScript/Conceptual/AppleScriptX/Concepts/work_with_as.html#//apple_ref/doc/uid/TP40001568-BABEBGCF) commands which make additional behaviors possible.  For example,

* Users who want more fine-grained control over when their bookmarks are synced than is available from BookMacster's built-in [Triggers]() may delete all of an Triggers of a Syncer and instead trigger the [Syncer]() to *perform* with their own AppleScript.

* New bookmarks may be landed into Markster or BookMacster directly from other scriptable applications such as NetNewsWire.

To get started AppleScripting , launch AppleScript Editor and File > Open the app's scripting dictionary.  Also, [download BookMacster's sample AppleScripts](https://sheepsystems.com/bookmacster/BookMacster-AppleScripts.zip).
