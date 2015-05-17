//
//  DBCollisionLocation.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/5/2.
//  Copyright (c) 2015Äê Gongwei. All rights reserved.
//

#import "DBCollisionLocation.h"
#import "DBConstants.h"

@implementation DBCollisionLocation

static NSString * const kLocCodeColumn = @"Loc_code";
static NSString * const kLatitudeColumn = @"Latitude";
static NSString * const kLongtitudeColumn = @"Longtitude";

+ (NSDictionary *)FMDBColumnsByPropertyKey
{
    return @{
             @"locCode": @"LOC_CODE",
             @"latitude": @"Latitude",
             @"longtitude": @"Longtitude"
             };
}

+ (NSArray*)FMDBPrimaryKeys
{
    return @[@"LOC_CODE"];
}

+ (NSString *)FMDBTableName
{
    return MAIN_DB_TBL_COLLISION_LOCATION;
}

@end