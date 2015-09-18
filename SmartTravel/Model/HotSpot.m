//
//  HotSpot.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/10/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "HotSpot.h"

@implementation HotSpot

- (instancetype)initWithLocCode:(NSString*)locCode
                       location:(NSString*)location
                          count:(int)count
                       latitude:(double)latitude
                     longtitude:(double)longtitude
                           type:(HotSpotType)type
{
    if (self = [super init])
    {
        self.locCode    = locCode;
        self.location   = location;
        self.count      = [NSNumber numberWithInt:count];
        self.latitude   = [NSNumber numberWithDouble:latitude];
        self.longtitude = [NSNumber numberWithDouble:longtitude];
        self.type       = type;
    }
    return self;
}

+ (NSString*)toString:(HotSpotType)type
{
    if (type == HotSpotTypeIntersection)
    {
        return @"INTERSECTION";
    }
    else if (type == HotSpotTypeMidStreet)
    {
        return @"MID STREET";
    }
    else if (type == HotSpotTypeMidAvenue)
    {
        return @"MID AVENUE";
    }
    else if (type == HotSpotTypeSchoolZone)
    {
        return @"SCHOOL ZONE";
    }
    return @"";
}

+ (HotSpotType)fromString:(NSString*)typeStr
{
    if ([typeStr isEqualToString:@"INTERSECTION"])
    {
        return HotSpotTypeIntersection;
    }
    else if ([typeStr isEqualToString:@"MID STREET"])
    {
        return HotSpotTypeMidStreet ;
    }
    else if ([typeStr isEqualToString: @"MID AVENUE"])
    {
        return HotSpotTypeMidAvenue;
    }
    else if ([typeStr isEqualToString:@"SCHOOL ZONE"])
    {
        return HotSpotTypeSchoolZone;
    }
    return HotSpotTypeCnt;
}

@end