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

+ (NSDictionary *)FMDBColumnsByPropertyKey
{
    return @{};
}

+ (NSArray*)FMDBPrimaryKeys
{
    return @[@"Loc_code"];
}

+ (NSString *)FMDBTableName
{
    return MAIN_DB_TBL_COLLISION_LOCATION;
}

@end