#import <XCTest/XCTest.h>
#import "LogMessage.h"
#import "K9LogPatternComponent.h"

@interface K9LogPatternMethodNameComponentTests : XCTestCase

@end

@implementation K9LogPatternMethodNameComponentTests

- (void)testStringFromEmpty
{
    K9LogPatternMethodNameComponent *component = [[K9LogPatternMethodNameComponent alloc] init];

    LogMessage *message = [[LogMessage alloc] init];
    message.methodName = @"";

    XCTAssertEqualObjects([component stringFromLogMessage:message], @"");
}

- (void)testStringFromEmptyPath
{
    K9LogPatternMethodNameComponent *component = [[K9LogPatternMethodNameComponent alloc] init];

    LogMessage *message = [[LogMessage alloc] init];
    message.methodName = @"";

    XCTAssertEqualObjects([component stringFromLogMessage:message], @"");
}

- (void)testStringFromMethodName
{
    K9LogPatternMethodNameComponent *component = [[K9LogPatternMethodNameComponent alloc] init];

    LogMessage *message = [[LogMessage alloc] init];
    message.methodName = @"doSomething";

    XCTAssertEqualObjects([component stringFromLogMessage:message], @"doSomething");
}

@end
