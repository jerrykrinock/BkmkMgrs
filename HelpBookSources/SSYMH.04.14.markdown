# More About Syncing Among Macs <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [dropboxDetails]

This section gives technical detail which may be helpful for troubleshooting any problems that might occur when [synchronizing your bookmarks among Macs](bkmxViaDropbox), assuming that you have fully activated Simple Syncers for two-way syncing like this…

<div class="screenshot">
<img src="images/SimpleSyncOn.png" alt="" />
</div>

## Step By Step

We show the actions which occur when you add or otherwise change a bookmark in a [client]() web browser's [built-in bookmarks]() under the above conditions, using Dropbox as the [Online File Syncing Service](onlineFileSyncServ).

As you read the steps below, you can follow along in this drawing…

<div class="figure">
<img src="images/DropboxHow.png" alt="" />
</div>

A.  Due to the to *Import Changes from Clients* checkbox, after 1-5 minutes, bookmarks changes you make in the bulit-in bookmarks of your web browsers are detected and imported into Smarky, Synkmark or BookMacster.  Provided that the involved Collection is not open in BookMacster, Synkmark, or Smarky, [BkmxAgent]() will silently and invisibly open the Collection.  If you have checked the box *Export Results to Clients*, [BkmxAgent]() will export changes, if any, to the other client web browsers on the local Mac.

B.  Internally, this [Syncer]() has a command to *Save Document* after the export, so the [Collection](bkmxDoc)() (.bkmxDoc file), which is in your Dropbox folder, gets saved to your Dropbox folder.

C.  The Dropbox application is always watching your Dropbox folder.  When it sees the changes in your Collection, it compresses them and then…

D.  Uploads the changes to the nearest Dropbox server.

E.  The Dropbox servers synchronize each other over the internet.

F.  The Dropbox application on your other Mac will receive the changes.  If you have just logged in or waken from sleep, Dropbox waits about 60 seconds for the things to calm down, and probably to get some assurance that the connection is going to stick around.

G.  The Dropbox application on your other Mac moves the original version to an archive in ~/.dropbox/cache, and then reconstructs the file, including the changes it receives, back into the Dropbox folder.  After Dropbox has received the file, you'll see a Growl notification from Dropbox (unless you've disabled them).

H.  [BkmxAgent]() sees that the file has changed and performs the Commands of the relevant Syncer.

I.  The same Syncer has a [command]() (its only command) to [Export]() changes to the [Client]() web browsers on your other Mac.

(The cloud and network icons in the figure are provided by [Open Security Architecture](http://www.opensecurityarchitecture.org/cms/) under the [Creative Commons](http://creativecommons.org/licenses/by-sa/3.0/) License.)

## Deleted or Replaced Files [dropboxTrash]

If a file is deleted or replaced on one Mac, Dropbox moves it into a special cache folder on other Macs, and appends *(deleted)* and a string of characters to its name, resulting in something funky like this:

&#160;&#160;&#160;<code>My Bookmarks (deleted 95d803a1e8aa701e86fbcbd1506e338e).bkmxDoc</code>

Therefore, if you want to trash a Collection file which is in your Dropbox, you must trash it on each Mac.  To do that,

* Find and select it from the submenu *File* > *Open Recent*.
* After it opens, click in the menu: *File* > *Close and Trash*.
* *OK* to trash it.

If you've changed your mind about this document and instead you want to keep it, instead of *Close and Trash*, you'll want to rename and move the document.  To rename and move, click in the menu: click *File* > *Move To…*.  In the sheet which appears, navigate to any desired location in your Home Folder.  Then, click *File* > *Rename…* and change the funky name.

<br />RELATED TOPICS

* [The Dropbox Cache/Trash](https://www.dropbox.com/help/328/en)
