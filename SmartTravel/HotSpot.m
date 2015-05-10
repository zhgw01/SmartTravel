//
//  HotSpot.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/10/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "HotSpot.h"

@implementation HotSpot

- (instancetype)initWithType:(HotSpotType)type
                         tag:(NSString*)tag
                locationCode:(NSString*)locationCode
                    location:(NSString*)location
                       count:(NSNumber*)count
                        rank:(NSNumber*)rank
                    latitude:(NSNumber*)latitude
                  longtitude:(NSNumber*)longtitude
{
    if (self = [super init])
    {
        self.type = type;
        self.tag = tag;
        self.locationCode = locationCode;
        self.location = location;
        self.count = count;
        self.rank = rank;
        self.latitude = latitude;
        self.longtitude = longtitude;
    }
    return self;
}

@end