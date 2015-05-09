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
    West
};

@interface LocationDirection : NSObject

@property (assign, nonatomic) Direction direction;

-(instancetype)initWithCLLocationDirection: (CLLocationDirection) coreDirection;

@end
