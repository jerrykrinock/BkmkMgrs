# Open, Save Automatic Actions <img src="images/BookMacster.png" class="whapp" /> [openSaveAutoAct]

SSYMH-PAGE-TOC

In BookMacster, you can configure a Collection to do things automatically when it is opened or saved.  Because all of these actions can be performed manually with a click or two, in our opinion, having them performed automatically is annoying and sometimes causes unexpected results.  We therefore recommend that most users leave all checkboxes discussed below switched OFF.  This feature is retained for some early adopters and former Bookdog users who seem to like them.

You edit the settings discussed in this section in the *Settings* > *Open/Save* tab of a .bmco document which is open in BookMacster.

Note that these settings do not persist if you move the document to another Macintosh account.  Instead, they are [Local Settings]().

## Open after BookMacster launches [openAfterBkmxLaunches]

This is handy if you intend to keep all of your [bookmarks content]() in a single Collection.  To override it and *not* have any document open, hold down the *alt* *option* key on your keyboard while launching BookMacster.

## Auto Import

If this box is checked, the document will [Import from its Import Clients]() immediately upon opening.  This is useful if you would like to keep the document in sync with its Import Clients, without having to remember to Import whenever you open it.

## Sort

You can set a Collection to perform a [Sort operation]() immediately upon opening.

## Find Duplicates

You can set a Collection to perform a [Find Duplicates operation]() immediately upon opening.

## Auto Export

If this box is checked, the document will display a sheet prior to saving or closing if there are unexported changes, giving you a default option to Export to the active [Export Clients]() first.  This is useful if you would like to keep the Export Clients in sync with the document, without having to remember to Export.  This is useful if you would like to keep the document in sync with its Export Clients, without having to remember to Export whenever you save it.

Auto Export only occurs *Save* operations that are commanded manually.  *Save As* operations, *Save As Move…* operations, *Save To* operations, Auto Saves by macOS 10.7 or later, and *Save* commands executed by an [BkmxAgent]() or [AppleScript]() command will not cause an Auto Export.  (Auto Export upon closing prevents unexported changes from not being exported without your approval in macOS 10.7 or later.)

## Overriding Settings

To open a Collection without any of the above prescribed actions being performed, hold down the *option* key on your keyboard as the document is opening.

