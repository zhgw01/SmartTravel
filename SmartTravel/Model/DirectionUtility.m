//
//  DirectionUtility.m
//  SmartTravel
//
//  Created by Gongwei on 15/5/9.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "DirectionUtility.h"
#import <Geo-Utilities/CLLocation+Navigation.h>

@implementation DirectionUtility

+ (Direction)fromCLLocationDirection:(CLLocationDirection)coreDirection
{
    if (0.0 <= coreDirection && coreDirection < 45.0) {
        return North;
    }
    else if (45.0 <= coreDirection && coreDirection < 135.0) {
        return East;
    }
    else if (135.0 <= coreDirection && coreDirection < 225.0) {
        return South;
    }
    else if (225.0 <= coreDirection && coreDirection < 315.0 ) {
        return West;
    }
    else {
        return North;
    }
}

+ (NSString*)directionToString:(Direction)direction
{
    switch (direction)
    {
        case North:
            return @"NORTH";
        case East:
            return @"EAST";
        case South:
            return @"SOUTH";
        case West:
            return @"WEST";
        case ALL:
            return @"ALL";
        default:
            return nil;
    }
}

+ (BOOL)isLocation:(CLLocationCoordinate2D)currenCoor
 approachingTarget:(CLLocationCoordinate2D)targetCoor
     withDirection:(CLLocationDirection)dir1
{
    CLLocationDirection dir2 = [[[CLLocation alloc] initWithLatitude:currenCoor.latitude
                                                           longitude:currenCoor.longitude] kv_bearingOnRhumbLineToCoordinate:targetCoor];
    
    if (dir1 <= dir2)
    {
        return ((dir2 - dir1) > (270 + 45) || (dir2 - dir1) < (90 - 45));
    }
    else
    {
        return ((dir1 - dir2) > (270 + 45) || (dir1 - dir2) < (90 - 45));
    }
}

@end
