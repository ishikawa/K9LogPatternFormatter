#import "K9LogPatternFormatter.h"
#import "K9LogPatternParser.h"
#import "K9LogPatternComponent.h"
#import "K9LogPatternDateComponent.h"
#import "K9LogPatternModifier.h"

@implementation K9LogPatternParser

- (NSArray *)parse:(NSString *)pattern error:(NSError **)errorPtr
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
            } else {
                if (errorPtr != NULL) {
                    *errorPtr = [NSError errorWithDomain:K9LogPatternFormatterErrorDomain
                                                    code:K9LogPatternFormatterParseError
                                                userInfo:nil];
                }

                return nil;
            }

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
                        *errorPtr = [NSError errorWithDomain:K9LogPatternFormatterErrorDomain
                                                        code:K9LogPatternFormatterParseError
                                                    userInfo:nil];
                    }

                    return nil;
                }
            }

            NSAssert(componentClass,
                     @"Pattern specifier class should be recognized.");

            id<K9LogPatternComponent> component = [[componentClass alloc] initWithParameters:parameters];

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
    
    return [components copy];
}

@end
