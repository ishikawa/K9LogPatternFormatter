#import "K9LogPatternModifier.h"

@implementation K9LogPatternModifier

- (instancetype)init
{
    return [self initWithComponent:nil];
}

- (instancetype)initWithComponent:(id<K9LogPatternComponent>)component
{
    if ((self = [super init])) {
        _component = component;
    }
    return self;
}

- (nonnull NSString *)stringFromLogMessage:(nonnull id<K9LogMessage>)logMessage
{
    return [_component stringFromLogMessage:logMessage];
}

@end

@implementation K9LogPatternMinWidthConstraint

- (instancetype)initWithComponent:(id<K9LogPatternComponent>)component
                            width:(NSUInteger)width
                leftJustification:(BOOL)leftJustification
{
    if ((self = [super initWithComponent:component])) {
        _width = width;
        _leftJustification = leftJustification;
    }

    return self;
}

- (nonnull NSString *)stringFromLogMessage:(nonnull id<K9LogMessage>)logMessage
{
    NSString *message = [self.component stringFromLogMessage:logMessage];

    if (message.length < self.width) {
        NSMutableString *buffer = [[NSMutableString alloc] initWithCapacity:self.width];
        const NSUInteger n = self.width - message.length;

        if (self.leftJustification) {
            [buffer appendString:message];
        }

        for (int i = 0; i < n; i++) {
            [buffer appendString:@" "];
        }

        if (!self.leftJustification) {
            [buffer appendString:message];
        }

        message = buffer;
    }
    
    return message;
}

@end

@implementation K9LogPatternMaxWidthConstraint

- (instancetype)initWithComponent:(id<K9LogPatternComponent>)component
                            width:(NSUInteger)width
{
    if ((self = [super initWithComponent:component])) {
        _width = width;
    }

    return self;
}

- (nonnull NSString *)stringFromLogMessage:(nonnull id<K9LogMessage>)logMessage
{
    NSString *message = [self.component stringFromLogMessage:logMessage];

    if (message.length > self.width) {
        message = [message substringToIndex:self.width];
    }

    return message;
}

@end

