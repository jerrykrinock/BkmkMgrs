function dumpText(text) {
	console.log(new Date() + " " + text) ;
}

var port;
var extensionVersion;
var extensionName;

function startListening() {
	chrome.browserAction.onClicked.addListener(function(tab) {
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

function connectNativeMessaging() {
  try {
    let hostName = "com.sheepsystems.chromessenger";
    console.log("Will connect");
    port = chrome.runtime.connectNative(hostName);
    console.log("Did connect");
  } catch (error) {
    console.log("Error 737-9519:", error);
  }
  if (!port) {
    console.log("Error 727-4883, connectNative did not return port");
  }
  
  // Send the newly-created Chromessenger its identity:
  var profileName = localStorage.profileName;
  var extoreName = localStorage.extoreName;
  if (!profileName) {
    profileName = "SORRY-NULL-PROFILE";
    // @"SORRY-NULL-PROFILE" matches constSorryNullProfile in BkmxGlobals.h
  }
  if (!extoreName) {
    extoreName = "SORRY-NULL-EXTORE";
    // @"SORRY-NULL-EXTORE" matches constSorryNullExtore in BkmxGlobals.h
  }
  var startupInfo = {
    extensionVersion: extensionVersion,
    extensionName: extensionName,
    profileName: profileName,
    extoreName: extoreName
  };
  try {
    port.postMessage({startupInfo: startupInfo});
  } catch (error) {
    console.log("Error 783-4874 Failed to post startupInfo:", error);
  }
  console.log("Waiting for Native Messages with info:", startupInfo);
    
  port.onMessage.addListener(function(rxObject) {
    console.log("Got a message from Chromessenger: ", rxObject);
    let command = rxObject.command;
    
    if (command == "configureBasicInfo") {
      console.log("configureBasicInfo");
      let profileName = rxObject.profileName;
      if (profileName) {
        localStorage.profileName = profileName;
        console.log("configured profileName:", localStorage.profileName);
      }
      let extoreName = rxObject.extoreName;
      if (extoreName) {
        localStorage.extoreName = extoreName;
        console.log("configured extoreName:", localStorage.extoreName);
      }
    } else if (command == "grabCurrentPageInfo") {
      chrome.tabs.query({active: true, lastFocusedWindow: true}, function(tabs) {
        var tab = tabs[0];

        let grabbedInfo = {name: tab.title, url: tab.url};
        port.postMessage({grabbedInfo: grabbedInfo});
      });      
    }
  });
}

function startUpPart2() {
  connectNativeMessaging();
  startListening() ;
}



function startUp() {
  /* We wrap the whole startup in a delay of 5 seconds to ensure that, if
  installed, our Sync extension loads and grabs our named CFMessagePort o
  on the system before we do.  See Sync extension's script.js > startUp()
  to learn another reason for this delay. */
  setTimeout(function() {
    var xhr = new XMLHttpRequest();
    xhr.responseType = "json";
    xhr.onreadystatechange = function() {
      if (xhr.readyState == 4) {
        let manifest = xhr.response;
        extensionVersion = manifest['version'];
        extensionName = manifest['name'];
        startUpPart2();
      }
    };

    xhr.open('GET', 'manifest.json');
    xhr.send();
  }, 5000) ;
}


document.addEventListener('DOMContentLoaded', function () {
  startUp();
});
