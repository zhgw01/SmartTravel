//
//  LocationRecord.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/14.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "LocationRecord.h"

@implementation LocationRecord

- (instancetype)initWithTimeStamp:(NSTimeInterval)timeStamp
                      andLocation:(CLLocation*)location
{
    if (self = [super init])
    {
        self.timeStamp = timeStamp;
        self.location = location;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    LocationRecord* lr = [[LocationRecord allocWithZone:zone] initWithTimeStamp:self.timeStamp
                                                                    andLocation:self.location];
    return lr;
}

@end
