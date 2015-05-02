//
//  Collision.m
//  SmartTravel
//
//  Created by Gongwei on 15/5/2.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "Collision.h"

@implementation Collision

+ (NSDictionary *)FMDBColumnsByPropertyKey
{
    return @{
             @"locationCode": @"LOC_CODE",
             @"location": @"LOCATION",
             @"count": @"COUNT",
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
    return @"Collision";
}

@end
