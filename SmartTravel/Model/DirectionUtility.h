//
//  Direction.h
//  SmartTravel
//
//  Created by Gongwei on 15/5/9.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, Direction) {
    North,
    East,
    South,
    West,
    ALL
};

@interface DirectionUtility : NSObject

+ (Direction)fromCLLocationDirection:(CLLocationDirection)coreDirection;

+ (NSString*)directionToString:(Direction)direction;

+ (BOOL)isLocation:(CLLocationCoordinate2D)locMiddle
inMiddleOfLocation:(CLLocationCoordinate2D)locStart
       andLocation:(CLLocationCoordinate2D)locEnd;

@end
