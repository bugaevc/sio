#import <SIO/SIOFileStream.h>
#import <pthread.h>

@implementation SIOFileStream

static SIOFileStream *s_stdin, *s_stdout, *s_stderr;

static void init_stdin() {
    s_stdin = [[SIOFileStream alloc] initWithFile: stdin
                                   closeOnDealloc: NO];
}

static void init_stdout() {
    s_stdout = [[SIOFileStream alloc] initWithFile: stdout
                                    closeOnDealloc: NO];
}

static void init_stderr() {
    s_stderr = [[SIOFileStream alloc] initWithFile: stderr
                                    closeOnDealloc: NO];
}

+ (SIOFileStream *) stdin {
    static pthread_once_t once = PTHREAD_ONCE_INIT;
    pthread_once(&once, init_stdin);
    return s_stdin;
}

+ (SIOFileStream *) stdout {
    static pthread_once_t once = PTHREAD_ONCE_INIT;
    pthread_once(&once, init_stdout);
    return s_stdout;
}

+ (SIOFileStream *) stderr {
    static pthread_once_t once = PTHREAD_ONCE_INIT;
    pthread_once(&once, init_stderr);
    return s_stderr;
}

- (instancetype) initWithFile: (FILE *) file
               closeOnDealloc: (BOOL) closeOnDealloc
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _file = file;
    _closeOnDealloc = closeOnDealloc;
    return self;
}

- (instancetype) initWithFileDescriptor: (int) fd
                                   mode: (const char *) mode
                         closeOnDealloc: (BOOL) closeOnDealloc
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _file = fdopen(fd, mode);
    if (_file == NULL) {
        [self release];
        return nil;
    }
    _closeOnDealloc = closeOnDealloc;
    return self;
}

static NSError *createError() {
    return [NSError errorWithDomain: NSPOSIXErrorDomain
                               code: errno
                           userInfo: nil];
}

- (BOOL) writeData: (NSData *) data error: (NSError **) error {
#ifdef HAVE_NSDATA_ENUMERATE_RANGES
    __block BOOL ok = YES;
    [data enumerateByteRangesUsingBlock:
        ^(const void *bytes, NSRange range, BOOL *stop) {
            fwrite(bytes, 1, range.length, _file);
            if (ferror(_file)) {
                if (error != NULL) {
                    *error = createError();
                }
                ok = NO;
                *stop = YES;
            }
        }
    ];
    return ok;
#else
    fwrite([data bytes], 1, [data length], _file);
    if (ferror(_file)) {
        if (error != NULL) {
            *error = createError();
        }
        return NO;
    }
    return YES;
#endif
}

- (void) flush {
    fflush(_file);
}

- (void) dealloc {
    if (_closeOnDealloc) {
        fclose(_file);
    }
    [super dealloc];
}

@end
