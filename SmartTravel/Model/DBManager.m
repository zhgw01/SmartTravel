//
//  DBManager.m
//  SmartTravel
//
//  Created by Gongwei on 15/5/2.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "DBManager.h"
#import "DBConstants.h"
#import "HotSpot.h"

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
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(locationDetected:)
                                                     name:@"ShowTestDataOfShanghai"
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)locationDetected:(id)sender
{
    BOOL showTestDataOfShanghai = [[[sender userInfo] objectForKey:@"ShowTestDataOfShanghai"] boolValue];
    if (!showTestDataOfShanghai)
    {
        NSString* mainDBPath = [DBManager getPathOfMainDB];
        FMDatabase* db = [FMDatabase databaseWithPath:mainDBPath];
        if (![db open])
        {
            NSAssert(NO, @"Open db failed");
            return;
        }
        
        NSString* smt = @"DELETE FROM TBL_COLLISION_LOCATION WHERE longitude>0";
        
        if (![db executeUpdate:smt])
        {
            NSAssert(NO, @"Delete locations of Shanghai failed");
        }
        
        if (![db close])
        {
            NSAssert(NO, @"Close db failed");
        }
    }
}

+(BOOL)deleteFromTable:(NSString*)tableName
{
    if (!tableName) return NO;
    
    NSString* smt = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    
    NSString* mainDBPath = [DBManager getPathOfMainDB];
    FMDatabase* db = [FMDatabase databaseWithPath:mainDBPath];
    if (![db open])
    {
        NSAssert(NO, @"Open db failed");
        return NO;
    }
    
    if (![db executeUpdate:smt])
    {
        NSAssert(NO, @"Delete table failed");
        return NO;
    }
    
    if (![db close])
    {
        NSAssert(NO, @"Close db failed");
        return NO;
    }
    
    return YES;
}

+(BOOL)insertJSON:(id)jsonArrayOrDic
        intoTable:(NSString*)tableName
{
    NSString* mainDBPath = [DBManager getPathOfMainDB];
    FMDatabase* db = [FMDatabase databaseWithPath:mainDBPath];
    if (![db open])
    {
        NSAssert(NO, @"Open db failed");
        return NO;
    }
    
    if ([jsonArrayOrDic isKindOfClass:[NSArray class]])
    {
        NSArray* jsonArray = (NSArray*)jsonArrayOrDic;

        NSUInteger idx = 0;
        for (NSDictionary* dic in jsonArray)
        {
            if ([tableName isEqualToString:MAIN_DB_TBL_COLLISION_LOCATION])
            {
                id location_name = [dic valueForKey:@"location_name"];
                id roadway_portion = [dic valueForKey:@"roadway_portion"];
                if (!roadway_portion)
                {
                    roadway_portion = @"";
                }
                id longitude = [dic valueForKey:@"longitude"];

                id latitude = [dic valueForKey:@"latitude"];

                id loc_code = [dic valueForKey:@"loc_code"];

                
                NSString* sql = [NSString stringWithFormat:@"INSERT INTO %@ (Loc_code, Location_name, Roadway_portion, Latitude, Longitude) VALUES (?, ?, ?, ?, ?)", MAIN_DB_TBL_COLLISION_LOCATION];
                BOOL res = [db executeUpdate:sql, loc_code, location_name, roadway_portion, latitude, longitude];
                if (!res)
                {
                    NSLog(@"Error insert %@ into %@", dic, MAIN_DB_TBL_COLLISION_LOCATION);
                    continue;
                }
            }
            else if ([tableName isEqualToString:MAIN_DB_TBL_LOCATION_REASON])
            {
                id row = [NSNumber numberWithUnsignedInteger:idx];
                id total = [dic valueForKey:@"total"];
                id warning_priority = [dic valueForKey:@"warning_priority"];
                id reason_id = [dic valueForKey:@"reason_id"];
                id loc_code = [dic valueForKey:@"loc_code"];
                id travel_direction = [dic valueForKey:@"travel_direction"];
                if (!travel_direction)
                {
                    travel_direction = @"ALL";
                }
                
                NSString* sql = [NSString stringWithFormat:@"INSERT INTO %@ (Id, Loc_code, Travel_direction, Reason_id, Total, Warning_priority) VALUES (?, ?, ?, ?, ?, ?)", MAIN_DB_TBL_LOCATION_REASON];
                BOOL res = [db executeUpdate:sql, row, loc_code, travel_direction, reason_id, total, warning_priority];
                if (!res)
                {
                    NSLog(@"Error insert %@ into %@", dic, MAIN_DB_TBL_LOCATION_REASON);
                    continue;
                }
            }
            else if ([tableName isEqualToString:MAIN_DB_TBL_WM_DAYTYPE])
            {
                id weekday = [dic valueForKey:@"weekday"];
                id weekend = [dic valueForKey:@"weekend"];
                id date = [dic valueForKey:@"date"];
                id school_day = [dic valueForKey:@"school_day"];
                
                NSString* sql= [NSString stringWithFormat:@"INSERT INTO %@ (Date, Weekday, Weekend, School_day) VALUES (?, ?, ?, ?)", MAIN_DB_TBL_WM_DAYTYPE];
                BOOL res = [db executeUpdate:sql,
                            date,
                            [weekday isEqual:@"TRUE"] ? @1 : @0,
                            [weekend isEqual:@"TRUE"] ? @1 : @0,
                            [school_day isEqual:@"TRUE"] ? @1 : @0];
                if (!res)
                {
                    NSLog(@"Error insert %@ into %@", dic, MAIN_DB_TBL_WM_DAYTYPE);
                    continue;
                }
            }
            else if ([tableName isEqualToString:MAIN_DB_TBL_WM_REASON_CONDITION])
            {
                id warning_message = [dic valueForKey:@"warning_message"];
                id weekday = [dic valueForKey:@"weekday"];
                id reason = [dic valueForKey:@"reason"];
                id reason_id = [dic valueForKey:@"reason_id"];
                id month = [dic valueForKey:@"month"];
                id weekend = [dic valueForKey:@"weekend"];
                id start_time = [dic valueForKey:@"start_time"];
                id end_time = [dic valueForKey:@"end_time"];
                id school_day = [dic valueForKey:@"school_day"];
                
                NSString* sql =[NSString stringWithFormat:@"INSERT INTO %@ (Reason_id, Reason, Month, Weekday, Weekend, School_day, Start_time, End_time, Warning_message) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", MAIN_DB_TBL_WM_REASON_CONDITION];
                BOOL res = [db executeUpdate:sql,
                            reason_id,
                            reason,
                            month,
                            [weekday isEqual:@"TRUE"] ? @1 : @0,
                            [weekend isEqual:@"TRUE"] ? @1 : @0,
                            [school_day isEqual:@"TRUE"] ? @1 : @0,
                            start_time,
                            end_time,
                            warning_message];
                if (!res)
                {
                    NSLog(@"Error insert %@ into %@", dic, MAIN_DB_TBL_WM_REASON_CONDITION);
                    continue;
                }
            }
            else
            {
                NSAssert(NO, @"Not implemented");
            }
            ++idx;
        }
    }
    else if ([jsonArrayOrDic isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* jsonDic = (NSDictionary*)jsonArrayOrDic;
        
        if ([tableName isEqualToString:MAIN_DB_TBL_NEW_VERSION])
        {
            id version = [jsonDic valueForKey:@"version"];
            NSString* sql = [NSString stringWithFormat:@"INSERT INTO %@ (Version) VALUES (?)", MAIN_DB_TBL_NEW_VERSION];
            BOOL res = [db executeUpdate:sql, version];
            if (!res)
            {
                NSLog(@"Error insert %@ into %@", jsonDic, MAIN_DB_TBL_NEW_VERSION);
            }
        }
        else
        {
            NSAssert(NO, @"Not implemented");
        }
    }
    else
    {
        NSLog(@"Error jsonArrayOrDic class: %@", [[jsonArrayOrDic class] description]);
    }
    
    if (![db close])
    {
        NSAssert(NO, @"Close db failed");
        return NO;
    }
    
    return YES;
}

+(NSString*)getPathOfMainDB
{
    NSString* userDocumentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [[userDocumentDir stringByAppendingPathComponent:DB_NAME_MAIN] stringByAppendingPathExtension:DB_EXT];
}

-(NSArray*)selectHotSpots:(HotSpotType)hotSpotType
{
    NSString* mainDBPath = [DBManager getPathOfMainDB];
    FMDatabase* db = [FMDatabase databaseWithPath:mainDBPath];
    if (![db open])
    {
        NSAssert(NO, @"Open db failed");
        return nil;
    }
    
    NSError* error = nil;
    NSMutableArray* res = [[NSMutableArray alloc] init];
    NSString* smt = nil;
    
    if (hotSpotType == HotSpotTypeCnt)
    {
        smt = @"select l.Loc_code, l.Location_name, l.Longitude, l.Latitude, r.Total from TBL_COLLISION_LOCATION as l, TBL_LOCATION_REASON as r where l.Loc_code = r.Loc_code";
    }
    else if (hotSpotType == HotSpotTypeAllExceptSchoolZone)
    {
        smt = [NSString stringWithFormat:@"select l.Loc_code, l.Location_name, l.Longitude, l.Latitude, r.Total from TBL_COLLISION_LOCATION as l, TBL_LOCATION_REASON as r where l.Loc_code = r.Loc_code and (l.Roadway_portion = '%@' or l.Roadway_portion = '%@' or l.Roadway_portion = '%@')", @"INTERSECTION", @"MID STREET", @"MID AVENUE"];
    }
    else
    {
        smt = [NSString stringWithFormat:@"select l.Loc_code, l.Location_name, l.Longitude, l.Latitude, r.Total from TBL_COLLISION_LOCATION as l, TBL_LOCATION_REASON as r where l.Loc_code = r.Loc_code and l.Roadway_portion = '%@'", [HotSpot toString:hotSpotType]];
    }
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    FMResultSet* resultSet = [db executeQuery:smt];
    while ([resultSet nextWithError:&error])
    {
        NSString* locationName = [resultSet stringForColumn:@"Location_name"];
        NSNumber* total = [NSNumber numberWithInt:[resultSet intForColumn:@"Total"]];
        NSNumber* latitude = [NSNumber numberWithDouble:[resultSet doubleForColumn:@"Latitude"]];
        NSNumber* longitude = [NSNumber numberWithDouble:[resultSet doubleForColumn:@"Longitude"]];

        NSString* key = [resultSet stringForColumn:@"Loc_code"];
        
        if ([[dic allKeys] containsObject:key])
        {
            NSMutableDictionary* obj = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:key]];
            NSNumber* totalSum = [obj objectForKey:@"Total"];
            NSNumber* newTotalNum = [NSNumber numberWithInt:[totalSum intValue] + [total intValue]];
            
            [obj setObject:newTotalNum forKey:@"Total"];
            [dic setObject:obj forKey:key];
        }
        else
        {
            NSDictionary* obj = [NSDictionary dictionaryWithObjectsAndKeys:
                                 locationName, @"Location_name",
                                 total, @"Total",
                                 latitude, @"Latitude",
                                 longitude, @"Longitude",
                                 nil];
            [dic setObject:obj forKey:key];
        }
    }
    [resultSet close];
    
    if (![db close])
    {
        NSAssert(NO, @"Close db failed");
    }
    
    // Create hotspot
    for (NSString* locCode in [dic allKeys])
    {
        NSDictionary* hotSpotData = [dic objectForKey:locCode];
        NSString* locationName = [hotSpotData valueForKey:@"Location_name"];
        int count = [((NSNumber*)[hotSpotData objectForKey:@"Total"]) intValue];
        double latitude = [((NSNumber*)[hotSpotData objectForKey:@"Latitude"]) doubleValue];
        double longitude = [((NSNumber*)[hotSpotData objectForKey:@"Longitude"]) doubleValue];
        
        HotSpot* hotSpot = [[HotSpot alloc] initWithLocCode:locCode
                                                   location:locationName
                                                      count:count rank:0
                                                   latitude:latitude
                                                 longtitude:longitude];
        [res addObject:hotSpot];
    }
    
    return [self sortHotSpotsOrderByLocationNameAsc:res];
}

-(NSArray*)selectHotSpotsOfReason:(NSString*)reasonId
{
    NSString* mainDBPath = [DBManager getPathOfMainDB];
    FMDatabase* db = [FMDatabase databaseWithPath:mainDBPath];
    if (![db open])
    {
        NSAssert(NO, @"Open db failed");
        return nil;
    }
    
    NSError* error = nil;
    NSMutableArray* res = [[NSMutableArray alloc] init];
    NSString* smt = [NSString stringWithFormat:@"select l.Loc_code, l.Location_name, l.Roadway_portion, l.Longitude, l.Latitude, r.Total from TBL_COLLISION_LOCATION as l, TBL_LOCATION_REASON as r where l.Loc_code = r.Loc_code and r.Reason_id='%@'", reasonId];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    FMResultSet* resultSet = [db executeQuery:smt];
    while ([resultSet nextWithError:&error])
    {
        NSString* locationName = [resultSet stringForColumn:@"Location_name"];
        NSString* roadwayPortion = [resultSet stringForColumn:@"Roadway_portion"];
        NSNumber* total = [NSNumber numberWithInt:[resultSet intForColumn:@"Total"]];
        NSNumber* latitude = [NSNumber numberWithDouble:[resultSet doubleForColumn:@"Latitude"]];
        NSNumber* longitude = [NSNumber numberWithDouble:[resultSet doubleForColumn:@"Longitude"]];
        
        NSString* key = [resultSet stringForColumn:@"Loc_code"];
        
        if ([[dic allKeys] containsObject:key])
        {
            NSMutableDictionary* obj = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:key]];
            NSNumber* totalSum = [obj objectForKey:@"Total"];
            NSNumber* newTotalNum = [NSNumber numberWithInt:[totalSum intValue] + [total intValue]];
            
            [obj setObject:newTotalNum forKey:@"Total"];
            [dic setObject:obj forKey:key];
        }
        else
        {
            NSDictionary* obj = [NSDictionary dictionaryWithObjectsAndKeys:
                                 locationName, @"Location_name",
                                 roadwayPortion, @"Roadway_portion",
                                 total, @"Total",
                                 latitude, @"Latitude",
                                 longitude, @"Longitude",
                                 nil];
            [dic setObject:obj forKey:key];
        }
    }
    [resultSet close];
    
    if (![db close])
    {
        NSAssert(NO, @"Close db failed");
    }
    
    // Create hotspot
    for (NSString* locCode in [dic allKeys])
    {
        NSDictionary* hotSpotData = [dic objectForKey:locCode];
        NSString* locationName = [hotSpotData valueForKey:@"Location_name"];
        NSString* roadwayPortion = [hotSpotData valueForKey:@"Roadway_portion"];
        int count = [((NSNumber*)[hotSpotData objectForKey:@"Total"]) intValue];
        double latitude = [((NSNumber*)[hotSpotData objectForKey:@"Latitude"]) doubleValue];
        double longitude = [((NSNumber*)[hotSpotData objectForKey:@"Longitude"]) doubleValue];
        
        HotSpot* hotSpot = [[HotSpot alloc] initWithLocCode:locCode
                                                   location:locationName
                                                      count:count rank:0
                                                   latitude:latitude
                                                 longtitude:longitude];
        hotSpot.type = [HotSpot fromString:roadwayPortion];
        [res addObject:hotSpot];
    }
    
    return [self sortHotSpotsOrderByLocationNameAsc:res];
}

-(NSArray*)sortHotSpotsOrderByLocationNameAsc:(NSArray*)hotSpots
{
    NSComparator cmptr = ^(id obj1, id obj2)
    {
        HotSpot* hotSpot1 = (HotSpot*)obj1;
        HotSpot* hotSpot2 = (HotSpot*)obj2;
        return [hotSpot1.location compare:hotSpot2.location options:NSLiteralSearch];
    };
    
    return [hotSpots sortedArrayUsingComparator:cmptr];
}

-(NSArray*)selectAllReasonNames
{
    NSString* mainDBPath = [DBManager getPathOfMainDB];
    FMDatabase* db = [FMDatabase databaseWithPath:mainDBPath];
    if (![db open])
    {
        NSAssert(NO, @"Open db failed");
        return nil;
    }
    
    NSMutableArray *res = [[NSMutableArray alloc] init];
    
    FMResultSet* resultSet = [db executeQuery:@"select Reason_id, Reason from TBL_WM_REASON_CONDITION asc order by Reason"];
    NSError *error = nil;
    while ([resultSet nextWithError:&error])
    {
        if (error)
        {
            NSLog(@"File: %s\nLine:%d\nError:%@\n", __FILE__, __LINE__, error.description);
            continue;
        }
        
        [res addObject:@{
                        @"Reason_id":[resultSet stringForColumn:@"Reason_id"],
                        @"Reason":[resultSet stringForColumn:@"Reason"]
                        }];
    }
    
    if (![db close])
    {
        NSAssert(NO, @"Close db failed");
    }
    
    return res;
}

-(NSArray*)getHotSpotDetailsByLocationCode:(NSString*)locCode
{
    NSString* mainDBPath = [DBManager getPathOfMainDB];
    FMDatabase* db = [FMDatabase databaseWithPath:mainDBPath];
    if (![db open])
    {
        NSAssert(NO, @"Open db failed");
    }
    NSMutableArray* res = [[NSMutableArray alloc] init];
    
    NSError* error = nil;
    NSString* smt =[NSString stringWithFormat:@"select l.Travel_direction, l.Total, r.Reason from TBL_LOCATION_REASON as l, TBL_WM_REASON_CONDITION as r where l.Loc_code = '%@' and l.Reason_id = r.Reason_id order by l.Total desc", locCode];
    
    FMResultSet* resultSet = [db executeQuery:smt];
    while ([resultSet nextWithError:&error])
    {
        NSString* travelDirection = [resultSet stringForColumn:@"Travel_direction"];
        NSString* reason = [resultSet stringForColumn:@"Reason"];
        int total = [resultSet intForColumn:@"Total"];
        
        NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:
                              travelDirection, @"Travel_direction",
                              reason, @"Reason",
                              [NSNumber numberWithInt:total], @"Total",
                              nil];
        [res addObject:data];
    }
    
    if (![db close])
    {
        NSAssert(NO, @"Close db failed");
    }
    
    return res;
}

@end
