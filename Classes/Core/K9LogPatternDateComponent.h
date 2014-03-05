#import <Foundation/Foundation.h>
#import "K9LogPatternComponent.h"

@interface K9LogPatternDateComponent : K9LogPatternParameterizedComponent

@property (nonatomic, readonly) NSString   *nameOrFormat;
@property (nonatomic, readonly) NSLocale   *locale;
@property (nonatomic, readonly) NSTimeZone *timeZone;

- (instancetype)initWithNameOrFormat:(NSString *)nameOrFormat;

@end
