# Syncers <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [syncers]

Syncers are observers which run in [BkmxAgent]().  They watch for certain [triggers](), such as bookmarks changing in a web browser.

Your settings for Syncers are not kept in the .bmco document.  Instead, they are [Local Settings]().

SSYMH-PAGE-TOC

## Controls for Syncing <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [settSyncing]

**Smarky** and **Synkmark** use Syncers under the hood to perform their syncing, and you control them in *Preferences* > *Syncing*.

**Markster** does not support syncing nor Syncers.

In **BookMacster**, you have fine-grained control over Syncers in a document's *Settings* > *Syncing* tab.  By default, the *Simple* Syncers subtab is displayed.  This tab is gives enough detail to configure syncers for [keeping bookmarks in a single browser sorted](useSingly), or [sync multiple browsers](useSync).  Users who desire more (or less) may use the *Advanced* Syncers subtab.


## Advanced Syncers <img src="images/BookMacster.png" class="whapp" /> [advancedSyncers]

In the [*Settings* > *Syncing*]() > *Advanced* tab of a Collection, you can create customized *Syncers*.

The conditions which trigger Syncers to spring into action are called, well, [Triggers](), and the work that they do is defined by a sequence of [Commands]().

In the Advanced view, note that the Triggers and Commands shown in the two lower tables are those of the Syncer which is *selected* in the upper table.  To add an item, click the nearby <img src="images/Button+.png" alt="" /> button.

The order of Triggers does not make any difference, but of course the order of Command execution is significant.  To reorder commands, either drag and drop, or select a command and type ⌘↑ or ⌘↓.

### Deactivating or Removing Syncers

If you would like to temporarily deactivate an Syncer, un-check the box in its *Active* column.  To remove a Syncer permanently, select it and click the <img src="images/Button-.png" alt="" /> button next in the top table in the Settings > Syncing tab.

### Triggers

Triggers are events which cause the [Commands]() of a BookMacster [Syncer]() to execute.

Triggers have a *trigger type* and an optional *detail*.  For example, the *scheduled* trigger type is triggered every day or every week at a certain time.  Its detail is the scheduled time and days.  The available *trigger types* are explained in subsequent sections on this page.

The necessary trigger(s) are created for you automatically when you check one of the boxes in the *Simple* tab of *[Settings > Syncing]()*.  To see what trigger(s) were created, or to modify triggers, click the *Advanced* tab.

If a Syncer has more than one trigger, there is no significance to the order of the triggers.

### Trigger Types

#### *I log in to my Mac* Trigger Type

This trigger will run commands when you log into your [Macintosh User Account]().  Besides being handy for people who like to start their day in sync, this trigger is recommended if your Collection file might be updated while you are logged out.  ChronoAgent, for example, can do this, and it is conceivable that other processes could update a .bmco file before macOS has loaded the *Other Mac updates this file" trigger. This trigger has an option; choose one of the following…

* *only if this .bmco has changed* reduces system resource usage by checking document metadata to see if a change has occurred before opening the .bmco document.

* *every login, always* is useful in case you want the commands to run because something may have updated bookmarks in web browsers, that you want to overwrite unconditionally.

#### *Bookmarks Changed* Trigger Type

The Bookmarks Changed trigger is available only if one of your Import or Export [Clients]() is the Safari, Firefox, or one of the (Google) Chrome bookmarks on your Mac account.  The reason is that only these browsers are capable of notificy BookMacster when their bookmarks change.  For other [locally-installed browser apps](), use the *Browser Quit* trigger (see below) instead.  For [web-based browser apps]() (Pinboard, Diigo), this trigger does not function because none of these services *push* their changes.

#### *Other Mac updates this file* Trigger Type

This trigger is activated whenever a [Online File Syncing Service]() (or, actually, any other app) updates the Collection file.  Note that when setting [Commands]() for such a trigger, it is not necessary to "reload" or "reopen" the Collection, even if it is already open, because Bookmacster does that automatically, presenting the new content.  Typically, with this trigger you will only execute one [Command](), which is to [Export]() – this is the trigger that is set when you activate the Simple Syncer to *Export Changes from Other Macs to [Clients]()*.

#### *New bookmark is landed from browser* Trigger Type

This trigger is activated following each *[landing* of a new bookmark to BookMacster *[directly](useDirectly)*.  The export is delayed in case you want to edit the newly-landed bookmark in the Inspector panel.  If the Inspector is not displayed when the new bookmark is landed, the export occurs immediately.  If the Inspector is being displayed, the export occurs when you close the Inspector panel, or until you do not edit anything for 30 seconds, whichever comes first.

#### *Browser Quit* Trigger Type

The Browser Quit trigger is only available if one or more of your Import or Export [Clients]() is that of a [local browser app]() with bookmarks on your Mac account.  This trigger is actually "as soon as possible" for browsers that do not allow BookMacster or BkmxAgent to edit their bookmarks while they are running.  (For Safari, you can get a sooner trigger by using the *Bookmarks Changed* trigger, see above.)


#### *Scheduled* Trigger Type

This trigger allows you to schedule an action to be performed daily or weekly at a specified time.  The time must be entered in the right-hand column using the [24-hour clock system](http://simple.wikipedia.org/wiki/24-hour_clock).

### Commands

*Commands* is a sequence of instructions which [BkmxAgent]() performs when its [Syncer]() is triggered.  A command is typically something that you could do manually yourself by clicking an item in the main menu.  Often, they have the same name and do the same thing.  Some commands are *Import*, *Sort*, *Export*, *Save Document*, etc.

Note that there is no *Open* or *Open Document* command because this is implied.  Commands are attributes of a Syncer which are in turn attributes of a particular [Collection](bkmxDoc) that must be opened in order for the commands to be performed.

Some commands have a *detail* associated with them.  For example, the *Export* commands have a detail setting which specifies what to do if the export cannot be executed because a web browser app is running (abort, quit the web browser app, or force quit the web browser app).

The necessary command(s) are created for you automatically when you check one of the boxes in the *Simple* tab of *Settings > *Syncers*.  To see what command(s) were created, or to modify commands, click the *Advanced* tab.

In the Advanced view, you can move a command within the sequence by selecting it and typing ⌘↑ or ⌘↓, or by drag and drop.

The *Revert* command is now superfluous in most cases, because current versions of BookMacster are constantly watching open .bmco files and immediately read in any changes they see.  This command is kept for compatibility.


#### Options for *Import* and *Export* Commands

When you select an *Import* or *Export* command, the next *detail* column offers a popup menu in which you select what to do if a web browser which is involved is running, and will not allow BookMacster to read or write its bookmarks as required.

**Cancel.**  The commands (sorting, whatever) will not be performed.  The Syncer will try to run the commands again at the next scheduled time.

**Quit.**  The browser will be asked to Quit.  Normally, it will quit.  But there are many circumstances under which a browser could refuse to quit.  One example is if you have set in the browser's preferences an option to "ask you" if windows or tabs should be closed.  It will display a dialog.  Another example, unexpected, is if the browser has recently been launched and is displaying a "Update is available, do you want me to install it now" message.  Finally, if you start to enter data into a web form, most browsers will display a dialog warning you that the data you have entered will be lost.  In any of these cases, if you are not there to dismiss the dialog, the browser will refuse to quit.

**Force Quit.**  In this case the browser will be asked to Quit, and if it refuses, BookMacster will "kill" it without regard to what dialogs are being displayed.

If BookMacster quits or force-quits a browser, it will automatically re-launch the browser for you after it is done.  Most browsers nowadays have a preference setting to restore your previous windows and tabs, loading all of the web pages currently being displayed.  Thus, with such a preference setting enabled, the Quit option is a good choice if your Syncer is scheduled to run when you are not normally at your computer.  When you return, the job will have run and your browser will be displaying the same web pages as it was before the job started.

## Syncers are *Lazy* <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [syncerLaziness]

Here is what happens after you make a change (adding a bookmark, for example) in a web browser.  In order to not slow down your Mac with frivolous processing, the [Syncer](syncers) does all tasks with the lowest priority available in macOS.

1.  There is a small delay, typically 5-20 seconds, before the change is reported to the [Syncer](syncers).

2.  The [Syncer](syncers) examines the browser's bookmarks and compares with data last imported from that browser to verify that a significant change has been made.  (For advanced readers: Actually, hashes of significant values are compared.)  This takes typically 10-20 seconds.

3.  If changes are warranted, a syncing operation is *staged* to occur.  By default, it is staged to occur after a delay of 60 seconds.  You can change this *Delay before starting to import changes from web browsers* in *Preferences* > *Syncing*, to be 10 seconds, 30 seconds, or 1, 2, 3, 4 or 5 minutes.  The advantage of shorter delays is that you are able to change bookmarks more rapidly in different browsers without conflicts arising.  The advantage of longer delays is less usage of computing resources due to coalescing of syncing operations.  For example, if you have the delay set to 5 minutes, add a bookmark at 10:00, and another at 10:03, only one syncing operation will occur, at 10:05, which will sync both new bookmarks.  But if you have the delay set to 10 seconds, two syncing operations will occur to sync these two bookmarks.  Computing resource usage can start to be significant if you have multiple thousands of bookmarks.

4.  The actual syncing operation is performed by the [Syncer](syncers).  This takes typically 10 seconds for importing plus 10 seconds for each browser that has changes to bne exported, for up to 1500 bookmarks.  It will be longer if you have multiple thousands of bookmarks.

5.  If the syncing operation has exported changes to a browser which is synced to another computer or mobile device via a browser's proprietary syncing service such as *Firefox Sync* or *iCloud*, it will usually take 5 seconds to 5 minutes or more for these changes to appear on your other device.  We have no control over that :)

## Syncers are run by *BkmxAgent* <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [bkmxAgent]

The Smarky, Synkmark and BookMacster application packages include a command-line executable named *BkmxAgentRunner* and BkmxAgent itself invoke as needed.  When you switch on *Syncing*, Smarky, Synkmark or BookMacster, this tool is invoked to "register" BkmxAgent with macOS.  The macOS will in turn launch this app and keep it running in the background.  *BkmxAgent* loads your active [Syncers]() and in turn installs into macOS various notifiers which notify BkmxAgent whenever a triggering event such as a bookmarks change occurs.  The relevant Syncer then runs in BkmxAgent to do the work.  BkmxAgentRunner starts, stops, or reboots BkmxAgent as needed. 

### Testing and Troubleshooting Aids [syncTTAids]

If syncing is not performing as you expect, it is sometimes helpful to be alerted when actions occur, or watch what is happening as it happens.

#### Alerts, Banners and Sounds via macOS Notification Center [agentNotifications]

BookMacster, Synkmark and Smarky can add notifications to your macOS Notification Center.  To control these, click in the main menubar: [application menu](appMenu) > *Preferences*, then the *Syncing* tab and finally the *Notifications…* button.

#### Real-Time Log [agentRealTimeLog]

To *see* [BkmxAgent]() in action, in even more detail, in the [application menu](appMenu) click *Logs* and view the *Logs* tab.  Periodically hit the round *Refresh* button at the top of *Logs* and observe the new entries from [BkmxAgent]().

### [BkmxAgent]() has your File System Permissions

[BkmxAgent]() operations will fail if you do not have permission to access the required data.  For example, when you import or export bookmarks on another [Macintosh User Account]() manually in Smarky, Synkmark or BookMacster, the app requires you to enter an administrator password.  However, [BkmxAgent]() does not know the password, so the operation will fail.

## Clean-Up of Orphaned Syncers <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

Smarky, Synkmark or BookMacster remember the documents in which you have set Syncers.  Each time you launch the app, in the background, it runs through each of these and makes sure that they exist, are not in your Trash, and have not been replaced by a [Online File Syncing Service]() update.    If any of these tests fail, the app removes any of their Syncers.  The same thing happens if [BkmxAgent]() cannot find its document when it tries to run a Syncer.
