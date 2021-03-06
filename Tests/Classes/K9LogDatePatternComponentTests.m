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

- (NSDate *)dateByParsingISO8601String:(NSString *)dateString
                 appendingTimeInterval:(NSTimeInterval)timeInterval
                              timeZone:(NSTimeZone *)timeZone
{
    NSDateFormatter *formatter = [self ISO8601DateFormatterWithTimeZone:timeZone];
    NSDate          *date      = [formatter dateFromString:dateString];

    if (timeInterval != 0.0) {
        date = [date dateByAddingTimeInterval:timeInterval];
    }

    return date;
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
    {
        K9LogPatternDateComponent *component = [[K9LogPatternDateComponent alloc] initWithParameters:@[ @"ISO8601" ]];

        XCTAssertEqualObjects(component.nameOrFormat, @"ISO8601");
    }
    {
        K9LogPatternDateComponent *component = [[K9LogPatternDateComponent alloc] initWithParameters:@[ @"ISO8601_BASIC" ]];

        XCTAssertEqualObjects(component.nameOrFormat, @"ISO8601_BASIC");
    }
    {
        K9LogPatternDateComponent *component = [[K9LogPatternDateComponent alloc] initWithParameters:@[ @"yyyy" ]];

        XCTAssertEqualObjects(component.nameOrFormat, @"yyyy");
    }
}

- (void)testISO8601
{
    K9LogPatternDateComponent *component = [[K9LogPatternDateComponent alloc] initWithNameOrFormat:@"ISO8601"];

    [self validateISO8601FormatWithComponent:component];
}

- (void)testISO8601_BASIC
{
    K9LogPatternDateComponent *component = [[K9LogPatternDateComponent alloc] initWithNameOrFormat:@"ISO8601_BASIC"];

    LogMessage *message = [[LogMessage alloc] init];

    message.timestamp = [self dateByParsingISO8601String:@"2014-02-01 01:20:30"
                                   appendingTimeInterval:0.5
                                                timeZone:component.timeZone];

    XCTAssertEqualObjects([component stringFromLogMessage:message],
                          @"20140201 012030,500",
                          @"ISO8601_BASIC");
}

- (void)testABSOLUTE
{
    K9LogPatternDateComponent *component = [[K9LogPatternDateComponent alloc] initWithNameOrFormat:@"ABSOLUTE"];

    LogMessage *message = [[LogMessage alloc] init];

    message.timestamp = [self dateByParsingISO8601String:@"2014-02-01 01:20:30"
                                   appendingTimeInterval:0.5
                                                timeZone:component.timeZone];

    XCTAssertEqualObjects([component stringFromLogMessage:message],
                          @"012030,500",
                          @"ABSOLUTE");
}

- (void)testDATE
{
    K9LogPatternDateComponent *component = [[K9LogPatternDateComponent alloc] initWithNameOrFormat:@"DATE"];

    LogMessage *message = [[LogMessage alloc] init];

    message.timestamp = [self dateByParsingISO8601String:@"2012-11-02 14:34:02"
                                   appendingTimeInterval:0.781
                                                timeZone:component.timeZone];

    XCTAssertEqualObjects([component stringFromLogMessage:message],
                          @"02 Nov 2012 14:34:02,781",
                          @"DATE");
}

- (void)testCOMPACT
{
    K9LogPatternDateComponent *component = [[K9LogPatternDateComponent alloc] initWithNameOrFormat:@"COMPACT"];

    LogMessage *message = [[LogMessage alloc] init];

    message.timestamp = [self dateByParsingISO8601String:@"2012-11-02 14:34:02"
                                   appendingTimeInterval:0.781
                                                timeZone:component.timeZone];

    XCTAssertEqualObjects([component stringFromLogMessage:message],
                          @"20121102143402781",
                          @"COMPACT");
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
