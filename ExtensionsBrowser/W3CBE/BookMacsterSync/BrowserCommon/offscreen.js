
chrome.runtime.onMessage.addListener(handleMessages);

async function handleMessages(message) {
  // Return early if this message isn't meant for the offscreen document.
  if (message.target !== 'offscreen-doc') {
    return;
  }

  switch (message.type) {
    case 'request-legacy-stored-info':
      sendLegacyStoredInfo();
      break;
    case 'close-yourself':
      closeMe();
      break;
    default:
      console.warn(`Unexpected message type received: '${message.type}'.`);
  }
}

async function sendLegacyStoredInfo() {
	chrome.runtime.sendMessage({
	type: 'legacy-stored-info',
	target: 'my-service-worker',
	extoreName: localStorage.extoreName,
	profileName: localStorage.profileName,
  });
}

async function closeMe() {
     window.close();
}
