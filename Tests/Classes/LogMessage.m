#import "LogMessage.h"

@implementation LogMessage

- (instancetype)init
{
    if ((self = [super init])) {
        _text      = @"";
        _level     = K9LogMessageLevelVerbose;
        _timestamp = [NSDate date];
    }
    return self;
}

- (NSString *)k9_logMessageText
{
    return self.text;
}

- (K9LogMessageLevel)k9_logMessageLevel
{
    return self.level;
}

- (NSDate *)k9_logTimestamp
{
    return self.timestamp;
}

@end

