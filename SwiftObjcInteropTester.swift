import Foundation

@objc public class SwiftObjcInteropTester : NSObject, NSCoding, NSSecureCoding {
    @objc public var foo: Int
    @objc public var foo2: String?
    
    @objc public override init() {
        self.foo = -7
        foo2 = nil
    }
    
    @objc public init(foo: Int) {
        self.foo = foo
        foo2 = nil
    }
    
    @objc public init(foo: Int, foo2: String?) {
        self.foo = foo
        self.foo2 = foo2
    }
    
    public override var description: String {
        return "A Swoo with foo = \(self.foo), foo2 = \(self.foo2 ?? "NadaFoo2")"
    }

    @objc public func swiftMe () -> Void {
        print("We're all Swiftees now.")
    }
    
    @objc public func instanceFuncWithParm(_ parm: String) {
        print("Instance func got parameter: \(parm)");
    }
    
    @objc public class func classFunc() -> Void {
        print("I am a class func");
    }

    @objc public class func classFuncWithParm(_ parm: String) -> Void {
        print("Class func got parameter: \(parm)");
    }

    // MARK: NSCoding Methods

    public static var supportsSecureCoding = true
    
    @objc public func encode(with coder: NSCoder) {
        coder.encode(self.foo, forKey: "foo")
    }
    
    @objc public required init?(coder: NSCoder) {
        foo = coder.decodeInteger(forKey:"foo")
    }
}
