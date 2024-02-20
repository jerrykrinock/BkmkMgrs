import Foundation

@objc extension NSNumber {
    @objc func mergeByDisplay() -> String? {
        switch self.int16Value {
        case 0:
            return NSLocalizedString("None", comment: "This is a noun")
        case 1:
            return NSLocalizedString("Identifier only", comment: "A hidden string which uniquely identifies an object.")
        case 2:
            return NSLocalizedString("Identifier or URL", comment: "Identifier is a hidden string which uniquely identifies an object.")
        default:
            return "Internal error 238-3938"
        }
    }
}
