#import "K9LogPatternFileNameComponent.h"

@implementation K9LogPatternFileNameComponent

- (nonnull NSString *)stringFromLogMessage:(nonnull id<K9LogMessage>)logMessage
{
    const char *filePath = [[logMessage k9_filePath] UTF8String];

    if (!filePath) {
        return @"";
    }

    const char *pend = filePath;

    const char *start = filePath;
    const char *end   = NULL;

    for (const char *p = filePath; *p != '\0'; pend = ++p) {
        const char c = *p;

        if (c == '/') {
            start = p + 1;

            // Clear pointer to last dot character
            end = NULL;
        } else if (c == '.'
                   && (p == filePath || *(p-1) != '.') // ".."
                  )
        {
            end = p;
        }
    }

    if (!end) {
        end = pend;
    }

    NSAssert(start && end, @"substring range");

    if (start == end) {
        return @"";
    }

    return [[NSString alloc] initWithBytesNoCopy:(char *)start
                                          length:(end - start)
                                        encoding:NSUTF8StringEncoding
                                    freeWhenDone:NO];
}

@end
