#import <Foundation/Foundation.h>
#import "K9LogMessage.h"

#pragma mark - Pattern Component Protocols

#pragma mark K9LogPatternComponent

@protocol K9LogPatternComponent <NSObject>

@required

- (NSString *)stringFromLogMessage:(id<K9LogMessage>)logMessage;

@end

#pragma mark K9LogPatternParametarizedComponent

@protocol K9LogPatternParametarizedComponent <K9LogPatternComponent>

@required

- (instancetype)initWithParameters:(NSArray *)parameters;

@end

#pragma mark - Pattern Component Classes

#pragma mark K9LogPatternParametarizedComponent

@interface K9LogPatternParametarizedComponent : NSObject <K9LogPatternParametarizedComponent>

@end

#pragma mark K9LogPatternLiteralTextComponent

@interface K9LogPatternLiteralTextComponent : NSObject <K9LogPatternComponent>

@property (nonatomic, readonly) NSString *text;

- (instancetype)initWithText:(NSString *)text;

@end

#pragma mark K9LogPatternMessageComponent

@interface K9LogPatternMessageComponent : K9LogPatternParametarizedComponent

@end

#pragma mark K9LogPatternLevelComponent

@interface K9LogPatternLevelComponent : K9LogPatternParametarizedComponent

@end

// TODO: Add more convertion specifiers
