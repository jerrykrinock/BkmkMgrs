
# Bookmarks, Folders and Separators <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [itemsAndAttributes]

A [Collection](bkmxDoc)(), and all supported browser apps, can contain several types of items: *bookmarks*, *folders*, and *separators*.  We refer to these item types collectively as *bookmarks content items*, or just *content* ...

SSYMH-PAGE-TOC


## Bookmarks

A bookmark is a reference to a URL on the internet.  Besides the URL, a bookmark can have several other attributes such as its name, tags, comments (description), shortcut key, [lineage](), and various statistics.  What we call a *bookmark* is called *url* in Pinboard.

## Hard Folders

Although they can look similar other folders, most web browsers have two or three of what we call *hard folders*.  Like the hardware inside your computer, you cannot change the name or location of a hard folder by typing with your keyboard or clicking with your mouse.

To replicate what you see in your web browser, a [Collection]() has *hard folders*.  You can recognize the *hardness* because their names are displayed in *italics*, as shown here:

<div class="screenshot">
<img src="images/HardFolders.png" alt="" />
</div>

A Collection may have zero, one, two, three or four hard folders.  Hard folders are present or absent in a document, depending on its [structure]().

In order to [map]() content items during [Import and Export]() operations, Smarky, Synkmark, Markster or BookMacster needs to identify equivalences between its own *hard folders* and those of web browser apps.  The table below shows the mappings.

The Hard Folders displayed in the app are named to match the name of the Hard Folder in the first of the document's [Browsers (Clients)](clients) which has such a folder.  In case that no browser (client) has a Hard Folder corresponding to a given Hard Folder existing in the app, the app defaults to these names: *Favorites Bar*, *Other Bookmarks*, *Reading List*, and *My Shared Bookmarks*.

<table cellpadding="7" rules="rows">
	<tr valign="bottom">
		<td align="left" width="*"><b>Possible Name as displayed in Smarky, Synkmark, or BookMacster</b></td>
		<td align="left" width="20%"><b>Favorites Bar</b><br />or<br /><b>Bookmarks Bar</b></td>
		<td align="left" width="20%"><b>Other Bookmarks</b></td>
		<td align="left" width="20%"><b>Reading List</b><br />or<br /><b>Unsorted Bookmarks</b></td>
		<td align="left" width="20%"><b>My Shared Bookmarks</b></td>
	</tr>
	<tr valign="bottom">
		<td><i>The original idea behind this hard folder</i></td>
		<td><i>Appears in the toolbar (near the top) of windows</i></td>
		<td><i>"Overflow" which cannot fit in the toolbar</i></td>
		<td><i>A special place to quickly drop new bookmarks which you will put in a better place, later.</i></td>
		<td><i>A special place for bookmarks that will be shared with other people.</i></td>
	</tr>
	<tr valign="top">
		<td>Brave, Chrome, Canary, [FreeSMUG's Chromium](http://www.freesmug.org/chromium), Epic</td>
		<td>Bookmarks Bar</td>
		<td>Other Bookmarks</td>
		<td>-</td>
		<td>-</td>
	</tr>
	<tr valign="top">
		<td>Edge</td>
		<td>Favorites Bar</td>
		<td>Other Favorites</td>
		<td>-</td>
		<td>-</td>
	</tr>
	<tr valign="top">
		<td>Firefox</td>
		<td>Bookmarks Toolbar</td>
		<td>Other Bookmarks</td>
		<td>Unsorted Bookmarks</td>
		<td>-</td>
	</tr>
	<tr valign="top">
		<td>iCab</td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
	</tr>
	<tr valign="top">
		<td>OmniWeb</td>
		<td>Favorites</td>
		<td>Personal Bookmarks</td>
		<td>-</td>
		<td>My Shared Bookmarks</td>
	</tr>
	<tr valign="top">
		<td>Opera</td>
		<td>Bookmarks Bar</td>
		<td>My Folders</td>
		<td>Unsorted Bookmarks</td>
		<td>Speed Dial</td>
	</tr>
    <tr valign="top">
        <td>Orion</td>
        <td>Favorites</td>
        <td>Bookmarks Bar</td>
        <td>-</td>
        <td>-</td>
    </tr>
	<tr valign="top">
		<td>Safari</td>
		<td>Favorites Bar</td>
		<td>-</td>
		<td>Reading List</td>
		<td>-</td>
	</tr>
	<tr valign="top">
		<td>Vivaldi</td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
	</tr>
	<tr valign="top">
		<td>Delicious, Diigo, Pinboard</td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
		<td>-</td>
	</tr>
</table>

## Soft Folders

In contrast to the Hard Folders, we speak of *Soft Folders* as the regular folders you create in Smarky, Synkmark, Markster or BookMacster or in a web browser app.  For example, folders named *News* or *Vacation Ideas* are *soft folders* that you've created.  In contrast the hard folders, you may rename, move or delete *soft folders* as you wish.

## Separators

*Separators*, also called *separator lines*, are little "fences" that may be placed between groups of items that are still in the same parent folder.

<div class="figure">
<img src="images/Separator.png" alt="" />
</div>

## Attributes

Attributes are the charactertistic of bookmarks and other [content items]().  For example, some of the attributes of Bookmarks Content items are: name, url, shortcut, tags, comments, date added, visit count.

Although most attributes are self-explanatory, in this section we explain those that are not…


### Three URLs [threeUrls]

There are three URLs which Smarky, Synkmark, Markster or BookMacster store for a bookmark:

***Current URL*** is the URL that would currently be used if you clicked *[Visit]()*, and the URL that would be passed to a Client during an Export.

***Suggested URL*** is likely a better, newer one which Smarky, Synkmark, Markster or BookMacster has received, usually as the result of a redirection from the website, during a Verify operation.

***Prior URL*** is just a holding place for a URL that was replaced, in case you want to revert to it later.

You can see all three URL of a selected bookmark by opening the Inspector panel and [opening its bottom sidebar](inspecSidebarsMenus).

<div class="screenshot">
<img src="images/ThreeURLs.png" alt="" />
</div>

Clicking one of the buttons on the left will swap the indicated URL values.

Clicking one of the buttons on the right will [visit]() the site addressed by the adjacent URL.


### Text Color

In the [Inspector Panel](), next to the name of the subject item is a rectangle called a *color well*.  After clicking this color well, you can set the text color which used is to display the item's name in the [Content View](), [Menu Extra](), and [contextual menus]().  This attribute is not supported by any [clients]() and is therefore not exported.  It is for your use within Smarky, Synkmark, Markster or BookMacster only.

### Will be Sorted

This attribute sets explicitly whether or not a *particular* folder will be sorted [when sorting is done]().  In addition to the checkbox in the [Inspector](), this is also indicated by the folder's [background color and symbol in the Content Tab]().


### *Verify* Status Codes

The response from a website to a request for a bookmark's URL normally contains an *HTTP Status Code*, which is usually a positive integer between 100 and 599, although some creative cowboy webmasters sometimes return their own made-up status codes, usually in the range 600 to 999.

However, "lower level" errors can occur if the site does not send an HTTP response.  These lower level errors are returned to Smarky, Synkmark, Markster or BookMacster by macOS and contain "error codes" in Apple's NSURLErrorDomain.  The codes in NSURLErrorDomain are negative numbers.

Fortunately (maybe because Apple planned it this way), there is no overlap between these positive and negative values.  Therefore, Smarky, Synkmark, Markster or BookMacster stores in its Verify results for a bookmark what we call a *Verify Status Code*.  Quite simply, if this value is positive, it's an HTTP Status Code, and if negative, it's an error code in the NSURLErrorDomain.

#### Verify Status Codes for Positive Values (HTTP Status Codes)

Most of the HTTP status codes you will see are defined in [Section 10 of Internet Society's specification HTTP/1.1](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html).  But although it was published in 1999, this document still has not been ratified into a standard, and in the meantime additional codes have been proposed.  For a readable and more complete table of the HTTP status codes in use at this time, we recommend this [Wikipedia article](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes).


#### Verify Status Codes for Negative Values (NSURLErrorDomain)

The following is derived from the file NSURLErrorDomain.h, but we've published them here since you will not have that file unless you have installed Apple's Developer Tools, and also we added the narrative descriptions.

<br />
<table cellpadding="5" >
<tr valign="bottom"><td width="50"><b>Code</b></td><td><b>NSURLError:</b></td><td><b>Means that connection failed because:</b></td></tr>
<tr><td>-999</td><td>Cancelled</td><td>it was cancelled.</td></tr>
<tr valign="top"><td>-1000</td><td>BadURL</td><td>it has a bad URL.</td></tr>
<tr valign="top"><td>-1001</td><td>TimedOut</td><td>it took longer than the timeout which was alotted.</td></tr>
<tr valign="top"><td>-1002</td><td>UnsupportedURL</td><td>it has an unsupported URL.</td></tr>
<tr valign="top"><td>-1003</td><td>CannotFindHost</td><td>the host could not be found.</td></tr>
<tr valign="top"><td>-1004</td><td>CannotConnectToHost</td><td>the host would not let us establish a connection.</td></tr>
<tr valign="top"><td>-1005</td><td>NetworkConnectionLost</td><td>we established a connection but it was lost.</td></tr>
<tr valign="top"><td>-1006</td><td>DNSLookupFailed</td><td>domain name server (DNS) lookup failed.</td></tr>
<tr valign="top"><td>-1007</td><td>HTTPTooManyRedirects</td><td>we received too many redirects from the server while processing the request.</td></tr>
<tr valign="top"><td>-1008</td><td>ResourceUnavailable</td><td>the requested resource is not available.</td></tr>
<tr valign="top"><td>-1009</td><td>NotConnectedToInternet</td><td>this computer appears to not have an internet connection.</td></tr>
<tr valign="top"><td>-1010</td><td>RedirectToNonExistentLocation</td><td>we were redirected to a nonexistent location.</td></tr>
<tr valign="top"><td>-1011</td><td>BadServerResponse</td><td>we got a bad response from the server.</td></tr>
<tr valign="top"><td>-1012</td><td>UserCancelledAuthentication</td><td>the user cancelled when asked for authentication.</td></tr>
<tr valign="top"><td>-1013</td><td>UserAuthenticationRequired</td><td>user authentication is required.</td></tr>
<tr valign="top"><td>-1014</td><td>ZeroByteResource</td><td>the requested resource contains no data.</td></tr>
<tr valign="top"><td>-1015</td><td>CannotDecodeRawData</td><td>we could not decode the raw data.</td></tr>
<tr valign="top"><td>-1016</td><td>CannotDecodeContentData</td><td>we could not decode the content.</td></tr>
<tr valign="top"><td>-1017</td><td>CannotParseResponse</td><td>we could not parse the response.</td></tr>
<tr valign="top"><td>-1100</td><td>FileDoesNotExist</td><td>the requested file does not exist.</td></tr>
<tr valign="top"><td>-1101</td><td>FileIsDirectory</td><td>the requested file is in fact a directory.</td></tr>
<tr valign="top"><td>-1102</td><td>NoPermissionsToReadFile</td><td>we lack sufficient permissions to read the requested file.</td></tr>
<tr valign="top"><td>-1103</td><td>DataLengthExceedsMaximum</td><td>the length of the requested data exceeds the limit.</td></tr>
<tr valign="top"><td>-1200</td><td>SecureConnectionFailed</td><td>we could not establish a secure connection.</td></tr>
<tr valign="top"><td>-1201</td><td>ServerCertificateHasBadDate</td><td>the server's SSL certificate appears to have expired.</td></tr>
<tr valign="top"><td>-1202</td><td>ServerCertificateUntrusted</td><td>the server's SSL certificate is not trusted.</td></tr>
<tr valign="top"><td>-1203</td><td>ServerCertificateHasUnknownRoot</td><td>the server's SSL certificate has an unknown root.</td></tr>
<tr valign="top"><td>-1204</td><td>ServerCertificateNotYetValid</td><td>the server's SSL certificate is not yet valid.</td></tr>
<tr valign="top"><td>-1205</td><td>ClientCertificateRejected</td><td>the server rejected our client certificate.</td></tr>
<tr valign="top"><td>-2000</td><td>CannotLoadFromNetwork</td><td>we could not load from the network.</td></tr>
<tr valign="top"><td>-3000</td><td>CannotCreateFile</td><td>we could not create a file.</td></tr>
<tr valign="top"><td>-3001</td><td>CannotOpenFile</td><td>we could not open a file.</td></tr>
<tr valign="top"><td>-3002</td><td>CannotCloseFile</td><td>we could not close a file.</td></tr>
<tr valign="top"><td>-3003</td><td>CannotWriteToFile</td><td>we could not write to a file.</td></tr>
<tr valign="top"><td>-3004</td><td>CannotRemoveFile</td><td>we could not remove a file.</td></tr>
<tr valign="top"><td>-3005</td><td>CannotMoveFile</td><td>we could not move a file.</td></tr>
<tr valign="top"><td>-3006</td><td>DownloadDecodingFailedMidStream</td><td>decoding the downloaded data failed in midstream.</td></tr>
<tr valign="top"><td>-3007</td><td>DownloadDecodingFailedToComplete</td><td>decoding the downloaded data failed to complete.</td></tr>
</table>

### HTTP Status Code 302

HTTP Status Code 302 should be returned by a website when there has been a temporary redirect that should not be used permanently.  For example, you may have a bookmark to the *Hooterville News* newspaper with the url

&#160; &#160; <code>http://www.hootervillenews.com/todaysHeadlines</code>

This URL takes you to today's headlines.  However, you won't get there directly.  In response, today, their server will send back a response with HTTP Status Code 302, including a *redirect* to the url:

&#160; &#160; <code>http://www.hootervillenews.com/headlines/2009_07_16</code>

which will give you the headlines for today, July 16.  Your browser then visits this redirect URL and renders its data instead of the URL you asked for.

Now. if you click on that same bookmark tomorrow, you will again get a 302 response but will be redirected to a different url:

&#160; &#160; <code>http://www.hootervillenews.com/headlines/2009_07_17</code>

which will give you the headlines for tomorrow, July 17.

This example illustrates the *correct usage* of the 302 status code by the *Hooterville News*.

Note that, in this case, you would *not* want to update your bookmark to point to the redirected url, because if you did, you would be reading July 16's headlines forever.

### Last Modified (Date)

*Last Modified* is an attribute supported by Firefox, Smarky, Synkmark, Markster or BookMacster.  It is imported or exported to Firefox during an Import or Export operation.

Smarky, Synkmark, Markster or BookMacster update the *Last Modified* of an item whenever any of its [nontrivial attributes]() are changed.  In addition, the app updates the *Last Modified* of a folder whenever it gains or loses a child item.  Therefore, when you move an item from one folder to another, although the Last Modified date of the item itself (or any of its descendants, if it is a folder) is not changed, the *Last Modified* date of the old and new parent folders are set to the current date and time.

As practiced by Firefox, *Last Modifed* is the last time that any of the bookmark's attributes such as Name or Comments (Description) were modified.  Moving the bookmark does not count as a change in attributes, and neither does changing tags (probably because Firefox considers 'parent' and 'tags' to be 'relationships' and not 'attributes').  Note that the *Last Modified* attribute has to do with the bookmark itself and not with the bookmarked website.  That is, *Last Modified* does *not* change when the site's webmaster changes the content of the site.

Finally, note that, as of Firefox 3.5, the *Last Modified* attribute, although updated as noted above, is not visible in Firefox itself.

### Export Exclusions

Bookmarks and folders have an attribute which allows you to exclude the from being exported to selected [Clients]().  To access these switches, activate the [Inspector]() and click the *Export Exclusions* sidebar button near the bottom.  Checkboxes for all Clients are on by default.

To use this feature,

* Open the Collection which is doing the syncing in Smarky, Synkmark, Markster or BookMacster.
* In the Content View, select any bookmarks, or folders of bookmarks, that you don't want exported to all browsers.  We'll call these the *excluded items*.
* If the Inspector is not showing, click in the menu: *Window* > *Show Inspector*.  The Inspector panel will appear.
* Click the Export Exclusions button at the bottom of the Inspector panel.
* In the sidebar which appears, switch off the checkbox(es) for whatever browser(s) you don't want the excluded items exported to.
* Back in the document window, verify that one of the little Export Exclusions icons has appeared next to the targetted bookmarks and folder(s).

<div class="figure">
<img src="images/excluded.png" alt="" />    or    <img src="images/excludedDs.png" alt="" />
</div>

Now, the next time you do a normal export, the excluded items will be removed from the browsers whose checkboxes you switched off, and will not re-exported until you switch them back on.

Note that *Export Exclusions* are attributes of the bookmark or folder and are not *[Local Settings]()*.  That is, if your Collection is synced to or copied to other Macs, the same exclusions will apply to the same Clients (and all of their [profiles](browserProfile)).

### Item Quality

When [deleting all duplicates]() or [consolidating folders](), Smarky, Synkmark, Markster or BookMacster must decide for you which item to keep and which item to delete.  As explained, in those sections, it retains the item with higher quality.  Generally, items are compared two at a time to determine which has higher quality.

* If the items are folders and one has more children than the other, the one with more children has higher quality.
* Otherwise, if the items are bookmarks and one has more tags, the one with more tags has higher quality.
* Otherwise, if one has schemes *http* and one has scheme *https*, the one with scheme *https* has higher quality.
* Otherwise, if one is buried deeper in the [hierarchy]() than the other (that is, has a longer [lineage]()), it has higher quality.  Why?  As one user pointed out, "If I buried it deeper, I must have thought longer about it."
* Otherwise, if both of the items have a Last Modified Date, and if one is newer by more than 5 minutes, it has higher quality.
* Otherwise, if at least one of them has Comments, and one has longer Comments, it has higher quality.
* Otherwise, if the names of the two items have different lengths, the one with the longer name has higher quality.
* Otherwise, if one of them has been marked with the *Don't Verify* attribute and the other has not, the one marked *Don't Verify* has higher quality.


