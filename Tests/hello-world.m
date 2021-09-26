#import <Foundation/Foundation.h>
#import <SIO/SIO.h>

int main() {
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    [[SIOFileStream stdout] writeFormat: @"Hello, %@!\n", @"World"];
    [pool drain];
    return 0;
}
