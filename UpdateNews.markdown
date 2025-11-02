<!-- # Latest Updates for Smarky, Synkmark, Markster and BookMacster -->

## Version 3.3.2 (2025-11-)

*  <img src="images/BookMacster. png" alt="" class="whappMini" />  Fixed a bug, probably introduced last year sometime which caused, when configuring a new Diigo or Pinboard client, switching on the *Save password to my macOS Keychain* checkbox to in fact not do that.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> In the document window > Now behaves safely and properly in macOS 26 Tahoe if user performs a File > Duplicate operation and affirms overwriting an existing .bmco file.  (No longer raises an internal assertion.)

## Version 3.3.1 (2025-09-12)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> In the document window > Now works with the latest version of Opera, no more Error 594520.  (Opera has corrected the index values for the first-level children in their bookmarks tree.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> In the document window > Content tab, restored images to the "Outline Mode / Table Mode" button which somehow got deleted in version 3.3.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> In the Manage Browser Extensions window, fixed alignment of Version and Status indicators along the right edge, which were improperly displaced in version 3.3.

## Version 3.3 (2025-09-09)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> New app icon and other cosmetic repairs for compatibility with macOS 26 Tahoe.

## Version 3.2 (2025-07-11)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now compatible with the [new syncing paradigm](https://developer.chrome.com/blog/bookmarks-sync-changes) in Chromium-based (["Chrome-ish"](chromish)) browsers which is being phased in to Google Chrome and Canary, and could be adopted by Brave, Microsoft Edge, Orion and Vivaldi without warning.  As part of this change, our apps will no longer attempt our *quick direct sync* method of import or export if the target browser is not running or if our *BookMacster Sync* extension is not installed in that browser.  All imports and exports must now be performed while the target web brwoser is running, and *BookMacster Sync* is installed into it and is running.  (As before, our app will attempt to quietly launch the target web browser when needed and then quit the web browser when done.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now supports imports and exports with the *[Opera Air](https://www.opera.com/air) web browser.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Imports from the current version of Opera now land in the correct folder in your Collection.

## Version 3.1.9 (2025-04-01)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now recovers gracefully if a Chrome-ish profile folder is missing.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The *Delete All Content* function no longer deletes [hard folders](), which caused errors to occur later.

## Version 3.1.8 (2024-10-28)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused a crash that was introduced in version 3.1.7 and modernized more old code.  (Date from browser extensions to main app is no longer encoded with NSKeyedArchiver.)

## Version 3.1.7 (2024-10-14)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Replaced old code, which was causing at least one rare issue, with newer Apple code that is available in recent macOS versions.  The rare issue was failure to import bookmarks from Chrome-ish browsers if a bookmark name contained invisible, undefined characters.  But since the replaced code is used in many parts of the app, this fix could resolve other unreported, weird, rare issues also.  (Replaced some uses of BSJSONAdditions with NSJSONSerialization.)

## Version 3.1.6 (2024-09-23)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Much less likely to display Error 592957 or 582958, which has been seen by some users particularly after logging in to their Mac if our app was running before logging out, and the checkbox "Reopen windows when logging back in" in the system's confirmation dialog was on.  (Increased the timeout before displaying Error 592957 or 582958 from 6.4 seconds to 60.1 seconds.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Syncing Status Report now correctly shows how long ago any BkmxAgent was launched instead of "???" as it has in recent versions.

## Version 3.1.5 (2024-09-09)

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Now includes a workaround for an apparent bug (FB14892799) in macOS 15.0 Sequoia which causes failure to open any second or subsequent .bmco document after launching BookMacster and opening a first .bmco document.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Removed the *Upgrade Insecure Bookmarks* feature because it rarely upgrades any bookmarks nowadays – Any sites which still do not support *https* are probably going to die before they do.  So using this feature has become pretty much a waste of users' time.

## Version 3.1.4 (2024-08-16)

Version 3.1.4 has some fixes for users with macOS 13 or earlier.  If, like most people, you are using macOS 14 or later, you should *Skip* this update.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now includes a workaround for a bug in recent versions of macOS 11-13 which caused Error 582958 when switching syncing between Ready and Paused or Off.

## Version 3.1.3 (2024-07-20)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which probably caused Error 582958 when switching syncing between Ready and Paused or Off, or Show Syncing Status, when running in macOS 11 - 13.

## Version 3.1.2 (2024-07-19)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved the information provided with Error 582958 in some cases.

## Version 3.1.1 (2024-07-17)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the document window, tab Reports > Verify, clicking the little magnifying glass buttons now set the predicate as expected when the Reports > Find tab is opened, as it worked in previous versions of macOS.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The app package no longer contains either of our web browser extensions.  When installing either into Firefox, our app now downloads the latest version from our repository at mozilla.org.

## Version 3.1 (2024-05-28)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Updated methods for running our background agent (BkmxAgent) per recent Apple recommendations and deprecations.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now works properly with current version of Opera web browser.  (Running Opera 103 or 104 may create a *Default* profile subfolder, as Chrome and Edge have, and move your profile data into it.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Can now import, export and (in Synkmark and BookMacster) sync with bookmarks in the Orion web browser.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Corrected the error recovery suggestion, a recovery mechanism, and Help Book text which in some cases advised user to use the *quick direct* sync method if an export operation failed because the *BookMacster Sync*.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer misses if Chrome Sync is on, and therefore presents the expected warning about sync loops, when using Chrome 123 or later.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved part of the process of importing from and exporting to Safari, so that it will no longer hang and eventually fail with Error 772041 on some Macs.  (Now uses a system function instead of a unix tool to get the machine heardware UUID that is used for file locking.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />   Replaced an old macOS system call which has become unreliable in macOS 14 (sometimes "just doesn't work") with a newer macOS system call that, in our testing, works every time.  This may affect many operations, including but not limited to: stopping old BkmxAgent processes after an upgrade of the app,  Show Syncing Status, document opening.  (Replaced NSTask with Swift's Process.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer migrates syncing configuration when upgrading from version 2.4.8 and earlier, which was 7 years ago.

*   <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />   If user accidentally commands landing a new bookmark when a browser is the active application, but that browser has no brpwser window open, now opens our Dock or Status Item menu instead of displaying an error dialog.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Added a new item in main menu > Help: "Wipe clean Safari and iCloud…"

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Re-entering an incorrect or missing password for Diigo or Pinboard now works correctly.

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  The running or not running state of our backgrouond syncing agent (BkmxAgent) is now checked and corrected if necessary on every BookMacster launch.  In particular, BkmxAgent is launched if necessary even if the .bmco document(s) which require syncing are not opened during the launch.

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  In the Collection document window, tab Settings > Syncing > Simple, the *Full Syncing* / *No Syncing* button now indicates the correct title again.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now acknowledges and supports multiple profiles in the Vivaldi web browser.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Updated *drag and drop* code to remove methods which have been deprecated by Apple.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer migrates syncing configuration when upgrading from version 2.4.8 and earlier, which was 7 years ago.

## Version 3.0.12 (2023-01-24)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now correctly imports and exports Tags with the current version of iCab.

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which caused a crash when editing non-empty Advanced Client Settings in macOS 13.2.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which caused deleting a Tag from the Tags View to only decrement the number of bookmarks it was related to.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed an annoying error, sometimes displayed as a dialog, indicating that another error could not be archived.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Apparently, fixed a rare crash which could occur when closing a document.  (BSManagedDocument now uses ARC.)

## Version 3.0.11 (2023-01-08)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Increased reliability of exports to Safari being pushed to some problematic iCloud accounts and into users' other Apple devices.

## Version 3.0.10 (2022-11-29)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Restored ability to change bookmark *colors*, which had been causing failure to save document, probably since version 3.0.

*  <img src="images/Smarky.png" alt="" class="whappMini" />  In the built-in store, purchasing a license for Smarky now returns and installs a license for Smarky 3 instead of a useless license for Smarky 2.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  If a *save* operation is interrupted because the app was not licensed, and the user is offered a license, and obtains one, fixed a bug which caused the offer window to appear again after the save operation.

For earlier version changes, see the [Version History](https://sheepsystems.com/bookmacster/HelpBook/SSYMH.05.03.html).
