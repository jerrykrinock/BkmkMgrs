import Foundation

extension NSSet {
    @objc
    func replaceOccurrences(of target: String, with replacement: String) {
        for tag in self {
            if let tag = tag as? Tag {
                if let original = tag.string {
                    tag.string = original.replacingOccurrences(of: target, with: replacement)
                }
            }
        }
    }
}
