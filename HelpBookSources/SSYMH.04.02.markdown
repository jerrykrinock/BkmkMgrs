# Navigating Your Content <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [theContentTab]

The *[Bookmarks Content]()* of a Collection is the bookmarks, folders and separators, all with their own [attributes]() and all arranged in a [hierarchy]() which can mimic (exactly, if desired) the arrangement of bookmarks you see in a web browser such as Safari or Firefox.  The content is displayed in the *Content Tab* of the document window.

SSYMH-PAGE-TOC

## Content View [contentView]

<div class="screenshot">
<img src="images/ContentView.png" alt="" />
</div>

The main (right) pane of the window shows a representation of the Collection's content in either Outline Mode or Table Mode.  In Table Mode, folders are shown at the bottom, and separators are not shown.

The Mode Switch at the upper left has two positions.

* <img src="images/hierarchical.png" alt="" /> *Outline Mode* shows all items, with their [lineage and hierarchy]().  

* <img src="images/flat.png" alt="" /> *Table Mode* omits [Hard Folders](), [Soft Folders](softFolders), and [separators]().  It shows bookmarks only, ordered alphanumerically by name.  Because it does not show the hierarchy, this type of view is also called *flat*.

In either view, items have contextual menus.  To access a menu of available actions available for an item, [secondary click]() the item.

To select multiple items, hold down the *shift* key to extend a  selection contiguously, or click with the ⌘ key down to add individual items discontiguously.

A notation such as this…

&#160; &#160; &#160; &#160; **(99§ 888▐)**

means that the document or folder contains, in this case, 99 subfolders and 888 bookmarks in all of its descendants.

## If you don't like folders popping open… [shiftSpringLoaded]

To prevent folders from springing open as you drag items across them, hold down the *shift* key on your keyboard as you begin the drag (or as you enter the Content View from another window).

## Tags View [tagsView]

<div class="screenshot">
<img src="images/TagsView.png" alt="" />
</div>

On the left side of the Content tab is the Tags View, which  shows the aggregate of all of the the [tags](), if any, attached to the Collection's bookmarks, in a box called a *tag cloud*.  The number [in square brackets] after the tag's name indicates the number of bookmarks in the Collection which have this tag.  The Tags View is ordered alphanumerically starting at the top left.

**If you don't use tags, feel free to grab the little window divider handle to the right of the Tags View and slide it all the way to the left.**

## Filtering to Find Selected Content [contentFilters]

There are two *filters* in the Content tab which filter the contents of the Main Content View, showing only those which meet your search criteria in *both* of them, if activated.

For more advanced searches, click to the *Reports* > *[Find/Replace]()* tab.

### Tags Filter

<div class="screenshot">
<img src="images/ContentFilterTags.png" alt="" />
</div>

Operation of the Tags Filter is [described in the section on *Tagging*](tagFilterInTagsView).


### Text Filter (Quick Search) [textFilterOrQuickSearch]

<div class="screenshot">
<img src="images/ContentFilterText.png" alt="" />
</div>

The Text Filter is the *Quick Search* field in the Toolbar.  The Text Filter is activated automatically when you type any characters into it, and deactivated when you delete all the characters in it.  The latter can also be done by clicking the little <img src="images/ContentFilterTextX.png" alt="" /> on the right.

Clicking the <img src="images/ContentFilterTextMag.png" alt="" /> magnifying glass icon on the left brings up a small contextual menu with several sections…

**Search for** Section.  In this section, you select the type of items which will be allowed to appear in the Main Content View.  Clicking the items checks them (turns them on) or unchecks them (turns them off).  Checking on *Bookmarks* allows bookmarks to appear, checking on *Folders* allows folders to appear, and checking on both of them allows both bookmarks and folders to appear.

**Search in** Section.  In this section, you select the attributes which will be search for the matching text you have entered into the search field.  Again, clicking the items checks them (turns them on) or unchecks them (turns them off).  For example, if you type in "Orange" and check on *Name* and *Tags*, then only items with containing the text "orange" in either their Name or Tags will appear in the Main Content View.  The text filter is case-insensitive, meaning that you'd also find items containing "oRAnGe".

## Tags Popover

Clicking the button with the tags icon exposes a popover in which you can view and edit the  *[tags]()* of the item(s) selected in the Content.

##  Lineage View

To the right of the Tags button is a line of text which gives the *[lineage]()* of the item(s) selected in the Content.

## Moving items Across Collections <img src="images/BookMacster.png" class="whapp" />

In this section we discuss a *move* of items as opposed to a *copy* of items.  The difference is that when items are *moved*, they are removed from their original location.

There are two ways to do this:

* Drag and drop without holding down the *option* key
* Using the *Move to* contextual menu item

In accordance with [Apple Human Interface Guidelines](http://developer.apple.com/mac/library/documentation/UserExperience/Conceptual/AppleHIGuidelines/XHIGDragDrop/XHIGDragDrop.html#//apple_ref/doc/uid/TP30000364-TPXREF30), *moving* items in this way from one Collection to another does not delete it from the source Collection.  It is actually a *copy* operation.


<br />RELATED TOPICS

[Editing tags](tagging)

