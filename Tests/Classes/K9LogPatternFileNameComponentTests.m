#import <XCTest/XCTest.h>
#import "LogMessage.h"
#import "K9LogPatternComponent.h"

@interface K9LogPatternFileNameComponentTests : XCTestCase

@end

@implementation K9LogPatternFileNameComponentTests

- (void)testStringFromEmptyPath
{
    K9LogPatternFileNameComponent *component = [[K9LogPatternFileNameComponent alloc] init];

    LogMessage *message = [[LogMessage alloc] init];
    message.fileName = @"";

    XCTAssertEqualObjects([component stringFromLogMessage:message], @"");
}

- (void)testStringFromPath
{
    K9LogPatternFileNameComponent *component = [[K9LogPatternFileNameComponent alloc] init];

    LogMessage *message = [[LogMessage alloc] init];
    message.fileName = @"Test";

    XCTAssertEqualObjects([component stringFromLogMessage:message], @"Test");
}

@end
