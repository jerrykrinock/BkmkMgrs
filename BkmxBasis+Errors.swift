import Foundation

extension BkmxBasis {
    
    func logErrorInformational(domain: String, code: Int, desc: String, underlyingError: Error?) {
        var userInfo = [NSLocalizedDescriptionKey: desc] as [String : Any]
 
        userInfo[SSYIsOnlyInformationalErrorKey] = true
        /* The appendage as [String : Any] is necessary for us to be able to
         add values types other than the type or "true" (Bool) later.  This
         is how you create a heterogenous dictionary in Swift. */

        if let underlyingError = underlyingError {
            userInfo[NSUnderlyingErrorKey] = underlyingError
        }
        
        let error = NSError(domain: domain,
                            code: code,
                            userInfo: userInfo)
        BkmxBasis.shared().logError(error ,
                                    markAsPresented: false)
    }
    
}
