import Foundation

struct SafariRootChildoid : Hashable & Descriptable {
    public var name: String?
    public var url: String?
    public var isFolder: Bool = false
    
    var description: String {
        get {
            guard let name = self.name else { return "Nada Nombre" }
            return name
        }
    }
    
    /* We do not provide a hash(intoHasher:) func because the default
     implementation provided by Swift, which hashes the three ivars,
     is sufficient for both bookmarks and folders.  For folders, the nil
     .url value is apparently ignored, hashed to zero, or whatever.  */

}

