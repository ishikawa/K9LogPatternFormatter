#import <Foundation/Foundation.h>
#import "K9LogPatternComponent.h"

@interface K9LogPatternDateComponent : K9LogPatternParameterizedComponent

@property (nonatomic, readonly, nonnull)         NSString   *nameOrFormat;
@property (nonatomic, readonly, null_resettable) NSLocale   *locale;
@property (nonatomic, readonly, null_resettable) NSTimeZone *timeZone;

- (nonnull instancetype)initWithNameOrFormat:(nonnull NSString *)nameOrFormat;

@end
