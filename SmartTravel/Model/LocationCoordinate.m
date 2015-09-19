//
//  LocationCoordinate.m
//  SmartTravel
//
//  Created by chenpold on 9/19/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "LocationCoordinate.h"

@implementation LocationCoordinate

- (instancetype)initWithLatitude:(double)latitude
                    andLongitude:(double)longitude
{
    if (self = [super init])
    {
        self.latitude  = latitude;
        self.longitude = longitude;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    LocationCoordinate *locationCoordinate = [[self class] allocWithZone:zone];
    locationCoordinate.latitude  = self.latitude;
    locationCoordinate.longitude = self.longitude;
    return locationCoordinate;
}

@end
