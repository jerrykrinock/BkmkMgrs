import Foundation

extension BkmxDoc {
    func logAsInformationalError(_ error: NSError){
        let errorOut = error.addingIsOnlyInformational() as NSError
        BkmxBasis.shared().logError(errorOut,
                                    markAsPresented: false)
    }
}
