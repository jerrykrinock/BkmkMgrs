# Organizing In Folders vs. Tags

There are two ways of having relationships bookmarks in use by different browser apps, folders and tags.  BookMacster supports both, and also provides methods for translating between the two.

SSYMH-PAGE-TOC

## Folders vs. Tags <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

### Using Folders (with Lineage and Hierarchy)

Most installed web browser applications (Safari, Firefox, etc.) support *folders* of bookmarks, allowing you to keep bookmarks in "parent" folders that can be "grandparent" folders, etc.  In this way, each bookmarks content item has a [lineage]().  The arrangement of folders in the entire bookmarks content is called a *hierarchy*.

### Using Tags

Most online bookmarks storage services (Pinboard, Diigo) do not support a folders. Instead, they allow you to attach *[tags]()*, also called *labels* to each of your bookmarks.

### Using both Folders and Tags

For compatibility, Smarky, Synkmark, Markster and BookMacster supports both Folders and Tags.  Firefox also supports both Folders and Tags.

## Comparison

The advantage of the Folders organization is that you can use simple names which are differentiated by their context.  For example, if you gave all of your "Apple" bookmarks the tag "Apple", you might end snacking on an Apple Computer.  (Actually, it can get alot worse than this.) But with a Folders, it's no problem:

&#160;&#160;&#160;&#160;Computers
<br />&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Apple
<br />&#160;&#160;&#160;&#160;Food
<br />&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Fruits
<br />&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&<br />&#160;&#160;&#160;&#160;&#160;&#160;Apple

However, there are advantages of the Tag organization too.  First, you can reference the same bookmark from multiple contexts.  For example, say you're in the remodeling business and found an article on kitchen sinks.  Do you place it in the folder "Kitchens" or "Plumbing Fixtures"?  In a Tag organizational system, there's no problem - you can give it both tags and you can find it in either case.  Second, using Tags you can share your bookmarks with other people, which is why the services that use Tag organization are called social bookmarking tools.

It's a design decision by the engineers of the browser or service and ultimately a personal, organizational preference.

## Making Tags Work Smarter

One way to solve the problem of tag organization finding fruit instead of computers is to get in the habit of giving each bookmark many tags.  For example, you would Apple computer bookmarks with "apple" and "computer" and apple fruit bookmarks with "apple" and "fruit".  Then when you wanted a snack you could search for bookmarks tagged with "apple" and "fruit".  This would eliminate Apple computer bookmarks.  The web interfaces of web service providers don't provide this, but Smarky, Synkmark, Markster and BookMacster do, with its [Content Filter](contentFilters).  (Select the desired tags in the Tag Cloud at the top and click the double-checkmark button.)


## Translating between Folder and Tag Relationships
				
Smarky, Synkmark, Markster and BookMacster help you to translate bookmarks between applications that use Folder and Tag relationships by [fabricating folders from tags]() and [fabricating tags from folders]() during [import and export]() operations.


