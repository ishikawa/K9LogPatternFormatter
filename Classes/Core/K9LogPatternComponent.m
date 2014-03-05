#import "K9LogPatternComponent.h"

@implementation K9LogPatternLiteralTextComponent

- (instancetype)init
{
    return [self initWithText:@""];
}

- (instancetype)initWithText:(NSString *)text
{
    if (!text) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"text should not be nil"
                                     userInfo:nil];
    }

    if ((self = [super init])) {
        _text = [text copy];
    }

    return self;
}

- (NSString *)stringFromLogMessage:(id<K9LogMessage>)logMessage
{
    return _text;
}

@end

@implementation K9LogPatternParameterizedComponent

- (instancetype)init
{
    return [self initWithParameters:@[]];
}

- (instancetype)initWithParameters:(NSArray *)parameters
{
    return [super init];
}

- (NSString *)stringFromLogMessage:(id<K9LogMessage>)logMessage
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end

@implementation K9LogPatternMessageComponent

- (NSString *)stringFromLogMessage:(id<K9LogMessage>)logMessage
{
    return [logMessage k9_logMessageText];
}

@end

@implementation K9LogPatternLevelComponent

- (NSString *)stringFromLogMessage:(id<K9LogMessage>)logMessage
{
    switch ([logMessage k9_logMessageLevel]) {
        case K9LogMessageLevelVerbose:
            return @"VERBOSE";
        case K9LogMessageLevelDebug:
            return @"DEBUG";
        case K9LogMessageLevelInfo:
            return @"INFO";
        case K9LogMessageLevelWarn:
            return @"WARN";
        case K9LogMessageLevelError:
            return @"ERROR";
        default:
            return @"CUSTOM";
    }
}

@end
