# Visiting + Adding <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [useBkmxOtherApps]

This page describes the features which make Markster and BookMacster available to you, for visiting and adding bookmarks, while web browsers are active.

SSYMH-PAGE-TOC

## *Floating Menu* [floatingMenu]

The *Floating Menu* brings the power of Markster or BookMacster into your web browsers.  There are three ways to access it

* [Global keyboard shortcut](globShorts)

* [Dock Menu]()

* [Menu Extra]()

In the Floating Menu, you can visit a bookmark you have previously stored in a [Collection](bkmxDoc), or *land* a new bookmark to the web page you are currently viewing.

To visit a bookmark, you can use either the *Mini Search* or *Bookmarks Tree*.  To land a new bookmark, you can use either the *Add to* menu item, or the *Add Here* menu items in the *Bookmarks Tree*.

### Using *Mini Search* to visit a bookmark [miniSearch]

* Hit the ↓ key on your keyboard, down to the *Mini Search* menu item.

* Type in a few characters, until the of results is short enough to be navigable.

* Hit the *tab* key, 

* Hit the ↓ key to select the bookmark you want to visit.

* Hit 'return' to visit the site.

<div class="screenshot">
<img src="images/MiniSearch.png" alt="" />
</div>

By default, Mini Search searches bookmark *names* and *tags*, but by clicking the magnifying glass you may remove these and/or add other attributes.

### Using *Add to* to land a new bookmark [addTo] 

* View the page you want to bookmark in a web browser in a web browser.

* Activate Markster's or BookMacster's Floating Menu.

* Hit the ↓ key on your keyboard, down to the *Add [My New Bookmark] to* menu item.  

* Hit the → key.

* Hit the ↓ as needed to select either your Default Landing or one of the Recent Landings in the submenu.  If you want to put the new bookmark in to a different folder which is not listed, choose the first folder in the submenu and we'll fix it later. 

* Hit the 'return' key to create the new bookmark in the folder you have selected.

<div class="screenshot">
<img src="images/AddTo.png" alt="" />
</div>

* If you wanted a different folder which was not listed, re-activate the Floating Menu and select the item *Inspect [My New Bookmark]*, then in the Inspector panel whick appears, under the *Comments*, click the *Move* hyperlink and move the bookmark to its final destination.  This final destination will be added to the Recent Landings, ready for your next use without this extra step.

<div class="screenshot">
<img src="images/InspectorMove.png" alt="" />
</div>

### Using the Bookmarks Tree to add or visit a bookmark [bookmarksTree]

**The Bookmarks Tree is only visible if, in Preferences > Appearance > Floating Menu, the checkbox *Bookmarks Tree* is switched on.  Users who prefer to use the *Mini Search* and *Add to* menu items described above may switch this off to reduce clutter.**

<div class="screenshot">
<img src="images/FloatingTree.png" alt="" />
</div>

#### Visiting [visitFloating]

* Hit the ↓ key on your keyboard, down to the Collection name or Hard Folder (Bar, Menu, etc.) containing the bookmark you want.  (To use the tree, you need to know the [lineage]() of the bookmark.)

* Navigate further into the subfolder containing it by using the arrow keys.  The → key takes you down to the next child level.  The ← key pops you out to the parent level.  The ↑ and ↓ keys navigate up and down the presently-displayed menu.  Note that the → and ← keys do as we said above; they don't necessarily move you to the "right" or "left".  It makes sense after you become accustomed to it.  You can also navigate through the menu using the mouse, but this is not recommended because it's too easy to fall off the edge, which causes the whole hierarchy to disappear and then you need to start all over.

* Once you've reached the desired menu item, hit the 'return' key to visit it.


#### Landing

* View the page you want to bookmark in a web browser in a web browser.

* Activate Markster's or BookMacster's Floating Menu.

* Navigate into the Tree as described in the previous section (*Visiting*), but instead of selecting a bookmark, after you've reached your target folder, select the *Add Here* menu item at the top of the submenu, or else select *… into a new subfolder …* to create a new subfolder.

## Bookmark *Name* and *Comments* are Generated Automatically [autoGenNameComments]

A newly-landed bookmark will have its *Name* set initially to the title of the window in the web browser (which is generally the name provided by the website publisher

If you have selected any text on the web page, the bookmark's *Comments* will may initially be set to your selected text.  (This does not work in all browsers.  It works in Chrome.)


## Landing New Bookmarks via the Menu Items and Toolbar Buttons in Web Browsers [browserWidgets]

Through the magic of [browser extensions](), Markster or BookMacster are able to install a button into some web browsers which send bookmarks directly to Markster or BookMacster.  In Firefox, Edge, Google Chrome, Vivaldi, Opera, Orion, Brave, Canary and [FreeSMUG's Chromium](http://www.freesmug.org/chromium), you can have a *browser action button* which sits to the right of the browser's address field:

<div class="screenshot">
<img src="images/WidgetExtoreChromy.png" alt="" />
</div>

Although there is only one action in these browsers, you can still *Add Quickly* or *Add & Inspect* by using the [option key to control whether or not the Inspector appears.]()

These controls are not installed by default.  To install them, in Markster or BookMacster, click in the [application menu](appMenu) > *Manage Browser Extensions* and use the lower *Button* section.


## Landing new bookmarkss via the *BookMacsterize* Bookmarklet [bookmacsterizer]

The *BookMacsterize Bookmarklet* is not as handy as the [Floating Menu]() and is not recommended for new users.  Also, as of today, 2016 Dec 01, the latest developer beta version of Safari Version 10.0.2 (12602.3.12), presumably slated for macOS 10.12.2, presents a dialog asking the user to approve of the bookmark information being sent to our app *each time this bookmarklet is clicked*.  The [Chrome-ish](chromish) browsers present such a dialog also, but the user only needs to approve once because their dialog has a *Don't ask me again* checkbox.  We've complained to Apple (Bug 29291937 dated 2016 Nov 16) about the lack of a *Don't ask me again* checkbox.

Although it looks like any other bookmark, clicking this bookmark does not visit any site.  Instead, it sends the title of the web page you are visiting, its URL, and any static text which you have selected in the page, to Markster or BookMacster.  The app immediately creates a new bookmark from this information, entering the selected static text into its *Comments* field.

### Creating the *BookMacsterize* Bookmarklet [createBkmxBkmklt]

There are two ways to create a BookMacsterize bookmarklet.

**Install in Browser (Recommended).**  Clicking in the menu *File* > *Install Bookmarklet into ▸* will create a BookMacsterize bookmarklet in the frontmost open Collection if one does not exist, and then export only the BookMacsterize bookmarklet to a selected [Client]() browser.

**Add to Collection.**  One of the menu options under the [+] (Add) button in the upper-right corner of the [Content Tab]() is to add a BookMacsterize bookmarklet.

After you perform an [Export](), this BookMacsterize bookmarklet will appear in the Bookmarks Bar/Toolbar/Favorites (or whatever it is called) in any [locally-installed]() web browser app which you exported to.

### Managing the *BookMacsterize* Bookmarklet [manageBkmxBkmklt]

The URL of the *BookMacsterize* Bookmarklet is a bit of JavaScript which sends the information to Markster or BookMacster.  Modifying this JavaScript may render it no longer functional.

By default, the *BookMacsterize* bookmarklet is placed at the end of the Bookmarks Bar/Toolbar/Favorites, but you may move it to wherever you wish, or you may delete it if you don't want to use this feature.  You can restore a missing or broken *BookMacsterize* bookmarklet by selecting its menu item under the + button in the top-right corner of the [Content View]().

You may also rename it.  For example, to conserve space on your Bookmarks Bar, you may want a shorter name.  The letter "B" works fine.  You might also find a suitable symbol by clicking in the menu *Edit* > *Special Characters*.  We didn't find any that we liked enough to use as default, but here are some you might consider:  ◆ ✸ ✔ β ◉.  Tip: You can copy and paste from here.


## Which browser is used for visiting [doxtusVisitWhich]

However you choose to initiate a visit,

**If the [active application](activeApp) is a web browser**, the bookmark will be visited with that web browser.  This is normally the case if you are browsing the web with, say Safari.  Thus, you can visit any bookmark with any browser at any time by activating the desired web browser before clicking the bookmark.

**If the active application is not a web browser**, the bookmark will be visited with the app's [designated web browser for that bookmark]().  

Thus, if you want to visit a bookmark with your designated web browser for that bookmark, activate any app which is not a web browser (not Safari, not Firefox, not Google Chrome, etc.) before clicking the bookmark.  Note that the latter case always applies if you doubleclick a bookmark in a Collection window, because at that time Markster or BookMacster itself is the active application, and these apps are not web browsers.
