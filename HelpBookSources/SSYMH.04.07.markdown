# Browser Extensions <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [browserExtensions]

Firefox and the *extensible* [Chrome-ish](chromish) browsers: Google Chrome, Opera, Vivaldi, Chrome Canary, Brave, Edge, Orion, and [FreeSMUG's Chromium](http://www.freesmug.org/chromium), have some hooks into which BookMacster *adds on* its own software components which empower it to work more intimately with these browsers.  The software components which we provide to hook into them are called browser *Extensions*.

SSYMH-PAGE-TOC

## Purposes of Browser Extensions [addonPurposes]

There are four purposes fulfilled by our *Browser Extensions*:

1.  <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> Empower Synkmark, Markster or BookMacster to export bookmarks content to, and for some browsers, Import bookmarks content from, the browser app while it is running.

2.  <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> Notify [BkmxAgent]() when you have changed (added, deleted, moved, or updated) a bookmark or folder in the browser's [built-in bookmarks](), signalling us to import then and then export to other browsers' built-in bookmarks.

3.  <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> provide the title and current URL in the web page you are viewing to BookMacster or Markster when you click the [Floating Menu](floatingMenu), [Menu Extra (Status Item) in the menubar](bkmxMenuExtra), or [Dock Menu](bkmxDockMenu).  This is only used for Firefox, Opera and Vivaldi.  (Safari, Google Chrome, Canary, Brave, Edge, Orion, and [FreeSMUG's Chromium](http://www.freesmug.org/chromium) provide an AppleScript facility which we used instead.)

4.  <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> provide a **Toolbar Button** *in the browser* by which you can add new bookmarks directly to Markster, or a BookMacster Collection.  They look like this

<div class="screenshot">
<img src="images/WidgetExtoreChromy.png" alt="" />
</div>

Purposes 1 and 2 support Synkmark, or [using BookMacster for syncing](useSync).
Purposes 3 and 4 support Markster, or  [using BookMacster *directly*](useDirectly).

## *BookMacstser Sync* and *BookMacster Button* Extensions [addOnComponents]

Referring to the *Purposes* described above,

* The *BookMacster Sync* extension fulfills purposes 1, 2 and 3.
* The *BookMacster Button* extension fulfills purpose 4, and if *BookMacster Sync* is not installed, it will fulfill purpose 3.

For Synkmark, you only install the *Sync* extensions.  For Markster, you only install the *Button* extension.  For BookMacster, you may install neither, either or both, depending on your usage.  The *Button* extension has a smaller resource footprint than the *Sync* extension.

## Management of Browser Extensions [addonInstall]

The first time you command an [import]() from or [export]() to a web browser supporting an extension while it is running in the importing or exported [profile](),  Synkmark, Markster or BookMacster will install the extension components which will make quitting the browser unnecessary in future such imports or exports.  You must make two or three mouse clicks to "approve" the installation.  The browser app will guide you through this.

When **installing** an extension, it is important that you use click the *Install* button in the *Manage Browser Extensions* function in our app.  If you bypass this and go directly to the browsers *web store*, the extension may not be configured correctly.

### *Manage Browser Extensions* window

Synkmark, Markster and BookMacster provides an interface to "manually" **install**, and test browser extensions.  To access it, click in the [application menu](appMenu) > *Manage Browser Extensions*.

In this window, the notation *(Loaded)* means that the extension is installed in the profile, and that the browser is running, in this profile.  The current version of Opera (2024-Feb) does not support multiple profiles.  Firefox does, but prefers to run in one profile at a time.  Google Chrome, Chrome Canary, Vivaldi, Brave, Edge, Orion and [FreeSMUG's Chromium](http://www.freesmug.org/chromium) can be running multiple profiles in different windows, each with its own extension loaded, or not, and once an extension is *loaded*, it will stay loaded even if all of its windows are closed.  Thus, clicking the *Refresh* button and noting whether extensions are *(Loaded)* and *(Not Loaded)* is the only true method to determine the current state of Sheep Systems' Extensions in a given profile.

The *More Tests…* button at the bottom of the window exposes a test which gives an accounting of the [browser profiles]() in use, and also provides a little monitor which indicates whenever bookmarks change notifications are issued by our Sync extensions.  This test may help determine the problem if you think Synkmark or BookMacster is not syncing when bookmarks changes occur in these browsers, but the *Test* buttons indicate OK.  (This type of problem is often caused by a mixup in browser profiles.)

### In the Web Browser

In addition to the *Manage Browser Extensions* window in Synkmark, Markster or BookMacster, you can also observe, control the status of and **uninstall** our two extensions in the web browser.  Launch the browser, and click in the main menu: *Help*, then in the search field type *Add-Ons* (for Firefox) or *Extensions* (for other browsers).

## Updates [addOnUpdates]

In order to add new features, fix bugs, or maintain compatibility, just like Synkmark, Markster or BookMacster, although less often, our browser Extensions are occasionally updated to a new version.  Although the details of the update process are different for each browser, all of them update automatically, without your intervention.

## Technical Details – What is Installed [addOnTech]

The files that comprise our browser Extensions are all installed into your Home's Library.

### Extension Files

The basic extension files themselves are installed in <code>~/Application Support/</code>, in the subfolder and possibly in a profile subfolder for the browser.  Please refer to your browser's documentation to learn how they store extensions.

### Special Manifest Files

When you install one of our extensions, it also installs a *special manifest file* in the NativeMessagingHosts subdirectory of the browser's application support directory, for examples…

  * Brave: <code>~/Library/Application Support/BraveSoftware/Brave-Browser/NativeMessagingHosts/com.sheepsystems.chromessenger.json</code>
  * Brave Beta: <code>~/Library/Application Support/BraveSoftware/Brave-Browser-Beta/NativeMessagingHosts/com.sheepsystems.chromessenger.json</code>
  * Chrome, Brave, Brave Beta, Opera(*): <code>~/Library/Application Support/Google/Chrome/NativeMessagingHosts/com.sheepsystems.chromessenger.json</code>
  * Edge: <code>~/Library/Application Support/Microsoft Edge/NativeMessagingHosts/com.sheepsystems.chromessenger.json</code>
  * Edge Beta: <code>~/Library/Application Support/Microsoft Edge Beta/NativeMessagingHosts/com.sheepsystems.chromessenger.json</code>
  * Edge Dev: <code>~/Library/Application Support/Microsoft Edge Dev/NativeMessagingHosts/com.sheepsystems.chromessenger.json</code>
  * Chrome Canary: <code>~/Library/Application Support/Google/Chrome Canary/NativeMessagingHosts/com.sheepsystems.chromessenger.json</code>
  * [FreeSMUG's Chromium](http://www.freesmug.org/chromium): <code>~/Library/Application Support/Chromium/NativeMessagingHosts/com.sheepsystems.chromessenger.json</code>
  * Firefox: <code>~/Library/Application Support/Mozilla/NativeMessagingHosts/com.sheepsystems.chromessenger.json</code>
  * Orion: <code>~/Library/Application Support/Orion/NativeMessagingHosts/com.sheepsystems.chromessenger.json</code>
  * Vivaldi: <code>~/Library/Application Support/Vivaldi/NativeMessagingHosts/com.sheepsystems.chromessenger.json</code>

(*) Oddly, the Brave and [Opera browsers uses Google Chrome's special manifest file](https://forums.opera.com/discussion/comment/15244396#Comment_15244396).

### Chromessenger

Both of our extensions communicate with Synkmark, Markster or BookMacster via our *Chromessenger* helper tool, which resides in the Synkmark, Markster or BookMacster application package.  When you launch a browser with either of our extensions installed, it launches one Chromessenger process for each User Profile into which either of our extensions is installed.  This process will continue running as long as the extension is loaded and browser is running.

### Obsolete Components

Until Synkmark/Markster/BookMacster version 2.3 (April 2017), we installed a *Sheep Systems Sync Extension* and *Sheep Systems Menu Extension* into Firefox.  Firefox now uses the same *BookMacster Sync* and *BookMacster Button* extensions that the other browsers do.  (The *Button* extension replaces the *Menu* extension.)  If you see any *Sheep Systems Sync Extension* and *Sheep Systems Menu Extension*, you should remove them.

Until Synkmark/Markster/BookMacster version 2.0.3 (November 2015), *BookMacster Sync* version 21 and *BookMacster Button* version 13, inclusive, our two extensions were installed as [External Extensions](http://developer.chrome.com/extensions/external_extensions.html).  Google no longer allows External Extensions in Chrome for macOS.  If you see any of these old or older versions of our extensions in Chrome, you should remove them.

Prior to Synkmark/Markster/BookMacster version 1.22.9 (July 2014), our [Chrome-ish](chromish) browser extensions required an NPAPI Plugin, installed at

&#160;&#160;&#160;<code>~/Library/Internet Plug-Ins/SheepSystemsNPAPIPlugin.plugin</code>

It is not used by versions 1.22.9 or later of our apps, and these versions will delete it upon launching.  If you find any *SheepSystemsNPAPIPlugin.plugin* , you should delete it.

