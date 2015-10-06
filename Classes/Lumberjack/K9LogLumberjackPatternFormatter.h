#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface K9LogLumberjackPatternFormatter : NSObject <DDLogFormatter>

@property (nonatomic, readonly) NSString *pattern;

- (instancetype)initWithPattern:(NSString *)pattern;

- (instancetype)initWithPattern:(NSString *)pattern
                          error:(NSError **)errorPtr;

@end
