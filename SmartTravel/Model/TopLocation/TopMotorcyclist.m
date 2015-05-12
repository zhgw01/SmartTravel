//
//  TopMotorcyclist.m
//  SmartTravel
//
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "TopMotorcyclist.h"

@implementation TopMotorcyclist

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
    return @"Top_Motorcyclist";
}

@end
