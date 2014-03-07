#import <XCTest/XCTest.h>
#import "LogMessage.h"
#import "K9LogPatternComponent.h"

@interface K9LogPatternFilePathComponentTests : XCTestCase

@end

@implementation K9LogPatternFilePathComponentTests

- (void)testStringFromNil
{
    K9LogPatternFilePathComponent *component = [[K9LogPatternFilePathComponent alloc] init];

    LogMessage *message = [[LogMessage alloc] init];
    message.filePath = nil;

    XCTAssertNil([component stringFromLogMessage:message]);
}

- (void)testStringFromEmptyPath
{
    K9LogPatternFilePathComponent *component = [[K9LogPatternFilePathComponent alloc] init];

    LogMessage *message = [[LogMessage alloc] init];
    message.filePath = @"";

    XCTAssertEqualObjects([component stringFromLogMessage:message], @"");
}

- (void)testStringFromPath
{
    K9LogPatternFilePathComponent *component = [[K9LogPatternFilePathComponent alloc] init];

    LogMessage *message = [[LogMessage alloc] init];
    message.filePath = @"Classes/Test.m";

    XCTAssertEqualObjects([component stringFromLogMessage:message], @"Classes/Test.m");
}

@end
