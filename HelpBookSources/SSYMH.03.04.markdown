# Sort (Alphabetize) <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [taskSort]

<div class="screenshot">
<img src="images/MenuSort.png" alt="" />
</div>

SSYMH-PAGE-TOC

## Sorting means "Putting in Alphanumeric Order"

Unfortunately, the word "sort" has two similar meanings in English:

* To arrange data in a prescribed sequence or order
* To separate, classify or group things into *groups*

For our purposes, *Sort* employs the first meaning, in particular, to *arrange items in alpha-numeric order*.  Our Engineering Department wanted to use a less ambiguous term, *orderize* or *alphanumericalize*, but our English Department hit the roof upon hearing of that proposal.  Since *order* is ambiguous also (being both a noun and a verb), we decided to go with our Marketing Department's recommendation and call it *sort*, like other apps do.

## *Persistent* vs. *View* Sorting [persVsViewSort]

A major function of Smarky, Synkmark, Markster and BookMacster is to sort bookmarks *persistently*, which means that if you close and then reopen a document, or export your bookmarks to a web browser, the sorted ordering will still be sorted.  This is different than immediately sorting your *view*, which does not affect the underlying data.  For example, when you click a column header in the macOS Finder, you can sort by the attribute displayed in that column, but this does not affect the arrangment of the files on your disk.

Smarky, Synkmark, Markster and BookMacster also offer *view* sorting, but only in the Content View when it is in [Table Mode](), and only in [Find/Replace]() results.  Furthermore, where we have the handy popup menus in the column header for changing the attribute displayed in the column, instead of clicking anywhere in the column header, to accomplish sorting or flip the order upside down, you click the *sort control* at the right edge of the header.  The *sort control* which is currently active is thick and blue.

<div class="screenshot">
<img src="images/ViewSortControls.png" alt="" />
</div>

**The remainder of this page discusses *persistent* sorting.**

## Sorting Boundaries

Sorting never moves items from their current folder; it only re-orders items within folders that are sorted.  Also, sorting will not move items across a [separator]().

## *When* Sorting is done

Sorting is done when you click in the menu *Bookmarks* > *Sort All*.  It may also done when a sync operation or BookMacster Syncer is triggered.  Sorting is *not done* when you set the *[will be sorted]()* or *[sort this folder]()* attribute of an folder; that only sets it up for sorting *the next time* that sorting is done.

## *Which* Items are Sorted [sortWhich]

In the Main Content View, a folder's [icon indicates whether or not it is set to be sorted]() the next time that [sorting]() occurs.  The app provides several mechanisms by which you can these settings.

### Individual Folder Settings [whichSortIndividual]

For the most fine-grained control, you may set explicitly whether or not individual folders will be sorted.  To do this, select the folder and then either

* Type the keyboard shortcut ⌘7, or
* Secondary-click and select the desired setting in the contextual menu, or,
* Show the [Inspector Panel](), and set the desired value in the popup menu...

<div class="screenshot">
<img src="images/InspectorDoSort.png" alt="" />
</div>

### Aggregate Settings [whichSortAggregate]

In BookMacster, settings which affect sorting of all folders are in the *Settings* > *Sorting* tab of a Collection.  In Synkmark, Markster and Smarky, these settings are in *Preferences* > *Sorting* > *Which folders will be sorted…*.

<div class="screenshot">
<img src="images/WhichSorted.png" alt="" />
</div>

#### Sort the Root

The Collection has an implicit *[root]()* folder, the parent of all items.  Some [Clients]() accept and display the order in which the app exports the items in root, and therefore whether or not the root is sorted makes a difference.  Since the root item does not appear in the Main Content View, it cannot be selected and set explicitly as described above.  The *Sort the Root* checkbox provides this function.

#### For folders not explicitly set...

Since you would not want to explicitly set the "Do" or "Don't" sort attribute on hundreds or thousands of folders, the three radio buttons at the bottom allow you to set default values for these attributes.

## Specifying Sort Order [sortHowOrder]

The app provides several several settings by which you can specify the order in which a Collection's folders are sorted.

### Forcing Items ↑ ↓ [sortTopBottom]

[Content items]() have a *Sort at…* attribute which you may edit to *Top*, *Bottom* or *Normally* (the default setting).  Setting this attribute to *Sort at Top* will add an attribute to the selected item(s) which will cause them to be sorted to the top of their folder, regardless of their name.  *Sort at Bottom* is similar, for the bottom.  *Sort Normally* sets it to be sorted in normal alphanumeric order.

The *Sort at Top* and *Sort at Bottom* values are only available if you have set your your *[Sort by]()* setting for this document to *[sort by name]()*, because otherwise these tags would have no effect.

The *Sort at…* attribute can be set by selecting the item and clicking the desired setting in the *Edit* menu, in some contextual menus or, like all attributes, in the [Inspector Panel]().

<div class="screenshot">
<img src="images/InspectorSortAt.png" alt="" />
</div>

### Ignoring Prefixes

A checkbox in a Collection's Settings > Sorting tells the app that you want certain prefixes, for example "The " or "Home Page of " to be ignored.

This checkbox is only enabled when bookmarks are [sorted by *name*]().

If you check this box, the app will look at the prefixes in the list given in Preferences > Sorting, and ignore these prefixes if they are found at the beginnings of names when sorting bookmarks by name.  (Note that, because the list is in the Preferences, for BookMacster, it applies to all Collections.)

<div class="screenshot">
<img src="images/PrefsSorting.png" alt="" />
</div>

For example, the entry *A* in the list will cause a bookmark named *A Big Bad Hockey Team* to be sorted with other bookmarks whose names begins with *B* instead of those whose names begin with *A*.
		
Checking the box at the end of an entry tells the app to append a space character to the entry. This is usually desired; otherwise, for example, entering the word "A" would cause the name "Apple" to appear with names beginning with the letter *p*. However, it is not usually desired when omitting a url-type prefix, such as "http://www", as indicated in the default prefixes. (You could get the same effect by putting a space after the entry, but the checkbox is easier to see and understand.)
		
This feature can lead to unexpected results if more than one prefix in the list matches a name!  If one prefix "contains" another, you should put the longer one first, because the app parses the list from top to bottom.


### Sort *by…*

Although items are normally sorted by name, the app can also sort by URL, according to a Collection Setting…

<div class="screenshot">
<img src="images/SettingsSortBy.png" alt="" />
</div>

#### by *Name*
		
When you add a bookmark to a site in a web browser, you are prompted to give it a *name*. The default *name* is the title of the page which is provided by the site. For example, the title of Apple's iTunes page is "Apple - iTunes".  The name is also what appears in the Bookmarks Menu.  Most people use this default option.
		
#### by *entire URL*
		
The *entire url* (uniform resource locator) is the "address" which appears in Safari's address bar, for example "http://www.apple.com/itunes".  Note that this method sorts firstly by the *scheme*, which is the first "word" in the url, which in this example is "http". This method will typically sort with all "ftp" bookmarks first, then all "http", then all "https:".
		
#### by *domain, host, path*
		
If you choose *domain, host, path*, the app reverses the URL, sorting firstly using the *top-level domain* (TLD). If the TLDs are the same, it then sorts by *2nd-level domain*, then *3rd-level domain*, then *4th-level domain*, etc.
		
If the app finds more than one bookmark in a subfolder with the same *host*, it then parses the *path* to determine the order among them. (The *path* identifies the file on the remote host which is sent when you click on the bookmark.)
		
There may be other keys following the *path*, such as *password* and *query*.  The app ignores these other keys.
		
If you have not been giving good names to your bookmarks, you may want to sort by *domain, host, path* until you get things straightened out.

#### by *Rating (stars)*
		
Sorting by [Rating (stars)]() will sort items with more stars in their rating before siblings with fewer stars.

### Secondary and Tertiary Sorting

Particularly when sorting by Rating (stars), more than one item in a folder may have the same attribute (same number of stars, for example).  When this happens, the app sorts those items using other attributes, in this order, until all such ambiguities are resolved…

* Type, putting folders above bookmarks
* Name
* Rating (stars)
* An internal unique identifier

Because that last attribute is guaranteed to be unique, repeatedly sorting the same items always gives the same result.
		

### Folders ↑↓ Bookmarks

At the bottom of *Settings* > *Sorting* is a control which can set folders to be sorted above bookmarks, or vice versa...

<div class="screenshot">
<img src="images/SettingsSortAbove.png" alt="" />
</div>

This attribute is only editable when bookmarks are sorted by *name*.

Here is an example of a folder sorted with *Folders above Bookmarks*:

<div class="screenshot">
<img src="images/FoldersAbove.png" alt="" />
</div>

Here is the same folder sorted *mixed*:
		
<div class="screenshot">
<img src="images/Mixed.png" alt="" />
</div>

Here is the same folder sorted with *Bookmarks above Folders*:
		
<div class="screenshot">
<img src="images/BookmarksAbove.png" alt="" />
</div>

## Keeping bookmarks sorted automatically [sortAgent]

The app can keep your bookmarks in a browser such as Safari sorted automatically.  To set this up,

### in Smarky or Synkmark <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> [sortAgentSmrkySynkmk]

Click in the menu: *Preferences*, click the *Sorting* tab and switch on the checkbox…

<div class="screenshot">
<img src="images/SortDuringSyncs.png" alt="" />
</div>

### in BookMacster <img src="images/BookMacster.png" class="whapp" />  [sortAgentBookMacster]

[Add the browser as a Client](settClients), and then in the *Settings* tab, > *Syncers*, switch on the *Sort* checkbox number <span style="font-weight : bold; color:red">2</span>.

In the very simple case of only one web browser Client on one Mac, *Settings* > *Syncers* should look like this…

<div class="screenshot">
<img src="images/SimpleSyncLocal.png" alt="" />
</div>

If your document is using [Advanced Syncers](), add *Sort All* before *Export* in the *Commands* table.


## Web Apps Cannot be Sorted <img src="images/BookMacster.png" class="whapp" />

[Locally-installed web browsers]() such as Safari store bookmarks in the order in which you (or BookMacster) arrange them.  However, [web apps]() such as Pinboard do not.  Therefore, exporting sorted bookmarks BookMacster to a web app does not affect the order in which the web app will display them when you log into your account in their web app.

