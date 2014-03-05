#import <Foundation/Foundation.h>
#import "K9LogPatternComponent.h"

#pragma mark - K9LogPatternParser

@class K9LogPatternParseResult;

@interface K9LogPatternParser : NSObject

- (K9LogPatternParseResult *)parse:(NSString *)pattern error:(NSError **)errorPtr;

// TODO: Customization API

@end

#pragma mark - K9LogPatternParseResult

@interface K9LogPatternParseResult : NSObject <K9LogPatternComponent,
                                               NSFastEnumeration>

- (instancetype)initWithComponents:(NSArray *)components;

- (NSUInteger)count;

- (id<K9LogPatternComponent>)componentAtIndex:(NSUInteger)index;

#pragma mark Indexed Subscripting

- (id<K9LogPatternComponent>)objectAtIndexedSubscript:(NSUInteger)idx;

@end

#pragma mark - Errors

extern NSString *const K9LogPatternParserErrorDomain;

/*
 * -[NSError code] of K9LogPatternParserErrorDomain
 */
typedef NS_ENUM(NSInteger, K9LogPatternParserError) {
    K9LogPatternParserInternalError = 1,
    K9LogPatternParserUnrecognizedPatternError,
    K9LogPatternParserUnclosedBraceError,
};
