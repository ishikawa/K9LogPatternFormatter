#import <Foundation/Foundation.h>
#import "K9LogMessage.h"

@interface LogMessage : NSObject <K9LogMessage>

@property (nonatomic) NSString          *text;
@property (nonatomic) K9LogMessageLevel  level;
@property (nonatomic) NSDate            *timestamp;
@property (nonatomic) NSString          *filePath;
@property (nonatomic) NSInteger          lineNumber;

@end
