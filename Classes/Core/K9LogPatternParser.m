#import "K9LogPatternParser.h"
#import "K9LogPatternComponent.h"
#import "K9LogPatternDateComponent.h"
#import "K9LogPatternFileNameComponent.h"
#import "K9LogPatternModifier.h"

NSString *const K9LogPatternParserErrorDomain = @"jp.ko9.LogPatternParser.ErrorDomain";

@implementation K9LogPatternParser

- (K9LogPatternParseResult *)parse:(NSString *)pattern error:(NSError **)errorPtr
{
    if (!pattern) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"pattern should not be nil"
                                     userInfo:nil];
    }

    NSScanner *scanner = [NSScanner scannerWithString:pattern];

    scanner.caseSensitive = YES;
    scanner.charactersToBeSkipped = nil;

    NSMutableArray *components = [NSMutableArray array];

    while (![scanner isAtEnd]) {
        NSString *literal = nil;

        if ([scanner scanUpToString:@"%" intoString:&literal]) {
            [components addObject:[[K9LogPatternLiteralTextComponent alloc] initWithText:literal]];
        };

        if ([scanner scanString:@"%" intoString:NULL]) {
            // Format modifier
            BOOL leftJustification = NO;

            NSInteger maxWidth = -1;
            NSInteger minWidth = -1;

            if ([scanner scanString:@"-" intoString:NULL]) {
                leftJustification = YES;
            }

            [scanner scanInteger:&minWidth];

            if ([scanner scanString:@"." intoString:NULL]) {
                [scanner scanInteger:&maxWidth];
            }


            Class componentClass = nil;

            if ([scanner scanString:@"m" intoString:NULL]) {
                componentClass = [K9LogPatternMessageComponent class];
            } else if ([scanner scanString:@"p" intoString:NULL]) {
                componentClass = [K9LogPatternLevelComponent class];
            } else if ([scanner scanString:@"d" intoString:NULL]) {
                componentClass = [K9LogPatternDateComponent class];
            } else if ([scanner scanString:@"F" intoString:NULL]) {
                componentClass = [K9LogPatternFileNameComponent class];
            } else if ([scanner scanString:@"l" intoString:NULL]) {
                componentClass = [K9LogPatternFilePathComponent class];
            } else if ([scanner scanString:@"L" intoString:NULL]) {
                componentClass = [K9LogPatternLineNumberComponent class];
            } else if ([scanner scanString:@"M" intoString:NULL]) {
                componentClass = [K9LogPatternMethodNameComponent class];
            } else if ([scanner scanString:@"%" intoString:NULL]) {
                componentClass = [K9LogPatternPercentSignComponent class];
            } else {
                if (errorPtr != NULL) {
                    *errorPtr = [NSError errorWithDomain:K9LogPatternParserErrorDomain
                                                    code:K9LogPatternParserUnrecognizedPatternError
                                                userInfo:nil];
                }

                return nil;
            }

            id<K9LogPatternComponent> component = nil;

            NSAssert(componentClass,
                     @"Pattern specifier class should be recognized.");

            if ([componentClass conformsToProtocol:@protocol(K9LogPatternParameterizedComponent)]) {
                // Parameters
                NSMutableArray *parameters = [NSMutableArray array];

                while ([scanner scanString:@"{" intoString:NULL]) {
                    NSString *param = @"";

                    // If first character is "}", scanUpToString:intoString: returns NO
                    [scanner scanUpToString:@"}" intoString:&param];

                    if ([scanner scanString:@"}" intoString:NULL]) {
                        [parameters addObject:param];
                    } else {
                        // Unclosed brace
                        if (errorPtr != NULL) {
                            *errorPtr = [NSError errorWithDomain:K9LogPatternParserErrorDomain
                                                            code:K9LogPatternParserUnclosedBraceError
                                                        userInfo:nil];
                        }

                        return nil;
                    }
                }

                component = [[componentClass alloc] initWithParameters:parameters];
            } else {
                component = [[componentClass alloc] init];
            }

            if (minWidth >= 0) {
                component = [[K9LogPatternMinWidthConstraint alloc] initWithComponent:component
                                                                                width:minWidth
                                                                    leftJustification:leftJustification];
            }

            if (maxWidth >= 0) {
                component = [[K9LogPatternMaxWidthConstraint alloc] initWithComponent:component
                                                                                width:maxWidth];
            }
            
            [components addObject:component];
        }
    }
    
    return [[K9LogPatternParseResult alloc] initWithComponents:components];
}

@end

#pragma mark - K9LogPatternParseResult

@interface K9LogPatternParseResult ()

@property (nonatomic, copy) NSArray *components;

@end

@implementation K9LogPatternParseResult

- (instancetype)init
{
    return [self initWithComponents:@[]];
}

- (instancetype)initWithComponents:(NSArray *)components
{
    if ((self = [super init])) {
        self.components = components;
    }

    return self;
}

- (NSUInteger)count
{
    return _components.count;
}

- (id<K9LogPatternComponent>)componentAtIndex:(NSUInteger)index
{
    return _components[index];
}

#pragma mark K9LogPatternComponent

- (NSString *)stringFromLogMessage:(id<K9LogMessage>)logMessage
{
    NSMutableString *buffer = [NSMutableString string];

    for (id<K9LogPatternComponent> component in self) {
        [buffer appendString:[component stringFromLogMessage:logMessage]];
    }

    return buffer;
}

#pragma mark Indexed Subscripting

- (id<K9LogPatternComponent>)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [_components objectAtIndexedSubscript:idx];
}

#pragma mark NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])buffer
                                    count:(NSUInteger)len
{
    return [_components countByEnumeratingWithState:state
                                            objects:buffer
                                              count:len];
}

@end
