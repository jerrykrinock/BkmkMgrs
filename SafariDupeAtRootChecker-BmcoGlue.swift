import Foundation

/* I put these extensions in this separate file because if their methods were
 in the files SafariDupeAtRootChecker.swift and Starkoid.swift, we would need
 to include the `Stark` and `StarkTyper` code in the SheepSysSafariHelper
 target. */

extension SafariDupeAtRootChecker {

    @objc
    class func errorFromRootStarks(_ starks: Set<Stark>) -> NSError? {
        let starkoids = Self.starkoids(starks: starks)
        return Self.error(starkoids, inBmco:true)
    }

    class func starkoids(starks: Set<Stark>) -> [SafariRootChildoid] {
        return starks.map {
            SafariRootChildoid.init(stark:$0)
        }
    }

}

extension SafariRootChildoid {
    
    init(stark: Stark) {
        self.name = stark.name
        self.url = stark.url
        self.isFolder = (StarkTyper.isContainerGeneralSharype(stark.sharypeValue()))
    }

}
