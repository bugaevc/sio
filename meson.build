project('sio', 'objc')

if host_machine.system() == 'darwin'
    foundation = dependency('appleframeworks', modules: 'foundation')
else
    foundation = dependency('gnustep')
endif

cc = meson.get_compiler('objc')

have_os_byte_order = cc.has_header('libkern/OSByteOrder.h')

nsdata_enumerate_ranges_test_code = '''
#import <Foundation/Foundation.h>

int main() {
    [NSAutoreleasePool new];
    unsigned char b = 42;
    NSData *data = [NSData dataWithBytes: &char
                                  length: 1];
    __block int first = 0;
    [data enumerateByteRangesUsingBlock:
        ^(const void *bytes, NSRange range, BOOL *stop) {
            first = ((unsigned char *) bytes)[0];
        }
    ];
    return first;
}
'''
have_nsdata_enumerate_ranges = cc.run(
    nsdata_enumerate_ranges_test_code,
    name: 'check for enumerateByteRangesUsingBlock:'
).returncode() == 42

conf_data = configuration_data({
    'HAVE_OS_BYTE_ORDER': have_os_byte_order,
    'HAVE_NSDATA_ENUMERATE_RANGES': have_nsdata_enumerate_ranges,
})
configure_file(output: 'config.h', configuration: conf_data)

src = []
subdir('Source')
inc = include_directories('Headers')

sio = library(
    'sio',
    src,
    include_directories: inc,
    dependencies: foundation,
    install: true,
)

sio_dep = declare_dependency(
    link_with: sio,
    include_directories: inc,
)

subdir('Tests')
