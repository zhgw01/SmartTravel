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
    return @{};
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