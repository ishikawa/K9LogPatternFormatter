#import <Foundation/Foundation.h>
#import "K9LogPatternComponent.h"

@interface K9LogPatternModifier : NSObject <K9LogPatternComponent>

@property (nonatomic, readonly) id<K9LogPatternComponent> component;

- (instancetype)initWithComponent:(id<K9LogPatternComponent>)component;

@end

@interface K9LogPatternMinWidthConstraint : K9LogPatternModifier

@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, readonly) BOOL       leftJustification;

- (instancetype)initWithComponent:(id<K9LogPatternComponent>)component
                            width:(NSUInteger)width
                leftJustification:(BOOL)leftJustification;

@end

@interface K9LogPatternMaxWidthConstraint : K9LogPatternModifier

@property (nonatomic, readonly) NSUInteger width;

- (instancetype)initWithComponent:(id<K9LogPatternComponent>)component
                            width:(NSUInteger)width;

@end
