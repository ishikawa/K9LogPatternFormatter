#import <XCTest/XCTest.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "K9LogLumberjackPatternFormatter.h"

static const DDLogLevel ddLogLevel = DDLogLevelWarning;

@interface CocoaLumberjackTests : XCTestCase

@end

@implementation CocoaLumberjackTests

- (void)testLogger {
    id<DDLogger> consoleLogger = [DDTTYLogger sharedInstance];

    consoleLogger.logFormatter = [[K9LogLumberjackPatternFormatter alloc] initWithPattern:@"%.1p: %m"];

    [DDLog addLogger:consoleLogger];

    DDLogVerbose(@"OK");
}

@end
