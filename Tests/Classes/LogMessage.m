#import "LogMessage.h"

@implementation LogMessage

- (instancetype)init
{
    if ((self = [super init])) {
        _text      = @"";
        _level     = K9LogMessageLevelVerbose;
        _timestamp = [NSDate date];
        _fileName  = @"";
        _filePath  = @"";
    }
    return self;
}

- (NSString *)k9_messageText
{
    return self.text;
}

- (K9LogMessageLevel)k9_logLevel
{
    return self.level;
}

- (NSDate *)k9_timestamp
{
    return self.timestamp;
}

- (NSString *)k9_fileName
{
    return self.fileName;
}

- (NSString *)k9_filePath
{
    return self.filePath;
}

- (NSInteger)k9_lineNumber
{
    return self.lineNumber;
}

@end
