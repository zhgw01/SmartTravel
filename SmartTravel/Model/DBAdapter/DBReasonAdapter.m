//
//  DBReasonAdapter.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/14/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <FMDB/FMDB.h>
#import "DBReasonAdapter.h"
#import "DBDayTypeAdapter.h"
#import "DBConstants.h"
#import "DBManager.h"
#import "DateUtility.h"

static NSString * const kReasonIdColumn = @"Reason_id";
static NSString * const kReasonColumn = @"Reason";
static NSString * const kWarningMessageColumn = @"Warning_message";
static NSString * const kMonthColumn = @"Month";
static NSString * const kWeekdayColumn = @"Weekday";
static NSString * const kWeekendColumn = @"Weekend";
static NSString * const kSchoolDayColumn = @"School_day";
static NSString * const kStartTimeColumn = @"Start_time";
static NSString * const kEndTimeColumn = @"End_time";

@implementation DBReasonAdapter

- (NSArray*)getReasonIDsOfDate:(NSDate*)date
{
    NSMutableArray* res = [[NSMutableArray alloc] init];
    
    FMDatabase* db = [FMDatabase databaseWithPath:[DBManager getPathOfMainDB]];
    if ([db open])
    {
        NSString* smt = [self constructSmt:date];
        FMResultSet* resultSet = [db executeQuery:smt];
        NSError* error = nil;
        while([resultSet nextWithError:&error])
        {
#ifdef DEBUG
            NSString* reasonId = [resultSet stringForColumn:kReasonIdColumn];
            [res addObject:reasonId];
#else
            NSString* reasonId = [resultSet stringForColumn:kReasonIdColumn];
            NSString* monthStr = [resultSet stringForColumn:kMonthColumn];
            NSString* startTimeStr = [resultSet stringForColumn:kStartTimeColumn];
            NSString* endTimeStr = [resultSet stringForColumn:kEndTimeColumn];
            if ([DateUtility isDateMatched:date month:monthStr startTime:startTimeStr endTime:endTimeStr])
            {
                [res addObject:reasonId];
            }
#endif
        }
        [resultSet close];
        
        if (![db close])
        {
            NSAssert(NO, @"Close db failed");
        }
    }
    
    return [res copy];
}

- (NSArray*)getWarningMessageAndReasonOfId:(int)reasonId
{
    NSMutableArray* res = [[NSMutableArray alloc] init];
    
    FMDatabase* db = [FMDatabase databaseWithPath:[DBManager getPathOfMainDB]];
    if ([db open])
    {
        NSString* smt = [NSString stringWithFormat:@"select %@, %@ from %@ where %@=%d", kReasonColumn, kWarningMessageColumn, MAIN_DB_TBL_WM_REASON_CONDITION, kReasonIdColumn, reasonId];
        FMResultSet* resultSet = [db executeQuery:smt];
        NSError* error = nil;
        if ([resultSet nextWithError:&error] && !error)
        {
            [res addObject:[resultSet stringForColumn:kWarningMessageColumn]];
            [res addObject:[resultSet stringForColumn:kReasonColumn]];
        }
        [resultSet close];
        
        if (![db close])
        {
            NSAssert(NO, @"Close db failed");
        }
    }
    
    return [res copy];
}

- (NSString*)constructSmt:(NSDate*)date
{
    DBDayTypeAdapter* dbDateAdapter = [[DBDayTypeAdapter alloc] initWith:date];
    return [NSString stringWithFormat:
            @"select %@, %@, %@, %@ from %@ where (%@ = %d) and (%@ = %d)",
            kReasonIdColumn,
            kMonthColumn,
            kStartTimeColumn,
            kEndTimeColumn,
            MAIN_DB_TBL_WM_REASON_CONDITION,
            dbDateAdapter.isWeekDay ? kWeekdayColumn : kWeekendColumn,
            1,
            kSchoolDayColumn,
            dbDateAdapter.isSchoolDay ? 1 : 0];
}

@end
