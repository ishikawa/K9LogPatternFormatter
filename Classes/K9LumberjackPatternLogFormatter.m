#import "K9LumberjackPatternLogFormatter.h"

@implementation K9LumberjackPatternLogFormatter

- (instancetype)init
{
    return [self initWithPattern:@"%m"];
}

- (instancetype)initWithPattern:(NSString *)pattern
{
    if (!pattern) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"pattern string should not be nil"
                                     userInfo:nil];
    }

    if ((self = [super init])) {
        _pattern = [pattern copy];
    }

    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *logLevel;
    switch (logMessage->logFlag)
    {
        case LOG_FLAG_ERROR : logLevel = @"ERROR"; break;
        case LOG_FLAG_WARN  : logLevel = @"WARN"; break;
        case LOG_FLAG_INFO  : logLevel = @"INFO"; break;
        case LOG_FLAG_DEBUG : logLevel = @"DEBUG"; break;
        default             : logLevel = @"TRACE"; break;
    }

    return [NSString stringWithFormat:@"%@ | %@", logLevel, logMessage->logMsg];
}

@end
