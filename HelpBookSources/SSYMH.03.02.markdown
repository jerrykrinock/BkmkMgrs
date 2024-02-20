# One-Time Import/Exports <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [oneTimeIxports]

This section describes

* The import methods you can use to copy bookmarks which may be in different web browsers, old files, online services, Macs, computers running Microsoft Windows, smart phones, etc. into a Smarky, Synkmark, Markster or BookMacster [Collection]()

* The export methods you can use to copy bookmarks in the other direction.

SSYMH-PAGE-TOC

## Singular Import/Exports <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [imEx1Client]

The *Import from* and *Export to* features provides several facilities for manual imports of bookmarks from a selected source.  To use this, activate a [Collection]()), click the *File* menu, then the desired action.  They're near the bottom.

### Submenu Selections

The items at the top of the menu are the available [browser apps]() which have been found in your Macintosh user account, and those web-based apps which are generally available.

If your target is an XBEL file or other file which is *loose* somewhere on a mounted drive, such as your hard drive, click the submenu item *Choose File (Advanced)* which is at the bottom.

The *Import from* and *Export to* items in the *File* menu allow you to execute one_time imports or exports without adding or configuring a Client.

To import from or export to a loose, standalone file such as an [XBEL](xbel) file that you have exported from another bookmarks managedment application, click the *Choose File (Advanced)* menu item.  Then, take care to properly choose *New File* or *Existing File* at the top of the sheet.

### *Normal* Import/Export versus *Overlay* [ixportOverlay]

#### *Normal* Import or Export

For clients which are not listed in Settings > Clients for the current document, a *normal* import or export will use the default settings for new clients.  In particular, this means that any items not existing in the [source]() will be deleted in the [destination]().  Also, since this is a first import or export with this client, you will not be warned if the operation exceeds the applicable [Safe Sync Limit]().

For clients which *are* listed in Settings > Clients for the current document, a *normal* import or export will use deviate from the defaults, using whatever [advanced settings for that client]() and, for Imports, any [Import Postprocessing]() settings you have set.  In other words, it's just like you had clicked in the menu *File* > *Import from all* or *File* > *Export to all*, except that if the Collection has multiple Clients, only one Client will be involved.

#### Overlay

An *overlay* import or export differs from the normal in that no items in the [destination]() will be deleted.  More precisely, [Delete Unmatched Items]() is OFF.

### Combining Import/Export with Other Operations <img src="images/BookMacster.png" class="whapp" />

If you want to use an Overlay during an Import, but still have unmatched items deleted, you can do this by clicking in the menu: *Bookmarks* > *Delete All Content* prior to importing.  After deleting, you should also visit the *Settings* > [*Structure*]() tab and configure as desired.  Similarly, if you wish to create a file which has only items exported from your Collection, you should export to a *New File*.

## Importing From Loose Files Exported From Other Apps [imexLooseFiles]

Although this is **usually not what you want to do**, our apps also support importing loose files exported from other apps.

* Best results are obtained by importing from the browser directly (*File* > *Import from* > *Browser-Name*).
* Second-best results are obtained by importing a browser's native bookmarks file (*File* > *Import from* > *Choose File (Advanced)* > *Choose File Format*> *Browser-Name*).
* Third best results are obtained via a `.xbel` file exported from another app, as described below.
* As a last resort, use a `.html` file exported from another app, as described below   

Remember that you can always *undo* an import (menu > *Edit* > *Undo Import*).  If you are using BookMacster, you might want to first create a new Collection document (menu > *File* > *New Collection*), import into that, and then copy contents to another Collection.

## Importing `.xbel` Files

You can migrate your bookmarks from *URL Manager Pro™*, *Webnote™*, or *Webnote Happy™* to the app via an XBEL file.  To do this, 

* Launch any of those applications and click in their menu *File* > *Export*.
* Set the *Format* to *[XBEL]()*
* Export to a file.  Verify that the exported file's name ends in the extension `.xbel`.
* Perform a [One-Time Import](imEx1Client), using  *Choose File (Advanced)*, then *Existing File* of *.xbel* format.
* Navigate to and select the `.xbel` file.

## Importing `.html` Files

You can import bookmarks from *.html* files such as those exported by most web browsers.   This file format was developed in the 1990s for Netscape Navigator and is only [loosely described](https://technet.microsoft.com/en-us/windows/aa753582(v=vs.60)).  Results are therefore not guaranteed.  We've designed for `.html` files produced by Firefox 59, Safari 11.1 and Google Chrome 65.0.

* Launch any of those applications and click in their menu *File* > *Export*.
* Set the *Format* to *HTML*.
* Export to a file.  Verify that the exported file's name ends in the extension `.html`.
* Perform a [One-Time Import](imEx1Client), using  *Choose File (Advanced)*, then *Existing File* of *.html* format.
* Navigate to and select the `.html` file.

Our apps require that the file begin with the text `<!DOCTYPE NETSCAPE-Bookmark-file-1>`.  To verify this, open the `.html` file with a text editor app such as *TextEdit*, which Apple puts in your `/Applications` folder.

## Drag+Drop, Copy+Paste [1TimeDDCP]

### *From* Other Apps

In addition to accepting drops and pastes from other Collections,  [Collections]() also accept drags and pastes of plain text from other applications.  The number and attributes of the bookmarks created depends on the occurrences of linefeeds (ASCII character 0x0a) and tabs (ASCII character 0x09) in the dropped or pasted text.  The rules are:

* If the text contains linefeeds, the text after each linefeed will be applied to a new, separate bookmark.

* If the text contains tab(s), the name of a bookmark created will be the text before the tab, and its url will be the text after the tab.

Using these rules, if you have a spreadsheet of bookmarks in OpenOffice *Calc* or Google Docs *Sheets*, with consecutive rows representing bookmarks, a column of bookmark names, and the *next* column of bookmark URLs, a drag+drop or copy+paste of these rows and two columns will create bookmarks with those names and URLs.

### *To* Other Apps [textCopyTemplate]

Typically, other applications paste the *text* representation of whatever is on the clipboard.  Our apps therefore allow you to specify the format of the *text* representation which is copied to the clipboard when you *Edit* > *Copy* items.

To specify this format, click in the app-name menu (*Smarky*, *Synkmark*, *Markster* or *BookMacster*): *Preferences*, then the *General* tab in the *Preferences* window, and enter your desired format into the *Text Copy Template* field.  To specify an attribute in your format, surround the attribute’s name with a pair of curly brackets to form a *placeholder*.  The following attribute placeholders are supported:

{name}
{url}
{tagsString}
{addDate}
{lastModifiedDate}
{comments}
{rating}
{shortcut}

To specify a printable character, such as a comma, just enter it.  To specify a tab character, enter a backslash followed by a *t*: *\t*.

Here are some examples:
 If you want | Enter
:-|:-
 Item’s URL only   | `{url}`
 Item’s name only   | `{name}`
 A Markdown hyperlink   | `[{name}]({url})`
 Tab-separated name and url   | `{name}\t{url}`
 Really verbose   | `My name is "{name}", and my URL is "{url}"`
 
If multiple items are selected, multiple lines, one line for each bookmark, separated by linefeed (ASCII 0x0a) characters, will be copied to the clipboard.

Only representations of bookmarks will be copied to the clipboard.  Folders and separators will be ignored.


<br />RELATED TOPICS

* [Aggressively Normalize URLs](aggressivelyNormalizeUrls)

 
