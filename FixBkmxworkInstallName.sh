#!/bin/bash

#  This script suddenly became necessary when I switched to using xcodebuild's `archive` command instead of `build`, and configuring project settings so that Xcode would do the code signing instead of my shipping script doing the code signing.  Xcode has been setting the install name to the Bkmxwork in its own build directories instead of the Bkmxwork embedded in the product, which is @rpath/Bkmxwork.framework/Versions/A/Bkmxwork.  Of course, using the Bkmxwork in the build directory works when run on my Mac but will fail on any other Mac (and will also fail when running a release/archihve build on my Mac because the app is signed but this version of the Bkmxwork framework is not.

# Pass in parameter $1 as the name of the main app currently being built:  BookMacster, Synkmark or Smarky

echo "*** Fixing Bkmxwork install name for BkmxAgent in $1 ***"

cd "$BUILT_PRODUCTS_DIR/$EXECUTABLE_FOLDER_PATH"

echo "Changed directory to: $PWD"

echo "   ... fixing for Debug builds"
install_name_tool -change /Users/jk/Library/Developer/Xcode/DerivedData/BkmkMgrs-dgajrgxroulefweqxsvazigfeucy/Build/Products/Debug/Bkmxwork.framework/Versions/A/$1 @rpath/Bkmxwork.framework/Versions/A/Bkmxwork "$EXECUTABLE_NAME"

echo "   ... fixing for Release arm64 builds"
install_name_tool -change /Users/jk/Library/Developer/Xcode/DerivedData/BkmkMgrs-dgajrgxroulefweqxsvazigfeucy/Build/Intermediates.noindex/ArchiveIntermediates/$1/IntermediateBuildFilesPath/BkmkMgrs.build/Release/Bkmxwork.build/Objects-normal/arm64/Binary/Bkmxwork @rpath/Bkmxwork.framework/Versions/A/Bkmxwork "$EXECUTABLE_NAME"

echo "   ... fixing for Release x86_64 builds"
install_name_tool -change /Users/jk/Library/Developer/Xcode/DerivedData/BkmkMgrs-dgajrgxroulefweqxsvazigfeucy/Build/Intermediates.noindex/ArchiveIntermediates/$1/IntermediateBuildFilesPath/BkmkMgrs.build/Release/Bkmxwork.build/Objects-normal/x86_64/Binary/Bkmxwork @rpath/Bkmxwork.framework/Versions/A/Bkmxwork "$EXECUTABLE_NAME"

echo "Did fix Bkmxwork install names"