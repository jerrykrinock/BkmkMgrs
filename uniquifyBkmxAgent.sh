/bin/sh

AGENT_INFO_PLIST_PATH=$BUILT_PRODUCTS_DIR/BkmxAgent.app/Contents/Info.plist
echo Will uniquify bundle identifier in $AGENT_INFO_PLIST_PATH

if test -f $AGENT_INFO_PLIST_PATH; then
  echo "BkmxAgent's Info.plist exists as expected at $AGENT_INFO_PLIST_PATH"
else
  echo "Error: Cannot uniquify bundle ID in nonexistent file: $AGENT_INFO_PLIST_PATH"
  #exit 79
fi

RAW_BUNDLE_ID=$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$AGENT_INFO_PLIST_PATH")
echo Read raw Bundle ID: $RAW_BUNDLE_ID

TIMESTAMP=`date +"%Y%m%d-%H%M%S"`
UNIQUE_BUNDLE_ID=$RAW_BUNDLE_ID-$TIMESTAMP
# We used a dash instead of a dot because of the way that -[BkmxBasis toAgentPortName] treats dots.

/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $UNIQUE_BUNDLE_ID" "$AGENT_INFO_PLIST_PATH"
echo Set Uniquified Bundle ID $UNIQUE_BUNDLE_ID in $AGENT_INFO_PLIST_PATH
