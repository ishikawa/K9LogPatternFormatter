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

- (nonnull NSString *)k9_messageText;

- (K9LogMessageLevel)k9_logLevel;

- (nonnull NSDate *)k9_timestamp;

- (nonnull NSString *)k9_filePath;

- (NSUInteger)k9_lineNumber;

- (nonnull NSString *)k9_methodName;

@end
