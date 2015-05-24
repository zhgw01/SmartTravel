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

+(NSString*)makeInsertSmtForTable:(NSString*)tableName
{
    if ([tableName isEqualToString:MAIN_DB_TBL_COLLISION_LOCATION])
    {
        return [NSString stringWithFormat:@"INSERT INTO %@ (Loc_code, Location_name, Roadway_portion, Latitude, Longitude) values(:Loc_code, :Location_name, :Roadway_portion, :Latitude, :Longitude)", MAIN_DB_TBL_COLLISION_LOCATION];
    }
    else if ([tableName isEqualToString:MAIN_DB_TBL_LOCATION_REASON])
    {
        return [NSString stringWithFormat:@"INSERT INTO %@ (Id, Loc_code, Travel_direction, Reason_id, Total, Warning_priority) values(:Id, :Loc_code, :Travel_direction, :Reason_id, :Total, :Warning_priority)", MAIN_DB_TBL_LOCATION_REASON];
    }
    else if ([tableName isEqualToString:MAIN_DB_TBL_WM_DAYTYPE])
    {
        return [NSString stringWithFormat:@"INSERT INTO %@ (Date, Weekday, Weekend, School_day) values(:Date, :Weekday, :Weekend, :School_day)", MAIN_DB_TBL_WM_DAYTYPE];
    }
    else if ([tableName isEqualToString:MAIN_DB_TBL_WM_REASON_CONDITION])
    {
        return [NSString stringWithFormat:@"INSERT INTO %@ (Reason_id, Reason, Month, Weekday, Weekend, School_day, Start_time, End_time, Warning_message) values(:Reason_id, :Reason, :Month, :Weekday, :Weekend, :School_day, :Start_time, :End_time, :Warning_message)", MAIN_DB_TBL_WM_REASON_CONDITION];
    }
    else
    {
        NSAssert(NO, @"Not implemented");
    }
    return nil;
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
        if (hotSpotType == HotSpotTypeMidStreet)
        {
            NSLog(@"*** %@", key);
        }
        
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
