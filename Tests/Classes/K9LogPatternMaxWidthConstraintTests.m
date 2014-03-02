#import <XCTest/XCTest.h>
#import "LogMessage.h"
#import "K9LogPatternComponent.h"
#import "K9LogPatternModifier.h"

@interface K9LogPatternMaxWidthConstraintTests : XCTestCase

@end

@implementation K9LogPatternMaxWidthConstraintTests

- (void)testInit
{
    id<K9LogPatternComponent>       component  = [[K9LogPatternMessageComponent alloc] init];
    K9LogPatternMaxWidthConstraint *constraint = [[K9LogPatternMaxWidthConstraint alloc] initWithComponent:component];

    XCTAssertEqual(constraint.width, (NSUInteger)0);
}

- (void)testZeroWidth
{
    LogMessage *message = [[LogMessage alloc] init];

    id<K9LogPatternComponent>       component  = [[K9LogPatternMessageComponent alloc] init];
    K9LogPatternMaxWidthConstraint *constraint = [[K9LogPatternMaxWidthConstraint alloc] initWithComponent:component
                                                                                                     width:0];

    // Empty
    {
        message.text = @"";
        XCTAssertEqualObjects([constraint stringFromLogMessage:message], @"");
    }

    // Not Empty
    {
        message.text = @"A";
        XCTAssertEqualObjects([constraint stringFromLogMessage:message], @"");
    }
}

- (void)testOneWidth
{
    LogMessage *message = [[LogMessage alloc] init];

    id<K9LogPatternComponent>       component  = [[K9LogPatternMessageComponent alloc] init];
    K9LogPatternMaxWidthConstraint *constraint = [[K9LogPatternMaxWidthConstraint alloc] initWithComponent:component
                                                                                                     width:1];

    // Empty
    {
        message.text = @"";
        XCTAssertEqualObjects([constraint stringFromLogMessage:message], @"");
    }

    // "A"
    {
        message.text = @"A";
        XCTAssertEqualObjects([constraint stringFromLogMessage:message], @"A");
    }

    // "12"
    {
        message.text = @"12";
        XCTAssertEqualObjects([constraint stringFromLogMessage:message], @"1");
    }
}

@end
