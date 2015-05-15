//
//  Direction.m
//  SmartTravel
//
//  Created by Gongwei on 15/5/9.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "Direction.h"

@implementation LocationDirection

-(instancetype) initWithCLLocationDirection:(CLLocationDirection)coreDirection
{
    if (self = [super init]) {
        _direction = [self fromCLLocationDirection:coreDirection];
    }
    
    return self;
}

- (Direction) fromCLLocationDirection: (CLLocationDirection) coreDirection
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
            return @"North";
        case East:
            return @"East";
        case South:
            return @"South";
        case West:
            return @"West";
        default:
            return nil;
    }
}

@end
