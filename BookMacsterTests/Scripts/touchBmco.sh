#!/bin/bash

# This script will change the name of a (any) boookmark whose name begins with a given string to that given string followed by a timestamp.  It also changes the document's docLastSaveToken.

TARGETNAMEPREFIX=ANF
DOCPATH=/Users/jk/Library/Application\ Support/BookMacster/Synkmark.bmco

TIMESTRING=$(date '+%Y-%m-%d %H:%M:%S')
NEWNAME="$TARGETNAMEPREFIX $TIMESTRING"
SQLCOMMAND="UPDATE ZSTARK_ENTITY SET ZNAME = \"$NEWNAME\" WHERE ZNAME LIKE \"$TARGETNAMEPREFIX%\""
sqlite3 "$DOCPATH/StoreContent/persistentStore" "$SQLCOMMAND"

PLBCOMMAND="Set :docLastSaveToken \"$TIMESTRING\""
/usr/libexec/PlistBuddy -c "$PLBCOMMAND" "$DOCPATH/auxiliaryData.plist"
echo "Changed suffix of target bookmark to $TIMESTRING"

