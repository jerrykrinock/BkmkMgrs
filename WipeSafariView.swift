import Cocoa
import SwiftUI
import SSYSwift

@objc
class WipeSafariController : NSWindowController {
    var view: WipeSafariView? = nil
    
    @objc func makeWindow() {
        self.view = WipeSafariView()
        self.window = NSWindow.makeAndShowSwiftUI(view: self.view, title: NSLocalizedString("Wipe out all bookmarks in Safari?", comment:"title of a window"))
    }
    
    @objc
    func closeWindow() {
        self.close()
    }
}

struct WipeSafariView: View {
    var advice : String {
        get {
            var currentChanges: String = "Trick to avoid if-let"
            do {
                let changeCount = try SafariWiper().currentChangeCount()
                if (changeCount > 0) {
                    currentChanges = "you currently have \(String(changeCount)) Change Orders in your Safari bookmarks file which are waiting to be pulled into iCloud"
                } else {
                    currentChanges = "your Safari Bookmarks file is \"clean\".  There are no Change Orders in it.  Maybe you don't want to do this"
                }
            }
            catch {
                currentChanges = "The changes in your file could not be counted because " + String.init(describing: error)
            }
            let rawText = """
            IMPORTANT: Consider doing this only if you are experiencing iCloud not syncing for 24 hours or more.
            
            There is a Safari bookmarks file on your Mac (~/Safari/Bookmarks.plist) which stores your bookmarks, folders, and *Change Orders* – orders for changes you have made which have not yet been pulled into iCloud by its Agent.  Change Orders can be, for example, orders to add a certain new bookmark, or move or delete a certain bookmark.  On a good day, Change Orders are pulled into iCloud within seconds after you make a change.  Change Orders are deleted from your file upon being pulled, so your file should almost always contain 0 Change Orders.  However, if your Mac does not have internet access, or if iCloud is just being slow, Change Orders can persist until internet access reappears, and/or up to, in our experience, 24 hours.
            
            We just looked and found that \(currentChanges).
            
            If Change Orders persist in the file for more than 24 hours, and you've had internet access, iCloud's Agent may what we call \"Dazed\".  iCloud's Agent can be Dazed by inconsistent Change Orders, for example, a Change Order to delete a nonexistent bookmnark, or add a new bookmark to a nonexistent folder.  iCloud's Agent typically reacts by saying \"I don't know what to do about this, so I'm going to shut down and not do anything!\".
            
            Clicking the \"Wipe Safari !\" button below will delete all of your bookmarks and folders in Safari, and also delete any Change Orders in your Safari bookmarks file.
            
            Recommended Usage:
            
            • In this app, switch Syncing to Paused or Off.
            • Verify that all of your bookmarks, folders and Reading List items are safely stored in this app.  (Import and reorganize as necessary.)
            • On all of your other devices connected to your iCloud account, in Safari, delete all bookmarks, folders and Reading List items.
            • Click the button below to \"Wipe Safari !\" in this Mac account.
            • Wait at least 20 minutes.  If you are not in a hurry, wait 24 hours.
            • If bookmarks or folders return on any devices, delete them again, or on this Mac, \"Wipe Safari !\" again.
            • Repeat until all devices stay wiped.
            • Again, wait 20 minutes to 24 hours.
            """
            
            let wipeSafariAdvice = NSLocalizedString(rawText, comment:"")
            return wipeSafariAdvice
        }
    }
    var body: some View {
        VStack {
            Text(self.advice)
            /* We want the vertical dimension of the view to be the so-called
             "ideal size" of the view, in other words, the height required to
             display all of the text content.  So, we set vertical: to true.
             But we want the horizontal size to defer to some other influencer
             (the .frame width in this case).  So we set the horizontal: to
             false.  I think that a better name for .fixedSize layout modifier
             would be .fitToContent() or .sizeToFit() as it is in AppKit. */
                .fixedSize(horizontal: false, vertical: true)
            HStack {
                Button(action: {
                    let result = SafariWiper().wipe()
                    self.closeWindow()
                    SSYMonologWindowController.makeWindow(title: NSLocalizedString("Result", comment:"title of a window"),
                                                          text: result)
                }) {
                    Text(NSLocalizedString("Wipe Safari !", comment: "Label on a button"))
                }
                Button(action: {
                    self.closeWindow()
                }) {
                    Text(NSLocalizedString("Cancel", comment: "Label on a button"))
                }
            }
        }
        
        /* The following layout modifiers are apparently applied to the entire
         View, not the VStack. */
        .frame(width: 600)
        .padding(EdgeInsets(top: 20.0, leading: 20.0, bottom: 20.0, trailing: 20.0))
    }
    
    private func closeWindow() {
        /* This works, but cannot be the the correct way!!! */
        NSApplication.shared.keyWindow?.close()
    }
}
