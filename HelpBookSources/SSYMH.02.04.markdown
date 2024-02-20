# Settings to use BookMacster *Directly* <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [settUseDirectly]

This section highlights the preferences and other settings which are particularly relevant when setting up Markster, or setting up to [use BookMacster *Directly*](useDirectly).

SSYMH-PAGE-TOC

## Your *New Bookmark Landing* [newBookmarkLanding]

When Markster or BookMacster create a new bookmark via one of its Firefox menu item, toolbar buton in Chrome, or BookMacsterize Bookmarklet, it is initially placed in the folder designated as your *New Bookmark Landing*.  To change a *New Bookmark Landing*,

* If you have Markster, in the menu click *Markster* > *Preferences*, then click the *Adding* tab.
* If you have BookMacsterster, in the toolbar click *Settings* > *General*.

You will see a popup menu.

<div class="screenshot">
<img src="images/NewBkmkLand.png" alt="" />
</div>

**Which Collection?**  BookMacster lands a new bookmark into whatever Collection you have open, asking you to choose one if you have more than one, or none, open.

## Dock Menu [bkmxDockMenu]

The [Dock Menu]() is one of three facilities in Markster and BookMacster which you may use to display its [Floating Menu](), which in turn provides capabilities to *land* new bookmarks and *visit* existing bookmarks.  To show the Dock Menu, perform a [secondary click]() on the app's icon in the Dock.

<div class="screenshot">
<img src="images/BkmxDockMenu.png" alt="" />
</div>

No setup is necessary.  All running Macintosh applications show a Dock Menu, unless they are in the background.

## Menu Extra [bkmxMenuExtra]

The [Menu Extra]() is another of the three facilities you may use to display the [Floating Menu](), which in turn provides capabilities to *land* new bookmarks and *visit* existing bookmarks.  The Menu Extra is not displayed by default.

<div class="screenshot">
<img src="images/MenuExtras-Bkmx.png" alt="" />
</div>

To display the Menu Extra whenever Markster or BookMacster is running,

* Click in the menu: *BookMacster* > *Preferences*.
* Click the tab *Appearance*.
* Under *Menu Extra*, deselect *(None)* by instead selecting the image you would like to see in your menu bar.

Note that if you have enabled the app's [Launch in Background](backgrounding) preference, you must have either a [Menu Extra](bkmxMenuExtra) or [Global Keyboard Shortcut](globShorts) to the [Floating Menu]() enabled.  (Otherwise, you would have no way to ever interact with the app!)  **The *(None)* selection may be disabled for this reason.**

## Global Keyboard Shortcuts [globShorts]

Markster and BookMacster offer three keyboard shortcuts which can create, search for or visit a bookmark while you are working in any [readable web browser application](readableBrowserApp).  The three shortcuts

* Bring forth the powerful [Floating Menu](floatingMenu)
* Add a bookmark quickly
* Add a bookmark and bring forth the Inspector panel, in which you can add and change the new bookmark's location and other attributes

These keyboard shortcuts are not active by default.  To activate or de-activate them,

* Click in the menu *Markster* or *BookMacster* > *Preferences* and 
* Click the *Shortcuts* tab.

<div class="screenshot">
<img src="images/PrefsShortcuts.png" alt="" />
</div>

* To add a keyboard shortcut, click in its text field, hold down the desired modifier keys and then type the desired character key.

If you enter a keyboard shortcut which conflicts with a keyboard shortcut in a [readable web browser application](), your Markster or BookMacster keyboard shortcut will over-ride the web browser's keyboard shortcut.  If Markster or BookMacster will not accept your keyboard shortcut, that is probably because the shortcut is in use by macOS.  To review those settings, click in your menubar:  > *System Preferences*, then the *Keyboard* tool, then the *Keyboard Shortcuts* tab.

Since many web browsers use ⌘D to create a new bookmark, we recommend using ⌘D as your keyboard shortcut for *Add Quickly*, so that you can add a bookmark to your Collection in the same way as you added a bookmark to your web browser before you began using Markster or BookMacster.  ⌘⌥D is our preference for *Add & Inspect*, but in order to use it you must switch off the shortcut to *Turn Dock Hiding On/Off* in  > *System Preferences* > *Keyboard* > *Keyboard Shortcuts* > *Launchpad & Dock*.  (As an alternative to that, we're fans of *Automatically hide and show the Dock* in  > *System Preferences* > *Dock*.)

* To remove a keyboard shortcut, click the little ⓧ at the right edge of its text field.

These shortcut keys are available (they "work") whenever a [readable web browser application]() is the [active application](activeApp), and Markster or BookMacster are running in some form – [launched in the background]() or window(s) are [minimized to the Dock]() are OK.

## New Bookmark Landing Sound [landingSoundFx]

Markster and BookMacster plays a the sound of a page ripping out of a book when landing a new bookmark, and two quick beeps when landing a duplicate bookmark.  The sound may be silenced with a checkbox in *Preferences* > *Adding*.

## Popping up the Inspector for a Newly-Landed Bookmark [landingInspection]

When adding a bookmark, in some cases you're in a hurry or don't want to break your concentration.  In other cases, you want to stop, compose a good name, add tags and notes, and/or place the bookmark in its proper folder.  BookMacster allows you to do it either way, at any time.  In the first case, you're done in one click.  In the second case, the [Inspector]() opens on the new bookmark wherein you can edit and move it.

If you are using the [Add Here menu item], or have the [BookMacster Button]() installed into a browser, or the [BookMacsterize Bookmarklet]() in any browser, whether or not you get the Inspector depends on whether or not you're holding down the *option*/*alt* key on your keyboard.  To set which is which, click in the menu *BookMacster* > *Preferences* > *Adding*

<div class="screenshot">
<img src="images/PrefsAddingOpt.png" alt="" />
</div>

(If you use the BookMacsterize Bookmarklet in Firefox, you must hit the option key quickly *after* clicking the bookmarklet, because holding down the *option* key prior to clicking any bookmark or bookmarklet seems to activate the *Save As* feature in Firefox.)
