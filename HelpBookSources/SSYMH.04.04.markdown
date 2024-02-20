# Import, Export & Syncing <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [ixportDetails]

SSYMH-PAGE-TOC

## What is Import and Export?

The following picture shows what Import and Export do.

<div class="figure">
<img src="images/ixport.png" alt="" />
</div>

In words,

* **An Import copies changes from web browser(s) to the bookmarks manager.**

* **An Export copies changes from the bookmarks manager to the browser(s).**

You can command an immediate Import or Export [manually from the File menu](menuImExport).

During Import and Export operations, by default, our bookmarks managers make the bookmarks in the destination (where the arrow is pointing to) look like the bookmarks in the source (where the arrow is coming from).  In particular, items not in the source are deleted.

You can change this default behavior if you want to, either temporarily or permanently, by using [Advanced Client Settings]() and, for imports, [Import Postprocessing](advClientSettsImportPP).

## Import/Export *from all* vs. *to only* <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [menuImExport]

### *Import from all* and *Export to all* [menuImExportAll]

<img src="images/Synkmark.png" class="whapp" /> In Synkmark, the *all* referred to in these menu items are the [browsers]() which you have listed and activated in the *Syncing* tab of the *Preferences* window.

<img src="images/BookMacster.png" class="whapp" /> In BookMacster, the *all* referred to in these menu items are the [Clients]() which you have listed and activated in the tab *Settings* > *Clients* of the current Collection.  These Import and Export operations are the same which are typically performed by BookMacster [Syncers]() during syncing operations.

### Import from only* and *Export to only* [menuImExportOnly]

These menu items have submenus in which you choose the Client you'd like to import from or export to.  The submenus include all Clients available on your Mac, not only the ones you have configured *Settings* > *Clients*.  For that reason, you will also be asked if you wish to perform a *Normal* or *Overlay* operation.  A *normal* import or export wipes everything out in the destination and makes it look like the source.  An *overlay* does a more graceful merge.

## What is Syncing? <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

When you make *syncing* ready in Smarky or Synkmark, or switch on simple [Syncers]() in BookMacster, your bookmarks are kept in sync automatically after you quit Smarky, Synkmark or BookMacster.   This means that when you add, update or delete bookmarks in one browser, depending on your configuration, bookmarks may be sorted (alphabetized) in that browser and/or copied to other browsers after a few minutes.  This is done by importing (as described above), possibly sorting, and then exporting (as described above).  In other words, a **a Sync operation is composed of an <em>Import from all</em>, followed by an <em>Export to all</em>**.

If the Syncing button in your document’s toolbar has a yellow dot in it like this:

<div class="figure">
<img src="images/ButtonSync-On.png" alt="" />
</div>

It means that syncing is ready to go.  After you quit Smarky, Synkmark or BookMacster, [BkmxAgent]() will watch your web browsers bookmarks and, a few minutes after you make any changes (or changes are synced from other devices), process such changes per your configuration.

If you wanted to do a Sync manually, you should do the same three steps manually.

* Import, by clicking one of the *Import* commands in the *File* menu.

* If alphabetizing is desired, Sort.

* Export, by clicking one of the *Export* commands in the *File* menu.

## Mapping and Remapping <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [mapping]

In general, bookmarks are *mapped* into the same location in the destination as they were in the source; Bookmarks Bar to Bar, Menu to Menu, etc.  However, because [Clients](), and the [Bookmarkshelves](), have different [structures](), some of the [bookmarks content]() content copied during an Import or Export have nowhere to go.  For example, if bookmarks from a Firefox Client, containing items in its *Unsorted Bookmarks* [Hard Folder]() are migrated to a Safari Client, which does not have such an Unsorted Bookmarks folder, the subject items must be remapped into a different location.

Using Smarky, Synkmark, Markster or BookMacster, such a migration is performed by an Import + Export, with the app "in the middle".  Depending on the structure of the Import Client, Collection, and Export Client, *remapping* may be necessary during Import, Export or both.  You can configure some of the remapping rules with the settings described in the next section.

### Mapping and the *Default Parent* [mapDefPar]

During either an Import or Export, the process of "mapping" computes where a content item should be placed in the destination based on its location in the source.  As previously discussed, even with the best of intentions and configurations, an item may not be allowed where it would be directly mapped.  For example, loose bookmarks are not allowed into the *[root]()* of an export destined for Chrome, or Firefox.  

If directly mapping an item is not allowed, the app checks to see if it can be remapped to the *Default Parent* for the destination.

For importing into a Collection, you set a *Default Parent* in the [Import Postprocessing sheet]().

For exporting to Clients, you can change the a *Default Parent* in the [Advanced Client Settings]() for each Client.

If the item is not allowed in the Default Parent either,the app tries the other [Hard Folders]() until it finds one where the item is allowed and remaps it to there.  (The order in which Hard Folders are tried is a [hidden preference](hiddenPref), with key "anyStarkCatchypeOrder".  It should be an array of numbers, wherein the first tried is the first number in the array, and values are one of 1=*[root]()*, 2=Bar/Favorites, 4=Menu 8=Unfiled/Unsorted, 10=Shared.) 

### Mapping Illustration - *What Goes Where* [mapWhatGoesWhere]

Rather than trying to explain the mapping behavior to browsers in detail, some of which is hard to describe in words, we present here a screenshot of a document containing 5 representative bookmarks and 5 representative folders.  After that are screenshots of where these items would go after being exported to the popular browsers.  You can compare the mapping of these items to corresponsponding items in your own document to find out *where they will go* or *where they went*.

<div class="screenshot">
<img src="images/mapWhatWhere01.png" alt="" />
</div>

In the above screenshot, all four possible [hard folders]() (Bar, Menu, Reading/Other and Speed Dial) are being used.  The last two items (*Folder RO* and *Bookmark RO*) are in what we call the *[Root]()*.

The screenshots below show what happens after an initial export.  After importing and exporting again, a few of the items may move.  The exact result depends on which browser/client is listed first.  In the example above, if Safari is first, the *Bookmark RL* will be moved into the *[Root]()*, because Safari does not allow folders in its *Reading List*.

Some of the screenshots have been doctored to show what happens when different items are clicked.

#### Firefox

Because Firefox does not allow anything except its three hard folders in *[Root]()*, the items from Root went into *Other Bookmarks*.  Same result with items from *Speed Dial*, because, Firefox does not 
have a *Speed Dial*.

<div class="screenshot">
<img src="images/mapWhatWhereFirefox1.png" alt="" />
</div>

If you click in the menu: *Bookmarks* > *Show All Bookmarks*

<div class="screenshot">
<img src="images/mapWhatWhereFirefox2.png" alt="" />
</div>

#### Safari

The *Bookmarks Menu* is optional in Safari.  f you launch Safari on a new Macintosh user account, and do not export a *Bookmarks Menu* from Smarky, Synkmark, Markster or BookMacster, you will not have a *Bookmarks Menu* in Safari.  This is apparently Apple's preferred configuration for new users.  If you have a *Bookmarks Menu* and want to get rid of it, you can do this in BookMacster:

* Move all items out of the *Bookmarks Menu*.
* Click the tab *Settings* > *Structure*.
* Switch the checkbox *Bookmarks Menu* OFF.
* Click in the menu: *File* > *Export to Safari*.

If you don't have a *Bookmarks Menu* but want one, skip the first step and switch the checkbox ON instead of OFF.

The other notable features in Safari are:

* Because Safari does not allow folders in its *Reading List*, *Folder RL* went into the *[Root]()*.
* Because Safari does not have a *Speed Dial*, the *Speed Dial* (SD) items went into the *[Root]()*.

In the following screenshot, note that menu > Bookmarks shows the contents of the *Bookmarks Menu*, the *Favorites*, and the *[Root]()*, in that order.

<div class="screenshot">
<img src="images/mapWhatWhereSafari1.png" alt="" />
</div>

If you click in the menu: *Bookmarks* > *Edit Bookmarks*

<div class="screenshot">
<img src="images/mapWhatWhereSafari2.png" alt="" />
</div>

If you click in the menu: *Bookmarks* > *Show Bookmarks*

<div class="screenshot">
<img src="images/mapWhatWhereSafari3.png" alt="" />
</div>

If you click in the menu: *View* > *Show Reading List Sidebar*

<div class="screenshot">
<img src="images/mapWhatWhereSafari4.png" alt="" />
</div>

#### Chrome, Chromium or Canary

Because these browsers do not allow anything except its three hard folders in *[Root]()*, the items from Root went into *Other Bookmarks*.  Same result with items from *Speed Dial*, because these browsers do not 
have a *Speed Dial*.

<div class="screenshot">
<img src="images/mapWhatWhereChrome1.png" alt="" />
</div>

If you click in the menu: *Bookmarks* > *Edit Bookmarks*

<div class="screenshot">
<img src="images/mapWhatWhereChrome2.png" alt="" />
</div>

#### Vivaldi

A unique approach is taken by the designers of Vivaldi:

* There are no [hard folders]().  So everything is exported to *[Root]()*.
* There is no *Bookmarks" menu in the main menu, but…
* The toolbar shows *all* items, with the items that don't fit overflowing into a menu which is accessed by clicking a ">>" button at the end.  So it's a combination toolbar/menu, with the first items on the toolbar.

<div class="screenshot">
<img src="images/mapWhatWhereVivaldi1.png" alt="" />
</div>

#### Opera

Opera supports all four Hard Folders.

<div class="screenshot">
<img src="images/mapWhatWhereOpera1.png" alt="" />
</div>

If you click in the menu: *Bookmarks* > *Show All Bookmarks*

<div class="screenshot">
<img src="images/mapWhatWhereOpera2.png" alt="" />
</div>




## May Ignore Some Moves from Import Clients  <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

If you *move* an item from one folder to another in a Client's [built-in Bookmarks]() Manager,the app recognizes this move, imports it, and later exports it to other Clients, unless the move could be accounted for as the result of an automatic mapping during a prior export.  There are two such cases of these automatic mappings.  Both of them rare…

* The Client would not allow the item to be exported to its current location in the Collection, and the apparent moved-to folder is the default parent of the item.
* The Client in which the move is apparent has a Tag Mapping whose target folder is the apparent moved-to folder, and whose tag is one of the item's tags.

These exceptions are necessary so that automatic mappings which should only be applied to one Client do not get applied to all Clients when importing from that one Client only.

We recommend that, when it's time to do housecleaning on your bookmarks (moving, renaming, and deleting items, etc.) please open your Collection, do the work inthe app, and, when done, Export to all Clients.

## Delete Unmatched Items <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

As the result of an [Export]() operation, usually you want the browser or file to which you exported to contain only the items which were exported from Smarky, Synkmark, Markster, or BookMacster.  Checking on the *Delete Unmatched Items* option will do this by deleting any [destination]() items which were not be matched to [source]() items during the *merge* process described above.  You should check this box if you want the content of the Client to look as much as possible like the content of your [Collection](bkmxDoc)().  You can control *Delete Unmatched Items* in the [Advanced Client Settings]().

*Delete Unmatched Items* is also available during [Import Postprocessing](), and is used as part of making your Collection exactly match the content in its [Import Clients]().  Note that there is only one "Delete Unmatched Items" checkbox for a document, not one for each Client in the table.  This is because, in this case, there is only one destination (the Collection) from which items can be deleted, and also it cannot be determined whether or not a given item has been matched until after all Import Clients have been imported.

## Safe Sync Limit <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

A disadvantage of syncing data sets such as bookmarks is that an inadvertent change in one data set will be automatically copied to all the others.  For example, if some errant Firefox extension or miscommunication from the cloud deleted 100 bookmarks in Firefox, and Synkmark or BookMacster were syncing Firefox and Safari, it would  dutifully delete those 100 in its own Content and in Safari too.  To avoid making a bad situation worse like that, Smarky, Synkmark and BookMacster provide *Safe Sync Limit*:  If, during an Import or Export operation, the number of [additions]() + [updates]() + [deletions]() exceeds the applicable *Safe Sync Limit*, a warning or [Error 103011 or 103012](safeSyncLimitError) will be presented.  (Note that the number of [slides]() is ignored.  This is because, for example, adding a single bookmark at the top of a folder of 100 items will cause 100 items to *slide* down.  This results in a high number but is in fact a normal occurrence.)

*Safe Sync Limits* are set to 25 by default.  We do *not* recommend increasing the Safe Sync Limit so that you can do bookmarks housecleaning or reorganization in a web browser's [internal bookmarks]() editor without Error 103011 or 103012 occurring.  We recommend that you instead do your bookmarks housecleaning or reorganization in the *Content* tab of Smarky, Synkmark or BookMacster.  That way you can maintain Safe Sync Limit protection.

Nevertheless, to change your Safe Sync Limit…

* If you are using BookMacster, click in the menu: *Bookmarks* > *Safe Sync Limit*.  BookMacster provides separate limits for *Import* and for *Export* of each Client.  Click the appropriate submenu item, then follow the bouncing arrows which will guide you to the appropriate popup menu.
* If you are using Synkmark or Smarky, click the *Safe Sync Limit* popup in *Preferences* > *Syncing*.

## Sync Snapshots <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [syncSnapshots]

*Sync Snapshots* provides recovery in case something went wrong and you want to restore a web browser's bookmarks to their state before you exported from Smarky, Synkmark, Markster, or BookMacster.  Just prior to importing or exporting, our apps save a copy of the browser's bookmarks file – the file in which the browser stores its bookmarks.  To examine the contents and/or restore from these files,

* Run Smarky, Synkmark, Markster, or BookMacster.
* In BookMacster, you may wish to create a *File* > *New Collection* in which to import recovered items.  In the Client selection sheet, choose the browser whose bookmarks you're trying to restore, but this is only to get the correct [hard folders]().  In the next sheet, click *Create Empty Document*.  
* Click in the menu: *File* > *Import from only* > *Choose File (Advanced)*.
* In the next sheet, leave the bullet at the default *Do a Normal Import…*, then *OK*.  Note that means any items that you currently have in this `.bmco` document window will be overwrtten.  But, as explained below, you can get those back easily.
* In the *Choose File Format* sheet, choose the name of the browser whose bookmarks you wish to restore and then *OK*."
* When the file chooser sheet appears, hold down the *shift* and *command* keys and then type *G*.
* Into the *Go to folder* sheet which appears, copy and paste this: `~/Library/Application Support/BookMacster/SyncSnapshots`.
* Click "Go*.  (By the way, this little-known trick works in most Mac apps.)
* You will now see a navigator sheet containing one ore more subfolders.  Ignoring the "|" characters, click the disclosure triangle to expand the subfolder whose name includes the browser and profile name of the bookmarks you are looking for.
* Select the file you want.  The filename tells you when and for what reason this file was copied from the browser.  For example `20150403-212510PreEx.Bookmarks` means that this snapshot was taken in 2015 on April (04) third (03), at 21:51:10.  A 24-hour clock is used to save space.  21:51 is 9:51 PM.  The `PreEx` means that this snapshot was taken prior to a export operation; `PreIm` is, of course, prior to an import.
* Click *Choose*.  The bookmarks from that file will be imported.
* Examine the Content.  If this is not what you wanted, click in the menu: *Edit* > *Undo Import*, then start over from *File* > *Import from only* and choose a different file this time.

Note that the files in the `Sync Snapshots` folder are exact copies of the native files written by the web browser.  So, as an alternative but more clumsy means to look at them, you may replace the browser's bookmarks file behind its back…

* Switch off Syncing in Smarky, Synkmark or BookMacster.
* Ensure that any relevant [browser syncing service](browserSync) is not syncing your bookmarks. 
* Quit the browser.
* Run Finder.
* Click in the menu: *Go* > *Go to folder…*.
* Into the *Go to folder* sheet which appears, copy and paste this: `~/Library/Application Support/BookMacster/SyncSnapshots`.
* Click "Go*.
* Find the desired file and, using another window, copy it to the browser's `Application Support` folder, or profile folder as applicable.  It's different for each browser.  If not obvious to you, search on the internet for the answer or ask us.
* Rename the copied file to replace the browser's actual bookmarks folder.
* Relaunch the browser.
* Open the browser's *Edit Bookmarks* or *Manage Bookmarks* window and see what you got.

Of course, to limit disk space usage, we keep only a limited number of Sync Snapshots, by discarding older snapshots.  You can set the limit Preferences > Syncing.  The default limit is 60 MB.   If disk space is important to you, and if you have plenty of other backups and are confident you can successfully use them if necessary, setting this limit to zero (0 MB) is reasonable.

## Merge by URL <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [mergeByUrl]

During an Import or Export, the app will compare bookmarks content items between the Collection and the Client, looking for items that were previously imported or exported.  It can do this because it remembers the items' [identifiers](exid).  When a match is found, Smarky, Synkmark, Markster, or BookMacster or  will *merge* the items by keeping either the item from the [Client](), or the item from the [Collection](bkmxDoc)().  

If no previously-imported or exported item is found for a given bookmark, there is another chance for a match if the *Merge by URL* box is checked.  In this case, a second search is done, for a bookmark with the same URL.  (Note that the app [normalizes URLs]().)  If found, the items are similarly merged, keeping the item from either the Client or Collection, as indicated by your setting of the *Keep matched item from* control in the [Advanced Client Settings]().  If more than one such bookmark is found, the [source]() and candidate [destination]() bookmarks' parents are compared, and if that still does not result in a unique match, the bookmarks' names are compared, and if that still does not result in a unique match, one is chosen arbitrarily.

For Exporting to a Client which does not accept duplicate items, Merge By URL is forced on and the control is disabled.

## Mapping Between Folders and Tags <img src="images/BookMacster.png" class="whapp" /> [fabMapFoldersTags]

When performing an Import or Export operation, BookMacster provides features that allow you to translate between [Clients]() that support [folders]() instead of [tags](), and Clients that support tags instead of folders.

For a one-time conversion of all of your bookmarks, consider *Fabricate Folders* or *Fabricate Tags*, which will map *all* of the bookmarks in the document.  For browsers that support hierarchy but not tags, during an Import you may *Fabricate Tags*, and during an Export you may *Fabricate Folders*.  For browsers that support tags but not hierarchy, it's just the opposite -- during an Import you may *Fabricate Folders*, and during an Export you may *Fabricate Tags*.

For a permanent configuration which will map certain special folders to certain special tags or vice versa, use *Tag ↔ Folder Mappings*

### Fabricate Tags [fabTags]

If the **Fabricate Tags** box in the [Advanced Settings for a Client](advClientSettsPerClient) is switched ON, the names of a bookmark's parent, grandparent, etc. folders which are not presently among the bookmark's tags will be added to bookmark's tags.  Only names of [soft folders]() are added, of course.  Names of [hard folders]() such as Bookmarks Bar or Bookmarks Menu are not informational and therefore are not added as tags.  This is useful if your goal is to use tags instead of folders.

### Fabricate Folders [fabFolders]

*Fabricate Folders* is useful if your goal is to use folders instead of tags.  If the **Fabricate Folders** box in the [Advanced Settings for a Client](advClientSettsPerClient) is switched ON, any item which has a tag will be placed into a subfolder which has the same name as its first tag, creating the folder if necessary.  If in addition the *One for each tag* setting is checked ON, for items with more than one tag, the same will be done for each additional tag, placing copies of the bookmark into subfolders for each tag, creating additional subfolders if necessary.  Note that this can fabricate many duplicate bookmarks.

The number of folders created, however is reduced by the fact that, during Fabricate Folders, only one folder is created to contain multiple bookmarks which require it.

The *Fabricate Folders* option will not fabricate a folder that would not be allowed at the required location.  Currently, there is in practice only one example of this:  If *Fabricate Folders* is checked *on*, and bookmark(s) in *[Root]()* have tags, but the [structure]() of the [destination]() (either external store or document) does not allow soft folders in *[Root]()*, then folders are not created for the tags of these bookmarks.

### Tag ↔ Folder Mappings [tagFolderMaps]

This feature is used if, for example, you collect bookmarks in a [web-based browser app]() such as Pinboard, tag them with a tag such as *to-read*, and want them automatically moved into a certain folder such as your *Reading List* when you sync this service with Safari, or vice versa.  It can also be used to create fake versions of [hard folders]() which exist in one browser but not others.  For example, you can create a fake *Reading List* in Chrome or Firefox. 

To configure Tag ↔ Folder Mappings,

* Open a [Collection](bkmxDoc) which has been [configured for syncing]().
* Show the [Advanced Client Settings sheet for a Client](advClientSettsPerClient).
* At the bottom of the sheet, click the *Tag ↔ Folder Mappings* button.  Another, deeper sheet will appear.  (If a client supports neither tags nor folders, this button is not available.)
* Click the [+] button below one of the two tables, to add the behavior you want in this Client.
* Enter your choices in each of the three columns.
* Click *Done* twice.
* Repeat for the other Client.

Note that there are four possible types of Tag ↔ Folder Mappings.  In the upper table, you configure *Folder to Tag* Mappings, specifying whether to do this during *[Import]()* or *[Export]()* operations.  In the lower table you similarly configure *Tag to Folder* Mappings.  For most Clients, only two types are available; only the *[Import]()* or only the *[Export]()* item are available in the *Do during* popup.  This is because most Clients which support tags do not support folders, and vice versa.  The exception is Firefox, which supports both tags and folders.

#### Example: Creating a *Reading List* in Chrome [chromeReadList]

You can string together a *Folder to Tag* mapping together with a *Tag to Folder* mapping, in order to map items from a particular folder in, say, Google Chrome, into your Reading List in Safari.  The trick is to tag all items from that particular folder during import, and then export all items with that tag to *Reading List* in Safari.  After syncing, any item which you place in that particular folder while browsing in Chrome will appear, for example, in Safari's *Reading List*.  To configure this,

* Activate BookMacster and open your Collection.
* Decide on an existing folder, or create a new folder into which you shall put your *Reading List* items while you are browsing in Chrome.  Let's assume that you name this folder *My Soft Reading List*.
* Click the tab Settings > Clients.
* Click the Advanced Settings (gear) button for Chrome.  A sheet will appear.
* In the sheet which appears, click the button > Tag ↔ Folder Mappings.  Another sheet will appear.
* In this 'nother sheet, in the upper table, create an Import mapping from your *My Soft Reading List* folder to a special tag, such as, for example, *to-read*.
* Click *Done* twice.
* Click the Advanced Settings (gear) button for Safari.  A sheet will appear.
* In the sheet which appears, click the button > Tag ↔ Folder Mappings.  Another sheet will appear.
* In the lower table this time, create an Export mapping from your designated tag, *to-read* or whatever, to the *Reading List* or *Reading/Unsorted* hard folder.  This is because BookMacster exports this hard folder to the *Reading List* in Safari and to *Unsorted Bookmarks* in Firefox.
* Click *Done* twice.

This will work.  However, when exporting to Safari, all items will be moved out of your *My Soft Reading List* folder, leaving it empty, which will cause confusion.  You can prevent this empty folder confusion by adding an *[Export Exclusion]()* so that this folder is not exported to Safari.  To do that, while still in your Collection,

* Click to the [Content View]().
* Select your *My Soft Reading List* folder. 
* If the Inspector is not showing, click in the menu: *Window* > *Show Inspector*.
* Verify that the Inspector subject is your *My Soft Reading List* folder. 
* Click the *Export Exclusions* button at the bottom of the window.
* In the sidebar which appears, switch off the checkbox for *Safari*.
* Click in the menu: FIle > Export to all…
* Verify that your *My Soft Reading List* appears in Chrome but not in Safari.

Finally, you are ready to test.  In Chrome, add a bookmark to *My Soft Reading List*.  Then in BookMacster, click in the menu: File > Import from only 

## Share New Items <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [shareNewItems]

Bookmarks stored in Clients which are bookmarking web apps such as Pinboard may have an attribute called *Shared*, or, conversely, "Private".  Bookmarks which are exported as *Shared* become viewable by other people who visit your bookmarks page.

BookMacster supports a 'Shared" attribute to its bookmarks, and this attribute is exported to such a Client.  So the question arises:  When items are imported from a Client such as Safari which does not support the *Shared* attribute, should the *Shared* attribute be turned on or off.

You provide the answer by switching the *Share new items* checkbox in the [Advanced Client Settings]().

## No Export if No Changes <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

To execute an Export, the app first reads in all of the current [bookmarks content]() from the Export [Client]() and compares it to the bookmarks content from the [Collection](bkmxDoc)() which is proposed to be exported.  It determines the number of each [type of change]() which needs to be made.  If there are no additions, deletions, moves, or slides, and if none of the items have any updates to a [nontrivial attribute](), the operation is terminated without writing the file or uploading anything.

## Import and Export of Tags <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [imexTags]

During an Import, tags are given a special, conservative treatment.  When a bookmark existing in the Collection is matched and merged with one from a Client, any new tags on the bookmark in the Client are added to the bookmark in the Collection, and none are deleted.

During an Export, tags are treated like any other attribute.  When a bookmark existing in the Client is matched and merged with one from the Collection, the tags on the bookmark in the Client are completely replaced by the tags on the bookmark in the Collection.  Any tags on the Client bookmark not on the Collection bookmark are deleted.

Conclusion: If you are using the app to sync browser Clients and want to delete tags, you must delete them in the (in the [Content](theContentTab) tab of a Collection).

## Exclude Export of Special Bookmarks <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [excludeExportSpecial]

In the [Advanced Client Settings]() for each Client, in the *Export* section, there are checkboxes in which you can selectively exclude exporting bookmarks to local files, JavaScript bookmarklets, RSS feeds and Firefox *Live* bookmarks.

## Import and Export of Separator Changes  <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

When we speak of *changes to [separators]()*, we mean adding new separators, moving separators, and/or deleting separators.  The behaviors described in this section are the same, with the additional requirement that, in order to delete separators, the relevant *Delete Unmatched Items* checkbox must be switched ON, and this must be a regular export and not an *[Overlay](ixportOverlay)*.

Separators are a structural element which you have usually set to your liking in *one* Client or another.  Therefore, when importing and exporting with multiple Clients,  Smarky, Synkmark, Markster, or BookMacster filter changes to separators according to special rules which prevent undesired duplications.  The underlying idea is that you want separators from [source]() or [destination](), but not both.  Which one you want is determined by the setting of the relevant *[Merging Keep]()* option, and there is also an option to not export any separators at all.  (This may be desirable if you are exporting to Safari and Safari bookmarks will be subsequently synced to the iPhone via iCloud.  Separators may be unwanted in the iPhone due to the small screen size.)

### Warning: Weeds Ahead!

The behavior you get with the default settings is probably "what you want" and should "just work".  The details in this section are way down in the weeds and are published for our testers.

### Importing Separators

To be precise, we need to define three classes of separators, imagining that separators are imported from Clients on the **Left**, to a Collection on the **Right**.

**Left**.  A separator in a Client which does not exist in the Collection (either because it was never im/exported or was im/exported and subsequently deleted) is called a **Left** separator.  In BookMacster, Left separators are imported to the Collection if *Keep matched item from* is set to *Client*, but not imported if *Keep matched item from* is set to *Collection*.  In Smarky and Synkmark, Left separators are imported.

**Matched**.  A separator in the Collection which also exists in all Clients (due to prior im/export) is called a **matched** separator.  A matched separator will always remain standing.  (Actually, in BookMacster, the one in the Collection is either overwritten by a mate imported from a Client, or is untouched, depending on whether *Keep matched item from* is set to Client or BkmxDoc.  But since separators have no visible attributes, you can't tell the difference).  

**Right**.  A separator in the Collection which is not matched by one in all of the Clients (either because it was never im/exported or was im/exported and subsequently deleted from a Client) is called a **Right** separator.  In  BookMacster, If the *Keep matched item from* option is set to *Client*, or if [Import Postprocessing]() [Delete Unmatched Items]() checkbox is switched ON, Right separators are deleted.  Otherwise, Right separators are untouched.  In Smarky and Synkmark, Right separators are deleted.

**Table**.  The above rules are summarized in the following table.  The settings in the **first row are the default settings**, which are what you should have if you have never changed any of the Advanced Settings (by clicking one of the "gear" buttons).  The **first row also applies to Smarky and Synkmark**, which do not have these settings.

<br />
<table border="1" cellspacing="0" cellpadding="5" align="center">
	<tr>
		<th colspan="2" align="center" valign="bottom"><b>Clients > Settings</b> (BookMacster only)</th>
		<th colspan="3" align="center" valign="bottom"><b>Behavior of Separators during Import</b></th>
	</tr>
	<tr>
		<th align="center" valign="bottom"><b>'Delete Unmatched Items' in Import Postprocessing (Advanced) Settings</b></th>
		<th align="center" valign="bottom"><b>'Merging Keep' in Client's Advanced Settings : Import</b></th>
		<th align="center" valign="bottom"><b>Left Separators</b></th>
		<th align="center" valign="bottom"><b>Matched Separators</b></th>
		<th align="center" valign="bottom"><b>Right Separators</b></th>
	</tr>
	<tr>
		<td align="center">ON</td>
		<td align="center">Client</td>
		<td align="center">Imported</td>
		<td align="center">Imported (*)</td>
		<td align="center">Deleted</td>
	</tr>
	<tr>
		<td align="center">OFF</td>
		<td align="center">Client</td>
		<td align="center">Imported</td>
		<td align="center">Imported (*)</td>
		<td align="center">Deleted</td>
	</tr>
	<tr>
		<td align="center">ON</td>
		<td align="center">Collection</td>
		<td align="center">Not imported</td>
		<td align="center">Untouched</td>
		<td align="center">Untouched</td>
	</tr>
	<tr>
		<td align="center">OFF</td>
		<td align="center">Collection</td>
		<td align="center">Not imported</td>
		<td align="center">Untouched</td>
		<td align="center">Untouched</td>
	</tr>
</table>
<br />

(*) Since separators do not have any attributes, the effect of "Imported" in this case is the same as that of "Untouched" -- the separator appears to survive unchanged.



### Exporting Separators

For exporting, we redefine the three classes of separators, because Collection and Client are now swapped in our imagined "Left to Right" movement.

**Left**.  A separator in the Collection which does not exist in the Client (either because it was never im/exported or was im/exported and subsequently deleted) is called a **Left** separator.  Action may be affected by the setting of the *Export Separators* checkbox:

A Left separator is exported only if <b>both</b> this box is checked <b>and</b> and the *Keep matched item from* is set to Collection.  Left separators are always exported in Smarky and Synkmark.

**Matched**.  A separator in the Client which also exists in the Collection (due to a prior im/export) is called a **matched** separator.  A matched separator will always remain standing.  (Actually, in BookMacster, the one in the Client is either overwritten by its mate exported from the Collection, or is untouched, depending on whether *Keep matched item from* is set to Collection or Client.  But since separators have no visible attributes, you can't tell the difference).  

**Right**.  A separator in the Client which is not matched by one in the Collection (either because it was never im/exported or was im/exported and subsequently deleted) is called a **Right** separator.  In BookMacster, Right separators are deleted if *Keep matched item from* is set to Collection, but untouched if set to Client.  In Smarky and Synkmark, Right separators are always deleted.

**Table**.  The above rules are summarized in the following table.  The settings in the **first row are the default settings**, which are what you should have if you have never changed any of the Advanced Settings (by clicking one of the "gear" buttons).  The **first row also applies to Smarky and Synkmark**, which do not have these settings.

<br />
<table border="1" cellspacing="0" cellpadding="5" align="center">
	<tr>
		<th colspan="2" align="center" valign="bottom"><b>Client's Advanced Settings : Export</b> (BookMacster only)</th>
		<th colspan="3" align="center" valign="bottom"><b>Behavior of Separators during Export</b></th>
	</tr>
	<tr>
		<th align="center" valign="bottom"><b>Merging <br /> Keep Item From</b></th>
		<th align="center" valign="bottom"><b>Export Separators</b></th>
		<th align="center" valign="bottom"><b>Left Separators</b></th>
		<th align="center" valign="bottom"><b>Matched Separators</b></th>
		<th align="center" valign="bottom"><b>Right Separators</b></th>
	</tr>
	<tr>
		<td align="center">Collection</td>
		<td align="center"></td>
		<td align="center">Exported</td>
		<td align="center">Exported (*)</td>
		<td align="center">Deleted</td>
	</tr>
	<tr>
		<td align="center">Collection</td>
		<td align="center"></td>
		<td align="center">Not exported</td>
		<td align="center">Untouched</td>
		<td align="center">Untouched</td>
	</tr>
	<tr>
		<td align="center">Client</td>
		<td align="center">ON</td>
		<td align="center">Not exported</td>
		<td align="center">Untouched</td>
		<td align="center">Untouched</td>
	</tr>
	<tr>
		<td align="center">Client</td>
		<td align="center">OFF</td>
		<td align="center">Not exported</td>
		<td align="center">Untouched</td>
		<td align="center">Untouched</td>
	</tr>
</table>
<br />

(*) Since separators do not have any attributes, the effect of "Exported" in this case is the same as that of "Untouched" -- the separator appears to survive unchanged.

Note that the Separators' Behavior does not depend on the Export Client's [Delete Unmatched Items]() setting.  (First of all, only the first two of the above four combinations are possible, since if the Export Client's Delete Unmatched Items is ON (☑), *Keep matched item from* must be set to BkmxDoc.  Of these two cases that remain, the separators which would be affected by the Export Client's Delete Unmatched Items, the Right separators, are deleted due to the action of the *Keep matched item from* = BkmxDoc.  So, the Export Client's Delete Unmatched Items does not matter.)

## Merge Folders <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [imexMergeFolders]

You might create a folder with a certain name, say, *News*, in, say, the Safari Bookmarks Bar, and then also create a folder with the same name, *News* in Firefox in the same corresponding location.  Then you might import from Safari and Firefox, expecting that the items in your two *News* folders would be merged into one *News* folder.  Smarky, Synkmark, Markster, and BookMacster do indeed do this.

### What, When and Where

To make this happen, very near the end of an [Import or Export]() operation, the app merges pairs of folders within the same parent, which have the same name, if they come from different sources (either different Clients or Client vs. Collection).  Because it does so starting from the *[Root]()*, all such pairs folders will be detected, provided that they have the same [lineage]().  When a pair of folders with the same lineage and name is so discovered, one folder will be kept and the other folder will have its items moved into the first folder and itself be deleted.  Also, any [identifiers](exid) in the deleted folder not already existing in the kept folder are appended to kept folder.

A more aggressive merging of folders may be performed by executing a [Consolidate Folders]([consolidateFolders]) command.

### Which one is Kept?

If during an [Import]() operation, the two folders are from different [Clients](), the one from the higher-priority Client (higher in the list in Settings > Clients) is kept.

Otherwise, if both folders are new (not previously in the destination), the one with the earlier Date Added is kept.  This is important for the following reason.  If you are merging from two or more [import clients]() which have similar but not identical hierarchies, for folders which exist in multiple Clients but not in the Collection, if these clients do not themselves provide an Date Added, Date Added is assigned as the time of their import.  Therefore, the folder from the client which is first in the Import Clients table will have an older Date Added, typically by a few seconds, and therefore will be the one that is kept.

If both folders were in the Destination before the Import or Export, then the one which has higher [item quality]() is kept.

If one folder is from the source and the other is from the destination, which one is kept depends on the *[Merging Keep]()* setting: If *Merging Keep* is set to *[Client]()*, the folder from the Client is kept.  If set to *[Collection](bkmxDoc)()*, ... Collection.  (As stated above, if set to *Both*, the Merge Folders operation is not even performed.)


### Why does it Matter which is Kept?

In most cases, it does not.  A folder with the same [lineage]() and the same name is pretty much the same folder.  The only differences might be a couple of attributes which are only used by Smarky, Synkmark, Markster, or BookMacster, such as *sorted or not*, *sort at top/bottom*, and the *Auto-Click* attribute which supported by a couple of browser apps.

## Content Not Exported <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

Before writing or uploading items, Smarky, Synkmark, Markster, and BookMacster remove items which are not allowed or not desirable in the given the Export Client, or won't work in any Client.  Most of these are fairly obvious, but here are a few examples…

* Bookmarks whose URLs have no characters, or illegal characters in their host portions, for example *http:///*, are not exported to any Client.
* Bookmarks whose URLs contain a percent-escaped NULL, "%00", in their path portions will not be exported to any Client because this causes weird behavior in Chrome, Firefox, and possibly other apps.
* Pinboard does not allow folders or separators, only bookmarks.
* Because they are typically huge, useless to Clients except Safari, and can cause errors in some Clients, the *[Safari Logins Bookmarklet](http://help.agile.ws/1Password3/logins_bookmarklet.html)* created by 1Password version 3.x, and the old 1Password bookmarklet created by 1Password version 2.x, are exported only to Safari Clients.
* Safari does not allow separators "out of the box".  But instead of not exporting them, Smarky, Synkmark, Markster, and BookMacster [convert separators when exporting to Safari]() to its own fake separators.

## Clients' Hidden Proprietary Attributes <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

Some web browsers have esoteric, proprietary attributes on their bookmarks which are of no interest to Smarky, Synkmark, Markster, BookMacster, you, or other browsers.  For example, Opera sports an "ACTIVE" attribute to indicate that an item is selected in Opera's *Manage Bookmarks* window, so that if you quit Opera and relaunch, that same item will be selected.   OmniWeb also adds several of its own attributes that hardly anyone even knows exist.

The app ignores such hidden proprietary attributes during an Import operation, and will therefore *not* pass them to another Client of the same type (another Opera, for example) if your Collection is synced to another Mac as part of your [multi-device syncing strategy](syncMultiDesign).

During an Export operation, the app preserves these attributes in the local Client.

## Normalization of URLs <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

Some local Clients, notably Chrome and Firefox, and in particular the web app Clients (Pinboard)  apply minor corrections or what we call *[normalization]()* to the URLs of your bookmarks.  For example, launch Firefox *Show All Bookmarks*, create a new bookmark and type in the URL "http://apple.com".  Notice that when you hit 'return', Firefox automatically adds a slash character to the end of the bookmark (signifying an empty "path" portion).

Actually this change can occur in one or more of three places:

* What URL you see in the *Show [All] Bookmarks*, web page, or similar user interface

* What URL they visit when you click the bookmark.

* What URL gets returned to BookMacster when it downloads your bookmarks as part of an *Import* operation.

The last item is the one relevant to Smarky, Synkmark, Markster, and BookMacster.  This is because these apps merge incoming and existing bookmarks during an [*Import* or *Export*]() operation.  For example, let's say you that your perform an *Export* in BookMacster to Pinboard, which uploads a bookmark whose URL is *http://UpPpeR.cOM*.  If you later perform an *Import* from this Pinboard account, BookMacster will receive a URL which has been normalized to contain only lower-case characters in the *host* portion, *http://upper.com*.

To minimize confusion and [churning]() of bookmarks, the apps also normalize any bookmark that you enter into it.  There are a couple dozen rules in our algorithm, and our *My Eyes Glaze Over* Department did not allow us to enter them here.  Generally, the app mimics the behavior of Firefox and Chrome, which we have found to be reasonable except for a couple cases.  Therefore, since the exported URL is already normalized, the Client will not make any further changes, and [churn]() rarely occurs.  One of these rare instances was when the path of a URL ends in 'index.html' and it is exported to Google Bookmarks.  Google Bookmarks incorrectly, we believe, omits the 'index.html', and therefore when you re-import such a bookmark into BookMacster for the first time, an "update" of its URL will be tallied.

## Undo and Redo <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

In Smarky, Synkmark, Markster, and BookMacster, as in most applications, Undo and Redo recall the *state* of the document (the [Collection](bkmxDoc)()) before or after an action was performed and simply replace the current state with the the prior state.  That is, they reverse *the effect of the action on the document*  but do not, as their title implies, actually undo or redo the action.

This subtle difference is apparent with  *Import* command.  After you *Import*, the *Edit* menu's *Undo* item will be titled "Undo Import".  If you click this, your Collection's content will be set back to the way it was before you imported from the browser/file(s).

Then, the *Undo* item will titled "Redo Import".  Now if you click this, your Collection's [content](theContentTab) will be set back to the way it was after you imported from the Import Client(s), reflecting the content in the Client(s) at the time the original import was done.  Thus, Redo recalls the content in the Clients at the the time the original import was done.  Redo does not import their *current* contents, which may be different if data was changed within the Client, for example by adding a bookmark, in the meantime.

This concept is even more apparent when performing an *Export*.  The app's Undo domain does not extend into other apps.  And there is no Undo action available after an export; the [Unsaved Changes Dot]() is not affected.  (Actually, the app does record the time of the export for considering whether future exports need to be done, but this change is recorded in [Local Settings]() and therefore does not change the Collection.  If it did, this would cause [Online File Syncing Services]() to upload this local "change" to their server after saving, which would be incorrect.)

There are two ways to restore pre-export content in the Client itself.  The first way is to restore the content of a Collection to the way it was before the export in the client, and then export again.  The second way, available to advanced users and not applicable to web app Clients, is to quit the Client application, then restore the relevant file(s) from a [Time Machine](https://support.apple.com/en-us/HT201250) or other backup.

## Reading Your Sync History <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [reportSyncLog]

### Reading the Status Bar after an Import or Export

<div class="screenshot">
<img src="images/StatusBar.png" alt="" />
</div>

After an [Import]() or [Export]() operation, the numbers *+*, *Δ*, *↖* *↕* and *-* respectively indicate the number of *[additions]()*, *[updates]()*, *[moves]()*, *[slides]()* and *[deletions]()* as a result of the operation.  An indication *Same-Skip* indicates that operation was skipped because the app pre-determined there to be no differences between the content in the source and that of the destination.  Recent operations are listed in order.  The *Save* at the end indicates that the .bmco document data was saved after the Export to Safari. 

### Sync Logs

For more detailed and longer-term history, the *Reports* > *Sync Log* tab shows the *changes* to your [Content](theContentTab) which occurred during recent Import/Export operations.

#### Changes [imexChanges]

There are five types of *Changes*:

* **Additions** (symbolized: +) are new items which previously did not exist in the [destination]().

* **Updates** (symbolized: Δ, ✛, or ✣) are changes to one or more of the [nontrivial attributes](), except for position (which is a *slide*), of existing items in the destination.  Updates are indicated by the Greek letter *delta*, the triangle, Δ.  An item which is *both* a *Slide* and a *Update* is counted only as an *Update*.  It appears in the Sync Log with symbol ✛.    An item which is *both* a *Move* and a *Update* is also counted only as an *Update*.  It appears in the Sync Log with symbol ✣.

* **Moves** (symbolized: ↖) are moves of items to a different parent.

* **Slides** (symbolized: ↕) are moves of items within the same folder (parent).  If an item is added at the top of a folder containing 45 items, the 45 items below it will undergo a *slide*, and therefore 45 slides will be counted.  *[Sorting]()* bookmarks produces only *slides*.

* **Deletions** (symbolized: -) are items deleted from the destination.

Here's an example.  Say that you have just imported from Safari.  Next, you switch to Safari and add a bookmark, placing it  above 12 existing bookmarks in a given parent folder.  Now, switch back to the app and import again.  The Status Bar will indicate "Safari (+1, Δ1, ↖0, ↕12, -0)".  The +1 is, of course, the new bookmark.  The Δ1 indicates the new item's parent folder, because it gained a *child*.  The ↕12 indicates the 12 items changed which were slid (had their *position* incremented by one) in order to make room for the new bookmark.

In some oddball cases, it might take more than one of Import and Export before the number of changes stabilizes to +0 Δ0 ↖0 ↕0 -0.  Here's an example to illustrate the point.  Say that a Collection's Client settings list Firefox and Safari with both Import and Export active.  A bookmark is added at the *[Root]()* level in Safari.  Say that in the Collection's [Structure](), bookmarks are allowed at Root.  During the next Import, this is imported to the Collection at the root level.  During the next Export, it is exported to Chrome, but since Chrome does not allow bookmarks at Root, it goes to the [Default Parent]() for Chrome, which is, say, the Bookmarks Menu.  (This is the default setting.)  So it is exported to the Bookmarks Menu in Chrome.  Say that in the Collection's Clients, Chrome Advanced settings are set to Keep items from Chrome instead of the Collection.  (This is also a default setting.)  Also say that Chrome precedes Safari.  Thus, during the next Import, this bookmark will be moved into the Bookmarks Menu.  Then, during the next Export, it will also be moved to the Bookmarks Menu in Safari, and, finally, during the next Import there will be no more changes.  Summarizing, we had two Imports and two Exports before we finally saw no changes in the next Import.

## How Our Apps Access Browser (Client) Content <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [howAccessClientCont]

In order to execute an Import or Export command, Smarky, Synkmark, Markster and BookMacster must somehow access the [bookmarks content]() of the Client that you chose in the popup menu in *Settings* > *Clients*.

This section explains how that is done, for each of the different types of Clients.


### Accessing Locally-Installed Browser Apps' Bookmarks

#### Bookmarks in your [Macintosh User Account]() [accessLocApp]

The apps has two methods for importing from and exporting to [Locally-installed browser apps]() (Safari, Firefox, etc.).  The app automatically chooses the appropriate method based on current conditions.

The **quick direct sync** is to import from and/or export to the browser's bookmarks file or files on the disk.  This is the only method available with some browsers, particularly Safari.  Safari allows us to do this while Safari is running, provided that we are careful with iCloud.  Our apps are not able to do a quick direct sync with the Opera web browser (because, starting in Opera 48, Opera apparently adds a secret salt to their file's checsum), nor te Orion web browser because Orion uses a proprietary file format which we have chosen to not reverse-engineer.  For other browsers, our app must quit the browser before importing and/or exporting with quick direct sync.  If a browser is running and needs to be quit, our app will present a dialog asking you if it is OK to quit the app, and then to re-launch it when done.

The other method is the **coordinated sync**.  This method is only available in Firefox, Google Chrome, Vivaldi, Brave, Edge, Chrome Canary and [FreeSMUG's Chromium](http://www.freesmug.org/chromium), and it is the only method available for Opera.  It communicates the import or export through a [browser extension](), and hence works while a browser app *is running*.  Our app will request that you install the browser extension into your browser profile when you add the browser as a Client, or the first time you perform either import or export with Opera, because this is the only available sync method for Opera.

#### Launch Browser to Coordinate with Other Sync Services [launchBrowserPref]

In [multi-device sync configurations](syncMultiDesign), our app's imports and exports must be coordinated with [the browser(s)' services](browserSync), and in general this means that the *coordinated sync* described above must be used, and therefore the browser must be *launched* if it is not running.

A simple example explains why.  Say that our app is syncing Safari and Firefox, and you also have Firefox on your iPhone synced to Firefox on your Mac via *Chrome Sync*.  When you add a new bookmark in Safari, our app could export that to Chrome using the *quick direct sync* if Firefox was not running, but only Firefox can push that new bookmark to Firefox on your iPhone, which won't happen if Firefox is not running.  The same thing happens in the reverse direction; a bookmark added to Firefox on your iPhone can not show up in our app or Safari without Chrome's help.

Therefore, before an Import or Export, if any of these browsers are involved and are not running, our app looks to see if *Firefox Sync* or whatever are active in the profiles involved, and if so, by default it *automatically launches* the browser.

To prevent the browser launching for a one-time export, click in the menu *File* > *Export to only* >.  The sheet which will appear has a *Do NOT launch* checkbox.  However, starting in 2019, we found that, if we use the *quick direct sync*, many [Chrome-ish browsers](chromish), Google Chrome and Microsoft Edge in particular, will revert your bookmarks to the previous bookmarks a few minutes after the app is launched.  Therefore, the *Do not launch* checkbox is not available for Chrome-ish browsers.

If you have our advanced app, BookMacster, you can control this behavior permanently by clicking the tab *Settings* > *Clients*, and then clicking the *Advanced Client Settings* (gear) button for the subject Chrome or Firefox profile.  As explained above, the *Never* option is not available for Chrome-ish browsers.

<div class="screenshot">
<img src="images/ClientAdvancedGear.png" alt="" />
</div>

In the *Special Settings* section you will see a popup menu to set *launch browser during Syncs*.

<div class="screenshot">
<img src="images/LaunchBrowserPref.png" alt="" />
</div>


If you do not want to leave Firefox running in the background, and you find it annoying when our app launches them automatically, and you don't mind bookmarks syncing being delayed, or occasional omitted bookmarks due to conflicts, you may change this setting to *Never*.  The setting *Never* is not available in any of the [Chrome-ish](chromish) browsers because, starting in 2019, *Chrome Sync* and *Vivaldi Sync* will not work correctly if bookmarks are changed while they are not running.

The opposite situation arises if you using another external syncing service instead of the built-in *Chrome Sync* or *Firefox Sync*.  In this case, such a service may have its own extension installed into, say, Chrome or Firefox, and again, our app *should* launch Chrome or Firefox prior to an import or export in order to coordinate syncing with it.  But our app is not aware of external syncing services.  To fix this, you can make sure that syncing is always properly coordinated by setting the popup to *Always*.

**But you can make all of the above moot.**  There are two other solutions to eliminate the annoyance of browsers launching and quitting while maintaining reliable bookmarks sync.

**Solution 1.**  If you are not using the browser on other devices, and do not need *Chrome Sync* or *Firefox Sync*, **turn them off**.  That is, for the [Chrome-ish](chromish) browsers, *Sign out* of your Google account, or at least switch off the *Bookmarks* option under *Advanced Sync Settings*.  For Firefox, in *Preferences* > *Sync*, either *Unlink this Device* or at least switch off the *Bookmarks* checkbox.

**Solution 2.**  *add the synced browser to your [Login Items](http://reviews.cnet.com/8301-13727_7-10335165-263.html?tag=mfiredir), and just leave them running*.  You can close all of their windows if you are not using them.  With no open windows, there is not much activity, and, thanks to the use of modern virtual memory by macOS, there will not be any noticeable performance degradation.  This may not, however be a good solution if you are using Separators, Tags, Keywords (Shortcuts),  Descriptions (Comments) or Live Bookmarks in Firefox because then [these things may not sync very often](syncFirefoxOnQuit).


### Accessing Web Apps <img src="images/BookMacster.png" class="whapp" /> [accessWebApp]

The bookmarks of [web-based browser apps]() such as Pinboard can be accessed at any time, typically using an "application programming interface" (API).  Where available, BookMacster uses such an API.  The web apps' synchronize changes uploaded and downloaded by BookMacster.

Accessing content from a web app requires that BookMacster be able to get a password from your [macOSKeychain]() If you want BookMacster's background [Sync Agent](bkmxAgent) to be importing from or exporting to a web app, when setting the Client, make sure to check the box that says *Keep in my macOS Keychain*.

In order to minimize loading on their servers, web apps require that BookMacster maintain a local cache of your bookmarks content.  Sometimes a glitch may result in the  server telling BookMacster that its local cache is synchronized with their data when in fact it is not.  If you are seeing inconsistencies between BookMacster and a web app, you can force BookMacster to re-download all bookmarks content from the server on the next import by emptying BookMacster's local cache.  To do this, in the menu click *BookMacster* > *Empty Cache*.  The web apps don't like if you do this too frequently (within minutes) and may temporarily ban your IP address if they feel offended.  BookMacster keeps track of this for you, if you are in danger of being banned, usually warns you and refuses to perform the command.


### Accessing Bookmarks in Loose Files <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [accessLoose]

When you set a Client using the *Choose File (Advanced).* item in the popup menu it the Import or Export table, BookMacster remembers the Macintosh file system's "alias" so that if you move the file, it cam still be found.  Again, no checks or warnings on browser running are made before performing an Import or Export.

