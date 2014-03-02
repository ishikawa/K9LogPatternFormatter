#import "K9ThreadLocal+Private.h"

@interface K9ThreadLocal ()

@property (nonatomic) id uniqueKey;

@end

@implementation K9ThreadLocal

static NSString *const kThreadLocalPrefixKey = @"jp.ko9.ThreadLocal.";

- (instancetype)init
{
    if ((self = [super init])) {
        _uniqueKey = [[NSString alloc] initWithFormat:@"%@.%p", kThreadLocalPrefixKey, self];
    }

    return self;
}

- (void)dealloc
{
    // Remove associated value from TLS.
    self.value = nil;
}

- (id)value
{
    NSDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];

    return threadDictionary[self.uniqueKey];
}

- (void)setValue:(id)value
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];

    if (value == nil) {
        [threadDictionary removeObjectForKey:self.uniqueKey];
    } else {
        threadDictionary[self.uniqueKey] = value;
    }
}

@end
