# Verify Bookmarks <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [taskVerify]

SSYMH-PAGE-TOC

## How Verify Works

When you click in the menu: *Bookmarkshself* > *Verify*, or *Bookmarks* > *Verify*, the app presents you with a choice of how many bookmarks to verify,

<div class="screenshot">
<img src="images/VerifySheet.png" alt="" />
</div>

and then begins a process which sends a request to the resource indicated by each of the bookmarks in the Collection.  In accordance with internet protocols, the site responds with either an "OK" or an error message.  By analyzing this response (or lack thereof) and the response from your Mac, the app decides whether or not this bookmark has a high probability of being broken, and if so, formulates a diagnosis and suggested treatment.

### Progress Display [verifyShow]

Detailed progress of a *Verify* operation is shown in the right sidebar which pops out of the Collection window

<div class="screenshot">
<img src="images/VerifyThrottle.png" alt="" />
</div>

Your Mac is capable of handling many internet connections at once; therefore to improve the speed of the operation, the app sends requests for additional bookmarks before receiving responses from the prior one.  Up to sixteen requests may be outstanding in this way.  Actually, a broadband internet connection should be able to handle many more, but we have found that some internet connections will employ [traffic shaping]() if they see a computer visiting sites too quickly, even if the amount of data transacted is minimal, as it is in the app's Verify.  The traffic shaping we have seen is that all additional requests will be summarily ignored for a minute or two; then they turn it on again.  When the app detects all requests failing, it slows down to a very low rate of 1 or 2 per second until responses start appearing again, then accelerates.  Limiting outstanding requests to sixteen limits the number of requests that will be dropped between the time that traffic shaping is applied and the time that the app detects it.

After a first pass, the app performs a second pass, retesting any failed bookmarks at a much slower rate.

### Throttle Adjustment

During the first pass of Verify, you may adjust the rate at which the app sends out its first requests to websites.  The default rate of 20 requests per second (that is, 20 websites per second) works well if you have a single computer on a typical DSL or broadband cable internet connection; typically a thousand bookmarks can be verified in just a few minutes.

At this wicked rate, however, you will notice that the internet bandwidth available to other applications and other computers using the same internet gateway will be reduced.  For example, Safari will load web pages more slowly and multi-player games played over the internet will "lag" until the app completes the first pass of its verify operation. 

To reduce the impairment seen by other applications and users, lower the throttle setting and allow Bookdog more time to verify.

Slower computers will not be able to achieve 50 requests per second of regardless of internet connection; they will simply go as fast as they can.  Also, if you have a dial-up internet connection, you will be able to complete only 2 to 5 requests per second. Although the overall verify time may be increased if the process is frequently waiting due to too many outstanding requests, setting the throttle too high does not affect reliability too much, because Bookdog will retest all non-responding resources in a second pass, done slowly, as described above.

### HTTP Status Code

The first thing the app looks at in a response from a site is the *[HTTP Status Code](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html)*. If a website is working normally, the app this is the number 200, which means *OK*.  Other codes indicate various errors.  The status codes 301 and 302, for example indicate a *redirect*.  They come with a new url to use instead of the old url you have.  Proper protocol is to send a "301" status code if the url has been moved permanently, or "302" if the url is changed temporarily.


### Request Method

For those interested, the *[HTTP Method](http://www.w3.org/Protocols/rfc2616/rfc2616-sec5.html#sec5.1.1)* specified in the request the app sends to each site is *GET*, which retrieves both *header* and *content*.  Theoretically, a *HEAD* method, which retrieves only the *header* should be sufficient.  But we have found that a small number of sites, maybe 2%, respond differently to a *HEAD* request.  To reduce unnecessary of network traffic, the app cancels the request once the header has been received.

### Verify Result for a Bookmark

The app registers as an attribute with each bookmark the [verify status code](verifyStatusCodes) it receives and, possibly, a [redirect URL](http://en.wikipedia.org/wiki/URL_redirection).

## Automatic URL Updates

When a Verify operation concludes or is cancelled, the app takes a second to sift through the results or partial results, and automatically updates the URLs of bookmarks for which a better URL has been found.

### Which bookmarks are automatically updated

Bookmarks which responded with HTTP Status Code 301 ("Permanent Move"), and some of the bookmarks which responded with [HTTP Status Code 302]() ("Temporary Move") are always automatically updated.

A literal reading of HTTP Status Code definitions implies that only bookmarks with HTTP Status Code 301 should be updated.  However, we have found that many sites incorrectly respo and with HTTP Status Code 302 when these moves are in fact permanent. Therefore, the app takes a closer look at bookmarks with HTTP Status Code 302 and classifies them into three categories…

* **Probably Temporary**  URLs which indeed appear to be temporary moves, as the site claims.
* **Probably Permanent**  URLs which look much more like permanent moves.
* **Not Sure**  URLs which score in between the other two cases.

### Update Options for bookmarks returning HTTP Status Code 302

The radio buttons in the rows for [Status Code 302]() allow you to choose how aggressively the app [automatically updates URLs]().  

<div class="screenshot">
<img src="images/ReportsButtons302.png" alt="" />
</div>

In the first row, note that the app never updates URLs which it deems are probably temporary address changes.  In the second row, you tell the app how to deal with bookmarks which it deems are probably permanent address changes.  In the third row, you tell the app how to deal with bookmarks which it is unsure about.

In either case, the choices are:

* leave them alone and report them as being OK
* to [update their URL to the suggested URL]()
* leave them alone and report them as being broken.

You may punch the buttons back and forth because the app remembers what it did and dynamically fixes and un-fixes bookmarks as commanded.

### How URLs are Rotated during Automatic Updating

When the app *automatically updates* a bookmark, its rotates those [three URLs]() such that the *Suggested URL* becomes the *Current URL*, the old *Current URL* becomes the *Prior URL*, and the old *Prior URL* disappears (although it is still available via Edit > Undo).  Saying that in a picture…

&#160; &#160; &#160; &#160; &#160; Suggested ➞ Current ➞ Prior ➞ oblivion

If you *un-automatically update* a bookmark, for example by [changing the disposition of its category in the Verify Report]() so that it is instead treated as *OK* or *Broken*, the opposite happens…

&#160; &#160; &#160; &#160; &#160; Suggested ← Current ← Prior

## Fixing Broken Bookmarks [fixingBrokenBookmarks]

Bookmarks which return a failing [Verify Status Code](), but cannot be [automatically updated]() by the app are *broken*.  To *fix* a broken bookmark, you'll either delete it, change its URL, consolidate it with some other bookmark, etc.

*Broken* bookmarks are summarized in a the columns in *Reports* > *Verify*.

<div class="screenshot">
<img src="images/ShowBroken.png" alt="" />
</div>

To see the list of broken bookmarks, click the magnifying glass button <img src="images/InlineMagGlass.png" alt="" /> next to the total.  This will send you into the [Find Report](), and set up a search predicate to display all of the broken bookmarks which were not automatically updated by the app.

Although that is usually what you want, we note in passing that you can change the predicate at the top to concentrate first on a particular class of failures.  For example, say that you would like to see all bookmarks for which the [Verify Status Code]() is -1003, indicating "Can't find host".  Change the predicate in the FInd Report to this:

<div class="screenshot">
<img src="images/PredVerifyCode-1003.png" alt="" />
</div>

Clicking that magnifying glass will also open the Inspector Panel and open its bottom extension:

<div class="screenshot">
<img src="images/InspectorBottom.png" alt="" />
</div>

The [Inspector panel]() will display data of whichever bookmark is currently selected in the report.  Use the down-arrow key (↓) to step through the results.

Information pertinent to Verify is in the bottom sidebar (aka *bottombar*) of the Inspector.  The top left corner of this bottombar gives you the actual facts that were received.  The top right corner gives you the app's advice, and the bottom shows up to [three URLs]() which the app has for this bookmark, with some buttons to swap and test them.

The *Current* URL is the one that will be exported to browsers and used when visiting within the app.  If the URL labelled *Current* is the one you want, you're done.  If you want one of the other two, swap the one you want into *Current* by clicking one of the *swap* buttons with the circular arrows to the left of the URLs.

If you conclude that the bookmarked page is no longer available, hit the *delete* key to delete the bookmark.

### Reverifying the Unverified

Clicking the gear button <img src="images/InlineGear.png" alt="" /> in the *Unverified* row will initiate another Verify operation, verifying only those bookmarks that are unverified.

## *Don't Verify* Bookmarks

In analyzing the response from a website, the app uses an algorithm based on our experience to determine whether the requested web page is *OK*, *broken*, or *not sure*.  However, in some cases a site which is in fact *OK* may be detected as otherwise by the app.  The app will "learn" about a troublesome bookmark if you check *on* its *Don't Verify*, causing the app to skip over this bookmark during future *verify* operations.  You can set (or un-set) this attribute by viewing its checkbox in a User-Defined column in the [Content View](), or else in the [Inspector Panel]():

<div class="screenshot">
<img src="images/InspectorDontVerify.png" alt="" />
</div>

You can display a list all bookmarks that are marked *Don't Verify* by searching for this attribute value in the *Find/Replace* tab.  There is a button in *Reports* > *Verify* that will configure such a search with one click.

<div class="screenshot">
<img src="images/ReportsDontVerify.png" alt="" />
</div>

Because a bookmark which has been marked as *Don't Verify* will never be verified, it will never have its URL updated by the app, even if the website returns a 301 *Moved Permanently* message. Thus, *Don't Verify* also means "Don't ever update my URL".

## URL Maintainance Tips

### More than one URL seems to work fine!

Often, testing a bookmark which has a 302 "found" or "moved temporarily" redirect, you will find that both the url you now have and the proposed new url take you to the same web page. Should you copy the new one or click *Don't Verify* and continue to use your old one? You must use your judgment. If you see that the domain (the "main" part of the url, for example "sheepsystems.com") has changed, then probably you should copy the new domain. But if you see that the proposed url ends with a question mark followed by something like "?sessionID=7A451E42" (technically called the *query* part of the url), then maybe you should try the new domain but delete the query (the part that begins with the question-mark "?"). In many cases, both urls will continue to work for a long time, so don't spend too much time worrying about it.
		
### Multiple Errors

Sometimes there are multiple errors in urls; for example, it may redirect you to a different url which turns out to not exist either. It takes two Verify/Fix operations to fix this one!  Again, don't worry about these; you'll get them the next time.
		
### Unable to ever get an "error-free" Verify of all bookmarks

Testing, say, 1000 bookmarks, is getting a fairly good sample of the world.  And if only 99% of the world is working properly at any given time, that's going to result in 10 failed bookmarks.  Whether or not they "work" at any given time depends on the internet, and on each webmaster whose site you have bookmarked.  All of these are ever-changing and imperfect. It is interesting to repeat the *Verify* process a second time, but any more than that will be frustrating, possibly resulting in some of the 10 or so failures testing OK, but new failures appearing from among the 990 which were OK the first time.  the app's re-checking of nonresponders is quite effective, but often sites are unavailable for minutes at a time.  That being said, if you believe that the app is consistently reporting bad results for a popular site which is OK, or vice versa, please [contact our Support team](https://sheepsystems.com/support/). We'll investigate and see if we can improve our algorithm.
		
### Load-Sharing Servers

Many web sites are hosted with load-sharing servers (computers) to distribute the traffic load, and these are often indicated in the url with a small number following the server name. For example:

* http://www01.sheepsystems.com
* http://ww3.sheepsystems.com
* http://www4.sheepsystems.com

These are different servers that all handle requests which are distributed to them from www.sheepsystems.com. Any of them may be down, moved or permanently taken out of service at any time. Therefore, when you are adding a bookmark to a site with a server name like this, you should immediately edit its url to indicate instead the "parent" server, which in this example is "https://sheepsystems.com".

Shoppers out there will also often see this with a "store" server, for example:

&#160; &#160; &#160; &#160; http://store2.esellerate.net/store/catalog.aspx?s=STR6837001335&pc=

was one of three "store" servers used by our old distributor, esellerate. The correct url for our store was:

&#160; &#160; &#160; &#160; http://store.esellerate.net/store/catalog.aspx?s=STR6837001335&pc=

The app knows about this problem and ignores "302" redirects to some parallel servers during *Verify*.

