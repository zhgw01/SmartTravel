//
//  DBReasonAdapter.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/14/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <FMDB/FMDB.h>
#import "DBReasonAdapter.h"
#import "DBDateAdapter.h"
#import "DBManager.h"

static NSString * const kReasonIdColumn = @"Reason_id";
static NSString * const kMonthColumn = @"Month";
static NSString * const kWeekdayColumn = @"Weekday";
//static NSString * const kWeekendColumn = @"Weekend";
static NSString * const kSchoolDayColumn = @"School_day";
static NSString * const kStartTimeColumn = @"Start_time";
static NSString * const kEndTimeColumn = @"End_time";

@implementation DBReasonAdapter

- (NSArray*)getReasonIDsOfDate:(NSDate*)date
{
    NSMutableArray* res = [[NSMutableArray alloc] init];
    
    FMDatabase* db = [[DBManager sharedInstance] mainDb];
    if ([db open])
    {
        NSString* smt = [self constructSmt:date];
        FMResultSet* resultSet = [db executeQuery:smt];
        NSError* error = nil;
        while([resultSet nextWithError:&error])
        {
            NSString* reasonId = [resultSet stringForColumn:kReasonIdColumn];
            NSString* monthStr = [resultSet stringForColumn:kMonthColumn];
            NSString* startTimeStr = [resultSet stringForColumn:kStartTimeColumn];
            NSString* endTimeStr = [resultSet stringForColumn:kEndTimeColumn];
            
            if ([self isReasonValid:date month:monthStr startTime:startTimeStr endTime:endTimeStr])
            {
                [res addObject:reasonId];
            }
        }
        
        [db close];
    }
    
    return [res copy];
}

- (NSString*)constructSmt:(NSDate*)date
{
    DBDateAdapter* dbDateAdapter = [[DBDateAdapter alloc] initWith:date];
    
    return [NSString stringWithFormat:
            @"select %@, %@, %@, %@ from %@ where (%@ = %@) and (%@ = %@)",
            kReasonIdColumn,
            kMonthColumn,
            kStartTimeColumn,
            kEndTimeColumn,
            MAIN_DB_TBL_WM_REASON_CONDITION,
            kWeekdayColumn,
            dbDateAdapter.isWeekDay ? @"true" : @"false",
            kSchoolDayColumn,
            dbDateAdapter.isSchoolDay ? @"true" : @"false"];
}

- (NSInteger)convertMinutesFromHour:(NSInteger)hour andMinute:(NSInteger)minute
{
    return hour * 60 + minute;
}

// Compute there're how many minutes of time since 00:00 of that day.
// The time str format should be 'hh:mm'.
- (NSInteger)getMinutesFromTimeStr:(NSString*)str
{
    NSArray* arr = [str componentsSeparatedByString:@":"];
    if (arr.count != 2)
    {
        return 0;
    }
    
    NSString* hourStr = (NSString*)arr[0];
    NSString* minuteStr = (NSString*)arr[1];
    return [hourStr integerValue] * 60 + [minuteStr integerValue];
}

- (BOOL)isReasonValid:(NSDate*)date
                month:(NSString*)monthStr
            startTime:(NSString*)startTimeStr
              endTime:(NSString*)endTimeStr
{
    NSCalendar* calendar = [NSCalendar currentCalendar];

    // Valid time should in range of [startTime, endTime]
    NSDateComponents* dateCom1 = [calendar components:(NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:date];
    NSInteger hourAndMinutes = [self convertMinutesFromHour:[dateCom1 hour] andMinute:[dateCom1 minute]];
    if ( hourAndMinutes < [self getMinutesFromTimeStr:startTimeStr] ||
        hourAndMinutes > [self getMinutesFromTimeStr:endTimeStr])
    {
        return false;
    }
    
    // Valid month should have '1' in the corresponding postion of monthStr of '111100001111' format.
    NSDateComponents* dateCom2 = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    NSInteger month = [dateCom2 month];
    BOOL isMonthValid = NO;
    for (NSInteger i = 0; i < 12; ++i)
    {
        if ([monthStr characterAtIndex:i] == '1')
        {
            if ((i + 1) == month)
            {
                isMonthValid = YES;
                break;
            }
        }
    }
    
    return isMonthValid;
}

@end
