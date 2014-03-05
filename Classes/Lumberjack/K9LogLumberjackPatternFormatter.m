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

@property (nonatomic, readonly) K9LogPatternParseResult *parseResult;

@end

@implementation K9LogLumberjackPatternFormatter

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
    K9LogPatternParseResult *parseResult = [parser parse:pattern error:errorPtr];

    if (!parseResult) {
        return nil;
    }

    if ((self = [super init])) {
        _pattern     = [pattern copy];
        _parseResult = parseResult;
    }

    return self;
}

#pragma mark - DDLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    return [_parseResult stringFromLogMessage:logMessage];
}

@end
