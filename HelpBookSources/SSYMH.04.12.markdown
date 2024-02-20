# Sync Loops <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [syncLoop]

Sync Loops are not complicated to understand, but because it's so important not to create one, we have a lengthy description, to make sure that everyone *gets* it.  You may stop reading as soon as you understand what a *Sync Loop* is.

Putting a Collection into a [Online Synced Folder](onlineFileSyncServ) and activating an [Syncer]() between them creates a bookmarks syncing service.  *Firefox Sync*, Chrome's *Sign in*, and iCloud - Safari syncing are also syncing services.

**It is OK to use more than one syncing service, as long as they are syncing separate pairs or groups of browsers and [devices](), and only meet at one point.**

<div class="figure">
<img src="images/SyncLoopGoodSimp.png" alt="" />
</div>

A *Sync Loop* is created when you configure two syncing services to do the same job; to keep the same bookmarks in sync.  To make sure you don't have a Sync Loop, draw a diagram of your setup, showing your [devices]() and browsers, like the diagrams in our [example sketches](syncMultiDesign).  Note that in our setups, you cannot start at one browser on a device, trace around the blue lines and come back to the same browser from a different direction.  There are no complete loops of blue lines.  No loops.  That's what you want.

<div class="figure">
<img src="images/SyncLoopBadSimp.png" alt="" />
</div>

Syncing services in a Sync Loop will step on one another's work as they fight over your bookmarks, continually un-doing and re-doing.  Deleted bookmarks will reappear, and may even multiply.  Don't create a Sync Loop.

You **could** have a Sync Loop if you are using two or more of the [syncing services provided by web browsers](browserSync), or have BookMacster or Synkmark on more than one Mac, with a .bmco file in a Dropbox, iCloud Drive or similar synced folder.
  
To determine if you have a Sync Loop, draw a little diagram of your system on paper, similar to the [diagrams in this Help Book](syncMultiDesign).  Note that none of our diagrams have any *closed loops*: Between each browser on each device and any other, there is only one line or path.  If your diagram shows two paths, which will form a closed loop, between any two browsers, you've got a Sync Loop!
  
To correct a Sync Loop, decide which lines you want to eliminate and do so by switching off syncing in those paths.  For example, one some devices you may wish to disable [the browser's syncing](browserSync).  In Smarky, Synkmark or BookMacster, that means to [switch off syncing (syncers)](settSyncing).

Although our apps have a little algorithm which detects when there is probably a Sync Loop, disables syncing and warns you.  But by that time a lot of damage has been done.

So, after clearing the Sync Loop, you should *zero out the clouds* – remove all of your bookmarks from whatever syncing services you'd been using.  This is definitely necessary if iCloud > Safari was ever in a Sync Loop, and the procedure is in [this Support article](https://sheepsystems.com/files/support_articles/bkmx/rebuilding-icloud-bookmarks.html).  We haven't have that much bad experience with the Firefox, Opera and Chrome syncing systems, but recommend doing a similar procedure if any of them may have ever been involved in a Sync Loop.

After zeroing out the clouds, repopulate by restoring your bookmarks to one source, and the let the various sync services propagate them to all of your browsers and devices.



<br />RELATED TOPICS

* [Multi-Device Bookmarks Syncing Configurations](syncMultiDesign)
