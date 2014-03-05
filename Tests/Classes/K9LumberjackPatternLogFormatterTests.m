#import <XCTest/XCTest.h>
#import "K9LogLumberjackPatternFormatter.h"
#import "K9LogPatternParser.h"

@interface K9LogLumberjackPatternFormatterTests : XCTestCase

@end

@interface K9LogLumberjackPatternFormatterTests (DDLogMessageAssertion)

- (void)assertFormattedLogWithPattern:(NSString *)pattern
                              message:(NSString *)message
                                 flag:(int)flag
                            timestamp:(NSDate *)timestamp
                      expectedMessage:(NSString *)format
                            arguments:(va_list)arguments;

- (void)assertFormattedLogWithPattern:(NSString *)pattern
                              message:(NSString *)message
                                 flag:(int)flag
                      expectedMessage:(NSString *)format, ...;

- (void)assertFormattedLogWithPattern:(NSString *)pattern
                              message:(NSString *)message
                      expectedMessage:(NSString *)expectedMessage, ...;

- (void)assertFormattedLogWithPattern:(NSString *)pattern
                              message:(NSString *)message
                            timestamp:(NSDate *)timestamp
                      expectedMessage:(NSString *)expectedMessage, ...;

@end

@implementation K9LogLumberjackPatternFormatterTests

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
    [self assertFormattedLogWithPattern:@""
                                message:@""
                        expectedMessage:@""];

    [self assertFormattedLogWithPattern:@""
                                message:@"Hi"
                        expectedMessage:@""];
}

- (void)testFormatLogMessage_message
{
    [self assertFormattedLogWithPattern:@"%m"
                                message:@""
                        expectedMessage:@""];

    [self assertFormattedLogWithPattern:@"%m"
                                message:@"Hi"
                        expectedMessage:@"Hi"];

    [self assertFormattedLogWithPattern:@"Hello, %m!"
                                message:@"World"
                        expectedMessage:@"Hello, World!"];
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
        [self assertFormattedLogWithPattern:@"[%p] %m"
                                    message:@"MESSAGE"
                                       flag:[flag intValue]
                            expectedMessage:@"[%@] MESSAGE", label];
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

        [self assertFormattedLogWithPattern:@"%d"
                                    message:@""
                                  timestamp:date
                            expectedMessage:@"2014-03-01 10:20:30,000"];
    }

    // %d
    {
        NSDate *date = [formatter dateFromString:@"2014-03-01 10:20:30"];

        [self assertFormattedLogWithPattern:@"%d{yyyy}"
                                    message:@""
                                  timestamp:date
                            expectedMessage:@"2014"];
    }
}

- (void)testFormatLogMessage_formatModifier
{
    // Zero
    {
        [self assertFormattedLogWithPattern:@"%-0m"
                                    message:@"Message"
                            expectedMessage:@"Message"];

        [self assertFormattedLogWithPattern:@"%0m"
                                    message:@"Message"
                            expectedMessage:@"Message"];

        [self assertFormattedLogWithPattern:@"%-0.0m"
                                    message:@"Message"
                            expectedMessage:@""];
        [self assertFormattedLogWithPattern:@"%0.0m"
                                    message:@"Message"
                            expectedMessage:@""];

        [self assertFormattedLogWithPattern:@"%.0m"
                                    message:@"Message"
                            expectedMessage:@""];
    }

    // %-5p
    {
        [self assertFormattedLogWithPattern:@"%-5p %m"
                                    message:@"Message"
                                       flag:LOG_FLAG_DEBUG
                            expectedMessage:@"DEBUG Message"];
        [self assertFormattedLogWithPattern:@"%-5p %m"
                                    message:@"Message"
                                       flag:LOG_FLAG_WARN
                            expectedMessage:@"WARN  Message"];
    }

    // Blank message
    {
        [self assertFormattedLogWithPattern:@"%5m"
                                    message:@""
                            expectedMessage:@"     "];
        [self assertFormattedLogWithPattern:@"%-5m"
                                    message:@""
                            expectedMessage:@"     "];
        [self assertFormattedLogWithPattern:@"%-5m"
                                    message:@" "
                            expectedMessage:@"     "];
        [self assertFormattedLogWithPattern:@"%5m"
                                    message:@" "
                            expectedMessage:@"     "];
    }

    // Min and Max
    {
        [self assertFormattedLogWithPattern:@"%5.10m"
                                    message:@""
                            expectedMessage:@"     "];
        [self assertFormattedLogWithPattern:@"%5.10m"
                                    message:@"A"
                            expectedMessage:@"    A"];
        [self assertFormattedLogWithPattern:@"%-5.10m"
                                    message:@"A"
                            expectedMessage:@"A    "];
        [self assertFormattedLogWithPattern:@"%-5.10m"
                                    message:@"0123456789"
                            expectedMessage:@"0123456789"];
        [self assertFormattedLogWithPattern:@"%-5.10m"
                                    message:@"0123456789A"
                            expectedMessage:@"0123456789"];
    }
}

@end


@implementation K9LogLumberjackPatternFormatterTests (DDLogMessageAssertion)

- (void)assertFormattedLogWithPattern:(NSString *)pattern
                              message:(NSString *)message
                                 flag:(int)flag
                            timestamp:(NSDate *)timestamp
                      expectedMessage:(NSString *)format
                            arguments:(va_list)arguments
{
    K9LogLumberjackPatternFormatter *formatter = [[K9LogLumberjackPatternFormatter alloc] initWithPattern:pattern error:NULL];

    DDLogMessage *logMessage = [[DDLogMessage alloc] initWithLogMsg:message
                                                              level:LOG_LEVEL_VERBOSE
                                                               flag:flag
                                                            context:0
                                                               file:__FILE__
                                                           function:__PRETTY_FUNCTION__
                                                               line:__LINE__
                                                                tag:nil
                                                            options:0];

    if (timestamp) {
        logMessage->timestamp = timestamp;
    }

    NSString *expectedMessage = [[NSString alloc] initWithFormat:format
                                                       arguments:arguments];

    XCTAssertEqualObjects([formatter formatLogMessage:logMessage],
                          expectedMessage,
                          @"Given \"%@\" with format \"%@\"",
                          message,
                          pattern);
}

- (void)assertFormattedLogWithPattern:(NSString *)pattern
                              message:(NSString *)message
                                 flag:(int)flag
                      expectedMessage:(NSString *)format, ...
{
    va_list arguments;

    va_start(arguments, format);

    [self assertFormattedLogWithPattern:pattern
                                message:message
                                   flag:flag
                              timestamp:nil
                        expectedMessage:format
                              arguments:arguments];
    va_end(arguments);
}

- (void)assertFormattedLogWithPattern:(NSString *)pattern
                              message:(NSString *)message
                      expectedMessage:(NSString *)format, ...
{
    va_list arguments;

    va_start(arguments, format);

    [self assertFormattedLogWithPattern:pattern
                                message:message
                                   flag:LOG_FLAG_VERBOSE
                              timestamp:nil
                        expectedMessage:format
                              arguments:arguments];
    va_end(arguments);
}

- (void)assertFormattedLogWithPattern:(NSString *)pattern
                              message:(NSString *)message
                            timestamp:(NSDate *)timestamp
                      expectedMessage:(NSString *)format, ...
{
    va_list arguments;

    va_start(arguments, format);

    [self assertFormattedLogWithPattern:pattern
                                message:message
                                   flag:LOG_FLAG_VERBOSE
                              timestamp:timestamp
                        expectedMessage:format
                              arguments:arguments];
    va_end(arguments);
}

@end
