# Syncing Notifications <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [syncNotifications]

## BkmxNotifier-A/B in macOS Notification Center [agentNoteCenter]

If you are using Smarky, Synkmark or BookMacster only to sort and/or sync your bookmarks automatically, it could operate for months without you seeing it.  But, with your approval, it will notify you if something goes wrong and, if you desire, whenever syncing operations are staged, begin, or complete.

These notifications are delivered via the [macOS Notification Center](https://support.apple.com/en-us/HT204079).  In order to allow you to have different levels of notification for major errors versus normal syncing events, our apps deliver these notifications to Notification Center via two different *helper* applications, BkmxNotifer-A and BkmxNotifier-B.  As explained in the Apple article linked to above, you configure the behavior of notifications from these helper apps in System Preferences > Notification Center.  Note that if BkmxNotifier-A or -B have never in their lifetime on your Mac attempted to send a notification, they will not appear in the System Preferences.  If you want to pre-configure notifications and one or both are absent from the list in System Preferences…

 * Activate the app you are using to sync bookmarks – BookMacster, Synkmark or Smarky.
 * Click in the main menu: {Name of app} > Preferences.  A window shall open.
 * Click the tab *Syncing*.
 * At the bottom of the window, click the button *Notifications*.  A sheet with many checkboxes will open.
 * Click the “Demo” button for BkmxNotifier-A. and/or one of the “Demo” buttons for BkmxNotifier-B.

The macOS should prompt you for permission, and if you OK the relevant BkmxNotifier will appear in System Preferences.  You may need to quit and relaunch System Preferences before they appear. 

### Major Errors: BkmxNotifier-A

Our helper app named *BkmxNotifier-A* produces the major *error* notifications, typically indicating that a sync operation failed and that therefore your bookmarks are no longer being synced, which could result in bookmarks loss if you, for example, create some new bookmarks in in one browser and then create some more in a different browser.  We recommend that you tell macOS to allow BkmxNotifier-A to present *Alerts*.  *Alerts* are rounded rectangular bubbles in macOS Notification Center which appear in the upper right corner of your screen, including one or more buttons.  An *Alert* bubble persists on your screen until you click one of its buttons.  If you instead allow BkmxNotifier-B to present only *Banners*, then the bubble will have no buttons and will clear itself after a few seconds.  To learn what went wrong and see the options for reparing the situation, you will need to launch BookMacster, Synkmark or Smarky and in the menu bar > *application* menu click *Logs*, then the *Errors* tab to read recent errors.

### Normal Events: BkmxNotifier-B

Our helper app named *BkmxNotifier-B* produces progress and informational notifications, typically indicating that things are syncing normally but also indicating minor errors which are expected to clear themselves.  If you want to receive these notifications, click in the main application menu: *Preferences* > *Syncing*, then the *Notifications* button.  Switch on whichever you want, answer *Allow* if asked by macOS.  The macOS will initially configure itself to present *Banners* for BkmxNotifier-B, which is probably what you want, because several syncing events will occur any time you make some bookmarks changes.

### Changing your Notification Preferences in macOS Notification Center

In either case, after you have given your authorization in the initial dialog presented by macOS, if you change your mind and want to change between “Banners” and “Alerts”,

* Click in the menubar:  > System Preferences.
* Click the *Notifications* pane
* Select *BkmxNotifier-A* or *-B* and edit as desired.  Our recommended settings are shown in the following two screenshots:

<div class="screenshot">
<img src="images/SysPrefNotifierA.png" alt="" />
</div>
<p></p>
<div class="screenshot">
<img src="images/SysPrefNotifierB.png" alt="" />
</div>

To reduce the number of notifications you get, go back to BookMacster, Synkmark or Smarky and then in Preferences > Notifications, switch off checkboxes controlling the notifications you no longer wish to receive.

## Customizing the sounds presented with our notifications [agentCustomSounds]

In *Preferences* > *Syncing* > *Notifications*, if you switch on a *Play Sound* checkbox and click the corresponding *Demo* button, you will hear the sound which the macOS Notification Center will play when such an event occurs.  If desired, you may configure your system to play sound files of your choosing instead.  To do that, you should place the sound files in the Library > Sounds subdirectory of your Home directory:

`~/Library/Sounds/`

Supposedly, you can also place them in `/Library/Sounds/`, `/Network/Library/Sounds/` or ` /System/Library/Sounds/` (macOS searches the directories in that order and the first one with the required filename is used), but we do not recommend this because increasingly in macOS any time you try and change stuff out of your Home folder you get security and permissions headaches.

The files are identified by name, for each notification event.  Your files must be named exactly as one of these:

`BookMacsterSyncFailMajor.aiff`
`BookMacsterSyncStage.aiff`
`BookMacsterSyncStart.aiff`
`BookMacsterSyncSuccess.aiff`
`BookMacsterSyncFailMinor.aiff`

Of course, these filenames are each used for one of the five Events listed in *Preference* > *Syncing* > *Notifications*.  If you want to keep your files elsewhere and/or with different names, it would probably work to use symbolic links, but we've never tested that. 
