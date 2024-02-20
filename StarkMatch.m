#import "StarkMatch.h"
#import "Stark.h"

@interface StarkMatch ()

@property (retain) Stark* sourceStark ;
@property (retain) Stark* destinStark ;

@end


@implementation StarkMatch

@synthesize sourceStark = m_sourceStark ;
@synthesize destinStark = m_destinStark ;


- (id)initWithSourceStark:(Stark*)sourceStark
              destinStark:(Stark*)destinStark {
    self = [super init] ;
    if (self) {
        [self setSourceStark:sourceStark] ;
        [self setDestinStark:destinStark] ;
    }
    
    return self ;
}

- (void)considerSourceStark:(Stark*)sourceStark {
    Stark* currentSource = [self sourceStark] ;
    Stark* currentDestin = [self destinStark] ;
    if (currentDestin) {
        Stark* bestMatch = [currentDestin bestMatchBetweenStark1:sourceStark
                                                          stark2:currentSource] ;
        if (bestMatch == sourceStark) {
            [self setSourceStark:sourceStark] ;
        }
    }
    else {
        [self setSourceStark:sourceStark] ;
    }
}

- (void)considerDestinStark:(Stark*)destinStark {
    Stark* currentDestin = [self destinStark] ;
    Stark* currentSource = [self sourceStark] ;
    if (currentSource) {
        Stark* bestMatch = [currentSource bestMatchBetweenStark1:destinStark
                                                          stark2:currentDestin] ;
        if (bestMatch == destinStark) {
            [self setDestinStark:destinStark] ;
        }
    }
    else {
        [self setDestinStark:destinStark] ;
    }
}

- (void)dealloc {
    [m_sourceStark release] ;
    [m_destinStark release] ;
    [super dealloc] ;
}


@end
