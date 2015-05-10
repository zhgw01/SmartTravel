//
//  TopIntersection.m
//  SmartTravel
//
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "TopIntersection.h"

@implementation TopIntersection

+ (NSDictionary *)FMDBColumnsByPropertyKey
{
    return @{
             @"locationCode": @"LOC_CODE",
             @"location": @"LOCATION",
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
    return @"Top_Intersection";
}

@end
