#import <XCTest/XCTest.h>
#import "LogMessage.h"
#import "K9LogPatternDateComponent.h"

@interface K9LogDatePatternComponentTests : XCTestCase

@end

@implementation K9LogDatePatternComponentTests

- (NSDateFormatter *)ISO8601DateFormatterWithTimeZone:(NSTimeZone *)timeZone
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    formatter.locale     = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.timeZone   = timeZone;
    formatter.dateFormat = @"yyyy'-'MM'-'dd' 'HH':'mm':'ss";

    return formatter;
}

- (void)validateISO8601FormatWithComponent:(K9LogPatternDateComponent *)component
{
    NSDateFormatter *formatter = [self ISO8601DateFormatterWithTimeZone:component.timeZone];

    LogMessage *message = [[LogMessage alloc] init];

    // No ms
    {
        message.timestamp = [formatter dateFromString:@"2014-02-01 01:20:30"];

        XCTAssertEqualObjects([component stringFromLogMessage:message],
                              @"2014-02-01 01:20:30,000",
                              @"ISO8601");
    }

    // With ms
    {
        NSDate *timestamp = [formatter dateFromString:@"2014-02-01 01:20:30"];

        message.timestamp = [timestamp dateByAddingTimeInterval:0.5];

        XCTAssertEqualObjects([component stringFromLogMessage:message],
                              @"2014-02-01 01:20:30,500",
                              @"ISO8601");
    }
}

- (void)testInit
{
    K9LogPatternDateComponent *component = [[K9LogPatternDateComponent alloc] init];

    XCTAssertNil(component.nameOrFormat);
    [self validateISO8601FormatWithComponent:component];
}

- (void)testInitWithParameters
{
    K9LogPatternDateComponent *component = [[K9LogPatternDateComponent alloc] initWithParameters:@[ @"ISO8601" ]];

    XCTAssertEqualObjects(component.nameOrFormat, @"ISO8601");
}

- (void)testISO8601
{
    K9LogPatternDateComponent *component = [[K9LogPatternDateComponent alloc] initWithNameOrFormat:@"ISO8601"];

    XCTAssertEqualObjects(component.nameOrFormat, @"ISO8601");

    [self validateISO8601FormatWithComponent:component];
}

- (void)testISO8601_BASIC
{
    K9LogPatternDateComponent *component = [[K9LogPatternDateComponent alloc] initWithNameOrFormat:@"ISO8601_BASIC"];

    XCTAssertEqualObjects(component.nameOrFormat, @"ISO8601_BASIC");

    NSDateFormatter *formatter = [self ISO8601DateFormatterWithTimeZone:component.timeZone];

    LogMessage *message = [[LogMessage alloc] init];

    NSDate *timestamp = [formatter dateFromString:@"2014-02-01 01:20:30"];

    message.timestamp = [timestamp dateByAddingTimeInterval:0.5];

    XCTAssertEqualObjects([component stringFromLogMessage:message],
                          @"20140201 012030,500",
                          @"ISO8601_BASIC");
}

- (void)testFormatEmpty
{
    LogMessage *message = [[LogMessage alloc] init];

    K9LogPatternDateComponent *component = [[K9LogPatternDateComponent alloc] initWithNameOrFormat:@""];

    XCTAssertEqualObjects([component stringFromLogMessage:message], @"");
}

- (void)testFormat
{
    LogMessage *message = [[LogMessage alloc] init];

    K9LogPatternDateComponent *component = [[K9LogPatternDateComponent alloc] initWithNameOrFormat:@"yyyy"];
    NSDateFormatter *formatter = [self ISO8601DateFormatterWithTimeZone:component.timeZone];

    message.timestamp = [formatter dateFromString:@"2014-02-01 01:20:30"];

    XCTAssertEqualObjects([component stringFromLogMessage:message], @"2014");
}

@end
