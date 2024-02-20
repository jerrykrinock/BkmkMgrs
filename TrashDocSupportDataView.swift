import Cocoa
import SwiftUI

let docRowHeight = 72.0


@available(macOS 10.15, *)
@objc
class CleanDocSupportFilesController : NSWindowController {
    var directoryWatcher: DirectoryWatcher? = nil
    var view: TrashDocSupportDataView? = nil
    
    @ObservedObject var docSupportBag: DocSupportBag = DocSupportBag()

    @objc func makeWindow() {
        self.refreshBagFromDisk()

        var height = 80.0  // margins above and below the entire view?
        
        // Will break with Sys Settings > Accesiibility > Bigger fonts
        // Maybe fixed row size will help, not need this calculation

        if (docSupportBag.oldAppVersionCrufts.count > 0) {
            /* Has top section aka "Trash files from old versions" */
            height += 74.0  // Short explanatory text, button and margins
        }
        if (docSupportBag.docSupports.count > 0) {
            /* Has bottom section, with the List/Table */
            height += 301.0 // Long explanatory text
            height += 47.0 // Button and its margins
            height += docRowHeight * CGFloat(docSupportBag.docSupports.count)
        }
        if (docSupportBag.oldAppVersionCrufts.count == 0 && docSupportBag.docSupports.count == 0) {
            height += 50  //  "No document support files found…" text
        }
        
        self.view = TrashDocSupportDataView(docSupportBag,
                                           trashAllOldFiles: {self.trashAllOldFiles()},
                                           trashIfDoCurrentFiles: {self.trashIfDoCurrentFiles()}
                                           )

        /* To someone unfamiliar with SwiftUI, it looks like the following line
         passes a *frame* to the rootView:, but no because .frame(…) is in
         fact a Layout Modifier which returns the view which called it.*/
        let hostingController = NSHostingController(rootView: view.frame(width: 800, height: height))
        let window = NSWindow(contentViewController: hostingController)
        /* The following is necessary so that -[SSYWindowHangout windowDidCloseNote:] will
         get invoked when this window closes.  In fact, I'm somewhat sure that this is the
         only reason why this class needs to inherit from NSWindowController. */
        self.window = window
        window.title = NSLocalizedString("Trash crufty document support files…", comment: "");
 
        guard let appSupportPath = Bundle.mainAppBundle().applicationSupportPathForMotherApp() else {
            self.logError(code: 828517,
                          desc: "Could not get app support path",
                          underlyingError: nil)
            return
        }

        do {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.handleChangesOnDisk),
                                                   name: Notification.Name(rawValue: "TrashDocKludgeWorkaround"),
                                                   object: nil)
            
            /* Create a DirectoryWatch */
            let rawPointerToSelf = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            //let context = UnsafeMutablePointer<FSEventStreamContext>(self)
            let retainer = {CFBridgingRetain($0); return $0} as CFAllocatorRetainCallBack

            var context = FSEventStreamContext(version: 0,
                                               info: rawPointerToSelf,
                                               retain: retainer,
                                               release: nil,
                                               copyDescription: nil) // tried {_ in Unmanaged(_private: "Anybody home?" as CFString)})
            self.directoryWatcher = try DirectoryWatcher(
                /* Parm 1, specifies directory of directories to watch */
                [appSupportPath],
                /* Parm 2, a FSEventStreamContext whose pointee is 'self', which will be passed to the callback closure */
                &context,
                /* Parm 3, the callback closure */
                {( streamRef: ConstFSEventStreamRef,
                   clientCallbackInfo: UnsafeMutableRawPointer?,
                   numEvents: Int,
                   eventPaths:UnsafeMutableRawPointer,
                   eventFlags:UnsafePointer<FSEventStreamEventFlags>,
                   eventIds: UnsafePointer<FSEventStreamEventId>) -> Void in
//  The following crashes at runtime
//                 Crash #1 in next line:
//                    let self2 = clientCallbackInfo?.bindMemory(to: CleanDocSupportFilesController.self, capacity: 1) as UnsafeMutablePointer<CleanDocSupportFilesController>?
//                    self2?.pointee.refreshBagFromDisk()
//                    let pathsPointer = eventPaths.bindMemory(to: Array<String>.self, capacity: 8)
//                    let paths = pathsPointer.pointee
//                 If Crash #1 is commented out, then crash #2 in next line:
//                    print("changed paths are: \(paths)")
                    // To work around the above crashes, I use this instead…
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "TrashDocKludgeWorkaround")))
                })
        } catch {
            self.logError(code: 828518,
                          desc: "Could not get app support path",
                          underlyingError: nil)
            return
        }

        window.display()
        window.makeKey()
        window.orderFront(self)
    }
    
    @objc
    func closeWindow() {
        self.close()
    }
    
    @objc  // Why does the Swift 'NotificationCenter' (not NS…) require @objc ???
    func handleChangesOnDisk() {
        self.refreshBagFromDisk()
    }

    func refreshBagFromDisk() {
        self.docSupportBag = DocSupportFileFinder.docSupportsOnDisk()
       /* The following is my attempt to get the view to update after files
         have been deleted.  It should not be necessary if SwiftUI magic is
         working properly.  But the the view does not update, with or without
         the following line. */
        self.view?.docSupportBag = self.docSupportBag
    }
    
    func trashAllOldFiles() {
        for url in self.docSupportBag.oldAppVersionCrufts {
            do {
                try FileManager.default.trashItem(at: url, resultingItemURL:nil)
            } catch {
                
            }
        }
    }

    private func trashIfDoCurrentFiles() {
        for docSupport in self.docSupportBag.docSupports {
            self.trashifDoDocSupport(docSupport)
        }
    }

    
    func trashifDoDocSupport(_ docSupport: DocSupport) {
        self.trashIfDoDelete(metadata: docSupport.exids, docName: docSupport.docName)
        self.trashIfDoDelete(metadata: docSupport.settings, docName: docSupport.docName)
        self.trashIfDoDelete(metadata: docSupport.syncLogs, docName: docSupport.docName)
    }
    
    private func trashIfDoDelete(metadata: DocSupportMetadata?, docName: String?) {
        if let metadata = metadata {
            if (metadata.doTrash) {
                let logDocName = docName ?? "NO-NAMO"
                let logFileUrlBase = (metadata.fileUrlBase ?? URL(fileURLWithPath:"NO-URL-BASE")).lastPathComponent
                BkmxBasis.shared().logString("DSC is trashing for \(logDocName): \(logFileUrlBase)")
                var nFailures = 0;
                var logError: Error? = nil;
                /* "try" each of these separately, because any one of them might fail due to "file not found". */
                do {
                    if let url = metadata.fileUrlBase?.appendingPathExtension("sql") {
                        try FileManager.default.trashItem(at: url,
                                                          resultingItemURL: nil)
                    }
                } catch {
                    nFailures += 1
                    logError = error
                }
                do {
                    if let url = metadata.fileUrlBase?.appendingPathExtension("sql-shm") {
                        try FileManager.default.trashItem(at: url,
                                                          resultingItemURL: nil)
                    }
                } catch {
                    logError = error
                }
                do {
                    if let url = metadata.fileUrlBase?.appendingPathExtension("sql-wal") {
                        try FileManager.default.trashItem(at: url,
                                                          resultingItemURL: nil)
                    }
                } catch {
                    logError = error
                }

                if (nFailures == 3) {
                    self.logError(code: 828206,
                                  desc: "Could not trash \(metadata.fileUrlBase?.path ?? "<UNKNOWN-PATH>").xxx",
                                  underlyingError: logError)
                }
            }
        }
    }
    
    private func logError(code: Int, desc: String, underlyingError: Error?) {
        BkmxBasis.shared().logErrorInformational(domain:"DocSupportFileTrasher",
                                                 code: code,
                                                 desc: desc,
                                                 underlyingError: underlyingError);
    }
}


@available(macOS 10.15, *)
struct TrashDocSupportDataView: View {
    var trashAllOldFiles: () -> Void
    var trashIfDoCurrentFiles: () -> Void
    @State var docSupportBag: DocSupportBag

    init(
        _ docSupportBag: DocSupportBag,
        trashAllOldFiles: @escaping () -> Void,
        trashIfDoCurrentFiles: @escaping () -> Void
    ) {
        self.docSupportBag = docSupportBag
        self.trashAllOldFiles = trashAllOldFiles
        self.trashIfDoCurrentFiles = trashIfDoCurrentFiles
    }
    
    var oldFilesAdvice: String? {
        if (docSupportBag.oldAppVersionCrufts.count > 0) {
            let format = NSLocalizedString("You have %@ in files that were migrated from old versions of %@.  Unless you think you might want ever to revert to an old version, you should trash these old-version files.", comment:"")
            return String (
                format: format,
                ByteCountFormatter.string(fromByteCount:Int64(docSupportBag.oldAppVersionCruftByteCount), countStyle: .file),
                BkmxBasis.shared().appNameLocalized)
        } else {
            return nil
        }
    }
    
    var currentFilesAdvice: String? {
        if (docSupportBag.docSupports.count > 0) {
            let adviceAfterKey = BkmxBasis.shared().isShoeboxApp() ? "trashDocSupportAfterShoebox" : "trashDocSupportAfterBookMacster"
            let adviceSuffix = NSLocalizedString(adviceAfterKey, comment: "")
            return String (
                format: NSLocalizedString("trashDocSupportEssay", comment:""),
                BkmxBasis.shared().appNameLocalized,
                BkmxBasis.shared().appNameLocalized,
                BkmxBasis.shared().appNameLocalized,
                BkmxBasis.shared().appNameLocalized,
                BkmxBasis.shared().labelClients(),
                BkmxBasis.shared().labelClients(),
                adviceSuffix
            )
        } else {
            return nil
        }

    }


    var body: some View {
        VStack {
            if let oldFilesAdvice = self.oldFilesAdvice {
                Text(oldFilesAdvice)
                    .multilineTextAlignment(TextAlignment.leading)
                    .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                Button(action: {self.trashAllOldFiles()}) {
                    Text(NSLocalizedString("Trash files from old versions", comment: "Label on a button"))
                }
            }
            
            if (self.oldFilesAdvice != nil && self.currentFilesAdvice != nil) {
                Divider().padding(EdgeInsets(top: 1.0, leading: 0.0, bottom: 1.0, trailing: 0.0))
            }

            if let currentFilesAdvice = self.currentFilesAdvice {
                Text(currentFilesAdvice)
                    .multilineTextAlignment(TextAlignment.leading)
                    .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                
                Divider().padding(EdgeInsets(top: 1.0, leading: 0.0, bottom: 1.0, trailing: 0.0))
                
                HStack {
                    Text(NSLocalizedString("Document Name", comment: ""))
                        .frame(width: 176.0)
                    /* Vertical divider line gits 1.0 px margin on leading and trailing. */
                    Divider().padding(EdgeInsets(top: 0.0, leading: 1.0, bottom: 0.0, trailing: 1.0))
                    Text(NSLocalizedString("Client Associations", comment: ""))
                        .frame(width: 176.0)
                    /* Vertical divider line gits 1.0 px margin on leading and trailing. */
                    Divider().padding(EdgeInsets(top: 0.0, leading: 1.0, bottom: 0.0, trailing: 1.0))
                    Text(NSLocalizedString("Settings", comment: ""))
                        .frame(width: 176.0)
                    /* Vertical divider line gits 1.0 px margin on leading and trailing. */
                    Divider().padding(EdgeInsets(top: 0.0, leading: 1.0, bottom: 0.0, trailing: 1.0))
                    Text(NSLocalizedString("Sync Logs", comment: ""))
                        .frame(width: 176.0)
                }
                .frame(width: 760, height:10)
                .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                
                /* If deploying to macOS 12 or later, replace List with Table, which looks
                 much nicer, particularly because it features column headers.  Example:
                 https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-multi-column-lists-using-table
                 But today we still support users with macOS 11 :(  */
                List {
                    ForEach(self.docSupportBag.docSupports) { docSupport in
                        Divider().padding(EdgeInsets(top: 1.0, leading: 0.0, bottom: 1.0, trailing: 0.0))
                        HStack {
                            Text(docSupport.docName ?? NSLocalizedString("Could not find file for doc reference \(docSupport.abbreviatedId)-….  Maybe never saved?  Deleted?", comment: ""))
                                 /* The "?" will cause it to be sorted to the top of other names. */
                                .frame(width: 175.0)
                                .truncationMode( .tail)
                                .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))

                            /* Vertical divider line gets 1.0 px margin on leading and trailing. */
                            Divider().padding(EdgeInsets(top: 0.0, leading: 1.0, bottom: 0.0, trailing: 1.0))

                            /* Make the three columns which have the checkboxes. */
                            TableBodyCell((docSupportBag.docSupports[docSupport.index!]).exids!)
                            TableBodyCell((docSupportBag.docSupports[docSupport.index!]).settings!)
                            TableBodyCell((docSupportBag.docSupports[docSupport.index!]).syncLogs!)
                        }
                    }
                }
                /* https://stackoverflow.com/questions/58242342/swiftui-row-height-of-list-how-to-control */
                .frame(height: 21.0 + CGFloat(self.docSupportBag.docSupports.count)*docRowHeight)

                /* List seems to have an annoying margin of about 15 points, at
                 lease on 3 sides.  To demonstrate thie, uncomment: */
                // .border(.red)
                /* You can partially get rid of this margin by passing
                 negative edge insets, up to the point where its margin begins
                 to clip a neighboring view. */
                .padding(EdgeInsets(top: -5.0, leading: -15.0, bottom: -15.0, trailing: -15.0))
                /* Maybe instead of that you could clip it with a rect that was
                 slightly smaller?  Maybe something like this…
                 .clipShape(ListClipRect(thisList)
                 Also tried fixing it by using zIndex, but as expected this had
                 no effect because .zIndex only has an effect inside a ZStack
                 .zIndex(-1)
                 */
                
                Divider().padding(EdgeInsets(top: 1.0, leading: 0.0, bottom: 1.0, trailing: 0.0))
                
                HStack {
                    Button(action: {self.trashIfDoCurrentFiles()}) {
                        Text(NSLocalizedString("Trash data files with checkmarks", comment: "Label on a button"))
                    }
                    Button(action: {self.closeWindow()}) {
                        Text(NSLocalizedString("Done", comment: "Label on a button"))
                    }
                }
                .padding(EdgeInsets(top: 10.0, leading: -0.0, bottom: 0.0, trailing: 0.0))
            }
            if (oldFilesAdvice == nil && currentFilesAdvice == nil) {
                Text(NSLocalizedString("No document support files found.  Either you are a very new user, or something is wrong.  There should be 6 or 9 .sql files with long jibberish names for each of your .bmco documents in:\n   \(String(describing: Bundle.mainAppBundle().applicationSupportPathForMotherApp()))\n (Synkmark, Markster and Smarky use only one .bmco document.)", comment:""))
            }
        }
        /* Margins to window edges */
        .padding(EdgeInsets(top: 20.0, leading: 22.0, bottom: 20.0, trailing: 21.0))
    }
        
    private func closeWindow() {
        /* This works, but cannot be the the correct way!!! */
        NSApplication.shared.keyWindow?.close()
    }
}

@available(macOS 10.15, *)
struct TableBodyCell : View {
    @ObservedObject private var metadata: DocSupportMetadata

    init(_ metadata: DocSupportMetadata) {
        self.metadata = metadata
    }
    
    var body: some View {
        if self.metadata.type != nil {
            VStack {
                Text(NSLocalizedString("Disk space", comment:"") + ": " + ByteCountFormatter.string(fromByteCount:Int64(metadata.size ?? 0), countStyle: .file))
                
                Text(NSLocalizedString("Last read", comment:"the most recent date that a file was read for any purpose") + ": " + ShortDateFormatter.dateFormatter.string(from: self.metadata.lastUsed!))
                
                Toggle(
                    NSLocalizedString("Trash", comment:"command to move file(s) to the computer's Trash"),
                    isOn: Binding (
                        get: {
                            return self.metadata.doTrash
                        },
                        set: {(newValue) in
                            self.metadata.doTrash = newValue
                        }
                    )
                )
                .toggleStyle(.checkbox)
                .padding(EdgeInsets(top: -8.0, leading: 0.0, bottom: -5.0, trailing: 0.0))
            }
            .frame(width: 175.0)
            .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
        } else {
            Text(NSLocalizedString("No files", comment:""))
                .frame(width: 175.0)
                .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
        }
        
        Divider().padding(EdgeInsets(top: 1.0, leading: 0.0, bottom: 1.0, trailing: 0.0))
    }

}

class ShortDateFormatter : DateFormatter {
    static var dateFormatter : DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }()
}
