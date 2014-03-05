#import <XCTest/XCTest.h>
#import "K9LogPatternFormatter.h"
#import "K9LogPatternParser.h"
#import "K9LogPatternComponent.h"
#import "K9LogPatternModifier.h"
#import "K9LogPatternDateComponent.h"

@interface K9LogPatternParserTests : XCTestCase

@end

@implementation K9LogPatternParserTests

- (K9LogPatternParseResult *)parseComponentsFromPattern:(NSString *)pattern
{
    K9LogPatternParser *parser = [[K9LogPatternParser alloc] init];

    NSError *error = nil;

    K9LogPatternParseResult *result = [parser parse:pattern error:&error];

    XCTAssertNotNil(result, @"Pattern: %@", pattern);
    XCTAssertNil(error, @"Pattern: %@", pattern);

    return result;
}

- (id)parseOneComponentFromPattern:(NSString *)pattern
{
    K9LogPatternParseResult *result = [self parseComponentsFromPattern:pattern];

    XCTAssertEqual(result.count,
                   (NSUInteger)1,
                   @"1 component: %@", pattern);

    return result[0];
}

- (void)testNil
{
    K9LogPatternParser *parser = [[K9LogPatternParser alloc] init];

    NSError *error = nil;

    XCTAssertThrowsSpecificNamed([parser parse:nil error:&error],
                                 NSException,
                                 NSInvalidArgumentException);
    XCTAssertNil(error);
}

- (void)testEmpty
{
    K9LogPatternParseResult *components = [self parseComponentsFromPattern:@""];

    XCTAssertEqual(components.count, (NSUInteger)0);
}

- (void)testLiteral
{
    K9LogPatternParseResult *components = [self parseComponentsFromPattern:@"Hi"];

    XCTAssertEqual(components.count, (NSUInteger)1, @"1 component");

    {
        K9LogPatternLiteralTextComponent *component = components[0];

        XCTAssertTrue([component isKindOfClass:[K9LogPatternLiteralTextComponent class]],
                      @"1st component");
        XCTAssertEqualObjects(component.text, @"Hi");
    }
}

- (void)testMultiplePatterns
{
    K9LogPatternParseResult *components = [self parseComponentsFromPattern:@"%p %m"];

    XCTAssertEqual(components.count, (NSUInteger)3);

    {
        K9LogPatternLevelComponent *component = (K9LogPatternLevelComponent *)components[0];

        XCTAssertTrue([component isKindOfClass:[K9LogPatternLevelComponent class]],
                      @"1st component");
    }
    {
        K9LogPatternLiteralTextComponent *component = (K9LogPatternLiteralTextComponent *)components[1];

        XCTAssertTrue([component isKindOfClass:[K9LogPatternLiteralTextComponent class]],
                      @"2nd component");
        XCTAssertEqualObjects(component.text, @" ");
    }
    {
        K9LogPatternMessageComponent *component = (K9LogPatternMessageComponent *)components[2];

        XCTAssertTrue([component isKindOfClass:[K9LogPatternMessageComponent class]],
                      @"3rd component");
    }
}

- (void)testParameter
{
    // Empty param
    {
        K9LogPatternDateComponent *component = [self parseOneComponentFromPattern:@"%d{}"];

        XCTAssertTrue([component isKindOfClass:[K9LogPatternDateComponent class]]);
        XCTAssertEqualObjects(component.nameOrFormat, @"");
    }

    // Whitespaces
    {
        K9LogPatternDateComponent *component = [self parseOneComponentFromPattern:@"%d{ }"];

        XCTAssertTrue([component isKindOfClass:[K9LogPatternDateComponent class]]);
        XCTAssertEqualObjects(component.nameOrFormat, @" ");
    }

    // Word
    {
        K9LogPatternDateComponent *component = [self parseOneComponentFromPattern:@"%d{ISO8601}"];

        XCTAssertTrue([component isKindOfClass:[K9LogPatternDateComponent class]]);
        XCTAssertEqualObjects(component.nameOrFormat, @"ISO8601");
    }

    // Unclosed
    {
        K9LogPatternParser *parser = [[K9LogPatternParser alloc] init];

        NSError *error = nil;

        [parser parse:@"%d{" error:&error];

        XCTAssertNotNil(error);
        XCTAssertEqualObjects(error.domain, K9LogPatternFormatterErrorDomain);
        XCTAssertEqual(error.code, (NSInteger)K9LogPatternFormatterParseError);
    }
}

- (void)testDatePattern
{
    // Default
    {
        K9LogPatternDateComponent *component = [self parseOneComponentFromPattern:@"%d"];

        XCTAssertTrue([component isKindOfClass:[K9LogPatternDateComponent class]]);
        XCTAssertNil(component.nameOrFormat);
    }

    // Format
    {
        K9LogPatternDateComponent *component = [self parseOneComponentFromPattern:@"%d{yyyy'-'mm' 'HH}"];

        XCTAssertTrue([component isKindOfClass:[K9LogPatternDateComponent class]]);
        XCTAssertEqualObjects(component.nameOrFormat, @"yyyy'-'mm' 'HH");
    }
}

- (void)testModifier
{
    // %1
    {
        K9LogPatternMinWidthConstraint *component = [self parseOneComponentFromPattern:@"%1m"];

        XCTAssertTrue([component isKindOfClass:[K9LogPatternMinWidthConstraint class]]);
        XCTAssertEqual(component.width, (NSUInteger)1);
        XCTAssertFalse(component.leftJustification);
        XCTAssertTrue([component.component isKindOfClass:[K9LogPatternMessageComponent class]]);
    }

    // %-10
    {
        K9LogPatternMinWidthConstraint *component = [self parseOneComponentFromPattern:@"%-10m"];

        XCTAssertTrue([component isKindOfClass:[K9LogPatternMinWidthConstraint class]]);
        XCTAssertEqual(component.width, (NSUInteger)10);
        XCTAssertTrue(component.leftJustification);
        XCTAssertTrue([component.component isKindOfClass:[K9LogPatternMessageComponent class]]);
    }

    // %.5
    {
        K9LogPatternMaxWidthConstraint *component = [self parseOneComponentFromPattern:@"%.5m"];

        XCTAssertTrue([component isKindOfClass:[K9LogPatternMaxWidthConstraint class]]);
        XCTAssertEqual(component.width, (NSUInteger)5);
        XCTAssertTrue([component.component isKindOfClass:[K9LogPatternMessageComponent class]]);
    }

    // %-20.50
    {
        K9LogPatternMaxWidthConstraint *component = [self parseOneComponentFromPattern:@"%-20.50m"];

        XCTAssertTrue([component isKindOfClass:[K9LogPatternMaxWidthConstraint class]]);
        XCTAssertEqual(component.width, (NSUInteger)50);

        K9LogPatternMinWidthConstraint *c1 = component.component;

        XCTAssertTrue([c1 isKindOfClass:[K9LogPatternMinWidthConstraint class]]);
        XCTAssertEqual(c1.width, (NSUInteger)20);
        XCTAssertTrue(c1.leftJustification);

        XCTAssertTrue([c1.component isKindOfClass:[K9LogPatternMessageComponent class]]);
    }
}

@end
