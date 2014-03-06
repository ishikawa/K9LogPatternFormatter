#import <XCTest/XCTest.h>
#import "K9LogLumberjackPatternFormatter.h"
#import "K9LogPatternParser.h"

@interface K9LogLumberjackPatternFormatterTests : XCTestCase

@end

@implementation K9LogLumberjackPatternFormatterTests

#pragma mark - Formatting Helpers

- (NSString *)formatLogMessageWithPattern:(NSString *)pattern
                                     file:(NSString *)file
                                     line:(int)line
{
    return [self formatLogMessageWithPattern:pattern
                                     message:@""
                                        flag:LOG_FLAG_VERBOSE
                                        file:file
                                        line:line
                                   timestamp:[NSDate date]];
}

- (NSString *)formatLogMessageWithPattern:(NSString *)pattern
                                  message:(NSString *)message
{
    return [self formatLogMessageWithPattern:pattern
                                     message:message
                                        flag:LOG_FLAG_VERBOSE
                                        file:@"test.m"
                                        line:1
                                   timestamp:[NSDate date]];
}

- (NSString *)formatLogMessageWithPattern:(NSString *)pattern
                                  message:(NSString *)message
                                     flag:(int)flag
{
    return [self formatLogMessageWithPattern:pattern
                                     message:message
                                        flag:flag
                                        file:@"test.m"
                                        line:1
                                   timestamp:[NSDate date]];
}

- (NSString *)formatLogMessageWithPattern:(NSString *)pattern
                                timestamp:(NSDate *)timestamp
{
    return [self formatLogMessageWithPattern:pattern
                                     message:@""
                                        flag:LOG_FLAG_VERBOSE
                                        file:@"test.m"
                                        line:1
                                   timestamp:timestamp];
}

- (NSString *)formatLogMessageWithPattern:(NSString *)pattern
                                  message:(NSString *)message
                                     flag:(int)flag
                                     file:(NSString *)file
                                     line:(int)line
                                timestamp:(NSDate *)timestamp
{
    K9LogLumberjackPatternFormatter *formatter = [[K9LogLumberjackPatternFormatter alloc] initWithPattern:pattern error:NULL];

    XCTAssertNotNil(formatter, @"formatter for %@", pattern);

    DDLogMessage *logMessage = [[DDLogMessage alloc] initWithLogMsg:message
                                                              level:LOG_LEVEL_VERBOSE
                                                               flag:flag
                                                            context:0
                                                               file:[file UTF8String]
                                                           function:__PRETTY_FUNCTION__
                                                               line:line
                                                                tag:nil
                                                            options:0];

    if (timestamp) {
        logMessage->timestamp = timestamp;
    }

    return [formatter formatLogMessage:logMessage];
}

#pragma mark Initialization

- (void)testInit
{
    K9LogLumberjackPatternFormatter *formatter = [[K9LogLumberjackPatternFormatter alloc] init];

    XCTAssertTrue([formatter isKindOfClass:[K9LogLumberjackPatternFormatter class]]);
    XCTAssertNotNil(formatter.pattern);
}

- (void)testInitWithPattern
{
    // Given none empty pattern string
    {
        NSString *pattern = @"%m";
        K9LogLumberjackPatternFormatter *formatter = [[K9LogLumberjackPatternFormatter alloc] initWithPattern:pattern error:NULL];

        XCTAssertTrue([formatter isKindOfClass:[K9LogLumberjackPatternFormatter class]]);
        XCTAssertEqualObjects(formatter.pattern, pattern);
    }

    // Given nil
    {
        XCTAssertThrowsSpecificNamed([[K9LogLumberjackPatternFormatter alloc] initWithPattern:nil error:NULL],
                                     NSException,
                                     NSInvalidArgumentException);
    }
}

#pragma mark Formatting

- (void)testFormatLogMessageWithIllegalPattern
{
    // "%"
    {
        NSError *error = nil;

        K9LogLumberjackPatternFormatter *formatter = [[K9LogLumberjackPatternFormatter alloc] initWithPattern:@"%"
                                                                                                        error:&error];

        XCTAssertNil(formatter);
        XCTAssertNotNil(error);
        XCTAssertEqualObjects(error.domain, K9LogPatternParserErrorDomain);
        XCTAssertEqual(error.code, K9LogPatternParserUnrecognizedPatternError);
    }

    // Unrecognized specifier
    {
        NSError *error = nil;

        K9LogLumberjackPatternFormatter *formatter = [[K9LogLumberjackPatternFormatter alloc] initWithPattern:@"%~"
                                                                                                        error:&error];

        XCTAssertNil(formatter);
        XCTAssertNotNil(error);
        XCTAssertEqualObjects(error.domain, K9LogPatternParserErrorDomain);
        XCTAssertEqual(error.code, K9LogPatternParserUnrecognizedPatternError);
    }
}

- (void)testFormatLogMessage_empty
{
    {
        NSString *text = [self formatLogMessageWithPattern:@""
                                                   message:@""];
        XCTAssertEqualObjects(text, @"");
    }

    {
        NSString *text = [self formatLogMessageWithPattern:@""
                                                   message:@"Hi"];
        XCTAssertEqualObjects(text, @"");
    }
}

- (void)testFormatLogMessage_message
{
    {
        NSString *text = [self formatLogMessageWithPattern:@"%m"
                                                   message:@""];
        XCTAssertEqualObjects(text, @"");
    }

    {
        NSString *text = [self formatLogMessageWithPattern:@"%m"
                                                   message:@"Hi"];
        XCTAssertEqualObjects(text, @"Hi");
    }

    {
        NSString *text = [self formatLogMessageWithPattern:@"Hello, %m!"
                                                   message:@"World"];
        XCTAssertEqualObjects(text, @"Hello, World!");
    }
}

- (void)testFormatLogMessage_logLevel
{
    NSDictionary *stringByLevel = @{
                                    @(LOG_FLAG_VERBOSE): @"VERBOSE",
                                    @(LOG_FLAG_DEBUG):   @"DEBUG",
                                    @(LOG_FLAG_INFO):    @"INFO",
                                    @(LOG_FLAG_WARN):    @"WARN",
                                    @(LOG_FLAG_ERROR):   @"ERROR",
                                    @(1000):             @"CUSTOM",
                                    };

    [stringByLevel enumerateKeysAndObjectsUsingBlock:^(NSNumber *flag, NSString *label, BOOL *stop) {
        NSString *text = [self formatLogMessageWithPattern:@"[%p] %m"
                                                   message:@"MESSAGE"
                                                      flag:[flag intValue]];
        NSString *expectation = [NSString stringWithFormat:@"[%@] MESSAGE", label];
        XCTAssertEqualObjects(text, expectation);
    }];
}

- (void)testFormatLogMessage_date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    formatter.locale     = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.timeZone   = [NSTimeZone systemTimeZone];
    formatter.dateFormat = @"yyyy'-'MM'-'dd' 'HH':'mm':'ss";

    // %d
    {
        NSDate *date = [formatter dateFromString:@"2014-03-01 10:20:30"];

        NSString *text = [self formatLogMessageWithPattern:@"%d"
                                                 timestamp:date];

        XCTAssertEqualObjects(text, @"2014-03-01 10:20:30,000");
    }

    // %d
    {
        NSDate *date = [formatter dateFromString:@"2014-03-01 10:20:30"];

        NSString *text = [self formatLogMessageWithPattern:@"%d{yyyy}"
                                                 timestamp:date];

        XCTAssertEqualObjects(text, @"2014");
    }
}

- (void)testFormatLogMessage_fileAndLineNumber
{
    {
        NSString *message = [self formatLogMessageWithPattern:@"%l"
                                                         file:@"Classes/Foo.m"
                                                         line:1];
        XCTAssertEqualObjects(message, @"Classes/Foo.m");
    }

    {
        NSString *message = [self formatLogMessageWithPattern:@"%F"
                                                         file:@"Classes/Foo.m"
                                                         line:1];
        XCTAssertEqualObjects(message, @"Foo");
    }

    {
        NSString *message = [self formatLogMessageWithPattern:@"%L"
                                                         file:@"Classes/Foo.m"
                                                         line:10];
        XCTAssertEqualObjects(message, @"10");
    }

    {
        NSString *message = [self formatLogMessageWithPattern:@"%F:%L"
                                                         file:@"Classes/Bar.m"
                                                         line:15];
        XCTAssertEqualObjects(message, @"Bar:15");
    }
}

- (void)testFormatLogMessage_formatModifier
{
    // Zero
    {
        {
            NSString *text = [self formatLogMessageWithPattern:@"%-0m"
                                                       message:@"Message"];
            XCTAssertEqualObjects(text, @"Message");
        }
        {
            NSString *text = [self formatLogMessageWithPattern:@"%0m"
                                                       message:@"Message"];
            XCTAssertEqualObjects(text, @"Message");
        }
        {
            NSString *text = [self formatLogMessageWithPattern:@"%-0.0m"
                                                       message:@"Message"];
            XCTAssertEqualObjects(text, @"");
        }
        {
            NSString *text = [self formatLogMessageWithPattern:@"%0.0m"
                                                       message:@"Message"];
            XCTAssertEqualObjects(text, @"");
        }
        {
            NSString *text = [self formatLogMessageWithPattern:@"%.0m"
                                                       message:@"Message"];
            XCTAssertEqualObjects(text, @"");
        }
    }

    // %-5p
    {
        {
            NSString *text = [self formatLogMessageWithPattern:@"%-5p %m"
                                                       message:@"Message"
                                                          flag:LOG_FLAG_DEBUG];
            XCTAssertEqualObjects(text, @"DEBUG Message");
        }
        {
            NSString *text = [self formatLogMessageWithPattern:@"%-5p %m"
                                                       message:@"Message"
                                                          flag:LOG_FLAG_WARN];
            XCTAssertEqualObjects(text, @"WARN  Message");
        }
    }

    // Blank message
    {
        {
            NSString *text = [self formatLogMessageWithPattern:@"%5m"
                                                       message:@""];
            XCTAssertEqualObjects(text, @"     ");
        }
        {
            NSString *text = [self formatLogMessageWithPattern:@"%-5m"
                                                       message:@""];
            XCTAssertEqualObjects(text, @"     ");
        }
        {
            NSString *text = [self formatLogMessageWithPattern:@"%5m"
                                                       message:@" "];
            XCTAssertEqualObjects(text, @"     ");
        }
    }

    // Min and Max
    {
        {
            NSString *text = [self formatLogMessageWithPattern:@"%5.10m"
                                                       message:@""];
            XCTAssertEqualObjects(text, @"     ");
        }
        {
            NSString *text = [self formatLogMessageWithPattern:@"%5.10m"
                                                       message:@"A"];
            XCTAssertEqualObjects(text, @"    A");
        }
        {
            NSString *text = [self formatLogMessageWithPattern:@"%-5.10m"
                                                       message:@"A"];
            XCTAssertEqualObjects(text, @"A    ");
        }
        {
            NSString *text = [self formatLogMessageWithPattern:@"%-5.10m"
                                                       message:@"0123456789"];
            XCTAssertEqualObjects(text, @"0123456789");
        }
        {
            NSString *text = [self formatLogMessageWithPattern:@"%-5.10m"
                                                       message:@"0123456789A"];
            XCTAssertEqualObjects(text, @"0123456789");
        }
    }
}

@end
