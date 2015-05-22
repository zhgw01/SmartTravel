//
//  DBLocationReasonAdapter.m
//  SmartTravel
//
//  Created by Pengyu chen on 5/15/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <FMDB/FMDB.h>
#import "DBLocationReasonAdapter.h"
#import "DBConstants.h"
#import "DBManager.h"
#import "DBReasonAdapter.h"
#import "DBLocationAdapter.h"

static NSString * const kLocCodeColumn = @"Loc_code";
static NSString * const kTravelDirectionColumn = @"Travel_direction";
static NSString * const kReasonIdColumn = @"Reason_id";
static NSString * const kTotalColumn = @"Total";
static NSString * const kWarningPriorityColumn = @"Warning_priority";

@implementation DBLocationReasonAdapter

- (NSDictionary*)getLocationReasonAtLatitude:(double)latitude
                                   longitude:(double)longitude
                                 ofReasonIds:(NSArray*)reasonIds
                                 inDirection:(Direction)direction
                                withinRadius:(double)radius
{
    // Get loc codes
    DBLocationAdapter* dbLocationAdapter = [[DBLocationAdapter alloc] init];
    NSArray* locCodes = [dbLocationAdapter getLocCodesInRange:radius atLatitude:latitude longitude:longitude];
    NSString* locCodesStr = [DBLocationReasonAdapter arrayToSQLInConditions:locCodes];
    
    NSString* reasonIdsStr = [DBLocationReasonAdapter arrayToSQLInConditions:reasonIds];
    
    // Get location_reasons
    NSString* smt = [self constructSmtWithDirection:direction locCodes:locCodesStr reasonIds:reasonIdsStr];
    
    NSDictionary* res = nil;
    
    FMDatabase* db = [FMDatabase databaseWithPath:[DBManager getPathOfMainDB]];
    if ([db open])
    {
        FMResultSet* resultSet = [db executeQuery:smt];
        NSError* error = nil;
        if([resultSet nextWithError:&error])
        {
            NSString* locCodeValue = [resultSet stringForColumn:kLocCodeColumn];
            NSString* directionValue = [resultSet stringForColumn:kTravelDirectionColumn];
            int reasonIdValue = [resultSet intForColumn:kReasonIdColumn];
            int totalValue = [resultSet intForColumn:kTotalColumn];
            int waringPriorityValue = [resultSet intForColumn:kWarningPriorityColumn];
            
            res = [NSDictionary dictionaryWithObjectsAndKeys:
                   locCodeValue, kLocCodeColumn,
                   directionValue, kTravelDirectionColumn,
                   [NSNumber numberWithInt:reasonIdValue], kReasonIdColumn,
                   [NSNumber numberWithInt:totalValue], kTotalColumn,
                   [NSNumber numberWithInt:waringPriorityValue], kWarningPriorityColumn,
                   nil];
        }
        
        BOOL dbCloseRes = [db close];
        NSAssert(dbCloseRes, @"Close db failed");
    }
    
    return [res copy];

}

+ (NSString*)arrayToSQLInConditions:(NSArray*)array
{
    NSMutableArray* arrayWithSingleQuotes = [[NSMutableArray alloc] init];
    for (NSString* str in array)
    {
        [arrayWithSingleQuotes addObject:[NSString stringWithFormat:@"'%@'", str]];
    }
    return [arrayWithSingleQuotes componentsJoinedByString:@","];
}


- (NSString*)constructSmtWithDirection:(Direction)direction
                              locCodes:(NSString*)locCodes
                             reasonIds:(NSString*)reasonIds
{
    NSString* smt =  [NSString  stringWithFormat:
                      @"select %@, %@, %@, %@, %@ from %@ where (%@ = '%@' or %@ = 'ALL') and %@ in (%@) and %@ in (%@) order by Warning_priority desc limit 1",
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
                      locCodes,
                      kReasonIdColumn,
                      reasonIds];
    return smt;
}
@end
