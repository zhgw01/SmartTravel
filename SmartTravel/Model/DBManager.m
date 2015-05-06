//
//  DBManager.m
//  SmartTravel
//
//  Created by Gongwei on 15/5/2.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <FMDB/FMDB.h>
#import "DBManager.h"
#import "Collision.h"
#import "VRU.h"

// TODO: Currently, data in smartTravelDb are for test purpose.
// Please refill real data into smartTravelDb
static NSString * const kDbName = @"smartTravelDb";

static NSString * const kCollisionsQuerySmt = @"select * from Collision";
static NSString * const kVRUsQuerySmt = @"select * from VRU";

@interface DBManager()

@property (nonatomic, strong) FMDatabase* db;

@end

@implementation DBManager

+ (DBManager *)sharedInstance
{
    static DBManager *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void) {
        sharedSingleton = [[self alloc] init];
    });
    return sharedSingleton;
}

- (instancetype)init
{
    if (self = [super init])
    {
        NSString* dbPath = [[NSBundle mainBundle] pathForResource:kDbName ofType:@"sqlite"];
        if([[NSFileManager defaultManager] fileExistsAtPath:dbPath])
        {
            self.db = [FMDatabase databaseWithPath:dbPath];
        }
    }
    return self;
}

-(NSArray*)selectAllCollisions
{
    NSMutableArray* collisions = [[NSMutableArray alloc] init];

    BOOL res = [self.db open];
    NSAssert(res, @"Open db failed");
    
    FMResultSet *resultSet = [self.db executeQuery:kCollisionsQuerySmt];
    NSError *error = nil;
    while ([resultSet next])
    {
        Collision *collision = [MTLFMDBAdapter modelOfClass:Collision.class fromFMResultSet:resultSet error:&error];
        NSAssert(collision, @"Collsion should be non nil");
        [collisions addObject:collision];
    }
    
    res = [self.db close];
    NSAssert(res, @"Close db failed");
    
    return [collisions copy];
}

-(NSArray*)selectAllVRUs
{
    NSMutableArray* vrus = [[NSMutableArray alloc] init];
    
    BOOL res = [self.db open];
    NSAssert(res, @"Open db failed");
    
    FMResultSet *resultSet = [self.db executeQuery:kVRUsQuerySmt];
    NSError *error = nil;
    while ([resultSet next])
    {
        VRU *vru = [MTLFMDBAdapter modelOfClass:VRU.class fromFMResultSet:resultSet error:&error];
        NSAssert(vru, @"VRU should be non nil");
        [vrus addObject:vru];
    }
    
    res = [self.db close];
    NSAssert(res, @"Close db failed");
    
    return [vrus copy];
}

@end
