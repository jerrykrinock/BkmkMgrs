import Foundation

@objc
class DraggableStark : NSObject, Codable {
    @objc public var starkURI: String
    @objc public var docUuid: String
    
    override var description: String {
        get {
            return "Stark URI \(self.starkURI) in doc \(self.docUuid)"
        }
    }
    
    @objc
    var jsonString : String? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
        } catch {
            return nil
        }
    }
    
    @objc
    init?(starkURI: String?, docUuid: String?) {
        if let starkURI = starkURI, let docUuid = docUuid {
            self.starkURI = starkURI
            self.docUuid = docUuid
        } else {
            return nil;
        }
    }
    
    @objc
    init?(stark: Stark?) {
        guard let stark = stark else {
            return nil
        }
        let uriRepresentation = stark.objectID.uriRepresentation()
        let stringRepresentation = uriRepresentation.absoluteString
        guard let owner = stark.owner() as? BkmxDoc else {
            return nil
        }
        self.starkURI = stringRepresentation
        self.docUuid = owner.uuid
    }
    
    @objc
    init?(jsonString: String) {
        if let jsonData = jsonString.data(using: .utf8) {
            let decoder = JSONDecoder()
            
            do {
                let protoself = try decoder.decode(Self.self, from: jsonData)
                self.starkURI = protoself.starkURI
                self.docUuid = protoself.docUuid
            } catch {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
    
    @objc
    var stark : Stark? {
        let docController = NSDocumentController.shared as! BkmxDocumentController
        let doc = docController.alreadyOpenDoc(withUuid: self.docUuid)
        let context = doc?.managedObjectContext
        let psc = context?.persistentStoreCoordinator
        guard let starkUrl = URL(string: self.starkURI) else {
            return nil
        }
        guard let objectID = psc?.managedObjectID(forURIRepresentation: starkUrl) else {
            return nil
        }
        guard let stark = context?.object(with: objectID) as? Stark else {
            return nil
        }
        return stark
    }
}
