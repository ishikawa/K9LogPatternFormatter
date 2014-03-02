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

- (NSString *)k9_logMessageText;

- (K9LogMessageLevel)k9_logMessageLevel;

- (NSDate *)k9_logTimestamp;

@end
