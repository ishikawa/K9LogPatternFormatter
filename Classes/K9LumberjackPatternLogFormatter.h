#import <Foundation/Foundation.h>
#import "DDLog.h"

@interface K9LumberjackPatternLogFormatter : NSObject <DDLogFormatter>

@property (nonatomic, readonly) NSString *pattern;

- (instancetype)initWithPattern:(NSString *)pattern;

@end
