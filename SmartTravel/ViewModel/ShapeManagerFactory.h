//
//  ShapeManagerFactory.h
//  SmartTravel
//
//  Created by Yuan Huimin on 15/9/27.
//  Copyright © 2015年 Gongwei. All rights reserved.
//
#import "HotSpot.h"
#import "ShapeManager.h"
#import <Foundation/Foundation.h>

@interface ShapeManagerFactory : NSObject

+ (ShapeManager*)createShapeManager:(HotSpotType)hotSpotType;

@end
