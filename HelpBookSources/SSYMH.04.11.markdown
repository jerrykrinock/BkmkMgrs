# Multi-Device Sync Configurations <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [syncMultiDesign]

Because of restrictions imposed by web browser publishers and [device]() manufacturers, no single app or service can sync bookmarks between all browsers and devices.  But Synkmark or BookMacster can be used in conjunction with other services to the job, and using multiple services gives you workarounds in case one of them fails.  The information in this section will empower you to sketch out a system that works for you.

Major web browser publishers now provide [their own services](browserSync) for your bookmarks among **their** browsers on multiple [devices]().  But they do not talk to one another.  **Synkmark or BookMacster can be the missing bridge among them.**

Unless you're starting from scratch, which is rare, syncing among multiple [devices]() or browsers requires a little thought to get all of your bookmarks in the correct place  before you start checking boxes.  We recommend sketching it out.

There are two basic alternatives:

## Alternative 1: One Synkmark or BookMacster on One *Bridge* Mac

This is the best alternative for most users, who want bookmarks synced to Safari, Chrome or Firefox on a iOS or Android device (phone or tablet).  In this example, Syncing is activated in Synkmark or BookMacster, which is installed on only one Mac.  Syncing to other devices is via the browsers' proprietary services: iCloud, Firefox Sync, and Chrome Sync.  A bonus is that these services are able to sync open tabs and browsing history in addition to bookmarks, albeit only among themselves.  The Mac with Synkmark or BookMacster syncing active is called the *Bridge* Mac.

<div class="figure">
<img src="images/SyncExample1.png" alt="" />
</div>

You should choose as your "Bridge" Mac whicever Mac you use most often, because syncing among the browsers will only occur when this Mac is on and you are logged in to it.

**Whatever you do, be careful not to create a [Sync Loop](syncLoop).**  In the picture above, if you installed *iCloud for Windows* on the Windows computer in the upper left and configured it to sync Chrome and/or Firefox bookmarks, you would have a sync loop.


## Alternative 2: Via a File Syncing Service in the Cloud [bkmxViaDropbox]

The other alternative is to install BookMacster on more than one Mac, using a single *synced Collection*.  To do this, you move the document into a synced folder, that is, a folder synced by a [Online File Syncing Service](onlineFileSyncServ).  In this example, BookMacster will not only bridge among browsers but also among Macs.  You activate the browsers' proprietary services only as needed to branch off to any non-Mac [devices]() where BookMacster can't go.  In this case, syncing to that device will only occur when the associated Mac is on, and you are logged in.

<div class="figure">
<img src="images/SyncExample2.png" alt="" />
</div>

We recommend this alternative only for users who understand what they are doing, because it is easier to create a [Sync Loop](syncLoop).  Connecting more than more than one Mac to one of these syncing services, if the Macs are also connected via Synkmark or BookMacster, would create a sync loop.

We maintain a [web page with our current evaluations of various services](https://sheepsystems.com/files/products/bkmx/cloudSyncServices/).

## Bonus of Alternative 1

Alternative 1 has the additional advantage of syncing not only bookmarks but other browser data (open tabs, history, etc.) *within each browser*.  Safari open tabs on one device will sync to Safari open tabs on another device.  Safari open tabs will not sync to Firefox open tabs.  Alternative 2 does not support syncing of open tabs or other data, because it relies on Synkmark or BookMacster between [devices](), and the app syncs only bookmarks.

## Not Recommended: Multiple `.bmco` Files

Note that, in both Alternatives 1 and 2 above, there is effectively only one BookMacster/Synkmark `.bmco` document file.  In Alternative 1 there is physically only one, on the *Bridge* Mac.  In Alternative 2 there is virtually only one, because the two are kept in sync by Dropbox.

Well, let's say that in configuring Alternative 2, you left the `.bmco` files in their default locations instead of moving them to the Dropbbox folder.  With Dropbox out of the picture, you instead linked the two Macs by switching on iCloud>Safari in both of them.  It is true that you do not have a Sync Loop, but now you have two `.bmco` documents which, if you are not careful, could be configured to arrange bookmarks in different ways.  For example, one could be set to sort *folders above bookmarks* and the other set to leave them mixed.  The sort order will keep flipping every few minutes, as the two `.bmco` documents *fight* each other by sorting *their* way. 

Even if you are careful, it is possible that, because the two computers' software will not be updated exactly simultaneously, some change in a future version of a browser, Synkmark or BookMacster could cause, for a time, a similar *fight* between the old and new ways of doing things.

## Bookmarks on a Local Network [bkmslfOnLAN]

Because a Collection (.bmco) file is just a document file, if you don't want to synchronize over the internet, you can get the same effect as synchronizing by simply accessing this file from multiple Macs.  The following figure shows three ways to do that.  Note, however, that in all cases here your Collection file is stored on only one device.  Therefore, whichever device is hosting your .Collection file should have some kind of backup system, Apple's Time Machine™ for example, in case the device fails or suffers some natural or man-made disaster.

<div class="figure">
<img src="images/BkmxDocOnLAN.png" alt="" />
</div>
