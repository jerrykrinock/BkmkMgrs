import Foundation

enum DocSupportDataType {
    case exids
    case settings
    case syncLogs
}

@available(macOS 10.15, *)
class DocSupportMetadata: ObservableObject {
    init(_ type: DocSupportDataType?) {
        self.type = type
    }
    var type: DocSupportDataType?
    var fileUrlBase: URL?
    var size: Int! = 0
    var lastUsed: Date?
    @Published var doTrash = false
    
}

@available(macOS 10.15, *)
class DocSupport : Identifiable, ObservableObject {
    var id: UUID? = nil
    var docName: String? = nil
    @Published var exids: DocSupportMetadata?
    @Published var settings: DocSupportMetadata?
    @Published var syncLogs: DocSupportMetadata?
    var index: Int? = 0
    
    var abbreviatedId: String {
        guard let string = self.id?.uuidString else {
            return "????"
        }
        return String(string.prefix(4))
    }
}

@available(macOS 10.15, *)
class DocSupportBag: ObservableObject {
    @Published var docSupports: [DocSupport] = []
    @Published var oldAppVersionCrufts: [URL] = []
    @Published var oldAppVersionCruftByteCount: Int = 0
}

@available(macOS 10.15, *)
struct DocSupportFileFinder {
    static func docSupportsOnDisk() -> DocSupportBag {
        var docSupportsDic = [String : DocSupport]()
        var oldAppVersionCrufts = [URL]()
        var oldAppVersionCruftByteCount = 0
        let docController = NSDocumentController.shared as! BkmxDocumentController
        /* Cache these for performance */
        var docPaths = [String: String]()
        
        guard let appSupportPath = Bundle.mainAppBundle().applicationSupportPathForMotherApp() else {
            self.logError(code: 828201,
                          desc: "Could not get app support path",
                          underlyingError: nil)
            return DocSupportBag()
        }
        let appSupportUrl = URL(fileURLWithPath: appSupportPath)
        var appSupportFilenames: [String]
        do {
            appSupportFilenames = try FileManager.default.contentsOfDirectory(atPath: appSupportPath)
        } catch {
            self.logError(code: 828202,
                          desc: "Could not get filenames in app support directory",
                          underlyingError: error)
            return DocSupportBag()
        }
        for filename in appSupportFilenames {
            let typeSignature = filename.prefixUpTo("-")
            var dataType: DocSupportDataType
            if (typeSignature == constBaseNameSettings) {
                dataType = DocSupportDataType.settings
            } else if (typeSignature == constBaseNameExids) {
                dataType = DocSupportDataType.exids
            } else if (typeSignature == constBaseNameDiaries) {
                dataType = DocSupportDataType.syncLogs
            } else {
                /* This is not a doc support file.  Ignore */
                continue
            }
            
            guard let docUuid = filename.stringBetween(startingSeparator: "-", endingSeparator: ".") else {
                self.logError(code: 828231,
                              desc: "Could not get uuid from \(filename)",
                              underlyingError: nil)
                continue
            }
            let fileUrl = appSupportUrl.appendingPathComponent(filename)
            var resourceValues: URLResourceValues
            do {
                resourceValues = try fileUrl.resourceValues(forKeys: [.fileSizeKey, .contentAccessDateKey])
            } catch {
                self.logError(code: 828204,
                              desc: "Could not get attributes of \(fileUrl.absoluteString)",
                              underlyingError: error)
                continue
            }
            let size = resourceValues.fileSize ?? 0
            let lastUsed = resourceValues.contentAccessDate
            if docUuid.hasSuffix("~") {
                oldAppVersionCrufts.append(fileUrl)
                oldAppVersionCruftByteCount += size
                continue
            }

            var docPath: String?
            var docName: String?
            /* The "?" will cause it to be sorted to the top of other names. */
            var docUrl: URL? = nil
            do {
                docPath = try docPaths[docUuid] ?? docController.pathOfDocument(withUuid: docUuid,
                                                                                appName: BkmxBasis.shared().mainAppNameUnlocalized,
                                                                                timeout: 5.0,
                                                                                trials: 3,
                                                                                delay: 1)
                if let docPath = docPath {
                    /* cache it */
                    docPaths[docUuid] = docPath
                    
                    docUrl = URL(fileURLWithPath: docPath)
                    if let docUrl = docUrl {
                        docName = docUrl.deletingPathExtension().lastPathComponent
                    } else {
                        docName = "? Error 283-7843"
                        /* The "?" prefix will cause it to be sorted to the top of other names. */
                    }
                }
            } catch {
                /* Leave docName as nil.  When we sort at the end of this func, our
                 sorting closure will use "?" as the docName.  When the view is
                 drawn, the View.body will substitute in a placeholder. */
            }
            guard let uuid = UUID(uuidString:docUuid) else {
                self.logError(code: 828205,
                              desc: "Could not generate UUID from docUuid \(docUuid)",
                              underlyingError: nil)
                continue
            }
            
            if (docSupportsDic[docUuid] == nil) {
                let docSupport = DocSupport()
                docSupport.id = uuid
                docSupport.docName = docName
                docSupportsDic[docUuid] = docSupport
            }
            var metadata: DocSupportMetadata? = nil
            switch dataType {
            case .settings:
                metadata = docSupportsDic[docUuid]?.settings
            case .exids:
                metadata = docSupportsDic[docUuid]?.exids
            case .syncLogs:
                metadata = docSupportsDic[docUuid]?.syncLogs
            }
            if (metadata == nil) {
                /* We delete the path extension of fileUrl because it may be
                 either .sql, .sql-shm or .sql-wal.  We shall append that later if
                 user if commands to delete the files. */
                let newMetadata = DocSupportMetadata(dataType)
                newMetadata.fileUrlBase = fileUrl.deletingPathExtension()
                newMetadata.lastUsed = Date.distantPast
                metadata = newMetadata
            }
            
            /* The following does not help the compiler to realize that
             metadata cannot be nil at this point*/
            guard metadata != nil else {
                return DocSupportBag()
            }
            
            /* Why are the bangs necessary, since obviously from reading the code
             above, you can see that metadata cannot be nil.*/
            metadata!.size += size
            metadata!.lastUsed = lastUsed
            
            switch dataType {
            case .settings:
                docSupportsDic[docUuid]?.settings = metadata
            case .exids:
                docSupportsDic[docUuid]?.exids = metadata
            case .syncLogs:
                docSupportsDic[docUuid]?.syncLogs = metadata
            }
        }
        
        /* Extract DocSupport values from dic, and sort nice for the user interface
         interface by sorting. */
        let docSupports = Array(docSupportsDic.values).sorted {
            let name0 = $0.docName ?? "?"
            let name1 = $1.docName ?? "?"
            return name0.localizedCaseInsensitiveCompare(name1) == .orderedAscending
        }
        
        /* Set the .index property to follow the sorted order, to support the hack
         which we use to associate docSupport objects with list rows in the
         user interface.  See TrashDocSupportDataView.getter:body. */
        var indexedDocSupports: [DocSupport] = []
        var index = 0
        for docSupport in docSupports {
            docSupport.index = index
            index += 1
            
            indexedDocSupports.append(docSupport)

            /* One more thing.  The user interface will require that
             all three metadata objects are not nil.  If any had files
             not found, they will be nil.  So plug in empty metadata
             objects as needed, with a nil type so that MetadataView.getter:body
             will draw the "No files" placeholder instead of the usual
             (Disk Space, Last Used and "Trash" checkbox. */
            if docSupport.exids == nil {
                docSupport.exids = DocSupportMetadata(nil)
            }
            if docSupport.settings == nil {
                docSupport.settings = DocSupportMetadata(nil)
            }
            if docSupport.syncLogs == nil {
                docSupport.syncLogs = DocSupportMetadata(nil)
            }
        }
        
        let docSupportBag = DocSupportBag()
        docSupportBag.docSupports = indexedDocSupports
        docSupportBag.oldAppVersionCrufts = oldAppVersionCrufts
        docSupportBag.oldAppVersionCruftByteCount = oldAppVersionCruftByteCount
        return docSupportBag
    }
    
    private static func logError(code: Int, desc: String, underlyingError: Error?) {
        BkmxBasis.shared().logErrorInformational(domain:"DocSupportFileTrasher",
                                                 code: code,
                                                 desc: desc,
                                                 underlyingError: underlyingError);
    }
}


