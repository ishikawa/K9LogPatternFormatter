#import <XCTest/XCTest.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "K9LogLumberjackPatternFormatter.h"

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

#pragma mark - MemoryLogger

@interface MemoryLogger : NSObject<DDLogger>

@property (nonatomic, strong)   id <DDLogFormatter> logFormatter;
@property (nonatomic, strong) NSString           *lastMessage;

@end

@implementation MemoryLogger

- (void)logMessage:(DDLogMessage *)logMessage
{
    self.lastMessage = [_logFormatter formatLogMessage:logMessage];
}

@end

#pragma mark - CocoaLumberjackTests

@interface CocoaLumberjackTests : XCTestCase

@property (nonatomic) MemoryLogger *memoryLogger;

@end

@implementation CocoaLumberjackTests

- (void)setUp
{
    _memoryLogger = [[MemoryLogger alloc] init];

    [DDLog removeAllLoggers];
    [DDLog addLogger:_memoryLogger];

    [super setUp];
}

- (void)assertLogWithPattern:(NSString *)pattern
                     message:(NSString *)message
                    shouldBe:(NSString *)expectation
{
    _memoryLogger.logFormatter = [[K9LogLumberjackPatternFormatter alloc] initWithPattern:pattern];

    DDLogVerbose(message);
    [DDLog flushLog];

    XCTAssertEqualObjects(_memoryLogger.lastMessage, expectation);
}

- (void)testLogLevelMinLength {
    [self assertLogWithPattern:@"%.1p: %m"
                       message:@"OK"
                      shouldBe:@"V: OK"];
}

- (void)testSinglePercentSign {
    [self assertLogWithPattern:@"%%%m"
                       message:@"OK"
                      shouldBe:@"%OK"];
}

@end
