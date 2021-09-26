#import <SIO/SIOStream.h>
#import "config.h"

#ifdef HAVE_OS_BYTE_ORDER
#include <libkern/OSByteOrder.h>
#endif

@implementation SIOStream

- (BOOL) writeData: (NSData *) data {
    return [self writeData: data error: NULL];
}

- (BOOL) writeData: (NSData *) data error: (NSError **) error {
    // Subclasses should override either this or writeByte:error:
#ifdef HAVE_NSDATA_ENUMERATE_RANGES
    __block BOOL ok = YES;
    [data enumerateByteRangesUsingBlock:
        ^(const void *bytes, NSRange range, BOOL *stop) {
            NSUInteger i;
            for (i = 0; i < range.length; i++) {
                unsigned char byte = ((unsigned char *) bytes)[i];
                ok = [self writeByte: byte: error: error];
                if (!ok) {
                    *stop = YES;
                    break;
                }
            }
        }
    ];
    return ok;
#else
    const unsigned char *bytes = [data bytes];
    NSUInteger i, length = [data length];
    for (i = 0; i < length; i++) {
        BOOL ok = [self writeByte: bytes[i] error: error];
        if (!ok) {
            return NO;
        }
    }
    return YES;
#endif
}

- (BOOL) writeString: (NSString *) string {
    return [self writeString: string
                    encoding: NSUTF8StringEncoding
                       error: NULL];
}

- (BOOL) writeString: (NSString *) string
            encoding: (NSStringEncoding) encoding
               error: (NSError **) error
{
    return [self writeData: [string dataUsingEncoding: encoding]
                     error: error];
}

- (BOOL) writeFormat: (NSString *) format, ... {
    va_list args;
    va_start(args, format);
    BOOL ok = [self writeFormat: format
                      arguments: args
                          error: NULL];
    va_end(args);
    return ok;
}

- (BOOL) writeFormat: (NSString *) format
           arguments: (va_list) arguments
               error: (NSError **) error
{
    NSString *string = [NSString stringWithFormat: format
                                        arguments: arguments];
    return [self writeString: string
                    encoding: NSUTF8StringEncoding
                       error: error];
}

- (BOOL) writeByte: (unsigned char) value {
    return [self writeByte: value error: NULL];
}

- (BOOL) writeByte: (unsigned char) value
             error: (NSError **) error
{
    // Subclasses should override either this or writeData:error:
    NSData *data = [NSData dataWithBytes: &value
                                  length: 1];
    return [self writeData: data error: error];
}

- (BOOL) writeInt16: (int16_t) value
          byteOrder: (NSByteOrder) byteOrder
              error: (NSError **) error
{
    int16_t swapped;
    switch (byteOrder) {
    case NS_LittleEndian:
#ifdef HAVE_OS_BYTE_ORDER
        swapped = OSSwapHostToLittleInt16(value);
#else
        swapped = htole16(value);
#endif
        break;
    case NS_BigEndian:
#ifdef HAVE_OS_BYTE_ORDER
        swapped = OSSwapHostToBigInt16(value);
#else
        swapped = htobe16(value);
#endif
        break;
    default:
        NSLog(@"Bad byte order %d, aborting", (int) byteOrder);
        abort();
    }

    NSData *data = [NSData dataWithBytes: &swapped
                                  length: sizeof(swapped)];
    return [self writeData: data error: error];
}

- (BOOL) writeInt32: (int32_t) value
          byteOrder: (NSByteOrder) byteOrder
              error: (NSError **) error
{
    int32_t swapped;
    switch (byteOrder) {
    case NS_LittleEndian:
#ifdef HAVE_OS_BYTE_ORDER
        swapped = OSSwapHostToLittleInt32(value);
#else
        swapped = htole32(value);
#endif
        break;
    case NS_BigEndian:
#ifdef HAVE_OS_BYTE_ORDER
        swapped = OSSwapHostToBigInt32(value);
#else
     	swapped = htobe32(value);
#endif
      	break;
    default:
        NSLog(@"Bad byte order %d, aborting", (int) byteOrder);
        abort();
    }

    NSData *data = [NSData dataWithBytes: &swapped
                                  length: sizeof(swapped)];
    return [self writeData: data error: error];
}


- (BOOL) writeInt64: (int64_t) value
          byteOrder: (NSByteOrder) byteOrder
              error: (NSError **) error
{
    int64_t swapped;
    switch (byteOrder) {
    case NS_LittleEndian:
#ifdef HAVE_OS_BYTE_ORDER
      	swapped = OSSwapHostToLittleInt64(value);
#else
        swapped = htole64(value);
#endif
        break;
    case NS_BigEndian:
#ifdef HAVE_OS_BYTE_ORDER
        swapped = OSSwapHostToBigInt64(value);
#else
        swapped = htobe64(value);
#endif
        break;
    default:
	NSLog(@"Bad byte order %d, aborting", (int) byteOrder);
        abort();
    }

    NSData *data = [NSData dataWithBytes: &swapped
                                  length: sizeof(swapped)];
    return [self writeData: data error: error];
}

@end
