#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface K9LogLumberjackPatternFormatter : NSObject <DDLogFormatter>

@property (nonatomic, readonly, nonnull) NSString *pattern;

- (nonnull instancetype)initWithPattern:(nonnull NSString *)pattern;

- (nonnull instancetype)initWithPattern:(nonnull NSString *)pattern
                                  error:(NSError * _Nullable * _Nullable)errorPtr;

@end
