#import "NSFileManager+SSYFixPermissions.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        NSInteger result = [[NSFileManager defaultManager] fixPermissionsOfLaunchAgentsFolder] ;
        NSLog(@"result = %ld", (long)result) ;
        sleep(2) ;
    }
}

