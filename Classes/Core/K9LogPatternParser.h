#import <Foundation/Foundation.h>
#import "K9LogPatternComponent.h"

#pragma mark - K9LogPatternParser

@class K9LogPatternParseResult;

@interface K9LogPatternParser : NSObject

- (nullable K9LogPatternParseResult *)parse:(nonnull NSString *)pattern error:(NSError * _Nullable * _Nullable)errorPtr;

// TODO: Customization API

@end

#pragma mark - K9LogPatternParseResult

@interface K9LogPatternParseResult : NSObject <K9LogPatternComponent,
                                               NSFastEnumeration>

- (nonnull instancetype)initWithComponents:(nonnull NSArray<id<K9LogPatternComponent>> *)components;

- (NSUInteger)count;

- (nonnull id<K9LogPatternComponent>)componentAtIndex:(NSUInteger)index;

#pragma mark Indexed Subscripting

- (nonnull id<K9LogPatternComponent>)objectAtIndexedSubscript:(NSUInteger)idx;

@end

#pragma mark - Errors

extern NSString * _Nonnull const K9LogPatternParserErrorDomain;

/*
 * -[NSError code] of K9LogPatternParserErrorDomain
 */
typedef NS_ENUM(NSInteger, K9LogPatternParserError) {
    K9LogPatternParserErrorUnknown = 1,
    K9LogPatternParserErrorUnrecognizedPattern,
    K9LogPatternParserErrorUnclosedBrace,
};
