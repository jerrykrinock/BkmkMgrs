# Collection *Structure* [bkmslfStructure]

## What is *Structure* <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

Import and Export [Clients](), and [Collection](bkmxDoc)() Documents, all have what we call a *Structure*, by which we mean:

<ul>
	<li>Which, if any, of the *[Hard Folders]()* are present in the [Root](root).</li>
	<li>What other content item types are allowed in the [Root](root)</li>
</ul>

All Structures have an implicit [Root]() which you could think of as the *great grandmother* from which all bookmarks descend.

Different browsers are designed with different structure.  Here are some examples:

* Safari has a *Favorites Bar* or *Bookmarks Bar*, and its Root accepts soft folders and bookmarks but not separators.  Only Apple can change this.  

* Only Firefox has an Unsorted Bookmarks folder.  Like any *hard folder*, it cannot be deleted or renamed.

* Pinboard has no *hard folders*.  All bookmarks are "loose" in its [Root]().


## Why Structure Matters

During an [Import or Export](), if the structure of the [source]() is different than that of the destination, some items may not be able to be placed at their expected location and must be [mapped]().

## Setting the Structure

In Smarky and Synkmark, the structure is set automatically for you, based on the structures of the browsers you are syncing with.  In Smarky, the structure never changes because only Safari is the only browser supported.

In Markster, the structure is fixed to be the Free Structure described below.

In BookMacster, you can set the structure of a Bookmarkshself document in its *Settings* > *Structure* tab.

### Free Structure [freeStructure]

*Free Structure* means that your document has no [hard folders](), and any item (bookmark, subfolder or separator) can be placed in any folder.

Free structure is used in Markster because there is no need to match the structures of web browsers if you are not syncing to them regularly.

In BookMacster, if you are using the Collection [directly](useDirectly), and do not ever export to web browsers or other [Clients](), you may want to use Free Structure for the same reason.  To do that,

* Activate the document window.
* Switch to the *Content* tab and move all items out of the [Hard Folders]().
* Switch to the *Settings* > *Structure* tab.
* Switch OFF all the checkboxes under *Have these Hard Folders*.
* Switch ON all the checkboxes under *Items Allowed in *[Root]()**.

<div class="screenshot">
<img src="images/StrucFree.png" alt="" />
</div>

### Default Structure <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [autoStructure]

When you create a new [Collection](bkmxDoc)(), Synkmark or BookMacster look at the Import [Browsers (Clients)]() you added during the process and set the structure of the [Collection]() so that any item allowed in any of the importing Browsers or Clients can be placed at the same location in the Collection.  Therefore, no [remapping]() will be required during an Import.  If you have more than one Client, this will give the Collection a liberal structure, meaning that in general remapping will be required during Export operations.

These apps will also change the Structure of an existing Collection if you change the Clients, if its file is not in your [Online Synced Folder](onlineFileSyncServ).  The adjustment when you click out of the [*Clients* tab](settClients) or close the document window, and will be noted in the [Status Bar]().
