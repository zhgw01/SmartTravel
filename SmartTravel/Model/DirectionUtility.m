//
//  DirectionUtility.m
//  SmartTravel
//
//  Created by Gongwei on 15/5/9.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "DirectionUtility.h"

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

+ (BOOL)isLocation:(CLLocationCoordinate2D)locMiddle
inMiddleOfLocation:(CLLocationCoordinate2D)locStart
       andLocation:(CLLocationCoordinate2D)locEnd
{
    double x1 = locMiddle.longitude - locStart.longitude;
    double y1 = locMiddle.latitude - locStart.latitude;
    double x2 = locEnd.longitude - locMiddle.longitude;
    double y2 = locEnd.latitude - locMiddle.latitude;
    return ((x1 * x2 + y1 * y2) > 0);
}

@end
