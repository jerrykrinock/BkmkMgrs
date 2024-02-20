# Move, Copy, Consolidate <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [taskMoveCopyCons]

## Drag, Drop, Copy Paste

Menu items in the main menu under *Edit* are enabled when you have appropriate candidate item(s) selected.

*Move To >* and *Copy To >* are more convenient than drag and drop for "long distance" moves and copies. 

*Merge Into* is designed for heavy-duty reorganization.  It moves all items of a selected folder into a destination folder, deletes the selected folder (unless it is a [hard folder](), and sorts all items in the destination by name.  To avoid interrupting your view, it does not expand the destination folder.

## Consolidate Folders [consolidateFolders]

Collecting bookmarks from multiple sources collected over a period of years can often leave you

* subfolders with the same name that you desire to be combined into a single folder
* undesired empty folders which you desire to be deleted

Smarky, Synkmark, Markster or BookMacster  can search for such items and automatically perform the desired operations.  To perform this operation, click in the menu: *Bookmarks* > *Consolidate Folders*.  If you have such folders nested inside one another, you may need to perform this operation more than once.  As usual, if the operation results in a less desireable result, you may *Edit* > *Undo*.

Note that our app's definition of duplicate folders is more restrictive than that of a duplicate bookmarks.  To be considered duplicates, folders must (a) have the same parent folder, that is, be siblings of one another and (b) have the same name, where uppercase and lowercase differences are ignored so that, for example, "News" = "NEWS".)  Empty folders are deleted whether they were made empty by the merging, or whether they were empty to begin with.

Note that [merging some duplicate folders](imexMergeFolders) and [deleting some empty folders](imexMergeFolders) is also performed in the normal course of any Import or Export operation, but in this case the merging and deleting are only performed on folders which became candidates as a result of the Import or Export.

