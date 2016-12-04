#import "K9LogPatternLevelComponent.h"

@implementation K9LogPatternLevelComponent

- (instancetype)initWithParameters:(NSArray *)parameters
{
    return [super init];
}

- (NSString *)stringFromLogMessage:(id<K9LogMessage>)logMessage
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
