#import <Foundation/Foundation.h>
#import "DDLog.h"

@interface K9LogLumberjackPatternFormatter : NSObject <DDLogFormatter>

@property (nonatomic, readonly) NSString *pattern;

- (instancetype)initWithPattern:(NSString *)pattern;

- (instancetype)initWithPattern:(NSString *)pattern
                          error:(NSError **)errorPtr;

@end
