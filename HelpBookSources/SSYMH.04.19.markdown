# Resolving Errors <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

When an error requiring your attention occurs, the app displays an error dialog.  At the bottom left is a button with a life-preserver icon.  Clicking this button generates an email message including additional technical information, addressed to our [Support team](https://sheepsystems.com/support/).  If you would like our support regarding an error, don't take a screenshot.  **Click the life-preserver icon.**

Whenever the app or one of its [BkmxAgent]() generates an error, it is stored on your [Macintosh User Account]().  You can re-view past errors by clicking in the [application menu]() > *Logs* and then clicking the *Errors* tab.  Errors displayed in this manner likewise have a button with a life-preserver icon.  Again, don't take a screenshot.  **Click the life-preserver icon.**

Although the apps generally provides quite informative error dialogs, there are a few that could benefit from further explanation.  The remained of this page does that

SSYMH-PAGE-TOC


## Error 144770 : Broken Login Item [brokenLoginItem]

### Why Error 144770 Occurs

Our older app, Bookdog, came with an accessory named *Bookwatchdog*, which ran in the background and can conflict with Smarky, Synkmark, Markster or BookMacster.  Therefore, these apps ask macOS for your Login Items, so it can see if Bookwatchdog is a Login Item, and if so remove it.  Unfortunately, if the application required for *any* of your Login Items (not just Bookwatchdog) is missing, macOS will give the app an incomplete report.  The app then asks for your help to fix it.  To get your help, the app presents *Broken Login Item* Error 14470.  Yes, it's annoying, but it's something that you should fix sooner or later anyhow.  We're just being helpful.

### Steps to Fix Error 144770 [stepsFixError144770]

The instructions here look ominous, but following them will probably be the easiest thing you do all day.  Here we go…

+  At the top left of your screen, click the Apple () menu down to *System Preferences*.

+  In the *System* row, click *Users & Groups* or *Accounts* <img src="images/Users+GroupsTool.png" alt="" />.

+  There are two tabs near to top.  Click *Login Items*.  You'll see something like this…

<div class="screenshot">
<img src="images/LoginItems.png" alt="" />
</div>

+  Go back to the dialog in Smarky, Synkmark, Markster or BookMacster and see which **item number** is broken.

+  Count down the list to that item number.  In the example shown above, the item number is 2.  Therefore we count down to the second item number and find that it is  *iTunesHelper*.  *You will likely have different item number and a different item name.*

+  If you know that you're no longer using the item indicated, typically because it is associated with an app that you no longer use, skip the next two steps.

+  If you don't recognize the item, put your mouse over the item and sit still for a few seconds.  You may see a [tooltip]() giving the *path* to the application */Applications/iTunes.app/Contents/Resources/iTunesHelper.app*.  If you don't get any tooltip, and if the item's 'Kind' is 'Unknown', it probably means that the item's file or package has been deleted.

+  If you realize that you no longer need this item, skip this step.  Otherwise, you should try and find or reinstall the missing item.  This can be a little tricky if, as in the case of this example, the path is to an app which is inside another app.  In this example, you would first navigate in Finder to /Applications, then see if you have iTunes application. If you don't then indeed this is a Broken Login Item.  If you do, then you must look inside the iTunes application package to see if you have Contents/Resources/iTunesHelper.app.  To do this, perform a secondary click ("right-click") on iTunes and click *Show Package Contents*.  Open the Contents folder, then inside that open Resources and look for iTunesHelper.  If it or any of its parent folders are not there, you've indeed got a Broken Login Item.

+  If the Broken Login Item is something that you no longer have or no longer use, re-activate the System Preferences > Accounts window, select the item and click the [-] button to delete it.  Of course, this item  will not work any more, but it wasn't working anyhow.  If on the other hand you still want this item to work, you'll need to reinstall it.  You may need to visit its developer's website and redownload it, or re-run the installer in the associated application.

+  Quit and re-launch Smarky, Synkmark, Markster or BookMacster.  This time you should not get the error message.  (No news is good news.)  This means that the app has successfully received your Login Items from macOS and verified that Bookwatchdog is not among them.


## Error 144762 : Broken Login Item [noRemoveLoginItem]

### Why Error 144762 Occurs

Our older app, Bookdog, came with an accessory named *Bookwatchdog*, which ran in the background and can conflict with Smarky, Synkmark, Markster or BookMacster.  Therefore, these apps ask macOS for your Login Items, so it can see if Bookwatchdog is a Login Item, and if so remove it.  Error 144762 indicates that Smarky, Synkmark, Markster or BookMacster requested that macOS remove Bookdog's old Bookwatchdog from your Login Items, and macOS said "No" and failed for some reason.

### Steps to Fix Error 144762 [stepsFixError144762]

To solve the problem, since this removal only needs to be done once, do it manually…

+ Click in your menu:  > System Preferences.

+  At the top left of your screen, click the Apple () menu down to *System Preferences*.

+  In the *System* row, click *Users & Groups* or *Accounts* <img src="images/Users+GroupsTool.png" alt="" />.

+  There are two tabs near to top.  Click *Login Items*.  You'll see something like this…

<div class="screenshot">
<img src="images/LoginItems.png" alt="" />
</div>

+  Scroll through the list and see if *Bookwatchdog* is listed in there.  If it's not, you're done.

+ If it is, delete it by selecting it and clicking the [-] button.


## Error 103040 : Too Long to Install Browser Extension [extnsnInstallTooLong]

### Why Error 103040 Occurs

Synkmark, Markster or BookMacster install [*extensions* into some web browsers in order to perform several functions](browserExtensions).  You must approve the installation by clicking a button in a popover which appears in the web browser.

Usually it works, but if you don't notice and/or respond to the popover, or if the browser didn't display the dialog because they are occupied with some other task, Error 264948 will appear in Synkmark, Markster or BookMacster.

### Steps to Fix the Problem [stepsFixError3040]

Although Synkmark, Markster or BookMacster will retry the installation later when needed, it is often less frustrating, and thus recommended, if you've read this far, to fix the problem immediately, in a manual mode where you have more control.  To do that,

+  Click in the [application menu]() > Manage Browser Extensions.  You will see a new window as shown here, except without the happy green-circled checkmarks.

<div class="screenshot">
<img src="images/ManageExtensionsHappy.png" alt="" />
</div>

+  The buttons are fairly self-explanatory, and if you want to stop reading now and start pushing buttons, go for it.

+  Focus on the row of buttons for the browser client for which the installation failed.

+  If indications are that the extension is installed, click the *Test* button and see what happens.  You should get a green-circled "passed the test" checkmark.  Sometimes the test will fail because the browser was not running and take too long to launch.  If that happens, click "Test" again.  At other times, Firefox hangs and won't quit.  If that happens, type ⌘⎇*esc* and Force Quit Firefox.

+  Otherwise, click the *Install* button for one of the Chrome or Firefox Clients which you wish Synkmark, Markster or BookMacster to be able to work with.  The *Install* button should be enabled after a failed test.

+  If installing for Firefox, activate Firefox and watch for instructions to appear.  Sometimes it fails to respond when you click "Install Now" after the countdown.  If that happens, wait a few seconds for the app to display another error, then retry.

+  After installing, return to *Manage Browser Extensions* and click "Test".

+  Repeat for other relevant clients.

In the end you should see happy green-circled checkmark(s) as shown above.

## Errors 103045 : Slow/No Response from Browser during Import/Export

These errors can only occur while the affected browser is running, but our app may launch the browser, [as explained here](launchBrowserPref).

## Errors 103011, 103012 : Import or Export *Safe Sync Limit* Exceeded [safeSyncLimitError]

### Why Error 103011 or 103012 Occurs

A disadvantage of syncing data sets such as bookmarks is that an inadvertent change in one data set will be automatically copied to all the others.  The [Safe Sync Limit in Smarky, Synkmark and BookMacster prevents that in many cases.](safeSyncLimit).  If an Import Safe Sync Limit is tripped, Error 103011 occurs, and if an Export Safe Sync Limit is tripped, Error 103012 occurs.  In either case, syncing is *paused* in order to prevent the error from recurring.  You at least need to restore sync in your data, and *resume* syncing.

To resolve Error 103011 or 103012,

* Activate Smarky, Synkmark or BookMacster.  For the latter, open the document which was said to have produced the error if it does not open automatically.

* Examine the [internal bookmarks]() in the synced web browsers and in Smarky, Synkmark or BookMacster.  Determine which place has the *good* bookmarks (the bookmarks you want).

* Depending on which is correct, click in the menu: *File* > *Import from …*, or *File* > *Export to …* as needed to overwrite from the *good* bookmarks to everywhere else.  If a Safe Sync Limit warning appears during an Import, *OK* it, because you are in control now and you've examined what you're doing.  If a Safe Sync Limit warning appears during an Export, for the same reason, click *Export Anyhow*.

* Click the *Syncing* button in the toolbar, to change it from *Paused* <img src="images/ButtonSync-Paused.png" alt="" /> to *Syncing* <img src="images/ButtonSync-On.png" alt="" />.

* When prompted to export, click *Export*.  (This is redundant if you have just exported, but it won't do any harm and is a good practice.  In BookMacster, you can click *It's OK* to avoid an unnecessary export.)

* Understand [how the Safe Sync Limit works and decide whether you want to change a limit, or change your work habits](safeSyncLimit), to prevent the error from recurring.

## Error 103015 : Sync Fight [syncFight]

### Why Error 103015 Occurs

After an Export operation to a [Client](), Smarky, Synkmark, or BookMacster compares the changes it exported to the changes exported in prior exports.  If the app finds that it is exporting the the same changes repeatedly, with no other changes, it is apparent that something must be un-changing what the app changed.  In other words, there's a fight!  Since the app in turn detects the un-change and syncs again, exporting again, this could go on forever.

Instead, the app disables syncing.  It either [pauses syncing]() or, equivalently, [disables Syncers](), and displays Error 103015 to you.

### Steps to Fix the Problem

* The first step is to find the cause of the problem and remove the cause.  There are two general causes.

* **You have a Sync Loop.**  The solution is to break the [Sync Loop]().

* **Syncing services are properly configured but one of them is misbehaving.**  Our website contains [current information on this topic](https://sheepsystems.com/files/products/bkmx/inex-sync-fight.html).  If you cannot resolve the issue, please consider sending us your data so that we can figure it out.  To do that,

  * Activate Smarky, Synkmark, or BookMacster.
  * Click in the menu: *Help* > *Trouble Zipper*.
  * Trouble Zipper will ask several questions regarding what data to include.  For this particular case, please click *Include Bookmarks*, and then select the browser whose bookmarks are being fought over.

If you would rather try to resolve the problem yourself, you need to find out what change(s) are being fought over.  You can see this by examining your recent [Sync Logs]().

In the following example, by clicking the popup menu you can see that there were three recent Exports interspersed with two Imports to Safari…

<div class="screenshot">
<img src="images/SyncFightPopup.png" alt="" />
</div>

After a fight over Safari bookmarks is reported, if you click any of the recent *Export* logs for the errant Client (Safari in this example) you should see exactly the same changes.  Here is an example…

<div class="screenshot">
<img src="images/SyncFightExport.png" alt="" />
</div>

In this example, the bookmark *Ant* is being moved up to position 0, and bookmark *Bird* is being moved down to position 1.  That is, BookMacster, say is putting them into alphabetical order.

Conversely, if you click any of the recent *Import* logs for the errant Client (Safari in this example) you should again see the same changes in each log, but the *opposite* of what changed during the exports.  Continuing the same example…

<div class="screenshot">
<img src="images/SyncFightImport.png" alt="" />
</div>

In this example, the bookmark *Ant* is being moved down to position 1, and bookmark *Bird* is being moved up to position 0.  That is, some other app or service is moving them back, *out* of alphabetical order.

* Restore Your Sync Snapshots Preference.  When Smarky, Synkmark or BookMacster first noticed the problem, it likely increased the setting of your *Number of [Sync Snapshots]() to keep* so that enough data could be gathered to diagnose the problem.  If you're not 100% sure that the problem won't come back, we recommed leaving it at the higher value.  But if you want to set it back,

  * Activate Smarky, Synkmark, Markster or BookMacster.
  * Click in the [application menu](): *Preferences*.
  * Click the tab: *Syncing*.
  * Change *Number of recent Snapshots to keep* to your preferred value.

* When Smarky, Synkmark or BookMacster first noticed the problem, it also paused syncing.  After the problem is resolved, you should [*resume* syncing](pauseResumeSyncers).


## Errors Exporting to Non-Running Firefox [notRunFfoxPrepErr]

When Synkmark, Markster or BookMacster needs to export to Firefox while Firefox is not running, or you ask Smarky to export to Firefox even if it is running, the app accesses Firefox' bookmarks database file directly.  In preparation for the actual export, it opens the database, verifies the expected tables, and performs a *checkpoint* operation, to flush through any changes pending by other applications.  These are simple operations, and if they fail, this almost always means that the database file is corrupt.  Here is what you need to do.

* Launch Firefox

* Activate Synkark or BookMacster and repeat the Export operation.  If the failure occurred by an Syncer operating in the background, click in the menu *File* > *Export*, to do a normal export.

* If it succeeds, activate Firefox and click in the menu: *Bookmarks* > *Show All Bookmarks*.  If you see all of your bookmarks there, including any newly-exported changes, you are done.  If not, continue.

* In the *Library* window which appeared in Firefox when you clicked *Show All Bookmarks*, click the star tool in the toolbar and Restore from a recent backup.

* If that worked, quit Firefox and repeat the Export from Synkmark or BookMacster.  If that works too, you are done.  If not, continue.

* Now we're at the point where your Firefox bookmarks are definitely corrupt and you're going to have to abandon what remains.

* Launch Firefox.

* Click in the menu: *Help* > *Troubleshooting Information*.  A window or tab will appear.

* In the section *Application Basics*, Profile Folder, click the button *Show in Finder*.  A Finder window will open.

* Quit Firefox.

* In the Finder window, find the file named *places.sqlite*.  Trash it (or move to your Desktop, if you think you might want to try to recover bookmarks later).

* See if there are file(s) named *places-shm.sqlite* and/or *places-wal.sqlite*, and if so trash them.

* Assuming you were doing a normal Export from Synkmark or BookMacster which was going to overwrite all of your Firefox bookmarks anyhow, repeat the export from the app.  Otherwise, you might wawnt to launch Firefox and restore from one of Firefox' backups using the Star button as described above.  Note that if you launch Firefox with no places.sqlite file in your Profile folder, Firefox will create a new one and populate it with a dozen or so bookmarks regarding the Firefox project and Mozilla, its suthor.
