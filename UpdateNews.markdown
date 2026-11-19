<!-- # Latest Updates for Smarky, Synkmark, Markster and BookMacster -->

This is a significant update for users of the Orion web browsers.  Other users may reasonably skip this update.

## Version 3.3.13 (2026-11-19)

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which was introduced in version 3.3.7 which in some cases prevented even populated folders from being exported to Orion, instead of just preventing empty folders from being exported to Orion.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Fixed a bug which, when exporting to Orion, sometimes caused a error when attempting to delete items in Orion.

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Now correctly maps items from the bookmarks root in Orion to the root of our Collection, and vice versa.  (Orion is the only Chromish browser which allows bookmarks and folders in its bookmarks root).

*  <img src="images/Smarky.png" alt="" class="whappMini" /> <img src="images/Synkmark.png" alt="" class="whappMini" /> <img src="images/BookMacster.png" alt="" class="whappMini" /> Improved description displayed with Error 651507.

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


For earlier version changes, see the [Version History](https://sheepsystems.com/bookmacster/HelpBook/SSYMH.05.03.html).
