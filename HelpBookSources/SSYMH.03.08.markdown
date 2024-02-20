# Remove URL Cruft <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [cruft]

SSYMH-PAGE-TOC

## Cruft [cruftDefine]

URLs which you arrive at from clicking on links sometimes contain cruft which is not necessary to get you to the page you want.  Often it is there to tell the site operator where you are coming from.  Typically, this cruft is in the *query* portion of the URL, in one or more of the *key=value pairs*, also called *parameters* or *tags*, which comprise the query.  Here is an example:

         <code>utm_source=facebook</code>

This tells a site operator using Google Analytics that you arrived at their site from clicking a link in Facebook.

## Removing Cruft [cruftRemove]

Our apps have a feature which can search for and eliminate specified key=value pairs in your bookmarks.

To use it, click in the menu: *Bookmarks* > *Remove URL Cruft*.  A sheet will appear.  In this first sheet, you list your *Cruft Specifications*.  Each Cruft Specification in the list consists of

* A *key*, which may be either the literal text of a key, or, if you switch on the *treat as Regular Expression* checkbox, a more general pattern in the form of an [ICU Regular Expression](http://userguide.icu-project.org/strings/regexp).

* An optional, single *domain*.  Only bookmarks which visit this domain will be searched for this key.  Normally, you leave this field blank, which causes all bookmarks to be searched.

* An optional *Description*, which is for you to note your purpose of this item for future reference.

To see some examples, or to use several Cruft Specifications which have been requested by other users, click the button *Add Default Cruft Specifications*.

When you click *Search…*, the app will search the bookmarks in the current document for all bookmarks which have any of your specified cruft and, if any are found, display a list of them, names and URLs, in a second sheet.  In the URLs, the *cruft* is highlighted in pink.  Select the bookmarks whose cruft you want to be removed, and then click button *Remove Cruft from Selected Bookmarks*.  The app will remove the cruft, and any associated *?*, *&* or *;* delimiter characters so that the resulting URL is still valid.

If you change your mind, click in the menu: *Edit* > *Undo Remove Cruft*.

Also, when you click *Search…*, your Cruft Specifications will be saved and re-presented the next time that you use this *Remove URL Cruft* feature.