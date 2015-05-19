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
                           rank:(int)rank
                       latitude:(double)latitude
                     longtitude:(double)longtitude
{
    if (self = [super init])
    {
        self.locCode = locCode;
        self.location = location;
        self.count = [NSNumber numberWithInt:count];
        self.rank = [NSNumber numberWithInt:rank];
        self.latitude = [NSNumber numberWithDouble:latitude];
        self.longtitude = [NSNumber numberWithDouble:longtitude];
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

@end