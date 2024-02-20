# Browser (Client) Oddities<img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

This page explains several subtle behaviors in some Import and Export operations which apply only when certain [browser or client](clients) types are involved.

SSYMH-PAGE-TOC

## Safari Issues

### App Updates

It is important for Safari users to keep our apps updated.  Since Apple removed official support for other apps editing Safari bookmarks outside of Safari in year 2011, our apps have used a reverse-engineered method to access Safari bookmarks, which has become increasingly complicated every year.  Apple could break our method with any macOS update, although this usually only happens annually, when macOS and Safari get major revisions.  If you install the macOS beta which Apple releases in June, you will likely find issues which we have not fixed yet, because we don't get the beta until June either.  For example, if you are syncing to Safari in macOS 13 Ventura or later, you need version 3.0 or later of our app.

### Granting Access in macOS 10.14 and later [grantAccessSafari]

In macOS 10.14 Mojave, and then making it worse in macOS 11.4 without warning, Apple has imposed additional security around Safari bookmarks.  Since this has proven to be a moving target, please [visit our latest instructions for fixing this issue](https://sheepsystems.com/discuss/YaBB.pl?num=1531491187/).

### Separators in Safari

Apple's Safari does not support separators, but Smarky, Synkmark, Markster or BookMacster "fake" them as best we can.  We export Safari [separators]() as a horizontal line of em-dashes, unless the bookmark's parent is the Bookmarks Bar, then it is the pipe character ("|").

### Mapping into Safari's *Reading List*

Safari has a third [hard folder]() called *Reading List*.  The idea of this is similar to the *Unsorted Bookmarks* in Firefox (except that it has a name which makes a little more sense).  They are both intended to be a place where you might quickly drop bookmarks discovered while browsing the web that you would like to read later, and then either "sort" (where here we have mean *categorize* instead of *alphabetize*) into a regular folder or delete.

Therefore, during [Import and Export]() operations, Smarky, Synkmark, Markster or BookMacster [map]() Safari's *Reading List* into its *Reading/Unsorted* hard folder, along with those of Firefox.  One issue, however, is that while Firefox allows folders (subfolders) in its *Unsorted Bookmarks*, Safari does not.  Therefore, when exporting to Safari, if a *Reading List* is found (indicating that the bookmarks of Safari 5.1 or later), any folders found in *Reading/Unsorted* are mapped into the [root level]() of Safari instead of Safari's *Reading List*.

### Sorting (Ordering) of the Reading List

When Safari displays its Reading List, it ignores the order imposed by Smarky, Synkmark, Markster or BookMacster and instead seems to display according to date added, with the more recent first.

### Moving On from legacy *Bookmarks Menu* [safariMenuObsolete]

When Safari was first published in 2003, it had two [hard folders]() under its root level: *Bookmarks Bar* and *Bookmarks Menu*.  A third hard folder, *Reading List*, was added in 2011, and at some point the *Bookmarks Bar* was renamed to *Favorites*.

When Safari appeared on the iPhone in 2007, it had only one hard folder, the *Bookmarks Bar*.  It did get the *Reading List* but not a *Bookmarks Menu*.  So, when Apple introduced bookmarks syncing between macOS and iOS devices, there was a bit of a mismatch.  Apple solved this by adding a behavior in Safari on iOS to create a *Bookmarks Menu* in Safari if and when bookmarks synced in from a Mac had items in the Bookmarks Menu.  Furthermore, at some point, on the Mac, Apple removed the Bookmarks Menu in new bookmarks collections which are created from scratch on a new macOS user account, and also added a behavior to remove the existing Bookmarks Menu if it was ever found to be empty.  In other words, the Bookmarks Menu was *grandfathered*.  If your bookmarks collection created years ago had items in its Bookmarks Menu, it would remain, but if you ever emptied it, it would disappear, and you could not get it back, well, unless you were using one of our apps, because…

Until version 2.12 of our apps, the *Bookmarks Menu* in our apps would export to Safari.  Of course, this would restore the *Bookmarks Menu* in Safari, if Safari had removed it.  However, when testing with beta versions of macOS 12 Monterey, we noticed that restoring the Bookmarks Menu in this way caused the *Favorites* and *Bookmarks Menu* appearing in Safari to immediately be relabelled with strange names (*BookmarksBar* and *BookmarksMenu*) until Safari was relaunched.  More importantly, in one occasion, it *may* haved caused iCloud syncing to stop.

Since the legacy *Bookmarks Menu* is clearly unwanted by Apple, and has become increasingly problematic as such deprecated features generally do, in version 2.12 of our apps we are adopting the behavior of Safari, and going a litte further, helping you to eliminate the grandfathered *Bookmarks Menu* if you have one.  During your first export to Safari with version 2.12 or later, any items in a *Bookmarks Menu* (also called *Other Bookmarks*) in our app will be appended to any existing items in Safari's root level.  Because Safari's main menu > *Bookmarks* includes items in the root level, they will appear on your Mac as they always have.  They will likewise appear in the root level in Safari on any iOS devices synced by iCloud, instead of in the grandfathered *Bookmarks Menu*, which will be gone.  One final change is that, in our app, the label of the hard folder *Bookmarks Menu* will be changed to *Other Bookmarks*, which is what it is named in Google Chrome and Microsoft Edge.

Summary: Although this is a rather serious change under the hood, you may not even notice it on the Mac.  Your bookmarks will be organized more uniformly across macOS and iOS devices, and more importantly, you will avoid some issues which we have seen when the legacy *Bookmarks Menu* is populated in macOS 12 Monterey, and likely avoid future issues as *Bookmarks Menu* compatibility gets less and less attention from Apple.  

### Can't have more than 500 items in a folder if using iCloud [iCloudFolderLimit]

For some strange reason, although this is [stated in their documentation](https://support.apple.com/en-us/HT203519), if you have more than 500 items (bookmarks + subfolders) in a folder, the order *may not* be preserved when iCloud syncs this folder to your other devices.  We have tested this and found it to be always the case that, although the first 500 items will be in order, if you have more than 500, the remainder will surely be all mixed up.  In addiiton to the obvious problem, this can, further cause [churn]() in future syncs.  For this reason, our apps check all folders before exporting.  If any are found containing more than 500 items, the export will fail with an error which explains why and how to fix.

## Chrome-ish Browser Issues

This section applies to all of the [Chrome-ish](chromish) browsers.

### Multiple Profiles

BookMacster supports multiple *Person* user profiles for those Chrome-ish browsers that support it.  Each browser/person is a separate [client]() in BookMacster.

You could sync two or three of Google Chrome, Google Chrome Canary or [FreeSMUG's Chromium](http://www.freesmug.org/chromium) together via a Google account, using their [built-in syncing](browserSync), but if you do that, be careful you don't create a [sync loop]().

### Loose Bookmarks vs. Enhanced Bookmarks <img src="images/BookMacster.png" class="whapp" /> [chromyEnhanced]

During the first half of 2015, the developers of the [Chrome-ish](chromish) browsers experimented on and off with what they called an *Enhanced Bookmarks Manager*.  As of this writing, 2015-06-26, [it appears to be off](https://productforums.google.com/forum/#!topic/chrome/mhIX5LB23As), and not even available – setting the *Enhanced Bookmarks Manager* setting in chrome://flags to *Enabled* has no effect.  However, it is still [available as an extension](https://chrome.google.com/webstore/detail/bookmark-manager/gmlllbghnfkpflemihljekbapjopfjik).

Whatever, if you use the *Enhanced Bookmarks Manager*, or if someday it comes back and becomes the only choice, BookMacster provides two optional settings which will make it sync more nicely with the more conventional bookmarks managers in Safari and Firefox.  The issue with the new interface is that the *Other Bookmarks* collection has been renamed to *Folders* and, as the name implies, it shows only the folders in it and hides "loose" bookmarks.  The loose bookmarks are actually still there, but the only way to see them is to click on *All Bookmarks*, which will show a lot of other bookmarks too.

If you use this Enhanced Bookmarks Manager, consider also using the options in the next two sections.

### 'Don't export loose bookmarks to 'Other Bookmarks' [noLoosiesInMenu]

This option, a checkbox in the [per-Client Advanced Client Settings](), is provided to play nicer with the [Enhanced Bookmarks Manager](chromyEnhanced), but it still works in any case.  If this checkbox is switched on, during exports, any loose bookmarks found in BookMacster's *Bookmarks Menu* will be [remapped]() (into the Bookmarks Bar) instead of being exported to the browser's' *Other Bookmarks* (called *Folders* if you are using the [Enhanced Bookmarks Manager](chromyEnhanced).).  In this way, *Other Bookmarks* / *Folders* will contain folders of bookmarks/subfolders only.

#### Create a 'Reading/Unsorted' [fakeUnfiled]

If this checkbox in the [per-Client Advanced Client Settings]() is switched on, during exports, if any items must be [remapped]() (including but not limited to the loose bookmarks mentioned in the previous paragraph), BookMacster will create and export to Chrome a folder named 'Reading/Unsorted' and put all such items into it.  The idea is to mimic the *Reading List* in Safari, or the *Unsorted Bookmarks* in Firefox.  However, it is not an un-delete-able [hard folder]() as are *Reading List* and *Unsorted Bookmarks* in other browsers.  It is in fact a regular [soft folder]() which you could delete or rename in the browser's bookmarks manager' if you wanted to.  However, do not do that because it will cause unexpected results.

During a later export, if there are no such items which need to be remapped, BookMacster will delete the *Reading/Unsorted* folder that it created.  (Technically it will delete any folder named "Reading/Unsorted" in the browser's *Other Bookmarks* (called *Folders* if you are using the [Enhanced Bookmarks Manager](chromyEnhanced).)

### *Mobile Bookmarks*

Smarky, Synkmark, Markster and BookMacster ignore but preserves Chrome's *Mobile Bookmarks*.  Our idea is that you should use *Mobile Bookmrks* for bookmarks which you only want on your mobile [device]().

You should put bookmarks which you want synced in either *Desktop Bookmarks* or *Other Bookmarks* (called *Folders* if you are using the [Enhanced Bookmarks Manager](chromyEnhanced).).  Chrome gives you a choice at the bottom of the popover.  Change "Mobile Bookmarks", and whatever you change it to will become your new default new-bookmark location.

If you have already started syncing with Smarky, Synkmark, Markster or BookMacster, and want to move your Chrome bookmarks out of *Mobile Bookmarks*, do this…

* Activate Smarky, Synkmark, Markster or BookMacster.

* Open your Collection if it does not open.

* Click the *Syncing* button in the toolbar to *Pause* syncing.

* Activate Chrome on your Mac.

* Click in the menu: *Bookmarks* > *Show All Bookmarks*.

* In the left sidebar, select *Mobile Bookmarks*

* Drag all the bookmarks you want from *Mobile Bookmarks* into *Other Bookmarks* or *Bookmark Bar*.

* Reorganize if desired.

* Activate Smarky, Synkmark, Markster or BookMacster.

* Click in the menu: File > Import from only > Chrome.

* Click the “Syncing” button in the toolbar to “Resume” syncing.

* Export as prompted.


### Sometimes Need Your Help to Load a Profile

There is a pathological case in which Smarky, Synkmark, Markster, BookMacster or [BkmxAgent]() will ask you to help a little by load a certain user profile so that it can import to or export from a [Chrome-ish](chromish) browser.  This will occur under the following conditions.

* You have created multiple profiles in a [Chrome-ish](chromish) browser.
* You have configured Syncers to sync a certain profile 'X'.
* In the browser, in profile 'X' , you have have enabled Chrome Sync to a Google account, have have not switched off the sub-setting to sync *Bookmarks*, which is on by default.
* The browser is running, but profile 'X' has not been loaded.  This will happen if the browser had been launched into a different profile, and no window has been opened into profile 'X' since launching.
* Smarky, Synkmark, Markster, BookMacster, or [BkmxAgent]() requires to *Export* to Chrome profile 'X'.

Once you load the profile, it will stay loaded until the browser quits, and will re-open automatically provided that you have a window open to this profile when quitting the browser.  In other words, this will not occur if you regularly use the profiles to which you are syncing.

We have requested that the Chrome developers provide a better facility for bookmarks syncing so that we may someday remove this annoyance.

## OmniWeb Issues

### Moving OmniWeb Items among its Hard Folders

[External identifiers]() of OmniWeb items are not unique among their three top-level {hard folders]() -- Favorites, Bookmarks Menu and My Shared Bookmarks.  Each of these collections can have an item numbered, for example, 57, and Smarky, Synkmark, Markster or BookMacster must therefore prepend a "collection identifier" to its identifier upon importing and remove it when exporting.

This sometimes causes little glitches.  For example, let's say you have a bookmark in OmniWeb's Personal Bookmarks that has been happily imported to and exported from a Collection .  In such a document, it appears in the Bookmarks Menu since this is the equivalent of OmniWeb's Personal Bookmarks.  Now, in OmniWeb, click menu > Bookmarks > Show Bookmarks Page, move this bookmark into Favorites.  Because it's in a different collection now, OmniWeb must assign it a different identifier.  Now activate the Collection and Import from OmniWeb.  Because it has a different identifier, the app will not recognize it as the one that was originally in the Personal Bookmarks/Bookmarks Menu, and will import it as a new bookmark, so now you'll have a duplicate.

You can prevent the duplicate from being created by setting the *[Merge Keep]()* control to *Client* or *Collection* and also checking *on* *[Merge URL]()*.

OmniWeb's bookmarks storage format was designed many years ago when the advantages of truly unique persistent identifiers were not as widely appreciated.  One hopes that if Omni Group continues development of OmniWeb, they will someday update update their bookmarks storage to realize this, as Opera Software did when they shipped Opera 9.5.

### Shortcuts Associated with URLs

OmniWeb associates its shortcuts with URLs instead of with bookmarks.  This means that if you have, for example, two bookmarks to the same URL, one with a shortcut and one without a shortcut, and export OmniWeb, in OmniWeb they will both have the shortcut.  Then when you import back from OmniWeb, Smarky, Synkmark, Markster or BookMacster will apply the shortcut to both of them.  However, if you are importing from other Clients at the same time, this conflict can cause spurious changes or [churn]() to be indicated in the Sync Log.

## Firefox Issues

### Multiple Profiles [ffoxMultiProfile]

Firefox supports multiple profiles on each Mac user account.  You may learn how to manage them in this [Mozilla support article](https://support.mozilla.org/en-US/kb/profile-manager-create-and-remove-firefox-profiles).  Unlike Chrome, which puts the 'Person' profile name in the title bar of every window, in Firefox it is very difficult to determine what profile you are in, if you are not sure.  The only way is to click in the menu: Help > Troubleshooting Information, then look for *Profile Folder* and click *Show in Finder*.  From looking at the name of the folder it shows, you can usually get a clue to what profile you are in.  Of course, it may be easier to quit Firefox and then restart with the Profile Manager as indicated in that article, specifying the desired profile.  There is also a [more in-depth article](https://developer.mozilla.org/Firefox/Multiple_profiles).

### Same Tags apply to Duplicate Bookmarks

In Firefox, when you click menu *Bookmarks* > *Manage Bookmarks* and get the bookmarks *Library* window, it appears as though [tags]() are associated with bookmarks, but they are not.  In Firefox, tags are actually associated with URLs.  In Smarky, Synkmark, Markster or BookMacster, tags are associated with bookmarks, just as they look.  To maintain the same content as you see in Firefox, when performing a [Import]() from Firefox, the app creates the same tags for all bookmarks that have the same url.

If you don't have any duplicate bookmarks (bookmarks with the same [normalized URL]()), then this doesn't matter, but if you do, it does.  For example, say that you have one or more bookmarks with the same normalized URL, and put a tag on, one of them, then Export to Firefox.  If you then inspect the content in Firefox' Organize Bookmarks window, you will see that all of the several bookmarks have this tag.


### Syncing of Separators, Tags, Keywords, Descriptions, and Live Bookmarks [syncFirefoxOnQuit]

The interface provided by Firefox for our *BookMacster Sync* extension does not support separators, tags, keywords (shortcuts), descriptions (comments) and Live Bookmarks.  Synkmark and BookMacster can still sync changes in these attributes with Firefox, but only when Firefox is not running.  Changes in separators will be ignored, and Live Bookmarks will appear in Synkmark and BookMacster as ordinary empty folders, instead of as bookmarks with the RSS icon.

If you are using Synkmark, or BookMacster with the default Simple Syncers, by default, Synkmark or BookMacster will silently perform the additional sync operations whenever Firefox quits.  If you are not using separators, tags, keywords, descriptions or Live Bookmarks in Firefox, you might want to switch this new feature off to avoid unnecessary syncing operations.  To do that, click in the menu: Synkmark or BookMacster > Preferences > Syncing.

<div class="screenshot">
<img src="images/SyncFirefoxWhenQuitPref.png" alt="" />
</div>

If you are using BookMacster with Advanced Syncing, and want separators, tags, keywords, descriptions or Live Bookmarks to be synced with Firefox, you should probably add a Browser Quit trigger to your Import changes from Firefox.

<div class="screenshot">
<img src="images/SyncFirefoxWhenQuitAdvanced.png" alt="" />
</div>

The reason we can sync these attributes when Firefox is not running is because we use the [*quick direct sync* method, instead of the *coordinated sync*](accessLocApp) which is used when Firefox is running.

When separators, tags, keywords, descriptions and Live Bookmarks finally sync, if there are conflicts between changes you have made in Firefox and changes you have made in BookMacster or Synkmark, the changes you made in Firefox will prevail.

### Slow Exports while Firefox is Running

Firefox is slow in accepting bookmarks exports while it is running.  If you're just adding a few bookmarks, this is not noticeable.  But if you are exporting, say, thousands of new items, as is typical in a first export from Smarky, Synkmark, Markster or BookMacster, it can take several minutes on a typical Mac.  If our app estimates that an export you've commanded' will take more than a minute, it will stop and ask you if you want to quit Firefox first, so that it can use a faster [*quick direct sync* method, instead of the *coordinated sync*](accessLocApp).

### Visit Count

Firefox keeps a *visit count* attribute for each bookmark, which, as the name implies, is supposed to increment each time a bookmark is visited in Firefox.  To see the *visit count* for a bookmark, display it in Firefox' *Show All Bookmarks* ("Library"), then perform a [secondary click]() on any column heading and switch on *Visit Count* in the contextual menu.  A *Visit Count* column will appear.

Smarky, Synkmark, Markster and BookMacster ignore Firefox' *visit count*.  The *visit count* that you see in Firefox is the count of visits from Firefox only.  The *visit count* that you see in Smarky, Synkmark, Markster or BookMacster is the count of visits from the app plus visits from other synced browsers which properly support import and export of *visit count*: OmniWeb.  (The design of Firefox makes syncing to their *visit count* problematic.)

## iCab Issues

### The Wandering Bookmarks Bar

iCab allows you to designate *any folder*, *anywhere in the hierarchy*, to be your *Favorites*.  The items in the *Favorites* folder appear in a toolbar across the top of the window.  It is thus like the *Bookmarks Bar* or *Bookmarks Toolbar* present in other browsers.

Smarky, Synkmark, Markster or BookMacster treats this folder as a Bookmarks Bar, but does not allow it to be anywhere.  When you Import from iCab, the *Favorites* folder, wherever it is, is moved to be the first child of the *[Root]()*, as in all other browsers.  However, the app remembers where it came from, and when you export to iCab, it is restored to its original location.

## Opera Issues

### Speed Dial [operaSpeedDial]

Opera is the only browsers that maps into all *four* of the [Hard Folders]() supported by our apps.  As shown in the chart in that section,
because the Shared Bookmarks is supported only by Opera and OmniWeb, those bookmarks will be [remapped]() when exporting to other browsers.

### Trash [operaTrash]

The *Trash* in Opera bookmarks is a special folder into which deleted bookmarks go.  Our apps ignore this during imports and exports.

## Vivaldi Issues

### Speed Dial is a Soft Folder [vivaldiSpeedDial]

The "Speed Dial* folder which appears in default Vivaldi bookmarks is not like the *Speed Dial* in Opera.  It is actually a soft folder.  (It can be renamed or deleted.)  Our apps therefore treat it as a [soft folder]().

### Trash [vivaldiTrash]

The *Trash* in Vivaldi bookmarks is a special folder into which deleted bookmarks go.  Our apps ignore this during imports and exports.

## Pinboard <img src="images/BookMacster.png" class="whapp" />

Short version: After making changes in Pinboard on the web, sometimes you need to wait 15 minutes or so before importing the changes to Smarky, Synkmark, Markster or BookMacster, or exporting additional changes from BookMacster to Pinboard.

Long Version:  In order to reduce network traffic and improve performance, BookMacster maintains a local cache of bookmarks stored on the remote servers, such as Pinboard's.  Prior to importing from or exporting to Pinboard, BookMacster sends a query ("posts/update") to Pinboard asking when was the last time that bookmarks were changed on the remote server.  If it matches the time that the local cache was stored, BookMacster skips downloading data from Pinboard and uses what it has.  Well, on 2012 June 13 we found that a download didn't occur as expected, and found that this was because Pinboard was returning a stale date to our "posts/update" query.  It did this for at least 10 minutes, but returned the correct date after 15 minutes.  If you don't want to wait, click in the menu BookMacster > Empty Cache….

## Punctuation in Diigo Tags <img src="images/BookMacster.png" class="whapp" />

Besides the fact that doublequotes serve as [tag delimiters]() in Diigo, other punctuation characters will get changed.  Commas get changed to spaces, forward and back slashes, and backslash-escaped doublequotes (as in "\"") get changed to underscores.  This is just what we've noticed; there may be other substitutions.  These are not documented anywhere in Diigo documentation.

## Smart Keyword Searches

Firefox, iCab, Google Chrome, the [Chrome-ish](chromish) browsers all support [Smart Keyword Searches](http://mzl.la/L8rNu0).  However, they are implemented differently.

* In Firefox and iCab, *Smart Keyword Searches* are stored as *bookmarks*.  Smarky, Synkmark, Markster or BookMacster will import them from these browsers, you'll see them in the [Content](theContentTab) of a Collection, you can edit them in BookMacster, and they'll be exported to these browser Clients.

* In the Chrome-ish browsers, Smart Keyword Searches are stored elsewhere, such as in Preferences.  You will never see them in Smarky, Synkmark, Markster or BookMacster.

Smarky, Synkmark, Markster or BookMacster will omit Firefox Smart Keyword Search Bookmarks when exporting to any other browser, because they won't like they do in Firefox.  (They don't work in iCab because iCab does not support a Keyword or Shortcut attribute.)

## <img src="images/BookMacster.png" class="whapp" /> Multiple Web App Accounts and the macOS *Keychain*

If you have multiple accounts for a web app such as Pinboard, each is a separate  *[Client](SSYMH.02.00.html#clients)* as far as BookMacaster is concerned.  BookMacster discovers these accounts and populates them into the *Import* and *Export* popup menus in *Settings* > *Clients* by looking in your [macOS Keychain]() for passwords you have stored to the web apps' domain, for example, Pinboard.  Some of these may have been entered previously by Safari, Cocoalicious or another *Keychain-aware* app.  To remove old accounts that are no longer used, launch the *Keychain Access* application (<code>/Applications/Utilities/Keychain Access.app</code>), search for and delete them.

When connecting to a web app, if BookMacster finds a password which you have not previously authorized BookMacster to use, Keychain will ask your permission. If BookMacster does not find the password even in Keychain, BookMacster will ask you to to enter it into as secure field, and give you the option to store it in Keychain for future use by BookMacster or any other (*Keychain-aware*) app which is smart enough to look there for it.  

## <img src="images/BookMacster.png" class="whapp" /> Download Policy Options for Web Apps [downloadPolicyOptsWeb]

During an Export operation to Diigo or Pinboard, BookMacster should find out what bookmarks are currently on the server and merge them per your settings.  Ideally, BookMacster would ask the server to *just tell me all of the bookmarks, if any, that have been added, updated or deleted since we last synced*.  But this information is not always available, sometimes not reliable, and in its absence BookMacster should download all bookmarks from the server.  This can take several or many minutes if you have thousands of bookmarks on the remote server.  Therefore, BookMacster allows you to manually override the default automatic behavior.  To access these controls, open the [advanced settings for the relevant Client](advClientSettsPerClient), and look in the *Special Settings* section.

Note that these settings are only available for permanent Clients which you have specified in the Settings > Clients tab.  The temporary Clients which are used when you click in the menu: *File* > *Import from Only* or *Esport to Only* will *always* download all bookmarks from the server (in BookMacster 1.22.4 or later).

<div class="screenshot">
<img src="images/DownloadPolicyCkboxes.png" alt="" />
</div>

The setting *Import* > *Never* is not available because it would defeat the purpose of the whole operation.  If you don't want a permanent client to Import, switch off its *Import* checkbox in *Settings* > *Clients*.

### Better Reliability: Always Download during Exports

Over the years we have seen bugs in the various web apps come and go, and at some times the indication from the server telling BookMacster that *nothing has changed, you can skip downloading* turns out to be  not true.  For best reliability, if you don't [export]() to a web app very often, you may prefer to *Always* download during Exports.

<div class="screenshot">
<img src="images/DownloadPolicyImportAlways.png" alt="" />
</div>

### Faster: Never Download during Exports

At the other extreme, to avoid the extended export times that can result if you have thousands of bookmarks to download, you may wish that BookMacster *never* download them.  This is technically OK if you use the web app only to *visit* bookmarks and **always change (add, update, edit, modify, delete) bookmarks in BookMacster only**, you may prefer to *Never* download during Exports.

<div class="screenshot">
<img src="images/DownloadPolicyExportNever.png" alt="" />
</div>

If there are other clients, it might also make sense to switch off the *Import* checkbox for this client (see above)

This can be efficient, but will will cause bad results if you ever forget and in fact change bookmarks changed on the remote server, using the client's web app, or some other tool, because this all happens effectively behind BookMacster's back.  For example, if you switch on this checkbox and then add bookmarks to the remote server using the web app or some other service, these bookmarks will be deleted the next time that you export from BookMacster, even if you have *Delete unmatched items* switched off.  Or if you delete 100 bookmarks on the remote server, then export from BookMacster, BookMacster will re-upload them if they are still in BookMacster, or waste time re-deleting them if not.


