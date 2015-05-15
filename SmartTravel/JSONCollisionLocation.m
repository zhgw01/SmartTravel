//
//  JSONCollisionLocation.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/15/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "JSONCollisionLocation.h"

@implementation JSONCollisionLocation

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"locationName": @"location_name",
             @"roadwayPortion": @"roadway_portion",
             @"longitude": @"longitude",
             @"latitude": @"latitude",
             @"locCode": @"loc_code"
             };
}

@end
