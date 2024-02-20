# Test Syncing <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [testSyncers]

If you want to see how Syncers work, click in the menu: BookMacster > Logs and watch the entries as you perform the test.  Click the little round *refresh* button in the *Logs* window to display new events.

## Testing Syncing in Smarky <img src="images/Smarky.png" class="whapp" /> [testSyncersSmarky]

*  Quit Smarky (*).

* Activate Safari.

* Add an [internal bookmark]().  That is, visit a web page and click in the menu *Bookmarks* > *Add Bookmark*.

* Click in the menu: *Bookmarks* > *Edit Bookmarks* or *Show All Bookmarks*.

* Find the bookmark you just added.

* Wait [a few minutes](syncerLaziness).  

* Verify that the bookmark has moved to its proper position based on your settings of [what gets sorted](sortWhich) and [sorting order](sortHowOrder).

## Testing Syncing in Synkmark <img src="images/Synkmark.png" class="whapp" /> [testSyncersSynkmark]

* Click in the menu: *Preferences* > *Syncing*.

* Note the list of *Synced Browsers*.

* Note one of the browsers which has the *Import* checkbox switched on, and another browser which has has the *Export* checkbox on.  (Normally, all checkboxes will be switched on, so just pick two of them.)

* Quit Synkmark (*).

* Activate the first browser.

* Add an [internal bookmark]().  That is, visit a web page and click in the menu *Bookmarks* > *Add Bookmark* (or equivalent).

* Wait [a few minutes](syncerLaziness).

* Activate the second browser.

* Look at its internal bookmarks.

* Verify that the bookmark you added in the first browser is now in the second browser, and also that it is positioned properly based on your settings of [what gets sorted](sortWhich) and [sorting order](sortHowOrder).

## Testing Syncers in BookMacster <img src="images/BookMacster.png" class="whapp" /> [testSyncersBookMacster]

* Activate a Collection window.

* Click in the toolbar: *Settings* > *Clients*.

* Note one of the Clients which has the *Import* checkbox switched on, and another browser which has has the *Export* checkbox on.  (Normally, all checkboxes will be switched on, so just pick two of them.)

* Quit BookMacster. (*)

* Activate the first client browser.

* Add an [internal bookmark]().  That is, visit a web page and click in the menu *Bookmarks* > *Add Bookmark* (or equivalent).

* Wait [a few minutes](syncerLaziness).

* Activate the second client browser.

* Look at its internal bookmarks.

* Verify that the bookmark you added in the first browser is now in the second browser, and also that it is positioned properly based on your settings of [what gets sorted](sortWhich) and [sorting order](sortHowOrder).

## (*) Why you must Quit for Syncing to work

As you know by now, Smarky, Synkmark and BookMacster are designed to sync or mirror their content with the bookmarks in your web browsers.  If you edit this bookmarks/content, in both of them before syncing can occur, this creates a conflict between the two.
