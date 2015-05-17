//
//  DBWMReasonCondition.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/5/2.
//  Copyright (c) 2015Äê Gongwei. All rights reserved.
//

#import "DBWMReasonCondition.h"
#import "DBConstants.h"

@implementation DBWMReasonCondition

+ (NSDictionary *)FMDBColumnsByPropertyKey
{
    return @{
             @"reasonId": @"Reason_id",
             @"month": @"Month",
             @"weekday": @"Weekday",
             @"weekend": @"Weekend",
             @"schoolDay": @"School_day",
             @"startTime": @"Start_time",
             @"endTime": @"End_time"
             };
}

+ (NSArray*)FMDBPrimaryKeys
{
    return @[@"Reason_id"];
}

+ (NSString *)FMDBTableName
{
     return MAIN_DB_TBL_WM_REASON_CONDITION;
}

@end