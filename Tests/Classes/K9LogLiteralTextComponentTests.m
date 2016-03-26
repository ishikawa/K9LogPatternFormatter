#import <XCTest/XCTest.h>
#import "K9LogPatternComponent.h"
#import "LogMessage.h"

@interface K9LogLiteralTextComponentTests : XCTestCase

@end

@implementation K9LogLiteralTextComponentTests

- (void)testInit
{
    LogMessage *message = [[LogMessage alloc] init];
    K9LogPatternLiteralTextComponent *component = [[K9LogPatternLiteralTextComponent alloc] init];

    XCTAssertEqualObjects([component stringFromLogMessage:message], @"");
}

- (void)testInitWithEmptyText
{
    LogMessage *message = [[LogMessage alloc] init];
    K9LogPatternLiteralTextComponent *component = [[K9LogPatternLiteralTextComponent alloc] initWithText:@""];

    XCTAssertEqualObjects([component stringFromLogMessage:message], @"");
}

- (void)testInitWithNil
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    XCTAssertThrowsSpecificNamed([[K9LogPatternLiteralTextComponent alloc] initWithText:nil],
                                 NSException,
                                 NSInvalidArgumentException);
#pragma clang diagnostic pop
}

@end
