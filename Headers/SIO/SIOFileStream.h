#import <SIO/SIOStream.h>

@interface SIOFileStream : SIOStream {
    FILE *_file;
    BOOL _closeOnDealloc;
}

+ (SIOFileStream *) stdin;
+ (SIOFileStream *) stdout;
+ (SIOFileStream *) stderr;

- (instancetype) initWithFile: (FILE *) file
               closeOnDealloc: (BOOL) closeOnDealloc;

- (instancetype) initWithFileDescriptor: (int) fd
                                   mode: (const char *) mode
                         closeOnDealloc: (BOOL) closeOnDealloc;

- (void) flush;

@end
