#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, K9LogMessageLevel) {
    K9LogMessageLevelVerbose    = -1,
    K9LogMessageLevelDebug      = -2,
    K9LogMessageLevelInfo       = -3,
    K9LogMessageLevelWarn       = -4,
    K9LogMessageLevelError      = -5,
    K9LogMessageLevelCustomBase = 0,
};

@protocol K9LogMessage <NSObject>

- (NSString *)k9_messageText;

- (K9LogMessageLevel)k9_logLevel;

- (NSDate *)k9_timestamp;

- (NSString *)k9_fileName;

- (NSString *)k9_filePath;

- (NSInteger)k9_lineNumber;

@end
