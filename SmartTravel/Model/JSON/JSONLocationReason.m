//
//  JSONLocationReason.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/15/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "JSONLocationReason.h"

@implementation JSONLocationReason

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"total": @"total",
             @"warningPriority": @"warning_priority",
             @"reasonId": @"reason_id",
             @"travelDirection": @"travel_direction",
             @"locCode": @"loc_code"
             };
}

@end
