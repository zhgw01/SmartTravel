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
static NSString * const kReasonIdColumn = @"Reason_id";

// Columns of TBL_COLLISION_LOCATION
static NSString * const kLatitudeColumn = @"Latitude";
static NSString * const kLongitudeColumn = @"Longitude";
static NSString * const kLocationNameColumn = @"Location_name";

// Columns of TBL_LOCATION_REASON
static NSString * const kTotalColumn = @"Total";
static NSString * const kWarningPriorityColumn = @"Warning_priority";
static NSString * const kTravelDirectionColumn = @"Travel_direction";

@implementation DBLocationAdapter

- (NSArray*)getLocCodesInRange:(double)radius
                    atLatitude:(double)latitude
                     longitude:(double)longitude
{
    NSMutableArray* res = [[NSMutableArray alloc] init];
    
    FMDatabase* db = [FMDatabase databaseWithPath:[DBManager getPathOfMainDB]];
    if ([db open])
    {
        NSString*(^constructSqlSmt)(double, double, double) = ^(double latitude, double longitude, double radius) {
            double latInset = 0;
            double lonInset = 0;
            [self getDegreeInsetsAtLatitude:latitude longitude:longitude radius:radius latInset:&latInset lonInset:&lonInset];
            
            return [NSString stringWithFormat:
                    @"select %@ from %@ where (%@ > %g and %@ < %g) and (%@ > %g and %@ < %g)",
                    kLocCodeColumn,
                    MAIN_DB_TBL_COLLISION_LOCATION,
                    kLatitudeColumn,
                    latitude - latInset,
                    kLatitudeColumn,
                    latitude + latInset,
                    kLongitudeColumn,
                    longitude - lonInset,
                    kLongitudeColumn,
                    longitude + lonInset];
        };
        NSString* smt = constructSqlSmt(latitude, longitude, radius);
        
        FMResultSet* resultSet = [db executeQuery:smt];
        NSError* error = nil;
        while([resultSet nextWithError:&error])
        {
            [res addObject:[resultSet stringForColumn:kLocCodeColumn]];
        }
        [resultSet close];
        
        if (![db close])
        {
            NSAssert(NO, @"Close db failed");
        }
    }
    
    return [res copy];
}

- (BOOL)getLocationName:(NSString**)locationName
               reasonId:(int*)reasonId
               latitude:(double*)latitude
              longitude:(double*)longitude
              ofLocCode:(NSString*)locCode
{
    BOOL res = NO;
    
    FMDatabase* db = [FMDatabase databaseWithPath:[DBManager getPathOfMainDB]];
    if ([db open])
    {
        NSString* smt = [NSString stringWithFormat:@"select l.Location_name, l.Latitude, l.Longitude, r.Reason_id from %@ as l, %@ as r where l.Loc_code = r.Loc_code and l.Loc_code ='%@'", MAIN_DB_TBL_COLLISION_LOCATION, MAIN_DB_TBL_LOCATION_REASON,locCode];
        FMResultSet* resultSet = [db executeQuery:smt];
        NSError* error = nil;
        if([resultSet nextWithError:&error])
        {
            *locationName = [resultSet stringForColumn:kLocationNameColumn];
            *reasonId = [resultSet intForColumn:kReasonIdColumn];
            *latitude = [resultSet doubleForColumn:kLatitudeColumn];
            *longitude = [resultSet doubleForColumn:kLongitudeColumn];
            res = YES;
        }
        [resultSet close];
        
        if (![db close])
        {
            NSAssert(NO, @"Close db failed");
        }
    }
    
    return res;
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


- (NSDictionary*)getLocationReasonAtLatitude:(double)latitude
                                   longitude:(double)longitude
                                 ofReasonIds:(NSArray*)reasonIds
                                 inDirection:(Direction)direction
                                withinRadius:(double)radius
{
    // Get loc codes
    NSArray* locCodes = [self getLocCodesInRange:radius atLatitude:latitude longitude:longitude];
    if (locCodes.count == 0)
    {
        return nil;
    }
    
    // Get location_reasons
    NSString* smt = [NSString  stringWithFormat:
                     @"select %@, %@, %@, %@, %@ from %@ where (%@ = '%@' or %@ = 'ALL') and %@ in (%@) and %@ in %@ order by %@ desc limit 1",
                     kLocCodeColumn,
                     kTravelDirectionColumn,
                     kReasonIdColumn,
                     kTotalColumn,
                     kWarningPriorityColumn,
                     MAIN_DB_TBL_LOCATION_REASON,
                     kTravelDirectionColumn,
                     [LocationDirection directionToString:direction],
                     kTravelDirectionColumn,
                     kLocCodeColumn,
                     [self locCodesToSQLParameters:locCodes],
                     kReasonIdColumn,
#ifdef DEBUG
                     @[@(1006)],
#else
                     reasonIds,
#endif
                     kWarningPriorityColumn];
    
    NSDictionary* res = nil;
    
    FMDatabase* db = [FMDatabase databaseWithPath:[DBManager getPathOfMainDB]];
    if ([db open])
    {
        FMResultSet* resultSet = [db executeQuery:smt withArgumentsInArray:locCodes];
        NSError* error = nil;
        if([resultSet nextWithError:&error])
        {
            NSString* locCodeValue = [resultSet stringForColumn:kLocCodeColumn];
            NSString* directionValue = [resultSet stringForColumn:kTravelDirectionColumn];
            int reasonIdValue = [resultSet intForColumn:kReasonIdColumn];
            int totalValue = [resultSet intForColumn:kTotalColumn];
            int warningPriorityValue = [resultSet intForColumn:kWarningPriorityColumn];
            
            res = [NSDictionary dictionaryWithObjectsAndKeys:
                   locCodeValue, kLocCodeColumn,
                   directionValue, kTravelDirectionColumn,
                   [NSNumber numberWithInt:reasonIdValue], kReasonIdColumn,
                   [NSNumber numberWithInt:totalValue], kTotalColumn,
                   [NSNumber numberWithInt:warningPriorityValue], kWarningPriorityColumn,
                   nil];
        }
        [resultSet close];
        
        if (![db close])
        {
            NSAssert(NO, @"Close db failed");
        }
    }
    
    return [res copy];
}

#pragma mark - Private methods
- (NSString*)locCodesToSQLParameters:(NSArray*)locCodes
{
    NSUInteger cnt = locCodes.count;
    NSMutableArray* placeholders = [[NSMutableArray alloc] init];
    for (NSUInteger idx = 0; idx < cnt; ++idx)
    {
        [placeholders addObject:@"?"];
    }
    
    return [placeholders componentsJoinedByString:@","];
}

@end
