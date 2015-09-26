//
//  LocationArrayParseTC.m
//  SmartTravel
//
//  Created by Yuan Huimin on 15/9/25.
//  Copyright © 2015年 Gongwei. All rights reserved.
//
#import "LocationCoordinate.h"
#import <XCTest/XCTest.h>

@interface LocationArrayParseTC : XCTestCase

@end

@implementation LocationArrayParseTC

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSString *segmentsStr = @"[[-113.44081842600,53.44805739300,-113.44062148200,53.44828551500,-113.44043576800,53.44851838120,-113.44025462700,53.44886229170,-113.44023934700,53.44922268610,-113.44033134000,53.44947530660,-113.44071442100,53.44993267910,-113.44050561500,53.44971197040,-113.44040855700,53.44959624160,-113.44027472700,53.44935037400,-113.44022585400,53.44904216970,-113.44032505600,53.44868655580],[+113.44081842600,-53.44805739300,+113.44062148200,-53.44828551500,+113.44043576800,-53.44851838120,+113.44025462700,-53.44886229170,+113.44023934700,-53.44922268610,+113.44033134000,-53.44947530660,+113.44071442100,-53.44993267910,+113.44050561500,-53.44971197040,+113.44040855700,-53.44959624160,+113.44027472700,-53.44935037400,+113.44022585400,-53.44904216970,+113.44032505600,-53.44868655580]]";
    
    NSArray *segments = [LocationCoordinate parseSegmentsFromString:segmentsStr];
    XCTAssertEqual(segments.count, 2);
    
    // Segment 1
    NSArray *segment1 = [segments objectAtIndex:0];
    XCTAssertEqual(segment1.count, 12);
    
    LocationCoordinate *lc00 = [segment1 objectAtIndex:0];
    XCTAssertEqual(lc00.longitude, -113.44081842600);
    XCTAssertEqual(lc00.latitude, 53.44805739300);
    
    LocationCoordinate *lc011 = [segment1 objectAtIndex:11];
    XCTAssertEqual(lc011.longitude, -113.44032505600);
    XCTAssertEqual(lc011.latitude, 53.44868655580);
    
    // Segment 2
    NSArray *segment2 = [segments objectAtIndex:0];
    XCTAssertEqual(segment2.count, 12);
    
    LocationCoordinate *lc10 = [segment2 objectAtIndex:0];
    XCTAssertEqual(lc10.longitude, -113.44081842600);
    XCTAssertEqual(lc10.latitude, 53.44805739300);
    
    LocationCoordinate *lc111 = [segment2 objectAtIndex:11];
    XCTAssertEqual(lc111.longitude, -113.44032505600);
    XCTAssertEqual(lc111.latitude, 53.44868655580);
}

@end
