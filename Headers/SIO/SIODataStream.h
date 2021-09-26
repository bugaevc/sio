#import <SIO/SIOStream.h>

@interface SIODataStream : SIOStream {
    NSData *_buffer;
}

- (instancetype) initForReadingData: (NSData *) data;
- (instancetype) initForWriting;

- (NSData *) data;

@end
