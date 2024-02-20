# Changing Your Setup [setupChange]

Many users, especially switchers from older versions of Microsoft Windows, are in the habit of uninstalling and reinstalling an app if the app is not behaving as expected.  This doesn't usually solve the problem in macOS, because macOS smartly keeps your data and applications separate.  So if you reinstall the app, it will still be using your same data.  What you want to do is move or remove the relevant data.  With BookMacster, the relevant data is your Collection files.  

Removing *Preferences* files is also popular.  BookMacster has Preferences, but they are straightforward in BookMacster and not likely to cause confusion.  Also, starting with 10.9, macOS caches preferences, and removing the file will have unpredictable results.

This section explains better methods for changing your setup.

SSYMH-PAGE-TOC

## The *Reset Button* <img src="images/BookMacster.png" class="whapp" /> [resetStartOver]

If you would like to change how BookMacster is configured, click in the menu: *File* > *Reset and Start Over*.  If you then follow through and click the button, this will remove all remove all BookMacster documents and data, reset most preferences, and then present the New User Setup window so you can start over.  Because your doucments will be trashed, you should only do this if any bookmarks that you want to keep are currently stored in another app or file.  Typically, your bookmarks are in a web browser app such as Safari.  After you Reset and Start Over, you can re-import them to a new document.

The documents and data removed are…

* All known Collections.  Any documents currently open will be closed.
* Any Syncers which they may have (for syncing, etc.)
* Documents' Sync Logs and Identifier Indexes.
* Any pending changes from web browsers.

*Reset and Start Over* will not change any of the [internal bookmarks]() currently in your web browsers.  Also, it will not delete the logs you see in menu > BookMacster > Logs, and will not uninstall [Browser Extensions](browserExtensions).  The idea is to keep the working infrastructure in place.  Browser Extensions can be uninstalled with menu > BookMacster > Manage Browser Extensions.

The few preferences *not* reset include cosmetic settings in *Preferences* > *Appearance*.  Any License (registration) Information is also preserved.

You've now down to "scratch" and are ready to start over.

## Locating Your Collection <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [docPathCmdClkTitle]

Sometimes it helps to just know where the document whose window you are looking at is located on your hard drive.  This little trick works in any document-based Mac app.  Hold down the ⌘ key while clicking its title at the top of the window…

<div class="screenshot">
<img src="images/DocLoc1.png" alt="" />
</div>

You will see a menu showing the *file path* of the document, like this…

<div class="screenshot">
<img src="images/DocLoc2.png" alt="" />
</div>

In this example, I am using the Dropbox [Online File Syncing Service](onlineFileSyncServ).  My-Bookmarks.bmco is in a folder named *Dropbox*, which is my "Dropbox" folder.  It is located in my home (jk) folder.

## Moving Your Collection <img src="images/BookMacster.png" class="whapp" />

If you need to move your Collection file, click in the menu *File* > *Save To…* ( or *Save As Move…* if you have macOS 10.7 or earlier).

