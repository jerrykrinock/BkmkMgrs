SSYMH-NUMBERING-LEVEL 1

# Version History [verHist]

Version numbers are synchronized for all four apps in the BookMacster family: Smarky, Synkmark, Markster and BookMacster.  The icons on each listed change indicate which app(s) the change affects.

We have three upgrade *channels*:  *Alpha*, *Beta* and *Production*.  If the built-in *Check for Update…* feature is not offering you the latest version as indicated here, it may be because that latest version is still on a earlier *channel*.  Alpha or Beta versions are moved to *Production* after we are certain of their improvement.  To get them earlier, you may [change your upgrade channel](https://sheepsystems.com/files/support_articles/bkmx/get-beta.html).

Version 3 of our apps requires macOS 11.0 or later.  Versions 2.12 and later of our apps require macOS 10.14 or later.

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

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which probably caused Error 582958 when switching syncing on or off, or Show Syncing Status, when running in macOS 11 - 13.

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

## Version 3.0.9 (2022-11-28)

*  <img src="images/Markster.png" alt="" class="whappMini" /> Fixed bug which could cause a brief hang followed by a crash on launch after updating from some earlier versions of Markster.

## Version 3.0.8 (2022-11-26)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Updated the detection of problematic duplicate folders at root to match the behavior of Safari 16.  (Safari 16 silently consolidates all folders at root with the same name during its launch, unlike previous versions of Safari which only consolidated empty duplicate-name folders.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Error 623938 ("Eeek, found [multiple] BkmxAgent processes running") is no longer alerted to the user.  Instead, we silently kill the multiple processes and move on.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which introduced in version 3.0 caused the description of individual changes in the Sync Log to be described as *changeX3* (an internal string identifier) instead of *blah was changed from blah to blah*, when an import or export was executed by our background agent (BkmxAgent).

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When importing from or exporting to Firefox, Sync Log entries are no longer written with ridiculously verbose descriptions of changes in Tags, as has been done since version 3.0.  (Tags changes are only imported/exported while Firefox is not running, because we are still waiting, since 2017, for Mozilla to show some love for their Tags feature and add Tags to Firefox' WebExtensions API.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Under the hood: No longer writes 2 extraneous change records (3 if using Safari 16) to the Safari bookmarks file during an export.  The extrandous records were never observed to cause any trouble with iCloud, but now that they no longer exist, we are sure.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer causes trouble under the hood when creating a new bookmark by copying an existing bookmark that has tags.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The document window becomes the main, active window immediately upon opening in macOS 13, so that the first mouse click in the window does what was intended.  Not sure if Apple broke this or we did, but it is fixed now.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer chokes when handling a tag that contains a backslash character.

*  <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed, we think, a long-standing bug which in rare cases would cause a Collection document's Content tab if in Outline mode to sometimes mush items together, resulting in folders that appeared to have no name, and later moving ietems around to have unexpected results.  Things would get back on track if user momentarily switched to Table Mode, or closed and re-opened the Collection.  These rare cases could be triggered by changing the Structure or Clients of an existing BookMacster Collection, or changing Synced Browsers in Synkmark's Preferences > Syncing.  Probably there were no such cases in Markster or Smarky.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now handles some database corruption (missing item identifier in Client Association) without crashing.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Finished fixing the document integrity check and document support cleanup operations which run silently in the background when a .bmco Collection is opened.  These operations now no longer *beachball* the user interface, and any changes they make are properly saved to the disk and, in the unlikely event that their changes are visible, upon completion, such changes are merged into the user's view.  Finally, nice little summaries are silently logged in *Logs* > *Errors*. 

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now fails and indicates error instead of hanging when trying to open .bmco documents with a particular type of corruption.

## Version 3.0.7 (2022-10-14)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed an internal issue (leaking of document instance after closing since version 3.0).  This might fix some obscure bugs or crashes that we didn't even know we had.

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bugs which caused changes made in document tab *Settings* > *Syncing* > to be not written to disk and therefore not realized if user switched between *Simple* and *Advanced*.

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Tables in the Tag ↔ Folder Mappings sheet now display correctly when in Dark Mode. (document window > Settings > Advanced Client Settings > Tag ↔ Folder Mappings)

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Double-clicking a .bmco document in Finder, or clicking one in Dock, no longer causes the (useless in this case) *Welcome* dialog to display if (a) no document is set to *Automatically open when BookMacster launches* and (b) *Welcome* has not been disabled in Preferences.  Kind of an edge edge case :)  But we fixed it.

## Version 3.0.6 (2022-10-10)

Version 3.0.6 was a special build with some extra logging.

## Version 3.0.5 (2022-10-06)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed some of the bottlenecks which could cause documents with thousands of bookmarks and folders to take a long time to open in some conditions.  We have more improvements to make in this area in future updates.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer logs a false, hidden Error 383749 when importing or exporting with Clients (Browsers) that do not support tags. 

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Restored redirection of tagged bookmarks to folders during export which user has specified in Settings > Clients > Advanced Settings > Tag–Folder Mappings.  This was broken in version 3.0.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug introduced by the third change in Version 2.12.6 (2022-04-29) which could cause items which were mapped from nonexisting to existing hard folders during exports to not be unmapped during subsequent imports from that browser.  For example, if a user was syncing Safari and Chrome, imported Reading List items from Safari, exported to Chrome, then imported from Chrome only to get a new bookmark from Chrome, the Reading List items would be moved to root or *Other Bookmarks*, and then exported that way to Safari, moving them from Reading List. 

## Version 3.0.4 (2022-09-21)

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Now supports *tags* when importing or exporting .html files.

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Restored capability broken in version 3.0 to import from nonexistent files (successfully imports 0 items) and export to new files (creates new files as required).

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which caused hang on launch if app is installed at a path which contains a space character.  (CoreDataProgressiveMigration commit ed272a7)

## Version 3.0.3 (2022-09-19)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which caused total [churn]() (all bookmarks and folders deleted and re-written) during exports and duplicating of all items during imports, for some users who upgraded from version 2.  Details: When migrating Client (browser) settings from version 2.x .bmco documents, if the value of *Merge by URL* was *no value*, as it apparently was for some users, the *Merge by* value is now correctly set to *Identifier or URL* instead of *None*.  Also, the default value is now *Identifier or URL*, and values in documents mis-migrated in previous versions are now corrected to *Identifier or URL*.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When importing from Firefox when Firefox is not running, now ignores the *mobile* folder, instead of treating it as a soft folder.  This was a cause of [churn]().  The *mobile* folder has been present in recent versions of Firefox.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which caused a crash when using the *Edit* > *Cut* command on a bookmark or folder.  Not sure if it started crashing with recent macOS versions, or because we recently started using a newer build system (Xcode 14, macOS 13 SDK) from Apple.

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed Diigo import/export which was broken in version 3.0.

## Version 3.0.2 (2022-09-16)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed an issue introduced in version 3.0 which caused failure to open a .bmco document which had been configured to open automatically when the app launches.  This is particularly important for Synkmark, Markster and Smarky because, by design, these apps' single document is configured in this way.  It may also help for BookMacster users who store documents in other than the default location.

## Version 3.0.1 (2022-09-14)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed automatic syncing, and importing and exporting to browsers other than Safari while they are running, which was broken in version 3.0.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Extended the free trial period until November 30, 2022.

## Version 3.0 (2022-09-13)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Able to import and export (and sync) )with Safari version 16, which is part of macOS 13 Ventura.  (Versions 2.x of our apps do not work with Safari 16.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Migrates data to a more secure format (Internall, data model Bkmx018 to Bkmx019.).

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  A lot of re-engineering under the hood; little bug fixes and some performance immprovements.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer supports import or export with the Roccat web browser.  (It appears that this capability has been broken since March 2018 or earlier, no one has noticed, and Roccat has not been updated since March 2018.)

## Version 2.12.9 (2022-07-18)

Version 2.12.9 was published for Markster only.

*  <img src="images/Markster.png" alt="" class="whappMini" />  Made a change to fix a problem with macOS 13 Ventura, which was that Markster would hang when it tried to create a new .bmco document file if the prior .bmco document file had been deleted from the disk prior to launching.

## Version 2.12.8 (2022-07-15) 

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved warning messages in previous version to reference Safari 16 in addition to macOS 13 Ventura.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which might cause a hang on launch in macOS 13 Ventura.

## Version 2.12.7 (2022-07-10)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When launching this version for the first time in macOS 10.13 Ventura or later, informs user that importing from or exporting to Safari in macOS 13 or later requires version 3 or later of our app.  Later, if such an import from or export is attempted, the operation is aborted before it begins, again informing the user of the new requirement, instead of failing with an unexplained error as previous versions do.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a rare case of  [churn]() when running in macOS 11 or later and exporting to Safari.  The rare case occured if the export contained changes to a bookmark which had percent escape sequences in its URL.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  If macOS fails to switch off our background syncing agent (BkmxAgent) when required, our app now kills the agent's process.  (Such a switching off happens when all syncing is turned off, or when the 'Reboot Sync Agent' menu command is clicked.)

## Version 2.12.6 (2022-04-29)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  If a Collection's bookmarks contain duplicate bookmarks at root, or duplicate folder(s) at root, at least one of which is empty, when an Export to Safari is attempted, now displays an informative error, with an explanation and a *how to fix*, instead of an un-actionable Error 7720XX.  (Such troublesome duplicates cause errors due to inconsistent data during our export process, and if manually created by user in Safari's *Edit Bookmarks* window, are silently deleted by Safari upon its next relaunch.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The converse of the above change.  If Safari bookmarks contain any of those troublesome duplicate types (which can happen if manually created by user in Safari's *Edit Bookmarks* window since Safari was last launched), during an Import or Export operation, now displays an informative error, with an explanation and a *how to fix*, instead of an un-actionable Error 7720XX.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  During Import or Export operations, now correctly copies some special-case moves from the web browser which had been ignored in previous versions.  The explanation is complicated, so you should probably stop reading here.  The idea is that, to avoid [churn](), moves which the user apparently did in the web browser since the last import or export are ignored if it could have been done by our app remapping the item during a prior export operation.  We check for three such cases.  Case 1 is when the current location in the Collection document is a hard folder which does not exist in the client.  For example, Safari does not have a *Bookmarks Menu* aka *Other Bookmarks*.  So if an item which is in *Bookmarks Menu* aka *Other Bookmarks* in the Collection document is found to be in a different folder in Safari during an import from Safari, in previous versions, this item fell into Case 1 and the move was ignored.  In this version, we have restricted Case 1 to moves in which the moved-to folder is the default parent for the moved item.  (Case 1 has been in our apps for about 8 years, but our dropping of the *Bookmarks Menu* in Safari in Version 2.12 has made it more likely to occur.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />     If the name of an item is changed to an empty string in a browser which allows empty strings as names, such as Chrome, and that change is imported, and then if this change is exported to Safari, the export operation now succeeds.

*  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In *Preferences* > *Shortcuts*, the keyboard shortcuts now correctly indicate their actual settings made during a previous run of the app, instead of showing no settings, when running in macOS 12.4.

*  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Uses a more mainstream method to generate the sound effects when landing a new bookmark.  It is hoped that this will fix issues of sometimes several seconds delay, and/or new bookmark not being the subject in the Inspector window, when landing the first new bookmark after launching the app.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a crash which would sometimes occur if a .bmco document was closed by AppleScript commands after the Inspector window was open, or had been open previously during the current run of the app.

*  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Corrected the nonsense in sec. 4.4.21 of the Help Book.

## Version 2.12.5 (2022-02-27)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Thanks to a user who showed us the secret that separators are a thing in the iCab web browser, now supports separators when importing from and exporting to iCab.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />  Errors 125787 and 125788 now contain additional information.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a crash while quitting which occurred while running in macOS 12 Monterey if a license had been obtained during the application run,

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  After purchasing a license, in the unlikely event that the user returns to our app before the new license is installed, now advises the user to manually click the "Retry…" menu item.

## Version 2.12.4 (2021-11-18)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug introduced in version 2.12.3 which can cause failure when attempting to import or export with Firefox due to Error 594520 with underlying error 264873.

## Version 2.12.3 (2021-11-12)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Attempting to run in macOS 10.13 or earlier now results in a failure to launch instead of a crash while launching.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug introduced in version 2.12 which causes hang when exporting to Safari with separators at the root level. 

## Version 2.12.2 (2021-11-10)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now built with the Core Data model included at the top level in the project, which may fix the *requires version 300.0.0 or later, but CoreData provides version 1.0.0* runtime error when running in macOS 13-.  (UPDATE 2022/10/05: We now have a crash report from a user with macOS 10.13.6 indicating that this *may fix* in fact did did *not* work.)

## Version 2.12.1 (2021-09-30)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now built with Xcode 13.0, which uses the macOS 11 SDK, which may fix the *requires version 300.0.0 or later, but CoreData provides version 1.0.0* runtime error when running in macOS 13-.  (UPDATE 2022/10/05: We now have a crash report from a user with macOS 10.13.6 indicating that this *may fix* in fact did *not* work.)

## Version 2.12 (2021-09-20)

You need this version if you are using macOS 12 Monterey and are syncing with, importing from or exporting to Safari (Safari 15).

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer exports to the legacy *Bookmarks Menu* [hard folder](https://sheepsystems.com/bookmacster/HelpBook/hardFolders) in Safari.  During your first export to Safari with this version or later, any items in a *Bookmarks Menu* will be appended to any existing items in Safari's root level instead.  So, the items will still appear in the main menu > *Bookmarks* on your Mac as they always have.  But in Safari on any iOS devices synced by iCloud, they will appear at the root level, and the legacy *Bookmarks Menu* which previously appeared under *Favorites* in iOS will be gone.  Summary: Although this is a rather serious change under the hood, you may not even notice it.  Your bookmarks will be organized more uniformly across macOS and iOS devices, and more importantly, you will avoid a couple of new issues which we have seen when the legacy *Bookmarks Menu* is populated in macOS 12 Monterey.  

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Can now export new folders to Safari in macOS 12 (Safari 15), instead of crashing the underlying process (*Pajara* or *SheepSafariHelper*) while indicating indeterminate progress, and finally, after 5 minutes, failing and displaying timeout Error 591200, with a *Suggestion to fix…* that does not work.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Corrected the Full Disk Access warnings and errors to give better information for macOS 11.4 and later, since when Apple requires that our syncing agent (BkmxAgent) be granted Full Disk Access on its own because it no longer just inherits it from BookMacster, Synkmark or Smarky.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Notification of any error occuring in our syncing agent (BkmxAgent) is now presented in modern fashion, via the macOS Notification Center, instead of the more reliable but ugly and very annoying old CFUserNotification dialog, which unconditionally splashed into the center of the screen [like the Kool-Aid Man](https://youtu.be/pW6192cgV8).

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which caused the Hint Arrow for Safe Limit > Export to point incorrectly at the *Import* button instead of the *Advanced* (gear) button, and modernized the appearance of the Hint Arrow for users with macOS 10.14 or later.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When exporting to Safari, now checks to see if there is one or more groups of folders at root or in Reading List with the same name, at least one of which is empty, and if so, aborts the export with a new Error 394842, which suggests how to fix the issue, instead of allowing the export to fail with Error 772030 because Safari rejects such folders.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a few more pathological cases which could cause [churn](https://sheepsystems.com/bookmacster/HelpBook/churn) when exporting to [Chrome-ish browsers](chromish) bookmarks whose scheme portions of their URLs are, in certain ways, invalid or non-standard in the eyes of Chrome.  (Chrome will either modify the scheme to make it valid and standard, for example by lowercasing uppercase alphabet characters, and/or prepending "http://" and percent-encoding disallowed characters; or in some cases just ignoring the bookmark.  For simplicity and robustness, our fix here is to simply not export any such bookmark, the same as we have for years not exported bookmarks other bookmarks which have URL characteristics previously found to not play well with Chrome.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed rare occurrence of the syncing agent (BkmxAgent) not launching or relaunching as required when syncing is ready.  Possibly this was only occuring in macOS 12.

## Version 2.11.11 (2021-04-24)

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which can cause a spurious Error 23004 when exporting to Pinboard or Diigo if (1) a bookmark is, for whatever reason, being deleted during an export to Pinboard (2) that bookmark is, for whatever reason, already deleted at Pinboard and (3) that bookmark's URL *ends* with a percent-escape encoded character, for example “%A2”, which will be doubly encoded to, for example, "%25A2".  (To workaround an old bug in Delicious, prior versions of BookMacster would remove the last *three* characters, resulting in an invalid URL.)

## Version 2.11.10 (2021-04-16)

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Reduced [churn](https://sheepsystems.com/bookmacster/HelpBook/churn) during subsequent exports to Pinboard or Diigo, particularly if the Collection contains duplicate bookmarks.

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  If a Collection contains duplicate bookmarks, after exporting to Pinboard or Diigo, now only one of them instead of all of them will indicate a Client Assocation to Pinboard or Diigo.  The new behavior is correct because Pinboard and Diigo do not accept duplicates.

## Version 2.11.9 (2021-04-16)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Upon launch, now checks to see if app is in a temporary location such as an App Translocation folder, and if so warns user and quits.  This is hoped to prevent the failures which will occur if macOS later tries to run one of our app/s helper tools, and macOS makes the mistake of launching the translocated instance.

*   <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Made a change under the hood which should eliminate the possibility that our syncing agent (BkmxAgent) would silently crash on launch, and therefore syncing would not work, when app was initially installed.  This may have been triggered by initially running the app from `~/Downloads`.  (Our Bkmxwork framework is now loaded via @rpath.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  During a [Verify Bookmarks](http://sheepsystems.com/bookmacster/HelpBook/verify) operation, the cool list which shows which bookmarks are currently being verified is now legible when running in Dark Mode in macOS 11. 

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Exports to Diigo or Pinboard no longer time out with Error 591200 after 5 minutes.  (This timeout, intended for exporting to locally installed web browsers, was inadvertently applied to Diigo and Pinboard too in BookMacster 2.10.30.)

## Version 2.11.8 (2021-03-12)

*  <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now installs our browser extensions into Brave such that they will work even if our extension is not installed in Chrome.  (Oddly, Brave and Opera piggy-back on Chrome's Native Messaging Manifests.)  This was fixed in version 2.11, but, it turns out, only for Brave Beta, not the regular Brave.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Readjusted log entries written by Pajara, removing most of those added in the last several versions..

## Version 2.11.7 (2021-03-10)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Added log entries during acquiring of lock by Pajara, when importing/exporting with Safari.

## Version 2.11.6 (2021-03-09)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Further improved log entries by Pajara, when importing/exporting with Safari.

## Version 2.11.5 (2021-03-08)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  If verbose logging is enabled in Pajara, when importing from Safari, each node is logged as the tree is built.

## Version 2.11.4 (2021-02-26)

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Now quits as expected if user creates a new Collection, but does not save it, then commands *Quit* and clicks *Delete* when asked whether or not to save the new Collection.  (Fix is in BSManagedDocument repo.) 

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug introduced in version 2.11.3 which usually caused a crash or hang when clicking in the application menu: Licensing > Try or Buy > Regular License.  (Fix is in SSLicensing repo.)

## Version 2.11.3 (2021-02-23)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Restored operation in macOS 10.10 which has been broken since version 2.11 due to a [recent bug in Apple's Developer tools](https://forums.developer.apple.com/thread/107546).  Although we always appreciate people running our beta versions, if you are using our previous version 2.11.2 and it works for you, you may skip this version.

## Version 2.11.2 (2021-02-09)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Several changes have been made to reduce occurrences and presentation of Errors 83400X, in particular 834003, *Says macOS: Launched our URL handler.  But it is not running :(*.
    * Smarky and Synkmark no longer even try to launch our URL handler helper process.  (These two apps )do not support landing of bookmarks directly, which is all the URL handler does, so they do not need the URL handler.)
    * If macOS apparently fails to our URL handler on the first try, BookMacster and Markster now try several more times over a period of 30 seconds.
    * Errors 834001, 834002 and 834003 are only displayed in a dialog to users of Markster.  (Landing of new bookmarks is a core function in Markster.)

## Version 2.11.1 (2021-01-07)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When attempting to import from or exporti to Safari, the time added to the time allowed for the system to respond before abandoning the effort and declaring error 298441 or 398441, added when the operation is being performed by our Agent (BkmxAgent), has been increased from 20 seconds to 57 seconds, and also it is configurable as a new hidden preference named safariMoreAgentSecs. 

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  In a .bmco document window > tab Settings > Advanced > table Triggers, for type Scheduled, the Time field is now editable when running in macOS 11 Big Sur.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now capable of import and export with *Microsoft Edge Beta* browser.  (Previously, our apps were and still are capable of import and export with *Microsoft Edge* and *Microsoft Edge Dev*.  The bookmarks sets of these three *Edges* are different.)

## Version 2.11 (2021-01-03)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Notifications of errors, warnings, or if so configured, normal syncing events are now delivered via the macOS Notification Center, in accordance with current Apple recommendations.  Users who have configured custom sound effects should visit Preferences > Syncing > Notifications to re-configure them.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In *Preferences* > *Appearance*, the control to have large, small or no icons in the toolbar has been removed, because it does not play well in macOS 10.11 Big Sur. 

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In *Preferences* > *Syncing*, the setting *Minutes to wait before starting to import changes…* has been renamed to *Delay before starting to import changes…*.  Two new faster values, *10 seconds* and *30 seconds* are now available in the menu, and the default setting for new users *and for users who have never touched this setting* has been reduced from 5 minutes to 60 seconds.  (We feel that, with the improved syncing performance we have achieved over the last year or two, 60 seconds is the most appropriate choice for most users.) 

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Toolbars in `.bmco` document windows (the *main" window in Synkmark, Markster and Smarky) now have, more or less, the "new look" recommended by Apple for macOS 10.11.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now supports import and export with iCab 6.  Import and export with earlier versions of iCab are no longer supported.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which caused expected launching and quitting of browsers to silently fail to happen in some cases.

*  <img src="images/Synkmark.png" alt="" class="whappMini" />  Improved readability of Browser list presented during initial configuration, and the list in *Preferences* > *Syncing*.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved readability of *Client* list presented when creating a new document, and the list in a document's *Settings* > *Clients* tab.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  All four apps are now "Universal" apps which run natively on the new Macs built on Apple Silicon. 

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Reduces probability of a false Error 834003 being indicated when launching on Macs built with many cores, such as the new Macs built on Apple Silicon. 

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Added setting to *Sort folders only* or *Sort bookmarks only* when using the option to push bookmarks or folders to the top or bottom.  (In BookMacster, the controls for this new option are in the *Collection* window > tab *Settings* > *Sorting*.  In Markster, Synkmark and Smarky, these controls are in the *Preferences* window, tab *Sorting*.)  (This feature was added previously in version 2.10.25 but was removed in version 2.10.26.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Changes made in the Inspector are now more reliably saved if the app is immediately quit.

*  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In Mini Search window, when running in macOS 11, scrollers no longer appear, and the list of results is no longer clipped.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the Inspector window, the *Name*, *Shortcut* and *Comments* fields no longer treat *tab* or *return* keys hits as the user indicating *done* instead of as part of the edited value.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer warns about an extension needing to be installed in listed Browser/Clients after an export, if the export is a special export to a single Browser/Client.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Sync Snapshots are now archived before each import in addition to before each export.

*  <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now installs our browser extensions into Brave such that they will work even if our extension is not installed in Chrome.  (Oddly, Brave and Opera piggy-back on Chrome's Native Messaging Manifests.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In Preferences > Syncing, the setting *Number of Sync Snapshots to keep* has been changed to *MB (megabyte) Limit for keeping old Sync Snapshots on disk*; in other words, instead of limiting the number of files for each browser/client, we now instead limit the disk space used.  The value of users' old *Number of Sync Snapshots* preference is migrated to the new *MB Limit* preference after multiplying by 12, up to a maximum of 1 GB.  For example, most users who still have the default 5 *Number of Sync Snapshots* will be migrated to a *Limit* of 60 MB.  Also, enforcement of the limit by removing older snaphots is now done every 24 hours when app or agent is running, instead of upon any export.

## Version 2.10.31 (2020-10-04)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could cause churn when syncing with Google Chrome.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The main menu item *File* > *Share*, which did not work properly, has been removed.

## Version 2.10.30 (2020-09-01)

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused a failure to show the document selection dialog, and thus failure to land a new bookmark, when attempting to land a new bookmark directly from a web browser if (1) BookMacster is running *backgrounded* and (2) more than one Collection document is open.  (Requires ClassesObjC commit a871544.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  If web browser fails to respond during an Export operation, now times out after 5 minutes for manually-initiated exports, or 20 minutes for agent-initiated exports, and fails with new Error 591200.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved recognition of separators when exporting to Safari, which will eliminate [churn](https://sheepsystems.com/bookmacster/HelpBook/churn) in some pathological cases.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Bookmarks and folders are now allowed to have no (nil) name, although this still cannot be done in the user interface, if some browser does it, and such a change or addition is imported, it will remain as is.  This better emulates the way most web browsers work, and thus shall eliminate [churn](https://sheepsystems.com/bookmacster/HelpBook/churn) in some pathological cases.

## Version 2.10.29 (2020-06-15)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  If macOS fails to find the our app running for its *URL Handler* helper when the *URL Handler* launches, as is happening for one user after updating this app, the URL Handler now tries to get info on our app using a new *screwball* method instead, and if that fails, waits a couple seconds and then tries both methods again.  If any of these work, it will prevent the URL Handler from quitting itself immediately (which makes the app unable to *land* new bookmarks *directly* from other applications).   

## Version 2.10.28 (2020-06-09)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could cause app to hang needing force quit in some cases if Agent encountered an error, informed user and user clicked *View…*. 

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could cause an Export to Vivaldi to fail with Error 408562, which would be presented as simply *Export to Vivaldi failed … Could not process changes for item*.  This bug was apparently introduced in version 2.10.23.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which would cause some rare errors, for example Error 19675, to not be recorded in the Logs and not be presented to the user. (Requires CategoriesObjC commit 88bb1dc). 

## Version 2.10.27 (2020-05-21)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which could cause syncing [churn](https://sheepsystems.com/bookmacster/HelpBook/churn) if Collection included one or more separators and was syncing Firefox.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Corrected and improved recovery suggestion displayed in Safe Sync Limit errors.

## Version 2.10.26 (2020-05-01)

*  <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  If a necessary syncing operation attempted by our Agent (BkmxAgent) fails because a necessary browser extension is not installed, now presents a dialog to the user, announcing Error 103053, which is new.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now has better logging to troubleshoot issues with our URL handler process running, and the process itself writes its own log file.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Removed the *Sort folders only* or *Sort bookmarks only* which was added in 2.10.25.  (Merge from branchSortFoldersOrBookmarksOnly to get it back.)

## Version 2.10.25 (2020-04-22)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Added setting to *Sort folders only* or *Sort bookmarks only* when using the option to push bookmarks or folders to the top or bottom.  (In BookMacster, the controls for this new option are in the *Collection* window > tab *Settings* > *Sorting*.  In Markster, Synkmark and Smarky, these controls are in the *Preferences* window, tab *Sorting*.)

## Version 2.10.24 (2020-04-15)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug in 2.10.21 which would cause a crash when launching a version later than 2.10.20 for the first time, if either of our Brave extensions had been previously installed.

## Version 2.10.23 (2020-04-15)

*  <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug introduced in version 2.10.21 which may cause an Error 112098 dialog to appear the first time one attempts to *land*  new bookmark from Brave or Brave Beta *directly*.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which would cause a crash when items in a deep folder which are included in previously-found duplicates were copied to the clipboard.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a long-standing bug which caused the metadata of a new Collection to not be written to the file until the *second* time a document was saved.  This probably had bad effects only if the user created a new empty Collection and then immediately closed it.  Although this is not likely in real life, but it happened in testing :) 

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  During an import or export operation, the progress indicators in the Status Bar (bottom) of the Collection window now show the progress when running in recent versions of macOS, as they did in older versions of macOS.  In most cases, with a Collection size of less than a couple thosand or so bookmarks, these indicators appear and disappear in milliseconds, so you don't see them.  But they have been helpful in some cases.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which may have caused an unnecessary document Save operation to proceed, or at least to appear to proceed, displaying the result *Save* in the Status Bar at the bottom of the Collection window, even when there were no changes to save.  We are not sure whether or not there were more significant ill effects.  We are just cleaning some things up here :)

## Version 2.10.22 (2020-04-04)

*  <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug in version 2.10.21 which would cause a crash when first opening a document that had ever been exported to a "loose" file in the Brave format.

## Version 2.10.21 (2020-04-03)

*  <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now supports Brave 1.7, with the return of its *Other Bookmarks*.

*  <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now supports Brave Browser *Beta* alongside Brave Browser as a Synced Browser or Client.

## Version 2.10.20 (2020-03-31)

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which would cause Error 772031 *Could not find a movee* when exporting to Safari in some cases.  One particular such case was if *Advanced Client Settings* > *Export* > *Delete Unmatched Items* was switched OFF, and if Safari contained a folder with the same name and the same parent lineage as a folder in the .bmco Collection, and if both had different *identifiers* (which can happen if they were each created separately or by *Advanced Client Settings* > *Fabricate Folders*).  (Because our apps consolidate such duplicate folders during an Export, one of them will be empty and deleted, but prior versions would incorrectly try to re-position the deleted folder, aka the *movee*.)  

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed bug which caused the *Fabricate Folders* in *Advanced Client Settings* to not create all expected folders and/or fail with Error 772040 when exporting to Safari.

## Version 2.10.19 (2020-03-19)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Bookmarks whose URL is the obviously useless "http://" or "https://" are no longer exported to Firefox, Pinboard or Diigo.  (Such bookmarks had previously been not exported to the Chrome-ish browsers because they had been found to cause weird behavior and errors, but now we have found similar issues when exporting to Firefox.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Updated the built-in [Sparkle](https://sparkle-project.org) *Check for Update* subsystem from version 1.19.0 to 1.20.0.  This should have no effect on users.

## Version 2.10.18 (2020-03-13)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a situation in which BkmxAgent (our *in-the-background* syncing process which syncs bookmarks while our app is quit) could cause a job to remain in the job queue if certain errors occurred, causing future syncing jobs to be stalled until BkmxAgent was rebooted.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed the `perform` AppleScript command, which has apparently been broken since version 2.9.

## Version 2.10.17 (2020-03-11)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/Markster.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />  No longer crashes when clicking on the text label of some checkboxes.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed the `perform` AppleScript command, which has apparently been broken since version 2.9.

Versions 2.10.14, 2.10.15, and 2.10.16 were special test versions, not publicly available. 

## Version 2.10.13 (2020-03-06)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/Markster.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />   The results sheet shown after a *Consolidate Folders* operation is now resizeable by the user.

## Version 2.10.12 (2020-02-27)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/Markster.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />   Fixed a bug which caused a rare crash, during Save or Auto Save operations, particularly in macOS 10.15.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/Markster.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />   Removed all of the file writing added for debugging since version 2.10.8.

## Version 2.10.11 (2020-02-27)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/Markster.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" /> More info has been added to the small file of state information which is written to user's BookMacster Appiication Supoport directory before each save operation, where a crash has been seen to occur rarely in macOS 10.15.

## Version 2.10.10 (2020-02-26)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/Markster.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />  The feature added in the special versions 2.10.8 and 2.10.9 have been removed.  Instead…

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/Markster.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />  This version writes a small file of state information to user's BookMacster Appiication Supoport directory before each save operation, where a crash has been seen to occur rarely in macOS 10.15.

## Version 2.10.9 (2020-02-25)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/Markster.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />  Special version which actually does what 2.10.8 said it would do.

## Version 2.10.8 (2020-02-24)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/Markster.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />  Special version which writes BSManagedDocument pre-crash information to Desktop with each document save.

## Version 2.10.7 (2020-02-24)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/Markster.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug introduced in version 2.10.6 which usually caused newly-created documents to not retain their Local Settings.

## Version 2.10.6 (2020-02-22)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/Markster.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />   Made some changes in the way that a new unique identifier is assigned in the extraordinary event that a document is missing its unique identifier.

## Version 2.10.5 (2020-02-19)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/Markster.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />   Landing new bookmarks *directly* from Microsoft Edge now works.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/Markster.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed spurious occurrences of Errors 519880, 519881, 519882, and 519883, particularly when running the previous version 2.10.4 which incorrectly amplified these.

## Version 2.10.4 (2020-02-11)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  Now includes means to detect and silently remove any Syncers which were created by corrupt and now-replaced `.bmco` documents, or documents of other apps from among BookMacster, Synkmark and Smarky.  Although these documents only exist in cases where something went wrong in the system, or maybe user was testing more than one of our apps, the effect was quite annoying and we are happy to have this fixed.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/Markster.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />  Added a mechanism which verifies that the document we get in response to our request from macOS is indeed the expected document, in particular that it is not a new document which happens to be at the same path as an old document.  This may have been causing, in rare cases, documents failing to open, or failing to sync due to missing configuration information.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/Markster.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" /> Import/Export with Microsoft Edge browser now works even if user has never edited bookmarks in Edge.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> Import/Export to a loose file (Advanced) now works for bookmarks files in Microsoft Edge format.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/Markster.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />  Logs now contain a message if URL handler was launched successfully, or (new) Error 834002 if it failed.  Also, the URL handler now says *goodbye* by presenting an alert dialog if the option key is held down when it quits.

## Version 2.10.3 (2020-01-31)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />  Errors 12908, 125787, 125788, 125789 now contain additional information.

## Version 2.10.2 (2020-01-24)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Sorry, fixed another mistake in the procedure for exporting to Brave when Brave is not running.

## Version 2.10.1 (2020-01-23)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a mistake in the procedure for exporting to Brave which was incorrectly done in version 2.9.23 and caused bookmarks to be omitted from exports to Brave in some cases.

## Version 2.10 (2020-01-20)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now supports import, export and syncing with the Microsoft Edge and Microsoft Edge Dev web browsers.  (Note: We have not put our extensions into the Microsoft store because Edge graciously allows installing extensions from the Chrome Web Store, the process is quite seamless, and so *less is more*.  To install one of our extensions into Edge, just OK installing extensions from the Chrome Web Store when prompted.)

## Version 2.9.23 (2020-01-17)

The fix in this version for the Brave Browser also requires that your browser profiles are updated to version 44 of our BookMacster Sync extension, which was published in the Chrome Web Store and Mozilla (Firefox) Add-Ons on January 16.  By default, Google Chrome, Firefox, Vivaldi, Brave and Opera check for updates every day, so you probably have been updated already, unless you have Opera.  Unfortunately, instead of scraping the Chrome Web Store as Vivaldi and Brave do, Opera maintains their own store and requires human review of all extension updates.  At this time, our version 44 is still awaiting review by Opera.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Imports and exports with Brave Browser now work with Brave version 1.2. and later, in which Brave has eliminated the *Other Bookmarks* hard folder.  (Last week's update to Brave 1.2 converted your *Other Bookmarks* hard folder into a *Other Booknmarks* soft folder.  Unfortunately, the Brave team did not explain this to users.  To learn why the new structure is better and how to adapt to the change, read [this thread in their forum](https://community.brave.com/t/other-bookmarks/101541/2).)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Changed some code which could maybe have caused spurious occurrences of Error 257938.  Not sure, but the changed code makes more sense.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed two bugs which could occur after user clicks "View" button to view a new error from Agent:
  *  Bug which could cause the previous error (or no error, if no previous) to be displayed instead of the latest error.
  *  Bug which could cause spurious appearance of Error 257938 from Agent.
  
  
* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /><img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which may have caused syncing irregularities or *churn* in some cases.  (We did not investigate the effects but definitely fixed a possible cause which was discovered accidentally.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When running in Dark Mode, in the document window, in order to guarantee sufficient contrast with the white characters, the background color behind the folder names is now forced to be as dark as possblle (saturation is forced to 1.0) regardless of the user's setting in Preferences > Appearance.)

## Version 2.9.22 (2019-12-23)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Error 478204 should always have an underlying error now. (Requires BSManagedDocument commit 329683b.)

## Version 2.9.21 (2019-12-12)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Changed so that having separator(s) in current versions of Firefox no longer causes a churn (unnecessary sync operation) after exporting to Firefox.  (No longer exports a dummy name or dummy URL with separators in Firefox.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  After users update to version 44 of our *BookMacster Sync* extension, serious errors encountered by the *BookMacster Sync* extension will be displayed in the Smarky, Synkmark or BookMacster after the import or export operation is complete.  (At this time, only two errors are deemed to be *serious*.).

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Further clarified the message in the sheet which appears whenever user attempts to begin or resume syncing.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Backed out of the change made in version 2.9.19 which *patched an omission which theoretically could cause .bmco document changes from another Mac to be missed when syncing*, and replaced it with a better and simpler fix.  (BkmxAgent now watches auxiliaryData.plist instead of the sqlite files, and as a side requirement to make this work, document's UUID is now stored in auxiliaryData.plist instead of Core Data store.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Clicking the Trouble Zipper command now successfully launches Trouble Zipper in macOS 10.15 Beta 4.  (ClassesObjC commit 7a9fbdf)

## Version 2.9.20 (2019-11-14)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Exporting with debug trace level greater than 0, (for example, option and shift key held down) now writes to the Desktop any JSON data pushed to browser extensions in addition to the merge trace.

## Version 2.9.19 (2019-11-02)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could cause, when syncing multiple browsers,  in some cases, changes from one browser to be missed and overwritten if changes are made in a second browser while those first changes are being synced.  (Last-imported hashes were not always truly being forgotten when the sync operation was aborted and re-staged.)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now prompts user to export if syncing is ready when an *Import* or *Export* checkbox of a browser/client is switched ON.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed encoding of non-ASCII characters in HTML (.html file) exports.  (Bookmark and folder names are now exported with only the five mandatory HTML control characters encoded, which removes a bug exporting characters in the upper Unicode planes.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the Inspector window now, the Name field is taller so that it can show three lines instead of one without scrolling.  (It still scrolls to show unlimited lines.)

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Patched an omission which theoretically could cause .bmco document changes from another Mac to be missed when syncing.  (BkmxAgent now watches documents' -shm and -wal files too.)

 ## Version 2.9.18 (2019-10-18)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now exports to Chrome-ish browsers bookmarks whose URL begins with "javascript:".

## Version 2.9.17 (2019-10-02)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Import/Export with Opera has been improved to support Opera installations which, for some reason, present bookmarks in a different format (JSON root has three children instead of the usual six).

## Version 2.9.16 (2019-09-30)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Errors in decoding Opera bookmarks (164874, 174869, 174875, 174876, 174879) now contain additional information.

## Version 2.9.15 (2019-09-20)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which sometimes caused Error 992544 on some Macs after our app performed a syncing operation in the background, and also further improved the information in that error to aid pinpointing of any similar bugs.  We hope there are no other such bugs, and so Error 992544 will not be seen any more.  But if anyone still sees Error 992544, please click the life preserver button in the dialog and send us the data in the email which will be generated. 

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When exporting certain URLs which have invalid paths or strangely encoded *path* portions to Chrome, Chromium, Vivaldi, Brave, Opera, Firefox, and Safari, in certain cases, now better emulates the auto-correction of these URLs by these browsers, eliminating *churn* in subsequent imports and exports with these browsers.

## Version 2.9.14 (2019-08-23)

This is an experimental version which we hope will help us solve some now-rare but still not totally eliminated occurrences of Error 992544.  In addition to the two changes listed below, it does some extra logging which shall be removed in the next non-experimental version.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When an open document is modified on disk, presumably from another Mac, via iCloud or Dropbox, the changes now appear in the existing window, instead of closing that window and opening a new one.  (Now uses Apple's NSFilePresenter as intended, since it supposedlly works properly in recent macOS versions.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer attempts to sync our bookmarks' *Shortcut* attribute with Firefox bookmarks' *Keyword* attribute, which has been deprecated in Firefox.  

## Version 2.9.13 (2019-08-08)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> Fixed bugs which sometimes caused failure to save the new Collection after configuring as a new user.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In a document, in the Content View, in outline mode, drag and drop now works properly in macOS 10.15 Catalina:
  *  Dropping a contiguous selection of items onto a folder now drops them in their original order.  Also, new items appear under pre-existing siblings.  This may have been inconsistent in previous versions.
  *  Dropping items from Safari's *Edit Bookmarks* view now results in new items with names from Safari instead of just URLs from Safari. 

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The *New User Setiup* window is now readable in Dark Mode and macOS 10.15 Catalina.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In .bmco document window > Status Bar at bottom, and in New User Setup window > Help Navigation bar, the background colors have been changed to  have more contrast, making them more readable, particularly in Dark Mode.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> *File* > *Duplicate* no longer fails to save in macOS 10.15 Catalina.  It may have been broken in macOS 10.14 Mojave too.  (Saving may still fail due to a issue FB6937676 in macOS 10.15 Catalina.  To work around this bug, be sure to name the new document by typing in the title bar immediately after creating it.)

* <img src="images/BookMacster.png" alt="" class="whappMini" />  In a document's *Settings* > *Syncers* > *Advanced*, for *Periodic* syncers, the *Every 60 Seconds* interval choice has been removed and *Every 5 minutes* has been changed to *Every 10 minutes*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now alllows some technically invalid but still useable URLs, such as some `javascript://` URLs, to be exported to Chrome. 

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could cause a crash if a/the `.bmco` document file was corrupt and failed to open.

## Version 2.9.12 (2019-04-03)

* <img src="images/BookMacster.png" alt="" class="whappMini" />  In a document's *Settings* > *Clients* > *Show Advanced Settings* for Brave, Canary, Chrome, Chromium, Epic and Vivaldi, in *Special Settings* > *launch browser during syncs*, the choice *Never* has been removed from the popup menu, and upon running this version for the first time, any such *Never* settings in existing documents will be changed to *Automatic*.  This is because the current verisons of Chrome and Vivaldi no longer sync properly if bookmark changes are made while Chrome or Vivaldi is not running and their *Sync* is in use.  The other browser/clients do not offer syncing so it does not matter for them at this time.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> Synkmark now supports two web browsers which were previously only supported by BookMacster: Google Chrome Canary (aka *Canary*) and [FreeSMUG's Chromium](http://www.freesmug.org/chromium).

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed some bugs which could cause misbehavior when opening documents under some conditions.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />   <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug introduced in version 2.9.11 which caused landing new bookmarks into the root to silently fail.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Help Book documentation has been updated…

* Covers support for the [Brave](https://brave.com/) web browser which was added in the last version.
* Clarifiies that the *Chromium* browser we support is [FreeSMUG's Chromium](http://www.freesmug.org/chromium).
* *Sign in to Chrome* is now referred to by its new name *Chome Sync*  (Thank you, Google, for renaming your service to read like a noun and reducing it to two words!)
* No longer describes the controls available for iCloud > Safari, Firefox Sync, Chrome Sync, Vivaldi Sync, and Opera Sync, since the developers of these browsers have now made their documentation good enough that we can instead link to them. 

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Clicking the Dock Menu, Status Item (menulet) or typing the global Keyboard Shortcut while Brave Browser is the frontmost app no longer displays an error message, and landing new bookmarks from Brave via these mechanisms now works.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  License Info window text now displays properly in Dark Mode.

## Version 2.9.11 (2019-03-22)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />   Now supports the [Brave](https://brave.com/) web browser.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which allowed soft items to be moved to positions in between the immoveable hard folders.  This could cause cause errors, warnings or churn during subsequent sync operations with browsers.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The *Sort where* property of a hard folders is now properly indicated as *not applicable* in the Inspector, and it is no longer possible to change this to one of the other (invalid) values.

## Version 2.9.10 (2019-03-15)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Loading Safari bookmarks for import and export is now (even) more robust and reliable.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a situation wherein a newly-created Collection might not be saved in recent versions of macOS.

## Version 2.9.9 (2019-03-11)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixes failure to export to Safari 12.1, if the changes included one or more new *folders*.  Safari 12.1 is apparently coming to macOS 14, probably in macOS 10.14.4 this week or next, and also appears to be in new installations of macOS 10.13.6.  The changes in this version may also fix other issues which occur rarely with earlier Safari versions.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Separators exported to Safari (actually pseudo-separators since Safari does not support real separators) now play more nicely with current implementations of Safari and iCloud.  The separators of existing Collections are migrated to the new form upon first being opened in this version.  (The URLs of separators, instead of being empty strings, aare now of the form `separator://` followed by a unique identifier.  Although not shown in the Content View, this URL is exported to Safari.  Safari 12.1 Beta has been seen to misbehave when bookmarks URLs are empty strings .) 

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bugs which occurred when running in macOS 10.10 or 10.11.  Foremost is that automatic syncing works now.  Also there are no more crashes upon closing some alert sheets or windows, such as the *Sync Status Report**.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Round *?* help buttons now work in earlier macOS versions the same as they do in macOS 10.14, opening to the relevant Help Book page on the internet, instead of showing *The selected content is currently unavailable…* in the very sadly broken *Apple Help Viewer*, which Apple has not been maintaining.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which caused the *File* > *Reboot Sync Agent* command to sometimes just do nothing (because an exception was raised internally).

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved some code which may have been causing a rare crash during quit.

## Version 2.9.8 (2019-02-08)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />   Imports and exports with Safari work when running in macOS 10.14.4.  The failure when using older versions is usually with Error 772042.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which sometimes required app to be force quit, with a false Error 992544, after saving a new document for the first time, particularly in macOS 10.14 and even more particularly in macOS 10.14.4.   

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />   <img src="images/BookMacster.png" alt="" class="whappMini" />  Bug fixes, efficiency and performance improvements to automatic syncing.

* <img src="images/BookMacster.png" alt="" class="whappMini" />   In the document window tab *Settings* > *Syncers* > *Advanced*, the *Perform…* button, whose operation was sacrificed in the rush to release version 2.9, works again.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />   The predicate editor in document window tab *Reports* > *Find/Replace* works in Dark Mode now.  (Apple Bug 46142171.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />   <img src="images/BookMacster.png" alt="" class="whappMini" />   In *Preferences* > *Syncing* > *Sound Effects*, user may now choose their own `.aiff` files as custom sound effects.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In document window tab Content, when in Outline Mode, items may now be dragged and dropped anywhere, including at the root level.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />   <img src="images/BookMacster.png" alt="" class="whappMini" />   The *Sync Snapshots* feature now works in macOS 10.14.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed crash which would occur for most users after menu command *Reset and Start Over…* had executed.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />   Fixed bug introduced in a recent version which caused documents to not be completely forgotten after they wre found to be no longer available, resulting in false error indications.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Trashing a document with *File* > *Close and Trash* no longer causes *File* > *Recent Documents* when running in macOS 10.14.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />   When exporting to Vivaldi, Opera, Google Chrome, Chrome Canary, or Chromium, any bookmark with an empty URL is now omitted.  (These browsers do not allow such bookmarks, and will change any such bookmark into a folder, which will cause also cause churn when syncing.)

## Version 2.9.7 (2018-12-11)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />   Fixed several functions which did not work for all users because in some cases macOS 10.14 did not show its *Do you want to allow this* dialog.   The important ones are:

  * Adding *Add [that-web-page] to* > our Floating Menu (keyboard shortcut), Menu Extra, or Dock Menu when user visits a web page in any supported browser, including Safari.
  * Landing a new bookmark by clicking the *BookMacster Button* in a web browser or using the *BookMacsterize* bookmarklet
  * Presenting the error dialog when Agent encounters an error and user clicks *View*, for more details.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />   <img src="images/BookMacster.png" alt="" class="whappMini" />   Now prevents contentions which could sometimes occur when BookMacster, Synkmark, Smarky, or their agent (BkmxAgent) syncs with Safari, causing our *Pajara* helper process to crash.  For most users, *Pajara* would be silently relaunched and work, but for some, this could cause a crash dialog to appear, and syncing to fail.  Preventing the collision also reduces resource usage.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />   <img src="images/BookMacster.png" alt="" class="whappMini" />   Further imrovements to Syncing reliability.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />    <img src="images/Markster.png" alt="" class="whappMini" />   <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug introduced in version 2.9.4 which caused the *Choose Clients* or *Choose Browsers* sheet to be misplaced, and also, sometimes prevented the new document from being saved until the next application run.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />   <img src="images/BookMacster.png" alt="" class="whappMini" />   The windows shown upon clicking *Show Syncing Status* and *Reboot Sync Agent* now always appear regardless of whatever the other, or other alerting windows are or have recently been display, and clicking *Done* in one of these windows no longer sometimes cause a crash when running in older macOS versions.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Main menu item *File* > *Close and Trash* works in macOS 10.14 now.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" />   <img src="images/BookMacster.png" alt="" class="whappMini" />   Fixed a bug which caused failure of *Install Bookmarklet into >*, and possibly some other rarely-done operations.

## Version 2.9.6 (2018-11-21)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />   <img src="images/BookMacster.png" alt="" class="whappMini" />   Fixed bug in version 2.9.5 which caused a crash upon clicking *Reboot Sync Agent* if user did not have all of BookMacster, Synkmark and Smarky installed.  (What user might have all  *three* of our apps installed and therefore not have seen this bug?  Our testing department, of course!!)

## Version 2.9.5 (2018-11-21)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />   <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed this bug: While app was quit and Syncing by agent in background, if something hit the browsers' bookmarks file (as iCloud frequently hits Safari's file) without making any substantive change in bookmarks, agent would no longer detect bookmarks changes in that browser until it was rebooted by the *Reboot Sync Agent* command, or if syncing was switched off and then back on again.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Restored ability to open documents which was broken with version 2.9.2 for users running macOS 10.10 or 10.11.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  •  The Sync Watches Report has been redesigned again.  It now includes a summary section giving the total number of watches that were last created, and a section giving the current path watches.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />   <img src="images/BookMacster.png" alt="" class="whappMini" />  Added main menu item *Help* > *Troublshooting* > *"Touch" Safari Bookmarks*. 

## Version 2.9.4 (2018-11-18)

* <img src="images/Smarky.png" alt="" class="whappMini" />  <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Restored readability to the *About* window (*About BookMacster*, *About Markster*, etc.)  when in Dark Mode in macOS 10.14.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Operation of the application menu items *Show Syncing Status* and *Reboot Sync Agent* has been changed to make more sense.  *Reboot Sync Agent* now gives process identifiers of the agent before and after rebooting, determined independently of the agent, and no longer shows a report of Sync Watches from the rebooted agent.  Instead, the report is held in the agent, and issued to the main app when *Show Syncing Status* executes, and is included in the report shown by *Show Syncing Status*.  Also, these commands may work more reliably now (because commnication is now via XPC instead of CFMessagePort).

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Reboot Sync Agent* no longer relaunches the agent if the only active watches are from another application among BookMacster, Synkmark, Smarky.  That was wrong.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Decreased the probability of some errors when exporting to Safari.  (Increased retry limit; affected error codes are 772030, 772031, 772032.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which could cause false appearance of Error 257938 in Logs > Errors upon relaunch if macOS re-opened a document which was open during a system crash, power failure or application crash.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  *Trouble Zipper* reports now create and include a *Syncing Status Report*, and such *Syncing Status Reports* are now archived in the Application Support folder.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer allows macOS to attempt to open document windows which were open prior to he last logout or restart.  This is because we have our own mechanism for doing this or not (document *Settings* > *Open/Save* > *Automatically open this document when app launches*), and the macOS mechanism may be the source of a bug which is preventing document opening for some users.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  When a document is opened, the window which shows "Processing…" now begins to show a countdown after several seconds, and some additional entries appear in Logs.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug whih might cause documents to fail to open.  (-showWindows not on main thread)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer crashes if value of sync snapshots limits in Preferences is corrupt (negative).

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Description in Error 662714 now includes additional information.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer crashes if value of sync snapshots limits in Preferences is corrupt (negative).

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Restored capability of the *Stop all syncing now* command to stop syncing from all three apps (BookMacster, Synkmark, Smarky) instead of just the one currently running.

## Version 2.9.3 (2018-11-03)

* <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  The default *Simple Syncers* no longer performs a sync whenever Firefox is quit, and when this version is first launched, it will remove any such trigger on Firefox quit from any document currently syncing with *Simple Syncers*.  As a result, [Tags will no longer be automatically synced between a Firefox and Synkmark or a BookMacster Collection](http://sheepsystems.com/files/support_articles/bkmx/firefoxTags.html).

* <img src="images/Smarky.png" alt="" class="whappMini" />  <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Added some means to try and fix an issue reported by two users, that sometimes detection of bookmarks changes in browsers does not always work after system wakes from sleep.  (When system wakes from sleep, if the Agent (BkmxAgent) does not have any pending jobs, it reboots itself.)

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused Agent to quit watching for triggers of one .bmco Collection upon opening a different .bmco Collection, and a spurious Error 582987 to appear upon performing an import or export with Pinboard or Diigo.

## Version 2.9.2 (2018-10-27)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Now supports *Dark Mode* when running in macOS 10.14 Mojave.  (To see *Dark Mode*, users must select appearance *Dark* in ** > *System Preferences*  > tab *General*.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />   Fixed several minor cosmetic defects in the .bmco document window and in alert sheets and dialogs.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />   Will now *forget*old documents which are found to be deleted or corrupted, as was the behavior prior to version 2.9.1.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />   The Agent (BkmxAgent) will now terminate itself immediately if macOS launches a version of it which is not currently installed in BookMacster, Synkmark, or Smarky.  This is to prevent more than one agent from being launched if macOS has old versions in its XPC cache, a problem which some users experienced after our last update.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />   If macOS has not opened a .bmco document after 35 seconds of trying, app now displays an error message (257938) instead of the *Processing .bmco* dialog remaining until user force quits the app.  (In addition to adding the timeout, document opening is now peformed on a secondary thread.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Added a workaround for an apparent bug in macOS *Launch Services* which may be causing some of those document-opening errors.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  When running in macOS 10.14 or later, when user clicks a round *?* Help Button, the relevant help page now opens in the user's web browser, served from our  website.  This is a temporary fix, until Apple provides a workaround for their breaking of help anchors in macOS 10.14.  When running in earlier macOS versions, the relevant help page still opens in Apple Help Viewer.

## Version 2.9.1 (2018-10-08)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />   Implemented some means to reduce errors 3025, 303025, 106842.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Changed tab label, which had been *Agents* for many years, and was changed to *Syncers* in the last version, to the more sensible *Syncing*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved operation of the menu item *Log Sync Watches to Clipboard* which was introduced in Version 2.9, changing its title to *Show Syncing Status*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bugs in and improved operation of the *Stop All Syncing* and *Reboot Sync Agent* menu items.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug introduced in version 2.9.0 which caused Error 812002 and failure to sync if user, typically a new user, installed the BookMacster Sync extension into Firefox, Vivaldi, Opera or Google Chrome and then switched on syncing before ever editing bookmarks in that browser.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When BkmxAgent operating in the background fails to open a Collection, no longer removes tells app to "forget" that Collection, and no longer advises user.  This will be done next time the user launches the application.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Most of the Help Book, except screenshots, is now updated to reflect the big change made in  Version 2.9.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Eliminated growth in memory usage over time by the sync agent (BkmxAgent) which was introduced in Version 2.9.

## Version 2.9 (2018-09-30)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />   For compatibility with automatic syncing of Safari bookmarks in macOS 10.14, our system which did the *syncing* work in the background after Smarky, Synkmark or BookMacster has been overhauled.  What were called (in BookMacster) *Agents* are now called *Syncers*, because there is only one *agent*, a new faceless application named *BkmxAgent* which is running constantly (but usually sleeping) whenever *Syncing* is on.  The *Sheep-Sys-Worker* process, which ran intermittently, is gone.  And instead of being triggered by *launchd* agents, BkmxAgent is triggered by other means.  Our apps no longer install any launchd agents.

## Version 2.8.7 (2018-09-10)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Implemented two measures which may reduce or eliminate rare occurrences of macOS Cocoa Error 516 when .bmco document is saved.

## Version 2.8.6 (2018-08-20)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Restored operation of *Quick Search* field in .bmco document window which was broken in Version 2.8.5.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which caused a nonfatal exception when a .bmco document was closed after the *Settings* tab had been open.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could theoretically cause a crash after an error occurred during a syncing operation.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Updated the built-in [Sparkle](https://sparkle-project.org) *Check for Update* subsystem from version 1.18.1 to 1.19.0.  There should be no user-facing effect.  This is just *for the record*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed four memory leaks.


## Version 2.8.5 (2018-08-16)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" /> Edits made during operations by Agents (background syncs while app is not running) now show up in the macOS Versions Browser (*File* > *Revert to* > *Browse All Versions…*) when running in macOS 10.13 or later.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" /> Worked around an apparent bug in the Versions Browser (menu > *File* > *Revert to* > *Browse All Versions…*) of macOS 10.13 and maybe 10.12, which sometimes caused a crash after an old version was selected with *Restore*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Decreased the probability of some errors when exporting to Safari.  (Increased retry limit; affected error codes are 772020, 772030-772032, 772040, 772041.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a condition which could cause syncing to fail until it is restarted, without giving any indication.  (Error 3025 is no longer hidden.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" /> Changed all old references to our sheepsystems.com website which had the `http:` scheme to `https:`.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Restored capability *File* > *Import/Export from only…* > *Choose File (Advanced)* for loose Safari files, which had not been working properly in recent versions. 

## Version 2.8.4 (2018-07-22)

* <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  When an import from or export to Safari fails due to the new restrictions imposed by Apple in macOS 10.14 Mojave, now presents [instructions which explain how to grant access and fix the problem](https://sheepsystems.com/bookmacster/HelpBook/fixSafar10_14), instead of Error 23511.

* <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  In Preferences > Appearance > Floating Menu, there is now an additional control which sets the position of the *Show*, *Background* and *Quit* menu items to *Top* or *Bottom*.  In previous versions, it was fixed to *Bottom*.

* <img src="images/Markster.png" alt="" class="whappMini" />  Fixed a bug which would cause Markster to quit instead of enter background mode if running as a foreground app in macOS 10.13.5 when user clicked *Background Markster*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which would cause, with some rare pathological bookmarks configurations, after executing a *Sort All* operation, items in the Content View to appear in the wrong folder, or nameless folders to appear.  (Only Content Outline view was temporarily incorrect.  If the document was closed and reopened, the view would be correct, and correct data was always exported to browsers and correctly arranged items always appeared in the *Floating menu*.)

## Version 2.8.3 (2018-06-28)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Added a check  to ignore missing name values when importing changes from a browser/Client.

## Version 2.8.2 (2018-06-25)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Added a check to ignore missing URL values when importing changes from a browser/Client.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Added a check to promote more graceful recovery from a certain error when exporting to Safari (ranges in exid index paths).

## Version 2.8.1 (2018-05-22)

Any user who syncs with Safari should install this update now.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Added a safeguard against an apparently valid import from Safari in fact being empty; an occurrence which we've seen a few times when testing in the forthcoming macOS 10.13.5.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  If a syncing operation begins within 60 seconds of system waking from sleep, now waits until 60 seconds after system waking from sleep.  This is to further prevent errors due to a busy system not responding.

## Version 2.8 (2018-05-16)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  The [template of text placed on the system clipboard upon copying bookmarks](https://sheepsystems.com/bookmacster/HelpBook/textCopyTemplate) is now configurable in *Preferences* > *General*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Some housekeeping operations, particularly some during application launching, are now performed on a secondary thread.  This improves performance and responsiveness slightly, but mostly it was done in case there is more than one user who sees macOS sometimes hang in these operations, for reasons unknown.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  * <img src="images/BookMacster.png" alt="" class="whappMini" />  Restored reliability of *Edit* > *Cut* and then *Paste* which sometimes failed in the current version of macOS. 

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  The various change types shown in a document's tab *Reports* > *Sync Log* are now better explained, in tool tips and in the Help Book sec. 4.4.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  If user tries to move the app's single `.bmco` document file by clicking the title bar, a warning sheet indicating that this is not supported appears, and the move is aborted.  (Previously, such a move would appear to succeed until the next launch.) 

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which sometimes caused a crash if two `.bmco` document windows were open while edits were made in the *Preferences* or *Manage Browser Extensions* window.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Removed all functions and user interface supporting the now-defunct *Delicious* aka `del.icio.us` bookmarking service. 

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug, introduced in version 2.5, which prevented proper automatic recovery from some corrupt database files.  (Corrupt auxiliary files, `-shm` and `-wal`, files were not being removed).

## Version 2.7.3 (2018-05-07)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  In the document window, if multiple recent completed export or import results to different destinations (usually browsers) were *Same-Skip*, the status bar at the bottom now shows all of the most recent such results that will fit, instead of only one of them.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  When opening a document window, if Syncing is ready, now displays a sheet which warns that syncing is disabled while a document is open.  This sheet has a *?* button which links to an improved Help Book section on this topic, and a *Don't tell me again* checkbox.

## Version 2.7.2 (2018-05-05)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />   <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved conflict resolution in case the user or a syncing service such as iCloud makes changes in one browser/client, or touches files of different web browsers in rapid succession; also reduced resource usage in these situations.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Restored capability to import and export bookmark *separators* with Firefox, *while Firefox is running*.  This capability was broken last year when Firefox 53 required us to redesign our extensions.  The restored capability requires Firefox 57 or later, and *BookMacster Sync* extension version 43 or later.  (Tags, Descriptions and Keywords still only import/export when Firefox is *not* running, because Firefox' new *WebExtensions* still does not provide the required interface.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />   <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which disabled future syncing operations for 20 minutes if a bookmarks change was detected while the relevant `.bmco` document was open.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />   <img src="images/BookMacster.png" alt="" class="whappMini" />  Events which emit the optional *Sound Effects* (*Preferences* > *Syncing*) have been slightly redefined.  In particular, if syncing is not performed because the `.bmco` document is open, the *Began syncing…* (sewing machine) sound effect is no longer emitted.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused a crash the first time (and only the first time) that a document created in a previous version was opened in version 2.6.1 or later by a user who is still running macOS 10.10 or 10.11.

## Version 2.7.1 (2018-04-24)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Exports to Firefox which use the *quick direct sync* method are faster.  The improvement increases with the number of items being exported, for example 10X typical with 20,000 items.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Exports to Safari, when the Safari bookmarks file has a *Bookmarks Menu*, but it is empty, and bookmarks are being added to or removed from the root, now succeed instead of failing with Error 298441 or 772031.

## Version 2.7 (2018-04-16)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  The *Selection* menu in the main menu has been removed.  Its items have been moved to the *Edit* menu, except for *Show Inspector* which has been moved to the *Window* menu.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Commands *Copy to…*, *Move to…* and *Merge into…*, which previously only existed in the contextual menu, now appear in the new improved *Edit* main menu as well.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Behaviors of some items in that *Edit* menu have been fixed or improved.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could cause items from browsers to be synced out of order, and some new items therefore lost, if if the `.bmco` document contained a *Bookmarks Menu* hard folder which was empty, and Safari was one of the browser/clients being synced.   

## Version 2.6.1 (2018-04-09)

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed responsiveness when syncing changes from another Mac, via Dropbox for example.  This has not been working correctly in recent versions.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Maybe fixed a crash which occurs sometimes when using the Manage Browser Extensions window, particularly in macOS 10.12.6.  

* <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a crash which sometimes occurred after closing a `.bmco` document window or while quitting the app, when running version 2.6, in macOS 10.12.6, if syncing was not configured.  

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  The names of Sync Snapshot files archived now separate the date from the browser's native filename with a dash ('-') instead of a dot ('.').  The latter caused *.Bookmarks* to be interpreted by macOS as a filename extension, which incorrectly filtered it from eligible files when using *File* > *Import from only…* > *Choose File (Advanced)* with Chrome, Opera, Canary, Chromium or Vivaldi selected as the file format.

## Version 2.6 (2018-04-03)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  In the *Syncing* button in the document toolbar, the *Ready* state is now indicated by a yellow dot instead of a green dot, to emphasize the fact that syncing is *Ready* but does not begin until the window is closed.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Now supports importing and exporting the old Netscape `.html` files which are still exported and imported by most web browsers and bookmarking services.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer mangles IPv6 numeric literal URLs upon entering them.

* <img src="images/Smarky.png" alt="" class="whappMini" /> Fixed a bug which caused the sheet indicating *Sync Status has changed…* and prompting *Export* to sometimes appear two or three times after clicking the *Syncing* button to make syncing ready.

* <img src="images/Smarky.png" alt="" class="whappMini" /> No longer fails with Error 54367 when attempting to export to a loose native browser file, or export to a browser installation which has not created a bookmarks file yet (because user has not created any bookmarks).

* <img src="images/Markster.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  If the *Launch in Background* preference is switched on, and a web browser is the active application before the app is launched, and the app is launched from the macOS *Dock* or *LaunchPad*, and one or both *Global Keyboard Shortcuts* are configured, those keyboard shortcuts now work (as expected) in the web browser immediately, without the user first needing activate a different application and then return to the web browser.

## Version 2.5.7 (2018-03-21)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Exports to Safari now reliably push into iCloud again for all users of macOS 10.12.6.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  After exporting to Safari in some macOS user accounts, when iCloud:Safari syncing is off, no longer displays false warning that *macOS indicated trouble while pushing your bookmarks export into iCloud*.

## Version 2.5.6 (2018-03-13)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Restored ability to export a large number of changes to Opera, and added capability to export a large number of bookmarks to Firefox, Chrome and Vivaldi while they are running, although this is still not recommended.  (Large exports to Opera have failed since our version 2.5.3, when we removed the *direct* sync capability due to impracticality in Opera 48+.  The remaining *coordinated* sync capability had always been limited in size.  This new version, together with Version 42 of our *BookMacster Sync* extension which all users should now have, removes that limit.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Plays better with iCloud when exporting to Safari in the older macOS 10.12.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now behaves more efficiently and robustly when importing from or exporting to Safari.  If no problems occur, completes the process without unnecessary waiting.  If rare problems occur, silently recovers and retries more quickly.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a condition which caused Error 325844 occasionally.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Corrected a bunch of references in Help Book and a few other messages which still referred to the old `.bkmslf` file extension which was replaced back in version 2.5 with `.bmco`.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Error 64215 now contains a *underlying* error which indicates *why*.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which affected syncing if user has enabled a document's *Settings* > *Clients* > *Advanced Settings for Chrome* > checkbox *Create a Reading/Unsorted*.  The bug caused an extra unnecessary syncing operation under the hood, and in recent versions, this extra operation would overwrite recent changes from other browsers.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed sorting by *domain, host, path* document setting, which appears to have been not performing for a long time.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could cause a crash instead of presenting Error 298441 or 398441 if something went wrong and timed out while exporting to Safari.

## Version 2.5.5 (2018-03-01)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed several misbehaviors which could occur when exporting to Safari when user's Safari bookmarks have been upgraded by Apple to the new *CloudKit* protocol.  Our thanks to the users who sent their Bookmarks and Document data using *Help* > *Trouble Zipper* in our apps' menu bars!

  * Added two fixes for users of macOS 10.12, which seems to temporarily lose track of items after moving one.  This can result in failure of the export with either Error 772031 *Could not find a movee* (if an item was moved into *limbo* after its original parent was removed) or Error 772032 *Could not find movee's new parent* (if an item is moved into a moved folder).  It is possible that this fix may also eliminate, in macOS 10.13, the occasional retrial which occurs under the hood after a few seconds, when an export to Safari initially fails.

  * Fixed bug which could be seen particularly if new item(s) were added to the root, causing the export to fail with Error 772031 or 772032, indicating *Could not find* a *movee* or its *new parent*.

  * Now succeeds when exporting to Safari a bookmark which was imported from Firefox as a *Live Bookmark* (RSS), if user's Safari bookmarks have been upgraded by Apple to the new *CloudKit* protocol, instead of failing with Error 772030.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved a performance bottleneck when exporting to Firefox..

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which could cause a crash or failure to export to Safari if the exporting document did not have a *Bookmarks Menu* in its *Settings* > *Structure*.

## Version 2.5.4 (2018-02-19)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Errors 145725 and 651507 no longer cause syncing to be switched off, and when occuring in a background Worker's Agent, are no longer automatically displayed to the user.  These errors are caused by non-responses from web browser extensions, and after extensive testing we've concluded that such non-responses do occasionally occur on busy Macs.  Also, with recent improvements in our apps, listed below, we can almost always recover from these non-responses on the next sync operation without losing any data (new bookmarks, for example).  So the warnings and switching off of syncing are now more annoying than useful.  Also, when 145725 does occur now, user is advised to simply relaunch the browser first, which often fixes it, before reinstalling the extension.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Made many improvements to reduce redundant sync operations when *Syncing* is switched, one of them to fix a regression in version 2.5.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Background Agents' Worker are now smart enough to import from any number of browsers instead of just *all* or *one*.  This gives some better conflict resolution when there are syncing conflicts due to bookmarks being changed rapidly in multiple browsers, and lays the groundwork for further improvements in conflict resolution.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Increased the sleep to allow browsers to launch, before even trying to open a port, from 8 seconds always to to 10 secs in main app and 30 secs in background Agents' Workers.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Background Agents' Worker now skip syncing other browsers as soon as a conflict is detected, instead of finishing and *then* doing it over a minute later.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a memory leak which caused imports and exports by background Agents' Workers using browser extensions to fail if a BookMacster process had executed a similar operation, until that BookMacster process was quit, and may have been causing other misbehaviors.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Timeouts when importing from or exporting to Safari have been readjusted.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed the silent retry of any failed imports and exports with Safari which was introduced in the previous version, which was not working for failed *reading* bookmarks, due to an oversight.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The metadata file introduced in version 2.5.3 is no longer sometimes trashed, which caused unnecessary syncing operations.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Maybe fixed a bug which rarely causes a crash when displaying the *Manage Browser Extensions* window.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer suggests that large exports to Opera be done without launching Opera.  (This change is an omission from, the previous version 2.5.3, wherein the fast *Direct* method became no longer available when exporting to Opera.)


## Version 2.5.3 (2018-02-02)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Imports from and exports to Opera using our fast *Direct* method, while Opera is not running, are no longer attempted.  Opera must always be running (or will be launched), and our *BookMacster Sync* extension must be installed, during any import from or export to Opera.  (The reason for this is that Opera 48+ apparently has some *salt* or other intentional obfuscation in its Bookmarks file's checksum, which is impractical for us to chase after.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When syncing by a background Agent's Worker after user logs in, waits until 5 minutes after login.  This is to reduce the occurrence of sync operations failing because the system or web browsers were too busy and not responding.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer warns the user when Syncing is on and a bookmarks change from a browser is detected while app is running.  (Browsers are making more "noise" lately, and these warnings are getting too annoying.)  To replace this warning, the terminology *Syncing is active* has been changed to *Syncing is ready*, and tooltips improved.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Upon opening a `.bmco` document (including a newly-converted `.bkmslf` document, any metadata stored as it has been in previous versions (in Core Data's metadata) is now moved to a separate file in the new  `.bmco` document package, and future metadata changes are now always stored in this separate file.  This is much more reliable and is known to fix at least one bug, that operations done by a background Agent's Worker, in macOS 10.13.3 and possibly other macOS versions, reducing some unnecessary sync operations.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed two similar bugs which could sometimes make it appear that our Firefox, Chrome, Opera or Vivaldi extensions were not responding, producing Error 651507.  (Singleton creations were not thread-safe.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  If web browsers are launched or quit to complete a Import or Export operation, they are now set back to their original launched/quit state even if the operation was aborted due to some error, or a syncing conflict.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  To reduce timeout errors when computer is very busy, increased the allowed time per change for exporting to Firefox (from 0.998 to 0.50777 secs).

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which, on rare occasions, caused triggering of sync operations by bookmarks changes in browsers to be halted for 30 minutes.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Implemented a workaround which eliminates occasional occurrence of Cocoa Error 516  syncing operations by a background Agent's Worker, and may fix other occasional save-related errors which have occurred starting with version 2.5. (Opted out of asynchronous saving.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Errors 298441, 398441 or 772XXX when importing from or exporting to Safari should occur much less frequently, maybe never.  (Since these failures seem to occur in Apple frameworks, and not very often, we now silently retry the operation if any of them occurs.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug, probably around since 2.4.10, which could cause a silent failure to export to Safari.  (XPC process would terminate.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which caused the numbers given in the menu item *File* > *Stop Workers, Agents* to sometimes not make sense.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which would have prevented recovery from error if reading from Safari failed.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which caused a crash during a Import from or Export to OmniWeb 6 in some cases.

## Version 2.5.2 (2018-01-08)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Added code to log information related to a certain rare cause of Error 651507.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which, rarely, caused a crash on launch.  (Fix is in ClassesObjC commit 3205b8.)

## Version 2.5.1 (2017-12-29)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed recent issues which have occurred while exporting to Safari when iCloud Safari syncing is used in older macOS versions 10.11 or 10.12.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug in introduced in 2.5 which caused import or export to hang and need force quit instead of indicating error if reading Safari bookmarks took too long.

## Version 2.5 (2017-12-28)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> This version replaces the *Bookmarkshelf* document (*.bkmslf* file) with a new *Collection* document (*.bmco* file package).  Upon opening a *.bkmslf* file in this version, it will automatically be removed and replaced with new *.bmco* file package.  [More info](https://sheepsystems.com/developers_blog/new-bmco-file-format.html).

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  During launch, if user is warned that a synced browser/client is has disappeared, the appropriate tab to correct the problem is now opened.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused syncing upon Firefox quit to be unreliable, particularly if BookMacster had been previously installed.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> Fixed a bug which caused redundant records to be left in the Preferences indicating action to be taken when Firefox quit.  This may or may not have affected behavior adversely.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Automatic, silent recovery from a document saving error (Cocoa Error 67000) is now more reliable in macOS 10.12 and 10.13.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Effects of the *Stop All Syncing Now* menu item have been improved.   When BookMacster documents are found to have Advanced Agents, those are now are switched off instead of being removed.  Also, fixed some edge cases wherein some malformed Agents were not affected.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed some misbehaviors while running in macOS 10.13 High Sierra: when duplicating documents, and when macOS' state restoration re-opens a previously-unsaved document.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer supports opening documents created with BookMacster version 1.14.1 (2013-Mar-27) or earlier.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug found by Apple's new Thread Sanitizer tool which theoretically could have caused misbehavior during Import operations.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a very old bug which could cause, upon first running a new or different version of the app, preferences and other data to not be updated correctly, if the different version is installed in a location which is of lower priority in the opinion of macOS than some pre-existing installation, and the pre-existing installation was not removed.  (Fix is in ClassesObjC commit 908b3f9.)

* <img src="images/BookMacster.png" alt="" class="whappMini" />  When adding a Command to an Advanced Agent, no longer logs *Internal Error 341-0815*.  It was actually a false alarm.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> The dialog announcing Error 198385 now says less and instead links to our [Bookmarks Manager Selection Guide](https://sheepsystems.com/products/bkmx.htmlF)).

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> The warning and 20-minute lockout which occurs after exporting hundreds of changes to Safari no longer occurs, incorrectly, if the export was only a *Test Run*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> When exporting to Safari using the new iCloud protocol which we began supporting in verison 2.4.12, now reads the existing bookmarks more exactly as Safari does, so that, if there are bugs in Safari such as [this one](https://youtu.be/LH8Tt9orqmo), our apps will mimic the bugs that Safari has, instead of throwing errors such as Error 772031 due to mismatched behaviors.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> When importing from or exporting to Safari, now properly identifies the Favorites Bar, even if the Favorites Bar representation in the file is missing the customary identifying title.  This new behavior mimics that of Safari itself.  With the old behavior, exporting to such an unconventional/corrupt file could result in failure, indicating one of various errors, such as Error 772031 *Could not find putee".

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Added a hidden preference (com.sheepsystems.Pajara logVerbosity) for debugging a crash with a particular user.

## Version 2.4.13 (2017-11-12)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which cause *Remove URL Cruft* to fail if cruft ranges from mulitple cruft specifications had interleaved ranges.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Installing the *BookMacster Sync* extension no longer breaks operation of the *BookMacster Button* extension's button.  (Normally, users install one or the other but not both.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Restored the *open* AppleScript command (for opening documents) which apparently disappeared at some point in recent years.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When executing *File* > *Export to only…*, the recently-added checkbox title *Do NOT launch … to coordinate syncing* now does not appear in some cases where we know such a launch will not happen.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When exporting to Safari using the new protocol which was added in version 2.4.12,
  * The Status Bar now shows progress *Pushing changes to Safari* instead of going blank for 1-3 seconds.
  * A timeout has been added.  It generates an error which would help us diagnose the problem in case such an export ever fail.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Removed *Bookdog Grads Quick Start* sec. 4.18 from Help Book because it contains outdated content and there are not enough Bookdog users out there any more to warrant fixing it.

## Version 2.4.12 (2017-11-08)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Exporting to Safari is now compatible with a new iCloud protocol.  So that we can track our quality and quickly deal with any issues which may arise, apps now send iCloud migration status and related performance statistics anonymously to our server.   The obligatory checkbox to opt out of such sending has been added to *Preferences* > *General*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed issues which will make *coordinated* exports to Firefox, Chrome, Opera or Vivaldi faster and more accurate:
  * Fixed a bug which caused items items to be exported out of order to Firefox, Chrome, Opera or Vivaldi during *coordinated* exports, if items in that folder were shuffled in a certain way.
  * Eliminated some redundant transactions sent to the browser.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which caused little translucent rectangles to sometimes remain on the screen after dragging item(s) in a document's Content View, when running in macOS 10.13.  (Fixed SSMoveableToolTip).

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Restored import and export compatibility with custom Firefox profiles to which the user has given an Absolute (as opposed to Relative) path, when using the recent versions of Firefox.  (Updated SSYFirefoxProfileFinder to correctly parse profiles.ini files produced by current Firefox.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />   Fixed a bug which caused failure to export to Vivaldi, with Error 266541, if the *Reading List* in our app contained (new) items which did not exist and thus needed to be created in Vivaldi.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />   When using version 29 or later of BookMacster Button Extension, or version 41 or later of BookMacster Sync extension, the *Test* in the *Manage Browser Extensions* window is now more rigorous.  (It now talks all the way through to the actual extension in real time, instead of just asking our Native Messaging tool which was launched by the extension for the configuration info that it got from the extension when it loaded.)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Added some defenses against a rare occurrence of the *BookMacster Sync* Firefox extension sometimes going *dead* until Firefox is relaunched.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Based on some new experiments and data from users, the reason and recovery suggestions presented with Errors 453973 and 651507 no longer implicate *too many bookmarks*, but instead implicate *CPU hogging by other processes*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> The requirement that no folder contain more than 500 items before exporting to Safari now applies whether or not iCloud:Safari is in use.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The threshold for warning user that a significant change has been made to Safari has been raised from 100 to 250 items.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />   After exporting a large number of changes to Safari, now advises the user to  give iCloud 20 minutes to sync before making any further changes, and also BookMacster, Synkmark or Smarky will ignore any churning of bookmarks by iCloud during this period.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Executing *Reset and Start Over* no longer disables browser extensions until the next time that our app is relaunched.  (The symbolic link required for communicating with extensions is now restored immediately.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Previous versions may have, at times, tried to treat the text under the name of a Safari > Reading List item as the item's *Comments*.  It appears that this may have worked in earlier versions of Safari, but it is not possible to prevent the current version of Safari from overwriting them.  To reduce complexity and increase reliaibility of exports to Safari, this would-be feature has been removed.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  If a manually-initiated export fails, the error sheet which appears now indicates immediately to which browser it failed.  This is helpful when performing *Export to all*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />   Improved some log entries.

## Version 2.4.11 (2017-09-10)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />   Fixed a few subtle cases in which our app would not correctly detect whether or not the content had been changed.  This affects two functions:
    * Regarding the warning which may appear when closing a synced document, that there are *changes which have not been exported*, there could have been false positives (warning appeared when there were in fact no changes) or missed negatives (warning did not appear when there were subtle changes).
    * When exporting to or importing from a Client (Browser), the operation was in some cases skipped when there were in fact subtle changes to sync, or performed when there were in fact no changes to sync.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  After the *Find Duplicates* upon opening executes, in documents where this option is switched on, if none are found, sheet now indicates: No *new* duplicates were found. We've added the word *new*, to indicate that there may be duplicates already known and shown in the *Duplicates* tab.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The 'host' segment of urls, if all their characters are decimal digits, and value is in the range 0 through 256^4, are now normalized to dotted quads, as Chrome and Firefox do.

## Version 2.4.10 (2017-09-01)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Package now includes updated extensions: BookMacster Button version 28, and BookMacster Sync  version 40.  The new Button version fixes a bug in the previous version which caused extra processes to sometimes be left sleeping instead of terminating.  Also, our apps have been changed to require these new versions for Firefox, Vivaldi, Chrome, Canary and Chromium.  Opera must wait until their review and approval process completes :( Due to an oversight in previous versions, thes versions will not be updated automatically by Firefox.  Users will be prompted to click through the reinstallation process.  In Vivaldi, Chrome, Canary and Chromium, our extensions should already be updated because our new versions were published by the Chrome Web Store last week.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  To play better with macOS 10.13 High Sierra, before importing from or exporting to Safari, our apps now only wait for apparent iCloud activity if the user has opted in to iCloud Safari syncing.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> After installing an extension into Opera, it now works, even if user has not also installed one of our extensions into Google Chrome.  (Before installing an extension into Opera, now installs a *Native Messaging Special Manifest* file into Google Chrome's `Application Support` folder, as well as in Opera's `Application Support` folder, because, oddly, the former is where Opera looks for it.)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Users should see fewer instances of Error 651507.  (After [analyzing data collected by testing Chrome and Firefox](https://docs.google.com/spreadsheets/d/1G9Cw8H5fG7G1ecxzj_lVjp2MSn9tqD4y2uL8ziihq8w/), we determined that there are rare outlier cases in which the last phase of an export, that which times out with Error 651507, can be delayed by macOS or the browser for a minute or more.  The minimum timeout has been increased from 15 seconds to 30 seconds when exporting for manually-initiated exports from within the application, and to 5 minutes for automatic exports initiated by a background Agent's Worker.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Before importing from or exporting to Firefox, now uses a different, possibly new indicator to determine whether or not a user who has opted in to Firefox Sync has its *Bookmarks* checkbox on or off.  This different indicator has been found to be more reliable in Firefox 55.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer stops and issues a warning if a proposed export to Firefox will take too long and cause nonresponsive behavior while Firefox is running.  Due to improvements in recent versions of Firefox, this is no longer necessary (and is instead annoying) for tne typical user who has not disabled Firefox' automatic updates.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug in the *Manage Browser Extensions* window which caused the button(s) in the top row (usually *Chrome*) of each family (*Sync* or *Button*) to not respond to mouse clicks unless user clicked in the bottom half of the button.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Updated the built-in [Sparkle](https://sparkle-project.org) *Check for Update* subsystem from version 1.15-ish to 1.18.1.  There should be little or no user-facing effect.  We're *just sayin'*.

## Version 2.4.9 (2017-08-09)

* <img src="images/Smarky.png" alt="" class="whappMini" />  <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer fails, falsely claiming that our *Sync* extension is not installed, when exporting to Firefox 55 while Firefox 55 is running.

* <img src="images/Smarky.png" alt="" class="whappMini" />  <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> If the Logs database file is corrupt, will now delete the file and start a new one.

* <img src="images/Synkmark.png" alt="" class="whappMini" />  Fixed a bug, which has been variously present in recent versions, which caused Error 193835 to be created a displayed in some cases if Firefox was quit while Synkmark was running.

* <img src="images/Smarky.png" alt="" class="whappMini" />  <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Before exporting to Safari, if iCloud syncing is in use, now checks all folders to ensure that none contain more than 500 items and, if so, fails.  The Help button in the error opens an explanation which has a link to [Apple  documentation stating that iCloud may misbehave if you put more than 500 items in a single folder](https://support.apple.com/en-us/HT203519).

* <img src="images/Smarky.png" alt="" class="whappMini" />  <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved wording of instructions for installing extensions into browsers with multiple profiles.

* <img src="images/Smarky.png" alt="" class="whappMini" />  <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which disallowed drops of text strings from other applications (to create new bookmarks) into empty folders.

* <img src="images/Smarky.png" alt="" class="whappMini" />  <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When dropping tab-return text strings from other applications (to create new bookmarks), no longer creates an extra *untitled* bookmark with no URL if the text string ends in a newline.

* <img src="images/Smarky.png" alt="" class="whappMini" />  <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When pasting tab-return text strings from other applications (to create new bookmarks), now accepts multiple items in the [special tab-return format](https://sheepsystems.com/bookmacster/HelpBook/bkmxTabReturn), same as when drag-and-dropping.

* <img src="images/Smarky.png" alt="" class="whappMini" />  <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When adding a new bookmark from another application, or creating one from scratch using the *Add* action button, the *Undo* action in the *Edit* menu is now indicated as *Undo Insert…* instead of *Undo Move…*.

* <img src="images/Smarky.png" alt="" class="whappMini" />  <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixes some inefficiency when exporting to Safari.  (When exporting to Safari 11, no longer unnecessarily writes *Changes* to the file if iCloud is not in use.  When running this version for the first time, checks for and removes any such *Changes*, which may still be present for users who do not regularly add or otherwise change bookmarks within Safari.  This is a continuoationof the change for Safari 11.0 which we made in version 2.4.8.)

## Version 2.4.8 (2007-07-08)

*<img src="images/Smarky.png" alt="" class="whappMini" />  <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Compatible with macOS 10.12.6 and/or Safari 11.0.  (Without this change, our app may think that iCould+Safari syncing is ON when in fact if is OFF, which will cause an error message to appear after an export to Safari.)

*<img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Restored capability to completely create a Firefox bookmarks database file from scratch, in the event that the user's file is missing or corrupt.

*<img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved emulation of Firefox during exports while Firefox is not running.  Although this does not fix any misbehavior that we know of at this time, it's better and safer.  (Now updates *syncChangeCounter*, no longer names the three hard folders representing shown in Firefox' *Show All Bookmarks – Library*.)

*<img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved wording of Error 651507.

<img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Backed out of a change in 2.4.6.  If it is detected that an extension is already installed, instead of changing to *Reinstall* as in 2.4.6, now becomes disabled, as in 2.4.5 and earlier.  Although it is more flexible in edge case, the 2.4.6 behavior gives user the impression that “Reinstall” will uninstall first.  But it doesn't work that way.  If this is used on Chrome for example, Chrome tells the user “Added to Chrome”, meaning that it's already installed; quite confusing.

*<img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Package now includes updated versions, BookMacster Button extension version 26, and BookMacster Sync extension version 26, signed by Mozilla, for initial installation into Firefox.  This does not affect existing users because the new versions published a few days ago and should already have been downloaded and silently installed by Firefox.

## Version 2.4.7 (2017-06-19)

* <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The Floating Menu, Menu Extra and Dock Menu can now land new bookmarks from the current page being viewed in Firefox, Opera, and Vivaldi.  This requires that these browsers have installed either BookMacster Sync extension version 38 or later, or BookMacster Button extension version 26 or later.

* <img src="images/Smarky.png" alt="" class="whappMini" />  <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Clicking the the application menu *Stop All Syncing Now* now completely removes all Synkmark agents, even if Synkmark is syncing Firefox.  This has appeared to not work (The menu item still indicated *1 document* syncing the next time it was clicked) since version 2.3.  Actually, syncing was stopped, but there was a vestige which caused this false indication.

* <img src="images/Smarky.png" alt="" class="whappMini" />  <img src="images/Synkmark.png" alt="" class="whappMini" />  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Code improvements suggested by latest Apple Developer tools (Xcode 9).

## Version 2.4.6 (2017-06-03)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the *Manage Browser Extensions* window, if is detected that an extension is already installed, the relevant *Install* button now changes its title to *Reinstall*, instead of becoming disabled.  (Update: This change was later removed, in 6.4.8.)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Syncing with Firefox via the Firefox extension now works properly again (since version 2.3) for users who have renamed their default Firefox profile, or reset Firefox.

## Version 2.4.5 (2017-05-28)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> When using VoiceOver, the command VO+m now changes focus to the main menu as it does in other applications, instead of causing our app to lose focus.  (Our apps no longer always start in the background and switch to the foreground if the *Launch in Background* preference is switched OFF.  That previous configuration triggered an apparent bug in macOS which caused some VoiceOver commands to fail.)

* <img src="images/BookMacster.png" alt="" class="whappMini" /> If the *Launch in Background* preference is switched ON, BookMacster will now momentarily flash its menu bar during launch.  (This is a side effect of the previous change.) 

## Version 2.4.4 (2017-05-25)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Improved support for screen-reading accessibility tools such as VoiceOver.

* <img src="images/Markster.png" alt="" class="whappMini" /> Changes to the Manage Browser Extensions window in Markster:

** Can now install our Button browser extensions into Canary, Chromium, Opera and Vivaldi too.

** Can no longer install our Sync browser extension into *any* browser.  (The only benefit of the Sync extension to Markster was to allow import/export with Firefox and Chrome while they are running.  However, the typical Markster user will import/export with browsers infrequently.  Also, import/exports performed via extension are much slower than import/exports performed via *direct access*, and eliminating software components decreases trouble and makes for happier users.)

* <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Indications in the *Manage Browser Extensions* window are now more trustworthy.  (Hitting the round *refresh* button, or re-activating our app, now quits any browser(s) if extensions have been recently installed or uninstalled, and clears any prior *test results*, before new indications are determined.  Previously, nothing happened when merely re-activating our app.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> In the *Logs* window, hitting the round *refresh* button now also scrolls the messages to the bottom so that new messages are immediately visible.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> The Preferences window, when displaying the *Preferences* > *Syncing* tab, now becomes as wide as necessary to show all of the user's browser and profile names in their entirety, even if there are one or more really long profile names.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  The document window, when displaying the *Settings* > *Clients* tab, now becomes as wide as necessary to show all of the user's client and profile names in their entirety, even if there are one or more really long profile names.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Clarified Help Book sec. 4.4.22.

* <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In *Preferences* > *Adding*, the image of our old menu items in Firefox (not used since version 2.3) has been removed.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Running this version once will remove some unnecessary files in user's `~/Library/Application Support` directory.  These files were inadvertently created by version 2.3 through 2.4.2.

## Version 2.4.3 (2017-05-08)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed several bugs which sometimes caused sync processes to begin unnecesarily when syncing with Chrome, Opera, Vivaldi, Chromium or Canary.  This would occur after exporting changes from another browser to one of these.  (The expected, spurious change notifications were not always identified as such, which resulted in sync processes being staged, and the sync processes would run a little, up until hashes were matched.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which, if user changed Syncing Agents while active and a Trigger was removed while a trigger was in process, could cause a large number of Error 3025 to be logged, instead of just one.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which caused Error 916540 to mask and overwrite, if it was, an underlying Error 484903.

## Version 2.4.2 (2017-05-02)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The Profile Name shown after *Chrome* or *Chrome Canary* in various places (example: *Chrome (My Profile Name)*) now shows the name shown in the *Person* menu of Chrome or Canary, even if the user has edited this name within Chrome, Canary, or Google Accounts and ID Administration.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved layout of *Manage Browser Extensions* window to provide more room for long profile names.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which prevented operation of browser extensions for Chrome, Canary or Chromium if user did not have a current-version extension installed into the browser's' *Default* profile, or no longer has a *Default* profile.  (This may be the case if user has created and is using other profile(s) instead.)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" />  Synkmark and Markster now show Vivaldi and Opera in *Manage Browser Extensions* window.  This should have been in 2.4.

## Version 2.4.1 (2017-04-29)

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug introduced in version 2.3 which prevented tags of new bookmarks from being exported to Pinboard or Diigo.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed several bugs in the Status Bar at the bottom of the document window:

* Upon opening a document, and at other times, no longer displays the meaningless announcement: *Completed:*.
* If user edits Content during a *Verify* or *Upgrade Insecure Bookmarks* operation, the progress bar is no longer pre-empted by *Loading Window…* or *Completed: Save*.
* No longer sometimes momentarily shows *Verify* results following an operation which is not a *Verify* operation.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The *Export Exclusions* area of the Inspector panel now reliably shows checkboxes when expanded.

## Version 2.4 (2017-04-27)

* <img src="images/Synkmark.png" alt="" class="whappMini" />  Synkmark can now sync browsers Vivaldi, OmniWeb, iCab and Opera too, instead of only Firefox, Safari and Chrome.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When exporting to browser Vivaldi while Vivaldi is not running, exports are now accepted by Vivaldi without rewriting in a way that could result in duplicate bookmarks later (due to changing identifiers).  (Vivaldi's '*Trash* is now included in the checksum.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the Inspector panel, the *URLs* view and *Export Exclusions* view now appear in sidebars (the former a *bottombar*) instead of drawers.  This is to conform to latest Apple Human Interface Guidelines, eliminate warnings in System console, and avoid future macOS bugs driven by Apple's neglect of *no longer recommended* features.

* <img src="images/Synkmark.png" alt="" class="whappMini" />  In *Preferences* > *Syncing*, all browsers now show in the list immediately – user no longer needs to make the window bigger as has been necessary since version 2.3.

## Version 2.3.6 (2017-04-25)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now correctly detects installation of our extensions in current versions of Chrome, Canary, Chromium, Opera, and Vivaldi, eliminating false warnings that they are not installed when they are.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Restored capability to install extensions into Vivaldi and Opera, which was broken in version 2.3.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Added new section 4.4.4.2: *Mapping Illustration - What Goes Where* to Help Book. 

## Version 2.3.5 (2017-04-20)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  If export to Firefox, Chrome, Vivaldi or Opera while browser is running contains too many changes for these browsers to comfortably accept, now gives a pre-flight indication and workaround (to quit the browser and retry), instead of failing with an incorrect explanation.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When performing a manual export using the menu command *File* > *Export to only* >, the sheet which appears now offers an option to NOT launch the browser to coordinate syncing, and the sheet is easier to read.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer stalls our new Firefox extension when exporting bookmarks whose attributes contain some corruption such as ASCII control characters.  (Before exporting to Firefox or Chrome while Firefox or Chrome are running, now removes any zero-width control or illegal characters which cause Firefox' new WebExtensions bookmarks API to choke.  Their old API did not seem to mind.)   

## Version 2.3.4 (2017-04-18)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  More meaningful message presented with Error 453973.

## Version 2.3.3 (2017-04-16)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug from 2.3 which would cause bookmarks *Comments* to be overwritten during a manual import from Firefox while Firefox was running, which was preceded by a manual export to Firefox while Firefox was not running.

## Version 2.3.2 (2017-04-16)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug in 2.3 which, when syncing, could cause the second of two browsers to not trigger when bookmarks where changed.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused the document window to end a Verify operation with a empty sidebar if there were only a few bookmarks to verify.

## Version 2.3.1 (2017-04-14)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The *Verify Progress* view now appears in a sidebar instead of a drawer.  (This is to conform to latest Apple Human Interface Guidelines, eliminate warnings in System console, and avoid future macOS bugs driven by Apple's neglect of *no longer recommended* features.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Restored importing and exporting of bookmark *Shortcut* attributes (as *Keywords* in Firefox) with Firefox, when Firefox is not running.  This has apparently been broken in recent Firefox version(s).

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When importing and exporting with Safari, now properly imports and exports the recently-discovered (and almost undiscoverable) *Description* attribute, and maps it to our *Comments*.  Also, no longer clobbers a couple of other recently-discovered attributes (*previewTextIsUserDefined* and *imageURL*), which Safari would replace later.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Now supports the current (sandboxed) version of OmniWeb 6.0.  (Imports and exports bookmarks from OmniWeb's sandbox.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bugs in the *Settings* and *Reports* tab of the .bkmslf document (main) window which caused the segmented controls at their tops to sometimes shift horizontally off center after certain sequences of tab selections.

## Version 2.3 (2017-04-10)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  This version will find, remove and replace the Firefox extensions installed by previous versions with new extensions that are compatible with Firefox 53.  Due to limitations in Firefox 53, the new extensions will somewhat impede the syncing of Separators, Tags, Keywords (shortcuts), Descriptions (Comments) and Live Bookmarks in Firefox, [as detailed in this article](https://sheepsystems.com/files/support_articles/bkmx/firefox53.html).

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  To accomodate the limitations of Firefox 53 referenced in the previous item, then default *Simple Agents* now trigger a sync operation whenever Firefox quits.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When calculating whether or not an impending Import or Export operation exceeds the Safe Sync Limit, mere changes to the attributes of existing bookmarks are no longer counted.  This is because such changes have never seen such changes indicate trouble (as additions and deletions do), and also with the limitations of Firefox 53 referenced in the previous item, such changes will be expected.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the Inspector panel, fixed the *Name*, *Shortcut* and *Comments* fields which were only occupying half of their available space in recent versions.  (This bug was probably due to a breaking change in Apple's Developer Tools.)

* <img src="images/BookMacster.png" alt="" class="whappMini" />  If Advanced Agents are in use, no longer automatically adjusts Triggers in response to other Agent changes, which made some trigger type combinations impossible to set.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which caused the *Browser Quit* trigger (used for some second-tier browsers such as OmniWeb, and available in Advanced Client Settings) to fail after the first syncing operation, until BookMacster was relaunched.  (QuatchRunner was not being recreated.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In document window > Reports > Sync Logs, the second row in each table item is now always visible.  Previously, it was not visible in macOS 10.12 for certain settings of Preferences > Appearance > Font Size > Tables, Tags.  (Fix was in SSYAlert.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Worked around some misbehavior apparent with macOS 10.12 which caused, if user has, in System Preferences > General, switched on *Ask to keep changes when closing documents*, a newly-opened (*clean*) document to act as though it is already *dirty* (dot in red *close* button, asks Save/Revert/Cancel when document closed).

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Application menu item *Stop All Syncing Now* now always removes orphaned semaphores as expected, even if there are no Agents to remove and no Workers to kill.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Corrected message which appears if user of Advanced Agents closes document while syncing was paused.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The advice which appears with the warning which appears when bookmarks are modified externally while Synkmark or BookMacster is running now also advises to *not* make Synkmark or BookMacster a Login Item. 

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could give wrong order if *Sort by Rating* was selected in Settings > Sorting.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could cause sync churning if document contained a folder whose items could be sorted in more than one way (for example, sorting by name when there are bookmarks in the same folder which have exactly the same name), and Synkmark or BookMacster on two different Macs are linked by a browser's syncing service (iCloud, Sign in to Chrome or Firefox Sync for example).'

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved message written to logs when a Sync Fight is detected.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved Help Book sec. 3.3.5.

## Version 2.2.18 (2017-02-01)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed some extraneous logging to system console, and possibly other yet-to-be-unseen *SQLite* issues, when interoperating with future versions of web browsers Firefox, Chrome, Canary, Opera, Vivaldi or Epic.  (Updated our built-in SQLite library from version 3.7.17 to 3.16.2.)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved the message displayed when a browsers' bookmarks are changed while an open document in Synkmark or BookMacster is syncing it. 

## Version 2.2.17 (2016-11-25)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  During launch, now detects a failure in macOS which would cause our apps to silently fail to open any document windows, and presents a dialog suggesting to the user how to fix the problem.  (The failure by macOS is that it does not properly bring our app to the foreground when requested.  It is probably caused by insufficient system resources of some kind, because it occurs reproducibly when at least 95 or so Safari tabs are open.  The suggested fix is to close tabs or quit other apps which are not being used.) 

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a couple details which may have caused some issues with exporting Shortcuts (*Keywords* in Firefox), and possibly other attributes to Firefox, while Firefox was not running.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could rarely cause a crash, or improper drawing, when displaying the Content View after items had been rearranged.

*  <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug in the *Advanced Client Setting* to *Create a Reading/Unsorted* in Google Chrome, Chromium and Canary.  The bug caused, under certain conditions, the app to hang during an import after this feature had been activated.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The *Uninstall* command in the application menu now does a better job of finding all documents, and gives user the option to preserve shared components which are used by the other apps in this family, so that *Uninstall* may now be used if user decides to swicth from one app (Synkmark, for example) to another (BookMacster, for example).

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Clarified Help Book sections 4.8.3 and 4.4.10.

## Version 2.2.16 (2016-10-21)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  After deleting item(s) in the Content View, the next item in the outline or table is selected.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused a crash if user would (1) Click in the main menu > *File* > *Duplicate*  (2) immediately, in the title bar, rename the file to match that of a filename which already exists in the parent folder  (3) hit return  (4) in the dialog sheet announcing the name conflict, click *Replace*.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Updated Help Book sec. 4.11, [Multi-Device Sync Configurations](https://sheepsystems.com/bookmacster/HelpBook/syncMultiDesign).

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now treats Firefox' *Nightly* developer build as Firefox, and behaves appropriately when it is running.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now gracefully bypasses instead of raising an *Internal Error* in one particular case of corrupt data (Clientoid has NSNull profile).

## Version 2.2.15 (2016-10-10)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused adding a new bookmark in certain ways, and also re-verifying bookmarks, to fail when operating in macOS 10.11 or earlier.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Names of bookmarks created by dragging *.webloc* files in to Content no longer have *.webloc appended.  (This was broken in a recent version as part of a fix for macOS 10.12.)

## Version 2.2.14 (2016-09-30)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused, when running in macOS 10.12, an exception/crash while exporting some tags to a browser or client which does not support tags.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer performs actions which user has set to perform upon opening (import, sort and/or find duplicates) immediately after recovering a prior document version from the macOS Version Browser (*File* > *Revert to* > *Browse all versions…*).

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug in the *Fabricate Folders* feature which caused additional folders to be fabricated on subsequent imports from web services Delicious, Diigo or Pinboard. 

* <img src="images/Markster.png" alt="" class="whappMini" />  Fixed a label in the Preferences window toolbar which has been garbled since version 2.2.7. 

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Adjusted timeout to give better indication when Pinboard's API is down.

## Version 2.2.13 (2016-09-27)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused nothing to happen if bookmarks or folders were pasted into a new, empty document or if nothing in the document was selected.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the Verify report, when user changes the disposition of bookmarks with HTTP Status 302, the numbers in the report now update as expected.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the *URLs* drawer of the Inspector panel, the displayed URLs now reflect their current values, even immediately after a change.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug, when running in macOS 10.12 Sierra, which caused documents to not function properly after an old version was restored using *File* > *Revert to…*, until the restored document was closed and re-opened.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could cause a crash a minute or two after re-opening a document with File > Revert to Saved….  Possibly this crash only occurred in macOS 10.12 Sierra.

## Version 2.2.12 (2016-09-04)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug introduced in version 2.2.11, by the last fix for macOS 10.12 Sierra, which caused Opera and Chrome extensions to fail after a while.

## Version 2.2.11 (2016-09-03)

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed several bugs, which could cause [churning](https://sheepsystems.com/bookmacster/HelpBook/churn) of Opera bookmarks, and consequent *Safe Sync Limit* warnings during later imports or exports with Opera, if items previously exported had been trashed within Opera, or if export was done while Opera was not running.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused installing one of our Chrome-ish extensions to disallow proper loading of a previously-installed Opera extension, and vice versa.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Possibly fixed some misbehavior when multiple Firefox or Chrome profiles are used in macOS 10.12 Sierra. (NSString pathExtension methods)

## Version 2.2.10 (2016-08-20)

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug, whwich may have been present for a long time, which caused the *Ask what to do if nothing opens on launch* preference to work as expected.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  For Firefox, now includes versions 330 of our Sheep Systems Menu Extension and Sheep Systems Sync Extenion.  These are exactly the same as the previous versions, except they have been approved and signed by Mozilla to work in Firefox versions 49, 50 and 51.  Users with older extensions installed will be prompted to *Update* upon launching this app version.  

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When user performs a secondary click on the empty background (that is, not on a tag) in the Tags View, the correct result, a System Alert sound, now occurs, instead of raising an exception (which displays the *Internal Error* dialog in macOS 10.12 Sierra).

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now has *better* fix for Help and Inspector buttons than in version 2.2.9.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which sometimes caused one of the dialog windows during licensing to reappear after it should have been gone.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the Inspector panel, tooltips on attribute names now show correct words for all supported browsers including the ones we added in version 2.2.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Patched in a workaround for new behavior (bug?) in macOS 10.12 Sierra which caused bookmarks changes to go undetected in some non-default profiles in Chrome-ish browsers.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When user clicks *Help* > *Trouble Zipper*, now produces some extra troubleshooting information (a class dump) before running Trouble Zipper.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Added a hidden menu item: *Help* > *Dump and Crash!*.

## Version 2.2.9 (2016-08-12)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When dragging in, from Finder, folder(s) and/or subfolder(s) of .webloc files, the folders and subfolders now create corresponding soft folders and subfolders of bookmarks, preserving the hierarchy that existed in Finder.  Also, the file and folder creation dates now become the Date Added and Last Modified Date of the created bookmarks and folders.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixes for macOS 10.12 Sierra:

  * The icons on the Help and Inspector buttons now appear as expected (**?** and **i**).  (Now has a workaround for Apple Bug 27813593 in case Apple does not fix it.).

  * Fixed a bug, possibly introduced in version 2.2.5, which could cause a crash in 10.12 in some cases cases when the *welcome* dialog is responded to.

## Version 2.2.8 (2016-07-21)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug, introduced in version 2.2.5, which causes buttons to not appear in some sheets and alert windows, when operating in macOS 10.10.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the *Manage Browser Extensions* window, the *Install* buttons remain enabled even after they are clicked.  This is because all web browsers are now implementing their *install extension* user interfaces in popovers which sometimes fail to materialize (if a browser window is not open), or else disappear before the user can interact with them if the user mouses over something else while going to the popover.  (**Another reason to hate popovers.**)  With this change, the user can immediately return to our window and re-click the *Install* button to try again.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  More robustly handles unexpected condition in Google Chrome's Local State when relaunching Chrome into a required user profile.

## Version 2.2.7 (2016-06-26)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Updated support for "second tier" browsers.  No longer supports import or export with browsers Camino, Shiira, or Opera version 12 or earlier.  Instead, now supports import or export with browsers Vivaldi, Epic, and current versions of Opera.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the Reports > Verify table, added a button to find and display bookmarks whose status is *Unknown*.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> In the Advanced Client Options for the Chrome-ish browser, relabelled the *Don't export loose bookmarks to 'Folders'* to *…'Other Bookmarks'*, and explained this better in the Help Book sec. 4.9.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> The *Manage Browser Extensions* window no longer shows extension status for browsers Chromium or Google Chrome Canary.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> Upon launching, if the extension checking finds an old version of *Sheep Systems Menu Extension* or *BookMacster Button* extension installed in Firefox or Chrome, user is now instructed to remove it.  (These extensions were never useful in Synkmark and old versions can interfere with the necessary *Sync* extensions).

* Fixed a bug which caused the *More Tests* sheet to inexplicably reappear, sometimes causing a crash, if, after dismissing this sheet, user invoked other sheets, for example, by clicking an *Install* button.

* Fixed a bug which caused exceptions to be logged to system console if *More Tests* sheet was dismissed without clicking *Start Test*.

* The two sheets which appear during *Install* operations now have *Cancel* buttons.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" />  In the *Manage Browser Extensions* window, if user clicks the *Update* button on an extension which should have updated automatically, now correctly explains the process.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  If the amount of explanatory text makes an alert window or sheet exceed the screen height, the explanatory text now scrolls instead of being clipped.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the *Manage Browser Extensions* window, fixed a bug which caused the *More Tests* sheet to inexplicably reappear, sometimes causing a crash, if, after dismissing this sheet, user invoked other sheets, for example, by clicking an *Install* button.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When exporting to Chrome, Chrome Canary or Chromium while the browser is not running, if the user is signed in to Google to sync bookmarks, but the browser does not launch because the *Launch Browser* preference in *Advanced Client Settings* is set to *Never*, the export is now more faithful (including sync_transaction_version values).  

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now requires version 24 of the *BookMacster Sync* extension for Google Chrome, Chrome Canary and Chromium.  These applications automatically check the Chrome Web Store for updates every few hours, so it should "just work" for regular users.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  For the record, various changes were made *under the hood* to work better with Apple's new Developer Tools (now Xcode 8, macOS 10.12 SDK).  As always, it is possible that this annual exercise may have introduced a bug or two, but no bugs have been reported by beta testers.

## Version 2.2.6 (2016-06-03)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In recent and current versions of Firefox, now properly recognizes when Firefox Sync is not syncing bookmarks because the *Bookmarks* checkbox is switched off.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The recovery suggestion which appears with Error 916540 has been further improved in the case when Firefox Sync is also in use.  

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In Reports > Find, the label that shows how many items were found is no longer clipped off for long numbers.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  During an ixport, in the Status bar, the progress text "Waiting in case *whatever*" has any changes…" now displays in macOS 10.11.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  More entries in the Logs seen in application menu > Logs:

  * Entry appears whenever a document is removed from those that are automatically opened on launch.

  * Entry appears during launch indicating which documents are automatically opened.

* Increased timeout to automatically open document on launch from 11 to 20 seconds..

## Version 2.2.5 (2016-05-27)

**This update is required to continue syncing with Firefox version 47, which Mozilla will start pushing to Firefox users automatically starting on June 7.**

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Compatible with Firefox 47+, due to changes in our application *and* a new version 329 of our Sheep Systems Sync Extension for Firefox, which users will be prompted to install upon first launching this version.  

## Version 2.2.4 (2016-05-22)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Corrected label and some operations in Advanced Client Settings sheet.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Added a hidden debugging feature (LaunchDog).

## Version 2.2.3 (2016-05-18)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In Content view, if selected item(s) are at Root, the Lineage View now says this in words instead of just showing an empty space.  

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which could cause a crash when Content is in Table Mode and items are moved using the *Move to…" contextual menu item.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Help Book better explains Launch in Background feature; removed hacky instructions for older macOS versions.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In Logs, the "Job already staged…" entry now indicates the process identifier which staged the job.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the new *Remove URL Cruft* feature, in the second sheet, in the list showing the bookmarks,

  * The row heights for each row are always correct for showing the name and URL, instead of being randomly incorrect.
  * Row heights always expand to show wrapped text instead of horizontal scrollers appearing under some conditions.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer raises exception if Sheep-Sys-Worker encounters an error such as Safe Limit violation, user clicks "View Now", then "Cancel" in the error SSYAlert dialog.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the new *Remove URL Cruft* feature, in the first or second sheet, in the lists,

  * Clicking a column header now does nothing, as expected, instead of causing a crash.
  * The sheets now have *default* (blue, hit return to click) buttons.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Added Failure Reason and Recovery Suggestion to Error 651507.  

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Improved formatting of Failure Reason and Recovery Suggestion in error presentations.  

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Updated the [Sparkle framework](https://sparkle-project.org), which implements the *Check for Update* feature, to version 1.14.1.  This is an internal "clean up" and should not affect operation.  (We have been using the security-patched version 1.13.1 since 2016-02-29.)

## Version 2.2.2 (2016-05-13)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer checks for presence of Bookwatchdog (part of our legacy app) during launch.  This may have been conflicting with new security restrictions in macOS for a few users, and causing failure to launch.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" />  No longer enters *Could not find image named…* message in system console during launch.

## Version 2.2.1 (2016-05-12)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Added feature to *Remove URL Cruft*, which is in the *Bookmarks* menu.  This feature can automatically find and remove undesired *key=value* pairs in bookmark URLs, such as those used by Google Analytics to track referrals.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The tab *Reports* > *Find* is now *Find/Replace*.  It now supports text replacement in bookmark and folder names, tags, comments and shortcuts, finding and find/replace can be done with *regular expressions*, also known as *regex* or *grep*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer provokes Apple's security daemon (secd) in recent versions of macOS 10.11 to print a batch of "-34018" warnings to the system console upon launch, and at other times.

* <<img src="images/BookMacster.png" alt="" class="whappMini" />  Title of main menu item *Bookmarkshelf* has been changed to *Bookmarks*.  All four apps look the same in this way now.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  If bookmarks are changed such that the *only* changes are to one or more URLs, such as may occur in particular after a *Verify*, *Upgrade Insecure Bookmarks* or *Remove URL Cruft* operation, Safari will now read in the changes immediately, and if changes are made to bookmarks within Safari before quitting, the URL changes exported from BookMacster will no longer be overwritten.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In Inspector window, the *Name*, *Shortcut* and *Comments* fields accept drops (of text) normally now.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Sort direction indicators more reliably change immediately now after clicking them.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused the gear-icon button in the lower right corner of the Verify report to verify all bookmarks instead of what it indicates, which is to only verify bookmarks which have never been verified.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the License Info window, the text cursors now behave normally.

## Version 2.2 (2016-04-22)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Feature *Update Insecure Bookmarks* has been added.  It tests all bookmarks which use the http:// scheme and changes those which respond to use https:// instead.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Comes with new versions 328 of our Firefox extensions, *Sheep Systems Sync Extension* and *Sheep Systems Menu Extension*.  These will be good through Firefox version 48. 

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The popup menus in the *Quick Search* field (in the Content view of a document) and the *Mini Search* field (in the menu extra) now have two *Search Options*: *Case Sensitive* and *Whole Words*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The Tags Popover now prefers to pop to the right instead of down, so that Content Outline and Tags View are less likely to be obscured.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Added an option (checkbox) in the Verify operation to verify *all bookmarks which failed the previous Verify operation*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Tags View now changes selection when mouse is clicked down instead of up, so that drags work more as expected.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The *File* > *Import from only* and *File* > *Export to only* followed by *Choose File (Advanced)* present appropriate dialogs and work correctly now in some rarely-used cases where previously they did not.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The tooltips on the *Outline*/*Table* mode switch in the Content view now indicate their proper respective meanings.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now exports correctly to OmniWeb even if hard folders are missing, which happens if there are no bookmarks in them or when exporting to a new folder using *Choose File (Advanced)*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Support for the now-defunct *Glims* Safari enhancer has been removed.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Increased the amount of time allowed for Firefox or Chrome to acknowledge themselves from 3 to 10 seconds.  This was done in response to a report of a timeout Error 145725 occurring with Firefox during a reboot.  

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the *Find* table results, when using the *View* sort added in version 2.1, it now maintains its order after the content is changed, by deleting a bookmark for example.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug introduced a couple months ago which caused the *warning* or *critical* badges on the application icon in alerts to be very tiny.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the Content View, the background color brightness behind folder names now varies such that there is always *some* color at all indentation levels, instead of saturating to white for level 5 and higher.

* <img src="images/Synkmark.png" alt="" class="whappMini" />  The *Manage Browser Extensions* window is no longer cluttered with controls for the Chrome *Toolbar Button* extensions and Firefox *Menu Items* extensions which are not useful in Synkmark.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the *Manage Browser Extensions* window, the introductory text, and tooltips on the *Install* buttons for Firefox, now give correct, updated information.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The *Save, Export Disabled" hyperlink in the document window title bar now disappears immediately after the app is licnsed in any way, including opening another document with License Info embedded.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the Help Book, updated screenshots which still looked like version 1, and some related text, to the current look of version 2.

## Version 2.1.2 (2016-02-29)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The terminology *Browser Add-On* has been changed to *Browser Extension* (because all of our browser add-ons have in fact been browser extensions for the last couple years).

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Redesigned the *Manage Browser Extensions* (formerly *Manage Browser Add-Ons* window) to be sensible based on our current Browser Extensions line-up.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When syncing is switched on, if the Agent or Preference is set to keep bookmarks sorted, a *Sort All* operation is proposed and performed before the required *Export* operation.  This is to prevent unexpected results in a couple of edge cases.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Patched two security vulnerabilities in the *Check for Update* feature.  (Updated the [Sparkle framework](https://sparkle-project.org) to version 1.13.1.) 

## Version 2.1.1 (2016-02-15)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug introduced in version 2.1 wherein if a column in the Find Table or Content View in Table Mode,which was set to a very narrow width, was switched to a heading in which was too small to fit any characters, window would become unresponsive.

## Version 2.1 (2016-02-10)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In Content View, when in Table Mode (vs. Outline Mode), and in the Reports > Find table, the column headers now have controls for immediate sorting in addition to selecting the attribute being displayed in that column.  Also, sorting is now done simply, by the selected attribute, ignoring the special sorting preferences which are applied when sorting the entire document, and folders are now mixed in with bookmarks instead of falling to the bottom.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Comes with new versions 327 of our Firefox extensions, *Sheep Systems Sync Extension* and *Sheep Systems Menu Extension*.  These will be good through Firefox version 46. 

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  * <img src="images/BookMacster.png" alt="" class="whappMini" />  Changed some code which, according to a crash report we received, was the culprit during an export operation, although we couldn't find anything wrong with it.'

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In Reports > Find, the selection now behaves conventionally, moving to select the single next item, if all selected items are deleted.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a condition which could cause spurious Error 453035 when exporting to Firefox.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> In Markster and Synkmark, better recovery suggestion for Error 916540.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  * <img src="images/BookMacster.png" alt="" class="whappMini" />  In the *Logs* window, date/time column has been made a little wider, apparently to accomodate slightly wider characters in macOS 10.11.

## Version 2.0.8 (2015-12-26)

* <img src="images/BookMacster.png" alt="" class="whappMini" /> Operation of the File > Export to only… > Choose File (Advanced) > New file feature has been restored.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> The Sparkle *Check for Update* framework has been updated to the lastest version, 1.13.0.  This is not expected to cause any change in behavior. 

## Version 2.0.7 (2015-12-23)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Comes with our new Firefox extensions, *Sheep Systems Sync Extension* and *Sheep Systems Menu Extension*, versions 325, which replace version 324 of our old *Sheep Systems Firefox Extension*.  This restores operation of the optional *Add Quickly* and *Add & Inspect* menu items in Firefox, which were broken by new security requirements in Firefox 43. 

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> During a *Find Duplicates* operation, the progress bar now works in macOS 10.11 El Capitan. 

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> The *Syncing* button in the document toolbar now has images drawn with vector line art to match the other new button images in the toolbar. 

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> The *License Info* now shows correct text at the bottom instead of nonsense if a demo/trial license is being used.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug, probably introduced in version 2.0.7 or 2.0.8, which caused the recovery option buttons presented in error presentation sheets to sometimes have no effect. 

## Version 2.0.6 (2015-11-28)

* <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug, apparent when running in macOS 10.11 El Capitan which caused, after sending the app into *Background*, the *Lineage* and *Tags* fields in the Inspector to become disconnected from the selected bookmark(s) and indicate the wrong data, usually empty or the *No Selection* placeholder.

* <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug, apparently in macOS 10.11 El Capitan, which could, after a certain sequence of clicks with the app running in Background mode, cause the on/off status of the *Inspector* ("i") button in the document toolbar to go out of sync with whether or not the Inspector window was showing, and sometimes the Inspector to not respond to hitting its red "close" button.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Now supports drag and drop of .webloc files produced by El Capitan's Safari 9, while maintaining support for Safari 5-8.  (Safari 9 apparently writes .webloc file data in plist format instead of XML.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> No longer momentarily activates Finder sometimes when switching from Background mode, or in rare cases when launching the app in macOS 10.11 El Capitan.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Finished replacing the user experience of installing our Chrome and Firefox extensions, which worked in version 2.0.3 for existing users, but did not prompt new users to install the extensions, as is required for syncing to work.

## Version 2.0.5 (2015-11-25)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug, apparently introduced in 2.0.4, which caused some alert sheets (those mini-windows that roll down from a window title bar and give choices like "Cancel" and "OK") to have no buttons when running in macOS 10.10 Yosemite.

## Version 2.0.4 (2015-11-24)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Compatible with a new version 22 of our **BookMacster Sync** extension, which is distributed via the Chrome Web Store instead of being packaged with the application.  Likewise for a new version 14 of our **BookMacster Button** extension.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> The user experience of installing our Chrome and Firefox extensions has been replaced.  The old method was wonderfully seamless when it worked, but it it was way too over-thought, complicated, dependent on the browser, and thus did not always work, and was confusing to recover from when it didn't work.  The new user experience requires the user to read and click more few things, but is much simpler under the hood, and much more straightforward to recover from if the browser does not cooperate.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Did more updating to latest Apple Application Programming Interfaces (API).

## Version 2.0.3 (2015-11-05)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> Firefox Extension in version 2.0.2 had some pieces missing.

## Version 2.0.2 (2015-10-31)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> The declared *Deployment Target* has been changed from macOS 10.8 to macOS 10.10, so that the app will not even launch in 10.8 or 10.9.  (2.0 and 2.0.1 would launch but have trouble later.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> If opening a license installer file of the type provided by our Support crew in response to Lost License requests fails because the license installer is for version 1 and the app is version 2, the error sheet now informs the user why it failed.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Support for Google Bookmarks as a Client, import of Google Bookmarks and export of Google Bookmarks has been completely removed.  For BookMacster users, upon running this version for the first time, all Google Bookmarks Clients will be removed from all documents.  (Among other reasons, this is because the facility which we had been using to provide this support has apparently been removed from macOS 10.11 El Capitan.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> If app is running with *Save* and *Export* disabled because it has no license, or if app is running on a demo license, a few blue words in the upper right corner of any document window now indicate this.

## Version 2.0.1 (2015-10-23)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Restored operation of the *Verify* function which was broken in version 2.0.  (The long-term viability of this feature is now in doubt to to new security features in macOS 10.11.)

## Version 2.0 (2015-10-19)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> **All apps now require macOS 10.10 or later.**  Users with macOS 10.5, 10.6, 10.7, 10.8 or 10.9 should *not* install this update.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Firefox Add-On (Extension) and installer are now compatible with Firefox 42+.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> The *Other Macintosh Account* Client type, increasingly buggy with each macOS update by Apple, and little used, is no longer supported.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />* <img src="images/BookMacster.png" alt="" class="whappMini" /> It is a known issue in this beta version that we need to update the screenshots in the Help Book.  The Help Book should otherwise be correct.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Smarky, Synkmark and BookMacster no longer show a non-dismissable sheet if bookmarks are changed by a browser while user is editing a document that syncs them.  Instead, apps show a dismissable sheet  which explains how to import the possible changes manually if desired.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> Changing the order of browsers in Synkmark can no longer cause the name of the *Bookmarks Bar* to be changed *Favorites* or vice versa.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> Restored operation of the *Default Parent* popup in Client > Advanced Settings > Export, which was probably broken in version 1.22.42 when support was added for Chrome's short-lived *Enhanced Bookmarks Manager*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Rewrote sections which rely on older facilities of macOS which Apple has deprecated, and therefore might have caused crashes in future versions on macOS.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />"Check for Update" and downloading of licenses now uses secure https:// transmission, and apps have adopted Apple's new *App Transport Security" protection.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Replaced old style fancy color images with the resolution-independent black-on-white line drawings which are more in line with the latest fad and fashion trends promoted by Apple.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> The dual-use switchable Detail View has been removed from the top of the Content View and replaced with a new *Tags* button that shows the tags in a popover, and a fixed, permanent *Lineage* view.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Moveable ToolTip background is now gray (like Yosmite) instead of old style yellow.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Improved wording of tooltip used to explain how modifier keys work when dragging in Content Outline.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed bug which could cause a crash if user commanded a second Safe Limit Guide arrow onto a window before the first one was dismissed.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> When user clicks File > Import from only >, the import and merge is now guaranteed to occur even if indications are that there are no changes to import.  This fixes rare cases wherein, due to prior errors, the indication could be wrong, and a needed import would not occur.  This new behavior now matches the existing behavior of File > Import from all.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Application package sizes are now a bit smaller.  (Requiring macOS 10.10 allowed us to eliminate 32-bit binaries.)

## Version 1.22.43 (2015-07-30)

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Added two checkboxes in the Advanced Client Settings for the Chrome-ish browser Clients, to allow the 2015 *Enhanced Bookmarks Manager* to sync more nicely with the more conventional bookmarks managers in Safari and Firefox.  (As it turns out, Google changed their mind in early June and relegated the *Enhanced Bookmarks Manager* to an Extension.  but we spent a lot of time on this and, oh well, we'll be more ready if it or something similar ever comes back.)

*  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug introduced in version 1.22.42 which caused the *Floating Menu* to fail to indicate that the Firefox extension was not working, when attempting to land a new bookmark from Firefox.

## Version 1.22.42 (2015-04-26)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Several changes were made to the exporting of bookmarks to Chrome, Chromium and Canary when these browsers are not running.  The first one fixes a known bug.  Three of them are to avoid possible future problems by more closely emulating the behavior of the browser.

  * <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which, under some conditions, caused Chrome, Canary or Chromium to *churn* all bookmarks, which then caused the next import to report that all bookmarks had been changed, which usually triggered, falsely, a Safe Sync Limit error.  (The *churn* in this case was changing the hidden unique identifying numbers.  One of the known conditions triggering this bug was that the browser was not running in the target user profile during the export, and that the number of bookmarks was fairly small, so that the highest identifying number among the "Mobile Bookmarks", which our apps ignore, was greater than the highest identifying number among the exported bookmarks".)

  * Adds sync_transaction_version key with value 2 if it is not present.

  * No longer escapes forward slashes when writing the file.

  * In all bookmarks and folders, adds an "add date" value if one is not present.

## Version 1.22.41 (2015-03-24)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug introduced in version 1.22.36 which caused bookmarks in the *Bookmarks Menu* to not be exported to Safari, if the user's Safari bookmarks had been created by a newer version of Safari which did not have a Bookmarks Menu.

## Version 1.22.40 (2015-03-18)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug introduced in version 1.22.36 which caused an extraneous Error 19675 to occur after executing a *Reset and Start Over* command, and possibly in other situations.

## Version 1.22.39 (2015-03-17)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Increased the timeout for the *Manage Browser Add-Ons* test from 10 seconds to 60 seconds, to accomodate that recent versions of Firefox in recent versions of macOS can sometimes take several tens of seconds to wake up and respond.

* <img src="images/Synkmark.png" alt="" class="whappMini" />  Operations of the *Ignore Duplicates in separate Hard Folders* checkbox and *Visit items with* popup in Synkmark's Preferences > General, which were broken in the 1.22.37 beta, have been restored.

## Version 1.22.38 (2015-03-14)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" />  Refined the feature added as beta in 1.22.36 to handle lack of *Bookmarks Menu* in Safari.  The feature is now only available in Smarky, no longer in Synkmark, because it made merging with Firefox and Chrome problematic.  A bug which could cause a crash has been fixed.

## Version 1.22.37 (2015-03-12)

This is a special test version to test failure of the FileAliasWorker which sometimes results in Error 519881.

## Version 1.22.36 (2015-03-11)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer creates a *Bookmarks Menu* hard folder if the Safari bookmarks being synced does not have aF*Bookmarks Menu*, and Firefox is not being synced.  Smarky and Synkmark now have a new setting: Preferences > General > Enable "Bookmarks Menu" / "Other Bookmarks" Folder.

* <img src="images/Smarky.png" alt="" class="whappMini" />  Smarky now is able to import and export with Safari even if the Safari bookmarks file is missing.  (Other three apps have had this recovery capability for a long time.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Help Book better explains commands *Consolidate Folders* and *Aggressively Normalize URLs*.

## Version 1.22.35 (2015-03-02)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bugs affecting large exports to Firefox while Firefox while Firefox was running, which could result in extraneous errors and, in one case, a crash.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug, recently introduced with version 323 of our Firefox extension, which causes import/exports while Firefox is running to fail in Firefox profiles which the user has renamed since the profile was originally created.  (The fix is in the main application; this version does not update our Firefox extension.)

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Google accounts from the macOS keychain are no longer listed in the New Document wizard, the File > Import/Export to only submenus, or the popups in the Settings > Clients tab.  (Google made the keychain items useless a couple years ago, so that we now identify Google accounts by user-supplied nickname anyhow, and removing these fixes the issue of users with too many Google accounts overflowing the screen during the New Document wizard.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could cause a crash after adding a new Client and exporting for the first time.

## Version 1.22.34 (2015-02-20)

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug introduced in version 1.22.20 which caused a forever hang if user clicked File > Import or Export to all, then chose the *New/Other* choice for Delicious, Diigo or Pinboard.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed behavior in situations where the helpful blue guide arrows pointing out the Safe Limit controls could be obscured by the Preferences window or Inspector panel.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused the value of the hidden last_modified (date) attribute of items exported to Chrome, Canary or Chromium to be either not exported, or exported with the value of the add_date attribute instead.  This might have been causing unnecessary *churn* of Chrome, Canary or Chromium bookmarks in some cases.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When exporting to Firefox, in case the Firefox bookmarks file is absent, the skeleton created has been updated to mimic a minor change in the current skeleton created by Firefox, in case this ever matters.

## Version 1.22.33 (2015-02-11)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Updates our Firefox Extension to version 323, which makes two improvements:

  * Fixed possible misbehavior if Firefox and Firefox Developer Edition are both installed and both being synced.  (This recently became an issue with the release of the new Firefox Developer Edition, which for the first time allows two instances of Firefox to be running simultaneously if they are in different profiles.  Even if the user was not running both Firefoxes, Synkmark or BookMacster might launch them to coordinate syncing if Firefox Sync is in use.  With our old Firefox extension and app versions, mixups could occur, resulting in various errors.)

  * While Firefox is running, no longer fails to import or export a bookmark which has a NULL url in Firefox.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Reduced occurrences of Error 3045 during user login.  (Increased timeout to take account of the fact that browsers may take a long time to launch during login.) 

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Worked around a bug in macOS 10.10 (or maybe Safari 8.x) which caused some web pages to fail to open if user made a multiple selection of more than a few bookmarks and commanded a visit.  (A delay of 0.4 seconds was added between page visits.)

## Version 1.22.32 (2015-01-24)

This is an experimental version, sent to a single user, to help troubleshoot a perticular problem.  (Has squawky __NSDictionaryM.)

## Version 1.22.31 (2015-01-24)

* <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug in our Firefox Extension which could cause Firefox version 34 or 35 to crash after adding several bookmarks via the Menu Extra, Dock Menu or Keyboard Shortcut.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Error 19001 (some other process invoked our Worker incorrectly) is no longer displayed to the user and no longer causes syncing to be paused.  It is only logged silently.  Also, added some measures to reduce the occurrence of Error 19001, and prevent macOS from restarting an incorrectly-started Worker as though it were an application, if it happens to be interrupted by user logging out or shutting down.

## Version 1.22.30 (2015-01-23)

This is an experimental version, sent to a single user, to help troubleshoot a perticular problem.

## Version 1.22.29 (2015-01-18)

This is an experimental version, sent to a single user, to help troubleshoot a perticular problem.

## Version 1.22.28 (2015-01-16)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which could cause an unexpected app activation, hang or crash if a new bookmark was landed while the Inspector window was open, and possibly other misbehavior of the Inspector window.

## Version 1.22.27 (2015-01-13)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bugs in the Content View, when redisplaying in Outline Mode, which caused expanded folders to sometimes collapse without reason, or to not open as required to re-expose items which had been previously selected in Table Mode.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bugs which caused the Tags field in the Detail View, the Tags shown in the Content Outline, and the Tags field in the Inspector to not always show the new value immediately when tags were changed.

## Version 1.22.26 (2015-01-06)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Restored operation of the *Collapse Roots* menu item, which was apparently broken in version 1.22.23.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed failure to properly archive some errors in macOS 10.10 Yosemite, which resulted in these errors being presented as to the user as Error 68458 "Sorry, could not unarchive error".

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  During an Import or Export with Safari, if the Safari bookmarks file is missing the Favorites Bar or Bookmarks Menu, now creates an empty one and moves on, as Safari does, instead of failing with Error 267563 or 267564.  (It is possible that iCloud might create such a file in some situations, and we might see it before Safari fixes it if Safari is not running.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which sometimes caused a crash if document window was closed while bouncing blue arrows were guiding user to Safe Sync Limit controls.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  No longer logs to system console when commanding the app into the background while a document window was open.  One of the entries was one line and occurred once for each document.  The other detailed an exception, and occurred only in BookMacster, when multiple document windows, and the Preferences window, were open.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  A failure reason and recovery suggestion have been added to Error 19001, to help us identify what process on a some Macs might be messing with our Worker.

## Version 1.22.25 (2014-12-12)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could cause items in the Content View of a newly-created document to not display properly after viewing the tab *Settings* > *Clients* in BookMacster, or *Preferences* > *Syncing* in Synkmark.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused the rather hidden *Skip Separators* (when exporting) setting to be set to ON instead of OFF when creating a new Firefox client in the tab *Settings* > *Clients* in BookMacster, or adding Firefox as a synced browser in *Preferences* > *Syncing* in Synkmark. 

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When dragging, copying or pasting bookmark names and URLs to other applications, duplicates no longer appear, even if bookmarks and their parent folders are selected.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" />  Fixed a bug which caused some of the popup menus in Preferences > Syncing to indicate a different setting than the actual default setting which was active, until the first time that a new user changed them.

* <img src="images/Synkmark.png" alt="" class="whappMini" />  Changed style of buttons in *Choose Browsers* sheet of new document wizard, and *Preferences* > *Syncing* tab, so that they are more legible in macOS 10.10 whether System Preferences > Accessibility > Increase contrast setting is ON or OFF.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Changed style of buttons in *Choose Clients* sheet of new document wizard, and *Settings* > *Clients* tab of document, so that they are more legible in macOS 10.10 whether System Preferences > Accessibility > Increase contrast setting is ON or OFF.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" />  In Inspector, first item in popup menus *Sort this folder?* and *Visit item with* now correctly indicate *Use settings from Preferences* instead of *Use Document Default Settings* (which is correct for BookMacster).

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The advice which appears when exporting a large number of changes to Firefox while Firefox is running no longer incorrectly states that the operation must be cancelled and restarted in order to make it run faster.

* <img src="images/Synkmark.png" alt="" class="whappMini" />  Corrected errors in Help Book sec. 1.2, *Getting Started with Synkmark*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The Help Book now has a section explaining how to recover from *Safe Sync Limit* errors 3011 and 3012, linked to from the error dialogs, and cross-linked to the topic of *Safe Sync Limit* .

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When an import from or export to Safari is being delayed to wait for updates by iCloud, the explanation shown in the status bar now gives a more reliable indication of when the process is *almost done*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed memory leak in Content View.


## Version 1.22.25 (2014-12-07)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could cause items in the Content View of a newly-created document to not display properly after viewing the tab *Settings* > *Clients* in BookMacster, or *Preferences* > *Syncing* in Synkmark.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When dragging, copying or pasting bookmark names and URLs to other applications, duplicates no longer appear, even if bookmarks and their parent folders are selected.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  The advice which appears when exporting a large number of changes to Firefox while Firefox is running has been corrected no longer incorrectly states that the operation must be cancelled and restarted in order to make it run faster.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When an import from or export to Safari is being delayed to wait for updates by iCloud, the explanation shown in the status bar now gives a more reliable indication of when the process is *almost done*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed memory leak in Content View.


## Version 1.22.24 (2014-12-05)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  If, while editing tags in the Detail View, user clicks ⌘S, or auto save occurs, the tag edits are now saved and not lost.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could cause a crash after creating a new document and importing bookmarks.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When importing, separtors are now *Deleted* as expected by Help Book sec. 4.3.15 > Importing Separators > table > last column.  Also, ambiguities in this section of the Help Book were corrected.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Holding down the option+shift keys when starting an import or export now produces a log file for only the current import or export and not subsequent imports or exports.


## Version 1.22.23 (2014-11-25)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the Content View, in Outline Mode, eliminated beachballing when expanding (or loading as expanded) folders that contain many thousands of immediate child items.  (New *lazy* data source.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  During an Import or Export operation, the *Finding Parents (4/7)* phase is now faster, much faster for documents that contain one or more folders that have thousands of immediate child items.  (Exportability is now cached, so *Big-O* N<sup>2</sup> reduced to N.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Increased too-close line spacing in tables in some modal dialogs, when running in macOS 10.10 Yosemite.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused the Preferences window to fail to open after a Keyboard Shortcut to show the Floating Menu had been set.  

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused changes in the Inspector Panel to not be saved if the panel was closed before activating a different field.  

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Identifiers were added to support [Firefox Developer Edition](https://www.mozilla.org/en-US/firefox/developer/), which has now replaced *Aurora* as Firefox' "alpha" channel.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> When running one of the three focused apps, the popover which macOS 10.9 or 10.10 provides next to the document window title has been removed, so that it is no longer possible for the user change the document's name or location and lose it.  (The focused apps have a "shoebox" architecture which does not support multiple documents.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When manually commanding an Import or Export operation, if any field in the Content View or Inspector Panel is currently being editing, its edits are now automatically accepted and registered before beginning the Import or Export operation.  (Previously, this did not work for all fields.)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which occurred after importing from Firefox, Diigo or an XBEL file, which caused, for bookmarks which were changed as a result of the import their Last Modified date to indicate the time of the import, instead of the Last Modified time which had been imported from Firefox, Diigo or the XBEL file, until the next time that the document was saved or autosaved; typically the first few minutes after the import.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused any change in a document, which macOS had not yet autosaved (which it does every 5 minutes, or when you switch apps) to be lost if the user first clicked the *Background* menu command to send the app into the background.  

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the Content Outline, after editing, moving or deleting items, the scroll position no longer sometimes jumps a fraction of a row, to the next row boundary.  It does not move at all.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bugs which caused the Inspector Panel to not open or close in all cases when it should have.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed bug which sometimes caused Firefox or Chrome to be not quit after it was launched to perform an import or export operation, if the user has more than one instance of Firefox or Chrome installed. (Now remembers and quits the same instance that was launched.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> The application menu item "Stop Syncing…" menu item title has been clarified to better indicate what is going on.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Replaced depracated function (ShowHideProcess).

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused the Folder Lineage field in the Inspector Panel to continue to show the old Folder Lineage after an item had been moved by the user clicking the *Move* hyperlink, or after all items had been deselected.  In the former case, it now shows the new Folder Lineage, and in the latter case, it now says *No Selection*, as expected.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  During export to Chrome or Firefox while Chrome or Firefox are running, the Status Bar at the bottom of the window now shows progress throughout the process and no longer disappears for several seconds during some phases.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Newline characters in bookmark names are now replaced with space characters.  (This reduces sync churning with Google Chrome which also does this, and it's a good idea for name visibility, since bookmark name fields are generally only one line high.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug that could cause Error 651507 when importing from Chrome, Canary or Chromium while the browser is running in the importing profile.  (Susceptibility to this bug depended on the exact length of the bookmarks data, and had a 1 in 1024 chance of occurring for a given bookmarks set.)

* <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When landing a new bookmark, if the site has not provided a title, the Floating Menu now indicates it as *this web page* in the menu and *untitled* if the user chooses to actually create a bookmark from it, instead of blank spaces.

* <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When landing a new bookmark, if the browser does not respond within 2.5 seconds of being asked for data, the Floating Menu now shows an appropriate error message in place of the *Add to…* menu item, instead of showing the name of the previously-landed bookmark.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which caused an item displayed in the Inspector Panel to continue to be displayed after it was deleted.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  May have fixed a condition that, in rare cases, caused relocations of bookmarks due to sorting to still have their old locations in a document's' Content View.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Decoding of license installer files (sent out by our Support team to users who have lost their License Information) is now even more robust with respect to different or extraneous newline characters our web host may inadvertantly insert.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  When changing the *Visit this bookmark with* attribute of more than 2 bookmarks in bulk, such that a warning appears, the warning now explains the new setting better.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Eliminated an unnecessary system log entry from our Chromessenger tool during exports.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Warning sheet which informs the user about possible conflicts with Sign in to Google is not so wide any more.

* <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Help Book better explains Global Keyboard Shortcuts.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  A few events now have improved or added messages in menu > Application > Logs.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Now built with Apple's Yosemite-generation developer tools.  (macOS 10.10 SDK, Xcode 6.1.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Removed the Breadcrumb framework which supported sales through the Bodega App Store which, sadly, shut down in early September.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  All components (executables) in the package, including auxiliary components, now have version numbers in their (embedded) metadata.  (Switched on Info.plist Preprocessing at the Project level.)

## Version 1.22.22 (2014-09-25)

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug which could cause a crash if a Bookmarkshelf is duplicated with *File* > *Duplicate* and not given a name by the user before quitting, or maybe if there are Recent Documents which are no longer available.

## Version 1.22.21 (2014-09-24)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug, which possibly became active in macOS 10.10 Yosemite, which could cause the *Beta Versions* and *Alpha Versions* checkboxes in Preferences > Updating to indicate the **on** state when in fact they were **off**.

## Version 1.22.20 (2014-09-24)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> No longer beachballs after opening window to a large document of more than a few thousand bookmarks that are synced to browsers or clients.  (Cleaning up defunct client/browser associations is now done on a background thread.)

* <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> The term *Status Menulet* has been changed to *Menu Extra*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In the main menu, application menu, the title of the item *Stop Workers, Agents* has been changed to *Stop all Syncing now*.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a bug, introduced in version 1.22.16, which could cause the *Advanced Client Options* button for a Google Bookmarks client to not do anything.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug, apparently present since verison 1.21.5, which caused the *Consolidate Folders* operation to not always find all valid candidates for consolidation.  (An exception would be raised and silently abort the search at some point before it was finished.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed several bugs, found by a new quality analysis tool from Apple, which could theoretically have caused rare crashes or other misbehaviors during or after Import, Export, or installing Web Browser Add-Ons operations.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" />  The *Reset and Start Over…* menu item, previously available in BookMacster only, has been added to the three focused apps.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> In the *Choose Browsers to be synced* sheet displayed during initial setup, or after *Reset and Start Over…*, the list available for automatic syncing no longer includes second-tier browsers (browsers other than Safari, Firefox and Chrome).  (Automatic syncing never worked with other browsers.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed bug which, after user had cancelled an error, sometimes caused the Status bar to mislead by indicating *Same-Skip* instead of *Cancelled*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> Instructions given to resume syncing now make more sense when no browsers have been set, or Settings have been corrupted.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Performance may be slightly improved in some additional cases.  (Removal of defunct client/browser associations is now more reliable, so there should be less cruft to process in some cases.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> Now automatically recovers if Settings file in Application Support has bad settings or is missing.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Cosmetic fix to arrows in the *Choose Browsers/Clients to be synced* sheet displayed during intial setup, creating a new document, or after *Reset and Start Over…*, in macOS 10.10 Yosemite.

## Version 1.22.19 (2014-09-11)

* <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which caused BookMacster windows to hide immediately after landing a new bookmark from our toolbar button in Google Chrome, if the Inspector window was set to be shown upon such landing.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which sometimes caused not all tags to be exported to Firefox.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> When using File > Export to only > Choose File, if user chooses a folder which may have a POSIX permissions issue, the feature to try and  authenticate the user has been removed.  If permissions are insufficient, it fails and displays an error.  (BookMacster had been attempting this unnecessarily in some cases; it had a bug which caused a crash in macOS Yosemite; and finally it was not working in recent versions of macOS due to changes in the security model by Apple.  The Privileged Helper Tool which supported this feature has been removed from the BookMacster package.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> In the Inspector window, if user abruptly leaves the *Comments* field by clicking a window in another application, the entered comments are now saved in the document and no longer vanish.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which caused, if an export to a browser/client which requested that some items be deleted failed, and if the next import from that browser/client was executed manually, either by user clicking in the File menu or by AppleScript, the items which had been requested to be deleted would not be imported.  This behavior is desired, and is by design if the import was initiated automatically as part of a sync operations, but was unexpected if the import is executed manually.

## Version 1.22.18 (2014-08-30)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> and maybe <img src="images/Smarky.png" alt="" class="whappMini" />  Fixed bugs which caused the license installer files which are sent out by our Lost License Emailer to not work.

## Version 1.22.17 (2014-08-21)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed bug introduced in version 1.22.10 (Yosemite update) which caused several of the buttons in a document's *Reports* > *Duplicates* and *Reports* > *Sync Logs* tabs to not function.

## Version 1.22.16 (2014-08-19)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> In the Help Book, fixed some misleading set-up instructions for new users.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> Menu item *File* > *Revert to* > *Last Opened* now works in Smarky, Synkmark and Markster; no longer causes the app to quit.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> In a document's Settings > Clients > Chrome/Canary/Chromium > Advanced Settings, the feature to *Don't use Other Bookmarks* has been removed.  (It did not always work as expected anyhow.)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> Cosmetic fixes to Preferences > Syncing tab when running in macOS 10.10 Yosemite.  (Text fonts in Browsers popup menu, and arrow lines in the diagram, are now black instead of ultra-light gray.)

* <img src="images/BookMacster.png" alt="" class="whappMini" /> Cosmetic fixes to document window's Settings > Clients tab   when running in macOS 10.10 Yosemite.  (Same as previous item, different location in BookMacster.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> If user has never changed the *Search for* parameters in the Quick Search field of a document, the default parameters *Bkmrks, Folders* now appear as placeholder text instead of the word *Search*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> If user enables syncing, is prompted to export, clicks *Export*, but then export exceeds a Safe Limit, and user backs out by choosing *Test Run* or *Cancel* instead of *Export Anyhow*, syncing is now paused.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> Fixed a bug which could, on rare occasions of multiple rapid bookmarks changes when Syncing is on, cause a background Worker to fail with error 325844.  (Fixed race condition in process control semaphores.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> Menu item *Bookmarks* > *Remove Bookdog Artifacts* now works in Smarky, Synkmark and Markster too.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> Unexplained reference to *Clients* removed from tooltip on *Syncing* button in document window toolbar.

## Version 1.22.15 (2014-08-11)

This was a special build, specially and temporarily modified for another developer to troubleshoot an issue with their app.

## Version 1.22.14 (2014-08-10)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> Fixed bug introduced in version 1.22.10 which caused the *Sorting* tab of Preferences to not display.

* <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which caused the user's wish to show the Inspector when landing a new bookmark via the Button in our Chrome extensions  to be ignored.  The Inspector would never show for this type of landing.  (User expresses this wish via the combination of preferences setting and option key up or down).  This bug was introduced when we replaced the plugin for the Chrome-ish browsers in version 1.22.9.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Now recovers gracefully in a particular case of corrupt preferences.

## Version 1.22.13 (2014-08-05)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> Fixed bug which caused the setting of the Preferences > Syncing Safe Limit control in Smarky and Synkmark to sometimes be ignored and instead behave with the default value of 25.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> The term *Dry Run* has been changed to *Test Run*.  (*Dry Run* has caused some confusion; seems to be an American colloquialism.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> Fixed bug which could cause license key to be sent incorrectly to server if and when user attempts to crossgrade to a different app in the family.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Result (or not) of Find Duplicates operation is now entered into Logs.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Added more warning text accompanying the *Export Anyhow* button.

## Version 1.22.12 (2014-07-27)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed bugs introduced in previous two versions: Preferences window would not open, and clicking some buttons in the document window had no effect.

## Version 1.22.11 (2014-07-27)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> More likely to provide a coherent error with recovery information if Chrome, Chromium, Canary or Firefox bookmarks are corrupt and cannot be decoded.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Further improvement to Uninstall function: Prefs *file* is trashed, and Error 1538022 is no longer shown if app is later *reinstalled*.

## Version 1.22.10 (2014-07-26)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Document windows now open as expected in macOS 10.10 Yosemite.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Quick Search field in document or main window toolbar now has helpful placeholder text.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which sometimes caused a crash or hang after manipulating the *Search For* or *Search In* menu items inside the *Quick Search* field.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which caused the menu item *Bookmarkshelf/Bookmarks* > *Find* to have no effect if the *Reports* tab had not previously been displayed by other means since the document had opened.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> The *Uninstall* application menu command now displays correct instructions and works without displaying errors in Smarky, Synkmark and Markster.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> Removed menu item, button and Help Book references which gratuitously directed users to Dropbox to support syncing bookmarks among multiple Macs.  (Several other services which perform comparably to Dropbox are now available.)

## Version 1.22.9 (2014-07-11)

Anyone syncing with Chrome, Canary or Chromium will need this update at some point.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Now compatible with future versions of Google Chrome, Canary or Chromium.  The *Sheep Systems NPAPI Plugin* has been retired, the *BookMacster Sync* Chrome extension updated to version 21 and *BookMacster Button* Chrome extension to version 13.  Immediately upon launching this version for the first time, any previously-installed *Sheep Systems NPAPI Plugin* will be removed from the user's ~/Library/Internet Plug-ins directory, and user will be prompted to click the *Update* button to update these extension(s) if they were previously installed.  (The new components use Chrome/Chromium's new Native Messaging API to implement all of the functions which had been provided via NPAPI.)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which could cause subsequent Imports and Exports to fail with Error 325844 if user opened the *Manage Browser Add-Ons* window and executed a test on the same Client, until the *Manage Browser Add-Ons* window was closed.  (Port is now relinquished after test.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Attempting to move an item, using the *Move* hyperlink in the Inspector, or the *Move to* contextual menu item, to a location where it is not allowed (such as moving a bookmark to Root level in many situations) now displays a warning sheet explaining that the move was not allowed, and will no longer, in some cases, move the subject item to the bottom of its current folder.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> More gracefully handles error condition if one of our Chrome, Chromium and Canary messenger processes becomes nonresponsive.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> When importing from or exporting to Google Bookmarks, when user is asked to verify that they are signed in to the correct Google account and clicks *Show Me*, the page visited is now the users' *Google Bookmarks* instead of the user's Account Profile page.  Although the profile is not as readily apparent in this page, particularly for users that have multiple Google accounts and have not customized their photo, it now directs the user to sign in again, in cases where, for some reason, being signed in to Google is not sufficient to access Google Bookmarks.

* <img src="images/Smarky.png" alt="" class="whappMini" /><img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  User clicking *Stop Workers, Agents* writes more info to Logs.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  If no Bookmarkshelf document is open to receive a new bookmark being landed from another app, after the user selects a document and it opens, the new bookmark is now added to the document immediately.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> The *File* > *Save* menu item is now enabled even if the document has no changes, in conformance with changes in recent macOS versions.  (This is particularly important if user has switched on "Ask to keep changes when closing documents” in macOS' System Preferences > General.  Even though document had been autosaved on disk, user could only Revert or Cancel upon closing.)

## Version 1.22.8 (2014-06-24)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  If another app from the family is running and app displays a warning indicating this and that the app *cannot run and will quit*, the promised quitting now happens even if the *Manage Browser Add-Ons* window opens due to an old browser add-on being found.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  In Preferences > Appearance, the *Toolbar Icon* size selection radio buttons now work again.

* <img src="images/BookMacster.png" alt="" class="whappMini" />  In a document's Settings > Clients > Advanced settings for Chrome and Firefox > Special Options > *launch browser during syncs*, the setting *Never* now works properly.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Fixed a corrupt resource file which somehow got into recent beta versions 1.22.6 and 1.22.7, causing failure to install the Chrome extension (something that would only have been done by new users).  (File is ChromeLocalStoragePrimer.sql).

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />  Error 287101 now provides additional data.

## Version 1.22.7 (2014-06-18)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Recovery suggestion for Error 145725 now advises user to check and see if browser is running by using the *Force Quit* window.  (We've recently corroborated user support requests, seeing that Firefox can be launched into an unquittable state as the user is logging in: using only 1 thread, 1 port, and no user interface.)

## Version 1.22.6 (2014-06-17)

* <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Corrected incorrect tooltip attached to tne *Preferences* > *General* > *Launch in Background* checkbox.

## Version 1.22.5 (2014-06-09)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> When finding duplicates for bookmarks whose URLs are the same except for schemes *http* vs *https*, now detects these as duplicates, and during *Delete All Duplicates*, in such duplicate groups, one with scheme *https* is retained and those with scheme *http* are deleted.  This change does not affect the automatic consolidation of duplicates which occurs in exports to web apps that do not accept duplicates, like Delicious.

## Version 1.22.4 (2014-05-21)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Smarky.png" alt="" class="whappMini" /> Fixed a bug which could cause the preference to automatically sort while syncing to be ignored if an automatic sync occured while Smarky or Synkmark was not running, until Smarky or Synkmark was launched the next time.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Smarky.png" alt="" class="whappMini" /> Fixed a bug which could cause syncing to not be disabled in Smarky or Synkmark, if a sync fight with another service was detected while Smarky or Synkmark was not running.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> No longer times out with an error when exporing 10,000 or more uncommented bookmarks to Google Bookmarks, although we are still in doubt about whether or not Google Bookmarks itself can handle 10,000 or more bookmarks.  (When mass-uploading bookmarks to Google Bookmarks, now segments the upload into separate requests of 200 or less bookmarks.  Mass uploading is used to improve speed for any new or changed bookmarks which do not have *comments* attributes.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> Fixed a bug which could cause failure to sync if bookmarks in Safari were changed while Smarky was running.  (Corrected Principal Class in Info.plist.)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Apps are now packaged directly inside the zip package instead of inside a folder in the zip package.
 
* <img src="images/Smarky.png" alt="" class="whappMini" /> In Smarky, the setting *Preferences* > *Sorting* > *Sort … Automatically, during Syncs* is now on by default for new users.  (Sorting is the primary use case of Smarky.)

* <img src="images/BookMacster.png" alt="" class="whappMini" /> When syncing to Delicious, timeout errors are now rare instead of frequent, as they have been recently due to Delicious' randomly slow response times.  (When sending a request to Delicious, Pinboard or Diigo, if a response is not received within the expected time, 10-30 seconds, now aborts the unanswered request and retries, up to two more times, with a new request.)

* <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which caused churn (trivial changes which cancel one another out in subsequent syncs) when importing a bookmark from Diigo, Delicious or Pinboard if any of the bookmark attributes (name, tags, URL, comments) ended in an ampersand ('&') character.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> During a sync (import or export) operation, if duplicate bookmarks have the same unique identifier, now tries to select the best match based on other attributes.  This reduces *churn* (trivial changes which cancel one another out in subsequent syncs) in some cases.  One such case is: exporting to a web service such as Diigo or Google Bookmarks, which use the URL (or a hash of it) as the unique identifier, if, in the exporting Bookmarkshelf document, there are duplicate bookmarks that have the same URL but different names or different tags.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> When choosing a web app (Delicious, Diigo, Google Bookmarks or Pinboard) from *File* > *Import from only*, or *File* > *Export to only*, the operation now *always* downloads all latest bookmarks from the server, ignoring the local cache.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> In Settings > Clients > Advanced, for Delicious, Diigo, Google Bookmarks and Pinboard, the checkbox to *Never download from the cloud.  Assume that nothing has changed up there" has been replaced with a pair of popup menus that allow separate, expanded options such downloading, for Import and Export separately.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> When importing from or exporting to to Google Bookmarks via the *Import from only* or *Export to only* command, no longer presents a checkbox *I'm always logged in … from now on, don't ask* (because this was and is a temporary Client, checking the box had no effect.)

* <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug, introduced around version 1.21.1, which could cause a document's internal pipline of long-winded operations (sorting, importing, exporting, etc.) to get clogged, never completing any operations as long as the app was left running, if an import from or export to Delicious, Pinboard or Diigo was attempted on an account whose credential was not in the macOS Keychain.  This version instead aborts the operation and displays an explanatory error, as expected.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> If import from Delicious, Diigo or Pinboard must be delayed to avoid throttling, no longer shows a second confirmation dialog sheet after user has approved.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> When an upload to Google Bookmarks fails due to Error 59547, if there are no particular bookmarks thought to have caused the error, error information will no longer advise user to check an empty set of suspect bookmarks.

## Version 1.22.3 (2014-05-09)

* <img src="images/BookMacster.png" alt="" class="whappMini" /> In BookMacster, the facility to browse the local network for bookmarks in browsers on other Macs via the local area network has been removed.  (Our improved syncing capabilities are a better choice for the few users of this old feature, which has become difficult to keep working as Apple has emphasized increased security in macOS.)

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug in the *Manage Browser Add-Ons* window which caused the Firefox basic Add-On to be indicated as *(loaded)*, and *Warning 105-8394* to be logged to the system console, if Firefox was not running when the *Manage Browser Add-Ons* window was loaded or refreshed.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Now recognizes the pre-release versions of Opera, *Opera Next* and *Opera Developer* as running versions of Opera.

* <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which could cause a delay, and browser needing to be quit manually after installing a Browser Add-On into an alpha (*Aurora*) version of Firefox.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Improved the information provided with Error 483277, and overlaid it with Errors 904235 and 3050.

## Version 1.22.2 (2014-04-29)

* <img src="images/BookMacster.png" alt="" class="whappMini" /> Worked around a bug in macOS 10.9 which causes spurious log entries when connecting with secure servers such as Diigo or Delicious.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Better initial positions of new document window, and preferences window when opened for the first time.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> In the Dock Menu, Floating Menu and Status Menulet, in Smarky, Synkmark and Markster, the *Background* and *Quit* menu items now end in the correct app name instead of *BookMacster*.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> If an Agent cannot be created because user's ~/Library/LaunchAgents directory has improper ACLs, now, after fixing POSIX permissions as in previous version, silently and automatically attempts to empty any Access Control List (ACL) from ~/Library/LaunchAgents, then ~/Library/ and finally ~.

## Version 1.22.1 (2014-04-24)

* <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which caused crashes during some exports to Diigo.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> Revised the warning of expected throttling by Diigo to reflect Diigo's new, more lenient throttling policy.

* <img src="images/BookMacster.png" alt="" class="whappMini" /> Increased timeout on Diigo requests from 90 seconds to 125.6 seconds.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> If an Agent cannot be created because user's ~/Library/LaunchAgents directory has improper permissions, now silently and automatically attempts to fix the permissions of ~/Library/LaunchAgents, then ~/Library/ and finally ~, and if that fails or does not fix the issue, creates a more informative Error.

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Eliminated logging of warning when Preferences window opened.

## Version 1.22 (2014-04-19)

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> [Initial release of Smarky, Synkmark, and Markster](https://sheepsystems.com/products/bkmx).

* <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Finished restructuring the Help Book for our new focused apps (Smarky, Synkmark, Markster).

## BookMacster 1.21.5 (2014-04-17)

* Fixed a bug introduced in BookMacster 1.21.4 which caused bookmarks order to not be exported under some conditions.

* Restructured even more of the Help Book.

## BookMacster 1.21.4 (2014-04-10)

* Fixed (better) a bug which could cause a crash when exporting to Delicious, Diigo or Pinboard.

* Restructured more of the Help Book.

* When importing from a Client that which has items in two or more hard folders (for example *Favorites Bar* and *Bookmarks Menu*) into a Bookmarkshelf document which has neither, items imported from the first hard folder now appear above the bookmarks imported from the second hard folder, instead of being interleaved.

* Fixed a bug which caused items to be sorted when copied or moved via the *Copy to…* or *Move to…* contextual menu items.

* When moving a separator into a destination which does not allow separators, it is removed instead of being targetted into the document's Default Parent.

* Fixed a bug which caused, when moving a selection of items from one folder to another, if one of the items was not allowed in the destination folder (for example, folders may not be allowed at the root level when a document has been configured to sync with Firefox), instead of just the non-allowed items being retargetted into the Default Parent, any of the item's siblings which appeared below it would also be so retargetted.  Now, only the disallowed item(s) is retargetted, as expected.

* Eliminated a rare case of syncing churn which could be caused by an un-normalized Firefox Smart Search bookmark.  (Now normalizes Firefox' Smart Searchs as Firefox does.)

## BookMacster 1.21.3 (2014-04-05)

* Fixed bug which could cause a crash when exporting to Delicious or Pinboard.

* Eliminated dire warnings of bookmarks to be *WIPED OUT* in some special situations where in fact this would not occur.

## BookMacster 1.21.2 (2014-03-31)

* More robust behavior when attempting to sync documents that macOS may have temporarily misplaced, while BookMacster is not running or document is not currently open.  (When such a sync is initiated, if macOS fails to provide Worker with the path to the subject .bkmslf document, instead of only silently switching off syncing [deleting the document's Agents], now re-requests the path 5 more times over the next minute, and only if all of these fail, switches off syncing, and creates and logs an Error (19004 or 19005) which informs the user of the switch.

## BookMacster 1.21.1 (2014-03-26)

* In Preferences > Syncing, the maximum numbers displayed in *Minutes to wait before importing changes from web browsers* have been increased to be more truthful in all cases, by including the additional delay which can occur if the user changes bookmarks immediately after BookMacster completed a previous sync.

* When importing from Diigo in the BookMacster app, if Diigo throttles the account, as it typically does after 60 seconds or 15,000 bookmarks, BookMacster now recognizes this and recovers by waiting until the throttle expires, typically 60 minutes, and displaying the reason for the delay the Status Bar, along with a *Cancel* button.  If such a throttle occurs when a BookMacster Worker is importing, the Worker cancels the operation and displays an error, with a recovery suggestion to retry the operation in the BookMacster app.

* If a document's file gets corrupted, instead of the standard macOS behavior which is to simply fail to open, the document will now open as a new empty document, and the user is advised that a prior version may be restored from the macOS Versions Browser.

* When user enters the macOS Versions Browser (File > Revert to… > Browse All Versions) and selects a document which is too old to be immediately displayed, an alert advises the user that the document is actually available and may in fact be restored (albeit sight unseen).

* The *Advanced Client Settings* for Delicious, Diigo, Google Bookmarks and Pinboard now have a checkbox to *Never download from the cloud.  Assume that nothing has changed up there.*

* Explanation of how to deal with 'unresponsive script' warning now appears properly, before a huge export to Firefox, instead of to Diigo.

* Fixed a bug which caused parsing bookmarks imported (downloaded) from Delicious or Pinboard to fail with Error 90257 if any part (name, url, comments, etc.) of any bookmark contained a character sequence composed of an ampersand, followed by a hash, followed by a sequence of decimal digits which represented an invalid sequence of UTF-16 code units.  (Apple Bug ID 16424156)

## BookMacster 1.21 (2014-03-14)

*This update closes the curtain on syncing with PowerPC Macs.*  Documents opened with this update will no longer be openable with BookMacster 1.6.x, which is the last version that will run in macOS 10.5.  Therefore, if you are syncing your Bookmarkshelf document with BookMacster on a Mac, such as a PowerPC Mac, which must continue to run macOS 10.5, do not install this update, and also you should click BookMacster's Preferences > Updates, and switch off *Check for updates when launching BookMacster*.

* Now has a silent workaround which should solve the issue, for users of the *Parallels Desktop* app, of repeated Error 513944 or 292114 which is caused by [Parallels and macOS directing BookMacster to an MS-Windows installation of Firefox](https://sheepsystems.com/files/support_articles/bkmx/parallelsConflict/index.html).

* Fixed a bug which sometimes caused bookmarks changes to be exported to browsers, but not saved to the .bkmslf document file, if a sync operation was performed in the background by a Worker while BookMacster was not running, and the Mac was rather busy with other processes.  (Multithread race condition sometimes allowed Worker process to exit before save was completed.)

* Fixed a bug related to macOS 10.9.2, which caused the new document created by a *Duplicate* or *Save As* operation to not save data, and sometimes crash, until it was closed and reopened.  (The workaround is that such new documents now close themselves and re-open immediately after they are created.)

* Error 59547, which can occur when exporting to Google Bookmarks, now includes the underlying error received from Google, if any, for several representative bookmarks.

* After deleting bookmarks in the Duplicates tab, the selection in the table view is now cleared instead of jumping to other undeleted items.

* Eliminated some unnecessary and sometimes repeated showings of the *For smooth syncing … export …* warning sheet after changing Clients and/or Agents.

* Improved reliability of the *Export to Clients whenever this document is updated from another Mac* sync setting, for use cases in which the Bookmarkshelf document file might be updated while the user is logged out.  ChronoAgent, for example, can do this, and it is conceivable that other processes could update a .bkmslf file before macOS has loaded BookMacster's file-watching agent.  (Instead of being triggered only when the document file is changed while the file-watching agent is watching, this agent is also now triggered when the user logs in, but only if the .bkmslf has changed, to "catch up" on any changes that were missed.)

* The *I log in to my Mac* agent trigger now has an option, a choice of *only if this .bkmslf has changed* versus *every login, always*.  The former choice greatly reduces system resource usage by checking document metadata to see if a change has occurred, which is rare.  Legacy agents in existing documents are migrated to the latter choice, which is the old behavior.

* In a document's Settings > Agents > Advanced > Triggers, a new trigger type has been added: *Periodic*.

* Text in most error and warning dialogs is now selectable and copiable.

* Fixed a bug introduced in BookMacster 1.20.5 which prevented the account name from being remembered after being entered by the users, so that it appeared as *null*, which also caused any non-default settings, such as *I am always signed in to Google as whoever* to also not be remembered.

* Fixed a bug which would cause a crash if a new name was typed into the title bar of a document window immediately after duplicating the document, and then certain document non-local settings were edited.  (Now closes and re-opens the document after such a renaming.)

* Now displays a sheet announcing when License Information has been extracted and installed from a Bookmarkshelf document.

* *Preferences* > *Syncing* now has a *Sound Effects…* button which exposes controls for adding sound effects to sync operations.  We've found sound effects to be useful in testing, and troubleshooting coordination with other syncing services.

* Changes to Help Book
  
  * Home Page has been simplified.

  * Incorporated several articles from our Support web page into the Help Book.  In particular, added a new section 3.6, *Tagging*.
  
  * Help Book is now generalized to apply to our three new apps.  (The three new apps are "coming soon".  Smarky, Synkmark and Markster are simplified clones of BookMacster which each target only one of BookMacster's three typical use cases.)

* Fixed a bug introduced several months ago which caused an unnecessary sync operation to occur immediately upon creating an *I log into my Mac* trigger for an Agent.

* Fixed a bug which caused a crash if user added Clients or Agents in such a way as to affect syncing and then managed to close the window within 1.5 seconds.

## BookMacster 1.20.6 (2014-02-21)

* Typically becomes responsive a few seconds faster after launching.  (Fixed a bug which caused checking for Bookwatchdog Login Item to run on the main thread.)

* The title of the *Clients* item in the pop-up user-selectable column headings has been changed to *Client Associations*, more accurately reflecting its content.

* Fixed a bug which caused user to *not* be prompted to export when syncing is active, after changing an existing Client to a different web browser or profile.  Export is prompted now.

* Upon launching, does some automatic cleanup in case Clients which may have gone defunct, as can occur if Firefox was reset by the user, or decided to reset itself after its profile data became corrupted somehow.  (Reportedly, this can occur if there is a kernel panic while Firefox is active.)

  * If any defunct clients are found, reveals the Clients tab and instructs user to delete or re-set them.
  
  * If all clients are OK, checks bookmarks and folders for identifiers associated with unavailable clients, and removes any such that are found.
  
* If user commands a document to *close* while it has an operation is in progress, BookMacster now displays a sheet informing the user that the window *will close after operations in progress are done*, which is what now it does, instead of cleaning up and closing as soon as possible.  We think that closing before all parts of an operation were complete may have been causing some unexpected behaviors.

* The wording of the recovery suggestion displayed for Error 259284 *Client not available*, when it occurs when exporting to Firefox or one of the Chrome-ish browsers, has been improved so that it is not so mucked up by the possiblity of multiple user profiles.

* Fixed a bug, introduced in the previous verison 1.20.5, which caused the *Close* button in the *License Info* window to not work when it was clicked with the mouse.

* Fixed a bug which could cause BookMacster's background Worker process to crash instead of producing an error if it attempted to open a .bkmslf document which was not available.

* The user is now warned if an agent's trigger is deleted because it failed a validity test.

## BookMacster 1.20.5 (2014-02-12)

* The menu attached to the *Quick Search* field in the document window now has some handy menu items, for finding bookmarks or folders modified during the last day, week, month or quarter.

* Improved conflict resolution when importing from multiple browsers, for attributes which are not present in the first Client.  For example, when importing from Safari and Firefox, in that order, the date *Added* of a bookmark, which is available from Firefox but not from Safari, is now correctly imported from Firefox.

* The *Open File* navigation dialog which appears when specifying a Client with *Choose File…* now navigates by default to BookMacster's default document location (~/Library/Application Support/BookMacster/Bookmarkshelf Documents/).

* The Preferences > Syncing tab now has some Help buttons to explain settings.

* More informative errors are displayed if an import or export fails because a Client has become unavailable, for example if a Chrome or Firefox profile was deleted.  (Client availability is now checked before attempting an import or export.)

* Better reliability of exports to Firefox, for users with only one Firefox profile.  (No longer tries to determine which profile is running, in this case that has only one possible answer.)

* Now displays a warning when user creates Agents in more than one document.

* Text in the *Import from Clients now?* dialog which is presented during creation of a new document has been changed to make it easier understand for new users.

* The warning which appears for new users prior to performing an export has been clarified, and an additional warning appears if the impending export will leave less than 5 bookmarks standing in a web browser Client.  This is to make it *even more difficult* for new users to unwittingly delete all of their bookmarks, by failing to import anything and then exporting their empty document.

* Error presentation dialogs are now more understandable.  They only show the error's *Timestamp* if the error occurred more than 10 seconds ago, and the timestamp's wording is in more plain English.

* The *Stop Workers, Remove Agents* command now also stops Workers and removes Agents from our forthcoming apps in addition to those of itself.

* The feature to *make license information available to all users on this Macintosh* has been removed.  ([Other ways to do this](https://sheepsystems.com/bookmacster/HelpBook/licOthMacJustWorks) still work.)

* The *Copy to…*, *Move to…*, and *Merge Into…* menu items in document Content's contextual menu, and the *Move* popup menu in the Inspector, no longer have *Visit All Items* menu items when navigating through some folders.

* Fixed a bug which could caused tags to not be exported to Firefox, sometimes if bookmarks were only exported to Firefox and never imported; that is, user had not configured Agents' syncing with Firefox.  The bug would affect only duplicate bookmarks (same normalized URL), wherein some member(s) of the dupliciate group, in BookMacster, did not have all of the tag(s) that other member(s) had.  Because Firefox assigns tags to URLs instead of bookmarks, during exporting to Firefox, in this case BookMacster is supposed to add the missing tags to bookmarks in a duplicate group which were missing tags.  The bug was that sometimes BookMacster would do the opposite, removing tags from bookmarks in a duplicate group that had "extra" tags.  The behavior was random, such that subsequent exports could result in the conflicted tags being removed, then later added back, etc.

* Fixed a bug, introduced in BookMacster 1.19.7, which is that after entering a credential for Pinboard or Delicious, the credential was not tested for validity, and was not entered into the macOS Keychain if the checkbox *Remember in my macOS Keychain* was switched on.

* Fixed a bug which prevented keyboard shortcuts defined in BookMacster itself from being set as one of the global keyboard shortcuts in Preferences > Shortcuts.  (These shortcuts are only active when a web browser is active, so there is in fact no conflict with the keyboard shortcuts defined in BookMacster itself.  (This bug was probably introduced in BookMacster 1.19.)

* Fixed a bug which caused the *Move To…* contextual menu item's submenu to only allow moves to a different document, if more than one document was open, and if the clicked document upon which the contextual menu was appearing was not the first document that had opened since the app had launched.  (The *Move To…* contextual menu item should only allow moves within the clicked document.  Instead, it was only allowing moves to the first-opened document, regardless of whether or not that was the clicked document.)

* Fixed a bug which caused the two fields in the Logs window > Errors to be user-editable, and if user did edit any text, stuff in the window wouldn't work until BookMacster was quit and re-launched.

* Fixed bugs which could cause recent changes in a new .bkmslf document file, or one migrated from a version of BookMacster prior to BookMacster 1.15, to be lost, if the newly-created or newly-migrated document was moved before it was closed and re-opened.  (These bugs were introduced in BookMacster 1.19.2 and is related to the WAL journal mode introduced in Apple's macOS 10.9 SDK and Apple Bug 16038419.)

## BookMacster 1.20.4 (2014-01-21)

* Fixed a bug which could cause a crash when if user clicked File > Export to only > Firefox while Firefox was running and before our Firefox extension was installed.

* If Firefox cannot be launched when needed to perform an export, Error 513944 which is generated now includes additional information for our Support team.

* Fixed memory leak in the *More Tests…* feature of *Manage Browser Add-Ons*.

## BookMacster 1.20.3 (2014-01-14)

This version has only one change since 1.20.2.  Users who already have BookMacster 1.20.2 from our Beta update channel may reasonably choose to skip this version.

* Fixed a bug which caused the “Export to Clients whenever … this document is updated from another Mac” Agent to fail if the Bookmarkshelf document was located in BookMacster's Application Support folder.  (Most users of this feature have their document in their Dropbox folder, and therefore were not affected.  But such a placement is natural for users of a synchronizing app with more flexibility, such as ChronoSync.)

## BookMacster 1.20.2 (2014-01-12)

* The *Floating Menu* (accessed via Status Item menulet, Dock Menu, or Global Keyboard Shortcut) has been reorganized, and a new section of preference settings for it has been added in Preferences > Appearance.  A new workflow, wherein a user visits bookmarks using *Mini Search*, and lands new bookmarks using the *Add to* menu item, is now smoothly supported.  If desired, the old fashioned Bookmarks Tree menu items can be switched out.

* Now compatible with Google Chrome, Chrome Canaray and Chromium version 33 and later, which is scheduled to be released on Chrome's Stable channel in 9-12 weeks.  (Previous BookMacster versions may fail with Error 692384 when exporting to these browsers while they are *not* running.)

* Bookmarkshelf Documents are now closed and re-opened when their files are updated in the manner that ChronoSync does.  Consequently, the Simple Agent setting to *Export to Clients whenever … this document is updated from another Mac* now works properly with ChronoSync.  (ChronoSync updates files in a different manner than Dropbox does.)

* When closing a document, if changes have been made since last exporting to Client(s) which are currently being synced by a BookMacster Agent, the user is now prompted to consider exporting to those Client(s) before closing, in order to keep everything in sync.

* In a document's Settings > Agents > Simple tab, clicking the *Full Sync* button no longer switches on the *Sort (alphabetize)* checkbox.  In other words, sorting is opt-in insead of opt-out.

* Setting an already-existing Simple Agent to *Sort (alphabetize)*, or, equivalently, adding a *Sort* command to an Advanced Agent, while syncing is active, no longer shows a warning sheet advising the user that an immediate (but in fact unnnecessary) export is necessary.

* In a document window's *Settings* > *Clients* > *Import Postprocessing (Advanced)* sheet, fixed bugs in operation of the *Default Parent* popup menu.

* If an export to Safari is aborted because BookMacster waited too long for some other process (usually iCloud's agent) to let go, the Error 613901 or 613902 which is produced no longer causes syncing to be paused.

* If an export to Safari is delayed because iCloud is busy with Safari bookmarks, the progress bar in the Status Bar now shows determinate instead of indeterminate progress (a progressing bar instead of a barberpole), and the timeout has been increased from 25 to 60 seconds.

## BookMacster 1.20.1 (2014-01-07)

* Document window titles no longer have the suffix "◇ BookMacster"; therefore new windows created by *File* > *Duplicate* now show the characters being typed in macOS 10.9.  The latter is because we no longer trigger Apple Bug 15736644.  However, we also decided that the cosmetics are better without the suffix anyhow.

* In Preferences > Appearance, a new section *Arrangement of items in Floating Menu, Dock Menu and Status Item (menulet) has been added.  The two controls in this section allow user to control the position of the *Mini Search* menu item, and also whether or not existing bookmarks are shown in the menu.  (For visiting, it's more convenient to use the *Mini Search* rather than to arrow-key through the hierarchy.)

* Fixes non-detection of Firefox bookmarks changes for some users.  (Contains version 311 of our Firefox extension, which gets the profile name from the profiles.ini file, instead of from the file path.  In particular, this fixes an odd case where Firefox put the user's "Default" profile files into the the parent "Profiles" folder instead of into a separate folder dedicated to that profile.)

* Feedback to the user when attempting to switch off the preferences *Appearance > Status Item (Menulet)* or *Shortcuts > Show the Floating Menu* while *General > Launch in Background* is ON has been improved.

  * If the *Status Item (menulet)* is set to *No Status Item*, and the user removes the global keyboard shortcut to *Show the Floating Menu*, a warning sheet appears advising the user that *Launch in Background* has been switched off.

  * If there is no keyboard shortcut to  *Show the Floating Menu*, the *No Status Item* selection in the *Status Item (menulet)* radio buttons is disabled.
  
* Similar to the *Launch in Background* preference, the *Background BookMacster* menu item is now enabled if a global keyboard shortcut to *Show the Floating Menu* is configured, even if the *Status Item (menulet)* is set to *No Status Item*.

* In a document's *Content* tab, when switching on or off the *Tags Filter*, the *Content View* now automatically switches into, respectively, *Table* or *Outline* mode.

* In macOS 10.9, when the user clicks *Background BookMacster*, the application which replaces it as the active application is more likely to be as expected, which is the last-active application.  (A special routine, which is required to activate the replacement application in Mac OS 10.8 and earlier, is now bypassed when running in macOS 10.9, wherein it is no longer necessary thanks to a bug fix in macOS 10.9.)

* Fixed a bug which caused the *Rename Tag* contextual menu item to be ineffective in recent versions.

* The new black-and-white Status Item (menulet) icon now looks better with desktop pictures that reflect a dark background into the menu bar.  (The circular "hole" at the top is now a transparent disc instead of an opaque white disc.)

## BookMacster 1.20 (2013-12-28)

* If an export operation is skipped because BookMacster pre-determines there are no changes to export, the result in the Status Bar now explains this a little more verbosely, indicating *Same-Skip* instead of just *Skip*.

* The *Manage Browser Add-Ons* window has a new button, *More Tests…*.  The new test shown by clicking this button gives an analysis of the Firefox and Chrome profiles in use, and also indicates if Firefox and Chrome extensions are posting the expected notifications when their bookmarks change.

* Lower probability of getting a rare Error 145725 when exporting to Chrome, Canary or Chromium while the browser is running.  (A timeout, which was reportedly too short in some situations, has been increased.)

* In a document's *Settings* > *Clients* tab, if a Client is no longer functioning because its bookmarks data can no longer be found on the disk, its name is prefixed by a heavy red X, its font is red, and a tool tip advises how to resolve the situation.  (This will happen after a user has [somehow](https://bugzilla.mozilla.org/show_bug.cgi?id=717070) caused a [Firefox Reset](http://mzl.la/MLVHSq), because in so doing, [Firefox suffixes the re-created profile name with a unix epoch timestamp](https://bugzilla.mozilla.org/show_bug.cgi?id=717070)).

* Added a measure to try and prevent occurrence of Error 325844, underlaid by Error 287101, which has been reported to occur in macOS 10.9.

* Google Bookmarks Error 59547 is now accompanied by a Recovery Suggestion for the user to double-check that they are properly signed in to Google.

* Corrected recovery suggestion of Error 613902 when it occurs during an import, to say *import from* instead of *import to*.

## BookMacster 1.19.9 (2013-12-17)

* The preference to *Show Status Item (menulet) in Menu Bar* has been moved from *Preferences* > *General* to *Appearance*, and additional options have been added to have a modern black-and-white bookmark icon, the old 3-color bookmark icon, or a gray version of it.  Exisiting users are migrated to the gray one.

* Automatic exports caused by the new *Export to Clients whenever a new bookmark is landed* setting are now delayed in case the user wants to edit the newly-landed bookmark in the Inspector panel.  If the Inspector is not displayed when the new bookmark is landed, the export occurs immediately.  If the Inspector is being displayed, the export occurs when the user closes the Inspector panel, or until nothing is edited for 30 seconds, whichever comes first.

* Now supports the new [OmniWeb 6](http://omnistaging.omnigroup.com/omniweb/).  (Previous versions worked, except that they would not insist on quitting OmniWeb 6 prior to an export, which is necessary to ensure that changes "stick".)

* Setting a Keyboard Shortcut to BookMacster's *Floating Menu* now enables the *Launch In Background* option, in the same way that *Show Status Item (menulet) in Menu Bar* still does.  This makes possible a "super stealth" background mode wherein BookMacster is running, and can receive landings of new bookmarks directly, but is completely invisible until the *Floating Menu* keyboard shortcut is hit.  When BookMacster is launched, if it is in this "super stealth" mode, for users of macOS 10.8 and later, a notification appears in the macOS Notification Center stating the keyboard shortcut which is necessary to show BookMacster.

* In Preferences, if both the Appearance > Status Item and Shorcuts > Floating Menu are switched off while *Launch in Background* is on, *Launch in Background* is switched off.

* Improved reliability of syncing across Macs using, for example, Dropbox.  (Resolved a random "race" which, in previous versions, rarely, caused bookmark changes to be not exported to browsers until the *next* change.)

* Fixed a bug which caused the Agents > Simple tab to display nonsense if an error occurred which paused syncing, if this tab had not yet been displayed since the window opened.

* Fixed a bug which caused churn, an unnecessary export by BookMacster on other Macs, when an export operation caused bookmarks to be deleted in a Client, if the Bookmarkshelf document was synced to other Macs by, for example, Dropbox, and had an Agent triggering on 

* Google Bookmarks Error 83213 is now accompanied by a Recovery Suggestion for the user to double-check that they are properly signed in to Google.

## BookMacster 1.19.8 (2013-12-05)

This update again focuses the experience of new users.  It also has some improvements and bug fixes in rarely-used features.  Existing users may skim the changes and choose to skip this update.  Thank you for helping us to support BookMacster!

* The term *Anywhere Menu* has been changed to *Floating Menu*.

* A new Agent trigger, *new bookmark is landed*, has been added.  This allows users who prefer to add bookmarks to BookMacster directly on their Mac to have such additions automatically synced to their other devices.  This trigger is activated by a new checkbox in the *Settings* > *Simple* tab, and is ON default when syncing is configured for a new document.

* The document's *Settings* > *Simple* tab has a whole new look:

  * The diagrams have been removed, and the checkboxes rearranged and retitled.
  
  * An *Full Syncing* button has been added, for default one-click configuration.
  
  * A Help button has been added.

* The warning sheet advising that the *document must be in a Dropbox or similar folder* when certain sync configurations have been activated no longer appears.

* The warning sheet advising users to export after affecting sync parameters has been adjusted to be somewhat less annoying.

* In the *Manage Browser Add-Ons* window, the appearance of the controls for Firefox *Menu items* now reflects the fact that a prerequisite of *Menu items* is the basic Firefox extension.

 * Button titles have been changed from *Install* and *Uninstall* to *Add* and *Remove*.

 * If the extension in which they reside is not installed, the buttons are disabled, and the status field explains that the basic extension must be installed before *Menu items* can be switched on.

* Restored proper operation of the rarely-used *Aggressively Normalize URLs* menu command.

* The moving tooltip which appears during drag operations in the Content View, which advises users how to avoid undesired folder expansions, etc. has been made bigger and bolder, but now only appears on a sparse schedule, and a preference has been added in *Preferences* > *Appearance* to never show it.

* Fixed a bug which sometimes caused the *Syncing* button in the toolbar to continue to indicate that syncing was still active after the user had manually removed the last Agent.

* Fixed a bug which could cause the the little *What to do* window to not have keyboard focus until it was clicked with the mouse.

## BookMacster 1.19.7 (2013-11-21)

* Updated method for signing in to Google Bookmarks to comply with latest Google security model.  Instead of BookMacster detecting the signed-in state, and signing in or out as required using the macOS Keychain, users must now verify the state manually, or else instruct BookMacster to assume that they are always signed in to the correct account.  (Chrome users, this does not affect you.  *Google Chrome* and *Google Bookmarks* are different Google products with different bookmarks.)

* Fixed bug which could cause BookMacster's *Toolbar Button* extension to fail to load in Google Chrome, Canary or Chromium.

* Fixed bug which could, in some systems, cause BookMacster's Status Item (menulet) to disappear when user clicked *Background BookMacster*.

* Fixed bug which could cause a change in Chrome, Canary or Chromium to not initiate an Agent sync operation if the change was only updating of item name(s).

* Fixed bug which could cause newly *landed* bookmarks from other applications not be placed into a folder, and ultimately disappear, if user had never designated a New Bookmark Landing in Settings > General.

* Fixed a bug which sometimes caused unnecessary downloads when importing from or exporting to Delicious, Diigo or Pinboard.

## BookMacster 1.19.6 (2013-11-17)

This version improves operation with Firefox and Chrome, particularly with *Firefox Sync*, Chrome's *Sign in to Google* and Firefox *Live Bookmarks*.  Also works better with Alfred 2, and fixes a few user interface bugs.  Thank you for helping us to support BookMacster!

* Updated our Firefox Add-On (Sheep Systems Firefox Extension) to version 297, in order to continue support for *Live Bookmarks* in future versions of Firefox.  Upon launching BookMacster 1.19.6 for the first time, users who have our extension installed will be prompted to click through the update.

* Improved coordination with *Firefox Sync* and Chrome's *Sign in to Google*.

 * Bookmarks changes made on other devices are imported faster and more reliably, because BookMacster now detects when these services are in use prior to any import *or* export with Firefox *or* Chrome, and if so, and if the browser is not running in the relevant profile, by default now (re)launches the browser into the correct profile, so that a*coordinated* import or export can be performed.  (Previous versions only did this when exporting to Chrome.)

 * Users may opt out of, or further into, the aforementioned new behavior with a new [Advanced Setting for browser launching](https://sheepsystems.com/bookmacster/HelpBook/accessLocApp).

 * Spurious, empty change notifications emitted periodically by Firefox Sync (typically every 60 minutes but sometimes every 10 minutes) are now detected as such in the initial change detection process, and no longer cause an unnecessary sync job to be scheduled.

* The process of installing our Firefox Add-On has been given a couple tweaks…

 * Updated to reliably activate the Add-On after installation in Firefox version 26 (which is due 2013-12-10).

 * Fixed a bug wherein our Add-On could be reinstalled into the wrong Firefox profile if multiple profiles were in use, an Add-On was removed in Firefox, and then Firefox was launched into a different profile before reinstallation was commenced.  Surely an [edge case](http://en.wikipedia.org/wiki/Edge_case).  But when we find 'em, we fix 'em.

* Increased the time allotted for Google Chrome to swallow bookmarks during coordinated exports, before giving up and throwing Error 453973.  (This was done because it appears that, for some users, Chrome is not as fast as we'd previously based our allotment upon.)

* Fixed a bug which could cause an export to Firefox to fail with Error 145725 if our Firefox extension had been recently removed.  (Now prompts user to re-install the Firefox extension if necessary, before trying to talk to it.)

* When launched by a background process such as *Alfred version 2* in macOS 10.9 Mavericks, BookMacster now shows its menu bar without the user needing to activate a third application first and then return to BookMacster.

* In Preferences > General, restored settings for *Ask what to do if nothing opens on launch* and *Save like macOS 10.6…*, which have been omitted since BookMacster 1.19.0.

* Fixed bugs which often caused column attribute assignments and/or widths to not be properly restored from the previous closing when re-opening a document window.

* Fixed a bug which caused the *Preferences* or *Inspector* window to remain open, and an exception to be logged to the system console, if either of these windows were open when user executed the *Background BookMacster* command from the main menu or Status menulet.

* Fixed memory leaks which occurred when running in macOS 10.9 Mavericks, while displaying the *Reports* > *Find* tab, whenever user resized the window to have a smaller width.

* In the License Information window, the font in the two editable fields is now always the user's preferred monospaced font of size 14, regardless of whether the information is read from the hard disk, read from a license installer file, or is pasted in, dragged in, or typed in.

## BookMacster 1.19.5 (2013-10-30)

* Fixed a misbehavior of syncing in macOS 10.9 Mavericks.  In some situations, BookMacster's background Worker would sync bookmarks among web browsers as expected, but changes would not be saved to the Bookmarkshelf Document.  If you are using BookMacster to sync bookmarks in 10.9 Mavericks, you should verify that all os OK.  To do that, install this update, and when BookMacster relaunches, you should open your Bookmarkshelf and spot-check its Content for any missing recently-added bookmarks.  Then, click in the menu: File > Import All.  Any missing bookmarks should now appear.  You're done.  You should verify that the green *Syncing* button is still lit in the toolbar, and quit BookMacster.  BookMacster Workers will now sync and save as expected.  (If something else happens and you want to back out of the import, Edit > Undo Import.)

## BookMacster 1.19.4 (2013-10-29)

* Updated our Chrome Extension to version 20.  Version 19 would fail to load in Chrome, Chromium or Canary because we entered the wrong version number into the External Extensions json file.

* Removed spurious logging of "Internal Error 524-7771" during imports or export, because actually it is not an error.

## BookMacster 1.19.3 (2013-10-29)

* Fixed bug introduced in 1.19.2 which sometimes caused a crash when opening Preferences.

## BookMacster 1.19.2 (2013-10-28)

* Fixed a bug which caused some imports, exports and syncs to be skipped, and possibly other issues, when using BookMacster in macOS 10.9 Mavericks.  (Because the root cause is apparently a bug in macOS itself, and affects BookMacster at a low level in several places, there may be other effects.)

* Modernized two implementations which might have been causing imports, exports and syncs to be skipped.  (Worker now accesses BookMacster's Preferences and other resources without replacing Apple's method, and file references no longer uses deprecated Alias Manager.)

* Fixed a bug, introduced in BookMacster 1.17, which caused, for example, bookmarks in Safari's Reading List to be moved into the Bookmarks Menu when a new bookmark was added in Chrome, while syncing Chrome and Safari.  More generally, when one client browser "S" *had* a certain Hard Folder, with items in it, and the client other browser "C" did *not* have this Hard Folder, when bookmarks are synced or imported from only browser "C", items which were in that Hard Folder in browser "A" were moved into wherever BookMacster had mapped them to in browser "C".)

* If user commands to *Resume Syncing* when Agents are configured for *Simple* but there are no clients to sync, BookMacster now displays a warning instead of resuming syncing of nothing.

* License Information window now displays its data in monospaced Courier New font.

* Fixed a bug which sometimes caused a document window to hang before it was completely drawn, when opening a document that had a lot of tags, only in macOS 10.6.

* Now built with the macOS 10.9 SDK instead of 10.8.  (Supposedly, this change has no effect.)

## BookMacster 1.19.1 (2013-10-10 to Beta)

* Fixed a bug, apparently introduced in BookMacster 1.17 published a month ago, which caused BookMacster's built-in *(Sparkle)* update checker to write a bad preference, which prevents any further updates, if user opened the Preferences and switched the *Beta*, or *Alpha* checkboxes on or off while using BookMacster 1.17, 1.18, 1.18.1, or 1.19.  Running this version once will correct that preference and restore update checking.

## BookMacster 1.19 (2013-10-08 to Beta)

This version has some user-interface reorganization which we hope makes BookMacster more intuitive to use, and also several components have been re-architected under the hood, so that we can re-use them in other products.  No additional issues with Mac OS 10.9 Mavericks have emerged.  We are publishing this version on the Beta track, in hopes that our early adopters would be kind enough to report any bugs found.

* The menu commands *Import* and *Export* have been renamed to *Import from all* and *Export to all*, and have been moved into the *File* menu

* Also in the *File* menu, the commands *One-Time Import >* and *One-Time Export >* have been renamed to *Import from only >* and *Export to only >*.  The corresponding AppleScript commands have been renamed to *import only* and *export only*.

* The tabs in the Preferences window have been re-ordered so as to be more conventional.

* After a Verify operation, the *Verify* Report simply opens.  The *Inspector* panel and *Find* report only open after the user has clicked one of the inspection buttons in the report.  The idea is to reduce annoying information overload.

* Again, to be less annoying, the *Inspector* panel no longer shows the second time that BookMacster is launched by a new user.

* Holding down the *command* key while dropping items into the Content view now results in a normal *move* operation instead of *copy* operation.  (The correct behavior is not defined in Apple's *macOS Human Interface Guidelines*, but we think this is better.)

* Fixed a bug, probably introduced in BookMacster 1.17, which would cause either no response or a crash if user attempted to switch on syncing when there were no Clients, and clicked the *Add Clients* button in the *Simple Agents* tab.

* Fixed a bug introduced back in BookMacster 1.12.7, in the document window's Settings > Structure tab, which enabled the *Items Allowed in Root* checkboxes to be switched off when they should have been disabled because subject items already existed in root.

* Fixed a bug which caused the Status View to continue to indicate indeterminate progress *Quitting (Browser-Name)* in some situations after installing a web browser add-on had failed, until some other status needed to be displayed or until the window was closed.

* Fixed a bug which caused BookMacster to try and trash a document twice, resulting in a spurious error indication, if it was left open while adding a second new document, or adding a first new document after clicking *Reset and Start Over…*.

* Fixed a bug which caused a new document to be omitted from the list in the menu item *File* > *Open Recent* if it was closed before any Content (bookmarks or folders) had been added to it.

* When adding Clients in *Settings* > *Clients*, after all known candidate Clients have been added, the *add* (+) button becomes disabled after adding one more placeholder Client.   (This is just a cosmetic fix.  Unfulfilled placeholder clients were and are deleted when a document is closed anyhow.)

* If user requests additional free trials after free trials are exhausted, the dialog now has a *Contact* button to request additional demo time.

* In BookMacster's AppleScript dictionary, the *BookMacster Suite* has been renamed to *Bookmarks Management Suite*.

* Fixed memory leak which occurred when user clicked *Reset and Start Over…* more than once.

## BookMacster 1.18.1 (2013-09-20)

This version is a fix for users of macOS 10.6 (Snow Leopard).  If you are using macOS 10.7, 10.8, or later you should skip this update.

* Fixed bug which caused failure to open documents when running in macOS 10.6.8.

* Improved the syntax of three AppleScripts which used under the hood for getting selected text from Safari, Opera and OmniWeb, so that they now in macOS 10.9 Mavericks.  These scripts are used when *landing* a new bookmark and the selected text becomes the bookmark's Comments.  But this change is only a *use best practices* change.  It does not affect operation, because we have disabled these scripts in Mavericks anyhow, for another reason: an annoying security warning and hoop which the user would need to jump through.

## BookMacster 1.18 (2013-09-17)

This version contains a couple of changes which make things better when running in macOS 10.9 Mavericks.

* The first-time launch process has been improved, making it much more fun for first-time users to get BookMacster configured.

* For users who are returning to BookMacster, a new menu item, *File* > *Reset and Start Over…* has been added.  This menu item removes old documents and settings, and launches that *new* new-user experience.

* Fixed a bug introduced in BookMacster 1.17 which disconnected some of the more obscure controls in a document's Settings tab, rendering them ineffective.

* When landing new bookmarks from Safari, Opera or OmniWeb, if operating in macOS 10.9 or later, BookMacster no longer tries to grab the selected text in the page and enter it as *Comments*.

* BookMacster's menu is shown immediately, without first activating another app, when launched in macOS 10.9 Mavericks.

* Clicking *Background BookMacster* now works better:
  * Open documents no longer appear to close and no longer need to be manually re-opened in the background.  (For technical reasons, documents are still closed.  However, starting with this version, they are automatically and immediately reopened, in the background.)
  * No System Alert (beep) sound.
  * Ownership of the main menu bar is relinquished immediately so that macOS can pass it to the next active app.

* Fixed a bug which could cause one of the keyboard shortcuts in Preferences > Shortcuts to initially be assigned to a random key combination.

* Failure to install the Firefox Extension due to non-cooperation by Firefox should occur less frequently because…
  * A 10-second unreliable time delay has been replaced with a 3-second reliable time delay.
  * User is now advised to look in other windows where Firefox might be hiding the Install sheet.

* Contains version 295 of Sheep Systems Firefox Extension, but this is not required.  The only change is that it now detects bookmarks changes when syncing customized Firefox profiles whose directory name form does not have a filename extension, for example "Joe Doe", as opposed to "slei8tks.Joe Doe", or "xeglw8qo.default" which is the form that 99.9% of users have.  To save thousands of unaffected BookMacster users the annoyance of clicking through a Firefox extension installation, we therefore left the BookMacster's internal *minimum required Firefox extension version* at 294.  Users with affected custom profiles should update to version 295 manually.  To do that, after updating to BookMacster 1.18, click in the menu: *File* > *Manage Browser Add-Ons*, then button *Uninstall* followed by *Install* for the affected Firefox profile.

## BookMacster 1.17 (2013-09-06)

BEHAVIORS

* Instead of the Hard Folders in BookMacster always being named *Bookmarks Bar*, *Bookmarks Menu*, *Reading/Unsorted*, and *My Shared Bookmarks*, each name now is now the name of the Hard Folder in the first of the document's Clients which maps to it.  In case that no Client has a Hard Folder corresponding to a given Hard Folder which has been created in BookMacster, the names *Favorites Bar*, *Bookmarks Menu*, *Reading List*, and *My Shared Bookmarks* are used.

* When syncing, now imports most all *moves* of items, from any Client, instead of just the first Client.  (Referring back to the second item in the Version History of version 1.7.3, we have replaced the *screen* described in there with a better one.)  In detail, BookMacster now considers moves which are apparent when importing from all Clients equally, and ignores such moves only if it could be accounted for as the result of an automatic mapping during a prior export.  There are two such cases of these automatic mappings.  Both of them rare…
  * The Client would not allow the item to be exported to its current location in the Bookmarkshelf document, and the apparent moved-to folder is the default parent of the item.
  * The Client in which the move is apparent has a Tag Mapping whose target folder is the apparent moved-to folder, and whose tag is one of the item's tags.

* Removed the restriction on exporting valid bookmarklets, which are deemed invalid by macOS, such as the bookmarklet published by [Plex](http://plexapp.com) or [Watchlater](http://watchlaterapp.com).  (This restriction was an unintended consequence of another change made in BookMacster 1.15.)

* The next two changes only affect BookMacster when running in *Background Mode*.  Together, these changes also fix a bug wherein the old version of BookMacster would continue to run along the new version if BookMacster was updated (*Check for Update*, then *Install and Relaunch*) while in Background Mode.  Because it occurs in the old version, that behavior may still occur when updating *to* this version, but should not occur in the future, when updating *from this version*.

  * Fixed a bug which caused the *Quit BookMacster* menu item in the Status Menulet or Dock Menu to fail silently (would not really quit) if a document was open.

  * BookMacster's URL Handler (a secondary process which receives landing of new bookmarks) is now quit when BookMacster quits.

* During drag and drop operations into the Content Outline, autoexpanded items now return to their original collapsed state after the mouse cursor moves away.  (And, the shift-key feature to avoid such expansions in the first place still works.)

* The feature to import and convert Bookdog settings the first time that BookMacster has run, and the menu item to do it on demand, has been removed.  The menu item to *Remove Bookdog Artifacts* remains.

* Is now able to find Google Bookmarks accounts that have multiple dots in their host name, for example "joe@abc.co.uk" in the Keychain.

* Fixed a bug which may have been causing rare occurrences of Error 134030 in Cocoa Error Domain when dragging in a URL from Safari to create a new bookmark.  Please click the life preserver and send us an error report if you ever see this happen again.  (Temporary new bookmark was not being deleted from its context after it was replaced with a permanent new bookmark.)

* BookMacster's Anywhere Menu and Dock menu now support landing new bookmarks from Google Chrome Canary.

* No longer hangs when parsing a Delicious or Pinboard bookmark that contains a percent-escape encoded UTF8 sequence representing the Unicode Replacement Character (%EF%BF%BD, U+FFFD) in its query portion.

* Upon entering the Versions Browser, if an *Export changes* Agent is active, BookMacster now warns the user that any restored bookmarks will be immediately exported to Clients, and advises how to prevent that if desired.

* Fixed a bug which caused an agent to become unremoveable after it had spawned a Worker process which crashed or was terminated by an external signal that caused it to return a non-zero exit status.

PERFORMANCE

* Document windows open faster and use less system memory.  (The improvement depends on the document and its data.  The largest improvement occurs for documents that open to the default *Content* tab and have a large history of Syncs in their *Reports* > *Sync Log*.  The change is that, instead of loading all three of the top-level tabs *Content*, *Settings*, and *Reports*, when the window opens, only the tab which is initially visible is loaded, and the other two tabs are loaded on demand, which means that in most cases they are never loaded.)

* The following three improvements reduce unnecessary sync operations…

  * When a file syncing service inexplicably decides to replace a synced .bkmslf file with a copy of itself that has the same contents, BookMacster now ignores the change even on Macs which did not create the change initially.  (Last-document-saved tokens are now updated after exporting.)
   * Fixed a bug which, if the user had a document open on one Mac account while an actual bookmarks change requiring a sync was made on another Mac account, about half the time, when the document re-opened with the changes from the other Mac, caused the first item in the document to appear to changed, triggering an unnecessary follow-up export.  (Tags of selected content item were being "changed" to their current value when window opened.)
  * Improved the reliability of detecting whether or not imported and exported bookmarks have actually changed as far as the Client is concerned.  Previously, changes were falsely detected in a few pathological edge cases, for example, adding a folder in Safari's *Edit Bookmarks* or *Show All Bookmarks* window could register changes on unrelated items.  (Hashes of Client contents now exclude attributes which are not supported by the Client, instead of hashing in unreliable default values.)

* During syncing operations, BookMacster now requests that macOS not put BookMacster into App Nap until the operation is complete.  This only affects syncing when BookMacster is running.  (For keeping browser bookmarks in sync, we recommend that BookMacster be quit.  BookMacster Workers sync silently in the background.)

* BookMacster was tested for memory leaks, and all memory leaks we found have been fixed.  (Significant memory leaks waste system resources and can degrade performance of applications.)


ANNOYANCES

* Two changes to the way column sizes are set in a document window:
  * Column widths no longer try to change smartly when the column header is clicked and changed to show a different attribute.  (Although the smart resizing is helpful in theory, we decided that in practice it is more annoying than helpful.)
  * Fixed bug which caused column widths to be incorrectly restored from the previous session in some cases.

* The size of the document window when displaying the tab Settings > Advanced is now properly restored when a document is reopened.

* Fixed a bug in the Uninstall command which caused a spurious Error 260 in NSCocoaErrorDomain to be presented if BookMacster's Firefox extension was not installed before the Uninstall began.  (Can't uninstall something that is not installed, but don't need to.)


COSMETICS

* In the Bookmarkshelf document Content window, the tags in the Tags View have been restyled to look like the tokens in a standard macOS token field.  (Example: Message recipients in Mail.app)

* In contextual menus, Status Menulet and Anywhere Menu, in the items, the sizes of the keyboard shortcut hints (*⌥⌘A*, *⌘B*, etc.), and any icons, now match the sizes of the text in the adjacent menu titles, instead of being fixed at a default size.

* When first launching BookMacster on a new Macintosh account wherein BookMacster preferences have never been set, in Preferences > Syncing, the Minutes to wait… popup menu indicates the default value of *4-5 minutes* (which it is and was) instead of being empty.

* The email message to our support team, which BookMacster kindly generates whenever Google Bookmarks refuses to accept some bookmarks during an export (Error 59547) now contains the URLs of the problem bookmarks in addition to their names.

* In a document window, *Settings* tab, the items in the *New Bookmark Landing* popup menu no longer try to follow the size the user has set in Preferences > Appearance > Menus.  (That setting is not appropriate for menus in popups because the popup itself is of fixed size.)

* Corrected slight misalignment of column headings in document window's Reports > Duplicates.


## BookMacster 1.16.4 (2013-07-15 to Beta)

* Clicking on a *Root* sub-item in a *Copy to ▸* or *Move to ▸* contextual menu item now copies or moves the selected item(s) to the indicated *Root*, as expected, instead of doing nothing.

* If more than one Bookmarkshelf document is open, the submenu under the *Move to ▸* contextual menu item no longer branches into the other documents.  Clicking these branches did not behave as implied since BookMacster 1.14, when this function was disabled, to conform with Apple Human Interface Guidelines that *moves* between documents are not allowed.  They actually performed a *copy* operation instead of a *move*.

* In the *New Bookmarkshelf* wizard, when the list of available clients iis shown, local browser client browsers which do not have any user-created bookmarks are omitted, and if there are no local browser clients with user-created bookmarks, the client-picking sheet is skipped and an empty document opens immediately.

* Improved normalization of the *path* portion of URLs when bookmarks are entered into BookMacster.  A URL with legal but rare nonalphanumeric characters in its *path* portion, such as http://b42.com/a+b, is no longer normalized by encoding the "+", for example.  A side effect of this is that BookMacster's normaliztion no longer decodes *any* percent escape sequences in a path portion.  All four of the major web browsers currently decode different ranges of percent escape sequences anyhow.  In decoding none, BookMacster now behaves like Firefox.

* Fixed a bug which could cause a crash while a browser extension was being installed, if all did not proceed normally.

* Added a test to prevent an export to Safari from stalling due to a rare data corruption.

## BookMacster 1.16.3 (2013-07-07 to Beta)

* Added a new command, *Merge Into ▸", into the contextual menus which appear in various views in a Bookmarkshelf window.  This new command merges selected folders' contents into another folder, and deletes the original folder(s).  Like all editing commmands in BookMacster, this command is undo-able and redo-able.

* Added new menu items to the *Bookmarkshelf* menu, to *Expand Roots* and *Collapse Roots*.  This empowers users with many subfolders of root (so-called *COLLECTIONS* in Safari, for example), to expand and collapse them with one click.

## BookMacster 1.16.2 (2013-07-01)

This list gives all changes since the last production verison, 1.15.4.  If you already have BookMacster 1.16.1 beta, you should skip this version, since there have only been a couple cosmetic changes since 1.16.1.

* The big news, for users of BookMacster *directly*, is that BookMacster's *Anywhere* Menu,  Status Menulet, and Dock Menu now have a *Mini Search* menu item.  The search field which appears in a mini floating window searches in bookmarks' *name* and *tags*, but is configurable to search URL, shortcut and/or comments if desired.  The search results (short list) are navigable with mouse or arrow keys.  To visit a bookmark from the short list, use a mouse click, or hit 'return' or 'space'.

* Contains Version 18 of our Chrome/Canary/Chromium Extension.  This version no longer creates a temporary folder named *Limbo (Sheep Systems)* during an export, so this folder can no longer inadvertently remain after the export is complete.  (We have seen that Chrome, Canary and Chromium sometimes fail to delete this temporary folder when so commanded.  The folder will usually deleted the next time that the browser is launched, but sometimes not, if *Sign In* has already pushed it to the cloud.)
  
* When BookMacster is launched with no documents set to open automatically, the behavior of the "Open Recent" menu items items which appear in the Status Menulet is now more apparent, and only those *Open Recent* menu items which work properly are presented.
  * If BookMacster is in foreground mode, there are only two such menu items, *Open Recent, show the window* and *Open Recent, dock the window*.
  * If BookMacster is in background mode, there is only one such menu item, *Open Recent, don't show the window*.
  
* Fixed two bugs in the little menu inside the *Quick Search* field in the toolbar of a Bookmarkshelf window
  * Now remembers *Recent Searches* reliably, up to and including 25 items.
  * The state-indicating checkmarks of the menu items under *Search In* and *Search For* now reliably track the actual settings.

* When BookMacster is in the background (due to either the preference setting to *Launch in Background* or prior execution of a *Background BookMacster* menu command, a note at the bottom of its Status Menulet indicates *"App is in background"*.

* In *Preferences* > *General* added a checkbox for switching off the Auto Save and Versions behavior of macOS 10.7 and later.  This is for power users who prefer the old behavior of macOS 10.6 and earlier, with the *dirty* dot in the red *close* button of a document window indicating that data needs to be saved, or whose Auto Save does not work properly due to system hacks.
  
* Now handles some partially-corrupted .webloc files dropped into a Bookmarkshelf's Content.  (In case a .webloc file  does not have the URL in its resource fork as it should, BookMacster now attempts to extract a URL from the XML in its data fork.)

* Error 157159, "You requested to rename this document to the same name it already has, and leave it in the same folder it is already in", no longer causes syncing to be paused, because this is not a bookmarks-threatening error.

* The menu item *Help* > *Getting Started* has been removed.  (It has been unnecessary and actually disabled since we moved the *Starting Points* to the home page of the Help Book.)

* We have likely fixed at least one cause of rare but very annoying hangs (beachball, must force quit) that may occur if macOS 10.7 or later requests an Auto Save while a save is already in progress, and is in some sensitive state.

* Possibly fixed a case where displaying a tooltip might cause an exception to be raised, or a crash.

## BookMacster 1.16.1 (2013-06-28)

* Contains Version 18 of our Chrome Extension, which corrects a packaging error that caused Version 17 to not function.

* The new Mini Search window now comes to the fore if BookMacster is in Background mode.

* When BookMacster is launched with no documents set to open automatically, the behavior of the "Open Recent" menu items items which appear in the Status Menulet is now more apparent, and only those *Open Recent* menu items which will presently work are presented.
  * If BookMacster is in foreground mode, there are two such menu items, *Open Recent, show the window* and *Open Recent, dock the window*.
  * If BookMacster is in background mode, there is only one such menu item, *Open Recent, don't show the window*.
  
* When BookMacster is in the background (due to either the preference setting to *Launch in Background* or prior execution of a *Background BookMacster* menu command, a note at the bottom of its Status Menulet indicates *"App is in background."*

## BookMacster 1.16 (2013-06-26 to Beta)

This version adds a Search Bookmarks item to BookMacster's *Anywhere Menu*, Dock Menu and Status Menulet.  This makes BookMacster even better to use *directly*.  Click the new menu item and you'll get the new Mini Search window.

* BookMacster's *Anywhere* Menu,  Status Menulet, and Dock Menu now have a *Search Bookmarks* menu item.  The search field which appears in a mini floating window searches in bookmarks' *name* and *tags*, but is configurable to search URL, shortcut and/or comments if desired.  The search results are navigable with mouse or arrow keys.  To visit a found bookmark, use a mouse click, or hit 'return' or 'space'.

* Contains Version 17 of our Chrome Extension.
  * It is no longer possible for Chrome, Canary or Chromium to fail to delete and therefore leave a temporary *Limbo (Sheep Systems)* folder after an export, because Version 17 does not this temporary folder[NSUserDefaults standardUserDefaults] .
  
* The hidden preference "dontWait" which was added in version 1.15.6 is no longer a preference.  Instead, the new behavior is permanently ON for all users.
  
* Fixed two bugs in the little menu inside the *Quick Search* field in the toolbar of a Bookmarkshelf window
  * Now remembers *Recent Searches* reliably, up to and including 25 items.
  * The state-indicating checkmarks of the menu items under *Search In* and *Search For* now reliably track the actual settings.

* Possibly fixed a case where displaying a tooltip might cause an exeception to be raised, or a crash.

* Now handles a case of partially-corrupted .webloc files.  (In case a .webloc file dropped into a Bookmarkshelf's Content does not have the URL in its resource fork as it should, BookMacster now attempts to extract a URL from the XML in its data fork.)

* Error 157159, "You requested to rename this document to the same name it already has, and leave it in the same folder it is already in", no longer causes syncing to be paused, because this is not a bookmarks-threatening error.

## BookMacster 1.15.6 (2013-06-14 to Alpha)

* Added two hidden preferences for controlling Auto Save behavior.
  * "defaults write com.sheepsystems.BookMacster dontWait -bool true" seems to fix rare but very annoying hangs (beachball, must force quit) that may occur if macOS requests an auto save while a save is already in progress, in some sensitive phase.  We have not done enough testing to switch this on by default.
  * "defaults write com.sheepsystems.BookMacster dontAutosave -bool true" will completely switch off Lion Auto Save and make BookMacster's saving work like it did in macOS 10.6.  This is recommended for people whose system configuration is somehow incompatible with Auto Save.  To test that this is working, change the Content of a document in some way and verify that the old-fashioned *dirty dot* appears in the red *close* button at the top left corner of the window.  It was only tested for a few minutes and may have unintended consequences.

## BookMacster 1.15.5 (2013-06-13 to Alpha)

* Added a menu command: *Bookmarkshelf* > *Aggressively Normalize URLs…*.  This is useful in more aggressively finding and deleting near-duplicates.  Click it, then click the Help button in the sheet which appears for more info.

## BookMacster 1.15.4 (2013-06-12)

This update brings BookMacsters 1.15 out of beta and into production.  If you already have BookMacster 1.15.3 beta, you should skip this version because there is nothing new.

BookMacster 1.15.x updates your existing documents and other data produced with earlier versions.  If you are syncing a Bookmarkshelf Document among multiple Macs via, for example, Dropbox, you should run, or else will be asked to run, BookMacster's *Check for Update* on each Mac.  For any older Macs running macOS 10.5, you will update to a new compatible legacy version, BookMacster 1.6.14.  It is also available now.

Here are the changes since 1.14.10…

* Contains Version 294 of our Firefox Extension…
  * **Required for operation with Firefox version 22**, which [Mozilla has scheduled for release on **June 25**](https://blog.mozilla.org/addons/2013/06/03/compatibility-for-firefox-22/).
  *  Bookmarks' *visit count* is no longer imported from nor exported to Firefox.
  *  Under the hood, uses a new interface for Firefox Live Bookmarks.  (Firefox 22 no longer has the old interface.)

* Contains a long-overdue reorganization and rewriting of the *Help Book*, with a focus on making it easy for new users to configure BookMacster.

* Eliminates spurious resyncs that sometimes caused BookMacster agents to run two or three times after changing a bookmark, as various web browsers on users' various Macs chimed in with their *two cents*.  (We seem to have peeled the last five layers off of that onion.)

* Workers no longer wait for Dropox activity to quiet down before commencing work.  (This is not necessary with recent versions of Dropbox.)

* For current users, the first time that this version is run, it cleans out some cruft from Application Support files.  (identifiers associated with Clients that are no longer in use, including non-profiled Chrome and related browsers, which were created before multiple profiles in these browsers were supported)

* If the user types text into the *Quick Search* field, which causes the Content Outline to automatically switch into *Table Mode* to show search results, it now automatically switches back into *Outline Mode* if the user clears the *Quick Search* field.

* Firefox' *Smart Search Bookmarks* are now only exported to Firefox and Camino.  (They don't work in other browsers, either because these other browsers do not store their Smart Searches as bookmarks, or their bookmarks do not support the Keyword/Shortcut/Nickname attribute which is necessary to use them).

* Attempting to open a document which is in the Dropbox cache of trashed documents now succeeds, and shows a warning with a Help button, instead of failing with Error 1538022.  This reduces user confusion if a document is trashed from the Dropbox on a second computer.  It would still show up in *File* > *Open Recent* in the first computer, with something like *(deleted 95d803a…6e338e)* appended to its name, but because of the error it could not be opened and deleted in the normal way using *File* > *Close and Delete*.  So the user had to figure out where it was and delete it by other means if they wanted a clean *Open Recent* subenu.

* The *visit count* attribute of bookmarks is no longer imported from nor exported to Firefox.  (This feature has been problematic, so we've now embraced Mozilla's model that the *visit count* which users see in Firefox is the number of times that the bookmark has been visited *in Firefox*.  The *visit count* in BookMacster is the number of times that the bookmark has been visited in BookMacster, and Camino and OmniWeb, if BookMacster is syncing them.)

* Fixed a bug which caused tags from the previously-inspected item to remain in the *Tags* field of the Inspector, and possibly tag the next-inspected item, if the user activated a different window or application without first de-activating the Tags field by clicking in a different field or hitting the 'tab' key.

* Fixed a bug, introduced in BookMacster 1.14.x, which caused setting a Client with the advanced *Other Macintosh User Account* feature to fail if the required drive was not already mounted with the required privileges.  (CocoaPrivilegedHelperTool had been built with wrong task definitions.)

* Now ignores a rare anomaly which caused export to Chrome to fail with Error 264085.

* Fixed a bug which caused the account name to be omitted in some views where it should be appended to *Delicious*, *Diigo*, *Pinboard* or *Google Bookmarks*.

* If bookmarks are deleted during a Verify operation, BookMacster now continues gracefully, without throwing any exceptions or logging any errors to the system console.

* Allows more time for iCloud to finish its work during user-initiated import or export operations. (Changed timeout from 15 to 25 seconds.)

* In Bookmarkshelf window, Settings ▸ Clients, fixed bug which caused the "+" (Add New Client) button to be disabled if all known clients had already been added.  This prevented the Advanced client types (new accounts of web service clients, *Choose File*, or *Other Macintosh User Account*) from being added.

* When exporting and importing XBEL files, now writes and reads unique identifiers as metadata elements, so that XBEL files may be repeatedly synchronized with changes tracked and properly counted, just like regular clients.

* Improved wording in the warning sheet which asks, upon closing a document which has syncing *paused*, whether or not to resume syncing.

* Improved recovery suggestion if an error occurs because Chrome or Firefox becomes unresponsive during an export operation.

* Improved the instructions displayed if user has multiple Chrome profiles, and BookMacster needs to export to Chrome while Chrome is running, because the user has synced Chrome bookmarks to a Google account, but the required profile has not been loaded into Chrome since it was launched.

* No longer logs *Internal Error 855-9207* to the system console when exporting to a browser both an unexportable (to that Client) item, and a deleted item in the same folder.

* If, during an export operation, user is presented with a sheet asking permission to quit a web browser, and user responds *Cancel*, a follow-up sheet announcing *Internal Error 524857* no longer appears.

* If, during an export operation, user is presented with a sheet asking permission to log out of a Google account so that BookMacster may log in to a different Google account, and user responds *Cancel*, a follow-up sheet announcing *Error 54266* no longer appears.

* More reliably removes unopenable documents from File ▸ Open Recent.

* If user attempts to visit a JavaScript bookmarklet in BookMacster, BookMacster now beeps instead of logging *Internal Error 324-6754*.

* No longer logs an exception if user somehow clicks or doubleclicks in, possibly the column header of one of the tables or outlines, and BookMacster thinks that user wants to visit that as if it were a bookmark.  (We couldn't reproduce this, but we received an error report from a user indicating that it happened somehow.)

## BookMacster 1.14.10 (2013-04-27)

* Implemented several measures which greatly reduce spurious change detections, which in turn reduces the frequency with which BookMacster silently resolves sync conflicts between web browser Clients, which in turn reduces the probability that deleted or renamed bookmarks might reappear or have their names changed back.  These changes also reduce Agent activity.
  
* Fixed a bug which could cause exported changes in bookmarks order, or new bookmarks, to not appear in other devices in user's iCloud.

* A setting has been added in Preferences > Syncing for setting the number of minutes to wait before importing changes from web browser Clients.  Previously this had been a hidden preference.  The default value remains 4-5 minutes but it may now be set to a lower values.

* Sync Snapshots are no longer added to the rolling archive prior to imports, or after exports.  Sync Snapshots are still archived *prior to exports*.

## BookMacster 1.14.9 (2013-04-25 to Alpha)

* Worker no longer waits for Dropbox activity to cease if the Bookmarkshelf document file being processed is not in the user's Dropbox folder.

* Improved algorithm for detecting Dropbox activity, to reduce false detections and delayed exports.

* Smart Bookmarks with *Shortcuts* (*Keyword* in Firefox, *Nickname* in Opera) now show their shortcut in the Inspector instead of *Not applicable*.

* If the Safe Sync Limit is exceeded during an Import or Export which was manually commanded by the user, while Agents are active in a document, the warning is still shown but Agents are no longer paused.

* The secondary error which can occur if a primary error causes Agents to be paused while other Worker processes are waiting their turn to perform, resulting in *agent or trigger could not be found* when this other Worker is freed to run, has now been silenced.

* Updated the open source Sparkle *Check for Update* framework.

## BookMacster 1.14.8 (2013-04-18)

* Fixed a bug which caused, during exports to OmniWeb, existing separators to be treated as new and float to the top of their folders.

* In a document's Settings > Clients, in the popup menus for selecting web browser Clients, menu items representing Clients which are already members of the current document are now disabled.  (This worked until recently but possibly was broken after a recent update of macOS.)

* Restored ability to visit a single bookmark from the Status Menulet, which appears to have been broken in BookMacster 1.14.4.

* Fixed a bug which caused BookMacster to hang when using *One-Time Import* or *One-Time Export* > Choose File (Advanced) if the File Format chosen was *Chrome* or *Firefox*.

* The Help Book page which is displayed after user clicks the *?* button in the *Manage Browser Add-ons* window now shows more prominently what are the *Toolbar Buttons* and *Menu Items* that BookMacster extensions can provide in Chrome and Firefox.

* If Firefox or Chrome stop responding for some reason while BookMacster is exporting to them, the error presented now explains this in plain English, and also includes a recovery suggestion (to retry the export).

## BookMacster 1.14.5 (2013-04-15)

* Restored application and document icons which were omitted from version 1.14.4.

## BookMacster 1.14.4 (2013-04-15)

* When adding a new bookmark to BookMacster [directly](https://sheepsystems.com/bookmacster/HelpBook/useDirectly), now scrolls if necessary to reveal the new bookmark in the Content View.

* The *Content View* and the *Tag Cloud* are now more likely to *do what I mean* when the user hits the *tab* key.

* Several versions ago, we made exporting to a browser or profile whose bookmarks had not been created by the web browser yet *just work*.  This did not work for the [Chromium[(http://www.chromium.org/Home) or [Canary](https://www.google.com/intl/en/chrome/browser/canary.html) relatives of Google Chrome.  Now it does.

* Fixed a bug which caused BookMacster to hang while installing the Chrome Extension (which usually occurs silently during a first export to Chrome) if Chrome's preference file does not contain at least an empty extension list.

* Fixed a bug, introduced in BookMacster 1.14.3, which caused migrating from Bookdog to fail while importing bookmarks from a web browser.

* Doubleclicking a folder or bookmark in the Content View now works as expected.  Prior to BookMacster 1.14, if the item was a folder, this resulted in visiting all descendants at all levels (after a warning if there were alot), or visiting the bookmark if the item was a bookmark.  Since BookMacster 1.14, nothing happened.  In this version, it works as it did prior to 1.14, except that if the item is a folder, the potential visits are now only the immediate children of the folder.  So now it works the same as the *Visit all NN bookmarks* item in BookMacter's Dock, Status, Anywhere and contextual menus.

* Increased the time allowed macOS to install or remove some agents from 2-3 seconds to 35 seconds, and no longer displays a dire warning advising user to restart the computer if macOS exceeds this time, if the user is running macOS 10.8.3 or later.  This is because Apple has apparently improved the behavior such that when the launchd process becomes nonresponsive, it seems to repair itself after some time, so there is no need for a restart.

* Fixed a bug which would cause an import to hang when doing a *One-Time Import*, if the document had no permanent clients, and the imported bookmarks contained one or more separator items.

* Error Code 1005, *same merge data as prior, no changes*, is no longer added to the error logs seen in main menu > BookMacster > Logs > Errors, because it is in fact not an error at all.

## BookMacster 1.14.3 (2013-03-27)

This version contains two fixes which affect new users.  If you have BookMacster 1.14.2, and if your Firefox and Chrome extensions are either not needed or already installed and working, you should skip this version.

* When quitting Firefox after installing or uninstalling our Firefox extension, BookMacster longer tells Firefox to close its windows first.  This seems to prevent triggering an [apparent bug in Firefox](https://bugzilla.mozilla.org/show_bug.cgi?id=855869) which, about half the time, causes it to incorrectly display a "Well, this is embarassing.  Firefox is having trouble…" page the next time that Firefox is launched.

* Fixed a bug which could cause web browser extensions from being installed during the first export to a new client.

## BookMacster 1.14.2 (2013-03-27)

* Package now contains proper, latest version 85 of SheepSystemsNPAPIPlugin.

## BookMacster 1.14.1 (2013-03-27)

* Fixed a bug which had been causing bookmarks to *churn* (same bookmarks to be deleted and then re-added, resulting in no net change) during an import from recent versions of Google Chrome, if the last export had occurred when Google Chrome was not running, if bookmarks had been moved or deleted prior to that export.  This would sometimes cause an additional export, if Agents were syncing with Chrome.

* If a bookmark is imported or entered with a URL whose scheme is "https" and whose port is 443, the port 443 is now immediately removed as part of BookMacster's URL normalization.  This reduces churn when exporting to Google Chrome, because Google Chrome does the same thing.

* Updated our Chrome Extension to version 16, and Plugin to version 85.  This was done to fix misbehavior which affected users of Chrome Canary, which was caused by these components' inability to distinguish between Chrome and Chrome Canary during some interapplication communications.

* The following changes resulted from simplifying the routines BookMacster runs in order to install web browser add-ons (extensions and plugins for Firefox, Chrome, Canary, Chromium).

  * Fixed a bug which prevented automatic installation of BookMacster's Chrome extension into Chrome profiles other than the Default *First User* profile.

  * No longer attempts to automaticaly reinstall a browser add-on if it fails during an import or export.  Error is presented to the user instead.

  * If an add-on Install, Uninstall, or Test is commanded while other operations such as Import or Export are in progress, now shows a sheet instructing the user to try again later instead of queueing the command to be performed after other operations are done.

* Now exports certain rare bookmarks with invalid URLs which had previously been found to cause problems if exported to Firefox or Chrome.  We have recently learned that they do not cause problems in current versions of Firefox or Chrome.

* No longer presents an error dialog (codes 651106, 228402) if a system call returns an inexplicable error while BookMacster is querying for Dropbox activity.

* No longer prints error messages (labels 361-2251, 361-2252) to the console any time BookMacster is running while Firefox is activated, if BookMacster's Firefox extension is not installed.

* Now exports rare bookmarks with certain invalid URLs, such as *http://foo.bar/#baz#/* (which has conflated *path* and *fragment* parts.  Previously, bookmarks such as this were found to cause problems when exported to Chrome )or Firefox, but now they don't.

* Updated sec. 3.0.2 of Help Book.

## BookMacster 1.14 (2013-03-19 to Beta)

We made this a *beta* release because it contains some new features only.  There are no significant bugs in BookMacster at this time, and it is playing nicely with current versions of all the web browsing apps and services which it supports.

* Added capability to visit all bookmarks in a folder, opening multiple tabs or windows, depending on users' preferences in the web browser.  This new feature is exposed in several places…

  * Submenus representing folders in the Status Menulet, Dock Menu, and *Anywhere Menu* now have a menu item, to *Visit all N Bookmarks*.

  * In contextual menus, and in the Inspector's *gear* menu, the *Visit* menu items are now enabled if the selection contains any folders whose immediate children contain bookmarks which have the relevant URL type, and these bookmarks are included in the items visited when the menu item is clicked.

* In contextual menus, and in the Inspector's *gear* menu, the *Move to…* menu items now funtions as expected, deleting the subject item(s) from their original location, even if the new location is in another document.  Drag and drop still complies with Apple Human Interface guidelines, however, always performing a *copy* operation and not deleting the item(s) from their original location if the drop location is in another document, regardless of the *option* key being down or not.

* How BookMacster magically transfers License Information automatically to users' other Macs is now explained in Sec. 6.1 of the Help Book.

* Changes were made to BookMacster's plugin installer, to ensure that BookMacster's plugin is allowed to load in Google Chrome, Chrome Canary and Chromium even if some inadvertent combination of security settings and the first web page opened would tend to disallow it.  The changes are…
  * During plugin installation, BookMacster now switches ON its plugin's *Always allowed* setting, in every installed profile of Google Chrome, Canary, and Chromium.
  * During plugin uninstallation, BookMacster cleans (removes) this setting.
  * Both processes, plugin installation and uninstallation, now quit Chrome, Canary and Chromium automatically, instead of reminding the user to do it later.

## BookMacster 1.13.6 (2013-03-12)

* Whether or not the profile name is displayed after the Client name *Firefox* or *Chrome* is now consistent between Firefox and Chrome.  In both cases, the profile name is displayed only if there is a non-default profile currently in use in the browser, in the relevant Macintosh account.

* Fixed a bug which would cause a bookmark which was imported from Safari, manually moved to a different folder in BookMacster, and then later exported back to Safari to sometimes be deleted later, if iCloud - *Safari* or *Bookmarks* syncing had been on.

* Fixed a bug which sometimes caused the Chrome Extension to not be fully installed, and therefore subsequent exports to require quitting Chrome, Chrome Canary or Chromium, even if Chrome profile was not signed in to Google.  Any such incomplete installations will be rectified during the first such export after this update is installed.

* The *Browser Widgets* section of the *Adding* tab of the *Preferences* window has been replaced with a single button, which opens the *Manage Browser Add-Ons* window, where these settings now reside.

* The *Manage Browser Add-Ons* has been reorganized to reflect the fact that the Plugin is no longer used for Firefox, and also to support install/uninstall the browser *Toolbar Buttons* and *Menu Items*, which previously resided in *Preferences* > *Adding*.  Also,…
  * More time is now allotted for the port in the browser to open, so that the test always succeeds on the first click now, unless there actually *is* a problem.
  * A *Refresh* button has been added.
  * The *Installed Version / Error* column now also states whether or not an extension is loaded, instead of only what version is installed.
  * The buttons respond faster in many cases because unnecessary delays, launches and quits of browsers have been eliminated.

* The Chrome Extension (*Sheep Sypstems Chrome Extension*) has been split into two separate extensions, now named *BookMacster Sync* and *BookMacster Button*, and the Plugin (SheepSystemsNPAPIPlugin) has been updated to version 84.  *BookMacster Button* is installed or not depending on whether or not the user wants the button in Chrome's toolbar to send web pages to BookMacster directly.  The split was necessary in order to support this option independently in different Chrome User Profiles.  The new components have the following improvements…
  * They conform to Google's latest [Content Security Policy](http://developer.chrome.com/extensions/contentSecurityPolicy.html), and have adopted [Manifest Version 2](http://developer.chrome.com/extensions/manifestVersion.html).  Therefore, they will continue to function in versions of Chrome released after September 2013.
  * Agent syncs are now triggered as expected when the Client is a Chrome profile other than the Default *First user* profile.
  * Installing the Toolbar Button (formerly called *Bookmarking Widget*) in one profile no longer installs it on all profiles, although updating it updates it on all profiles.
  * Now supports import/export with multiple Chrome profiles without relaunching Chrome, provided that all required profiles have been open in Chrome since launching.  (The latter requirement is due to limitations and bugs in Google Chrome, which we have reported to Google's Chrome team.)
  * Fixed a bug which could cause SheepSystemsNPAPIPlugin to crash if the companion Chrome Extension had not been fully installed.

* Fixed a bug wherein, if a Chrome profile is signed in to the Google cloud, and an export to this profile using BookMacster's cloud-friendly style failed for some reason, the export might be retried using BookMacster's cloud-unfriendly method.  This would cause some unexpected results; for example, deleted items would be restored immediately by the Google cloud.

* If Chrome is launched in the background, by a BookMacster Worker, in order to accept an export (which is necessary when the profile is signed in to Google), there is now a 10 second delay before quitting Chrome, to allow the Google cloud time to begin syncing whatever changes we made to other devices.  Previously, the delay only occurred if the export was was from the BookMacster main application.

* When BookMacster is quit, if any document's sync status has been switched to *Paused*, a sheet now reminds the user to resume syncing if desired.  Previously, this reminder only appeared if the document window was closed before quitting.

* Fixed a bug which caused tags for a bookmark to not be restored properly after saving and then re-opening a document, if the bookmark only had one tag and if that one tag had only a single ASCII character, such as "A".

* Fixed a bug which caused an exception to be raised when exporting to a Chromium or Canary client which was created with a version prior to BookMacster 1.13.3.  The problem was that BookMacster 1.13.3 needed to update clients of Chrome, Canary and Chromium for compatibility with multiple profiles, but only did so for Chrome.  Old Chromium and Canary clients are now updated too.

* Tag ↔ Folder Mappings now take precedence over Export Exclusions, so that remapped bookmarks in an unexported folder are still remapped and exported as expected.

* Tag ↔ Folder Mappings now work as expected even if applied to bookmarks that are simultaneously being relocated for some other reason during an Import or Export.

* The following improvements were made to the little icons which appear in the Content View and Duplicates View…

  * The icons' tooltips, which were supposedly added in BookMacster 1.13.1, are now visible; that is, they actually work.  Also, the tooltips indicating Tag ↔ Folder Mappings now state the name of the Client, Tag, Folder, and operation (Import or Export) to which they apply.

  * The single icon indicating indicating Tag ↔ Folder Mapping has been replaced with four more specific icons which specify whether the Mapping is Folder to Tag or vice versa, and whether for Import or Export.

  * The icon indicating that an item has an Export Exclusion in effect now appears or disappears immediately after an Export Exclusion is set or cleared in the Inspector, instead of remaining until its window is reactivated.

* Eliminated some performance bottlenecks which could cause a noticeable pause when activating BookMacster or visiting a bookmark.  (The root cause of these small pauses was the same as that which caused the big pauses that were fixed in version 1.13.4.)

* Fixed a bug which caused bookmarks to churn during syncing if Opera was a Client, with its *Import items marked "Show on bookmarks bar" into Bookmarks Bar* Advanced Setting switched on, and if there were one or more other Clients ahead of Opera in the list, and if one or more bookmarks had *Show on bookmarks bar* switched on in its *Properties* in Opera, one of whose ancestor folders also had *Show on bookmarks bar* switched on.

* Applied several patches to a bug wherein, occasionally, the *Export Exclusions* drawer of the Inspector opened with no checkboxes in it, or else the checkboxes were ineffective, and the only way to rectify this was to quit and relaunch BookMacster.  We think the root cause may be in macOS, but it happens too rarely to nail it as we would like to.

* Fixed a bug which caused the sheet indicating that a sync job had been staged to hang around after the job had actually started, instead of being replaced by a sheet indicating that the job was in process, and the *Stop Agents, Workers* menu item to sometimes indicate *Orphaned Semaphore*.

* Fixed a bug which caused subsequent Imports, or Exports to a given Client, to be skipped because of *no changes* if the previous two such operations in fact failed due to Error 57460, until some other change in Content or Clients occurred.  This was because the change was incorrectly registered as though the operation had succeeded.

* Added a hidden preference for skipping the check that Bookwatchdog is not a login item whenever BookMacster launches.  This is for people whose System Preferences are not working properly but don't want to bother fixing it.  To activate this preference, in Terminal.app enter the command "defaults write com.sheepsystems.BookMacster skipBookwatchdogCheck -bool true".

* Errors which occur due to BookMacster ensuring that Bookdog is not a Login Item, including Error 144762, are no longer displayed to the user, although they are still logged in BookMacster > Logs.

* Fixed a bug which caused Error 144762 to in some cases be presented without its underlying error.

* In the Content View, if a column is set to show *Clients*, the several clients always now appear in the same alphabetical order instead of in random order.

* In Logs > Messages, a misleading entry that a web browser had been "quit" no longer appears if the browser was only seen as "quit" because it had not been running to begin with.

## BookMacster 1.13.5 (2013-02-11)

* Fixed a bug, which has apparently been around since 1.12.3 in October/November, that prevented the Plugin in our Chrome Add-On from working properly in macOS 10.6 or 10.7.  BookMacster 1.13.5 contains a new Plugin, version 83.

## BookMacster 1.13.4 (2013-02-09)

This version is a performance fix, primarily for new users who have imported from or exported to Google Chrome and are organizing their bookmarks.  Existing users should consider *Skip This Version*.  If you are experiencing slow loading and scrolling, change the column headings in your bookmarks views (Content, etc.) to display anything other than *Clients*.

* Fixed slow scrolling and performance lag which started in version 1.13.2, when using the Bookmarkshelf window, and displaying bookmarks with one of the columns set to display *Clients*, if one of the clients was Google Chrome.

## BookMacster 1.13.3 (2013-02-08)

* Fixed a bug in version 1.13.2 which prevented existing Bookmarkshelf documents with Google Chrome clients created with very old versions of BookMacster from opening.

## BookMacster 1.13.2 (2013-02-07)

* Now supports [multiple user profiles in Google Chrome](http://support.google.com/chrome/bin/answer.py?hl=en&answer=2364824), Chromium, and Google Chrome's Canary.  (Chrome Extension has been updated to version 104, and Plugin to 82.)

* Added capability to [switch BookMacster from the foreground into the background](https://sheepsystems.com/bookmacster/HelpBook/backgrounding) (that is, leave it running but hide any windows and remove it from the Dock and ⌘-tab Application Switcher).  Previously, only the reverse was possible.  This new capability is only available when running under macOS 10.7 or later.  (A reminder: People who use BookMacster to sync bookmarks among web browsers need not run BookMacster in the background but best leave BookMacster completely *Quit* when not reorganizing bookmarks.  BookMacster's Agent Workers will run silently as needed to sync.)

* Added capability to [exclude special bookmark types from exports](https://sheepsystems.com/bookmacster/HelpBook/excludeExportSpecial) to designated Client web browsers.

* The popup menus for selecting Client web browsers now include all installed and supported local web browser apps, whether or not their bookmarks files exist, and upon creating such a Client and exporting, BookMacster creates a bookmarks file from scratch which is adopted by the web browser.  (This happens on a new Macintosh user account, if the user configures BookMacster before using that browser enough to create a bookmarks file.  That is, not very often, but our Support Team will appreciate having this *just work*.)

* Fixed a bug which sometimes caused, during an export operation, Google Chrome, Chrome Canary or Chromium to be launched in the background momentarily even if Google's Chrome Sync was not in use.

* Fixed a bug which could cause a crash after executing a one-time export (*File* > *One-Time Export*) to Google Chrome.

* Fixed a bug which could cause a crash during any of BookMacster's multi-threaded operations, and apparently did cause a  crash for one user who was kind enough to send us a crash report.

* Fixed a bug which would cause a crash when exporting to Google Chrome, Chrome Canary or Chromium if our extension needed to be installed and no 'settings' for any other extensions existed in the preferences file.

* Now gives more informative error information, with a recovery suggestion, when a web browser refuses to quit after being asked repeatedly.

* The graphic at the bottom of the *Settings* > *Agents* > *Simple* tab no longer shows Clients which have neither *Import* nor *Export* switched on.

* Fixed a bug in the *Manage Browser Add-Ons* window which caused Clients with long profile names to display no profile name at all.  The part which fits is now displayed.

## BookMacster 1.13.1 (2013-01-17)

* Improved compatibility with Chrome Sync when exporting to Google Chrome.  Using Chrome Sync, BookMacster's bookmarks syncing capability can now be reliably extended to Google Chrome on Windows PCs, Android or iOS devices.

* Added a new feature, *Tag ↔ Folder Mappings*.  Folders may be designated to receive all bookmarks with a given tag during imports, and/or add a given tag during exports.  Similarly, certain tags may be designated so that bookmarks with them will always be imported and/or exported into a certain folder.

* Minor changes (bookmark names, comments) to bookmarks now *stick* again when exporting to the  Delicious and Pinboard.  (For compatibility with recent deployments of Delicious and Pinboard, now deletes a changed bookmark before uploading the changed version.)

* In Content View, icons indicating *Export Exclusions* now also appear (in a gray color) if an Export Exclusion is in effect due to an item's ancestor.

* In Content View, the icon indicating *Sorted at Top* or *Sorted at Bottom* now appears gray if this setting has no effect because the item's parent folder is currently set to be not sorted.

* In Content View, the icon indicating *Export Exclusions* is better, a dissed green arrow instead of circled black *X*.

* In Content View, all of the little icons in items, such as those mentioned above, now have tooltips to explain their meaning, and the Help page displayed upon clicking the "?" Help Button now has a nice legend which explains all of the icons.

* Fixed a bug which could cause Local Data files to be trashed before their associated Bookmarkshelf document had been missing for 60 days.  This may have been responsible for occasional "Could not open xxxxx.sql" file errors, and also Local Settings to be unavailable if a document was accidentally trashed and then untrashed.

## BookMacster 1.13 (2013-01-05)

* Updated support for Google Chrome bookmarks that are synced with Android devices, so that export operations while such a synced Chrome is not running no longer cause BookMacster to hang in some cases.  Also, any future such failures  will indicate an error instead of hanging.

* Added capability to exclude selected items from being exported to some Client browsers or services.  For example, you can designate that one or more bookmarks or folders not be exported to Safari during any future sync operations.  This is done in the Inspector panel, in a drawer revealed by clicking the *Export Exclusions* button at the bottom.

* Removed the display of item identifiers.  (The drawer which displayed item identifiers now sisplays the new *Export Exclusions*.)

* Added recovery suggestion to Errors 519891 and 519892.

* Upon completion of a Verify operation, the first item in the Content View is now selected and is subject in the Inspector, instead of *No Selection*.

## BookMacster 1.12.9 (2012-12-23)

*  Fixed a bug which could cause the last 2-3 items in a subfolder in BookMacster's Status Menulet submenus, Dock Menu submenus or Anywhere Menu submenus to appear as empty items.

*  Added information to the report users may send when to us Cocoa Error 134030 occurs.

## BookMacster 1.12.8 (2012-12-21)

*  The report which appears in the sheet after a *Consolidate Folders* operation is now presented as a scrollable text view, so that all results are now visible even for new users with large consolidations, and the results are clipboard-copiable for further consideration if desired.

* The icon representing Bookmarkshelf Document files now has a wood shelf underneath the three similing bookmarks, to distinguish documents from the BookMacster application.  (Existing users may not see this until they (a) delete any old versions of BookMacster.app which may be lying around and (b) restart the Mac.

* Fixed a bug which could cause a crash after performing a *Consolicate Folders* operation, and possibly at other times.  (Covered some corner case crashes, a side effect of the optimization which underlays the performance improvements in version 1.12.7.)

* Fixed a bug which caused some obscure functions (refreshing some views after an Undo or Redo operation, for example) to not behave as exppeced after reverting to an older document version using the Versions Browser or *Revert To…* manu item.

## BookMacster 1.12.7 (2012-12-12)

* The *Merge Folders* phase of an import or export operation is no longer noticeable and now typically occurs in the blink of an eye.

* Eliminated beachballing which would start several seconds after opening a document.  For most users, this beachballing was so short that the beachball never appeared.  But it could occur for tens of seconds in rare documents which contained one or more folders with thousands of immediate children.  The time was doubled if the preference to *Show BookMacster status in menu bar* was switched on.

* The display of tags in the Detail View and in the Inspector now shows tags in alpha-numeric order.

* When importing from multiple Clients, and when a Client which does not support separators precedes a Client containing one or more separators, the separators are no longer churned to different positions.

* Fixed a bug which sometimes caused a crash while exporting to Opera.

* Clicking the *Sort At (Top|Normally|Bottom)* contextual menu item now affects only the selected item, and not its children.  Thus, the behavior is the same as when clicking the corresponding regular menu item or keyboard shortcut.

* Fixed a bug which could have caused unnecessary disabling of one or more of the *Have these Hard Folders* checkboxes in the *Settings* > *Structure* tab.

* When a document's Hard Folders are automatically added or removed due to changing of Clients, the changes are now reflected in the checkboxes in the *Structure* tab immediately, instead of not until the document was next reopened.

## BookMacster 1.12.6 (2012-12-03)

* The *Quick Search* field is now accessible via an item in the *Bookmarkshelf* menu, and keyboard shortcut ⌘F.  The keyboard shortcut for *Find*, which was ⌘F, has been changed to ⌥⌘F.

* The Tag Cloud now supports a contextual menu, which facilitates renaming of tags in one simple step.

* When clicking the *Add Quickly* menu items in Firefox provided by our Firefox extension, the explicit implication to *not* show the Inspector panel now overrides the normal behavior specified in Preferences > Adding.

* Fixed two bugs which occasionally caused bookmarks added in web browsers to be missed and thus deleted during syncing, if a user was alternately creating bookmarks in different web browser clients (Safari and Firefox, for example).  One bug allowed a 10-second window, while a syncing Agent was exporting, in which added bookmarks added by the user in Firefox or Chrome would be not synced and eventually deleted.  The other bug was seen more rarely, and could occur with any browser if the user created a bookmark in one browser, then in another, then still another in the first browser.

* Fixed a bug in Tags Autocompletion (which appears in the Content Tab of a document and also in the Inspector window) which caused relevant completions to be omitted, particularly if open documents had a large number of tags.

* Typing a character while focused on the Tag Cloud, if the Tag Cloud is scrollable, now causes the Tag Cloud to scroll to the first tag beginning with the character typed, if any.

* Now gives the Launch Services of macOS a gentle reminder that the BookMacsterize bookmarklet should be directed to BookMacster during each launch, in case it forgets, as it sometimes does.

* Improved robustness of Worker launching (no longer inhibited by zombie processes).

* Now silently fixes the problem if a user manages to get the *Launch in Background* preference switched on while the *Show Status Menu* preference is switched off.

* Fixed a bug which allowed messages in the logs (menu > BookMacster > Logs > Messages) which occurred within a few milliseconds of one another to be timestamped out of order and thus appear out of order.

* Shortened prefix of helper process names (Worker, UrlHandler, etc.) to "Sheep-Sys-".

## BookMacster 1.12.5 (2012-11-13)

* More reliably displays the Inspector panel after landing a new bookmark, as expected, in particular if user adds a bookmark via our Firefox extension, by clicking the *Add & Inspect* menu item in Firefox, not using the ⌤⌥D keyboard shortcut.

* Fixed a bug which could cause adding new bookmarks or synchronizing to fail silently.

* Fixed a bug which could cause a crash if a Worker was triggered while the relevant Bookmarkshelf document was open and user clicked the *Perform Now* button.

## BookMacster 1.12.4 (2012-11-06)

Only affecting Roccat users, and cosmetics update.

* Does not close Roccat windows before quitting Roccat, so that Roccat can restore its open windows and tabs when relaunched.

* Application icon, and most of the toolbar icons, now have high-resolution images for Retina displays.  Also, the bright colors on the latter have been toned down.

## BookMacster 1.12.3 (2012-11-02) (Cumulative)

Changes since version 1.11.9, in all the 1.12.x beta versions, have been accumulated into this section.  Differences since the last beta 1.12.2, are shown in [Incremental Changes for Version 1.12.3](VrsnHstIncrement11221123).

* BookMacster 1.12, and its helper processes, now run as 64-bit processes on 64-bit Intel-based Macs.  BookMacster 1.12 still works on 32-bit Intel Macs and, as before, down to and including macOS 10.6.  PowerPC and macOS 10.5 users are still supported with BookMacster 1.6.x.

* A checkbox has been added to Preferences > Updating, and in the *A new version is available* window, to allow future BookMacster updates to be downloaded and installed automatically.

* Now supports the Runecats [Roccat](http://runecats.com/roccat.html) web browser as a Client.

* When running in macOS 10.8, the *Save As Move* menu item no longer appears in the *File* menu.  This is because, in macOS 10.8, Apple copied our idea and added a *Move To* and *Rename* menus item to the *File* menu in all apps.  They do the same thing as our *Save As Move*.

* Now verifies our digital signature before installing *future* updates, for example, 1.12.4.

* Fixed a bug which caused, when BookMacster is configured to *Launch In Background*, and to show the Inspector when landing a new bookmark, the Inspector would not show the new bookmark.

* During Import and Export operations for syncing, when comparing date attributes of bookmarks to determine if a change has occurred, a tolerance of 2 seconds is now allowed.  This is to eliminate unnecessary churning and uploading of unchanged bookmarks, which has recently started to occur with Pinboard.

* Now closes a dragged .webloc file, so that the Trash can be emptied before quitting BookMacster.

* Fixed a bug which causes adding a bookmark using the Widget in Google Chrome or Firefox, or the BookMacsterize bookmarklet, to fail silently if the web page being bookmarked had one or more doublequote characters in its title, or in the selected text (which becomes the bookmark's Comments).

* When the menu item *Bookmarkshelf* > *Sort All* is disabled because bookmarks are already sorted, its title now helps the user understand by changing to *Bookmarks are all sorted*.

* Similarly, when the menu item *Bookmarkshelf* > *Find Duplicates* is disabled because all duplicates have already been found, its title changes to *See Reports > Duplicates*.

* Now displays an informational sheet explaining the appropriate and inappropriate use cases for *Launch in Background* when the *Launch in Background* preference is switched on.

* Fixed a bug which caused the 10 most recent folders into which new bookmarks had been landed from the Status Menulet (*Recent Landings*) to not appear as they should in the Status Menulet if BookMacster had been launched in the background.

* Fixed a bug which sometimes caused an Import or Export to be skipped because there were supposedly no changes, when in fact there were changes.  One case which triggered this bug was if the only changes were bookmark names.

* Fixed a bug which sometimes caused the Content view to not update after an Import operation until another change was clicked.

* Fixed a few bugs in the way that bookmarks with some very oddball features in their URLs, a *path* part generated using nonstandard character-escape rules , or including *user* and *password* parts, are normalized and hence stored and exported.

* BookMacster is now less aggressive about removing old Local settings files.  This should reduce or eliminate rare occurrences of Error 149034.  Prior to BookMacster 1.12, Error 149034 was reported as 134030.  The change is that, to delete a Loca settings file, in addition to the subject document file having failed to open during the prior application run, it is also now required that no Local settings file for any of the failed document have been modified in the prior 62 days.

* The warning which appears when a new user exports bookmarks to the first time has been reworded to make it even more painfully clear to new users that *Export* to a web browser usually means *bye-bye* to whatever bookmarks were there before the export.

* Added a checking routine to the *Keyboard Shortcuts* preferences, so that it is no longer possible for corrupt preferences to cause BookMacster to hijack ordinary keystrokes from web browsers.

* Methods for accessing bookmarks on *Other Macintosh User Account* have been retested, a couple of possible bugs fixed, and updated to work more reliably within the more restrictive security framework of macOS 10.8.

* Methods for installing License Information for *all users of this Mac* have been updated to work more reliably within the more restrictive security framework of macOS 10.8.

* It is now possible to delete a tag on all bookmarks, as one would expect, by selecting the undesired tag in the Tag Cloud and hitting the 'delete' key.

* When adding a new Opera client, in *Advanced Client Settings*, the checkbox to *Import items marked 'Show on Bookmarks Bar' into Bookmarks Bar is now switched OFF by default instead of ON.

* BookMacster 1.12 is built with the latest Apple developer tools (Xcode 4.5.1, macOS 10.8 SDK)

* Fixed many memory leaks and possible bugs, thanks to the new tools.

* The built-in Sparkle Updater, which provides the *Check for Update* feature, has been updated from version 1.5b5 to version 1.5.


## Incremental Changes from BookMacster 1.12.2 to 1.12.3 [VrsnHstIncrement11221123]

## BookMacster 1.12.3 (2012-11-02)

* A checkbox has been added to Preferences > Updating to control whether or not BookMacster updates are downloaded  and installed automatically.

* Now supports the Runecats [Roccat](http://runecats.com/roccat.html) web browser as a Client.

* Fixed a bug which caused the 10 most recent folders into which new bookmarks had been landed from the Status Menulet (*Recent Landings*) to not appear as they should in the Status Menulet if BookMacster had been launched in the background.

* Fixed a bug which sometimes caused an Import or Export to be skipped because there were supposedly no changes, when in fact there were changes.  One case which triggered this bug was if the only changes were bookmark names.

* Fixed a bug which sometimes caused the Content view to not update after an Import operation until another change was clicked.

* When adding a new Opera client, in *Advanced Client Settings*, the checkbox to *Import items marked 'Show on Bookmarks Bar' into Bookmarks Bar is now switched OFF by default instead of ON.

## BookMacster 1.12.2 (2012-10-22 to Beta)

* Fixed a few bugs in the way that bookmarks with some very oddball features in their URLs, a *path* part generated using nonstandard character-escape rules , or including *user* and *password* parts, are normalized and hence stored and exported.

* Is now less aggressive about removing old Local settings files.  This should reduce or eliminate rare occurrences of Error 149034.  Prior to BookMacster 1.12, Error 149034 was reported as 134030.  The change is that, to delete a Loca settings file, in addition to the subject document file having failed to open during the prior application run, it is also now required that no Local settings file for any of the failed document have been modified in the prior 62 days.

## BookMacster Version 1.12.1 (2012-10-15 to Beta)

* Fixed a bug introduced in version 1.12 which caused failure to launch in macOS 10.6.8.

* Fixed a bug introduced in version 1.12 which caused the *New Bookmark Landing* popup menu to appear empty.

## BookMacster Version 1.12 (2012-10-14 to Beta)

* BookMacster 1.12, and its helper processes, now run as 64-bit processes on 64-bit Intel-based Macs.  BookMacster 1.12 still works on 32-bit Intel Macs and, as before, down to and including macOS 10.6.  PowerPC and macOS 10.5 users are still supported with BookMacster 1.6.x.

* When running in macOS 10.8, the *Save As Move* menu item no longer appears in the *File* menu.  This is because, in macOS 10.8, Apple copied our idea and added a *Move To* menu item to the *File* menu in all apps.  It does the same thing as our *Save As Move*.

* Fixed a bug which caused, when BookMacster is configured to *Launch In Background*, and to show the Inspector when landing a new bookmark, the Inspector would not show the new bookmark.

* During Import and Export operations for syncing, when comparing date attributes of bookmarks to determine if a change has occurred, a tolerance of 2 seconds is now allowed.  This is to eliminate unnecessary churning and uploading of unchanged bookmarks, which has recently started to occur with Pinboard.

* Now closes a dragged .webloc file, so that the Trash can be emptied before quitting BookMacster.

* Fixed a bug which causes adding a bookmark using the Widget in Google Chrome or Firefox, or the BookMacsterize bookmarklet, to fail silently if the web page being bookmarked had one or more doublequote characters in its title, or in the selected text (which becomes the bookmark's Comments).

* When the menu item *Bookmarkshelf* > *Sort All* is disabled because bookmarks are already sorted, its title now helps the user understand by changing to *Bookmarks are all sorted*.

* Similarly, when the menu item *Bookmarkshelf* > *Find Duplicates* is disabled because all duplicates have already been found, its title changes to *See Reports > Duplicates*.
* Now displays an informational sheet explaining the appropriate and inappropriate use cases for *Launch in Background* when the *Launch in Background* preference is switched on.

* The warning which appears when a new user exports bookmarks to the first time has been reworded to make it even more painfully clear to new users that *Export* to a web browser usually means *bye-bye* to whatever bookmarks were there before the export.

* Added a checking routine to the *Keyboard Shortcuts* preferences, so that it is no longer possible for corrupt preferences to cause BookMacster to hijack ordinary keystrokes from web browsers.

* Methods for accessing bookmarks on *Other Macintosh User Account* have been retested, a couple of possible bugs fixed, and updated to work more reliably within the more restrictive security framework of macOS 10.8.

* Methods for installing License Information for *all users of this Mac* have been updated to work more reliably within the more restrictive security framework of macOS 10.8.

* BookMacster 1.12 is built with the latest Apple developer tools (Xcode 4.5.1, macOS 10.8 SDK)

* Fixed many memory leaks and possible bugs, thanks to the new tools.

* It is now possible to delete a tag on all bookmarks, as one would expect, by selecting the undesired tag in the Tag Cloud and hitting the 'delete' key.

* Updated the Sparkle Updater from version 1.5b5 to version 1.5.  Among other improvements, this version adds security by verifying future updates with our digital signature.


## BookMacster Version 1.11.9 (2012-07-28)

* Fixed a bug which could cause items in Safari Reading List to not be exported properly to Safari 6.x.

* Fixed a bug which caused a New Bookmarkshelf to be created without a *Reading/Unsorted* hard folder if the Safari minor version number was 0, such as, eeek, Safari 6.0.

* Now properly imports and exports tags containing space characters with Delicious.  The tag delimiter for Delicious has recently changed from the *space* character to the *comma*.  Our thanks to the un-named Delicious engineer who was sick and out of the office yesterday, but fixed the resulting break in the Delicious API from his home after we reported that it was not behaving as required by this change!

* Fixed a bug which caused a long entry to sometimes be written to the console log after a Bookmarkshelf document was deleted by clicking in the menu *File* > *Close and Delete*.

## BookMacster Version 1.11.8 (2012-07-25)

There are no changes in this version.  We just upped the rev number to indicate that it was packaged with Apple's new *Developer ID*, which allows it to run in macOS 10.8 Mountain Lion.

## BookMacster Version 1.11.7 (2012-07-20)

This update, together with 1.11.6 released on the Beta channel last week, improve a couple of the facilities for *tagging* bookmarks, and there are some little bug fixes.

* An autocompletion menu now attaches to the *Tags* field in the Inspector, and the *Detail* field above the Content Outline, when it is switched to display Tags.  (It displays a menu of matching tags used on other bookmarks, like the way that the address fields in Mail.app suggest entries from your Address Book as you type an email address.)

## BookMacster Version 1.11.6 (2012-07-14)

* Most fields in the Inspector, and the Tags field above the Content Outline, now smartly handle selections of multiple items, instead of displaying an uneditable *Multiple Selection* placeholder.  This means that, for example, multiple items may now be rated by selecting all of them and clicking the desired star in the Inspector.  Tags are treated individually, so that desired tags may be added or removed from all items in a selection of bookmarks, without affecting other, existing tags.

* The Inspector no longer floats above other applications after landing a new bookmark from a web browser.  (The old behavior was a poor workaround for the fact that macOS activates BookMacster unconditionally after it receives a 'land new bookmark' URL event from a web browser.  This version has a proper workaround, a tiny helper which receives the URL event, and forwards it to BookMacster without necessarily activating BookMacster.)

* The warning which appears during an export if Google Chrome's built-in bookmarks syncing is enabled now notes that this is OK under some conditions, and displays a checkbox for disabling future warnings, and this checkbox is also available in Clients > Advanced Settings for Chrome/Chromium/Canary clients.

* Menu items in BookMacster's *Anywhere Menu*, *Status Menulet* and *Dock Menu* (which are folder and bookmark names) now truncate with an ellipsis at 64 characters instead of 32, so users can see more of the names.

* Re-fixed a bug which could cause the later bookmark addition or change to be ignored, if a BookMacster Agent was configured to sync multiple browsers, and a bookmark was added in a second browser quickly after adding a bookmark in a first browser.

* Fixed a bug which caused some minor misbehaviors when performing Import, Export, Sort, Verify, Find Duplicates or Save operations manually.  The problem was that in some cases, BookMacster thought that it was performing the operation for a Worker or script instead of manually.  This is a subtle difference, and the only misbehavior we know of is that, if iCloud had hung and prevented BookMacster from importing or exporting, BookMacster would hang and not give up and inform the user for 20 minutes, instead of 15 seconds.  But this bug could have been causing other misbehaviors.

## BookMacster Version 1.11.5 (2012-06-26)

This update is primarily for new users' installing the Chrome extension.  Current users who want the new feature described in the first item below, or are synchronizing with Pinboard, should install this update.  Other current users may reasonably skip this update. 

* Added capability to add a new bookmark into a *New Subfolder* when adding via the Status Menulet, Dock Menu or Global Keyboard Shortcut (*Anywhere Menu*).  This appears as a *… into new subfolder…* menu item under the *Add here* menu item.

* Updated method of exporting to Pinboard to eliminate HTTP Error 429 indications which started due to a recent change at Pinboard.  (Now only requests the posts/update time once during the conclusion of an Export operation instead of twice.)

* Updated method for installating Chrome extension, for compatibility with Chrome 21.  The good news is that the new method (*External Extension*, which is actually old but was incorrectly implemented in macOS until Chrome 16) has fewer moving parts, and does not require annoying user interaction.

* Our Chrome Extension has been updated to version 103, for compatibility with Chrome 21.  Actually, the old extension will still work, but it cannot be reinstalled.  The only substantive change is to eliminate a warning printed to Chrome's JavaScript Console when Chrome is launched, when our Bookmarking Widget is disabled.   (Previous versions masked the widget declaration by assigning it to an undefined key.  This version provides two extensions, for with/without widget.)

## BookMacster Version 1.11.4 (2012-06-15)

* When an Import or Export with Chrome or Firefox is interrupted by the necessity of installing a Browser Add-On, the third button option, to *Retry*, has been removed.  (It did not work properly and to fix it would have introduced unwarranted complexity.)

* Fixed a bug, introduced in BookMacster 1.11, which caused the *Delete* button in the Reports > Duplicates tab of a Bookmarkshelf document to usually fail.

* Now supports *Google Canary* (nightly builds of Google Chrome) as a Client, for Import and Export.

* Restored capability to export Firefox Smart Search Bookmarks to Firefox, which may have been broken in a recent update, and also now detects and exports a broader range of Firefox Smart Search Bookmarks.

## BookMacster Version 1.11.3 (2012-06-12 to Beta)

* No longer reshuffles items when importing from a Client which does not support ordering of bookmarks (Delicious, Diigo, Google Bookmarks, Pinboard).

* Fixed a bug which caused the Status Bar and Sync Logs to falsely indicate that changes in bookmark locations (parent folder, order/position) were being exported to Clients which do not support bookmark locations (Delicious, Diigo, Google Bookmarks, Pinboard).

* Fixed a bug which caused misreading of item positions when importing from or exporting to Opera with the Advanced Setting : Special Settings for Opera : *Import items marked "Show on Personal Bar" into Bookmarks Bar* switched on.  This would cause postion changes to be tallied when there were in fact no changes, and eventually, a spurious *Sync Fight* to be detected, which was reported to the user as an error, and further caused shut down of the user's Agents as a precaution.

* Fixed a bug which caused quitting of Bookwatchdog to usually fail and be reported as a success.

* If an Export to Firefox is interrupted by the necessity of installing our Firefox Extension, the export is now actually executed, as indicated, after the extension is installed.

* The *Pause/Resume Syncing* menu item now changes to *Syncing is not set up* when applicable, instead of *Set Up Syncing*, which was misleading.

* Fixed a bug which caused a trigger to disappear immediately after setting it in the Advanced Agents tab, if Clients included a local Client which could be watched *live* for changes (Safari, Firefox Chrome) but had its *Import* switched off, and was followed by another local Client which cannot be so watched (Camino, Opera, etc.) that had its *Import* switched on.

## BookMacster Version 1.11.2 (2012-05-28)

* Fixed a bug which could cause an exception to be raised, and a spurious "not able to save" message written to the system console, as BookMacster discarded a document for some reason, for example, the user clicking in the menu *File* > *Close and Delete*.

* Fixed a bug which could cause an import to be instead retried repeatedly after using clicked *Cancel* when an import was interrupted for installation of a browser Add-On (extension or plug-in).

* Fixed a bug which could cause bookmarks to not be imported during an Import operation after installing a browser Add-On (extension or plug-in).

* Fixed a bug which caused the first new document created by a new user to sometimes be created in a temporary folder.

* Fixed a bug which could cause a "deadlock" to be logged to system console if user clicked *Retry* more than once when performing an Import or Export operation.

* Fixed a bug, introduced in BoolkMacster 1.11,  which caused a crash when clicking the *Perform Now* button in the *Settings* > *Agents* > *Advanced* tab.

## BookMacster Version 1.11.1 (2012-05-23)

* The Inspector now has a *Rating (Stars)* field for bookmarks and folders.  (Ability to access star ratings from a column in the Content outline, and ability to rate multiple items at once has not been implemented yet.)

* In a document's *Settings* > *Sorting*, and in the *Sort Now, by ▸* contextual menu item, an option to sort by *Rating (Stars)* has been added.

* The sorting operation executed by the *Sort All* operation, and also the *Sort Now, by ▸* contextual menu item, now further sort items which have the same value for the selected *sort by* attribute.  The further sorting is done firstly by type (folder or bookmark), then if those are the same, by name, then if those are the same, by rating (stars), then by URL, and finally by an internal unique identifier, which is guaranteed to work.  Thus, sorting results are now always repeatable.

* The *Sort Now, by ▸* contextual menu item is now also available in the main menu under *Selection*.

* Fixed the client *advanced settings* (gear) buttons which were broken in BookMacster 1.11.

* A preference control has been added (in the *General* tag)  for adjusting the number of web pages that may be visited at once without a warning dialog.

* The warning which appears if a Safe Limit is exceeded during an Import or Export operation no longer incorrectly states that *Syncing has been disabled* if syncing was not enabled to begin with.

* Fixed a bug which prevented export of bookmarks to Firefox, Chrome, Chromium, Diigo, Google Bookmarks and Pinboard if the matching bookmark in the Client had no URL.  Although bookmarks with no URLs should generally not occur in these Clients to begin with, BookMacster is now able to repair them.

## BookMacster Version 1.11 (2012-05-17)

This update has many bug fixes, and performance, robustness and efficiency improvements, particularly in the area of syncing web browsers.  The changes are largely under the hood.  There are a few visible new features, mostly to make syncing easier to configure.  It also accomodates recent changes with Delicious, Google Bookmarks, Diigo, and Pinboard.

If you are not using BookMacster as a syncing tool among Clients, but are bookmarking *directly* with BookMacster (using its Status Menulet, *Anywhere* Menu (global hotkey), etc., and if BookMacster has been working well for you, you may want to skip this update.  We'll be giving your use case some love in a future version.

The package incudes new versions of our Firefox Extension, Chrome Plug-In, and Chrome Extension.  If you are using any of these, you will be asked to approve updating them upon launching this version for the first time.

LIST OF CHANGES

* The *Sync*/*Pause*/*Resume* button in the toolbar of a Bookmarkshelf window now always has the same title, *Syncing*, and it now responds appropriately in various corner cases if syncing is paused and syncing agent(s) are removed.

* A preference to keep recent *Snapshots* of Clients' bookmarks data has been added.

* A new preference tab, *Syncing*, has been added to accomodate the new *Snapshots* preference, and several others which were formerly in the *General* tab.

* When exporting to Chrome or Firefox while they are running, BookMacster no longer needs to re-import after the export to check and make sure that no one edited bookmarks during the export.  (For Chrome, a quick comparison is still done silently by a Worker, but it is faster and cheaper.  If new changes are found, the re-import is staged and later proceeds as usual.)

* Now yields to iCloud activity to finish before *reading* Safari bookmarks.  Previous versions only yielded for iCloud before *writing* Safari bookmarks.  (An *Import* involves reading only; an *Export* involves first reading, then writing.)  The advantage of the additional yields is that we can eliminate a subsequent re-sync, or at least a re-read, by not reading in bookmarks that are in the midst of actual, or at least spurious, changes.

* Yielding to iCloud, Sync Services or Safari activity is now smarter.  BookMacster now waits until 8-12 seconds after iCloud activity ceases, will not retrigger if iCloud changes bookmarks repeatedly, and the user interface no longer beachballs during the yield or the final wait.

* In the main menu, *File*, the *Quick Import* item has been retitled to the more meaningful *Import from one Client*, and similarly *Quick Export* item has been retitled to *One-Time Export*.  Also, intead of having two menu items for each existing Client, with two different behaviors, suffixed with the non-obvious *(Quick)* and *(Client Settings)* there is now only one menu item for each client.  After clicking an item for which the choice of behaviors is available, a dialog sheet appears, with two radio buttons explaining the two choices. 

* When syncing bookmarks, each export now checks to see if some other process seems to be fighting with BookMacster by repeatedly changing back the changes correctly exported by BookMacster during previous exports, and if such a fight is detected, disables syncing and displays an error message which has links to help resolve the issue.

* A new menu item, *Stop Workers, Agents*, has been added to the application (*BookMacster*) menu, replacing the two menu items, *Active Agents* and *Force Quit Agents' Workers*.

* *Auto Import* is automatically switched off when the user configures an Agent to automatically import a Client's changes, and switching on Auto Import while such an Agent is configured is not allowed.  In either case, a warning is displayed in a sheet, explaining that there is no need for Auto Import if changes are being continuously imported.  (Auto Import in this case just caused a delay and head-scratching when a document was opened.)

* The *Auto Import* and *Auto Export* options are no longer switched on automatically when creating a New Bookmarkshelf document having only one Client.  Users desiring these options for a document must now find the checkboxes in Settings > Open/Save and switch them on explicitly.  They are still switched on automatically when creating a new Bookmarkshelf from Bookdog, if user indicates to have separate document(s) for each Client.

* A bookmark's tags are no longer merged together during imports or exports with the current Delicious service.  (The problem was caused by Delicious recently changing the *delimiter* character which separates tags from the space character " " to the comma, ",".)

* Tags containing commas are now imported and exported without being split, as they were before Diigo changed their protocol recently.  (Changed the tag delimiter character for Diigo from comma "," to doublequote, """.)

* Exporting to Diigo now works properly if only the attributes of a bookmark other than URL (Name, Tags, Comments) are changed, because BookMacster now works around the bug in Diigo's system by deleting each bookmark before re-uploading the one with updated attributes.  Unfortunately, this means that such exports to Diigo take twice as long.  Bug has been reported to Diigo's Bug Reporter.

* Fixed a bug, which occurred when using the *Fabricate Tags* feature during an export, which caused unmatched tags in the destination to remain instead of being deleted.

* Several changes were made to get performance improvements when editing large, flat Bookmarkshelf documents that have a one or more collections containing hundreds or thousands of items.  Not many people keep their bookmarks this way, but they can happen if managing bookmarks a web service only, or sometimes with new users.  100X speed improvements and 100X less peak memory usage were achieved in some pathological cases involving several thousands of bookmarks in one folder.

* The performance penalty imposed by Tags when importing Firefox bookmarks is now insignificant.  The time required to import Firefox bookmarks with 3 tags per bookmark have been reduced by about half.

* The *Comments* field in the Inspector panel now scrolls vertically if necessary to show long comments.

* The *Help* menu has been reorganized, a *Video Tutorials* item has been added and the *Log Alias Records* item has been removed.

* Now always keeps tags in alphabetical order, and coalesces duplicate tags in a case-insensitive manner instead of case-sensitive.  This was done to mirror the behavior of Firefox, and eliminates a condition wherein if different bookmarks had the same tag with different cases, for example *politics* and *Politics*, because Firefox stores the same tag for multiple bookmarks, choosing one at random, BookMacster agents would re-sync every time Firefox changed them, and if there were many such bookmarks the resulting random walk would likely never show zero changes and thus never end, resulting in excessive sync activity.  In BookMacster now, when tags must be coalesced because of case insensitivity, the tag with the first uppercase character is deleted.  For example, a bookmark which is created or imported with two tags "brownDOG" and "Browndog" will have these tags coalesced into "brownDOG" because the other one has the first uppercase character.  **When an existing Bookmarkshelf document is opened in this version of BookMacster, tags will be coalesced in this way and the document will be saved.**

* When exporting to Firefox, BookMacster now enforces the restriction that bookmarks with equivalent normalized URLs must have the same tags.  This is to prevent the same kind of excessive syncing as explained in the previous item.

* Fixed a bug which caused each bookmark in a duplicate (URL) group of N bookmarks to be exported with N tags to each of its tags, instead of 1, when exporting to Firefox while Firefox was not running.

* No longer synchronizes the rare hidden client-proprietary attributes of items between Macs during imports and exports.  Hidden client-proprietary attributes are, for example, *Last Modified Date* in Google Chrome which is, oddly, only used for folders, the "Use as Dock Menu" checkbox in Camino, the Check (Verify) frequency setting in OmniWeb, and several items in Opera.  This was done to simplify syncing operations and to eliminate syncing operations caused by some browsers' uncontrollable editing of these attributes, such as Google Chrome's editing *Date Added* when *it* perceives an addition.  These attributes are still preserved when Exporting to a web browser; they're just no longer stored in the Bookmarkshelf Document, nor in BookMacster's Local Settings, and no longer propagated to the same browser on other Macs via, for example, Dropbox.

* Fixed a bug which caused an unnecesary re-import for changes after exporting if a *Export Changes from Other Macs to Clients* trigger/agent was active.

* Whenever a non-trivial error occurs, or whenever an Import or Export operation exceeds its Safe Sync Limit, all Agents associated in the document are immediately paused, or removed (if it happens to a Worker).  A message stating what happened and how to resume syncing is appended to the end of the error or warning which is presented to the user.

* In the dialog which appears when an Agent's Worker stops because a Safe Limit was exceeded, the *Retry* button has been removed and replaced with an *Open* button.  This is because, per the previous change, the Agent has been automatically removed and thus retrying is not possible.  Instead, the user is advised to *Open* the document, then manually retry the import or export.

* Fixed a bug which caused Google account login to be incorrectly detected if the local-part of an email address contained a dot, such as *firstname.lastname@gmail.com*.  It would complain that you were already logged in with lastname@gmail.com, and want to log out and back in, which worked, but was unnecessary.

* Fixed a bug which could cause a crash if user clicked *Cancel* during the *New Bookmarkshelf* wizard.

* When exporting to Firefox from a Bookmarkshelf document which is open in BookMacster, warns the user if the export is expected to take more than 1 minute, because Firefox is running, and advises the user that they can greatly speed up the process by quitting Firefox first.  If such an export is attempted by an Agent, skips the export and presents an error message to the user.  (On a typical Mac, this will only happen if number of bookmarks being changed is in the thousands, which may occur when configuring syncing, but should rarely occur during regular syncs.)

* Fixed a bug which caused (rare) trailing slashes on *path* components of URLs to be trimmed whenever a bookmark was imported, exported or created.

* BookMacster now compensates for the fact that Google Chrome, for some reason, replaces rare nonbreaking spaces (+U00A0) in bookmark names with regular ASCII spaces (+U0020) when accepting exports, and also coalesces consecutive ASCII spaces in names into one, so that these artifacts no longer cause *churn* and extra imports and exports when syncing.

* Fixed a bug which caused bookmarks to *churn*, and extra imports and exports when syncing, if a rare bookmark which is not exportable to all of the configured Clients in a Bookmarkshelf is placed into a folder that also has exportable bookmark(s) at higher indexes, when an import from a Client to which it is not exportable executes.

* When a web app, such as Pinboard, rejects an export because a bookmark has too much text (in its Name, Comments or whatever), the error message now better explains how to fix it.

* Increased the minimum time interval between imports of all bookmarks from Pinboard from two minutes to five minutes, in accordance with the latest Pinboard API.  (Note: Imports of all bookmarks do not occur unless bookmarks are changed by another app, such as the Pinboard web app, because BookMacster keeps a local cache.)

* Fixed a bug in the method for exporting to Firefox, when Firefox is not running, so that it is now compatible with Firefox 12, and future versions of Firefox.  Prior to this update, one of the annotation values for the *All Places* hard folder was written as it was in previous versions of Firefox, which is different than that expected by Firefox 12.  After such an export, when Firefox was launched later, it would apparently flag the incorrect value as a file corruption, and replace all of the hard folders with new items.  This would cause an unnecessary import if a BookMacster Agent was watching for changes in Firefox.  In fact, there was no need for BookMacster to even touch these annotation values during an export, and now it does not.

* Includes a new version 288 of our Firefox extension.  The improvements in this version are:  (1) Maybe some performance improvements exporting to Firefox while Firefox is running; unfortunately most of the slowness is due to Firefox.  (2) Fixed a bug which caused *Bookmarks Changed* triggers from Firefox to silently fail if the Firefox profile name was not the *default* profile.  (3) No longer notifies BookMacster that bookmarks were changed during an export.  (We can get away with this as long as Firefox bookmarks management remains single-threaded.)  (4) Does not notify BookMacster of bookmarks changes if user has not activated a syncing Agent which needs the information.  (5) No longer causes an error to be logged to the JavaScript Error Console by declaring the SheepSysBinXPCOM Component which was removed several versions ago.

* Includes a new version 101 of our Plug-In for Google Chrome.  The improvements in this version are (1) Notifies BookMacster of what the changes were when bookmarks are changed, instead of just saying that something changed.  (2) Does not notify BookMacster of bookmarks changes if user has not activated a syncing Agent which needs the information.  (3) When a large number of bookmarks changes are exported to Google Chrome while Chrome and BookMacster are running, it now periodically feeds progress information back to BookMacster, so that the progress indicator in the Status Bar at the bottom of the Bookmarkshelf window now indicates truthfully instead of staying stuck at 5% until finished.  (Previously, we had only implemented this feature for Firefox, because Chrome is usually quick enough that no one notices.)

* Includes a new version 81 of our Plug-In for Google Chrome.  The improvements in this version are:  (1) No longer crashes if the user launches Chrome while our Plug-In and Extension are duly installed, cripples the system by uninstalling BookMacster's Chrome Extension, without quitting Chrome, and then performs an Import, Export, or Browser Add-on Test with Chrome.  (2) No longer crashes on rare occasions when a web browser is quit.  (3) Supports progress feedback discussed in the previous item.  (4) Is now based on FireBreath version 1.6, updated from 1.4.  (We don't know of any bugs that were fixed by doing this, but [The FireBreath Project](http://firebreath.org) says it's better and more stable.)

* Reduces file cruft in BookMacter's Application Support directory.  When a Bookmarkshelf document is trashed using *File* > *Close and Delete*, or cannot be found when an Agent needs it, besides de-activating Agents, BookMacster now, also, trashes the associated Local Data files (Exids, Settings, Diaries) in Application Support.  In addition, two minutes after each launch, BookMacster scans its Application Support directory and trashes any Local Data files whose documents are no longer known.

* Fixed a bug which sometimes caused the "View" button in the dialog presented when BookMacster's background Worker encounters an error to have no effect.

* When closing a document, when *Auto Export* is active, if user switches on the *Switch off Auto Export* checkbox and then clicks *Close*, Auto Export is actually switched off the next time the document is reopened.

* Fixed a bug which caused the temporary Client created during an *One-Time Export* as an *Overlay* (formerly *(QuickMerge)* to sometimes not be deleted as expected after the operation was completed.  The undeleted Client was apparent in the *Settings* > *Clients tab and may have caused other weird behavior later.

* The *Would you like to see the Help for Getting Started?* sheet is no longer displayed when a new Bookmarkshelf document is created.  Instead, this is shown automatically when a new user uses BookMacster for the first time, or when a new *Getting Started* item in the *Help* menu is clicked.

* The *Messages* view in the *Logs* window (main menu > *BookMacster* > *Logs…*) is a finished product and now has the features one would expect in such a view…  (1) It has a text search field.  (2) The newest entry now appears at the bottom instead of the top, and it keeps scrolled to the bottom, showing new entries, unless the user has scrolled up.  (3) Text of selected entries may be copied to the clipboard with the standard *Edit* > *Copy* command.

* Fixed a bug which caused the *Fabricate Tags* feature in export to not fabricate any tags in existing bookmarks which had no other attribute changes.

* Fixed a syncing bug which created a one-minute window, beginning 0-60 seconds after changing a bookmark, wherein if user changed another bookmark, the second change would propagate to BookMacster on the other Mac but not to its Client web browsers.  It was propagated during the next change, but if an change was made on the other Mac in the meantime, this second change (new bookmark or whatever) might be lost.

* Additional triggers (such as bookmarks being changed in browsers) to perform for the same agent whose performance is currently queued are now ignored, since it would not make sense to repeat it.  This avoids compounding of errors when Clients decline to cooperate with BookMacster's Imports or accept Exports for some reason.

* When BookMacster's Worker launches BookMacster to display duplicates found, or display an error message, BookMacster now skips opening any Bookmarkshelf Document which had been set to open, and skips opening the *Welcome – What do you want to do?* window, even if user's preference is set to do so normally.

* Fixed a bug which caused Imports to *merge* bookmarks, even if the content of the Bookmarkshelf, the content of the Client being imported, and the relevant Import settings were all unchanged since the previous merge.  (Such a merge operation will have no effect and is unnecessary.)

* Agents triggered by a scheduled time, browser quitting, or bookmarks changes arriving via Dropbox or other Online File Syncing Service are now re-created each time they are used.  This might work around a bug in macOS' launchd program and result in more reliable operation.  In any case, it is more robust.

* Fixed several bugs which sometimes caused messages indicating *launchctl: Couldn't stat*, *Already loaded* and/or *nothing found to unload* to be logged to the system Console during Import or Export (syncing) operations.

* Fixed a bug whereby if Advanced Agents were in use, and if the only syncing agent was triggered by *Other Mac Updates This File*, and there were no *Bookmarks Changed* or *Browser Quit* triggers, the user interface would indicate and behave as though syncing was not active.

* Fixed a bug which, during an export, caused BookMacster to erroneously report that Firefox or Chrome were running and prompt the user to (re)install the browser Add-on, if Firefox or Chrome had in fact been running when the export *started* but had actually been quit before the merged data was ready to be piped into the Add-on.

* Eliminated some unnecessary re-imports when syncing via Dropbox or other Online File Syncing Service, if Chromium or Google Chrome is a Client.  (This is a product of the next item.)

* Fixed a bug which could cause the sheet indicating that *An Agent's Worker is currently syncing possible changes…* sheet to get stuck on if an error dialog was not responded to immediately; the only way to get rid of it was to force quit BookMacster later.

* Fixed a bug which caused lots of things to not work, and memory to be leaked, if user clicked *Browse All Versions* in the Bookmarkshelf document's title bar, then clicked *Done* in order to keep the current version, unless the current version had itself been previously restored from the Versions Browser.

* Fixed a bug which could cause a crash if operations commanded by buttons in the *Manage Browser Add-Ons* window were performed in certain sequences with other operations involving Browser Add-Ons.  Here's one example.  (1) Export to Chrome or Firefox while it is running.  (2) Click the button to *Test* that browser/profile's Add-On.  (3) Export again.  (4) Test again.

* If an Import or Export fails because Firefox or some other app has locked the Firefox bookmarks database, the error presentation now states this and explains that the solution is to wait a bit and then retry.

* Operations commanded by buttons in the *Manage Browser Add-Ons* window (Install/Update, Uninstall, Test) are now delayed if necessary until other Bookmarkshelf operations (Import, Export, etc.) are completed, eliminating any wacky behavior which could be caused by these operations stepping on one another.

* When importing from or exporting to Chromium or Google Chrome, the bookmark attributes *Last Modified Date* and *Date Added* are no longer mapped into the corresponding fields in BookMacster, and thus no longer synchronized to other Clients which support these fields, or Chromium/Chrome Clients on other Macs to which the Bookmarkshelf is synced.  Instead, these attributes are ignored during an import and passed under the hood during an export.  (We did this for *Date Added* because the Chrome/Chromium API does not allow us to update *Date Added*, but instead updates it uncontrollably whenever we merely change any other attribute.  We did this for *Last Modified Date* because Chrome/Chromium only supports it for folders.  Properly handling these two quirks would require complexity which is obviously unwarranted.)

* Added several checks to improve behavior if corruptions are encountered in a Firefox bookmarks file.

* Fixed a bug which could cause a crash if Firefox or Chrome failed to respond during an Import or Export operation and user clicked *Cancel* in the resulting error dialog.

* No longer fails to install plug-in for Chrome if the ~/Library/Internet Plug-Ins folder is missing, as could happen on a new Macintosh user account.

* If Google Chrome or Firefox hang instead of installing a browser extension when BookMacster asks them to, BookMacster no longer hangs with them but recovers.

* If an import or export which is being performed in BookMacster was initiated by an Agent, and is delayed due to Safari or iCloud editing bookmarks, the timeout before an error message is presented is now 20 minutes, the same as if the operation is being performed in a background Worker, instead of 15 seconds, which is the timeout for such operations initiated by the user.

* The timeout which allows syncing by Agents to ultimately recover after an Import or Export is interrupted by an exception or crash now works when the BookMacster main app is running too.

* Changing a Client to a different Client has been added as one of the conditions which prompts the user to Export if an affected Agent is active.

* Internal mechanisms for installing Firefox and Chrome Extensions and Plug-In (Add-ons) have been simplified and improved.  (1) There is no more 3-second delay before *Test* success is indicated.  (2) Corrected a condition wherein if installing the Firefox or Chrome Add-on from the Manage Browser Add-ons failed, the error would not be displayed and the spinner would continue spinning.

* Fixed a bug which caused the sheet instructing how to install the Chrome Add-On to hang open indefinitely if, prior to installing the Chrome Add-On, the Extension was already installed but maybe not working, and/or the Plugin was not installed or not working.

* More reliably quits stubborn web browsers when required.  (Instead of just waiting for the browser to quit for until a timeout occurs, now repeatedly sends a 'quit' AppleEvent every 1 second.  This has been found to be particularl effective with Firefox.)

* Slightly faster (20% for 1000+ bookmarks) during the *Reading Firefox…* phase of an Import operation.

* Fixed a bug which caused an export to Firefox or Chrome to be repeated twice instead of once if it failed originally because the browser was running and the browser add-on was not installed or not working.

* Fixed a bug which could cause Internal Error 309-9284 to be logged to the system console, particularly when setting some Advanced Agents, and possibly other misbehavior by newly-set Advanced Agents.

* Fixed a bug which which would cause a Bookmarkshelf window to belatedly close if user commanded the window to close while syncing was paused, clicked *Resume syncing*, and then *later* clicked the *Syncing* button again (to re-pause syncing).  This is because we were trying to handle two user commands at once, Resume and Close.  Now, if Close is interrupted by Resume, we forget about Close.

* The warning to make sure that a Bookmarkshelf document is in a Dropbox folder or similar synced folder is no longer shown (again) if user commands the window to close while syncing was paused and clicks *Resume syncing*.

* Hard folders (Bar, Menu, Reading/Unsorted, My Shared Bookmarks) added after a Bookmarkshelf document is initially created now appear at the top of the root collection, in that order, the same as if they had been created by the New Bookmarkshelf wizard.

* Fixed a bug which caused false changes indicating that items were moved *into (null)* to appear in the Sync Log, and re-imports to occur when syncing, if a an Import Client had items
in a Hard Folder which does not exist in the Bookmarkshelf's structure.  (This condition would not occur if a Bookmarkshelf is configured automatically using the New Bookmarkshelf wizard or Clients added, but only if Hard Folders are switched off manually in Settings > Structure.  So it probably never occurred in the wild.)

* Fixed a bug which caused items whose attributes were update, and were also either *moved* or *slid*, to not appear in the Sync Log.

* Error  now logs more complete error information.

* Error 513560, which occurs when a local Logs, Settings, or Sync Log file cannot be saved, is no longer displayed to the user.

* Pushing to iCloud now stops trying if the iCloud mechanism in macOS fails to respond and the user clicks *Ignore*.

* When agents cannot be added to a document because there are *No Local Clients*, instead of just displaying that text, the Simple Agents tab of a Bookmarkshelf document now says *No Local Clients.  Add Clients first.*  Also, it displays an *Add Clients* button, which reveals the Clients tab when clicked. 

* When a new user creates a first Bookmarkshelf document, the user is not asked to approve the default name, and the default name no longer has the suffix "-01".

* The blue suffix, *Welcome Start Here…* on the menu item *File* > *New Bookmarkshelf* now disappears after the user has created one, instead of persisting until BookMacster is quit for the first time.

* Improved error recovery in case the iCloud mechanism in macOS is not working as expected for some reason.  If user clicks *Ignore* when presented with the error, BookMacster now stops trying to invoke iCloud; if user clicks to give it more time, BookMacster now attempts to re-enable the mechanism in macOS.  Also, the helper tool no longer crashes if macOS does not give an appropriate response in some situations.

* The warning indicating that *The action you have just taken affects Agent's syncing …* and imploring user to *Export* no longer appears when adding a Trigger or changing the type of a Trigger to a type which does not constitute syncing, or upon removing any Trigger.

* Fixed a small memory leak which occurred whenever an *alert* panel or sheet was displayed.

* Entries in BookMacster > Logs have been improved, to be more concise and informative (as always).

## BookMacster Version 1.10.1 (2012-02-24)

* Fixed a bug introduced in 1.10 which caused Error 57460 when new bookmarks are imported from Pinboard, Delicious or Diigo.


## BookMacster Version 1.10 (2012-02-24)

SUMMARY.  This update is important for anyone using BookMacster with Pinboard, syncing Google Chrome bookmarks to an Android device, using *Smart Search* bookmarks in Firefox, or using BookMacster to sync with Camino, iCab, OmniWeb, or Opera.  For users synchronizing browser bookmarks with the Agents feature, it improves performance and simplifies the experience, particularly for new users, by adding a button to the toolbar.  It also adds AppleScriptability for landing new bookmarks from applications such as NetNewsWire, and many little bugs have been fixed.

The following list shows all the changes since the last production release, 1.9.7.  Beta testers may scroll down to see the changes from [1.9.8 to 1.9.9](betaChanges1_9_8to1_9_9) or from [1.9.9 to 1.10](betaChanges1_9_9to1_10).

* A *Sync* button has been added to the toolbar, and the initial Export required when activating syncing is now prompted.  Thus, new users with common syncing requirements such as *Keep my Safari and Firefox bookmarks synchronized* should be able configure BookMacster correctly without reading the *Getting Started* page in the Help Book.

* Added an AppleScript command: *land new bookmark*.  BookMacster can now land new bookmarks directly from other AppleScriptable applications such as NetNewsWire.  A sample AppleScript for NetNewsWire is [posted on our forum](https://sheepsystems.com/discuss/YaBB.pl?num=1329484256)

* Now plays properly with Pinboard's new protocol for getting all bookmarks.  HTTP Error 429 is no longer displayed after importing from Pinboard.

* Added a Preference to truncate the length of *Comments* when landing a new bookmark from another application.  (This is necessary because comments coming in from the internet via, for example, NetNewsWire, are otherwise uncontrolled.  The default value is 180 characters.)

* The *Tag Delimiter Replacement* is now a user preference (in the *General* tab) and may be changed from its default value of "_", the underscore character.

* Does a better job of identifying items in Imports and Exports with Pinboard.  (Pinboard has apparently eliminated some URL normalizations, so that, for example, bookmarks with pathless URLs, with and without a trailing slash, for example, http://apple.com/ and http://apple.com, are allowed in Pinboard as two distinct bookmarks.)

* Avoids some unnecessary downloading of all bookmarks from Delicious or Pinboard.  (BookMacster no longer registers that changes were exported if in fact not only the export but merging was skipped because there were no changes in either the Bookmarkshelf or the Client since the last merge, which resulted in no changes to export.)

* No longer alphabetizes all bookmarks when importing only from Client(s) which do not recognize ordering, such as Delicious, Pinboard, Diigo and/or Google Bookmarks.

* Exports to Chrome when Chrome is not running now ignore and preserve Chrome's *Mobile Bookmarks*, which Chrome syncs to Android devices.

* Fixed a bug which caused failure to import Pinboard or Delicious bookmarks if the very *first* character in any attribute of any bookmark was an ASCII control character.  The failure appeared as Error 65 in NSXMLParserErrorDomain.

* Now properly handles throttling responses from the Pinboard server, and the Bookmark Request parameters (*Initial Time Interval*, *Rest Time Interval*, and *Backoff Factor* appear in the *Advanced Settings* sheet for Pinboard Clients.  Pinboard Clients in existing documents will have these values set to their minimums, which do not work well if Pinboard decides to throttle during an Import or Export.  Accordingly, if such values are found when a document is opened, they are changed to appropriate values and saved in Local Settings.

* *Smart Search* Bookmarks imported from Firefox are no longer omitted when later exporting to Firefox.  (The "q=%s" key/value pair in the query portion which makes them invalid URLs is now ignored.)

* Eliminated re-importing from Safari after exporting to Safari, if the Bookmarkshelf Content had any folders in its Reading/Unsorted.  (Fixed a bug which caused BookMacster to erroneously think that folders had been moved into the Reading List.  In fact, they were not moved into the Reading List, because Safari does not allow folders in its Reading List.  The erroneous conclusion would cause a BookMacster Agent to re-import repeatedly if iCloud Bookmarks Syncing was activated.)

* Improved user experience if an Agent's Worker begins work while user is editing a Bookmarkshelf document.  This can occur if user had edited bookmarks in a Client a few minutes earlier, or if a Client changes its bookmarks or quits, or if another syncing actor such as iCloud suddenly decides to do a sync.  Instead of the automatic import and other actions commencing abruptly and interrupting the user, a warning sheet is now presented in most cases, giving the user the opportunity to either cancel or accelerate the process while it is still staged, and after it starts, another sheet prevents the user from editing during the actions.

* Before a manually-initiated Export, a warning that bookmarks will be modified in Clients, and the inconvenience of undoing an export, is presented to the user.  Experienced users may disable this warning.

* A tad less resource usage, and no more logging of failure by *launchctl* during some operations by Agents.  (No longer attempts to unload a *standby* agent which has not been loaded.)

* Whenever a Bookmarkshelf Document is opened, now checks that macOS launchd agents are in sync with the document's Agents, and installs, uninstalls, loads or unloads as required.

* Now displays a warning upon user entering duplicate triggers, which is possible when using Advanced Agents view.

* If the Client of a Client-based Trigger is changed from a Client which does not support observing changes when it is running (such as Camino, iCab, Opera or OmniWeb) to a Client which does support observing such changes (such as Safari, Firefox, or Chrome), the trigger type is now automatically changed from *Browser Quit* to *Bookmarks Changed*.  And vice versa, so that the changed Client now has the most appropriate trigger type.   (Although it is possible to have a *Browser Quit* trigger for one of the latter browsers, the *Bookmarks Changed* trigger is better, and we want to use the best one because the trigger type is not visible in the Simple Agents view which is that seen by most users.)

* The *Switch off Auto Export* checkbox in the Auto Export warning dialog now works even if the *Cancel* button is clicked.

* When an Agent is configured to sync Clients, and is set to import from a Client which, by design, cannot participate in syncs while it is running (Opera, OmniWeb, Camino, or iCab), and this Client is above some other Client in the list, and if a new bookmark is added to this other Client while the non-participatory Client is running, the new bookmark is no longer deleted in a subsequent sync when the non-participatory Client browser is quit.

* Fixed a bug which would cause changes made in BookMacster, or imported from other browsers, to be not exported to Camino, iCab, OmniWeb or Opera if these browsers were running during the export, and if additional bookmarks changes were made in these browsers before they were quit.

* When activating or changing Local Settings (Clients, Agents) to sync bookmarks, the requirement to Export is now prompted and enforced by presenting the user a dialog sheet and requiring the user to either Export immediately, or temporarily *Pause* syncing.

* Improved automatic conflict resolution when bookmarks are changed in another browser Client before BookMacster has imported pending changes from a first browser Client.

* Fixed a bug which caused Tag changes which were in fact cancelled out by Delimiter Replacements to be listed as changes in the Sync Log.

* Fixed a bug which caused an import to be skipped, missing changes, if the Client's Content had indeed not changed, but the Content in the Bookmarkshelf had changed (meaning that the old Content should be re-imported), or if the Import Postprocessing (Advanced) Settings had been changed (meaning that the results of the import might be different even if both source and destination Content were unchanged).  Also, this bug did not appear if the import Clients included Firefox and/or Chrome	.

* Eliminated some extra Import and Export operations which would sometimes occur when spurious changes were detected during the prior Import or Export.  These appeared in the Sync Log as *CHANGE* in *proprietary attribute(s)*.  Although all Clients may have been affected in a few cases, the churn was most prevalent if Opera was involved, and particiularly upon the initial export to Opera.
 
* Fixed a bug which caused a spurious Error 384005 to sometimes be logged and displayed if an Agent's Worker ran to sync multiple Clients while BookMacster was running with the subject Bookmarkshelf open.

* Fixed a bug which caused error 613902 *Apple's iCloud is currently syncing your bookmarks* to be unnecessarily indicated if iCloud had been syncing when first probed, but had actually finished within the allotted time.

* Fixed a bug which sometimes caused unnecessary do-over Agent operations in Bookmarkshelf documents that have multiple local Clients.  (Fixed random crosstalk among import hashes.)

* Resource usage during exports to Safari has been reduced.  (Now takes advantage of file locking, so that BookMacster-Worker is no longer retriggered after an export to Safari for a short run to recheck hashes for any changes made during the export.)

* Fixed a bug which caused the *Local Settings* controls (Clients, Agents, etc.) to have no effect if these were changed after prior version of a Bookmarkshelf document had been resurrected from Lion's Versions Browser, until it was closed and re-opened.

* During Import operations from a single Client, items which are not exportable to this Client, and thus were not exported to it, and thus absent from the Import, no longer move to the top.  This could cause a rather large number of extraneous changes, or *churn* as we call it, in large folders wherein many siblings would be displaced.

* Fixed a cosmetic bug in the Bookmarkshelf window that sometimes caused buttons in a sheet to be moved on top of other controls when there was no need to do so.  (When a sheet is shown that would overflow the bottom of the screen, BookMacster now takes into account the fact that macOS will animatedly move the window up to accomodate the screen when it calculates if and how far the important buttons in the sheet need to be moved up to stay on-screen.)

* When exporting to Safari, if the *Show [All] Bookmarks* page is showing in Safari, the method by which BookMacster changes this to a blank page and then changes it back to show the bookmarks after the export has been updated so that it works again with the current version of Safari.

* When exporting to Safari, now waits for iCloud activity and file locks to clear even if Safari is not running.  Also, if the Bookmarkshelf window is open, the status bar now indicates indeterminate progress when *Waiting for Safari or iCloud to let go*.

* A change was made which may avoid triggering a sporadic bug which sometimes causes a *Bookmarks Changed* Agent to stop working until it is either recreated, or the user logs out and back in.  (This appears to be a bug in the launchd service of macOS.  The change is that BookMacster's Worker now always exits with status 0.)

* No longer displays Error 19015, because it turns out to be usually a false alarm.

* When exporting to Safari, the timeout for which a Worker process will wait for iCloud to finish its work before giving up has been increased from 10 minutes to 20 minutes, and this longer timeout is now applied also when a Worker commands an open Bookmarkshelf document in the BookMacster app to perform its work.  Previously, the shorter timeout of 15 seconds, which applies when the user commands the export manually in the BookMacster app, had applied to this case.

* If the preference has been set to launch BookMacster in the background, and BookMacster-Worker encounters an error which needs to be displayed, that preference is now disregarded, so that the error can be seen.

* Fixed a bug which caused Google Chrome to be launched and then quit if it was not running, when uninstalling BookMacster's Chrome extension.

* When uninstalling the Chrome extension, if Google Chrome is detected to be running in its broken state wherein it silently ignores a "quit" command even from its own user interface, now just kills it.

* When the Chrome plug-in is not installed, the *Manage Browser Add-Ons* window now correctly indicates it as *not installed* instead of the head-scratching *Version 0*.

* Now accepts any .bookmacsterlicenseinstaller file issued by our server, even if our server generated strange line-ending delimiters when creating the file.

* Fixed a bug which caused warnings to be logged and probably misbehavior of BookMacster's Status Menulet after a license installer file (.bookmacsterlicenseinstaller) had been opened by the user.

* As was originally intended, records of whether folders are expanded or collapsed, for folders which no longer exist in a Bookmarkshelf document, are now deleted from the documents *Settings* database when their document is closed.

* If user insists on closing a Bookmarkshelf document window while operations such as Import, Export or Save are running in the Status Bar, and if an unfulfilled Auto Save operation has been recently requested by macOS Lion, the document now ignores the user's request, instead of hanging and needing to be force quit.

* Fixed a bug which caused .rawdata files, sometimes needed for debugging, to not always be written while importing from Delicious or Pinboard.

### CHANGES IN VERSION 1.10 AFFECTING CHANGES IN BETA VERSION 1.9.9 [betaChanges1_9_9to1_10]

* Fixed a bug which caused tag delimiters which are replaced by the Tag Delimiter Replacement because they are not allowed in the Client to instead be replaced by a decimal number during exports to web app types of Clients.

### CHANGES IN BETA VERSION 1.9.9 AFFECTING CHANGES IN BETA VERSION 1.9.8 [betaChanges1_9_8to1_9_9]

* The new *Sync* button in the toolbar now also functions to open the *Agents* tab and prompt the user to configure syncing, if no syncing agents are available, and its label changes appropriately to *Sync*, *Pause* or *Resume* depending on whether or not a syncing agent is available and whether or not syncing is paused.  In the Main Menu, the two items *Set Up Sync…* and *Pause|Resume Syncing* have been combined into a single menu item that works in the same way.  (Thanks to a beta tester who asked, "Do I click the *Sync* button to *do* a sync?", and to the original Macintosh designers who insisted on that one-button mouse.)

* The new *Sync* button in the toolbar now works properly if Advanced Agents were paused when the document was last closed.  (Shows the correct state, and *Resumes* on the first click).

* But sometimes three buttons are needed.  Added a third button, *It's OK* to the new dialog which appears advising user to Export upon activating an Agent which performs syncing.

* Fixed a bug which caused a crash about half the time upon clicking the *Perform…* button in the tab Settings > Agents > Advanced.


## BookMacster Version 1.9.7 (2012-01-08)

If you've updated to 1.9.6, and don't plan to reconfigure any *Agents* in the forseeable future, you can skip this version.

* Fixed a bug which, randomly, might cause either either the *Import Changes from Clients* agent or the *Export Changes from Other Macs* agent, in a Bookmarkshelf which was configured to do both, to not function when they are first switched on.

## BookMacster Version 1.9.6 (2012-01-08)

* The Help Book now contains an interactive *Syncing Visualizer* to illustrate how BookMacster can sync other browsers' bookmarks via iCloud to Safari on iPhone, iPad and iPod Touch devices.

* Some terminologies have been changed to eliminate confusion between iCloud and other clouds.

* Updated method for verifying Google account login, so that attempting to import from or export to Google Bookmarks no longer fails with Error 54267.  (This problem appears to have started yesterday, due to a change by Google in their service.)

* Improved conflict resolution when local Clients and clients on another Mac synced via Dropbox or other Online File Syncing Service make near-simulatenous changes.

* Fixed a bug which sometimes caused the *Export changes from Other Macs to Clients* agent to fail silently, causing bookmarks changes synced via Dropbox or other Online File Syncing Service to not always appear in the expected client browsers as expected.

* If a Bookmarkshelf has Agents watching for multiple triggers, such as changes in multiple web browser clients, and multiple triggers occur before the Worker runs in response to the first trigger, the jobs are now combined and the Worker only runs once, resulting in the changes being made properly based on Client order, and, obviously, less resource usage.

* Fixed a bug which, in multi-Client Bookmarkshelf Documents, caused imports from earlier Clients to be skipped if the last Client had no changes.

* Fixed a bug which caused an import to be silently skipped if changes were made manually to a Bookmarkshelf Document's Content but no changes were made to the Client's content, or if Content was changed by restoring an Auto Saved Version in macOS Lion, or if Content was changed by an Undo or Redo action, since the last import from that client.

* Fixed a bug which caused a hang while installing Chrome extension if Chrome happened to be displaying its *Extensions* window.

* Fixed a bug which caused installing Chrome extension or Firefox extension to sometimes silently abort before anything was done.

* Fixed a bug which would cause BookMacster's Worker to crash if the Agent for which it had been invoked was deleted between the time the Worker was triggered and the time it  ran (usually 1-5 minutes later).

* Removing or deactivating an Agent by switching off its checkbox always works now.  (Besides killing the regular Agent, this action now kills any transient Agents which have have been staged, and any associated Workers which are currently executing.)

* Importing, or not, of Separators from Clients now consistently works as specified in *BookMacster Help* (sec. 5.2.8).

* Restored operation of the filter which prevents Bookmarkshelf documents in the Dropbox trash (.dropbox.cache) folder from being opened.  (This safety feature had stopped working with Dropbox 2.x.)

* If the text views on a sheet extend beyond the bottom of the display, as can occur for example when showing the results of a *Consolidate Folders* operation on newly-imported bookmarks which had never been managed, the buttons and other critical controls are now moved up so that they are visible.

* Updated instructions given for disabling the bookmarks sync feature which is built in to Google Chrome, to reflect the user interface in current versions of Google Chrome.

* In BookMacster's AppleScript dictionary, removed the *force import all* parameter from the *perform* command.   An operation now executes for all triggers if  the optional *for trigger* parameter is simply omitted.  Also, it now works properly.

* New version of Google Chrome Extension gives better error reporting.

* Fixed two images in the Help Book, the BookMacster icon on the title page, and the *Getting Started* diagram in sec. 0.1.1, so that they now display properly in all browsers.  (The first had size metadata which did not reflect the actual size, and the second was a pdf, which is not compliant to the HTML standard.  They worked in Safari and Help Viewer, but not in Google Chrome or Camino, for example.)

## BookMacster Version 1.9.4 (2011-12-10)

If your BookMacster add-on or extension for Firefox and Chrome are installed OK at this time, or if everything worked fine during your last BookMacster update, you should skip this update.

* Fixed a bug which caused failure to install Firefox or Chrome extension in some cases.

## BookMacster Version 1.9.3 (2011-12-09)

This version has bug fixes, performance improvements, and improvements to user experience.

* Fixed two bugs in process of installing Chrome and Firefox extensions; if an error occurred during the first attempt, subsequent attempts would also fail, displaying the same old error, until BookMacster was quit and relaunched.

* BookMacster no longer causes Firefox to beachball by asking it for all bookmarks once during each Import operation and once during each Export operation.  Although the beachball duration was less than a second with the typical 1000 bookmarks on most Macs, it seemed to increase exponentially with an exponent of 2 or so, as a function of the number of bookmarks, and became quite annoying at 4,000 bookmarks.  (Now uses our *faster but unofficial* method of reading Firefox bookmarks while Firefox is running.  This method works consistently now because we no longer support Firefox 3.6.)

* Includes a new version of the Sheep Systems Firefox Extension, version 284, which no longer causes Firefox to be very slow and beachball if the user manually does something which moves, deletes or restores a large number of bookmarks in Firefox' *Library* window which is displayed upon clicking *Show All Bookmarks* in Firefox.  (Notifications of bookmarks content changes to BookMacster are now coalesced and throttled.)

* When importing settings from Bookdog, BookMacster no longer creates any Agents based on Bookwatchdog settings.  We've found that, in most cases, users are better off creating new Agents from scratch, rather than importing settings which were compromised by the limited capabilities of Bookwatchdog.  Also, if an initial import failed for some reason, subsequent Agent operations could cause unexpected results, including deleting bookmarks in browsers.  An initial import could fail if a web browser had some settings in Bookdog, but had not been used for a long time, and its bookmarks experienced bit rot.  If this happened to be the last browser imported, the Bookmarkshelf would be empty, and exporting from an empty Bookmarkshelf, by default, causes bookmarks content in the exported-to browsers to reflect that emptiness.  That is, it would delete all bookmarks.  More simply, creating Agents automatically violates the advice we give new non-Bookdog users, which is that BookMacster Agents should not be activated until a user has successfully imported, reviewed and approved their Bookmarkshelf Content, and exported manually.

* When importing from Bookdog, if the import fails for some reason, the Status Bar no longer incorrectly includes failed items in its tally of the number of items imported.

* Fixed a bug which could cause automatic triggering of BookMacster agents to always fail after a system crash or other extraordinary event.  (BookMacster-Worker would crash or choke on defunct *doOver*, *doSoon* or *standby* launch plist files which had been left stranded in ~/Library/LaunchAgents.)

* Fixed a bug which caused an Export to fail when exporting to a *Choose File (Advanced)* Client.

* Replaced  the detailed-but-not-detailed-enough wordiness in presenting Errors 144770 and 264948 with an explicit reminder to click the Help button for more information, and expanded the Help Book sections which these buttons display to include step-by-step instructions.  Instead of trying to please everyone, power users will no longer be annoyed reading a long explanation they don't need, and novice users can get the detailed instructions that they do need.  (144770 occurs when macOS reports a bogus Login Item, and 264948 occurs when Chrome or Firefox get fouled up during installation of a browser Extension.)

* Added some housekeeping for defunct Agents.  (Now removes any associated and defunct Agent plist files whenever any changes to Local Settings are made to a Bookmarkshelf, and whenever a Bookmarkshelf document is saved, in the BookMacster application.)


## BookMacster Version 1.9.2 (2011-12-03)

This update only affects the process of crossgrading from Bookdog, and the *Perform…* button in the Agents > Advanced tab.  Unless you have not done the Bookdog import yet, and plan to, or use that button, which most users don't even know is there, you should skip this update and instead do something more enjoyable.

* Fixed a bug which caused BookMacster to hang during *Reading Safari* if user elected to import Safari settings while importing from Bookdog.

• Fixed a bug which sometimes caused a crash if user entered the Agents > Advanced tab and clicked the Perform… button.


## BookMacster Version 1.9.1 (2011-12-01)

* Fixed a bug which caused a document to become unsaveable and uncloseable, indicating Error 134030 in NSCocoaErrorDomain, if *Undo* or *Redo* was commanded while a text field was focused for editing in the Content view.

* When a Bookmarkshelf window is displaying a tab view such as *Sorting* or *Simple Agents* which would become a mess if the user resized it, the window is no longer resizable in macOS Lion.


## BookMacster Version 1.9 (2011-11-29)

* If user has enabled in *System Preferences* > *iCloud* > *Bookmarks*, exports from BookMacster to Safari are now pushed into iCloud by macOS Lion.


## BookMacster Version 1.8 (2011-11-21)

* While web browsing, users may now add or visit BookMacster bookmarks with one keystroke, by using one of three new keyboard shortcuts.  Users may activate the new shortcuts in a new Preferences tab named *Shortcuts*.

* After installing this version, BookMacster's Firefox extension will no longer need to be updated and reinstalled whenever a new Firefox major version is released, and the BookMacster application package has been reduced by ~300 KB.  (The enclosed Sheep Systems Firefox Extension version 282 contains a modernized, multi-Firefox-version dynamic library.)

* Firefox 3.6 is no longer supported.  The Firefox version used with BookMacster 1.8 must be version 4.0 or later.  (BookMacster 1.6.x still works with Firefox 3.6.)

* Fixed compatibility issues with Bookmarkshelf documents produced on Macs using the PowerPC processor, or macOS 10.5.  (These Macs must use BookMacster version 1.6.x.  The 1.6.x track is still being updated, but is missing some new features not available in macOS 10.5.)

* The terminologies *Mirror-Open* and *Mirror-Save* have been changed to *Auto Import* and *Auto Export*, respectively, to take advantage of the analogy to Apple's new *Auto Save* in macOS Lion.  Also, *Auto Export* is now run if there are unexported changes when a document is *closed* as well as when it is saved.  This is necessary to not miss unexported changes in macOS Lion or later, because *Auto Export* is not run during an Auto Save by macOS.

* Exports to Safari play nicer with iCloud syncing.

* Restored capability to import more than 1000 bookmarks from Delicious, which was recently broken by Delicious/AVOS.

* No longer supports *Delicious-Yahoo!* accounts, because this service no longer exists.  Because the "new" Delicious uses what had been called the "Old Skool" access method only, labels in menus and other user interface elements which had referred to *Delicious-Old-Skool* now say simply *Delicious*.

* No longer emits Error 651105 at times when used with Dropbox version 1.2 or later.  (Dropbox updates itself automatically.  If you are a Dropbox user and don't have Dropbox 1.2 yet, you will soon.)

* No longer able to automatically move a Bookmarkshelf into a user's Dropbox folder, and no longer able to automatically determine whether or not a Bookmarkshelf is in the user's Dropbox.  (This is due to new security measures implemented by Dropbox in the Dropbox app version 1.2.)

* Now displays a small floating window with a progress bar when the Status Menulet or Dock menu are clicked for the first time, when Safari is the active web browser, during the 5-10 seconds while BookMacster is waiting for Safari to get its act together and return information about its current web page.

* Improved the mechanisms for ensuring that Agents do not miss any bookmarks changes from browsers, particularly in Bookmarkshelf documents with multiple clients, when users make bookmarks changes in different browsers in rapid succession.  (Now stores and calculates a hash value with each import, for comparison with later imports.)

* Changing the Expanded/Collapsed state of a folder in the Content Outline no longer creates an Undo action, and these states are not persisted when opening the same Bookmarkshelf on a different Mac account.  (This state is no longer saved in the .bkmslf document file but is now saved in the Local Settings database.)

* If the user has minimized the Bookmarkshelf window to the Dock, then creates a new bookmark using one of the Bookmarking Widgets, Status Menulet, Dock Menu, BookMacsterize Bookmarklet, or one of the new keyboard shortcuts, with the *Add & Inspect* option, the Inspector panel is now displayed without bringing the Bookmarkshelf window out of the Dock.

* Fixed a bug which caused the Import Safe Limit to be ignored for new documents.  (Import count was not being incremented.)

* The *BookMacsterize Bookmarklet* is no longer added to new Bookmarkshelf Documents by default.  This is because we now have so many better ways to add bookmarks, its use is discouraged.

* Fixed a bug which caused error recovery to fail (import to not be repeated) if the Safe Limit was exceeded during an Import operation performed in the background by a BookMacster's Worker, and the user clicked *View* and then *Retry* when presented with the error in BookMacster.

* Fixed a bug which could, on rare occasions, cause an Agent *Bookmarks Changed* Trigger to stop functioning until the main BookMacster application was launched.  (Fixed a race condition in which the finishing agent could delete the staging of the next agent to execute, if it started too soon.)

* Churning of bookmarks (replacement of bookmarks with identical bookmarks) which could occur during Import or Export of iCab bookmarks has been eliminated, if using iCab version 5.0 or later.   (Our thanks to iCab developer Alexander Clauss, who made it possible by adding unique identifiers to iCab bookmarks!)

* Fixed a bug which caused a hang while writing an export to iCab, if iCab's designated *Favorites* folder happened to be a subfolder of a folder which was deleted during the merging.

* No longer momentarily flashes a progress window on the screen when accessing a document which is already open.  (Usually this flash was too brief to be seen but sometimes it was.)

* The text shown in the *Save as Move…* dialog sheet is more clear and concise.


## BookMacster Version 1.7.3 (2011-10-08)

This update fixes some sporadic hangs or crashes in macOS Lion, updates protocols for Google Bookmarks access, and fixes export of Reading List to Safari 5.1.

* Fixed a bug which could cause BookMacster to hang during a Save operation (if a non-cancellable autosave had been requested by macOS Lion after the Save had been commanded but before it had executed).

* When importing from a Client (browser) which is not the first client, moves of existing items are now ignored.  This should better meet expectations of more users.  Here is an example.  Bookmarkshelf has two Clients, Safari and Firefox, with Safari first, and has bookmarks in the root.   These bookmarks would have been exported to the root in Safari, but, because Firefox does not allow bookmarks in its root, they would have been exported to the *Unsorted Bookmarks* hard folder in Firefox.  If the Simple Agent to Import changes and Export to all Clients was activated, and later a new bookmark was added in Firefox, the Agent would detect the change and import from Firefox only, and BookMacster would move all of those root bookmarks into the Bookmarkshelf's *Reading/Unsorted* folder, because that is equivalent to their location in Firefox.  Then, when exported to Safari, they would be moved into Safari's *Reading List*.  This behavior would be unexpected.  In this new version, such root bookmarks are not moved in this situation.  As a contrary example, if a user purposely moves bookmarks from one folder to another in Firefox and expects such a change to be imported to Safari, this would work in previous versions, but in this new version such moves would be ignored, and during the next Export, be overwritten back to the old arrangement.  However, we feel that this situation is a more rare usage, and reorganizing bookmarks in the web browser is indeed something that we have always recommended against.

* Now supports Firefox version 8.

* When *Restoring* a Bookmarkshelf document from Lion's Versions Browser, any actions which had been set in *Settings* > *Open/Save* to occur when opening, such as *Import*, are now skipped.  This prevents the document's Contents from being immediately changed.  (In the previous version, these actions were skipped when opening the document in the Versions Browser, but we now know that, when the user clicks the *Restore* button, Lion actually closes, probably moves, and then re-opens the restored document.  Although there are other workarounds, such as *Undo Import*, they are not immediately apparent to the average user.)

* Fixed a bug which caused BookMacster to hang when opening a previous document version, which was corrupt but repairable, in Lion's Versions Browser.  (BookMacster would repair the document and then try to save it to the .DocumentRevisions-V100 directory, but this would fail since changing history is not allowed.  Starting with BookMacster 1.7.3, the document integrity tests are skipped if a document is in the Versions Browser.  If the user selects to Restore a corrupt document, the tests, repair and save are performed a few seconds later, when the document is re-opened normally.)

* Reading List bookmarks are now reliably exported to Safari 5.1, and are exported even if Safari's Reading List was originally empty.

* Updated detection of the currently-logged in account to eliminate errors caused by recently-observed GAUSR cookies that have a prefix and a colon character before the account name (email).

* Fixed the back-up method for determining the Google account to which the user is logged in, to work with recent Google services.  (The back-up method is used in case none of the known cookies are found.)

* Fixed a bug which could cause an Undo operation to silently fail, raise an exception, or crash, if bookmarks and folders were added, then deleted, then the Bookmarkshelf was saved, and then the user clicked Edit > Undo, to undo the deletions.

* Fixed a bug which sometimes caused a silent failure when logging into Google Bookmarks to perform an Import or Export.

* Fixed two bugs which could cause a crash if an error occured while importing or exporting with Google Bookmarks.

* Simplified the method used to make HTTP requests during operations such as imports and exports to web services such as Pinboard or Google Bookmarks.

* Improved mechanism for warning user if ever a Bookmarkshelf created by a newer version of BookMacster cannot be opened by the current version.  (This can happen if a user syncing via Dropbox updates BookMacster on one Mac before the other(s)).

## BookMacster Version 1.7.2 (2011-09-05)

* Fixed a bug which caused error messages to be printed to the system console when opening a Bookmarkshelf which had been created by a previous version of BookMacster in *Browse All Versions* in macOS Lion.  (Now checks to make sure that document is not in *viewing mode* before attemping to write updated *meta*data.)

* No longer writes warnings to system console when creating a new Trigger.  (Removed depracated launchd key 'ServiceDescription' in task schema.)

* No longer writes warnings to system console involving *Couldn't stat … /LaunchAgents/ … No such file or directory* sometimes, when an Agent's Worker is triggered.


## BookMacster Version 1.7.1 (Beta) (2011-08-31)

* Upon landing a new bookmark from the BookMacster's Status Menulet, Dock Menu, or BookMacsterize bookmarklet, if the receiving Bookmarkshelf document window is showing, its Content View tab is revealed even if a different tab view was showing, and if the Inspector is shown or was showing, the new bookmark is shown in the Inspector even if the Content tab was not initially showing.

* In menu item *File* > *Export Bookmarklet to ▸*, the submenu no longer includes two items, *(Client Settings)* and *(Quick Merge – No Delete)*, for each local app client.  By design, such exports have always executed as *Quick Merge – No Delete* even if user clicked *Client Settings*.

* Upon launching, the previous BookMacster 1.7 beta required that the Browser Add-On Plug-In for Chrome or Chromium, if installed, be updated to version 81.  That was not really necessary and this version does not require that.  Any Chrome/Chromium Plug-In version 77 or later is OK and does not need to be updated.

## BookMacster Version 1.7 Beta (2011-08-29)

* Now supports the [Diigo](http://diigo.com) web bookmarking and annotation service as a Client.

* Fixed a bug when running in macOS Lion which caused changes due to a long operation, such as a multi-Client Import, to sometimes not be saved (actually, not autosaved) if the long operation was executed, and then BookMacster was quit within 15 seconds after the long operation completed.

* BookMacster no longer keeps its own backups of the last 5 Firefox bookmarks files.  Existing backup files for a Firefox profile are deleted during the next Export to that profile which occurs while Firefox is not running.

* If an error occurs when an Agent's Worker is performing, and the error is presented to the user, and the user approves a recovery option to be performed by BookMacster, performance by the Worker is now bypassed, so that the work is not done twice.  This sometimes caused Error 67000 from NSCocoaErrorDomain to appear when running in macOS Lion, and may have been causing other problems.

* Fixed a bug which caused errors generated by macOS (typically indicated by *NSCocoaErrorDomain*), to not perform the desired recovery after the user clicked a recovery button.  In one case, which only occurs in macOS Lion, Error 67000, the Bookmarkshelf could not be closed and BookMacster would have to be force quit.

* Fixed a bug which caused an Import operation to be bypassed without actually importing new bookmarks content, if a prior operation by an Agent's Worker had imported the new content, but then terminated before saving due to, for example, a Safe Limit being exceeded during an intervening Export operation.  There could have been other pathological cases, although generally not under macOS Lion due to Lion's autosave.

* When running Verify, BookMacster now sends the User-Agent string of Safari 5.1, instead of its own User-Agent string.  This is so that some sites, notably facebook.com and capitalone.com, will not incorrectly assume that BookMacster is a mobile app and respond with a permananent redirect to their *m* subdomain, for example "m.facebook.com".  Such subdomains send *minimal* web pages appropriate for *mobile* devices with small screens.

* In Preferences > Adding, added a popup in which the user may indicate how BookMacster should act when they land a new bookmark which duplicates an existing bookmark.  The choices are "Ask", "Merge", "Cancel" and "Keep Both".  Previously, the action was always "Ask" if BookMacster was running as a normal app and "Cancel" if BookMacster was running as a background app.

* Fixed a bug which caused account names from any available web app Client (Delicious, Pinboard, Google Bookmarks) to appear in the popup menu for all available web app Clients, whether or not these accounts actually existed.  For example, if user had a credential for Delicious account with username "suzie", the popup menu would contain "Pinboard (suzie)" and Google Bookmarks (suzie)" in addition to the expected "Delicious (suzie)".  Attempting to log in, import or export bookmarks involving such a nonexistent account would, of course, result in an error.

* Creating a new bookmark by dropping or pasting text into the Content View from other applications is now more likely to *Do what I mean*.

* Improved reliability of Agent triggering, particularly triggering *Export Changes from The Cloud to Clients* to import from The Cloud when operating in macOS Lion.  The difference is that we have implemented more reliable, closed-loop methods for inhibiting self-triggers, replacing the fixed 16-second blackout following any extended operations.  Extended Operations are, for example, Exporting, including quitting web browsers if necessary, and saving a Bookmarkshelf document.  The improvement is most effective in macOS Lion because Lion's sometimes-frequent autosaves caused sometimes-frequent 16-seconds blackouts.  These improvements also make the operation cleaner, eliminating some instances where a Worker would be re-launched a second time after performing work, just to verify that there was no new work to do and then terminate itself after a few milliseconds.

* Improved reliability of getting *all* Google Bookmarks during an Import operation, for users that have more than 1000 Google Bookmarks.

* During an Import or Export operation to a web app such as Delicious, Pinboard or Diigo which require a separate request for each bookmark, the little red *Cancel* button now responds immediately when clicked instead of after the next request.  (This was done to better support Diigo, which sometimes keeps BookMacster waiting for up to an hour during large exports.)

* If system sleeps during an Export operation to a web app such as Delicious, Pinboard or Diigo which require a separate request (upload) for each bookmark, now waits 20 seconds after the system wakes before resuming requests.  This allows other applications to wake faster, and also greatly reduces the probability that the first request will generate an error indicating that internet access is not available (yet).

* During an Export to a web app such as Delicious, Pinboard or Diigo which require a separate request for each bookmark, if user attempts to close the document window twice, the operation is now cancelled and the window is allowed to close, without user clicking the little red *Cancel* button in the Status Bar.

* Menu item *File* > *Export Bookmarklet to ▸* no longer includes web apps in its submenu.  (Exporting our bookmarklet to a web app would be useless even if it worked, which it didn't since BookMacster generally does not export JavaScript bookmarklets to web apps.)

* When opening a previous version of a document after clicking *Browse All Versions* in macOS Lion, no longer attempts to perform any of the actions which are set under *After opening this document, do automatically* in *Settings* > *Open/Save*.  (The available actions are Import, Sort and Find Duplicates.  If the results of such actions were allowed to be saved, which Lion did not allow anyhow, it would have been essentially changing history.)

* Fixed a bug which foiled BookMacster's attempts to extract a web app password written by another app from the macOS Keychain, if the other app had prefixed the host name with a subdomain such as "www" or "my", in some cases.

* Fixed a bug which caused a bogus *wrong password* error during an Import or Export operation, if the Client had just been changed from one web app/account to another web app/account, because the password from the prior web app/account would be sent in the request to the new web app/account.

* Implemented a proper lockout mechanism so that an Auto Save in macOS Lion can no longer sometimes initiate several cycles of ping-ponging when a Bookmarkshelf is configured to synchronize between two Macs via Dropbox.

* Fixed this bug: If *Find Duplicates* command was disabled, and if Settings > General > *Ignore Duplicates descending from different Hard Folders* checkbox was ON, when this checkbox was checked OFF, the *Find Duplicates* command did not become enabled.  It should have, because unchecking this box can cause groups of bookmarks spanning different Hard Folders, which were not considered to be duplicates when the box was checked, to become duplicates.  This works properly now.

* Fixed this bug: After duplicates had been effectively deleted by changing the rules, for example, checking the box Settings > General > *Ignore Duplicates descending from different Hard Folders*, the summary line at the top of the Reports > Duplicates table would indicate more Duplicate Groups than were listed in the table.

* A Bookmarkshelf document can now be edited during a *Save* operation in macOS Lion.  On the surface, this is a trivial improvement, but under the hood it means that we have implemented Lion's new *asynchronous saving* feature (not to be confused with *Auto Save and Versions*, which we've had since Lion was released).  This reason for doing this is because it gets us more fully in step with the Apple program, which means that we'll avoid some present or future bugs in the area of saving and autosaving, either in BookMacster or in macOS Lion.

* Major operations (Save, Import, Export, Sort, Find Duplicates, Verify, Install/Uninstall Browser Add-On, etc.) may now be performed concurrently by different Bookmarkshelf documents, and/or the Manage Browser Add-Ons window.  Like the previous change, we certainly didn't have any users screaming for this capability, although it is occasionally nice to be able to work around exports to throttled web services such as Delicious and Diigo, which can take many minutes or hours to swallow thousands of bookmarks.  It was done primarily to better implement the document model assumed by macOS Lion, eliminating some possibilities whereby an Auto Save operation could cause BookMacster to deadlock under the hood and require a force-quit.

* No longer enters *User Cancelled* errors into the log.  This is to reduce extraneous log entires in macOS Lion, wherein *User Cancelled* errors occur without the user actually cancelling, when Lion requests an Auto Save while BookMacster is busy with a major operation.

* Silently recovers from rare, nuisance Error 67000 in NSCocoaErrorDomain when running in macOS Lion, by effectively clicking the "Save Anyway" button before the error would have been displayed, and logging information about the occurrence to the system's stderr.  Although some of the other changes may have eliminated this nuisance, we're not sure and shall continue to look for the root cause if we see any such logs.

* This is the first version in a new branch which requires macOS 10.6 or later, and an Intel processor.  We plan to release a roughly equivalent version for users with macOS 10.5 or PowerPC processors.


**---------**

## Updates For macOS 10.5 Users Only [osx5versionHistory]

BookMacster updates were [split into two tracks](https://sheepsystems.com/files/products/bkmx/OSX-10-5.html) starting with version 1.7.  BookMacster versions 1.7 and later require Mac OS 10.6 or later.  Beginning with version 1.6.8, versions numbered 1.6.X are for Mac OS 10.5 users only.

## BookMacster Version 1.6.14 (2013-05-15)

All changes listed listed in the regular version of BookMacster, up to and including BookMacster 1.15.1, except those which are not possible in macOS 10.5, are now incorporated into this version.  This version can open documents created by any version of BookMacster up to and including 1.15.1.

## BookMacster Version 1.6.13 (2013-04-30)

All changes listed listed in the regular version of BookMacster, up to and including BookMacster 1.14.10, except those which are not possible in macOS 10.5, are now incorporated into this version.  And, this version can open documents created by any version of BookMacster up to and including 1.14.10.  In addition,

* Fixed bug which caused a crash when opening the Inspector macOS 10.5.

* Fixed bug which could cause failure to receive new bookmarks from web browsers, after another app had quit, on macOS 10.5.

* Fixed a bug which could cause a crash during exports, on macOS 10.5.

## BookMacster Version 1.6.12 (2013-04-23)

All changes listed listed in the regular version of BookMacster, up to and including BookMacster 1.14.8, except those which are not possible in macOS 10.5, are now incorporated into this version.  And, this version can open documents created by any version of BookMacster up to and including 1.14.8.  In addition,

* Fixed bug which caused failure to launch on Core Duo Intel Macs running macOS 10.5.

* Smart Bookmarks with *Shortcuts* (*Keyword* in Firefox, *Nickname* in Opera) now show their shortcut in the Inspector instead of *Not applicable*.

## BookMacster Version 1.6.11 (2013-04-16)

This version incorporates most all of the changes which have been made in BookMacster since July 2012, versions 1.11.8 through 1.14.4, except for the first two regarding the better function of the *tab* keys.  A few of the changes require later macOS versions and therefore do not work in this version.  However, the important change is that this version can now open any document created with any version of BookMacster up to and including the latest, 1.14.4.

Support for performing privileged operations, such as checking the box to license BookMacster on all Macintosh user accounts, and importing and exporting bookmarks with other Macintosh user accounts, has been eliminated in this version.  This is because we've the methods supporting this capability in the regular version of BookMacster have been substantially overhauled to work in macOS 10.8, and it would have been too costly to maintain both tracks, given that hardly anyone uses these features.  We'd rather you have some shiny new apps from us when you upgrade your Mac!  Contact our Support team if you need help with a workaround.  

## BookMacster Version 1.6.10 (2012-07-20)

This version is equivalent to the macOS 10.6+ version BookMacster 1.11.7.  It incorporates all of the changes, listed above, from BookMacster 1.9.1 (2011-12-01) through BookMacster 1.11.9 (2012-07-20), with the exception of a few new features that require later versions of macOS.

## BookMacster Version 1.6.9 (2011-11-21)

This version is equivalent to the macOS 10.6+ version BookMacster 1.8.

* While web browsing, users may now add or visit BookMacster bookmarks with one keystroke, by using one of three new keyboard shortcuts.  Users may activate the new shortcuts in a new Preferences tab named *Shortcuts*.

* The terminologies *Mirror-Open* and *Mirror-Save* have been changed to *Auto Import* and *Auto Export*, respectively, to take advantage of the analogy to Apple's new *Auto Save* in macOS Lion.  Also, *Auto Export* is now run if there are unexported changes when a document is *closed* as well as when it is saved.  (This is necessary to not miss unexported changes in macOS Lion or later, because *Auto Export* is not run during an Auto Save by macOS.)

* Restored capability to import more than 1000 bookmarks from Delicious, which was recently broken by Delicious/AVOS.

* No longer supports *Delicious-Yahoo!* accounts, because this service no longer exists.  Because the "new" Delicious uses what had been called the "Old Skool" access method only, labels in menus and other user interface elements which had referred to *Delicious-Old-Skool* now say simply *Delicious*.

* No longer emits Error 651105 at times when used with Dropbox version 1.2 or later.  (Dropbox updates itself automatically.  If you are a Dropbox user and don't have Dropbox 1.2 yet, you will soon.)

* No longer able to automatically move a Bookmarkshelf into a user's Dropbox folder, and no longer able to automatically determine whether or not a Bookmarkshelf is in the user's Dropbox.  (This is due to new security measures implemented by Dropbox in the Dropbox app version 1.2.)

* Now displays a small floating window with a progress bar when the Status Menulet or Dock menu are clicked for the first time, when Safari is the active web browser, during the 5-10 seconds while BookMacster is waiting for Safari to get its act together and return information about its current web page.

* Improved the mechanisms for ensuring that Agents do not miss any bookmarks changes from browsers, particularly in Bookmarkshelf documents with multiple clients, when users make bookmarks changes in different browsers in rapid succession.  (Now stores and calculates a hash value with each import, for comparison with later imports.)

* Changing the Expanded/Collapsed state of a folder in the Content Outline no longer creates an Undo action, and these states are not persisted when opening the same Bookmarkshelf on a different Mac account.  (This state is no longer saved in the .bkmslf document file but is now saved in the Local Settings database.)

* If the user has minimized the Bookmarkshelf window to the Dock, then creates a new bookmark using one of the Bookmarking Widgets, Status Menulet, Dock Menu, BookMacsterize Bookmarklet, or one of the new keyboard shortcuts, with the *Add & Inspect* option, the Inspector panel is now displayed without bringing the Bookmarkshelf window out of the Dock.

* Fixed a bug which caused the Import Safe Limit to be ignored for new documents.  (Import count was not being incremented.)

* The *BookMacsterize Bookmarklet* is no longer added to new Bookmarkshelf Documents by default.  This is because we now have so many better ways to add bookmarks, its use is discouraged.

* Fixed a bug which caused error recovery to fail (import to not be repeated) if the Safe Limit was exceeded during an Import operation performed in the background by a BookMacster's Worker, and the user clicked *View* and then *Retry* when presented with the error in BookMacster.

* Fixed a bug which could, on rare occasions, cause an Agent *Bookmarks Changed* Trigger to stop functioning until the main BookMacster application was launched.  (Fixed a race condition in which the finishing agent could delete the staging of the next agent to execute, if it started too soon.)

* Churning of bookmarks (replacement of bookmarks with identical bookmarks) which could occur during Import or Export of iCab bookmarks has been eliminated, if using iCab version 5.0 or later.   (Our thanks to iCab developer Alexander Clauss, who made it possible by adding unique identifiers to iCab bookmarks!)

* Fixed a bug which caused a hang while writing an export to iCab, if iCab's designated *Favorites* folder happened to be a subfolder of a folder which was deleted during the merging.

* No longer momentarily flashes a progress window on the screen when accessing a document which is already open.  (Usually this flash was too brief to be seen but sometimes it was.)

* The text shown in the *Save as Move…* dialog sheet is more clear and concise.


## BookMacster Version 1.6.8 (2011-09-05)

* Now supports the [Diigo](http://diigo.com) web bookmarking and annotation service as a Client.

* No longer writes warnings to system console when creating a new Trigger.  (Removed depracated launchd key 'ServiceDescription' in task schema.)

* No longer writes warnings to system console involving *Couldn't stat … /LaunchAgents/ … No such file or directory* sometimes, when an Agent's Worker is triggered.

* Upon landing a new bookmark from the BookMacster's Status Menulet, Dock Menu, or BookMacsterize bookmarklet, if the receiving Bookmarkshelf document window is showing, its Content View tab is revealed even if a different tab view was showing, and if the Inspector is shown or was showing, the new bookmark is shown in the Inspector even if the Content tab was not initially showing.

* In menu item *File* > *Export Bookmarklet to ▸*, the submenu no longer includes two items, *(Client Settings)* and *(Quick Merge – No Delete)*, for each local app client.  By design, such exports have always executed as *Quick Merge – No Delete* even if user clicked *Client Settings*.

* BookMacster no longer keeps its own backups of the last 5 Firefox bookmarks files.  Existing backup files for a Firefox profile are deleted during the next Export to that profile which occurs while Firefox is not running.

* If an error occurs when an Agent's Worker is performing, and the error is presented to the user, and the user approves a recovery option to be performed by BookMacster, performance by the Worker is now bypassed, so that the work is not done twice.  This sometimes caused Error 67000 from NSCocoaErrorDomain to appear when running in macOS Lion, and may have been causing other problems.

* Fixed a bug which caused errors generated by macOS (typically indicated by *NSCocoaErrorDomain*), to not perform the desired recovery after the user clicked a recovery button.  In one case, which only occurs in macOS Lion, Error 67000, the Bookmarkshelf could not be closed and BookMacster would have to be force quit.

* Fixed a bug which caused an Import operation to be bypassed without actually importing new bookmarks content, if a prior operation by an Agent's Worker had imported the new content, but then terminated before saving due to, for example, a Safe Limit being exceeded during an intervening Export operation.  There could have been other pathological cases, although generally not under macOS Lion due to Lion's autosave.

* When running Verify, BookMacster now sends the User-Agent string of Safari 5.1, instead of its own User-Agent string.  This is so that some sites, notably facebook.com and capitalone.com, will not incorrectly assume that BookMacster is a mobile app and respond with a permananent redirect to their *m* subdomain, for example "m.facebook.com".  Such subdomains send *minimal* web pages appropriate for *mobile* devices with small screens.

* In Preferences > Adding, added a popup in which the user may indicate how BookMacster should act when they land a new bookmark which duplicates an existing bookmark.  The choices are "Ask", "Merge", "Cancel" and "Keep Both".  Previously, the action was always "Ask" if BookMacster was running as a normal app and "Cancel" if BookMacster was running as a background app.

* Fixed a bug which caused account names from any available web app Client (Delicious, Pinboard, Google Bookmarks) to appear in the popup menu for all available web app Clients, whether or not these accounts actually existed.  For example, if user had a credential for Delicious account with username "suzie", the popup menu would contain "Pinboard (suzie)" and Google Bookmarks (suzie)" in addition to the expected "Delicious (suzie)".  Attempting to log in, import or export bookmarks involving such a nonexistent account would, of course, result in an error.

* Creating a new bookmark by dropping or pasting text into the Content View from other applications is now more likely to *Do what I mean*.

* Improved reliability of Agent triggering, particularly triggering *Export Changes from The Cloud to Clients* to import from The Cloud when operating in macOS Lion.  The difference is that we have implemented more reliable, closed-loop methods for inhibiting self-triggers, replacing the fixed 16-second blackout following any extended operations.  Extended Operations are, for example, Exporting, including quitting web browsers if necessary, and saving a Bookmarkshelf document.  The improvement is most effective in macOS Lion because Lion's sometimes-frequent autosaves caused sometimes-frequent 16-seconds blackouts.  These improvements also make the operation cleaner, eliminating some instances where a Worker would be re-launched a second time after performing work, just to verify that there was no new work to do and then terminate itself after a few milliseconds.

* Improved reliability of getting *all* Google Bookmarks during an Import operation, for users that have more than 1000 Google Bookmarks.

* During an Import or Export operation to a web app such as Delicious, Pinboard or Diigo which require a separate request for each bookmark, the little red *Cancel* button now responds immediately when clicked instead of after the next request.  (This was done to better support Diigo, which sometimes keeps BookMacster waiting for up to an hour during large exports.)

* If system sleeps during an Export operation to a web app such as Delicious, Pinboard or Diigo which require a separate request (upload) for each bookmark, now waits 20 seconds after the system wakes before resuming requests.  This allows other applications to wake faster, and also greatly reduces the probability that the first request will generate an error indicating that internet access is not available (yet).

* During an Export to a web app such as Delicious, Pinboard or Diigo which require a separate request for each bookmark, if user attempts to close the document window twice, the operation is now cancelled and the window is allowed to close, without user clicking the little red *Cancel* button in the Status Bar.

* Fixed two bugs, either of which could cause an export to Google Chrome to fail with Error 453973 if performed while Google Chrome was running, and if an incoming bookmark was merged by URL with another bookmark that had been in a different folder in Google Chrome.

* Menu item *File* > *Export Bookmarklet to ▸* no longer includes web apps in its submenu.  (Exporting our bookmarklet to a web app would be useless even if it worked, which it didn't since BookMacster generally does not export JavaScript bookmarklets to web apps.)

* Fixed a bug which foiled BookMacster's attempts to extract a web app password written by another app from the macOS Keychain, if the other app had prefixed the host name with a subdomain such as "www" or "my", in some cases.

* Fixed a bug which caused a bogus *wrong password* error during an Import or Export operation, if the Client had just been changed from one web app/account to another web app/account, because the password from the prior web app/account would be sent in the request to the new web app/account.

* Fixed this bug: If *Find Duplicates* command was disabled, and if Settings > General > *Ignore Duplicates descending from different Hard Folders* checkbox was ON, when this checkbox was checked OFF, the *Find Duplicates* command did not become enabled.  It should have, because unchecking this box can cause groups of bookmarks spanning different Hard Folders, which were not considered to be duplicates when the box was checked, to become duplicates.  This works properly now.

* Fixed this bug: After duplicates had been effectively deleted by changing the rules, for example, checking the box Settings > General > *Ignore Duplicates descending from different Hard Folders*, the summary line at the top of the Reports > Duplicates table would indicate more Duplicate Groups than were listed in the table.

* Major operations (Save, Import, Export, Sort, Find Duplicates, Verify, Install/Uninstall Browser Add-On, etc.) may now be performed concurrently by different Bookmarkshelf documents, and/or the Manage Browser Add-Ons window.  Like the previous change, we certainly didn't have any users screaming for this capability, although it is occasionally nice to be able to work around exports to throttled web services such as Delicious and Diigo, which can take many minutes or hours to swallow thousands of bookmarks.  It was done primarily to better implement the document model assumed by macOS Lion, eliminating some possibilities whereby an Auto Save operation could cause BookMacster to deadlock under the hood and require a force-quit.

* No longer enters *User Cancelled* errors into the log.  This is to reduce extraneous log entires in macOS Lion, wherein *User Cancelled* errors occur without the user actually cancelling, when Lion requests an Auto Save while BookMacster is busy with a major operation.

* This is the first version in a new branch which requires macOS 10.6 or later, and an Intel processor.  We plan to release a roughly equivalent version for users with macOS 10.5 or PowerPC processors.

* Google Bookmarks Imports and Exports now work for Google accounts which have been upgraded to [Google+](http://www.google.com/+/learnmore/).

* BookMacster is now *built* on a Mac running macOS Lion.  If all goes well, this should have no effect whatsoever.


**---------**

**Updates below this line run on any macOS version, 10.5 or later.**  (This is the point at which BookMacster updates were [split into two tracks](https://sheepsystems.com/files/products/bkmx/OSX-10-5.html).


## BookMacster Version 1.6.7 Beta (2011-08-01)

* This version launches again.

## BookMacster Version 1.6.6 Beta (2011-08-01)

* Google Bookmarks Imports and Exports now work for Google accounts which have been upgraded to [Google+](http://www.google.com/+/learnmore/).

* BookMacster is now *built* on a Mac running macOS Lion.  If all goes well, this should have no effect whatsoever.

## BookMacster Version 1.6.5 (2011-07-30)

* Implemented an effective workaround for a bug in macOS Lion, which launches a Worker two or three times within a period of several minutes, instead of just once, to perform commands (import, sync, sort, export, whatever) after bookmarks or Bookmarkshelf were changed.  To eliminate this unnecessary resource usage, Workers now detect if Lion has launched them unnecessarily, and if so terminate themselves after a few milliseconds.

* Fixed a bug which caused installation of Firefox Add-On to fail repeatedly if Firefox was updated to a new major version, such as Firefox 5.x to Firefox 6.x, while BookMacster was running.  With each Import or Export, BookMacster would prompt the user to reinstall the Firefox Add-On, but each time, it would install the Add-On for the old Firefox version, which wouldn't work.  The proper Add-On would not be installed until after BookMacster had been quit and re-launched.

* Fixed a bug introduced in BookMacster 1.6.2 which caused AppleScript references to Agents to fail, and Agent Workers to fail silently if BookMacster was currently open with the subject Bookmarkshelf document when an Agent action was triggered.  This would result in bookmarks not being imported, sorted, or whatever when as expected.

* Bookmarkshelf Documents opened in macOS Lion which are more than several weeks old no longer show "– Locked" in the title bar, and no longer have Auto Save disabled until the user saves manually.  Lion's Auto Save is now working for all Bookmarkshelf Documents, always.  (In the previous version 1.6.4, we had bypassed the warning which Lion wanted to display when these documents were opened.  This fix complements that previous fix.)

* Auto Save operations initiated by macOS Lion are now prohibited while BookMacster is busy with intensive operations such as multiple-Client imports, so that the time to complete these operations is no longer extended by Auto Saves being performed senselessly when more changes are imminent.

* Auto Save operations initiated by macOS Lion no longer display "Completed: Save" in the Status Bar at the bottom of a Bookmarkshelf window, and therefore no longer wipe out previous completion messages which may be there.

* Auto Save operations initiated by macOS Lion can no longer trigger an agent, in particular an *Export Changes from The Cloud to Clients* agent.

* Fixed a bug which caused the Logs (menu > BookMacster > Logs) to indicate time in Coordinated Universal Time (UTC) instead of the local time zone when operating in macOS Lion.

* When creating a new bookmark using the *Add Here* or *Add To* menu items in the Status Menulet or Dock Menu, if browsing in Safari, Opera or OmniWeb, if no text is selected in the browser, the browser no longer emits an "alert" sound.  (Selected text, if any, still becomes the Comment of the new bookmark.)

* When using the *Sort Now, by ▸* contextual menu items, if the chosen attribute is a date, the order is now newest to oldest starting at the top, and when sorting by Visit Count, the order is highest to lowest starting at the top.

## BookMacster Version 1.6.4 (2011-07-26)

* Fixed bugs which caused three dialogs indicating that a User Cancelled Error 3072 to be displayed, and in some cases fail to open the document, when opening a Bookmarkshelf Document which is more than several weeks old in macOS Lion.

* Bugs were fixed so that clicking in the menu File > Duplicate when operating in macOS Lion works properly now.

* An (annoying) new feature of macOS Lion, which displays a warning when opening a document which was last opened more than several weeks ago, has been bypassed for Bookmarkshelf documents.  Old documents now *just open* (although, as before, they take longer to open the first time if an intervening BookMacster update requires that their data model be updated).

* Fixed a bug which caused empty folders resulting from merging folders to not be deleted when importing from multiple Clients, if these Clients had folder structures which were similar but not identical in certain pathological respects.

* Fixed bug which caused exceptions to be written to system console log when scrolling through the Sync Logs of a Bookmarkshelf document when operating in macOS Lion.

* Fixed a bug which caused the *Sort Now, by* contextual menu item introduced in version 1.6.2 to not work for all of the non-string (dates and number) attribute types in its submenu.

* Fixed a bug which sometimes caused a crash when closing a Bookmarkshelf document window in our test lab with AppleScript.  Theoretically, similar crashes could have been occurring in real life.

## BookMacster Version 1.6.3 (2011-07-23)

* Fixed a bug which could cause a Bookmarkshelf to log exceptions to the system log and cause the application to hang after viewing an item in the Inspector.

* After the first phase of a Verify operation, the time that BookMacster will wait for websites to respond has been reduced to 30 seconds, instead of 60 seconds in the Leopards and more in macOS Lion.

## BookMacster Version 1.6.2 (2011-07-20)

**Summary.**  This update, and the [prior update to 1.6 beta]() improve the user interface and user experience, particularly for those that are [using BookMacster Directly](https://sheepsystems.com/bookmacster/HelpBook/useDirectly).  It also fixes a couple more bugs we found when operating under macOS Lion, and Bookmarkshelf Documents now sport Lion's new [Auto Save and Versions](http://www.apple.com/macosx/whats-new/auto-save.html) features.

* *Add To* menu items have been added to the Status Menulet and Dock Menu, to complement the *Add Here* items added in version 1.6 beta.  The *Add to* item has a submenu which remembers the ten most recent folders to which the the user has added a bookmark, in addition to the users's default New Bookmark Landing.

* Bookmarkshelf Documents now have the [Auto Save and Versions](http://www.apple.com/macosx/whats-new/auto-save.html) family of features when operating in macOS Lion.  Lion users can easily copy and paste or drag and drop bookmarks or folders from back in history, or roll entire Bookmarkshelf Documents back in time.

* Fixed a bug, active when operating under macOS Lion, whereby edits made to a Bookmarkshelf would not *dirty* the red *close* button in the title bar, so the document could not be saved.

* Fixed a bug which caused a Bookmarkshelf window to stop operating properly in various ways if one of the columns in the Find tab was set to display *Add Date*, *Last Modified Date* or *Last Visited Date*, always when operating under macOS Lion, and rarely when operating under one of the Leopards.  A message regarding "Cannot remove an observer for the key path 'xxxx.medDateShortTimeString'" was observed in the system console.

* Added a new item, *Sort By*, to the contextual menu on items in the Content View and in the Find Report.  This item is enabled for folders.  It does a one-time sort of the folder's content, by any of nine attributes (name, URL, shortcut, and Added Date, etc.), selectable from a submenu.

* The Help Book now explains how to work through Google's *2-Step Verification* when syncing with a Google Bookmarks client.  (See sec. 5.3.11.)

* When operating in macOS Lion, a checkmark in the *Always save unsaved changes when closing – Don't ask* checkbox in *Settings* > *Open/Save* is ignored, because this feature is obviated by Lion's *Auto Save*.

* During an Export operation, if there are multiple Hard Folders which are present in BookMacster but not present in the Export Client (for example, Camino has neither *Shared Bookmarks* nor *Reading/Unsorted*), when the contents of these hard folders are merged into the client's Default Parent, they are now inserted as contiguous blocks from each Hard Folder, instead of being interleaved.

* Names of bookmarks and folders shown in the Dock Menu and Status Menulet are now truncated to a reasonable length so that the menu will no longer take over the screen if a folder happens to have a bookmark with a long name.

* Throughout the application, in many places where text is truncated to fit in a desired space, whole words are removed if possible so that you won't see "nons…se" or "gar…ge".

* The size of the Folder and Add To icons in the Status Menulet and Dock Menu have been reduced so that they are the same size as the menu font, making the menu more compact and allowing more items to fit on the screen, for the same font size setting.

* All menu items in Status Menulet and Dock Menu now respect the Menu Font Size set in Preferences > Appearance.

* Added seven new AppleScript commands: *import*, *export*, *quick import*, *quick export*, *make new local client*, *delete all clients*, and *write sync log*.  We added these for our automated regression testing, but they are documented in BookMacster's AppleScript dictionary, anyone can use them, and we've already found them to be quite handy for other purposes.

* When presenting an error from BookMacster-Worker or via the *present last logged error* AppleScript command, if the last logged error was a trivial error which should not be presented (*User Cancelled*, for example), BookMacster now displays the next non-trivial error, instead of silently presenting nothing.

* Fixed a bug which caused, during export to an iCab client, if the iCab client did not have any bookmarks or folders in it at all, and thus no designated *Favorites* folder, bookmarks from BookMactser's Bookmarks Bar were not exported.

* Fixed a bug which occurred when attempting to import from an *Other Macintosh Account* Client – if the required disk was not mounted, instead of presenting an error, BookMacster would proceed as though this Client had no bookmarks in it.

* Fixed a bug which caused some errors to not appear after BookMacster-Worker encountered an error and user clicked *View Now*.

* Fixed a bug which caused unmatched items to be deleted during an Import with Delete Unmatched Items checked OFF, if a previous Import had been done during in the same window with Delete Unmatched Items checked ON, followed by an Undo Import.

* Several anomalies have been removed during the writing of Sync Logs, so that Sync Logs now contain fewer spurious entries in corner cases.

* Fixed a bug which caused BookMacster-Worker to crash after completing its work if a Trigger had recently become invalidated, for example, if a Bookmarkshelf document had an Agent with a Trigger that was supposed to activate when Dropbox updated its file, but the Bookmarkshelf had been moved out of the user's Dropbox.

* Fixed code which could sometimes cause a crash while launching or quitting BookMacster, if a Bookmarkshelf document was being opened or closed at the same time, particularly if these actions were driven by AppleScript.

* XBEL exports now contain all bookmarks and hierarchy.


## BookMacster Version 1.6 (2011-07-04) (Beta)

**Summary.**  This update improves the user interface and user experience, particularly for those that are [using BookMacster Directly](https://sheepsystems.com/bookmacster/HelpBook/useDirectly).

* *Add Here* menu items have been added to BookMacster's Status Menulet.  These items add a bookmark to the current web page, directly to the current Bookmarkshelf, in a designated folder.  This new feature is supported when browsing in Camino, Chromium, Firefox (3.6-7.0), Google Chrome, OmniWeb, Opera, and Safari.

* Upon clicking a bookmark in BookMacster's Status Menulet or Dock Menu, if the active application is a web browser, the bookmark will be visited with that web browser instead of the browser which has been designated in the Inspector for that bookmark.  The Help Book now explains explains how users can now use BookMacster to [quickly visit any web page with any desired browser](https://sheepsystems.com/bookmacster/HelpBook/doxtusVisitWhich).

* When triggered by a web browser app quitting, or by a drop from The Cloud, sync Agents are no longer subjected to the 5-minute delay but execute immediately.

* In the main menu > *Window*, added three menu items, with keyboard shortcuts, to reveal the *Content*, *Settings*, and *Reports* tabs. 

* In the main menu > *Selection*, added three menu items, with keyboard shortcuts, to *Add New Soft Folder*, *Add New Bookmark*, and *Add New Separator*.

* When creating a new bookmark using that menu item, or with the old "+" button in the Content view, if the clipboard contains a valid absolute URL, that URL is assigned to the new bookmark.

* To make room for the *Add New Soft Folder* keyboard shortcut, and to emphasize that creating a New Bookmarkshelf should be rare, the keyboard shortcut for *File* > *New Bookmarkshelf* has been changed from ⌘N to ⌘⇧N.

* When users who have only one Bookmarkshelf Document begin to create a second Bookmarkshelf, they are now warned that this is usually undesirable, and are given options to either proceed, reopen their first Bookmarkshelf instead, or trash it before creating a new one, and are also given a Help Button which is linked to the appropriate place in the documentation.

* Fixed a bug which caused a crash during an Import if the relevant Bookmarkshelf had its *Sync Log* > *Days to keep* set to zero (0).

* All menu items in the Status Menulet, including Bookmarkshelf Document Names, *Quit BookMacster*, and *Show BookMacster*, now respect the Menu Font Size set in Preferences > Appearance.

* Fixed a bug which caused error recovery in an Import or Export to silently abort in some cases, for example, if the operation required sending a query to a server on the internet which had just been queried during the last to minutes, and the user clicked *Retry* to indicate that BookMacster should retry when it was safe.  That works now.

* When opening a Bookmarkshelf Document, if a prior setting for *Show Folders (Outline Mode)* is not found for the document, which can happen if preferences were trashed, the setting now defaults to YES instead of NO.

* BookMacster Agents now launch Worker processes with a *nice* value of 20 instead of 0, to minimize any performance impact on other processes.

* Removed nonsense in presentation of error 519892.

* Fixed a bug which caused the *Delete All Content* and *Remove Bookdog Artifacts* menu items to be incorrectly disabled after an Import operation which populated a previously-empty Bookmarkshelf.

* Fixed a bug in Help Book which caused section 1.1 to have no title in the Table of Conents.

* Fixed a bug which sometimes caused a failure to log into Delicious via OAuth.

* Fixed a bug which caused Undo to fail at times, for example if an error occurred during an Import or Export operation, and then the operation was repeated.  A message stating that there were too many Undo Groups open would be printed to the system console because the error preempted closing of an Undo Group.

## BookMacster Version 1.5.8 (2011-06-24)

**Summary.**  Since the last production release, 1.5.4, this update fixes bugs triggered in macOS Lion, restores functions that were broken with the release of Firefox 5, improves the user experience particularly when errors occur, and incorporates other bug fixes and updates, including several affecting syncs with Firefox, Opera, Google Bookmarks, and Safari in macOS Lion.

* The bookmarking widgets, import/export while browser is running, and automatic detection of bookmarks changes now work in Firefox 5, Firefox 6, and Firefox 7.  (Users who have BookMacster's Firefox Extension installed will be prompted to approve the update in Firefox upon launching this version of BookMacster.)

* Fixed a bug introduced in 1.5.7 which caused the "Export ➞ Whatever ()" result to not appear, and all previous results to be cleared, after an Export operation under some conditions.

* If the user clicks *Cancel* or if an error occurs while configuring a *Choose File (Advanced)* or *Other Macintosh Account (Advanced)* Client, the resulting non-functional Client is now always removed.  (Non-functional Clients would cause errors later, typically Error 19675 : 541875 during a subsequent Import or Export.)


## BookMacster Version 1.5.7 (2011-06-21) (Beta)

Note: This update does not support Firefox 5 beta.  Mozilla fixed a bug last week which supposedly makes it possible for us to support Firefox 5 in an upcoming release.

* The events which occur when an Import or Export operation exceeds the Safe Limit have been redeveloped to be more informative and less annoying, including an *Undo* for imports and a *Dry Run* for exports.  When executed in the main application, an Import or Export which exceeds the Safe Limit is no longer treated as an error.  If it occurs during an Import, the import is allowed to complete and the user is advised to examine the results and click *Undo* if desired.  If it occurs during an export, the export is temporarily halted while waiting for the user to click *Dry Run*, *Cancel* or *Proceed*.  *Dry Run* directs the user to the *Sync Log* report after the dry run is complete, so that the user can see what would have been changed.  In either case, the dangerous option to *Change Limit* is no longer offered (but is still available elsewhere).  When executed by an Agent's Worker, an Import or Export which exceeds the Safe Limit is still treated as an error, but if the user clicks *View*, the dangerous and head-scratching *Ignore Limit* recovery option has been replaced with an option to *Retry* in the main application, which executes safely, as described above.  Unlike the old *Ignore Limit*, *Retry* only executes the Import or Export that failed, instead of the whole sequence of Agent operations (typically Import, Sort, Export, etc.)

* Exports to multiple Clients are now more independent of one other.  For example, if an Export to a given Client is aborted due to the Safe Limit being exceeded, or if a browser must be quit but the relevant Trigger's settings do not allow automatic quitting of this btrowser, exports to other Clients complete normally.

* Fixed a bug, whereby under certain conditions, an import exceeding the Safe Limit could cause a *prior* action to be undone, if the import did not contain any changes.

* When a browser is running and needs to be quit to effect an Import or Export (which is still necessary for browsers other than Safari, Chrome and Firefox), the situation now gets custom handling instead of being treated as an error.

* Other improvements were made to the running of various tasks (Import, Export, Sort, etc.), both when run manually in the BookMacster app, and when sequenced automatically by Agents.  The logic is now much more robust, and it's now more likely to recover gracefully and less likely to present an error, and the behavior when multiple errors occur is better controlled.

* When a new bookmark is landed by one of the Bookmarking Widgets or BookMacsterize Bookmarklet, or when a bookmark is moved or copied to a new location using the *Copy To* or *Move To* contextual menu commands, or the *Copy To* or *Move To* gear menu item in the Inspector, or the *Move* hyperlink in the Inspector, and if the landing folder is specified to be sorted when sorting occurs, the landing folder is now sorted immediately according to the Bookmarkshelf's settings.  In other words, items which are moved or copied into a folder without specifying their position (such as by dropping) are now put in their proper position automatically.

* The term *Diary* has been renamed to *Sync Log*.

* The term *Safe Limit* has been renamed to *Safe Sync Limit*.

* Three "shortcut" menu items have been added under the *Import* and *Export* items in the *Bookmarkshelf* menu.  They don't add any new functions but make things easier to find for new users who are accustomed to the word *Sync*.  *Set Up Sync…* opens the *Settings* > *Agents* tab.  *Safe Sync Limit…* guides the user to set a desired Safe Sync Limit for a particular Import or Export operation, like the *Change Limit* in the old Error dialog shown when the limit was exceeded, but with an improved animation.  *Show Sync Log* opens the *Reports* > *Sync Log* tab.

* Supports the new [*Reading List*](http://www.apple.com/macosx/whats-new/features.html) in Safari in macOS Lion.  During Imports and Exports, the *Reading List* maps into BookMacster's *Unsorted Bookmarks* hard folder, the name of which has now been changed to *Reading/Unsorted*.   This hard folder still maps into Firefox' *Unsorted Bookmarks* too, so that bookmarks (not folders) in Firefox' *Unsorted Bookmarks* sync to Safari's *Reading List*  and vice versa.

* No longer fails to find Opera bookmarks when populating Client menus, or doing imports or exports, if Opera is freshly installed at version 11.11 without having had Opera bookmarks previously.

* Updated method for determining the account currently logged in to Google Bookmarks so that Google Bookmarks can be reliably accessed with the current version of Google Bookmarks being served by Google.

* Fixed a long sought-after bug which caused a Firefox Import or Export to fail, it turns out, on the first such attempt if Firefox was not running, and if BookMacster had to create the *Library* in Firefox because the user had never used the *Manage Bookmarks* function in Firefox (which was called *Organize Bookmarks* prior to Firefox 4).

* When the contents of the Content View change for any reason, for example, sorting, if there are items which were selected, these same items remain selected after the change, even if they have moved.

* When an operation (Import, Export, Sort, etc.) is completed, the result in the Status Bar no longer mixes results from repeated operations into the same item in the comma-separated list, but instead lists them as separate items, so that this is no longer a head-scratcher.  The tooltip which is shown when text of old results overflows the Status Bar has been reformatted to be more readable, and the time that results are shown before being discarded has been increased back up to 10 seconds.

* Fixed a bug which sometimes caused recent bookmarks changes in Firefox to be missed when importing from or exporting to a Firefox *Other Macintosh Account* client.  This bug may also have affected simple Firefox clients (those on the current Macintosh account), although we've never seen this happen unless Firefox had crashed or been force quit.  (Now checkpoints the Write Ahead Log used in Firefox 4.0 or later, before importing or exporting Firefox clients while Firefox is not running.)

* Pre-processing to export a large Bookmarkshelf documents (thousands of bookmarks) to web a app Client (Google Bookmarks, Pinboard, Delicious) no longer takes a really long time.

* Fixed a bug which caused spurious changes to be indicated when exporting to a Client if Special Options affecting mapping of items had been set.  This is possible for Clients of  Opera, Google Chrome, and Chromium.

* When exporting to a Client which is not hierarchical, that is, does not support folders, the *Merge Folders* step, which can take several seconds in a Bookmarkshelf containing thousands of items, is now skipped.

* Occasional failures to quit web browsers when needed to perform an Import or Export have probably been fixed, thanks to AppleScript guru [Shane Stanley](http://www.macosxautomation.com/applescript/apps/index.html).

* Fixed a bug which caused Undo to fail in some cases.

* Fixed a bug which caused changes in item attributes, for example a bookmark's name, to be not counted if the item had also been moved or slid within its family by an Import or Export operation.  This could cause under-counting of changes, allowing an Import or Export operation which had over the Safe Limit number of changes to be not detected as such.

* When performing an Import or Export to a web browser's built-in bookmarks on another Macintosh account, the warning to quit web browsers on the other Mac account now has a checkbox to *Don't show this warning again*, and this is also controllable in Preferences > General.

* When exporting bookmarks to an *Other Mac Account* client, no longer tries to set the Unix Group ID of whatever files are written.  Prior versions would try to set the Group ID to the Group ID of the new file's parent folder, which resulted in a failure, even after authenticating as an administrator, if someone had annointed this parent folder with a weird group ID such as *501*.  (We no longer try to copy other peoples' mistakes.)

* Fixed a bug which was introduced by a recent change in macOS that caused *no browsers bookmarks* to be found when configuring an *Other Mac Account (Advanced)* client on another Mac, if the other Mac was not mounted with authentication as that other user.

* Fixed a bug which could cause the sheet warning that a Bookmarkshelf must be in The Cloud to appear multiple times after a *from The Cloud* trigger is added.

* Fixed a bug which caused a message about  a *Client* entity being *deallocated while key value were still registered with it* to be printed to the system console whenever a Bookmarkshelf window containing a  Client for which the Advanced Client Settings sheet had Special Options which had been showing was later closed.  Theoretically, this also could have caused a crash or other subsequent unexpected behavior.

* During Import and Export operations, the intervals when the Status Bar momentarily goes blank instead of showing a progress indication are fewer and shorter.  Progress is shown more consistently.

* Fixed a bug which caused the titles of the entries in the popup menu in a Bookmarkshelf window *Reports* > *Sync Log* (formerly *Diaries*) to not update immediately when an entry was changed.

* Cosmetic improvements were made in Bookmarkshelf window's Settings > Agents > Simple.

* Cosmetic improvements were made in Bookmarkshelf window's Settings > Clients.  The tooltip explaining what a *Client* is now only appears when the mouse is over the Client List View, instead of when anywhere in the whole tab view.

* Cosmetic repairs were made to the list of Clients presented during the *New Bookmarkshelf* wizard.


## BookMacster Version 1.5.6 (2011-06-05) (Alpha)

* In a Bookmarkshelf's *Setting* > *General*, the *By default, visit bookmarks with* popup, and in Inspector, the *Visit this bookmark with* popup no longer contain empty menu items representing browsers which are supported by BookMacster but not installed on the user's system.

* Fixed a bug which caused exports to subsequent browser Clients to be aborted if an error occurred when exporting to a prior browser Client.

* Automatic saving of a Bookmarkshelf when landing a new bookmark, in addition to occurring immediately after the bookmark is added, also now occurs, if the Inspector pops up, edits are made, and the Inspector is closed within 60 seconds.

* No longer attempts to install a browser add-on which we know won't work during each Import and Export operation.  For example, BookMacster's Firefox Add-On is not yet compatible with Firefox 5, pending resolution of a [bug](http://bugzilla.mozilla.org/show_bug.cgi?id=653971) in a Firefox 5 component.

* When creating a new Client for Opera, the Advanced Options to "Import items marked 'Show on Personal Bar' into Bookmarks Bar" and "Don't import items from Trash" are now ticked ON by default.

* Preferences > Adding tab is now large enough to show the bottom of the last control withit clipping.

* Advanced Agents with a *Scheduled* trigger now begin promptly at the scheduled time instead of being subject to the 5-minute delay that other triggers are subject to.

* Fixed a bug which sometimes raised an exception and could cause future unexpected behavior including crashes and items appearing in the Content Outline as disclosure triangles with no name.

* Fixed a bug which raised an exception, possibly causing unexpected behavior, if the ↑ or ↓ keys were hit while the list of Clients was being displayed in during the New Bookmarkshelf wizard, or while the *Settings* > *Clients* tab was being displayed.

* Clicking the "Perform" button in Agents > Advanced to no longer quits web browsers if necessary to perform the commands if the options in the Trigger did not specify to do so.

* Eliminated some unnecessary data in Bookmarkshelf Documents that have Safari Clients.  Documents will be updated the first time that they are opened in this version.

* Fixed a bug which caused clicking "Cancel" when presented with the dialog indicating that an Import or Export operation exceeded the Safe Limit of changes to not always undo the Import if multiple Clients were involved.

* Increased the timeout for importing bookmarks while while a Client browser is running from 80 seconds to 90 seconds, fixed a bug which caused a crash if the timeout is exceeded, and changed the error message of this timeout to advise the user that the process can be speeded up by quitting the slow Client, usually Firefox.

* The *Cancel* button has been removed from the sheet that shows the list of available Clients during the New Bookmarkshelf wizard, because at that point it's already too late to cancel creating the document.

## BookMacster Version 1.5.4 (2011-05-29)

* A *Play Sound* checkbox has been added to *Preferences* > *Adding* so that users may land bookmarks from the BookMacsterize Bookmarklet or the Bookmarking Widgets in Firefox and Chrome in silence.  *Play Sound* is on by default.

* The *Duplicate* sound effect (two quick beeps) now always plays when landing a duplicate bookmark, instead of only when BookMacster is in the foreground.

* In a Bookmarkshelf *Settings* > *Clients*, it is no longer possible to add more Clients than are available on the user's Macintosh account, which in previous versions resulted in phony clients labelled *Under Construction…* to be added.  Also, bugs were fixed which could cause a crash later, after such a phony client had been added.

* Fixed a bug which could cause the *Do sort* / *Do not sort* setting of folders which are initially visible in a Bookmarkshelf's Content when opened to revert to their default setting.

* Fixed a bug which, apparently, caused *Client* settings to not appear in the *Settings* > *Clients* tab for some users.

* Fixed a bug which sometimes caused duplicate bookmarks to be deleted during exports.

* When opening a document and finding minor corruptions which can be fixed, even if some settings are unknown and must be reset to default values, added several cases where this is done so.  (Prior BookMacster versions would refuse to open the document, and present an annoying error dialog, if any settings needed to be assumed.)

* Similarly, when opening an old Bookmarkshelf and finding that an auxiliary file of Settings, Diaries or Identifiers is corrupt, now silently sets the unreadable file aside by adding a one or more "#" to the end of the file's base name, and creates and uses a new file with empty/default settings.

* Fixed a bug so that the middle button in the dialog which appears when landing a duplicate new bookmark now says *Keep Both* instead of the semi-sensible *Keep matched item from Both*.

* Fixed a bug which caused a crash when opening some old Bookmarkshelf documents under macOS 10.5.

* Fixed a bug which caused a crash when attempting to import from or export to Firefox or Chrome if another instance of BookMacster was already running, or for some other reason macOS refused to give BookMacster the port that it uses to receive data from Firefox and Chrome.

* Added an *Uninstall…* operation which is executed by a new item in the *File* menu.

## BookMacster Version 1.5.3 (2011-05-27)

* Now plays sound effects when landing a new bookmark from the BookMacsterize Bookmarklet or the Bookmarking Widgets in Firefox and Chrome.

* Fixed bugs which caused the "Show Menu" menu item, which is available in the Status Menulet when BookMacster has been set to launch in the background, to not always show windows properly.  Also, the name of this menu item has been changed to "Show BookMacster".

* Fixed a bug which caused an error to be displayed, indicating that a browser add-on could not be installed into Camino when attempting to import from Camino while Camino was running.  The error was wrong because Camino does not support a browser add-on.

* Fixed a bug which caused the *Merge by URL* option to be ignored on some imports.

* Fixed a very old bug which caused the "Show on Personal Bar" attribute to not be *exported* to Opera bookmarks which should have had them.

## BookMacster Version 1.5.2 (2011-05-26)

* Fixed a bug which caused the Bookmarkshelf Window to not be populated with text, and many of its functions to not work, or in Mac OS 10.5 to not open at all, if its Clients were web apps such as Pinboard or Delicious in some combinations.

* Improved the Help Book sections 0.1.1 *Getting Started* and 1.2.2 *How to Configure Syncing*.

## BookMacster Version 1.5.1 (2011-05-24)

* Fixed a crash introduced in version 1.5 which occurred when attempting a *Quick Import* from a *Choose File (Advanced)* Client.

* A couple cosmetic fixes in the Bookmarkshelf window.


## BookMacster Version 1.5 (2011-05-24)

This update includes the first general release of our Firefox and Chrome extensions, which make it possible to detect bookmarks changes while Firefox and Chrome are running, import from and export to Firefox and Chrome while they are running, and, optionally, install bookmarking widgets which are nicer to use than the BookMacsterize bookmarklet.  This version is also able to launch in the background, has major improvements to the sync triggering processes, uses a much more reliable method for identifying Firefox bookmarks, does a better job of watching its file for updates, and has many other improvements, updates and bug fixes.  If you are syncing with Firefox as a Client, this version **requires Firefox 3.6 or later**.  Enjoy!

* The *Bookmarks Changed* trigger is now available for Chrome and Chromium as well as Firefox and Safari.  For users who have directed an Agent to *Import Changes from Clients*, bookmarks changes made within these browsers are now imported within 5 minutes (and sorted and/or synced to other Clients and back into Chrome), instead of being deferred until the browser has been quit.  If the computer is put to sleep or is shut down before the Agent activates, the operation is run after waking or starting up.

* Added the capability to install *Bookmarking Widgets* into the Firefox and Google Chrome web browsers.  These are more handy alternatives to the BookMacsterize Bookmarklet, for users who are keeping their bookmarks in BookMacster now instead of syncing browsers built-in bookmarks.  To install a widget, check the appropriate box in Preferences > Adding.

* The New Bookmarkshelf wizard has been improved based on user feedback.  Instead of offering to automatically activate Agents in most cases, it now offers to open to a little *Getting Started* diagram in the Help Book which shows the user how to get started, why Agents are sometimes used, and what should be done before activating one to make sure that there are no surprises.

* Added a menu command *BookMacster* > *Manage Browser Add-ons*, which opens a new window in which BookMacster's Extensions and Plugins for Chrome, Chromium, and various Firefox profiles can be installed, updated, tested and uninstalled.

* Running in a Macintosh account with a preferred language of French, German, Italian, Japanese or Spanish no longer results in a patchwork of English and non-English text in the user interface.  For now, BookMacster is *not* localized; all text appears in English.

* Vast improvements have been made to the reliability of the mechanism which triggers Agents to do sorts, syncs, etc.  In order to work around the less-than-stellar reliability which we have observed in the launchd mechanism macOS, we now re-create launchd agents after each use, and use our own mechanism to throttle them.  In addition, Standby agents watch while an Agent is running, in case a system crash, logout or shutdown interrupts a Worker process.  The whole thing is much more robust and self-healing.

* In *Preferences* > *General*, added a checkbox to *Launch in Background*.  Users who are using the Bookmarking Widgets or BookMacsterize Bookmarklet, and are visiting bookmarks with the Status Menulet now have the option of keeping BookMacster completely in the background and not even in the Dock.  To provide necessary control in this mode, two menu items, *Show Menu* and *Quit BookMacster* have been added to the Status Menulet.

* In the Status Menulet and Dock Menu, when no Bookmarkshelf is open, the menu item *Open Recent and Minimize* has been renamed to *Open Recent, Into Dock*, and two more menu items have been added: *Open Recent* and *Open Recent, Invisibly*.  The last item only appears when BookMacster is Launched in Background.  So now there are three ways to open a Bookmarkshelf: in a regular window, in a regular window but immediately minimized to the Dock, and invisibly, in the background.

* Added some graphics to the Bookmarkshelf tab *Settings* > *Agents* > *Simple* so it's easier to visualize what each of the four checkboxes do.

* If Worker is triggered to perform for an Agent while BookMacster is running, and the Bookmarkshelf which needs work is open in the BookMacster app, the Worker will now tell the running BookMacster to perform the work even if BookMacster is the active application, instead of ignoring the trigger.  This is because the work usually performs syncing of bookmarks, and on the rare occasions when this occurs while the Bookmarkshelf is active in BookMacster (generally while either our Test Department or a user is stress-testing BookMacster's synchronization by making multiple bookmarks changes in multiple browsers on multiple Macs sharing the same Bookmarkshelf via Dropbox™), we've concluded that it is more important to maintain synchronization of bookmarks than to worry about the user being interrupted once in a blue moon. 

* BookMacster is now more watchful of the document's .bkmslf file.  If another application moves or renames the file, BookMacster knows immediately, even if it is not the active application, and is less much less likely to be outsmarted by Dropbox™ or other sync services churning files around.

* If an open and active Bookmarkshelf window has its file modified on disk (for example, due to an update by Dropbox™), the warning of conflict, with choice to Ignore or Revert, is no longer displayed unless the Bookmarkshelf has unsaved changes.

* The warning dialog that "You have never exported this content to *X Client*" prior to closing a new Bookmarkshelf which has an unexported Client has been eliminated, since it was annoying and does not make sense for Usage Style 3 (Keeping your bookmarks in BookMacster) which is now recommended.

* When login to Pinboard or Delicious fails due to bad credentials in Keychain, the dialog of re-entering username and passwords is now commenced automatically.

* *File* > *Revert* now executes much faster since the document is no longer reloaded from scratch.  It's still not as smooth as, say, reverting a TextEdit document, but it's as good as it gets without abandoning Apple's Core Data technology, which we don't want to do.

* In the *File* menu, under submenus *Quick Import* and *Quick Export*, the suffixes have been changed from *(Your Settings)* and *(Default Settings)* to *(Client Settings)* and *(QuickMerge – No Delete)*.  The actions are the same, but we hope that they are better implied so that fewer people need to look them up in the Help Book.

* Fixed a bug which, depending on their relative locations, could cause a bookmark which was duplicated in a single Client to only be imported once.

* Reduced some unnecessary launches and re-examination of bookmarks by additional Worker processes after a first Worker process, which actually did something, had terminated.

* BookMacster no longer creates or presents errors when Workers are unable to find Triggers, Agents, or Bookmarkshelf Documents required to perform tasks.  The tasks are aborted silently.

* Fixed a bug which allowed the index numbers of Triggers to sometimes get out of sequence when Clients were removed while the Agents were showing their Advanced view.  This in turn could cause Agents to fail with an error that the requested trigger index was higher than the number of triggers available.

* Fixed a bug which allowed the index numbers of Commands to sometimes get out of sequence when Commands were added and/or deleted in Agents > Advanced view.

* Fixed a bug which, under rare conditions, could allow two Agents to run simultaneously, giving unexpected results.

* Fixed several bugs in the way that hidden proprietary attributes are exported to Opera, to conform to Opera version 11.x.

* Fixed a bug which sometimes caused Agents to still be indicated in the user interface after they had in fact been automatically deleted due to an error.

* When opening a Bookmarkshelf, the silent Integrity Test which runs now detects and corrects discontiguous indexes in any folders' children.

* Fixed bugs which caused Worker processes to be killed prior to normal completion if an error occurred.  Although the user did not see this, its may have been causing other unexpected behaviors.

* Fixed a bug which caused a warning to indicate that the document's file has been modified by another application if problems were detected and repaired while opening a Bookmarkshelf, and said Bookmarkshelf was later modified and saved.

* In menu *BookMacster* > *Logs*, the number of updates given in *Will save changes in BkmxDoc* enrties is no longer inflated above the true value.

## BookMacster Version 1.3.22 Alpha (2011-04-19)

* When importing from multiple Clients, when merging folders, if merged folders come from different Clients, the folder that is kept is now reliably the one from the higher Client in the table of Clients (Settings > Clients).

* When deleting empty folders at the end of an Import or Export operation, folders which contain only other folders which were also emptied as a result of merging items and consolidating folders are now reliably deleted.  (We now empty folders in order of depth, starting with the deepest.)

* This version requires that Camino be quit before exporting *or importing* with it, which eliminates the possibility that bookmarks changes in Camino will not be imported.  (Prior versions only required that Camino be quit before exporting.)  The reason for this new restriction is that recent versions of Camino do not always write bookmarks changes to the disk until Camino has been quit, and also because Camino does not offer a facility by which BookMacster can use to access its bookmarks while it is running, as Safari, Firefox and Chrome now do. 

* Fixed a bug introduced in version 1.3.19 which caused, during an import operation from multiple Clients, folders which were not pre-existing in the Bookmarkshelf but came from an Import Client, and which were emptied as a result of merging bookmarks among the multiple Clients, to be imported into the Bookmarkshelf as empty folders, instead of being deleted as stated in the documentation. 

* When quitting [Chromium](http://build.chromium.org/f/chromium/snapshots/Mac/) in order to perform an Import or Export operation, if the user OKs installation of the Extension, for the next such Import or Export, Chromium no longer needs to be quit.  (The Internet Plug-in which is installed along with the Extension now works with Chromium as well as with Google Chrome.)

* If an older version of BookMacster is launched after using a version built with a newer data model, the error arising from the inability to log is now logged silently and is no longer presented to the user in an error dialog, several times.  

* In Inspector, if the Mac OS does not give a display name for a browser when displaying the *Visit this bookmark with* menu, now logs the error to the system console and substitutes an alternate name.

* Possibly fixed a bug which causes, on rare occasions, the "BookMacster will now install an extension…" dialog sheet to appear twice when installing an extension into Google Chrome or Firefox, with the second sheet not rolling up until the window was closed.

## BookMacster Version 1.3.21 Alpha (2011-04-15)

* The *Bookmarks Changed* trigger now works for Firefox as well as Safari Clients on the current user's account.  The *Bookmarks Changed* trigger causes changes in Firefox bookmarks to be sorted and/or synced to other Clients automatically, a few minutes after they have been changed, instead of being deferred until Firefox has been quit.  

* Fixed a couple bugs which could cause the dialog process for choosing a Client on with *Other Mac Account* to end without explanation before the browser had been chosen.

* Fixed a bug, introduced in version 1.3.19, which caused the dialog process for choosing a Client on with *Chooose File (Advanced)* to show *No Selection* after a file had been chosen, and fail to Import or Export.

* Fixed a bug which caused soft folders to be deleted and replaced with identifical soft folders (*churned*) when importing from a loose file (*Choose File*), closing the document, re-opening, and re-importing.

* Fixed a bug which sometimes caused the same dialog to appear the next time, if user began to close a document with a new Export Client that had never been exported to, and then clicked *Export and Close* in response to the warning of that.

* Fixed a bug which, if user began to close a document with a new Export Client that had never been exported to, and then clicked *Close* in response to the warning of that, with certain documents, if one of the columns in the Content or Reports > Find tab had been set to show 'Tags', sometimes caused a crash.

## BookMacster Version 1.3.20 Alpha (2011-04-09)

* Fixed a bug which could cause our Chrome Plug-In to display a "unexpectedly quit" crash dialog as it Chrome was quitting.

* Moved the location of our Chrome Plug-In in the package, from Contents/Resources, to Contents/Plugins, per Apple recommendation TN2206.

## BookMacster Version 1.3.19 Alpha (2011-04-09)

This release is *alpha* because it updates your Bookmarkshelf documents in a couple ways, and more importantly it includes our new **Firefox Extension**.  For now, the extension merely allows BookMacster to export to or import from Firefox without quitting Firefox.  We plan that the next version will install a Firefox menu item to replace the *BookMacsterize* bookmarklet, and allow changed Firefox bookmarks to trigger an Agent before Firefox quits, working as we do now with Safari.

To install the Firefox extension, launch Firefox, then open a Bookmarkshelf in BookMacster 1.3.19, and *Import* from (or *Export* to) Firefox.  If you don't want the import, either click *Edit* > *Undo Import* or close the document with *Don't Save*.  If you have multiple Firefox profiles, this must be done for each profile.

We've found that Firefox is quite slow to insert and delete new bookmarks.  While this is not an issue during normal day-to-day operation when you're adding a few bookmarks, if you're doing a "wholesale" export which inserts or deletes hundreds of bookmarks, it will be much faster to quit Firefox so that the our old method will be used instead.  On a typical Mac, with Firefox running, expect 4 minutes per thousand bookmarks, during which time Firefox will beachball.

This version drops support for Firefox 3.0 - 3.5.  Import or Export of Firefox bookmarks with this version of BookMacster now requires **Firefox 3.6 or later**.

Changes in this version:

* No longer requires that Firefox be quit during import or export with Firefox (except for the first import or export after this update, or once after a new installation of BookMacster, to allow a Firefox Extension to be installed.)

* Improved performance during *Delete All Duplicates*, *Delete All Content*, and *Consolidate Folders* operations when large numbers of items are being deleted, by reducing peak memory allocations.

* Improved performance when moving or deleting large numbers of items in the Content View, by reducing peak memory allocations.

* Improved performance when importing large numbers of Firefox bookmarks

* Landing a new bookmark from the BookMacsterize Bookmarklet now resets the filter criteria (Quick Search text and Tag Filters) in the Bookmarkshelf's Content View, so that these filters no longer prevent the new bookmark from being selected and thus displayed in the Inspector.

* An Agent is no longer removed when its last Trigger is removed in *Settings* > *Agents* > *Advanced*.  This is to allow advanced users (and our Automated Testing Department) to employ triggerless Agents which are run via BookMacster's *perform agent* AppleScript command.

* When relaunching a web browser application after an Import or Export operation which required it to be quit, if multiple instances of said web browser are installed, now always relaunches the same instance which had been quit.

* This version makes better decisions of which item to keep during *Delete All Duplicates* operations, *Consolidate Folder* operations, and the *Merge Folders* phase of Import and Export operations.

* Fixed a bug which caused a crash later, after clicking in the menu *File* > *Quick Import* > *Delicious-Yahoo! (New/Other)*.

* Fixed a bug which aborted an import or export requiring all bookmarks to be requested from the Pinboard server, and displayed an error, saying that an identical request had been made less than two minutes ago and that the operation could result in the user being temporarily being banned by the server, if in fact the prior request had actually been made to Delicious and not Pinboard, or vice versa.

* Fixed a bug which caused changes made to Clients > Advanced Settings > Export > Safe Limit to sometimes not be registered after the document was closed.

* Fixed a bug which caused errors originated by BookMacster-Worker (Agent) processes to sometimes be displayed and logged several times.

* Fixed a bug which caused the Verify operation to end before all eligible bookmarks were verified upon encountering a bookmark with no name (nil, not an empty string).

* Fixed a bug which caused a warning to be displayed saying that Google Chrome Sync was syncing Bookmarks, when in fact it was syncing only other data, for example Apps and Extensions.

* If a Firefox profiles.ini file is not accessible during Import or Export with a Firefox client, BookMacster-Worker now generates an error message instead of crashing.

* Now, automatically sets aside corrupt Settings files so that Error 315006 is not displayed repeatedly.

* More explicit instructions recovery instructions are given for  Error 354160.

* Omits exporting bookmarks whose scheme is "chrome://" to Firefox, since Firefox chokes on them.

* No longer stores normalized and un-normalized URLs of bookmarks as separate attributes; all URLs are normalized immediately upon import or other entry, and only this value is stored and exported to all Clients, whether the Client normalizes URLs or not.  (At this time, Chrome, Delicious, Firefox, Google Bookmarks and Pinboard all do normalization, and although Chrome and Firefox are quite similar, none of them behave exactly the same in all cases.)  This is mostly an under-the-hood change to reduce complexity and increase efficiency; however it has some noticeable facets.  For example, if the user types in a new bookmark with url "http://apple.com", a trailing slash (path) is now added as soon as the entry is complete, changing it to "http://apple.com/".  URLs in Bookmarkshelf documents created with earlier versions of BookMacster are silently updated and the documents are re-saved immediately when they are opened with this version of BookMacster.  Note: URL *normalization* is called *canonicalization* by developers at Google.

* Now uses a more robust globally unique identifier (guid) when matching Firefox items during Import and Export, instead of the primary key.  This should eliminate some rare but annoying corner cases wherein a Firefox export would fail indicating an "SQL Error" of some kind.  For Bookmarkshelf documents created with earlier versions of BookMacster which have Firefox Clients, their associated [identifiers](exid) files are silently updated when the associated document is opened for the first time with this version of BookMacster.  Also, if items in the Firefox database do not already have globally unique identifiers (as is the case if the user has never used Firefox 4.x and never used any other bookmarks management application), globally unique identifiers are created and added to Firefox' bookmarks database.

* Uses a more robust algorithm for importing and exporting to Chrome while Chrome is running, to eliminate some corner cases where items could get their identifiers crossed, causing them to end up in the wrong location.

* Eliminated a performance bottleneck which occurred while opening or scrolling through items in the Content window which are associated with (Advanced) Clients that are Loose Files which have been deleted since the last Import or Export.

* Now always updates the rare hidden client-proprietary attributes of items during imports and exports, even if no other attributes of the item have changed.  Hidden client-proprietary attributes are, for example, the "Use as Dock Menu" checkbox in Camino, the Check (Verify) frequency setting in OmniWeb.

* Items in a Bookmarkshelf newly-created by a Save As operation no longer incorrectly show Diary entries, Clients and associated identifiers from the spawining document until the new document is closed and re-opened.  Also, new associations are now correctly set if an Import or Export operation is executed before closing and re-opening.

* Eliminated memory leaks of auxiliary objects (identifier links, diary records, settings) after Bookmarkshelf documents are closed.

* Eliminated unnecessary storage of empty identifier links for Content items that are not associated with a Client.

* When BookMacster-Worker sends an AppleScript message to BookMacster to display duplicates found or display an error, it now specifies the path to BookMacster currently in use, which eliminates the possibility that macOS will choose the wrong BookMacster in the event that the user has more than one copy of BookMacster on their computer.

## BookMacster Version 1.3.18 (2011-02-05)

* No longer modifies some URLs during an *Export* to Google Chrome.  Examples: No longer deletes the *path* portion of a URL if it is 'index.htm' or 'index.html'; no longer removes trailing slashes on non-empty paths.  Some of these modifications could cause a some bookmarks to visit the wrong site.  (Succinctly, no longer *normalizes*, or as they say *canonicalizes* URLs when exporting to Google Chrome.)

* Fixed a bug which could cause BookMacster or BookMacster-Worker to hang during an Import operation.  The only known trigger for this bug was having multiple *Import* commands in the same *Agent*, which is odd, and only affected BookMacster-Worker.  But possibly there were other triggers.

## BookMacster Version 1.3.17 (2011-02-03)

* Fixed a bug introduced in 1.3.15 which caused an Export to Google Chrome to fail with error 165825 if an Export was attempted before the first Import after updating, and if version 1.3.14 had been used.

## BookMacster Version 1.3.16 (2011-02-03)

* Old version of NPAPI Plugin was shipped in Version 1.3.15; caused imports and exports with Google Chrome to fail, if Chrome was running.

## BookMacster Version 1.3.15 (2011-02-03)

* Reliably re-activates the *correct* web browser, in cases where the Inspector does not show, after landing a new bookmark from the BookMacsterize bookmarklet.  In particular, no longer activates Safari when the bookmark came from Google Chrome.  (Digs out the sender of the Apple Event instead of trying to decode its User Agent string.)

* When creating a New Bookmarkshelf, for the first Client, under Advanced Settings > Export > Merging, the *Keep matched item from" is no longer set to the Client but is set to "Bookmarkshelf", same as the other Clients.

* Fixed logging into Google Bookmarks, to accomodate recent protocol changes by Google.  (Gets GALX from HTML if not provided as cookie.)

* When asking if a browser should be relaunched during an Import or Export, other tasks in the Import or Export are now postponed until the user clicks their response.  This is to reduce user confusion, and also prevents sheets from being left hanging if the user clicks responses out of order.

* Now reliably gets even the lastest changes when importing frome Google Chrome while Chrome is running.  (Chrome Imports now also use Extension if Chrome is running).

* If a web browser must be quit in order to complete an Import or Export operation, the dialog sheet announcing this no longer bears the ominous title "Error: 1060".

* Bookmarks dragged from the *Show [All] Bookmarks* or *Show All History* window of Safari version 5.0.3 or later are now accepted as drops.

* When installing the Extension into Google Chrome, if the window which opens in Google Chrome is not wide enough to show its extension-installation controls in its status bar, now makes this window wider.

* Menu items Bookmarkshelf > Import and Export now list Clients in correct order.

* Added checks to prevent crashes when dealing with Clients that were incompletely constructed for some reason.

* In the Inspector Panel, Identifiers drawer, any new Clients' identifiers are now updated after an Export without switching to a different item and back.

* Additional information is now provided with Error 1538022.

* During Import or Export with Firefox, the progress bars in the Status Bar are now all consistently sized to complement the progress text.

## BookMacster Version 1.3.14 (2011-01-23)

Note to our beta testers:  Version 1.3.14 is exactly the same as version 1.3.13 except that the label *Beta* has been removed.  Thank you for testing!

* Now supports Firefox 4.0 which is in beta.  No longer fails to Import or Export bookmarks which have been written by Firefox 4.0 beta with Error 453008.

* Other improvements to the robustness of Firefox Imports and Exports.

* No longer requires that Google Chrome be quit before exporting to Google Chrome (except for the first time after this update, or once after a new installation of BookMacster, to allow our new Chrome Plugin and Chrome Extension to be installed.)  Note: This does not yet apply to Firefox, but will in a future version.

* When moving items from one Bookmarkshelf document to another using the Move To… contextual menu item or drag and drop, the Move operation is silently changed to a Copy operation, meaning that the items are not deleted from the source Bookmarkshelf document.  This is to conform to Apple Human Interface Guidelines.

* A New Bookmarkshelf now has its *Safe Limit* for Import and all of its Export clients set to 25 changes maximum.  This is so that new users who click *Later* instead of *Do It* when asked if an Import should be performed during the New Bookmarkshelf Wizard will not accidentally delete many bookmarks in their Clients if they later Export before Importing.  Also, additional warning text now appears if more than 25 items are set to be deleted.

* The *Ignore Duplicates in Different Hard Folders* setting now considers bookmarks which descend from soft folders which descend directly from Root to be in the Root, and consider the Root to be a Hard Folder.

* Fixed bugs which sometimes caused exceptions to be logged, or values of prior selections to be displayed in the Inspector, and fields to be enabled in the Inspector, when there was no selection to edit.

* Fixed bugs which sometimes caused the Duplicates Status near the top of the Reports > Duplicates tab to not be updated after duplicates were eliminated.

* Fixed bug which caused hyperlinks in Help Book to fourth-level headings to be broken links.

* Fixed some program code which may have been allowing the Verify operation to abruptly stop on rare occasions.

## BookMacster Version 1.3.10 (2010-12-18)

* Fixed a bug which sometimes caused items to not be deleted in the Client during an Export operation, which could lead to duplicate items.

* In the Client's Advanced Settings sheets, the controls to *Merge By URL* are no longer disabled when the corresponding *Delete Unmatched Items* box is checked.

* Now properly exports items to Bookmarks Bar in Opera 11.  (Note: In previous Opera versions, the Bookmarks Bar was called *Personal Bar*.)

* Now properly presents several strings regarding Opera when Opera 11 is in use; no longer substitutes the word "Opera" in some controls.

## BookMacster Version 1.3.9 (2010-12-16)

* Fixed a bug which could cause items deleted during an import to remain as unconnected *orphans* in a .bkmslf file. 

* In various contextual menus, the *Show Inspector* item is no longer permanently disabled.  It is now enabled if the Inspector is not showing, and absent if the Inspector is already showing.

## BookMacster Version 1.3.8 (2010-12-12)

* Added a *Consolidate Folders* menu item in the *Bookmarkshelf* menu.  This command merges like-named folders in the same parent folder into one, and deletes any empty soft folders in the Bookmarkshelf.

* Now supports the beta version 11.0 of the Opera web browser.

* Fixed a bug which aborted drawing of the hierarchical menu in BookMacster's Status Menulet upon attempting to draw a Separator which had been imported from an XBEL file.

* Separators in BookMacster's Status Menulet are now properly drawn as actual menu separator items instead of as bookmarks named "Separator".

* Upon opening a Bookmarkshelf, now detects and silently deletes any conflicting agents from deleted Bookmarkshelf documents.  Such a "ghost agent" can be created by setting an Agent in a Bookmarkshelf, then closing it and deleting the .bkmslf file, then creating a new Bookmarkshelf at exactly the same file path as the one which had been deleted.

* In the Settings > Clients tab, hovering the mouse over a Client popup set to a *Choose File (Advanced)* type of Client now produces a tooltip which shows the path to the Client's file.

* No longer produces extraneous warnings in console log during creation of a *Choose File (Advanced)* Client. 

* No longer produces extraneous warnings in console log during Import or Export of Google Bookmarks Clients. 

* Errors produced when unable to open a Bookmarkshelf document now include information about the parent process.

* Triggers based on Clients are now only allowed for Clients which have the Import option checked ON, and if a Client is deleted or if a Client's Import option is checked OFF, triggers based on watching it are deleted.

* Simple Agents now properly re-set the underlying (Advanced) Agents when Clients are added, deleted, or activated or deactivated for Import.

* Checking integrity of Agents is now performed when a Bookmarkshelf window is closed, instead of when it is saved.  This is to reflect the fact that, in recent versions, Agent settings have been stored as Local Settings, and not in the Bookmarkshelf document file.

* Fixed a bug which caused extraneous entries in the system log when bookmarks in Soft Folders were exported to Clients such as Google Bookmarks which do not support Soft Folders.

* Fixed a bug which could cause a crash after beginning to add a Google Bookmarks client but cancelling during the process.

* Fixed a bug which caused some Bookmarkshelf documents last saved with BookMacster 1.1.x or earlier to fail to open.

* Import and Export statistics (shown in the Status Bar after an Import or Export), and also the Diary Reports, now report a fifth change type called *Moves* (↖), which indicate when an item has been moved to a new parent.  Prior to this, there were four change categories: Additions (+), Updates (Δ), Slides (↕), and Deletions (-).

* During an Import or Export operation, when multiple items which are in the root level of the source cannot be mapped into the root level of the destination due to its structural restrictions, they are now mapped into the default parent using the same order in which they appeared in the source.

* During login to Import or Export with Google Bookmarks, now properly handles when Google acknowledges a non-Google account name with an @googlemail.com account name.  This can occur if a Google account is created with a non-Google email address, which gets into the user's macOS Keychain as such, and a BookMacster Client is created with this account name, but in the meantime a @googlemail email is added to the account.  Prior verions of BookMacster were able to handle if a @gmail.com email address was added and returned, but in some European countries, Google uses googlemail.com instead of gmail.com.

## BookMacster Version 1.3.4 (2010-11-14)

This version has several bug fixes and performance improvements.  (Early adopters who have 1.3.3 may skip this update since there are no new changes.)

* Eliminated a performance logjam which would cause seconds of beachballing after making any change to the Content, in a Bookmarkshelf with many thousands of bookmarks and many duplicates.

* Eliminated a performance logjam which occurred when importing a large XBEL file containing many duplicated bookmarks that also do not have externally-supplied identifiers.

* Fixed bugs which prevented Bookmarkshelf documents created on very old versions of BookMacster from opening.

* Eliminated occurrence of Error 32452 when setting an Agent on some Macs which, for some strange reason, require -w or -F option to launchctl(1) in order to load some launchd jobs, even if the launchd job does not have a 'Disabled' key.

## BookMacster Version 1.3.1 (2010-11-08)

**Important:** If you are syncing bookmarks via The Cloud, after you install this update on one Mac, current (older) versions of BookMacster on your other Mac(s) will display an error when attempting to open synced bookmarks, until you update their BookMacsters too.  **Just click in the menu *BookMacster* > *Check for Update* to fix the problem.**  (Improvements in *this* update will make this process neater in the *next* update.)

* In Import and Export settings, the terminology *Clean Slate* has been changed to *Delete Unmatched Items*.

* Now able to import and export bookmarks files in the [XML Bookmark Exchange Language (XBEL) file format](http://xbel.sourceforge.net/).  Therefore, migrations are now possible between other bookmarks management applications which also support XBEL, such as *URL Manager Pro™* and *Webnote™*.

* In the File menu, added two new items, Quick Import and Quick Export.  Usage is explained in a [new section](https://sheepsystems.com/bookmacster/HelpBook/imEx1Client) in the Help Book.

* After purchasing a Regular License on one Mac, if syncing a Bookmarkshelf to on other Macs via The Cloud, it is no longer necessary to manually copy the new License Information to the other Macs.

* Added ability to set text color for each bookmark and folder (Inspector Panel).

* Added preference to set font size of contextual menus and status menulet menu (Preferences > Appearance).

* In BookMacster's Status Menulet, the three *Visit* items now appear in contextual menus on the first click, even if the clicked document window is not yet the frontmost or key window.

* Now remembers deleted items if an Export operation fails to a certain browser, and ignores them on subsequent imports.  This prevents, for example, deleted bookmarks from reappearing if export fails because a non-cooperative web browser is running, and then later bookmarks are re-imported from this browser/Client.

* When *this* version of BookMacster attempts to open a Bookmarkshelf document created by the *next* version of BookMacster (as will happen if a user updates BookMacster on one Mac, saves a Bookmarkshelf, that Bookmarkshelf gets updated via The Cloud to another Mac, and then either the user or an Agent attempt to open that Bookmarkshelf on  the other Mac), a concise message will be displayed, with a *Check For Update* button to solve the problem immediately.

* When creating a new Bookmarkshelf, if no other Bookmarkshelf is set to open when BookMacster launches, the new Bookmarkshelf is now automatically set to do so.  If other Bookmarkshelf(s) are already set to open when BookMacster launches, now presents a sheet asking user "Yes" or "No".

* If a Bookmarkshelf is created with Client(s) whose *Export* is checked ON, and the user attempts the close the document before exporting at least once to all such Export Client(s), a warning sheet will appear with recovery button options "Close", "Export and Close", and "Cancel".   Clicking "Export and Close" will export to those Client(s) which have never been exported to by this Bookmarkshelf.  This warning will never appear again, even on subsequent launches, after each such Export Client has been exported to at least once.  It will appear again if the user adds a *new* such Export Client, and attempts to close before exporting.

* Now able to migrate the hidden Application Support files (Logs, Settings, Diaries and External Identifiers) after doing a *multiple-hop* update of the application.  *Multiple Hop* means to update from a much older version.  (Previously, multi-hop migration worked for Bookmarkshelf document files but not Application Support files, so that the Open/Save, Clients, and Agents settings would be lost.)

* When executing a *Revert* operation, the *After opening this document, do automatically* actions (sort, import, find duplicates), if any are set to go, are now skipped.

* The Settings > Clients panel now updates to show the new order after the up or down buttons have been clicked to change the order.  This was apparently broken in one of the 1.1.x updates.

* Eliminated redundant processing which caused a spinning beachball for a long time at the end of "Find Duplicates", if there were already a lot of duplicates which had been found previously.

* Error 19675 is now displayed with a Recovery Suggestion explaining how to fix the problem.  (But we're still trying to figure out why this error has occurred for a few people.)

* Fixed a bug which caused the "Add" ([+]) button for Commands in a Bookmarkshelf's Settings > Agents > Advanced to not function in some circumstances.

* Added a *Export Bookmarklet to ▸* item in the *File* menu, so that users who prefer to not have any Clients but bookmark directly in BookMacster (Usage Style 3) can now insert the BookMacsterize bookmarklet only into desired Client browsers, without exporting any other items, and without jumping through any hoops.

* When the new Dropbox version 0.8.x "Experimental" is in use, now correctly finds the Dropbox folder, and no longer incorrectly reports that Dropbox account information could not be found.

* Fixed a bug which caused the BookMacsterize bookmarklet to *not* be inserted into a New Bookmarkshelf if no Clients were added during the New Bookmarkshelf wizard.

* Fixed two bugs which caused bookmarks at the root level displayed in the Dock Menu or Status Menulet to (1) have a submenu and (2) not visit their site when clicked, if only one Bookmarkshelf was open.

* When an Agent is performed by a Worker or by a Worker messaging the BookMacster main app, if an Import or Export to a browser Client cannot be completed due to the browser running and insufficient settings to quit it, the Commands are not completely aborted; some later operations still occur.  In particular, other Clients later in the Export still receive their exports if possible, and the Save Document command is still executed.

* If a Worker ends in error, and user clicks "View" in the dialog which is presented, instead of opening the Error Log, BookMacster now presents the error in a dialog.  This is advantageous if the error is that of Safe Limit being exceeded, because the recovery option to simply re-perform the Agent's commands while ignoring ("Ignore Once") the limit is now available.

* Fixed bug which could cause Settings > Agents > Advanced view to become unresponsive if multiple Agents were listed and the selected Agent was changed.

* Queries from Agents are now inhibited during the updating of a Bookmarkshelf (database migration), when a Bookmarkshelf is opened for the first time by a version of BookMacster which requires such updating.  This eliminates a potential for trouble which may or may not have occurred for some users during previous updates.

* Fixed cosmetic defects in Reports > Diaries table.

* The Structure of a New Bookmarkshelf created with no Clients is now, by default, able to accept all items (bookmarks, folders, separators) in its Root.

## BookMacster Version 1.2.6 (2010-10-16)

This version has a half-dozen bugs fixed, and is better able to handle corruptions in Firefox bookmarks and OmniWeb files.  Beta versions 1.2.2-1.2.5 have been rolled into this production version.

* Fixed a bug which caused, in Bookmarkshelves with multiple Clients, when an *Import : Triggering Client* operation was executed, items deleted in a Client to not be deleted in the Bookmarkshelf nor the other clients, and consequently reinserted into the Client from which it was deleted, unless the Client was the last active Import Client.

* If a Bookmarkshelf document is not found when attempting to open it, now removes that document, if it was present, from the list of documents which BookMacster attempts to open automatically upon launch.

* Fixed a bug which caused the "Open this document when BookMacster launches" checkbox in Settings > Open/Save to sometimes indicate a checkmark when in fact the switch was off, and probably this was most likely if the document was created by an old version of BookMacster.

* Fixed a bug which caused RSS Articles in Firefox Live Bookmarks (which are imported but not displayed in BookMacster except in a tooltip when hovering over the Live Bookmark) to not always be exported back out to Firefox.

* More tolerant of corruption in Firefox database.  During an Export to Firefox, now deletes orphaned items found in the Firefox database, so that they can no longer cause the export to fail with SSYSqliterErrorDomain error 
: Sqlite error "PRIMARY KEY must be unique" when attempting to insert a legitimate new item with the same identifier as the orphaned item.

* Fixed a bug so that Visit Count and Last Visited are now correctly imported from OmniWeb.

* During an Import from or Export to OmniWeb, improved ability to recover from reading corruptions in OmniWeb's Preferences and History.plist files.

* During an Import or Export from Firefox, no longer hangs when encountering a corrupt bookmark which claims to be its own parent.

* Now built with LLVM Compiler 1.5 instead of GCC 4.2.

## BookMacster Version 1.2.1 (2010-10-10)

* Automatic cross-browser synchronization across multiple Macs is now no longer restricted to using Dropbox™ – other Online File Syncing Services can be used.  

* Now supports the [iCab Internet Taxi](http://www.icab.de/) as a Client.

* Now supports [Pinboard – Social Bookmarking for Introverts](http://pinboard.in/) as a Client.

* Fixed a bug which caused some of the hidden proprietary attributes which are only used used by one type of browser client (for example, the *Last Checked Time* in OmniWeb) to be lost after multiple round trips of Import and Export.

## BookMacster Version 1.1.25 (2010-10-05)

Because this update is to fix a bug in *Reports* > *Find*, most users will  

* Fixed a bug in Bookmarkshelf window's Reports > Find which caused all attributes to be treated as strings, so that the available predicate expressions in the popup were *contains*, *begins with*, *ends with*, etc, for all attributes.  Therefore filtering on attributes whose types were number, date or Boolean types did not work.  (This bug was probably introduced in version 1.1.?.)

## BookMacster Version 1.1.24 (2010-10-04)

* In tab Settings > Agents > Advanced > Commands, corrected the logic so that the popup menu indicating *Cancel job if it is pre-empted by browser running*, *Quit browser and relaunch if needed*, and *Force quit browser and relaunch if needed* are available for additional trigger types.

* When asking user's permission in a dialog to quit or force quit a web browser application in order to accomplish an Import or Export operation, the message now correctly states that permission is granted not only for the current web browser but for other web browsers that may need it during the operation. 

* Fixed a bug which caused License Information to fail validation if Licensee Name contained a multi-byte UTF8 character near the 8th position.

## BookMacster Version 1.1.23 (2010-10-03)

* Corrected Sec. 1.2 of Help Book to explain how you *can* still use MobileMe and iSync to sync Safari bookmarks to your iPhone and iPad, while using BookMacster's new Dropbox™ integration for cross-browser syncing on your *Macs*.

* If duplicate identifiers are encountered during an Import or Export operation, instead of aborting the operation with an error, now silently attempts to set new nonduplicated identifiers as required.  If this succeeds, just logs the issues to the console and continues.

## BookMacster Version 1.1.22 (2010-10-02)

**Summary.**  This is the first production release of BookMacster 1.1.x.  Since our last production release, version 1.0.5, back in May, we've added automatic cross-browser syncing of bookmarks between multiple Macs,  simplified the user interface, made many bug fixes, and also some updates to support recent changes in browser applications.

*Regarding that email you may have gotten…*  Regular licensees who had not opted out received an email from us on July 15 asking for feedback on a proposal to make BookMacster a non-document-based application like, for example, iTunes.  Thank you for your feedback.  We decided to not do that.

LIST OF CHANGES

Changes in all the 1.1.x beta versions have been consolidated into the following single record.  For differences since the last beta 1.1.21, see [Incremental Changes](VrsnHstIncrement11211122).

* Now features automatic cross-browser syncing of bookmarks among multiple Macs, using a free Dropbox account.

* The New Bookmarkshelf wizard has been redesigned so that it only hits the important points, and in an understandable way.  In particular, it no longer requests selecting a Usage Style.

* The Settings > Clients tab is now clean and understandable.  There is only one list of clients, instead of separate tables for Import and Export, crowded with confusing attributes.  Advanced Settings for each Client and advanced Import Postprocessing have been moved into sheets, which have plenty of room and are customized as required for the Client type.

* The Settings > Agents tab has been subtabbed to show a *Simple* or *Advanced* view.  The default *Simple* tab has only four checkboxes and a button, and can configure the Agents desired by most users.  The *Advanced* subtab contains the old Agents view, with its three tables, allowing custom setting of multiple Agents, Triggers and Commands.  

* The checkbox in Settings > General to *Show Advanced Settings* has been removed.  Advanced settings are now hidden individually, as described in the two previous items.

* Referring to the *Settings* tab in the Bookmarkshelf document, settings in the *Open/Save*, *Clients*, and *Settings* tabs are now stored as a user preference for that particular Bookmarkshelf, instead of in the Bookmarkshelf itself.  This has been done to support file syncing schemes such as Dropbox, so that the same Bookmarkshelf can have different Open/Save behavior, different Clients, and different Agents when opened on different Macintosh accounts.  It also means that changes to these settings are not undo-able and do not result in the Bookmarkshelf having unsaved changes, because user preferences are automatically saved, immediately, to a data store in ~/Library/Application Support instead of to the .bkmslf file.

* The order of the subtabs in Settings has been changed so that the three whose settings are saved in the .bkmslf file (General, Sorting, Structure) are followed by the three whose settings are not saved in the .bkmslf file (Open/Save, Clients, Agents).  The latter are now referred to as "Local Settings" and are so noted in their tabs.

* The *Status Bar* along the bottom of the Bookmarkshelf window has been reduced in height, and given a snazzy gray background gradient, so that it complements the toolbar and looks more like the status bar in other apps such as Safari, Xcode, iTunes.

* Added an option in Clients > Client Advanced Info, for Google Chrome clients, to *Don't Use 'Other Bookmarks'*.  When this box is checked, during Import, items from Chrome's Bar and *Other Bookmarks* are combined into BookMacster's Bookmarks Menu, and during Export, items from BookMacster's Bookmarks Bar and Bookmarks Menu are all exported to Chrome's *Bookmarks Bar* (which means that they all appear in the *Bookmarks* menu).

* Added an option in Clients > Client Advanced Info, for Opera clients, to *Don't Import Trash*.  When this box is checked, during Import, the Trash is ignored.  During Export, it is stashed while items are merged, and then inserted at the end of the Opera bookmarks just before the Opera bookmarks file is rewritten.

* Individual RSS Article links which are imported from Firefox as constituents of Live RSS bookmarks are no longer exported to OmniWeb as regular bookmarks.  Only the Live RSS bookmark itself is exported to OmniWeb, the same behavior as when exporting to other Clients.

* Firefox' Smart Bookmarks are no longer exported to Safari, Camino, Opera or Google Chrome.  (Google Chrome immediately deletes them anyhow.)

* Import and Export with an *Other Macintosh Account* now Actually Works™ for Macintosh accounts on the same Mac, as well as those on other networked Macs, except that for OmniWeb Clients it requires macOS 10.6 or later.

* Import and Export with Firefox bookmarks on an *Other Macintosh Account* on another networked Mac is now much faster.  (The actual change is that for all *Other Macintosh Account* clients, we now copy the file to the local Mac, do our transactions, then copy it back.  For most Clients, it doesn't help, but for Firefox it is much faster because the old way required sqlite transactions to be sent over the network.)

* When an Import or Export operation attempted with a Client on an Other Macintosh Account is interrupted by a Warning to make sure that the client web browser on the other Mac account is not running, clicking the "Proceed" button now inhibits the warning (for 3 minutes) *and* retries the operation automatically.  The user no longer needs to guess that they should retry the operation manually.

* The Agent Command choices *Import* and *Export* have each been bifurcated, so that in the Advanced view we now we have instead these four choices:
    *Import Triggering Client*
    *Import All Clients*
    *Export Triggering Client*
    *Export All Clients*
The *All Clients* versions behave the same as the old *Import* and *Export* commands.  The *Triggering Client* versions only operate upon the Client browser which triggered the Agent.  For example, if there are three Import Clients, one of which is Safari, and if one of the Triggers is *Bookmarks Changed : Safari*, then when Safari bookmarks change, if the Import command is *Import Triggering Client*, then only Safari bookmarks are imported.  Since this is what users will want most of the time, it is the new default when creating a *Simple* Agent, or when creating an *Advanced* Agent from scratch.  The default Export command is still *Export : All* since was and is what most users want.  Users who want to convert an existing *Simple* Agent to the new behavior may do so by checking OFF and then back on the *Simple* Agent.  For an *Advanced* agent, change the Command in the popup.

* In Settings > Structure, the option to *Configure this document's structure automatically… [for] Import Clients* has been removed.  Some background to explain the new behavior:  The automatic or non-automatic configuration had affected had three groups of items: (1) which *Hard Folders* (Bookmarks Bar, Bookmarks Menu, Unsorted Bookmarks, My Shared Bookmarks) were present in the Bookmarkshelf, (2) the types of items were allowed at Root (Hard Folders, Soft Folders, Bookmarks, Separators) and (3) the Default Parent for importing.  In the new version, automatic configuration of groups (1) and (2) is still performed when a Bookmarkshelf is initially created and whenever Clients are changed, but there is no effort made to update them if the Bookmarkshelf is later re-opened on a different Mac account which has different Clients.  (If there were, and if the Bookmarkshelf were synced via Dropbox or other means to different Mac accounts which had different Clients for the Bookmarkshelf, there would be a continual argument – an infinite loop – between the two accounts.  This is because different Clients are now possible on different Mac accounts).  Regarding (3), the Default Parent, this is now set only when a Bookmarkshelf is initially created but never again.  All of the settings can still be changed manually – (1) and (2) in Settings > Structure, and (3) in Settings > Clients > Import Postprocessing (Advanced).

* Updated method for authorizing the Client, when adding a Delicious Yahoo! Client, to comply with new security restrictions recently imposed by Yahoo!  Because the Yahoo! web page will no longer invoke BookMacster using a custom url scheme, when authorizing BookMacster to access a Delicious account for the first time, users must now copy an authorization token from their web browser and paste it into BookMacster.

* When adding a Delicious Client (either Yahoo! or Old Skool), if authorization fails or is cancelled, now deletes the non-functioning Client.
 
* During an Export operation, the *[Safari Logins Bookmarklet](http://help.agile.ws/1Password3/logins_bookmarklet.html)* created by 1Password version 3.x, is now only exported to Safari Clients.  (This is the same behavior as we've had for the old 1Password 2.x bookmarklet.)

* When a Worker is triggered to perform for an Agent, and it finds that the BookMacster main app has the required Bookmarkshelf open in the background, and it therefore messages to BookMacster to perform the work, and if BookMacster needs to quit a browser in order to execute an Import or Export command, and if it has been so authorized by the detail setting in the command, and so quits the browser, now it no longer displays a sheet asking the user if said browser should be relaunched first.  It just relaunches it without asking, since this is what the Worker is expected to do if the Worker had done the work itself.  The said sheet now appears only if the command was initiated manually by the user.

* If an Agent's Worker is triggered by a *Bookmarks Changed* trigger (only available for Safari), instead of reacting immediately, Worker now sleeps a minimum of 60 seconds after the trigger before executing its first Command.  This is in case the user makes additional changes.  For example, if a user creates a new bookmark in Safari, the change is detected immediately.  If ten seconds later the user renames or moves the new bookmark, in previous versions the Worker might already be at work with the original new bookmark.  In this version, any change within the next 60 seconds is coalesced into one change, which triggers only a single Worker process.  (The delay of 60 seconds may be changed by users who know how to change hidden preferences.  The hidden preference key for this value is "bookmarksChangeDelay".)

* When creating a new Bookmarkshelf, no longer tries to generate a cute/smart filename based on the Clients' name(s). 

* In Settings > Agents > Advanced > Commands, command Indexes now appear in human-readable form, beginning with 1 instead of 0.

* Agent's Worker now skips writing the *Bookmarkshelf* file if there are no changes in it.

* During an Export, for Client browsers whose bookmarks can be read but not written while they are running (all browsers except Safari and Firefox), now reads the bookmarks and checks to see if there are any changes which need to be written before attempting to quit the browser.  If there are no changes to write, no longer attempt to quit the browser.

* In Agents, the Command options to *Quit and relaunch browser if needed* and *Force Quit and relaunch browser if needed* are now available if the agent has any Trigger of any type.  A trigger of type *Scheduled* or *Dropbox™ updates this file* is no longer required.

* The tortuous checkbox *When it is necessary to log out of the current Google account…* has been moved from Preferences > General to Clients > Client Advanced Info, for Google Bookmarks clients.

* In Settings > Open/Save, the default setting of *Open when BookMacster launches* is now ON for all newly-created Bookmarkshelves, because it is assumed that 98% of users will regularly use only one Bookmarkshelf.

* In Settings > Clients > Import Postprocessing (Advanced), the default setting of *Clean Slate* is now ON for all newly-created Bookmarkshelves.

* The *Safe Limit* settings for Import and Export now no longer default to 20 after the first Import or Export.  The default values remain infinite, and may be manually changed by the user at any time.  (The reason for the change is that we're no longer worried that BookMacster is going to hose anyone's bookmarks). 

* Unnecessary *churn* or *dithering* in bookmarks placement and attributes which was sometimes seen when performing consecutive Imports and Exports, which showed itself as the number of changes after repeated Imports and Exports not converging to zero (+0, Δ0, ↕0, -0) after a finite number of imports or exports, has been, with a fairly high confidence level, eliminated.  As one example, *churn* occurred when there were duplicate items are present in Client or Bookmarkshelf, because our valid but nondeterministic algorithms might in some cases match different bookmarks or folders with different mates (between Bookmarkshelf and Client) on each Import or Export.  *Churn* now only occurs for one or two cycles, and only in a few understood *corner cases* where it is expected behavior.  (Although the new algorithms take typically a few tens of milliseconds longer, eliminating *churn* improves the confidence that saavy users have in BookMacster, and more importantly it makes it much easier for our quality assurance testing when a test has only one correct answer.)

* The *Open Active Agent* menu item has been moved from the *File* menu to the *BookMacster* menu, and renamed to *Active Agent…*.  Instead of showing a submenu of Bookmarkshelves with active Agents, it now opens a window which shows these in a list, with a little explanation of how to edit them.  Besides being easier to understand, this also improves responsiveness throughout the app since aliases no longer need to be resolved to show the paths in menu item tooltips every time the system decides that this menu needs to be updated (which it does too frequently).

* The menu item BookMacster > *View Errors from Agents' Workers* has been replaced with *BookMacster* > *Logs*.  Clicking it opens a new *Logs* window which shows, in tabs, Messages and Errors (history), from both the main application and from Agents' Workers.

* In BookMacster's AppleScript terminology, the name of the command *view errors from worker* has been changed to *display error logs*, and it now simply activates the *Logs* window and tabs to the *Errors* tab.

* Since errors are now logged internally, most errors are no longer logged to the system console log upon presentation.

* In the Bookmarkshelf window, the tab Settings > Logs has been renamed to Settings > Diaries, to eliminate confusion between these Import/Export records and the new *Logs* window.  Also, the diaries are not labelled to indicate if they were the result of the main app vs. an Agent's Worker.

* Improved the built-in verbose debug logging facility and changed its name to *Trace*, so that it would not be confused with the un-verbose *Messages* which are displayed in the *Logs…* window.

* A *Trouble Zipper* item has been added to the Help menu.  Clicking this menu item downloads the latest Trouble Zipper script from our server, unzips and launches it.

* New Preferences tab *Updates* allows choice of Production, Beta (Early Adopter) and Alpha (Very Early Adopter) policies when running a *Check for Update*.

* Improved algorithm for exporting to Delicious.  Instead of a fixed wait time of 1.2 seconds for the first 900 bookmarks and 5.0 seconds thereafter, with a "banning" by Delicious requiring user intervention to retry, it now detects when Delicious has banned, waits for a time, then restarts uploading at a slightly lower rate.  User may adjust the algorithm's parameters in Settings > Clients > Advanced Info sheet > Special Settings.  The old algorithm had been frequently requiring user intervention due to recent unpublished but de facto policy changes implemented by Delicious, and the adjustmentability allows for some future-proofing.

* No longer uploads any bookmark whose URL has scheme 'data', such as a 1Password bookmarklet, to Delicious.  (Delicious accepts such a bookmark, but truncates its URL to simply "http://data///", which makes it even more useless than it already is, up there in the cloud.  The 1Password bookmarklet only functions in locally-installed web browser apps.)

* No longer uploads a BookMacsterize bookmarklet to Delicious.

* Now recovers properly, no longer suggesting that user re-enter their username and password, if Delicious sends us an HTTP Status Code 999 (which is undefined).

* An Export operation now no longer causes a Bookmarkshelf document to have unsaved changes.

* When contemplating an Export to Safari, no longer temporarily locks Safari bookmarks and blanks Safari's *Show [All] Bookmarks* view, if currently being displayed, unless there are actually changes to be exported.

* The default deference for the *Export* command in the prefabbed *Export updates from Dropbox™ cloud to Clients* Agent has been changed from *Cancel job if pre-empted by browser running* to *Quit and relaunch browser if needed*.  This is because we expect that, in most cases, this action will occur a minute after a Mac is awakened from sleep, after Dropbox™ checks in and updates the Bookmarkshelf, and also we expect that most users will leave their web browsers running during sleep.  Therefore, momentarily quitting the browser is required for bookmark updates to appear as expected (except for Safari which accepts bookmarks updates while it is running).

* Now supports the open-source [Chromium](http://build.chromium.org/buildbot/snapshots/chromium-rel-mac/) web browser.

* In order to accomodate a recent policy change at Delicious, now recognizes bookmarks with a slightly different URL, but the same normalized URL, as different bookmarks.  Because previous versions of BookMacster followed the old Delicious policy of using normalized URLs, Import and Export operations have recently exhibited omissions in changes and deletions with Delicious clients.  This change corrects that situation.

* During an Export operation, no longer counts a bookmark as *changed* if the receiving Client does not support the attribute that changed.  This eliminates extraneous Diary (formerly Log) entries, and improves performance a little, except for Delicious it improves performance alot, since Delicious requires at least 1 second to upload a changed bookmark.

* Fixed retain cycles which caused Bookmarkshelf documents to be leak memory, once they had undergone an Import or Export operation.  This would cause excess memory to be used between the time, if any, that a Bookmarkshelf was closed and the app was quit.  (Therefore, there was no effect unless multiple Bookmarkshelf documents were opened and closed.  The memory leak happened in Worker processes also, but likewise was of no consequence since Worker processes open only one Bookmarkshelf exit as soon as their work is done.  Fixing memory leaks is done to improve overall quality and reduce the probability of other bugs.)

* When executing an Export operation (or an Import, for Firefox) while operating in macOS 10.6, and when a running browser needs to be quit, now works around a bug in the system which sometimes caused the browser to be reported as still running after it had in fact quit.

* When executing an Export operation and a browser refuses an AppleScript message to quit, as Google Chrome sometimes does, now displays an error with the underlying error returned by the browser immediately, instead of waiting 15 seconds and then displaying an error without the underlying error.

* When writing OAuth passwords to the macOS Keychain for Delicious-Yahoo (new skool) accounts, the account name is no longer dot-suffixed onto the service name.  The service name for all such items is now simply "com.sheepsystems.BookMacster.ExtoreDelicious2".  Upon running BookMacster 1.1.3 or later for the first time, during launch, the macOS Keychain is searched for prior-style items and any found are converted to the new style.

* Reflecting the changes which became effective in BookMacster 1.1 regarding the storage of the Open/Save, Clients and Agents settings, the [identifiers](exid) which are used to locate items (bookmarks, folders separators) within Client browsers are now stored in Application Support for each Mac account, instead of in the Bookmarkshelf file.  This change reduces the size of a typical .bkmslf file by 75%, eliminates the appearance of unsaved changes when a Bookmarkshelf is exported to a new Client browser for the first time, and we have judged it to be a more natural, correct and therefore robust data model to build upon.

* Fixed a bug which, during Export to a Delicious client, caused overwriting the *Shared*/*Private* status of a bookmark existing in the cloud from *Private* to *Shared* to fail silently.  That is, BookMacster would indicate that it had uploaded the state change to *Shared*, but the Delicious server would not get it.

* Fixed a bug which caused, during an Export, *Clean Slate* to not clean out destination items which are not supposed to be exportable to the Export Client, but were somehow already in there before the export.  Non-exportable items are, for examples, Separators in Clients which do not support separators, 1Password bookmarklets in Clients whose browser is not Safari, etc.

* Fixed bugs and improved logic in recovering from errors.  In some cases, error recovery just wouldn't work.  In other cases, error recovery was excessive.  Using this version, for example, if user clicks "Export" with three active Export Client browsers, and the last export to, say Firefox, fails because Firefox needs to be quit, when the user clicks, "Quit Firefox", after successful quitting only the export to Firefox is subsequently repeated instead of all three exports.  Same idea if a *Safe Limit* is exceeded for one Client.

* Added a patch to prevent a crash which might occur when first opening a new version of BookMacster in Mac OS 10.5, per [Apple recommendation](http://developer.apple.com/mac/library/releasenotes/Cocoa/MigrationCrashBuild106Run105/index.html).  (This crash became possible in BookMacster 1.1.11 since the update requires migrating a subentity.)

* Fixed a bug which caused silent failure when after clicking "Reenter" to re-enter username and password for a Delicious Old Skool client.

* Fixed a bug which allowed a Worker, which should have been inhibited due to recent saving of the Bookmarkshelf, to perform later, after it got the baton from another Worker which had it when this Worker was launched.  This resulted in unnecessary and redundant work being done (importing, sorting, exporting, saving, etc.) as well as Dropbox activity if applicable.

* Fixed a bug which caused occurred during an Import or Export, while merging folders, when two folders were merged, if one folder had no identifiers and the other folder had some, that none would survive in the merged folder.  This could have caused unnecessary churning (deletion of items and replacement by identifical items with no net effect) during the Import or Export.

* In the Inspector > side drawer (identifiers), Clients are now identified with the human-readable display names used elsewhere instead of with a geeky string including five pipe (|) characters.

* When exporting new items for the first time, now properly copies the unique identifiers provided by the Client browser.  Although these should have been copied previously, this bug didn't make any difference before Dropbox syncing was in use, because new items never had identifiers provided by the Client.  Now, they can have identifiers from the same Client browser over on the other Mac, and these need to be copied.

* When executing a Clean Slate on Import, the BookMacsterize Bookmarklet will now be deleted if it is not present in the Import Client.  The old reason for not deleting it, retention of the BookMacsterize Bookmarklet during the first Import of a New Bookmarkshelf, is now no longer a requirement since we add the bookmarklet after the Import instead of before.  Theoretically, the old behavior was OK, but the new behavior is more logical and robust, and will no longer add additional symptoms to other bugs (such as the previous item).

* Fixed a bug which could cause failure to indicate an error that Export to Safari failed because Safari was busy for more than the allowed timeout.

* Fixed a bug which could cause the BookMacsterize Bookmarklet to be placed at the top/left of a New Bookmarkshelf instead of the bottom/right.

* Fixed a bug which could cause Duplicate Groups to remain even after all duplicates had been deleted.  (The remaining Duplicate Groups would each contain only one bookmark; not really a Duplicate Group any more.)

* The status indication at the top of the Reports > Duplicates view (i.e. "6 Duplicate Groups") now updates correctly following Undo and Redo operations.

* Fixed a bug which could cause failure of Reports > Duplicates view to load properly if deleted duplicates were un-deleted via Undo.  In order to maintain performance, the maximum number of bookmarks in a Duplicate Group which cause them to appear unsorted in the Duplicates view has been reduced from 32 to 8.

* Fixed a bug which could cause Delicious-Yahoo (new skool) accounts to silently fail to properly record all of their settings during initial setup.

* Fixed bug which could Delicious Clients to lose their user names.

* Fixed a bug which would cause entire Delicious bookmarks to be downloaded unnecesarily if only minor changes, such as changing the shared/private attribute of a bookmark were performed during a previous Export.  Such an export causes BookMacster to use a workaround for a bug in Delicious, which was that they do not update their last-modified timestamp for these minor changes, but this workaround triggered our own bug.

* Fixed bug which could theoretically have caused various failures if someone used a pipe character ("|") in a Firefox profile name, or Delicious user name or Google account name.

* Fixed a bug which caused all Local Settings (Clients, Agents, Open/Save) associated with a Bookmarkshelf to be lost when BookMacster opened a Bookmarkshelf with minor corruptions that it was able to fixed, and silently fixed them.

* Fixed a bug which caused a conflict accessing Client bookmarks between the BookMacster application and one of its Workers, or between Workers, to be incorrectly displayed as an error and explained as a conflict "possibly with another application", instead of just being ignored.

* By default, the Quick Search field now has *Folders* checked ON too, instead of only *Bookmarks*.

* Fixed a bug which could cause a crash during the summarizing phase, if tags had been deleted while exporting to a Delicious or Google Bookmarks account.

* To aid in troubleshooting, when downloading all bookmarks from Delicious during an Import, now writes a file containing the downloaded XML data to the user's Application Support directory.  (This file is overwritten with each new complete download.)

* Fixed a couple bugs which may have caused corrupt Bookmarkshelf documents which had been set to open upon launch to continue to open on each launch, even after repeated failures.

* The [+] and [-] buttons in Settings > Agents - Advanced are now disabled when their action is not available.

* The Import/Export Logs are now stored in ~/Library/Application Support instead of in the Bookmarkshelf document files.  (Although this is a better design and would have been done this way the originally had more design time been available, it is necessary now for Dropbox compatibility, since Import and Export events occur independently on each Mac.)

* Displaying and resizing a Bookmarkshelf window tabbed to Content is now faster.  (Attribute types are cached instead of being read from a temporary managed object context for each displayed item.)

* Bookmarkshelf windows now load faster for users with more than a few web app accounts in their macOS Keychain.  (Keychain information is now cached temporarily instead of re-read for each web app account.)

* Probably no longer gets confused if the Delicious account userame for a Yahoo!-linked Delicious account is different than the linked Yahoo! account name.  We hope that this does not break anything for users who may have somehow got these names reversed.  Oh, Yahoo!!

* Fixed a bug which could cause a crash if an error was received while exporting bookmarks to a Delicious-Yahoo! account.

* Fixed a bug which could cause a crash if an error was received while exporting bookmarks to a Delicious Old Skool account.

* Fixed a bug which, after attempting to Import from Firefox on an Other Mac Account, receiving the warning about Firefox not running, and clicking "Proceed", nothing got better – repeating the Import resulted in the same warning.

* Fixed a bug which, if a Bookmarkshelf contained duplicate bookmarks, when exporting to Google Bookmarks or Delicious, caused the duplicate bookmarks to be identified with the same non-duplicate bookmark in Google Bookmarks or Delicious.  (Google Bookmarks and Delicious do not allow duplicate bookmarks.)  During subsequent imports or exports, these multiple bookmarks with the same client identifier would cause false matches, which would cause changes to these bookmarks to be missed.

* Although Camino did not seem to notice the differences between BookMacster's writing of its bookmarks file and its own, made a few corrections to the way Camino bookmarks files are written.

* Added several more measures to avoid crashing due to corrupt preferences files.

* The *Close and Delete* menu item now invokes Finder to trash the file via AppleScript.

* Fixed a bug which could result in the Sort Order not being set in Opera Preferences if necessary.  (This bug was only triggered Sort Order was the last item in the Opera Preferences file, and possibly this happens with Opera 10.6.)

* Fixed a bug which caused Chrome bookmarks to be exported with the same identifier if more than one new one was exported during one export, which would cause all but one to be removed when bookmarks were later re-imported.

* Fixed a bug which caused the URL to be omitted when exporting Firefox Live Bookmarks to Opera.

* Fixed bug which caused the Shortcut (Keyword), Visit Count, and Last Visited Date attributes to be not read from OmniWeb during an Import or Export.

* Fixed a bug which causes items exported Shiira to have the wrong index.

* Fixed a couple bugs which could cause Agent operations to execute repeatedly, or not complete execution, possibly resulting in file corruption, if they were interrupted and took too long.  Toward the same end, increased the inhibit time after a new Agent is saved from 10 seconds to 20 seconds.

* Fixed a bug which caused the *Fabricate Folders* feature to just not work in most situations.

* Fixed bugs which, during Import, sometimes caused merged items to end up in the wrong place.

* Fixed a bug which would cause a New Bookmarkshelf to be written as two files, neither of which was complete, if the user deleted the default filename extension *.bkmslf* when specifying the filename in the Save panel.  Needless to say, neither of the incomplete files would work very well when subsequently re-opened.

* Fixed a bug which would often result in a misbehaved Import or Export if, since the time of the last Import or Export with the Client, either the Client itself, or some other application, or a backup restoration, had rewritten the Client's bookmarks so that persistent identifiers were reassigned to different types of items.  For example, if an identifier which had been assigned to a folder was reassigned to a regular bookmark, depending on the folder structure, other such reassignments, and random events in program execution, the Import or Export operation could hang in an infinite loop, necessitating a Force Quit.

* Fixed a bug which would falsely cause an Import or Export operation to fail because the Safe Limit was supposedly exceeded if it was initiated by clicking the "Perform…" button in the tab Settings > Agents > Advanced, if the change counts from the previous Import or Export plus the new change counts exceeded the limit, and if in fact it the actual import or export was skipped because it was not necessary.  (The prior change counts were not being cleared.)

* Fixed a bug which could cause a nameless Soft Folder to appear as an Update in the log after an Import, supposedly because its Verify Disposition changed from -1 to 1.

* Fixed a bug which caused a *Save As* operation to fail with Error 64510 if user executed a *Save As* operation but then did not give a different path, and clicked *Replace*.  The action now degenerates to a Save, Close and then re-Open.  (This bug was introduced with the new *Save As* implementation in version 1.0.3.)

* Fixed a bug which disabled opening of loose Opera bookmarks files using *Choose File (Advanced)*.

* Fixed a bug which caused Triggers to apparently keep their old order after reordering by drag and drop, although actually the order was changed as could be seen the next time time Bookmarkshelf was reopened.  (This is actually just a cosmetic fix because there is no need to reorder triggers; the order of triggers is meaningless.)


## Incremental Changes from BookMacster 1.1.21 to 1.1.22 [VrsnHstIncrement11211122]

* Added integrity testing (for nonunique exids) during Import and Export.

* Now displays a warning during an Export operation if the browser's built-in syncing is turned ON when exporting to Chrome or Chromium.

* Fixed a bug which could sometimes caused a crash during Verify.

## BookMacster Version 1.0.5 (2010-05-31)

* Fixed a bug which would cause a New Bookmarkshelf to be written as two files, neither of which was complete, if the user deleted the default filename extension *.bkmslf* when specifying the filename in the Save panel.  Needless to say, neither of the incomplete files would work very well when subsequently re-opened.

* Fixed a bug which would often result in a misbehaved Import or Export if, since the time of the last Import or Export with the Client, either the Client itself, or some other application, or a backup restoration, had rewritten the Client's bookmarks so that persistent identifiers were reassigned to different types of items.  For example, if an identifier which had been assigned to a folder was reassigned to a regular bookmark, depending on the folder structure, other such reassignments, and random events in program execution, the Import or Export operation could hang in an infinite loop, necessitating a Force Quit.

## BookMacster Version 1.0.3 (2010-05-25)

* In tab Settings > Open/Save, added a checkbox to "Automatically save unsaved changes when closing [this Bookmarkshelf]".  This nonstandard behavior is thus provided as an option for users who are annoyed by the standard *Don't Save* | *Save* dialogs which appear when closing or quitting.

* Fixed a bug which sometimes caused Smart Folders in Firefox, particularly after editing the URL, to be exported to Firefox as a Separator.

* Fixed a bug which caused an error originating in a BookMacster Agent Worker to be not displayed after user clicked "View".

* Fixed a bug which occurred if user opened an old Bookmarkshelf after updating BookMacster to a newer version which required migration to a new data model, and while this Bookmarkshelf was opened for the first time, the user happened to activate a Finder window containing the newly-migrated (and old) Bookmarkshelf.  (The old Bookmarkshelf typically has a tilde (~) appended to its name.)  The bug is that the open Bookmarkshelf would become associated with the old file, which would cause subsequent *Save* operations to fail due to "persistent store" or "data model" errors.

* Re-implemented the *Save As* function to work around some crashes which usually occur when executing *Save As* on a few rare Bookmarkshelf specimens via the *Save As* function built into macOS.  The new behavior is a little slow because it copies the file, saves the document, closes it, moves it to the Save As path, re-opens it, and finally renames the copy back to the original name.  But it no longer has this particular crash possibility.

## BookMacster Version 1.0.2 (2010-05-16)

* Improved performance when finding, displaying, and deleting duplicates of Bookmarkshelf which has thousands of duplicate bookmarks.  The large memory demands which previous versions imposed upon the system during such operations, sometimes resulting in a crash if the demands could not be met, have been reduced to typical and manageable levels.

* Now opens special .bookmacsterlicenseinstaller files which our Support department may provide to users who have lost their Preferences and need to reinstall their License Information, so that all it takes is doubleclicking such a file.

## BookMacster Version 1.0.1 (2010-05-10)

* Fixed a bug which caused error 315000 when saving a new Bookmarkshelf.

## BookMacster Version 1.0 (2010-05-10)

This version is for keeps.  Although frequent updates are expected to finish things up during the next few months, this version will not expire on you every couple weeks the way previous versions did.  It requires a License to Save or Export bookmarks, as described on the [product web page](https://sheepsystems.com/products/bkmx/) -- free demo licenses are available and installed automatically.  Qualified beta testers should have all received their coupon codes last week.  Thanks again to our beta testers.  

* Fixed a bug which caused indefinite hang if an Agent's commands included *Verify*, and the *Perform Commands* button was clicked to test this Agent.

* Unclogged a performance bottleneck which caused Undo of an Import or Export to take a long time, proportional to the number of changes in the Import or Export.  (Now ~80x faster measured with 1500 changes).

* Our Beta Testers are now listed in the [Acknowledgments]() section of the Help Book.
  
## BookMacster Version 0.9.33 (2010-05-06)

* Unclogged a performance bottleneck which could cause huge memory usage, and progress to apparently come to a standstill (although actually it would eventually finish), during an Import operation if there were any changes to bookmarklets with very long URLs, such as a 1Password bookmarklet.

* Added more tests to ignore illegal tagged folders (1) when setting tags and (2) when exporting to Firefox.

* When a Bookdog user runs BookMacster for the first time, the option to *Cancel* when asked whether to import Bookdog settings has been replaced with an option to *start anew* (*New*), which starts the New Bookmarkshelf wizard.

* Fixed a bug which could cause hard folders to be incorrectly set as *not sorted* in a new Bookmarkshelf created by importing from Bookdog.

* More appropriate Help Book page shown after importing from Bookdog.

* Now able to read old Bookmarkshelves from any previous version.

## BookMacster Version 0.9.32 (2010-05-01)

* Although this version is still another free time-limited beta test, the *Licensing* menu item has now been enabled so that it is possible to purchase a permanent license by clicking in the menu BookMacster > Licensing > Try or Buy > Purchase.

## BookMacster Version 0.9.31 (2010-04-30)

* Cosmetic improvements to New Bookmarkshelf "wizard".

* Changed the command *Delete All Duplicates* to *Delete All Duplicates…*, and it now shows a warning sheet with option to cancel before acting.

* When opening a Bookmarkshelf, now detects and removes any tags from any folders.  Folders should not have tags.  Folders with tags would cause errors during subsequent operations, in particular when exporting to a Firefox client.

* One or more bookmarks with no URL will no longer cause the Find Duplicate operation to fail.


## BookMacster Version 0.9.30 (2010-04-30)

* Fixed a bug which caused a hang during Export operations.


## BookMacster Version 0.9.29 (2010-04-29)

This version has several bug fixes and changes in Import operations.  The first few changes in particular should further reduce or possibly eliminate the occurence of Error 54760, and also the appearance of "ghost" items (empty, nameless disclosure triangles) after an Import, which have been reported by a few users and reproduced in our lab.

* Fixed a bug which sometimes caused, during Import, items which exist in the Bookmarkshelf, and also in multiple Import Clients, to have their attributes obtained from a higher/earlier Import Client to be overwritten by attributes from a later/lower Import Client.  The higher/earlier Import Clients' attributes now take precedence, per documentation.

* Fixed a bug which caused the change to not be recognized during Import if a Client had re-used an old identifier of an old bookmark for a new folder, or vice versa.

* Fixed a bug which caused empty folders to not be imported if they were from a second or later/higher Import Client.

* When opening a Bookmarkshelf, automatically removes orphaned or untyped items which may have been created by buggy earlier versions, so that they cannot cause confusion and failure in subsequent Import operations.

* During Import or Export, some unnecessary processing steps have been eliminated, and the text which announces the current step beside the progress bar at the bottom of the Bookmarkshelf window now makes more sense.

* During an Import or Export, no longer merges like-named folders, as was described in Help Book sec. 1.1.10 of BookMacster 0.9.28, if the two folders being merged are from the same source (client, bookmarkshelf, etc.).  Only folders from different sources are now merged.

* In previous versions, an Import operation initiated by a Worker, by AppleScript or by clicking the *Perform Commands* button in a Bookmarkshelf's Settings > Agents tab would skip importing Clients which had not been modified since the last import.  This is done to reduce unnecessary work by Agents' Workers.  In this version, the client is skipped only if, in addition, the content of the Bookmarkshelf itself has not been modified either.

* If an Import or Export operation with Safari cannot proceed because Safari's bookmarks are locked, BookMacster now reads the lock and removes it if the locking process is deemed to have crashed or hung, instead of repeatably failing with error 61390 until Safari or Sync Services get around to removing the lock.

## BookMacster Version 0.9.28 (2010-04-25)

* Fixed a bug which caused items to appear as "ghost" items (empty, nameless disclosure triangles) if an Import was aborted due to an error, then repeated after recovering from the error.

* Some reorganization of the Help Book.

## BookMacster Version 0.9.27 (2010-04-23)

* Now detects recent versions of Firefox' *Minefield* alpha tests when checking to see if Firefox is running before accessing Firefox bookmarks during an Import or Export.  (Recent versions of Minefield are using the bundle identifier *org.mozilla.minefield* instead of *org.mozilla.firefox*.  This version of BookMacster checks for both of them.)

* Help Button in Verify Drawer of Bookmarkshelf window now moves properly when drawer or window is resized.

## BookMacster Version 0.9.26 (2010-04-19)

* Fixed a bug which would cause a Bookmarkshelf to be declared as corrupt and refuse to open if (1) a certain Hard Folder had item(s) in it, (2) its Structure was set to Configure Automatically, (3) any client(s) requiring that certain Hard Folder were deleted, (4) Bookmarkshelf was saved and then (5) reopened.

* Error 144770 with underlying error -35 now gives a "Suggestion to Fix this Error" (same as if underlying error is -43).

## BookMacster Version 0.9.25 (2010-04-18)

* Fixed a bug and some flaky code which could cause a crash if no version of Opera was installed.

* Fixed a bug which caused drag and drop of groups of items to be sometimes to be added to their new location in reverse order (upside down) with respect to their original order.  Known Issue: This can still happen if the selected items are from different parents.

## BookMacster Version 0.9.24 (2010-04-17)

* Added Opera 10.5 Beta bookmarks to the search list for Opera Bookmarks, so that Opera 10.5 beta is now supported.

* Added graphics and improved explanations in the first "New Document" dialog box.

* Cleaned up the *About BookMacster* window, and the *Acknowledgments* page in the Help Book.

## BookMacster Version 0.9.23 (2010-04-12)

* Now supports Google's [Chrome](http://www.google.com/chrome) web browser.

* Up and Down Arrow Keys now work (again?) in radio button matrices in dialog boxes, now by design instead of by accident.

## BookMacster Version 0.9.22 (2010-04-10)

* Fixed a bug, probably introduced in a recent version, which caused items which were merely moved in an Import or Export source to not have their moves be reflected in the destination.

*  Simplified the error presentation when, upon launch, the Mac OS informs BookMacster of a broken login item, and provided a Help Button which opens a new page in the Help Book giving further explanation.

* Added a *Final Integrity Test* to Import and Export operations.  This is to prevent a particular, rarely-triggered bug from corrupting a Bookmarkshelf, and possibly provide information we can use to fix it.

* Fixed unresponsive, slow performance while a fourth-party menu-enhancing application was repeatedly asking BookMacster to validate its menus.  This would occur, for example, during the first 55 seconds after launch, if KeyCue (version 4.5) was running because it asks for menu validation 88-100 times during this period.

* Agent operations which are dispatched by a Worker to be performed by the BookMacster main app (when the required Bookmarkshelf is open and BookMacster is not active) now no longer perform Mirror-Save when saving.  This is not desired because because Save is a separate command, and this is the way it works when a Worker performs the operation itself.

* Fixed a bug which caused radio buttons in some dialogs to select the top button whenever the title of any of its buttons was clicked.

* Consolidated the warning dialogs which appear when BookMacster or Worker quit or force-quit Bookdog or Bookwatchdog (which they do to avoid conflicts).

## BookMacster Version 0.9.21 (2010-04-04)

* When recovering from a Change Limit Exceeded error which occurred in a Worker, the *Ignore Once* recovery option now works.

* Possibly fixed a possible bug that caused a Bookmarkshelf to sometimes not be saved if it was open in BookMacster and was commanded to do so as part of an Agent operation.

* Fixed a bug introduced in 0.9.20 which caused an emtpy "Error:" dialog to appear occasionally.

* In Bookmarkshelf Reports > Logs, added a *Write to File* button.

* Fixed a bug which caused folders moved in an Import Client to not always be moved when re-imported, as they should if the Merging Keep is set to Client.  This bug was introduced in 0.9.13 when we went a little too far in fixing a bug in 0.9.13; see the first item listed in 0.9.13 Release Notes.

## BookMacster Version 0.9.20 (2010-04-03)

* Added coordination between BookMacster and Agents' Workers to avoid document conflicts.  These conflicts would appear as "This document’s file has been changed by another application since you opened or saved it.  The changes made by the other application will be lost if you save.  Save anyway?".  These conflicts occurred when attempting to save a Bookmarkshelf after an Agent had been triggered to perform its Commands on that same Bookmarkshelf.  In the new version, workers perform Commands themselves only if the subject Bookmarkshelf is not open in BookMacster.  (a) If the subject Bookmarkshelf is open in BookMacster and the BookMacster app *is not* active, then instead of opening the Bookmarkshelf itself, the Worker messages BookMacster to perform the Agent's commands on the already-open Bookmarkshelf.  This is for the benefit of Usage Style 3, when a Bookmarkshelf is left open in the background to receive new items from web browsers.  (b) If the subject Bookmarkshelf is open in BookMacster and the BookMacster app *is* active, the Worker silently aborts itself and the Commands are not performed.  This is so that a user who is manually editing content in BookMacster will not be interrupted.

* In BookMaster's AppleScript terminology, 'agent' elements of 'bookmarkshelf' documents have been exposed, and they respond to a new command, 'perform'.  These additions allow Agents to be triggered to perform their commands via AppleScript.

* Fixed bug so that an AppleScript asking for the 'identifier' of a bookmarkshelf now returns the identifier instead of error -10000.

## BookMacster Version 0.9.19 (2010-03-28)

* Now supports new Delicious accounts, or converted old Delicious accounts, which are linked to Yahoo! accounts.  Old and new Delicious account selections now appear in the menus and tables prefixed with *Delicious - Old Skool* and *Delicious - Yahoo!*, respectively.

* Fixed a bug which caused a bookmark to fail to be deleted at Delicious during an Export, if the bookmark in the Bookmarkshelf was normalized and the bookmark at Delicious was not normalized, or vice versa.

* Fixed a bug which caused items to be incorrectly deleted and then restored on alternate imports if the *Merging Keep* setting was *BkmxDoc*.

* Fixed a bug which caused any new items in the Bookmarks Bar of a Bookmarkshelf, except the first new one, to fail to be exported to any Opera client.

* Fixed a bug in New Document wizard which caused Export Clients to be (unnecessarily) requested when user selected Usage Style 1 or Usage Style 3.

* In logging the changes resulting from an Import or Export operation, a new category named *slides* has been split off from the category of *updates* (Δ), and *slides* are not counted toward the Change Limit for an Import or Export operation.  *Slides* are items which have had only their position changed, and are indicated by the symbol ↕ in the summary in the Status View and in the Import/Export Logs.  The reason for this change is that, under the old definition, adding, say, one bookmark at the top of a folder of 400 bookmarks would cause 400 items to be displaced downward by 1, thus have their position changed, and cause the update count for this one addition to be 400.  This would make a big deal out of a little deal, and exceed any reasonable Change Limit which the user had set to declare an error and abort such operations.

* The error which occurs when an Import or Export operation attempts to exceed its Change Limit is now presented as a warning instead of an error, and a additional recovery option, to *ignore the limit this one time only*, is available.

* Fixed a bug in the conception of the internal operation queues which, if a Bookmarkshelf had more than one Import or Export Client, and a second Import or Export operation was commanded before a first such operation had begun to Import or Export its last Client, caused the first Client of the second Import or Export to be imported or exported before the remaining Clients of the first Import or Export.  This would usually result in some or all content disappearing, but it seems that orphaned items or crashes would have been possible too.

* Fixed a bug which, during recovery from an error in which multiple Clients were being imported or exported, caused Client Imports or Export queued after the one during which the error occurred to be omitted.

* Fixed a bug which caused the space available for displaying the subject bookmark name to be only enough to show a half dozen or so characters, next to the progress bar in the Status View, when adding or deleting subject bookmark during an Export to a Delicious client, or when deleting subject bookmark during an Export to a Google Bookmarks client.

* No longer checks the minimum version of a web browser before importing its bookmarks.  Instead, checks this only after an import fails, and if the browser is found to be too old, presents this to the user as a possible reason underlying the failure.  This change resolves inability to import bookmarks if the latest web browser is installed in a nonstandard location, or in File Vault, and the system instead finds a too-old version somewhere.

* Now presents the web page when, instead of sending bookmarks, Yahoo!-Delicious sends an undefined HTTP Status Code with an unexpected web page.

* Fixed a bug which caused the blue "hint" arrow which appears if the user clicks "Change Limit" during an excessive Export Operation to sometimes point to the wrong column or row in the Export Clients table.

* Added *gopher://* and *color:* to the list of http schemes that may be exported to Delicious clients, in conformance with the latest revision of [Restricted Bookmarks on Delicious](http://delicious.com/doc/dangerous).

* Removed the possibility that Opera 9 bookmarks might be opened instead of Opera 10.  This would happen if Opera 9 had been used more recently than Opera 10.  BookMacster does not support Opera 9 bookmarks as a Client.

* Added a *Log Path Aliases* menu item to the *Help* menu.  This is for use by a particular beta tester who has experienced a problem we need to understand better.

## BookMacster Version 0.9.18 (2010-03-12)

* The New Document wizard now explains the first choice in terms of the *Usage Styles*, including the new Usage Style 3, which is *Import my browsers' current bookmarks, but from then on, bookmark with BookMacster directly*.  Also, this dialog now has a Help Button.

* The recently-introduced term "User Case" in the Help Book has been changed to "Usage Style".

* When adding a new bookmark from a web browser via the BookMacster bookmarklet, now searches for an already-existing bookmark with the same normalized URL and if found gives user choice to Merge, Cancel, or Keep Both.

* General updates to Help Book, in particular all of the screenshots have been to reflect the current window designs.

* In Help Book, removed HTML frames so that content pages now get the full window width, and also the forward and back buttons work as expected in Mac OS 10.6's Help Viewer, which is buggy when handling framesets or inline frames.

* In Help Book generation, fixed a bug which caused some hyperlinks to fail.

* Clicking the Help Button in the Bookmarkshelf window now opens the Help Book to the page which is relevant to the current window tab, instead of the Home Page of the Help Book.

* Fixed a bug which caused Bookdog and Bookwatchdog to usually be force quit if they were running when BookMacster was launched, since the time allowed for them to quit was too short for most systems.  Also, if quitting fails, now alerts the user with an error instead of force quitting the offender.

* Fixed a bug which caused, in a Bookmarkshelf > Reports > Duplicates, the *Allow* and *Delete* buttons to be disabled if more than one bookmark was selected.

* BookMacster and its Workers now check to make sure that Bookdog and Bookwatchdog are not running before performing any Import or Export operation, instead of just when launching.

* Fixed a bug which caused BookMacster to crash the first time that it was launched on a Mac account which also has a very old version of Bookdog, earlier than 4.4.0.

* In the New Document wizard, if the filename suggested by concatenating Client names in Usage Style 1 or 2 is too long, it now substitutes simply "Bookmarkshelf-N", where N is a number, instead of truncating the suggestion to something which doesn't make sense.

* Upon opening a Bookmarkshelf, BookMacster and Workers now check that the presence or absence of each Hard Folder in the Content matches the Settings in Structure, and fails with an error if any discrepancy is found.

## BookMacster Version 0.9.17 (2010-03-04)

This update attempts to fix a problem for some users who cannot open their Bookmarkshelf documents after updating to BookMacster 0.9.15 or 0.9.16.

If you're not having this problem, you can skip this update.

If you are having this problem, please install this update and let us know via Forum or email if it fixes it, your macOS version, and what was the last BookMacster version that saved the problem Bookmarkshelf, or the approximate date that you did so.

* Added Mapping Model for data model versions "3-5".

## BookMacster Version 0.9.16 (2010-03-03)

* Updated Google Bookmarks protocol to reflect recent changes at Google.  At the present time, at least in California, depending on the nature of the bookmarks change(s), users of prior BookMacster versions will encounter either HTTP Error 502, or a silent failure, when exporting to a Google Bookmarks client.  BookMacster 0.9.16 talks to Google using its new protocol.

* BookMacster now sports its own Status Menulet (aka *Status Menu*, *Menulet* – an icon in the top right of the screen).  It is off by default, and can be activated by a new checkbox in Preferences > General.  When activated, it can be used to visit sites bookmarked in an open Bookmarkshelf, using the browser indicated by that bookmark.

* Improved and added hyperlinks to Help Book sec. 0.1, "Introducing *BookMacster*".

* To eliminate two levels of navigation, if only one Bookmarkshelf is open, the Root level is now omitted from the hierarchical "Visit Bookmark" section of the Dock Menu, and the root-level folders are shown directly in the menu.

## BookMacster Version 0.9.15 (2010-03-01)

* Help Book has been updated to reflect recent changes, and reorganized to make basic usage instructions more prominent.  (The Help Book still has old screenshots, though.)  BookMacster 0.9.14, which was posted for a couple hours, still had the old opening page on the Help Book.

* Now supports adding bookmarks directly to a Bookmarkshelf, via a *BookMacsterize* bookmarklet which is exported to web browsers.  Other methods of adding bookmarks directly to a Bookmarkshelf are still under study.

* Now supports visiting bookmarks of open Bookmarkshelves from BookMacster's Dock Menu.

* To protect bookmarks in case of unexpected file corruption, *Safe Limit* controls have been added to limit the number of additions+changes+deletions in an Import or Export operation.  For users of the Advanced Settings, there are two new controls, in the Clients tab of a Bookmarkshelf.  For users not using Advanced Settings, there is one control in the General tab of a Bookmarkshelf.

* Fixed a bug which sometimes caused the number of deleted items in an Export operation to be under-counted.

* When moving an item while it is being displayed in the Inspector, its displayed Lineage now updates immediately to reflect the new location.

* Fixed a bug which allowed items to be moved above Hard Folders when copying or moving items to Root, when using  *Copy To…* or *Move To…* menu contextual items.

* If only one Bookmarkshelf is open, the first item in the *Copy to…* and *Move to…* contextual menus are now titled simply *Root* instead of the Bookmarkshelf filename.

* The items shown in the hierarchical *Copy to…* and *Move to…* contextual menus are now displayed with folder icons.

* To more accurately reflect usage of the *Description* field when bookmarks are added directly to a BookMacster Bookmarkshelf, the name of this field has been changed to *Comments*.

* The Inspector Panel now does not open when opening a Bookmarkshelf unless it had been open when the last Bookmarkshelf was closed.

* The font size in the table in Reports > Logs now tracks the font size set in Preferences > Appearance, as the other tables do.

* Fixed a small memory leak which occured when clicking the Gear Menu Button in the Inspector.

## BookMacster Version 0.9.13 (2010-02-14)

* Fixed a bug which was triggered during repeated Imports from multiple Clients which contained matching items with different attributes, for example, different locations.  The bug was that, the attributes (such as location) of these items in the Bookmarkshelf would oscillate, on alternate imports, between the attributes (locations) in the first Client and the attributes (locations) in the second Client.

* Results during an Import/Export, if Merge By URL is switched on and is used to match an item, now better match user expectations if Clients have bookmarks with the same normalized URL scattered in different locations in different Clients.  If the matching algorithm finds more than one item in the destination with the same normalized URL as a source item, the best one is now chosen from among them by comparing parents, and if that fails to produce a unique match, then by comparing names, instead of just choosing one arbitrarily.

* During an Import or Export, the policy for deleting empty folders has been clarified to affect any folder, from either source or destination, which was not empty at the beginning of the operation but was empty at the end of the operation.  Previously, the behavior was not well-defined.

* Fixed a bug which, when importing from multiple Clients with Merge by URL switched on, if there were duplicates within Clients, caused the duplicate items from different Clients which were so merged to only be registered as being present in only one Client instead of all.  We're not sure if this caused any problem, since registration would have occurred upon the first Export.

* Fixed a bug which caused an old tag joiner for each tag to be not deleted, every time there was an export to a Firefox Client.  This would increase the file size with redundant tag joiners, and also when inspecting tagged bookmarks in Firefox' Organize Bookmarks, tags would be listed multiple times.  For example, if a bookmark was tagged with "News", after three exports from BookMacster, in Firefox' *Organize Bookmarks* this bookmark's tags would be listed as "News, News, News".  Because the current version properly deletes and rewrites all old tag joiners whenever it exports, exporting to that Firefox Client once with this version of BookMacster will remove all the redundant tag joiners, and from then on it should only say "News".

* Improved speed of some operations by eliminating unnecessary processing.  In particular, *Delete All Content* is much faster.

* Added a new *Reports* tab named *Logs*.  This tab displays a history of Import and Export operations, showing the additions, deletions and changes made during each operation, and other information.

* Fixed some bugs in counting the numbers of items Added, Changed and Deleted which appear in the Status Bar after an Import or Export (and now also appears in the Logs).

* Fixed a bug which caused the autosaved settings of a Bookmarkshelf window (Table vs. Outline Mode of Main Content View, window size, tab selections, window minimum size and column widths in tables) to be forgotten the *second* time that its document was opened.

* Fixed a bug which caused too-wide and too-narrow column sizes to be sometimes applied to a New Bookmarkshelf.  The too-ness was proportional to how much the width of any prior Bookmarkshelf window had last been resized away from the default width.

* Fixed a bug which caused the Bookmarkshelf window to jump up by about 140 pixels, or to the top of the screen, whenever a new tab view item was selected, if Show Advanced Interface was unchecked.

* Fixed a bug which caused the Undo Action name to sometimes become other than "Undo Import" or "Undo Export" after Import or Export, followed by an Undo operation followed by a Redo operation.

* After creating a new Bookmarkshelf, the third column in the Main Content View is now set to show the attribute which most users would find third-most interesting given the Clients, instead of always showing Tags.

* In Bookmarkshelf window, more cosmetic fixes were applied to how windows are resized and controls are placed when switching tabs.

* When creating a New Bookmarkshelf with multiple Clients, the "Skip duplicate Bookmarks which hit the same page when merging Clients" checkbox is now switched ON by default.

* Fixed a bug which caused the *folder is expanded* attribute to be sometimes incorrectly imported from or exported to Opera Clients.

* In a Bookmarkshelf's Main Content View and Find Table, it is no longer possible to resize the rightmost column inward from the right edge and reveal ugly artifacts.

## BookMacster Version 0.9.12 (2010-02-05)

* Fixed two bugs in writing Google Bookmarks and Delicious passwords to the macOS Keychain.  First, if user checked box to "Keep in my macOS Keychain", passwords were only written during initial testing, after setting the Client, and not if a password was required to replace an incorrect or removed password during an Import or Export operation.  Second, passwords were sometimes written incorrectly.  This version finds and removes incorrect keychain entries written by previous versions.

* If a Google Bookmarks server rejects a password which BookMacster obtained from the macOS Keychain, now provides an error recovery option to remove the invalid password from the Keychain, instead of just telling the user that login failed without giving a clue how to fix it.

* In Bookmarkshelf window, cleaned up sloppy some control placement and margin sizes when resizing, and restoring autosaved sizes.

* Holding down the 'option' or 'alt' key while launching now inhibits Bookmarkshelves set to Open when BookMacster Launches from doing so.  Note: This is in addition to, and does not conflict with, the feature that holding down the 'option' or 'alt' key while opening a Bookmarkshelf causes settings of Mirror-Open, Sort and/or Find Duplicates when launching to be inhibited.

* Reduced number of Firefox backup files archived in ~/Library/Application Support/BookMacster/Firefox 3 Backups from 32 to 10.  (In the final release, we plan to either improve or remove this.)

## BookMacster Version 0.9.11 (2010-02-01)

* Fixed a bug dropped into 0.9.10 which caused a crash when opening a Bookmarkshelf when running in macOS 10.5, and the Detail View, when switched to Tags, to not edit properly when running in macOS 10.6.

## BookMacster Version 0.9.10 (2010-01-31)

This is a beta test with a built-in expiration date of 2010 Feb 14.  Known issues are that still we don't support new Delicious accounts based on Yahoo! ID, localization is sporadic, and many of the screenshots in the Help Book don't reflect the current user interface.

* Preferences > Appearance > *Show Icons in Bookmarkshelf Toolbar* now allows icon sizes None, Small and Regular instead of just None and Regular, and Small is the default setting for new users.

* Added menu item File > Close and Delete.

* Fixed bugs which caused incorrect progress indicator behavior in the Status Bar at the bottom of the Bookmarkshelf window during Delete All Duplicates and possibly other operations.

* Fixed a bug which, with some combinations of Import and Export Clients, would cause an Import or Export Client to immediately change its web browser or service to one which was not in use, after it was moved.

* Fixed a bug which caused an empty Undo Action labelled "Undo (null)" to be registered when changing the expanded/collapsed state of a folder was Redone.
 
* Better error message is given if Safari bookmarks cannot be exported because Safari, iSync or another application is currently editing or syncing them.  Also, the timeout before an Agent raises this error has been increased from 20 to 180 seconds.

* Fixed tooltip in Bookmarkshelf > Settings > Clients > Export Separators.

* Fixed a bug which, if Preferences > Appearance > Icons in Bookmarkshelf Toolbars was set to None, and more than one Bookmarkshelf was open, and user clicked the *Quick Search* tool in one of them, toolbars in all Bookmarkshelves would temporarily show icons during the search instead of just in the one that was clicked.

## BookMacster Version 0.9.9 (2010-01-27)

This is a beta test with a built-in expiration date of 2010 Feb 14.  Known issues are that still we don't support new Delicious accounts based on Yahoo! ID, localization is sporadic, and many of the screenshots in the Help Book don't reflect the current user interface.

* Bookmarks which are RSS Feeds now show, if available, the names of their articles in their tooltip.  Currently, Firefox *Live Bookmarks* and RSS Feeds from OmniWeb have these available when imported into BookMacster.
 
* Fixed a bug which caused export to fail with Error 15993 when exporting to a Firefox or OmniWeb profile or loose file, when the bookmarks being exported contained one or more RSS Feeds with articles that were imported from a different Firefox or OmniWeb profile or loose file.

* In the Main Content View and Find Table, when hovering mouse over a text cell or tags cell with truncated text or tags, the Expansion Tool Tip which shows the entire text or tags now appears properly in macOS 10.6.

* When the Detail View or a table/outline column is set to show Tags (without hovering the mouse over the cell), more tags that can fit in the available space are now indicated by an ellipsis.

* Attempting to add a duplicate tag to a bookmark now produces an Alert sound, and the duplicate tag is not added.

* Fixed a bug which caused some Bookmarkshelf documents to open with unsaved changes and *Undo (null)* showing in the Edit menu.

* The subject of the email message which gets produced when BookMacster encounters an error now includes the error code number.

* In the Content Tab, in the "+" (Add) button, added a little triangle pointing down to indicate that clicking this button exposes a menu.

* The annoying "Context-Click for Contextual Menu" tooltip is no longer displayed in the Main Content View.

## BookMacster Version 0.9.8 (2010-01-24)

This is a beta test with a built-in expiration date of 2010 Jan 31.  Known issues are that still we don't support new Delicious accounts based on Yahoo! ID, localization is sporadic, and many of the screenshots in the Help Book don't reflect the current user interface.

* Fixed bugs which caused the default column widths which should be used when creating a new Bookmarkshelf to sometimes be ignored.  (For users of earlier versions, behavior will still be wonky until the first time you resize a "Name" column, which will fix your Preferences.)

* Fixed bug which caused a new Bookmarkshelf created by Importing from Bookdog to be born with unsaved changes under some conditions.

* Fixed a bug which sometimes caused the "Bookdog Grads" Help page to show on the second time after a Bookmarkshelf created by Importing from Bookdog was saved, instead of when it was first created and saved.

* For minimalist users, Preferences > Appearance now has a checkbox to turn off showing icons in Bookmarkshelf toolbars.

## BookMacster Version 0.9.7 (2010-01-22)

This is a beta test with a built-in expiration date of 2010 Jan 31.  Known issues are that still we don't support new Delicious accounts based on Yahoo! ID, localization is sporadic, and many of the screenshots in the Help Book don't reflect the current user interface.

* The Tag Cloud has been moved from the top of the Content Tab to the left side, and its tooltip now includes advice on how multiple bookmarks can be tagged by dragging bookmarks to tags, and vice versa.

* When viewing the Main Content View in Table Mode, a sentence appears above the outline whenever filtering has been applied by a Quick Search string or filtering by tags, dynamically explaining the current filter criteria.

* Several buttons, and the Detail View, which were scattered around the Content Tab have all been aligned to a single row just under the toolbar at the top.

* The labels "✖", "Any" and "All" on the Tag Filter switch have been changed to "-", "✓", and "✓✓".  This has been done because the new labels look better, and not many people understood the meaning of "Any" and "All" without reading the tooltip or Help anyhow.  In addition, the new dynamic explanation (see previous item) makes the effect of this switch readily apparent and easy to learn.

* Inconsistent terminology in the Content Tab has been made consistent (although the Help Book still needs to be updated).  It now consists of a  *Main Content View*, a *Tag Cloud*, and a *Detail View*.  The *Main Content View* has two modes: *Outline Mode* (hierarchical) and *Table Mode* (flat).

* Undo and Redo operations now show the display the tab in which the change was made, clearly showing the undone or redone data, up to an infinite number of undo and/or redo operations, instead of only up to the second redo.  Several other fixes were made to the Undo and Redo operations, where it was found that incorrect Undo Actions names would be shown in the menu, in few places multiple Undo clicks were still required to undo single commands, the Show Advanced Interface value would be changed but not be realized in the view, etc.

* Fixed a bug which caused items in the Main Content View to appear as blank lines with disclosure triangles if a Bookmarkshelf was saved with the Main Content View in Outline Mode but not dislaying the Content Tab at the time it was closed, until the mode was changed to Table mode and then back to Outline mode once.

* Fixed a bug which caused items in the Main Content View to be all collapsed, ignoring their stored expanded/collapsed state, if a Bookmarkshelf was saved dislaying a tab other than the Content Tab at the time it was closed, until the mode was changed to Table mode and then back to Outline mode once.

* Fixed a bug which, when using the *Hold shift key down to stop folders from springing open* feature during a drag and drop in the Content Outline, would cause all folders in the entire outline to collapse when the items were finally dropped.

* Fixed a bug which caused all Delicious bookmarks to always be downloaded during any Import of Delicous bookmarks, even if the server indicated that BookMacster's local cache was in sync.

* During an Import, when attempting to download from two Delicious accounts consecutively, or if a download is repeated too soon for some other reason, now gives a better error message and offers to retry the Import automatically when it is safe to do so.

* Now displays a more descriptive error message if a server sends a response with an HTTP Status Code which is not defined in internet standards.  In particular, this accomodates the fact that Yahoo!'s Delicious now usually sends an undefined 999 instead of proper 503 when the user's IP address has been temporarily banned.

* When selecting tags in the Tag Cloud with mouse clicks, the selection now changes on mouse up instead of mouse down if a modifier key is not down.  This is the standard Mac behavior and allows drags to be initiated immediately, no longer requiring a wonky triple-click which I don't even think I can describe.

* After dropping one or more tags from the Tag Cloud onto a bookmark, the target bookmark is now selected and the Detail View is switched to the Tags position, so that the result of the operation is apparent.

* Immediately after creating a New Bookmarkshelf, the Undo menu item is now disabled, indicating *Nothing To Undo*, instead of being enabled to undo weird stuff.

* Upon creating a new Bookmarkshelf, if Outline mode results, all of the items are now always expanded.

* When executing an Import from Bookdog, things execute and results appear in a more orderly fashion.

* Fixed a bug which caused column widths set by user to be forgotten upon reopening a Bookmarkshelf, restoring default column widths instead, if one of them was too narrow to show the title in its header.

## BookMacster Version 0.9.6 (2010-01-12)

This is a beta test with a built-in expiration date of 2010 Jan 22.  Known issues are that still we don't support new Delicious accounts based on Yahoo! ID, localization is sporadic, and many of the screenshots in the Help Book don't reflect the current user interface.

* A Toolbar has been added to the top of the Bookmarkshelf window, and several controls have been moved into this new toolbar.  The moved controls are the Help button, the top-level tab selector (Content|Settings|Reports), the Quick Search field, and the Inspector button.  Upon typing into the Quick Search field, the Content tab is selected, to display the results.

* The menu attached to the Quick Search Field has been expanded to allow setting of *Search for* parameters (Bookmarks, Soft Folders) and *Search in* parameters (Name, URL, Tag, Shortcut, Comments)

* Folders as well as bookmarks are now included in the Content Outline when it is in Flat mode, if "Folders" is checked ON in the Quick Search menu.  (By default it is not.)

* Entering text into the Quick Search field now resets the Filter by Tag (X|Any|All) switch to off (X), so that results are filtered by text only.  (The user can still filter by text *and* tags by re-clicking the Filter by Tag switch to Any or All, after entering text.  Although this is an inconvenience when doing repeated Quick Searches by text and tags with different text, it is less confusing for the much more common usage style of doing a quick search by text only, while not noticing that a Filter by Tag had also been set, causing unexpected omissions.)

* When executing an Undo or Redo of data which is not visible in the currently-displayed Bookmarkshelf tab, now selects the tab in which the result of the Undo Redo operation is visible, at least up until the second Redo action.

* All actions in Bookmarkshelf's Settings > Clients and Agents are now correctly described in the Edit menu, at least up until the second Redo action.

* Welcome Window is now a non-modal window, and there is a checkbox and preference to not show it when no document opens upon launch.

* The method for storing the states of two switches in a Bookmarkshelf's user interface has been changed so that changing their settings no longer causes a saved document to need to be saved, and also the changes no longer appear in Undo or Redo.  The two switches are (1) the switch for Hierarchical-vs.-Flat above left of the outline and (2) the Detail View switch for Tags-vs.-Lineage below the outline.  Their states are now stored in Preferences instead of in the .bkmslf document file.  (This also makes things cleaner under the hood.)

* All tables in Bookmarkshelf's Settings now support reordering of items using drag and drop,  ⌘↑ or ⌘↓.

* Added missing ToolTips to Bookmarkshelf's Settings > Clients.

* Fixed a bug which could caused the Triggers popup in a Bookmarkshelf's Settings > Agents to omit the "Bookmarks Changed" and "Browser Quit" triggers, when in fact the Bookmarkshelf's Clients should have allowed these triggers.

* Fixed a bug which could cause elements in a Bookmarkshelf window to be incorrectly resized upon reopening the document.

* When launching or saving, no longer tries (and fails, presenting an error) to quit the BookMacster-Quatch process if it is running on another user account on the same Macintosh.

* During Verify, if the internet pipeline becomes clogged, the progress bar in the Status Bar now spins indeterminately until the pipeline unclogs, instead of disappearing until the pipeline unclogs.

* Improved error messages if failure occurs getting identifiers for items during Import or Export, especially with Firefox.

* Added more defenses against corrupt preferences files.

## BookMacster Version 0.9.5 (2009-12-31)

This is a beta test with a built-in expiration date of 2010 Jan 15.

* Fixed a problem, introduced in 0.9.4, which can cause a crash while closing a Bookmarkshelf document.  (This problem was triggered by introduction of GCUndoManager but appears to be the fault of Apple's frameworks, not GCUndoManager).

* More Undo Action Names have been provided, so that the *Undo* and *Redo* menu items are now much more likely to give a meaningful description instead of just *Undo* or *Redo*.

* After clicking Undo or Redo to effect changing of a Client, the new (or old, as the case may be) setting now shows up immediately in a Bookmarkshelf's Settings > Clients.  In previous versions, the change appeared mysteriously after de-activating and then re-activating the tab, window or application.

* When saving a Bookmarkshelf document while Mirror-Save is on, in the "will export now" warning sheet, if user checks the box to "Switch Off Mirror-Save", the switching off is now done before the saving, so that the document does not need to be immediately re-saved.

* When logging in to Google Bookmarks in order to Import or Export, if the user is already logged in to the correct Google account with a cookie, now skips the unnecessary dance of logging out and then back in.

## BookMacster Version 0.9.4 (2009-12-29)

This is a beta test with a built-in expiration date of 2009 Dec 31.

* Fixed a bug (probably introduced in 0.9.2) which would cause a crash, or cause Import or Export to fail silently, when logging into Google Bookmarks if a good password for the desired Google Bookmarks account was not found in the Keychain.

* Fixed a bug which could cause a crash when undoing addition or deletion of Clients in Bookmarkshelf's Settings > Clients.

* Now uses Graham Cox' [GCUndoManager](http://apptree.net/gcundomanager.htm).

## BookMacster Version 0.9.3 (2009-12-27)

This is a beta test with a built-in expiration date of 2009 Dec 31.

* Fixed a bug which could cause bookmarks from Google Bookmarks or Delicious Clients to be omitted during an Import from multiple clients, if the Google Bookmarks or Delicious Client was not the last one in the list.

* During an Import or Export, when unmappable items are mapped into the Default Parent or other alternative parent, they are now all added neatly underneath their aboriginal siblings, instead of being shoved in at some random index.

* Bookmarkshelf's Status Bar (the line of text and progress bar at the bottom of the window) now scales appropriatedly when the window is resized.

* When a Bookmarkshelf window opens and shows the Content tab, the Detail View near the bottom now correctly indicates "No Selection" instead of an empty space.

## BookMacster Version 0.9.2 (2009-12-27)

This is a beta test with a built-in expiration date of 2009 Dec 31.  The special debugging log-writing in the previous version has been removed since tht experiment is now concluded.

* The 'Merge Tags' checkbox for Import in a Bookmarkshelf's Clients tab has been removed, because (1) its default setting of OFF and disabled would clear tags in the Bookmarkshelf when content was re-imported from a Client which did not support tags, and (2) it was deemed that not many users would ever want this to be off, and for those that do, probably what they really want is Clean Slate anyhow.  The explanation of this feature was removed from Sec. 2.6 of the BookMacster Help and the new non-adjustable behavior is explained in a new section 2.8.2.

## BookMacster Version 0.9.1 (2009-12-25)

This is a beta test with a built-in expiration date of 2009 Dec 31.  

This is also a special debugging version which writes a file to the desktop when attempting to log in to Google Bookmarks, to help us troubleshoot an issue reported by a particular user.

* Fixed some un-cosmetic formatting errors which crept into the Help Book in 0.9.0.

## BookMacster Version 0.9.0 (2009-12-24)

This is a beta test with a built-in expiration date of 2009 Dec 31.  A new version will be available in Check for Update by then.

* Upon selecting a tab view of a Bookmarkshelf window, the window size now changes appropriately to the new view, and when user resizes the window, the window size is remembered for each resizable tab view when it is reselected later, for each Bookmarkshelf.

* When Importing with Clean Slate on, existing Separators in a Bookmarkshelf are now deleted.

* In Settings > Clients > Export, a checkbox has been added to disable exporting of any separators whatsoever.

* Behavior of separators during Import and Export is now clearly explained in BookMacster Help, Sec. 2.8.2.

* After adding a new Bookmark or Folder using the popup menu in the Content Outline View, when a field
editor opens and grabs focus for immediate editing of the new item's name, it now stays opens instead of closing after a few milliseconds.

* Measures have been added to prevent writing and reading of corrupt column widths to the Preferences.  In prior versions, when corrupt column widths were read, the body of the Content Outline and Reports > Find table would appear to be empty, although sometimes items would reappear after relaunch, and the second and third columns might be missing, or if they were there, would not respond to clicks in their column header.

## BookMacster Version 0.8.4 (2009-12-20)

This is a beta test with a built-in expiration date of 2009 Dec 25.  A new version will be available in Check for Update by then.  All of the special debugging behavior present in 0.8.1-0.8.3 has been removed, because all of those issues have been resolved. 

* When importing from Bookdog, creating a Bookmarkshelf from a single Bookdog Bookmarks Document (resulting in the same single Client for Import and Export), now checks on Mirror-Save in addition to Mirror-Open.  With the addition of the warning before saving several versions ago, it seems that the prevalence of Bookdog cross-graders being surprised by Mirror-Save has been eliminated, and so this fix addresses the issue of such users making changes in the Bookmarkshelf, saving, and then finding their changes gone after re-opening because their old bookmarks were re-imported.

* Fixed a bug which caused a crash when clicking the "+" button under the Import or Export Clients list in a Bookmarkshelf's Settings > Clients tab, if BookMacster could not guess which new Client was wanted next and added a "No Selection" Client.

* The initial Client set when adding a new Import or Export Client will now never show a Client that is already listed, and in general it now makes a more intelligent choice.

* Fixed a bug which caused a crash when attempting to log into Google Bookmarks with invalid credentials.

* During an Import or Export, if valid credentials are entered for Delicious or Google Bookmarks after an initial failure due to invalid credentials, now recovers automatically and completes the login, the retries the desired Import or Export.

## BookMacster Version 0.8.3 (2009-12-18)

This is a special version with some extra logging to help us track down a crash experienced by a particular user when logging into Google Bookmarks.

* Fixed a bug which caused a Bookmarkshelf to become unresponsive following an Undo or Redo operation which restored previously-deleted Duplicate Groups.

* Now implements Safari's file locking protocol, to prevent Safari from crashing in the event that BookMacster or its Worker happen to export to Safari while the user is editing bookmarks in Safari.

## BookMacster Version 0.8.2 (2009-12-17)

This is a special debugging version with the normal throttling of Worker operations due to Bookmarks Changed set to 5 seconds instead of 5 minutes.  Also, the Worker plays a "Tink" sound when it begins and a "Pop" sound when it ends.  This version if for testing only.

## BookMacster Version 0.8.1 (2009-12-17)

This is a special version with some extra logging to help us track down a certain problem which is being experienced by a particular user.

## BookMacster Version 0.8.0 (2009-12-16)

We still have several crashes reported by individuals which have not yet been fixed in this version, but it does fix a major crash which has been reported by several people, so we decided to push this version out anyhow.  Again, this is a beta test with a built-in expiration date of 2009 Dec 25.  A new version will be available in Check for Update by then.

* Fixed a bug which could cause a crash, or deleted duplicates to still appear, if all the bookmarks of a Duplicate Group existing in the Duplicates Report were deleted in one operation.  This could be triggered by selecting all the bookmarks in the Content Outline and hitting 'delete', but there are other sneaky ways that the triggering factors can occur.  For example, they can occur when BookMacster is launched, if a Bookmarkshelf with such content is set to open on launch, and also to Mirror-Open Import from a Client not currently containing these bookmarks.  The signature of this crash was that it took several seconds and resulted in a long crash report with stack of 511 calls, including calls to com.sheepsystems.Bkmxwork alternating in groups of 2 and 5.

* Opening a Bookmarkshelf while holding down the 'option' key now inhibits operations normally caused by the Settings *After Open...* *Import* (Mirror-Open), *Sort* or *Find Duplicates*.  Same idea as when you restart or log in to your Mac with the certain keys held down.

* Now responds as expected to AppleScript 'open' and 'open documents' command, and understands the AppleScript term 'bookmarkshelf'.

* Added a few AppleScript commands: *activate* (an override of Apple's default method), *view errors from worker*, and *reveal tab*.

* The methods by which BookMacster's Workers activate BookMacster to show errors and duplicates have been redesigned and made more robust and better-behaved by using the new AppleScript commands.

## BookMacster Version 0.7.0 (2009-12-14)

This is a beta test with a built-in expiration date of 2009 Dec 25.  A new version will be available in Check for Update by then.

* BookMacster can now open Bookmarkshelves created by any earlier version of BookMacster.  When opening Bookmarkshelves created by versions of BookMacster prior to 0.1.9, it will immediately re-save the Bookmarkshelf, leaving the original file with a tilde ("~") appended to its name.  This is explained further in section 1.0.3 of *BookMacster Help*.

* It is no longer necessary to quit BookMacster in order for Agents to work.  Instead, a locking mechanism has been provided which prevents BookMacster the Worker initiated by an Agent from importing or exporting at the same time.

* After deleting items in the Content Outline, adjacent remaining items are no longer selected.

## BookMacster Version 0.6.3 (2009-12-10)

This is a beta test with a built-in expiration date of 2009 Dec 21.  A new version will be available in Check for Update by then.

* Deleting, expanding, or collapsing an item in the Content Outline of a Bookmarkshelf no longer causes the outline to scroll to the top when operating under macOS 10.5.

## BookMacster Version 0.6.2 (2009-12-08)

This is a beta test with a built-in expiration date of 2009 Dec 21.  A new version will be available in Check for Update by then.

* Fixed bug which caused Bookmarkshelf window to open with missing elements, and generally not work correctly, when operating under macOS 10.5.

* Fixed bug which caused an exception if a New Bookmarkshelf was created without specifying any Clients in the Wizard.

## BookMacster Version 0.6.1 (2009-12-08)

This is a beta test with a built-in expiration date of 2009 Dec 21.  A new version will be available in Check for Update by then.

* Fixed a bug which caused New Bookmarkshelf command to fail, not producing a window, if only one web browser (i.e., Safari) was ever used on the user's Mac account.  If you have not been affected by this issue, **you may choose to skip this update**.

## BookMacster Version 0.6.0 (2009-12-07)

This is a beta test with a built-in expiration date of 2009 Dec 21.  A new version will be available in Check for Update by then.

* During importing of bookmarks from multiple web Clients, if a Client is delayed by waiting for the user to approve quitting the web browser, other Clients no longer jump ahead of it in the order.  This had resulted in bookmarks content from the delayed Client being orphaned and missing from most views.  This affected Import from Bookdog of multiple Clients into one combined Bookmarkshelf, as well as executing a regular Import with multiple Clients active.

* Fixed a bug which caused separators from Camino to be coalesced into fewer separators, losing some, during an Import.

* In the *New Bookmarkshelf* Wizard, an additional dialog has been added which asks, after user picks multiple Import Clients, which one should be imported first, and offers the option to merge by Url for the remaining Import Clients.  (This is actually the same dialog which appears during Import *From Bookdog* after selecting a *Combined* Bookmarkshelf.)

* Changed order of default Commands in default Agent so that *Save Document* occurs after *Export* instead of before.  This order is required, for example, so that items' identifiers exported to the Client can be fed back and saved in the Bookmarkshelf.  Without this feedback, if a Bookmarkshelf is closed, reopened, and then the same export repeated to the same Client (as typically happens with Agent invocations), new items will not be properly recognized as old items in subsequent exports, and changes will be repeated.

* Items copied and pasted to within the same parent now land at the expected location, in the expected order.  (However note that, as in the table/outline views in other Mac apps, the landing location is just below the *most recent item which was added to the current selection*, which is not necessarily the highest-indexed item in the current selection.  This sometimes leads to unexpected results if a multiple selection is created by extending a selection upwards.  But it is correct.)

* In the Status Bar, after an import or export, the number of updated ("Δ") items is no longer overstated if items move around due to deletions during the process but end up back where they started.

* Separators (either [Glims](http://www.machangout.com/) or BookMacster) are now recognized as such when importing from Safari.

* When importing and exporting Safari separators, changed Glims detector to detect the Agent which powers Glims 1.x.  (No longer detects the old Input Manager of Glims 0.x.)

* Camino separators which have been previously imported now behave like other imported items: They are recognized as already existing and not as new items, so that after an Import or Export, they are no longer counted in the Status Bar in the numbers of deleted ("-") and (re-)added ("+") items.

## BookMacster Version 0.5.0 (2009-11-30)

This is a beta test with a built-in expiration date of 2009 Dec 07.  A new version will be available in Check for Update by then.

* Fixed a bug introduced in 0.1.9 which might haved caused a crash, but usually Google or Delicious Bookmarks would "just not import" when a password was extracted from the macOS Keychain.

* In Reports > Duplicates, when a bookmark is selected and the "Allow" button is clicked, item(s) which should no longer be in the report now disappear immediately.

* Fixed bug which allowed the Inspector Show/Hide button to get out of sync with reality sometimes.  Also, added a checkmark to menu Bookmarkshelf > Show Inspector so that it can now also be used to hide the Inspector.

* In Inspector Panel, added a field which displays the Clients which the selected item is identified with.  Also, a little cosmetic cleanup of Inspector Panel.

* After selecting an item in the Content tab and then switching Reports > Duplicates tab, the "Allow" and "Delete" buttons are now disabled if no bookmark is selected in the Duplicates Report above them.

* Tooltips added in the Reports > Duplicates tab, to the "Allow" and "Delete" buttons.

* Content items whose names should not be editable (Hard Folders and Separators) names are no longer editable in any view, in particular, the Inspector Panel where they had been editable.

* Fixed a bug which, under a rare circumstance (item with nil name) would cause Export to a Firefox Client to hang the app.

## BookMacster Version 0.2.0 (2009-11-29)

This is a beta test with a built-in expiration date of 2009 Dec 07.  A new version will be available in Check for Update by then.

* Applied a temporary fix to a bug which caused an error when Bookmarkshelves created with versions of BookMacster prior to 0.1.9 were opened, edited and then attempted to be saved.  Such Bookmarkshelves will now refuse to open.

* Fixed a bug which would cause a crash if a simple Bookmarkshelf was created by importing from Bookdog, and if the "Show Advanced Interface" checkbox was unchecked to Off and then re-checked to On.

* Fixed bugs which caused sorting by Agents to not happen when triggered if the relevant bookmarks only had minor changes such as moved bookmarks.

* In Settings > Clients > Merge > Keep, eliminated the setting *Both* (i.e. *keep both*), because there seems to be no reason that this would ever be desirable, and also because it could cause more than one item to have the same identifier, which will probably have many unintended bad consequences.

* In Agent Worker, increased the timeout allowed for the system to return the Bookmarkshelf file path from 3 seconds to 120 seconds.  This should eliminate occurrence of Error Code 19005 if an Agent is triggered when the system is too busy to respond immediately, such as when waking from sleep.

* When performing a *Save As* operation, the status bar now correctly indicates that data is being written to the new filename, instead of the old filename.

* When performing an Import or Export with a Client whose browser does not allow it to be running during operation, increased the time allowed for the browser to quit, before giving up and proposing Force Quit, from 6 seconds to 15 seconds.

* All three outline/table views (Content, Duplicates, and Find) in the Bookmarkshelf window, the Tag Cloud and the Detail View in the Content tab now change their font size and row height immediately when the font size is changed in Preferences > Appearance.

* In Reports > Find, the spacing between the table rows now properly tracks the font size.

* If user had previously quit with Inspector panel open, when BookMacster is relaunched, now it only re-opens after the first pre-existing Bookmarkshelf is done reopening, or never if no pre-existing Bookmarkshelves are reopened.

* Fixed a bug which caused a crash if, while selecting a Client in *Other Macintosh Account*, user clicked *Cancel* in the *Choose Account* sheet.

* Preferences Window has had cosmetic cleanup.  For example, the window height now animates to fit the content of the selected tab, just like a *regular app*.

* If user has the old Bookwatchdog set as a Login Item, and if this Bookwatchdog has now been deleted (not trashed – deleted), when BookMacster attempts and fails with error code 19584 to delete this Login Item, the error displayed now includes a Failure Reason and Recovery Suggestion

* Help Book now explains about *Show Advanced Settings*.

* In Bookmarkshelf window, Settings > Clients tab, aligned table headings and columns.

* Added some extra logging ("Mercrash ...") to help find a reported crash involving contextual menu.

## BookMacster Version 0.1.9 (2009-11-23)

This is a beta test with a built-in expiration date of 2009 Nov 30.  A new version will be available in Check for Update by then.

* In *Settings* > *Clients*, added *Merge Keep* controls to the Import and Export configurations, so that for each Client, user may configure whether to keep items from the Client, items from the Bookmarkshelf, or items from Both.  Operation is explained in BookMacster Help §2.6.1.  Some bugs in this area of merging were also fixed.

* When Importing from Bookdog, if user selects a *Combined* Bookmarkshelf and more than one Client, now presents an additional dialog asking which Client has the best structure and giving the option to Skip Duplicates between Clients.

* Settings > General now has a checkbox to specify *Show Advanced Settings*.  Unchecking the box reveals a "simplified" user interface with the *Clients*, *Structure* and *Agents* subtabs removed from *Settings*.  A single Client and a single default Agent (which keeps bookmarks sorted) may be selected in the *General* subtab.  The simplified user interface is used, when generating simple Imports from Bookdog and simple New Bookmarkshelves.

* Import Clients' *Clean Slate* now only affects the first client imported.

* Modified the import/export of Separators to follow the new *Merge Keep* control instead of *Clean Slate*, except for *Both*.

* Modified which folder is kept when merging folders to follow the new *Merge Keep* control instead of *Clean Slate*.  Operation is explained in BookMacster Help §2.8.2.

* When analyzing for duplicates, now distinguishes between URLs with different [fragment identifiers](http://en.wikipedia.org/wiki/Fragment_identifier).

* Fixed a crash which would occur while Finding Duplicates if bookmarks contained a corrupt bookmark with an undefined "host" portion.

* Fixed a bug which caused a crash if an early error occurred while logging in to Google Bookmarks.

## BookMacster Version 0.1.8 (2009-11-16)

* Fixed a possible bug introduced in 0.1.7 which might cause BookMacster-Worker to quit  on launch because of failure to "load library SSYLocalize".

* Disabled *License Info* menu item for versions such as this which do not require a license.

* Fixed *Help* button in *About BookMacster* box.

## BookMacster Version 0.1.7 (2009-11-16)

This is a beta test with a built-in expiration date of 2009 Nov 23.  A new version will be available in Check for Update by then.

* When performing a *Save As* or *Save As Move* operation, now ignores the *Mirror-Save* setting if it is on, and thus does not perform an Export.  *Mirror-Save* now only affects *Save* operations.

* When performing a *Save* operation, if *Mirror-Save* is turned on, now gives a warning and choice to override *Export* and/or turn off *Mirror-Save*.

* An Import operation which does not change any bookmarks content no longer causes a Bookmarkshelf document to indicate that it has unsaved changes.  The explanation for the former phenomena, which had been in BookMacster Help §1.2.3, has been deleted.

* When performing a *Save As* operation, the Status Bar now indicates *Completed: Save* after the operation has actually completed, instead of before the file name has even been specified in the dialog sheet.

* Drag-dropped items now land at their expected locations instead of one or more rows down.

* Copying an item from a source document to a destination document no longer causes the source document to indicate that it has unsaved changes.

* Fixed a bug which caused bookmarks to be imported from *loose* files without identifiers, printing many error messages to the console in the process.

* Speeded up *Delete All Duplicates* in some cases by coalescing internal notifications.

* While executing *Delete All Duplicates*, the progress bar in the Status Bar now progresses properly.

* When done executing *Delete All Duplicates*, the notation that *New duplicates, not shown, may exist* no longer appears above the report.

* Fixed a bug which would cause a crash if user rapidly hit the 'enter' key three or more times as BookMacster was launching, giving default responses to the *Welcome* and *Choose [Recent] Bookmarkshelf* dialogs, along with extra hit(s) during a window of vulnerability.

* Corrected misinformation in BookMacster Help §6.2.1.

## BookMacster Version 0.1.6 (2009-11-12)

This is a beta test with a built-in expiration date of 2009 Nov 23.  A new version will be available in Check for Update by then.

* Fixed a major bug which was inadvertantly introduced a couple weeks ago as a side effect of fixing another problem.  This bug would cause items to be misplaced or lost during import and export.  With each import or export, different items would be misplaced and sometimes it would cause a crash.  The crash report would show a "stack" of 511 lines in Thread 0, with the last 505 or so being identical.

* Fixed Google Bookmarks login which was recently broken when Google added a 'GALX' parameter to their login protocol.  (Most Google Bookmarks users, with only one Google account, to which they are almost always logged in, would probably not have noticed this problem.)


## BookMacster Version 0.1.5 (2009-11-11)

This is the initial beta release of BookMacster.  It has a built-in expiration date of 2009 Nov 23.  A new version will be available in Check for Update by then.

Known issues are:

* Like other Delicious clients available at this time, BookMacster cannot access new Delicious client accounts which are created with a Yahoo! ID.
* Only about half the strings are localized.  Localization is to be considered.
* Undo and Redo work *pretty good*, actually, better than most apps, but sometimes lose track if several undos are followed by several redos.  Bug reports with repeatable "steps to reproduce" would be appreciated.

Thank you for testing *BookMacster*!

