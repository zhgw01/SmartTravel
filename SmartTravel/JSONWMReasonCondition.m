//
//  JSONWMReasonCondition.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/15/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "JSONWMReasonCondition.h"

@implementation JSONWMReasonCondition

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"warnigMessage": @"warnig_message",
             @"weekday": @"weekday",
             @"reason": @"reason",
             @"weenend": @"weenend",
             @"endTime": @"end_time",
             @"reasonId":@"reason_id",
             @"month":@"month",
             @"startTime":@"start_time",
             @"schoolDay":@"school_day"
             };
}

@end
