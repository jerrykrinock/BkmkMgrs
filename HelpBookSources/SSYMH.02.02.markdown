# Simple Syncers <img src="images/BookMacster.png" class="whapp" /> [syncersSimple]

## Simple Setup

To keep browsers in sync, or to just keep the content of one browser sorted alphabetically, you activate Syncers.  For most users, Simple Syncers suffice.

* Click the tab *Settings* > *Syncing*, then the subtab *Simple*.

* Click the button *Full Syncing*.

  <div class="screenshot">
  <img src="images/SimpleSyncOff.png" alt="" />
  </div>

Four of the checkboxes will switch on.

  <div class="screenshot">
  <img src="images/SimpleSyncOn.png" alt="" />
  </div>

Leaving all four checkboxes on is recommended for most users.  If you want your bookmarks to be sorted (alphabetized), you should also switch ON Checkbox <span style="font-weight:bold; color:red">2</span>.

**If you have no special requirements and want syncing to "just work", you are now done and may go back to the previous page.**

If you want to make sure that BookMacster will sync as you want it to, please read on.

## A Little More Detail

Conceptually, when you switch on these checkboxes, you are enabling *sync operations* to occur whenever your bookmarks are changed.  A *sync operation* commences [0-5 minutes after the change, and is slow and lazy by design](syncerLaziness).  Upon commencement, it typically takes 5-20 seconds total, and consists of three steps…

* Bookmarks changes are read in to your [Collection](), from wherever they happened.

* [Optional] Bookmarks in your Collection are sorted (alphabetized).

* The changed bookmarks [Content](theContentTab) is exported from your Collection to [Clients]() (web browsers and such).

Voila!  All Clients now have the same, changed bookmarks.  These three steps are enabled in various ways by the five checkboxes…

* Checkbox <span style="font-weight:bold; color:red">1</span> tells macOS to watch each of your Clients for which you have switched on the *Import* checkbox in the  [Clients tab]().  Whenever any of their [internal bookmarks]() changes (for example, when you add a bookmark to Safari), after a few minutes, [BkmxAgent]() imports the changes and, if warranted, performs the required sync operation a minute or so later.

* Checkbox <span style="font-weight:bold; color:red">2</span> tells BookMacster to, after an import triggered by Checkbox <span style="font-weight:bold; color:red">1</span>, sort (alphabetize) your bookmarks.  Bookmarks are [ordered in the same way]() as if you had clicked in the menu *Bookmarks* > *Sort All*.

* Checkbox <span style="font-weight:bold; color:red">3</span> tells BookMacster to, furthermore after an import triggered by Checkbox <span style="font-weight:bold; color:red">1</span>, export the changed bookmarks to the web browser Clients for which you have switched on the *Export* checkbox in the [Clients tab]().

**For basic syncing among one or more web browsers on one Mac, you need to leave on at least Checkbox <span style="font-weight:bold; color:red">1</span> and Checkbox <span style="font-weight:bold; color:red">3</span>.**

* Checkbox <span style="font-weight:bold; color:red">4</span> tells macOS to perform a sync operation whenever the Collection file is updated from another Mac, which can occur if you keep the document in a [Online Synced Folder](onlineFileSyncServ).  If such an update never happens, this checkbox has no effect.  If you are planning to sync bookmarks across multiple Macs, and if you made a sketch which has BookMacster on this Mac syncing with BookMacster on other Macs too, you may need Checkbox 4 on.

* Checkbox <span style="font-weight:bold; color:red">5</span> is useful if you plan to [add bookmarks to BookMacster directly]().  It causes an export to occur following each *landing* of a new bookmark.  This immediately syncs the new bookmark to all [Clients]()  and, from there, possibly, to your other devices.

## If you want a Lot More Detail

If you would like even finer-grained control over how and when BookMacster syncs, and additional triggers, such as syncing on a schedule or syncing when you log in, consider using [Advanced Syncers]() instead of these Simple Syncers.

<br />RELATED TOPICS

* [How Syncers Work](syncers) <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />
* [Advanced Syncers](advancedSyncers) <img src="images/BookMacster.png" class="whapp" />
