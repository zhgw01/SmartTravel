//
//  DBLocationAdapter.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/14/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <FMDB/FMDB.h>
#import "DBLocationAdapter.h"
#import "DBConstants.h"
#import "DBManager.h"

static NSString * const kLocCodeColumn = @"Loc_code";
static NSString * const kLatitudeColumn = @"Latitude";
static NSString * const kLongitudeColumn = @"Longitude";

@implementation DBLocationAdapter

- (NSArray*)getLocCodesInRange:(double)radius
                    atLatitude:(double)latitude
                     longitude:(double)longitude
{
    NSMutableArray* res = [[NSMutableArray alloc] init];
    
    FMDatabase* db = [FMDatabase databaseWithPath:[DBManager getPathOfMainDB]];
    if ([db open])
    {
        NSString* smt = [self constructSmt:latitude longitude:longitude radius:radius];
        FMResultSet* resultSet = [db executeQuery:smt];
        NSError* error = nil;
        while([resultSet nextWithError:&error])
        {
            [res addObject:[resultSet stringForColumn:kLocCodeColumn]];
        }
        
        BOOL dbCloseRes = [db close];
        NSAssert(dbCloseRes, @"Close db failed");
    }
    
    return [res copy];
}

- (BOOL)getLocationName:(NSString**)locationName
                  total:(int*)total
        warningPriority:(int*)warningPriority
              ofLocCode:(NSString*)locCode
{
    BOOL res = NO;
    
    FMDatabase* db = [FMDatabase databaseWithPath:[DBManager getPathOfMainDB]];
    if ([db open])
    {
        NSString* smt = [NSString stringWithFormat:@"select l.Location_name, r.Total, r.Warning_priority from TBL_COLLISION_LOCATION as l, TBL_LOCATION_REASON as r where l.Loc_code = r.Loc_code and l.Loc_code ='%@'", locCode];
        FMResultSet* resultSet = [db executeQuery:smt];
        NSError* error = nil;
        if([resultSet nextWithError:&error])
        {
            *locationName = [resultSet stringForColumn:@"Location_name"];
            *total = [resultSet intForColumn:@"Total"];
            *warningPriority = [resultSet intForColumn:@"Warning_priority"];
            
            res = YES;
        }
        
        BOOL dbCloseRes = [db close];
        NSAssert(dbCloseRes, @"Close db failed");
    }
    
    return res;
}

- (NSString*)constructSmt:(double)latitude
               longitude:(double)longtitude
                   radius:(double)radius
{
    double latInset = 0;
    double lonInset = 0;
    [self getDegreeInsetsAtLatitude:latitude longitude:longtitude radius:radius latInset:&latInset lonInset:&lonInset];
    
    return [NSString stringWithFormat:
            @"select %@ from %@ where (%@ > %g and %@ < %g) and (%@ > %g and %@ < %g)",
            kLocCodeColumn,
            MAIN_DB_TBL_COLLISION_LOCATION,
            kLatitudeColumn,
            latitude - latInset,
            kLatitudeColumn,
            latitude + latInset,
            kLongitudeColumn,
            longtitude - lonInset,
            kLongitudeColumn,
            longtitude + lonInset];
}

- (void)getDegreeInsetsAtLatitude:(double)latitude
                        longitude:(double)longitude
                           radius:(double)radius
                         latInset:(double*)latInset
                         lonInset:(double*)lonInset
{
    if (radius < 0)
    {
        return;
    }
    
    CLLocation* left = [[CLLocation alloc] initWithLatitude:latitude longitude:(longitude - 0.01)];
    CLLocation* right = [[CLLocation alloc] initWithLatitude:latitude longitude:(longitude + 0.01)];
    CLLocation* up = [[CLLocation alloc] initWithLatitude:(latitude - 0.01) longitude:longitude ];
    CLLocation* down = [[CLLocation alloc] initWithLatitude:(latitude + 0.01) longitude:longitude ];
    
    double distanceOfOnePercentDegreeAtLon = [left distanceFromLocation:right] * 0.5;
    double distanceOfOnePercentDegreeAtLat = [up distanceFromLocation:down] * 0.5;

    *latInset = radius / distanceOfOnePercentDegreeAtLat * 0.01;
    *lonInset = radius / distanceOfOnePercentDegreeAtLon * 0.01;
}

@end
