#import <XCTest/XCTest.h>
#import "K9LogPatternComponent.h"
#import "LogMessage.h"

@interface K9LogPatternPercentSignComponentTests : XCTestCase

@end

@implementation K9LogPatternPercentSignComponentTests

- (void)testInit
{
    LogMessage *message = [[LogMessage alloc] init];
    K9LogPatternPercentSignComponent *component = [[K9LogPatternPercentSignComponent alloc] init];

    XCTAssertEqualObjects([component stringFromLogMessage:message], @"%");
}

@end
