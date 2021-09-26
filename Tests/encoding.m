#import <Foundation/Foundation.h>
#import <SIO/SIO.h>

int main() {
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    SIODataStream *stream = [[SIODataStream alloc] initForWriting];

    [stream writeString: @"hello"];
    [stream writeInt16: 42 byteOrder: NS_BigEndian error: NULL];
    [stream writeInt32: 35 byteOrder: NS_LittleEndian error: NULL];

    const char reference[] = "hello\0\x2a\x23\0\0";
    NSData *referenceData = [NSData dataWithBytes: reference
                                           length: sizeof(reference)];

    NSLog(@"stream data: %@", [stream data]);
    NSLog(@"reference: %@", referenceData);

    assert([[stream data] isEqual: referenceData]);

    [stream release];
    [pool drain];
    return 0;
}
