# BookMacster : Sync Browsers <img src="images/BookMacster.png" class="whapp" /> [useSync]

This section gives the steps to set up BookMacster, possibly in conjunction with other services, to keep the [internal bookmarks]() of your [web browsers](browserApps) in sync with one another.  For example, when you add or delete a bookmark in Firefox' *Bookmarks Toolbar* or menu, you want the same addition or deletion to be reflected in Safari's *Favorites* or *Bookmarks* menu.

Follow the steps below.  If you click a link for more detail, use the Back (<) button in the toolbar above to return here.

* Activate BookMacster.

* [Create a Collection](bkmxDocCreate), importing existing bookmarks from the web browsers you wish to sync.

* If there are other bookmarks in other files, browsers or [devices]() which you want to import and merge with what you have just imported, [import those now](imEx1Client).  In particular, if there are bookmarks on other Macs that you want to have in your synced collection, make sure you get those now and import them into this document.  Later, when we Export on that other Mac, those bookmarks will be deleted.

* [Organize your bookmarks](organizingTasks).

* If you have [browser's sync services](browserSync) already syncing your bookmarks, or if your ultimate goal is to sync your bookmarks among multiple [devices](), read about the different [routes available for syncing multiple devices](syncMultiDesign) and sketch out how you will use BookMacster, in conjunction, with other services if necessary, to reach all the browsers on all devices.

* If, as a result of the previous step, you need to disable branches of these other services because they are not in your sketch, do that now.  If you don't remember how you set them up, [we have links for you](browserSync).

* [Set up simple Syncers]().  This is how you "turn on syncing".
  
* If you *Paused* syncing during the previous step, click the *Syncing* button in the toolbar to *Resume* syncing.

* This time, click *Export*.  Your initial export is important, to make sure that all [clients]() begin with the same bookmarks, that is, they begin *in sync*.

* Finally, quit BookMacster.  Your Syncers will work silently.  (If you leave the Collection window open, Syncers will still work, but they will draw a sheet over the window while it is working, to prevent a conflict between you and the Syncer changing your bookmarks at the same time, which is annoying.)

**If you are only using BookMacster on one Mac, you are done.**  If desired, you may [test your Syncers]().

If you made a sketch earlier and it shows BookMacster on multiple Macs, repeat the following group of steps on each additional Mac.  They're mostly the same as what you did on the first Mac.

* Install BookMacster.

* Find the synced .bmco Collection file, which you placed in your [Online Synced Folder](onlineFileSyncServ) on your first Mac.  (For most services, you can get there by clicking on their [menu extra]().)

<div class="screenshot">
<img src="images/MenubarDropbox.png" alt="" />
</div>

* Verify that the file is done downloading.  Most services indicate this with a green checkmark "badge" on its icon.  If you don't see the file or the badge yet, check your network connection and [Online Synced Folder](onlineFileSyncServ) configuration, and wait a few minutes.  ([Path Finder](http://cocoatech.com/) users must *Reveal in Finder* to see the badge.)

* Double-click the .bmco file, to open it in BookMacster.

* Click the tab: Settings > Clients and add the [clients]() that you want synced on this Mac, switching on *Import*, *Export* or *both*, as desired.

* [Set up simple Syncers]() to watch your [Clients]() for changes on this Mac.

* If you *Paused* syncing during the previous step, click the *Syncing* button in the toolbar to [*Resume* syncing](pauseResumeSyncers).

* This time, click *Export*.  Your initial export is very important, to make sure that all [clients]() begin with the same bookmarks, that is, they begin *in sync*.

* Quit BookMacster.  [Learn Why](leaveRunning).

Your setup is now complete.

* If desired, you may [test your Syncers]().
