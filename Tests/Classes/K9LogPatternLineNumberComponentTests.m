#import <XCTest/XCTest.h>
#import "LogMessage.h"
#import "K9LogPatternComponent.h"

@interface K9LogPatternLineNumberComponentTests : XCTestCase

@end

@implementation K9LogPatternLineNumberComponentTests

- (void)testStringFromLineNumber
{
    K9LogPatternLineNumberComponent *component = [[K9LogPatternLineNumberComponent alloc] init];

    LogMessage *message = [[LogMessage alloc] init];
    message.lineNumber = 16;

    XCTAssertEqualObjects([component stringFromLogMessage:message], @"16");
}

@end
