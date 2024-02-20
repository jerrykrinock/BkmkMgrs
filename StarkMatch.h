#import <Foundation/Foundation.h>

@class Stark ;


/*
 @details  This class only stores one source stark and one destin stark.  It
 could be made smarter by storing instead sets or arrays instead.  This would
 work better if a StarkMatch had, for example, the following life story:
 1. Add a first destin, 2. Add a second destin, 3. Add a first source.  In this
 example, when the first source was added, an intelligent choice could be made
 between the first destin and the second destin.  I don't think that this
 happens in real life, but if I ever found such a case, such a change would
 be encapsulated in the implementation of this class.
 */
@interface StarkMatch : NSObject {
    Stark* m_sourceStark ;
    Stark* m_destinStark ;
}

- (id)initWithSourceStark:(Stark*)sourceStark
              destinStark:(Stark*)destinStark ;

- (void)considerSourceStark:(Stark*)sourceStark ;
- (void)considerDestinStark:(Stark*)destinStark ;

- (Stark*)sourceStark ;
- (Stark*)destinStark ;

@end
