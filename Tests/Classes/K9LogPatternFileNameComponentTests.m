#import <XCTest/XCTest.h>
#import "LogMessage.h"
#import "K9LogPatternComponent.h"
#import "K9LogPatternFileNameComponent.h"

@interface K9LogPatternFileNameComponentTests : XCTestCase

@end

@implementation K9LogPatternFileNameComponentTests

- (void)testStringFromEmpty
{
    K9LogPatternFileNameComponent *component = [[K9LogPatternFileNameComponent alloc] init];

    LogMessage *message = [[LogMessage alloc] init];
    message.filePath = @"";

    XCTAssertEqualObjects([component stringFromLogMessage:message], @"");
}

- (NSString *)formatWithFilePath:(NSString *)filePath
{
    K9LogPatternFileNameComponent *component = [[K9LogPatternFileNameComponent alloc] init];
    LogMessage *message = [[LogMessage alloc] init];

    message.filePath = filePath;

    return [component stringFromLogMessage:message];
}

#define AssertFormatToBeEmpty(filePath) XCTAssertEqualObjects([self formatWithFilePath:(filePath)], @"");

- (void)testFormatExpectToBeEmpty
{
    AssertFormatToBeEmpty(@"");
    AssertFormatToBeEmpty(@".m");
    AssertFormatToBeEmpty(@".");
    AssertFormatToBeEmpty(@"..");
    AssertFormatToBeEmpty(@"/");
    AssertFormatToBeEmpty(@"//");
    AssertFormatToBeEmpty(@"./");
    AssertFormatToBeEmpty(@"./../");
    AssertFormatToBeEmpty(@".././");
    AssertFormatToBeEmpty(@"../../");
    AssertFormatToBeEmpty(@"file:///");
    AssertFormatToBeEmpty(@"file:///../.");
}

#define AssertFormatToBeFileName(filePath, fileName) XCTAssertEqualObjects([self formatWithFilePath:(filePath)], (fileName));

- (void)testStringFromFilePath
{
    AssertFormatToBeFileName(@"Test", @"Test");
    AssertFormatToBeFileName(@"Test.m", @"Test");
    AssertFormatToBeFileName(@"Classes/Test.m", @"Test");
    AssertFormatToBeFileName(@"/Classes/Test.m", @"Test");
    AssertFormatToBeFileName(@"./Classes/Test.m", @"Test");
    AssertFormatToBeFileName(@"./Classes/Test", @"Test");
    AssertFormatToBeFileName(@"./../Classes/Test.m", @"Test");
    AssertFormatToBeFileName(@"./../Classes/Test", @"Test");
    AssertFormatToBeFileName(@"./../Classes/../Test.m", @"Test");
    AssertFormatToBeFileName(@"./../Classes/../Test", @"Test");
    AssertFormatToBeFileName(@"file:///Workspace/Classes/Test.m", @"Test");
}

@end
