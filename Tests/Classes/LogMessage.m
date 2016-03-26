#import "LogMessage.h"

@implementation LogMessage

- (instancetype)init
{
    if ((self = [super init])) {
        _text       = @"";
        _level      = K9LogMessageLevelVerbose;
        _timestamp  = [NSDate date];
        _filePath   = @"";
        _methodName = @"";
    }
    return self;
}

- (nonnull NSString *)k9_messageText
{
    return self.text;
}

- (K9LogMessageLevel)k9_logLevel
{
    return self.level;
}

- (nonnull NSDate *)k9_timestamp
{
    return self.timestamp;
}

- (nonnull NSString *)k9_filePath
{
    return self.filePath;
}

- (NSUInteger)k9_lineNumber
{
    return self.lineNumber;
}

- (nonnull NSString *)k9_methodName
{
    return self.methodName;
}

@end
