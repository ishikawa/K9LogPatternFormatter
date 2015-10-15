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

@implementation K9LogPatternPercentSignComponent

- (NSString *)stringFromLogMessage:(id<K9LogMessage>)logMessage
{
    return @"%";
}

@end

#pragma mark K9LogPatternMessageComponent

@implementation K9LogPatternMessageComponent

- (NSString *)stringFromLogMessage:(id<K9LogMessage>)logMessage
{
    return [logMessage k9_messageText];
}

@end

#pragma mark K9LogPatternFilePathComponent

@implementation K9LogPatternFilePathComponent

- (NSString *)stringFromLogMessage:(id<K9LogMessage>)logMessage
{
    return [logMessage k9_filePath];
}

@end

#pragma mark K9LogPatternLineNumberComponent

@implementation K9LogPatternLineNumberComponent

- (NSString *)stringFromLogMessage:(id<K9LogMessage>)logMessage
{
    return [NSString stringWithFormat:@"%lu", (unsigned long)[logMessage k9_lineNumber]];
}

@end

#pragma mark K9LogPatternMethodNameComponent

@implementation K9LogPatternMethodNameComponent

- (NSString *)stringFromLogMessage:(id<K9LogMessage>)logMessage
{
    return [logMessage k9_methodName];
}

@end
