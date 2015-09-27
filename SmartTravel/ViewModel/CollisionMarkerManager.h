//
//  CollisionMarkerManager.h
//  SmartTravel
//
//  Created by Yuan Huimin on 15/9/27.
//  Copyright © 2015年 Gongwei. All rights reserved.
//
#import "MarkerManager.h"
#import <Foundation/Foundation.h>

@interface CollisionMarkerManager : MarkerManager

- (void)breath:(NSString*)locationCode;
- (void)stopBreath;

@end
