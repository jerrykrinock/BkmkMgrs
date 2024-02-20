# Duplicates <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [taskDupes]

The app has tools to manage duplicate bookmarks, which we call **Duplicate Groups**, and also tools to manage Duplicate Folders.

It is important to understand that the app can’t work on the bookmarks in Safari, Firefox or Chrome directly.  In addition, the precise definition of what makes a *duplicate* requires some discretion.  Here is how you eliminate duplicates from bookmarks in a web browser…

* [Import the bookmarks](menuImExport) from the web browser into Smarky, Synkmark, Markster or BookMacster.

* Configure whether or not you wish to [ignore duplicates that are in different hard folders](ignorDupsDiffHardFolds).

* If desired, mark special bookmarks as [Duplicate Allowed](duplicateAllowed).

* [Find the duplicates](findingDuplicates).
* Delete the duplicates, either [individually](deleteDupes1By1), or [en masse](deleteAllDupes).

* Review your de-duplicated Content.

* [Export the bookmarks](menuImExport) back out to the web browser.


SSYMH-PAGE-TOC

## Duplicate Groups (Bookmarks)

A group of bookmarks in a Collection which have the same URL is said to form a *duplicate group*.  (Note that the app [normalizes URLs]().)  The app is able to find duplicate groups within a Collection and displays a list of them in the tab *Reports* > *Duplicates*.

<div class="screenshot">
<img src="images/ReportsDupes.png" alt="" />
</div>

Note that some browser apps (for example, Pinboard, and Firefox) do not allow duplicate groups within your account. If you create within or export a new bookmark into one of these apps which creates a duplicate group with an existing bookmark, one of them (usually the existing one) will be immediately and silently deleted.

## Finding Duplicates (Bookmarks) [findingDuplicates]

Because the process of finding duplicates needs to compare each of your bookmarks with every other bookmark, it can take quite a few seconds of intense computation when the number of bookmarks is large.  (For example, if you have 1000 bookmarks, 1000 URLs may need to be computed, and 1000 × 999 / 2 = 499,500 comparisons must be made.)  Therefore, the app does not always keep this report updated, and instead does so only when commanded to update the report.

To find duplicates and thus update the report, you may click in the menu *Bookmarks* > *Find Duplicates*,

<div class="screenshot">
<img src="images/MenuFindDupes.png" alt="" />
</div>

or else click the hyperlink in the tab *Reports* > *Duplicates*.

<div class="screenshot">
<img src="images/FindDupesHyperlink.png" alt="" />
</div>

If these controls are disabled, that means that no change which could have added duplicates has occurred since the last such update, and therefore no update is necessary.

Deleting duplicate groups in response to changes is not as laborious as finding them, so the app observes such changes and deletes defunct duplicate groups "on the fly".

The app detects as duplicates bookmarks whose URLs are the same except for schemes *http* vs *https*.

If you think that the app is not finding all the duplicates that you think are duplicates, see [Aggressively Normalize URLs](), below.

## Allowing Some Duplicates (Bookmarks)

Although duplicate bookmarks are undesirable in general, you may wish to allow duplicates of certain bookmarks for easy access.  the app provides two mechanisms for you to do this.

### Ignore Duplicates in different Hard Folders [ignorDupsDiffHardFolds]

*Ignore Duplicates in different top-level Hard Folders* is a setting which is useful if you'd like to keep a few commonly-used bookmarks in one [hard folder](), for example the Bookmarks Bar, but also have duplicates in another hard folder such as the Bookmarks Menu.  If this box is checked, Duplicate Groups which involve bookmarks in different Hard Folders are not reported.

Bookmarks whose lineage does not include one of these four hard folders, such as bookmarks in [root]() directly, or bookmarks which are in a [soft folder]() which descends from root, are considered to be in a "root" hard folder.  Duplicate Groups comprised of one bookmark in, for example, Bookmarks Bar, and another in the "root" will be ignored if this setting is checked ON.

In Smarky, Synkmark and Markster, this setting is a checkbox in *Preferences* > *General*.  In BookMacster, the checkbox is in a document's *Settings* > *General*.

### *Duplicate Allowed* Attribute [duplicateAllowed]

*Duplicate Allowed* is an is an attribute which may be switched on in any bookmark.  A bookmark so marked will never appear in a Duplicate Group.  Note that if you only have two bookmarks to a given URL, and activate Duplicate Allowed on one of them, Find Duplicates will now find neither bookmark.  If you have, say, three bookmarks to a given URL, and activate Duplicate Allowed on one of them, Find Duplicates will now find the other two.

There are several ways to mark (or unmark) a bookmark with this attribute:

* To do this while browsing the duplicates report (*Reports* > *Duplicates*), clicking the button:

<div class="screenshot">
<img src="images/MarkAllowedButton.png" alt="" />
</div>

will set the *Duplicate Allowed* attribute of the selected bookmark(s).

To do this while browsing the *Content*,

* In the Inspector panel, there is a *Duplicate Allowed* checkbox.  Since our Inspector smartly handles multiple selections, an easy way to "harden" a whole bunch is to show the Inspector, select all of the bookmarks which you want to "harden", and then switch on the Duplicate Allowed checkbox.  It will affect all of them.
* In the User-Defined Column in the Main Content View, if you set the column header to *Duplicate Allowed*.

<div class="screenshot">
<img src="images/DupeAllowUDC.png" alt="" />
</div>

## Removing Duplicates (Bookmarks) [deleteDupes1By1]

Of course, the direct way to remove a duplicate group is to delete all of the bookmarks in it except one.  You can do this in either the [Content View]() or, as shown here, in *Reports* > *Duplicates*…

<div class="screenshot">
<img src="images/DeleteSingly.png" alt="" />
</div>

### Delete All Duplicates [deleteAllDupes]

But if you find yourself with more duplicate groups than you care to deal with individually, you can command the app to *Delete All* duplicate groups…

<div class="screenshot">
<img src="images/DeleteAllButton.png" alt="" />
</div>

If you click **Delete All**, the app will step through each of the group and delete all except one in each.  (This is the same as clicking from the main menu > *Bookmarks* *Delete All Duplicates…*.)

Although this is fast, it may in some cases delete bookmarks whose name and/or location you would have preferred.  It is undo-able, so you can experiment.

**Tags of deleted bookmarks.**  If a deleted bookmarks has any tags, the app adds its tags to the tags of its surviving bookmark in the group, so that no tags are lost in this process.
		
**Which one will survive?**  For each group of less than 12 bookmarks, the app decides which one one has higher [item quality]().

For groups of 12 bookmarks or more, the app simply chooses one at random and deletes the remainder.  This is done to reduce the amount of time that it takes.

## Aggressively Normalize URLs [aggressivelyNormalizeUrls]

When the app enters a bookmark into a document, either because it was imported or because you typed it in, the app [normalizes its URL]().  One of the effects of this is that all bookmarks in a document which *must* refer to the same web page have the same URL.  When the app finds duplicates, therefore, because normalization has already been done, it simply looks for identical URLs.

Users often have some bookmarks which *may* technically refer to different web pages, but in fact refer to the same web page.  So the app will not recognize them as duplicates as the user would like.  The most notorious example is bookmarks whose *path* portion of its URL has one or more components, ending in a slash.  Here is an example, showing two URLs for a bookmark whose path portion has one component, "/bar"

* http://foo.com/bar
* http://foo.com/bar/

Technically, according to IETF standards, these two URLs may refer to different web pages.  Therefore, the app's normalization does *not* remove a trailing slash from the end of a URL's *path* if it has one or more components, and the app will not recognize these as duplicates.

If you *do* want the app to recognize these as duplicates, you can use the menu item Bookmarks > Aggressively Normalize URLs, which will strip any trailing slashes from the ends of the URLs of all bookmarks in the document whose path has one or more components.  Note that this does not widen the app's definition of a duplicate.  Instead, it is a one-time operation which checks all of the URLs in a document, and modifies some of them.

To aggressively delete duplicates, including such "near" duplicates in a document,

* Click in the menu: *Bookmark(shelf)* > *Aggressively Normalize URLs*
* Review the results.
* If you think this did more harm than good, click in the menu: *Edit* > *Undo* and instead remove undesired trailing slashes manually.
* Proceed to [Find Duplicates]().
* If desired, [Delete All Duplicates]().

Note that if a URL has *no* path components, the app *will* add a one-character path, "/"  Example:

* http://foo.com
* http://foo.com/

The above two URLs *are* technically the same, and the app *will* automatically add a slash to the end of the first one immediately upon it being imported or typed in to a document.

## Automatically Detect New Duplicates (BookMacster only) <img src="images/BookMacster.png" class="whapp" />

Because one person’s duplicate may be another person’s favorite bookmark, manually deduplicating, as described above, is recommended.

If you have BookMacster, however, and are using Syncers to sync or sort bookmarks, you can set it to check for duplicates whenever bookmarks are changed, as part of each syncing job.  The same rule [regarding Hard Folders](ignorDupsDiffHardFolds), and any [Duplicate Allowed attributes](duplicateAllowed) you have set on special bookmarks are respected.

To configure automatic duplicate detection,

* [Configure Syncers to sync some web browser(s)](useSync).

* In the Clients > Syncers tab of your document, click the Advanced subtab.

<div class="screenshot">
<img src="images/TabSyncersAdvanced.png" alt="" />
</div>

* In the Commands table, you should see three commands.  Hit the square “+” button, to create a new command.

* Change the new command to Find Duplicates.

* Drag it above Save Document, so that it is command number 3.

<div class="screenshot">
<img src="images/AdvancedFindDupesCommand.png" alt="" />
</div>


* As always, after you have configured syncing, quit BookMacster.  BookMacster Syncers work most quietly and efficiently when BookMacster is not running.

<br />RELATED TOPICS

* [Consolidate Folders](consolidateFolders)
