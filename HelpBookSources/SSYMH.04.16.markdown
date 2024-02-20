# *Collection* Document File <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [bkmxDoc]

Smarky, Synkmark, Markster and BookMacster are all *document-based* Macintosh apps.  Your bookmarks and some settings are stored in the Collection (.bmco) file, which  contains bookmarks and folders (your *[content](theContentTab)*).  A Collection can be *Opened*, *Saved*, backed-up, *Saved As*, *Duplicated*,  or even *Trashed* or *Deleted*.  All apps have adopted Apple's [auto save](autoSave).

The Collection, however, varies from documents in other apps in these ways:

* In Smarky, Synkmark, Markster, you have **only one** Collection.  It is opened (if necessary, created) for you automatically when you launch the app, and when you close the document, the app quits.

* Collections have associated behaviors which which you control with *[Local Settings]()*.  With *local settings*, you can tell the app to do certain things when you launch BookMacster or open the document, and keep web browser bookmarks in sync with the document, and with each other.

## Multiple Collection files <img src="images/BookMacster.png" class="whapp" /> [multBkmslf]

Most users want all of their bookmarks in one place, and if this applies to you, you should create only one Collection in BookMacster (or use Smarky, Synkmark or Markster which support only one).  This single Collection can be set (and is so set, by default), to be [opened whenever you launch BookMacster](openSaveAutoAct).

After OKing our warning, though, you can create multiple Collections if you want to.  Some good reasons for multiple Collections are:

* You prefer to keep a different bookmarks set in each [client]() browser.
* You want to create a sub-set of your bookmarks for an associate.
* You prefer to strictly compartmentalize Work, Home Hobbies, etc.

If you think that you created multiple Collection files inadvertently, and want to combine them, you should be aware of the following features in BookMacster and macOS.

* In the main menu, *File* > *Open Recent >* will show all of the documents you've ever created that still exist, unless you have a large number.

* macOS makes it easy to [find where the current document is located in your file hierarchy](docPathCmdClkTitle).

* A quick way to find and trash any and all documents is to [Reset and Start Over](resetStartOver).

* The magnifying glass in the upper right corner of your screen is the *Spotlight* feature of macOS.  To find all Collections, click Spotlight and enter *.bmco*.  A list will appear.  To open one of them, click it.  If you have macOS 10.9 or later, to simply show where it is in the filesystem without opening it, mouse over it until the popover appears showing info, and *then* hold down the command (⌘) key on your keyboard.  The file *path* will appear at the bottom of the popover.

## Automatic Saving <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [autoSave]

Since you may be adding bookmarks sporadically throughout the day, the Collection landing such bookmarks needs to be saved periodically.

When a bookmark is landed, the landing Collection is automatically saved, immediately. In addition, if the [Inspector pops up](), and if you make your changes and close the Inspector within 60 seconds, your changes are automatically saved when you close the Inspector.

These saves are coordinated with the [Auto Save and Versions feature of macOS](https://support.apple.com/kb/PH18862).

If you are using BookMacster, you can switch off Auto Save by switching ON the checkbox at the bottom of Preferences > General.  But we don't recommend this.  With Auto Save and Versions, you'll never "lose" a bookmark.


## Weird File Names <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

From time to time you may see copies of your Collection (.bmco) files that have weird file names alongside the current version.  These are usually nothing to worry about and, if all appears well with the current version, may be deleted.  This section gives more detail.

### Filenames with Tildes (~)

If one day you see a mysterious extra Collection file with one or more tildes (~) between the filename and ".bmco", and BookMacster is working fine for you, you may trash these tilde files.  They were created by previous versions of BookMacster and are no longer readable.  For more info, read on…

### Filenames with Sharp/Hash/Pound Characters (#)

If one day you see a mysterious extra Collection file with one or more # characters between the filename and ".bmco", and BookMacster is working fine for you, you may trash such these # files.  

When BookMacster opens a Collection file, therefore, it examines the file for corruptions which it can fix.  If any are found, BookMacster moves the corrupt document to a different name, fixes the corruptions, and saves the file.  The old, corrupt file now has one or more # characters added between the filename and ".bmco".  If it turns out that the removed items are of value to you, [our Support team](https://sheepsystems.com/support/) may be able to recover the removed items from a # file.

### Filenames with *(deleted xxxxxx)*

Collection files which have been in your Dropbox folder may have been [deleted by Dropbox](dropboxTrash).

## Details of Collection Versioning [bkmslfVersioning]

A Collection file, such as *myname-01.bmco* is actually a little database, with tables defined by the application version which created it.  As Smarky, Synkmark, Markster and BookMacster are updated to new versions, sometimes news "rows", "columns" or "tables" may be added to support new features.  When a newer version of the app with such table changes opens a Collection which was created by an older version, it immediately renames the Collection file by apending a tilde (~) to its name, and then converts the file to the new table and saves it with the old name.  It's a built-in "feature" of Apple's Core Data framework which is used by the app.  The reason is that, on the rare occasion that the new version of the app doesn't work for you, and you downgrade back to the older version, you won't be able to open the new file, but will still be able to open the old tilde file.

