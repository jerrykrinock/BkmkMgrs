# Glossary <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

Our glossary includes quite a few standard Macintosh terms, which we were unable to find good definitions for elsewhere.

### ❖ Active Application [activeApp]

macOS allows you to have many applications (apps) running simultaneously, but only one is the *active application* at any time.  The *active application* is the one whose name appears next to the Apple  menu in the upper left corner of your screen.

You can quickly switch to a new active application by holding down the ⌘ key while hitting your *tab* key.

### ❖ Application Menu [appMenu]

The *Application Menu* of a Mac app refers to the first main menu item, after the Apple  menu, at the top left of your menu bar, whose title is the name of the application, in our case *Smarky*, *Synkmark*, *Markster* or *BookMacster*.

### ❖ Browser Apps, *Local* and *Web* [browserApps]

A **locally-installed browser app**, commonly referred to as a [web browser](http://en.wikipedia.org/wiki/Web_browser), is an app installed on your Mac.  The term "desktop app" has been used for this, but "desktop" is now a misnomer since more Macs are actually "laptop".  Examples are: Safari, Firefox, Chrome, Opera.

A **web-based browser app** keeps your bookmarks data on a remote server.  These apps run inside your web browser.  (Note that you never "installed" these applications onto your Mac.)  Examples are: Pinboard, Diigo.

### ❖ Browser Profile [browserProfile]

Some users may prefer to compartmentalize their web browsing, so that they have different sets of bookmarks, history, and other browser app settings for different purposes.  For *[web-based browser apps]()*, this is done easily by creating multiple user accounts.  This feature is also available some *[locally-installed browser apps]()*, in particular  [Firefox](http://mzl.la/LL5Dxl) and browsers in the [Google Chrome family](http://support.google.com/chrome/bin/answer.py?hl=en&answer=2364824).  Of course, in any web browser you get different bookmarks, history, and other browser app settings in each [Macintosh user account]().

### ❖ Built-In Bookmarks [builtInBookmarks]

This refers to the built-in bookmarks storage of a web browser.  This is probably the place where you always put and got your bookmarks before using Smarky, Synkmark, Markster, or BookMacster.  It is what is being synced to when you *Import* to our app or *Export* from one of these apps.  Typically, the built-in bookmarks are accessed by clicking the *Bookmarks* menu of the web browser app, but sometimes part of the built-in bookmarks may be hiding elsewhere, for example, the *Reading List* in Safari.


### ❖ Chrome-ish Browsers [chromish]

*Chrome-ish* refers to a web browser which is substantially built upon the [Chromium open-source project](http://code.google.com/intl/en/chromium/).  Such browsers include: Google Chrome, Google Chrome Canary, Brave, Edge, [FreeSMUG's Chromium](http://www.freesmug.org/chromium), Opera (since version 15), Vivaldi, Orion, Maxthon, Epic, and probably more which may have come and gone by the time you read this!


### ❖ Churn [churn]

When exporting to web browsers, the app must respect each browser's rules regarding what types of items (bookmarks, folders, separators) can be put where, and then when importing, not recognize that any moves made due to these rules should not be re-imported into the Collection.  If this is not done carefully, items can be moved back and forth between two different locations during successive syncs (export + import cycles).  We refer to this as *churn*.

### ❖ Contextual Menu [contextualMenu]

Rather than searching through the Main Menu bar to find one of the commands applicable to a particular item, some application views provide menus that pop up on the item and show only these applicable commands.  To access a contextual menu for an item, click it with a [secondary click]().

<div class="screenshot">
<img src="images/ContextualMenu.png" alt="" />
</div>

### ❖ Devices [devices]

It is fashionable nowadays to use the term *devices* to refer to, collectively,

* Personal computers (including Macintosh computers)
* Tablets (including iPads)
* Smart phones (including iPhones)
* Smart music players (including iPod Touch)

### ❖ Dock Menu [dockMenu]

Application items in your [macOS Dock](http://support.apple.com/kb/HT2474) show a menu when you click them with a [secondary click]().   Secondary-click the app's icon to see its Dock Menu.  Note that an application must be running in order to show the usual items in its Dock Menu.

### ❖ Enabled vs. Disabled Controls [enDisControls]

A control which has a "grayed-out" contrast does nothing when you click on it, because it is *disabled*.  This is in contrast to a control in its normal *enabled* state.

This happens to regular controls such as checkboxes...

<div class="screenshot">
<img src="images/EnDisCheckbox.png" alt="" />
</div>

as well as menu items...

<div class="screenshot">
<img src="images/EnDisMenu.png" alt="" />
</div>

Note that the *enabled* state is independent of whether the control is ON or OFF.  In the first screenshot there, the *Bookmarks Menu* checkbox is *disabled*, although the checkmark indicates that its *value* is ON.

### ❖ Hidden Preference [hiddenPref]

In addition to the options available when you click *Preferences* in an application's *application* menu, some applications have other preferences available to advanced users.  Preferences are hidden because either because we didn't think it was important and thought that our time would be better spent on other stuff, and/or that we thought exposing the option to all users would make the app more confusing to the average user and have a net negative value.  To request a hidden preference, [contact our Support team](https://sheepsystems.com/support/).

### ❖ Identifier [exid]

Most [web browsers](browserApps) attach an *identifier* attribute to each bookmark or folder in their content.  In [Web-based browser apps](browserApps), which do not allow folders nor duplicate bookmarks, this is often a hash of the bookmark's URL.  In any case, the app uses this identifier, whenever possible, to identify this item when syncing as one that has already been synced.  We use identifiers when [merging](mergeBy).  If you need to see the identifiers which the app has stored for an item, show the item in the [Inspector Panel](), hold down the *option* key on your keyboard, and click on the *Export Exclusions* button at the bottom.  The items identifiers will be logged in an entry to your system Console.

### ❖ Internal Bookmarks [internalBookmarks]

All [web browsers](http://en.wikipedia.org/wiki/Web_browser) have a storage place for bookmarks, which we call their *internal bookmarks*, to distinguish them from the bookmarks which are in the Content of Smarky, Synkmark, Markster or BookMacster [Collection](bkmxDoc).  You can view and edit internal bookmarks, for example, in…

* **Safari**.  Activate Safari and click in its menu: *Bookmarks* > *Edit Bookmarks*.   For older versions of Safari, click *Show Bookmarks*, but in current versions *Show Bookmarks* shows an incomplete view in a sidebar, which is not what you want.

* **Chrome**.  Activate Chrome and click in its menu: *Bookmarks* > *Bookmark Manager*. 

* **Firefox**.  Activate Firefox and click in its menu: *Bookmarks* > *Show All Bookmarks*. 

Internal bookmarks may also appear in the toolbar at the top of a browser window in these applications.  This so-called *Bookmarks Bar* or *Bookmarks Toolbar* is *part* of a browser's internal bookmarks.

### ❖ Lineage and Hierarchy [lineage]

The *lineage* of a bookmarks content item is its "location" or "place" in a *hierarchy*, defined by the following sequence:

* The folder it is in, called its *parent*
* The folder that its parent is in, called its *grandparent*
* The folder that its grandparent is in, called its *great-grandparent*
* ...
* The "highest level" folder that its ancestors are in, often a [hard folder]().
* The *root*.

* In Smarky, Synkmark, Markster, and BookMacster, and in bookmarks views in other apps, what you see is an upside-down version of the above list.  The root is at the top; the parent is at the bottom.
* The *root* is not shown in any app.  It is "just there".
* Usually, the sequence is not this long and the above descriptions are combined.  For example, the parent may be a hard folder, and the grandparent may be the root.
* *Lineage* is indicated in the user interface by this icon: <img src="images/lineage.png" alt="" />.

An efficient way to view the hierarchy of items, is using an *outline view* or as we call it, Outline Mode.  The apps use the icon <img src="images/hierarchical.png" alt="" /> to indicate Outline Mode.

If the lineage of bookmarks content items is ignored, viewing them results in a "flat" view, simply a list, or as we call it, Table Mode.  The app uses the icon <img src="images/flat.png" alt="" /> to indicate  Table Mode.


### ❖ Macintosh User Account [macUserAcct]

The Macintosh supports multiple users, keeping all of your documents, settings and personal data, including bookmarks, separated into different Macintosh User Accounts.  The data in each account is stored in a different Home Folder.  If you are the only user of your Mac, you probably have only one Macintosh User Account on it, but computers shared among families or company employees are often configured with one account for each user.  When each person logs into their Macintosh User Account, they see only their own documents, data, settings and bookmarks, from their own Home folder.

A Macintosh User Account can only be on Macintosh computer at one time.  If you regularly use two Macintosh computers, even if they have the same account name in the upper-right corner of the menu bar, you are actually using two different Macintosh accounts *unless* you carry the Home folder around on a portable hard drive or thumb drive and plug it in to whatever Mac you are using.  The account is still only one one Macintosh at a time, but it is portable.

### ❖ macOS Keychain [macOsKeychain]

Although used under the hood by Safari and many applications to securely store passwords, the Keychain is an not-well-understood feature of macOS.  Even Apple itself does not tell us very much about it.  We did find a [good MacWorld article](http://www.macworld.com/article/40403/2004/10/workingmac.html) written back in 2004 by Dan Frakes.

### ❖ Menu Extra [menuExtra]

*Menu Extra* refers to one of the icons you see lined up at the top of your screen, starting at the right side.

<div class="screenshot">
<img src="images/MenuExtras.png" alt="" />
</div>

Technically, Apple uses the  term *Menu Extra* to refer to things installed by Apple apps, which are on the right, and the term *[Status Item](http://developer.apple.com/mac/library/documentation/cocoa/conceptual/StatusBar/StatusBar.html#//apple_ref/doc/uid/10000073)* to refer to the things installed by non-Apple apps, which are more toward the left or center of the screen.  However, they look the same to you the user, so we call ours a *Menu Extra* because we feel this term is much more lucid and specific than *Status Item*.

Menu Extras are handy, but the problem is that space is limited and Apple gives them secondary priority to the Main Menu Bar of the active application, which is displayed starting on the left side.  If the active application's Main Menu has too many items with long names, its Main Menu Bar will collide with the Menu Extras in the middle, and the Main Menu Bar wins.  Menu Extras which do not fit are wiped out.  Therefore, particularly on a laptop or other small-screen Mac, you need to economize and only activate the menu extras which are most useful to you.

Menu Extras are only shown when their application is running, and when running, most apps allow you to turn their Menu Extra ON or OFF in their Preferences Window.  **The control for the app's Menu Extra is in Preferences > General**.  By default, it is OFF.

Like most applications, the app duplicates the content of its Menu Extra in its Dock Menu.  So, if you don't have room for it in your menu bar, you can access the same functions in BookMacter's [Dock Menu]().

### ❖ Nontrivial Attributes [nontrivialAttributes]

A *nontrivial attribute* is any [attribute]() of a bookmarks content item which is not one of the following ***trivial attributes***.

* Add Date
* Expanded
* [External Identifier]() for a Client
* Last Visited Date
* Last Modified Date
* Last Checked Date (may be visible in future version)
* RSS Articles
* Visit Count

Note that an item's *index*, that is, its position among its siblings, is not a trivial attribute.  (If it were, then we would not export the changes when bookmarks are only sorted.)

### ❖ Online File Syncing Service, Online Synced Folder [onlineFileSyncServ]

An Online File Syncing Service is a service that keeps items in a designated folder or folders on your different Macs *synchronized*, which means that any files in this folder that you change on one Mac are, typically some minutes later, or as soon as they wake up, copied to your other Macs.  We refer to such a folder as an Online Synced Folder.  An Online File Syncing Service  also provides a backup for this data, because it is also stored on their servers.  We maintain a [web page showing our current evaluations of such services for our purposes](https://sheepsystems.com/files/products/bkmx/cloudSyncServices/).

Putting your Collection in such a designated folder is [one way to get the same bookmarks on multiple Macs](syncMultiDesign).

### ❖ Orphaned Items [orphanedItem]

An *orphaned item* is a bookmark, folder, etc. which has no parent and therefore no place in a the [hierarchy]() of a the [bookmarks content]() of a [Collection](bkmxDoc)().  It cannot be displayed, and may cause confusion if it matches to incoming items during an [Import]() operation.

### ❖ Rating (stars) [ratingStars]

In the [Inspector]() panel, you can assign a bookmark or folder to have 1-5 *stars*.  Generally, this is to indicate how useful the bookmark is, but you can use it however you want.  By default, items have 0 stars which means that they are *unrated*.

### ❖ Readable Web Browser Application [readableBrowserApp]

A *Readable Web Browser Application* is a web browser from which Markster or BookMacster can extract the current web page to create a bookmark.  The Readable Web Browser Applications are: Safari, Firefox, Google Chrome, Brave, Edge, Orion, [FreeSMUG's Chromium](http://www.freesmug.org/chromium), Canary, and OmniWeb.

### ❖ Secondary Click [secondaryClick]

Performing a *secondary click* on an item brings up its *contextual menu*.  There are several ways to do it.

* With any mouse or trackpad, hold down the *control* key on your keyboard while clicking the primary (or only) mouse button.  This is also called a *control click*.

* With a trackpad, if you have this default gesture enabled, tap the item with two fingers.

* If you have an Apple *Magic Mouse* with *Secondary Click* enabled, tap in your Secondary Click area.

* If you have a multi-button mouse, click with your "secondary" mouse button.  By default, this is the right-side mouse button.

So that we don't have to keep referring to *secondary click or right-click or control-click*, we refer to any of the above using what appears to be Apple's latest term, *secondary click*.

### ❖ Source and Destination [sourceDestin]

In an Import operation, the [Import Client(s)]() are source(s) and the [Collection](bkmxDoc)() is the destination.  In an Export operation, the [Collection](bkmxDoc)() is the source and the [Export Clients]() are destination(s).  

<div class="screenshot">
<object data="images/IxportSourceDestin.svg" type="image/svg+xml">
</object>
</div>

<!-- Notes on SVG:
1.  In order to avoid scroll bars appearing in WebKit browsers, (Chrome, Safari, Apple Help Viewer) you may need to *reduce* the height or width attribute in the svg output from Sketch.app.
2.  In the .svg file, for Firefox 4.0 beta, in the first line the XML version must be 1.0, not 1.1.  Otherwise you get an error message instead of the image. -->

### ❖ Status Bar [statusBar]

The *Status Bar* is the line of text and sometimes other controls which is along the bottom of the app's document window.

<div class="screenshot">
<img src="images/StatusBar.png" alt="" />
</div>

After an [Import]() or [Export]() operation, the numbers *+*, *Δ*, *↖*, *↕* , and *-* indicate the how many changes of each [type of change](imexChanges) occurred in the destination as a result of the operation.

### ❖ Nonsyncing Syncer  [nonSyncingSyncer]

In BookMacster, in the tab *Settings* > *Syncing* > *Advanced* it is possible to create a syncer which does neither [import]() nor [export]() with any [clients]().  That is, none of its [Commands]() is an *Import* or *Export* command.

### ❖ Tag Delimiter [tagDelimiter]

For historical reasons, in [browser apps]() which support tags, you enter the tags into one long text field, and therefore there must be a character which you type to signal the end of one tag and the beginning of another tag.  We call this character the *tag delimiter*.

For Pinboard and iCab, the tag delimiter is the space character, " ".  This means that if you want a tag which is more than one word, you must connect the words by something other than a space.  For example, *computer software* is no good but *computer-software* will work.

For Firefox, the tag delimiter is a comma, ",".  For Smarky, Synkmark, Markster, or BookMacster, you can set the tag delimiter to one of several choices in *Preferences* > *General*, and you may override this choice for any [Collection](bkmxDoc) in the tool *Settings*, tab *General*.  In a Collection which syncs with only one tab-supporting Client, you may want to set the tag delimiter to the same tag delimiter which is used by that Client.

For Diigo, the tag delimiter character is, effectively, the doublequote character, """.  But they do it a little differently; tags are doublequoted.  Diigo does other weird character replacements too.

### ❖ Tag Delimiter Replacement [tagDelimiterReplacement]

A problem arises when syncing between Clients that use different tag delimiters – tags may be merged together or split apart.  Smarky, Synkmark, Markster, and BookMacster solve this problem by replacing delimiter characters found within tags by your preferred *Tag Delimiter Replacement*.  You specify this in *Preferences* > *General*.  By default, it is the underscore character.  For example, when you support the tag *computer software* to Pinboard, it will be exported as *computer_software*.

### ❖ Tags [tags]

*Tags* are phrases that you may attach to bookmarks to aid in searching later, as explained in this [Wikipedia article](http://en.wikipedia.org/wiki/Tag_(metadata)).

### ❖ Trace [trace]

As a verb, to log the processing actions verbosely, that is, with more entries than the normal Log you see when you click in the menu [application menu](appMenu) > *Logs…* > *Messages*.  As a noun, the text file which is written to your Desktop containing the trace entries.  This can be useful in troubleshooting problems.  To produce a trace file during an Import or Export operation, hold down the *shift* and *option* keys on your keyboard while the operation is beginning.  Keep them held down until you hear the *Submarine* alert sound.

### ❖ Traffic-Shaping Policies [trafficShapingPolicies]

*Traffic Shaping* is the set of programmed rules or algorithms by which servers on the internet which serve content, or routers within the internet, may choose to delay, sometimes infinitely, transmission of packets or entire requests for data.  For reasons which the reader can surmise, there seems to be not much information available publicly on this topic.  Again, the best starting point may be a [Wikipedia article](http://en.wikipedia.org/wiki/Traffic_Shaping).


### ❖ Tooltip [tooltip]

macOS provides *tooltips*, helpful explanations that appear in small borderless windows when you hover your mouse over items that the app designer felt needed more explanation for new users, without cluttering the view for experienced users.

<div class="screenshot">
<img src="images/TooltipSample.png" alt="" />
</div>

(Prior to macOS 10.10 Yosemite, the rectangle was yellow instead of gray.)

The idea is that new users will set their mouse over a confusing item, then stop and scratch their heads for a few seconds.

How macOS decides when you're doing this is a little more complicated and rather inscrutable, and this is sometimes frustrating.  If you really want a tooltip for an item, first make sure that the item's window is active.  Then put your mouse over it and let go.  Wait 5 seconds.  If nothing appears, move your mouse away, bring it back, let go and wait another 5 seconds.  If nothing appears after the second try, the item probably does not have a tooltip.

If your subject is a control in a table, hover over the column heading which names the control, rather than the row in the table.


### ❖ Unsaved Changes Dot [unsavedChangesDot]

The left side of the title bar in a Macintosh document window has three buttons: red, yellow and green.  The red one closes the window when clicked, but also indicates if the document has unsaved changes, with a black dot at its center.  If you attempt to close a window when the black dot is present, you will be asked whether or not to save the unsaved changes.


### ❖ Untyped Item [untypedItem]

An *orphaned item* is an item in the [bookmarks content]() of a [Collection](bkmxDoc)() which does not have enough attributes to be properly displayed, because we don't even know if it is a bookmark or a folder.

### ❖ XBEL File Format [xbel]

The [XML Bookmark Exchange Language (XBEL) file format](http://xbel.sourceforge.net/) is a mechanism by which Smarky, Synkmark, Markster or BookMacster can import and export its content with other bookmarks management applications which also support XBEL.  XBEL supports folders and hierarchy.  It also supports the following item [attributes](): name, URL, comments, date added, last modified date and last visited date.  In addition to these officially supported attributes, the app is able to import [tags]() and comments which are kindly exported by Webnote™.

