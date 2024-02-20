import Foundation

/* @objc is not necessary if class inherits from NSObject */
public class FullDiskAccessor : NSObject {
    @objc public class func check() {
        print("Checking Full Disk Access")
    }
}
