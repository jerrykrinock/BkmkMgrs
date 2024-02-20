# Browsers (Clients) <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [clients]

In BookMacster, **A *Client* is usually a web browser.**  More generally, a client is a thing from which a Collection will get [bookmarks content]() during its *Import*, and to which it will send them during its *Export*.  In the first context, it is referred to as an *Import Client* and in the second, an *Export Client*.  You add and remove Clients in the Import and Export tables in a Collection's *Settings* > *Clients* tab.

In Synkmark, Safari, Firefox and Chrome profiles are actually all *clients* under the hood, but they are always one of these three, so we just call them "browsers".

In Smarky, Safari is actually a *client* under the hood, but we just call it "Safari"!

SSYMH-PAGE-TOC

## Types of *Clients*

There are actually four types of clients.

* <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> Most often, a Client is a **[locally-installed]()** web browser app, with its bookmarks in your Mac account.  Client "Safari" simply means *your* Safari bookmarks.  For browser apps that support multiple [profiles](), each profile is a different Client.  (This is the only type of Client supported by Smarky and Synkmark.)

* <img src="images/BookMacster.png" class="whapp" /> A Client can also be a **[web-based]()** browser app account.  If you have multiple accounts, for example, two Pinboard accounts, each will appear as a separate Client in BookMacster.

*  <img src="images/BookMacster.png" class="whapp" /> A Client may also reference the bookmarks of a particular locally-installed web browser app on **another Mac account** on your network, for example, *the Chrome bookmarks in profile "Suzie" in server Old Mac Mini*.  This will appear in the popup menu as "Old Mac Mini:Suzie:Chrome".

* <img src="images/BookMacster.png" class="whapp" />  Finally, a Client can be a ***loose* file**  of bookmarks which you accessed using the *Choose File (Advanced)* menu item.  BookMacster tracks this file using the path and file alias mechanism built into macOS.

## Browsers' Syncing Services <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [browserSync]

Many web browser publishers now provide proprietary sync services for your bookmarks, open tabs, browsing history and other data among **their** browsers on multiple [devices]().  For syncing, you may need to [consider how they interact with Smarky, Synkmark or BookMacster](syncMultiDesign).  The following list gives links to the instructions you need to control these services.

* For Firefox, Mozilla provides [Firefox Sync](https://support.mozilla.org/en-US/products/firefox/sync)
* For Safari, Apple provides [iCloud > Safari](https://support.apple.com/en-us/HT203519).  That article is a little vague.  To switch Safari bookmarks syncing on or off, click in the menu  > *System Preferences* > *Internet & Wireless* > *iCloud*, then switch the checkbox labelled *Safari* (macOS 10.8 or later) or *Bookmarks* (macOS 10.7).  We've also found this [even better explanation](http://osxdaily.com/2013/03/28/how-to-sync-safari-bookmarks-between-mac-os-x-windows-iphone-ipad/).
* For Chrome, Google provides [Chrome Sync](https://chrome.google.com/sync).
* For Vivaldi, there is [Vivaldi's Sync](https://help.vivaldi.com/article/sync/)
* For Opera, Opera Software provides [Opera Sync](https://www.opera.com/computer/features/sync).
* iCab offers a syncing facility if you bring your own WebDAV server.  Launch iCab and click *Preferences* > *Show All* > *Browser* > *Bookmarks* > *Synchronizing*.
* Ditto for OmniWeb.  Launch OmniWeb and click *Preferences* > *Bookmarks*.

## Browser (Client) Settings <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [settClients]

<img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> In Smarky and Synkmark, settings for browsers are in *Preferences* > *Syncing*.


<img src="images/BookMacster.png" class="whapp" />In BookMacster, settings for Clients are in BookMacster's document window, tab *Settings* > *Clients*.

<div class="screenshot">
<img src="images/ClientsTab.png" alt="" />
</div>

In all cases, these settings are not kept in the .bmco document.  Instead, they are [Local Settings]().

### Browser (Client) Popup <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [clientPopup]

The control contains a popup menu for each Browser (Client), in which you specify its target browser/service/account/profile.  Browser (clients) found on your [Macintosh User Account]() are listed explicitly.  Otherwise, you can click one of the special menu items at the bottom:

* To access bookmarks in a web app account which does not have a password in your keychain, click *New/Other*.
* To access bookmarks of a Client app in another Macintosh user account, click *Other Macintosh User Account*
* To access bookmarks in a "loose" file, *Choose File*.

After clicking one of these special items, appropriate dialogs will appear for navigation, account or application identification, and/or authentication as required.

Smarky does not have this popup because it supports only the single Safari profile in the current Macintosh user account.

### *Import* and *Export* Checkboxes <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [imexChkbx]

For normal syncing of bookmarks, leave both the *Import* and *Export* checkboxes switched ON.  (For Smarky, there are no such checkboxes because both *Import* and *Export* are always enabled.)

If you don't want bookmarks changes from the Client to be synced to Synkmark BookMacster, other Clients, other Macs, etc. then switch off *Import*.  If you don't want the Client to get bookmarks changes from Synkmark or BookMacster, other Clients, other Macs, etc. then switch off *Export*.

### Advanced Client Settings <img src="images/BookMacster.png" class="whapp" /> [advClientSetts]

In BookMacster, advanced users can customize the way imports and exports are done.

#### Per-Client Settings [advClientSettsPerClient]

<div class="screenshot.left">
<img src="images/AdvancedClientSettingsPerClient.png" alt="" />
</div>

To the right of each Client listed in Settings > Clients tabs is a small button with a gear icon.  Clicking this button displays a sheet of the Advanced Settings for that particular Client.  In the sheet, you'll see sub-contexts *Import*, *Export* and *Special* in which the settings are applied.  The *Special* subsection is for settings which are only applicable to a certain Client type, and therefore will not be shown for all Clients.

##### *Merge By* popup menu [mergeBy]

One of the main features of our apps is that when you import from or export to a web browser, we don't just overwrite everything or plop the items from the source into a new folder in the destination labelled *Imported on XXX date*.  Instead, by default, items are *merged*; that is, we recognize items which we have imported or exported previously and leave them alone if there are no changes, or make necessary changes without re-creating the whole item.  Without merging, our app would delete the old item and insert a new item, which takes more time, uses more resources, and makes it confusing to track what happened.

Generally, web browsers and web bookmarking app attach a hidden [identifier](exid) to each item, and our apps use this identifier when merging.  You can change everything about a bookmark (name, URL, whatever) and it will still be recognized as the same bookmark during an import or export, because you did not and could not change its identifier.

Optionally, if an item cannot be matched by identifier, as happens during an initial import or export of an item, our apps can try to match items by URL.  Of course, this only works for bookmarks, not folders.  This is done during the first *Import All* operation after you create a new .bmco document, because most new users have bookmarks with the same URL in multiple browsers which they do not want merged into one instead of creating a duplicate.

The Advanced Client Settings has two popups, one for Imports and one for Exports, in which BookMacster users can specify how merging should be done.  The choices are: 

  * None.  Do not try to merge.  Just delete all existing items in XXXXX, then XXXXport all items from XXXXXX to it.  This is faster for one time operations.  And it is in fact what happens (regardless of your setting here) for Clients such as .html files which do not support identifiers on individual bookmarks or folders.

  * Identifier only.  If an item cannot be matched by identifier, it is treated as a new, separate item.  

  * Identifier or URL.  Try to match items by identifier, and then if some items fail to match by identifier, try to match them by URL.  This is the default setting.

#### Import Postprocessing Settings [advClientSettsImportPP]

<div class="screenshot.left">
<img src="images/AdvancedClientSettingsImport.png" alt="" />
</div>

Besides making adjustments during an Import operation for each Client, a few adjustments, for example [Delete Unmatched Items](), cannot be performed until after all Clients have been imported.  You can set the parameters for these adjustments by clicking the larger button with a gear icon nearest the top of the Settings > Clients tab.

### Reordering Buttons <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

By clicking the up and down triangles at the far right, you can arrange the order of which Clients' imports and exports.  This may make a difference when [bookmarks content]() is imported.  For example, if two Clients each have a bookmark with the same URL, and are set to [merge by URL](), which of the two is actually imported is affected by which one is imported first.  (Note that BookMacster [normalizes URLs]().)  For Export operations, however, because exporting does not affect the Collection's content, the order of Clients does not matter.

### Browser (Client) Name in Red, prefixed by **X** <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [redClient]

If a Client's name appears in a red font, prefixed by a heavy red X, that means the Client's bookmarks data can no longer be found on the disk, and thus it is defunct.  There are three ways to resolve this situation:

* Click the disappeared Client's popup and re-assign it a different client which is currently available.

* Restore the data of the disappeared client, possibly from a backup.  If you don't know how the data disappeared, try changing a bookmark in the Client.

* Delete the defunct Client by clicking its "-" button.

Firefox clients, in particular, will go defunct after you have  [somehow](https://bugzilla.mozilla.org/show_bug.cgi?id=717070) caused a [Firefox Reset](http://mzl.la/MLVHSq), because in so doing, [Firefox suffixes the re-created profile name with a unix epoch timestamp](https://bugzilla.mozilla.org/show_bug.cgi?id=717070).  In this case, you should see the new client/profile in the popup, available for reassignment.

## Warning to power users <img src="images/BookMacster.png" class="whapp" />

Your knowledge of where bookmarks files are stored is nice but dangerous.   Do not use the *Choose File* advanced feature if you simply want to access the bookmarks of a locally-installed app.  Doing so will make browser-related [triggers]() unavailable and bypass checking to see whether or not a browser is running when later executing an Import or Export, which can result in bookmarks loss or corruption.  To set, for example, your Safari bookmarks as a Client, simply click "Safari" in the Clients popup menu.  And, by the way, never touch Safari's *Bookmarks.plist* file while *Safari* or *Bookmarks* syncing is switched on in *iCloud* in your System Preferences.  If not done properly, iCloud will quietly raise hell, not always immediately.

