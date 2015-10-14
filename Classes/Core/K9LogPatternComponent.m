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

- (nonnull NSString *)stringFromLogMessage:(nonnull id<K9LogMessage>)logMessage
{
    return _text;
}

@end

@implementation K9LogPatternPercentSignComponent

- (NSString *)stringFromLogMessage:(id<K9LogMessage>)logMessage
{
    return @"%";
}

@end

@implementation K9LogPatternParameterizedComponent

- (instancetype)init
{
    return [super init];
}

- (instancetype)initWithParameters:(NSArray *)parameters
{
    return [super init];
}

- (nonnull NSString *)stringFromLogMessage:(nonnull id<K9LogMessage>)logMessage
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end

#pragma mark K9LogPatternMessageComponent

@implementation K9LogPatternMessageComponent

- (nonnull NSString *)stringFromLogMessage:(nonnull id<K9LogMessage>)logMessage
{
    return [logMessage k9_messageText];
}

@end

#pragma mark K9LogPatternLevelComponent

@implementation K9LogPatternLevelComponent

- (nonnull NSString *)stringFromLogMessage:(nonnull id<K9LogMessage>)logMessage
{
    switch ([logMessage k9_logLevel]) {
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

#pragma mark K9LogPatternFilePathComponent

@implementation K9LogPatternFilePathComponent

- (nonnull NSString *)stringFromLogMessage:(nonnull id<K9LogMessage>)logMessage
{
    return [logMessage k9_filePath];
}

@end

#pragma mark K9LogPatternLineNumberComponent

@implementation K9LogPatternLineNumberComponent

- (nonnull NSString *)stringFromLogMessage:(nonnull id<K9LogMessage>)logMessage
{
    return [NSString stringWithFormat:@"%lu", (unsigned long)[logMessage k9_lineNumber]];
}

@end

#pragma mark K9LogPatternMethodNameComponent

@implementation K9LogPatternMethodNameComponent

- (nonnull NSString *)stringFromLogMessage:(nonnull id<K9LogMessage>)logMessage
{
    return [logMessage k9_methodName];
}

@end
