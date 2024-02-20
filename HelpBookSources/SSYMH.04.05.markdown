# Visiting Bookmarks <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [visit]

The main menu and contextual menus in Smarky, Synkmark, Markster, and BookMacster contain *[Visit]()* menu items which visit bookmarks when clicked.

You can also visit items by doubleclicking them in the document window, and [visit from the app's Floating Menu](visitFloating).

If you want Smarky, Synkmark, Markster or BookMacster to remain the active application, hold down the *option* key as you click this menu item.  (This does not work when using the keyboard shortcut ⌘K.  That is, ⌘⌥K does not work.)

## Designated Web Browser [designatedBrowser]

The *designated web browser for a bookmark* depends on several factors.

At the lowest level, which operates *per bookmark* is the *Visit this bookmark with:* attribute in the Inspector panel.

<div class="screenshot">
<img src="images/VisitWith.png" alt="" />
</div>

We'll explain the two bottom choices:

***Your Default Browser (whatever)*** Your [Macintosh User Account]() has a *default* browser set to use in opening links from other applications, such as Smarky, Synkmark, Markster or BookMacster.  Selecting this option tells the app to use that *default* browser.

(To change your default browser, activate Safari, then click menu *Preferences* > *General* and find *Default web browser*.  More info is available in this [Apple article](http://support.apple.com/kb/HT1637).)

macOS may sometimes not behave as expected.  If you have more than one copy of your default browser installed, the Mac OS sometimes gets confused and defaults to using Safari instead.  Also, if your default browser is on another disk drive, it will show in this menu as *(Unknown)*, even though it will probably work correctly.

***Use Document Default Settings*** Selecting this option tells BookMacster to use the browser that you have set as default.  In Smarky, Synkmark and Markster, this is in Preferences > General.  In BookMacster, you set this per each Collection in each document's *Settings* > *General*.

To summarize: By default, BookMacster visits bookmarks with your macOS Default Web Browser, but you have fine-grained control down to the level of a single bookmark if you want to use it.


