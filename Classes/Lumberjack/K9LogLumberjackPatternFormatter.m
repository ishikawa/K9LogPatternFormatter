#import "K9LogLumberjackPatternFormatter.h"
#import "K9LogMessage.h"
#import "K9LogPatternComponent.h"
#import "K9LogPatternParser.h"


@interface DDLogMessage (K9LogMessage) <K9LogMessage>

@end

@implementation DDLogMessage (K9LogMessage)

- (NSString *)k9_messageText
{
    return self.message;
}

- (K9LogMessageLevel)k9_logLevel
{
    // CocoaLumberjack: DDLogFlag is constant value, but DDLogLevel is bitmask.
    const DDLogFlag flag = self.flag;

    switch (flag) {
        case DDLogFlagVerbose:
            return K9LogMessageLevelVerbose;
        case DDLogFlagDebug:
            return K9LogMessageLevelDebug;
        case DDLogFlagInfo:
            return K9LogMessageLevelInfo;
        case DDLogFlagWarning:
            return K9LogMessageLevelWarn;
        case DDLogFlagError:
            return K9LogMessageLevelError;
        default:
            return K9LogMessageLevelCustomBase + flag;
    }
}

- (NSDate *)k9_timestamp
{
    return self.timestamp;
}

- (NSString *)k9_filePath
{
    return self.file;
}

- (NSUInteger)k9_lineNumber
{
    return self.line;
}

- (NSString *)k9_methodName
{
    return self.function;
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
