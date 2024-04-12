<!-- # Latest Updates for Smarky, Synkmark, Markster and BookMacster -->

## Version 3.1 (2023-04-15)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Updated methods for running our background agent (BkmxAgent) per recent Apple recommendations and deprecations.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now works properly with current version of Opera web browser.  (Running Opera 103 or 104 may create a *Default* profile subfolder, as Chrome and Edge have, and move your profile data into it.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Can now import, export and (in Synkmark and BookMacster) sync with bookmarks in the Orion web browser.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Corrected the error recovery suggestion, a recovery mechanism, and Help Book text which in some cases advised user to use the *quick direct* sync method if an export operation failed because the *BookMacster Sync*.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer misses if Chrome Sync is on, and therefore presents the expected warning about sync loops, when using Chrome 123 or later.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved part of the process of importing from and exporting to Safari, so that it will no longer hang and eventually fail with Error 772041 on some Macs.  (Now uses a system function instead of a unix tool to get the machine heardware UUID that is used for file locking.)

*   <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />   If user accidentally commands landing a new bookmark when a browser is the active application, but that browser has no brpwser window open, now opens our Dock or Status Item menu instead of displaying an error dialog.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Added a new item in main menu > Help: "Wipe clean Safari and iCloud…"

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Re-entering an incorrect or missing password for Diigo or Pinboard now works correctly.

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  The running or not running state of our backgrouond syncing agent (BkmxAgent) is now checked and corrected if necessary on every BookMacster launch.  In particular, BkmxAgent is launched if necessary even if the .bmco document(s) which require syncing are not opened during the launch.

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  In the Collection document window, tab Settings > Syncing > Simple, the *Full Syncing* / *No Syncing* button now indicates the correct title again.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now acknowledges and supports multiple profiles in the Vivaldi web browser.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Updated *drag and drop* code to remove methods which have been deprecated by Apple.

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
