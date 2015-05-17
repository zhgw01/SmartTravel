//
//  DBWMDayType.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/5/2.
//  Copyright (c) 2015Äê Gongwei. All rights reserved.
//

#import "DBWMDayType.h"
#import "DBConstants.h"

@implementation DBWMDayType

+ (NSDictionary *)FMDBColumnsByPropertyKey
{
    return @{
             @"weekday": @"Weekday",
             @"schoolDay": @"School_day",
             @"date" : @"Date"
             };
}

+ (NSArray*)FMDBPrimaryKeys
{
    return @[@"Date"];
}

+ (NSString *)FMDBTableName
{
    return MAIN_DB_TBL_WM_DAYTYPE;
}

@end