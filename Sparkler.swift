import Foundation

class Sparkler : NSObject, SPUUpdaterDelegate, SPUStandardUserDriverDelegate {
    var updater: SPUUpdater? = nil
    var didNotFindAnyUpdate: Bool = false
    
    @objc
    static let shared = Sparkler()
    var username: String?
    
    private override init() { }
    
    @objc
    func start() {
        let bundleToBeUpdated = Bundle.mainAppBundle()
        let driver = SPUStandardUserDriver.init(hostBundle:bundleToBeUpdated,
                                            delegate: self)
        let updater = SPUUpdater(hostBundle: bundleToBeUpdated,
                                 applicationBundle: Bundle.main,
                                 userDriver: driver,
                                 delegate: self)
        self.updater = updater;
        do {
            try updater.start()
        } catch {
            BkmxBasis.shared().logError(error,
                                        markAsPresented: false)
        }
    }
    
    @objc
    func checkForUpdates() {
        self.updater?.checkForUpdates()
    }
    
    

    /* Sparkle Updater Delegate */
    @objc
    func updater(_ updater: SPUUpdater, didFinishUpdateCycleFor updateCheck: SPUUpdateCheck, error: Error?) {
        NSLog("Got updater callback")
    }

    func updaterDidNotFindUpdate(_ updater: SPUUpdater) {
        self.didNotFindAnyUpdate = true
    }
 
    /* Sparkle Driver Delegate Methods */

    func standardUserDriverWillFinishUpdateSession() {
        if (SSYLCDaysToExpire() <= 0) {
            if (self.didNotFindAnyUpdate) {
                let error = NSError(domain: NSError.myDomain(),
                                    code: Int(constBkmxErrorAppIsExpiredButSparkleDidNotFindUpdate),
                                    localizedDescription: NSLocalizedString ("App is expired but Sparkle did not find any update.  Maybe our server is not working?", comment:"no comment"))
                BkmxBasis.shared().logError(error, markAsPresented: false)
                /* This could happen if developer allowed app to expire without
                 posting an update, or if developer's server or appcast
                 has malfunctioned.  Allow user to continue using the expired
                 version. */
            } else {
                /* User chose not to update the expired app after clicking
                 "Check for Update".  Sorry! */
                NSApp.terminate(self)
            }
        }
    }


    
    
}
