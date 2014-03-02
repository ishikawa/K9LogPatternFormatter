#import <XCTest/XCTest.h>
#import "LogMessage.h"
#import "K9LogPatternComponent.h"
#import "K9LogPatternModifier.h"

@interface K9LogPatternMinWidthConstraintTests : XCTestCase

@end

@implementation K9LogPatternMinWidthConstraintTests

- (void)testInit
{
    id<K9LogPatternComponent>       component  = [[K9LogPatternMessageComponent alloc] init];
    K9LogPatternMinWidthConstraint *constraint = [[K9LogPatternMinWidthConstraint alloc] initWithComponent:component];

    XCTAssertFalse(constraint.leftJustification);
    XCTAssertEqual(constraint.width, (NSUInteger)0);
}

- (void)testZeroWidth
{
    LogMessage *message = [[LogMessage alloc] init];

    id<K9LogPatternComponent>       component  = [[K9LogPatternMessageComponent alloc] init];
    K9LogPatternMinWidthConstraint *constraint = [[K9LogPatternMinWidthConstraint alloc] initWithComponent:component
                                                                                                     width:0
                                                                                         leftJustification:NO];

    // Empty
    {
        message.text = @"";
        XCTAssertEqualObjects([constraint stringFromLogMessage:message], @"");
    }

    // Not Empty
    {
        message.text = @"A";
        XCTAssertEqualObjects([constraint stringFromLogMessage:message], @"A");
    }
}

- (void)testOneWidth
{
    LogMessage *message = [[LogMessage alloc] init];

    for (NSNumber *leftJustification in @[ @YES, @NO ]) {
        id<K9LogPatternComponent>       component  = [[K9LogPatternMessageComponent alloc] init];
        K9LogPatternMinWidthConstraint *constraint = [[K9LogPatternMinWidthConstraint alloc] initWithComponent:component
                                                                                                         width:1
                                                                                             leftJustification:leftJustification.boolValue];

        // Empty
        {
            message.text = @"";
            XCTAssertEqualObjects([constraint stringFromLogMessage:message], @" ");
        }

        // "A"
        {
            message.text = @"A";
            XCTAssertEqualObjects([constraint stringFromLogMessage:message], @"A");
        }

        // "12"
        {
            message.text = @"12";
            XCTAssertEqualObjects([constraint stringFromLogMessage:message], @"12");
        }
    }
}

- (void)testTwoWidth
{
    LogMessage *message = [[LogMessage alloc] init];

    id<K9LogPatternComponent>       component  = [[K9LogPatternMessageComponent alloc] init];

    // leftJustification = NO
    {
        K9LogPatternMinWidthConstraint *constraint = [[K9LogPatternMinWidthConstraint alloc] initWithComponent:component
                                                                                                         width:2
                                                                                             leftJustification:NO];

        message.text = @"A";
        XCTAssertEqualObjects([constraint stringFromLogMessage:message], @" A");
    }

    // leftJustification = YES
    {
        K9LogPatternMinWidthConstraint *constraint = [[K9LogPatternMinWidthConstraint alloc] initWithComponent:component
                                                                                                         width:2
                                                                                             leftJustification:YES];

        message.text = @"A";
        XCTAssertEqualObjects([constraint stringFromLogMessage:message], @"A ");
    }
}

@end
