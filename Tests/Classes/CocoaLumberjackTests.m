#import <XCTest/XCTest.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "K9LogLumberjackPatternFormatter.h"

static const DDLogLevel ddLogLevel = DDLogLevelWarning;

@interface CocoaLumberjackTests : XCTestCase

@end

@implementation CocoaLumberjackTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    id<DDLogger> consoleLogger = [DDTTYLogger sharedInstance];

    consoleLogger.logFormatter = [[K9LogLumberjackPatternFormatter alloc] initWithPattern:@"%.1p: %m"];

    [DDLog addLogger:consoleLogger];

    DDLogVerbose(@"OK");
}

@end
