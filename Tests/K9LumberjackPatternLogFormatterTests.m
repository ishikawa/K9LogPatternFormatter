#import <XCTest/XCTest.h>
#import "K9LumberjackPatternLogFormatter.h"

@interface K9LumberjackPatternLogFormatterTests : XCTestCase

@end

@implementation K9LumberjackPatternLogFormatterTests

#pragma mark - Initialization

- (void)testInit
{
    K9LumberjackPatternLogFormatter *formatter = [[K9LumberjackPatternLogFormatter alloc] init];

    XCTAssertTrue([formatter isKindOfClass:[K9LumberjackPatternLogFormatter class]]);
    XCTAssertNotNil(formatter.pattern);
}

- (void)testInitWithPattern
{
    // Given none empty pattern string
    {
        NSString *pattern = @"%m";
        K9LumberjackPatternLogFormatter *formatter = [[K9LumberjackPatternLogFormatter alloc] initWithPattern:pattern];

        XCTAssertTrue([formatter isKindOfClass:[K9LumberjackPatternLogFormatter class]]);
        XCTAssertEqualObjects(formatter.pattern, pattern);
    }

    // Given nil
    {
        XCTAssertThrowsSpecificNamed([[K9LumberjackPatternLogFormatter alloc] initWithPattern:nil],
                                     NSException,
                                     NSInvalidArgumentException);
    }
}

@end
