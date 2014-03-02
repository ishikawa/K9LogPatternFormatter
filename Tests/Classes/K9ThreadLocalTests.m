#import <XCTest/XCTest.h>
#import "K9ThreadLocal+Private.h"

@interface K9ThreadLocalTests : XCTestCase

@end

@implementation K9ThreadLocalTests

- (void)testInit
{
    K9ThreadLocal *local = [[K9ThreadLocal alloc] init];

    XCTAssertNil(local.value);
}

- (void)testSet
{
    K9ThreadLocal *local = [[K9ThreadLocal alloc] init];

    local.value = @1;
    XCTAssertEqualObjects(local.value, @1);

    local.value = @2;
    XCTAssertEqualObjects(local.value, @2);

    local.value = nil;
    XCTAssertEqualObjects(local.value, nil);
}

- (void)testMultipleInstances
{
    K9ThreadLocal *local1 = [[K9ThreadLocal alloc] init];
    K9ThreadLocal *local2 = [[K9ThreadLocal alloc] init];

    local1.value = @1;
    local2.value = @2;

    XCTAssertEqualObjects(local1.value, @1);
    XCTAssertEqualObjects(local2.value, @2);

    local1.value = nil;
    XCTAssertEqualObjects(local2.value, @2, @"local2 should not be affected");
}

- (void)testBackingStorage
{
    NSDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];

    id key = nil;

    @autoreleasepool {
        K9ThreadLocal *local = [[K9ThreadLocal alloc] init];

        key = [local.uniqueKey copy];

        XCTAssertNil(threadDictionary[key]);

        local.value = @1;

        XCTAssertEqualObjects(threadDictionary[key], @1);
    }

    XCTAssertNil(threadDictionary[key], @"Value in TLS should be released");
}

@end
