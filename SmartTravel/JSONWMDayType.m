//
//  JSONWMDayType.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/15/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "JSONWMDayType.h"

@implementation JSONWMDayType

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"weekday": @"weekday",
             @"weenend": @"weenend",
             @"date": @"date",
             @"schoolDay": @"school_day"
             };
}

@end
