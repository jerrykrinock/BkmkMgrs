# Upgrade Insecure Bookmarks <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [taskSecurify]

SSYMH-PAGE-TOC

## How *Upgrade Insecure Bookmarks* Works

When you click in the menu: *Bookmarks* > *Upgrade Insecure Bookmarks*, the app will scan your bookmarks, make a list of all those URL begins with the old unsafe <code>http://</code> scheme, and ask your approval to *upgrade* them.  If you approve, it will then perform a first [Verify]() operation on those bookmarks.  It will then perform a second [Verify]() operation on all of those bookmarks whose resources respond, except during the second pass, it will use the secure <code>https://</code> scheme instead.  All of the bookmarks which respond during the second pass will then have their URLs permanently changed to <code>https://</code> scheme.  

The *Upgrade Insecure Bookmarks* operation, therefore, looks like two *Verify* operations.  All of the displays, throttle adjustments, etc. that are available during [Verify]() are also available during *Upgrade Insecure Bookmarks*.

At the conclusion of the operation, the [Reports]() tab opens and shows the results. 

<div class="screenshot">
<img src="images/SecurifyResult.png" alt="" />
</div>

If you want to see which bookmarks were updated, you may click the magnifying glass icon under *Updated*.  It will open the [Find/Replace]() report with an appropriate search predicate.

Note that bookmarks which have been secured by this process will continue to show as *Secured* in the Verify and Find/Replace tabs until the next time it is processed by a regular [Verify]() operation.


