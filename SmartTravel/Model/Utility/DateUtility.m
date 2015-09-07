//
//  DateUtility.m
//  SmartTravel
//
//  Created by chenpold on 5/17/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "DateUtility.h"

@implementation DateUtility

+ (BOOL)isDateWeekday:(NSDate*)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSRange weekdayRange = [calendar maximumRangeOfUnit:NSWeekdayCalendarUnit];
    NSDateComponents* components = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    NSUInteger weekdayOfDate = [components weekday];
    
    if (weekdayOfDate == weekdayRange.location || weekdayOfDate == weekdayRange.length)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (NSInteger)convertMinutesFromHour:(NSInteger)hour andMinute:(NSInteger)minute
{
    return hour * 60 + minute;
}

// Compute there're how many minutes of time since 00:00 of that day.
// The time str format should be 'hh:mm'.
+ (NSInteger)getMinutesFromTimeStr:(NSString*)str
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


+ (BOOL)isDateMatched:(NSDate*)date
                month:(NSString*)monthStr
            startTime:(NSString*)startTimeStr
              endTime:(NSString*)endTimeStr
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    // Valid time should in range of [startTime, endTime]
    NSDateComponents* dateCom1 = [calendar components:(NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:date];
    NSInteger hourAndMinutes = [self convertMinutesFromHour:[dateCom1 hour] andMinute:[dateCom1 minute]];
    if (hourAndMinutes < [self getMinutesFromTimeStr:startTimeStr] ||
        hourAndMinutes > [self getMinutesFromTimeStr:endTimeStr])
    {
        return false;
    }
    
    // Valid month should have '1' in the corresponding postion of monthStr of '111100001111' format.
    NSDateComponents* dateCom2 = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    NSInteger month = [dateCom2 month];
    BOOL isMonthValid = NO;
    for (NSInteger i = 0; i < monthStr.length; ++i)
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

+ (NSString*)getDateString:(NSDate*)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString* dateStr = [dateFormat stringFromDate:date];
    return dateStr;
}

+ (NSString*)getDateString1:(NSDate *)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString* dateStr = [dateFormat stringFromDate:date];
    return dateStr;
}

@end
