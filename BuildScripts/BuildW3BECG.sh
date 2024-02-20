#!/bin/sh


packExtensionForBrowser () {
    echo "#"
    echo "##### Building $productName as $type for $browser #####"

    cd $sourceDir

    # Remove .DS_Store file, if any
    rm -f $productName/BrowserCommon.DS*

    # Make a temporary directory path which we shall use for building
    outerTempDir=$(mktemp -d -t "Build-W3CBE-Temp")
    innerTempDir=$outerTempDir/$productName
    echo Will build stuff in temporary directory $innerTempDir

    # Copy everything to temporary directory
    cp -R $productName/BrowserCommon/ $innerTempDir

    # Create a destination directory if one does not already exist
    destinDir=$destinDirBase/$browser
    echo Creating destinDir $destinDir
    # In the next line, the bash && operator between two commands executes the second command if the first one returns true, which in this case means that the $destinDir does not exist, because the ! operator is negation, and [ ... ] tests if directory exists.
    [ ! -d $destinDir ] && mkdir -p $destinDir

    # Get the manifest for this browser
    manifestPath=$productName/BrowserSpecial/$browser/manifest.json
    # See if $manifest file exists
    if [ ! -f $manifestPath ]
    then
        echo "Did not find manifest file for $browser in $productName"
    else
        echo "Found manifest file for $browser of $productName"

        # Verify that extension version is the same as that which will be demanded by the app to install the extension, and if not, exit with nonzero status.
        versionFromManifest=`~/bin/jq --raw-output '.version' "$manifestPath"`
        echo "version in manifest: $versionFromManifest"
        echo "min version demanded by xcconfig: $minVersion"
        if (( $versionFromManifest >= $minVersion )) ; then
            echo "OK.  Version from manifest ($versionFromManifest) is >= version demanded by app ($minVersion)"
        else
            echo "FAIL because Version from manifest ($versionFromManifest) < version demanded by $appKey in product ($minVersion)"
            exit 15
        fi

        cp $manifestPath $innerTempDir

    fi

    # The following section no longer executes.  It was useful for manifest v2 when I had a common manifest file for all browsers, with additions for Firefox.  But as of now, 2023-08-25, Chrome needs manifest v3 and Firefox barfs on service_worker which is requireed by Chrome manifest v3 in lieu of background page.
    # See if there is are any additions to the manifest for this browser
    manifestAdditions=$productName/BrowserSpecial/$browser/manifestAdditions.json
    # See if $manifestAdditions file exists
    if [ ! -f $manifestAdditions ]
    then
        echo "There are no special additions to manifest for $browser in $productName"
    else
    echo "Adding additions to manifest for $browser of $productName"
        manifest=$productName/BrowserCommon/manifest.json
        ~/bin/jq -s '.[0] * .[1]' "$manifestAdditions" "$manifest" > $innerTempDir/manifest.json
    fi

    cd $outerTempDir

    if [ "$type" == "crx" ]; then
        # Make the .crx product
        # Requires crxmake from https://github.com/GoogleChrome/chrome-app-samples/blob/master/samples/dojo/crxmake.sh
        cmd="$SOURCE_ROOT/../../Scripts/crxmake.sh $productName $sourceDir/$productName.pem"
        echo current directory is: `pwd`
        echo Will crxmake $productName
        echo by executing: $cmd
        echo in directory: `pwd`
        `$cmd`
        crxName=$productName.crx
        echo Did crxmake $crxName
        mv *.crx $destinDir
    fi

    if [ "$type" == "zip" ]; then
        # You can make the .zip product, using Mozilla's web-ext tool.  This has the advantage that you can submit it to their store (and wait 38 days for review).  The only difference I can see between using `web-ext build`, and `zip -r` is that the name of the unzipped folder is different.  Read this:
        #   https://discourse.mozilla-community.org/t/unable-to-submit-new-add-on/12416/7
        # Something is wrong there, because the documentation states that `zip-r` should work:
        #   https://developer.mozilla.org/en-US/Add-ons/WebExtensions/Publishing_your_WebExtension
        # cd $productName
        # web-ext build
        # cd ..
        # Move product to current directory (Note the "." at end of next line)
        # mv $productName/web-ext-artifacts/*.zip .
        # Remove garbage empty folder left by web-ext tool
        # rm -Rf $productName/web-ext-artifacts

        # Anyhow, since I cannot wait 38 days and am therefore not submitting to the store, I instead use `zip -r` which takes less code and gives me known file name.
        zip -r $productName $productName
        mv *.zip $destinDir
    fi

    echo removing $outerTempDir
    rm -Rf $outerTempDir
}

packExtensionForBrowsers () {
    cd $sourceDir

    productName=$productNamePrefix$productShortName

    # Build for each of the browsers

    browser=Opera
    type=crx
    packExtensionForBrowser

    browser=Chrome
    type=zip
    packExtensionForBrowser

    browser=Firefox
    type=crx
    packExtensionForBrowser
}

##### End of Subroutines


##### Beginning of Script

# Check that the 'jq' program is available on this computer
~/bin/jq --version
if [[ $? -ne 0 ]]; then
echo "This script requires jq, a command-line JSON file editor.  It looks like jq is not installed.  Please visit https://stedolan.github.io/jq/"
exit 1
fi
sourceDir="$SOURCE_ROOT/ExtensionsBrowser/W3CBE"
destinDirBase=$BUILT_PRODUCTS_DIR/W3CBE-Extensions

productNamePrefix=BookMacster

productShortName=Button
minVersion=$W3CBE_BUTTON_EXTENSION_MIN_VERSION_FOR_OTHERS
packExtensionForBrowsers

productShortName=Sync
minVersion=$W3CBE_SYNC_EXTENSION_MIN_VERSION_FOR_OTHERS
packExtensionForBrowsers

# For your convenience, opens a Finder window so you can ship them or whatever.
open $destinDirBase



