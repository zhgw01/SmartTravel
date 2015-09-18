//
//  DateUtilityTC.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/9/6.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DateUtility.h"

@interface DateUtilityTC : XCTestCase

@end

@implementation DateUtilityTC

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testIsDateMatched1 {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:@"2015-09-07 07:33:22"];
    BOOL actual = [DateUtility isDateMatched:date
                                       month:@"111111111111"
                                   startTime:@"16:00"
                                     endTime:@"19:00"];
    XCTAssertFalse(actual);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
