//
//  TopCyclist.m
//  SmartTravel
//
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "TopCyclist.h"

@implementation TopCyclist

+ (NSDictionary *)FMDBColumnsByPropertyKey
{
    return @{
             @"locationCode": @"LOC_CODE",
             @"location": @"LOCATION",
             @"portion": @"PORTION",
             @"count": @"COUNT",
             @"rank": @"RANK",
             @"latitude": @"LAT",
             @"longtitude": @"LONG"
             };
}

+ (NSArray*)FMDBPrimaryKeys
{
    return @[@"LOC_CODE"];
}

+ (NSString *)FMDBTableName
{
    return @"Top_Cyclist";
}

@end
