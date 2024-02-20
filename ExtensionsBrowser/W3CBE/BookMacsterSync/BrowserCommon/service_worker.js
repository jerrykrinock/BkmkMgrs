/* Oddly, JavaScript's 'Array' object does not have a method for removing
  an object by value.  So we define a global function to do so.  Objects to
  be removed follow the theArray argument. */
function removeObjectFromArray(theArray, removee) {
  var len = theArray.length
  var i = len - 1;
  while (i >= 0) {
    indexOfRemovee = theArray.indexOf(removee)
    if (indexOfRemovee !== -1) {
      theArray.splice(indexOfRemovee, 1);
      break;
    }
    i--;
  }
  return theArray;
}

var port;
var extensionVersion;
var extensionName;
var jsonRoot;
var jsonArray;
var phase;
var nToDo;

// Constants
var phaseBegin = 0;
var phaseCut = 1;
var phasePut = 2;
var phaseRepair = 3;
var phaseDone = 4;

// Where we will expose all the data we retrieve from storage.sync.
const storageCache = { count: 0 };
// Asynchronously retrieve data from storage.sync, then cache it.
const initStorageCache = chrome.storage.local.get().then((items) => {
  // Copy the data retrieved from storage into storageCache.
  console.log("Retrieved from storage: " + items.extoreName + ", " + items.profileName)
  Object.assign(storageCache, items);
});

/*The following are initialized when starting each new Export from our app.
 barId is needed because we'll temporarily stash limbo-fied items
 in Bookmarks Bar during exports.  We use the Bar because it is the only
 hard folder which is had by all browsers that use this extension. */
var limbo;
var barId;
var exidFeedbacks;
var assignedVsProposedExids;
var errors;
var chunkTrain;

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

function handshakeRepeatedly() {
  let i = 1;
  setInterval(function() {
    var msg = "Greeting " + i + " from browser " + storageCache.extoreName + "." + storageCache.profileName;
    port.postMessage({testString: msg});
    console.log("Posted msg: " + msg);
    i = i + 1;
  },
  5000);
}

function streamTest() {
  var cat = ""
  for (i=0; i<32768; i++) {
    cat = cat + "meow"
  }
  var len = cat.length;
  console.log("Will output cat of length " + len);
  port.postMessage({meows: cat});
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
      logError(639519, error);
    } else {
      logError(639520, error);
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
    var isLastChunk = rxObject.isLastChunk;
    if (isDefined(isLastChunk)) {
      // This message has been split into chunks to keep under 1 MB limit (rare)
      var isLastText = rxObject.isLastChunk ? "" : "non-";
      console.log("Got", isLastText + "last chunk of a message,");
      console.log("Chromessenger chunked this after", rxObject.chunkIterations + " iterations, allowing for", rxObject.chunkOverheadAllowance, "overhead bytes");
            let newChunk = rxObject.chunkPayload;
            if (!isDefined(chunkTrain)) {
                // Must be the first chunk
                chunkTrain = new String();
            }
            
            chunkTrain = chunkTrain.concat(newChunk);
            
            if (rxObject.isLastChunk) {
              // Got all chunks now.  However, it is a long JSON string.
              // We must convert back to a JSON object
              let reconstructedRxObject = JSON.parse(chunkTrain)
                handleCommandInRxObject(reconstructedRxObject)
            }

    } else {
      // This is a normal message, all in one, no chunks
      console.log("Got a normal, non-chunked message");
      // console.log("with object:"); console.log(rxObject);
      handleCommandInRxObject(rxObject);
    }
  });
  
//   port.onDisconnect.addListener(function () {
//     console.log('Native Messaging port disconnected, will try reconnect');
//     connectNativeMessaging();
//     console.log('Native Messaging port disconnected, did try reconnect');
//   });
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


function handleCommandInRxObject(rxObject) {
    var command = rxObject.command;
    console.log("Got command from Chromessenger: " + command);

    if (isDefined(errors)) {
        console.log("Clearing " + errors.length + " errors from prior command");
        errors = new Array();
    }

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
    } else if (command == "sendWholeTree") {
        // Invoke chrome's bookmarks to get the tree, calling back
        // our gotTree() function to send it.
        chrome.bookmarks.getTree(gotTree);
    } else if (command == "putExportAndSendExids") {
        putExportAndSendExids(rxObject.jsonTree);
    } else if (command == "configureBasicInfo") {
        let profileName = rxObject.profileName;
        let extoreName = rxObject.extoreName;
        console.log("Got basic info from Chromessenger: " + extoreName + "." + profileName);
        cacheAndStore(extoreName, profileName)
    } else if (command == "grabCurrentPageInfo") {
        chrome.tabs.query({active: true, lastFocusedWindow: true}, function(tabs) {
            var tab = tabs[0];

            let grabbedInfo = {name: tab.title, url: tab.url};
            port.postMessage({errors:errors});
            port.postMessage({grabbedInfo: grabbedInfo});
        });
    } else {
        logError(618375, "Unrecognized command " + command.description);
    }
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

function registerForChanges() {
//    // Test for Safari.  So far, July 2020, getTree() will run without
//    // error but the callback gotTree() is never called :(
//    try {
//        console.log("Here we go!!!")
//        chrome.bookmarks.getTree(gotTree);
//    }
//    catch (error) {
//      logError(664990, error.description);
//    }
  // Register callbacks for bookmarks changed events
  try {
    chrome.bookmarks.onCreated.addListener(function(id, changeInfo) {
      // In this case, changeInfo is bookmark info; url, etc.
      changeInfo.changeType = 'created';
      changeInfo.affectedId = id;
      port.postMessage({changeInfo: changeInfo});
      });
  }
  catch (error) {
    logError(664991, error.description);
  }
  try {
    chrome.bookmarks.onRemoved.addListener(function(id, changeInfo) {
      changeInfo.changeType = 'removed';
      changeInfo.affectedId = id;
      port.postMessage({changeInfo: changeInfo});
    });
  }
  catch (error) {
    logError(664992, error.description);
  }
  try {
    chrome.bookmarks.onMoved.addListener(function(id, changeInfo) {
      changeInfo.changeType = 'moved';
      changeInfo.affectedId = id;
      port.postMessage({changeInfo: changeInfo});
    });
  }
  catch (error) {
    logError(664993, error.description);
  }
  try {
    chrome.bookmarks.onChanged.addListener(function(id, changeInfo) {
      changeInfo.changeType = 'changed';
      changeInfo.affectedId = id;
      port.postMessage({changeInfo: changeInfo});
    });
  }
  catch (error) {
    logError(664994, error.description);
  }
  try {
    chrome.bookmarks.onImportBegan.addListener(function() {
      var changeInfo = {
        changeType: 'importBegan'
      };
      port.postMessage({changeInfo: changeInfo});
    });
  }
  catch (error) {
    // See Note NO_SUPPORT_SOME_EVENTS, below.
  }
  try {
    chrome.bookmarks.onImportEnded.addListener(function() {
      var changeInfo = {
        changeType: 'importEnded'
      };
      port.postMessage({changeInfo: changeInfo});
    });
  }
  catch (error) {
    // See Note NO_SUPPORT_SOME_EVENTS, below.
  }
  try {
    chrome.bookmarks.onChildrenReordered.addListener(function(id, changeInfo) {
      changeInfo.changeType = 'childrenReordered';
      changeInfo.affectedId = id;
      port.postMessage({changeInfo: changeInfo});
    });
  }
  catch (error) {
    // See Note NO_SUPPORT_SOME_EVENTS, below.
  }

  console.log("Bookmarks change observers armed!");
}

/* Note NO_SUPPORT_SOME_EVENTS
  Do not console.log() the error here because, although Chrome and Opera
  support this event, Firefox does not, so this catch is expected in Firefox.
  Furthermore, I think we don't really need this event anyhow and are only
  interested in it for "future debugging", in case things change. */

function makeIndent(indentLength) {
  return "  ".repeat(indentLength);
}

function logItem(item, indent) {
  if (item.url) {
    console.log(makeIndent(indent) + item.index + " Bookmark with title: " + item.title);
  } else {
    console.log(makeIndent(indent) + item.index + " Folder with title: " + item.title);
  }

  console.log(makeIndent(indent) + "  id: " + item.id);
  console.log(makeIndent(indent) + "  parentId: " + item.parentId);
  if (item.dateAdded) {
    console.log(makeIndent(indent) + "  dateAdded:", new Date(item.dateAdded), " raw:", item.dateAdded);
  }
  if (item.dateGroupModified) {
    console.log(makeIndent(indent) + "  dateGrMod:", new Date(item.dateGroupModified), " raw:", item.dateGroupModified);
  }
  if (item.unmodifiable) {
    console.log(makeIndent(indent) + "  unmodifiable:", item.unmodifiable);
  }
  if (item.url) {
    // In the following, the ' around the url is because, otherwise, for
    // some crazy reason, console.log will quote its entire string.
    console.log(makeIndent(indent) + "  url: '" + item.url + "'");
  }
  if (doKeywords && item.keywords) {
    item.keywords.forEach(x => console.log(makeIndent(indent) + "  keyword: ", x));
  }

  if (item.children) {
    indent++;
    if (item.children.length == 0) {
      console.log(makeIndent(indent) + "children: []");
    }
    else {
      for (child of item.children) {
        logItem(child, indent);
      }
    }
  }

  indent--;
}

async function startUpPart2() {
  try {
    await initStorageCache;
  } catch (e) {
    console.log("Error initializing storage cache: " + e)
  }

  connectNativeMessaging();
  registerForChanges();

  // Do stream test
  //console.log("Will streamTest in 10 secs");
  //setTimeout(function() { streamTest(); }, 10000);

  // Do repeated handshaking
  //console.log("Will handshake with Chromessenger every 5 seconds");
  //handshakeRepeatedly();
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


/*
The json object represented by the jsonText should be structured like this:
* deletions
*    (array of dictionaries with keys:)
*      exid (required)
* insertions
*     (array of dictionaries with keys:)
*      parentExid (required)
*      index (optional)
*      name (optional)
*      url (optional)
* moves
*   (array of dictionaries with keys:)
*      exid (required)
*      parentExid (required)
*      index (optional)
* updates
*   (array of dictionaries with keys:)
*      exid (required)
*      name (optional)
*      url (optional)
 */


function isDefined(x) {
  // See  http://constc.blogspot.com/2008/07/undeclared-undefined-null-in-javascript.html
  // "My solution instead relies on the fact that undefined is
  // equal to null, but is not strictly equal to null"
  return !(x == null && x !== null);
}

function gotTree(rootChildren) {
  if (rootChildren) {
    var response;
    if (rootChildren.length == 1) {
      response = rootChildren;
      port.postMessage({errors:errors});
      port.postMessage({rootChildren: rootChildren});
    } else {
      logError(420397, " Not 1 root but " + rootChildren.length + ".");
    }
  } else {
    logError(420398, " getTree callback (gotTree) got nothing: " + rootChildren.description);
  }
}

function abortPhase() {
  nToDo = 1;
  checkPhase();
}

function checkPhase() {
  // console.log("Checking phase=" + phase + " with nToDo=" + nToDo + "\n");
    
  nToDo--;
  if (nToDo === 0) {
    phase++;
    switch(phase) {
      case phaseCut:
        jsonArray = jsonRoot.cuts;
        if (!isDefined(jsonArray)) {
          abortPhase();
          break;
        }
        nToDo = jsonArray.length;
        if (jsonArray.length === 0) {
          abortPhase();
          break;
        }
        doNextDeletion();
        break;
      case phasePut:
        jsonArray = jsonRoot.puts;
        if (!isDefined(jsonArray)) {
          abortPhase();
          break;
        }
        nToDo = jsonArray.length;
        if (jsonArray.length === 0) {
          abortPhase();
          break;
        }
        doNextPut();
        break;
      case phaseRepair:
        jsonArray = jsonRoot.repairs;
        if (!isDefined(jsonArray)) {
          abortPhase();
          break;
        }
        nToDo = jsonArray.length;
        if (jsonArray.length === 0) {
          abortPhase();
          break;
        }
        doNextRepair();
        break;
      case phaseDone:
        var hasChildren = false;
        var len = 0;
        if (isDefined(limbo)) {
          if (isDefined(limbo.length)) {
            len = limbo.length;
          }
        }
                
        if (len > 0) {
          /* There should not be any items left in limbo, because when we
          generate and send a change to delete a folder in BookMacster, we also
          generate and send a change to delete each one of its descendants. */
          logError(619751, "Will delete " + len + " items left in limbo");
          /* We use the old-fashioned loop instead of for...in to avoid
           other non-member properties of limbo.  See :
           http://blog.sebarmeli.com/2010/12/06/best-way-to-loop-through-an-array-in-javascript/
           */
          for (var i=0; i<len; i++) {
            var limboiteId = limbo[i];
            try {
              logError(619752, "Deleting id=" + limboiteId);
              chrome.bookmarks.remove(limboiteId);
            } catch (err) {
              logError(619753, "Removing id=" + limboiteId);
            }
          }
        }

        port.postMessage({errors: errors});
        port.postMessage({assignedVsProposedExids: assignedVsProposedExids});
        break;
      default:
        logError(633890, " No case " + phase);
        break;
    }
  }
}

function didDelete1() {
  checkPhase();
  if ((nToDo > 0) && (phase == phaseCut)) {
    doNextDeletion();
  }
}

function doNextDeletion() {
  var i = jsonArray.length - nToDo;
  var nDone = i+1;
  var total = nToDo+nDone
  reportProgress(1, 3, nDone, total);
  var json = jsonArray[i];
  // Get the item which has the given exid
  try {
    chrome.bookmarks.get(json.exid,
      function (itemsArray) {
      /* Regarding next line, see Note LastError at end of file. */
        if(chrome.runtime.lastError) {
          logError(633844, "Failed get to delete item id=" + json.exid + ".  Ignoring.  Error: " + chrome.runtime.lastError.message);
          didDelete1();
        } else if (itemsArray != null) {  // See note 155 below
          if (itemsArray.length > 0) {
            var deletee = itemsArray[0];
            if (deletee != null) {  // See note 155 below
              // If the deletee is a folder, we don't want to just delete it because that would also delete its children, some of which may have been moved to other folders, and this will not be handled until the Repairs phase.  Instead, we move all of its children into the Bookmarks Bar, aka Favorites, aka Toolbar, and also add these children' ids into Limbo.  If a child is found to be moved in the Repairs phase, we'll remove it from Limbo.  Finally, in phaseDone, we'll delete any children which are still in Limbo, which actually there shouldn't be.  See comment in phaseDone.
              chrome.bookmarks.getChildren(deletee.id,
                function(children) {
                  let length = 0;
                  let limboInfo;
                  if (isDefined(children)) {
                    length = children.length;
                    limboInfo = {parentId: barId};
                  }
                  deleteItemAfterRecursivelyMovingAnyChildrenToLimbo(children, limboInfo, length, deletee.id);
                }
              );
            }
          } else {
            didDelete1();
          }
        } else {
          didDelete1();
        }
      }
    );
  } catch (err) {
    logError(633891, "Failed get to deleted item id=" + json.exid + ".  Ignoring.  Error: " + err.description);
    didDelete1();
  }
}

// Note 155.  The expression (item.foo != null) only if foo is not null and also that foo is not undefined.  See http://constc.blogspot.com/2008/07/undeclared-undefined-null-in-javascript.html

function deleteItemAfterRecursivelyMovingAnyChildrenToLimbo(children, limboInfo, i, deleteeId) {
  if (i > 0) {
    // Remove next child (going down)
    i = i - 1;
    var child = children[i];
    chrome.bookmarks.move(child.id, limboInfo, function(result) {
      limbo.push(child.id);
      console.log("Moved to limbo: " + child.id + " " + child.title);
      deleteItemAfterRecursivelyMovingAnyChildrenToLimbo(children, limboInfo, i, deleteeId);
    });
  } else {
    // All children, if any, have been safely moved to limbo.  Remove the parent.
    chrome.bookmarks.removeTree(deleteeId, didDelete1);
  }
}

function doNextPut() {
  var i = jsonArray.length - nToDo;
  var nDone = i+1;
  reportProgress(2, 3, nDone, nToDo+nDone);
  var json = jsonArray[i];
    
  var parentProposedExid;
  var parentAssignedExid;
  var parentExid;
  if (json.isNew == true) {
    // Use the parent's new exid instead of the one assigned by BookMacster.
    // (This is why, in BookMacster, we sorted insertions by increasing
    // depth.  Otherwise, this would not work.)
    parentProposedExid = json.parentExid;
    parentAssignedExid = assignedVsProposedExids[parentProposedExid];
        
    if (parentAssignedExid != null) {
      parentExid = parentAssignedExid;
    }
    else {
      // Parent is an existing item
      parentExid = parentProposedExid;
    }
        
    try {
      var attributes = {
        parentId: parentExid,
        index: json.index,
        title: json.name,
        url: json.url
      };
      /* Firefox only: */
      if (json.type == "separator") {
          attributes.type = "separator";
          delete attributes.title;  // or Firefox errors
      }

      chrome.bookmarks.create(attributes,
      function didInsert1(newItem) {
        if (newItem) {
          if (!(exidFeedbacks[newItem.parentId])) {
            exidFeedbacks[newItem.parentId] = {};
          }
          exidFeedbacks[newItem.parentId][newItem.index] = newItem.id;
          assignedVsProposedExids[json.exid] = newItem.id;
        } else {
          // For some reason, the create[2] try/catch does not catch this error
          logError(633892, "Failed create[1] new bookmark with parentExid=" + parentExid + " index=" + json.index + " title: " + json.name + " url: " + json.url);
        }
        checkPhase();
        if ((nToDo > 0) && (phase == phasePut)) {
          doNextPut();
        }
      });
    }
    catch (err) {
      logError(633893, "Failed create[2] new bookmark with parentExid=" + parentExid + " index=" + json.index + " title: " + json.name + " url: " + json.url + " Error: " + err.description);
    }
  }
  else {
    var destinInfo = {};

    parentProposedExid = json.parentExid;
    parentAssignedExid = assignedVsProposedExids[parentProposedExid];
    if (parentAssignedExid) {
      parentExid = parentAssignedExid;
    } else {
      parentExid = parentProposedExid;
    }
    destinInfo.parentId = parentExid;
    if (json.index != null) {
      destinInfo.index = json.index;
    }

    chrome.bookmarks.move(json.exid, destinInfo, function(movedItem) {
      /* This object has a new parent and is therefore no longer
      in limbo.  We must remove it from limbo so that it is
      not deleted during phaseDone. */

      /* Regarding next line, see Note LastError at end of file. */
      if(chrome.runtime.lastError) {
        logError(632384, "Failed moving id=" + json.exid + " to", destinInfo, ".  Ignoring.  Error: " + chrome.runtime.lastError.message);
      } else {
        try {
          var movedItemId = movedItem.id;
          removeObjectFromArray(limbo, movedItemId);
        } catch (err) {
          logError(637743, "Could not get id for item " + json.exid + " moved to " + destinInfo.description);
        }
      }
      checkPhase();
      if ((nToDo > 0) && (phase == phasePut)) {
        doNextPut();
      }
    });
  }
}

function doNextRepair() {
  var i = jsonArray.length - nToDo;
  var nDone = i+1;
  reportProgress(3, 3, nDone, nToDo+nDone);
  var json = jsonArray[i];
  var changesOut = {};
  
  if (json.name || json.url) {
    if (json.name) {
      changesOut.title = json.name;
    }
    if (json.url) {
      changesOut.url = json.url;
    }
    chrome.bookmarks.update(json.exid, changesOut,
    function(updatedItemNotUsed) {
      checkPhase();
      if ((nToDo > 0) && (phase == phaseRepair)) {
        doNextRepair();
      }
    });
  } else {
    checkPhase();
    if ((nToDo > 0) && (phase == phaseRepair)) {
      doNextRepair();
    }
  }
}

function ssyP2E_getProfile() {
  var profileName = storageCache.profileName;
  if (!profileName) {
    profileName = "SORRY-NULL-PROFILE";
    // Warning: That string matches one in constSorryNullProfile in BkmxGlobals.h
  }
  return profileName;
}

function putExportAndSendExids(jsonTree) {
  exidFeedbacks = {};
  assignedVsProposedExids = {};
  jsonRoot = jsonTree;
  phase = phaseBegin;
  nToDo = 1;
  barId = 0 ; // Fail-safe to 0
  limbo = new Array();
    
  // Get the id of Bar so we can move limbo-fied items into it.
  chrome.bookmarks.getTree(function(findings) {
    if (findings.length > 0) {
      var root = findings[0];
      var rootChildren = root.children;
      if (rootChildren) {
        if (rootChildren.length > 0) {
          var bar;
          rootChildren.every(x => {
            if (x.id == "toolbar_____") {
              bar = x;
              console.log("For Limbo, got Firefox' Bar, guid=", bar.id);
              return false; // Break out of this little .every loop
            }
            return true; // Continue to next .every x
          });
          if (!bar) {
            bar = rootChildren[0];
            if (bar) {
          		console.log("For Limbo, got Chromy's Bar, guid=", bar.id);
          	} 
          }
          if (bar) {
            barId = bar.id;
            // Begin actual work
            checkPhase();
          } else {
            logError(639646, " No Bar.  Need Bar for Limbo");
          }
        } else {
          logError(639656, " 0 root children");
        }
      } else {
        logError(639666, " Null root children");
      }
    }
    else {
      logError(639676, " Not 1 root but " + findings.length);
    }
  });
}

var progressReportInterval = 250 ; // milliseconds
var timeOfLastProgressReport = new Date();

function reportProgress(majorNum, majorDen, minorNum, minorDen) {
  var timeNow = new Date();
  if (timeNow - timeOfLastProgressReport > progressReportInterval) {
    timeOfLastProgressReport = timeNow;
    var progress = {
      progressMajorNum: majorNum,
      progressMajorNum: majorNum,
      progressMinorNum: minorNum,
      progressMinorDen: minorDen
    };
    port.postMessage({progress: progress});
  }
}

console.log("Will start");
startUp();
console.log("Did start");

/*

Note LastError

Checking for chrome.runtime.lastError is necessary because, in asynchrous code,
try{} does not necessarily catch all errors.  For further study see:
https://stackoverflow.com/questions/28431505/unchecked-runtime-lasterror-when-using-chrome-api
*/
