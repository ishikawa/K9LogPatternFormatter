#import <Foundation/Foundation.h>
#import "K9LogMessage.h"

@interface LogMessage : NSObject <K9LogMessage>

@property (nonatomic, nonnull) NSString          *text;
@property (nonatomic)          K9LogMessageLevel  level;
@property (nonatomic, nonnull) NSDate            *timestamp;
@property (nonatomic, nonnull) NSString          *filePath;
@property (nonatomic)          NSUInteger         lineNumber;
@property (nonatomic, nonnull) NSString          *methodName;

@end
