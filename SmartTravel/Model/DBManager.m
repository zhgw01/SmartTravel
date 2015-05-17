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
        smt = @"select l.Location_name, l.Longitude, l.Latitude, r.Total, r.Warning_priority from TBL_COLLISION_LOCATION as l, TBL_LOCATION_REASON as r where l.Loc_code = r.Loc_code order by r.Total asc";
    }
    else
    {
        smt = [NSString stringWithFormat:@"select l.Location_name, l.Longitude, l.Latitude, r.Total, r.Warning_priority from TBL_COLLISION_LOCATION as l, TBL_LOCATION_REASON as r where l.Loc_code = r.Loc_code and l.Roadway_portion = '%@' order by r.Total asc", [HotSpot toString:hotSpotType]];
    }
    
    FMResultSet* resultSet = [db executeQuery:smt];
    while ([resultSet nextWithError:&error])
    {
        HotSpot* hotSpot = [[HotSpot alloc] initWithLocation:[resultSet stringForColumn:@"Location_name"]
                                                       count:[resultSet intForColumn:@"Total"]
                                                        rank:[resultSet intForColumn:@"Warning_priority"]
                                                    latitude:[resultSet doubleForColumn:@"Latitude"]
                                                  longtitude:[resultSet doubleForColumn:@"Longitude"]];
        [res addObject:hotSpot];
    }
    [resultSet close];
    
    BOOL dbCloseRes = [db close];
    NSAssert(dbCloseRes, @"Close db failed");
    
    return res;
}

@end
