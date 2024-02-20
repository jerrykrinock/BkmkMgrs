# Acknowledgements

SSYMH-PAGE-TOC

## Beta Testers

Our sincere thanks to the following people who contributed feedback, many of whom persisted with great patience, during the Beta Test of BookMacster, between November 2009 through May 2010.  

* [Alexander Hoffmann](http://www.mangochutney.me "Visit Alexander Hoffman") in Trier

* Andreas Zeitler of [macOS Screencasts](http://www.macosxscreencasts.com) in London

* Andrew Lyles of New York, New York ("Say it twice, we're kinda slow")

* [Bradley MacDonald](http://functionswitch.net) of Chevy Chase

* Charles WJ in France

* Mr. D. Wright of Wasilla, Alaska

* Eric O'Brien of Possibility Engine in Seattle, USA

* [Faisal N. Jawdat](http://faisal.com/)

* Mr. Frank H. Wu of San Francisco

* Guy Kawasaki of [Alltop](http://alltop.com/all), Palo Alto

* John M. Knapp, LMSW, of Knapp Family Counseling in  Malone, NY

* [Leo Marihart](http://marihart.org/leo/) of Lemoore, California, USA

* [macmystic](http://www.macmystic.com) in Venezuela

* Mads Vestergaard in Copenhagen

* Mark Dymek of Mark's Computer Repair in Boston, MA

* [Mike Harris](http://wcitymike.tumblr.com) in Chicago

* Nic Giannandrea of Visalia, CA

* [Nikolaos Anastopoulos](http://www.ebababi.net/) in Greece

* Rick Mathes of [Egoscue - Austin](http://austin.egoscue.com) in Austin, TX

* Roland Schama of Seven Hills, OH

* Steve Mayer in Aloha, OR

* Steven Wickliffe of Evanston

* Tedkl

* Yoni Blumberg of Northfield, MN

* and a couple dozen others who contributed anonymously


## Open-Source Code

* The *bmco* document file is based on our fork of [BSManagedDocument](https://github.com/karelia/BSManagedDocument), developed by Sasmito Adibowo of [Basil Salad Software](https://basilsalad.com), Mike Abdullah of [Karelia Software](http://karelia.com), and others.

* [Graham Cox](http://apptree.net/about.htm "Visit Graham Cox") wrote and published the [GCUndoManager](http://apptree.net/gcundomanager.htm "Visit GCUndoManager") which provides Undo and Redo support.  Yes, GCUndoManager plays with Apple's Core Data!

* The *Check For Updates* feature is implemented by the [*Sparkle* framework](http://sparkle-project.org "Visit *Sparkle* framework"), written and maintained by the Sparkle Project, and provided under [license](LicenseSparkle.html "Visit license").

* We read/write [JavaScript Object Notation](http://json.org/) using the Cocoa categories from the BSJSONAdditions which is among the [source code](http://blakeseely.com/downloads.html) published by [Blake Seely](http://blakeseely.com/ "Visit blakeseely.com"), and used under [license](LicenseBlakeSeely.html "Visit license").  The *latest* code is available on the project's [github](http://github.com/blakeseely/bsjsonadditions).

* The Firefox reader/writer (when Firefox is not running) uses the latest version of [SQLite](http://sqlite.org/), written and placed into the [public domain](http://www.sqlite.org/copyright.html "Public Domain") by D. Richard Hipp of [Hipp, Wyrick & Company, Inc.](http://www.hwaci.com/ "Visit HWACI").

* The text fields used to record keyboard shortcuts in the *Shortcuts* tab of the Preferences in Markster and BookMacster are the  [shortcutrecorder](http://code.google.com/p/shortcutrecorder/).  We use the code from this project under the contributor's [New BSD License](http://www.opensource.org/licenses/bsd-license.php).

* [Michael Ash](http://www.mikeash.com/ "Visit Michael") wrote and published the [MAKVONotificationCenter](http://www.mikeash.com/pyblog/key-value-observing-done-right.html "Visit GCUndoManager"), which allows our apps to have "Key-Value Observing *Done Right*".

* The code implementing our Preferences window is based substantially on the UKPrefsPanel, from the collection of [source code](http://www.zathras.de/angelweb/sourcecode.htm "Visit source code") written by Uli Kusterer.

* The *Tags View* in the document window is based on the [*Tag Cloud NSView*](http://www.fernlightning.com/doku.php?id=randd:tcloud:start "Visit *Tag Cloud NSView*") source code, which was generously shared to the world by [Robert Pointon](http://www.fernlightning.com/doku.php "Visit Robert Pointon").

* Code for using Core Animation to animate this "Hint" arrow was copied and modified from [Core Animation Tutorial: Window Shake Effect](http://www.cimgf.com/2008/02/27/core-animation-tutorial-window-shake-effect/), by [Marcus Zarra](http://www.zarrastudios.com/ZDS/Home/Home.html)

* Parsing and unparsing of dates formatted per ISO 8601 in XBEL files is done using the [ISO8601DateFormatter class](http://boredzo.org/iso8601parser/) written by Peter Hosey.

* The star rater thingey was adapted from [EDStarRating](http://cocoacontrols.com/platforms/mac-os-x/controls/edstarrating), by Ernesto Garcia, of [cocoaWithChurros](http://www.cocoawithchurros.com/). 

* Changes in bookmarks trees are detected using the [mix() function](http://www.burtleburtle.net/bob/hash/doobs.html), published by Robert Jenkins, for nonlinearly combining hash values.

* The popup menu in the [Content View]() is based in part on the [KBPopUpTableHeaderCell](http://lists.apple.com/archives/cocoa-dev/2005/Apr/msg01223.html "Visit KBPopUpTableHeaderCell") published by Keith Blount of [Literature & Latte](http://www.literatureandlatte.com/index.html "Visit Literature & Latte").

* The idea to use an attached window to make the blue "Hint" (Help) arrow, and most of the heavy lifting code, was copied and modified from [MAAttachedWindow](http://mattgemmell.com/2007/10/03/maattachedwindow-nswindow-subclass) by [Matt Gemmell](http://mattgemmell.com).
 
* The tooltip window which drags with the mouse is based on the [ToolTip class](http://www.cocoadev.com/index.pl?ToolTip "Visit ToolTip class") published by Eric Forget of [Cafederic](http://www.cafederic.com/ "Visit Cafederic").

* The small blue "bookmark" and some of the other stock icons are from the kit created by Jasper Hauser of [JasperHauser.nl Icon Design](http://www.jasperhauser.nl/icon/ "Visit JasperHauser.nl Icon Design").

* Cool sound effects were provided by [SoundJay.com](http://soundjay.com).  They have many high-quality sound effects available.

## Teachers

* Quitting Chrome and Firefox was only about 98% reliable until we learned a trick from AppleScript guru [Shane Stanley](http://www.macosxautomation.com/applescript/apps/index.html).

## Tools

*  The Help Book is produced with our own Perl script which invokes Fletcher Penney's *[MultiMarkdown](http://fletcherpenney.net/multimarkdown/)*, which is in turn built on John Gruber's *[Markdown](http://daringfireball.net/projects/markdown/index)*, and also invokes John Gruber's *[SmartyPants](http://daringfireball.net/projects/smartypants/)*.

