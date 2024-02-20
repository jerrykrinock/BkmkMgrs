import Foundation
import AppKit

extension NSPasteboard.PasteboardType {
    static let contentProxy = NSPasteboard.PasteboardType(constBkmxPboardTypeDraggableStark)
}

/* Note that, in modernizing Drag and Drop to remove a deprecated method
 implementation, in BkmkMgrs 3.1, I thought it would be necessary to make
 this class conform to NSPasteboardWriting and NSPasteboardReading.  But it was
 not.  In fact, the "required" methods pasteboardPropertyList(forType:) and
 init(pasteboardPropertyList:ofType:) are never even called. */
@objc class ContentProxy : NSObject {
    static func types(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        return [NSPasteboard.PasteboardType.string,
                NSPasteboard.PasteboardType.tabularText,
                NSPasteboard.PasteboardType.contentProxy]
    }
    
    func writableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        return Self.types(for: pasteboard)
    }
    
    static func readableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        return Self.types(for: pasteboard)
    }
    
    private var lazyButResettableStark: Stark?
    @objc var parent: ContentProxy?
    @objc var index: Int
    @objc var outlineView: NSOutlineView?
    @objc var isDirty = true
    @objc lazy var children: [ContentProxy]? = {
        [ContentProxy]()
    }()
    
    @objc override init() {
        self.lazyButResettableStark = nil
        self.index = 0
    }
    
    @objc var stark: Stark? {
        get {
            if (self.lazyButResettableStark == nil) {
                let proxyParent = self.parent
                var parent = proxyParent?.stark
                if let dataSource = self.outlineView?.dataSource as? ContentDataSource {
                    if let winCon = dataSource.document.bkmxDocWinCon() {
                        if (winCon.outlineMode) {
                            if (parent == nil) {
                                parent = winCon.document?.starker.root
                            }
                            
                            if (self.index >= (parent?.numberOfChildren())!) {
                                // This can happen if the last child of a parent is deleted
                                // while it was being edited in the field editor.
                                // Leave m_stark as nil.  This seems to be the correct answer;
                                // it recovers with no exception or crash.
                            } else {
                                let child = parent?.child(at: self.index)
                                self.lazyButResettableStark = child
                            }
                            
                        } else {
                            if (parent == nil) {
                                if (index < dataSource.flatCache().count) {
                                    self.lazyButResettableStark = dataSource.flatCache()[index]
                                }
                            } else {
                                // This will occur when switching from outline mode to table
                                // mode.  The proxy's starks will still have parents.
                                
                            }
                        }
                    }
                } else {
                    // This does execute for certain drag/drops
                    self.lazyButResettableStark = nil
                }
            }
            
            if (self.lazyButResettableStark?.isAvailable() == false) {
                // This will happen if the stark has been deleted.
                self.lazyButResettableStark = nil
            }
            
            return self.lazyButResettableStark
        }
        
        set (newStark) {
            self.lazyButResettableStark = newStark
        }
        
    }

    var starkIvar: Stark? {
        return self.lazyButResettableStark
    }
    
    func starksFromProxies(_ proxies:[ContentProxy]) -> [Stark] {
        var starks = [Stark]()
        for proxy in proxies {
            if let stark = proxy.stark {
                starks.append(stark)
            }
        }
        
        return starks
    }

    @objc func putChild(_ child:ContentProxy?,
                  at: Int) {
        if (self.children == nil) {
            self.children = []
        }
        let mutable = (self.children! as NSArray).mutableCopy()
        let array = mutable as! NSMutableArray
        array.put(child, at: at)
        let immutable = array.copy() as! NSArray
        self.children = (immutable as! [ContentProxy])
    }
    
    func unensuredChild(_ at: Int) -> ContentProxy? {
        var aChild: ContentProxy? = nil
        if at < (self.children?.count ?? 0) {
            aChild = self.children?[at]
        }
        
        return aChild
    }
    
    @objc func put(_ child:ContentProxy,
                   index:Int) {
        // MAKE children a lazy var !!!
        if (self.children == nil) {
            self.children = [ContentProxy]()
        }
        
        (self.children as! NSMutableArray?)?.put(child, at: index)
    }
    
    @objc func ensureValues(deeply: Bool,
                            regardless: Bool) {
        if let stark = self.stark {
            if (self.isDirty || regardless) {
                /*
                 Algorithm for making array B (proxy) match array A (stark), which is
                 efficient for array types that use null placeholders (as ContentProxy
                 children do).
                 
                 . for each element B[i] of B
                 .     get the same-indexed element of A, A[i]
                 .     if A[i] is absent or is a null placeholder,
                 .        create a new element
                 .        replace A[i] in A with the new element
                 .     for each attribute of the A[i] (which may be the new element)
                 .         if attribute is different than the same attribute in B[i]
                 .         set the attribute in A[i] to equal that of B[i]
                 . remove all elements of B, B[i] whose index is greater than i at the end of the above iteration.
                 
                 This algorithm, implemented below, does not efficiently detect the case
                 where there are a few missing or a few inserted elements in a large
                 array.  But I think that the extra computation required to try and
                 detect such patterns would result in poorer performance for the
                 average user with average-sized (a few tens, typical) arrays.
                 
                 This same algorithm is also used on m_rootProxies in
                 -[ContentDataSource checkAllProxies].
                 */
                var i:Int = 0
                if let stark = self.stark {
                    if let childrenOrdered = stark.childrenOrdered() {
                        for childStark in childrenOrdered {
                            var childProxy = self.unensuredChild(i)
                            if (childProxy == nil) {
                                childProxy = ContentProxy()
                                self.putChild(childProxy,
                                              at:i)
                            }
                            if let childProxy = childProxy {
                                if (childProxy.stark != childStark) {
                                    childProxy.stark = childStark
                                }
                                if (childProxy.index != i) {
                                    childProxy.index = i
                                }
                                if (deeply) {
                                    childProxy.ensureValues(deeply: true,
                                                            regardless: regardless)
                                }
                            }
                            
                            i += 1
                        }
                        
                        // Mark any remaining children as dirty
                        if let children = self.children {
                            let upperBound = children.count
                            if children.count > i {
                                for j in i...upperBound {
                                    if let dirtyChild = self.unensuredChild(j) {
                                        dirtyChild.isDirty = true
                                    }
                                }
                            }
                        }
                    }
                }
                self.index = stark.indexValue()
                self.isDirty = false
            }
        } else {
            self.index = 0
            self.isDirty = false
        }
    }
    
    @objc func ensureDeeplyAndRegardlessly() {
        self.ensureValues(deeply: true, regardless: true)
    }
    
    @objc func child(at index: Int) -> ContentProxy? {
        self.ensureValues(deeply: true,
                          regardless: false)
        
        return self.unensuredChild(index)
    }
    
    @objc func cleanChildAt(_ index: Int) {
        (self.children as! NSMutableArray?)?.cleanObject(at: index)
    }
    
    @objc
    var numberOfChildren: Int {
        self.ensureValues(deeply: true, regardless: false)
        
        return self.children?.count ?? 0
    }
    
    @objc func noteChangedChildren() {
        self.isDirty = true
    }
    
    @objc
    override var description: String {
        return String(format:
                    "%@ %p %@ for %@ pNC=%ld prxIdx=%ld prxPar : %@",
                      String(describing: type(of: self)),
                      self,
                      self.isDirty ? "dty" : "cln",
                      self.starkIvar?.name ?? "No Stark",
                      self.numberOfChildren,
                      self.index,
                      self.parent ?? "NONE")
    }

    @objc
    override func shortDescription() -> String {
        return String(format:
                    "%@ %p %@ for stark %p pNC=%ld prxIdx=%ld prxPar : %@",
                      String(describing: type(of: self)),
                      self,
                      self.isDirty ? "dty" : "cln",
                      self.starkIvar?.name ?? "No Stark",
                      self.numberOfChildren,
                      self.index,
                      self.parent ?? "NONE")
    }

}


