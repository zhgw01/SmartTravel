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
    return @{
             @"locCode": @"Loc_code",
             @"travelDirection": @"Travel_direction",
             @"reasonId": @"Reason_id",
             @"total": @"Total",
             @"warningPriority": @"Warning_priority"
             };
}

+ (NSArray*)FMDBPrimaryKeys
{
    return @[@"Loc_code", @"Reason_id"];
}

+ (NSString *)FMDBTableName
{
    return MAIN_DB_TBL_LOCATION_REASON;
}

@end