<!-- # Latest Updates for Smarky, Synkmark, Markster and BookMacster -->

Note: We have been testing in macOS 27 *Golden Gate* and have thus far not found any issues which are specific to macOS 27.

## Version 3.3.12 (2026-10-22)

*  <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a crash which could occur in macOS 27 when upon clicking main menu > BookMacster > Background BookMacster.

## Version 3.3.11 (2026-10-20)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug in our background syncing agent (BkmxAgent) which would, in some cases, leave a web browser running after launching it to performa a syncing operation.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" />Internal maintenance: updated some old code to use Apple's current programming interfaces.

*  <img src="images/Synkmark.png" alt="" class="whappMini" />  Fixed a bug which made clicking the Syncing button in the toolbar to open Preferences instead of enabling syncing in the event that Synkmark was initially configured with no Synced Browsers, and a first Synced Browser was added later, until Synkmark was relaunched.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Error 259284 now states which browser is missing in the body of the description instead of only in the Recovery Suggestion.

## Version 3.3.10 (2026-08-25)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Added support for import and export with the *Brave Origin* (the paid version of Brave) web browser.

## Version 3.3.9 (2026-08-18)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> No longer works in macOS 11.  Now requires macOS 12 or later.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> We've added support for so many web browsers this year that the *Export Exclusions* list in the Inspector Window needed a scroller to show all of them.  That scroller is now in place.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Now pre-encodes apostrophe (`'`) characters in URLs when exporting to Chrome-ish browsers.  This eliminates churn for users who have such bookmarks.  The churn started recently due to a change in these browsers.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> When a Verify operation encounters a site managed by Cloudflare which returns a 403 "Not authorized" error due to our being actually a bot and do not responding to its "Verify you are human" challenge, now categorizes this bookmark as good instead of as broken.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> In the Inspector window, bottom collapsible *URLs* area, repositioned some graphics which have been misplaced in recent versions due to changes in Apple's build tools.

## Version 3.3.8 (2026-05-13)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Added support for import, export and syncing with the [Dia](https://www.diabrowser.com) web browser.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> In an attempt to fix occasional occurrences of Error 651507 ("browser stopped responding"), if a web browser app needs to be launched in preparation for an import or export with it, now waits an additional 3 seconds between the launch and the import or export.  The idea is to give the browser app more time to get its act together.

## Version 3.3.7 (2026-04-29)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> When importing from the current version of Vivaldi, no longer puts all items from Vivaldi into the *Bookmarks Bar*.  Items at root in Vivaldi (which is all items in Vivaldi) are now mapped to the root in our app.  By default, BookMacster users keep the old behavior in old Collection documents, and may [manually opt to the new behavior](https://sheepsystems.com/bookmacster/HelpBook/vivaldiUseLegacyMapping).

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Added support for import, export and syncing with the [Helium](https://helium.computer) web browser.

## Version 3.3.6 (2026-02-12)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Added support for import, export and syncing with the [ChatGPT Atlas](https://chatgpt.com/atlas/) web browser.

## Version 3.3.5 (2026-02-07)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Added support for import, export and syncing with the [Comet](https://www.perplexity.ai/comet) web browser.

*  <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed bug: Dragging multiple bookmarks to a tag did not tag all of the bookmarks. 

*  <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed bug: When user selected multiple tags in the Tag Cloud (RPTokenControl), then begins a drag, all tags except the last tag which was selected become deselected.

## Version 3.3.4 (2026-02-06)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Added support for import, export and syncing with [Zen Browser](https://zen-browser.app).

## Version 3.3.3 (2026-01-17)

*  <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> The option to have the icon of the Menu Extra be a grayscale image of the application icon, which looked bad and was not even discernable with the new applicattion icon we made for macOS 26, has been eliminated.  Users who had previously selected this option in *Preferences* > *Appearance* > *Menu Extra* will be automatically migrated to use the other option, which looks like is a simple, flat, black-or-white bookmark.  This icon is more appropriate in the current style of macOS.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Icons in *Preferences* > *Appearance* > *Colors* display properly when user is in Dark Mode now. 

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Added AppleScript commands to enable and disable *undo* registration, necessary to reduce memory bloat when running long scripts.

## Version 3.3.2 (2026-01-03)

*  <img src="images/BookMacster. png" alt="" class="whappMini" />  Fixed a bug which caused a crash when certain errors occurred while searching for crufty files or app versions, which our apps do in the background shortly after being launched.

*  <img src="images/BookMacster. png" alt="" class="whappMini" />  Fixed a bug which caused, when configuring a new Diigo or Pinboard client, switching on the *Save password to my macOS Keychain* checkbox to in fact not do that.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> To prevent later crashes or import/export failures, now automatically removes any invisible control characters when storing bookmark names.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Better error reporting in case the messaging host of one of our web browser extensions receives undecodeable data during an Import or Export operation.

## Version 3.3.1 (2025-09-12)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> In the document window > Now works with the latest version of Opera, no more Error 594520.  (Opera has corrected the index values for the first-level children in their bookmarks tree.)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> In the document window > Content tab, restored images to the "Outline Mode / Table Mode" button which somehow got deleted in version 3.3.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> In the Manage Browser Extensions window, fixed alignment of Version and Status indicators along the right edge, which were improperly displaced in version 3.3.

## Version 3.3 (2025-09-09)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/Markster.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> New app icon and other cosmetic repairs for compatibility with macOS 26 Tahoe.


For earlier version changes, see the [Version History](https://sheepsystems.com/bookmacster/HelpBook/SSYMH.05.03.html).
