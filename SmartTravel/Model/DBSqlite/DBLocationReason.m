//
//  DBLocationReason.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/5/2.
//  Copyright (c) 2015Äê Gongwei. All rights reserved.
//

#import "DBLocationReason.h"
#import "DBConstants.h"

@implementation DBLocationReason

+ (NSDictionary *)FMDBColumnsByPropertyKey
{
    return @{};
}

+ (NSArray*)FMDBPrimaryKeys
{
    return @[@"Id"];
}

+ (NSString *)FMDBTableName
{
    return MAIN_DB_TBL_LOCATION_REASON;
}

@end