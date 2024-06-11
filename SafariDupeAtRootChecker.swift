import Foundation
import SSYSwift

/* Requirement 2, noticed in macOS 11.4 Beta 4, Safari Version 14.1.1 (16611.2.7.1.4)
 Detect if there is any of a  If you do this in Safari's Edit
 Bookmarks – create two folders at root and leave one empty, then quit and
 relaunch Safari, the empty one will be gone after the relaunch.  Pajara
 will fail with Error 772030 if you try to export.  I have not determined
 the mechanism of that, but the mechanism is moot due to the behavior of
 Safari itself just described.
 */
/**
This class exposes of one public fund, class SafariDupeAtRootChecker.error(_:),
 which checks bookmarks proposed to be exported to Safari.
 */
class SafariDupeAtRootChecker : NSObject {

    /**  Checks an array of root children for either of the two duplicate
     types which are disallowed by Safari.
     
     (1) Problem Bookmarks.  A group of two or more bookmarks at root with the
     same name and same URL.
     (2) Problem Folders.  A group of two or more folders at root with the same
     name.
     
     - parameter starks: A set of Stark objects, assumed to be the immediate
     children of root, which may have Problem Bookmarks or Probem Folders

     - returns:  If neither problem bookmarks nor problem folders are found,
     returns nil.  If Problem Bookmarks are found, returns an NSError
     describing the Problem Bookmarks.  If no Problem Bookmarks are found but
     Problem Folders are found, returns an NSError describing the Problem
     Folders.
     */
    class func error(_ starkoids: [SafariRootChildoid], inBmco: Bool) -> NSError? {
        /* bookmarkoids is, at this time, an empty set of Starkoids into
         which we shall add only Starkoids that represent bookmarks. */
        var folderoids = CountedSetByHash<SafariRootChildoid>()
        var bookmarkoids = CountedSetByHash<SafariRootChildoid>()
        for rootChildoid in starkoids {
            if rootChildoid.isFolder {
                /* CountedSetByHash will coalesce any additions with the
                 same .name in the case of a folder, and any additions with
                 the same name and .url for bookmarks. */
                folderoids.add(rootChildoid)
            } else {
                /* CountedSetByHash will coalesce any additions with the
                 same url and same name. */
                bookmarkoids.add(rootChildoid)
            }
        }

        var code = Int(0)
        var description: String = ""
        var suggestion: String = ""
        var didHeader = false
        for bookmarkoid in bookmarkoids {
            if (bookmarkoids.count(for: bookmarkoid) > 1) {
                if !didHeader {
                    if (inBmco) {
                        code = 294832
                        description = Self.ErrorMessages.badBookmarkInBmcoDescription
                        suggestion = Self.ErrorMessages.badBookmarkInBmcoSuggestion
                    } else {
                        code = 294833
                        description = Self.ErrorMessages.badBookmarkInSafariDescription
                        suggestion = Self.ErrorMessages.badBookmarkInSafariSuggestion
                    }
                    didHeader = true
                    suggestion.append("\n")
                }
                suggestion.append("\n")
                suggestion.append("\(bookmarkoid.name ?? "<NO-NAME>") [\(bookmarkoids.count(for: bookmarkoid))  instances]")
            }
        }
        /* So as to not overwhelm the user and our own coding ability, if there
         are problem bookmarks, we only make an error for the bookmarks and
         ignoring any problem folders.  In the unlikely event that a user has
         both problem bookmarks and problem folders, user will be notified of
         the latter on a second pass, after they have fixed the problem
         bookmarks. */
        if (code == 0) {
            didHeader = false
            for folderoid in folderoids {
                if (folderoids.count(for: folderoid) > 1) {
                    if !didHeader {
                        if (inBmco) {
                            code = 294842
                            description = Self.ErrorMessages.badFolderInBmcoDescription
                            suggestion = Self.ErrorMessages.badFolderInBmcoSuggestion
                        } else {
                            code = 294843
                            description = Self.ErrorMessages.badFolderInSafariDescription
                            suggestion = Self.ErrorMessages.badFolderInSafariSuggestion
                        }
                        didHeader = true;
                        suggestion.append("\n")
                    }
                    suggestion.append("\n")
                    suggestion.append("\(folderoid.name ?? "<NO-NAME>") [\(folderoids.count(for: folderoid))  instances]")
                }
            }
        }

        var error : NSError? = nil;
        if (code != 0) {
            error = NSError(domain: "SafariDupeAtRootChecker",
                            code: code,
                            userInfo:
                                [NSLocalizedDescriptionKey : description,
                      NSLocalizedRecoverySuggestionErrorKey: suggestion])
        }
        
        return error
    }
    
    enum ErrorMessages {
        static let badBookmarkInBmcoDescription = NSLocalizedString("""
You have some duplicate bookmarks at your root level, \
or in your Bookmarks Menu or Other Bookmarks.  \
Safari will not accept this.  \
The current import/export has therefore been aborted.
""", comment:"later-gator")
        static let badBookmarkInBmcoSuggestion = NSLocalizedString("""
Delete the duplicates of such bookmarks at your root level, \
or in your Bookmarks Menu or Other Bookmarks.  \
The names of the offending bookmarks are listed below.  \
Or, an easier way:  Click in the menu: Bookmarks > Find Duplicates, then delete as desired.  \
Then, retry the import/export with Safari.
""", comment:"later-gator")
        static let badFolderInBmcoDescription = NSLocalizedString("""
There are some folders at your root level, or in your Bookmarks Menu, Other Bookmarks, or Reading List,\
with the same names, and some are empty.  \
Safari will not accept this.  \
The current import/export has therefore been aborted.
""", comment:"later-gator")
        static let badFolderInBmcoSuggestion = NSLocalizedString("""
Delete any such empty folders at your root level, or in your Bookmarks Menu, Other Bookmarks, or Reading List.  \
The names of the offending folders are listed below.  \
Or, an easier way:  Click in the menu: Bookmarks > Consolidate Folders.  \
(This will consolidate folders, removing amy such duplicate empty subfolders *throughout* your Collection, \
which is arguably good housekeeping in any case.)  \
Then, retry the import/export with Safari.
""", comment:"later-gator")
        
        static let badBookmarkInSafariDescription = NSLocalizedString("""
There are some duplicate bookmarks at your root level in Safari.  \
or in your Bookmarks Menu or Other Bookmarks.  \
This will cause import and export operations with Safari to fail.  \
The current import/export has therefore been aborted.
""", comment:"later-gator")
        static let badBookmarkInSafariSuggestion = NSLocalizedString("""
In Safari, delete the duplicates of such bookmarks at your root level, \
or in your Bookmarks Menu or Other Bookmarks.  \
The offending bookmark names are listed below.  \
Or, an easier way:  If Safari is running, quit it.  Then, relaunch Safari.  \
Safari will remove all of the duplicate items except one.  \
Then, retry the import/export with Safari.
""", comment:"later-gator")
        static let badFolderInSafariDescription = NSLocalizedString("""
You have some folders at your root level in Safari,\
with the same names.  \
This will cause import and export operations with Safari to fail.  \
The current import/export has therefore been aborted.
""", comment:"later-gator")
        static let badFolderInSafariSuggestion = NSLocalizedString("""
In Safari, rename folders at your root level, or in your Bookmarks Menu, Other Bookmarks, or Reading List.  \
The offending folder names are listed below.  \
Or, an easier way:  If Safari is running, quit it.  Then, relaunch Safari.  \
Safari will consolidate the contents of all of the same-name folders into one.  \
Then, retry the import/export with Safari.
""", comment:"later-gator")
    }
    
}
