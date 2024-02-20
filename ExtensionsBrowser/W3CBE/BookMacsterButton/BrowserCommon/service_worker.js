function dumpText(text) {
	console.log(new Date() + " " + text) ;
}

var port;
var extensionVersion;
var extensionName;
var errors;

function isDefined(x) {
  // See  http://constc.blogspot.com/2008/07/undeclared-undefined-null-in-javascript.html
  // "My solution instead relies on the fact that undefined is
  // equal to null, but is not strictly equal to null"
  return !(x == null && x !== null);
}

function logError(errorCode, errorDescription) {
    if (!isDefined(errorDescription)) {
      errorDescription = "Sorry, no error description"
    }
    console.log("Error " + errorCode + ": " + errorDescription);
    let errorInfo = {
        errorCode: errorCode,
        errorDescription: errorDescription
    };
    if (!isDefined(errors)) {
        errors = new Array();
    }
    errors.push(errorInfo);
}

// Where we will expose all the data we retrieve from storage.sync.
const storageCache = { count: 0 };
// Asynchronously retrieve data from storage.sync, then cache it.
const initStorageCache = chrome.storage.local.get().then((items) => {
  // Copy the data retrieved from storage into storageCache.
  console.log("Retrieved from storage: " + items.extoreName + ", " + items.profileName)
  Object.assign(storageCache, items);
  console.log("storageCache initialized");
});

function startListening() {
	chrome.action.onClicked.addListener(function(tab) {
		var pgUrl = encodeURIComponent(tab.url) ;
		var pgTitle = encodeURIComponent(tab.title) ;
		var tabId = tab.id ;
		var tabIndex = tab.index ;
		var windowId = tab.windowId ;

  /* This is a bit of a trick.  The natural approach would be to send the
  bookmark to our native host, which would then forward it to the native app
  via SSYInterappClient.  Instead, we use the bookmacster:// URL scheme,
  which our native app's UrlHandler is waiting for, and programmed to handle
  in the same way, that is, to land a new bookmark.  To prepare for that, we
  encode it as a URL. */
		var daUrl = 'bookmacster://add?url=' + pgUrl
		+ '&name=' + pgTitle
		+ '&tabId=' + tabId
		+ '&tabIndex=' + tabIndex
		+ '&windowId=' + windowId ;

        try {
            let message = {bookmacsterizeUrl: daUrl} ;
            port.postMessage(message);
        }
        catch (error) {
            dumpText("Error 737-9784: " + error) ;
        }
	});
}

async function connectNativeMessaging() {
  try {
    var hostName = "com.sheepsystems.chromessenger";
    port = chrome.runtime.connectNative(hostName);
  } catch (error) {
    /* This branch does not execute if our extension id is missing from our
    NativeMessagingHosts file.  It does not execute if our Chromessenger
    symlink is not on disk.  Apparently, connectNative() never throws?
    Furthermore, in each of the above two fault cases, port will be a defined object,
    not null.     Summary: There is no way to tell, at this point, whether we have a
    valid port.  The first error will occur later, when we try to send a message to
    the port.  Oh, well.  I leave the following code just in case it does throw
    in some way I have not thought of. */
    var errDesc = error.description
    if (errDesc) {
      logError(739519, error);
    } else {
      logError(739520, error);
    }
  }
  
  if (!isDefined(storageCache.profileName)) {
    console.log("No profileName in storageCache");
  }
  if (!isDefined(storageCache.extoreName)) {
    console.log("No extoreName in storageCache");
  }

  if (!isDefined(storageCache.profileName) || !isDefined(storageCache.extoreName)) {
    try {
    await requestLegacyStorage();
    console.log("Requested legacy storage");
    } catch {
      console.log("Error requesting legacy storage (seen in Orion)");
      finishConnectNativeMessaging();
    }
  } else {
    finishConnectNativeMessaging();
  }
}
    
/*
In legacy manifest v2 extensions, there was only one store in which an extensions could store local user data persistently:
    (2a) the localStorage of a background page [1]

In manifest v3 extensions, there are two stores [2]:
    (3a) the localStorage of an offscreen document
    (3b) chrome.storage.local [3]
  
Fortunately, since stores 2a and 2b have the same origin (chrome-extension://{{hash}}) there is no need to migrate stored local data from a manifest v2 extension to a manifest v3 extension.  Stores 2a and 3a are in fact the same stores and furthermore, their data will persist through an update of the extension from manifest v2 to manifest v3.

But store 3a is a bit of a pain to access, requiring some dozens lines of code and two additional files (e.g. offscreen.html and offscreen.js) to be added to the extension. [4]  Therefore, in this manifest v3 extension we only *read* data from 3a on the first run, then immediately write it to 3b.  The need for all of that code and the two additional files is thus only temporary, until all users have either launched Chrome and been updated to manifest v3, or until their data is so stale that it doesn't matter any more.  Conclusion: A year or so after we publish our first manifest v3 extension update (version 48, 2023 Oct 1), in some future extension update, we could delete those two offscreen.xxx files, the following two functions, and the code branches which call them.

1. https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage
2. https://developer.chrome.com/docs/extensions/migrating/to-service-workers/#convert-localstorage
3. https://developer.chrome.com/docs/extensions/reference/storage/
4. https://github.com/GoogleChrome/chrome-extensions-samples/tree/main/functional-samples/cookbook.offscreen-clipboard-write
5. https://groups.google.com/a/chromium.org/g/chromium-extensions/c/T3_8r6Anv14/m/kelGzQ92AQAJ?utm_medium=email&utm_source=footer
*/

async function requestLegacyStorage() {
  chrome.runtime.onMessage.addListener(receiveMessageFromOffscreenDoc);

  await chrome.offscreen.createDocument({
    url: 'offscreen.html',
    reasons: [chrome.offscreen.Reason.CLIPBOARD],
    justification: 'Read legacy stored info'
  });
  console.log("Created offscreen document to get legacy storage");

  // Dispatch the message.
  chrome.runtime.sendMessage({
    type: 'request-legacy-stored-info',
    target: 'offscreen-doc'
  });

  console.log("Sent message to offscreen document requesting legacy storage");
}

async function receiveMessageFromOffscreenDoc(message) {
  // Return early if this message isn't meant for the offscreen document.
  if (message.target !== 'my-service-worker') {
    console.log("Received message for unknown target: " + message.target);
    return;
  }

  switch (message.type) {
    case 'legacy-stored-info':
      let extoreName = message.extoreName;
      if (isDefined(extoreName)) {
        console.log("Got legacy stored extoreName: " + extoreName);
        storageCache.extoreName = extoreName;
      } else {
         console.log("Failed to get legacy stored extoreName");
      }
      let profileName = message.profileName;
      if (isDefined(profileName)) {
        console.log("Got legacy stored profileName: " + profileName);
        storageCache.profileName = profileName;
      } else {
         console.log("Failed to get legacy stored profileName");
      }
      
      cacheAndStore(extoreName, profileName)
      
	  chrome.runtime.sendMessage({
		type: 'close-yourself',
		target: 'offscreen-doc'
	  });
      console.log("Closed offscreen document");

      finishConnectNativeMessaging();
      break;
    default:
      console.warn(`Unexpected message type received: '${message.type}'.`);
  }
}

function finishConnectNativeMessaging() {
  if (!isDefined(storageCache.extoreName)) {
    console.log("No extoreName in legacy storage, using SORRY_");
    storageCache.extoreName = "SORRY-NULL-EXTORE";
      // Warning: That string matches one in constSorryNullProfile in BkmxGlobals.h
    }
    if (!isDefined(storageCache.profileName)) {
      console.log("No profileName in legacy storage, using SORRY_");
      storageCache.profileName = "SORRY-NULL-PROFILE";
      // Warning: That string matches one in constSorryNullProfile in BkmxGlobals.h
    }

  var startupInfo = {
    extensionVersion: extensionVersion,
    extensionName: extensionName,
    profileName: storageCache.profileName,
    extoreName: storageCache.extoreName
  };
  try {
    port.postMessage({startupInfo: startupInfo});
  } catch (error) {
    logError(484874, "Failed to post startupInfo: " + error.description);
  }
  console.log("Waiting for Native Messages with info:", startupInfo);
    
  port.onMessage.addListener(function(rxObject) {
    console.log("Got a message from Chromessenger: ", rxObject);
    let command = rxObject.command;
    
    if (command == "getBasicInfo") {
        let basicInfo = {
            extensionVersion: extensionVersion,
            extensionName: extensionName,
            profileName: storageCache.profileName,
            extoreName: storageCache.extoreName,
            thisInfoIsCheesy: "NotCheesy"
        };
        port.postMessage({errors:errors});
        port.postMessage({basicInfo: basicInfo});
    } else if (command == "configureBasicInfo") {
      console.log("configureBasicInfo");
      let profileName = rxObject.profileName;
      let extoreName = rxObject.extoreName;
      console.log("Got basic info from Chromessenger: " + extoreName + "." + profileName);
      cacheAndStore(extoreName, profileName)
    } else if (command == "grabCurrentPageInfo") {
      chrome.tabs.query({active: true, lastFocusedWindow: true}, function(tabs) {
        var tab = tabs[0];

        let grabbedInfo = {name: tab.title, url: tab.url};
        port.postMessage({grabbedInfo: grabbedInfo});
      });      
    }
  });
}

async function startUpPart2() {
  try {
    await initStorageCache;
  } catch (e) {
    console.log("Error initializing storage cache: " + e)
  }

  connectNativeMessaging();
  startListening() ;
}

function startUp() {
  /* We wrap the whole startup in a stupid delay of 100 milliseconds
  because, in Firefox 54, the Debugger Console won't show any console.log()
  output until about 5 milliseconds after the extension loads. */
  setTimeout(async function() {
    /* The following magic assures that this Service Worker will be active on startup
    when running in a Chrome-ish browser.
    https://groups.google.com/a/chromium.org/g/chromium-extensions/c/XY6u0raKRJQ */
    chrome.runtime.onStartup.addListener(() => {});
    const manifest = chrome.runtime.getManifest();
    extensionVersion = manifest['version'];
    extensionName = manifest['name'];
    startUpPart2();
    console.log("Starting up " + extensionName + " version " + extensionVersion);

    try {
      console.log("Browser has defined chrome.bookmarks? ", isDefined(chrome.bookmarks) != null ? "YES" : "NO");
    } catch (err) {
        /* Ignore because this err is could (but currently does not) occur in Firefox. */
    }
    try {
      console.log("Browser has defined browser.bookmarks? ", isDefined(browser.bookmarks) != null ? "YES" : "NO");
    } catch (err) {
      /* Ignore because this err is *expected* in Chromy browsers. */
    }
  }, 100) ;
}

function cacheAndStore(extoreName, profileName) {
  if (isDefined(profileName)) {
    storageCache.profileName = profileName;
    console.log("cached profileName:", storageCache.profileName);
  }
  if (isDefined(extoreName)) {
    storageCache.extoreName = extoreName;
    console.log("cached extoreName:", storageCache.extoreName);
  }
  if ( isDefined(extoreName) && isDefined(profileName) ) {
    chrome.storage.local.set(storageCache).then(() => {
      console.log("Stored both: " + storageCache.extoreName + " " + storageCache.profileName);
    });
  }     
}



console.log("Will start");
startUp();
console.log("Did start");

