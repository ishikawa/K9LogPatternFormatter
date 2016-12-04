#import <XCTest/XCTest.h>
#import "LogMessage.h"
#import "K9LogPatternLevelComponent.h"

@interface K9LogLevelPatternComponentTests : XCTestCase

@end

@implementation K9LogLevelPatternComponentTests

- (void)testStringFromLevel
{
    K9LogPatternLevelComponent *component = [[K9LogPatternLevelComponent alloc] init];



    NSDictionary *stringByLevel = @{
                                    @(K9LogMessageLevelVerbose):      @"VERBOSE",
                                    @(K9LogMessageLevelDebug):        @"DEBUG",
                                    @(K9LogMessageLevelInfo):         @"INFO",
                                    @(K9LogMessageLevelWarn):         @"WARN",
                                    @(K9LogMessageLevelError):        @"ERROR",

                                    // Custom
                                    @(K9LogMessageLevelCustomBase):   @"CUSTOM",
                                    @(K9LogMessageLevelCustomBase+1): @"CUSTOM",
                                    };

    [stringByLevel enumerateKeysAndObjectsUsingBlock:^(NSNumber *level, NSString *label, BOOL *stop) {
        LogMessage *message = [[LogMessage alloc] init];

        message.level = [level integerValue];

        XCTAssertEqualObjects([component stringFromLogMessage:message], label);
    }];
}

- (void)testStringFromUnrecognizedLevel
{
    LogMessage *message = [[LogMessage alloc] init];

    message.level = -9999;

    K9LogPatternLevelComponent *component = [[K9LogPatternLevelComponent alloc] init];

    XCTAssertNoThrow([component stringFromLogMessage:message]);
}

@end
