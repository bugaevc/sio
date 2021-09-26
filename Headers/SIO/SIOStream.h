#import <Foundation/Foundation.h>

@interface SIOStream : NSObject

- (BOOL) writeData: (NSData *) data;
- (BOOL) writeData: (NSData *) data error: (NSError **) error;

- (BOOL) writeString: (NSString *) string;
- (BOOL) writeString: (NSString *) string
            encoding: (NSStringEncoding) encoding
               error: (NSError **) error;

- (BOOL) writeFormat: (NSString *) format, ...;
- (BOOL) writeFormat: (NSString *) format
           arguments: (va_list) arguments
               error: (NSError **) error;

- (BOOL) writeByte: (unsigned char) value;
- (BOOL) writeByte: (unsigned char) value
             error: (NSError **) error;

- (BOOL) writeInt16: (int16_t) value
          byteOrder: (NSByteOrder) byteOrder
              error: (NSError **) error;

- (BOOL) writeInt32: (int32_t) value
          byteOrder: (NSByteOrder) byteOrder
              error: (NSError **) error;

- (BOOL) writeInt64: (int64_t) value
          byteOrder: (NSByteOrder) byteOrder
              error: (NSError **) error;

@end
