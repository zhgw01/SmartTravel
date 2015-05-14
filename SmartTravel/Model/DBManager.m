//
//  DBManager.m
//  SmartTravel
//
//  Created by Gongwei on 15/5/2.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "DBManager.h"
#import "TopIntersection.h"
#import "TopMidblock.h"
#import "TopPedestrian.h"
#import "TopCyclist.h"
#import "TopMotorcyclist.h"
#import "HotSpot.h"

// Top locations are stored locally in smartTravelTopLocation.sqlite
static NSString * const kTopLocationDbName = @"smartTravelTopLocation";
// For query collisions
static NSString * const kTopIntersectionQuerySmt = @"select * from Top_Intersection";
static NSString * const kTopMidblockQuerySmt = @"select * from Top_Midblock";
// For query VRUs
static NSString * const kTopPedestrianQuerySmt = @"select * from Top_Pedestrian";
static NSString * const kTopCyclistQuerySmt = @"select * from Top_Cyclist";
static NSString * const kTopMotorcyclistQuerySmt = @"select * from Top_Motorcyclist";

static NSString * const kTemplateDbName = @"smartTravelTemplate";
static NSString * const kMainDbName = @"smartTravel";

NSString * const MAIN_DB_TBL_COLLISION_LOCATION = @"TBL_COLLISION_LOCATION";
NSString * const MAIN_DB_TBL_WM_REASON_CONDITION = @"TBL_WM_REASON_CONDITION";
NSString * const MAIN_DB_TBL_WM_DAYTYPE = @"TBL_WM_DAYTYPE";

@interface DBManager()

@property (readwrite, strong) FMDatabase* topLocationDb;
@property (readwrite, strong) FMDatabase* mainDb;

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
        NSString* userDocumentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        static NSString* dbExt = @"sqlite";

        // Copy TopLocation to user document and initialize
        if ([self copyResourceFromAppBundle:kTopLocationDbName toUserDocumentWithNewName:kTopLocationDbName withExt:dbExt])
        {
            NSString* topLocationDbPath = [[userDocumentDir stringByAppendingPathComponent:kTopLocationDbName] stringByAppendingPathExtension:dbExt];
            self.topLocationDb = [FMDatabase databaseWithPath:topLocationDbPath];
        }
        
        // Copy Main to user document and initialize
        if ([self copyResourceFromAppBundle:kTemplateDbName toUserDocumentWithNewName:kMainDbName withExt:dbExt])
        {
            NSString* mainDbPath = [[userDocumentDir stringByAppendingPathComponent:kMainDbName] stringByAppendingPathExtension:dbExt];
            self.mainDb = [FMDatabase databaseWithPath:mainDbPath];
        }
    }
    return self;
}

// Return YES if copy succeeded or the target file exists
- (BOOL)copyResourceFromAppBundle:(NSString*)oldFileName
        toUserDocumentWithNewName:(NSString*)newFileName
                          withExt:(NSString*)ext
{
    NSString* userDocumentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* targetPath = [[userDocumentDir stringByAppendingPathComponent:newFileName] stringByAppendingPathExtension:ext];

    NSString* sourcePath = [[NSBundle mainBundle] pathForResource:oldFileName ofType:ext];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:sourcePath])
    {
        if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath])
        {
            NSError* error = nil;
            [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:targetPath error:&error];
            return !error;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

-(NSArray*)selectAllCollisions
{
    NSAssert(self.topLocationDb, @"TopLocationDb should exist");
    NSMutableArray* collisions = [[NSMutableArray alloc] init];
    
    BOOL res = [self.topLocationDb open];
    NSAssert(res, @"Open TopLoactionDb failed");
    
    // Select all top intersections
    NSArray* allTopIntersections = [self queryDB:self.topLocationDb withSmt:kTopIntersectionQuerySmt forModelOfClass:[TopIntersection class]];
    for (TopIntersection* intersection in allTopIntersections)
    {
        HotSpot* hotSpot = [[HotSpot alloc] initWithType:HotSpotTypeCollision
                                                     tag:@"Intersection"
                                            locationCode:intersection.locationCode
                                                location:intersection.location
                                                   count:intersection.count
                                                    rank:intersection.rank
                                                latitude:intersection.latitude
                                              longtitude:intersection.longtitude];
        [collisions addObject:hotSpot];
    }
    
    // Select all top midblocks
    NSArray* allTopMidblocks = [self queryDB:self.topLocationDb withSmt:kTopMidblockQuerySmt forModelOfClass:[TopMidblock class]];
    for (TopMidblock* midblock in allTopMidblocks)
    {
        HotSpot* hotSpot = [[HotSpot alloc] initWithType:HotSpotTypeCollision
                                                     tag:@"Midblock"
                                            locationCode:midblock.locationCode
                                                location:midblock.location
                                                   count:midblock.count
                                                    rank:midblock.rank
                                                latitude:midblock.latitude
                                              longtitude:midblock.longtitude];
        [collisions addObject:hotSpot];
    }
    
    res = [self.topLocationDb close];
    NSAssert(res, @"Close TopLocationDb failed");
    
    return [collisions copy];
}

-(NSArray*)selectAllVRUs
{
    NSAssert(self.topLocationDb, @"TopLocationDb should exist");
    NSMutableArray* vrus = [[NSMutableArray alloc] init];
    
    BOOL res = [self.topLocationDb open];
    NSAssert(res, @"Open TopLoactionDb failed");
    
    // Select all top pedestrian
    NSArray* allTopPedestrians = [self queryDB:self.topLocationDb withSmt:kTopPedestrianQuerySmt forModelOfClass:[TopPedestrian class]];
    for (TopPedestrian* pedestrian in allTopPedestrians)
    {
        HotSpot* hotSpot = [[HotSpot alloc] initWithType:HotSpotTypeVRU
                                                     tag:@"Pedestrian"
                                            locationCode:pedestrian.locationCode
                                                location:pedestrian.location
                                                   count:pedestrian.count
                                                    rank:pedestrian.rank
                                                latitude:pedestrian.latitude
                                              longtitude:pedestrian.longtitude];
        [vrus addObject:hotSpot];
    }
    
    // Select all top cyclisit
    NSArray* allTopCyclists = [self queryDB:self.topLocationDb withSmt:kTopCyclistQuerySmt forModelOfClass:[TopCyclist class]];
    for (TopCyclist* cyclist in allTopCyclists)
    {
        HotSpot* hotSpot = [[HotSpot alloc] initWithType:HotSpotTypeVRU
                                                     tag:@"Cyclist"
                                            locationCode:cyclist.locationCode
                                                location:cyclist.location
                                                   count:cyclist.count
                                                    rank:cyclist.rank
                                                latitude:cyclist.latitude
                                              longtitude:cyclist.longtitude];
        [vrus addObject:hotSpot];
    }
    
    // Select all top motorcyclist
    NSArray* allTopMotoryclists = [self queryDB:self.topLocationDb withSmt:kTopMotorcyclistQuerySmt forModelOfClass:[TopMotorcyclist class]];
    for (TopMotorcyclist* motorcyclist in allTopMotoryclists)
    {
        HotSpot* hotSpot = [[HotSpot alloc] initWithType:HotSpotTypeVRU
                                                     tag:@"Motorcyclist"
                                            locationCode:motorcyclist.locationCode
                                                location:motorcyclist.location
                                                   count:motorcyclist.count
                                                    rank:motorcyclist.rank
                                                latitude:motorcyclist.latitude
                                              longtitude:motorcyclist.longtitude];
        [vrus addObject:hotSpot];
    }
    
    res = [self.topLocationDb close];
    NSAssert(res, @"Close TopLocationDb failed");
    
    return [vrus copy];
}

-(NSArray*)queryDB:(FMDatabase*)db
           withSmt:(NSString*)smt
   forModelOfClass:(Class)class
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    NSError *error = nil;
    FMResultSet *resultSet = [db executeQuery:smt];
    while ([resultSet next])
    {
        MTLModel* item = [MTLFMDBAdapter modelOfClass:class fromFMResultSet:resultSet error:&error];
        [array addObject:item];
    }
    return [array copy];
}

@end
