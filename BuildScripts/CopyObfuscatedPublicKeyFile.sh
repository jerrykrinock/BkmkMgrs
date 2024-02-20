#!/bin/sh

ORIGINAL_IFS=$IFS
IFS='.' # dot character is delimiter in major.minor.bugfix
# read CURRENT_PROJECT_VERSION into an array as tokens separated by IFS
read -ra ADDR <<< "$CURRENT_PROJECT_VERSION"
IFS=$ORIGINAL_IFS
PUBLIC_KEY_OBFUSCATING_FILENAME=colors
MAJOR_VERSION=${ADDR[0]}
echo Copying appropriate obfuscated public key file to Resources
SOURCE="$SRCROOT/Resources/Per-App/$PRODUCT_NAME/ObfuscatedPublicKeys/V$MAJOR_VERSION"
DESTIN="$CONFIGURATION_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH/$PUBLIC_KEY_OBFUSCATING_FILENAME"
echo   source: $SOURCE
echo   destin: $DESTIN
cp $SOURCE $DESTIN
exit 0
