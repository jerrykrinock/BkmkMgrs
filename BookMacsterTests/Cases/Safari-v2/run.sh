#!/bin/zsh

APPSUPPORT=~/Library/Application\ Support/BookMacster
TESTSDIR=~/Documents/Programming/Projects/BkmkMgrs/BookMacsterTests/Cases/Safari
SLEEP=3
# Make this > 1 to test repeatedly
TOTALTESTCOUNT=1


for TESTCOUNT in {1..$TOTALTESTCOUNT}
do

cd $TESTSDIR

if [ $TESTCOUNT -eq 1 ]
then
	echo "Please ensure that BookMacster is running  (preferably in the Xcode debugger in case of trouble).  Then hit 'return'."
	read answer
fi
cp -fp Bookmarks.plist /Users/jk/Library/Safari/
sleep $SLEEP
echo "***** Beginning test $TESTCOUNT of $TOTALTESTCOUNT ******"
echo "Will close any open .bmco documents (and Inspector, to prevent crashes)"
scriptResult=`osascript -e "tell application \"BookMacster\" to close every document"`
# Hide inspector, because even after working on it for a week, which resulted in removing
# Cocoa Bindings from the two object controllers in Inspector.xib (BkmkMgrs commit f33c5a05),
# the damn thing sometimes still crashes 
scriptResult=`osascript -e "tell application \"BookMacster\" to hide inspector"`
rm -Rf $APPSUPPORT/Collections/Safari-*.bmco


CURRENT_BMCO=Safari-0
DOCID=452A
echo "Will test exporting to Safari from $CURRENT_BMCO.bmco."
cp -Rfp $CURRENT_BMCO.bmco $APPSUPPORT/Collections/
cp -Rfp *$DOCID*.* $APPSUPPORT
sleep $SLEEP
scriptResult=`osascript -e "tell application \"BookMacster\" to open \"$APPSUPPORT/Collections/$CURRENT_BMCO.bmco\""`
sleep $SLEEP
scriptResult=`osascript -e "tell application \"BookMacster\" to tell document 1 to export ignoring limit true"`
sleep $SLEEP
scriptResult=`osascript -e "tell application \"BookMacster\" to close document 1"`

CURRENT_BMCO=Safari-1
DOCID=8C79
echo "Will test exporting to Safari from $CURRENT_BMCO.bmco."
cp -Rfp $CURRENT_BMCO.bmco $APPSUPPORT/Collections/
cp -Rfp *$DOCID*.* $APPSUPPORT
sleep $SLEEP
scriptResult=`osascript -e "tell application \"BookMacster\" to open \"$APPSUPPORT/Collections/$CURRENT_BMCO.bmco\""`
sleep $SLEEP
scriptResult=`osascript -e "tell application \"BookMacster\" to tell document 1 to export ignoring limit true"`
sleep $SLEEP
scriptResult=`osascript -e "tell application \"BookMacster\" to close document 1"`

CURRENT_BMCO=Safari-2
DOCID=CA41
echo "Will test exporting to Safari from $CURRENT_BMCO.bmco."
cp -Rfp $CURRENT_BMCO.bmco $APPSUPPORT/Collections/
cp -Rfp *$DOCID*.* $APPSUPPORT
sleep $SLEEP
scriptResult=`osascript -e "tell application \"BookMacster\" to open \"$APPSUPPORT/Collections/$CURRENT_BMCO.bmco\""`
sleep $SLEEP
scriptResult=`osascript -e "tell application \"BookMacster\" to tell document 1 to export ignoring limit true"`
sleep $SLEEP
scriptResult=`osascript -e "tell application \"BookMacster\" to close document 1"`

CURRENT_BMCO=Safari-3
DOCID=FCB6
echo "Will test exporting to Safari from $CURRENT_BMCO.bmco."
cp -Rfp $CURRENT_BMCO.bmco $APPSUPPORT/Collections/
cp -Rfp *$DOCID*.* $APPSUPPORT
sleep $SLEEP
scriptResult=`osascript -e "tell application \"BookMacster\" to open \"$APPSUPPORT/Collections/$CURRENT_BMCO.bmco\""`
sleep $SLEEP
scriptResult=`osascript -e "tell application \"BookMacster\" to tell document 1 to export ignoring limit true"`
sleep $SLEEP
echo "Importing to Safari from $CURRENT_BMCO.bmco."
scriptResult=`osascript -e "tell application \"BookMacster\" to tell document 1 to import ignoring limit true"`
echo "Verify that the number of imported changes is +0, Δ0, ↖0, ↕0, -0.  Will sleep 10."
sleep 10
scriptResult=`osascript -e "tell application \"BookMacster\" to close every document"`

done
