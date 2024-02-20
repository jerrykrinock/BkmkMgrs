#import "ExtoreLocalPlist.h"

@class Stark ;
@class StarkLocation ;
                                                     // type      applicability      remarks
extern NSString* const constKeyIcabName ;            // string    all types
extern NSString* const constKeyIcabComments ;        // string    all types
extern NSString* const constKeyIcabType ;            // string    all types          allowed values given below
extern NSString* const constKeyIcabUrl ;             // string    leafs only
extern NSString* const constKeyIcabUuid ;            // string    all types
extern NSString* const constKeyIcabAddDate ;         // date      leafs only
extern NSString* const constKeyIcabTags ;            // string    leafs only         space-separated
extern NSString* const constKeyIcabClosed ;          // boolean   nodes only
extern NSString* const constKeyIcabChildren ;        // array     nodes only
extern NSString* const constKeyIcabFolderType ;      // string    Favorites only

// Client Proprietary
extern NSString* const constKeyIcabTopTen ;          // boolean   leafs only
extern NSString* const constKeyIcabCheckFlags ;      // number    leafs only
extern NSString* const constKeyIcabFBOpen ;          // boolean   nodes only
extern NSString* const constKeyIcabRules ;           // array     SmartFolders only  elements = dics

// String values for constKeyIcabType
extern NSString* const constKeyIcabTypeBookmark ;    // leaf
extern NSString* const constKeyIcabTypeFolder ;      // node
extern NSString* const constKeyIcabTypeSeparator ;   // separator
extern NSString* const constKeyIcabTypeSmartFolder ; // node

// String values for constKeyIcabFolderType
extern NSString* const constKeyIcabTypeBar ;         // node

@interface ExtoreICab : ExtoreLocalPlist {
	BOOL m_supportsUniqueExids ;
}

@property (assign) BOOL supportsUniqueExids ;

@end
