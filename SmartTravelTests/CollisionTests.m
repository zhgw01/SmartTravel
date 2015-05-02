//
//  CollisionTests.m
//  SmartTravel
//
//  Created by Gongwei on 15/5/2.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <FMDB/FMDB.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>
#import <Mantle/Mantle.h>
#import "Collision.h"

@interface CollisionTests : XCTestCase
@property (nonatomic, strong) FMDatabase* db;
@end

@implementation CollisionTests

- (void)setUp {
    [super setUp];
    
    NSBundle *testBundle = [NSBundle bundleForClass:self.class];
    NSString *dbFile = [testBundle pathForResource:@"testDb" ofType:@"sqlite"];
    XCTAssertNotNil(dbFile);
    
    self.db = [FMDatabase databaseWithPath:dbFile];
    XCTAssertNotNil(self.db);
    if (![self.db open]) {
        XCTFail(@"Cannot open the sqlite database");
    }
}

- (void)tearDown {
    [self.db close];
    [super tearDown];
}

- (void)testReadModel {

    
    NSError *error = nil;

    FMResultSet *resultSet = [self.db executeQuery:@"select * from Collision"];
    if ([resultSet next]) {
        Collision *collision = [MTLFMDBAdapter modelOfClass:Collision.class fromFMResultSet:resultSet error:&error];
        XCTAssertNotNil(collision);
    }
}

- (void)testWriteModel {
    
    Collision *collision = [[Collision alloc] init];
    collision.locationCode = @"test-location-code";
    collision.location = @"test-location";
    collision.count = @1;
    collision.latitude =@100.0;
    collision.longtitude = @100.0;
    
    NSString *stmt = [MTLFMDBAdapter insertStatementForModel:collision];
    NSArray *param = [MTLFMDBAdapter columnValues:collision];
    BOOL result = [self.db executeUpdate:stmt withArgumentsInArray:param];
    XCTAssertTrue(result);
}

@end
