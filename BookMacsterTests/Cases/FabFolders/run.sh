#!/bin/zsh

APPSUPPORT=~/Library/Application\ Support/BookMacster
DOCNAME=FabFolders
DOCID=DFEB
TESTSDIR=~/Documents/Programming/Projects/BkmkMgrs/BookMacsterTests/Cases/$DOCNAME


cd $TESTSDIR

cp -fp Bookmarks.plist /Users/jk/Library/Safari/

echo "Please ensure that BookMacster is running, preferably in the Xcode debugger in case of trouble.  Then hit 'return'."
read answer
osascript -e "tell application \"BookMacster\" to close every document"
rm -Rf $APPSUPPORT/Collections/$DOCNAME.bmco

echo "Hit 'return' to do load $DOCNAME and its local data"
read answer
cp -Rfp $DOCNAME.bmco $APPSUPPORT/Collections/
cp -Rfp *$DOCID*.* $APPSUPPORT
osascript -e "tell application \"BookMacster\" to open \"$APPSUPPORT/Collections/$DOCNAME.bmco\""

echo "Hit 'return' to export from $DOCNAME to Safari"
read answer
osascript -e "tell application \"BookMacster\" to tell document 1 to export"

echo "Tests complete.  Hit 'return' to close $DOCNAME.bmco."
osascript -e "tell application \"BookMacster\" to close document 1"
