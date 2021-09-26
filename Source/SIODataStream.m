#import <SIO/SIODataStream.h>

@implementation SIODataStream

- (instancetype) initForReadingData: (NSData *) data {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _buffer = [data copy];
    return self;
}

- (instancetype) initForWriting {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _buffer = [NSMutableData new];
    return self;
}

- (NSData *) data {
    return _buffer;
}

- (BOOL) writeData: (NSData *) data error: (NSError **) error {
    [(NSMutableData *) _buffer appendData: data];
    return YES;
}

- (BOOL) writeByte: (unsigned char) value
             error: (NSError **) error
{
    [(NSMutableData *) _buffer appendBytes: &value
                                    length: 1];
    return YES;
}

- (void) dealloc {
    [_buffer release];
    [super dealloc];
}

@end
