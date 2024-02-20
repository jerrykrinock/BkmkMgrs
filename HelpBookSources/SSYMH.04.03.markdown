# Finding Your Settings <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> 

## Preferences <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> [prefs]

Settings which affect all documents are in the Preferences window.  **Because Smarky, Synkmark and Markster support a single [Collection](), their document settings are all in the *Preferences* window.**

To edit Preferences in the [Application Menu](appMenu) > *Preferences*.  

## Per-Document Settings <img src="images/BookMacster.png" class="whapp" />

Because BookMacster supports multiple documents, it has an additional, per-document level of *settings*.  Controls for these settings are in the *Settings* tab of the document.

<div class="screenshot">
<img src="images/TabSettings.png" alt="" />
</div>

## Local Settings [localSettings]

Some settings, although associated with a document, are more related to its usage in a particular [Macintosh User Account]() or different Mac.  We call such settings **Local Settings**.  Local Settings are not stored in the Collection .bmco file but are stored separately (see below).

If a .bmco file is copied to another Macintosh User Account, either manually or if synced by an [Online File Syncing Service](onlineFileSyncServ) as part of your [multi-device syncing strategy](syncMultiDesign), you will see that these Local Sttings are reset to default or empty values.  You need to set what you want on each Mac.

There are two such groups of Local Settings

### Open, Save Automatic Actions <img src="images/BookMacster.png" class="whapp" /> [settOpenSaveLocals]

[Open, Save Automatic Actions](openSaveAutoAct) are actions you have set to occur automatically when a document opens.  These are only available in BookMacster.

### Synced Browsers or Clients <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" />

These settings control which web browsers or clients are automatically  synced, and how.

* In **Smarky** and **Synkmark**, this is configured in the *Syncing* tab of the *Preferences* window.
* **Markster** does not support synced browsers or clients, so there are no controls.
* In **BookMacster**, relevant settings are in the document window, tabs *Settings* > *Clients* and *Settings* > *Syncing*.

## Technical Note  <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [localSettUnderHood]

Local Settings are stored in a file named *Settings-XXXXXXXX-XXXXX-XXXX-XXXXXXXXXXXX.sql* in ~/Library/Application Support/BookMacster.  For BookMacster, the *XXX* number is the unique identifier you see when you click menu > Bookmarks > Document Information.  For the other apps, you should have only one such file.  If you have more than one, they are probably from BookMacster or discarded documents.  Look at the file modification dates.


