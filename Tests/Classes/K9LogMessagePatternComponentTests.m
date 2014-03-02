#import <XCTest/XCTest.h>
#import "LogMessage.h"
#import "K9LogPatternComponent.h"

@interface K9LogMessagePatternComponentTests : XCTestCase

@end

@implementation K9LogMessagePatternComponentTests

- (void)testStringFromEmptyText
{
    K9LogPatternMessageComponent *component = [[K9LogPatternMessageComponent alloc] init];

    LogMessage *message = [[LogMessage alloc] init];
    message.text = @"";

    XCTAssertEqualObjects([component stringFromLogMessage:message], @"");
}

- (void)testStringFromNotEmpty
{
    K9LogPatternMessageComponent *component = [[K9LogPatternMessageComponent alloc] init];

    LogMessage *message = [[LogMessage alloc] init];
    message.text = @"A";

    XCTAssertEqualObjects([component stringFromLogMessage:message], @"A");
}

@end
