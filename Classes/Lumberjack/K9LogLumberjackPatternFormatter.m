#import "K9LogLumberjackPatternFormatter.h"
#import "K9LogMessage.h"
#import "K9LogPatternComponent.h"
#import "K9LogPatternParser.h"


@interface DDLogMessage (K9LogMessage) <K9LogMessage>

@end

@implementation DDLogMessage (K9LogMessage)

- (NSString *)k9_logMessageText
{
    return self->logMsg;
}

- (K9LogMessageLevel)k9_logMessageLevel
{
    const NSInteger level = self->logFlag;

    switch (level) {
        case LOG_FLAG_VERBOSE:
            return K9LogMessageLevelVerbose;
        case LOG_FLAG_DEBUG:
            return K9LogMessageLevelDebug;
        case LOG_FLAG_INFO:
            return K9LogMessageLevelInfo;
        case LOG_FLAG_WARN:
            return K9LogMessageLevelWarn;
        case LOG_FLAG_ERROR:
            return K9LogMessageLevelError;
        default:
            return K9LogMessageLevelCustomBase + level;
    }
}

- (NSDate *)k9_logTimestamp
{
    return self->timestamp;
}

@end



@interface K9LogLumberjackPatternFormatter ()

@property (nonatomic, readonly) NSArray *patternComponents;

@end

@implementation K9LogLumberjackPatternFormatter

// TODO: Extract initialization code into abstract class
- (instancetype)init
{
    return [self initWithPattern:@"%m"];
}

- (instancetype)initWithPattern:(NSString *)pattern
{
    return [self initWithPattern:pattern error:NULL];
}

- (instancetype)initWithPattern:(NSString *)pattern
                          error:(NSError **)errorPtr
{
    if (!pattern) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"pattern string should not be nil"
                                     userInfo:nil];
    }

    K9LogPatternParser *parser = [[K9LogPatternParser alloc] init];
    NSArray *components = [parser parse:pattern error:errorPtr];

    if (!components) {
        return nil;
    }

    if ((self = [super init])) {
        _pattern           = [pattern copy];
        _patternComponents = components;
    }

    return self;
}

#pragma mark - DDLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    // TODO: Extract into class (Parsed object?)
    NSMutableString *buffer = [NSMutableString string];

    for (id<K9LogPatternComponent> component in _patternComponents) {
        [buffer appendString:[component stringFromLogMessage:logMessage]];
    }

    return buffer;
}

@end
