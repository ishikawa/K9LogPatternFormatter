#import <Foundation/Foundation.h>
#import "K9LogMessage.h"

#pragma mark - Pattern Component Protocols

#pragma mark K9LogPatternComponent

@protocol K9LogPatternComponent <NSObject>

@required

- (nonnull NSString *)stringFromLogMessage:(nonnull id<K9LogMessage>)logMessage;

@end

#pragma mark K9LogPatternParameterizedComponent

@protocol K9LogPatternParameterizedComponent <K9LogPatternComponent>

@required

- (nonnull instancetype)initWithParameters:(nonnull NSArray *)parameters;

@end

#pragma mark - Pattern Component Classes

#pragma mark K9LogPatternParameterizedComponent

@interface K9LogPatternParameterizedComponent : NSObject <K9LogPatternParameterizedComponent>

@end

#pragma mark K9LogPatternLiteralTextComponent

@interface K9LogPatternLiteralTextComponent : NSObject <K9LogPatternComponent>

@property (nonatomic, readonly, nonnull) NSString *text;

- (nonnull instancetype)initWithText:(nonnull NSString *)text;

@end

#pragma mark K9LogPatternLiteralPercentSignComponent

@interface K9LogPatternPercentSignComponent : NSObject <K9LogPatternComponent>

@end

#pragma mark K9LogPatternMessageComponent

@interface K9LogPatternMessageComponent : NSObject <K9LogPatternComponent>

@end

#pragma mark K9LogPatternLevelComponent

@interface K9LogPatternLevelComponent : NSObject <K9LogPatternComponent>

@end

#pragma mark K9LogPatternFilePathComponent

@interface K9LogPatternFilePathComponent : NSObject <K9LogPatternComponent>

@end

#pragma mark K9LogPatternLineNumberComponent

@interface K9LogPatternLineNumberComponent : NSObject <K9LogPatternComponent>

@end

#pragma mark K9LogPatternMethodNameComponent

@interface K9LogPatternMethodNameComponent : NSObject <K9LogPatternComponent>

@end

// TODO: Add more convertion specifiers
